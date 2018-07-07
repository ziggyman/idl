;##################################################### 
procedure do_htmldoc_sestest_results,ecdtlist,ecdtmlist,ecdtslist,ecdtclist,ecdctslist,ecdctmlist
;#####################################################

if n_elements(ecdctmlist) eq 0 then begin
  print,'do_htmldoc_sestest_results: NOT ENOGH PARAMETERS SPECIFIED -> return 0'
  print," USAGE: do_htmldoc_sestest_results,'ecdtlist','ecdtmlist','ecdtslist','ecdtclist','ecdctslist','ecdctmlist'"
endif else begin

  necdtfiles   = countlines(ecdtlist)
  necdtmfiles  = countlines(ecdtmlist)
  necdtslist   = countlines(ecdtslist)
  necdtclist   = countlines(ecdtclist)
  necdctslist  = countlines(ecdctslist)
  necdctmlist  = countlines(ecdctmlist)
  
  ecdtarr    = strarr(necdtfiles)
  ecdtmarr   = strarr(necdtmfiles)
  ecdtsarr   = strarr(necdtsfiles)
  ecdtcarr   = strarr(necdtcfiles)
  ecdctsarr  = strarr(necdctsfiles)
  ecdctmarr  = strarr(necdctmfiles)

  i = 0UL
  j = 0UL
  k = 0UL
  l = 0UL
  tempstr = ''

  openr,lun,ecdtlist,/GET_LUN
  for i=0,necdtfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtarr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,ecdtclist,/GET_LUN
  for i=0,necdtcfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtcarr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,ecdtmlist,/GET_LUN
  for i=0,necdtmfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtmarr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,ecdtclist,/GET_LUN
  for i=0,necdtcfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtcarr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,ecdtcslist,/GET_LUN
  for i=0,necdtcsfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtcsarr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,ecdtcmlist,/GET_LUN
  for i=0,necdtcmfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    ecdtcmarr(i) = tempstr
  endfor
  free_lun,lun
  
; --- write html file
; --- main file
  outfile='/home/azuri/daten/html/stella-testresults/results.html'
  openw,lunw,outfile,/GET_LUN
  printf,lunw,'<center>'
  printf,lunw,'  <h1>SES test results</h1>'
  printf,lunw,'  <h2>Results</h2><hr><br>'
  printf,lunw,'  Here the first two observing blocks, taken 11/10/05 and 11/27/05, are presented. The images have been reduced using the STELLA pipeline.<br><br><hr><br>'
  printf,lunw,'  <a href="11-10-05.html">11/10/05</a><br><br>'
  printf,lunw,'  <a href="11-27-05.html">27/10/05</a><br><br><hr>'
  printf,lunw,'</center>'
  free_lun,lunw

; --- 11-10-05
  outfilee='/home/azuri/daten/html/stella-testresults/11-10-05.html'
  openw,lunwe,outfilee,/GET_LUN
  printf,lunwe,'<center>'
  printf,lunwe,'  <h1>SES test results</h1>'
  printf,lunwe,'  <h2>Observing block 11/10/05</h2><hr><br>'
  printf,lunwe,'  <h3>The different letters at the end of the image names mean the following:</h3><br><br>'
  printf,lunwe,'  b...bad pixel rejected<br>'
  printf,lunwe,'  o...overscan subtracted<br>'
  printf,lunwe,'  t...trimmed<br>'
  printf,lunwe,'  z...zero-image level subtracted<br>'
  printf,lunwe,'  s...scattered light subtracted<br>'
  printf,lunwe,'  f...flattened<br>'
  printf,lunwe,'  x...cosmic rays rejected<br>'
  printf,lunwe,'  ec...extracted<br>'
  printf,lunwe,'  d...dispersion corrected<br>'
  printf,lunwe,'  c...continuum set<br>'
  printf,lunwe,'  t...trimmed (again)<br>'
  printf,lunwe,'  s...spectra combined (with the IRAF-scombine task<br>'
  printf,lunwe,'  m...spectra combined (with the STELLA-stmerge task<br>'

; --- 11-27-05
  outfiles='/home/azuri/daten/html/stella-testresults/11-27-05.html'
  openw,lunws,outfiles,/GET_LUN
  printf,lunws,'<center>'
  printf,lunws,'  <h1>SES test results</h1>'
  printf,lunws,'  <h2>Observing block 11/27/05</h2><hr><br>'
  printf,lunws,'  <h3>The different letters at the end of the image names mean the following:</h3><br><br>'
  printf,lunws,'  b...bad pixel rejected<br>'
  printf,lunws,'  o...overscan subtracted<br>'
  printf,lunws,'  t...trimmed<br>'
  printf,lunws,'  z...zero-image level subtracted<br>'
  printf,lunws,'  s...scattered light subtracted<br>'
  printf,lunws,'  f...flattened<br>'
  printf,lunws,'  x...cosmic rays rejected<br>'
  printf,lunws,'  ec...extracted<br>'
  printf,lunws,'  d...dispersion corrected<br>'
  printf,lunws,'  c...continuum set<br>'
  printf,lunws,'  t...trimmed (again)<br>'
  printf,lunws,'  s...spectra combined (with the IRAF-scombine task<br>'
  printf,lunws,'  m...spectra combined (with the STELLA-stmerge task<br><br><hr><br>'

; --- sort images by night
  for i=0;necdtfiles-1 do begin
    if whichnight(ecdtarr(i) eq 1 then $
      printf,lunwe,'  <a href="'+strtrim(ecdtarr(i),2)+'"><img src="'+ecdtarr(i)+'" width=30%>This image 
  ecdtmarr   = strarr(necdtmfiles)
  ecdtsarr   = strarr(necdtsfiles)
  ecdtcarr   = strarr(necdtcfiles)
  ecdctsarr  = strarr(necdctsfiles)
  ecdctmarr  = strarr(necdctmfiles)
  endfor

  printf,lunwe,'</center>'
  free_lun,lunwe
  printf,lunws,'</center>'
  free_lun,lunws

end
