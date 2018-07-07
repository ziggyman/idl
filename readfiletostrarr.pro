;###########################
function readfiletostrarr,filename,$
                          delimiter,$
                          I_NLINES     = i_nlines,$
                          I_NDATALINES = i_ndatalines,$
                          I_NCOLS      = i_ncols,$
                          DEBUG        = debug,$
                          HEADER       = header
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 2 then begin
    print,'READFILETOSTRARR: Not enough parameters specified, return dumarr'
    print,'Calling seqence: readfiletostrarr,(string)filename,(string)delimiter'
  endif else begin
    i_nlines     = countlines(filename)
    print,'readfiletostrarr: ',filename,': i_nlines = ',i_nlines
    if i_nlines eq 0 then begin
      print,'readfiletostrarr: i_nlines = ',i_nlines,' == 0 -> returning 0'
      return,0
    end
    nheaderlines = 1
    i_ndatalines = countdatlines(filename,NHEADERLINES=nheaderlines)
    if nheaderlines gt 0 then $
      header = strarr(nheaderlines)
    i_ncols      = countcols(filename,DELIMITER=delimiter)
    print,'readfiletostrarr: i_ndatalines = ',i_ndatalines,', i_ncols = ',i_ncols
    dataarr = strarr(i_ndatalines,i_ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    iheaderlines = 0ul
    for i=0UL, i_nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if (strmid(templine,0,1) ne '#') and (templine ne '') then begin
        idat = 0UL
        while (strpos(templine,delimiter) ge 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,delimiter))
          if keyword_set(DEBUG) then $
            print,'readfiletostrarr: dataarr(irun=',irun,',idat=',idat,') = ',dataarr(irun,idat)
          templine = strtrim(strmid(templine,strpos(templine,delimiter)+1),2)
          if keyword_set(DEBUG) then $
            print,'readfiletostrarr: templine = ',templine
          idat = idat + 1
        end
        dataarr(irun,idat) = templine
        irun = irun + 1
      end else begin
        if (strmid(templine,0,1) eq '#') then begin
          header(iheaderlines) = templine
          iheaderlines = iheaderlines + 1
        endif
      end
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end
