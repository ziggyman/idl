pro vrad_from_uvwlb, I_DBL_L = i_dbl_l,$; [deg]
                     I_DBL_B = i_dbl_b,$; [deg]
                     I_DBL_UU = i_dbl_uu,$; [km/s]
                     I_DBL_VV = i_dbl_vv,$; [km/s]
                     I_DBL_WW = i_dbl_ww,$; [km/s]
                     I_DBL_U_SUN = i_dbl_u_sun,$; [km/s]
                     I_DBL_V_SUN = i_dbl_v_sun,$; [km/s]
                     I_DBL_W_SUN = i_dbl_w_sun,$; [km/s]
                     O_DBL_VRAD = o_dbl_vrad; [km/s]
; NAME:
;       vrad_from_uvwlb
; PURPOSE:
;       re-calculates vrad from U, V, W, L, B with different LSR
;
; EXPLANATION:
;       - adopt new LSR to re-calculate vrad
;       - LSR specified in vrad_from_uvwlb.pro
;
; CALLING SEQUENCE:
;       besancon_calculate_vrad_from_uvwlb,(IO_STR_FILENAME=filename)
;
; INPUTS: IO_STR_FILEAME - file name Besancon data file
;
; OUTPUTS: writes <IO_STR_FILENAME_root>+'_vrad-from-uvwlb'.dat
;
; RESTRICTIONS: -
;
; PRE: -
;
; POST: -
;
; USES: - readfiletostrarr.pro
;       - vrad_from_uvwlb.pro
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2010-07-25
;-------------------------------------------------------------------------

  if not keyword_set(I_DBL_L) then begin
    i_dbl_l = 0.87500;50.85
    i_dbl_b = -89.12500;-49.15
    i_dbl_uu = -80.15; -11.03 -17.06;20.9
    i_dbl_vv = -11.03;8.21
    i_dbl_ww = -17.06;-20.17

    ;vrad = 15.83 km/s

  endif

; --- RAVE
;  i_dbl_u_sun = 14.18
;  i_dbl_v_sun = 5.76
;  i_dbl_w_sun = 8.56

; --- Besancon
    dbl_u_sun_bes = 10.3
    dbl_v_sun_bes = 6.3
    dbl_w_sun_bes = 5.9

; --- Coscugnolu
    dbl_u_sun_rave = 8.5
    dbl_v_sun_rave = 13.38
    dbl_w_sun_rave = 6.49
;    i_dbl_u_sun = 8.83
;    i_dbl_v_sun = 14.19
;    i_dbl_w_sun = 6.57
  if keyword_set(I_DBL_U_SUN) then begin
    dbl_u_sun_rave = i_dbl_u_sun
    dbl_v_sun_rave = i_dbl_v_sun
    dbl_w_sun_rave = i_dbl_w_sun
  endif
;    i_dbl_r_sun = 8.

  dbl_v_lsr = 226.4

  ; --- r = sqrt(u^2 + v^2) ... length of velocity vector in u-v plane
  ; --- alpha = asin(v/r)   ... angle between r and u
  ; --- phi                 ... rotation vector of u-v coordinate system
  ; --- u' = r * cos(alpha + phi)
  ; --- v' = r * sin(alpha + phi)

  ; --- position of LSR from Sun
;  i_dbl_l_lsr = 53.
;  i_dbl_b_lsr = 23.

  dbl_pi = 3.14159265
  dbl_kiloparsec_in_km = 30.857 * 10.^12.

;  dbl_dist_star = dbl_dist * dbl_kiloparsec_in_km

;  l_lsr = 2. * dbl_pi * i_dbl_l_lsr / 360.
;  b_lsr = 2. * dbl_pi * i_dbl_b_lsr / 360.

  l_star = 2. * dbl_pi * i_dbl_l / 360.
;  print,'i_dbl_l = ',i_dbl_l,', l_star = ',l_star
  b_star = 2. * dbl_pi * i_dbl_b / 360.
