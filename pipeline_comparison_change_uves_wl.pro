pro pipeline_comparison_change_uves_wl, str_filename_in,str_filename_out
  dblarr_data = double(readfiletostrarr(str_filename_in,' '))
  intarr_size = size(dblarr_data)
  
  print,'intarr_size = ',intarr_size
  
; --- no_tiltcorr
;  a = 1.0000
;  b = 5817.776
;  dw = 0.016708530137141
  
; --- tiltcorr
  a = 1.0007214
  b = 5817.7172
  dw = 0.0167845424770628
  
  indarr = lindgen(intarr_size(1))
  dblarr_wlen = indarr * dw * a + b

  print,size(dblarr_wlen)
  dblarr_data(*,0) = dblarr_wlen
  
  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, intarr_size(1)-1 do begin
      printf,lun,strtrim(dblarr_data(i,0),2)+' '+strtrim(dblarr_data(i,1),2)
    endfor
  free_lun,lun
  
end
