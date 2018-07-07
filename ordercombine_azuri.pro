;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;############################
pro ordercombine,filelist,outfile
;############################
;
; NAME:                  ordercombine
; PURPOSE:               combines the orders of a spectra, stored in
;                        the files which are written to filelist, to a
;                        single spectra
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      ordercombine,'filelist','outfile'
; INPUTS:                input file: 'filelist':
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecd_01.text
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecd_02.text
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecd_03.text
;                                            .
;                                            .
;                                            .
;                        outfile: String
; OUTPUTS:               outfile:
;                         3740.80444335938      105783.50
;                         3740.82373046875      104585.70
;                         3740.84277343750      106158.90
;                                            .
;                                            .
;                                            .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;

if n_elements(outfile) eq 0 then begin
  print,'ordercombine: No outfile specified, return 0.'
  print,'ordercombine: USAGE: ordercombine:<in: filelist:String>,<out: outfile:String>'
end else begin
  path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)

;--- open logfile
  close,101
  openw,101,filelist+'.log'

;--- countlines
  maxn = 0UL
  maxn = countlines(filelist)
  print,filelist,': ',maxn,' FILES / ORDERS'
  printf,101,filelist,': ',maxn,' FILES / ORDERS'

;--- build arrays
  files = strarr(maxn)
  npix  = intarr(maxn)
  firstlambda = dblarr(maxn)
  lastlambda  = dblarr(maxn)
  meana = dblarr(maxn)
  meanb = dblarr(maxn)

;--- define variables
  filenameq = ''
  lambdaq   = 0.
  intensq   = 0.
  endpos    = 0
  lastpos   = 0
  dumxa     = 0.
  dumya     = 0.
  dumxb     = 0.
  dumyb     = 0.
  dumxc     = 0.
  dumyc     = 0.
  dumxd     = 0.
  dumyd     = 0.
  dumxe     = 0.
  dumye     = 0.
  dumxf     = 0.
  dumyf     = 0.
  dumxg     = 0.
  dumyg     = 0.
  dumxh     = 0.
  dumyh     = 0.
  dumxi     = 0.
  dumyi     = 0.

;--- read filenames
  close,1
  openr,1,filelist
  for i=0,maxn-1 do begin
      readf,1,filenameq
      files(i) = path+filenameq
  endfor
  close,1

;--- count pix per order
  for i=0,maxn-1 do begin
      npix(i) = countlines(files(i))
  endfor

;--- define arrays
  lambda = dblarr(maxn,max(npix))
  intens = dblarr(maxn,max(npix))
  overlap = intarr(maxn,2)
  lambdaend = dblarr(maxn*max(npix))
  intensend = dblarr(maxn*max(npix))

;--- read orders
  close,2
  for i=0,maxn-1 do begin
      openr,2,files(i)
      for j=0UL,npix(i)-1 do begin
          readf,2,lambdaq,intensq
          lambda(i,j) = lambdaq
          intens(i,j) = intensq
;          print,'lambda(',i,',',j,') = ',lambda(i,j)
;          print,'intens(',i,',',j,') = ',intens(i,j)
      endfor
      close,2
  endfor

;--- find overlap
  for i=0,maxn-1 do begin
      firstlambda(i) = lambda(i,0)
      lastlambda(i)  = lambda(i,npix(i)-1)
  endfor
  for i=0,maxn-1 do begin
      if i eq 0 then begin
          for j=0UL,npix(i)-2 do begin
              if (lambda(i,j) lt firstlambda(i+1)) and (lambda(i,j+1) ge firstlambda(i+1)) then begin
                  overlap(i,1) = j+1
              end
          endfor
          overlap(i,0) = 0
          printf,101,'ordercombine: overlap(',i,',0) = ',overlap(i,0),', overlap(',i,',1) = ',overlap(i,1)
          printf,101,'ordercombine: lambda(i,',overlap(i,1)-1,') = ',lambda(i,overlap(i,1)-1)
          printf,101,'ordercombine: lambda(i,',overlap(i,1),') = ',lambda(i,overlap(i,1))
          printf,101,'ordercombine: lambda(i,',overlap(i,1)+1,') = ',lambda(i,overlap(i,1)+1)
          printf,101,'ordercombine: firstlambda(i+1) = ',firstlambda(i+1)
      end else if i eq maxn-1 then begin
          for j=0UL,npix(i)-2 do begin
              if (lambda(i,j) le lastlambda(i-1)) and (lambda(i,j+1) gt lastlambda(i-1)) then begin
                  overlap(i,0) = j
              end
          endfor
          overlap(i,1) = npix(i)-1
