pro get_smoothed_surface_4d_test
  str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'
    strarr_data = readfiletostrarr(str_filename,' ',HEADER=strarr_header)

  ; --- column numbers external file
  int_col_teff_ref = 4
  int_col_eteff_ref = 5
  int_col_logg_ref = 6
  int_col_elogg_ref = 7
  int_col_mh_ref = 8
  int_col_emh_ref = 9
  int_col_bool_feh_ref = 10
  int_col_afe_ref = 11
  int_col_teff_rave = 13
  int_col_eteff_rave = 14
  int_col_logg_rave = 15
  int_col_elogg_rave = 16
  int_col_mh_rave = 17
  int_col_emh_rave = 18
  int_col_afe_rave = 19
  int_col_stn_rave = 20
  int_col_source_ref = 21

  ; --- fill arrays external file
  dblarr_teff_ref = double(strarr_data(*,int_col_teff_ref))
  dblarr_logg_ref = double(strarr_data(*,int_col_logg_ref))
  dblarr_mh_ref = double(strarr_data(*,int_col_mh_ref))
  dblarr_afe_ref = double(strarr_data(*,int_col_afe_ref))

  dblarr_teff_rave = double(strarr_data(*,int_col_teff_rave))
  dblarr_logg_rave = double(strarr_data(*,int_col_logg_rave))
  dblarr_mh_rave = double(strarr_data(*,int_col_mh_rave))
  dblarr_afe_rave = double(strarr_data(*,int_col_afe_rave))
  dblarr_stn_rave = double(strarr_data(*,int_col_stn_rave))

  get_smoothed_surface_4d, R_I_DBLARR_W = dblarr_stn_rave,$
                             R_I_DBLARR_X = dblarr_teff_rave,$
                             R_I_DBLARR_Y = dblarr_logg_rave,$
                             R_I_DBLARR_Z = dblarr_mh_ref - dblarr_mh_rave,$
                             R_I_DBLARR_RANGE_W = [0.,200.],$
                             R_I_DBLARR_RANGE_X = [3000.,8000.],$
                             R_I_DBLARR_RANGE_Y = [0.,5.5],$
                             R_I_DBLARR_RANGE_Z = [-1.,1.],$
                             O_O_INDARR_CLIPPED = o_indarr_clipped,$
                             R_I_INT_NBINS_W    = 10,$
                             R_I_INT_NBINS_X    = 10,$
                             R_I_INT_NBINS_Y    = 10,$
                             R_I_STR_WTITLE     = 'STN',$
                             R_I_STR_XTITLE     = 'T!Deff!N [K]',$
                             R_I_STR_YTITLE     = 'log g [dex]',$
                             R_I_STR_ZTITLE     = 'd[M/H] [dex]',$
                             R_I_STR_TITLE_W    = 'STN',$
                             R_I_STR_TITLE_X    = 'Teff',$
                             R_I_STR_TITLE_Y    = 'logg',$
                             R_I_STR_TITLE_Z    = 'dMH',$
                             R_O_DBLARR_SMOOTHED_SURFACE = o_dblarr_smoothed_surface

end
