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

;############################################
pro do_htmldoc_plot_equiwidths_and_airmass
;############################################

; ### ALL EMISSION LINES
; --- blue
    plot_equiwidths_and_airmass_over_hjd,'/yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out.dat','/yoda/UVES/MNLupus/ready/blue/airmasses.dat','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
    
    psfilelist_blue = '/yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_equiwidth_over_hjd_eps-files.list'
    npsfiles_blue = countlines(psfilelist_blue)
    psfilearr_blue = strarr(npsfiles_blue)
    openr,lunr,psfilelist_blue,/GET_LUN
    tempstr = ''
    jpegarr_blue = strarr(npsfiles_blue)
    jpegsmallarr_blue = strarr(npsfiles_blue)
    tempfile = 'temp.eps'
    for i=0,npsfiles_blue-1 do begin
        readf,lunr,tempstr
        psfilearr_blue(i) = strtrim(tempstr,2)
        spawn,'cp '+psfilearr_blue(i)+' temp.eps'
        spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
        jpegarr_blue(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_blue(i),strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_blue(i))-strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)-5)+'.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegarr_blue(i)
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        jpegsmallarr_blue(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_blue(i),strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_blue(i))-strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)-5)+'_small.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegsmallarr_blue(i)
    endfor
    free_lun,lunr

; --- red_r
    plot_equiwidths_and_airmass_over_hjd,'/yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out.dat','/yoda/UVES/MNLupus/ready/red_l/airmasses.dat','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    
    psfilelist_r = '/yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_equiwidth_over_hjd_eps-files.list'
    npsfiles_r = countlines(psfilelist_r)
    psfilearr_r = strarr(npsfiles_r)
    openr,lunr,psfilelist_r,/GET_LUN
    jpegarr_r = strarr(npsfiles_r)
    jpegsmallarr_r = strarr(npsfiles_r)
    for i=0,npsfiles_r-1 do begin
        readf,lunr,tempstr
        psfilearr_r(i) = strtrim(tempstr,2)
        spawn,'cp '+psfilearr_r(i)+' temp.eps'
        spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
        jpegarr_r(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_r(i),strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_r(i))-strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)-5)+'.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegarr_r(i)
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        jpegsmallarr_r(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_r(i),strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_r(i))-strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)-5)+'_small.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegsmallarr_r(i)
    endfor
    free_lun,lunr

; --- red_l
    plot_equiwidths_and_airmass_over_hjd,'/yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out.dat','/yoda/UVES/MNLupus/ready/red_l/airmasses.dat','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    
    psfilelist_l = '/yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_equiwidth_over_hjd_eps-files.list'
    npsfiles_l = countlines(psfilelist_l)
    psfilearr_l = strarr(npsfiles_l)
    openr,lunr,psfilelist_l,/GET_LUN
    jpegarr_l = strarr(npsfiles_l)
    jpegsmallarr_l = strarr(npsfiles_l)
    for i=0,npsfiles_l-1 do begin
        readf,lunr,tempstr
        psfilearr_l(i) = strtrim(tempstr,2)
        spawn,'cp '+psfilearr_l(i)+' temp.eps'
        spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
        jpegarr_l(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_l(i),strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_l(i))-strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)-5)+'.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegarr_l(i)
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        jpegsmallarr_l(i) = '/yoda/UVES/MNLupus/ready/website/equiwidths/'+strmid(psfilearr_l(i),strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)+1,strlen(psfilearr_l(i))-strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)-5)+'_small.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegsmallarr_l(i)
    endfor
    free_lun,lunr
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths/index.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus Equiwidths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>Equivalent widths of the emission features for MNLupus</h1><br>'
    printf,lunw,'<h3>The equivalent widths have been automatically measured using the IRAF task "onedspec.fitprofs". The measurements have been done once for every emission feature, giving the task the limits of each feature.</h3>'
    printf,lunw,'<a href=index_blue.html>Blue channel (3290-4512 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_red_r.html>Red channel, right chip (4780-5745 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_red_l.html>Red channel, left chip (5830-6810 Angstroem)</a><br><br>'
    printf,lunw,'</body></html>'
    free_lun,lunw

