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

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;###########################
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;############################
pro equiwidth,datfile,xmiddle,xmin,xmax,npixlowl,npixlowu,npixhighl,npixhighu,outfile
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
;                        xmiddle,xmin, xmax: Real
;                        npix...: Integer
;
;      I------...-----I-------I-----------I------------------------------------------I------------------I----------I---------...------I
;                       npixlowl    npixlowu                                               npixhighl      npixhighu
;                            xmin                           xmiddle                                    xmax
;                                I(contlow)                                                          I(counthigh)
;                               xlow                                                               xhigh
; OUTPUTS:               outfile,
;                        rangepsfile = strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(xmin),2)+'-'+strtrim(string(xmax),2)+'.eps'
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
    ;print,datfile+': '+string(maxn)+' DATA LINES'  

;define variables
    meana = 0.d
    meanb = 0.d
    lambdaq = 0.d
    intensq = 0.d
    ewidth  = 0.d
    xlow    = 0.d
    xhigh   = 0.d
    contlow = 0.d
    conthigh = 0.d
    funcm = 0.d
    funcn = 0.d
    mli = 0.d
    mlipn = 0.d

;build arrays
    lambda = dblarr(maxn)
    intens = dblarr(maxn)

;read file in arrays
    openr,lun,datfile,/GET_LUN
    for i=0UL,maxn-1 do begin  
        readf,lun,lambdaq,intensq
;        print,i,lambdaq,intensq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7 )'
        lambda(i) = lambdaq
        intens(i) = intensq
    end  
    free_lun,lun

; --- write tempfile
    tempfile = strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(xmin),2)+'-'+strtrim(string(xmax),2)+'.dat'
    ;print,'equiwidth: tempfile = '+tempfile
    openw,lun,tempfile,/GET_LUN
    for i=npixhighu,maxn-npixlowl-1 do begin
        if (lambda(i+npixlowl) ge xmin) and (lambda(i-npixhighu) le xmax) then begin
            printf,lun,lambda(i),intens(i),FORMAT='(F16.11," ",F20.7)'
;            ewidth = ewidth + ((lambda(i)-lambda(i-1)) * (intens(i-1)-(1.d)+((intens(i)-intens(i-1))/(2.d))))
;            print,'equiwidth: lambda(i-1) = ',lambda(i-1),': intens(i-1) = ',intens(i-1)
;            print,'equiwidth: lambda(i) = ',lambda(i),', intens(i) = ',intens(i),' => ewidth = ',ewidth
        end
    end
    free_lun,lun

; --- read tempfile
    nlines = countlines(tempfile)
    ndatlines = countdatlines(tempfile)
    lambdaarr = dblarr(ndatlines)
    intensarr = dblarr(ndatlines)
    idat = 0
    tempstr = ''
    openr,lun,tempfile,/GET_LUN
    for i=0UL,nlines-1 do begin
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        if strmid(tempstr,0,1) ne '#' then begin
            lambdaarr(idat) = strmid(tempstr,0,strpos(tempstr,' '))
            ;print,idat,lambdaarr(idat), FORMAT = '("equiwidth: lambdaarr(idat=", F20.0 , ") = ", F20.11 )'
            tempstr = strmid(tempstr,strpos(tempstr,' ',/REVERSE_SEARCH)+1)
            intensarr(idat) = tempstr
            ;print,idat,intensarr(idat), FORMAT = '("equiwidth: intensarr(idat=", F20.0, ") = ", F15.7 )'
            idat = idat + 1
        endif
    endfor
    free_lun,lun

; --- calculate continua
    contlow = 0.
    for i=0UL,npixlowl+npixlowu-1 do begin
        ;print,'equiwidth: calculating contlow: i = '+strtrim(string(i),2)+': intensarr(i) = '+strtrim(string(intensarr(i)),2)
        contlow = contlow + intensarr(i)
        ;print,contlow, FORMAT = '("equiwidth: contlow = ", F20.11)'
    endfor
    contlow = contlow / (npixlowl+npixlowu)
    ;print,'equiwidth: contlow = '+strtrim(string(contlow),2)

    conthigh = 0.
    for i=ndatlines-npixhighl-npixhighu, ndatlines-1 do begin
        ;print,'equiwidth: calculating conthigh: i = '+strtrim(string(i),2)+': intensarr(i) = '+strtrim(string(intensarr(i)),2)
        conthigh = conthigh + intensarr(i)
        ;print,conthigh, FORMAT = '("equiwidth: conthigh = ", F20.9)'
    endfor
    conthigh = conthigh / (npixhighl+npixhighu)
    ;print,'equiwidth: conthigh = '+strtrim(string(conthigh),2)

