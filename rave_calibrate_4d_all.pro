pro rave_calibrate_4d_all

  int_sigma_minelements = 3

  str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  strarr_data_rave = readfiletostrarr(str_filename_rave,' ', HEADER = strarr_header_all)

  ; --- column numbers rave file
  int_col_teff_rave_all = 19
  int_col_logg_rave_all = 20
  int_col_mh_rave_all   = 21
  int_col_afe_rave_all  = 22
  int_col_s2n_rave_all  = 34
  int_col_stn_rave_all  = 35

  ; --- fill arrays rave file
  dblarr_stn_rave_all = double(strarr_data_rave(*,int_col_stn_rave_all))
  dblarr_teff_rave_all = double(strarr_data_rave(*,int_col_teff_rave_all))
  dblarr_logg_rave_all = double(strarr_data_rave(*,int_col_logg_rave_all))
  dblarr_mh_rave_all = double(strarr_data_rave(*,int_col_mh_rave_all))
  dblarr_afe_rave_all = double(strarr_data_rave(*,int_col_afe_rave_all))

  str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'

  strarr_data = readfiletostrarr(str_filename,' ',HEADER = strarr_header)

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
  dblarr_mh_ref = double(strarr_data(*,int_col_mh_ref))
  dblarr_teff_ref = double(strarr_data(*,int_col_teff_ref))
  dblarr_logg_ref = double(strarr_data(*,int_col_logg_ref))
  dblarr_afe_ref = double(strarr_data(*,int_col_afe_ref))

  dblarr_stn_rave = double(strarr_data(*,int_col_stn_rave))
  dblarr_teff_rave = double(strarr_data(*,int_col_teff_rave))
  dblarr_logg_rave = double(strarr_data(*,int_col_logg_rave))
  dblarr_mh_rave = double(strarr_data(*,int_col_mh_rave))
  dblarr_afe_rave = double(strarr_data(*,int_col_afe_rave))

  str_filename_besancon = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh_with-errors_height_rcent_errdivby-1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe_samplex1_9ltI2MASSlt12_calib_logg_0.dat'
  strarr_data_besancon = readfiletostrarr(str_filename_besancon,' ')
  int_col_teff_bes = 5
  int_col_logg_bes = 6
  int_col_mh_bes = 8
  int_col_age_bes = 11
  dblarr_teff_bes = double(strarr_data_besancon(*,int_col_teff_bes))
  dblarr_logg_bes = double(strarr_data_besancon(*,int_col_logg_bes))
  dblarr_mh_bes = double(strarr_data_besancon(*,int_col_mh_bes))
  intarr_age_bes = long(strarr_data_besancon(*,int_col_age_bes))
  dblarr_data_besancon = 0

  dblarr_teff_rave_raw = dblarr_teff_rave
  dblarr_logg_rave_raw = dblarr_logg_rave
  dblarr_mh_rave_raw = dblarr_mh_rave
  dblarr_afe_rave_raw = dblarr_afe_rave

  dblarr_teff_rave_all_raw = dblarr_teff_rave_all
  dblarr_logg_rave_all_raw = dblarr_logg_rave_all
  dblarr_mh_rave_all_raw = dblarr_mh_rave_all
  dblarr_afe_rave_all_raw = dblarr_afe_rave_all

  dblarr_range_mh = [-2.,1.]
  dblarr_range_teff = [3000.,8000.]
  dblarr_range_logg = [0.,5.5]
  dblarr_range_afe = [0.,0.4]
  dblarr_range_stn = [0.,200.]

  int_nbins_mh = 10
  int_nbins_teff = 10
  int_nbins_logg = 10
  int_nbins_afe = 10
  int_nbins_stn = 10

  str_path = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/4d/'
  spawn,'mkdir '+str_path

  for i_par=0, 2 do begin
    if i_par eq 0 then begin
      dblarr_z_ref = dblarr_mh_ref

      dblarr_w_rave_ref = dblarr_stn_rave
      dblarr_x_rave_ref = dblarr_teff_rave_raw
      dblarr_y_rave_ref = dblarr_logg_rave_raw
      dblarr_z_rave_ref = dblarr_mh_rave_raw

      dblarr_w_rave_all = dblarr_stn_rave_all
      dblarr_x_rave_all = dblarr_teff_rave_all_raw
      dblarr_y_rave_all = dblarr_logg_rave_all_raw
      dblarr_z_rave_all = dblarr_mh_rave_all_raw

      dblarr_z_bes = dblarr_mh_bes

      str_wtitle = 'STN'
      str_xtitle = 'T!Deff!N [K]'
      str_ytitle = 'log g [dex]'
      str_ztitle = 'd[M/H] [dex]'
      str_hist_xtitle = '[M/H] [dex]'

      str_title_w = 'STN'
      str_title_x = 'Teff'
      str_title_y = 'logg'
      str_title_z = 'dMH'

      dblarr_wrange = dblarr_range_stn
      dblarr_xrange = dblarr_range_teff
      dblarr_yrange = dblarr_range_logg
      dblarr_zrange = dblarr_range_mh

      int_nbins_w = int_nbins_stn
      int_nbins_x = int_nbins_teff
      int_nbins_y = int_nbins_logg
    end else if i_par eq 1 then begin
      dblarr_z_ref = dblarr_teff_ref

      dblarr_w_rave_ref = dblarr_stn_rave
      dblarr_x_rave_ref = dblarr_mh_rave_raw
      dblarr_y_rave_ref = dblarr_logg_rave_raw
      dblarr_z_rave_ref = dblarr_teff_rave_raw

      dblarr_w_rave_all = dblarr_stn_rave_all
      dblarr_x_rave_all = dblarr_mh_rave_all_raw
      dblarr_y_rave_all = dblarr_logg_rave_all_raw
      dblarr_z_rave_all = dblarr_teff_rave_all_raw

      dblarr_z_bes = dblarr_teff_bes

      str_wtitle = 'STN'
      str_xtitle = '[M/H] [dex]'
      str_ytitle = 'log g [dex]'
      str_ztitle = 'dT!Deff!N [K]'
      str_hist_xtitle = 'T!Deff!N [K]'

      str_title_w = 'STN'
      str_title_x = 'MH'
      str_title_y = 'logg'
      str_title_z = 'dTeff'

      dblarr_wrange = dblarr_range_stn
      dblarr_xrange = dblarr_range_mh
      dblarr_yrange = dblarr_range_logg
      dblarr_zrange = dblarr_range_teff

      int_nbins_w = int_nbins_stn
      int_nbins_x = int_nbins_mh
      int_nbins_y = int_nbins_logg
    end else if i_par eq 2 then begin
      dblarr_z_ref = dblarr_logg_ref

      dblarr_w_rave_ref = dblarr_stn_rave
      dblarr_x_rave_ref = dblarr_teff_rave_raw
      dblarr_y_rave_ref = dblarr_mh_rave_raw
      dblarr_z_rave_ref = dblarr_logg_rave_raw

      dblarr_w_rave_all = dblarr_stn_rave_all
      dblarr_x_rave_all = dblarr_teff_rave_all_raw
      dblarr_y_rave_all = dblarr_mh_rave_all_raw
      dblarr_z_rave_all = dblarr_logg_rave_all_raw

      dblarr_z_bes = dblarr_logg_bes

      str_wtitle = 'STN'
      str_xtitle = 'T!Deff!N [K]'
      str_ytitle = '[M/H] [dex]'
      str_ztitle = 'd(log g) [dex]'
      str_hist_xtitle = 'log g [dex]'

      str_title_w = 'STN'
      str_title_x = 'Teff'
      str_title_y = 'MH'
      str_title_z = 'dlogg'

      dblarr_wrange = dblarr_range_stn
      dblarr_xrange = dblarr_range_teff
      dblarr_yrange = dblarr_range_mh
      dblarr_zrange = dblarr_range_logg

      int_nbins_w = int_nbins_stn
      int_nbins_x = int_nbins_teff
      int_nbins_y = int_nbins_mh
    endif
    str_plotname_root = str_path + strmid(str_filename,strpos(str_filename,'/',/REVERSE_SEARCH)+1)
    str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))+'_'+str_title_z+'_vs_'+str_title_w+'-'+str_title_x+'-'+str_title_y
    str_plotname_hist_root = str_plotname_root + '_hist'
    rave_calibrate_4d, I_DBLARR_Z_REF           = dblarr_z_ref,$
                       I_DBLARR_W_RAVE_REF      = dblarr_w_rave_ref,$
                       I_DBLARR_X_RAVE_REF      = dblarr_x_rave_ref,$
                       I_DBLARR_Y_RAVE_REF      = dblarr_y_rave_ref,$
                       IO_DBLARR_Z_RAVE_REF     = dblarr_z_rave_ref,$
                       I_DBLARR_W_RAVE_ALL      = dblarr_w_rave_all,$
                       I_DBLARR_X_RAVE_ALL      = dblarr_x_rave_all,$
                       I_DBLARR_Y_RAVE_ALL      = dblarr_y_rave_all,$
                       IO_DBLARR_Z_RAVE_ALL     = dblarr_z_rave_all,$
                       I_DBLARR_Z_BES           = dblarr_z_bes,$
                       I_INTARR_AGE_BES         = intarr_age_bes,$
                       I_STR_WTITLE             = str_wtitle,$
                       I_STR_XTITLE             = str_xtitle,$
                       I_STR_YTITLE             = str_ytitle,$
                       I_STR_ZTITLE             = str_ztitle,$
                       I_STR_TITLE_W            = str_title_w,$
                       I_STR_TITLE_X            = str_title_x,$
                       I_STR_TITLE_Y            = str_title_y,$
                       I_STR_TITLE_Z            = str_title_z,$
                       I_STR_HIST_XTITLE        = str_hist_xtitle,$
                       I_DBLARR_WRANGE          = dblarr_wrange,$
                       I_DBLARR_XRANGE          = dblarr_xrange,$
                       I_DBLARR_YRANGE          = dblarr_yrange,$
                       I_DBLARR_ZRANGE          = dblarr_zrange,$
                       I_STR_PLOTNAME_ROOT      = str_plotname_root,$
                       I_STR_PLOTNAME_HIST_ROOT = str_plotname_hist_root,$
                       I_DBL_REJECTVALUE_Z_REF  = 0.,$
                       I_INT_SIGMA_MINELEMENTS  = int_sigma_minelements,$
                       I_INT_NBINS_W            = int_nbins_w,$
                       I_INT_NBINS_X            = int_nbins_x,$
                       I_INT_NBINS_Y            = int_nbins_y
    if i_par eq 0 then begin
      strarr_data(*, int_col_mh_rave) = strtrim(string(dblarr_z_rave_ref))
      strarr_data_rave(*, int_col_mh_rave_all) = strtrim(string(dblarr_z_rave_all))
    end else if i_par eq 1 then begin
      strarr_data(*, int_col_teff_rave) = strtrim(string(dblarr_z_rave_ref))
      strarr_data_rave(*, int_col_teff_rave_all) = strtrim(string(dblarr_z_rave_all))
    end else if i_par eq 2 then begin
      strarr_data(*, int_col_logg_rave) = strtrim(string(dblarr_z_rave_ref))
      strarr_data_rave(*, int_col_logg_rave_all) = strtrim(string(dblarr_z_rave_all))
    endif
  endfor

  str_filename_out = str_path + strmid(str_filename,strpos(str_filename,'/',/REVERSE_SEARCH)+1)
  str_filename_out = strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_calib.dat'
  write_file, I_STRARR_DATA   = strarr_data,$
              I_STRARR_HEADER = strarr_header,$
              I_STR_FILENAME  = str_filename_out

  str_filename_rave_out = str_path + strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
  str_filename_rave_out = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_calib.dat'
  write_file, I_STRARR_DATA   = strarr_data_rave,$
              I_STRARR_HEADER = strarr_header_all,$
              I_STR_FILENAME  = str_filename_rave_out

  rave_compare_to_external_and_calibrate, I_STR_PATH         = str_path,$
                                          I_STR_FILENAME     = str_filename_out,$
                                          I_STR_RAVEFILENAME = str_filename_rave_out

  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
                     I_B_DWARFS     = 0,$
                     I_INT_COL_FIT  = int_col_mh_rave_all

  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
                     I_B_DWARFS     = 1,$
                     I_INT_COL_FIT  = int_col_mh_rave_all
end
