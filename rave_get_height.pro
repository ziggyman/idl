function rave_get_height,DBLARR_DIST = dblarr_dist,$
                         DBLARR_LAT = dblarr_lat
  dbl_distance_of_sun_from_galactic_plane = 0.026;+/- 0.003 kpc (Majaess2009 - Characteristics of the Galaxy according to Cepheids.pdf)

  dblarr_height = dblarr_dist * sin(dblarr_lat)
  dblarr_height = dblarr_height + dbl_distance_of_sun_from_galactic_plane
  return,dblarr_height
end
