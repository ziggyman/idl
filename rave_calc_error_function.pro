pro rave_calc_error_function,dblarr_data,$
                             dblarr_errors,$
                             str_filename,$
                             DBLARR_COEFFS=dblarr_coeffs

  dbl_err_mean=mean(dblarr_errors)
  dbl_err_sigma=meanabsdev(dblarr_errors)
  set_plot,'ps'
    loadct,12
    device,filename=str_filename,/color
      plot,dblarr_data,$
           dblarr_errors,$
           psym=2,$
           yrange=[0.,dbl_err_mean+(5.*dbl_err_sigma)]
      dblarr_coeffs = poly_fit(dblarr_data,dblarr_errors,7,YFIT=dblarr_fit)
      intarr_data_sort = sort(dblarr_data)
      oplot,dblarr_data(intarr_data_sort),$
            dblarr_coeffs(intarr_data_sort),$
            THICK=3.,$
            color=3
    device,/close
  set_plot,'x'
end
