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

;############################
pro empty,parameter
;############################
;
; NAME:                  empty
; PURPOSE:               * calculates ...
;                        
; CATEGORY:              
; CALLING SEQUENCE:      empty,<parametertype parameter>
; INPUTS:                input file: 'parameter':
;                         3740.80444335938      105783.50
;                                            .
;                                            .
;                                            .
;                        outfile: String
; OUTPUTS:               outfile:
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.12.2005
;

if n_elements(parameter) eq 0 then begin
  print,'empty: No outfile specified, return 0.'
  print,'empty: USAGE: empty,<in: parameter:Type of parameter>'
end else begin

  tempstr = ''

;countlines
  maxn = 0UL
  maxn = countlines(parameter)
  print,parameter,': ',maxn,' LINES'  
  maxndat = 0UL
  maxndat = countdatlines(parameter)
  print,parameter,': ',maxndat,' DATA LINES'  

;build arrays
  dumla            = dblarr(maxndat)
  intensstddev     = 0.
  dintens          = 5
  i = 0UL
  j = 0UL
  k = 0UL

;read file in arrays
  print,'empty: reading file ',parameter
  openr,lun,parameter,/GET_LUN
  for i=0UL,maxn-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    if strmid(tempstr,0,1) ne '#' then begin
      dumla(j)
      print,'empty: reading file: line ',i,': dumla(',i,') = ',dumla(i)
      j+=1
    end
  end
  free_lun,lun

  print,'empty: j = ',j

  maxn = j
  lambda    = dblarr(maxn)
  for l=0UL,maxndat-1 do begin
      lambda(l) = dumla(l)
  end

  openw,luna,outfile,/APPEND,/GET_LUN
  openw,lunb,datoutfile,/APPEND,/GET_LUN

;calculat
      
; --- plot snrarray
  set_plot,'ps'
  device,filename=strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_snr.ps'
  mytitle = ''
  mytitle = '!A'+strmid(datfile,strpos(datfile,'/')+1,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'/')-1)
  mytitle = mytitle + ': mean(SNR) = '+strtrim(string(long(mean(dumsnr))),2)
  print,'mytitle = '+mytitle
  plot,lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1))),dumsnr,title=mytitle,xtitle='wavelength / '+STRING("305B),ytitle='SNR',yrange=[min(dumsnr)-stddev(dumsnr),max(dumsnr)+stddev(dumsnr)],ystyle=1,xrange=[min(lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1)))),max(lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1))))],xstyle=1,position=[0.15,0.1,0.98,0.9]
  device,/free_lun
  set_plot,'x'
      
  free_lun,luna
  free_lun,lunb
endelse
end
