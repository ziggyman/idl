pro rave_recalc_mh_echelle
  str_filename = '/home/azuri/daten/rave/calibration/echelle_orig_lon_lat.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

  int_col_mh = 9

  dblarr_mh_orig = double(strarr_data(*,int_col_mh))


end
