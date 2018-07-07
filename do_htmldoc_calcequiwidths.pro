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
pro do_htmldoc_calcequiwidths
;############################################

; --- delete old output dir
    spawn,'rm -rf /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/equiwidths_calc'

; --- delete old files
    spawn,'rm -f /yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_????.??00.*'
    spawn,'rm -f /yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_????.??00.*'
    spawn,'rm -f /yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_????.??00.*'

; --- calculate equivalent widths
    calcequiwidths_RXJ,'/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.text.list','/yoda/UVES/MNLupus/ready/blue/all_emission_lines_to_calc_equiwidth_blue.dat','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
    do_calcequiwidths_RXJ

; --- create file lists
    psfilelist = '/yoda/UVES/MNLupus/ready/equiwidths_RXJ_ctc_ps.list'
    datafilelist = '/yoda/UVES/MNLupus/ready/equiwidths_RXJ_ctc_data.list'
    psfilelist_blue = '/yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_ps.list'
    datafilelist_blue = '/yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_data.list'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_????.??00.ps > '+psfilelist_blue
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_????.??00.data > '+datafilelist_blue
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_????.??00.ps > '+psfilelist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_????.??00.data > '+datafilelist
    psfilelist_l = '/yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_ps.list'
    datafilelist_l = '/yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_data.list'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_????.??00.ps > '+psfilelist_l
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_????.??00.data > '+datafilelist_l
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_????.??00.ps >> '+psfilelist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/equiwidths_RXJ_ctc_????.??00.data >> '+datafilelist
    psfilelist_r = '/yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_ps.list'
    datafilelist_r = '/yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_data.list'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_????.??00.ps > '+psfilelist_r
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_????.??00.data > '+datafilelist_r
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_????.??00.ps >> '+psfilelist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/equiwidths_RXJ_ctc_????.??00.data >> '+datafilelist

; --- build jpg's
    npsfiles = countlines(psfilelist)
    tempstr = ''
    tempdstr = ''
    dumstr = ''
    openr,lun,psfilelist,/GET_LUN
    openr,lund,datafilelist,/GET_LUN
    tempfile = 'temp.eps'
    for i=0, npsfiles-1 do begin
; --- ps files
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        spawn,'cp '+tempstr+' '+tempfile
        spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
        dumstr = strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
        dumstr = strmid(dumstr,0,strpos(dumstr,'.',/REVERSE_SEARCH))
        spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'.jpg'
        spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
        spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'_small.jpg'

; --- data files
        readf,lund,tempstr
	tempstr = strtrim(tempstr,2)
        newfile = '/yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
        spawn,'cp '+tempstr+' '+newfile
    endfor
    free_lun,lun
    free_lun,lund

; --- write index.html file
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus - measured equivalent widths of the emission lines</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: Measured equivalent widths of the emission features</h1><br>'
    printf,lunw,'For the emission features the equivalent widths of the emission features have been determined by setting the continuum (borders of the features to 1) and then calculating the equivalent width out of the spectra (without fitting any function to the emission feature). This has been done using self written IDL procedures.<br><br>'
    printf,lunw,'<a href=index_blue.html>Blue chip (3290-4512 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_red_r.html>Red chip, right channel (4780-5745 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_red_l.html>Red chip, left channel (5830-6810 Angstroem)</a><br><br><hr><br>'
    printf,lunw,'</body></html>'
    free_lun,lunw

; --- read psfilelist_blue
    npsfiles_blue = countlines(psfilelist_blue)
    psfilearr_blue = strarr(npsfiles_blue)
    datafilearr_blue = strarr(npsfiles_blue)
    openr,lun,psfilelist_blue,/GET_LUN
    openr,lund,datafilelist_blue,/GET_LUN
    for i=0,npsfiles_blue-1 do begin
; --- ps files
        readf,lun,tempstr
        psfilearr_blue(i) = strtrim(tempstr,2)
; --- data files
        readf,lund,tempstr
        datafilearr_blue(i) = strtrim(tempstr,2)
    endfor
    free_lun,lun
    free_lun,lund

; --- write index_blue.html
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_blue.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus (blue channel): measured equivalent widths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: Measured equivalent widths for the emission lines</h1><br>'
    printf,lunw,'<h2>Blue channel (3290-4512 Angstroem)</h2><br><br><hr><br>'
