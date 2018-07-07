pro vrad_from_uvwlb_lib, DBL_L = dbl_l,$; [deg]
                     DBL_B = dbl_b,$; [deg]
                     DBL_UU = dbl_uu,$; [km/s]
                     DBL_VV = dbl_vv,$; [km/s]
                     DBL_WW = dbl_ww,$; [km/s]
;                     DBL_DIST = dbl_dist,$; [kiloparsec]
                     DBL_U_SUN = dbl_u_sun,$; [km/s]
                     DBL_V_SUN = dbl_v_sun,$; [km/s]
                     DBL_W_SUN = dbl_w_sun,$; [km/s]
;                     DBL_R_SUN = dbl_r_sun,$; [kiloparsec]
;                     DBL_V_LSR = dbl_v_lsr,$; [km/s]
                     OUT_DBL_VRAD = out_dbl_vrad; [km/s]

  if not keyword_set(DBL_L) then begin
    dbl_l = 50.85
    dbl_b = -49.15
    dbl_uu = 20.9
    dbl_vv = 8.21
    dbl_ww = -20.17
;    dbl_dist = 0.071
    ;vrad = 20.9

  endif

; --- RAVE
;  dbl_u_sun = 14.18
;  dbl_v_sun = 5.76
;  dbl_w_sun = 8.56

; --- Besancon
    dbl_u_sun = 10.3
    dbl_v_sun = 6.3
    dbl_w_sun = 5.9

;    dbl_r_sun = 8.

  dbl_v_lsr = 226.4

  ; --- r = sqrt(u^2 + v^2) ... length of velocity vector in u-v plane
  ; --- alpha = asin(v/r)   ... angle between r and u
  ; --- phi                 ... rotation vector of u-v coordinate system
  ; --- u' = r * cos(alpha + phi)
  ; --- v' = r * sin(alpha + phi)

  ; --- position of LSR from Sun
;  dbl_l_lsr = 53.
;  dbl_b_lsr = 23.

  dbl_pi = 3.14159265
  dbl_kiloparsec_in_km = 30.857 * 10.^12.

;  dbl_dist_star = dbl_dist * dbl_kiloparsec_in_km

;  l_lsr = 2. * dbl_pi * dbl_l_lsr / 360.
;  b_lsr = 2. * dbl_pi * dbl_b_lsr / 360.

  l_star = 2. * dbl_pi * dbl_l / 360.
;  print,'dbl_l = ',dbl_l,', l_star = ',l_star
  b_star = 2. * dbl_pi * dbl_b / 360.
;  print,'dbl_b = ',dbl_b,', b_star = ',b_star

; vector v_star
  dblarr_v_star = [dbl_uu, dbl_vv, dbl_ww]
;  print,'dblarr_v_star = ',dblarr_v_star

; vector v_sun
  dblarr_v_sun = [dbl_u_sun, dbl_v_sun, dbl_w_sun]
;  print,'dblarr_v_sun = ',dblarr_v_sun

; x_star
;  dbl_x_star = sin(dbl_pi / 2. - b_star) * cos(l_star); * dbl_dist_star
  dbl_x_star = cos(b_star) * cos(l_star); * dbl_dist_star
; y_star
;  dbl_y_star = sin(dbl_pi / 2. - b_star) * sin(l_star); * dbl_dist_star
  dbl_y_star = cos(b_star) * sin(l_star); * dbl_dist_star
; z_star
;  dbl_z_star = cos(dbl_pi / 2. - b_star); * dbl_dist_star
  dbl_z_star = sin(b_star); * dbl_dist_star
; --- vector (x_star, y_star, z_star) from sun
  dblarr_xyz_star_from_sun = [dbl_x_star,dbl_y_star,dbl_z_star]
;  print,'dblarr_xyz_star_from_sun = ',dblarr_xyz_star_from_sun

; --- angle between v_star and r
  dbl_alpha_star = acos(total(dblarr_xyz_star_from_sun * dblarr_v_star) /$
                        (sqrt(total(dblarr_xyz_star_from_sun^2)) *$
                         sqrt(total(dblarr_v_star^2))))
;  print,'dbl_alpha_star = ',dbl_alpha_star

; --- angle between v_sun and r
  dbl_alpha_sun = acos(total(dblarr_xyz_star_from_sun * dblarr_v_sun) /$
                       (sqrt(total(dblarr_xyz_star_from_sun^2)) *$
                        sqrt(total(dblarr_v_sun^2))))
;  print,'dbl_alpha_sun = ',dbl_alpha_sun

; --- projection of v_star on r
  dbl_vrad_star = sqrt(total(dblarr_v_star^2)) * cos(dbl_alpha_star)
;  print,'dbl_vrad_star = ',dbl_vrad_star

; --- projection of v_sun on r
  dbl_vrad_sun = sqrt(total(dblarr_v_sun^2)) * cos(dbl_alpha_sun)
;  print,'dbl_vrad_sun = ',dbl_vrad_sun

  out_dbl_vrad = dbl_vrad_star - dbl_vrad_sun
  print,'out_dbl_vrad = ',out_dbl_vrad



; -------------------------------


;  dbl_abs_v_uv_star = sqrt(dbl_uu^2. + dbl_vv^2)
;  dbl_alpha_star = acos(dbl_uu / dbl_abs_v_uv_star)
;  dbl_beta_star = l_star - dbl_alpha_star
;  dbl_abs_v_rad_uv_star = dbl_abs_v_uv_star * cos(dbl_beta_star)
;
;  dbl_abs_v_uv_sun = sqrt(dbl_u_sun^2. + dbl_v_sun^2.)
;  dbl_alpha_sun = acos(dbl_u_sun / dbl_abs_v_uv_sun)
;  dbl_beta_sun = dbl_alpha_sun - l_star
;  dbl_abs_v_rad_uv_sun = dbl_abs_v_uv_sun * cos(dbl_beta_sun)
;
;  dbl_abs_v_rad_uv_sun_star = dbl_abs_v_rad_uv_star - dbl_abs_v_rad_uv_sun
;
;  dbl_abs_vrad_w_star = dbl_ww * sin(b_star)
;  dbl_abs_vrad_w_sun  = dbl_w_sun * sin(b_star)
;
;  out_dbl_vrad = dbl_abs_v_rad_uv_sun_star + dbl_abs_vrad_w_star - dbl_abs_vrad_w_sun
;  print,'out_dbl_vrad = ',out_dbl_vrad


end