;  print,'i_dbl_b = ',i_dbl_b,', b_star = ',b_star

; vector v_star
  dblarr_v_star = [i_dbl_uu + dbl_u_sun_bes - dbl_u_sun_rave, i_dbl_vv + dbl_v_sun_bes - dbl_v_sun_rave, i_dbl_ww + dbl_w_sun_bes - dbl_w_sun_rave]
;  print,'dblarr_v_star = ',dblarr_v_star

; vector v_sun
  dblarr_v_sun = [dbl_u_sun_rave, dbl_v_sun_rave, dbl_w_sun_rave]
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
                        (sqrt(total(dblarr_xyz_star_from_sun^2.)) *$
                         sqrt(total(dblarr_v_star^2.))))
;  print,'dbl_alpha_star = ',dbl_alpha_star

; --- angle between v_sun and r
  dbl_alpha_sun = acos(total(dblarr_xyz_star_from_sun * dblarr_v_sun) /$
                       (sqrt(total(dblarr_xyz_star_from_sun^2.)) *$
                        sqrt(total(dblarr_v_sun^2.))))
;  print,'dbl_alpha_sun = ',dbl_alpha_sun

; --- projection of v_star on r
  dbl_vrad_star = sqrt(total(dblarr_v_star^2.)) * cos(dbl_alpha_star)
;  print,'dbl_vrad_star = ',dbl_vrad_star

; --- projection of v_sun on r
  dbl_vrad_sun = sqrt(total(dblarr_v_sun^2.)) * cos(dbl_alpha_sun)
;  print,'dbl_vrad_sun = ',dbl_vrad_sun

  o_dbl_vrad = dbl_vrad_star; - dbl_vrad_sun
  print,'o_dbl_vrad = ',o_dbl_vrad



; -------------------------------


;  dbl_abs_v_uv_star = sqrt(i_dbl_uu^2. + i_dbl_vv^2)
;  dbl_alpha_star = acos(i_dbl_uu / dbl_abs_v_uv_star)
;  dbl_beta_star = l_star - dbl_alpha_star
;  dbl_abs_v_rad_uv_star = dbl_abs_v_uv_star * cos(dbl_beta_star)
;
;  dbl_abs_v_uv_sun = sqrt(i_dbl_u_sun^2. + i_dbl_v_sun^2.)
;  dbl_alpha_sun = acos(i_dbl_u_sun / dbl_abs_v_uv_sun)
;  dbl_beta_sun = dbl_alpha_sun - l_star
;  dbl_abs_v_rad_uv_sun = dbl_abs_v_uv_sun * cos(dbl_beta_sun)
;
;  dbl_abs_v_rad_uv_sun_star = dbl_abs_v_rad_uv_star - dbl_abs_v_rad_uv_sun
;
;  dbl_abs_vrad_w_star = i_dbl_ww * sin(b_star)
;  dbl_abs_vrad_w_sun  = i_dbl_w_sun * sin(b_star)
;
;  o_dbl_vrad = dbl_abs_v_rad_uv_sun_star + dbl_abs_vrad_w_star - dbl_abs_vrad_w_sun
;  print,'o_dbl_vrad = ',o_dbl_vrad


