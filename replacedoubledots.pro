pro replacedoubledots,file

  if n_elements(file) eq 0 then begin
    print,'replacedoubledots: no filename specified! Return 0.'
    print,"replacedoubledots: USAGE: replacedoubledots,'file_to_replace_double_dots'"
  endif else begin
    newfile = strmid(file,0,strpos(file,'/',/REVERSE_SEARCH)+1)
    file = strmid(file,strpos(file,'/',/REVERSE_SEARCH)+1)
    for i=0UL, strlen(file)-1 do begin
      if strmid(file,i,1) ne ':' then begin
        newfile = newfile + strmid(file,i,1)
      endif else begin
        newfile = newfile + '-'
      endelse
    endfor
    spawn,'mv '+file+' '+newfile
  endelse
end
