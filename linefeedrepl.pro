pro linefeedrepl,infile,outfile

  if n_elements(outfile) eq 0 then begin
    print,'linefeedrepl: ERROR: NOT ENOUGH PARAMETERS SPEZIFIED!!!'
    print,'linefeedrepl: USAGE:'
    print,"linefeedrepl,'infile','outfile'"
  end else begin
    nlines = countlines(infile)
    if nlines eq 0 then nlines = 1
    tempstr = ''
    linearr = readfilelinestoarr(infile)
    openw,lun,outfile,/GET_LUN
    for i=0UL, nlines-1 do begin
      print,'linefeedrepl: linearr('+strtrim(string(i),2)+') = '+linearr(i)+' contains '+strtrim(string(strlen(linearr(i))),2)+' characters'
      for j=0UL, strlen(linearr(i))-2 do begin
          if strmid(linearr(i),j,2) ne '^M' then begin
            tempstr = tempstr + strmid(linearr(i),j,1)
          endif else begin
            printf,lun,tempstr
            tempstr = ''
          endelse
      endfor
      if strmid(linearr(i),strlen(linearr(i))-2,2) ne '^M' then begin
        tempstr = tempstr + strmid(linearr(i),strlen(linearr(i))-1,1)
      endif
    endfor
    if tempstr ne '' then begin
      printf,lun,tempstr
    endif
    free_lun,lun
  endelse

end
