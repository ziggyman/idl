pro reverse_lines,infile,outfile
  strarr_lines = readfilelinestoarr(infile)
  if n_elements(strarr_lines) gt 1 then begin
    openw,lun,outfile,/GET_LUN
      for i=1ul, n_elements(strarr_lines) do begin
        printf,lun,strarr_lines(n_elements(strarr_lines)-i)
      endfor
    free_lun,lun
  endif
end
