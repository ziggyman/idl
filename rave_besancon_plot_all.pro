pro rave_besancon_plot_all, DBL_LOGG_DIVIDE_ERR_BY = dbl_logg_divide_err_by,$
                            DBL_MH_DIVIDE_ERR_BY = dbl_mh_divide_err_by,$
                            DBL_TEFF_DIVIDE_ERR_BY = dbl_teff_divide_err_by,$
                            DBL_VRAD_DIVIDE_ERR_BY = dbl_vrad_divide_err_by,$
                            DBL_DIST_DIVIDE_ERR_BY = dbl_dist_divide_err_by,$
                            DBL_DIST_BREDDELS_DIVIDE_ERR_BY = dbl_dist_breddels_divide_err_by

  ; --- Besancon:
  ; --- besancon_create_new_datafile:
  ; ---    besancon_write_stars_all -> *.dat
  ; ---    besancon_combine_datafiles -> besancon_all_10x10
  ; ---    besancon_combine_all_and_JmK -> besancon_all_10x10_230-315_-25-25_JmK2MASS_gt_0_5
  ; ---    besancon_convolve_i_with_eimag -> _eI
  ; ---    rave_besancon_plot_all,b_calc_errors+,b_calc_snr+,b_calc_mh+ -> _mh+snr
  ; ---    rave_besancon_plot_all,b_calc_errors+,b_calc_snr+,b_calc_mh- -> _+snrdec_gt_13
  ; --- (besancon_get_ravesample -> _samplex1/_distsample)
  ; --- rave_besancon_plot_all,b_calc_errors+,b_calc_snr-, b_dist+ -> _with_errors_errdiffby_?.??_?.??_?.??_?.??_?.??.dat
  ; --- rave_besancon_calc_heights -> _with_errors_heights_rcent_errdiffby_?.??_?.??_?.??_?.??_?.??.dat
  ; ---
  ; --- RAVE:
  ; --- dist+:
  ; ---        rave_dist_write_min_err -> _lon_lat.dat
  ; --- dist- && chem-: rave_remove_bad_stars   -> _with-2MASS-JK_no-flag
  ; --- rave_remove_ic1_from_rave_data           -> _minus_ic1
  ; --- rave_remove_stars_in_box_with_jmk_lt_0_5 -> _230-315_-25-25_JmK2MASS_gt_0_5.dat
  ; --- rave_find_doubles -> _no_doubles_<minerr/maxsnr>.dat
  ; --- abundances:
  ; ---        rave_abundances_find_imag -> _I2MASS(_9ltIlt12)_frac_gt_70
  ; --- dist+:
  ; ---        rave_replace_imag_with_2mass_dist -> _I2MASS(_9ltIlt12)_lb
  ; ---        rave_besancon_calc_heights -> _height_rcent.dat
  ; --- rave:
  ; ---        rave_replace_imag_with_2mass -> _I2MASS(_9ltIlt12)_lb
  ; --- to calculate snr:
  ; ---    b_calc_errors = 1
  ; ---    b_calc_snr = 1
  ; ---    (b_dist = 1)
  ; ---    b_do_... = 0
  ; ---    run TWICE: once with dwarfs_only and once with giants_only, then concatenate both files
  ; --- (dist-:
  ; ---        rave_find_good_stars : -> _good_STN-gt-20-with-atm-par)
  ; --- besancon_get_ravesample : -> _distsample/samplex1
  ; --- to calculate errors:
  ; ---    b_calc_errors = 1
  ; ---    b_calc_snr = 0
  ; ---    (b_dist = 1)
  ; ---    b_do_... = 0

  ; --- if b_do_i_vrad: set all other b_do_... to 0

  !P.CHARSIZE=1.2
  !P.CHARTHICK=2

  b_sanjib = 0
  b_corrado = 0
  b_breddels = 0

  str_XxY = '5x5'
  str_pixelmap = '/home/azuri/daten/rave/rave_data/map_5x5.html'

  b_plot_contours = 1
  b_do_boxcar_smoothing = 1

  b_with_extinction = 0; --- set to 1 to handle raw Besancon data files, which didn't go through besancon_combine_datafiles
  b_extinction_test = 0
  i_rave_dr = 10

  b_select_from_imag_and_logg = 1; --- i_plot_giant_to_dwarf_ratio must be 0
  i_plot_giant_to_dwarf_ratio = 0; --- b_giants_only AND b_dwarfs_only must be 0

  b_giants_only = 1
  b_dwarfs_only = 0

  ; --- b_input:
  b_do_I_K = 0
  b_do_I_ImK = 0

  ; --- test!!!
  b_do_ImV_VmK = 0; JmK: JmI_ImK

  ; --- special:
  b_do_I_vrad_9_12 = 0

  ; --- all
  b_do_I_vrad_9_10_5 = 0
  b_do_I_vrad_10_5_12 = 0
  b_do_I_vrad_9_10 = 0
  b_do_I_vrad_10_11 = 0
  b_do_I_vrad_11_12 = 0

  b_do_I_Teff_9_12 = 0
  b_do_I_Teff_9_10_5 = 0
  b_do_I_Teff_10_5_12 = 0
  b_do_I_Teff_9_10 = 0
  b_do_I_Teff_10_11 = 0
  b_do_I_Teff_11_12 = 0

  b_do_vrad_MH_9_12 = 1
  b_do_vrad_MH_9_10_5 = 0
  b_do_vrad_MH_10_5_12 = 0
  b_do_vrad_MH_9_10 = 0
  b_do_vrad_MH_10_11 = 0
  b_do_vrad_MH_11_12 = 0

  b_do_Teff_logg_9_12 = 0
  b_do_Teff_logg_9_10_5 = 0
  b_do_Teff_logg_10_5_12 = 0
  b_do_Teff_logg_9_10 = 0
  b_do_Teff_logg_10_11 = 0
  b_do_Teff_logg_11_12 = 0

  b_do_Teff_MH_9_12 = 0;1

;  b_do_I_giant_to_dwarf_ratio_9_12 = 0
;  if b_do_I_giant_to_dwarf_ratio_9_12 then $
;    b_select_from_imag_and_logg = 0

  b_dist = 0
  b_do_dist_vrad_9_12 = 0
  b_do_dist_vrad_9_10_5 = 0
  b_do_dist_vrad_10_5_12 = 0
  b_do_dist_vrad_9_10 = 0
  b_do_dist_vrad_10_11 = 0
  b_do_dist_vrad_11_12 = 0

  b_do_dist_height_9_12 = 0

  b_do_vrad_height_9_12 = 0

  b_do_height_MH_9_12 = 0

  b_do_rcent_height_9_12 = 0

  b_do_rcent_MH_9_12 = 0

  b_do_dist_Teff_9_12 = 0

;  if b_dist then begin
;    i_col_imag = 12
;    i_col_id = 0
;  end

  i_col_lon_besancon = 0
  i_col_lat_besancon = 1
  i_col_imag_besancon = 2
  i_icol_besancon = 2
  i_col_vjmag_besancon = 3
  i_col_kmag_besancon = 4
  i_col_teff_besancon = 5
  i_col_logg_besancon = 6
  i_col_vrad_besancon = 7
  i_col_feh_besancon = 8
  i_col_dist_besancon = 9
  i_col_type_besancon = 10
  i_col_age_besancon = 11
;    i_col_vmi_besancon = 10; V-I, JmK: I-J
;    i_col_vmk_besancon = 11; V-K, JmK: I-K
  i_col_u_besancon = 12
  i_col_v_besancon = 13
  i_col_w_besancon = 14
  i_col_snr_besancon = 15
  i_col_height_besancon = 16
  i_col_rcent_besancon = 17

  if b_sanjib then $
    i_col_snr_besancon = 10
  i_col_height_san = 11
  i_col_rcent_san = 12

  b_i_search = 1;              --- create random samples with same I-mag distribution like the RAVE stars in the field
  b_one_besanconfile = 1
  b_lonlat = 1
  b_star_types = 1
  b_pop_id = 0
  if b_star_types and b_sanjib then begin
    b_star_types = 0
    b_pop_id = 1
  endif
  b_calcnbins = 1
  b_calcsamples = 1
  b_plot_mean_kst = 1
  i_nsamples = 30
  nbinsmin = 20
  nbinsmax = 30

  if b_giants_only or b_dwarfs_only then $
    i_plot_giant_to_dwarf_ratio = 0
  if i_plot_giant_to_dwarf_ratio gt 0 then $
    b_select_from_imag_and_logg = 0

  b_colorcut = 0
  d_BV_min = 0.4
  d_BV_max = 1.2

  b_log_cut = 0
  d_log_min = 0.
  d_log_max = 3.5
  if b_dwarfs_only then begin
    b_log_cut = 1
    d_log_min = 3.5
    d_log_max = 10.
  end
  if b_giants_only then begin
    b_log_cut = 1
    d_log_min = 0.
    d_log_max = 3.5
  end

  ; --- besancon
  b_calc_snr = 0
  b_calc_snr_again = 0
  b_calc_mh = 0
  b_calc_errors = 0


  if b_calc_snr or b_calc_snr_again then $
    b_calc_errors = 1
  if b_calc_snr_again then begin
    if not b_corrado then $
      b_calc_mh = 1
    int_which_get_snr = 4 ;1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
                          ;2 --- besancon_get_snr_i_dec
                          ;3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
                          ;4 --- besancon_get_snr_i_dec_giant_dwarf
  end else begin
    b_calc_mh = 0
    int_which_get_snr = 4 ;1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
                          ;2 --- besancon_get_snr_i_dec
                          ;3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
                          ;4 --- besancon_get_snr_i_dec_giant_dwarf
  end

  ; --- rave
  if b_corrado then begin
    i_calibrate_rave_metallicities = 0
  end else begin
    i_calibrate_rave_metallicities = 4
  end
  ; --- 0: no calibration
  ; --- 1: [M/H] = [m/H] + 0.2
  ; --- 2: old calib (with logg)
  ; --- 3: new calib (with teff)
  ; --- 4: DR3 calib (separate for dwarfs and giants, with logg, teff, stn)

  b_input = 0
  b_rave_input_vs_observed = 0
  b_rave_input_vs_parameters = 0
  if b_rave_input_vs_observed or b_rave_input_vs_parameters then begin
    b_star_types = 0
    b_pop_id = 0
    b_calc_errors = 0
    b_calc_snr = 0
  endif

  dbl_snr_maxdiff_i = 0.05
  dbl_snr_maxdiff_dec = 2.
  dbl_snr_maxdiff_logg = 0.2

; --- all stars
  dbl_logg_divide_error_by = 1.56;1.7825;1.83;1.90;2.36
  if b_corrado then begin
    dbl_mh_divide_error_by   = 2.37;2.345;2.95;2.24;3.64
  end else begin
    dbl_mh_divide_error_by   = 2.37;2.345;2.95;2.24;3.64
  end
  dbl_teff_divide_error_by = 2.75;2.615;3.04;1.86;2.84
  dbl_vrad_divide_error_by = 1.50;1.;1.;1.0
  dbl_dist_divide_error_by = 2.00;1.00;3.9875;1.;0.93;1.26
  dbl_dist_breddels_divide_error_by = 2.00;1.00;3.9875;1.;0.93;1.26

;dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00
;dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00
; --- dwarfs only
  if b_dwarfs_only then begin
    dbl_logg_divide_error_by = 2.70;1.44;1.56;1.7825;1.83;1.90;2.36
    if b_corrado then begin
      dbl_mh_divide_error_by   = 1.10;0.72;2.37;2.345;2.95;2.24;3.64
    end else begin
      dbl_mh_divide_error_by   = 0.75;0.72;2.37;2.345;2.95;2.24;3.64
    end
    dbl_teff_divide_error_by = 2.00;1.64;2.75;2.615;3.04;1.86;2.84
    dbl_vrad_divide_error_by = 1.00;1.00;1.;1.;1.0
    dbl_dist_divide_error_by = 4.00;1.00;3.9875;1.;0.93;1.26
    dbl_dist_breddels_divide_error_by = 2.00;1.00;3.9875;1.;0.93;1.26
  endif

; --- giants only
  if b_giants_only then begin
    dbl_logg_divide_error_by = 1.5;1.0
    ;1.5;1.44;1.56;1.7825;1.83;1.90;2.36
    if b_corrado then begin
      dbl_mh_divide_error_by   = 2.00
      ;0.72;2.37;2.345;2.95;2.24;3.64
    end else begin
      dbl_mh_divide_error_by   = 1.5;1.0
      ;1.50;0.72;2.37;2.345;2.95;2.24;3.64
    end
    dbl_teff_divide_error_by = 1.8;2.0
    ;1.80;1.64;2.75;2.615;3.04;1.86;2.84
    dbl_vrad_divide_error_by = 1.50
    ;1.00;1.;1.;1.0
    dbl_dist_divide_error_by = 2.00
    ;1.00;3.9875;1.;0.93;1.26
    dbl_dist_breddels_divide_error_by = 2.00
    ;1.00;3.9875;1.;0.93;1.26
  endif

  if keyword_set(DBL_LOGG_DIVIDE_ERR_BY) then dbl_logg_divide_error_by = dbl_logg_divide_err_by
  if keyword_set(DBL_MH_DIVIDE_ERR_BY) then dbl_mh_divide_error_by = dbl_mh_divide_err_by
  if keyword_set(DBL_TEFF_DIVIDE_ERR_BY) then dbl_teff_divide_error_by = dbl_teff_divide_err_by
  if keyword_set(DBL_VRAD_DIVIDE_ERR_BY) then dbl_vrad_divide_error_by = dbl_vrad_divide_err_by
  if keyword_set(DBL_DIST_DIVIDE_ERR_BY) then dbl_dist_divide_error_by = dbl_dist_divide_err_by
  if keyword_set(DBL_DIST_BREDDELS_DIVIDE_ERR_BY) then dbl_dist_breddels_divide_error_by = dbl_dist_breddels_divide_err_by

  dbl_xmax_I = 0.1
  dbl_xmax_vrad = 20.
  dbl_xmax_Teff = 200.
  dbl_xmax_MH = 0.2
  dbl_xmax_logg = 0.2
  dbl_xmax_dist = 0.5
  dbl_xmax_height = 0.5
  dbl_xmax_rcent = 0.5
  dbl_xmax_z = 0.5

  if b_star_types then begin
    if b_one_besanconfile then begin
;      if b_with_extinction then begin
;        int_col_star_types = 13
;      end else begin
        int_col_star_types=10
;      end
    end else begin
      int_col_star_types=2
    end
  end else if b_pop_id then begin
    if b_sanjib then begin
      int_col_star_types = 8
    end else begin
;      if b_with_extinction then begin
;        int_col_star_types = 16
;      end else begin
        int_col_star_types = 11
;      end
    end
  end else begin
    int_col_star_types = 0
  end
  if b_sanjib then begin
    str_path='/home/azuri/daten/besancon/lon-lat/html/'+str_XxY+'/sanjib/'
  end else begin
    if b_with_extinction then begin
      str_path='/home/azuri/daten/besancon/lon-lat/html/with_extinction/'
    end else begin
      str_path='/home/azuri/daten/besancon/lon-lat/html/'+str_XxY+'/';'calibrated-merged/'
      spawn,'mkdir '+str_path
      if b_select_from_imag_and_logg then begin
        str_path = str_path+'sample_logg/'
      end else begin
        str_path = str_path+'sample_no_logg/'
      end
      spawn,'mkdir '+str_path
      str_path = str_path+'vrad_Coscugnolu/'
      spawn,'mkdir '+str_path
      if b_corrado then begin
        str_path = str_path+'abundances/'
      end else if i_calibrate_rave_metallicities eq 1 then begin
        str_path = str_path+'mh+0.2/'
      end else if i_calibrate_rave_metallicities eq 2 then begin
        str_path = str_path+'old_calib/'
      end else if i_calibrate_rave_metallicities eq 3 then begin
        str_path = str_path+'new_calib/'
      end else if i_calibrate_rave_metallicities eq 4 then begin
        str_path = str_path+'dr3_calib/'
      end
      spawn,'mkdir '+str_path
      str_path = str_path+'rave_dr'+strtrim(string(i_rave_dr),2)+'/'
      spawn,'mkdir '+str_path
;      str_path = str_path+'test/'
;      spawn,'mkdir '+str_path
      if b_pop_id then begin
        str_path=str_path+'popid/'
      end else if b_star_types then begin
        str_path=str_path+'star_types/'
      end
      spawn,'mkdir '+str_path
    end
;    str_path='/home/azuri/daten/besancon/lon-lat/html/5x5/with_errors/'
  end
;  str_path='/home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low_err_divby_5.0_5.0_5.0/'
;  str_path='/home/azuri/daten/besancon/lon-lat/html/5x5/test_noise_SNR/'
;  str_path='/home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/'
  if b_input eq 1 then begin
    str_path = str_path+'rave-input_besancon/'
  endif
  if b_rave_input_vs_observed then begin
    str_path = str_path+'rave_input_vs_observed/'
  endif
  if b_rave_input_vs_parameters then begin
    str_path = str_path+'rave_input_vs_parameters/'
  endif
  if b_log_cut eq 1 then begin
    spawn,'mkdir '+str_path
    str_dum = strtrim(string(d_log_min),2)
    str_dum = strmid(str_dum,0,strpos(str_dum,'.')+2)
    str_path=str_path+'logg_'+str_dum+'-'
    str_dum = strtrim(string(d_log_max),2)
    str_dum = strmid(str_dum,0,strpos(str_dum,'.')+2)
    str_path=str_path+str_dum+'/'
  end
  spawn,'mkdir '+str_path
  if b_input eq 1 then begin
    spawn,'mkdir '+str_path+'I_K/'
  end else begin
    spawn,'mkdir '+str_path+'ImV_VmK/'
    spawn,'mkdir '+str_path+'I_Teff/'
    spawn,'mkdir '+str_path+'I_vrad/'
    spawn,'mkdir '+str_path+'vrad_MH/'
    spawn,'mkdir '+str_path+'Teff_logg/'
    spawn,'mkdir '+str_path+'Teff_MH/'
    spawn,'mkdir '+str_path+'dist_vrad/'
    spawn,'mkdir '+str_path+'dist_height/'
    spawn,'mkdir '+str_path+'vrad_height/'
    spawn,'mkdir '+str_path+'height_MH/'
    spawn,'mkdir '+str_path+'rcent_height/'
    spawn,'mkdir '+str_path+'rcent_MH/'
    spawn,'mkdir '+str_path+'dist_Teff/'
  endelse

  if b_colorcut eq 1 then begin
    str_path=str_path+'colour_cut/'
  endif

  if b_with_extinction then begin
    fieldsfile = '/rave/fields_lon_lat_test_extinction.dat'

;    fieldsfile = '/home/azuri/daten/besancon/lon-lat/with_extinction/fields.dat'
  end else if b_extinction_test then begin
    fieldsfile = '/rave/fields_lon_lat_small_new-5x5_dust.dat'
  end else begin

