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

;############################
pro recalc_aps,apfile_old,apfile_edited,naps,apfile_new
;############################
;
; NAME:                  recalc_thars
; PURPOSE:               recalculates the IRAF-ecThAr file for different binnings
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      recalc_thars,<string 'apfile_old'>,<string 'ecfile_edited'>,<int naps>,<string 'apfile_new'>
; INPUTS:                input file: 'aprefFlat_SES_1074x1026':
;                                            .
;                                            .
;                                            .
;                        int naps: number of apertures to recalculate
;                                        1 - recalculates emission feature positions from not-binned to binned
; OUTPUTS:               file ''
;                                            .
;                                            .
;                                            .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.11.2005
;

if n_elements(apfile_new) eq 0 then begin
  print,'recalcaps : No file specified, return 0.'
  print,'usage     : recalc_aps,apfile_old,apfile_edited,naps,apfile_new'
endif else begin

;logfile
  close,1
  openw,1,'logfile_recalc_aps'

;countlines
  maxn = countlines(apfile_old)
  print,apfile_old,': ',maxn,' DATA LINES'
  printf,1,apfile_old,': ',maxn,' DATA LINES'
  maxm = countlines(apfile_edited)
  print,apfile_edited,   ': ',maxm,' DATA LINES'
  printf,1,apfile_edited,': ',maxm,' DATA LINES'

;build arrays
  apold        = strarr(maxn)
  apedited     = strarr(maxm)
  tempstr      = ''
  newaps       = 1
  filename_old = strmid(apfile_old,2,strlen(apfile_old)-2)
  printf,1,'filename_old = '+filename_old
  filename_new = strmid(apfile_new,2,strlen(apfile_new)-2)
  printf,1,'filename_new = '+filename_new
  newline      = ''

;read files in arrays
  close,2
  openr,2,apfile_old
  for i=0,maxn-2 do begin
    readf,2,tempstr
    tempstr = strtrim(tempstr,2)
;    printf,1,'recalc_aps: tempstr='+tempstr
    apold(i) = tempstr
  endfor
  close,2
  openr,2,apfile_edited
  for i=0,maxm-2 do begin
    readf,2,tempstr
    tempstr = strtrim(tempstr,2)
;    printf,1,'recalc_aps: tempstr='+tempstr
    apedited(i) = tempstr
  endfor
  close,2

;recalc apertures
  openw,2,apfile_new
  for i=0,naps-1 do begin
    for j=0,19 do begin
      printf,2,apedited(j+(i*27))
      printf,1,'apedited('+string(j+(i*27))+') = '+apedited(j+(i*27))
    endfor
    for j=20,23 do begin
      printf,2,apold(j+(i*29))
      printf,1,'apold('+string(j+(i*29))+') = '+apold(j+(i*29))
    endfor
    printf,2,apedited(24+(i*27))
    printf,1,'apedited('+string(24+(i*27))+') = '+apedited(24+(i*27))
    for j=25,28 do begin
      printf,2,apold(j+(i*29))
      printf,1,'apold('+string(j+(i*29))+') = '+apold(j+(i*29))
    endfor
  endfor

;close logfile
  close,/all
endelse
end
