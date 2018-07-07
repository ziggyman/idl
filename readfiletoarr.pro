;###########################
function readfiletoarr,filename
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'READFILETOARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    print,'readfiletoarr: nlines = ',nlines
    print,'readfiletoarr: ndatalines = ',ndatalines
    print,'readfiletoarr: ncols = ',ncols
    dataarr = strarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
;        print,'readfiletoarr: idat = ',idat
        dataarr(irun,idat) = templine
        irun = irun + 1
      end
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end