; --- blue
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths/index_blue.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus Equiwidths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>Measured equivalent widths and image-header airmasses for MNLupus</h1><br>'
    printf,lunw,'<h2>Blue channel (3290-4512 Angstroem)</h2><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_blue(npsfiles_blue-1),strpos(jpegarr_blue(npsfiles_blue-1),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_blue(npsfiles_blue-1),strpos(jpegsmallarr_blue(npsfiles_blue-1),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over airmass</a><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_blue(npsfiles_blue-2),strpos(jpegarr_blue(npsfiles_blue-2),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_blue(npsfiles_blue-2),strpos(jpegsmallarr_blue(npsfiles_blue-2),'/',/REVERSE_SEARCH)+1)+'><br>Mean of airmasses at start and end of observation over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd</h2><br>'
    printf,lunw,'<a href='+strmid(jpegarr_blue(npsfiles_blue-3),strpos(jpegarr_blue(npsfiles_blue-3),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_blue(npsfiles_blue-3),strpos(jpegsmallarr_blue(npsfiles_blue-3),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd for every feature</h2><br>'
    for i=0, npsfiles_blue-4 do begin
        printf,lunw,'<a href='+strmid(jpegarr_blue(i),strpos(jpegarr_blue(i),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_blue(i),strpos(jpegsmallarr_blue(i),'/',/REVERSE_SEARCH)+1)+'><br>'+strmid(jpegarr_blue(i),strpos(jpegarr_blue(i),'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

; --- red_r
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths/index_red_r.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus Equiwidths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>Measured equivalent widths and image-header airmasses for MNLupus</h1><br>'
    printf,lunw,'<h2>red channel, right chip (4780-5745 Angstroem)</h2><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_r(npsfiles_r-1),strpos(jpegarr_r(npsfiles_r-1),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(npsfiles_r-1),strpos(jpegsmallarr_r(npsfiles_r-1),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over airmass</a><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_r(npsfiles_r-2),strpos(jpegarr_r(npsfiles_r-2),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(npsfiles_r-2),strpos(jpegsmallarr_r(npsfiles_r-2),'/',/REVERSE_SEARCH)+1)+'><br>Mean of airmasses at start and end of observation over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd</h2><br>'
    printf,lunw,'<a href='+strmid(jpegarr_r(npsfiles_r-3),strpos(jpegarr_r(npsfiles_r-3),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(npsfiles_r-3),strpos(jpegsmallarr_r(npsfiles_r-3),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd for every feature</h2><br>'
    for i=0, npsfiles_r-4 do begin
        printf,lunw,'<a href='+strmid(jpegarr_r(i),strpos(jpegarr_r(i),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(i),strpos(jpegsmallarr_r(i),'/',/REVERSE_SEARCH)+1)+'><br>'+strmid(jpegarr_r(i),strpos(jpegarr_r(i),'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

; --- red_l
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths/index_red_l.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus Equiwidths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>Measured equivalent widths and image-header airmasses for MNLupus</h1><br>'
    printf,lunw,'<h2>red channel, left chip (5830-6810 Angstroem)</h2><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_l(npsfiles_l-1),strpos(jpegarr_l(npsfiles_l-1),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(npsfiles_l-1),strpos(jpegsmallarr_l(npsfiles_l-1),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over airmass</a><br><br><hr><br>'
    printf,lunw,'<a href='+strmid(jpegarr_l(npsfiles_l-2),strpos(jpegarr_l(npsfiles_l-2),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(npsfiles_l-2),strpos(jpegsmallarr_l(npsfiles_l-2),'/',/REVERSE_SEARCH)+1)+'><br>Mean of airmasses at start and end of observation over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd</h2><br>'
    printf,lunw,'<a href='+strmid(jpegarr_l(npsfiles_l-3),strpos(jpegarr_l(npsfiles_l-3),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(npsfiles_l-3),strpos(jpegsmallarr_l(npsfiles_l-3),'/',/REVERSE_SEARCH)+1)+'><br>Mean of measured equivalent widths over hjd</a><br><br><hr><br>'
    printf,lunw,'<h2>Measured equivalent widths over hjd for every feature</h2><br>'
    for i=0, npsfiles_l-4 do begin
        printf,lunw,'<a href='+strmid(jpegarr_l(i),strpos(jpegarr_l(i),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(i),strpos(jpegsmallarr_l(i),'/',/REVERSE_SEARCH)+1)+'><br>'+strmid(jpegarr_l(i),strpos(jpegarr_l(i),'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw
end
