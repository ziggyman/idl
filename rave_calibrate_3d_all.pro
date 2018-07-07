pro rave_calibrate_3d_all


  ; --- TODO: plot cgsurf for surface derived from x vs y and for surface derived from y vs x (get_smoothed_surface)
  ; ---       remove all clipped stars from all calculations

  int_niter = 1
  b_calib_mh = 0
  b_calib_cmh = 0
  b_calib_mh_cmh = 1
  b_without_afe = 0
  b_afe_first_run_only = 1
  b_calib_vs_raw = 1
  b_dwarfs_only = 0
  b_giants_only = 0

  if b_calib_mh_cmh then begin
    b_calib_mh = 1
    b_calib_cmh = 1
  endif

  str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  strarr_data_rave = readfiletostrarr(str_filename_rave,' ',HEADER=strarr_header_all)

  ; --- column numbers rave file
  int_col_teff_rave_all = 19
  int_col_logg_rave_all = 20
  int_col_mh_rave_all   = 21
  int_col_cmh_rave_all  = 23
  int_col_afe_rave_all  = 22
  int_col_s2n_rave_all  = 34
  int_col_stn_rave_all  = 35

  ; --- fill arrays rave file
  dblarr_logg_rave_all = double(strarr_data_rave(*,int_col_logg_rave_all))
  dblarr_teff_rave_all = double(strarr_data_rave(*,int_col_teff_rave_all))
  dblarr_mh_rave_all = double(strarr_data_rave(*,int_col_mh_rave_all))
  dblarr_afe_rave_all = double(strarr_data_rave(*,int_col_afe_rave_all))
  dblarr_stn_rave_all = double(strarr_data_rave(*,int_col_stn_rave_all))

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_rave_all,$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5

  indarr_logg_rave_all = lindgen(n_elements(dblarr_logg_rave_all))
  if b_dwarfs_only then begin
    dblarr_logg_rave_all = dblarr_logg_rave_all(indarr_dwarfs)
    dblarr_teff_rave_all = dblarr_teff_rave_all(indarr_dwarfs)
    dblarr_mh_rave_all = dblarr_mh_rave_all(indarr_dwarfs)
    dblarr_afe_rave_all = dblarr_afe_rave_all(indarr_dwarfs)
    dblarr_stn_rave_all = dblarr_stn_rave_all(indarr_dwarfs)
    indarr_logg_rave_all = indarr_dwarfs
  end else if b_giants_only then begin
    dblarr_logg_rave_all = dblarr_logg_rave_all(indarr_giants)
    dblarr_teff_rave_all = dblarr_teff_rave_all(indarr_giants)
    dblarr_mh_rave_all = dblarr_mh_rave_all(indarr_giants)
    dblarr_afe_rave_all = dblarr_afe_rave_all(indarr_giants)
    dblarr_stn_rave_all = dblarr_stn_rave_all(indarr_giants)
    indarr_logg_rave_all = indarr_giants
  endif

  dblarr_teff_rave_all_raw = dblarr_teff_rave_all
  dblarr_logg_rave_all_raw = dblarr_logg_rave_all
  dblarr_mh_rave_all_raw = dblarr_mh_rave_all
  dblarr_afe_rave_all_raw = dblarr_afe_rave_all

  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh_rave_all,$
                               I_DBLARR_AFE           = dblarr_afe_rave_all,$
                               I_DBLARR_TEFF          = dblarr_teff_rave_all,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_logg_rave_all,$; --- old calibration
                               I_DBLARR_STN           = dblarr_stn_rave_all,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = strarr_cmh_rave_all,$;           --- string array
                               I_DBL_REJECTVALUE      = 9.99,$; --- double
                               I_DBL_REJECTERR        = 1,$;       --- double
                               I_B_SEPARATE           = 1
  dblarr_cmh_rave_all = double(strarr_cmh_rave_all)
  dblarr_cmh_rave_all_raw = dblarr_cmh_rave_all

  str_path = '/home/azuri/daten/rave/calibration/MH-from-FeH-and-aFe/3d/'
  if b_without_afe then begin
    str_path = str_path + 'without_aFe/'
  end else if b_afe_first_run_only then begin
    str_path = str_path + 'aFe_first_run_only/'
  end else begin
    str_path = str_path + 'with_aFe/'
  endelse
  spawn,'mkdir '+str_path
  if b_calib_mh_cmh then begin
    str_path = str_path + 'calib_mh_cmh/'
  end else if b_calib_cmh then begin
    str_path = str_path + 'calib_cmh/'
  end else if b_calib_mh then begin
    str_path = str_path + 'calib_mh/'
  endif
  spawn,'mkdir '+str_path
  if b_calib_vs_raw then begin
    str_path = str_path + 'calib_vs_raw/'
  end else begin
    str_path = str_path + 'calib_vs_calib/'
  endelse
  spawn,'mkdir '+str_path
  str_path = str_path + strtrim(string(int_niter),2)+'_iterations/'
  spawn,'mkdir '+str_path
  if b_dwarfs_only then begin
    str_path = str_path + 'dwarfs/'
    spawn,'mkdir '+str_path
  end else if b_giants_only then begin
    str_path = str_path + 'giants/'
    spawn,'mkdir '+str_path
  endif
  str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'
  str_filename_out = str_path + strmid(str_filename,strpos(str_filename,'/',/REVERSE_SEARCH)+1)
  str_filename_out = strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_calib.dat'

  str_filename_rave_out = str_path + strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
  str_filename_rave_out = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_calib.dat'

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
;  int_col_eteff_rave = 14
  int_col_logg_rave = 15
;  int_col_elogg_rave = 16
  int_col_mh_rave = 17
  int_col_cmh_rave = 18
