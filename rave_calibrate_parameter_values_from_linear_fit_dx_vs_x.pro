pro rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = i_str_filename_calib,$; --- #x Par_ext-Par_RAVE
                                                            I_DBLARR_X                 = i_dblarr_x,$
                                                            IO_DBLARR_PARAMETER_VALUES = io_dblarr_parameter_values

  if not keyword_set(I_DBLARR_X) then $
    i_dblarr_x = io_dblarr_parameter_values

  dblarr_coeffs = double(readfiletostrarr(i_str_filename_calib,' '))

  i_fit_order = n_elements(dblarr_coeffs)
  if i_fit_order eq 2 then begin
    io_dblarr_parameter_values = io_dblarr_parameter_values + dblarr_coeffs(0) + (dblarr_coeffs(1) * i_dblarr_x)
  end else begin
    stop
  end

end
