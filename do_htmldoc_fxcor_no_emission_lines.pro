;###########################
function strrep,s,sso,ssn
;###########################

c=0L
if n_params() ne 3 then print,'STRREP: Not enough string parameters specified, return 0.' $
else begin
  result = ''
  i = 0
  j = 1
  while (j eq 1) do begin
    if i le strlen(s)-1 then begin
      if strmid(s,i,strlen(sso)) eq sso then begin
        result = result + ssn
        i = i + strlen(sso)
      endif else begin
        result = result + strmid(s,i,1)
        i = i + 1
      endelse
    endif else begin
      j = 0
    end
  end
end
return,result
end

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
pro do_htmldoc_fxcor_no_emission_lines
;############################################

; --- do_fxcor_RXJ_plot_both_red_chips
    do_fxcor_RXJ_plot_both_red_chips

; --- prepare images
    finalimage = '/yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission_vhelio_mean+rms_offset_set'
    finaljpg = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(finalimage,strpos(finalimage,'/',/REVERSE_SEARCH)+1)

    refhdimage = '/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2'
    refhdjpg = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(refhdimage,strpos(refhdimage,'/',/REVERSE_SEARCH)+1)

    bothchipsimage = '/yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission_vhelio'
    bothchipsjpg   = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges'+strmid(bothchipsimage,strpos(bothchipsimage,'/',/REVERSE_SEARCH))

; --- fxcor_out_trim
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_red_r_ref1_no_emission_????-????_*-_trimmed.dat'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_red_l_ref1_no_emission_????-????_*-_trimmed.dat'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_red_r_ref1_no_emission_????-????_*-_trimmed_vhelio.ps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_red_l_ref1_no_emission_????-????_*-_trimmed_vhelio.ps'
    datalist = strmid(bothchipsimage,0,strpos(bothchipsimage,'_',/REVERSE_SEARCH))+'.list'
    spawn,'rm '+datalist
    fxcor_out_trim_list_no_emission
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_red_l_ref1_no_emission_????-????_*-_trimmed.dat > '+datalist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_red_r_ref1_no_emission_????-????_*-_trimmed.dat >> '+datalist
    fxcor_out_RXJ_plot_red,datalist,'print'
    fxcor_RXJ_offset,bothchipsimage+'_mean+rms.data',refhdimage+'.data','print'

; --- write datafiles as htmlfiles
    refhddatafile = refhdimage+'_mean_rms.data'
    refhdhtmlfile = refhdjpg+'_mean_rms.html'
    print,'do_htmldoc_fxcor_no_emission_lines: refhddatafile = '+refhddatafile+', refhdhtmlfile ? '+refhdhtmlfile
    writefileashtml,refhddatafile,refhdhtmlfile,strmid(refhddatafile,strpos(refhddatafile,'/',/REVERSE_SEARCH)+1)
    bothdatafile = bothchipsimage+'_mean+rms.data'
    bothhtmlfile = bothchipsjpg+'_mean_rms.html'
    print,'do_htmldoc_fxcor_no_emission_lines: bothdatafile = '+bothdatafile+', bothhtmlfile ? '+bothhtmlfile
    writefileashtml,bothdatafile,bothhtmlfile,strmid(bothdatafile,strpos(bothdatafile,'/',/REVERSE_SEARCH)+1)
    finaldatafile = finalimage+'_mean_rms.data'
    finalhtmlfile = finaljpg+'_mean_rms.html'
    print,'do_htmldoc_fxcor_no_emission_lines: finaldatafile = '+finaldatafile+', finalhtmlfile ? '+finalhtmlfile
    writefileashtml,finaldatafile,finalhtmlfile,strmid(finaldatafile,strpos(finaldatafile,'/',/REVERSE_SEARCH)+1)

    tempfile = 'temp.eps'
; --- finalimage
    spawn,'cp '+finalimage+'.eps '+tempfile
    spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+finaljpg+'.jpg'
    spawn,'pstopnm -portrait -xsize 600 -ysize 420 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+finaljpg+'_small.jpg'
; --- refhdimage
    spawn,'cp '+refhdimage+'.eps '+tempfile
    spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+refhdjpg+'.jpg'
    spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+refhdjpg+'_small.jpg'
; --- both chips
    spawn,'cp '+bothchipsimage+'.eps '+tempfile
    spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'.jpg'
    spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'_small.jpg'
; --- red_r
    spawn,'cp '+bothchipsimage+'_r.eps '+tempfile
    spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'_r.jpg'
    spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'_r_small.jpg'
; --- red_l
    spawn,'cp '+bothchipsimage+'_l.eps '+tempfile
    spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'_l.jpg'
    spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
    spawn,'pnmtojpeg '+tempfile+'001.ppm > '+bothchipsjpg+'_l_small.jpg'

