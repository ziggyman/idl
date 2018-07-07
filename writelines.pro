common maxn,dlambda,lambda,flux

pro writelines,fname,fnameo,max,mindl  
common maxn,dlambda,lambda,flux
  
;
; NAME:                  writelines.pro
; PURPOSE:               writes all absorption lines with a minimum below max
; CATEGORY:              data reduction
; CALLING SEQUENCE:      writelines,filename,outputfilename,maximum,mindeltalambda
; INPUTS:                input file: object_ecd.text:
;
;                                    lambda1 flux1
;                                    lambda2 flux2...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  14.02.2001
;
;                        headline
;                        feetline (up to now not used) 
;

;-- test arguments
if strlen(fname) eq 0 then begin
  print,'ERROR: no filename spezified!'
  print,'Usage: writelines,filename,outputfilename,maximum,mindletalambda'
endif else begin

;-- count lines fname
 maxn=countlines(fname)  
 print,maxn,' DATA-LINES'  

;-- initialize variables
 dlambda=100.
 dumlambda=1.
 dum=1
 lambda=dblarr(maxn)
 flux=dblarr(maxn)  

;-- read lambda and flux from fname (inputfile)
 close,1  
 openr,1,fname  
 for i=0,maxn-1 do begin  
   readf,1,lambdaq,fluxq
   lambda(i)=lambdaq 
   ;print,'lambda = ',lambda(i) 
   flux(i)=fluxq
   ;print,'flux = ',flux(i)    
 endfor
 close,1  

;-- find minimums and write them to fnameo (outputfile)
 close,2
 openw,2,fnameo

 for i=20,maxn-21 do begin 

   if (flux(i) lt flux(i-1)) and (flux(i) lt flux(i-2)) and (flux(i) lt flux(i-3)) and (flux(i) lt flux(i-4)) and (flux(i) lt flux(i-5)) and (flux(i) lt flux(i-6)) and (flux(i) lt flux(i-7)) and (flux(i) lt flux(i-8)) and (flux(i) lt flux(i-9)) and (flux(i) lt flux(i-10)) and (flux(i) lt flux(i-11)) and (flux(i) lt flux(i-12)) and (flux(i) lt flux(i-13)) and (flux(i) lt flux(i-14)) and (flux(i) lt flux(i-15)) and (flux(i) lt flux(i-16)) and (flux(i) lt flux(i-17)) and (flux(i) lt flux(i-18)) and (flux(i) lt flux(i-19)) and (flux(i) lt flux(i-20)) and (flux(i) lt flux(i+1)) and (flux(i) lt flux(i+2)) and (flux(i) lt flux(i+3)) and (flux(i) lt flux(i+4)) and (flux(i) lt flux(i+5)) and (flux(i) lt flux(i+6)) and (flux(i) lt flux(i+7)) and (flux(i) lt flux(i+8)) and (flux(i) lt flux(i+9)) and (flux(i) lt flux(i+10)) and (flux(i) lt flux(i+11)) and (flux(i) lt flux(i+12)) and (flux(i) lt flux(i+13)) and (flux(i) lt flux(i+14)) and (flux(i) lt flux(i+15)) and (flux(i) lt flux(i+16)) and (flux(i) lt flux(i+17)) and (flux(i) lt flux(i+18)) and (flux(i) lt flux(i+19)) and (flux(i) lt flux(i+20)) and (flux(i) lt max) then begin

     dlambda=lambda(i)-dumlambda

     if dlambda gt mindl then begin
       dumlambda=lambda(i)
       print,dum,'. line: lambda = ',lambda(i)
       printf,2,lambda(i)
       dum = dum + 1
     endif

   endif

 endfor

 close,2

endelse
end








