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

;############################
pro write_rvcorrect_input_lists,filelist,imagelist,utcmiddle_hms_list,ra_hms_list,dec_hms_list
    nlines = countlines(filelist)
    ndatlines = countdatlines(filelist)

    filearr = strarr(ndatlines)
    tempstr = ''
    ndats = 0
    openr,lun,filelist,/GET_LUN
    for i=0,ndatlines-1 do begin
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        if strmid(tempstr,0,1) ne '#' then begin
            filearr(ndats) = tempstr
            ndats = ndats + 1
        endif
    endfor
    free_lun,lun

    outfilelist = strmid(filelist,0,strpos(filelist,'.',/REVERSE_SEARCH))+'_to_rvcorrect.list'
    openw,lun,outfilelist,/GET_LUN
    outlist = ''
    for i=0,ndatlines-1 do begin
        outlist = strmid(filearr(i),0,strpos(filearr(i),'.',/REVERSE_SEARCH))+'_to_rvcorrect.dat'
        printf,lun,outlist
        write_rvcorrect_input,imagelist,utcmiddle_hms_list,ra_hms_list,dec_hms_list,filearr(i),outlist
    endfor
    free_lun,lun
end