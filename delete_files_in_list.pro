pro delete_files_in_list,filelist
  str_path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)
  strarr_files = readfiletostrarr(filelist,' ')
  for i=0UL, n_elements(strarr_files)-1 do begin
    print,'deleting '+str_path+strarr_files(i)
    spawn,'rm '+str_path+strarr_files(i)
  endfor
end
