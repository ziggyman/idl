pro read_iraf_database_file,str_filename,strarr_out
  strarr_lines = readfilelinestoarr(str_filename,STR_DONT_READ='#')
  for i=0ul, n_elements(strarr_lines)-1 do begin
    print,'strarr_lines(i=',i,') = ',strarr_lines(i)
  endfor
;stop
  strarr_out = strarr(n_elements(strarr_lines),6)
  strarr_lines = strtrim(strarr_lines,2)
  for i=0ul, n_elements(strarr_lines)-1 do begin
    print,'strarr_lines(i=',i,') = ',strarr_lines(i)
    str_temp = strtrim(strmid(strarr_lines(i),0,strpos(strarr_lines(i),'	')),2)
;    if strpos(strarr_lines(i),'low') ge 0 then stop
    if str_temp eq '' then $
      str_temp = strtrim(strmid(strarr_lines(i),0,strpos(strarr_lines(i),' ')),2)
    print,'i=',i,': str_temp = <'+str_temp+'>'
    str_temptemp = str_temp
    if str_temp ne '' then $
      remove_substring_in_string,str_temp,'	'
    if str_temptemp ne str_temp then stop
    print,'i=',i,': str_temp = <'+str_temp+'>'

    if str_temp eq 'begin' then begin
      print,'i=',i,': begin found'
      strarr_out(i,0) = str_temp
      str_temp = strmid(strarr_lines(i),6)
      print,'i=',i,': str_temp = <'+str_temp+'>'
      int_pos = strpos(str_temp,' ')
      print,'i=',i,': int_pos = ',int_pos
      j=1
      while int_pos ge 1 do begin
        strarr_out(i,j) = strmid(str_temp,0,int_pos)
	str_temp = strtrim(strmid(str_temp,int_pos),2)
	print,'i=',i,': j=',j,': str_temp = <'+str_temp+'>'
	int_pos = strpos(str_temp,' ')
	j = j+1
      endwhile
      strarr_out(i,j) = str_temp
      print,'strarr_out(i=',i,',*) = ',strarr_out(i,*)
    end else if (str_temp eq 'image') or (str_temp eq 'aperture') or (str_temp eq 'beam') or (str_temp eq 'xmin') or (str_temp eq 'xmax') or (str_temp eq 'function') or (str_temp eq 'order') or (str_temp eq 'sample') or (str_temp eq 'naverage') or (str_temp eq 'niterate') or (str_temp eq 'low_reject') or (str_temp eq 'high_reject') or (str_temp eq 'grow') or (str_temp eq 'axis') or (str_temp eq 'curve')  then begin
      print,'i=',i,': <'+str_temp+'> found'
      strarr_out(i,0) = str_temp
      strarr_out(i,1) = strtrim(strmid(strarr_lines(i),strlen(str_temp)+1),2)
      remove_substring_in_string,strarr_out(i,1),'	'
      print,'strarr_out(i=',i,',*) = ',strarr_out(i,*)
    end else if (str_temp eq 'center') or (str_temp eq 'low') or (str_temp eq 'high') then begin
      print,'i=',i,': <'+str_temp+'> found'
      strarr_out(i,0) = str_temp
      strarr_lines(i) = strtrim(strmid(strarr_lines(i),strlen(str_temp)+1),2)
      int_pos = strpos(strarr_lines(i), ' ')
      str_temp = strtrim(strmid(strarr_lines(i),0,int_pos),2)
      print,'strarr_lines = <'+strarr_lines(i)+'>'
      print,'str_temp = <'+str_temp+'>'
      int_pos = strpos(str_temp, ' ')
      strarr_out(i,1) = strtrim(strmid(str_temp,int_pos),2)
      ;remove_substring_in_string,strarr_out(i,1),'	'

      strarr_out(i,2) = strmid(strarr_lines(i),strlen(str_temp)+1)

      print,'strarr_out(i=',i,',*) = ',strarr_out(i,*)
;      if strarr_out(i,0) eq 'low' then stop
    end else if str_temp eq '' then begin
      print,'i=',i,': <> found'
      print,'strarr_lines(i) = <'+strarr_lines(i)+'>'
      remove_substring_in_string,strarr_lines(i),'	'
      strarr_out(i,0) = strtrim(strarr_lines(i),2)
;      stop
    end else begin
      print,'i=',i,': '+strarr_lines(i)+' found'
      print,'strarr_lines(i) = <'+strarr_lines(i)+'>'
      strarr_out(i,0) = remove_substring_in_string(strarr_lines(i),'	')
      strarr_out(i,0) = strtrim(strarr_out(i,0),2)
;      stop
    end
  endfor
  for i=0ul, n_elements(strarr_out(*,0))-1 do begin
    print,'<'+strarr_out(i,0)+'> <'+strarr_out(i,1)+'> <'+strarr_out(i,2)+'> <'+strarr_out(i,3)+'> <'+strarr_out(i,4)+'> <'+strarr_out(i,5)+'>'
  endfor
;stop
end
