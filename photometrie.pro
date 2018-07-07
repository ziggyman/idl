common vars,bmag,vmag,calx,caly,calb,calv,calberr,calverr
common varsa,bx,vx,by,vy

;###########################
function countlines,s
;###########################

common vars,bmag,vmag,calx,caly,calb,calv,calberr,calverr
common varsa,bx,vx,by,vy

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
pro photometrie,filelist,calfile
;############################
common vars,bmag,vmag,calx,caly,calb,calv,calberr,calverr
common varsa,bx,vx,by,vy
;
; NAME:                  photometrie
; PURPOSE:               reduces photometric images and creates a
;                        diagram V over B-V
; CATEGORY:
; CALLING SEQUENCE:      photometrie,'filelist','calfile'
; INPUTS:                input file: 'filelist':
;                                        file1.fits
;                                        file2.fits
;                                        file3.fits
;                                            .
;                                            .
;                                            .
;                                    'calfile'
;                                        x1   y1   b1[mag]   v1[mag]
;                                        x2   y2   b2[mag]   v2[mag]
;                                        x3   y3   b3[mag]   v3[mag]
;                                            .
;                                            .
;                                            .
;                                        x,y: Coords of stars in FITS file
; OUTPUTS:               output file: 'v_over_b-v.ps'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           19.11.2003
;        

if n_elements(filelist) eq 0 then begin
  print,'PHOTOMETRIE: No filelist specified, return 0.'
  print,'PHOTOMETRIE: Usage: photometrie,filelist,<calfile>'
end else begin   

;    close,102
;    openw,102,strmid(filelist,0,strpos(filelist,'.'))+'.log'
    
    maxfiles = countlines(filelist)
    print,'photometrie:',maxfiles,' FILES'  
    
    files    = strarr(maxfiles)
    nbias    = 0
    nflat    = 0
    nflat_b  = 0
    nflat_v  = 0
    fileq    = ' '
    biaswert = 0.
    xposarr = dblarr(1000)
    yposarr = dblarr(1000)
    fluxarr = dblarr(1000)
    
    close,1
    openr,1,filelist
    for i=0,maxfiles-1 do begin  
        readf,1,fileq  
        files(i)=fileq
; --- BIAS ???
        if strmid(fileq,0,1) eq 'b' then begin
            nbias = nbias + 1
            print,'photometrie: '+'nbias = ',nbias
; --- Flat ???
        endif else if strmid(fileq,1,1) eq 'f' then begin
;   --- blue ???
            if strmid(fileq,5,1) eq 'b' then begin
                nflat_b = nflat_b + 1
;   --- visual ???
            endif else begin
                nflat_v = nflat_v + 1
            endelse
            nflat = nflat + 1
            print,'photometrie: '+'nflat_b = ',nflat_b,', nflat_v = ',nflat_v,' => nflat = ',nflat
        end
    end  
    close,1  

; --- build arrays
    biases         = strarr(nbias)
    objects        = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_b_z    = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_v_z    = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_z      = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_b_zf   = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_v_zf   = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_zf     = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_b_zfp  = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_v_zfp  = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_zfp    = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_b_zfpp = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_v_zfpp = strarr(maxfiles-nbias-nflat_v-nflat_b)
    objects_zfpp   = strarr(maxfiles-nbias-nflat_v-nflat_b)
    flats          = strarr(nflat)
    flats_b        = strarr(nflat_b)
    flats_v        = strarr(nflat_v)
    flats_z        = strarr(nflat)
    
; --- define other variables
    ibias      = 0
    iflat      = 0
    iflat_b    = 0
    iflat_v    = 0
    nobjects_b = 0
    nobjects_v = 0
    nobjects   = 0
    
    for i=0,maxfiles-1 do begin
; --- Bias ?
        if strmid(files(i),0,1) eq 'b' then begin
            biases(ibias)=files(i)
            ibias = ibias + 1