;  if b_input eq 1 then begin
;    fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test_I_K.dat'

;    fieldsfile = '/rave/fields_lon_lat_test_JmK.dat'
;  end else begin
;    fieldsfile = '/rave/release3/fields.dat'
;    fieldsfile = '/rave/release3/fields_lon_lat_new.dat'
;    fieldsfile = '/rave/release3/fields_lon_lat_big-small.dat'
;    fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test_teff.dat'
;    fieldsfile = '/rave/fields_lon_lat_small_new-2.5x2.5_test.dat'





    fieldsfile = '/rave/fields_lon_lat_small_new-'+str_XxY+'_new.dat'
;    fieldsfile = '/rave/fields_lon_lat_small_new-'+str_XxY+'_test.dat'
;    fieldsfile = '/rave/fields_lon_lat_small_new-5x5_new.dat'
    ;fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test.dat'
;    fieldsfile = '/rave/fields_lon_lat_small_new-5x5_dust.dat'
;    fieldsfile = '/rave/fields_lon_lat_test_extinction.dat'

;    fieldsfile = '/rave/fields_test.dat'





;  fieldsfile = '/rave/fields_lon_lat_test_vrad.dat'


;  fieldsfile = '/rave/fields_lon_lat_small_new-5x5.dat'
;  fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test.dat'
;  fieldsfile = '/rave/fields_lon_lat_small_new-5x5_2nd_half.dat'
;  fieldsfile = '/home/azuri/daten/besancon/lon-lat/230-240_-50--40/fields_lon_lat_star-types.dat'
;  fieldsfile = '/rave/release3/fields_lon_lat_big.dat'
;  fieldsfile = '/rave/release3/fields_lon_lat_small.dat'
;  fieldsfile = '/rave/fields_lon_lat_all_stars.dat'
;  fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test_dist.dat'
;  fieldsfile = '/rave/stellar_streams.dat'
;  fieldsfile = '/rave/fields_lon_lat_small_new-5x5_test_dust.dat'
;  endelse
  end
  if b_input eq 1 then begin
    ravedatafile = '/rave/input_catalogue/rave_input_final.dat'
    i_col_rave_ra = 1
    i_col_rave_dec = 2
    i_col_rave_lon = 3
    i_col_rave_lat = 4
    i_col_rave_i = 5
    i_col_rave_j = 6
    i_col_rave_k = 7
;  end else if b_dist and not b_calc_errors then begin
;    ravedatafile = '/rave/release2/rave_dr2.dat'
  end else begin
    ; --- pre: rave_find_doubles, rave_find_good_stars
;    ravedatafile = '/rave/release3/rave_internal_090408.dat'
;    ravedatafile = '/rave/release5/rave_internal_300808_no_doubles.dat'
;    ravedatafile = '/rave/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'

    if i_rave_dr eq 7 then begin
      ravedatafile = '/rave/release7/rave_internal_290110_no_doubles_maxsnr_SNR_gt_20_230-315_-25-25_JmK_gt_0_5_samplex1.dat'
      i_col_rave_ra   = 2
      i_col_rave_dec  = 3
      i_col_rave_lon  = 4
      i_col_rave_lat  = 5
      i_col_rave_i    = 13; --- I [mag]
      i_col_rave_vrad = 6; --- vrad
      i_col_rave_teff = 18; --- Teff [K]
      i_col_rave_mh   = 20; --- [Fe/H]
      i_col_rave_afe  = 21; --- [alpha/Fe]
      i_col_rave_logg = 19; --- log g
      i_col_rave_id   = 0; --- ID
      i_col_rave_snr  = 32; --- SNR
      i_col_rave_stn  = 33; --- STN
    end else if i_rave_dr eq 8 then begin
      if b_do_I_vrad_9_12 eq 1 then begin
        ravedatafile = '/rave/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_samplex1_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat';                                                                    rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat'
      end else begin
        if b_corrado then begin
          ravedatafile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000_chemsample_logg_0';RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_no-doubles-maxsnr.dat';_STN_gt_13_chemsample_logg_0.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_minus_ic1_chemsample_0.dat'
        end else begin
          ravedatafile = '/rave/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1_logg_0_errdivby_1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1_logg_0_errdivby_dwarfs-1_00-1_48-1_41-1_55-1_00';.dat';/rave/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib_samplex1_logg_0';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
        endelse
        if not b_calc_errors then begin
          if b_corrado then begin
            ravedatafile = ravedatafile + '_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00';RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_no-doubles-maxsnr.dat';_STN_gt_13_chemsample_logg_0.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_minus_ic1_chemsample_0.dat'
          end else begin
;            ravedatafile = ravedatafile + '_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00';_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
          endelse
        endif
        ravedatafile = ravedatafile + '.dat'
        ;ravedatafile = '/rave/release8/rave_internal_dr8_stn_gt_20_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5_IDenis_9ltIlt12_samplex1_0.dat'
      end
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
      i_col_rave_mh       = 23; --- [M/H] calibrated
      i_col_rave_afe      = 22; --- [alpha/Fe]
      i_col_rave_logg     = 20; --- log g
      i_col_rave_id       = 0; --- ID
      i_col_rave_snr      = 33; --- SNR
      i_col_rave_s2n      = 34; --- S2N
      i_col_rave_stn      = 35; --- STN
      if b_corrado then begin
        i_col_rave_mh      = 68; --- [Fe/H]
        i_col_rave_teff    = 70; --- T_eff [K]
;        i_col_rave_mh       = 72; --- [M/H]
        i_col_rave_afe     = 73; --- [alpha/Fe]
        i_col_rave_logg    = 71; --- log g [dex]
      endif
    end else if i_rave_dr eq 9 then begin
      if b_do_I_vrad_9_12 eq 1 then begin
        ravedatafile = '/rave/release9/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_samplex1_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat';                                                                    rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat'
      end else begin
        if b_corrado then begin
          ravedatafile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000_chemsample_logg_0';RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_no-doubles-maxsnr.dat';_STN_gt_13_chemsample_logg_0.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_minus_ic1_chemsample_0.dat'
        end else begin
          ravedatafile = '/rave/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-20-with-atm-par_samplex1_logg_0_errdivby_dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50'
          ;'/rave/release9/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1_logg_0_errdivby_1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1_logg_0_errdivby_dwarfs-1_00-1_48-1_41-1_55-1_00';.dat';/rave/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib_samplex1_logg_0';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
        endelse
        if not b_calc_errors then begin
          if b_corrado then begin
            ravedatafile = ravedatafile + '_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00';RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_no-doubles-maxsnr.dat';_STN_gt_13_chemsample_logg_0.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_minus_ic1_chemsample_0.dat'
          end else begin
;            ravedatafile = ravedatafile + '_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00';_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
          endelse
        endif
        ravedatafile = ravedatafile + '.dat'
        ;ravedatafile = '/rave/release8/rave_internal_dr8_stn_gt_20_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5_IDenis_9ltIlt12_samplex1_0.dat'
      end
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
      if b_corrado then begin
        i_col_rave_mh      = 68; --- [Fe/H]
        i_col_rave_teff    = 70; --- T_eff [K]
;        i_col_rave_mh       = 72; --- [M/H]
        i_col_rave_afe     = 73; --- [alpha/Fe]
        i_col_rave_logg    = 71; --- log g [dex]
      endif
    end else if i_rave_dr eq 10 then begin
      if b_do_I_vrad_9_12 eq 1 then begin
        ravedatafile = '/rave/release10/rave_internal_dr8_all_with-2MASS-JK_no-flag_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_samplex1_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat';                                                                    rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat'
      end else begin
        if b_corrado then begin
          ravedatafile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000_chemsample_logg_0';RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_no-doubles-maxsnr.dat';_STN_gt_13_chemsample_logg_0.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_minus_ic1_chemsample_0.dat'
        end else begin
          ravedatafile = '/rave/release10/raveinternal_150512_with2MASSJK_noFlag_minusIC1-IC2_230-315_-25-25_JmK2MASSgt0_5_noDBLS-within2arcsec-maxSNR_I2MASS-9ltIlt12_STNgt20WithAtmPar_MHgood_samplex1-'+str_XxY+'_logg_0_errdivby_dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50'
        endelse
        if not b_calc_errors then begin
          if b_corrado then begin
            ravedatafile = ravedatafile + '_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00'
          end else begin
;            ravedatafile = ravedatafile + '_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00';_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
          endelse
        endif
        ravedatafile = ravedatafile + '.dat'
      end
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
      if b_corrado then begin
        i_col_rave_mh      = 68; --- [Fe/H]
        i_col_rave_teff    = 70; --- T_eff [K]
;        i_col_rave_mh       = 72; --- [M/H]
        i_col_rave_afe     = 73; --- [alpha/Fe]
        i_col_rave_logg    = 71; --- log g [dex]
      endif
    end
  endelse
  str_ravedatafile = strmid(ravedatafile,0,strpos(ravedatafile,'/',/REVERSE_SEARCH)+1)+'rave_temp'
  if (b_giants_only) then begin
    str_ravedatafile = str_ravedatafile+'_giants'
  end else if (b_dwarfs_only) then begin
    str_ravedatafile = str_ravedatafile+'_dwarfs'
  endif
  str_ravedatafile = str_ravedatafile+'.dat'
  spawn,'cp -p '+ravedatafile+' '+str_ravedatafile
  str_temp = str_ravedatafile
  str_ravedatafile = ravedatafile
  ravedatafile = str_temp
  print,'ravedatafile = ',ravedatafile
  print,'str_ravedatafile = ',str_ravedatafile
;  stop
  str_temp = 0
  if b_calc_errors then begin
    if b_with_extinction then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/extinction/l310b5-oldchim.msp1004.dat'
;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/with_extinction/besancon_with_extinction.dat'
    end else if b_extinction_test then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/extinction/new/besancon_with_extinction_new_mh+snr.dat'
    end else if b_sanjib then begin
      besancondatafile = '/home/azuri/daten/besancon/sanjib_mh+snr_with_errors_height_rcent.dat'
;      besancondatafile = '/home/azuri/daten/besancon/sanjib_mh+snr_samplex1.dat'
    end else begin
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_big.dat'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_230-240_5-15_dust7.dat'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_230-320_-25-25_JmK_vrad.dat'
;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK.dat'





;      besancondatafile='/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors.dat'

;      if b_do_I_vrad_9_12 eq 1 then begin
;        besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_rave_all_samplex1.dat'
;      end else begin
;        besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_rave_stn_gt_20_samplex1.dat'
;      end

;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_samplex1.dat'





;       besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr.dat';'_height_rcent.dat'
       besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20.dat';'besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_vrad-from-uvwlb.dat'
;       if b_dist then $
;         besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snrdec_gt_13_distsample_9ltI2MASSlt12_logg_0.dat';_samplex1_0.dat'

       if b_corrado then begin
         besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_teff-gt-4000.dat';_chemsample_9ltI2MASSlt12_logg_0.dat';_+snrdec_gt_13_chemsample_9ltI2MASSlt12_0.dat'
         ;besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_+snrdec_gt_20_chemsample_IDenis2MASS_9ltIlt12_0.dat';_samplex1_0.dat'
       endif
       ;besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_rave_stn_gt_20_IDenis_9ltIlt12.dat';_samplex1_0.dat'




;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_vrad_vec_helio.dat'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/230-240_20-25/1244196938.938676.dat'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/230-240_-50--40/supergiants.dat'
    end
  end else begin
    if b_with_extinction then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/extinction/l310b5-oldchim.msp1004_mh+snr_with_errors.dat'
;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/with_extinction/besancon_with_extinction_with_errors'
    end else if b_sanjib then begin
      besancondatafile = '/home/azuri/daten/besancon/sanjib_mh+snr_with_errors_height_rcent'
    end else if b_extinction_test then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/extinction/new/besancon_with_extinction_new_mh+snr_with_errors_height_rcent'
    end else begin
;      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_height_rcent_errdivby-1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe.dat'
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_with-errors_errdivby-dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50_vrad-from-uvwlb.dat'
      ;'/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh_with-errors_height_rcent_errdivby-1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe.dat'
      ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_height_rcent_errdivby-dwarfs-1_00-1_48-1_41-1_55-1_00-giants-1_00-1_22-1_26-1_61-1_00-MH-from-FeH-and-aFe_adj-mh.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_height_rcent_errdivby-dwarfs-1_00-1_48-1_41-1_55-1_00_samplex1_9ltI2MASSlt12_calib_logg_0.dat';/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_height_rcent_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00.dat';dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'; --- dist and samplex1
      if b_corrado then $
        besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_with_errors_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00_teff-gt-4000.dat'
                                                              ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-
     ;new+snr-i-dec-giant-dwarf-minus-
     ;ic1_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00.dat'
                                                              ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-
     ;new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_errdivby_1.56_2.37_2.75_1.50_2.00.dat';
                                                              ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_1.56_2.37_2.75_1.50_2.00_snr-ge-20.dat';besancon_all_10x10_230-315_-25-25_JmK_mh+snr-_with_errors_height_rcent_'
      ;besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors_height_rcent'
;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_vrad_vec_rave-lsr_with_errors'
;    if dbl_divide_error_by gt 1. then begin
    end
;    str_temp = strtrim(string(dbl_logg_divide_error_by),2)
;    besancondatafile = besancondatafile+'_errdivby_'+strmid(str_temp,0,4)
;    str_temp = strtrim(string(dbl_mh_divide_error_by),2)
;    besancondatafile = besancondatafile+'_'+strmid(str_temp,0,4)
;    str_temp = strtrim(string(dbl_teff_divide_error_by),2)
;    besancondatafile = besancondatafile+'_'+strmid(str_temp,0,4)
;    str_temp = strtrim(string(dbl_vrad_divide_error_by),2)
;    besancondatafile = besancondatafile+'_'+strmid(str_temp,0,4)
;    str_temp = strtrim(string(dbl_dist_divide_error_by),2)
;    besancondatafile = besancondatafile+'_'+strmid(str_temp,0,4)
;;    endif
;    besancondatafile = besancondatafile+'.dat'
;    if b_corrado then $
;       besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_+snrdec_gt_20_dwarfs+giants_with_errors_errdivby_4.00-1.19_1.10-2.00_4.00-1.80_0.25-2.00_2.00-2.00.dat'
  endelse;if !b_calc_errors then begin
  str_besancondatafile = strmid(besancondatafile,0,strpos(besancondatafile,'/',/REVERSE_SEARCH)+1)+'besancon_temp'
  if (b_giants_only) then begin
    str_besancondatafile = str_besancondatafile+'_giants'
  end else if (b_dwarfs_only) then begin
    str_besancondatafile = str_besancondatafile+'_dwarfs'
  endif
  str_besancondatafile = str_besancondatafile+'.dat'
  spawn,'cp -p '+besancondatafile+' '+str_besancondatafile
;  if b_calc_errors then begin
;    strarr_temp = readfiletostrarr(str_besancondatafile,' ')
;    dblarr_logg_temp = strarr_temp(i_col_logg_besancon,*)
;    strarr_temp = readfilelinestoarr(str_besancondatafile)
;    indarr = where((dblarr_logg_temp ge d_logg_min) and (dblarr_logg_temp lt d_logg_max))
;    if b_dwarfs_only or b_giants_only then begin
;      if b_dwarfs_only then $
;        str_besancondatafile_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH)+1)+'_dwarfs.dat' $
;      else $
;        str_besancondatafile_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH)+1)+'_giants.dat'
;      openw,lun,str_besancondatafile_out
;      for i=0ul, n_elements(indarr)-1 do begin
;        printf,lun,strarr_temp(indarr(i))
;      endfor
;      free_lun,lun
;    endif
;  endif
  str_temp = str_besancondatafile
  str_besancondatafile = besancondatafile
  besancondatafile = str_temp
  str_temp = 0
  print,'rave_besancon_plot_all: besancondatafile = '+besancondatafile
  i_ndatalines = countlines(ravedatafile)
  i_nravelines = i_ndatalines
  print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end

  print,'rave_besancon_plot_all: ravedatafile = ',ravedatafile
;  stop
  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
;  sizea = size(strarr_ravedata_all)
;  print,'rave_besancon_plot_all: strarr_ravedata_all(*,',sizea(2),')=',strarr_ravedata_all(*,sizea(2)-1)
;  stop
  if b_input eq 1 then begin
    strarr_ravedata = strarr(i_ndatalines,6)
  end else begin
    strarr_ravedata = strarr(i_ndatalines,13)
  end
  if b_lonlat eq 1 then begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_lon)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_lat)
  end else begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_ra)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_dec)
  end
  print,'rave_besancon_plot_all: ravedatafile "'+ravedatafile+'" read'

  if b_input eq 1 then begin
    strarr_ravedata(*,2) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
    strarr_ravedata(*,3) = strarr_ravedata_all(*,i_col_rave_j); --- J [mag]
    strarr_ravedata(*,4) = strarr_ravedata_all(*,i_col_rave_k); --- K [mag]
;    print,'rave_besancon_plot_all: strarr_ravedata(0:10,2) = ',strarr_ravedata(0:10,2)
    i_col_rave_i = 2
    i_col_rave_j = 3
    i_col_rave_k = 4
    dblarr_k = double(strarr_ravedata(*,i_col_rave_k))
    dblarr_i = double(strarr_ravedata(*,i_col_rave_i))
    dblarr_imk = dblarr_i - dblarr_k
    strarr_ravedata(*,5) = string(dblarr_imk)
    i_col_rave_imk = 5
;    dblarr_imkrange = [min([min(dblarr_imk),dblarr_imkrange(0)]),max([max(dblarr_imk),dblarr_imkrange(1)])]
;    dblarr_krange = [min([min(dblarr_k),dblarr_krange(0)]),max([max(dblarr_k),dblarr_krange(1)])]
;    openw,lunb,'debug_b_input1_dblarr_k.dat',/GET_LUN
;      printf,lunb,'dblarr_k = ',dblarr_k
;      printf,lunb,'dblarr_krange = ',dblarr_krange
;    free_lun,lunb
    dblarr_k = 0
    dblarr_i = 0
    dblarr_imk = 0
