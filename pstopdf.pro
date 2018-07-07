pro pstopdf,i_str_filelist
  strarr_files = readfilelinestoarr(i_str_filelist)
  for i=0ul, n_elements(strarr_files)-1 do begin
    spawn,'epstopdf '+strarr_files(i)
    str_filename_root = strmid(strarr_files(i),0,strpos(strarr_files(i),'.',/REVERSE_SEARCH))
    reduce_pdf_size,str_filename_root+'.pdf',str_filename_root+'_small.pdf'
  endfor
end