;  int_col_emh_rave = 18
  int_col_afe_rave = 19
  int_col_stn_rave = 20
  int_col_source_ref = 21

  ; --- fill arrays external file
  dblarr_teff_rave = double(strarr_data(*,int_col_teff_rave))
  dblarr_teff_ref = double(strarr_data(*,int_col_teff_ref))

  indarr_teff_temp = where((dblarr_teff_ref lt 15000.) and (dblarr_teff_rave lt 15000.), COMPLEMENT=indarr_teff_prob)
  strarr_data = strarr_data(indarr_teff_temp,*)

  dblarr_teff_rave = double(strarr_data(*,int_col_teff_rave))
  dblarr_logg_rave = double(strarr_data(*,int_col_logg_rave))
  dblarr_mh_rave = double(strarr_data(*,int_col_mh_rave))
  dblarr_afe_rave = double(strarr_data(*,int_col_afe_rave))
  dblarr_stn_rave = double(strarr_data(*,int_col_stn_rave))

  dblarr_teff_ref = double(strarr_data(*,int_col_teff_ref))
  dblarr_logg_ref = double(strarr_data(*,int_col_logg_ref))
  dblarr_mh_ref = double(strarr_data(*,int_col_mh_ref))
  dblarr_afe_ref = double(strarr_data(*,int_col_afe_ref))

  indarr_logg = where(abs(dblarr_logg_ref) lt 0.0000001)
  dblarr_logg_ref_temp = dblarr_logg_ref
  dblarr_logg_ref_temp(indarr_logg) = dblarr_logg_rave(indarr_logg)
  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_ref_temp,$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5
  indarr_logg_ref = lindgen(n_elements(dblarr_logg_ref_temp))
  if b_dwarfs_only then begin
    dblarr_teff_rave = dblarr_teff_rave(indarr_dwarfs)
    dblarr_logg_rave = dblarr_logg_rave(indarr_dwarfs)
    dblarr_mh_rave = dblarr_mh_rave(indarr_dwarfs)
    dblarr_afe_rave = dblarr_afe_rave(indarr_dwarfs)
    dblarr_stn_rave = dblarr_stn_rave(indarr_dwarfs)

    dblarr_teff_ref = dblarr_teff_ref(indarr_dwarfs)
    dblarr_logg_ref = dblarr_logg_ref(indarr_dwarfs)
    dblarr_mh_ref = dblarr_mh_ref(indarr_dwarfs)
    dblarr_afe_ref = dblarr_afe_ref(indarr_dwarfs)

    indarr_logg_ref = indarr_dwarfs
  end else if b_giants_only then begin
    dblarr_teff_rave = dblarr_teff_rave(indarr_giants)
    dblarr_logg_rave = dblarr_logg_rave(indarr_giants)
    dblarr_mh_rave = dblarr_mh_rave(indarr_giants)
    dblarr_afe_rave = dblarr_afe_rave(indarr_giants)
    dblarr_stn_rave = dblarr_stn_rave(indarr_giants)

    dblarr_teff_ref = dblarr_teff_ref(indarr_giants)
    dblarr_logg_ref = dblarr_logg_ref(indarr_giants)
    dblarr_mh_ref = dblarr_mh_ref(indarr_giants)
    dblarr_afe_ref = dblarr_afe_ref(indarr_giants)

    indarr_logg_ref = indarr_giants
  endif
  dblarr_logg_ref_temp = 0
  indarr_dwarfs = 0
  indarr_giants = 0
  indarr_logg = 0

  dblarr_teff_rave_raw = dblarr_teff_rave
  dblarr_logg_rave_raw = dblarr_logg_rave
  dblarr_mh_rave_raw = dblarr_mh_rave
  dblarr_afe_rave_raw = dblarr_afe_rave

  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh_rave,$
                               I_DBLARR_AFE           = dblarr_afe_rave,$
                               I_DBLARR_TEFF          = dblarr_teff_rave,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_logg_rave,$; --- old calibration
                               I_DBLARR_STN           = dblarr_stn_rave,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = strarr_cmh_rave,$;           --- string array
                               I_DBL_REJECTVALUE      = 9.99,$; --- double
                               I_DBL_REJECTERR        = 1,$;       --- double
                               I_B_SEPARATE           = 1
  dblarr_cmh_rave = double(strarr_cmh_rave)
  dblarr_cmh_rave_raw = dblarr_cmh_rave

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

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_bes,$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5
  if b_dwarfs_only then begin
    dblarr_teff_bes = dblarr_teff_bes(indarr_dwarfs)
    dblarr_logg_bes = dblarr_logg_bes(indarr_dwarfs)
    dblarr_mh_bes = dblarr_mh_bes(indarr_dwarfs)
    intarr_age_bes = intarr_age_bes(indarr_dwarfs)
  end else if b_giants_only then begin
    dblarr_teff_bes = dblarr_teff_bes(indarr_giants)
    dblarr_logg_bes = dblarr_logg_bes(indarr_giants)
    dblarr_mh_bes = dblarr_mh_bes(indarr_giants)
    intarr_age_bes = intarr_age_bes(indarr_giants)
  endif

  openw,lun_mh,str_path+'index_mh.html',/GET_LUN
  openw,lun_cmh,str_path+'index_cmh.html',/GET_LUN
  openw,lun_teff,str_path+'index_teff.html',/GET_LUN
  openw,lun_logg,str_path+'index_logg.html',/GET_LUN
  openw,lun_afe,str_path+'index_afe.html',/GET_LUN

  printf,lun_mh,'<html><body><center>'
  printf,lun_cmh,'<html><body><center>'
  printf,lun_teff,'<html><body><center>'
  printf,lun_logg,'<html><body><center>'
  printf,lun_afe,'<html><body><center>'

  str_title_mh = '[m/H] [dex]'
  str_title_cmh = '[M/H] [dex]'
  str_title_teff = 'T!Deff!N [K]'
  str_title_logg = 'log g [dex]'
  str_title_afe = '[!4a!3/Fe] [dex]'
  str_title_stn = 'RAVE STN'

  str_mh = 'mH'
  str_cmh = 'MH'
  str_teff = 'Teff'
  str_logg = 'logg'
  str_afe = 'aFe'
  str_stn = 'STN'

  str_greek_capital_delta_letter = "104B
  str_greek_capital_delta = '!4'+String(str_greek_capital_delta_letter)+'!3'

  dblarr_range_teff = [3000.,8000.]
  dblarr_range_mh = [-2.5,1.]
  dblarr_range_cmh = [-2.5,1.]
  dblarr_range_logg = [0.,5.5]
  dblarr_range_afe = [0.,0.4]
  dblarr_range_stn = [0.,200.]

  dbl_grid_space_stn = 20.
  dbl_grid_space_teff = 500.
  dbl_grid_space_mh = 0.35
  dbl_grid_space_cmh = 0.35
  dbl_grid_space_logg = 0.55
  dbl_grid_space_afe = 0.04

  for i_iter = 0, int_niter-1 do begin
    for i_par = 0, 4 do begin
      if i_par eq 0 then begin
        if i_iter eq 0 then begin
          dblarr_calib = dblarr_teff_rave_raw
          dblarr_calib_all = dblarr_teff_rave_all_raw
        end else begin
          dblarr_calib = dblarr_teff_rave_calib
          dblarr_calib_all = dblarr_teff_rave_all_calib
        endelse
        if (i_iter eq 0) or b_calib_vs_raw then begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_raw
          dblarr_w = dblarr_cmh_rave_raw
          dblarr_x = dblarr_logg_rave_raw
          dblarr_y = dblarr_afe_rave_raw

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_raw
          dblarr_w_all = dblarr_cmh_rave_all_raw
          dblarr_x_all = dblarr_logg_rave_all_raw
          dblarr_y_all = dblarr_afe_rave_all_raw
        end else begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_calib
          dblarr_w = dblarr_cmh_rave_calib
          dblarr_x = dblarr_logg_rave_calib
          dblarr_y = dblarr_afe_rave_calib

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_calib
          dblarr_w_all = dblarr_cmh_rave_all_calib
          dblarr_x_all = dblarr_logg_rave_all_calib
          dblarr_y_all = dblarr_afe_rave_all_calib
        endelse

        dblarr_z_ref = dblarr_teff_ref
        dblarr_z_bes = dblarr_teff_bes

        str_u_title = str_title_stn
        str_v_title = str_title_mh
        str_w_title = str_title_cmh
        str_x_title = str_title_logg
        str_y_title = str_title_afe
        str_z_title = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'

        str_title_u = str_stn
        str_title_v = str_mh
        str_title_w = str_cmh
        str_title_x = str_logg
        str_title_y = str_afe
        str_title_z = 'd'+str_teff

        str_xtitle_hist = str_title_teff

        dblarr_range_u = dblarr_range_stn
        dblarr_range_v = dblarr_range_mh
        dblarr_range_w = dblarr_range_cmh
        dblarr_range_x = dblarr_range_logg
        dblarr_range_y = dblarr_range_afe
        dblarr_range_z = dblarr_range_teff

        dbl_rejectvalue_z_ref = 0.

        dblarr_grid_space_uvz = [dbl_grid_space_stn, dbl_grid_space_mh]
        dblarr_grid_space_uwz = [dbl_grid_space_stn, dbl_grid_space_cmh]
        dblarr_grid_space_uxz = [dbl_grid_space_stn, dbl_grid_space_logg]
        dblarr_grid_space_uyz = [dbl_grid_space_stn, dbl_grid_space_afe]
        dblarr_grid_space_vwz = [dbl_grid_space_mh, dbl_grid_space_cmh]
        dblarr_grid_space_vxz = [dbl_grid_space_mh, dbl_grid_space_logg]
        dblarr_grid_space_vyz = [dbl_grid_space_mh, dbl_grid_space_afe]
        dblarr_grid_space_wxz = [dbl_grid_space_cmh, dbl_grid_space_logg]
        dblarr_grid_space_wyz = [dbl_grid_space_cmh, dbl_grid_space_afe]
        dblarr_grid_space_xyz = [dbl_grid_space_logg, dbl_grid_space_afe]

        barr_mh = [0,1,0,0,0]
        barr_cmh = [0,0,1,0,0]
        barr_afe = [0,0,0,0,1]
      end else if i_par eq 1 then begin
        if i_iter eq 0 then begin
          dblarr_calib = dblarr_mh_rave_raw
          dblarr_calib_all = dblarr_mh_rave_all_raw
        end else begin
          dblarr_calib = dblarr_mh_rave_calib
          dblarr_calib_all = dblarr_mh_rave_all_calib
        endelse
        if (i_iter eq 0) or b_calib_vs_raw then begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_teff_rave_raw
          dblarr_w = dblarr_cmh_rave_raw
          dblarr_x = dblarr_logg_rave_raw
          dblarr_y = dblarr_afe_rave_raw

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_teff_rave_all_raw
          dblarr_w_all = dblarr_cmh_rave_all_raw
          dblarr_x_all = dblarr_logg_rave_all_raw
          dblarr_y_all = dblarr_afe_rave_all_raw
        end else begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_teff_rave_calib
          dblarr_w = dblarr_cmh_rave_calib
          dblarr_x = dblarr_logg_rave_calib
          dblarr_y = dblarr_afe_rave_calib

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_teff_rave_all_calib
          dblarr_w_all = dblarr_cmh_rave_all_calib
          dblarr_x_all = dblarr_logg_rave_all_calib
          dblarr_y_all = dblarr_afe_rave_all_calib
        endelse

        dblarr_z_ref = dblarr_mh_ref
        dblarr_z_bes = dblarr_mh_bes

        str_u_title = str_title_stn
        str_v_title = str_title_teff
        str_w_title = str_title_cmh
        str_x_title = str_title_logg
        str_y_title = str_title_afe
        str_z_title = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'

        str_title_u = str_stn
        str_title_v = str_teff
        str_title_w = str_cmh
        str_title_x = str_logg
        str_title_y = str_afe
        str_title_z = 'd'+str_mh

        str_xtitle_hist = str_title_mh

        dblarr_range_u = dblarr_range_stn
        dblarr_range_v = dblarr_range_teff
        dblarr_range_w = dblarr_range_cmh
        dblarr_range_x = dblarr_range_logg
        dblarr_range_y = dblarr_range_afe
        dblarr_range_z = dblarr_range_mh

        dbl_rejectvalue_z_ref = 0.

        dblarr_grid_space_uvz = [dbl_grid_space_stn, dbl_grid_space_teff]
        dblarr_grid_space_uwz = [dbl_grid_space_stn, dbl_grid_space_cmh]
        dblarr_grid_space_uxz = [dbl_grid_space_stn, dbl_grid_space_logg]
        dblarr_grid_space_uyz = [dbl_grid_space_stn, dbl_grid_space_afe]
        dblarr_grid_space_vwz = [dbl_grid_space_teff, dbl_grid_space_cmh]
        dblarr_grid_space_vxz = [dbl_grid_space_teff, dbl_grid_space_logg]
        dblarr_grid_space_vyz = [dbl_grid_space_teff, dbl_grid_space_afe]
        dblarr_grid_space_wxz = [dbl_grid_space_cmh, dbl_grid_space_logg]
        dblarr_grid_space_wyz = [dbl_grid_space_cmh, dbl_grid_space_afe]
        dblarr_grid_space_xyz = [dbl_grid_space_logg, dbl_grid_space_afe]

        barr_mh = [0,0,0,0,0]
        barr_cmh = [0,0,1,0,0]
        barr_afe = [0,0,0,0,1]
      end else if i_par eq 2 then begin
        if i_iter eq 0 then begin
          dblarr_calib = dblarr_cmh_rave_raw
          dblarr_calib_all = dblarr_cmh_rave_all_raw
        end else begin
          dblarr_calib = dblarr_cmh_rave_calib
          dblarr_calib_all = dblarr_cmh_rave_all_calib
        endelse
        if (i_iter eq 0) or b_calib_vs_raw then begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_raw
          dblarr_w = dblarr_teff_rave_raw
          dblarr_x = dblarr_logg_rave_raw
          dblarr_y = dblarr_afe_rave_raw

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_raw
          dblarr_w_all = dblarr_teff_rave_all_raw
          dblarr_x_all = dblarr_logg_rave_all_raw
          dblarr_y_all = dblarr_afe_rave_all_raw
        end else begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_calib
          dblarr_w = dblarr_teff_rave_calib
          dblarr_x = dblarr_logg_rave_calib
          dblarr_y = dblarr_afe_rave_calib

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_calib
          dblarr_w_all = dblarr_teff_rave_all_calib
          dblarr_x_all = dblarr_logg_rave_all_calib
          dblarr_y_all = dblarr_afe_rave_all_calib
        endelse

        dblarr_z_ref = dblarr_mh_ref
        dblarr_z_bes = dblarr_mh_bes

        str_u_title = str_title_stn
        str_v_title = str_title_mh
        str_w_title = str_title_teff
        str_x_title = str_title_logg
        str_y_title = str_title_afe
        str_z_title = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'

        str_title_u = str_stn
        str_title_v = str_mh
        str_title_w = str_teff
        str_title_x = str_logg
        str_title_y = str_afe
        str_title_z = 'd'+str_cmh

        str_xtitle_hist = str_title_cmh

        dblarr_range_u = dblarr_range_stn
        dblarr_range_v = dblarr_range_mh
        dblarr_range_w = dblarr_range_teff
        dblarr_range_x = dblarr_range_logg
        dblarr_range_y = dblarr_range_afe
        dblarr_range_z = dblarr_range_cmh

        dbl_rejectvalue_z_ref = 0.

        dblarr_grid_space_uvz = [dbl_grid_space_stn, dbl_grid_space_mh]
        dblarr_grid_space_uwz = [dbl_grid_space_stn, dbl_grid_space_teff]
        dblarr_grid_space_uxz = [dbl_grid_space_stn, dbl_grid_space_logg]
        dblarr_grid_space_uyz = [dbl_grid_space_stn, dbl_grid_space_afe]
        dblarr_grid_space_vwz = [dbl_grid_space_mh, dbl_grid_space_teff]
        dblarr_grid_space_vxz = [dbl_grid_space_mh, dbl_grid_space_logg]
        dblarr_grid_space_vyz = [dbl_grid_space_mh, dbl_grid_space_afe]
        dblarr_grid_space_wxz = [dbl_grid_space_teff, dbl_grid_space_logg]
        dblarr_grid_space_wyz = [dbl_grid_space_teff, dbl_grid_space_afe]
        dblarr_grid_space_xyz = [dbl_grid_space_logg, dbl_grid_space_afe]

        barr_mh = [0,1,0,0,0]
        barr_cmh = [0,0,0,0,0]
        barr_afe = [0,0,0,0,1]
      end else if i_par eq 3 then begin
        if i_iter eq 0 then begin
          dblarr_calib = dblarr_logg_rave_raw
          dblarr_calib_all = dblarr_logg_rave_all_raw
        end else begin
          dblarr_calib = dblarr_logg_rave_calib
          dblarr_calib_all = dblarr_logg_rave_all_calib
        endelse
        if (i_iter eq 0) or b_calib_vs_raw then begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_raw
          dblarr_w = dblarr_teff_rave_raw
          dblarr_x = dblarr_cmh_rave_raw
          dblarr_y = dblarr_afe_rave_raw

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_raw
          dblarr_w_all = dblarr_teff_rave_all_raw
          dblarr_x_all = dblarr_cmh_rave_all_raw
          dblarr_y_all = dblarr_afe_rave_all_raw
        end else begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_calib
          dblarr_w = dblarr_teff_rave_calib
          dblarr_x = dblarr_cmh_rave_calib
          dblarr_y = dblarr_afe_rave_calib

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_calib
          dblarr_w_all = dblarr_teff_rave_all_calib
          dblarr_x_all = dblarr_cmh_rave_all_calib
          dblarr_y_all = dblarr_afe_rave_all_calib
        endelse

        dblarr_z_ref = dblarr_logg_ref
        dblarr_z_bes = dblarr_logg_bes

        str_u_title = str_title_stn
        str_v_title = str_title_mh
        str_w_title = str_title_teff
        str_x_title = str_title_cmh
        str_y_title = str_title_afe
        str_z_title = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'

        str_title_u = str_stn
        str_title_v = str_mh
        str_title_w = str_teff
        str_title_x = str_cmh
        str_title_y = str_afe
        str_title_z = 'd'+str_logg

        str_xtitle_hist = str_title_logg

        dblarr_range_u = dblarr_range_stn
        dblarr_range_v = dblarr_range_mh
        dblarr_range_w = dblarr_range_teff
        dblarr_range_x = dblarr_range_cmh
        dblarr_range_y = dblarr_range_afe
        dblarr_range_z = dblarr_range_logg

        dbl_rejectvalue_z_ref = 0.

        dblarr_grid_space_uvz = [dbl_grid_space_stn, dbl_grid_space_mh]
        dblarr_grid_space_uwz = [dbl_grid_space_stn, dbl_grid_space_teff]
        dblarr_grid_space_uxz = [dbl_grid_space_stn, dbl_grid_space_cmh]
        dblarr_grid_space_uyz = [dbl_grid_space_stn, dbl_grid_space_afe]
        dblarr_grid_space_vwz = [dbl_grid_space_mh, dbl_grid_space_teff]
        dblarr_grid_space_vxz = [dbl_grid_space_mh, dbl_grid_space_cmh]
        dblarr_grid_space_vyz = [dbl_grid_space_mh, dbl_grid_space_afe]
        dblarr_grid_space_wxz = [dbl_grid_space_teff, dbl_grid_space_cmh]
        dblarr_grid_space_wyz = [dbl_grid_space_teff, dbl_grid_space_afe]
        dblarr_grid_space_xyz = [dbl_grid_space_cmh, dbl_grid_space_afe]

        barr_mh = [0,1,0,0,0]
        barr_cmh = [0,0,0,1,0]
        barr_afe = [0,0,0,0,1]
      end else if i_par eq 4 then begin
        if i_iter eq 0 then begin
          dblarr_calib = dblarr_afe_rave_raw
          dblarr_calib_all = dblarr_afe_rave_all_raw
        end else begin
          dblarr_calib = dblarr_afe_rave_calib
          dblarr_calib_all = dblarr_afe_rave_all_calib
        endelse
        if (i_iter eq 0) or b_calib_vs_raw then begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_raw
          dblarr_w = dblarr_teff_rave_raw
          dblarr_x = dblarr_cmh_rave_raw
          dblarr_y = dblarr_logg_rave_raw

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_raw
          dblarr_w_all = dblarr_teff_rave_all_raw
          dblarr_x_all = dblarr_cmh_rave_all_raw
          dblarr_y_all = dblarr_logg_rave_all_raw
        end else begin
          dblarr_u = dblarr_stn_rave
          dblarr_v = dblarr_mh_rave_calib
          dblarr_w = dblarr_teff_rave_calib
          dblarr_x = dblarr_cmh_rave_calib
          dblarr_y = dblarr_logg_rave_calib

          dblarr_u_all = dblarr_stn_rave_all
          dblarr_v_all = dblarr_mh_rave_all_calib
          dblarr_w_all = dblarr_teff_rave_all_calib
          dblarr_x_all = dblarr_cmh_rave_all_calib
          dblarr_y_all = dblarr_logg_rave_all_calib
        endelse

        dblarr_z_ref = dblarr_afe_ref
        dblarr_z_bes = dblarr_mh_bes

        str_u_title = str_title_stn
        str_v_title = str_title_mh
        str_w_title = str_title_teff
        str_x_title = str_title_cmh
        str_y_title = str_title_logg
        str_z_title = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'

        str_title_u = str_stn
        str_title_v = str_mh
        str_title_w = str_teff
        str_title_x = str_cmh
        str_title_y = str_logg
        str_title_z = 'd'+str_afe

        str_xtitle_hist = str_title_afe

        dblarr_range_u = dblarr_range_stn
        dblarr_range_v = dblarr_range_mh
        dblarr_range_w = dblarr_range_teff
        dblarr_range_x = dblarr_range_cmh
        dblarr_range_y = dblarr_range_logg
        dblarr_range_z = dblarr_range_afe

        dbl_rejectvalue_z_ref = 0.

        dblarr_grid_space_uvz = [dbl_grid_space_stn, dbl_grid_space_mh]
        dblarr_grid_space_uwz = [dbl_grid_space_stn, dbl_grid_space_teff]
        dblarr_grid_space_uxz = [dbl_grid_space_stn, dbl_grid_space_cmh]
        dblarr_grid_space_uyz = [dbl_grid_space_stn, dbl_grid_space_logg]
        dblarr_grid_space_vwz = [dbl_grid_space_mh, dbl_grid_space_teff]
        dblarr_grid_space_vxz = [dbl_grid_space_mh, dbl_grid_space_cmh]
        dblarr_grid_space_vyz = [dbl_grid_space_mh, dbl_grid_space_logg]
        dblarr_grid_space_wxz = [dbl_grid_space_teff, dbl_grid_space_cmh]
        dblarr_grid_space_wyz = [dbl_grid_space_teff, dbl_grid_space_logg]
        dblarr_grid_space_xyz = [dbl_grid_space_cmh, dbl_grid_space_logg]

        barr_mh = [0,1,0,0,0]
        barr_cmh = [0,0,0,1,0]
        barr_afe = [0,0,0,0,0]
      endif

      i_end = 9