; --- Flat ?
        endif else if strmid(files(i),1,1) eq 'f' then begin
            flats(iflat)   = files(i)
            flats_z(iflat) = strmid(files(i),0,strpos(files(i),'.'))+'_z.fits'
            iflat = iflat + 1
;   --- blue ?
            if strpos(files(i), 'b') ne -1 then begin
                flats_b(iflat_b) = files(i)
                iflat_b = iflat_b + 1
;   --- visual ?
            endif else begin
                flats_v(iflat_v) = files(i)
                iflat_v = iflat_v + 1
            endelse
; --- objects
        end else begin
;   --- blue ?
            if strpos(files(i),'b',1) ne -1 then begin
                objects_b_z(nobjects_b)    = strmid(files(i),0,strpos(files(i),'.')) + '_z.fits'
                objects_b_zf(nobjects_b)   = strmid(files(i),0,strpos(files(i),'.')) + '_zf.fits'
                objects_b_zfp(nobjects_b)  = strmid(files(i),0,strpos(files(i),'.')) + '_zfp.fits'
                objects_b_zfpp(nobjects_b) = strmid(files(i),0,strpos(files(i),'.')) + '_zfpp.fits'
                objects(nobjects) = files(i)
                objects_z(nobjects)    = objects_b_z(nobjects_b)
                objects_zf(nobjects)   = objects_b_zf(nobjects_b)
                objects_zfp(nobjects)  = objects_b_zfp(nobjects_b)
                objects_zfpp(nobjects) = objects_b_zfpp(nobjects_b)
                nobjects = nobjects + 1
                nobjects_b = nobjects_b + 1
;   --- visual ?
            endif else if strpos(files(i),'v',1) ne -1 then begin
                objects_v_z(nobjects_v)    = strmid(files(i),0,strpos(files(i),'.')) + '_z.fits'
                objects_v_zf(nobjects_v)   = strmid(files(i),0,strpos(files(i),'.')) + '_zf.fits'
                objects_v_zfp(nobjects_v)  = strmid(files(i),0,strpos(files(i),'.')) + '_zfp.fits'
                objects_v_zfpp(nobjects_v) = strmid(files(i),0,strpos(files(i),'.')) + '_zfpp.fits'
                objects(nobjects) = files(i)
                objects_z(nobjects)    = objects_v_z(nobjects_v)
                objects_zf(nobjects)   = objects_v_zf(nobjects_v)
                objects_zfp(nobjects)  = objects_v_zfp(nobjects_v)
                objects_zfpp(nobjects) = objects_v_zfpp(nobjects_v)
                nobjects = nobjects + 1
                nobjects_v = nobjects_v + 1
            end else begin
                print,'photometrie: '+'no _b_ neither _v_ nor _sf_ found'
            end

; --- write lists            
            close,2
            close,3
            close,4
            close,5
            close,6
            close,7
            close,8
            close,9
            close,10
            close,11
            close,12
            close,13
            openw,2,strmid(filelist,0,strpos(filelist,'.'))+'_objects_z.list'
            openw,3,strmid(filelist,0,strpos(filelist,'.'))+'_objects_zf.list'
            openw,4,strmid(filelist,0,strpos(filelist,'.'))+'_objects_zfp.list'
            openw,5,strmid(filelist,0,strpos(filelist,'.'))+'_objects_zfpp.list'
            openw,6,strmid(filelist,0,strpos(filelist,'.'))+'_objects_b_z.list'
            openw,7,strmid(filelist,0,strpos(filelist,'.'))+'_objects_b_zf.list'
            openw,8,strmid(filelist,0,strpos(filelist,'.'))+'_objects_b_zfp.list'
            openw,9,strmid(filelist,0,strpos(filelist,'.'))+'_objects_b_zfpp.list'
            openw,10,strmid(filelist,0,strpos(filelist,'.'))+'_objects_v_z.list'
            openw,11,strmid(filelist,0,strpos(filelist,'.'))+'_objects_v_zf.list'
            openw,12,strmid(filelist,0,strpos(filelist,'.'))+'_objects_v_zfp.list'
            openw,13,strmid(filelist,0,strpos(filelist,'.'))+'_objects_v_zfpp.list'
            for j = 0,nobjects-1 do begin
                printf,2,objects_z(j)
                printf,3,objects_zf(j)
                printf,4,objects_zfp(j)
                printf,5,objects_zfpp(j)
            endfor
            for j = 0,nobjects_b-1 do begin
                printf,6,objects_b_z(j)
                printf,7,objects_b_zf(j)
                printf,8,objects_b_zfp(j)
                printf,9,objects_b_zfpp(j)
            endfor
            for j = 0,nobjects_v-1 do begin
                printf,10,objects_v_z(j)
                printf,11,objects_v_zf(j)
                printf,12,objects_v_zfp(j)
                printf,13,objects_v_zfpp(j)
            endfor
            close,2
            close,3
            close,4
            close,5
            close,6
            close,7
            close,8
            close,9
            close,10
            close,11
            close,12
            close,13
        endelse
    end
    