;    printf,lunw,'<a href='+strmid(jpegarr_blue(0),strpos(jpegarr_blue(0),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_blue(0),strpos(jpegsmallarr_blue(0),'/',/REVERSE_SEARCH)+1)+'><br>Mean and stddev of observed radial velocity over hjd</a><br><br><hr><br>'
;    printf,lunw,'<h2>Measured equivalent widths over hjd for every emission feature</h2><br>'
    for i=0, npsfiles_blue-1 do begin
; --- ps files
        tempstr = strmid(psfilearr_blue(i),strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)+1)
        tempstr = strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'.jpg'
        printf,lunw,'<a href='+tempstr+'><img src='+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_small.jpg><br>'+tempstr+'</a><br><br>'
; --- data files
        tempstrd = strmid(datafilearr_blue(i),strpos(datafilearr_blue(i),'/',/REVERSE_SEARCH)+1)
        printf,lunw,'<a href='+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html>'+tempstrd+'</a><br><br>'
        ndatafilelines = countlines(datafilearr_blue(i))
	openr,lund,datafilearr_blue(i),/GET_LUN
        openw,lundw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html',/GET_LUN
        printf,lundw,'<html>'
        printf,lundw,'<head>'
        printf,lundw,'<TITLE>MNLupus (blue channel): measured equivalent widths</TITLE>'
        printf,lundw,'</head>'
        printf,lundw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lundw,'<center><h1>'+tempstrd+':</h1></center><br><br><hr><br>'
        for j=0,ndatafilelines-1 do begin
            readf,lund,tempdstr
;            tempdstr = strtrim(tempdstr,2)
            printf,lundw,tempdstr+'<br>
        endfor
        free_lun,lundw
        free_lun,lund
; --- range files
        rangefilelist = '/yoda/UVES/MNLupus/ready/'+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_rangefiles.list'
        spawn,'rm rangefilelist'
        xmiddle = strmid(tempstr,strpos(tempstr,'_',/REVERSE_SEARCH)+1,9)
        spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/RXJ1523_UVES.*_'+xmiddle+'.eps > '+rangefilelist
        indexrangefile = '/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_'+xmiddle+'.html'
        printf,lunw,'<a href=index_'+xmiddle+'.html>Images of normalized ranges used to calculate equivalent widths</a><br>'
        openw,lunrangew,indexrangefile,/GET_LUN
        printf,lunrangew,'<html>'
        printf,lunrangew,'<head>'
        printf,lunrangew,'<TITLE>MNLupus (blue channel): ranges used to calculate equivalent widths</TITLE>'
        printf,lunrangew,'</head>'
        printf,lunrangew,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lunrangew,'<center>'
        printf,lunrangew,'<h1>MNLupus: Normalized ranges used to calculate equivalent widths</h1><br>'
        printf,lunrangew,'<h2>Blue channel: (3290-4512 Angstroem)</h2><br><br><hr><br>'
        printf,lunrangew,'<h2>Range: ('+xmiddle+' Angstroem)</h2><br><br><hr><br>'

        nrangefiles = countlines(rangefilelist)
;        rangefilearr = strarr(nrangefiles)
        openr,lunrange,rangefilelist,/GET_LUN
        for j=0, nrangefiles-1 do begin
            readf,lunrange,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+tempfile
            spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
            dumstr = strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
            dumstr = strmid(dumstr,0,strpos(dumstr,'.',/REVERSE_SEARCH))
            dumstr = strrep(dumstr,':','-')
            print,'do_htmldoc_calcequiwidths: dumstr = '+dumstr
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'.jpg'
            spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'_small.jpg'
            printf,lunrangew,'<a href='+dumstr+'.jpg><img src='+dumstr+'_small.jpg><br>'+dumstr+'.jpg</a><br><br><hr><br>'
        endfor
        free_lun,lunrange
        free_lun,lunrangew
        printf,lunw,'<hr><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

; --- read psfilelist_red_r
    npsfiles_r = countlines(psfilelist_r)
    psfilearr_r = strarr(npsfiles_r)
    datafilearr_r = strarr(npsfiles_r)
    openr,lun,psfilelist_r,/GET_LUN
    openr,lund,datafilelist_r,/GET_LUN
    for i=0,npsfiles_r-1 do begin
; --- ps files
        readf,lun,tempstr
        psfilearr_r(i) = strtrim(tempstr,2)
; --- data files
        readf,lund,tempstr
        datafilearr_r(i) = strtrim(tempstr,2)
    endfor
    free_lun,lun
    free_lun,lund

; --- write index_red_r.html
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_red_r.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus (red channel, right chip): measured equivalent widths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: Measured equivalent widths for the emission lines</h1><br>'
    printf,lunw,'<h2>Red channel, right chip (4780-5745 Angstroem)</h2><br><br><hr><br>'
