pro dist_arcsec_haversine, I_DBLARR_LON     = i_dblarr_lon,$
                           I_DBLARR_LAT     = i_dblarr_lat,$
                           I_DBL_LON        = i_dbl_lon,$
                           I_DBL_LAT        = i_dbl_lat,$
                           I_B_RA_DEC       = i_b_ra_dec,$
                           I_B_DEGREES      = i_b_degrees,$
                           O_DBLARR_DIST    = o_dblarr_dist

  if keyword_set(I_B_RA_DEC) then begin
    euler,i_dblarr_lon, i_dblarr_lat, dblarr_lon, dblarr_lat,1
    euler,i_dbl_lon,i_dbl_lat,dbl_lon,dbl_lat,1
  end else begin
    dblarr_lon = i_dblarr_lon
    dblarr_lat = i_dblarr_lat
    dbl_lon = i_dbl_lon
    dbl_lat = i_dbl_lat
  endelse
  if keyword_set(I_B_DEGREES) then begin
    dblarr_lon = dblarr_lon / !RADEG
    dblarr_lat = dblarr_lat / !RADEG
    dbl_lon = dbl_lon / !RADEG
    dbl_lat = dbl_lat / !RADEG
  endif

  dblarr_dlon = dblarr_lon - dbl_lon
  dblarr_dlat = dblarr_lat - dbl_lat

  dblarr_a = sin(dblarr_dlat/2.) * sin(dblarr_dlat/2.) + sin(dblarr_dlon/2.) * sin(dblarr_dlon/2.) * cos(dbl_lat) * cos(dblarr_lat)
  o_dblarr_dist = 2. * atan2(sqrt(dblarr_a), sqrt(1-dblarr_a)) * 240.;


;  if keyword_set(I_B_DEGREES) then begin
;    o_dblarr_dist = sqrt((((dblarr_ra * cos(dblarr_dec / !RADEG)) - (dbl_ra * cos(dbl_dec / !RADEG)))^2.) + (((dblarr_ra * sin(dblarr_dec / !RADEG)) - (dbl_ra * sin(dbl_dec / !RADEG)))^2.)) * 240.
;  end else begin
;    o_dblarr_dist = sqrt((((dblarr_ra * cos(dblarr_dec)) - (dbl_ra * cos(dbl_dec)))^2.) + (((dblarr_ra * sin(dblarr_dec)) - (dbl_ra * sin(dbl_dec)))^2.)) * 240.
;  endelse
;  print,'dist_arcsec: o_dblarr_dist = ',o_dblarr_dist
end
