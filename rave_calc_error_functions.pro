pro rave_calc_error_functions
  ravedatafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'

  i_nlines = countdatlines(ravedatafile)
  strarr_rave_data_all = readfiletostrarr(ravedatafile,' ')

  ; --- vrad
  dblarr_data = double(strarr_rave_data_all(*,6))
  dblarr_errors = double(strarr_rave_data_all(*,7))

  str_filename=strmid(ravedatafile,0,strpos(ravedatafile,'.',/REVERSE_SEARCH))+'_errors_vrad.ps'
  dblarr_coeffs = 1
  rave_calc_error_function,dblarr_data,$
                           dblarr_errors,$
                           str_filename,$
                           DBLARR_COEFFS=dblarr_coeffs

  ; --- Teff
;  dblarr_data = double(strarr_rave_data_all(*,18))
;  dblarr_errors = double(strarr_rave_data_all(*,7))

;  str_filename=strmid(ravedatafile,0,strpos(ravedatafile,'.',/REVERSE_SEARCH))+'_errors_Teff.ps'
;  dblarr_coeffs = 1
;  rave_calc_error_function,dblarr_data,$
;                           dblarr_errors,$
;                           str_filename,$
;                           DBLARR_COEFFS=dblarr_coeffs
end