; --- set continuum
    xlow = lambdaarr((npixlowl+npixlowu)/2)
    xhigh = lambdaarr(ndatlines-1-((npixhighl+npixhighu-1)/2))
    ;print,'equiwidth: xlow = ',xlow,', xhigh = ',xhigh
    funcm = (conthigh - contlow)
    ;print,'equiwidth: funcm = '+strtrim(string(funcm),2)
    xhml = xhigh - xlow
    ;print,'equiwidth: xhigh - xlow = ',xhml
    funcm = funcm / xhml
    funcn = contlow - (funcm*xlow)

    ;print,'equiwidth: funcm = '+strtrim(string(funcm),2)+', funcn = '+strtrim(string(funcn),2)
; --- divide intensarr by continuum function
    for i=0UL,ndatlines-1 do begin
        mli = funcm * lambdaarr(i)
        mlipn = mli + funcn
        ;print,'equiwidth: i = ',i,': mli = ',mli,', mlipn = ',mlipn
        intensarr(i) = intensarr(i) / mlipn
        ;print,'equiwidth: i = '+strtrim(string(i),2)+': lambdaarr(i) = '+strtrim(string(lambdaarr(i)),2)+', intensarr(i) = '+strtrim(string(intensarr(i)),2)
    endfor

; --- calc equiwidth
    area = 0.
    ewidth = 0.
    for i=npixlowl, ndatlines-npixhighu-1 do begin
        if i eq npixlowl then begin
            dl = lambdaarr(i) - xmin
            ixmin = 0.
            ixmin = intensarr(i-1) + (((intensarr(i) - intensarr(i-1)) * (xmin - lambdaarr(i-1))) / (lambdaarr(i) - lambdaarr(i-1)))
            area = dl * (1.-((ixmin + intensarr(i)) / 2.))
        end else if i eq ndatlines-npixhighu-1 then begin
            dl = lambdaarr(i) - lambdaarr(i-1)
            area = dl * (1.-((intensarr(i-1) + intensarr(i)) / 2.))
            dl = xmax - lambdaarr(i)
            ixmax = 0.
            ixmax = intensarr(i) + (((intensarr(i+1) - intensarr(i)) * (xmax - lambdaarr(i))) / (lambdaarr(i+1) - lambdaarr(i)))
            area = area + dl * (1.-((ixmax + intensarr(i)) / 2.))
        end else begin
            dl = lambdaarr(i) - lambdaarr(i-1)
            area = dl * (1.-((intensarr(i-1) + intensarr(i)) / 2.))
        end
;        print,'equiwidth: i = '+strtrim(string(i),2)+': dl = '+strtrim(string(dl),2)+', area = '+strtrim(string(area),2)
        ewidth = ewidth + area
;        print,'equiwidth: ewidth = '+strtrim(string(ewidth),2)
    endfor
    ;print,'equiwidth: ewidth = ',ewidth

; --- plot range
    rangepsfile = strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(xmiddle),2)+'.eps'
    ;print,'equiwidth: rangepsfile = ',rangepsfile
    set_plot,'ps'
    device,filename=rangepsfile
    plot,lambdaarr,intensarr,xtitle='lambda ('+STRING("305B)+')',ytitle='normalized flux',xtickformat='(F9.2)',xstyle=1,ystyle=1
    oplot,[xmin,xmin],[min(intensarr),max(intensarr)],psym=0
    oplot,[xmax,xmax],[min(intensarr),max(intensarr)],psym=0
    oplot,[xmin,xmax],[1.,1.],psym=0
    device,/close
    set_plot,'x'
    
    openw,lun,outfile,/GET_LUN,/APPEND
    printf,lun,datfile+' '+strtrim(string(ewidth),2)
    free_lun,lun

endelse
end
