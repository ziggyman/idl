pro rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = i_str_filename_calib,$; --- #ext RAVE
;                                                                I_DBLARR_X                 = i_dblarr_x,$
                                                                IO_DBLARR_PARAMETER_VALUES = io_dblarr_parameter_values
  dblarr_coeffs = double(readfiletostrarr(i_str_filename_calib,' '))

  i_fit_order = n_elements(dblarr_coeffs)
  dblarr_old = io_dblarr_parameter_values
  if i_fit_order eq 2 then begin
    dblarr_new = (dblarr_old - dblarr_coeffs(0)) / dblarr_coeffs(1)
  end else if i_fit_order eq 3 then begin
    dblarr_sqrt = sqrt((dblarr_old / dblarr_coeffs(2)) + ((dblarr_coeffs(1)^2.) / (4. * (dblarr_coeffs(2)^2.))) - (dblarr_coeffs(0) / dblarr_coeffs(2)))
    dbl_test = (dblarr_coeffs(1) / (2. * dblarr_coeffs(2)))
    dblarr_new = dblarr_sqrt + dbl_test
    if max(dblarr_new) lt 0. then $
      dblarr_new = 0. - (dblarr_sqrt + dbl_test)
    if min(dblarr_new) gt 15000. then $
      dblarr_new = dblarr_sqrt - dbl_test
  endif
  io_dblarr_parameter_values = dblarr_new

  ; --- clean up
  dblarr_old = 0
  dblarr_new = 0
end