; --- combine biases
    print,'photometrie: reading fits file ',biases(0)
    combinedbias=fitsconvert(readfits(biases(0), h))
    for i=1,nbias-1 do begin
        print,'photometrie: reading fits file ',biases(i)
        combinedbias = combinedbias + fitsconvert(readfits(biases(i), h))
    end
    combinedbias=combinedbias/nbias
    writefits,'combinedbias.fits',combinedbias
    ccd_tv_win1,combinedbias,xmax=1012
    biaswert = mean(combinedbias)
    print,'photometrie: BIASWERT = ',biaswert
    
; --- subtract bias
    for i=0,nflat-1 do begin
        print,'photometrie: reading fits file flats_z('+string(i)+') = '+flats_z(i)
        tempfits = fitsconvert(readfits(flats(i), h)) - biaswert
        ccd_tv_win1,tempfits,xmax=1012
        writefits,flats_z(i),tempfits
    end
    for i=0,nobjects-1 do begin
        print,'photometrie: reading fits file objects_z('+string(i)+') = '+objects_z(i)
        tempfits = fitsconvert(readfits(objects(i), h)) - biaswert
        ccd_tv_win1,tempfits,xmax=1012
        writefits,objects_z(i),tempfits
    end
    
; --- combine flats
; --- blue
    print,'photometrie: '+'nflat_b = ',+string(nflat_b)
    print,'photometrie: reading fits file flats_b(0) = '+flats_b(0)
    combinedflat_b = fitsconvert(readfits(flats_b(0), h))
    combinedflat_b = combinedflat_b + 0.
    for i=1,iflat_b-1 do begin
        print,'photometrie: reading fits file flats_b('+string(i)+') = '+flats_b(i)
        combinedflat_b = combinedflat_b + fitsconvert(readfits(flats_b(i), h))
    end
    combinedflat_b = combinedflat_b/nflat_b
    combinedflat_b = combinedflat_b/max(combinedflat_b)
    print,'photometrie: '+'combined Flat B ready'
    ccd_tv_win1,combinedflat_b,xmax=1012
    writefits,'combinedFlat_b.fits',combinedflat_b
; --- visual
    print,'photometrie: reading fits file flats_v(0) = '+flats_v(0)
    combinedflat_v = fitsconvert(readfits(flats_v(0), h))
    combinedflat_v = combinedflat_v + 0.
    for i=1,iflat_v-1 do begin
        print,'photometrie: reading fits file flats_v('+string(i)+') = '+flats_v(i)
        combinedflat_v = combinedflat_v + fitsconvert(readfits(flats_v(i), h))
    end
    combinedflat_v = combinedflat_v/nflat_v
    combinedflat_v = combinedflat_v/max(combinedflat_v)
    ccd_tv_win1,combinedflat_v,xmax=1012
    writefits,'combinedFlat_v.fits',combinedflat_v

