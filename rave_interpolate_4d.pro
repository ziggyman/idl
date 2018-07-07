pro rave_interpolate_4d, I_DBL_W                   = i_dbl_w,$
                         I_DBL_X                   = i_dbl_x,$
                         I_DBL_Y                   = i_dbl_y,$
                         IO_DBL_Z                  = io_dbl_z,$
                         I_DBLVEC_W                = i_dblvec_w,$
                         I_DBLVEC_X                = i_dblvec_x,$
                         I_DBLVEC_Y                = i_dblvec_y,$
                         I_DBLARR_SMOOTHED_SURFACE = i_dblarr_smoothed_surface

  dbl_dw = i_dblvec_w(1) - i_dblvec_w(0)
  dbl_dx = i_dblvec_x(1) - i_dblvec_x(0)
  dbl_dy = i_dblvec_y(1) - i_dblvec_y(0)

  indarr_w = where(abs(i_dbl_w - i_dblvec_w) le dbl_dw)
  indarr_x = where(abs(i_dbl_x - i_dblvec_x) le dbl_dx)
  indarr_y = where(abs(i_dbl_y - i_dblvec_y) le dbl_dy)

  print,'indarr_w = ',indarr_w
  print,'indarr_x = ',indarr_x
  print,'indarr_y = ',indarr_y

  if (indarr_w(0) ge 0) and (indarr_x(0) ge 0) and (indarr_y(0) ge 0) then begin

    if n_elements(indarr_w) lt 2 then begin
      if indarr_w(0) eq n_elements(i_dblvec_w)-1 then begin
        indarr_w = [indarr_w(0) - 1, indarr_w(0)]
      end else begin
        indarr_w = [indarr_x(0), indarr_w(0) + 1]
      endelse
    endif
    if n_elements(indarr_x) lt 2 then begin
      if indarr_x(0) eq n_elements(i_dblvec_x)-1 then begin
        indarr_x = [indarr_x(0) - 1, indarr_x(0)]
      end else begin
        indarr_x = [indarr_x(0), indarr_x(0) + 1]
      endelse
    endif
    if n_elements(indarr_y) lt 2 then begin
      if indarr_y(0) eq n_elements(i_dblvec_y)-1 then begin
        indarr_y = [indarr_y(0) - 1, indarr_y(0)]
      end else begin
        indarr_y = [indarr_y(0), indarr_y(0) + 1]
      endelse
    endif

    ; --- interpolate in w
    dbl_dist_w_0 = (i_dbl_w - i_dblvec_w(indarr_w(0))) / (i_dblvec_w(indarr_w(1)) - i_dblvec_w(indarr_w(0)))

    ; --- interpolate in x
    dbl_dist_x_0 = (i_dbl_x - i_dblvec_x(indarr_x(0))) / (i_dblvec_x(indarr_x(1)) - i_dblvec_x(indarr_x(0)))

    ; --- interpolate in y
    dbl_dist_y_0 = (i_dbl_y - i_dblvec_y(indarr_y(0))) / (i_dblvec_y(indarr_y(1)) - i_dblvec_y(indarr_y(0)))

    ; --- interpolate z
    dbl_dz = interpolate(i_dblarr_smoothed_surface, indarr_w(0) + dbl_dist_w_0, indarr_x(0) + dbl_dist_x_0, indarr_y(0) + dbl_dist_y_0, MISSING = 0.)
    print,'dbl_dz = ',dbl_dz

;    print,'dblarr_z_calib(i=',i,') = ',dblarr_z_calib(i)
    io_dbl_z += dbl_dz
  endif
;  print,'dblarr_z_calib(i=',i,') = ',dblarr_z_calib(i)
;    stop


end