;    print,'rave_besancon_plot_all: strarr_ravedata_all(0,7) = '+strarr_ravedata_all(0,7)
;    print,'rave_besancon_plot_all: dblarr_krange = ',dblarr_krange
;    stop
;  end else if b_dist and not b_calc_errors then begin
;    strarr_ravedata(*,2) = strarr_ravedata_all(*,12); --- I [mag]
;    strarr_ravedata(*,3) = strarr_ravedata_all(*,5) ; --- vrad
;    strarr_ravedata(*,4) = strarr_ravedata_all(*,12); --- I [mag]
;    strarr_ravedata(*,5) = strarr_ravedata_all(*,17) ; --- Teff [K]
;    strarr_ravedata(*,6) = strarr_ravedata_all(*,19); --- [Fe/H]
;    strarr_ravedata(*,7) = strarr_ravedata_all(*,20); --- [alpha/Fe]
;    strarr_ravedata(*,8) = strarr_ravedata_all(*,18); --- log g
;    strarr_ravedata(*,9) = strarr_ravedata_all(*,0); --- ID
;    strarr_ravedata(*,10) = strarr_ravedata_all(*,31); --- SNR
  end else begin
    strarr_ravedata(*,2) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
    strarr_ravedata(*,3) = strarr_ravedata_all(*,i_col_rave_vrad) ; --- vrad
    strarr_ravedata(*,4) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
    strarr_ravedata(*,5) = strarr_ravedata_all(*,i_col_rave_teff) ; --- Teff [K]
    strarr_ravedata(*,6) = strarr_ravedata_all(*,i_col_rave_mh); --- [Fe/H]
    strarr_ravedata(*,7) = strarr_ravedata_all(*,i_col_rave_afe); --- [alpha/Fe]
    strarr_ravedata(*,8) = strarr_ravedata_all(*,i_col_rave_logg); --- log g
    strarr_ravedata(*,9) = strarr_ravedata_all(*,i_col_rave_id); --- ID
    if i_rave_dr eq 7 then begin
      dblarr_rave_stn = double(strarr_ravedata_all(*,i_col_rave_snr))
      dblarr_rave_snr = double(strarr_ravedata_all(*,i_col_rave_stn))
    end else if i_rave_dr eq 8 then begin
      dblarr_rave_stn = double(strarr_ravedata_all(*,i_col_rave_stn))
      dblarr_rave_s2n = double(strarr_ravedata_all(*,i_col_rave_s2n))
      dblarr_rave_snr = double(strarr_ravedata_all(*,i_col_rave_snr))
    end else if i_rave_dr eq 9 then begin
      dblarr_rave_stn = double(strarr_ravedata_all(*,i_col_rave_stn))
      dblarr_rave_s2n = double(strarr_ravedata_all(*,i_col_rave_s2n))
      dblarr_rave_snr = double(strarr_ravedata_all(*,i_col_rave_snr))
    end else if i_rave_dr eq 10 then begin
      dblarr_rave_stn = double(strarr_ravedata_all(*,i_col_rave_stn))
      dblarr_rave_s2n = double(strarr_ravedata_all(*,i_col_rave_s2n))
      dblarr_rave_snr = double(strarr_ravedata_all(*,i_col_rave_snr))
    end
    indarr_snr_temp = where(dblarr_rave_stn lt 0.1)
    if indarr_snr_temp(0) ge 0 then begin
      dblarr_rave_stn(indarr_snr_temp) = dblarr_rave_s2n(indarr_snr_temp)
    endif
    indarr_snr_temp = where(dblarr_rave_stn lt 0.1)
    if indarr_snr_temp(0) ge 0 then begin
      dblarr_rave_stn(indarr_snr_temp) = dblarr_rave_snr(indarr_snr_temp)
    endif
    strarr_ravedata(*,10) = strtrim(string(dblarr_rave_stn),2); --- SNR
    for iiii=0ul, 10 do begin
      print,'strarr_ravedata(0:10,iiii=',iiii,') = ',strarr_ravedata(0:10,iiii)
    endfor
;    stop
    dblarr_rave_stn = 0
    dblarr_rave_s2n = 0
    dblarr_rave_snr = 0
    indarr_snr_temp = 0

    i_col_lon_rave = 0
    i_col_lat_rave = 1
    i_col_i_rave = 2
    i_col_vrad_rave = 3
    i_col_teff_rave = 5
    i_col_mh_rave = 6
    i_col_afe_rave = 7
    i_col_logg_rave = 8
    i_col_id_rave = 9
    i_col_snr_rave = 10

    if b_do_ImV_VmK then begin

      dblarr_tycho_vt = double(strarr_ravedata_all(*,i_col_rave_tycho_vt))
      ;print,'rave_besancon_plot_all: dblarr_tycho_vt = ',dblarr_tycho_vt
      ;stop
      dblarr_tycho_bt = double(strarr_ravedata_all(*,i_col_rave_tycho_bt))
      indarr_tycho_gt_99 = where(dblarr_tycho_vt gt 99. or dblarr_tycho_bt gt 99., COMPLEMENT = indarr_tycho_lt_99)
      dblarr_v = dblarr_tycho_vt -0.090*(dblarr_tycho_bt-dblarr_tycho_vt)
      dblarr_rave_i = double(strarr_ravedata(*,i_col_i_rave))
      dblarr_ImV = dblarr_rave_i - dblarr_v
      strarr_ravedata(*,11) = strtrim(string(dblarr_ImV),2)
      i_col_imv_rave = 11

  ; --- K
      dblarr_2mass_k = double(strarr_ravedata_all(*,i_col_rave_2mass_k))
      dblarr_denis_k = double(strarr_ravedata_all(*,i_col_rave_denis_k))
      indarr_2mass = where(dblarr_2mass_k lt 99., COMPLEMENT=indarr_2mass_k_gt99)
      indarr_denis = where(dblarr_denis_k lt 99., COMPLEMENT=indarr_denis_k_gt99)
  ; --- !!! We don't trust DENIS J and K
      dblarr_rave_k = dblarr_2mass_k
      if indarr_2mass_k_gt99(0) ge 0 then $
        dblarr_rave_k(indarr_2mass_k_gt99) = dblarr_denis_k(indarr_2mass_k_gt99)
      dblarr_VmK = dblarr_v - dblarr_rave_k
      strarr_ravedata(*,12) = strtrim(string(dblarr_VmK),2)
      i_col_vmk_rave = 12

  ; --- J
      dblarr_2mass_j = double(strarr_ravedata_all(*,i_col_rave_2mass_j))
      dblarr_denis_j = double(strarr_ravedata_all(*,i_col_rave_denis_j))
      indarr_2mass_j = where(dblarr_2mass_j lt 99., COMPLEMENT=indarr_2mass_j_gt99)
      indarr_denis_j = where(dblarr_denis_j lt 99., COMPLEMENT=indarr_denis_j_gt99)
  ; --- !!! We don't trust DENIS J and K
      dblarr_rave_j = dblarr_2mass_j
      if indarr_2mass_j_gt99(0) ge 0 then $
        dblarr_rave_j(indarr_2mass_j_gt99) = dblarr_denis_j(indarr_2mass_j_gt99)
      dblarr_JmK = dblarr_rave_j - dblarr_rave_k
      dblarr_ImJ = dblarr_rave_i - dblarr_rave_j
      dblarr_rave_lon = double(strarr_ravedata(*,0))
      dblarr_rave_lat = double(strarr_ravedata(*,1))
      indarr_b_lt_25 = where(dblarr_rave_lon ge 230. and dblarr_rave_lon le 315. and dblarr_rave_lat ge -25. and dblarr_rave_lat le 25.)
      strarr_ravedata(indarr_b_lt_25,11) = strtrim(string(dblarr_ImJ(indarr_b_lt_25)),2)
      strarr_ravedata(indarr_b_lt_25,12) = strtrim(string(dblarr_JmK(indarr_b_lt_25)),2)
      i_col_jmk_rave = 12

      indarr_all_good = where(dblarr_rave_k lt 99. and dblarr_tycho_vt lt 99. and dblarr_tycho_bt lt 99. and dblarr_rave_j lt 99.)
      strarr_ravedata_good_colours = strarr_ravedata(indarr_all_good,*)

      dblarr_tycho_bt = 0
      dblarr_tycho_vt = 0
      dblarr_v = 0
      dblarr_rave_i = 0
      dblarr_rave_j = 0
      dblarr_rave_k = 0
      dblarr_rave_lon = 0
      dblarr_rave_lat = 0
      dblarr_ImV = 0
      dblarr_ImJ = 0
      dblarr_2mass_k = 0
      dblarr_denis_k = 0
      dblarr_2mass_j = 0
      dblarr_denis_j = 0
      indarr_2mass = 0
      indarr_denis = 0
  ;    indarr_k_lt_99 = 0
      indarr_all_good = 0
      dblarr_VmK = 0
      dblarr_JmK = 0
    endif
    if b_colorcut eq 1 then begin
    ; --- RAVE
      dblarr_BT = double(strarr_ravedata_all(*,34))
      dblarr_VT = double(strarr_ravedata_all(*,36))
      dblarr_BV = 0.85 * (dblarr_BT - dblarr_VT)

      i_nelements = n_elements(dblarr_BV)
      indarr = where(abs(dblarr_BT - 99.999) gt 0.01)
      strarr_ravedata = strarr_ravedata(indarr,*)
      dblarr_BV = dblarr_BV(indarr)
      print,'color cut: ',i_nelements-n_elements(indarr),' stars without B-V rejected from RAVE data'
      i_nelements = n_elements(dblarr_BV)

      indarr = where(dblarr_BV gt d_BV_min)
      strarr_ravedata = strarr_ravedata(indarr,*)
      dblarr_BV = dblarr_BV(indarr)
      print,'color cut: ',i_nelements-n_elements(indarr),' stars with B-V < ',d_BV_min,' rejected from RAVE data'
      i_nelements = n_elements(dblarr_BV)

      indarr = where(dblarr_BV lt d_BV_max)
      strarr_ravedata = strarr_ravedata(indarr,*)
      print,'color cut: ',i_nelements-n_elements(indarr),' stars with B-V > ',d_BV_max,' rejected from RAVE data'
    endif
  endelse
  print,'strarr_ravedata(0,0:4) = '+strarr_ravedata(0,0)+' '+strarr_ravedata(0,1)+' '+strarr_ravedata(0,2)+' '+strarr_ravedata(0,3)+' '+strarr_ravedata(0,4)

  if b_one_besanconfile eq 1 then begin
    strarr_besancondata = readfiletostrarr(besancondatafile,$
                                           ' ',$
                                           I_NLINES=i_ndatalines,$
                                           I_NCOLS=i_ncols,$
                                           HEADER=strarr_header)
    print,'rave_besancon_plot_all: besancondatafile "'+besancondatafile+'" read'
    print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines
    if i_ndatalines eq 0 then begin
      problem=1
      return
    end
;    stop
    if b_colorcut eq 1 then begin
      dblarr_BV = double(strarr_besancondata(*,7))
      i_nelements = n_elements(dblarr_BV)

      indarr = where(dblarr_BV gt d_BV_min)
      strarr_besancondata = strarr_besancondata(indarr,*)
      dblarr_BV = dblarr_BV(indarr)
      print,'color cut: ',i_nelements-n_elements(indarr),' stars with B-V < ',d_BV_min,' rejected from Besancon data'
      i_nelements = n_elements(dblarr_BV)

      indarr = where(dblarr_BV lt d_BV_max)
      strarr_besancondata = strarr_besancondata(indarr,*)
      print,'color cut: ',i_nelements-n_elements(indarr),' stars with B-V > ',d_BV_max,' rejected from Besancon data'
    end

;    if strpos(besancondatafile, '+snr-i-dec') lt 0 then $
;      strarr_besancondata(*,i_col_teff_besancon) = strtrim(string(10. ^ double(strarr_besancondata(*,i_col_teff_besancon))),2)


    ; --- log cut
    ; --- RAVE
    if b_log_cut then begin
      if not b_calc_errors then begin
        indarr = where((double(strarr_ravedata(*,8)) ge d_log_min) and (double(strarr_ravedata(*,8)) lt d_log_max))
        print,'rave_besancon_plot_all: size(indarr) = ',size(indarr)
        strarr_ravedata = strarr_ravedata(indarr,*)
        print,'rave_besancon_plot_all: size(strarr_ravedata) = ',size(strarr_ravedata)
      endif

    ; --- Besancon
      indarr = where((double(strarr_besancondata(*,i_col_logg_besancon)) ge d_log_min) and (double(strarr_besancondata(*,i_col_logg_besancon)) lt d_log_max))
      print,'rave_besancon_plot_all: size(indarr) = ',size(indarr)
      strarr_besancondata = strarr_besancondata(indarr,*)
      print,'rave_besancon_plot_all: size(strarr_besancondata) = ',size(strarr_besancondata)
    end







    if b_input eq 1 then begin
      xcol_besancon = i_col_imag_besancon
      ycol_besancon = 3
      icol_besancon = i_col_imag_besancon
      ; --- calculate K from V-I and V-K
      dblarr_i = double(strarr_besancondata(*,icol_besancon))
;      dblarr_vmi = double(strarr_besancondata(*,10))
;      dblarr_v = dblarr_vmi + dblarr_i
      dblarr_imk = double(strarr_besancondata(*,i_col_imk_besancon))
;      dblarr_k = dblarr_v - dblarr_vmk
      dblarr_k = dblarr_i - dblarr_imk
;      strarr_besancondata(*,3) = string(dblarr_k)

;      dblarr_imk = dblarr_i - dblarr_k
      dblarr_imkrange = [min(dblarr_imk),max(dblarr_imk)]
      dblarr_krange = [min(dblarr_k),max(dblarr_k)]
;      strarr_besancondata(*,11) = string(dblarr_imk)

      dblarr_i = 0
;      dblarr_vmi = 0
;      dblarr_v = 0
;      dblarr_vmk = 0
      dblarr_k = 0
      dblarr_imk = 0
    end else begin
      xcol_besancon = 2
      ycol_besancon = 3
      icol_besancon = 2

    ; --- calibrate Metallicities
      dblarr_mH = double(strarr_ravedata(*,6))
      dblarr_aFe = double(strarr_ravedata(*,7))
      dblarr_teff = double(strarr_ravedata(*,5))
      dblarr_logg = double(strarr_ravedata(*,8))
      dblarr_stn = double(strarr_ravedata(*,i_col_snr_rave))

      if b_corrado then begin
        dblarr_MH_calibrated = dblarr_mH
      end else begin
        if i_calibrate_rave_metallicities eq 1 then begin
          strarr_MH_calibrated = string(dblarr_mH + 0.2)
        end else if i_calibrate_rave_metallicities eq 2 then begin
          rave_calibrate_metallicities,dblarr_mH,$
                                       dblarr_aFe,$
                                       DBLARR_LOGG=dblarr_logg,$
                                       REJECTVALUE=99.9,$
                                       REJECTERR=1.,$
                                       OUTPUT=strarr_MH_calibrated
        end else if i_calibrate_rave_metallicities eq 3 then begin
          rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mH,$
                                       I_DBLARR_AFE           = dblarr_aFe,$
                                       I_DBLARR_TEFF          = dblarr_teff,$
                                       I_DBL_REJECTVALUE      = 99.9,$
                                       I_DBL_REJECTERR        = 1.,$
                                       O_STRARR_MH_CALIBRATED = strarr_MH_calibrated
        end else if i_calibrate_rave_metallicities eq 4 then begin
          rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mH,$
                                       I_DBLARR_AFE           = dblarr_aFe,$
                                       I_DBLARR_TEFF          = dblarr_teff,$
                                       I_DBLARR_LOGG          = dblarr_logg,$
                                       I_DBLARR_STN           = dblarr_stn,$
                                       I_DBL_REJECTVALUE      = 99.9,$
                                       I_DBL_REJECTERR        = 1.,$
                                       O_STRARR_MH_CALIBRATED = strarr_MH_calibrated,$
                                       I_B_SEPARATE           = 1
        end
        if i_calibrate_rave_metallicities eq 0 then begin
          dblarr_MH_calibrated = dblarr_mH
        end else begin
          dblarr_MH_calibrated = double(strarr_MH_calibrated)
          strarr_MH_calibrated = 0
        endelse
;  openw,lun,'MH_calibrated_hist.text',/GET_LUN
;  for i=0UL,n_elements(dblarr_MH_calibrated)-1 do begin
;    printf,lun,dblarr_MH_calibrated(i)
;  endfor
;  free_lun,lun
      end
      strarr_ravedata(*,6) = string(dblarr_MH_calibrated)
      dblarr_MH_calibrated = 0

; --- add noise
      if b_calc_errors then begin

; --- get SNR for Besancon stars

        if b_calc_mh then begin
