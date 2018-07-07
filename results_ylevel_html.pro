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
pro results_ylevel_html,obsaplimitlist,pslist_ylevel,parameterfile_ylevel
;############################
;
; NAME:                  results_ylevel_html
; PURPOSE:               documents results of the STELLA-pipeline
;                        tests in a html file
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      results_ylevel_html,'obsaplimit_psfiles.list','ylevel_psfiles.list','parameterfile'
; INPUTS:                input files:
;                         'obsaplimit_psfiles.list':
;                          snrresults_ylevel_obsaplimit+-16.5_files.ps
;                          snrresults_ylevel_obsaplimit+-18.5_files.ps
;                          snrresults_ylevel_obsaplimit+-20.5_files.ps
;
;                         'ylevel_psfiles.list':
;                          obsaplimit+-16.5/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00025_3906.54-3907.26.ps
;                          obsaplimit+-16.5/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00025_4005.61-4010.75.ps
;
;                          obsaplimit+-16.5/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00025_4184.53-4186.18.ps
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
; LAST EDITED:           11.01.2004
;
if n_elements(obsaplimitlist) eq 0 then begin
    obsaplimitlist='obsaplimit_psfiles.list'
    pslist_ylevel='ylevel_psfiles.list'
    parameterfile_ylevel='parameterfile_UVES_blue_437_2148x3000_ylevel0.1.prop'
    pslist_lus='ylevel_psfiles.list'
end
if n_elements(parameterfile_ylevel) eq 0 then begin
  print,'results_ylevel_html: Not enough parameters given, return 0.'
  print,"usage: results_ylevel_html,'obsaplimitlist','pslist_ylevel','paramterfile_ylevel'"
endif else begin   

  iq = ''
  jq = ''
  root = ''
  temproot = ''
  tempobsaplimit = ''
  tempylevel = ''
  in = ''
  out = ''
  outsmall = ''
  explain = ''
  obsaplimit = ''

;countlines
  maxl = countlines(obsaplimitlist)
  maxn = countlines(pslist_ylevel)
  print,'results_ylevel_html: ',maxl,' FILENAMES in ',obsaplimitlist,', ',maxn,' FILENAMES in ',pslist_ylevel

;write index.html
  close,2
  openw,2,'index.html'
  printf,2,'<html>'
  printf,2,'<head>'
  printf,2,'<TITLE>Testreport STELLA pipeline</TITLE>'
  printf,2,'</head>'
  printf,2,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,2,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,2,'<h1>Testreport of the STELLA pipeline</h1>'
  printf,2,'<br><br>'
  printf,2,'<li>'
  printf,2,'<A HREF="testylevels.html">'
  printf,2,'<font size="+2">Test of different ylevels for the extraction task</font>'
  printf,2,'</A>'
  printf,2,'<br><br>'
  printf,2,'<li>'
  printf,2,'<A HREF="testsigmas.html">'
  printf,2,'<font size="+2">Test of different LOWER and UPPER SIGMA REJECTION THRESHOLDs for the extraction task</font>'
  printf,2,'</A>'
  printf,2,'<br><br>'

  printf,2,'</body>'
  printf,2,'</html>'
  close,2

;write testylevels.html
  openw,2,'testylevels.html'
  printf,2,'<html>'
  printf,2,'<head>'
  printf,2,'<TITLE>Report of test with different ylevels for the extraction task</TITLE>'
  printf,2,'</head>'
  printf,2,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,2,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,2,'<center>'
  printf,2,'<h1>Report of the STELLA-pipeline test with different obsaplimits and ylevels for the extraction task</h1>'
  printf,2,'<br><hr><br>'
  printf,2,'<b>The parameter YLEVEL is identical to the IRAF-noao.imred.echelle.apresize.ylevel parameter. It sets the intensity threshold for the RESIZE task to YLEVEL times the maximum of the order profile perpendicular to the dispersion axis. If the so defined size of the resized order in positive / negative direction greater than the paramter OBSAPUPLIMIT / OBSAPLOWMIT (what can happen if the signal is too low), the size in pos. / neg. direction is set to the half of the defined limit.</b><br><br><hr><br>'
  parameterfile = 'parameterfile_testylevel.html'
  printf,2,'<a href="'+parameterfile+'">view parameterfile</a><br>'
  printf,2,'<br><hr><br>'
  printf,2,'<table><tr><td>+</td><td>whole wavelengthrange</td></tr>'
  printf,2,'<tr><td>*</td><td>small wavelengthrange</td></tr></table>'
  printf,2,'<br><hr><br>'

; obsaplimitlist
  close,1
  openr,1,obsaplimitlist
  for i=0UL, maxl-1 do begin
      readf,1,iq
      root = strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))
      in = root+'001.ppm'
      out = root+'.jpg'
      outsmall = root+'_small.jpg'
      outbig = root+'_big.jpg'
