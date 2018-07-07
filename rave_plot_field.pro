pro rave_plot_field
  str_filename = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-13-with-atm-par.dat'
  strarr_data = readfiletostrarr(str_filename,' ')

  i_col_rave_ra       = 3
  i_col_rave_dec      = 4
  i_col_rave_lon      = 5
  i_col_rave_lat      = 6
  i_col_rave_vrad     = 7; --- vrad
  i_col_rave_i        = 14; --- I [mag]
  i_col_rave_denis_j  = 52; --- Denis J [mag]
  i_col_rave_denis_k  = 54; --- Denis K [mag]
  i_col_rave_2mass_j  = 59; --- Denis J [mag]
  i_col_rave_2mass_k  = 63; --- Denis K [mag]
  i_col_rave_tycho_Bt = 36; --- Tycho Bt [mag]
  i_col_rave_tycho_Vt = 38; --- Tycho Vt [mag]
  i_col_rave_teff     = 19; --- Teff [K]
  i_col_rave_mh       = 21; --- [M/H] calibrated
;      i_col_rave_mh       = 23; --- [M/H] calibrated
  i_col_rave_afe      = 22; --- [alpha/Fe]
  i_col_rave_logg     = 20; --- log g
  i_col_rave_id       = 0; --- ID
  i_col_rave_snr      = 33; --- SNR
  i_col_rave_s2n      = 34; --- S2N
  i_col_rave_stn      = 35; --- STN
  i_col_rave_mu_ra    = 9; --- proper motion in RA
  i_col_rave_mu_dec   = 11; --- proper motion in DEC

  dblarr_mh = double(strarr_data(*,i_col_rave_mh))
  indarr_good_mh = where(dblarr_mh lt 1000.)
  dblarr_mh = dblarr_mh(indarr_good_mh)
  
  dblarr_lon = double(strarr_data(indarr_good_mh,i_col_rave_lon))
  dblarr_lat = double(strarr_data(indarr_good_mh,i_col_rave_lat))
  dblarr_x = double(strarr_data(indarr_good_mh,i_col_rave_mu_ra))
  dblarr_y = double(strarr_data(indarr_good_mh,i_col_rave_mu_dec))
  dblarr_vrad = double(strarr_data(indarr_good_mh,i_col_rave_vrad))
  
  
  indarr_good_x = where(dblarr_x lt 9999.)
  indarr_good_y = where(dblarr_y(dblarr_x) lt 9999.)
  dblarr_x = dblarr_x(indarr_good_x(indarr_good_y))
  dblarr_y = dblarr_x(indarr_good_x(indarr_good_y))
  dblarr_lon = dblarr_lon(indarr_good_x(indarr_good_y))
  dblarr_lat = dblarr_lat(indarr_good_x(indarr_good_y))
  dblarr_mh = dblarr_mh(indarr_good_x(indarr_good_y))
  dblarr_vrad = dblarr_vrad(indarr_good_x(indarr_good_y))

  dbl_lon_min = 20.;240.
  dbl_lon_max = 30.;255.
  dbl_lat_min = -50.;5.
  dbl_lat_max = -25.;10.
  
  dbl_mark_mh_min = 0.
  dbl_mark_mh_max = 0.5
  dbl_mark_vrad_min = 50.
  dbl_mark_vrad_max = 200.
  
  indarr_lon = where((dblarr_lon ge dbl_lon_min) and (dblarr_lon le dbl_lon_max))
  indarr_lat = where((dblarr_lat(indarr_lon) ge dbl_lat_min) and (dblarr_lat(indarr_lon) le dbl_lat_max))
  
  indarr_mh = where((dblarr_mh(indarr_lon(indarr_lat)) ge dbl_mark_mh_min) and (dblarr_mh(indarr_lon(indarr_lat)) le dbl_mark_mh_max))
  indarr_vrad = where((dblarr_vrad(indarr_lon(indarr_lat(indarr_mh))) ge dbl_mark_vrad_min) and (dblarr_vrad(indarr_lon(indarr_lat(indarr_mh))) le dbl_mark_vrad_max))
  
  set_plot,'ps'
  device,filename='/home/azuri/daten/rave/rave_data/release10/vrad_MH_'+strtrim(string(dbl_lon_min),2)+'-'+strtrim(string(dbl_lon_max),2)+'_'+strtrim(string(dbl_lat_min),2)+'-'+strtrim(string(dbl_lon_min),2)+'-'+strtrim(string(dbl_lon_max),2)+'_vrad'+strtrim(string(dbl_mark_vrad_min),2)+'-'+strtrim(string(dbl_mark_vrad_max),2)+'_mh'+strtrim(string(dbl_mark_mh_min),2)+'-'+strtrim(string(dbl_mark_mh_max),2)+'.ps',/color
  plot,dblarr_vrad(indarr_lon(indarr_lat)),$
       dblarr_mh(indarr_lon(indarr_lat)),$
       psym=2
  device,/close

  device,filename='/home/azuri/daten/rave/rave_data/release10/mu-ra_mu-dec_'+strtrim(string(dbl_lon_min),2)+'-'+strtrim(string(dbl_lon_max),2)+'_'+strtrim(string(dbl_lat_min),2)+'-'+strtrim(string(dbl_lon_min),2)+'-'+strtrim(string(dbl_lon_max),2)+'_vrad'+strtrim(string(dbl_mark_vrad_min),2)+'-'+strtrim(string(dbl_mark_vrad_max),2)+'_mh'+strtrim(string(dbl_mark_mh_min),2)+'-'+strtrim(string(dbl_mark_mh_max),2)+'.ps',/color
  plot,dblarr_x(indarr_lon(indarr_lat)),$
       dblarr_y(indarr_lon(indarr_lat)),$
       psym=2
  oplot,dblarr_x(indarr_lon(indarr_lat(indarr_mh(indarr_vrad)))),$
        dblarr_y(indarr_lon(indarr_lat(indarr_mh(indarr_vrad)))),$
        psym=2,$
        color=200
  device,/close
end