; --- calculate Besancon Metallicities
          dblarr_besancon_feh = double(strarr_besancondata(*,i_col_feh_besancon))
          dblarr_besancon_logg = double(strarr_besancondata(*,i_col_logg_besancon))
          besancon_calculate_mh,I_DBLARR_FEH  = dblarr_besancon_feh,$
                                O_DBLARR_MH   = dblarr_besancon_mh,$
                                I_B_MINE      = 1,$
                                I_DBLARR_LOGG = dblarr_besancon_logg
          strarr_besancondata(*,i_col_feh_besancon) = string(dblarr_besancon_mh)
          dblarr_besancon_feh = 0
        endif

        if b_calc_snr or b_calc_snr_again then begin
          dblarr_snr_besancon = dblarr(n_elements(strarr_besancondata(*,0)))

          euler,double(strarr_besancondata(*,i_col_lon_besancon)),double(strarr_besancondata(*,i_col_lat_besancon)),dblarr_ra_besancon,dblarr_dec_besancon,SELECT=2
          dblarr_ra_besancon = 0
          euler,double(strarr_ravedata(*,0)),double(strarr_ravedata(*,1)),dblarr_ra_rave,dblarr_dec_rave,SELECT=2
          dblarr_ra_rave = 0

          if int_which_get_snr eq 1 then begin

          end else if int_which_get_snr eq 2 then begin
            besancon_get_snr_i_dec,STRARR_BESANCONDATA = strarr_besancondata,$
                                   STRARR_RAVEDATA     = strarr_ravedata,$
                                   I_COL_I_BESANCON    = i_icol_besancon,$
                                   I_COL_I_RAVE        = i_col_i_rave,$
                                   DBLARR_DEC_BESANCON = dblarr_dec_besancon,$
                                   DBLARR_DEC_RAVE     = dblarr_dec_rave,$
                                   I_COL_SNR_RAVE      = i_col_snr_rave,$
                                   DBLARR_SNR_BESANCON = dblarr_snr_besancon,$
                                   DBL_SEED=dbl_seed,$
                                   DBL_MAXDIFF_I = dbl_snr_maxdiff_i,$
                                   DBL_MAXDIFF_DEC = dbl_snr_maxdiff_dec
          end else if int_which_get_snr eq 3 then begin
            besancon_get_snr_i_dec_logg,STRARR_BESANCONDATA = strarr_besancondata,$
                                        STRARR_RAVEDATA     = strarr_ravedata,$
                                        I_COL_I_BESANCON    = i_icol_besancon,$
                                        I_COL_I_RAVE        = i_col_i_rave,$
                                        I_COL_LOGG_BESANCON = i_col_logg_besancon,$
                                        I_COL_LOGG_RAVE     = i_col_logg_rave,$
                                        DBLARR_DEC_BESANCON = dblarr_dec_besancon,$
                                        DBLARR_DEC_RAVE     = dblarr_dec_rave,$
                                        I_COL_SNR_RAVE      = i_col_snr_rave,$
                                        DBLARR_SNR_BESANCON = dblarr_snr_besancon,$
                                        DBL_SEED            = dbl_seed,$
                                        DBL_MAXDIFF_I       = dbl_snr_maxdiff_i,$
                                        DBL_MAXDIFF_DEC     = dbl_snr_maxdiff_dec,$
                                        DBL_MAXDIFF_LOGG    = dbl_snr_maxdiff_logg
          end else begin
            besancon_get_snr_i_dec_giant_dwarf,I_STRARR_BESANCONDATA = strarr_besancondata,$
                                               I_STRARR_RAVEDATA     = strarr_ravedata,$
                                               I_INT_COL_I_BESANCON    = i_icol_besancon,$
                                               I_INT_COL_I_RAVE        = i_col_i_rave,$
                                               I_INT_COL_LOGG_BESANCON = i_col_logg_besancon,$
                                               I_INT_COL_LOGG_RAVE     = i_col_logg_rave,$
                                               I_DBLARR_DEC_BESANCON = dblarr_dec_besancon,$
                                               I_INT_COL_DEC_BESANCON = dblarr_dec_besancon,$
                                               I_DBLARR_DEC_RAVE     = dblarr_dec_rave,$
                                               I_INT_COL_DEC_RAVE     = dblarr_dec_rave,$
                                               I_INT_COL_SNR_RAVE      = i_col_snr_rave,$
                                               O_DBLARR_SNR_BESANCON = dblarr_snr_besancon,$
                                               I_DBL_SEED            = dbl_seed,$
                                               I_DBL_MAXDIFF_I       = dbl_snr_maxdiff_i,$
                                               I_DBL_MAXDIFF_DEC     = dbl_snr_maxdiff_dec
          endelse
          dblarr_dec_besancon = 0

        endif
        if b_calc_snr or b_calc_mh or b_calc_snr_again then begin
          if b_calc_snr_again then begin
            i_loop_end = 0
          end else begin
            i_loop_end = 1
          end
          for iii=0,i_loop_end do begin
            if b_calc_snr_again then begin
              if b_calc_mh then begin
                str_snrfilename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))+'_mh-new+snr'
              end else begin
                str_snrfilename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))+'_snr'
              end
            end else begin
              str_snrfilename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))+'_+snr'
            end
            if int_which_get_snr eq 1 then begin
              str_snrfilename_out = str_snrfilename_out+'-i'
            end else if int_which_get_snr eq 2 then begin
              str_snrfilename_out = str_snrfilename_out+'-i-dec'
            end else if int_which_get_snr eq 3 then begin
              str_snrfilename_out = str_snrfilename_out+'-i-dec-logg'
            end else begin
              str_snrfilename_out = str_snrfilename_out+'-i-dec-giant-dwarf'
            end
            if (strpos(ravedatafile,'minus-ic1') ge 0) or (strpos(ravedatafile,'minus_ic1') ge 0) then $
              str_snrfilename_out = str_snrfilename_out + '-minus-ic1'
            if iii eq 1 then begin
              str_snrfilename_out = str_snrfilename_out+'-gt-20'
            endif
            str_snrfilename_out = str_snrfilename_out + '.dat'
            openw,lune,str_snrfilename_out,/GET_LUN
              intarr_size = size(strarr_besancondata)
              if n_elements(strarr_header) gt 0 then begin
                for ll = 0ul, n_elements(strarr_header) - 1 do begin
                  printf,lune,strarr_header(ll)
                endfor
              endif
              for ll=0ul,intarr_size(1)-1 do begin
                str_line = strarr_besancondata(ll,0)
                if b_calc_snr_again then begin
                  for mm=1ul,intarr_size(2)-2 do begin
                    str_line = str_line + ' ' + strarr_besancondata(ll,mm)
                  endfor
                end else begin
                  for mm=1ul,intarr_size(2)-1 do begin
                    str_line = str_line + ' ' + strarr_besancondata(ll,mm)
                  endfor
                end
                str_line = str_line + ' ' + string(dblarr_snr_besancon(ll))
                                                                                                                                                                                                                                                                ;                print,'rave_besancon_plot_all: printing line ll=',ll,' = '+str_line
                if iii eq 0 or dblarr_snr_besancon(ll) ge 20. then $
                  printf,lune,str_line
              endfor
            free_lun,lune
          endfor
          return
        end else begin
          dblarr_snr_besancon = double(strarr_besancondata(*,i_col_snr_besancon))
        end

;        dbl_seed = 5.
        dbl_i_seed = 1.

        dblarr_besancon_mh = double(strarr_besancondata(*,i_col_feh_besancon))
        dblarr_besancon_logg = double(strarr_besancondata(*,i_col_logg_besancon))
        dblarr_besancon_i = double(strarr_besancondata(*,i_col_imag_besancon))
        dblarr_besancon_teff = 10. ^ double(strarr_besancondata(*,i_col_teff_besancon))
        print,'rave_besancon_plot_all: dblarr_besancon_teff(0:9) = ',dblarr_besancon_teff(0:9)

        for pp = 0, 2 do begin
          if pp eq 0 then begin; --- Teff
;            dblarr_temp = dblarr_besancon_teff
            dbl_divide_error_by = dbl_teff_divide_error_by
            b_teff = 1
            b_logg = 0
            b_mh = 0
          end else if pp eq 1 then begin; --- logg
;            dblarr_temp = dblarr_besancon_logg
            dbl_divide_error_by = dbl_logg_divide_error_by
            b_teff = 0
            b_logg = 1
            b_mh = 0
          end else begin; --- [M/H]
;            dblarr_temp = dblarr_besancon_mh
            dbl_divide_error_by = dbl_mh_divide_error_by
            b_teff = 0
            b_logg = 0
            b_mh = 1
          end

; --- log Teff
;        str_sigma_filename = '/rave/sigma_teff.rez'

;        dblarr_teff_sigma = readfiletodblarr(str_sigma_filename)
;        print,'add_noise_test: dblarr_teff_sigma = ',dblarr_teff_sigma
;        print,'add_noise_test: size(dblarr_teff_sigma) = ',size(dblarr_teff_sigma)
;        print,'add_noise_test: n_elements(dblarr_teff_sigma(*,0)) = ',n_elements(dblarr_teff_sigma(*,0))
;        print,'add_noise_test: n_elements(dblarr_teff_sigma(0,*)) = ',n_elements(dblarr_teff_sigma(0,*))
;        dblarr_teff_sigma(*,3) = dblarr_teff_sigma(*,3) * (10.^dblarr_teff_sigma(*,2))
        ;print,'add_noise_test: dblarr_teff_sigma = ',dblarr_teff_sigma

;        dbl_k = -0.848;,$;              --- double
;        print,'rave_besancon_plot_all: size(dblarr_teff_temp) = ',size(dblarr_teff_temp)
          if not(b_corrado) or (b_corrado and pp lt 2) then begin
            o_dblarr_err = 1
            o_dblarr_data = 1
;        o_dblarr_snr_teff = dblarr(n_elements(dblarr_teff))
            rave_besancon_calc_errors,B_TEFF = b_teff,$
                                      B_LOGG = b_logg,$
                                      B_MH = b_mh,$
                                      O_DBLARR_DATA  = o_dblarr_data,$;        --- vector(n)
                                      O_DBLARR_ERR = o_dblarr_err,$;       --- vector(n)
                                      DBLARR_SNR = dblarr_snr_besancon,$; --- O: vector(n)
                                      DBLARR_TEFF  = dblarr_besancon_teff,$;        --- vector(n)
                                      DBLARR_MH    = dblarr_besancon_mh,$;          --- vector(n)
                                      DBLARR_LOGG  = dblarr_besancon_logg,$;        --- vector(n)
                                      DBL_DIVIDE_ERROR_BY = dbl_divide_error_by
            if pp eq 0 then begin; --- Teff
              dblarr_teff_temp = o_dblarr_data
;            dblarr_besancon_teff = dblarr_temp
            end else if pp eq 1 then begin; --- logg
              dblarr_logg_temp = o_dblarr_data
;            dblarr_besancon_logg = dblarr_temp
            end else begin; --- [M/H]
              dblarr_mh_temp = o_dblarr_data
;            dblarr_besancon_mh = dblarr_temp
            end
          endif
        endfor
        o_dblarr_err = 0
        o_dblarr_data = 0

      ; --- vrad
        dblarr_temp = double(strarr_besancondata(*,i_col_vrad_besancon))
        add_noise,IO_DBLARR_DATA        = dblarr_temp,$
                  I_DBL_SIGMA           = 2.2,$
                  IO_DBL_SEED           = dbl_seed,$
                  I_DBL_DIVIDE_ERROR_BY = dbl_vrad_divide_error_by

        if b_corrado then begin
          indarr_besancon_snr_le_40 = where(dblarr_snr_besancon le 40., COMPLEMENT = indarr_besancon_snr_gt_40)
          dblarr_mh_bes_le_40 = dblarr_besancon_mh(indarr_besancon_snr_le_40)
          add_noise,DBLARR_DATA = dblarr_mh_bes_le_40,$
                    DBL_SIGMA = 0.25,$
                    DBL_SEED = dbl_seed,$
                    DBL_DIVIDE_ERROR_BY = dbl_mh_divide_error_by
          dblarr_besancon_mh(indarr_besancon_snr_le_40) = dblarr_mh_bes_le_40
          dblarr_mh_bes_le_40 = 0

          dblarr_mh_bes_gt_40 = dblarr_besancon_mh(indarr_besancon_snr_gt_40)
          add_noise,DBLARR_DATA = dblarr_mh_bes_gt_40,$
                    DBL_SIGMA = 0.175,$
                    DBL_SEED = dbl_seed,$
                    DBL_DIVIDE_ERROR_BY = dbl_mh_divide_error_by
          dblarr_besancon_mh(indarr_besancon_snr_gt_40) = dblarr_mh_bes_gt_40
          dblarr_mh_bes_gt_40 = 0
          indarr_besancon_snr_gt_40 = 0
          indarr_besancon_snr_le_40 = 0
          dblarr_mh_temp = dblarr_besancon_mh
        endif

        dblarr_besancon_mh = 0
        dblarr_besancon_logg = 0
        dblarr_besancon_teff = 0
        dblarr_besancon_i = 0
        dblarr_i_sn_rave = 0
        dblarr_teff_sigma = 0

      ; --- write new data to data array
;        if strpos(besancondatafile, '+snr-i-dec') lt 0 then begin
;          strarr_besancondata(*,i_col_teff_besancon) = string(alog10(dblarr_teff_temp))
;        end else begin
          strarr_besancondata(*,i_col_teff_besancon) = string(dblarr_teff_temp)
;        end
        strarr_besancondata(*,i_col_logg_besancon) = string(dblarr_logg_temp)
        strarr_besancondata(*,i_col_feh_besancon) = string(dblarr_mh_temp)
        strarr_besancondata(*,i_col_vrad_besancon) = string(dblarr_temp)

        dblarr_temp = 0
        dblarr_logg_temp = 0
        dblarr_mh_temp = 0
        dblarr_teff_temp = 0

      ; --- write data array to new data file
        str_filename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))
        if b_giants_only then begin
          str_filename_out = str_filename_out + '_giants'
        end
        if b_dwarfs_only then begin
          str_filename_out = str_filename_out + '_dwarfs'
        endif
        str_filename_out = str_filename_out+'_with_errors'
;        if dbl_divide_error_by gt 1. then begin
        str_temp = strtrim(string(dbl_logg_divide_error_by),2)
;        if b_corrado then $
;          str_filename_out = str_filename_out+'_chem'
        str_filename_out = str_filename_out+'_errdivby_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_mh_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_teff_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_vrad_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)
          ;        endif
        ;str_filename_out_b = str_filename_out + '+snr.dat'

        str_filename_out = str_filename_out + '.dat'
        openw,lund,str_filename_out,/GET_LUN
        ;  if b_calc_snr then begin
        ;    openw,lune,str_filename_out_b,/GET_LUN
        ;  endif
          intarr_size = size(strarr_besancondata)
          if n_elements(strarr_header) gt 0 then begin
            for ll=0ul,n_elements(strarr_header) - 1 do begin
              printf,lund,strarr_header(ll)
            endfor
          endif
          for ll=0ul,intarr_size(1)-1 do begin
            str_line = strarr_besancondata(ll,0)
            for mm=1ul,intarr_size(2)-1 do begin
              str_line = str_line + ' ' + strarr_besancondata(ll,mm)
            endfor
            print,'rave_besancon_plot_all: printing line ll=',ll,' = '+str_line
            printf,lund,str_line
        ;    if b_calc_snr then begin
        ;      str_line_b = str_line + ' ' + string(dblarr_snr_besancon(ll)); + ' ' + string(o_dblarr_err_teff(ll)) +' '+string(o_dblarr_err_mh(ll)) + ' ' +string(o_dblarr_err_logg(ll))
        ;      printf,lune,str_line_b
        ;    endif
          endfor
;          o_dblarr_err_teff = 0
;          o_dblarr_err_mh = 0
;          o_dblarr_err_logg = 0
;          o_dblarr_snr_teff = 0
;          o_dblarr_snr_mh = 0
;          o_dblarr_snr_logg = 0
         ; if b_calc_snr then $
         ;   free_lun,lune
        free_lun,lund
      endif
    end
  end else begin
    strarr_besancondata = 0
    xcol_besancon = i_col_imag_besancon
    ycol_besancon = 15
    icol_besancon = i_col_imag_besancon
    if xcol_besancon eq 0 then $
      xcol_besancon = 0.0001
    if ycol_besancon eq 0 then $
      ycol_besancon = 0.0001
    if icol_besancon eq 0 then $
      icol_besancon = 0.0001
  end
  strarr_ravedata_all = 0

  ; --- plot v_rad vs I
  ; 12 -> 2
  ; 5 -> 3
  ; 7 -> 5
  ; 19 -> 6

  if b_input then begin
    b_i_search = 0

    if b_do_I_K then begin
      ; --- plot vrad over I for I=9.-12.
      xcol_besancon = i_col_imag_besancon
      ycol_besancon = i_col_kmag_besancon
      icol_besancon = i_col_imag_besancon
      if xcol_besancon eq 0 then $
        xcol_besancon = 0.0001
      if ycol_besancon eq 0 then $
        ycol_besancon = 0.0001
      if icol_besancon eq 0 then $
        icol_besancon = 0.0001
      dbl_xmax = dbl_xmax_I
      dbl_ymax = dbl_xmax_vrad
      yrangeset = dblarr_krange
      irange = [9.,12.]
      spawn,'mkdir '+str_path+'I_K/I9.00-12.0/'
      openw,luna,str_path+'I_K/I9.00-12.0/debug_I_K_I9-12.text',/GET_LUN
        printf,luna,'besancon_rave_plot_two_cols,PATH=str_path=',str_path
        printf,luna,'                            SUBPATH=I_K'
        printf,luna,'                            RAVEDATAFILE=ravedatafile=',ravedatafile
        printf,luna,'                            BESANCONDATAFILE=besancondatafile=',besancondatafile
        printf,luna,'                            STRARR_RAVE_DATA=strarr_ravedata'
        printf,luna,'                            STRARR_BESANCON_DATA=strarr_besancondata'
        printf,luna,'                            FIELDSFILE=fieldsfile=',fieldsfile
        printf,luna,'                            XCOLRAVE=2'
        printf,luna,'                            XCOLBESANCON=xcol_besancon=',xcol_besancon
        printf,luna,'                            XTITLE=I [mag]'
        printf,luna,'                            XRANGESET=irange=',irange
        printf,luna,'                            YCOLRAVE=4'
        printf,luna,'                            YCOLBESANCON=ycol_besancon=',ycol_besancon
        printf,luna,'                            YTITLE=K [mag]'
        printf,luna,'                            YRANGESET=yrangeset=',yrangeset
        printf,luna,'                            IRANGE=irange=',irange
        printf,luna,'                            ICOLRAVE=2'
        printf,luna,'                            ICOLBESANCON=icol_besancon=',icol_besancon
        printf,luna,'                            FORCEXRANGE=1'
        printf,luna,'                            FORCEYRANGE=0'
        printf,luna,'                            REJECTVALUEX=15'
        printf,luna,'                            REJECTVALUEY=100000.'
        printf,luna,'                            LONLAT=b_lonlat=',b_lonlat
        printf,luna,'                            CALCSAMPLES=b_calcsamples=',b_calcsamples
        printf,luna,'                            I_NSAMPLES=i_nsamples=',i_nsamples
        printf,luna,'                            XYTITLE=[Imag,Kmag]'
        printf,luna,'                            B_HIST=1'
        printf,luna,'                            STAR_TYPES_COL=int_col_star_types=',int_col_star_types
        printf,luna,'                            B_CALCNBINS=b_calcnbins=',b_calcnbins
        printf,luna,'                            NBINSMIN=nbinsmin=',nbinsmin
        printf,luna,'                            NBINSMAX=nbinsmax=',nbinsmax
        printf,luna,'                            B_I_SEARCH=b_i_search=',b_i_search
      free_lun,luna
      dbl_xmax = dbl_xmax_I
      dbl_ymax = dbl_xmax_I
      besancon_rave_plot_two_cols,PATH                 = str_path,$
                                  SUBPATH              = 'I_K',$
                                  RAVEDATAFILE         = ravedatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                  BESANCONDATAFILE     = besancondatafile,$
                                  STRARR_RAVE_DATA     = strarr_ravedata,$
                                  STRARR_BESANCON_DATA = strarr_besancondata,$
                                  FIELDSFILE           = fieldsfile,$
                                  XCOLRAVE             = 2,$
                                  XCOLBESANCON         = xcol_besancon,$
                                  XTITLE               = 'I [mag]',$
                                  XRANGESET            = irange,$
                                  YCOLRAVE             = 4,$
                                  YCOLBESANCON         = ycol_besancon,$
                                  YTITLE               = 'K [mag]',$
                                  YRANGESET            = yrangeset,$
                                  IRANGE               = irange,$
                                  ICOLRAVE             = 2,$
                                  ICOLBESANCON         = icol_besancon,$
                                  FORCEXRANGE          = 1,$
                                  FORCEYRANGE          = 0,$
                                  REJECTVALUEX         = 15,$
                                  REJECTVALUEY         = 100000.,$
                                  LONLAT               = b_lonlat,$
                                  CALCSAMPLES          = b_calcsamples,$
                                  I_NSAMPLES           = i_nsamples,$
                                  XYTITLE              = ['Imag','Kmag'],$
                                  B_HIST               = 1,$
                                  B_POP_ID             = b_pop_id,$
                                  STAR_TYPES_COL       = int_col_star_types,$
                                  B_CALCNBINS          = b_calcnbins,$
                                  NBINSMIN             = nbinsmin,$
                                  NBINSMAX             = nbinsmax,$
                                  B_I_SEARCH           = b_i_search,$
                                  DBL_XMAX             = dbl_xmax,$
                                  DBL_YMAX             = dbl_ymax,$
                                  B_PLOT_MEAN_KST      = b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
    end

    ; --- I-K over I
    if b_do_I_ImK then begin
      strarr_besancondata_colours = strarr(3,n_elements(strarr_besancondata(*,0)))
      strarr_besancondata_colours(0,*) = strarr_besancondata(*,i_col_imag_besancon)
      strarr_besancondata_colours(1,*) = strarr_besancondata(*,i_col_imag_besancon)
      strarr_besancondata_colours(2,*) = strtrim(string(double(strarr_besancondata(*,i_col_imag_besancon)) - double(strarr_besancondata(*,i_col_kmag_besancon))),2)
      icol_besancon = 0
      xcol_besancon = 1
      ycol_besancon = 2
      if xcol_besancon eq 0 then $
        xcol_besancon = 0.0001
      if ycol_besancon eq 0 then $
        ycol_besancon = 0.0001
      if icol_besancon eq 0 then $
        icol_besancon = 0.0001
      irange = [9.,12.]
      xrangeset = irange
      yrangeset = dblarr_imkrange
      dbl_xmax = dbl_xmax_I
      dbl_ymax = dbl_xmax_I
      spawn,'mkdir '+str_path+'I_ImK/'
      spawn,'mkdir '+str_path+'I_ImK/I9.00-12.0/'
      openw,luna,str_path+'I_ImK/I9.00-12.0/debug_I_ImK_I9-12.text',/GET_LUN
        printf,luna,'besancon_rave_plot_two_cols,PATH=str_path=',str_path
        printf,luna,'                            SUBPATH=I_ImK'
        printf,luna,'                            RAVEDATAFILE=ravedatafile=',ravedatafile
        printf,luna,'                            BESANCONDATAFILE=besancondatafile=',besancondatafile
        printf,luna,'                            STRARR_RAVE_DATA=strarr_ravedata'
        printf,luna,'                            STRARR_BESANCON_DATA=strarr_besancondata_colours'
        printf,luna,'                            FIELDSFILE=fieldsfile=',fieldsfile
        printf,luna,'                            XCOLRAVE=2'
        printf,luna,'                            XCOLBESANCON=xcol_besancon=',xcol_besancon
        printf,luna,'                            XTITLE=I [mag]'
        printf,luna,'                            XRANGESET=irange=',irange
        printf,luna,'                            YCOLRAVE=4'
        printf,luna,'                            YCOLBESANCON=ycol_besancon=',ycol_besancon
        printf,luna,'                            YTITLE=I-K [mag]'
        printf,luna,'                            YRANGESET=yrangeset=',yrangeset
        printf,luna,'                            IRANGE=irange=',irange
        printf,luna,'                            ICOLRAVE=2'
        printf,luna,'                            ICOLBESANCON=icol_besancon=',icol_besancon
        printf,luna,'                            FORCEXRANGE=1'
        printf,luna,'                            FORCEYRANGE=0'
        printf,luna,'                            REJECTVALUEX=15'
        printf,luna,'                            REJECTVALUEY=100000.'
        printf,luna,'                            LONLAT=b_lonlat=',b_lonlat
        printf,luna,'                            CALCSAMPLES=b_calcsamples=',b_calcsamples
        printf,luna,'                            I_NSAMPLES=i_nsamples=',i_nsamples
        printf,luna,'                            XYTITLE=[Imag,ImKmag]'
        printf,luna,'                            B_HIST=1'
        printf,luna,'                            STAR_TYPES_COL=int_col_star_types=',int_col_star_types
        printf,luna,'                            B_CALCNBINS=b_calcnbins=',b_calcnbins
        printf,luna,'                            NBINSMIN=nbinsmin=',nbinsmin
        printf,luna,'                            NBINSMAX=nbinsmax=',nbinsmax
        printf,luna,'                            B_I_SEARCH=b_i_search=',b_i_search
      free_lun,luna
      besancon_rave_plot_two_cols,PATH=str_path,$
                                  SUBPATH='I_ImK',$
                                  RAVEDATAFILE=ravedatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                  BESANCONDATAFILE=besancondatafile,$
                                  STRARR_RAVE_DATA=strarr_ravedata,$
                                  STRARR_BESANCON_DATA=strarr_besancondata_colours,$
                                  FIELDSFILE=fieldsfile,$
                                  XCOLRAVE=2,$
                                  XCOLBESANCON=xcol_besancon,$
                                  XTITLE='I [mag]',$
                                  XRANGESET=irange,$
                                  YCOLRAVE=5,$
                                  YCOLBESANCON=ycol_besancon,$
                                  YTITLE='I-K [mag]',$
                                  YRANGESET=yrangeset,$
                                  IRANGE=irange,$
                                  ICOLRAVE=2,$
                                  ICOLBESANCON=icol_besancon,$
                                  FORCEXRANGE=1,$
                                  FORCEYRANGE=0,$
                                  REJECTVALUEX=15,$
                                  REJECTVALUEY=100000.,$
                                  LONLAT=b_lonlat,$
                                  CALCSAMPLES=b_calcsamples,$
                                  I_NSAMPLES=i_nsamples,$
                                  XYTITLE=['Imag','ImKmag'],$
                                  B_HIST=1,$
                                  B_POP_ID             = b_pop_id,$
                                  STAR_TYPES_COL=int_col_star_types,$
                                  B_CALCNBINS=b_calcnbins,$
                                  NBINSMIN=nbinsmin,$
                                  NBINSMAX=nbinsmax,$
                                  B_I_SEARCH=b_i_search,$
                                  DBL_XMAX=dbl_xmax,$
                                  DBL_YMAX=dbl_ymax,$
                                  B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      strarr_besancondata_colours = 0
    end
  end else begin

  ; --- plot V-K vs. I-V for I=9.-12.
  if b_do_ImV_VmK then begin
    irange = [9.,12.]
    str_path_temp = str_path+'ImV_VmK/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