; --- _
;    combinedflat = fitsconvert(readfits(flats_b(0), h))
;    combinedflat = combinedflat + 0.
;    for i=1,iflat_b-1 do begin
;        combinedflat = combinedflat + fitsconvert(readfits(flats_b(i), h))
;    end
;    for i=0,iflat_v-1 do begin
;        combinedflat = combinedflat + fitsconvert(readfits(flats_v(i), h))
;    end
;    combinedflat = combinedflat/(nflat_b + nflat_v)
;    flatmax = dblarr(2)
;    flatmax(0) = max(combinedflat_b)
;    flatmax(1) = max(combinedflat_v)
;    combinedflat = combinedflat/max(flatmax)
;    ccd_tv_win1,combinedflat,xmax=1012
;    writefits,'combinedFlat.fits',combinedflat
    
; --- divide pics by flats
; --- blue
    for i=0,nobjects_b-1 do begin
        print,'photometrie: reading fits file objects_b_z('+string(i)+') = '+objects_b_z(i)
        tempfits = fitsconvert(readfits(objects_b_z(i), h)) / combinedflat_b
        ccd_tv_win1,tempfits,xmax=1012
        writefits,objects_b_zf(i),tempfits
    endfor
; --- visual
    for i=0,nobjects_v-1 do begin
        print,'photometrie: reading fits file objects_v_z('+string(i)+') = '+objects_v_z(i)
        tempfits = fitsconvert(readfits(objects_v_z(i), h)) / combinedflat_v
        ccd_tv_win1,tempfits,xmax=1012
        writefits,objects_v_zf(i),tempfits
    endfor
; --- _
;    for i=0,nobjects-1 do begin
;        print,'photometrie: '+'objects_z('+string(i)+') = '+objects_z(i)
;        tempfits = fitsconvert(readfits(objects_z(i), h)) / combinedflat
;        ccd_tv_win1,tempfits,xmax=1012
;        writefits,objects_zf(i),tempfits
;    endfor
    
; --- correct positions

; --- all object images
    starlist = 'all.stars'
    poscor,strmid(filelist,0,strpos(filelist,'.'))+'_objects_zf.list',starlist,'objects_zfpa.fits',45,45,dumx,dumy,dumfluxmag

; --- blue
    starlist = strmid(objects_b_z(0),0,5)+'.stars'
    poscor,strmid(filelist,0,strpos(filelist,'.'))+'_objects_b_zfp.list',starlist,'objects_b_zfpa.fits',5,5,xb,yb,fluxbmag

; --- visual
    starlist = strmid(objects_v_z(0),0,5)+'.stars'
    poscor,strmid(filelist,0,strpos(filelist,'.'))+'_objects_v_zfp.list',starlist,'objects_v_zfpa.fits',5,5,xv,yv,fluxvmag

; --- find equal stars
    srcor,xb,yb,xv,yv,2,ib,iv
;    print,'photometrie: ib = ',ib
;    print,'photometrie: iv = ',iv
    ibsize = size(ib)
    ivsize = size(iv)
    print,'photometrie: ',ibsize(1),' stars found in both lists'
    print,'photometrie: size of ib = ',ibsize(1),', size of iv = ',ivsize(1)
    bmag = dblarr(ibsize(1))
    bx   = dblarr(ibsize(1))
    by   = dblarr(ibsize(1))
    vmag = dblarr(ibsize(1))
    vx   = dblarr(ibsize(1))
    vy   = dblarr(ibsize(1))
    for i=0,(ibsize(1)-1) do begin
        bx(i)   = xb(ib(i))
        by(i)   = yb(ib(i))
        bmag(i) = fluxbmag(ib(i))
    end
    for i=0,ibsize(1)-1 do begin
        vx(i)   = xv(iv(i))
        vy(i)   = yv(iv(i))
        vmag(i) = fluxvmag(iv(i))
    end

