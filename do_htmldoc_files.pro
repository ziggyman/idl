pro do_htmldoc_files
; --- delete old files

    homepath = '/yoda/UVES/MNLupus/ready/website/files'

    spawn,'rm -rf '+homepath+'/'
    spawn,'mkdir '+homepath

; --- write file lists
    fits_filelist_blue = '/yoda/UVES/MNLupus/ready/reduced_fits_files_blue.list'
    text_filelist_blue = '/yoda/UVES/MNLupus/ready/reduced_text_files_blue.list'
    fits_filelist_red_r = '/yoda/UVES/MNLupus/ready/reduced_fits_files_red_r.list'
    text_filelist_red_r = '/yoda/UVES/MNLupus/ready/reduced_text_files_red_r.list'
    fits_filelist_red_l = '/yoda/UVES/MNLupus/ready/reduced_fits_files_red_l.list'
    text_filelist_red_l = '/yoda/UVES/MNLupus/ready/reduced_text_files_red_l.list'

    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/*ctc.fits > '+fits_filelist_blue
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/*ctc.text > '+text_filelist_blue
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/*ctc.fits > '+fits_filelist_red_r
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/*ctc.text > '+text_filelist_red_r
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/*ctc.fits > '+fits_filelist_red_l
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/*ctc.text > '+text_filelist_red_l

; --- write index.html
    openw,lun,homepath+'/index.html',/GET_LUN
    printf,lun,'<html>'
    printf,lun,'<head>'
    printf,lun,'<TITLE>MNLupus - Reduced spectra</TITLE>'
    printf,lun,'</head>'
    printf,lun,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lun,'<center><br>'
    printf,lun,'<h1>MNLupus: Reduced spectra</h1><br><hr><br>'
    printf,lun,'<h3>Legend</h3><br>'
    printf,lun,'<table>'
    printf,lun,'<tr><td>b</td><td>...bad pixel corrected</td></tr>'
    printf,lun,'<tr><td>o</td><td>...overscan subtracted</td></tr>'
    printf,lun,'<tr><td>t</td><td>...trimmed</td></tr>'
    printf,lun,'<tr><td>z</td><td>...zero subtracted</td></tr>'
    printf,lun,'<tr><td>f</td><td>...flattened</td></tr>'
    printf,lun,'<tr><td>s</td><td>...scattered light subtracted</td></tr>'
    printf,lun,'<tr><td>x</td><td>...cosmics removed</td></tr>'
    printf,lun,'<tr><td>ec</td><td>...extracted</td></tr>'
    printf,lun,'<tr><td>d</td><td>...dispersion corrected</td></tr>'
    printf,lun,'<tr><td>c</td><td>...continuum set</td></tr>'
    printf,lun,'<tr><td>t</td><td>...trimmed</td></tr>'
    printf,lun,'<tr><td>c</td><td>...orders merged</td></tr>'
    printf,lun,'</table><br><hr><br>'
; --- read file lists
; --- blue channel
    printf,lun,'<h2>Blue channel (3290-4512 Angstroem)</h2><br><br>'
    tempstr = ''
    nffiles = countlines(fits_filelist_blue)
    ntfiles = countlines(text_filelist_blue)
    if nffiles ne ntfiles then begin
        print,'do_htmldoc_files: ERROR: nfitsfiles(=',nffiles,') NOT EQUAL TO ntextfiles(=',ntfiles,') -> omitting blue channel'
    end else begin
        openr,lunf,fits_filelist_blue,/GET_LUN
        openr,lunt,text_filelist_blue,/GET_LUN
        for i=0UL, nffiles-1 do begin
            readf,lunf,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br>'
            readf,lunt,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
        endfor
        free_lun,lunf
        free_lun,lunt
    endelse
; --- red channel, right chips
    printf,lun,'<hr><br><h2>Red channel, right chip (4780-5745 Angstroem)</h2><br><br>'
    tempstr = ''
    nffiles = countlines(fits_filelist_red_r)
    ntfiles = countlines(text_filelist_red_r)
    if nffiles ne ntfiles then begin
        print,'do_htmldoc_files: ERROR: nfitsfiles(=',nffiles,') NOT EQUAL TO ntextfiles(=',ntfiles,') -> omitting red channel, right chip'
    end else begin
        openr,lunf,fits_filelist_red_r,/GET_LUN
        openr,lunt,text_filelist_red_r,/GET_LUN
        for i=0UL, nffiles-1 do begin
            readf,lunf,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br>'
            readf,lunt,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
        endfor
        free_lun,lunf
        free_lun,lunt
    endelse
; --- red channel, right chips
    printf,lun,'<hr><br><h2>Red channel, left chip (5830-6810 Angstroem)</h2><br><br>'
    tempstr = ''
    nffiles = countlines(fits_filelist_red_l)
    ntfiles = countlines(text_filelist_red_l)
    if nffiles ne ntfiles then begin
        print,'do_htmldoc_files: ERROR: nfitsfiles(=',nffiles,') NOT EQUAL TO ntextfiles(=',ntfiles,') -> omitting red channel, left chip'
    end else begin
        openr,lunf,fits_filelist_red_l,/GET_LUN
        openr,lunt,text_filelist_red_l,/GET_LUN
        for i=0UL, nffiles-1 do begin
            readf,lunf,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br>'
            readf,lunt,tempstr
            tempstr = strtrim(tempstr,2)
            spawn,'cp '+tempstr+' '+homepath+'/'
            printf,lun,'<a href="'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'">'+strmid(tempstr,strpos(tempstr,'/',/REVERSE_SEARCH)+1)+'</a><br><br>'
        endfor
        free_lun,lunf
        free_lun,lunt
    endelse
    printf,lun,'</body></html>'
    free_lun,lun


end
