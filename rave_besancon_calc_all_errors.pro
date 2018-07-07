pro rave_besancon_calc_all_errors
  for i=0,11 do begin
    if i eq 0 then begin
      dbl_error = 0.25
    end else if i eq 1 then begin
      dbl_error = 0.5
    end else if i eq 2 then begin
      dbl_error = 0.75
    end else if i eq 3 then begin
      dbl_error = 1.
    end else if i eq 4 then begin
      dbl_error = 1.25
    end else if i eq 5 then begin
      dbl_error = 1.5
    end else if i eq 6 then begin
      dbl_error = 1.75
    end else if i eq 7 then begin
      dbl_error = 2.
    end else if i eq 8 then begin
      dbl_error = 2.5
    end else if i eq 9 then begin
      dbl_error = 3.
    end else if i eq 10 then begin
      dbl_error = 3.5
    end else if i eq 11 then begin
      dbl_error = 4.
    end else if i eq 12 then begin
      dbl_error = 4.5
    end else begin
      dbl_error = 5.
    end
    dbl_logg_divide_err_by = dbl_error
    dbl_mh_divide_err_by = dbl_error
    dbl_teff_divide_err_by = dbl_error
    dbl_vrad_divide_err_by = dbl_error
    dbl_dist_divide_err_by = dbl_error
    rave_besancon_plot_all, DBL_LOGG_DIVIDE_ERR_BY = dbl_logg_divide_err_by,$
                            DBL_MH_DIVIDE_ERR_BY = dbl_mh_divide_err_by,$
                            DBL_TEFF_DIVIDE_ERR_BY = dbl_teff_divide_err_by,$
                            DBL_VRAD_DIVIDE_ERR_BY = dbl_vrad_divide_err_by,$
                            DBL_DIST_DIVIDE_ERR_BY = dbl_dist_divide_err_by,$
                            DBL_DIST_BREDDELS_DIVIDE_ERR_BY = dbl_dist_divide_err_by
  endfor
end