;          printf,101,'ordercombine: overlap(',i,',0) = ',overlap(i,0),', overlap(',i,',1) = ',overlap(i,1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,0)-1,') = ',lambda(i,overlap(i,0)-1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,0),') = ',lambda(i,overlap(i,0))
;          printf,101,'ordercombine: lambda(i,',overlap(i,0)+1,') = ',lambda(i,overlap(i,0)+1)
;          printf,101,'ordercombine: firstlambda(i+1) = ',firstlambda(i+1)
;          printf,101,'ordercombine: lastlambda(i-1)  = ',lastlambda(i-1)
      end else begin
          for j=0UL,npix(i)-2 do begin
              if (lambda(i,j) le lastlambda(i-1)) and (lambda(i,j+1) gt firstlambda(i-1)) then begin
                  overlap(i,0) = j
              end
              if (lambda(i,j) lt firstlambda(i+1)) and (lambda(i,j+1) ge firstlambda(i+1)) then begin
                  overlap(i,1) = j+1
              end
          endfor
;          printf,101,'ordercombine: overlap(',i,',0) = ',overlap(i,0),', overlap(',i,',1) = ',overlap(i,1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,0)-1,') = ',lambda(i,overlap(i,0)-1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,0),') = ',lambda(i,overlap(i,0))
;          printf,101,'ordercombine: lambda(i,',overlap(i,0)+1,') = ',lambda(i,overlap(i,0)+1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,1)-1,') = ',lambda(i,overlap(i,1)-1)
;          printf,101,'ordercombine: lambda(i,',overlap(i,1),') = ',lambda(i,overlap(i,1))
;          printf,101,'ordercombine: lambda(i,',overlap(i,1)+1,') = ',lambda(i,overlap(i,1)+1)
;          printf,101,'ordercombine: firstlambda(i+1) = ',firstlambda(i+1)
;          printf,101,'ordercombine: lastlambda(i-1) = ',lastlambda(i-1)
      end
  endfor

;--- normalize flux
  meanb(0) = mean(intens(0,overlap(0,1):npix(0)-1))
  for i=1,maxn-1 do begin
      meana(i) = mean(intens(i,0:overlap(i,0)))
      for j=0UL,npix(i)-1 do begin
          print,'i = ',i,', j = ',j
          intens(i,j) = intens(i,j)*(meanb(i-1)/meana(i))
      endfor
      meanb(i) = mean(intens(i,overlap(i,1):npix(i)-1))
  endfor

;--- combine orders
  close,3
  openw,3,outfile
  for i=0UL,overlap(0,1)-1 do begin
      lambdaend(i) = lambda(0,i)
      intensend(i) = intens(0,i)
      if intens(0,i) gt 0. then begin
          printf,3,lambdaend(i),intensend(i),FORMAT = '(F16.11, F15.2)'
      endif
      printf,101,'ordercombine: i = '+strtrim(string(i),2)+': lambda = '+$
         strtrim(string(lambdaend(i)),2)+', intensity = '+strtrim(string(intensend(i)),2)
      endpos = i
  endfor
  for i=1,maxn-1 do begin
      lastpos = overlap(i-1,1)-1
      for j=0,overlap(i,0) do begin
          if ((lambda(i,j) gt lambda(i-1,lastpos)) and (lambda(i,j) le lambda(i-1,lastpos+1))) and $
             ((lambda(i,j+1) gt lambda(i-1,lastpos)) and (lambda(i,j+1) le lambda(i-1,lastpos+1))) then begin
