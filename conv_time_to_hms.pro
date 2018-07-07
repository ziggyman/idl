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
pro conv_time_to_hms,inlist,outlist
;############################
;
; NAME:                  conv_time_to_hms.pro
; PURPOSE:               reads, converts and writes times of input
;                        list to outlist
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      add_1col_lists,'inlist','outlist'
; INPUTS:                input file: 'inlist':
;                          83054.000
;                          899.000
;                          925.000
;                             ...
; OUTPUTS:               output file: 'outlist':
;                          23:04:14.000
;                          00:14:59.000
;                          00:15:25.000
;                             ...
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           20.10.2004
;
    if n_elements(outlist) lt 1 then begin
        print,'conv_time_to_hms: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'conv_time_to_hms: USAGE:'
        print,"  conv_time_to_hms,'inlist','outlist'"
    endif else begin
        nlines = countlines(inlist)
        ndatlines = countdatlines(inlist)
        timearr = dblarr(ndatlines)
        timehmsarr = strarr(ndatlines)
        tempstr = ''
        ndats = 0
; --- read inlist
        openr,lun,inlist,/GET_LUN
        for i=0,nlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                timearr(ndats) = double(tempstr)
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- convert read times to HH:MM:SS.MS
        nhours = 0ul
        nmins = 0ul
        nsecs = 0ul
        temptime = 0.
        openw,lun,outlist,/GET_LUN
        for i=0,ndatlines-1 do begin
            tempstr = ''
            print,'conv_time_to_hms: timearr(',i,') = ',timearr(i)
            nhours = ulong(timearr(i) / 3600)
;            print,'conv_time_to_hms: nhours = ',nhours
            if nhours lt 10 then $
                tempstr = '0'
            tempstr = tempstr+strtrim(string(nhours),2)+':'
            temptime = timearr(i)-(nhours*3600)
            nmins = ulong(temptime / 60.)
;            print,'conv_time_to_hms: nmins = ',nmins
            if nmins lt 10 then $
                tempstr = tempstr+'0'
            tempstr = tempstr+strtrim(string(nmins),2)+":"
            nsecs = ulong(temptime - (nmins * 60.))
;            print,'conv_time_to_hms: nsecs = ',nsecs
            if nsecs lt 10 then $
                tempstr = tempstr + '0'
            tempstr = tempstr+strtrim(string(nsecs),2)
            printf,lun,tempstr
        endfor
        free_lun,lun
    endelse
end