;    printf,lunw,'<a href='+strmid(jpegarr_r(0),strpos(jpegarr_r(0),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_r(0),strpos(jpegsmallarr_r(0),'/',/REVERSE_SEARCH)+1)+'><br>Mean and stddev of observed radial velocity over hjd</a><br><br><hr><br>'
;    printf,lunw,'<h2>Measured equivalent widths over hjd for every emission feature</h2><br>'
    for i=0, npsfiles_r-1 do begin
; --- ps files
        tempstr = strmid(psfilearr_r(i),strpos(psfilearr_r(i),'/',/REVERSE_SEARCH)+1)
        tempstr = strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'.jpg'
        printf,lunw,'<a href='+tempstr+'><img src='+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_small.jpg><br>'+tempstr+'</a><br><br>'
; --- data files
        tempstrd = strmid(datafilearr_r(i),strpos(datafilearr_r(i),'/',/REVERSE_SEARCH)+1)
        printf,lunw,'<a href='+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html>'+tempstrd+'</a><br><br>'
        ndatafilelines = countlines(datafilearr_r(i))
	openr,lund,datafilearr_r(i),/GET_LUN
        openw,lundw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html',/GET_LUN
        printf,lundw,'<html>'
        printf,lundw,'<head>'
        printf,lundw,'<TITLE>MNLupus (red channel, right chip): measured equivalent widths</TITLE>'
        printf,lundw,'</head>'
        printf,lundw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lundw,'<center><h1>'+tempstrd+':</h1></center><br><br><hr><br>'
        for j=0,ndatafilelines-1 do begin
            readf,lund,tempdstr
;            tempdstr = strtrim(tempdstr,2)
            printf,lundw,tempdstr+'<br>
        endfor
        free_lun,lundw
        free_lun,lund
; --- range files
        rangefilelist = '/yoda/UVES/MNLupus/ready/'+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_rangefiles.list'
        spawn,'rm rangefilelist'
        xmiddle = strmid(tempstr,strpos(tempstr,'_',/REVERSE_SEARCH)+1,9)
        spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/RXJ1523_r_UVES.*_'+xmiddle+'.eps > '+rangefilelist
        indexrangefile = '/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_'+xmiddle+'.html'
        printf,lunw,'<a href=index_'+xmiddle+'.html>Images of normalized ranges used to calculate equivalent widths</a><br>'
        openw,lunrangew,indexrangefile,/GET_LUN
        printf,lunrangew,'<html>'
        printf,lunrangew,'<head>'
        printf,lunrangew,'<TITLE>MNLupus (red channel, right chip): ranges used to calculate equivalent widths</TITLE>'
        printf,lunrangew,'</head>'
        printf,lunrangew,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lunrangew,'<center>'
        printf,lunrangew,'<h1>MNLupus: Normalized ranges used to calculate equivalent widths</h1><br>'
        printf,lunrangew,'<h2>Red channel, right chip (4780-5745 Angstroem)</h2><br><br><hr><br>'
        printf,lunrangew,'<h2>Range: ('+xmiddle+' Angstroem)</h2><br><br><hr><br>'

        nrangefiles = countlines(rangefilelist)
;        rangefilearr = strarr(nrangefiles)
        openr,lunrange,rangefilelist,/GET_LUN
        for j=0, nrangefiles-1 do begin
            readf,lunrange,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+tempfile
            spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
            dumstr = strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
            dumstr = strmid(dumstr,0,strpos(dumstr,'.',/REVERSE_SEARCH))
            dumstr = strrep(dumstr,':','-')
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'.jpg'
            spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'_small.jpg'
            printf,lunrangew,'<a href='+dumstr+'.jpg><img src='+dumstr+'_small.jpg><br>'+dumstr+'.jpg</a><br><br><hr><br>'
        endfor
        free_lun,lunrange
        free_lun,lunrangew
        printf,lunw,'<hr><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

; --- read psfilelist_red_l
    npsfiles_l = countlines(psfilelist_l)
    psfilearr_l = strarr(npsfiles_l)
    datafilearr_l = strarr(npsfiles_l)
    openr,lun,psfilelist_l,/GET_LUN
    openr,lund,datafilelist_l,/GET_LUN
    for i=0,npsfiles_l-1 do begin
; --- ps files
        readf,lun,tempstr
        psfilearr_l(i) = strtrim(tempstr,2)
; --- data files
        readf,lund,tempstr
        datafilearr_l(i) = strtrim(tempstr,2)
    endfor
    free_lun,lun
    free_lun,lund

; --- write index_red_l.html
    openw,lunw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_red_l.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus (red channel, left chip): measured equivalent widths</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: Measured equivalent widths for the emission lines</h1><br>'
    printf,lunw,'<h2>Red channel, left chip (5830-6810 Angstroem)</h2><br><br><hr><br>'
;    printf,lunw,'<a href='+strmid(jpegarr_l(0),strpos(jpegarr_l(0),'/',/REVERSE_SEARCH)+1)+'><img src='+strmid(jpegsmallarr_l(0),strpos(jpegsmallarr_l(0),'/',/REVERSE_SEARCH)+1)+'><br>Mean and stddev of observed radial velocity over hjd</a><br><br><hr><br>'
;    printf,lunw,'<h2>Measured equivalent widths over hjd for every emission feature</h2><br>'
    for i=0, npsfiles_l-1 do begin
; --- ps files
        tempstr = strmid(psfilearr_l(i),strpos(psfilearr_l(i),'/',/REVERSE_SEARCH)+1)
        tempstr = strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'.jpg'
        printf,lunw,'<a href='+tempstr+'><img src='+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_small.jpg><br>'+tempstr+'</a><br><br>'
; --- data files
        tempstrd = strmid(datafilearr_l(i),strpos(datafilearr_l(i),'/',/REVERSE_SEARCH)+1)
        printf,lunw,'<a href='+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html>'+tempstrd+'</a><br><br>'
        ndatafilelines = countlines(datafilearr_l(i))
	openr,lund,datafilearr_l(i),/GET_LUN
        openw,lundw,'/yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+strmid(tempstrd,0,strpos(tempstrd,'.',/REVERSE_SEARCH))+'.html',/GET_LUN
        printf,lundw,'<html>'
        printf,lundw,'<head>'
        printf,lundw,'<TITLE>MNLupus (red channel, left chip): measured equivalent widths</TITLE>'
        printf,lundw,'</head>'
        printf,lundw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lundw,'<center><h1>'+tempstrd+':</h1></center><br><br><hr><br>'
        for j=0,ndatafilelines-1 do begin
            readf,lund,tempdstr
;            tempdstr = strtrim(tempdstr,2)
            printf,lundw,tempdstr+'<br>
        endfor
        free_lun,lundw
        free_lun,lund
; --- range files
        rangefilelist = '/yoda/UVES/MNLupus/ready/'+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_rangefiles.list'
        spawn,'rm rangefilelist'
        xmiddle = strmid(tempstr,strpos(tempstr,'_',/REVERSE_SEARCH)+1,9)
        spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/RXJ1523_l_UVES.*_'+xmiddle+'.eps > '+rangefilelist
        indexrangefile = '/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_'+xmiddle+'.html'
        printf,lunw,'<a href=index_'+xmiddle+'.html>Images of normalized ranges used to calculate equivalent widths</a><br>'
        openw,lunrangew,indexrangefile,/GET_LUN
        printf,lunrangew,'<html>'
        printf,lunrangew,'<head>'
        printf,lunrangew,'<TITLE>MNLupus (red channel, left chip): ranges used to calculate equivalent widths</TITLE>'
        printf,lunrangew,'</head>'
        printf,lunrangew,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lunrangew,'<center>'
        printf,lunrangew,'<h1>MNLupus: Normalized ranges used to calculate equivalent widths</h1><br>'
        printf,lunrangew,'<h2>Red channel, left chip (5830-6810 Angstroem)</h2><br><br><hr><br>'
        printf,lunrangew,'<h2>Range: ('+xmiddle+' Angstroem)</h2><br><br><hr><br>'

        nrangefiles = countlines(rangefilelist)
;        rangefilearr = strarr(nrangefiles)
        openr,lunrange,rangefilelist,/GET_LUN
        for j=0, nrangefiles-1 do begin
            readf,lunrange,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+tempfile
            spawn,'pstopnm -portrait -xsize 1200 -ysize 840 '+tempfile
            dumstr = strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
            dumstr = strmid(dumstr,0,strpos(dumstr,'.',/REVERSE_SEARCH))
            dumstr = strrep(dumstr,':','-')
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'.jpg'
            spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'_small.jpg'
            printf,lunrangew,'<a href='+dumstr+'.jpg><img src='+dumstr+'_small.jpg><br>'+dumstr+'.jpg</a><br><br><hr><br>'
        endfor
        free_lun,lunrange
        free_lun,lunrangew
        printf,lunw,'<hr><br>'
    endfor
    printf,lunw,'</center></body></html>'
    free_lun,lunw

end
