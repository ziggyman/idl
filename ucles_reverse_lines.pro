pro ucles_reverse_lines
  b_thar = 1

  if b_thar then begin
    str_filelist = '/home/azuri/spectra/hermes/ThXe/thar_aps.list'
  end else begin
    str_filelist = '/home/azuri/spectra/hermes/ThXe/to_reverse_lines.list'
  end

  strarr_filelist = readfilelinestoarr(str_filelist)

  for i=0,n_elements(strarr_filelist)-1 do begin
    reverse_lines,strarr_filelist(i),strmid(strarr_filelist(i),0,strpos(strarr_filelist(i),'.',/REVERSE_SEARCH))+'r.text'
  endfor
end
