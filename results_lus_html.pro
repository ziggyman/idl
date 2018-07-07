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
pro results_lus_html,snrresults_lus,pslist_lus,parameterfile_lus,sigmas_datfile
;############################
;
; NAME:                  results_lus_html
; PURPOSE:               documents results of the STELLA-pipeline
;                        tests in a html file
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      results_lus_html,'snrresults_lus_jpgs.list','lus_psfiles.list','parameterfile','sigmas.list'
; INPUTS:                input files:
;                         'snrresults_lus_jpgs.list':
;                          snrresults_testsigma_whole_wavelengthrange.jpg
;                          snrresults_testsigma_3906.545-3907.264.jpg
;                          snrresults_testsigma_4005.609-4010.746.jpg
;
;                         'lus_psfiles.list':
;                          testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.01_3906.5450-3907.2640.ps
;                          testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.01_4005.6090-4010.7460.ps
;                          testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.01_4184.5290-4186.1760.ps
;
;                         'parameterfile_UVES_blue_437_2148x3000_lsigma1._usigma1.prop'
;
;                         'sigmas.list'
;                           0.01
;                           0.05
;                           0.1
;                                .
;                                .
;                                .
; OUTPUTS:               'testsigmas.html'
;                        'testsigmas_wholewavelengthrange.html'
;                        'testsigmas_'+strmid(iq,strpos(iq,'_',/REVERSE_SEARCH)+1,strpos(iq,'.',/REVERSE_SEARCH)-strpos(iq,'_',/REVERSE_SEARCH)-1)
;                        'parameterfile_testlus.html'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           11.01.2004
;
if n_elements(sigmas_datfile) eq 0 then begin
    snrresults_lus='snrresults_lus_jpgs.list'
    pslist_lus='lus_psfiles.list'
    parameterfile_lus='parameterfile_UVES_blue_437_2148x3000_lsigma1._usigma1.prop'
    sigmas_datfile = 'sigmas.list'
end
if n_elements(pslist_lus) eq 0 then begin
  print,'results_lus_html: Not enough parameters given, return 0.'
  print,"usage: results_lus_html,'snrresults_lus','pslist_lus','paramterfile_lus'"
endif else begin   

  iq = ''
  jq = ''
  root = ''
  temproot = ''
  templsigma = ''
  tempusigma = ''
  in = ''
  out = ''
  outsmall = ''
  explain = ''
  lsigma = ''
  usigma = ''
  nareas = 13
  nsigmas = countlines(sigmas_datfile)
  print,'nsigmas = ',nsigmas

;countlines
  maxl = countlines(snrresults_lus)
  maxn = countlines(pslist_lus)
  print,'results_lus_html: ',maxl,' FILENAMES in ',snrresults_lus,', ',maxn,' filenames in ',pslist_lus 

;write testsigmas.html
  close,2
  openw,2,'testsigmas.html'
  printf,2,'<html>'
  printf,2,'<head>'
  printf,2,'<TITLE>Report of test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</TITLE>'
  printf,2,'</head>'
  printf,2,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,2,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,2,'<center>'
  printf,2,'<h1>Report of the STELLA-pipeline test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</h1>'
  printf,2,'<br><br><hr><br>'
  printf,2,'<b>The parameters EXTLSIGMA and EXTUSIGMA are identical to the IRAF-NOAO.IMRED.ECHELLE.APSUM.LSIGMA / USIGMA parameter. They set the lower / upper rejection threshold of the extraction task to LSIGMA / USIGMA times the standard deviation of one pixel in comparison to the surrounding pixels.</b><br><br><hr><br>'
  parameterfile = 'parameterfile_testlus.html'
  printf,2,'<a href="'+parameterfile+'">view parameterfile</a><br>'
  printf,2,'<br><br><hr><br>'
  