; --- build jpg's
      spawn,'cp '+iq+' temp.ps'
      obsaplimit = strmid(iq,strpos(iq,'obsap')+12,strpos(iq,'_',/REVERSE_SEARCH)-strpos(iq,'obsap')-12)
      explain = 'obsaplimit = +/- '+obsaplimit
      spawn,'pstopnm -xsize 600 -ysize 384 temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+out
      spawn,'pstopnm -xsize 200 -ysize 128 temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+outsmall
      spawn,'pstopnm temp.ps'
      spawn,'pnmtojpeg temp001.ppm > '+outbig
      printf,2,'<a href="obsaplimit'+obsaplimit+'.html">'
      printf,2,'<font size="+1">obsaplimit = '+obsaplimit+'</font><br>'
      printf,2,'<img src="'+out+'" alt="'+explain+'">'
      printf,2,'</a><br><hr><br>'
  endfor
  close,1
  printf,2,'</center>'
  printf,2,'<table><tr>'
  printf,2,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,2,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,2,'</tr></table>'
  printf,2,'</body></html>'
  close,2

; parameterfile_ylevel
  close,5
  openr,5,parameterfile_ylevel
  close,6
  openw,6,parameterfile
  printf,6,'<html>'
  printf,6,'<head>'
  printf,6,'<TITLE>Report of test with different ylevels for the extraction task</TITLE>'
  printf,6,'</head>'
  printf,6,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
  printf,6,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
  printf,6,'<center>'
  printf,6,'<h1>Master paramterfile for STELLA-pipeline test with different obsaplimits and ylevels for the extraction task</h1>'
  printf,6,'</center>'
  printf,6,'<br><hr><br>'
  for i=0UL,countlines(parameterfile_ylevel)-1 do begin
      readf,5,iq
      if (strmid(iq,0,9) eq 'extylevel') or $
         (strmid(iq,0,16) eq 'extobsaplowlimit') or $
         (strmid(iq,0,15) eq 'extobsapuplimit') then begin
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

; pslist_ylevel
  close,3
  openr,3,pslist_ylevel
  close,4

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

    obsaplimit = strmid(root,12,strpos(root,'/')-12)
    if (strmid(root,strpos(root,'_',/REVERSE_SEARCH),7) eq '_ylevel') then begin
;   --- comparison file
        ylevel = strmid(root,strpos(root,'ylevel')+6,strlen(root)-strpos(root,'ylevel')-6)
        explain = 'obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel
    end else if(strmid(root,strpos(root,'_',/REVERSE_SEARCH),4) eq '_snr') then begin
;   --- all-wavelenghts file
        ylevel = strmid(root,strpos(root,'ylevel')+6,strpos(root,'_',/REVERSE_SEARCH)-strpos(root,'ylevel')-6)
        explain = 'obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel
    end else begin
;   --- single-wavelength file
        ylevel = strmid(root,strpos(root,'ylevel')+6,strpos(root,'_',/REVERSE_SEARCH)-strpos(root,'ylevel')-6)
        explain = 'obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel+', w = '+strmid(iq,strpos(iq,'_',/REVERSE_SEARCH)+1,strpos(iq,'.',/REVERSE_SEARCH))
    end
    print,'obsaplimit = '+obsaplimit+', ylevel = '+ylevel,', tempobsaplimit = '+obsaplimit+', tempylevel = '+tempylevel

; --- new obsaplimit
    if tempobsaplimit ne obsaplimit then begin
; --- write obsaplimit-html file
        if temproot ne '' then begin
            printf,2,'<table><tr>'
            printf,2,'<td><a href="index.html">Back to test startpage</a></td>'
            printf,2,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
            printf,2,'</tr></table>'
            printf,2,'</body></html>'
        end
        close,2
        openw,2,'obsaplimit'+strtrim(string(obsaplimit),2)+'.html'
        printf,2,'<html>'
        printf,2,'<head>'
        printf,2,'<TITLE>Report of test with different obsaplimits for the extraction task</TITLE>'
        printf,2,'</head>'
        printf,2,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
        printf,2,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
        printf,2,'<center>'
        printf,2,'<h1>obsaplimit = +/- '+strtrim(string(obsaplimit),2)+'</h1>'
        printf,2,'</center>'
        printf,2,'<br><hr><br>'
        tempobsaplimit = obsaplimit
    end
; --- new ylevel
    if tempylevel ne ylevel then begin
;   --- write ylevel?.???.html
        if temproot ne '' then begin
            printf,4,'<table><tr>'
            printf,4,'<td><a href="index.html">Back to test startpage</a></td>'
            printf,4,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
            printf,4,'</tr></table>'
            printf,4,'</body></html>'
        end
        filefour = strmid(iq,0,strpos(iq,'/'))+strmid(iq,strpos(iq,'_ylevel'),strpos(iq,'_',/REVERSE_SEARCH)-strpos(iq,'_ylevel'))+'.html'
        print,'filefour = '+filefour
        close,4
        openw,4,filefour
        printf,4,'<html>'
        printf,4,'<head>'
        printf,4,'<TITLE>'+strmid(explain,0,strpos(explain,',',/REVERSE_SEARCH))+'</TITLE>'
        printf,4,'</head>'
        printf,4,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96"'
        printf,4,'background="STELLA-pipeline_blockdiagramm_englisch_small_trans.gif" bgcolor="#000000">'
        printf,4,'<center>'
        printf,4,'<h1>Report of STELLA-pipeline test with different ylevels for the extraction task</h1>'
        printf,4,'<br><h2>'+strmid(explain,0,strpos(explain,',',/REVERSE_SEARCH))+'</h2>'
        printf,4,'</center>'
        printf,4,'<br><hr><br>'
        printf,2,'<center><a href="'+filefour+'"><h2>Extraction-task ylevel for OBJECT files: '+ylevel+'</h2></a></center>'
        printf,2,'<a href="'+filefour+'">'
