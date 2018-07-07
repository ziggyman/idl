pro remove_substring_in_string,str_string,str_substring
  i_pos = strpos(str_string,str_substring)
  if i_pos lt 0 then return
  while i_pos ge 0 do begin
    str_string = strmid(str_string,0,i_pos)+strmid(str_string,i_pos+strlen(str_substring))
    i_pos = strpos(str_string,str_substring)
  end
end