;    openw,luna,str_path_temp+'debug_ImV_VmK_I9-12.text',/GET_LUN
;      printf,luna,'besancon_rave_plot_two_cols,PATH=str_path=',str_path
;      printf,luna,'                            SUBPATH=I_vrad'
;      printf,luna,'                            RAVEDATAFILE=ravedatafile=',ravedatafile
;      printf,luna,'                            BESANCONDATAFILE=besancondatafile=',besancondatafile
;      printf,luna,'                            STRARR_RAVE_DATA=strarr_ravedata'
;      printf,luna,'                            STRARR_BESANCON_DATA=strarr_besancondata'
;      printf,luna,'                            FIELDSFILE=fieldsfile=',fieldsfile
;      printf,luna,'                            XCOLRAVE=2'
;      printf,luna,'                            XCOLBESANCON=xcol_besancon=',xcol_besancon
;      printf,luna,'                            XTITLE=I [mag]'
;      printf,luna,'                            XRANGESET=irange=',irange
;      printf,luna,'                            YCOLRAVE=3'
;      printf,luna,'                            YCOLBESANCON=ycol_besancon=',ycol_besancon
;      printf,luna,'                            YTITLE=Radial Velocity [km/s]'
;      printf,luna,'                            YRANGESET=yrangeset=',yrangeset
;      printf,luna,'                            IRANGE=irange=',irange
;      printf,luna,'                            ICOLRAVE=4'
;      printf,luna,'                            ICOLBESANCON=icol_besancon=',icol_besancon
;      printf,luna,'                            FORCEXRANGE=1'
;      printf,luna,'                            FORCEYRANGE=0'
;      printf,luna,'                            REJECTVALUEX=15'
;      printf,luna,'                            REJECTVALUEY=100000.'
;      printf,luna,'                            LONLAT=b_lonlat=',b_lonlat
;      printf,luna,'                            CALCSAMPLES=b_calcsamples=',b_calcsamples
;      printf,luna,'                            I_NSAMPLES=i_nsamples=',i_nsamples
;      printf,luna,'                            XYTITLE=[Imag,vrad]'
;      printf,luna,'                            B_HIST=1'
;      printf,luna,'                            STAR_TYPES_COL=int_col_star_types=',int_col_star_types
;      printf,luna,'                            B_CALCNBINS=b_calcnbins=',b_calcnbins
;      printf,luna,'                            NBINSMIN=nbinsmin=',nbinsmin
;      printf,luna,'                            NBINSMAX=nbinsmax=',nbinsmax
;      printf,luna,'                            B_I_SEARCH=b_i_search=',b_i_search
;    free_lun,luna

    strarr_besancondata_colours = strarr(n_elements(strarr_besancondata(*,0)),7)

    ; --- LON
    strarr_besancondata_colours(*,0) = strarr_besancondata(*,i_col_lon_besancon)

    ; --- LAT
    strarr_besancondata_colours(*,1) = strarr_besancondata(*,i_col_lat_besancon)

    ; --- Imag
    strarr_besancondata_colours(*,2) = strarr_besancondata(*,i_col_imag_besancon)

    ; --- I-V
    strarr_besancondata_colours(*,3) = strtrim(string(double(strarr_besancondata(*,i_col_imag_besancon)) - double(strarr_besancondata(*,i_col_vjmag_besancon))),2)

    ; --- V-K
    strarr_besancondata_colours(*,4) = strtrim(string(double(strarr_besancondata(*,i_col_vjmag_besancon)) - double(strarr_besancondata(*,i_col_kmag_besancon))),2)

    ; --- star types
    strarr_besancondata_colours(*,5) = strarr_besancondata(*,int_col_star_types)

    ; --- log g
    strarr_besancondata_colours(*,6) = strarr_besancondata(*,i_col_logg_besancon)

    print,'strarr_besancondata_colours(0:10,*) = '
    print,strarr_besancondata_colours(0:10,*)
;    stop

;    icol_lon_bes  = 0.00001
;    icol_lat_bes  = 1
    icol_besancon = 2
    xcol_besancon = 4
    ycol_besancon = 3
    typecol_besancon = 5
    if xcol_besancon eq 0 then $
      xcol_besancon = 0.0001
    if ycol_besancon eq 0 then $
      ycol_besancon = 0.0001
    if icol_besancon eq 0 then $
      icol_besancon = 0.0001

    dbl_xmin = min(double(strarr_besancondata_colours(*,xcol_besancon)))
    dbl_xmax = max(double(strarr_besancondata_colours(*,xcol_besancon)))
    dbl_ymin = min(double(strarr_besancondata_colours(*,ycol_besancon)))
    dbl_ymax = max(double(strarr_besancondata_colours(*,ycol_besancon)))
    xrangeset = [long(dbl_xmin),long(dbl_xmax)+1]
    yrangeset = [long(dbl_ymin),long(dbl_ymax)+1]

    besancon_rave_plot_two_cols,PATH                 = str_path,$
                                SUBPATH              = 'ImV_VmK',$
                                RAVEDATAFILE         = ravedatafile,$
                                BESANCONDATAFILE     = besancondatafile,$
                                I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_RAVE_DATA     = strarr_ravedata_good_colours,$
                                STRARR_BESANCON_DATA = strarr_besancondata_colours,$
                                FIELDSFILE           = fieldsfile,$
                                XCOLRAVE             = i_col_imv_rave,$
                                XCOLBESANCON         = xcol_besancon,$
                                XTITLE               = 'V-K [mag] (J-K [mag])',$
                                XRANGESET            = xrangeset,$
                                YCOLRAVE             = i_col_vmk_rave,$
                                YCOLBESANCON         = ycol_besancon,$
                                YTITLE               = 'I-V [mag] (I-J [mag])',$
                                YRANGESET            = yrangeset,$
                                IRANGE               = irange,$
                                ICOLRAVE             = 4,$
                                ICOLBESANCON         = icol_besancon,$
                                FORCEXRANGE          = 0,$
                                FORCEYRANGE          = 0,$
                                REJECTVALUEX         = 15,$
                                REJECTVALUEY         = 100000.,$
                                LONLAT               = b_lonlat,$
                                CALCSAMPLES          = b_calcsamples,$
                                I_NSAMPLES           = i_nsamples,$
                                XYTITLE              = ['V-K','I-V'],$
                                B_HIST               = 1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL       = typecol_besancon,$
                                B_CALCNBINS          = b_calcnbins,$
                                NBINSMIN             = nbinsmax,$;nbinsmin,$
                                NBINSMAX             = nbinsmax,$
                                B_I_SEARCH           = b_i_search,$
                                DBL_XMAX             = dbl_xmax,$
                                DBL_YMAX             = dbl_ymax,$
                                B_PLOT_MEAN_KST      = b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
;                              TEST=1
      strarr_besancondata_colours = 0
  endif

  ; --- plot vrad over I for I=9.-12.
  yrangeset = [-200.,200.]
  dbl_xmax = dbl_xmax_I
  dbl_ymax = dbl_xmax_vrad
  if b_do_I_vrad_9_12 then begin
    irange = [9.,12.]
    str_path_temp = str_path+'I_vrad/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
    openw,luna,str_path_temp+'debug_I_vrad_I9-12.text',/GET_LUN
      printf,luna,'besancon_rave_plot_two_cols,PATH=str_path=',str_path
      printf,luna,'                            SUBPATH=I_vrad'
      printf,luna,'                            RAVEDATAFILE=ravedatafile=',str_ravedatafile
      printf,luna,'                            BESANCONDATAFILE=besancondatafile=',besancondatafile
      printf,luna,'                            STRARR_RAVE_DATA=strarr_ravedata'
      printf,luna,'                            STRARR_BESANCON_DATA=strarr_besancondata'
      printf,luna,'                            FIELDSFILE=fieldsfile=',fieldsfile
      printf,luna,'                            XCOLRAVE=2'
      printf,luna,'                            XCOLBESANCON=xcol_besancon=',xcol_besancon
      printf,luna,'                            XTITLE=I [mag]'
      printf,luna,'                            XRANGESET=irange=',irange
      printf,luna,'                            YCOLRAVE=3'
      printf,luna,'                            YCOLBESANCON=ycol_besancon=',ycol_besancon
      printf,luna,'                            YTITLE=Radial Velocity [km/s]'
      printf,luna,'                            YRANGESET=yrangeset=',yrangeset
      printf,luna,'                            IRANGE=irange=',irange
      printf,luna,'                            ICOLRAVE=4'
      printf,luna,'                            ICOLBESANCON=icol_besancon=',icol_besancon
      printf,luna,'                            FORCEXRANGE=1'
      printf,luna,'                            FORCEYRANGE=0'
      printf,luna,'                            REJECTVALUEX=15'
      printf,luna,'                            REJECTVALUEY=100000.'
      printf,luna,'                            LONLAT=b_lonlat=',b_lonlat
      printf,luna,'                            CALCSAMPLES=b_calcsamples=',b_calcsamples
      printf,luna,'                            I_NSAMPLES=i_nsamples=',i_nsamples
      printf,luna,'                            XYTITLE=[Imag,vrad]'
      printf,luna,'                            B_HIST=1'
      printf,luna,'                            STAR_TYPES_COL=int_col_star_types=',int_col_star_types
      printf,luna,'                            B_CALCNBINS=b_calcnbins=',b_calcnbins
      printf,luna,'                            NBINSMIN=nbinsmin=',nbinsmin
      printf,luna,'                            NBINSMAX=nbinsmax=',nbinsmax
      printf,luna,'                            B_I_SEARCH=b_i_search=',b_i_search
    free_lun,luna

    xcol_besancon = i_col_imag_besancon
    ycol_besancon = i_col_vrad_besancon
    if xcol_besancon eq 0 then $
      xcol_besancon = 0.0001
    if ycol_besancon eq 0 then $
      ycol_besancon = 0.0001
    if icol_besancon eq 0 then $
      icol_besancon = 0.0001
    besancon_rave_plot_two_cols,PATH                 = str_path,$
                                SUBPATH              = 'I_vrad',$
                                RAVEDATAFILE         = ravedatafile,$
                                I_STR_PIXELMAP       = str_pixelmap,$
                                BESANCONDATAFILE     = besancondatafile,$
                                STRARR_RAVE_DATA     = strarr_ravedata,$
                                STRARR_BESANCON_DATA = strarr_besancondata,$
                                FIELDSFILE           = fieldsfile,$
                                XCOLRAVE             = 2,$
                                XCOLBESANCON         = xcol_besancon,$
                                XTITLE               = 'I [mag]',$
                                XRANGESET            = irange,$
                                YCOLRAVE             = 3,$
                                YCOLBESANCON         = ycol_besancon,$
                                YTITLE               = 'Radial Velocity [km/s]',$
                                YRANGESET            = yrangeset,$
                                IRANGE               = irange,$
                                ICOLRAVE             = 4,$
                                ICOLBESANCON         = icol_besancon,$
                                FORCEXRANGE          = 1,$
                                FORCEYRANGE          = 0,$
                                REJECTVALUEX         = 15,$
                                REJECTVALUEY         = 100000.,$
                                LONLAT               = b_lonlat,$
                                CALCSAMPLES          = b_calcsamples,$
                                I_NSAMPLES           = i_nsamples,$
                                XYTITLE              = ['Imag','vrad'],$
                                B_HIST               = 1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL       = int_col_star_types,$
                                B_CALCNBINS          = b_calcnbins,$
                                NBINSMIN             = nbinsmax,$;nbinsmin,$
                                NBINSMAX             = nbinsmax,$
                                B_I_SEARCH           = b_i_search,$
                                DBL_XMAX             = dbl_xmax,$
                                DBL_YMAX             = dbl_ymax,$
                                B_PLOT_MEAN_KST      = b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
;                              TEST=1
  endif
