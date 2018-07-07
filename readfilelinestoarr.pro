;###########################
function readfilelinestoarr,filename,STR_DONT_READ=str_dont_read,NLINES=nlines
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILELINESTOARR: No file specified, return dumarr'
  endif else begin
    nlines  = countlines(filename)
    print,'readfilelinestoarr: filename = '+filename+', nlines = ',nlines
    if nlines eq 0 then nlines = 1
    dataarr = strarr(nlines)
    templine = ''
    openr,lun,filename,/get_lun
    j = 0ul
    for i=0UL, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if keyword_set(STR_DONT_READ) then begin
        if strmid(templine,0,strlen(str_dont_read)) ne str_dont_read then begin
          dataarr(j) = templine
          j = j+1
        endif
      end else begin
        dataarr(j) = templine
        j = j+1
      end
    endfor
    free_lun,lun
    return,dataarr(0:j-1)
  end
  return,dumarr
end
