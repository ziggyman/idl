pro reduce_pdf_size,str_input,str_output
  spawn,'pdfinfo '+str_input+' > tempfile'
  wait,1.5
  strarr_info = readfiletostrarr('tempfile',' ')
  strarr_size = strarr(2)
  for i=0ul, n_elements(strarr_info(*,0)) - 1 do begin
    if strarr_info(i,0) eq 'Page' then begin
      strarr_size(0) = strarr_info(i,2)
      strarr_size(1) = strarr_info(i,4)
    endif
    if strarr_info(i,0) eq 'File' then begin
      int_bytes_old = long(strarr_info(i,2))
    endif
  endfor
  strarr_size = strtrim(string(long(strarr_size) / 2),2)
  spawn,'convert -resample '+strarr_size(0)+'x'+strarr_size(1)+' '+str_input+' '+str_output

  spawn,'pdfinfo '+str_output+' > '+str_output+'_temp'
  strarr_info = readfiletostrarr(str_output+'_temp',' ')
  for i=0ul, n_elements(strarr_info(*,0)) - 1 do begin
    if strarr_info(i,0) eq 'File' then begin
      int_bytes_new = long(strarr_info(i,2))
    endif
  endfor
  spawn,'rm '+str_output+'_temp'
  if int_bytes_new gt int_bytes_old then $
    spawn,'cp -p '+str_input+' '+str_output
end
