pro rave_add_pixelmap_to_index_html, I_STR_PATH       = i_str_path,$
                                     I_STR_PIXELMAP   = i_str_pixelmap,$
                                     I_STR_FIELDSFILE = i_str_fieldsfile 
  strarr_index_lines = readfilelinestoarr(i_str_path+'index.html')
  if not(keyword_set(i_str_pixelmap))  then $
    i_str_pixelmap = '/home/azuri/daten/rave/rave_data/map_5x5.html'
  strarr_pixelmap_lines = readfilelinestoarr(i_str_pixelmap)
  strarr_fields = readfiletostrarr(i_str_fieldsfile,' ')

  k=0ul

  openw,lun_index,i_str_path+'index.html.temp',/GET_LUN
    for i=0ul, n_elements(strarr_index_lines)-1 do begin
      i_insertpos = strpos(strarr_index_lines(i),'60%')
      i_insertname = strpos(strarr_index_lines(i),'deg<br>RA = ')
      if i_insertpos gt 0 then begin
        str_line = strmid(strarr_index_lines(i),0,i_insertpos)
        str_line = str_line + '"520" height="373" usemap="#pixelmap"'
        str_line = str_line + strmid(strarr_index_lines(i),i_insertpos+3)
        printf,lun_index,str_line
      endif else if i_insertname gt 0 then begin
        str_line = '<hr><a name="'+strmid(strarr_fields(k,0),0,strpos(strarr_fields(k,0),'.',/REVERSE_SEARCH)+3)+$
                    '-'+$
                    strmid(strarr_fields(k,1),0,strpos(strarr_fields(k,1),'.',/REVERSE_SEARCH)+3)+$
                    '_'+$
                    strmid(strarr_fields(k,2),0,strpos(strarr_fields(k,2),'.',/REVERSE_SEARCH)+3)+$
                    '-'+$
                    strmid(strarr_fields(k,3),0,strpos(strarr_fields(k,3),'.',/REVERSE_SEARCH)+3)+'">'
        str_line = str_line + strmid(strarr_index_lines(i),4)
        printf,lun_index,str_line
        k = k+1
      endif else if strarr_index_lines(i) eq '</body>' then begin
        for j=0ul, n_elements(strarr_pixelmap_lines) - 1 do begin
          printf,lun_index,strarr_pixelmap_lines(j)
        endfor
        printf,lun_index,strarr_index_lines(i)
      endif else begin
        printf,lun_index,strarr_index_lines(i)
      endelse
    endfor
  free_lun,lun_index
  spawn,'mv '+i_str_path+'index.html.temp '+i_str_path+'index_new.html'
end
