pro epstopdf,str_list
  strarr_files = readfilelinestoarr(str_list)
  for i=0ul, n_elements(strarr_files)-1 do begin
    print,'running <epstopdf '+strarr_files(i)+'>'
    spawn,'epstopdf '+strarr_files(i)
  endfor
end