; --- snrresults_lus
  wholewavelengthrange_htmlfile = 'testsigmas_wholewavelengthrange.html'
  close,3
  openw,3,wholewavelengthrange_htmlfile
  printf,3,'<html>'
  printf,3,'<head>'
  printf,3,'<TITLE>Report of test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</TITLE>'
  printf,3,'</head>'
  printf,3,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,3,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,3,'<center>'
  printf,3,'<h1>Report of the STELLA-pipeline test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</h1>'
  printf,3,'<br><br><hr><br>'
  close,1
  openr,1,snrresults_lus
  testsigmas_dl_htmlfile = strarr(maxl-1)
  for i=0UL,maxl-1 do begin
      readf,1,iq
      if i eq 0 then begin
          printf,2,'<center><a href="'+wholewavelengthrange_htmlfile+'">'
          printf,2,'<img src="'+iq+'" alt="SNR of sigma test for the whole wavelengthrange">'
          printf,2,'</a><br><hr><br>'
          printf,2,'<h2>Closer view to wavelengthranges not showing spectral lines</h2><br>'
          printf,2,'<h2>(flux normalized by linear fit)</center><br><br>'
          printf,3,'<center><img src="'+iq+'" alt="SNR of sigma test for the whole wavelengthrange"><br><hr><br></center>'
      end else begin
          testsigmas_dl_htmlfile(i-1) = 'testsigmas_'+strmid(iq,strpos(iq,'_',/REVERSE_SEARCH)+1,strpos(iq,'.',/REVERSE_SEARCH)-strpos(iq,'_',/REVERSE_SEARCH)-1)+'.html'
          printf,2,'<a href="'+testsigmas_dl_htmlfile(i-1)+'">'
          printf,2,'<img src="'+iq+'" alt="SNR of sigma test for the whole wavelengthrange"></a>'
          close,10+i-1
          openw,10+i-1,testsigmas_dl_htmlfile(i-1)
          printf,10+i-1,'<html>'
          printf,10+i-1,'<head>'
          printf,10+i-1,'<TITLE>Report of test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</TITLE>'
          printf,10+i-1,'</head>'
          printf,10+i-1,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
          printf,10+i-1,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
          printf,10+i-1,'<center>'
          printf,10+i-1,'<h1>Report of the STELLA-pipeline test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</h1><br><br>'
          printf,10+i-1,'<h2>wavelengthrange = '+strmid(iq,strpos(iq,'_',/REVERSE_SEARCH)+1,strpos(iq,'.',/REVERSE_SEARCH)-strpos(iq,'_',/REVERSE_SEARCH)-1)+' A</h2>'
          printf,10+i-1,'<br><br><hr><br>'
          printf,10+i-1,'<center><img src="'+iq+'" alt="'+iq+'"></center><br><br><hr><br>'
      end
  endfor
  close,1
  printf,2,'<br><br><hr><br><table><tr>'
  printf,2,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,2,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,2,'</tr></table>'
  printf,2,'</body></html>'
  close,2
  
; --- parameterfile_ylevel
  close,5
  openr,5,parameterfile_lus
  close,6
  openw,6,parameterfile
  printf,6,'<html>'
  printf,6,'<head>'
  printf,6,'<TITLE>Report of test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</TITLE>'
  printf,6,'</head>'
  printf,6,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,6,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,6,'<center>'
  printf,6,'<h1>Master paramterfile for STELLA-pipeline test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</h1>'
  printf,6,'</center>'
  printf,6,'<br><hr><br>'
  for i=0UL,countlines(parameterfile_lus)-1 do begin
      readf,5,iq
      if (strmid(iq,0,9) eq 'extlsigma') or $
         (strmid(iq,0,9) eq 'extusigma') then begin
          printf,6,'<b><font color="#FF0000">'+iq+'</font></b><br>'
      endif else begin
          printf,6,iq+'<br>'
      end
  endfor
  printf,6,'<br><hr><br><table><tr>'
  printf,6,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,6,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,6,'</tr></table>'
  printf,6,'</body></html>'
  close,6
  close,5
  
