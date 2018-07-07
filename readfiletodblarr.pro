;###########################
function readfiletodblarr,filename
;###########################

  dumarr = dblarr(1)
  dumarr(0) = 0.
  if n_params() ne 1 then begin
    print,'READFILETODBLARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    print,'readfiletodblarr: filename = <'+filename+'>: nlines = ',nlines,', ndatalines = ', ndatalines,', ncols = ',ncols
    if ncols lt 1 then begin
      print,'readfiletodblarr: filename = <'+filename+'>: nlines = ',nlines,', ndatalines = ', ndatalines,', ncols = ',ncols,' < 1 => returning 0.'
      return,dumarr
    end
    dataarr = dblarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0ul, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
        dataarr(irun,idat) = double(templine)
        irun = irun + 1
      end
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end
