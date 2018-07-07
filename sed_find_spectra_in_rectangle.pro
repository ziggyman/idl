pro sed_find_spectra_in_rectangle
  i_xmin = 900
  i_xmax = 1200
  i_ymin = 870
  i_ymax = 1480
  
  str_filename = '/home/azuri/spectra/SEDIFU/aps_cal_ident.list'
  strarr_filenames = readfilelinestoarr(str_filename)
  str_filename_out = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_sky.list'
  
  intarr_x = ulonarr(n_elements(strarr_filenames))  
  intarr_y = ulonarr(n_elements(strarr_filenames))  
  
  openw,lun,str_filename_out,/GET_LUN
  
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    xstart = strpos(strarr_filenames(i), '_x') + 2
    xend = strpos(strarr_filenames(i), '_',xstart)
    print,'i=',i,': x=<'+strmid(strarr_filenames(i),xstart,xend-xstart)+'>'
    intarr_x(i) = ulong(strmid(strarr_filenames(i),xstart,xend-xstart))
    
    ystart = strpos(strarr_filenames(i), '_y') + 2
    yend = strpos(strarr_filenames(i), '_',ystart)
    intarr_y(i) = ulong(strmid(strarr_filenames(i),ystart,yend-ystart))
    
    if ((intarr_x(i) ge i_xmin) and (intarr_x(i) le i_xmax) and (intarr_y(i) ge i_ymin) and (intarr_y(i) le i_ymax)) then begin
      printf,lun,strarr_filenames(i)
    endif
  endfor
  
  free_lun,lun
end