; pslist_lus
  close,4
  openr,4,pslist_lus
  
  files = strarr(maxn)
  j = 0UL
  for i=0UL,maxn-1 do begin
      readf,4,iq
      files(i) = iq
      if strpos(iq,'_snr') ge 1 then begin
;          root = strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))
          ls = strmid(iq,strpos(iq,'_ls')+3,strpos(iq,'_us')-strpos(iq,'_ls')-3)
          us = strmid(iq,strpos(iq,'_us')+3,strpos(iq,'_',/REVERSE_SEARCH)-strpos(iq,'_us')-3)
          printf,3,'<center><h3>lsigma = '+ls+', usigma = '+us+'</h3></center><br><br>'
          printf,3,'<center>'
          printf,3,'<table><tr><td colspan=3>'
          printf,3,'<a href="testsigmas_ls'+ls+'_us'+us+'.html"><img src="'+strmid(iq,0,strpos(iq,'_',/REVERSE_SEARCH))+'.jpg" alt="'+strmid(iq,0,strpos(iq,'_',/REVERSE_SEARCH))+'.jpg"> <img src="'+strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))+'.jpg" alt="'+strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))+'.jpg"></a><br><br></td></tr>'
; --- logfile
          logfile = strmid(iq,0,strpos(iq,'/')+1)+'logfile_lsigma'+ls
;          tempdouble = double(double(ls)-long(double(ls)))
;          print,'tempdouble from ls = ',tempdouble
;          if tempdouble lt 0.001 then logfile = logfile + '.'
          logfile = logfile + '_usigma' + us
          tempdouble = double(double(us)-long(double(us)))
;          print,'tempdouble from ls = ',tempdouble
          if tempdouble lt 0.001 then logfile = logfile + '.'
          logfile = logfile+'.log'
          loghtmlfile = strmid(logfile,strpos(logfile,'/')+1,strpos(logfile,'.',/REVERSE_SEARCH)-strpos(logfile,'/')-1)
          close,9
          openr,9,logfile
          close,8
          openw,8,loghtmlfile+'.html'
          printf,8,'<html>'
          printf,8,'<head>'
          printf,8,'<TITLE>'+loghtmlfile+'</TITLE>'
          printf,8,'</head>'
          printf,8,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
          printf,8,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
          printf,8,'<center>'
          printf,8,'<h1>logfile</h1>'
          printf,8,'<br><h2>lsigma = '+ls+', usigma = '+us+'</h2>'
          printf,8,'</center><br><hr><br><br>'
          for j=0,countlines(logfile)-1 do begin
              readf,9,jq
              printf,8,jq+'<br>'
          endfor
          printf,8,'<br><hr><br><br><table><tr>'
          printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
          printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
          printf,8,'</tr></table>'
          printf,8,'</body></html>'
          close,9
          close,8
; --- warningfile
          warningfile = strmid(iq,0,strpos(iq,'/')+1)+'warnings_lsigma'+ls
;          tempdouble = double(double(ls)-long(double(ls)))
;          print,'tempdouble from ls = ',tempdouble
;          if tempdouble lt 0.001 then warningfile = warningfile + '.'
          warningfile = warningfile+'_usigma'+us
          tempdouble = double(double(us)-long(double(us)))