; --- red_r
    psfilelist_r = '/yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_no_emission_lines.list'
    spawn,'rm '+psfilelist_r
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_red_r_ref1_no_emission_????-????_*_80_80_75._3._-2.-_trimmed_vhelio.ps > '+psfilelist_r
    npsfiles_r = countlines(psfilelist_r)
    print,'do_htmldoc_fxcor_no_emission_lines: npsfiles_r = '+strtrim(string(npsfiles_r),2)
    psfilearr_r = strarr(npsfiles_r)
    openr,lunr,psfilelist_r,/GET_LUN
    jpegarr_r = strarr(npsfiles_r)
    jpegsmallarr_r = strarr(npsfiles_r)
    tempstr = ''
    for i=0,npsfiles_r-1 do begin
        readf,lunr,tempstr
        psfilearr_r(i) = strtrim(tempstr,2)
        print,'do_htmldoc_fxcor_no_emission_lines: psfilearr_r('+strtrim(string(i),2)+') = '+psfilearr_r(i)
        spawn,'cp '+psfilearr_r(i)+' temp.eps'
        spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
        jpegarr_r(i) = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(psfilearr_r(i),strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)+1)
        jpegarr_r(i) = strmid(jpegarr_r(i),0,strpos(jpegarr_r(i),'.',/REVERSE_SEARCH))+'.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegarr_r(i)
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        jpegsmallarr_r(i) = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(psfilearr_r(i),strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)+1)
        jpegsmallarr_r(i) = strmid(jpegsmallarr_r(i),0,strpos(jpegsmallarr_r(i),'.',/REVERSE_SEARCH))+'_small.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegsmallarr_r(i)
    endfor
    free_lun,lunr

; --- red_l
    psfilelist_l = '/yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_no_emission_lines.list'
    spawn,'rm '+psfilelist_l
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_red_l_ref1_no_emission_????-????_*_80_80_75._3._-2.-_trimmed_vhelio.ps > '+psfilelist_l
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
        jpegarr_l(i) = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(psfilearr_l(i),strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)+1)
        jpegarr_l(i) = strmid(jpegarr_l(i),0,strpos(jpegarr_l(i),'.',/REVERSE_SEARCH))+'.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegarr_l(i)
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        jpegsmallarr_l(i) = '/yoda/UVES/MNLupus/ready/website/vhelio/ranges/'+strmid(psfilearr_l(i),strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)+1)
        jpegsmallarr_l(i) = strmid(jpegsmallarr_l(i),0,strpos(jpegsmallarr_l(i),'.',/REVERSE_SEARCH))+'_small.jpg'
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+jpegsmallarr_l(i)
    endfor
    free_lun,lunr

; --- index.html
    openw,lun,'/yoda/UVES/MNLupus/ready/website/vhelio/ranges/index.html',/GET_LUN
    printf,lun,'<html>'
    printf,lun,'<head>'
    printf,lun,'<TITLE>MNLupus - Heliocentric radial velocities for the regions without emission lines</TITLE>'
    printf,lun,'</head>'
    printf,lun,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lun,'<center><br>'
    printf,lun,'<h1>MNLupus: Heliocentric radial velocities for the regions without emission lines</h1><br><hr><br>'
    printf,lun,'<h2>The heliocentric radial velocities shown here have calculated in quite a complicate way... All cross correlations have been done using the IRAF task "noao.rv.fxcor". First the most large regions without emission features together have been cross correlated with HD 209290 as reference spectrum (for the result of this have a look at the following picture).</h2><br>'
    printf,lun,'<a href='+strmid(refhdjpg,strpos(refhdjpg,'/',/REVERSE_SEARCH)+1)+'.jpg><img src='+strmid(refhdjpg,strpos(refhdjpg,'/',/REVERSE_SEARCH)+1)+'_small.jpg><br>'
    printf,lun,'Result of the cross correlation of the largest regions without emission lines (taken as one sample) with HD 209290. The error bars show the errors given by the IRAF task "noao.rv.fxcor".</a><br>'
    printf,lun,'<a href='+strmid(refhdhtmlfile,strpos(refhdhtmlfile,'/',/REVERSE_SEARCH)+1)+'>Datafile containing mean and rms</a><br>'
    printf,lun,'<h2>This gives quite large error bars, because of the large width of the fitting gauss function and the changing of the line profiles during the observation block.'
    printf,lun,'Because of this all single regions without emission lines have been cross correlated one by one with the fitting regions of the first image as reference.'
    printf,lun,'These results are shown in the next image:</h2><br>'
    printf,lun,'<a href='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'.jpg><img src='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'_small.jpg><br>This image shows the single values of all measurements taken in both chips of the red channel, and the mean and rms (error bars) of these values for every exposure.</a><br>'
    printf,lun,'<a href='+strmid(bothhtmlfile,strpos(bothhtmlfile,'/',/REVERSE_SEARCH)+1)+'>Datafile containing mean and rms</a><br>'
    printf,lun,'<h2>Then the mean and rms of these results are built, following by a comparison of the resulting mean value to the mean of the vhelios from the cross correlation with HD 209290.'
    printf,lun,'The difference of these mean values is added to the mean values resulting from the single regions cross correlation (first image as reference).<h2><br>'
    printf,lun,'<a href='+strmid(finaljpg,strpos(finaljpg,'/',/REVERSE_SEARCH)+1)+'.jpg><img src='+strmid(finaljpg,strpos(finaljpg,'/',/REVERSE_SEARCH)+1)+'_small.jpg><br>Final result of the cross correlation of all single regions not containing emission features. The mean of these values is the same as the mean of the vhelios resulting from the cross correlation with HD 209290. The error bars show the standard deviation of the results from the different single regions.</a><br>'
    printf,lun,'<a href='+strmid(finalhtmlfile,strpos(finalhtmlfile,'/',/REVERSE_SEARCH)+1)+'>Data file containing mean and rms</a><br>'
    printf,lun,'<br><hr><br><h2>These radial velocities have been measured using the first image of the first night as zero reference:</h2><br>'
    printf,lun,'<a href=../all_ranges/index_red_r.html><h3>Measured heliocentric radial velocities over hjd (red channel, right chip (4780-5745 Angstroem))</h3></a><br><br>'
    printf,lun,'<a href=../all_ranges/index_red_l.html><h3>Measured heliocentric radial velocities over hjd (red channel, left chip (5830-6810 Angstroem))</h3></a><br>'
    printf,lun,'<br><hr><br><h2>These radial velocities have been take to calculate the mean and rms of the single results:</h2><br>'
    printf,lun,'<a href=index_red_r.html><h3>Measured heliocentric radial velocities over hjd (red channel, right chip (4780-5745 Angstroem))</h3></a><br><br>'
    printf,lun,'<a href=index_red_l.html><h3>Measured heliocentric radial velocities over hjd (red channel, left chip (5830-6810 Angstroem))</h3></a><br><br>'
    printf,lun,'</body></html>'
    free_lun,lun

