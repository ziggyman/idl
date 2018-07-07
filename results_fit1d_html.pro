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
pro results_fit1d_html,pslist_fit1d_nobg,pslist_fit1d,parameterfile_fit1d
;############################
;
; NAME:                  results_fit1d_html
; PURPOSE:               documents results of the STELLA-pipeline
;                        tests in a html file
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      results_fit1d_html,'fit1d_psfiles.list','parameters.text'
; INPUTS:                input files:
;                         'fit1d_psfiles.list':
;                          testfit1d/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsff1d_ecdc_3906.54-3907.26.ps
;                          testfit1d/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsff1d_ecdc_4005.61-4010.75.ps
;                          testfit1d/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsff1d_ecdc_4184.53-4186.18.ps
;
;                         'parameterfile':
;                                            .
;                                            .
;                                            .
; OUTPUTS:               STELLA-pipeline.html
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           26.01.2004
;
if n_elements(pslist_nobg_fit1d) eq 0 then begin
    pslist_nobg_fit1d='fit1d_nobg_psfiles.list'
    pslist_fit1d='fit1d_psfiles.list'
    parameterfile_fit1d='testfit1d/parameters.text'
end
if n_elements(parameterfile_fit1d) eq 0 then begin
  print,'results_fit1d_html: Not enough parameters given, return 0.'
  print,"usage: results_fit1d_html,'pslist_fit1d','../testfit1d/paramters.text'"
endif else begin   

  iq = ''
  jq = ''
  root = ''
  temproot = ''
  in = ''
  out = ''
  outsmall = ''
  explain = ''

;countlines
  maxn = countlines(pslist_fit1d)
  print,'results_fit1d_html: ',maxn,' FILENAMES in ',pslist_fit1d


;write testfit1ds.html
  openw,2,'testfit1d.html'
  printf,2,'<html>'
  printf,2,'<head>'
  printf,2,'<TITLE>Report of test with fitting spectrum with the FIT1D algorithm before extracting them</TITLE>'
  printf,2,'</head>'
  printf,2,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,2,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,2,'<center>'
  printf,2,'<h1>Report of the STELLA-pipeline test with fitting spectrum with the FIT1D algorithm before extracting them</h1>'
  printf,2,'<br><hr><br>'
  printf,2,'<b>Fitting spectra means that the two dimensional spectra within the defined apertures of the input images are fit by a model using IRAF-TWODSPEC.APEXTRACT profile algorithms.</b><br><br><hr><br>'
  parameterfile = 'parameterfile_testfit1d.html'
  printf,2,'<a href="'+parameterfile+'">view parameterfile</a><br>'
  printf,2,'<br><hr><br>'
  printf,2,'<table><tr><td>+</td><td>whole wavelengthrange</td></tr>'
  printf,2,'<tr><td>*</td><td>small wavelengthrange</td></tr></table>'
  printf,2,'<br><hr><br>'

; parameterfile_fit1d
  close,5
  openr,5,parameterfile_fit1d
  close,6
  openw,6,parameterfile
  printf,6,'<html>'
  printf,6,'<head>'
  printf,6,'<TITLE>Report of the STELLA-pipeline test with fitting spectrum with the FIT1D algorithm before extracting them</TITLE>'
  printf,6,'</head>'
  printf,6,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,6,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,6,'<center>'
  printf,6,'<h1>Master paramterfile for STELLA-pipeline test with fitting spectrum with the FIT1D algorithm before extracting them</h1>'
  printf,6,'</center>'
  printf,6,'<br><hr><br>'
  for i=0UL,countlines(parameterfile_fit1d)-1 do begin
      readf,5,iq
      if (strmid(iq,0,5) eq '(pfit') or $
         (strmid(iq,0,8) eq '(backgro') or $
         (strmid(iq,0,4) eq '(fit') then begin
          printf,6,'<b><font color="#FF0000">'+iq+'</font></b><br>'
      endif else begin
          printf,6,iq+'<br>'
      end
  endfor
  printf,6,'<table><tr>'
  printf,6,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,6,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,6,'</tr></table>'
  printf,6,'</body></html>'
  close,6
  close,5

; pslist_fit1d
  close,3
  openr,3,pslist_nobg_fit1d
  close,4
  printf,2,'<h2>without background subtraction</h2><br>'
  for i=0UL,maxn-1 do begin
    readf,3,iq
    root = strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))
    in = root+'001.ppm'
    out = root+'.jpg'
    outsmall = root+'_small.jpg'
    outbig = root+'_big.jpg'
; --- build jpg's
    spawn,'cp '+iq+' temp.ps'
    spawn,'pstopnm -xsize 450 -ysize 322 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+out
    spawn,'pstopnm -xsize 200 -ysize 128 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+outsmall
    spawn,'pstopnm -xsize 788 -ysize 564 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+outbig

    explain = 'Spectrum fitted using the fit1d-profile algorithm '
; --- write links and pics
    if strmid(iq,strpos(iq,'nobg')+4,1) eq '.' then begin
    ; --- botzxsff1d_ecdc.ps
        printf,2,'<br><center><a href="'+outbig+'"><img src="'+out+'" alt="'+explain+'"></a>'
    end else if(strmid(root,strpos(root,'_',/REVERSE_SEARCH),4) eq '_snr') then begin
    ; --- all-wavelenghts file
        printf,2,'<a href="'+outbig+'"><img src="'+out+'" alt="'+explain+'">'
        printf,2,'</a></center><br><hr><br>'
    end else begin
;   --- single-wavelength file
        printf,2,'<a href="'+outbig+'"><img src="'+outsmall+'" alt="'+explain+'"></a>'
    end
  end
; pslist_fit1d
  close,3
  openr,3,pslist_fit1d
  close,4
  printf,2,'<hr><br><br><h2>with background subtraction</h2><br>'
  for i=0UL,maxn-1 do begin
    readf,3,iq
    root = strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))
    in = root+'001.ppm'
    out = root+'.jpg'
    outsmall = root+'_small.jpg'
    outbig = root+'_big.jpg'
; --- build jpg's
    spawn,'cp '+iq+' temp.ps'
    spawn,'pstopnm -xsize 450 -ysize 322 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+out
    spawn,'pstopnm -xsize 200 -ysize 128 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+outsmall
    spawn,'pstopnm -xsize 788 -ysize 564 temp.ps'
    spawn,'pnmtojpeg temp001.ppm > '+outbig

    explain = 'Spectrum fitted using the fit1d-profile algorithm '
; --- write links and pics
    if strmid(iq,strpos(iq,'ecdc')+4,1) eq '.' then begin
    ; --- botzxsff1d_ecdc.ps
        printf,2,'<br><center><a href="'+outbig+'"><img src="'+out+'" alt="'+explain+'"></a>'
    end else if(strmid(root,strpos(root,'_',/REVERSE_SEARCH),4) eq '_snr') then begin
    ; --- all-wavelenghts file
        printf,2,'<a href="'+outbig+'"><img src="'+out+'" alt="'+explain+'">'
        printf,2,'</a></center><br><hr><br>'
    end else begin
;   --- single-wavelength file
        printf,2,'<a href="'+outbig+'"><img src="'+outsmall+'" alt="'+explain+'"></a>'
    end
  end
  close,3
  close,4
  printf,2,'<br><br><center><hr><br>'
  printf,2,'<table><tr>'
  printf,2,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,2,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,2,'</tr></table>'
  printf,2,'</body></html>'
  close,2

endelse
end