;      if (b_without_afe) or (b_afe_first_run_only and (i_iter gt 0)) then $
;        i_end = 2
;      if i_par eq 3 then $
;        i_end = 5

      dblarr_z_rave = dblarr_calib
      dblarr_z_rave_all = dblarr_calib_all
      str_ztitle = str_z_title
      str_titlez = str_title_z
      dblarr_zrange = dblarr_range_z
      for i=0,i_end do begin
        b_is_mh = 0
        b_is_cmh = 0
        b_is_afe = 0
        if i eq 0 then begin
          if barr_mh(0) or barr_mh(1) then $
            b_is_mh = 1
          if barr_cmh(0) or barr_cmh(1) then $
            b_is_cmh = 1
          if barr_afe(0) or barr_afe(1) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_u
          dblarr_y_rave = dblarr_v

          dblarr_x_rave_all = dblarr_u_all
          dblarr_y_rave_all = dblarr_v_all

          str_xtitle = str_u_title
          str_ytitle = str_v_title

          str_titlex = str_title_u
          str_titley = str_title_v

          dblarr_xrange = dblarr_range_u
          dblarr_yrange = dblarr_range_v

          dblarr_grid_space = dblarr_grid_space_uvz
        end else if i eq 1 then begin
          if barr_mh(0) or barr_mh(2) then $
            b_is_mh = 1
          if barr_cmh(0) or barr_cmh(2) then $
            b_is_cmh = 1
          if barr_afe(0) or barr_afe(2) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_u
          dblarr_y_rave = dblarr_w

          dblarr_x_rave_all = dblarr_u_all
          dblarr_y_rave_all = dblarr_w_all

          str_xtitle = str_u_title
          str_ytitle = str_w_title

          str_titlex = str_title_u
          str_titley = str_title_w

          dblarr_xrange = dblarr_range_u
          dblarr_yrange = dblarr_range_w

          dblarr_grid_space = dblarr_grid_space_uwz
        end else if i eq 2 then begin
          if barr_mh(0) or barr_mh(3) then $
            b_is_mh = 1
          if barr_cmh(0) or barr_cmh(3) then $
            b_is_cmh = 1
          if barr_afe(0) or barr_afe(3) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_u
          dblarr_y_rave = dblarr_x

          dblarr_x_rave_all = dblarr_u_all
          dblarr_y_rave_all = dblarr_x_all

          str_xtitle = str_u_title
          str_ytitle = str_x_title

          str_titlex = str_title_u
          str_titley = str_title_x

          dblarr_xrange = dblarr_range_u
          dblarr_yrange = dblarr_range_x

          dblarr_grid_space = dblarr_grid_space_uxz
        end else if i eq 3 then begin
          if barr_mh(0) or barr_mh(4) then $
            b_is_mh = 1
          if barr_cmh(0) or barr_cmh(4) then $
            b_is_cmh = 1
          if barr_afe(0) or barr_afe(4) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_u
          dblarr_y_rave = dblarr_y

          dblarr_x_rave_all = dblarr_u_all
          dblarr_y_rave_all = dblarr_y_all

          str_xtitle = str_u_title
          str_ytitle = str_y_title

          str_titlex = str_title_u
          str_titley = str_title_y

          dblarr_xrange = dblarr_range_u
          dblarr_yrange = dblarr_range_y

          dblarr_grid_space = dblarr_grid_space_uyz
        end else if i eq 4 then begin
          if barr_mh(1) or barr_mh(2) then $
            b_is_mh = 1
          if barr_cmh(1) or barr_cmh(2) then $
            b_is_cmh = 1
          if barr_afe(1) or barr_afe(2) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_v
          dblarr_y_rave = dblarr_w

          dblarr_x_rave_all = dblarr_v_all
          dblarr_y_rave_all = dblarr_w_all

          str_xtitle = str_v_title
          str_ytitle = str_w_title

          str_titlex = str_title_v
          str_titley = str_title_w

          dblarr_xrange = dblarr_range_v
          dblarr_yrange = dblarr_range_w

          dblarr_grid_space = dblarr_grid_space_vwz
        end else if i eq 5 then begin
          if barr_mh(1) or barr_mh(3) then $
            b_is_mh = 1
          if barr_cmh(1) or barr_cmh(3) then $
            b_is_cmh = 1
          if barr_afe(1) or barr_afe(3) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_v
          dblarr_y_rave = dblarr_x

          dblarr_x_rave_all = dblarr_v_all
          dblarr_y_rave_all = dblarr_x_all

          str_xtitle = str_v_title
          str_ytitle = str_x_title

          str_titlex = str_title_v
          str_titley = str_title_x

          dblarr_xrange = dblarr_range_v
          dblarr_yrange = dblarr_range_x

          dblarr_grid_space = dblarr_grid_space_vxz
        end else if i eq 6 then begin
          if barr_mh(1) or barr_mh(4) then $
            b_is_mh = 1
          if barr_cmh(1) or barr_cmh(4) then $
            b_is_cmh = 1
          if barr_afe(1) or barr_afe(4) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_v
          dblarr_y_rave = dblarr_y

          dblarr_x_rave_all = dblarr_v_all
          dblarr_y_rave_all = dblarr_y_all

          str_xtitle = str_v_title
          str_ytitle = str_y_title

          str_titlex = str_title_v
          str_titley = str_title_y

          dblarr_xrange = dblarr_range_v
          dblarr_yrange = dblarr_range_y

          dblarr_grid_space = dblarr_grid_space_vyz
        end else if i eq 7 then begin
          if barr_mh(2) or barr_mh(3) then $
            b_is_mh = 1
          if barr_cmh(2) or barr_cmh(3) then $
            b_is_cmh = 1
          if barr_afe(2) or barr_afe(3) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_w
          dblarr_y_rave = dblarr_x

          dblarr_x_rave_all = dblarr_w_all
          dblarr_y_rave_all = dblarr_x_all

          str_xtitle = str_w_title
          str_ytitle = str_x_title

          str_titlex = str_title_w
          str_titley = str_title_x

          dblarr_xrange = dblarr_range_w
          dblarr_yrange = dblarr_range_x

          dblarr_grid_space = dblarr_grid_space_wxz
        end else if i eq 8 then begin
          if barr_mh(2) or barr_mh(4) then $
            b_is_mh = 1
          if barr_cmh(2) or barr_cmh(4) then $
            b_is_cmh = 1
          if barr_afe(2) or barr_afe(4) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_w
          dblarr_y_rave = dblarr_y

          dblarr_x_rave_all = dblarr_w_all
          dblarr_y_rave_all = dblarr_y_all

          str_xtitle = str_w_title
          str_ytitle = str_y_title

          str_titlex = str_title_w
          str_titley = str_title_y

          dblarr_xrange = dblarr_range_w
          dblarr_yrange = dblarr_range_y

          dblarr_grid_space = dblarr_grid_space_wyz
        end else if i eq 9 then begin
          if barr_mh(3) or barr_mh(4) then $
            b_is_mh = 1
          if barr_cmh(3) or barr_cmh(4) then $
            b_is_cmh = 1
          if barr_afe(3) or barr_afe(4) then $
            b_is_afe = 1

          dblarr_x_rave = dblarr_x
          dblarr_y_rave = dblarr_y

          dblarr_x_rave_all = dblarr_x_all
          dblarr_y_rave_all = dblarr_y_all

          str_xtitle = str_x_title
          str_ytitle = str_y_title

          str_titlex = str_title_x
          str_titley = str_title_y

          dblarr_xrange = dblarr_range_x
          dblarr_yrange = dblarr_range_y

          dblarr_grid_space = dblarr_grid_space_xyz
        end
