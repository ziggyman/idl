pro do_htmldoc_I_res_lambda
; --- delete old files
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/I_res_lambda_*.ps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/I_res_lambda_*.ps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/I_res_lambda_*.ps'

    I_res_lambda_RXJ

; --- write file lists
    pslist = '/yoda/UVES/MNLupus/ready/I_res_lambda_psfiles.list'

    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/I_res_lambda_*.ps > '+pslist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/I_res_lambda_*.ps > '+pslist
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/I_res_lambda_*.ps > '+pslist

; --- write index.html
    openw,lun,'/yoda/UVES/MNLupus/ready/website/i_res_lambda/index.html',/GET_LUN
    printf,lun,'<html>'
    printf,lun,'<head>'
    printf,lun,'<TITLE>MNLupus - Grey scale plots</TITLE>'
    printf,lun,'</head>'
    printf,lun,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lun,'<center><br>'
    printf,lun,'<h1>MNLupus: Grey scale plots</h1><br><hr><br>'
; --- read psfile
    openr,lunp,pslist,/GET_LUN
    tempstr = ''
    tempfile = 'temp.eps'
    npsfiles = countlines(pslist)
    for i=0UL, npsfiles-1 do begin
        readf,lunp,tempstr
        tempstr = strtrim(tempstr,2)
        tempjpg = '/yoda/UVES/MNLupus/ready/website/i_res_lambda/'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)
        tempjpg = strmid(tempjpg,0,strpos(tempjpg,'.',/REVERSE_SEARCH))
        spawn,'cp '+tempstr+' '+tempfile
        spawn,'pstopnm -portrait -xsize 1200 -ysize 2000 '+tempfile
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+tempjpg+'.jpg'
        spawn,'pstopnm -portrait -xsize 600 -ysize 1000 '+tempfile
        spawn,'pnmtojpeg '+tempfile+'001.ppm > '+tempjpg+'_small.jpg'
        printf,lun,'<hr><br><a href="'+strmid(tempjpg,strpos(tempjpg,'/',/REVERSE_SEARCH)+1)+'.jpg"><img src="'+strmid(tempjpg,strpos(tempjpg,'/',/REVERSE_SEARCH)+1)+'_small.jpg"><br>'+strmid(tempjpg,strpos(tempjpg,'/',/REVERSE_SEARCH)+1)+'.jpg</a><br>'
    endfor
    free_lun,lunp
    printf,lun,'</body></html>'
    free_lun,lun


end
