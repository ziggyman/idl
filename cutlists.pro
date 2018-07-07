pro cutlists,inlist,outlist,xstart,xend

  if n_elements(xend) eq 0 then begin
    print,'cutlists: ERROR: NOT ENOUGH PARAMETERS SPEZIFIED!!!'
    print,'cutlists: USAGE:'
    print,"cutlists,'inlist','outlist',xstart,xend"
  end else begin
    nlines = countlines(inlist)
    if nlines eq 0 then nlines = 1
    tempstr = ''
    infilesarr = readfilelinestoarr(inlist)
    outfilesarr = readfilelinestoarr(outlist)
    for i=0UL, nlines-1 do begin
      cutlist,infilesarr(i),outfilesarr(i),xstart,xend
    endfor
  endelse

end
