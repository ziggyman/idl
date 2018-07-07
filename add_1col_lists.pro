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
pro add_1col_lists,lista,listb,outlist
;############################
;
; NAME:                  add_1col_lists.pro
; PURPOSE:               reads values of both input lists and writes sum of first
;                        value and half second value to outlist
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      add_1col_lists,'lista','listb','outlist'
; INPUTS:                input file: 'lista':
;                           582339.95
;                           653644.70
;                             ...
;                        input file: 'listb':
;                           1000.2321
;                           3000.0324
;                             ...
; OUTPUTS:               output file: 'outlist':
;                           592423.1821
;                           686235.9341
;                             ...
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           20.10.2004
;
    if n_elements(outlist) lt 1 then begin
        print,'add_1col_lists: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'add_1col_lists: USAGE:'
        print,"  add_1col_lists,'lista','listb','outlist'"
    endif else begin
        nlinesa = countlines(lista)
        ndatlinesa = countdatlines(lista)
        nlinesb = countlines(listb)
        ndatlinesb = countdatlines(listb)
        if ndatlinesa ne ndatlinesb then begin
            print,'add_1col_lists: ndatlines of lista NOT EQUAL to ndatlinesb of listb -> returning!!!'
        end else begin
            valuearra = dblarr(ndatlinesa)
            valuearrb = dblarr(ndatlinesa)
            tempstr = ''

; --- read lista
            openr,lun,lista,/GET_LUN
            ndats = 0
            for i=0,nlinesa-1 do begin
                readf,lun,tempstr
                tempstr = strtrim(tempstr,2)
                if strmid(tempstr,0,1) ne '#' then begin
                    valuearra(ndats) = double(tempstr)
                    print,'add_1col_lists: valuearra(',ndats,') = ',valuearra(ndats)
                    ndats = ndats+1
                endif
            end
            free_lun,lun

; --- read listb
            openr,lun,listb,/GET_LUN
            ndats = 0
            for i=0,nlinesb-1 do begin
                readf,lun,tempstr
                tempstr = strtrim(tempstr,2)
                if strmid(tempstr,0,1) ne '#' then begin
                    valuearrb(ndats) = double(tempstr)
                    print,'add_1col_lists: valuearrb(',ndats,') = ',valuearrb(ndats)
                    ndats = ndats+1
                endif
            end
            free_lun,lun
        
; --- add values and write outlist
            openw,lun,outlist,/GET_LUN
            tempdbl = 0.
            for i=0,ndatlinesa-1 do begin
                tempdbl = valuearra(i)+(valuearrb(i)/2.)
                printf,lun,tempdbl,FORMAT='(F12.4)'
            endfor
            free_lun,lun
        endelse
    endelse
end
