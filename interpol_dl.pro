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
pro interpol_dl,datfile,dlambdanew
;############################
;
; NAME:                  interpol
; PURPOSE:               interpolates datfile to a fixed dlambda
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      interpol,'datfile',0.002346234
; INPUTS:                input file: 'datfile':
;                                        3463.3245235   23465.234
;                                        3463.4355223   24652.236
;                                        3436.5262436   23523.634
;                                            .
;                                            .
;                                            .
;                        dlambdanewstr: float
; OUTPUTS:               output file: strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+dlambdanewstr+'.text
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;

if n_elements(dlambdanew) eq 0 then begin
  print,'INTERPOL: No dlambda specified, return 0.'
  print,'INTERPOL: Usage: interpol,<datfile: String>,<dlambdanew:Float>'
end else begin   

  dlambda       = 0.
  dlambdanewstr = ''
  dlambdanewstr = strtrim(string(dlambdanew),2)
;  dlambdanewstr = '0.007221'

;countlines
  maxn = countlines(datfile)
  print,maxn,' DATA LINES'  

;build arrays
  lambda = dblarr(maxn)
  intens = dblarr(maxn)
  lambdanew = dblarr(2*maxn)
  intensnew = dblarr(2*maxn)

;read file in arrays
  close,1
  openr,1,datfile
  for i=0UL,maxn-1 do begin  
    readf,1,lambdaq,intensq
;    print,i,lambdaq,intensq,whoknowsq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7, " whoknowsq = ", F15.7 )'
    lambda(i) = lambdaq
    intens(i) = intensq
  end  
  close,1  

;interpolate
  lambdanew(0) = lambda(0)
  for i=1UL,(2*maxn)-1 do begin
    lambdanew(i) = lambdanew(i-1) + dlambdanew
  endfor

  k = 0
  intensnew(0) = intens(0)
  for i=1UL,(2*maxn)-1 do begin
    l = 0UL
    if k lt 98 then l = 98 else l = k
    m = 0UL
    if k gt maxn-100 then m = maxn-100 else m = k+98
    for j=ulong(l-98),m do begin
      if (lambda(j) lt lambdanew(i)) AND (lambda(j+1) ge lambdanew(i)) then begin
        dlambda       = lambda(j+1) - lambda(j)
        dlambdabefore = (lambdanew(i) - lambda(j))
        dlambdaafter  = lambda(j+1) - lambdanew(i)
        if intens(j) lt intens(j+1) then begin
          intensnew(i) = intens(j) + (((intens(j+1) - intens(j)) / dlambda) * dlambdabefore)
        endif else begin
          intensnew(i) = intens(j+1) + (((intens(j) - intens(j+1)) / dlambda) * dlambdaafter)
        endelse
;        print,lambda(j),intens(j),lambda(j+1),intens(j+1), FORMAT = '(F15.7 , F15.7 , "   " , F15.7,  F15.7 )'
        print,i,lambdanew(i),i,intensnew(i),FORMAT = '("  => lambdanew(",F15.0,") = ",F15.7,", intensnew(",F15.0,") = ",F20.7)'
        maxi = i
        k = j+1
      endif
    endfor 
;    k = k+1
  endfor

;write file
  newlist = strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+dlambdanewstr+'.text'
  print,'output filename:',newlist,' with ',maxi,' data lines'
  close,2
  openw,2,newlist
  for i=0UL,maxi-1 do begin
      printf,2,lambdanew(i),intensnew(i),FORMAT = '(F15.7,F20.7)'
;        print,i,lambdanew(i),i,intensnew(i),FORMAT = '("  => lambdanew(",F15.0,") = ",F15.7,", intensnew(",F15.0,") = ",F20.7)'
  endfor
  close,2

endelse
end