; --- plot vrad over I for I=9.-10.5
  if b_do_I_vrad_9_10_5 then begin
    irange = [9.,10.5]
    str_path_temp = str_path+'I_vrad/I9.00-10.5/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_vrad',$
                                RAVEDATAFILE=ravedatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                YCOLRAVE=3,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Radial Velocity [km/s]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=100000.,$
                                LONLAT=1,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','vrad'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot vrad over I for I=10.5-12.
  if b_do_I_vrad_10_5_12 then begin
    irange = [10.5,12.]
    str_path_temp = str_path+'I_vrad/I10.5-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_vrad',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                YCOLRAVE=3,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Radial Velocity [km/s]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=100000.,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','vrad'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

 ; --- plot vrad over I for I=9.-10.
  if b_do_I_vrad_9_10 then begin
    irange = [9.,10.]
    str_path_temp = str_path+'I_vrad/I9.00-10.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_vrad',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                YCOLRAVE=3,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Radial Velocity [km/s]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=100000.,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','vrad'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
  endif

  ; --- plot vrad over I for I=10.-11.
  if b_do_I_vrad_10_11 then begin
    irange = [10.,11.]
    str_path_temp = str_path+'I_vrad/I10.0-11.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_vrad',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                YCOLRAVE=3,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Radial Velocity [km/s]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=100000.,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','vrad'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot vrad over I for I=11.-12.
  if b_do_I_vrad_11_12 then begin
    irange = [11.,12.]
    str_path_temp = str_path+'I_vrad/I11.0-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_vrad',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                YCOLRAVE=3,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Radial Velocity [km/s]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=100000.,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','vrad'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot Teff over I for I=9.-12.
  if b_one_besanconfile eq 1 then begin
    xcol_besancon = i_col_imag_besancon
    ycol_besancon = i_col_teff_besancon
    if xcol_besancon eq 0 then $
      xcol_besancon = 0.0001
    if ycol_besancon eq 0 then $
      ycol_besancon = 0.0001
    if icol_besancon eq 0 then $
      icol_besancon = 0.0001
  end else begin
    xcol_besancon = 12
    ycol_besancon = 4
  end
  yrangeset = [3000.,7000.]
  dbl_xmax = dbl_xmax_I
  dbl_ymax = dbl_xmax_Teff
  if b_do_I_Teff_9_12 then begin
    irange = [9.,12.]
    str_path_temp = str_path+'I_Teff/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
    openw,lun_deb,str_path_temp+'logfile.log',/GET_LUN
      printf,lun_deb,'besancon_rave_plot_two_cols,PATH                 = ',str_path
      printf,lun_deb,'                            SUBPATH              = I_Teff'
      printf,lun_deb,'                            RAVEDATAFILE         = ',str_ravedatafile
      printf,lun_deb,'                            BESANCONDATAFILE     = ',besancondatafile
      printf,lun_deb,'                            STRARR_RAVE_DATA     = strarr_ravedata'
      printf,lun_deb,'                            STRARR_BESANCON_DATA = strarr_besancondata'
      printf,lun_deb,'                            FIELDSFILE           = ',fieldsfile
      printf,lun_deb,'                            XCOLRAVE             = 2'
      printf,lun_deb,'                            XCOLBESANCON         = ',xcol_besancon
      printf,lun_deb,'                            XTITLE               = I [mag]'
      printf,lun_deb,'                            XRANGESET            = ',irange
      printf,lun_deb,'                            YCOLRAVE             = 5'
      printf,lun_deb,'                            YCOLBESANCON         = ',ycol_besancon
      printf,lun_deb,'                            YTITLE               = Effective Temperature [K]'
      printf,lun_deb,'                            YRANGESET            = ',yrangeset
      printf,lun_deb,'                            IRANGE               = ',irange
      printf,lun_deb,'                            ICOLRAVE             = 4'
      printf,lun_deb,'                            ICOLBESANCON         = ',icol_besancon
      printf,lun_deb,'                            FORCEXRANGE          = 0'
      printf,lun_deb,'                            FORCEYRANGE          = 1'
      printf,lun_deb,'                            REJECTVALUEX         = 15'
      printf,lun_deb,'                            REJECTVALUEY         = 0.0000001'
      printf,lun_deb,'                            LONLAT               = ',b_lonlat
      printf,lun_deb,'                            CALCSAMPLES          = ',b_calcsamples
      printf,lun_deb,'                            I_NSAMPLES           = ',i_nsamples
      printf,lun_deb,'                            XYTITLE              = [Imag,Teff]'
      printf,lun_deb,'                            B_HIST               = 1'
      printf,lun_deb,'                            B_POP_ID             = ',b_pop_id
      printf,lun_deb,'                            STAR_TYPES_COL       = ',int_col_star_types
      printf,lun_deb,'                            B_CALCNBINS          = ',b_calcnbins
      printf,lun_deb,'                            NBINSMIN             = ',nbinsmin
      printf,lun_deb,'                            NBINSMAX             = ',nbinsmax
      printf,lun_deb,'                            B_I_SEARCH           = ',b_i_search
      printf,lun_deb,'                            DBL_XMAX             = ',dbl_xmax
      printf,lun_deb,'                            DBL_YMAX             = ',dbl_ymax
      printf,lun_deb,'                            B_PLOT_MEAN_KST      = ',b_plot_mean_kst
      printf,lun_deb,'                            I_COL_LON_BESANCON   = ',i_col_lon_besancon
      printf,lun_deb,'                            I_COL_LAT_BESANCON   = ',i_col_lat_besancon
      printf,lun_deb,'                            I_COL_LOGG_RAVE      = ',i_col_logg_rave
      printf,lun_deb,'                            I_COL_LOGG_BESANCON  = ',i_col_logg_besancon
      printf,lun_deb,'                            B_SELECT_FROM_IMAG_AND_LOGG = ',b_select_from_imag_and_logg
    free_lun,lun_deb
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_Teff',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$
                                DBL_YMAX=dbl_ymax,$
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif


; --- plot Teff over I for I=9.-10.5
  if b_do_I_Teff_9_10_5 then begin
    irange = [9.,10.5]
    str_path_temp = str_path+'I_Teff/I9.00-10.5/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_Teff',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$        ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
  endif

; --- plot Teff over I for I=10.5-12
  if b_do_I_Teff_10_5_12 then begin
    irange = [10.5,12.]
    str_path_temp = str_path+'I_Teff/I10.5-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_Teff',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot Teff over I for I=9.-10.
  if b_do_I_Teff_9_10 then begin
    irange = [9.,10.]
    str_path_temp = str_path+'I_Teff/I9.00-10.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_Teff',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot Teff over I for I=10.-11.
  if b_do_I_Teff_10_11 then begin
    irange = [10.,11.]
    str_path_temp = str_path+'I_Teff/I10.0-11.0/'
    spawn,'mkdir '+str_path_temp
   besancon_rave_plot_two_cols,PATH=str_path,$
                              SUBPATH='I_Teff',$
                              RAVEDATAFILE=ravedatafile,$
                              BESANCONDATAFILE=besancondatafile,$
                              STRARR_RAVE_DATA=strarr_ravedata,$
                              STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                              FIELDSFILE=fieldsfile,$
                              XCOLRAVE=2,$
                              XCOLBESANCON=xcol_besancon,$
                              XTITLE='I [mag]',$
                                XRANGESET=irange,$
                              ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_CALCNBINS=b_calcnbins,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot Teff over I for I=11.-12.
  if b_do_I_Teff_11_12 then begin
    irange = [11.,12.]
    str_path_temp = str_path+'I_Teff/I11.0-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='I_Teff',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=2,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='I [mag]',$
                                XRANGESET=irange,$
                                ;YLOGBES = 1,$
                                YCOLRAVE=5,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Effective Temperature [K]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=0,$
                                FORCEYRANGE=1,$
                                REJECTVALUEX=15,$
                                REJECTVALUEY=0.0000001,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Imag','Teff'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

;  strarr_ravedata(*,2) = strarr_ravedata_all(*,5)
;  strarr_ravedata(*,3) = strarr_ravedata_all(*,19)
  ; --- plot [Fe/H] over vrad
  if b_one_besanconfile eq 1 then begin
    xcol_besancon = i_col_vrad_besancon
    ycol_besancon = i_col_feh_besancon
  end else begin
    xcol_besancon = 15
    ycol_besancon = 19
  end
  if xcol_besancon eq 0 then $
    xcol_besancon = 0.0001
  if ycol_besancon eq 0 then $
    ycol_besancon = 0.0001
  if icol_besancon eq 0 then $
    icol_besancon = 0.0001
  yrangeset = [-2.,1.]
  xrangeset = [-300.,300.]
  dbl_xmax = dbl_xmax_vrad
  dbl_ymax = dbl_xmax_MH
  if b_do_vrad_MH_9_12 then begin
    irange = [9.,12.]
    str_path_temp = str_path+'vrad_MH/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
    openw,lun_deb,str_path_temp+'logfile.log',/GET_LUN
      printf,lun_deb,'    besancon_rave_plot_two_cols,PATH                 = ',str_path
      printf,lun_deb,'                                SUBPATH              = vrad_MH'
      printf,lun_deb,'                                RAVEDATAFILE         = ',str_ravedatafile
      printf,lun_deb,'                                BESANCONDATAFILE     = ',besancondatafile
      printf,lun_deb,'                                STRARR_RAVE_DATA     = strarr_ravedata'
      printf,lun_deb,'                                STRARR_BESANCON_DATA = strarr_besancondata'
      printf,lun_deb,'                                FIELDSFILE           = ',fieldsfile
      printf,lun_deb,'                                XCOLRAVE             = 3'
      printf,lun_deb,'                                XCOLBESANCON         = ',xcol_besancon
      printf,lun_deb,'                                XTITLE               = Radial Velocity [km/s]'
      printf,lun_deb,'                                XRANGESET            = ',xrangeset
      printf,lun_deb,'                                YCOLRAVE             = 6'
      printf,lun_deb,'                                YCOLBESANCON         = ',ycol_besancon
      printf,lun_deb,'                                YTITLE               = Metallicity [dex]'
      printf,lun_deb,'                                YRANGESET            = ',yrangeset
      printf,lun_deb,'                                IRANGE               = ',irange
      printf,lun_deb,'                                ICOLRAVE             = 4'
      printf,lun_deb,'                                ICOLBESANCON         = ',icol_besancon
      printf,lun_deb,'                                FORCEXRANGE          = 1'
      printf,lun_deb,'                                FORCEYRANGE          = 0'
      printf,lun_deb,'                                REJECTVALUEX         = 100000.'
      printf,lun_deb,'                                REJECTVALUEY         = 99.90'
      printf,lun_deb,'                                LONLAT               = ',b_lonlat
      printf,lun_deb,'                                CALCSAMPLES          = ',b_calcsamples
      printf,lun_deb,'                                I_NSAMPLES           = ',i_nsamples
      printf,lun_deb,'                                XYTITLE              = [vrad,MH]'
      printf,lun_deb,'                                B_HIST               = 1'
      printf,lun_deb,'                                B_POP_ID             = ',b_pop_id
      printf,lun_deb,'                                STAR_TYPES_COL       = ',int_col_star_types
      printf,lun_deb,'                                B_CALCNBINS          = ',b_calcnbins
      printf,lun_deb,'                                NBINSMIN             = ',nbinsmin
      printf,lun_deb,'                                NBINSMAX             = ',nbinsmax
      printf,lun_deb,'                                B_I_SEARCH           = ',b_i_search
      printf,lun_deb,'                                DBL_XMAX             = ',dbl_xmax      ; -- colour range x value
      printf,lun_deb,'                                DBL_YMAX             = ',dbl_ymax      ; -- colour range y value
      printf,lun_deb,'                                B_PLOT_MEAN_KST      = ',b_plot_mean_kst
      printf,lun_deb,'                                I_COL_LON_BESANCON   = ',i_col_lon_besancon
      printf,lun_deb,'                                I_COL_LAT_BESANCON   = ',i_col_lat_besancon
      printf,lun_deb,'                                I_COL_LOGG_RAVE      = ',i_col_logg_rave
      printf,lun_deb,'                                I_COL_LOGG_BESANCON  = ',i_col_logg_besancon
      printf,lun_deb,'                                B_SELECT_FROM_IMAG_AND_LOGG = ',b_select_from_imag_and_logg
    free_lun,lun_deb
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing


  endif

; --- plot [Fe/H] over vrad I=9-10.5
  if b_do_vrad_MH_9_10_5 then begin
    irange = [9.,10.5]
    str_path_temp = str_path+'vrad_MH/I9.00-10.5/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot [M/H] over vrad I=10.5-12.
  if b_do_vrad_MH_10_5_12 then begin
    irange = [10.5,12.]
    str_path_temp = str_path+'vrad_MH/I10.5-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing


  endif

; --- plot [M/H] over vrad I=9-10.
  if b_do_vrad_MH_9_10 then begin
    irange = [9.,10.]
    str_path_temp = str_path+'vrad_MH/I9.00-10.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot [M/H] over vrad I=10.-11.
  if b_do_vrad_MH_10_11 then begin
    irange = [10.,11.]
    str_path_temp = str_path+'vrad_MH/I10.0-11.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

