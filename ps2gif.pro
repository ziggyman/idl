pro ps2gif,str_input_list
  strarr_files = readfiletostrarr(str_input_list,' ')

  for i=0ul, n_elements(strarr_files)-1 do begin
    print,'converting '+strarr_files(i)
    str_outfile = strmid(strarr_files(i),0,strpos(strarr_files(i),'.',/REVERSE_SEARCH))+'.gif'
    spawn,'ps2gif '+strarr_files(i) + ' ' + str_outfile
  endfor
end