;          print,'tempdouble from us = ',tempdouble
          if tempdouble lt 0.001 then warningfile = warningfile + '.'
          warningfile = warningfile+'.log'
          warninghtmlfile = strmid(warningfile,strpos(warningfile,'/')+1,strpos(warningfile,'.',/REVERSE_SEARCH)-strpos(warningfile,'/')-1)
          close,9
          openr,9,warningfile
          close,8
          openw,8,warninghtmlfile+'.html'
          printf,8,'<html>'
          printf,8,'<head>'
          printf,8,'<TITLE>'+warninghtmlfile+'</TITLE>'
          printf,8,'</head>'
          printf,8,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
          printf,8,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
          printf,8,'<center>'
          printf,8,'<h1>warningfile</h1>'
          printf,8,'<br><h2>lsigma = '+ls+', usigma = '+us+'</h2>'
          printf,8,'</center><br><hr><br><br>'
          for j=0,countlines(warningfile)-1 do begin
              readf,9,jq
              printf,8,jq+'<br>'
          endfor
          printf,8,'<br><hr><br><br><table><tr>'
          printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
          printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
          printf,8,'</tr></table>'
          printf,8,'</body></html>'
          close,9
          close,8
; --- errorfile
          errorfile = strmid(iq,0,strpos(iq,'/')+1)+'errors_lsigma'+ls
;          tempdouble = double(double(ls)-long(double(ls)))
;          print,'tempdouble from ls = ',tempdouble
;          if tempdouble lt 0.001 then errorfile = errorfile + '.'
          errorfile = errorfile+'_usigma'+us
          tempdouble = double(double(us)-long(double(us)))
;          print,'tempdouble from us = ',tempdouble
          if tempdouble lt 0.001 then errorfile = errorfile + '.'
          errorfile = errorfile+'.log'
          errorhtmlfile = strmid(errorfile,strpos(errorfile,'/')+1,strpos(errorfile,'.',/REVERSE_SEARCH)-strpos(errorfile,'/')-1)
          close,8
          openw,8,errorhtmlfile+'.html'
          printf,8,'<html>'
          printf,8,'<head>'
          printf,8,'<TITLE>'+errorhtmlfile+'</TITLE>'
          printf,8,'</head>'
          printf,8,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
          printf,8,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
          printf,8,'<center>'
          printf,8,'<h1>errorfile</h1>'
          printf,8,'<br><h2>lsigma = '+ls+', usigma = '+us+'</h2>'
          printf,8,'</center><br><hr><br><br>'
          if countlines(errorfile) gt 0 then begin
              close,9
              openr,9,errorfile
              for j=0,countlines(errorfile)-1 do begin
                  readf,9,jq
                  printf,8,jq+'<br>'
              endfor
              close,9
          endif else begin
              printf,8,'empty'
          end
          printf,3,'<tr><td align="center"><a href="'+loghtmlfile+'.html"><h3>view logfile</h3></a></td>'
          printf,3,'<td align="center"><a href="'+warninghtmlfile+'.html"><h3>view warningfile</h3></a></td>'
          printf,3,'<td align="center"><a href="'+errorhtmlfile+'.html"><h3>view errorfile</h3></a></td></tr></table>'
          printf,3,'</center>'
          printf,8,'<br><hr><br><br><table><tr>'
          printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
          printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
          printf,8,'</tr></table>'
          printf,8,'</body></html>'
          close,8
          printf,3,'<br><hr><br>'
      end
  end
  close,4
  
  for i=0UL,maxn-1 do begin
      root = strmid(files(i),0,strpos(files(i),'.',/REVERSE_SEARCH))
      print,'i = ',i,': root = '+root
      in = root+'001.ppm'
      out = root+'.jpg'
      outsmall = root+'_small.jpg'
      outbig = root+'_big.jpg'
      spawn,'cp '+files(i)+' temp.ps'
      spawn,'pstopnm -xsize 450 -ysize 322 temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+out
      spawn,'pstopnm -xsize 200 -ysize 128 temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+outsmall
      spawn,'pstopnm -xsize 788 -ysize 564 temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+outbig
      j = i mod (nareas+2)
      if (j ge 0) and (j le 12) then begin
          printf,10+j,'<a href="'+outbig+'"><img src="'+out+'" alt="'+out+'"></a>'
      end
  endfor
  printf,3,'<br><br><hr><br><table><tr>'
  printf,3,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,3,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,3,'</tr></table>'
  printf,3,'</body></html>'
  close,3
  for i=0UL,maxl-2 do begin
      printf,10+i,'<br><br><hr><br><table><tr>'
      printf,10+i,'<td><a href="index.html">Back to test startpage</a></td>'
      printf,10+i,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
      printf,10+i,'</tr></table>'
      printf,10+i,'</body></html>'
      close,10+i
  end
  