;              if j gt 0 then begin
;                  printf,101,'ordercombine: a i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: a lambda(i,j-1) = ',lambda(i,j-1),', lambda(i,j) = ',lambda(i,j),$
;                    ', lambda(i,j+1) = ',lambda(i,j+1)
;                  printf,101,'ordercombine: a lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1),', lambda(i-1,lastpos+2) = ',lambda(i-1,lastpos+2)
;              end else begin
;                  printf,101,'ordercombine: a i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: a lambda(i,j) = ',lambda(i,j),', lambda(i,j+1) = ',lambda(i,j+1)
;                  printf,101,'ordercombine: a lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1),', lambda(i-1,lastpos+2) = ',lambda(i-1,lastpos+2)
;              end
              endpos = endpos+1
              dumxa = lambda(i-1,lastpos)
              dumya = intens(i-1,lastpos)
;              printf,101,'ordercombine: a dumxa = ',dumxa,', dumya = ',dumya
              dumxb = lambda(i,j)
              dumyb = intens(i,j)
;              printf,101,'ordercombine: a dumxb = ',dumxb,', dumyb = ',dumyb
              dumxc = lambda(i,j+1)
              dumyc = intens(i,j+1)
;              printf,101,'ordercombine: a dumxc = ',dumxc,', dumyc = ',dumyc
              dumxd = lambda(i-1,lastpos+1)
              dumyd = intens(i-1,lastpos+1)
;              printf,101,'ordercombine: a dumxd = ',dumxd,', dumyd = ',dumyd
              dumxe = dumxa+((dumxb-dumxa)/2.)
              dumye = dumya+((dumyb-dumya)/2.)
;              printf,101,'ordercombine: a dumxe = ',dumxe,', dumye = ',dumye
              dumxf = dumxb + ((dumxc-dumxb)/2.)
              dumyf = dumyb + ((dumyc-dumyb)/2.)
;              printf,101,'ordercombine: a dumxf = ',dumxf,', dumyf = ',dumyf
              dumxg = dumxc+((dumxd-dumxc)/2.)
              dumyg = dumyc+((dumyd-dumyc)/2.)
;              printf,101,'ordercombine: a dumxg = ',dumxg,', dumyg = ',dumyg
              dumxh = dumxe+((dumxf-dumxe)/2.)
              dumyh = dumye+((dumyf-dumye)/2.)
;              printf,101,'ordercombine: a dumxh = ',dumxh,', dumyh = ',dumyh
              dumxi = dumxf+((dumxg-dumxf)/2.)
              dumyi = dumyf+((dumyg-dumyf)/2.)
;              printf,101,'ordercombine: a dumxi = ',dumxi,', dumyi = ',dumyi
              lambdaend(endpos) = dumxh + ((dumxi-dumxh)/2.)
              intensend(endpos) = dumyh + ((dumyi-dumyh)/2.)
;              printf,101,'ordercombine: a lastpos = ',lastpos
              if intens(i,j) gt 0. then begin
                  printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F20.5)'
              endif
              printf,101,'ordercombine: a endpos = '+strtrim(string(endpos),2)+': lambda = '+strtrim(string(lambdaend(endpos)),2)+$
                    ', intensity = '+strtrim(string(intensend(endpos)),2)
              lastpos = lastpos + 1
;          end else if      then begin
          end else if ((lambda(i,j) gt lambda(i-1,lastpos)) and (lambda(i,j) le lambda(i-1,lastpos+1))) and $
             lambda(i,j+1) gt lambda(i-1,lastpos+1) then begin
;              if j gt 0 and j lt overlap(i,0)-2 then begin
;                  printf,101,'ordercombine: b i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: b lambda(i,j-1) = ',lambda(i,j-1),', lambda(i,j) = ',lambda(i,j),$
;                    ', lambda(i,j+1) = ',lambda(i,j+1)
;                  printf,101,'ordercombine: b lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1),', lambda(i-1,lastpos+2) = ',lambda(i-1,lastpos+2)
;              end else if j le overlap(i,0)-2 then begin
;                  printf,101,'ordercombine: b i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: b lambda(i,j) = ',lambda(i,j),', lambda(i,j+1) = ',lambda(i,j+1)
;                  printf,101,'ordercombine: b lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1),', lambda(i-1,lastpos+2) = ',lambda(i-1,lastpos+2)
;              end else begin
;                  printf,101,'ordercombine: b i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: b lambda(i,j) = ',lambda(i,j)
;                  printf,101,'ordercombine: b lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos)
;              end
              endpos = endpos+1
              dumxa = lambda(i-1,lastpos)
              dumya = intens(i-1,lastpos)
