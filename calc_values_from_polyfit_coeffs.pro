pro calc_values_from_polyfit_coeffs,DBLARR_DATA = dblarr_data,$
                                    DBLARR_COEFFS = dblarr_coeffs,$
                                    DBLARR_OUT = dblarr_out
  dblarr_out = dblarr_data - dblarr_data
  for i=0ul,n_elements(dblarr_coeffs)-1 do begin
    dblarr_out = dblarr_out + dblarr_coeffs(i) * dblarr_data ^ double(i)
  endfor
end
