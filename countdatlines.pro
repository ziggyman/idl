;###########################
function countdatlines,s,NHEADERLINES=nheaderlines
;###########################

c=0uL
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = ulong(0)
  nheaderlines = ulong(0)
  nlines = countlines(s)
  if not file_test(s) then $
    return,0
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0UL,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif else begin
    nheaderlines = nheaderlines + 1
    end
  endfor
  tempstr = 0
  free_lun,lun
end
return,c
end