; --- logfile
        logfile = strmid(root,0,strpos(root,'/')+1)+'logfile_ylevel'+ylevel+'.log'
        loghtmlfile = strmid(logfile,strpos(logfile,'/')+1,strpos(logfile,'.',/REVERSE_SEARCH)-strpos(logfile,'/')-1)
        printf,4,'<a href="'+loghtmlfile+'.html"><h3>view logfile</h3></a><br>'
        close,7
        openr,7,logfile
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
        printf,8,'<br><h2>obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel+'</h2>'
        printf,8,'</center><br><hr><br><br>'
        for j=0,countlines(logfile)-1 do begin
            readf,7,jq
            printf,8,jq+'<br>'
        endfor
        printf,8,'<br><hr><br><br><table><tr>'
        printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
        printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
        printf,8,'</tr></table>'
        printf,8,'</body></html>'
        close,7
        close,8
; --- warningfile
        warningfile = strmid(root,0,strpos(root,'/')+1)+'warnings_ylevel'+ylevel+'.log'
        warninghtmlfile = strmid(warningfile,strpos(warningfile,'/')+1,strpos(warningfile,'.',/REVERSE_SEARCH)-strpos(warningfile,'/')-1)
        printf,4,'<a href="'+warninghtmlfile+'.html"><h3>view warningfile</h3></a><br>'
        close,7
        openr,7,warningfile
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
        printf,8,'<br><h2>obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel+'</h2>'
        printf,8,'</center><br><hr><br><br>'
        for j=0,countlines(warningfile)-1 do begin
            readf,7,jq
            printf,8,jq+'<br>'
        endfor
        printf,8,'<br><hr><br><br><table><tr>'
        printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
        printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
        printf,8,'</tr></table>'
        printf,8,'</body></html>'
        close,7
        close,8
; --- errorfile
        errorfile = strmid(root,0,strpos(root,'/')+1)+'errors_ylevel'+ylevel+'.log'
        errorhtmlfile = strmid(errorfile,strpos(errorfile,'/')+1,strpos(errorfile,'.',/REVERSE_SEARCH)-strpos(errorfile,'/')-1)
        printf,4,'<a href="'+errorhtmlfile+'.html"><h3>view errorfile</h3></a><br>'
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
        printf,8,'<br><h2>obsaplimit = +/- '+obsaplimit+', ylevel = '+ylevel+'</h2>'
        printf,8,'</center><br><hr><br><br>'
        if countlines(errorfile) gt 0 then begin
            close,7
            openr,7,errorfile
            for j=0,countlines(errorfile)-1 do begin
                readf,7,jq
                printf,8,jq+'<br>'
            endfor
            close,7
        endif else begin
            printf,8,'empty'
        end
        printf,8,'<br><hr><br><br><table><tr>'
        printf,8,'<td><a href="index.html">Back to test startpage</a></td>'
        printf,8,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
        printf,8,'</tr></table>'
        printf,8,'</body></html>'
        close,8
        printf,4,'<br><hr><br>'
    end

; --- write links and pics
    if (strmid(root,strpos(root,'_',/REVERSE_SEARCH),7) eq '_ylevel') then begin
;   --- comparison file
        printf,2,'<br><center><img src="'+out+'" alt="'+explain+'">'
        printf,4,'<br><hr><br><br><center><a href="'+outbig+'"><img src="'+out+'" alt="'+explain+'"></a></center><br><hr><br>'
    end else if(strmid(root,strpos(root,'_',/REVERSE_SEARCH),4) eq '_snr') then begin
;   --- all-wavelenghts file
        printf,2,'<img src="'+out+'" alt="'+explain+'">'
        printf,2,'</a></center><br><hr><br>'
    end else begin
;   --- single-wavelength file
        printf,4,'<a href="'+outbig+'"><img src="'+outsmall+'" alt="'+explain+'"></a>'
    end
    temproot = strmid(root,0,strlen(root)-15) ;
    tempylevel = ylevel
    tempobsaplimit = obsaplimit
  end
  printf,4,'<table><tr>'
  printf,4,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,4,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,4,'</tr></table>'
  printf,4,'</body></html>'
  close,3
  close,4
  printf,2,'<table><tr>'
  printf,2,'<td><a href="index.html">Back to test startpage</a></td>'
  printf,2,'<td><a href="http://www.aip.de/people/aritter/index.html">Azuri'+"'s homepage"+'</a></td>'
  printf,2,'</tr></table>'
  printf,2,'</body></html>'
  close,2

endelse
end
