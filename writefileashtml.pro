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

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;###########################
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;###########################
function readfilelinestoarr,filename
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILELINESTOARR: No file specified, return dumarr'
  endif else begin
    nlines   = countlines(filename)
    dataarr  = strarr(nlines)
    templine = ''
    openr,lun,filename,/get_lun
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine)
      dataarr(i) = templine
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;###########################
function readfiletoarr,filename
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILETOARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    dataarr = strarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
        dataarr(irun,idat) = templine
        irun = irun + 1
      end
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;###########################
function readfiletodblarr,filename
;###########################

  dumarr = dblarr(1)
  dumarr(0) = 0.
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILETODBLARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    dataarr = dblarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
        dataarr(irun,idat) = templine
        irun = irun + 1
      endif
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;############################
pro writefileashtml,textfile,htmlfile,title
;############################
;
; NAME:                  writefileashtml.pro
; PURPOSE:               writes text file <textfile> as html file <htmlfile>
;                        with title <title>
;
; CATEGORY:              documentation
; CALLING SEQUENCE:      writefileashtml,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2_mean_rms.data','/yoda/UVES/MNLupus/ready/website/vhelio/ranges/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2_mean_rms.html','Mean and rms for the heliocentric radial velocities'
; INPUTS:                input file: textfile ('</yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2_mean_rms.data>'):
;                          night 1:       16 images
;                          vobs:
;                            mean = 8.2614676 km/s
;                            rms  = 1.6048895 km/s
;                          vrel:
;                                    ...
;                          (OUTPUT-file of 'fxcor_out_trim(_mean_rms).pro')
;                        input: <title>: String
; OUTPUTS:               output file: '<htmlfile>'
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           29.12.2004
;
    if n_elements(title) eq 0 then begin
        print,'writefileashtml: ERROR: Not enough parameters specified!'
        print,"writefileashtml: USAGE: writefileashtml,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2_mean_rms.data','/yoda/UVES/MNLupus/ready/website/vhelio/ranges/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2_mean_rms.html','Mean and rms for the heliocentric radial velocities'"
    endif else begin
        path = strmid(htmlfile,0,strpos(htmlfile,'/',/REVERSE_SEARCH)+1)
        spawn,'cp whitespace.gif '+path
        nlines = countlines(textfile)
        linearr = readfilelinestoarr(textfile)

        openw,lun,htmlfile,/GET_LUN
        printf,lun,'<html>'
        printf,lun,'<head>'
        printf,lun,'<TITLE>'+title+'</TITLE>'
        printf,lun,'</head>'
        printf,lun,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
        printf,lun,'<br><center>'
        printf,lun,'<h1>'+title+'</h1></center><br><hr><br><h3>'
        for i=0UL, nlines - 1 do begin
            tempstr = ''
            for j=0UL, strlen(linearr(i))-1 do begin
                if strmid(linearr(i),j,1) eq ' ' then begin
                    tempstr = tempstr+'<img src=whitespace.gif>'
                endif else begin
                    tempstr = tempstr+strmid(linearr(i),j,1)
                endelse
            endfor
            printf,lun,tempstr+'<br>'
        endfor
        printf,lun,'</h3></body>'
        printf,lun,'</html>'
        free_lun,lun

    endelse
end
