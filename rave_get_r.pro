function rave_get_r,DBLARR_LON = dblarr_lon,$; --- in RAD
                    DBLARR_DIST = dblarr_dist; --- in kpc

  dbl_r_sun = 8.5; kpc

  dblarr_r_half = dbl_r_sun - dblarr_dist * cos(dblarr_lon)
  dblarr_temp = dblarr_dist * sin(dblarr_lon)
  dblarr_r = sqrt(dblarr_temp^2. + dblarr_r_half^2.)

  return,dblarr_r
end