; --- sigmas_datfile
  sigmas = strarr(nsigmas)
  close,7
  openr,7,sigmas_datfile
  for i=0,nsigmas-1 do begin
      readf,7,iq
      sigmas(i) = iq
  end
  close,7
  
; --- testsigmas_l11-l12.html
  for i=0,nsigmas-1 do begin
      for j=0,nsigmas-1 do begin
          close,30
          if strmid(sigmas(j),strlen(sigmas(j)-1),1) eq '.' then $
            openw,30,'testsigmas_ls'+sigmas(i)+'_us'+strmid(sigmas(j),0,strlen(sigmas(j)-1))+'.html' $
          else $
            openw,30,'testsigmas_ls'+sigmas(i)+'_us'+sigmas(j)+'.html'
          printf,30,'<html>'
          printf,30,'<head>'
          printf,30,'<TITLE>Report of test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</TITLE>'
          printf,30,'</head>'
          printf,30,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
          printf,30,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
          printf,30,'<center>'
          printf,30,'<h1>Master paramterfile for STELLA-pipeline test with different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</h1>'
          printf,30,'</center>'
          printf,30,'<br><hr><br>'
          
          for k=0UL,maxn-1 do begin
              if strpos(files(k),'_snr') ge 1 then begin
                  ls = strmid(files(k),strpos(files(k),'_ls')+3,strpos(files(k),'_us')-strpos(files(k),'_ls')-3)
                  us = strmid(files(k),strpos(files(k),'_us')+3,strpos(files(k),'_',/REVERSE_SEARCH)-strpos(files(k),'_us')-3)
                  if (ls eq sigmas(i)) and (us eq sigmas(j)) then begin
                      printf,30,'<center><h2>lsigma = '+ls+', usigma = '+us+'</h2></center><br>'
                      printf,30,'<center><table><tr><td colspan=3>'
                      printf,30,'<a href="'+strmid(files(k),0,strpos(files(k),'_',/REVERSE_SEARCH))+'_big.jpg"><img src="'+strmid(files(k),0,strpos(files(k),'_',/REVERSE_SEARCH))+'.jpg" alt="'+strmid(files(k),0,strpos(files(k),'_',/REVERSE_SEARCH))+'.jpg"></a>'
                      printf,30,'<a href="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'_big.jpg"><img src="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'.jpg" alt="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'.jpg"></a><br></td></tr>'
                      printf,30,'<tr><td align=center><a href="'+loghtmlfile+'.html"><h3>view logfile</h3></a></td>'
                      printf,30,'<td align=center><a href="'+warninghtmlfile+'.html"><h3>view warningfile</h3></a><br></td>'
                      printf,30,'<td align=center><a href="'+errorhtmlfile+'.html"><h3>view errorfile</h3></a></td></tr></table>'
                      printf,30,'<br><hr><br>'
                  end
              end
          endfor
          for k=0UL,maxn-1 do begin
              if (k mod (nareas+2)) eq i then begin
                  printf,30,'<a href="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'_big.jpg"><img src="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'_small.jpg" alt="'+strmid(files(k),0,strpos(files(k),'.',/REVERSE_SEARCH))+'.jpg"></a>'
              end
          endfor
          printf,30,'</center><br><br><hr><br><table><tr>'
          printf,30,'<td><a href="index.html">Back to test startpage</a></td>'
          printf,30,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
          printf,30,'</tr></table>'
          printf,30,'</body></html>'
          close,30
      end
  end
endelse
end