;              printf,101,'ordercombine: b dumxa = ',dumxa,', dumya = ',dumya
              dumxb = lambda(i,j)
              dumyb = intens(i,j)
;              printf,101,'ordercombine: b dumxb = ',dumxb,', dumyb = ',dumyb
              dumxd = dumxa+((dumxb-dumxa)/2.)
              dumyd = dumya+((dumyb-dumya)/2.)
;              printf,101,'ordercombine: b dumxd = ',dumxd,', dumyd = ',dumyd
              dumxc = lambda(i-1,lastpos+1)
              dumyc = intens(i-1,lastpos+1)
;              printf,101,'ordercombine: b dumxc = ',dumxc,', dumyc = ',dumyc
              dumxe = dumxb + ((dumxc-dumxb)/2.)
              dumye = dumyb + ((dumyc-dumyb)/2.)
;              printf,101,'ordercombine: b dumxe = ',dumxe,', dumye = ',dumye
              lambdaend(endpos) = dumxd + ((dumxe-dumxd)/2.)
              intensend(endpos) = dumyd + ((dumye-dumyd)/2.)
;              printf,101,'ordercombine: b lastpos = ',lastpos
              if intens(i,j) gt 0. then begin
                  printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F15.2)'
              endif
              printf,101,'ordercombine: b endpos = '+strtrim(string(endpos),2)+': lambdaend = '+strtrim(string(lambdaend(endpos)),2)+$
                    ', intensityend = '+strtrim(string(intensend(endpos)),2)
              if j le overlap(i,0)-1 then begin
                  if lambda(i,j+1) gt lambda(i-1,lastpos+2) then begin
                      anstieg = (intens(i-1,lastpos+2)-intens(i-1,lastpos+1))/(lambda(i-1,lastpos+2)-lambda(i-1,lastpos+1))
                      constante = intens(i-1,lastpos+1)-(anstieg*lambda(i-1,lastpos+1))
                      endpos = endpos+1
                      lambdaend(endpos) = lambda(i-1,lastpos+1) + ((lambda(i-1,lastpos+2)-lambda(i-1,lastpos+1))/2.)
                      intensend(endpos) = intens(i-1,lastpos+1) + (anstieg*(lambdaend(endpos)-lambda(i-1,lastpos+1)))
                      if intens(i,j) gt 0. then begin
                          printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F15.2)'
                      endif
                      printf,101,'ordercombine: c endpos = '+strtrim(string(endpos),2)+': lambda = '+strtrim(string(lambdaend(endpos)),2)+$
                    ', intensity = '+strtrim(string(intensend(endpos)),2)
                      lastpos = lastpos + 2
                  end else begin
                      lastpos = lastpos + 1
                  end
              end else begin
                  lastpos = lastpos + 1
              end
;              printf,101,'ordercombine: lastpos = ',lastpos
          end else if lambda(i,j) eq lambda(i-1,lastpos) then begin
              endpos = endpos + 1
              lambdaend(endpos) = lambda(i,j)
              intensend(endpos) = (intens(i,j) + intens(i-1,lastpos)) / 2.
              if intens(i,j) gt 0. then begin
                  printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F15.2)'
              endif
              printf,101,'ordercombine: f endpos = '+strtrim(string(endpos),2)+': lambdaend = '+strtrim(string(lambdaend(endpos)),2)+$
                    ', intensityend = '+strtrim(string(intensend(endpos)),2)
              lastpos = lastpos + 1
          end else begin
              if j eq 0 then begin
                  printf,101,'ordercombine: ERROR: i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
                  printf,101,'ordercombine: ERROR: lambda(i,j) = ',lambda(i,j),', lambda(i,j+1) = ',lambda(i,j+1)
                  printf,101,'ordercombine: ERROR: lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1)
              end else begin
                  printf,101,'ordercombine: ERROR: i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
                  printf,101,'ordercombine: ERROR: lambda(i,j-1) = ',lambda(i,j-1),', lambda(i,j) = ',lambda(i,j),$
                    ', lambda(i,j+1) = ',lambda(i,j+1)
                  printf,101,'ordercombine: ERROR: lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1)
              end 
