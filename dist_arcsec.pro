pro dist_arcsec, I_DBLARR_RA     = i_dblarr_ra,$
                 I_DBLARR_DEC    = i_dblarr_dec,$
                 I_DBL_RA        = i_dbl_ra,$
                 I_DBL_DEC       = i_dbl_dec,$
                 I_B_LON_LAT     = i_b_lon_lat,$
                 I_B_DEGREES     = i_b_degrees,$; --- 0: I_* given in rad, 1: I_* given in Degrees
                 O_DBLARR_DIST   = o_dblarr_dist

  if keyword_set(I_B_LON_LAT) then begin
    euler,i_dblarr_ra, i_dblarr_dec, dblarr_ra, dblarr_dec,2
    euler,i_dbl_ra,i_dbl_dec,dbl_ra,dbl_dec,2
  end else begin
    dblarr_ra = i_dblarr_ra
    dblarr_dec = i_dblarr_dec
    dbl_ra = i_dbl_ra
    dbl_dec = i_dbl_dec
  endelse

  if keyword_set(I_B_DEGREES) then begin
    dblarr_ra = dblarr_ra / !RADEG
    dblarr_dec = dblarr_dec / !RADEG
    dbl_ra = dbl_ra / !RADEG
    dbl_dec = dbl_dec / !RADEG
  endif

  gcirc, 0, dbl_ra, dbl_dec, dblarr_ra, dblarr_dec, o_dblarr_dist
  o_dblarr_dist = o_dblarr_dist * !RADEG * 3600.
end