;        end else if i_par eq 1 then begin
;          if i eq 0 then begin
;  ;          stop
;            dblarr_z_ref = dblarr_mh_ref(indarr_teff_temp)
;            dblarr_x_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_logg_rave_raw(indarr_teff_temp)
;            if i_iter eq 0 then begin
;              dblarr_z_rave_ref = dblarr_mh_rave_raw(indarr_teff_temp)
;              dblarr_z_rave_all = dblarr_mh_rave_all_raw
;            end else begin
;              dblarr_z_rave_ref = dblarr_mh_rave_ref_calib
;              dblarr_z_rave_all = dblarr_mh_rave_all_calib
;            endelse
;            dblarr_x_rave_all = dblarr_teff_rave_all_raw
;            dblarr_y_rave_all = dblarr_logg_rave_all_raw
;            dblarr_z_bes = dblarr_mh_bes
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = 'log g [dex]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'logg'
;            str_title_z = 'dMH'
;            str_xtitle_hist = '[M/H] [dex]'
;            dblarr_xrange = [3000.,8000.]
;            dblarr_yrange = [0.,5.5]
;            dblarr_zrange = [-2.5,1.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.15]
;          end else if i eq 1 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_teff_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = 'T!Deff!N [K]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'Teff'
;            str_title_z = 'dMH'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [3000.,8000.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 300.]
;          end else if i eq 2 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_logg_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_logg_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = 'log g [dex]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'logg'
;            str_title_z = 'dMH'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [0.,5.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.25]
;          end else if i eq 3 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'aFe'
;            str_title_z = 'dMH'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [0.,0.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.025]
;          end else if i eq 4 then begin
;            dblarr_x_rave_ref = dblarr_logg_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_logg_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = 'log g [dex]'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'logg'
;            str_title_y = 'aFe'
;            str_title_z = 'dMH'
;            dblarr_xrange = [0.,5.5]
;            dblarr_yrange = [0.,0.4]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [0.25, 0.0125]
;          end else if i eq 5 then begin
;            dblarr_x_rave_ref = dblarr_teff_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_teff_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd[M/H] [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'aFe'
;            str_title_z = 'dMH'
;            dblarr_xrange = [0.,7500.]
;            dblarr_yrange = [0.,0.4]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.0125]
;          end
;        end else if i_par eq 2 then begin
;          if i eq 0 then begin
;            dblarr_z_ref = dblarr_logg_ref(indarr_teff_temp)
;            dblarr_x_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_mh_rave_raw(indarr_teff_temp)
;            if i_iter eq 0 then begin
;              dblarr_z_rave_ref = dblarr_logg_rave(indarr_teff_temp)
;              dblarr_z_rave_all = dblarr_logg_rave_all
;            end else begin
;              dblarr_z_rave_ref = dblarr_logg_rave_ref_calib
;              dblarr_z_rave_all = dblarr_logg_rave_all_calib
;            endelse
;            dblarr_x_rave_all = dblarr_teff_rave_all
;            dblarr_y_rave_all = dblarr_mh_rave_all
;            dblarr_z_bes = dblarr_logg_bes
;
;            print,'dblarr_logg_ref = ',dblarr_logg_ref
;            print,'dblarr_logg_rave = ',dblarr_logg_rave;
;
;
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = '[M/H] [dex]'
;            str_ztitle = 'd(log g) [dex]'
;            str_xtitle_hist = 'log g [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'MH'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [3000.,8000.]
;            dblarr_yrange = [-2.5,1.]
;            dblarr_zrange = [0.,5.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.1]
;          end else if i eq 1 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_teff_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = 'T!Deff!N [K]'
;            str_ztitle = 'd(log g) [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'Teff'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [3000.,8000.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 300.]
;          end else if i eq 2 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_mh_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_mh_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = '[M/H] [dex]'
;            str_ztitle = 'd(log g) [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'MH'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [-2.5,1.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.25]
;          end else if i eq 3 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd(log g) [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'aFe'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [0.,0.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.025]
;          end else if i eq 4 then begin
;            dblarr_x_rave_ref = dblarr_teff_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_teff_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd(log g) [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'aFe'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [3000.,8000.]
;            dblarr_yrange = [0.,0.4]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.0125]
;          end else if i eq 5 then begin
;            dblarr_x_rave_ref = dblarr_mh_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_mh_rave_all
;            dblarr_y_rave_all = dblarr_afe_rave_all_raw
;            str_xtitle = '[M/H] [dex]'
;            str_ytitle = '[!4a!3/Fe] [dex]'
;            str_ztitle = 'd(log g) [dex]'
;            str_title_x = 'MH'
;            str_title_y = 'aFe'
;            str_title_z = 'dlogg'
;            dblarr_xrange = [-2.5,1.]
;            dblarr_yrange = [0.,0.4]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [0.1, 0.0125]
;          end
;        end else if i_par eq 3 then begin
;          if i eq 0 then begin
;            dblarr_z_ref = dblarr_afe_ref(indarr_teff_temp)
;            dblarr_x_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_logg_rave_raw(indarr_teff_temp)
;            if i_iter eq 0 then begin
;              dblarr_z_rave_ref = dblarr_afe_rave_raw(indarr_teff_temp)
;              dblarr_z_rave_all = dblarr_afe_rave_all_raw
;            end else begin
;              dblarr_z_rave_ref = dblarr_afe_rave_ref_calib
;              dblarr_z_rave_all = dblarr_afe_rave_all_calib
;            endelse
;            dblarr_x_rave_all = dblarr_teff_rave_all_raw
;            dblarr_y_rave_all = dblarr_logg_rave_all_raw
;            dblarr_z_bes = dblarr_mh_bes
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = 'log g [dex]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'logg'
;            str_title_z = 'daFe'
;            str_xtitle_hist = '[!4a!3/Fe] [dex]'
;            dblarr_xrange = [3000.,8000.]
;            dblarr_yrange = [0.,5.5]
;            dblarr_zrange = [0.,0.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.15]
;          end else if i eq 1 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_teff_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_teff_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = 'T!Deff!N [K]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'Teff'
;            str_title_z = 'daFe'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [3000.,8000.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 300.]
;          end else if i eq 2 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_mh_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_mh_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = '[M/H] [dex]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'MH'
;            str_title_z = 'daFe'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [-2.5,1.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.25]
;          end else if i eq 3 then begin
;            dblarr_x_rave_ref = dblarr_stn_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_logg_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_stn_rave_all
;            dblarr_y_rave_all = dblarr_logg_rave_all_raw
;            str_xtitle = 'STN'
;            str_ytitle = 'log g [dex]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'STN'
;            str_title_y = 'logg'
;            str_title_z = 'daFe'
;            dblarr_xrange = [0.,200.]
;            dblarr_yrange = [0.,5.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [5., 0.15]
;          end else if i eq 4 then begin
;            dblarr_x_rave_ref = dblarr_teff_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_mh_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_teff_rave_all
;            dblarr_y_rave_all = dblarr_mh_rave_all_raw
;            str_xtitle = 'T!Deff!N [K]'
;            str_ytitle = '[M/H] [dex]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'Teff'
;            str_title_y = 'MH'
;            str_title_z = 'daFe'
;            dblarr_xrange = [3000.,8000.]
;            dblarr_yrange = [-2.5,1.]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [300., 0.1]
;          end else if i eq 5 then begin
;            dblarr_x_rave_ref = dblarr_mh_rave(indarr_teff_temp)
;            dblarr_y_rave_ref = dblarr_logg_rave_raw(indarr_teff_temp)
;            dblarr_x_rave_all = dblarr_mh_rave_all
;            dblarr_y_rave_all = dblarr_logg_rave_all_raw
;            str_xtitle = '[M/H] [dex]'
;            str_ytitle = 'log g [dex]'
;            str_ztitle = 'd[!4a!3/Fe] [dex]'
;            str_title_x = 'MH'
;            str_title_y = 'logg'
;            str_title_z = 'daFe'
;            dblarr_xrange = [-2.5,1.]
;            dblarr_yrange = [0.,5.5]
;            dbl_rejectvalue_z_ref = 0.
;            dblarr_grid_space = [0.1, 0.15]
;          end
;        endif

        if i eq 0 then begin
          str_plotname_root = str_path + strmid(str_filename,strpos(str_filename,'/',/REVERSE_SEARCH)+1)
          print,'str_plotname_root = <'+str_plotname_root+'>'
          str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
          str_plotname_root_orig = str_plotname_root
          str_plotname_root = str_plotname_root+'_' + str_titlez + '_vs_' + str_titlex + '-' + str_titley + '_3dbox'
          str_plotname_hist_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'_',/REVERSE_SEARCH)) + '_hist'
