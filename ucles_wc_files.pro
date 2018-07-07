pro ucles_wc_files
  str_filename = '/home/azuri/spectra/hermes/ThXe/file_list_alpha.list'

  strarr_files = readfilelinestoarr(str_filename)

  str_wc_argument = ''
  for i=0,n_elements(strarr_files)-1 do begin
    str_wc_argument = str_wc_argument + strarr_files(i)+' '
  endfor
  spawn,'wc '+str_wc_argument+' > '+strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_wc-out.text'
end
