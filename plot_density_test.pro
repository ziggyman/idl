pro plot_density_test
  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK.dat'
  strarr_data = readfiletostrarr(str_filename,' ')
  dblarr_x = double(strarr_data(*,14))
  dblarr_y = double(strarr_data(*,7))
  dblarr_xrange = [6.,13.]
  indarr = where(dblarr_x gt 11.9)
  print,'n_elements(indarr) = ',n_elements(indarr)
;  print,'dblarr_x(indarr) = ',dblarr_x(indarr)
  dblarr_yrange = [-300.,300.]
  plot_density,I_DBLARR_X = dblarr_x,$
               I_DBLARR_Y = dblarr_y,$
               I_DBLARR_RANGE_X = dblarr_xrange,$
               I_DBLARR_RANGE_Y = dblarr_yrange,$
               I_STR_PLOTNAME_ROOT = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_I-vrad',$
               I_DBL_THICK = 3.,$
               I_DBL_CHARTHICK = 3.,$
               I_DBL_CHARSIZE=1.8,$
               I_STR_XTITLE = 'I!DC!N [mag]',$
               I_STR_YTITLE = 'v!Drad!N [km/s]';,$
;                 I_DBLARR_POSITION   = i_dblarr_position,$
;                 I_INT_XTICKS        = 4,$
;                 I_INT_YTICKS        = i_int_yticks,$
;                 I_STR_XTICKFORMAT   = i_str_xtickformat,$
;                 I_STR_YTICKFORMAT   = i_str_ytickformat,$
;                 I_INT_NBINS_MIN_X   = i_int_nbins_min_x,$
;                 I_INT_NBINS_MAX_X   = i_int_nbins_max_x,$
;                 I_INT_NBINS_MIN_Y   = i_int_nbins_min_y,$
;                 I_INT_NBINS_MAX_Y   = i_int_nbins_max_y

end
