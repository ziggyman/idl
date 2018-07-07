pro rave_show_fields, path
  i_strlen_path = strlen(path)
;  spawn,'ls '+path+'*-*_*-*/rave_internal*.gif'
  spawn,'ls '+path+'*-*_*-*/rave_internal*.gif > temp.list'
  strarr_files = readfiletostrarr('temp.list',' ')
  print,'strarr_files: ',strarr_files

  print,'rave_show_fields: n_elements(strarr_files) = ',n_elements(strarr_files)
  openw,lun,path+'index_rave.html',/GET_LUN
    printf,lun,'<html><body><center>'
    for i=0UL, n_elements(strarr_files)-1 do begin
      printf,lun,'<a href="'+strmid(strarr_files(i),i_strlen_path)+'">'+strmid(strarr_files(i),i_strlen_path)+'<br><img src="'+strmid(strarr_files(i),i_strlen_path)+'"></a><br><hr>'
    endfor
    printf,lun,'</center></body></html>'
  free_lun,lun
end