; --- plot [M/H] over vrad I=11.-12.
  if b_do_vrad_MH_11_12 then begin
    irange = [11.,12.]
    str_path_temp = str_path+'vrad_MH/I11.0-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='vrad_MH',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=3,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Radial Velocity [km/s]',$
                                XRANGESET=xrangeset,$
                                YCOLRAVE=6,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Metallicity [dex]',$
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=100000.,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['vrad','MH'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif


;  strarr_ravedata(*,2) = strarr_ravedata_all(*,5)
;  strarr_ravedata(*,3) = strarr_ravedata_all(*,19)
  ; --- plot T_eff versus log g for I=9..12
  if b_one_besanconfile eq 1 then begin
    xcol_besancon = i_col_teff_besancon
    ycol_besancon = i_col_logg_besancon
  end else begin
    xcol_besancon = 4
    ycol_besancon = 5
  end
  if xcol_besancon eq 0 then $
    xcol_besancon = 0.0001
  if ycol_besancon eq 0 then $
    ycol_besancon = 0.0001
  if icol_besancon eq 0 then $
    icol_besancon = 0.0001
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  xrangeset = [3000.,7000.]
  yrangeset = [0.,6.]
  dbl_xmax = dbl_xmax_Teff
  dbl_ymax = dbl_xmax_logg

  if b_do_Teff_logg_9_12 then begin
    irange = [9.,12.]
    str_path_temp = str_path+'Teff_logg/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
    openw,lun_deb,str_path_temp+'logfile.log',/GET_LUN
      printf,lun_deb,'    besancon_rave_plot_two_cols,PATH                        = ',str_path; ---
      printf,lun_deb,'                                SUBPATH                     = Teff_logg';---
      printf,lun_deb,'                                RAVEDATAFILE                = ',str_ravedatafile;---
      printf,lun_deb,'                                BESANCONDATAFILE            = ',besancondatafile;---
      printf,lun_deb,'                                STRARR_RAVE_DATA            = strarr_ravedata';---
      printf,lun_deb,'                                STRARR_BESANCON_DATA        = strarr_besancondata';---
      printf,lun_deb,'                                FIELDSFILE                  = ',fieldsfile;---
      printf,lun_deb,'                                XCOLRAVE                    = 5';---
      printf,lun_deb,'                                XCOLBESANCON                = ',xcol_besancon;---
      printf,lun_deb,'                                XTITLE                      = Effective Temperature [K]';---
      printf,lun_deb,'                                XRANGESET                   = ',xrangeset;---
      printf,lun_deb,'                                ;XLOGBES = 1,$;---'
      printf,lun_deb,'                                YCOLRAVE                    = 8';---
      printf,lun_deb,'                                YCOLBESANCON                = ',ycol_besancon;---
      printf,lun_deb,'                                YTITLE                      = Surface Gravity [dex]';---
      printf,lun_deb,'                                I_PLOT_GIANT_TO_DWARF_RATIO = ',i_plot_giant_to_dwarf_ratio; --- 0: don't, 1: x=logg, 2: y=logg
      printf,lun_deb,'                                YRANGESET                   = ',yrangeset;---
      printf,lun_deb,'                                IRANGE                      = ',irange;---
      printf,lun_deb,'                                ICOLRAVE                    = 4';---
      printf,lun_deb,'                                ICOLBESANCON                = ',icol_besancon;---
      printf,lun_deb,'                                FORCEXRANGE                 = 1';---
      printf,lun_deb,'                                FORCEYRANGE                 = 0';---
      printf,lun_deb,'                                REJECTVALUEX                = 0.0000001';---
      printf,lun_deb,'                                REJECTVALUEY                = 99.90';---
      printf,lun_deb,'                                LONLAT                      = ',b_lonlat;---
      printf,lun_deb,'                                CALCSAMPLES                 = ',b_calcsamples;---
      printf,lun_deb,'                                I_NSAMPLES                  = ',i_nsamples;---
      printf,lun_deb,'                                XYTITLE                     = [Teff,logg]';---
      printf,lun_deb,'                                B_HIST                      = 1';---
      printf,lun_deb,'                                B_POP_ID                    = ',b_pop_id;---
      printf,lun_deb,'                                STAR_TYPES_COL              = ',int_col_star_types;---
      printf,lun_deb,'                                B_CALCNBINS                 = ',b_calcnbins;---
      printf,lun_deb,'                                NBINSMIN                    = ',nbinsmin;---
      printf,lun_deb,'                                NBINSMAX                    = ',nbinsmax;---
      printf,lun_deb,'                                B_I_SEARCH                  = ',b_i_search;---
      printf,lun_deb,'                                DBL_XMAX                    = ',dbl_xmax      ; -- colour range x value
      printf,lun_deb,'                                DBL_YMAX                    = ',dbl_ymax      ; -- colour range y value
      printf,lun_deb,'                                B_PLOT_MEAN_KST             = ',b_plot_mean_kst
      printf,lun_deb,'                                I_COL_LON_BESANCON          = ',i_col_lon_besancon
      printf,lun_deb,'                                I_COL_LAT_BESANCON          = ',i_col_lat_besancon
      printf,lun_deb,'                                I_COL_LOGG_RAVE             = ',i_col_logg_rave
      printf,lun_deb,'                                I_COL_LOGG_BESANCON         = ',i_col_logg_besancon
      printf,lun_deb,'                                B_SELECT_FROM_IMAG_AND_LOGG = ',b_select_from_imag_and_logg
    free_lun,lun_deb
    besancon_rave_plot_two_cols,PATH                        = str_path,$; ---
                                SUBPATH                     = 'Teff_logg',$;---
                                RAVEDATAFILE                = ravedatafile,$;---
                                BESANCONDATAFILE            = besancondatafile,$;---
                                STRARR_RAVE_DATA            = strarr_ravedata,$;---
                                STRARR_BESANCON_DATA        = strarr_besancondata,$;---
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE                  = fieldsfile,$;---
                                XCOLRAVE                    = 5,$;---
                                XCOLBESANCON                = xcol_besancon,$;---
                                XTITLE                      = 'Effective Temperature [K]',$;---
                                XRANGESET                   = xrangeset,$;---
                                ;XLOGBES = 1,$;---
                                YCOLRAVE                    = 8,$;---
                                YCOLBESANCON                = ycol_besancon,$;---
                                YTITLE                      = 'Surface Gravity [dex]',$;---
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET                   = yrangeset,$;---
                                IRANGE                      = irange,$;---
                                ICOLRAVE                    = 4,$;---
                                ICOLBESANCON                = icol_besancon,$;---
                                FORCEXRANGE                 = 1,$;---
                                FORCEYRANGE                 = 0,$;---
                                REJECTVALUEX                = 0.0000001,$;---
                                REJECTVALUEY                = 99.90,$;---
                                LONLAT                      = b_lonlat,$;---
                                CALCSAMPLES                 = b_calcsamples,$;---
                                I_NSAMPLES                  = i_nsamples,$;---
                                XYTITLE                     = ['Teff','logg'],$;---
                                B_HIST                      = 1,$;---
                                B_POP_ID                    = b_pop_id,$;---
                                STAR_TYPES_COL              = int_col_star_types,$;---
                                B_CALCNBINS                 = b_calcnbins,$;---
                                NBINSMIN                    = nbinsmin,$;---
                                NBINSMAX                    = nbinsmax,$;---
                                B_I_SEARCH                  = b_i_search,$;---
                                DBL_XMAX                    = dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX                    = dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST             = b_plot_mean_kst,$
                                I_COL_LON_BESANCON          = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON          = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE             = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON         = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing



  endif

  ; --- plot T_eff versus log g for I=9..10.5
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  if b_do_Teff_logg_9_10_5 then begin
    irange = [9.,10.5]
    str_path_temp = str_path+'Teff_logg/I9.00-10.5/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='Teff_logg',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=5,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Effective Temperature [K]',$
                                XRANGESET=xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE=8,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Surface Gravity [dex]',$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=0.0000001,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Teff','logg'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot T_eff versus log g for I=10.5..12
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  if b_do_Teff_logg_10_5_12 then begin
    irange = [10.5,12.]
    str_path_temp = str_path+'Teff_logg/I10.5-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='Teff_logg',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=5,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Effective Temperature [K]',$
                                XRANGESET=xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE=8,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Surface Gravity [dex]',$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=0.0000001,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Teff','logg'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot T_eff versus log g for I=9..10
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  if b_do_Teff_logg_9_10 then begin
    irange = [9.,10.]
    str_path_temp = str_path+'Teff_logg/I9.00-10.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='Teff_logg',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=5,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Effective Temperature [K]',$
                                XRANGESET=xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE=8,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Surface Gravity [dex]',$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=0.0000001,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Teff','logg'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot T_eff versus log g for I=10..11
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  if b_do_Teff_logg_10_11 then begin
    irange = [10.,11.]
    str_path_temp = str_path+'Teff_logg/I10.0-11.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='Teff_logg',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=5,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Effective Temperature [K]',$
                                XRANGESET=xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE=8,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Surface Gravity [dex]',$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=0.0000001,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Teff','logg'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif

  ; --- plot T_eff versus log g for I=11..12
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  if b_do_Teff_logg_11_12 then begin
    irange = [11.,12.]
    str_path_temp = str_path+'Teff_logg/I11.0-12.0/'
    spawn,'mkdir '+str_path_temp
    besancon_rave_plot_two_cols,PATH=str_path,$
                                SUBPATH='Teff_logg',$
                                RAVEDATAFILE=ravedatafile,$
                                BESANCONDATAFILE=besancondatafile,$
                                STRARR_RAVE_DATA=strarr_ravedata,$
                                STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE=fieldsfile,$
                                XCOLRAVE=5,$
                                XCOLBESANCON=xcol_besancon,$
                                XTITLE='Effective Temperature [K]',$
                                XRANGESET=xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE=8,$
                                YCOLBESANCON=ycol_besancon,$
                                YTITLE='Surface Gravity [dex]',$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                YRANGESET=yrangeset,$
                                IRANGE=irange,$
                                ICOLRAVE=4,$
                                ICOLBESANCON=icol_besancon,$
                                FORCEXRANGE=1,$
                                FORCEYRANGE=0,$
                                REJECTVALUEX=0.0000001,$
                                REJECTVALUEY=99.90,$
                                LONLAT=b_lonlat,$
                                CALCSAMPLES=b_calcsamples,$
                                I_NSAMPLES=i_nsamples,$
                                XYTITLE=['Teff','logg'],$
                                B_HIST=1,$
                                B_POP_ID             = b_pop_id,$
                                STAR_TYPES_COL=int_col_star_types,$
                                B_CALCNBINS=b_calcnbins,$
                                NBINSMIN=nbinsmin,$
                                NBINSMAX=nbinsmax,$
                                B_I_SEARCH=b_i_search,$
                                DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif








  if b_one_besanconfile eq 1 then begin
    xcol_besancon = i_col_teff_besancon;      Teff
    ycol_besancon = i_col_feh_besancon;           [M/H]
  end else begin
;    xcol_besancon = 4
;    ycol_besancon = 5
  end
  if xcol_besancon eq 0 then $
    xcol_besancon = 0.0001
  if ycol_besancon eq 0 then $
    ycol_besancon = 0.0001
  if icol_besancon eq 0 then $
    icol_besancon = 0.0001
  xcol_rave = 5;     Teff
  ycol_rave = 6;     [M/H]

;  strarr_ravedata(*,2) = strarr_ravedata_all(*,5)
;  strarr_ravedata(*,3) = strarr_ravedata_all(*,19)
  ; --- plot T_eff versus [M/H] for I=9..12
  print,'rave_besancon_plot_all: xcol_besancon = ',xcol_besancon
  print,'rave_besancon_plot_all: ycol_besancon = ',ycol_besancon
  xrangeset = [3000.,7000.]
  yrangeset = [-2.,1.]
  dbl_xmax = dbl_xmax_Teff / 3.
  dbl_ymax = dbl_xmax_MH / 3.
  if b_do_Teff_MH_9_12 then begin
    irange = [9.,12.]
    str_path_temp = str_path+'Teff_MH/I9.00-12.0/'
    spawn,'mkdir '+str_path_temp
    openw,lun_deb,str_path_temp+'logfile.log',/GET_LUN
      printf,lun_deb,'    besancon_rave_plot_two_cols,PATH                        = ',str_path
      printf,lun_deb,'                                SUBPATH                     = Teff_MH'
      printf,lun_deb,'                                RAVEDATAFILE                = ',str_ravedatafile
      printf,lun_deb,'                                BESANCONDATAFILE            = ',besancondatafile
      printf,lun_deb,'                                STRARR_RAVE_DATA            = ',strarr_ravedata
      printf,lun_deb,'                                STRARR_BESANCON_DATA        = ',strarr_besancondata
      printf,lun_deb,'                                FIELDSFILE                  = ',fieldsfile
      printf,lun_deb,'                                XCOLRAVE                    = ',xcol_rave
      printf,lun_deb,'                                XCOLBESANCON                = ',xcol_besancon
      printf,lun_deb,'                                XTITLE                      = Effective Temperature [K]'
      printf,lun_deb,'                                XRANGESET                   = ',xrangeset
      printf,lun_deb,'                                ;XLOGBES = 1,$'
      printf,lun_deb,'                                YCOLRAVE                    = ',ycol_rave
      printf,lun_deb,'                                YCOLBESANCON                = ',ycol_besancon
      printf,lun_deb,'                                YTITLE                      = Metallicity [dex]'
      printf,lun_deb,'                                YRANGESET                   = ',yrangeset
      printf,lun_deb,'                                IRANGE                      = ',irange
      printf,lun_deb,'                                ICOLRAVE                    = 4'
      printf,lun_deb,'                                ICOLBESANCON                = ',icol_besancon
      printf,lun_deb,'                                FORCEXRANGE                 = 1'
      printf,lun_deb,'                                FORCEYRANGE                 = 0'
      printf,lun_deb,'                                REJECTVALUEX                = 0.0000001'
      printf,lun_deb,'                                REJECTVALUEY                = 99.90'
      printf,lun_deb,'                                LONLAT                      = ',b_lonlat
      printf,lun_deb,'                                CALCSAMPLES                 = ',b_calcsamples
      printf,lun_deb,'                                I_NSAMPLES                  = ',i_nsamples
      printf,lun_deb,'                                XYTITLE                     = [Teff,MH]'
      printf,lun_deb,'                                B_HIST                      = 1'
      printf,lun_deb,'                                B_POP_ID                    = ',b_pop_id
      printf,lun_deb,'                                STAR_TYPES_COL              = ',int_col_star_types
      printf,lun_deb,'                                B_CALCNBINS                 = ',b_calcnbins
      printf,lun_deb,'                                NBINSMIN                    = ',nbinsmin
      printf,lun_deb,'                                NBINSMAX                    = ',nbinsmax
      printf,lun_deb,'                                B_I_SEARCH                  = ',b_i_search
      printf,lun_deb,'                                DBL_XMAX                    = ',dbl_xmax      ; -- colour range x value
      printf,lun_deb,'                                DBL_YMAX                    = ',dbl_ymax      ; -- colour range y value
      printf,lun_deb,'                                B_PLOT_MEAN_KST             = ',b_plot_mean_kst
      printf,lun_deb,'                                I_COL_LON_BESANCON          = ',i_col_lon_besancon
      printf,lun_deb,'                                I_COL_LAT_BESANCON          = ',i_col_lat_besancon
      printf,lun_deb,'                                I_COL_LOGG_RAVE             = ',i_col_logg_rave
      printf,lun_deb,'                                I_COL_LOGG_BESANCON         = ',i_col_logg_besancon
      printf,lun_deb,'                                B_SELECT_FROM_IMAG_AND_LOGG = ',b_select_from_imag_and_logg
    free_lun,lun_deb
    besancon_rave_plot_two_cols,PATH                        = str_path,$
                                SUBPATH                     = 'Teff_MH',$
                                RAVEDATAFILE                = ravedatafile,$
                                BESANCONDATAFILE            = besancondatafile,$
                                STRARR_RAVE_DATA            = strarr_ravedata,$
                                STRARR_BESANCON_DATA        = strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                FIELDSFILE                  = fieldsfile,$
                                XCOLRAVE                    = xcol_rave,$
                                XCOLBESANCON                = xcol_besancon,$
                                XTITLE                      = 'Effective Temperature [K]',$
                                XRANGESET                   = xrangeset,$
                                ;XLOGBES = 1,$
                                YCOLRAVE                    = ycol_rave,$
                                YCOLBESANCON                = ycol_besancon,$
                                YTITLE                      = 'Metallicity [dex]',$
                                YRANGESET                   = yrangeset,$
                                IRANGE                      = irange,$
                                ICOLRAVE                    = 4,$
                                ICOLBESANCON                = icol_besancon,$
                                FORCEXRANGE                 = 1,$
                                FORCEYRANGE                 = 0,$
                                REJECTVALUEX                = 0.0000001,$
                                REJECTVALUEY                = 99.90,$
                                LONLAT                      = b_lonlat,$
                                CALCSAMPLES                 = b_calcsamples,$
                                I_NSAMPLES                  = i_nsamples,$
                                XYTITLE                     = ['Teff','MH'],$
                                B_HIST                      = 1,$
                                B_POP_ID                    = b_pop_id,$
                                STAR_TYPES_COL              = int_col_star_types,$
                                B_CALCNBINS                 = b_calcnbins,$
                                NBINSMIN                    = nbinsmin,$
                                NBINSMAX                    = nbinsmax,$
                                B_I_SEARCH                  = b_i_search,$
                                DBL_XMAX                    = dbl_xmax,$      ; -- colour range x value
                                DBL_YMAX                    = dbl_ymax,$      ; -- colour range y value
                                B_PLOT_MEAN_KST             = b_plot_mean_kst,$
                                I_COL_LON_BESANCON          = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON          = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE             = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON         = i_col_logg_besancon,$
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing

  endif






  if b_dist then begin

    if keyword_set(B_BREDDELS) then begin
      b_zwitter = 0
      b_breddels = 1
    end else if not(b_breddels) then begin
      b_zwitter = 1
      b_breddels = 0
    endif
    ;b_breddels

    if b_zwitter then begin
      int_loop_end = 2
    end else if b_breddels then begin
      int_loop_end = 0
    end
    if b_calc_errors then $
      int_loop_end = 1

    str_path_bak = str_path

    for i_loop = 0, int_loop_end do begin
      if b_calc_errors then begin
        if i_loop eq 0 then begin
          b_breddels = 0
          b_zwitter = 1
        end else begin
          b_breddels = 1
          b_zwitter = 0
        endelse
      endif
      if b_zwitter then begin
        i_col_ra     = 2
        i_col_dec    = 3
        i_col_lon    = 4
        i_col_lat    = 5
        i_col_dist   = 22
        i_col_vrad   = 6
        i_col_logg   = 19
        i_col_teff   = 18
        i_col_imag   = 12
        i_col_height = 28
        i_col_rcent  = 29
        i_col_mh     = 20

        str_ravedatafile = '/rave/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent_distsample_logg_0_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00.dat';errdivby_1.56_2.37_2.75_1.50_2.00.dat';Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb_minus_ic1_height_rcent_distsample_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat';Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb_minus_ic1_height_rcent.dat';_distsample_0.dat'
      end else if b_breddels then begin
        i_col_ra     = 1
        i_col_dec    = 2
        i_col_lon    = 3
        i_col_lat    = 4
        i_col_dist   = 28
        i_col_vrad   = 5
        i_col_logg   = 13
        i_col_teff   = 11
        i_col_imag   = 52
        i_col_height = 54
        i_col_rcent  = 55
        i_col_mh     = 17

        str_ravedatafile = '/rave/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS-9ltIlt12-lb+stn_height_rcent_distsample_logg_0_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00.dat';errdivby_1.00_1.00_1.00_1.00_1.00.dat';Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent_distsample_logg_0_errdivby_1.56_2.37_2.75_1.50_2.00.dat';Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-    endelse
      end
      ravedatafile = strmid(str_ravedatafile,0,strpos(str_ravedatafile,'/',/REVERSE_SEARCH)+1)+'rave_temp.dat'
      spawn,'cp -p '+str_ravedatafile+' '+ravedatafile
      i_ndatalines = countdatlines(ravedatafile)
      print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines

      strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')

      if i_loop eq 1 then begin
        i_col_dist   = 24
        if b_calc_errors then $
          i_col_dist   = 26
      end else if i_loop eq 2 then begin
        i_col_dist   = 26
      end
      if b_zwitter then begin
        indarr_good = where(double(strarr_ravedata_all(*,i_col_dist) lt 15.))
        strarr_ravedata_all = strarr_ravedata_all(indarr_good,*)
        i_ndatalines = n_elements(indarr_good)
        indarr_good = 0
      endif

      print,'rave_besancon_plot_all: strarr_ravedata_all(0,*) = ',strarr_ravedata_all(0,*)
      strarr_ravedata_dist = strarr(i_ndatalines,11)
      if b_lonlat eq 1 then begin
  ;      dblarr_ra = double(strarr_ravedata_all(*,2))
  ;      dblarr_dec = double(strarr_ravedata_all(*,3))
  ;      euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,SELECT=1
  ;      strarr_ravedata_dist(*,0) = string(dblarr_lon)
  ;      strarr_ravedata_dist(*,1) = string(dblarr_lat)
        strarr_ravedata_dist(*,0) = strarr_ravedata_all(*,i_col_lon); --- lon
        strarr_ravedata_dist(*,1) = strarr_ravedata_all(*,i_col_lat); --- lat
  ;      dblarr_ra = 0
  ;      dblarr_dec = 0
  ;      dblarr_lon = 0
  ;      dblarr_lat = 0
      end else begin
        strarr_ravedata_dist(*,0) = strarr_ravedata_all(*,i_col_ra); --- ra
        strarr_ravedata_dist(*,1) = strarr_ravedata_all(*,i_col_dec); --- dec
      end
      print,'rave_besancon_plot_all: ravedatafile "'+ravedatafile+'" read'

      strarr_ravedata_dist(*,2) = strarr_ravedata_all(*,i_col_dist); --- distance
      strarr_ravedata_dist(*,3) = strarr_ravedata_all(*,i_col_imag); --- Imag
      strarr_ravedata_dist(*,4) = strarr_ravedata_all(*,i_col_logg); --- log g
      strarr_ravedata_dist(*,5) = strarr_ravedata_all(*,i_col_vrad); --- vrad
      strarr_ravedata_dist(*,6) = strarr_ravedata_all(*,i_col_dist+1); --- edistance
      strarr_ravedata_dist(*,7) = strarr_ravedata_all(*,i_col_height); --- height
      strarr_ravedata_dist(*,8) = strarr_ravedata_all(*,i_col_mh); --- M/H
      strarr_ravedata_dist(*,9) = strarr_ravedata_all(*,i_col_rcent); --- r_cent
      strarr_ravedata_dist(*,10) = strarr_ravedata_all(*,i_col_teff); --- T_eff

      i_col_ra_rave  = 0
      i_col_dec_rave = 1
      i_col_lon_rave = 0
      i_col_lat_rave = 1
      i_col_dist_rave = 2
      i_col_imag_rave = 3
      i_col_logg_rave = 4
      i_col_vrad_rave = 5
      i_col_err_dist_rave = 6
      i_col_height_rave = 7
      i_col_mh_rave = 8
      i_col_rcent_rave = 9
      i_col_teff_rave = 10

  ;    print,'rave_besancon_plot_all: dist = '+strarr_ravedata_dist(*,2)

  ;    if b_new_datafile then begin
  ;      strarr_ravelines = readfilelinestoarr(ravedatafile,STR_DONT_READ='#')
  ;      openw,lun,strmid(ravedatafile,0,strpos(ravedatafile,'.',/REVERSE_SEARCH))+'_Imag.dat',/GET_LUN
  ;      for i=0UL, i_ndatalines-1 do begin
  ;        indarr = where(strarr_ravedata_dist(i,8) eq strarr_ravedata(*,9))
  ;        if n_elements(indarr) gt 1 or indarr(0) gt -1 then begin
  ;          strarr_ravedata_dist(i,9) = strarr_ravedata(indarr(0),2)
  ;          print,'rave_besancon_plot_all: strarr_ravedata_dist(',i,',9)=',strarr_ravedata_dist(i,9),', dist = ',strarr_ravedata_dist(i,2)
  ;          printf,lun,strarr_ravelines(i+1)+','+strarr_ravedata_dist(i,9)
  ;        end else begin
  ;          print,'rave_besancon_plot_all: strarr_ravedata_dist(i=',i,', 8) = ',strarr_ravedata_dist(i,8)
  ;          print,'rave_besancon_plot_all: indarr = ',indarr
  ;          stop
  ;        end
  ;      endfor
  ;      free_lun,lun
  ;      strarr_ravelines = 0
  ;    end else begin
  ;      strarr_ravedata_dist(*,9) = strarr_ravedata_all(*,i_col_imag); --- Imag
  ;   end
      strarr_ravedata = 0
      strarr_ravedata_all = 0

      ; --- log cut
      ; --- RAVE
      if b_log_cut and (not b_calc_errors) then begin
        indarr = where((double(strarr_ravedata_dist(*,i_col_logg_rave)) ge d_log_min) and (double(strarr_ravedata_dist(*,i_col_logg_rave)) lt d_log_max))
        print,'rave_besancon_plot_all: size(indarr) = ',size(indarr)
        strarr_ravedata_dist = strarr_ravedata_dist(indarr,*)
        print,'rave_besancon_plot_all: size(strarr_ravedata_dist) = ',size(strarr_ravedata_dist)
      end
      print,'rave_besancon_plot_all: max(dist) = ',max(double(strarr_ravedata_dist(*,i_col_dist_rave)))
  ;    stop

      if b_calc_errors then begin
        ; --- calculate distance error
        dbl_seed = 5.
        dblarr_temp = double(strarr_besancondata(*,i_col_dist_besancon))
        if b_breddels then begin
          add_noise,DBLARR_DATA = dblarr_temp,$
;                    DBLARR_LOGG = dblarr_logg_temp,$
                    DBL_SEED = dbl_seed,$
                    B_PERCENT = 1,$
                    DBL_PERCENTAGE = 22.1,$
                    DBL_DIVIDE_ERROR_BY = dbl_dist_breddels_divide_error_by
        end else begin
          dblarr_logg_temp = double(strarr_besancondata(*,i_col_logg_besancon))
          add_noise,DBLARR_DATA = dblarr_temp,$
                    DBLARR_LOGG = dblarr_logg_temp,$
                    DBL_SEED = dbl_seed,$
                    B_PERCENT = 1,$
                    DBLARR_RAVE_LOGG = double(strarr_ravedata_dist(*,i_col_logg_rave)),$
                    DBLARR_RAVE_DIST = double(strarr_ravedata_dist(*,i_col_dist_rave)),$
                    DBLARR_RAVE_EDIST = double(strarr_ravedata_dist(*,i_col_err_dist_rave)),$
                    DBL_DIVIDE_ERROR_BY = dbl_dist_divide_error_by
        endelse
        strarr_besancondata(*,i_col_dist_besancon) = string(dblarr_temp)
        dblarr_temp = 0
        dblarr_logg_temp = 0

        ; --- write data array to new data file
        str_filename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))
        if b_dwarfs_only then begin
          str_filename_out = str_filename_out+'_dwarfs'
        end
        if b_giants_only then begin
          str_filename_out = str_filename_out+'_giants'
        end
        str_filename_out = str_filename_out+'_with_errors'
        if b_breddels then $
        str_filename_out = str_filename_out+'_breddels'

        str_temp = strtrim(string(dbl_logg_divide_error_by),2)
        str_filename_out = str_filename_out+'_errdivby_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_mh_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_teff_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_vrad_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)

        str_temp = strtrim(string(dbl_dist_divide_error_by),2)
        str_filename_out = str_filename_out+'_'+strmid(str_temp,0,4)
  ;        endif