;          print,'str_plotname_root = <'+str_plotname_root+'>'
;          print,'str_plotname_hist_root = <'+str_plotname_hist_root+'>'
;          stop
        end else begin
          str_plotname_root = str_plotname_root_orig + '_' + str_titlez + '_vs_' + str_titlex + '-' + str_titley + '_3dbox'
          str_plotname_hist_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'_',/REVERSE_SEARCH)) + '_' + str_titlez + '_vs_' + str_titlex + '-' + str_titley + '_hist'
        endelse

        print,'dblarr_x_rave(0:10) = ',dblarr_x_rave(0:10)
        print,'dblarr_y_rave(0:10) = ',dblarr_y_rave(0:10)
        print,'dblarr_z_rave(0:10) = ',dblarr_z_rave(0:10)
        print,'dblarr_z_ref(0:10) = ',dblarr_z_ref(0:10)
        print,'dblarr_x_rave_all(0:10) = ',dblarr_x_rave_all(0:10)
        print,'dblarr_y_rave_all(0:10) = ',dblarr_y_rave_all(0:10)
        print,'dblarr_z_rave_all(0:10) = ',dblarr_z_rave_all(0:10)
;        stop

        b_do_calib = 1

;  b_calib_mh = 0
;  b_calib_cmh = 1
;  b_calib_mh_cmh = 0
;  b_without_afe = 0
;  b_afe_first_run_only = 0

        if (b_is_mh and (not(b_calib_mh))) or (b_is_cmh and (not(b_calib_cmh))) or (b_is_afe and (b_without_afe)) or (b_is_afe and b_afe_first_run_only and (i_iter gt 0)) then $
          b_do_calib = 0
        if b_do_calib then begin
          rave_calibrate_3d, I_DBLARR_Z_REF           = dblarr_z_ref,$
                            I_DBLARR_X_RAVE          = dblarr_x_rave,$
                            I_DBLARR_Y_RAVE          = dblarr_y_rave,$
                            IO_DBLARR_Z_RAVE         = dblarr_z_rave,$
                            I_DBLARR_X_ALL           = dblarr_x_rave_all,$
                            I_DBLARR_Y_ALL           = dblarr_y_rave_all,$
                            IO_DBLARR_Z_ALL          = dblarr_z_rave_all,$
                            I_DBLARR_Z_BES           = dblarr_z_bes,$
                            I_INTARR_AGE_BES         = intarr_age_bes,$
                            I_STR_XTITLE             = str_xtitle,$
                            I_STR_YTITLE             = str_ytitle,$
                            I_STR_ZTITLE             = str_ztitle,$
                            I_STR_TITLE_X            = str_titlex,$
                            I_STR_TITLE_Y            = str_titley,$
                            I_STR_TITLE_Z            = str_titlez,$
                            I_STR_HIST_XTITLE        = str_xtitle_hist,$
                            I_DBLARR_XRANGE          = dblarr_xrange,$
                            I_DBLARR_YRANGE          = dblarr_yrange,$
                            I_DBLARR_ZRANGE          = dblarr_zrange,$
                            I_STR_PLOTNAME_ROOT      = str_plotname_root + '_' + strtrim(string(i_iter), 2),$
                            I_STR_PLOTNAME_HIST_ROOT = str_plotname_hist_root + '_' + strtrim(string(i_iter), 2),$
                            I_DBL_REJECTVALUE_Z_REF  = dbl_rejectvalue_z_ref,$
                            I_DBLARR_GRID_SPACE      = dblarr_grid_space,$
                            I_INT_SIGMA_MINELEMENTS  = 5
          if str_title_z eq 'd'+str_teff then begin
            lun_html = lun_teff
          end else if str_title_z eq 'd'+str_mh then begin
            lun_html = lun_mh
          end else if str_title_z eq 'd'+str_logg then begin
            lun_html = lun_logg
          end else if str_title_z eq 'd'+str_afe then begin
            lun_html = lun_afe
          end else if str_title_z eq 'd'+str_cmh then begin
            lun_html = lun_cmh
          endif
          printf,lun_html,'<a href="'+strmid(str_plotname_hist_root,strpos(str_plotname_hist_root,'/',/REVERSE_SEARCH)+1)+'_'+strtrim(string(i_iter),2)+'_calib.gif">'+strmid(str_plotname_hist_root,strpos(str_plotname_hist_root,'/',/REVERSE_SEARCH)+1)+'_'+strtrim(string(i_iter),2)+'_calib<br><img src="'+strmid(str_plotname_hist_root,strpos(str_plotname_hist_root,'/',/REVERSE_SEARCH)+1)+'_'+strtrim(string(i_iter),2)+'_calib.gif"></a><br>'
        endif
      endfor
      if str_title_z eq 'd'+str_teff then begin
        dblarr_teff_rave_calib = dblarr_z_rave
        dblarr_teff_rave_all_calib = dblarr_z_rave_all
        strarr_data(indarr_teff_temp(indarr_logg_ref),int_col_teff_rave) = strtrim(string(dblarr_z_rave),2)
        strarr_data_rave(indarr_logg_rave_all,int_col_teff_rave_all) = strtrim(string(dblarr_z_rave_all),2)
      end else if str_title_z eq 'd'+str_mh then begin
        dblarr_mh_rave_calib = dblarr_z_rave
        dblarr_mh_rave_all_calib = dblarr_z_rave_all
        strarr_data(indarr_teff_temp(indarr_logg_ref),int_col_mh_rave) = strtrim(string(dblarr_z_rave),2)
        strarr_data_rave(indarr_logg_rave_all,int_col_mh_rave_all) = strtrim(string(dblarr_z_rave_all),2)
      end else if str_title_z eq 'd'+str_cmh then begin
        dblarr_cmh_rave_calib = dblarr_z_rave
        dblarr_cmh_rave_all_calib = dblarr_z_rave_all
        strarr_data(indarr_teff_temp(indarr_logg_ref),int_col_cmh_rave) = strtrim(string(dblarr_z_rave),2)
        strarr_data_rave(indarr_logg_rave_all,int_col_cmh_rave_all) = strtrim(string(dblarr_z_rave_all),2)
      end else if str_title_z eq 'd'+str_logg then begin
        dblarr_logg_rave_calib = dblarr_z_rave
        dblarr_logg_rave_all_calib = dblarr_z_rave_all
        strarr_data(indarr_teff_temp(indarr_logg_ref),int_col_logg_rave) = strtrim(string(dblarr_z_rave),2)
        strarr_data_rave(indarr_logg_rave_all,int_col_logg_rave_all) = strtrim(string(dblarr_z_rave_all),2)
      end else if str_title_z eq 'd'+str_afe then begin
        dblarr_afe_rave_calib = dblarr_z_rave
        dblarr_afe_rave_all_calib = dblarr_z_rave_all
        strarr_data(indarr_teff_temp(indarr_logg_ref),int_col_afe_rave) = strtrim(string(dblarr_z_rave),2)
        strarr_data_rave(indarr_logg_rave_all,int_col_afe_rave_all) = strtrim(string(dblarr_z_rave_all),2)
      endif
    endfor; parameters
  endfor; iterations

  printf,lun_mh,'</center></body></html>'
  printf,lun_cmh,'</center></body></html>'
  printf,lun_teff,'</center></body></html>'
  printf,lun_logg,'</center></body></html>'
  printf,lun_afe,'</center></body></html>'

  free_lun,lun_mh
  free_lun,lun_cmh
  free_lun,lun_teff
  free_lun,lun_logg
  free_lun,lun_afe
