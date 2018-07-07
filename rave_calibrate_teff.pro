pro rave_calibrate_teff,IO_DBLARR_TEFF         = io_dblarr_teff,$
                        I_DBLARR_STN           = i_dblarr_stn,$
                        I_STR_FILE_COEFFS_POLY_1 = i_str_file_coeffs_poly_1,$; --- coeffs from svdfit Teff_RAVE vs Teff_ext (2d or 3d)
                        I_STR_FILE_CALIB_STN   = i_str_file_calib_stn,$; --- coeffs from fit Teff_ext - Teff_RAVE vs STN
                        I_STR_FILE_COEFFS_POLY_2 = i_str_file_coeffs_poly_2; --- coeffs from svdfit Teff_RAVE vs Teff_ext (2d or 3d)

  dblarr_coeffs_poly_1 = double(readfiletostrarr(i_str_file_coeffs_poly_1,' '))
  if keyword_set(I_STR_FILE_COEFFS_POLY_2) then $
    dblarr_coeffs_poly_2 = double(readfiletostrarr(i_str_file_coeffs_poly_2,' '))

  if n_elements(io_dblarr_teff) ne n_elements(i_dblarr_stn) then begin
    print,'rave_calibrate_teff: ERROR: n_elements(io_dblarr_teff)=',n_elements(io_dblarr_teff),' ne n_elements(i_dblarr_stn)=',n_elements(i_dblarr_stn)
  endif

  ; --- 1st calibration from 1st svdfit
  indarr = where(io_dblarr_teff lt 7000.)
  if n_elements(dblarr_coeffs_poly_1) eq 2 then begin
    io_dblarr_teff(indarr) = (io_dblarr_teff(indarr) - dblarr_coeffs_poly_1(0)) / dblarr_coeffs_poly_1(1)
  end else if n_elements(dblarr_coeffs_poly_1) eq 3 then begin
    dblarr_sqrt = sqrt((io_dblarr_teff(indarr) / dblarr_coeffs_poly_1(2)) + ((dblarr_coeffs_poly_1(1)^2.) / (4. * (dblarr_coeffs_poly_1(2)^2.))) - (dblarr_coeffs_poly_1(0) / dblarr_coeffs_poly_1(2)))
    ;print,'dblarr_sqrt = ',dblarr_sqrt
    dbl_test = (dblarr_coeffs_poly_1(1) / (2. * dblarr_coeffs_poly_1(2)))
    ;print,'dbl_test = ',dbl_test
    io_dblarr_teff(indarr) = dblarr_sqrt + dbl_test
    if max(io_dblarr_teff(indarr)) lt 0. then $
      io_dblarr_teff(indarr) = 0. - (dblarr_sqrt + dbl_test)
    if min(io_dblarr_teff(indarr)) gt 15000. then $
      io_dblarr_teff(indarr) = dblarr_sqrt - dbl_test
  end else begin
    print,'rave_calibrate_teff: ERROR: dblarr_coeffs_poly_1 contains less than 2 or more than 3 elements'
  end

  ; --- 2nd calibration from dTeff vs STN fit
  rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = i_str_file_calib_stn,$; --- #x Par_ext-Par_RAVE
                                  I_DBLARR_X                 = i_dblarr_stn,$
                                  IO_DBLARR_PARAMETER_VALUES = io_dblarr_teff

  ; --- 3rd calibration from 2nd fit
  if keyword_set(I_STR_FILE_COEFFS_POLY_2) then begin
    if n_elements(dblarr_coeffs_poly_2) eq 2 then begin
      io_dblarr_teff(indarr) = (io_dblarr_teff(indarr) - dblarr_coeffs_poly_2(0)) / dblarr_coeffs_poly_2(1)
    end else if n_elements(dblarr_coeffs_poly_2) eq 3 then begin
      dblarr_sqrt = sqrt((io_dblarr_teff(indarr) / dblarr_coeffs_poly_2(2)) + ((dblarr_coeffs_poly_2(1)^2.) / (4. * (dblarr_coeffs_poly_2(2)^2.))) - (dblarr_coeffs_poly_2(0) / dblarr_coeffs_poly_2(2)))
      ;print,'dblarr_sqrt = ',dblarr_sqrt
      dbl_test = (dblarr_coeffs_poly_2(1) / (2. * dblarr_coeffs_poly_2(2)))
      ;print,'dbl_test = ',dbl_test
      io_dblarr_teff(indarr) = 0. - (dblarr_sqrt + dbl_test)
    end else begin
      print,'rave_calibrate_teff: ERROR: dblarr_coeffs_poly_1 contains less than 2 or more than 3 elements'
    end
  endif

end
