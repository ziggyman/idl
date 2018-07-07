pro temp

    psfilelist_blue = '/yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_ps.list'
    datafilelist_blue = '/yoda/UVES/MNLupus/ready/blue/equiwidths_RXJ_ctc_data.list'
    npsfiles_blue = countlines(psfilelist_blue)
    tempstr = ''
    tempfile = 'temp.eps'
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
    for i=0, npsfiles_blue-1 do begin
; --- ps files
        tempstr = strmid(psfilearr_blue(i),strpos(psfilearr_blue(i),'/',/REVERSE_SEARCH)+1)
        tempstr = strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'.jpg'
;        printf,lunw,'<a href='+tempstr+'><img src='+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_small.jpg><br>'+tempstr+'</a><br><br>'
; --- data files
        tempstrd = strmid(datafilearr_blue(i),strpos(datafilearr_blue(i),'/',/REVERSE_SEARCH)+1)
;        printf,lunw,'<a href='+tempstrd+'>'+tempstrd+'</a><br><br>'
; --- range files
        rangefilelist = '/yoda/UVES/MNLupus/ready/'+strmid(tempstr,0,strpos(tempstr,'.',/REVERSE_SEARCH))+'_rangefiles.list'
        spawn,'rm rangefilelist'
        xmiddle = strmid(tempstr,strpos(tempstr,'_',/REVERSE_SEARCH)+1,9)
        spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/RXJ1523_UVES.*_'+xmiddle+'.eps > '+rangefilelist
        indexrangefile = '/yoda/UVES/MNLupus/ready/website/equiwidths_calc/index_'+xmiddle+'.html'
        openw,lunrangew,indexrangefile,/GET_LUN
        printf,lunrangew,'<html>'
        printf,lunrangew,'<head>'
        printf,lunrangew,'<TITLE>MNLupus (blue channel): ranges used to calculate equivalent widths</TITLE>'
        printf,lunrangew,'</head>'
        printf,lunrangew,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lunrangew,'<center>'
        printf,lunrangew,'<h1>MNLupus: Normalized ranges used to calculate equivalent widths</h1><br>'
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
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'.jpg'
            spawn,'pstopnm -portrait -xsize 400 -ysize 280 '+tempfile
            spawn,'pnmtojpeg '+tempfile+'001.ppm > /yoda/UVES/MNLupus/ready/website/equiwidths_calc/'+dumstr+'_small.jpg'
            printf,lunrangew,'<a href='+dumstr+'.jpg><img src='+dumstr+'_small.jpg><br>'+dumstr+'.jpg</a>'
        endfor
        free_lun,lunrange
        free_lun,lunrangew
 ;       printf,lunw,'<hr><br>'
    endfor
;    printf,lunw,'</center></body></html>'
;    free_lun,lunw


end
