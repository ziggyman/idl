pro rave_merge_calibrated_files
  str_filename_calib_mH = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_MH-from-FeH-and-aFe.dat'
  str_filename_calib_cmH = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_MH-from-FeH-and-aFe.dat'
  str_filename_calib_mH_cmH = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_MH-from-FeH-and-aFe.dat'

  str_filename_out = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged.dat'

  int_col_teff = 19
  int_col_logg = 20
  int_col_mh = 24
  int_col_cmh = 23
  int_col_afe = 22

  strarr_data_calib_mh = readfiletostrarr(str_filename_calib_mH,' ',HEADER=strarr_header)
  strarr_data_calib_cmh = readfiletostrarr(str_filename_calib_cmH,' ')
  strarr_data_calib_mh_cmh = readfiletostrarr(str_filename_calib_mH_cmH,' ')

  dblarr_logg = double(strarr_data_calib_mh(*,int_col_logg))

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5

  strarr_out = strarr_data_calib_mh

;  strarr_out(indarr_dwarfs,int_col_teff) = strarr_data_calib_cmh(indarr_dwarfs,int_col_teff)
;  strarr_out(indarr_giants,int_col_teff) = strarr_data_calib_mh_cmh(indarr_giants,int_col_teff)

  strarr_out(indarr_giants,int_col_logg) = strarr_data_calib_mh_cmh(indarr_giants,int_col_logg)

  strarr_out(indarr_giants, int_col_mh) = strarr_data_calib_cmh(indarr_giants,int_col_mh)

  strarr_out(indarr_dwarfs, int_col_cmh) = strarr_data_calib_cmh(indarr_dwarfs, int_col_cmh)
;  strarr_out(indarr_giants, int_col_cmh) = strarr_data_calib_mh_cmh(indarr_giants, int_col_cmh)

  strarr_out(indarr_giants, int_col_afe) = strarr_data_calib_mh_cmh(indarr_giants, int_col_afe)

  write_file, I_STRARR_DATA   = strarr_out,$
              I_STRARR_HEADER = strarr_header,$
              I_STR_FILENAME  = str_filename_out

end
