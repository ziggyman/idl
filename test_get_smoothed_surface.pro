pro test_get_smoothed_surface
  str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

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

  dblarr_teff = double(strarr_data(*,int_col_teff_rave))
  dblarr_logg = double(strarr_data(*,int_col_logg_rave))
  dblarr_mh = double(strarr_data(*,int_col_mh_rave))
  dblarr_mh_ref = double(strarr_data(*,int_col_mh_ref))

  get_smoothed_surface, I_DBLARR_X = dblarr_teff,$
                        I_DBLARR_Y = dblarr_logg,$
                        I_DBLARR_Z = dblarr_mh_ref-dblarr_mh,$
                        I_INT_NBINS_X = 10,$
                        I_INT_NBINS_Y = 10,$
                        I_DBLARR_RANGE_X = [3000.,8000.],$
                        I_DBLARR_RANGE_Y = [0.,5.5],$
                        I_DBLARR_RANGE_Z = [-2.5,1.]

end
