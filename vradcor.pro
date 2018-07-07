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
pro vradcor,spectralistfile,vraddatfile
;############################
;
; NAME:                  vradcor
; PURPOSE:               corrects the wavelength of the input spectra
;                        by the radial velocities
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      vradcor,'spectralistfile','vraddatfile'
; INPUTS:                input file: 'spectralistfile':
;                          ../../UVES/ready/red_l/RXJ1523..._ctc+h.text
;                                            .
;                                            .
;                                            .
;                        input file: 'vraddatfile':
;                          #N HJD HGHT FWHM VOBS VREL VHELIO VERR
;                          #U days          km/s km/s km/s   km/s
;                          1691.4790 0.91 248.39 9.7044 -0.1387 6.6591  0.000
;                          1691.5037 0.92 246.33 10.8072 0.9641 7.7242
;                          1.647
;                                            .
;                                            .
;                                            .
; OUTPUTS:               output files: strmid(<spectrafile>,0,strpos(<spectrafile>,'.',/REVERSE_SEARCH))+'_'+'_v.text'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.04.2004
;

if n_elements(vraddatfile) eq 0 then begin
    print,'VRADCOR: Not enough parameters specified, return 0.'
    print,"VRADCOR: Usage: vradcor,'../../UVES/ready/red_l/RXJ_ctc_head.text.list','../../UVES/ready/red_l/vobs/fxcor...data'"
end else begin   

;countlines
    maxn = countlines(spectralistfile)
    maxm = countlines(vraddatfile)
    print,spectralistfile+': ',maxn,' DATA LINES'  
    print,vraddatfile+': ',maxm-2,' DATA LINES'  
    
    if maxn ne (maxm-2) then begin
        print,'VRADCOR: number of data lines do not agree! Return 0.'
    end else begin

;build arrays
        filelist = strarr(maxn)
        vradarr  = dblarr(maxn,7)

;define variables
        fileq   = ''
        dumstr  = ''
        maxd    = 0
        crval   = double(0.)
        lambdaq = double(0.)
        intensq = double(0.)

;read spectra-file list in arrays
        close,1
        openr,1,spectralistfile
        for i=0UL,maxn-1 do begin  
            readf,1,fileq
            filelist(i) = strmid(spectralistfile,0,strpos(spectralistfile,'/',/reverse_search))+'/'+strtrim(fileq,2)
            maxf = countlines(filelist(i))
;            print,'maxf = ',maxf
            if maxf gt maxd then maxd = maxf
            print,'maxd = ',maxd
        end  
        close,1

;build spectra arrays
        headerarr    = strarr(maxn,maxd)
        nheaderlines = intarr(maxn)
        lambda       = dblarr(maxn,maxd)
        intens       = dblarr(maxn,maxd)
        lambdanew    = dblarr(maxn,maxd)

;read spectra files in arrays
        for i=0UL,maxn-1 do begin
            openr,1,filelist(i)
            print,'VRADCOR: reading '+filelist(i)
            found = 0
            maxf = countlines(filelist(i))
            print,filelist(i)+' contains ',maxf,' lines'
            for j=0UL,maxf-1 do begin
                if found eq 0 then begin
                    readf,1,dumstr
                    headerarr(i,j) = dumstr
                    if strmid(dumstr,0,3) eq 'END' then begin
                        nheaderlines(i) = j+1
                        found = 1
                        print,'VRADCOR: end of header found at line',nheaderlines(i)
                    endif
                endif else begin
                    readf,1,lambdaq,intensq
                    if j ge maxf-1 then $
                      print,j,lambdaq,intensq,FORMAT = '(F15.0,": lambdaq = ",F15.7,",    intensq = ",F20.7)'
                    lambda(i,j-nheaderlines(i)) = lambdaq
                    intens(i,j-nheaderlines(i)) = intensq
;                print,i,j,lambda(i,j),i,j,intens(i,j),FORMAT = '("VRADCOR: lambda(",F15.0,",",F15.0,") = ",F15.10,", intens(",F15.0,",",F15.0,") = ",F15.7)'
                endelse
            endfor
            close,1
        endfor

;read vraddatfile in array
        openr,1,vraddatfile
        print,'VRADCOR: reading '+vraddatfile
        for i=0UL,maxm-1 do begin
            if i lt 2 then readf,1,fileq else begin
                readf,1,hjdq,hghtq,fwhmq,vobsq,vrelq,vhelioq,verrq
                vradarr(i-2,0) = hjdq
                vradarr(i-2,1) = hghtq
                vradarr(i-2,2) = fwhmq
                vradarr(i-2,3) = vobsq
                vradarr(i-2,4) = vrelq
                vradarr(i-2,5) = vhelioq
                vradarr(i-2,6) = verrq
            end
        endfor

;vrad correct
        for i=0UL, maxn-1 do begin
            close,2
            newfilename = strmid(filelist(i),0,strpos(filelist(i),'.',/reverse_search))+'_v.text'
            print,'VRADCOR: writing new '+newfilename
            print,'VRADCOR: i='+strtrim(string(i),2)+': vrad = '+strtrim(string(vradarr(i,4)))
            openw,2,newfilename
            vrad = vradarr(i,3)
            for j=0UL, nheaderlines(i)-1 do begin
                if strmid(headerarr(i,j),0,6) ne 'CRVAL1' then begin
                    printf,2,headerarr(i,j)
                end else begin
                    crval = lambda(i,0)+(lambda(i,0)*vrad/double(299792.))
                    dumstringx = strmid(headerarr(i,j),0,14)
                    dumstringy = strmid(headerarr(i,j),strpos(headerarr(i,j),' ',strpos(strtrim(headerarr(i,j),2),' ',/reverse_search)+2),strlen(headerarr(i,j))-strpos(headerarr(i,j),' ',strpos(strtrim(headerarr(i,j),2),' ',/reverse_search)+2))
                    print,'VRADCOR: CRVAL1: dumstringx = '+dumstringx+ ', crval = '+string(crval)+', dumstringy = ',dumstringy,'<'
                    printf,2,FORMAT = '(A,F16.11,A)',dumstringx,crval,dumstringy
                end
            endfor
            maxf = countlines(filelist(i))
            for j=0UL, maxf-1-nheaderlines(i) do begin
                lambdanew(i,j) = lambda(i,j) + (lambda(i,j) * vrad/double(299792.))
                if j eq 0 then print,i,lambda(i,j),i,lambdanew(i,j),FORMAT = '("VRADCOR: lambda(",F15.0,",0) = ",F15.7,", lambdanew(",F15.0,",0) = ",F15.7)'
                printf,2,lambdanew(i,j),intens(i,j),FORMAT = '(F16.11,T19,F9.7)'
            endfor
            close,2
            maxg = countlines(newfilename)
            if maxg ne maxf then print,'VRADCOR: number of lines in output file not equal to number of lines in input file!!!'
        endfor
    end
endelse
end
