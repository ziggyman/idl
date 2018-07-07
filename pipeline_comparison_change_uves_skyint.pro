pro pipeline_comparison_change_uves_skyint, str_filename_in,str_filename_out
  dblarr_data = double(readfiletostrarr(str_filename_in,' '))
  intarr_size = size(dblarr_data)
  
  print,'intarr_size = ',intarr_size

  dblarr_data(*,1) = dblarr_data(*,1) / 8.
  
  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, intarr_size(1)-1 do begin
      printf,lun,strtrim(dblarr_data(i,0),2)+' '+strtrim(dblarr_data(i,1),2)
    endfor
  free_lun,lun
  
end