;  dblarr_t = dblarr(3,3)
;  dblarr_t(0,0) = -0.06699
;  dblarr_t(1,0) = -0.87276
;  dblarr_t(2,0) = -0.48354
;  dblarr_t(0,1) = 0.49273
;  dblarr_t(1,1) = -0.45035
;  dblarr_t(2,1) = 0.74458
;  dblarr_t(0,2) = -0.86760
;  dblarr_t(1,2) = -0.18837
;  dblarr_t(2,2) = 0.46020
;
;  dblarr_t_inv = invert(dblarr_t)
;
;  dblarr_l_b = dblarr(1,3)
;  dblarr_l_b(0,0) = cos(i_dbl_b) * cos(i_dbl_l)
;  dblarr_l_b(0,1) = cos(i_dbl_b) * sin(i_dbl_l)
;  dblarr_l_b(0,2) = sin(i_dbl_b)
;
;  dblarr_ra_dec = dblarr_t_inv ## dblarr_l_b
;  dbl_dec = asin(dblarr_ra_dec(2))
;  dbl_ra = asin(dblarr_ra_dec(1) / cos(dbl_dec))
;  print,'ra from T = ',dbl_ra
;  print,'dec from T = ',dbl_dec
;
;  euler,i_dbl_l,i_dbl_b,o_dbl_ra,o_dbl_dec,2
;  print,'o_dbl_ra = ',o_dbl_ra
;  print,'o_dbl_dec = ',o_dbl_dec
;
;  dblarr_a = dblarr(3,3)
;  dblarr_a(0,0) = cos(dbl_ra) * cos(dbl_dec)
;  dblarr_a(1,0) = 0. - sin(dbl_ra)
;  dblarr_a(2,0) = -cos(dbl_ra) * sin(dbl_dec)
;  dblarr_a(0,1) = sin(dbl_ra) * cos(dbl_dec)
;  dblarr_a(1,1) = cos(dbl_ra)
;  dblarr_a(2,1) = 0. - (sin(dbl_ra) * sin(dbl_dec))
;  dblarr_a(0,2) = sin(dbl_dec)
;  dblarr_a(1,2) = 0.
;  dblarr_a(2,2) = cos(dbl_dec)
;  print,'dblarr_a = ',dblarr_a
;
;  dblarr_a1 = dblarr(3,3)
;  dblarr_a1(0,0) = cos(dbl_ra)
;  dblarr_a1(1,0) = sin(dbl_ra)
;  dblarr_a1(2,0) = 0.
;  dblarr_a1(0,1) = sin(dbl_ra)
;  dblarr_a1(1,1) = 0. - cos(dbl_ra)
;  dblarr_a1(2,1) = 0.
;  dblarr_a1(0,2) = 0.
;  dblarr_a1(1,2) = 0.
;  dblarr_a1(2,2) = 0. - 1.
;
;  dblarr_a2 = dblarr(3,3)
;  dblarr_a2(0,0) = cos(dbl_dec)
;  dblarr_a2(1,0) = 0.
;  dblarr_a2(2,0) = 0. - sin(dbl_dec)
;  dblarr_a2(0,1) = 0.
;  dblarr_a2(1,1) = 0. - 1.
;  dblarr_a2(2,1) = 0.
;  dblarr_a2(0,2) = 0. - sin(dbl_dec)
;  dblarr_a2(1,2) = 0.
;  dblarr_a2(2,2) = 0. - cos(dbl_dec)
;
;  print,'dblarr_a1 # dblarr_a2 = ',dblarr_a1 # dblarr_a2
;  print,'dblarr_a1 ## dblarr_a2 = ',dblarr_a1 ## dblarr_a2
;
;  dblarr_b = dblarr_t ## dblarr_a
;  dblarr_b_inv = invert(dblarr_b)
;
;  print,'dblarr_b_inv ## dblarr_b = ',dblarr_b_inv ## dblarr_b
;  print,'dblarr_b_inv # dblarr_b = ',dblarr_b_inv # dblarr_b
;
;  dblarr_uvw = dblarr(1,3)
;  dblarr_uvw(0,0) = i_dbl_uu; - i_dbl_u_sun
;  dblarr_uvw(0,1) = i_dbl_vv; - i_dbl_v_sun
;  dblarr_uvw(0,2) = i_dbl_ww; - i_dbl_w_sun
;
;  dblarr_v = dblarr_b_inv ## dblarr_uvw
;
;  print,'dblarr_v = ',dblarr_v
;
;  print,'vrad = ',dblarr_v(0)
;  stop
end