; --- red_r
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/vhelio/ranges/index_red_r.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus (red channel, right chip): heliocentric radial velocities</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: heliocentric radial velocities for the ranges without emission lines with respect to first spectrum</h1><br>'
    printf,lunw,'<h2>Red channel, right chip (4780-5745 Angstroem)</h2><br><br><hr><br>'
    printf,lun,'<a href='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'_r.jpg><img src='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'_r_small.jpg><br>This image shows the single values of all measurements taken in the right chip of the red channel, and the mean and rms of these values for every exposure.<br><br><hr><br>'
    printf,lunw,'<h2>Observed radial velocities over hjd for every cross correlation range</h2><br>'
    for i=0, npsfiles_r-1 do begin
        range = strmid(jpegarr_r(i),strpos(jpegarr_r(i),'no_emission_')+12,9)+' Angstroem'
        printf,lunw,'Cross correlation range: '+range+'<br>'
        printf,lunw,'<a href='+strmid(jpegarr_r(i),strpos(jpegarr_r(i),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(i),strpos(jpegsmallarr_r(i),'/',/REVERSE_SEARCH)+1)+'><br>'+strmid(jpegarr_r(i),strpos(jpegarr_r(i),'/',/REVERSE_SEARCH)+1)+'</a><br><br><hr><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

; --- red_l
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/vhelio/ranges/index_red_l.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus (red channel, right chip): heliocentric radial velocities</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: heliocentric radial velocities for the ranges without emission lines with respect to first spectrum</h1><br>'
    printf,lunw,'<h2>Red channel, left chip (5830-6810 Angstroem)</h2><br><br><hr><br>'
    printf,lun,'<a href='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'_l.jpg><img src='+strmid(bothchipsjpg,strpos(bothchipsjpg,'/',/REVERSE_SEARCH)+1)+'_l_small.jpg><br>This image shows the single values of all measurements taken in the left chip of the red channel, and the mean and rms of these values for every exposure.<br><br><hr><br>'
    printf,lunw,'<h2>Observed radial velocities over hjd for every cross correlation range</h2><br>'
    for i=0, npsfiles_l-1 do begin
        range = strmid(jpegarr_l(i),strpos(jpegarr_l(i),'no_emission_')+12,9)+' Angstroem'
        printf,lunw,'Cross correlation range: '+range+'<br>'
        printf,lunw,'<a href='+strmid(jpegarr_l(i),strpos(jpegarr_l(i),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(i),strpos(jpegsmallarr_l(i),'/',/REVERSE_SEARCH)+1)+'><br>'+strmid(jpegarr_l(i),strpos(jpegarr_l(i),'/',/REVERSE_SEARCH)+1)+'</a><br><br><hr><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw


end
