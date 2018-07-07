pro rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$; --- #x Par_ext-Par_RAVE
                                                       I_DBLARR_X                 = i_dblarr_x,$
                                                       IO_DBLARR_PARAMETER_VALUES = io_dblarr_parameter_values
  strarr_calib = readfiletostrarr(i_str_filename_calib,' ')
  dblarr_calib = double(strarr_calib)
  strarr_calib = 0

  dbl_diff_min = 10000000.
  for i=1ul, n_elements(dblarr_calib(*,0))-1 do begin
    dbl_diff = dblarr_calib(i,0) - dblarr_calib(i-1,0)
    if dbl_diff lt dbl_diff_min then $
      dbl_diff_min = dbl_diff
  endfor
  if n_elements(i_dblarr_x) ne n_elements(io_dblarr_parameter_values) then begin
    print,'rave_calibrate_parameter_values: PROBLEM: n_elements(i_dblarr_x)=',n_elements(i_dblarr_x),' ne n_elements(io_dblarr_parameter_values)=',n_elements(io_dblarr_parameter_values)
    stop
  endif
  for i=0ul, n_elements(i_dblarr_x)-1 do begin
    if i_dblarr_x(i) le dblarr_calib(0,0) then begin
      dbl_correction = dblarr_calib(0,1)
    end else if i_dblarr_x(i) ge dblarr_calib(n_elements(dblarr_calib(*,0))-1,0) then begin
      dbl_correction = dblarr_calib(n_elements(dblarr_calib(*,0))-1,1)
    end else begin
      ind_a = max(where(dblarr_calib(*,0) le i_dblarr_x(i)))
      ind_b = min(where(dblarr_calib(*,0) gt i_dblarr_x(i)))
      ;print,'rave_calibrate_parameter_values: i_dblarr_x(i=',i,') = ',i_dblarr_x(i),', dblarr_calib(ind_a,*) = ',dblarr_calib(ind_a,*),', dblarr_calib(ind_b,*) = ',dblarr_calib(ind_b,*)
      dbl_correction = dblarr_calib(ind_a,1) + ((i_dblarr_x(i) - dblarr_calib(ind_a,0)) * (dblarr_calib(ind_b,1) - dblarr_calib(ind_a,1)) / (dblarr_calib(ind_b,0) - dblarr_calib(ind_a,0)))
    endelse
    ;print,'rave_calibrate_parameter_values: old io_dblarr_parameter_values(i=',i,') = ',io_dblarr_parameter_values(i)
    ;print,'rave_calibrate_parameter_values: dbl_correction = ',dbl_correction
    io_dblarr_parameter_values(i) = io_dblarr_parameter_values(i) + dbl_correction
    ;print,'rave_calibrate_parameter_values: new io_dblarr_parameter_values(i=',i,') = ',io_dblarr_parameter_values(i)
;    stop
  endfor
end
