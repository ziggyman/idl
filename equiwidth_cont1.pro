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
pro equiwidth_cont1,datfile,xmin,xmax,outfile
;############################
;
; NAME:                  equiwidth
; PURPOSE:               * calculates the equivalent widths for a
;                          given wavelengthrange (xmin - xmax) 
;                        * appends the results to OUTFILE
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      equiwidth,'datfile',xmin,xmax,outfile
; INPUTS:                input file: 'datfile':
;                          6556.45 1.0235342
;                          6556.48 1.0123143
;                                 .
;                                 .
;                                 .
;                        xmin, xmax: Real
; OUTPUTS:               outfile
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.04.2004
;

if n_elements(outfile) eq 0 then begin
    print,'equiwidth: Not enough arguments specified, return 0.'
    print," USAGE: equiwidth,'datfile',xmin:Real,xmax:Real,'outfile'"
end else begin   

;countlines
    maxn = countlines(datfile)
    print,datfile+': '+string(maxn)+' DATA LINES'  

;define variables
    meana = 0.d
    meanb = 0.d
    lambdaq = 0.d
    intensq = 0.d
    ewidth  = 0.d
    xlow    = 0.d
    xhigh   = 0.d
    

;build arrays
    lambda = dblarr(maxn)
    intens = dblarr(maxn)

;read file in arrays
    close,1
    openr,1,datfile
    for i=0,maxn-1 do begin  
        readf,1,lambdaq,intensq
;        print,i,lambdaq,intensq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7 )'
        lambda(i) = lambdaq
        intens(i) = intensq
;	if (lambda(i-1) lt xmin) and (lambda(i) ge xmin) then begin
;            
;	endif
    end  
    close,1

;equiwidth
    for i=1,maxn-1 do begin
        if ((lambda(i-1) ge xmin) and (lambda(i) ge xmin)) and ((lambda(i-1) le xmax) and (lambda(i) le xmax)) then begin
            ewidth = ewidth + ((lambda(i)-lambda(i-1)) * (intens(i-1)-(1.d)+((intens(i)-intens(i-1))/(2.d))))
;            print,'equiwidth: lambda(i-1) = ',lambda(i-1),': intens(i-1) = ',intens(i-1)
;            print,'equiwidth: lambda(i) = ',lambda(i),', intens(i) = ',intens(i),' => ewidth = ',ewidth
        end
    end

    print,'equiwidth: ewidth = ',ewidth
    
    close,2
    openw,2,outfile,/APPEND
    printf,2,datfile+' '+strtrim(string(ewidth),2)
    close,2

endelse
end
