pro rave_xcheck_external
  str_fechelle = '/home/azuri/daten/rave/calibration/echelle_orig_lon_lat.dat'
  str_fsoubiran = '/home/azuri/daten/rave/calibration/rave_soubiran_orig.dat'
  str_fpastel = '/home/azuri/daten/pastel/asu.tsv'

  for i=0,1 do begin
    if i eq 0 then begin
      str_fa = str_fechelle
      int_col_lon_a = 23
      int_col_lat_a = 24
      b_radec_a = 0
    end else begin
      str_fa = str_fsoubiran
      int_col_lon_a = 0
      int_col_lat_a = 1
      b_radec_a = 1
    endelse
    xmatch_two_catalogues, I_STR_FILENAME_A              = str_fa,$
                           I_STR_FILENAME_B              = str_fpastel,$
                           I_STR_DELIMITER_A             = ' ',$
                           I_STR_DELIMITER_B             = ';',$
                           I_INT_COL_LON_A               = i_int_col_lon_a,$
                           I_INT_COL_LON_B               = 0,$
                           I_INT_COL_LAT_A               = i_int_col_lat_a,$
                           I_INT_COL_LAT_B               = 1,$
                           I_B_RADEC_A                   = b_radec_a,$
                           I_B_RADEC_B                   = 0,$
                           I_DBL_MAX_DIFF_LON_LAT_ARCSEC = 5
  endfor
end