;else if j lt overlap(i,0)-2 then begin
;                  printf,101,'ordercombine: ERROR: i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: ERROR: lambda(i,j) = ',lambda(i,j),', lambda(i,j+1) = ',lambda(i,j+1)
;                  printf,101,'ordercombine: ERROR: lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos),', lambda(i-1,lastpos+1) = ',lambda(i-1,lastpos+1)
;              end else begin
;                  printf,101,'ordercombine: ERROR: i=',i,', j=',j,', lastpos=',lastpos,', endpos=',endpos
;                  printf,101,'ordercombine: ERROR: lambda(i,j) = ',lambda(i,j)
;                  printf,101,'ordercombine: ERROR: lambda(i-1,lastpos-1) = ',lambda(i-1,lastpos-1),', lambda(i-1,lastpos) = ',$
;                    lambda(i-1,lastpos)
;              end
;;              lastpos = lastpos + 1
          end
      endfor
      for j=overlap(i,0)+1,overlap(i,1)-1 do begin
          endpos = endpos+1
          lambdaend(endpos) = lambda(i,j)
          intensend(endpos) = intens(i,j)
          if intens(i,j) gt 0. then begin
              printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F15.2)'
          endif
          printf,101,'ordercombine: d endpos = '+strtrim(string(endpos),2)+': lambdaend = '+strtrim(string(lambdaend(endpos)),2)+$
                ', intensityend = '+strtrim(string(intensend(endpos)),2)
      endfor
  endfor
;  for i=overlap(maxn-1,0)+1,npix(maxn-1)-1 do begin
;      if intens(maxn-1,i) gt 0. then begin
;          endpos = endpos+1
;          lambdaend(endpos) = lambda(maxn-1,i)
;          intensend(endpos) = intens(maxn-1,i)
;          printf,3,lambdaend(endpos),intensend(endpos),FORMAT = '(F16.11, F15.2)'
;          printf,101,'ordercombine: e endpos = '+strtrim(string(endpos),2)+': lambdaend = '+strtrim(string(lambdaend(endpos)),2)+$
;                ', intensity = '+strtrim(string(intensend(endpos)),2)
;      end
;  endfor
;  lambdaend = congrid(lambdaend,endpos+1)
;  intensend = congrid(intensend,endpos+1)

  print,'ordercombine: min(lambdaend) = ',min(lambdaend),', max(lambdaend) = ',max(lambdaend)
  print,'ordercombine: min(intensend) = ',min(intensend),', max(intensend) = ',max(intensend)

;--- plot result
  set_plot,'ps'
  device,filename=strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'.ps'
  plot,lambdaend[0:endpos],intensend[0:endpos],xtitle='wavelength / A',ytitle='flux',xrange=[min(lambdaend[0:endpos]),max(lambdaend[0:endpos])],yrange=[10,max(intensend[0:endpos])],xstyle=1,ystyle=1,/ylog,position=[0.15,0.1,0.98,0.9]
  device,/close
  set_plot,'x'

;--- write result
;  close,2
;  openw,2,outfile
;  for i=0UL,endpos do begin
;      if lambdaend(i) lt 0.0001 then printf,101,'ordercombine: lambdaend(',i,') = ',lambdaend(i)
;      if intensend(i) lt 0.0001 then printf,101,'ordercombine: intensend(',i,') = ',intensend(i)
;      printf,2,lambdaend(i),intensend(i),FORMAT = '(F16.11, F15.2)'
;  endfor
  close,2
  close,101
endelse
end
