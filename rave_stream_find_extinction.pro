pro rave_stream_find_extinction
  str_filename_in = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l\=240-255\,b\=5-15.dat'
  str_filename_out = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'
  strarr_data = readfiletostrarr(str_filename_in,' ')
  strarr_lines = readfilelinestoarr(str_filename_in)
  
  int_col_l = 5
  int_col_b = 6
  
  dbl_convert_to_k = 0.367
  dbl_convert_to_j = 0.902

  dblarr_l = double(strarr_data(*,int_col_l))
  dblarr_b = double(strarr_data(*,int_col_b))

  openw,lun,str_filename_out,/GET_LUN
  for i=0ul, n_elements(dblarr_l)-1 do begin
    value = dust_getval(dblarr_l(i),dblarr_b(i),/interp)
    printf,lun,strarr_lines(i) + ' ' + strtrim(string(value),2) + ' ' + strtrim(string(value*dbl_convert_to_j),2) + ' ' + strtrim(string(value*dbl_convert_to_k),2)
  endfor
  free_lun,lun
end
