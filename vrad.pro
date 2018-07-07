common maxfn,maxn,flux

pro vrad,fname,datname,firstn
common maxfn,maxn,flux
  
;
; NAME:                  vrad.pro
; PURPOSE:               calculates middle vrad and rms per night
; CATEGORY:              data reduction
; CALLING SEQUENCE:      vrad,'data.list',17,'print'
; INPUTS:                input file: data.list:
;
;                                    file hjd1 vrad1 failure1 file hjd2 vrad2 failure2
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  10.10.2002
;
;                        headline
;                        feetline (up to now not used) 
;

headline=''            
feetline=''
;xaxis='!7k!5 [A]'
;yaxis='!5        residuals          normalized flux - hjd '

;-- test arguments
if strlen(fname) eq 0 then begin
  print,'ERROR: no filename spezified!'
  print,'Usage: vrad,data.dat,17,print'
endif else begin

;-- count lines fname
 maxfn=countlines(fname)
 print,maxfn,' DATA-FILES'

;-- initialize variables
 filename    = strarr(maxfn)
 hjd         = dblarr(maxfn)
 vrad        = dblarr(maxfn,2)
 vraderror   = dblarr(maxfn,2)

;-- read filenames from fname (inputfile)
 filenameq = ''
 close,1  
 openr,1,fname
 for i=0,maxfn-1 do begin  
   readf,1,filenameq
   filename(i) = filenameq
 endfor
 close,1
 middle1    = double(0.)
 middle2    = double(0.)
 close,2  
 openr,2,datname
  for i=0,firstn-1 do begin  
   readf,2,hjdq,vrad1q,vraderr1q,vrad2q,vraderr2q
   hjd(i) = hjdq
   vrad(i,0) = vrad1q
   vrad(i,1) = vrad2q
   vraderror(i,0) = vraderr1q
   vraderror(i,1) = vraderr2q
   middle1 = middle1 + ((vrad(i,0) + vrad(i,1))/2.)
  endfor
  middle1 = middle1 / firstn
  for i=firstn,maxfn-1 do begin  
   readf,2,hjdq,vrad1q,vraderr1q,vrad2q,vraderr2q
   hjd(i) = hjdq
   vrad(i,0) = vrad1q
   vrad(i,1) = vrad2q
   vraderror(i,0) = vraderr1q
   vraderror(i,1) = vraderr2q
   middle2 = middle2 + ((vrad(i,0) + vrad(i,1))/2.)
  endfor
  middle2 = middle2 / (maxfn-firstn)
 close,2

 close,3
 openw,3,'vrad_RXJ.dat'
  printf,3,'filename hjd vrad vraderror'
  rms = 0.
  for i=0,firstn-1 do begin
   rms = rms + (middle1 - (vrad(i,0) + vrad(i,1))/2.)^2
;   printf,3,"%-38s %.4f %.4f %.3f\n",filename(i),hjd(i),(vrad(i,0) + vrad(i,1))/2.,(vraderror(i,0) + vraderror(i,1))/2.
   printf,3,filename(i),' ',hjd(i),' ',(vrad(i,0) + vrad(i,1))/2.,' ',(vraderror(i,0) + vraderror(i,1))/2.
  endfor
  rms = sqrt(rms) / firstn
  printf,3,'middle vrad_firstnight = ',middle1
  printf,3,'rms_firstnight = ',rms
  rms = 0.
  for i=firstn,maxfn-1 do begin
   rms = rms + (middle2 - (vrad(i,0) + vrad(i,1))/2.)^2
   printf,3,filename(i),' ',hjd(i),' ',(vrad(i,0) + vrad(i,1))/2.,' ',(vraderror(i,0) + vraderror(i,1))/2.
  endfor
  rms = sqrt(rms) / (maxfn - firstn)
  printf,3,'middle vrad_secondnight = ',middle2
  printf,3,'rms_secondnight = ',rms
 close,3

endelse
end
