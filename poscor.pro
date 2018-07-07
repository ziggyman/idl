;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
    result=strarr(1)
    lines=0
    spawn,'wc -l '+s,result
    c=long(result(0))
end
return,c
end

;############################
pro poscor,filelist,starlist,addedfitsout,maxdx,maxdy,xstar,ystar,fluxstarmag
;############################
;
; NAME:                  poscor
; PURPOSE:               corrects the positions of the stars, finds
;                        the positions of stars and writes them to 'starlist'
; CATEGORY:
; CALLING SEQUENCE:      poscor,'filelist','starlist','addedfitsout',maxdx,maxdy,xstar,ystar,fluxstarmag
; INPUTS:                input file: 'filelist':
;                                        file1.fits
;                                        file2.fits
;                                        file3.fits
;                                            .
;                                            .
;                                            .
;                        integer: maxdx, maxdy
; OUTPUTS:               output files: 'starlist','addedfitsout'
;                        output variables: xstar,ystar,fluxstarmag
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           19.11.2003
;        

if n_elements(addedfitsout) eq 0 then print,'POSCOR: No files specified, return 0.'+$
'usage: poscor,filelist,starlist,xstar,ystar,fluxstarmag' $
else begin   

;open logfile
;    close,101
;    openw,101,strmid(filelist,0,strpos(filelist,'.'))+'_poscor.log'
    
;count lines
    maxfiles = countlines(filelist)
    print,'POSCOR: ',maxfiles,' FILES'
    print,'POSCOR: maxdx = ',maxdx,', maxdy = ',maxdy
    
    files   = strarr(maxfiles)
    fits    = strarr(maxfiles)
    fitscut = strarr(maxfiles)
    fitscor = strarr(maxfiles)
    valmin  = dblarr(maxfiles)
    posminx = intarr(maxfiles)
    posminy = intarr(maxfiles)
    posx    = intarr(maxfiles)
    posy    = intarr(maxfiles)
    nx      = 0
    ny      = 0
    dx = 1
    dy = 1
;    maxdx = 45
;    maxdy = 45
    fileq   = ' '
    stddevarr = dblarr(2*maxdx+1,2*maxdy+1)
    stddevminarr = dblarr(maxfiles)
    
;read in filenames
    close,1
    openr,1,filelist
    for i=0,maxfiles-1 do begin  
        readf,1,fileq  
        files(i) = fileq
        fits(i)  = strmid(fileq,0,strpos(fileq,'.'))+'_.fits'
        fitscut(i) = strmid(fileq,0,strpos(fileq,'.'))+'_cut.fits'
        fitscor(i) = strmid(fileq,0,strpos(fileq,'.'))+'p.fits'
    end  
    close,1  
    
;read refpic and cut it
    print,'poscor: reading fits file files('+string(maxfiles-1)+' = '+files(maxfiles-1)
    refpic = fitsconvert(readfits(files(maxfiles-1),h))
    refsize = size(refpic)
    ccd_tv_win1,refpic,xmax=1012
    writefits,'refpic.fits',refpic
    refpiccut = refpic[maxdx:refsize(1)-maxdx-1, maxdy:refsize(2)-maxdy-1]
    writefits,'refpiccut.fits',refpiccut
    
;cut fits
    for i=0,maxfiles-1 do begin
        valmin[i] = 100000.
        posminx[i] = -25
        posminy[i] = -25
        print,'poscor: reading fits file files('+string(i)+') = '+files(i)
        tempfits = fitsconvert(readfits(files(i), h))
        ccd_tv_win1,tempfits,xmax=1012
        writefits,fits(i),tempfits
; --- move images around and take the stddev of (tempfitscut-refpiccut)
        for dx = -maxdx,maxdx do begin
            for dy = -maxdy,maxdy do begin
                tempfitscut = (tempfits)[maxdx+dx:refsize(1)-maxdx-1+dx, maxdy+dy:refsize(2)-maxdy-1+dy]
                writefits,fitscut(i),tempfitscut
                stddevarr(maxdx+dx, maxdy+dy) = stddev(tempfitscut-refpiccut)
;                print,'poscor: '+'dx = ',dx,', dy = ',dy,': stddev = ',stddevarr(maxdx+dx,maxdy+dy)
; --- find minimum of stddev array
                if valmin[i] gt stddevarr(maxdx+dx,maxdy+dy) then begin
                    posminx[i] = maxdx+dx
                    posminy[i] = maxdy+dy
                    valmin[i] = stddevarr(posminx[i],posminy[i])
                endif
            end
        end
        print,'poscor: '+' valmin[',i,'] = ',valmin[i],', posminx[',i,'] = ',posminx[i],', posminy[',i,'] = ',posminy[i]
    end
    
; --- trim images
    posxmax = 0
    posxmin = 0
    posymax = 0
    posymin = 0
    openw,1,strmid(filelist,0,strpos(filelist,'.'))+'_poscor.dat'
    for i=0,maxfiles-1 do begin
        posx[i] = maxdx - posminx[i]
        if posxmax lt posx[i] then posxmax = posx[i]
        if posxmin gt posx[i] then posxmin = posx[i]
        posy[i] = maxdy - posminy[i]
        if posymax lt posy[i] then posymax = posy[i]
        if posymin gt posy[i] then posymin = posy[i]
        print,'poscor: '+'posx['+string(i)+'] = ',posx[i],', posy['+string(i)+'] = ',posy[i]
        print,'poscor: posxmax = ',posxmax,', posymax = ',posymax
        print,'poscor: posxmin = ',posxmin,', posymin = ',posymin
; --- write *poscor.dat
        printf,1,fitscor(i),valmin[i],posx[i],posy[i]
    endfor
    close,1
    for i=0,maxfiles-1 do begin
    print,'poscor: reading fits file files('+string(i)+') = '+files(i)
        tempfits = fitsconvert(readfits(files(i), h))
        tempfits = (tempfits)[posxmax-posxmin-posx[i]:refsize(1)-posxmax+posxmin-1-posx[i], posymax-posymin-posy[i]:refsize(2)-posymax+posymin-1-posy[i]]
;        tempfits = (tempfits)[posx[i]:refsize(1)-1-posxmax+posxmin+posx[i], posy[i]:refsize(1)-1-posymax+posymin+posy[i]]
        writefits,fitscor(i),tempfits
    endfor

; add pictures and find star positions
    print,'poscor: reading fits file fitscor(0) = '+fitscor(0)
    tempfits = fitsconvert(readfits(fitscor(0),h))
    for i=1,maxfiles-1 do begin
        print,'poscor: reading fits file fitscor('+string(i)+') = '+fitscor(i)
        tempfits = tempfits + fitsconvert(readfits(fitscor(i),h))
    endfor
    writefits,addedfitsout,tempfits
    ccd_tv_win1,tempfits,xmax=1012
    
    find,tempfits,xstar,ystar,fluxstar
    fluxstarmag = flux2mag(fluxstar)
;    print,'poscor: xb = ',xb,', yb = ',yb,', fluxb = ',fluxb
    openw,4,starlist
    printf,4,'x coord:'
    printf,4,xstar
    printf,4,'y coord:'
    printf,4,ystar
    printf,4,'flux:'
    printf,4,fluxstar
    printf,4,'flux [mag]:'
    printf,4,fluxstarmag
    close,4
;    close,101
endelse
end