end
;  write_file, I_STRARR_DATA   = strarr_data,$
;              I_STRARR_HEADER = strarr_header,$
;              I_STR_FILENAME  = str_filename_out
;
;  write_file, I_STRARR_DATA   = strarr_data_rave,$
;              I_STRARR_HEADER = strarr_header_all,$
;              I_STR_FILENAME  = str_filename_rave_out
;
;  rave_compare_to_external_and_calibrate, I_STR_PATH         = str_path,$
;                                          I_STR_FILENAME     = str_filename_out,$
;                                          I_STR_RAVEFILENAME = str_filename_rave_out
;
;  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
;                     I_B_DWARFS     = 0,$
;                     I_INT_COL_FIT  = int_col_mh_rave_all,$
;                     I_STR_OUTFILENAME = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_gaussians_mH'
;
;  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
;                     I_B_DWARFS     = 1,$
;                     I_INT_COL_FIT  = int_col_mh_rave_all,$
;                     I_STR_OUTFILENAME = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_gaussians_mH'
;
;  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
;                     I_B_DWARFS     = 0,$
;                     I_INT_COL_FIT  = int_col_cmh_rave_all,$
;                     I_STR_OUTFILENAME = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_gaussians_MH'
;
;  rave_mh_gaussfits, I_STR_FILENAME = str_filename_rave_out,$
;                     I_B_DWARFS     = 1,$
;                     I_INT_COL_FIT  = int_col_cmh_rave_all,$
;                     I_STR_OUTFILENAME = strmid(str_filename_rave_out,0,strpos(str_filename_rave_out,'.',/REVERSE_SEARCH))+'_gaussians_MH'
;
;end