;        if b_breddels then $
;          str_filename_out = str_filename_out + '_breddels'

        str_filename_out_b = str_filename_out+'+snr.dat'
        str_filename_out = str_filename_out+'.dat'
        openw,lund,str_filename_out,/GET_LUN
          if b_calc_snr then begin
            openw,lune,str_filename_out_b,/GET_LUN
          endif
          intarr_size = size(strarr_besancondata)
          for ll=0ul,intarr_size(1)-1 do begin
            str_line = strarr_besancondata(ll,0)
            for mm=1ul,intarr_size(2)-1 do begin
              str_line = str_line + ' ' + strarr_besancondata(ll,mm)
            endfor
            print,'rave_besancon_plot_all: printing line ll=',ll,' = '+str_line
            printf,lund,str_line
            if b_calc_snr then begin
              str_line_b = str_line + ' ' + string(dblarr_snr_besancon(ll)); + ' ' + string(o_dblarr_err_teff(ll)) +' '+string(o_dblarr_err_mh(ll)) + ' ' +string(o_dblarr_err_logg(ll))
              printf,lune,str_line_b
            endif
          endfor
          o_dblarr_err_teff = 0
          o_dblarr_err_mh = 0
          o_dblarr_err_logg = 0
  ;          o_dblarr_snr_teff = 0
  ;          o_dblarr_snr_mh = 0
  ;          o_dblarr_snr_logg = 0
          if b_calc_snr then begin
            free_lun,lune
            print,'rave_besancon_plot_all: besancondatafile '+str_filename_out_b+' written'
          end
        free_lun,lund
  ;      openw,lund,str_filename_out,/GET_LUN
  ;        intarr_size = size(strarr_besancondata)
  ;        for ll=0ul,intarr_size(1)-1 do begin
  ;          str_line = strarr_besancondata(ll,0)
  ;          for mm=1ul,intarr_size(2)-1 do begin
  ;            str_line = str_line + ' ' + strarr_besancondata(ll,mm)
  ;          endfor
  ;          printf,lund,str_line
  ;        endfor
  ;      free_lun,lund
        print,'rave_besancon_plot_all: besancondatafile '+str_filename_out+' written'
      end else begin


      ; --- plot vrad versus distance for I=9.-12.
        xrangeset = [0.,3.]
        yrangeset = [-150.,150.]
        dbl_xmax = dbl_xmax_dist
        dbl_ymax = dbl_xmax_vrad
        xcol_besancon = i_col_dist_besancon
        ycol_besancon = i_col_vrad_besancon
        xcol_rave = i_col_dist_rave
        ycol_rave = i_col_vrad_rave
        icol_rave = i_col_imag_rave
        if b_do_dist_vrad_9_12 then begin
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'dist_vrad'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          openw,lun_deb,str_path_temp+'logfile.log',/GET_LUN
          printf,lun_deb,'      besancon_rave_plot_two_cols,PATH                        = ',str_path
          printf,lun_deb,'                                  SUBPATH                     = ',str_sub_path
          printf,lun_deb,'                                  RAVEDATAFILE                = ',str_ravedatafile
          printf,lun_deb,'                                  BESANCONDATAFILE            = ',besancondatafile
          printf,lun_deb,'                                  STRARR_RAVE_DATA            = strarr_ravedata_dist'
          printf,lun_deb,'                                  STRARR_BESANCON_DATA        = strarr_besancondata'
          printf,lun_deb,'                                  FIELDSFILE                  = ',fieldsfile
          printf,lun_deb,'                                  XCOLRAVE                    = ',xcol_rave
          printf,lun_deb,'                                  XCOLBESANCON                = ',xcol_besancon
          printf,lun_deb,'                                  XTITLE                      = Distance [kpc]'
          printf,lun_deb,'                                  XRANGESET                   = ',xrangeset
          printf,lun_deb,'                                  YCOLRAVE                    = ',ycol_rave
          printf,lun_deb,'                                  YCOLBESANCON                = ',ycol_besancon
          printf,lun_deb,'                                  YTITLE                      = Radial Velocity [km/s]'
          printf,lun_deb,'                                  YRANGESET                   = ',yrangeset
          printf,lun_deb,'                                  IRANGE                      = ',irange
          printf,lun_deb,'                                  ICOLRAVE                    = ',icol_rave
          printf,lun_deb,'                                  ICOLBESANCON                = ',icol_besancon
          printf,lun_deb,'                                  FORCEXRANGE                 = 0'
          printf,lun_deb,'                                  FORCEYRANGE                 = 0'
          printf,lun_deb,'                                  REJECTVALUEX                = 15'
          printf,lun_deb,'                                  REJECTVALUEY                = 100000.'
          printf,lun_deb,'                                  LONLAT                      = ',b_lonlat
          printf,lun_deb,'                                  CALCSAMPLES                 = ',b_calcsamples
          printf,lun_deb,'                                  I_NSAMPLES                  = ',i_nsamples
          printf,lun_deb,'                                  XYTITLE                     = [dist,vrad]'
          printf,lun_deb,'                                  B_HIST                      = 1'
          printf,lun_deb,'                                  B_POP_ID                    = ',b_pop_id
          printf,lun_deb,'                                  STAR_TYPES_COL              = ',int_col_star_types
          printf,lun_deb,'                                  B_CALCNBINS                 = ',b_calcnbins
          printf,lun_deb,'                                  NBINSMIN                    = ',nbinsmin
          printf,lun_deb,'                                  NBINSMAX                    = ',nbinsmax
          printf,lun_deb,'                                  B_I_SEARCH                  = ',b_i_search
          printf,lun_deb,'                                  DBL_XMAX                    = ',dbl_xmax      ; -- colour range x value
          printf,lun_deb,'                                  DBL_YMAX                    = ',dbl_ymax      ; -- colour range y value
          printf,lun_deb,'                                  B_PLOT_MEAN_KST             = ',b_plot_mean_kst
          printf,lun_deb,'                                  I_COL_LON_BESANCON          = ',i_col_lon_besancon
          printf,lun_deb,'                                  I_COL_LAT_BESANCON          = ',i_col_lat_besancon
          printf,lun_deb,'                                  I_COL_LOGG_RAVE             = ',i_col_logg_rave
          printf,lun_deb,'                                  I_COL_LOGG_BESANCON         = ',i_col_logg_besancon
          printf,lun_deb,'                                  B_SELECT_FROM_IMAG_AND_LOGG = ',b_select_from_imag_and_logg

          free_lun,lun_deb
          besancon_rave_plot_two_cols,PATH                        = str_path,$
                                      SUBPATH                     = str_sub_path,$
                                      RAVEDATAFILE                = ravedatafile,$
                                      BESANCONDATAFILE            = besancondatafile,$
                                      STRARR_RAVE_DATA            = strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA        = strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE                  = fieldsfile,$
                                      XCOLRAVE                    = xcol_rave,$
                                      XCOLBESANCON                = xcol_besancon,$
                                      XTITLE                      = 'Distance [kpc]',$
                                      XRANGESET                   = xrangeset,$
                                      YCOLRAVE                    = ycol_rave,$
                                      YCOLBESANCON                = ycol_besancon,$
                                      YTITLE                      = 'Radial Velocity [km/s]',$
                                      YRANGESET                   = yrangeset,$
                                      IRANGE                      = irange,$
                                      ICOLRAVE                    = icol_rave,$
                                      ICOLBESANCON                = icol_besancon,$
                                      FORCEXRANGE                 = 0,$
                                      FORCEYRANGE                 = 0,$
                                      REJECTVALUEX                = 15,$
                                      REJECTVALUEY                = 100000.,$
                                      LONLAT                      = b_lonlat,$
                                      CALCSAMPLES                 = b_calcsamples,$
                                      I_NSAMPLES                  = i_nsamples,$
                                      XYTITLE                     = ['dist','vrad'],$
                                      B_HIST                      = 1,$
                                      B_POP_ID                    = b_pop_id,$
                                      STAR_TYPES_COL              = int_col_star_types,$
                                      B_CALCNBINS                 = b_calcnbins,$
                                      NBINSMIN                    = nbinsmin,$
                                      NBINSMAX                    = nbinsmax,$
                                      B_I_SEARCH                  = b_i_search,$
                                      DBL_XMAX                    = dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX                    = dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST             = b_plot_mean_kst,$
                                      I_COL_LON_BESANCON          = i_col_lon_besancon,$
                                      I_COL_LAT_BESANCON          = i_col_lat_besancon,$
                                      I_COL_LOGG_RAVE             = i_col_logg_rave,$
                                      I_COL_LOGG_BESANCON         = i_col_logg_besancon,$
                                      B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
        if b_do_dist_vrad_9_10 then begin
          irange = [9.,10.]
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Radial Velocity [km/s]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','vrad'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                    B_I_SEARCH=b_i_search,$
                                    DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                    DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                    B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
        if b_do_dist_vrad_10_11 then begin
          irange = [10.,11.]
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Radial Velocity [km/s]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','vrad'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                    B_I_SEARCH=b_i_search,$
                                    DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                    DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                    B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
        if b_do_dist_vrad_11_12 then begin
          irange = [11.,12.]
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Radial Velocity [km/s]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','vrad'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                    B_I_SEARCH=b_i_search,$
                                    DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                    DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                    B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
        if b_do_dist_vrad_9_10_5 then begin
          irange = [9.,10.5]
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Radial Velocity [km/s]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','vrad'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                    B_I_SEARCH=b_i_search,$
                                    DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                    DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                    B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
        if b_do_dist_vrad_10_5_12 then begin
          irange = [10.5,12.]
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Radial Velocity [km/s]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','vrad'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                    B_I_SEARCH=b_i_search,$
                                    DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                    DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                    B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif

        if b_do_dist_height_9_12 then begin
      ; --- plot dist versus z for I=9.-12.
          xrangeset = [0.,3.]
          yrangeset = [-3.,3.]
          dbl_xmax = dbl_xmax_dist
          dbl_ymax = dbl_xmax_height
          xcol_besancon = i_col_dist_besancon
          if b_sanjib then begin
            ycol_besancon = i_col_height_san
          end else begin
            ycol_besancon = i_col_height_besancon
          end
          if xcol_besancon eq 0 then $
            xcol_besancon = 0.0001
          if ycol_besancon eq 0 then $
            ycol_besancon = 0.0001
          if icol_besancon eq 0 then $
            icol_besancon = 0.0001
          xcol_rave = i_col_dist_rave
          ycol_rave = i_col_height_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'dist_height'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='z [kpc]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','z'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif

        if b_do_vrad_height_9_12 then begin
      ; --- plot vrad versus z for I=9.-12.
          xrangeset = [-300.,300.]
          yrangeset = [-3.,3.]
          dbl_xmax = dbl_xmax_dist
          dbl_ymax = dbl_xmax_height
          xcol_besancon = 3
          if b_sanjib then begin
            ycol_besancon = i_col_height_san
          end else begin
            ycol_besancon = i_col_height_besancon
          end
          if xcol_besancon eq 0 then $
            xcol_besancon = 0.0001
          if ycol_besancon eq 0 then $
            ycol_besancon = 0.0001
          if icol_besancon eq 0 then $
            icol_besancon = 0.0001
          xcol_rave = i_col_vrad_rave
          ycol_rave = i_col_height_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'vrad_height'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Radial Velocity [km/s]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='z [kpc]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['vrad','z'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif

        if b_do_height_MH_9_12 then begin
      ; --- plot height versus M/H for I=9.-12.
          xrangeset = [-3.,3.]
          yrangeset = [-3.,1.2]
          dbl_xmax = dbl_xmax_height
          dbl_ymax = dbl_xmax_MH
          if b_sanjib then begin
            xcol_besancon = i_col_height_san
          end else begin
            xcol_besancon = i_col_height_besancon
          end
          ycol_besancon = i_col_feh_besancon
          if xcol_besancon eq 0 then $
            xcol_besancon = 0.0001
          if ycol_besancon eq 0 then $
            ycol_besancon = 0.0001
          if icol_besancon eq 0 then $
            icol_besancon = 0.0001
          xcol_rave = i_col_height_rave
          ycol_rave = i_col_mh_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'height_MH'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='z [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Metallicity [dex]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=99.90,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['z','MH'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif


        if b_do_rcent_height_9_12 then begin
      ; --- plot height versus z for I=9.-12.
          xrangeset = [5.,11.]
          yrangeset = [-3.,3.]
          dbl_xmax = dbl_xmax_rcent
          dbl_ymax = dbl_xmax_z
          if b_sanjib then begin
            xcol_besancon = i_col_rcent_san
          end else begin
            xcol_besancon = i_col_rcent_besancon
          end
          ycol_besancon = i_col_height_besancon
          if xcol_besancon eq 0 then $
            xcol_besancon = 0.0001
          if ycol_besancon eq 0 then $
            ycol_besancon = 0.0001
          if icol_besancon eq 0 then $
            icol_besancon = 0.0001
          xcol_rave = i_col_rcent_rave
          ycol_rave = i_col_height_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'rcent_height'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='r!Dcent!N [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='z [kpc]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=99.90,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['r_c','z'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif

        if b_do_rcent_MH_9_12 then begin
      ; --- plot height versus M/H for I=9.-12.
          xrangeset = [5.,11.]
          print,'rave_besancon_plot_all: xrangeset = ',xrangeset
          yrangeset = [-3.,1.2]
          dbl_xmax = dbl_xmax_rcent
          dbl_ymax = dbl_xmax_MH
          if b_sanjib then begin
            xcol_besancon = i_col_rcent_san
          end else begin
            xcol_besancon = i_col_rcent_besancon
          end
          ycol_besancon = i_col_feh_besancon
          xcol_rave = i_col_rcent_rave
          ycol_rave = i_col_mh_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'rcent_MH'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='r!Dcent!N [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='Metallicity [dex]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=99.90,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['r_c','mh'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif

        if b_do_dist_Teff_9_12 then begin
      ; --- plot dist versus z for I=9.-12.
          xrangeset = [0.,10.]
          yrangeset = [3000.,7000.]
          dbl_xmax = dbl_xmax_dist
          dbl_ymax = dbl_xmax_Teff
          xcol_besancon = i_col_dist_bes
          if b_sanjib then begin
            ycol_besancon = i_col_teff_san
          end else begin
            ycol_besancon = i_col_teff_bes
          end
          xcol_rave = i_col_dist_rave
          ycol_rave = i_col_height_rave
          icol_rave = i_col_imag_rave
          irange = [9.,12.]
          if b_zwitter then begin
            if i_loop eq 0 then begin
              str_path = str_path_bak + 'YY/'
            end else if i_loop eq 1 then begin
              str_path = str_path_bak +'Dart/'
            end else if i_loop eq 2 then begin
              str_path = str_path_bak +'Padova/'
            end
          end else if b_breddels then begin
            str_path = str_path_bak + 'Breddels/'
          end
          spawn,'mkdir '+str_path
          str_sub_path = 'dist_Teff'
          spawn,'mkdir '+str_path+str_sub_path
          str_path_temp = str_path + str_sub_path + 'I9.00-12.0/'
          spawn,'mkdir '+str_path_temp
          besancon_rave_plot_two_cols,PATH=str_path,$
                                      SUBPATH=str_sub_path,$
                                      RAVEDATAFILE=ravedatafile,$
                                      BESANCONDATAFILE=besancondatafile,$
                                      STRARR_RAVE_DATA=strarr_ravedata_dist,$
                                      STRARR_BESANCON_DATA=strarr_besancondata,$
                                  I_STR_PIXELMAP       = str_pixelmap,$
                                      FIELDSFILE=fieldsfile,$
                                      XCOLRAVE=xcol_rave,$
                                      XCOLBESANCON=xcol_besancon,$
                                      XTITLE='Distance [kpc]',$
                                      XRANGESET=xrangeset,$
                                      YCOLRAVE=ycol_rave,$
                                      YCOLBESANCON=ycol_besancon,$
                                      YTITLE='T!Deff!N [K]',$
                                      YRANGESET=yrangeset,$
                                      IRANGE=irange,$
                                      ICOLRAVE=icol_rave,$
                                      ICOLBESANCON=icol_besancon,$
                                      FORCEXRANGE=0,$
                                      FORCEYRANGE=0,$
                                      REJECTVALUEX=15,$
                                      REJECTVALUEY=100000.,$
                                      LONLAT=b_lonlat,$
                                      CALCSAMPLES=b_calcsamples,$
                                      I_NSAMPLES=i_nsamples,$
                                      XYTITLE=['dist','Teff'],$
                                      B_HIST=1,$
                                      B_POP_ID             = b_pop_id,$
                                      STAR_TYPES_COL=int_col_star_types,$
                                      B_CALCNBINS=b_calcnbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      B_I_SEARCH=b_i_search,$
                                      DBL_XMAX=dbl_xmax,$      ; -- colour range x value
                                      DBL_YMAX=dbl_ymax,$      ; -- colour range y value
                                      B_PLOT_MEAN_KST=b_plot_mean_kst,$
                                    I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                    I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                    I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                    I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                    B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing
      ;                              TEST=1
        endif
      endelse
    endfor
  end
 endelse
end
