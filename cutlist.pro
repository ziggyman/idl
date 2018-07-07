pro cutlist,infile,outfile,xstart,xend

  if n_elements(xend) eq 0 then begin
    print,'cutlist: ERROR: NOT ENOUGH PARAMETERS SPEZIFIED!!!'
    print,'cutlist: USAGE:'
    print,"cutlist,'infile','outfile',xstart,xend"
  end else begin
    lambdastr = ''
    fluxstr   = ''
    lambda = 0.
    flux   = 0.
    nlines = countlines(infile)
    if nlines eq 0 then nlines = 1
    tempstr = ''
    linearr = readfilelinestoarr(infile)
    openr,lunr,infile,/GET_LUN
    openw,lunw,outfile,/GET_LUN
    for i=0UL, nlines-1 do begin
      readf,lunr,lambdastr
;      print,'cutlist: line '+strtrim(string(i),2)+': line = <'+lambdastr+'>'
      lambdastr = strtrim(lambdastr,2)
      fluxstr = strmid(lambdastr,strpos(lambdastr,' ')+1)
      fluxstr = strtrim(fluxstr,2)
      lambdastr = strmid(lambdastr,0,strpos(lambdastr,' '))
      lambdastr = strtrim(lambdastr,2)
;      print,'cutlist: line '+strtrim(string(i),2)+': lambdastr = <'+lambdastr+'>, fluxstr = <'+fluxstr+'>'
      lambda = lambdastr
      if (lambda ge xstart) and (lambda lt xend) then begin
        printf,lunw,lambdastr+' '+fluxstr
      endif
    endfor
    if tempstr ne '' then begin
      printf,lunw,lambdastr+' '+fluxstr
    endif
    free_lun,lunr
    free_lun,lunw
  endelse
end