; --- mark star positions
    print,'photometrie: reading fits file objects_zfpa.fits'
    obs_zfpafits = fitsconvert(readfits('objects_zfpa.fits', h)) + 0.
    writefits,strmid(filelist,0,strpos(filelist,'.'))+'_obs_zfpa.fits',obs_zfpafits
    for i=0,ibsize(1)-1 do begin
        obs_zfpafits(bx(i),by(i)) = 100.
    end
    for i=0,ibsize(1)-1 do begin
        obs_zfpafits(vx(i),vy(i)) = 0.
    end
    ccd_tv_win1,obs_zfpafits,xmax=1012
    writefits,strmid(filelist,0,strpos(filelist,'.'))+'_obs_zfpa_stars.fits',obs_zfpafits

; --- calibrate flux
; --- read calfile
    if n_elements(calfile) eq 0 then begin
        maxcalstars = 0 
        tempmaxcalstars = 1
        print,'photometrie:',maxcalstars,' stars for calibration in list'  
    endif else begin
        maxcalstars = countlines(calfile)
        tempmaxcalstars = maxcalstars
        print,'photometrie:',maxcalstars,' stars for calibration in list'  
        calx = intarr(tempmaxcalstars)
        caly = intarr(tempmaxcalstars)
        calb = dblarr(tempmaxcalstars)
        calv = dblarr(tempmaxcalstars)
        calberr = dblarr(tempmaxcalstars)
        calverr = dblarr(tempmaxcalstars)

        close,1
        openr,1,calfile
        for i=0,maxcalstars-1 do begin
            readf,1,dummyx,dummyy,dummyb,dummyv
            calx(i) = dummyx
            caly(i) = dummyy
            calb(i) = dummyb
            calv(i) = dummyv
            print,'calfile: line('+string(i+1)+') = ',calx(i),caly(i),calb(i),calv(i)
        endfor
        close,1
    end

; --- compare list of calstars with list of found stars
    if maxcalstars gt 0 then begin
        for j=0,ibsize(1)-1 do begin
            for i=0,maxcalstars-1 do begin
                if ((bx(j) gt calx(i)-2 and bx(j) lt calx(i)+2) and $
               ( vx(j) gt calx(i)-2 and vx(j) lt calx(i)+2) and $
               ( by(j) gt caly(i)-2 and by(j) lt caly(i)+2) and $
               ( vy(j) gt caly(i)-2 and vy(j) lt caly(i)+2)) then begin
                    print,'photometrie: found same star in calibration stars and object images'
                    print,'photometrie:     at position i='+string(i)+', j='+string(j)
                    calberr(i) = bmag(j) - calb(i)
                    calverr(i) = vmag(j) - calv(i)
                    print,'photometrie: calberr('+string(i)+') = '+string(calberr(i))
                    print,'photometrie: calverr('+string(i)+') = '+string(calverr(i))
                endif
            endfor
        endfor

        calbmean = mean(calberr)
        calvmean = mean(calverr)
        print,'photometrie: calberr: mean = '+string(calbmean)+', stddev = '+string(stddev(calberr))
        print,'photometrie: calverr: mean = '+string(calvmean)+', stddev = '+string(stddev(calverr))

        bmag = bmag - calbmean
        vmag = vmag - calvmean

;    endif else begin
;        bmag = bmag + 46.4633
;        vmag = vmag + 43.1143
    end

    bmagmax = max(bmag)
    bmagmin = min(bmag)
    vmagmax = max(vmag)
    vmagmin = min(vmag)
    print,'photometrie: max(bmag) = ',bmagmax,', max(vmag) = ',vmagmax
    print,'photometrie: min(bmag) = ',bmagmin,', min(vmag) = ',vmagmin

; --- print FHD to file
    set_plot,'ps'
    device,filename='FHD_'+strmid(filelist,0,strpos(filelist,'.'))+'.eps'
    plot,bmag-vmag,vmag,psym=1,title="FHD von NGC "+strmid(filelist,0,strpos(filelist,'.')), $
         xtitle="B-V in mag", ytitle="V in mag" ,yrange=[vmagmax+1,vmagmin-1]
    device,/close
    set_plot,'x'

;    close,102

endelse
end
