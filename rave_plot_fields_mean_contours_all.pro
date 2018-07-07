pro rave_plot_fields_mean_contours_all

  b_abundances = 0
  b_calibrated = 0

  jj_end = 9
  if b_abundances then jj_end = 1
  if b_calibrated then jj_end = 1

  for jj = 0, jj_end do begin
    if jj eq 0 then begin
      str_path_temp = '/vrad_MH/I9.00-12.0/'
    end else if jj eq 1 then begin
      str_path_temp = '/Teff_logg/I9.00-12.0/'
    end else if jj eq 2 then begin
      str_path_temp = '/Breddels/rcent_MH/I9.00-12.0/'
    end else if jj eq 3 then begin
      str_path_temp = '/Breddels/dist_height/I9.00-12.0/'
    end else if jj eq 4 then begin
      str_path_temp = '/YY/rcent_MH/I9.00-12.0/'
    end else if jj eq 5 then begin
      str_path_temp = '/YY/dist_height/I9.00-12.0/'
    end else if jj eq 6 then begin
      str_path_temp = '/Dart/rcent_MH/I9.00-12.0/'
    end else if jj eq 7 then begin
      str_path_temp = '/Dart/dist_height/I9.00-12.0/'
    end else if jj eq 8 then begin
      str_path_temp = '/Padova/rcent_MH/I9.00-12.0/'
    end else if jj eq 9 then begin
      str_path_temp = '/Padova/dist_height/I9.00-12.0/'
    end
    for ii = 0, 1 do begin; --- b_sigma
      for nn = 0, 1 do begin; --- dwarfs and giants
        str_path = '/home/azuri/daten/besancon/lon-lat/html/5x5/best_error_fit/sample_logg/dr3_calib/popid/logg_'
        if b_calibrated then $
          str_path = '/home/azuri/daten/besancon/lon-lat/html/5x5/calibrated-merged/sample_logg/popid/logg_'
        if b_abundances then $
          str_path = '/home/azuri/daten/besancon/lon-lat/html/5x5/best_error_fit/sample_logg/abundances/popid/logg_'
        if nn eq 0 then begin
          str_path = str_path + '0.0-3.5'
        end else begin
          str_path = str_path + '3.5-10.0'
        end
        str_path = str_path + str_path_temp
        rave_plot_fields_mean_contours,I_STR_PATH = str_path,$
                                       I_B_SIGMA = ii,$
                                       I_B_DO_SIGMA_CLIPPING = 1
      endfor
    endfor
  endfor
end
