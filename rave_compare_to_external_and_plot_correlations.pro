pro rave_compare_to_external_and_plot_correlations

  b_orig = 0

  b_do_all = 0
  b_with_feh = 1
  b_do_calib_x_vs_ext = 0
  int_sigma_minelements = 5
  int_sigma_nbins = 20

    str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  if b_orig then begin
    str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'
    str_path = '/home/azuri/daten/rave/calibration/calib-orig/'
  end else begin
    str_filename = '/home/azuri/daten/rave/calibration/calib-mH-MH_MH-from-FeH-and-aFe_temp/all_found_calib.dat'
    str_path = '/home/azuri/daten/rave/calibration/calib-results-mH-MH/'
  endelse
  spawn,'rm -r '+str_path
  spawn,'mkdir '+str_path

  strarr_rave = readfiletostrarr(str_filename_rave,' ')
  int_col_teff = 19
  int_col_logg = 20
  int_col_mh   = 21
  int_col_afe  = 22
  int_col_s2n  = 34
  int_col_stn  = 35
  dblarr_rave_teff = double(strarr_rave(*,int_col_teff))
  dblarr_rave_logg = double(strarr_rave(*,int_col_logg))
  dblarr_rave_mh = double(strarr_rave(*,int_col_mh))
  dblarr_rave_afe = double(strarr_rave(*,int_col_afe))
  dblarr_rave_s2n = double(strarr_rave(*,int_col_s2n))
  dblarr_rave_stn = double(strarr_rave(*,int_col_stn))
  print,'dblarr_rave_teff(0:10) = ',dblarr_rave_teff(0:10)
  print,'dblarr_rave_logg(0:10) = ',dblarr_rave_logg(0:10)
  print,'dblarr_rave_mh(0:10) = ',dblarr_rave_mh(0:10)
  print,'dblarr_rave_afe(0:10) = ',dblarr_rave_afe(0:10)
  print,'dblarr_rave_s2n(0:10) = ',dblarr_rave_s2n(0:10)
  print,'dblarr_rave_stn(0:10) = ',dblarr_rave_stn(0:10)
  indarr_stn = where(dblarr_rave_stn lt 1.)
  if indarr_stn(0) ge 0 then $
    dblarr_rave_stn(indarr_stn) = dblarr_rave_s2n(indarr_stn)
  dblarr_rave_s2n = 0
  dblarr_rave_logg_last = dblarr_rave_logg

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_rave_logg,$
                                     O_INDARR_DWARFS  = indarr_dwarfs_all,$
                                     O_INDARR_GIANTS  = indarr_giants_all,$
                                     I_DBL_LIMIT_LOGG = 3.5

  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_rave_mh,$
                               I_DBLARR_AFE           = dblarr_rave_afe,$
                               I_DBLARR_TEFF          = dblarr_rave_teff,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_rave_logg,$; --- old calibration
                               I_DBLARR_STN           = dblarr_rave_stn,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = strarr_rave_cmh,$;           --- string array
                               I_DBL_REJECTVALUE      = 9.99,$; --- double
                               I_DBL_REJECTERR        = 1,$;       --- double
                               I_B_SEPARATE           = 1
  dblarr_rave_cmh = double(strarr_rave_cmh)
  dblarr_rave_cmh_orig = dblarr_rave_cmh

  ;dblarr_rave_teff_last = dblarr_rave_teff
  ;dblarr_rave_logg_last = dblarr_rave_logg
  ;dblarr_rave_mh_last   = dblarr_rave_mh
  ;dblarr_rave_cmh_last  = dblarr_rave_cmh
  ;dblarr_rave_afe_last  = dblarr_rave_afe
  print,'dblarr_rave_teff(0:10) = ',dblarr_rave_teff(0:10)
  print,'dblarr_rave_logg(0:10) = ',dblarr_rave_logg(0:10)
  print,'dblarr_rave_mh(0:10) = ',dblarr_rave_mh(0:10)
  print,'dblarr_rave_cmh(0:10) = ',dblarr_rave_cmh(0:10)
  print,'dblarr_rave_afe(0:10) = ',dblarr_rave_afe(0:10)
  print,'dblarr_rave_stn(0:10) = ',dblarr_rave_stn(0:10)
;  stop

  str_htmlfile = str_path + 'index_calib.html'
  openw,lun_html,str_htmlfile,/GET_LUN
  printf,lun_html,'<html><body><center>'
  ; --- 0: lon,
  ; --- 1: lat,
  ; --- 2: vrad,
  ; --- 3: evrad,
  ; --- 4: Teff,
  ; --- 5: eTeff,
  ; --- 6: logg,
  ; --- 7: elogg,
  ; --- 8: mh,
  ; --- 9: emh,
  ; --- 10: bool_feh,
  ; --- 11: a/Fe
  ; --- 12: rave_vrad,
  ; --- 13: rave_teff,
  ; --- 14: rave_eteff,
  ; --- 15: rave_logg,
  ; --- 16: rave_elogg,
  ; --- 17: rave_mh,
  ; --- 18: rave_emh,
  ; --- 19: rave_afe,
  ; --- 20: rave_stn,
  ; --- 21: source
  int_col_teff_ext = 4
  int_col_eteff_ext = 5
  int_col_logg_ext = 6
  int_col_elogg_ext = 7
  int_col_mh_ext = 8
  int_col_emh_ext = 9
  int_col_bool_feh_ext = 10
  int_col_afe_ext = 11
  int_col_teff_rave = 13
  int_col_eteff_rave = 14
  int_col_logg_rave = 15
  int_col_elogg_rave = 16
  int_col_mh_rave = 17
  int_col_emh_rave = 18
  int_col_afe_rave = 19
  int_col_stn_rave = 20
  int_col_source_ext = 21

  indarr_clipped_teff = [-1]
  indarr_clipped_logg = [-1]
  indarr_clipped_mh = [-1]
  indarr_clipped_cmh = [-1]
  indarr_clipped_afe = [-1]

  for ii=1,2 do begin; --- dwarfs and giants
;ii = 1
    if ii eq 0 then begin
      b_dwarfs_only = 0
      b_giants_only = 0
    end else if ii eq 1 then begin
      b_dwarfs_only = 1
      b_giants_only = 0
    end else begin
      b_dwarfs_only = 0
      b_giants_only = 1
    end
    strarr_data = readfiletostrarr(str_filename,' ')
    strarr_data(*,int_col_elogg_rave) = strtrim(string(0.000001),2)

    indarr = where((long(strarr_data(*,int_col_source_ext)) ne 3))
    strarr_data = strarr_data(indarr,*)

    indarr_teff = where(double(strarr_data(*,int_col_teff_ext)) gt 15000.)
    if indarr_teff(0) ge 0 then $
      strarr_data(indarr_teff,int_col_teff_ext) = strtrim(string(0.),2)
;    if b_giants_only then begin
;      indarr_teff = where(double(strarr_data(*,int_col_teff_ext)) le 5000.)
;      strarr_data = strarr_data(indarr_teff,*)
;    endif

    indarr_mh = where(double(strarr_data(*,int_col_mh_rave)) gt 3.)
    if indarr_mh(0) ge 0 then $
      strarr_data(indarr_mh,int_col_mh_rave) = strtrim(string(0.),2)

    indarr_mh = where(double(strarr_data(*,int_col_mh_ext)) gt 3.)
    if indarr_mh(0) ge 0 then $
      strarr_data(indarr_mh,int_col_mh_ext) = strtrim(string(0.),2)

    indarr = where((abs(double(strarr_data(*,int_col_mh_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_mh_rave))) ge 0.0000001))
    indarr_feh = where(long(strarr_data(indarr, int_col_bool_feh_ext)) eq 1)
          ;if ii eq 0 then begin
    if b_with_feh then begin
      dblarr_teff_temp = double(strarr_data(indarr(indarr_feh), int_col_teff_ext))
      indarr_feh_and_no_teff = where(abs(dblarr_teff_temp) lt 0.00001)
      if indarr_feh_and_no_teff(0) ge 0 then $
        dblarr_teff_temp(indarr_feh_and_no_teff) = double(strarr_data(indarr(indarr_feh(indarr_feh_and_no_teff)), int_col_teff_rave))

      dblarr_logg_temp = double(strarr_data(indarr(indarr_feh), int_col_logg_ext))
      indarr_feh_and_no_logg = where(abs(dblarr_logg_temp) lt 0.00001)
      if indarr_feh_and_no_logg(0) ge 0 then $
        dblarr_logg_temp(indarr_feh_and_no_logg) = double(strarr_data(indarr(indarr_feh(indarr_feh_and_no_logg)), int_col_logg_rave))
      ;print,'before besancon_calculate_mh: i_dblarr_feh = ',strarr_data(indarr(indarr_feh(0:100)), int_col_mh_ext)
      besancon_calculate_mh,I_DBLARR_FEH  = double(strarr_data(indarr(indarr_feh), int_col_mh_ext)),$
                            O_DBLARR_MH   = o_dblarr_mh,$ ; --- dblarr
                            I_INT_VERSION = 3,$
                            I_DBLARR_TEFF = dblarr_teff_temp,$
                            I_DBLARR_LOGG = dblarr_logg_temp
      ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
      ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
  ;                          I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_feh), int_col_logg_rave))
            ;endif
      ;print,'after besancon_calculate_mh: o_dblarr_mh = ',o_dblarr_mh(0:100)
      ;stop
      strarr_data(indarr(indarr_feh), int_col_mh_ext) = strtrim(string(o_dblarr_mh),2)
    end else begin
      strarr_data(indarr(indarr_feh), int_col_mh_ext) = strtrim(string(0.),2)
    endelse
    str_filename_meansig = str_path+'all_found_mean_sig_diff'
    if b_dwarfs_only then $
      str_filename_meansig = str_filename_meansig + '_dwarfs'
    if b_giants_only then $
      str_filename_meansig = str_filename_meansig + '_giants'
    str_filename_meansig = str_filename_meansig + '.dat'
    openw,lunmeansig,str_filename_meansig,/GET_LUN

    dblarr_teff_rave_last = double(strarr_data(*,int_col_teff_rave))
    dblarr_logg_rave_last = double(strarr_data(*,int_col_logg_rave))
    dblarr_mh_rave_last   = double(strarr_data(*,int_col_mh_rave))
    dblarr_afe_rave_last   = double(strarr_data(*,int_col_afe_rave))

    if b_orig then begin
      rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh_rave_last,$
                                    I_DBLARR_AFE           = double(strarr_data(*,int_col_afe_rave)),$
                                    I_DBLARR_TEFF          = dblarr_teff_rave_last,$; --- new calibration
                                    I_DBLARR_LOGG          = dblarr_logg_rave_last,$; --- old calibration
                                    I_DBLARR_STN           = double(strarr_data(*,int_col_stn_rave)),$; --- calibration from DR3 paper
                                    O_STRARR_MH_CALIBRATED = strarr_mh_rave_calibrated_last,$;           --- string array
                                    I_DBL_REJECTVALUE      = 9.99,$; --- double
                                    I_DBL_REJECTERR        = 1,$;       --- double
                                    I_B_SEPARATE           = 1
      dblarr_cmh_rave_last = double(strarr_mh_rave_calibrated_last)
    end else begin
      dblarr_cmh_rave_last = double(strarr_data(*,23))
    endelse
    dblarr_teff_calib = dblarr_teff_rave_last
    dblarr_logg_calib = dblarr_logg_rave_last
    dblarr_mh_calib = dblarr_mh_rave_last
    dblarr_cmh_calib = dblarr_cmh_rave_last
    dblarr_afe_calib = dblarr_afe_rave_last

    indarr = where((abs(double(strarr_data(*,int_col_teff_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_teff_rave))) ge 0.0000001))
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_teff_rave_last = ',dblarr_teff_rave_last
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_teff_ext = ',strarr_data(*, int_col_teff_ext)
    print,'rave_compare_to_external_and_calibrate_teff: size(dblarr_teff_rave_last) = ',size(dblarr_teff_rave_last)
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_logg_ext = ',strarr_data(*, int_col_logg_ext)
    dblarr_logg_ext_rave = double(strarr_data(*, int_col_logg_ext))
    indarr_no_logg = where(abs(dblarr_logg_ext_rave) lt 0.0000000001)
    if indarr_no_logg(0) ge 0 then $
      dblarr_logg_ext_rave(indarr_no_logg) = dblarr_logg_rave_last(indarr_no_logg)
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_logg_ext_rave = ',dblarr_logg_ext_rave
;    stop
    for iii = 0,0 do begin; --- number of complete iterations

;      if iii eq 3 then begin
;        b_do_calib_x_vs_ext = 1
;      end else begin
        b_do_calib_x_vs_ext = 0
;      endelse

      if iii gt 0 then begin
        dblarr_teff_rave_last = dblarr_teff_calib
        dblarr_logg_rave_last = dblarr_logg_calib
        dblarr_mh_rave_last   = dblarr_mh_calib
        dblarr_cmh_rave_last  = dblarr_cmh_calib
        dblarr_afe_rave_last  = dblarr_afe_calib

        ; --- all rave data
        dblarr_rave_teff_last = dblarr_rave_teff
        dblarr_rave_logg_last = dblarr_rave_logg
        dblarr_rave_mh_last   = dblarr_rave_mh
        dblarr_rave_cmh_last  = dblarr_rave_cmh
        dblarr_rave_afe_last  = dblarr_rave_afe
        if indarr_no_logg(0) ge 0 then $
          dblarr_logg_ext_rave(indarr_no_logg) = dblarr_logg_rave_last(indarr_no_logg)
      endif

      rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_ext_rave,$
                                         O_INDARR_DWARFS  = indarr_dwarfs,$
                                         O_INDARR_GIANTS  = indarr_giants,$
                                         I_DBL_LIMIT_LOGG = 3.5
      if b_dwarfs_only then begin
        indarr_logg = indarr_dwarfs
        indarr_logg_all = indarr_dwarfs_all
      end else if b_giants_only then begin
        indarr_logg = indarr_giants
        indarr_logg_all = indarr_giants_all
      end else begin
        indarr_logg = lindgen(n_elements(dblarr_logg_ext_rave))
        indarr_logg_all = lindgen(n_elements(dblarr_rave_logg))
      endelse
      int_col_err_ext = int_col_elogg_rave
      int_col_err_rave = int_col_elogg_rave
      for int_cal = 0,0 do begin
        i_do_stn_calib = 0
        if int_cal eq 0 then begin; --- STN
          dblarr_calib = double(strarr_data(indarr_logg, int_col_stn_rave))
          dblarr_calib_all = dblarr_rave_stn(indarr_logg_all)
          dblarr_xrange_calib = [0.,200.]
          str_xtitle_calib = 'STN!DRAVE!N'
          str_calib = 'STN'
          str_xtickformat_calib = '(I6)'
          i_do_stn_calib = 1
        end else if int_cal eq 1 then begin; --- Teff
          dblarr_calib = dblarr_teff_calib(indarr_logg)
          dblarr_calib_all = dblarr_rave_teff(indarr_logg_all)
          if b_dwarfs_only then begin
            dblarr_xrange_calib = [4500.,7500.]
          end else if b_giants_only then begin
            dblarr_xrange_calib = [3500.,6000.]
          endif
          str_xtitle_calib = 'T!Deff, RAVE!N [K]'
          str_calib = 'Teff'
          str_xtickformat_calib = '(I6)'
          i_do_stn_calib = 1
        end else if int_cal eq 2 then begin; --- [m/H]
          dblarr_calib = dblarr_mh_calib(indarr_logg)
          dblarr_calib_all = dblarr_rave_mh(indarr_logg_all)
          if b_dwarfs_only then begin
            dblarr_xrange_calib = [-1.,0.5]
          end else if b_giants_only then begin
            dblarr_xrange_calib = [-2.,0.5]
          endif
          str_xtitle_calib = '[m/H]!DRAVE!N [dex]'
          str_calib = 'mH'
          str_xtickformat_calib = '(F4.1)'
          i_do_stn_calib = 1
        end else if int_cal eq 3 then begin; --- [M/H]
          dblarr_calib = dblarr_cmh_calib(indarr_logg)
          dblarr_calib_all = dblarr_rave_cmh(indarr_logg_all)
          if b_dwarfs_only then begin
            dblarr_xrange_calib = [-1.,0.5]
          end else if b_giants_only then begin
            dblarr_xrange_calib = [-2.,0.5]
          endif
          str_xtitle_calib = '[M/H]!DRAVE!N [dex]'
          str_calib = 'MH'
          str_xtickformat_calib = '(F4.1)'
          i_do_stn_calib = 1
        end else if int_cal eq 4 then begin
          dblarr_calib = dblarr_logg_calib(indarr_logg)
          dblarr_calib_all = dblarr_rave_logg(indarr_logg_all)
          if b_dwarfs_only then begin
            dblarr_xrange_calib = [3.3,5.]
          end else if b_giants_only then begin
            dblarr_xrange_calib = [0.,3.7]
          endif
          str_xtitle_calib = '(log g)!DRAVE!N [dex]'
          str_calib = 'logg'
          str_xtickformat_calib = '(F4.1)'
          i_do_stn_calib = 1
        end else if int_cal eq 5 then begin
          dblarr_calib = dblarr_afe_calib(indarr_logg)
          dblarr_calib_all = dblarr_rave_afe(indarr_logg_all)
          dblarr_xrange_calib = [0.,0.4]
          str_xtitle_calib = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_calib = 'aFe'
          str_xtickformat_calib = '(F4.1)'
          i_do_stn_calib = 1
        endif
        for i=0,66 do begin
          b_teff = 0
          b_logg = 0
          b_mh = 0
          b_cmh = 0
          b_afe = 0
          print,'ii=',ii,', i=',i
          int_smooth_mean_sig = 0
          int_do_stn_calib = 0
          dbl_sigma_clip = 3.
          b_diff_plot_y_minus_x = 0
          dblarr_coeffs_dlogg_vs_dteff_giants = 0
          dblarr_lines_in_diff_plot = 0
          dblarr_vertical_lines = 0
          dblarr_yfit = 0
          indarr_clipped = 0
          b_quadratic = 0
          b_dont_plot_colour_bar = 0
          dblarr_position = [0.205,0.175,0.932,0.925]
          dblarr_position_diff=[0.205,0.175,0.932,0.925]
          dblarr_position_hist=[0.205,0.175,0.932,0.925]
          if i eq 0 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_xtitle_hist = 'T!Deff!N [K]'
            str_ytitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            dblarr_xrange = [3500.,6000.]
            dblarr_yrange = [3500.,6000.]
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            i_xticks = 0
            i_yticks = 0
            b_print_moments = 1
            dblarr_yfit = 0
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
              dblarr_yrange = [4500.,7500.]
              dblarr_yrange_hist = [0.,13.2]
              b_print_moments = 1
            endif
            if b_giants_only then begin
              b_print_moments = 3
              dbl_sigma_clip = 3.
            endif
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = dblarr_teff_calib(indarr)
            str_plotname_root = str_path + 'all_found_Teff-RAVE_vs_Teff-ext'
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_diff_only = 0
            dblarr_vertical_lines = 0
            ;dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_teff
            b_teff = 1
          end else if i eq 1 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_xtitle_hist = 'log g [dex]'
            str_ytitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_hist = 'Percentage of stars'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_xrange = [0., 5.0]
            dblarr_yrange_hist = 0
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3, 5.]
              dblarr_yrange = [3.3, 5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,4.2]
              dblarr_yrange = [0.,4.2]
            endif
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_dlogg_vs_logg-ext'
            i_yticks = 0
            i_xticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext_logg)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr,indarr_clipped_logg
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = dblarr_logg_calib(indarr)
            b_diff_only = 0
            b_logg = 1
          end else if i eq 2 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1., 0.5]
              dblarr_yrange = [-1., 0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
              i_xticks = 5
              dblarr_yrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = dblarr_cmh_calib(indarr)
            b_diff_only = 0
            b_cmh = 1
          end else if i eq 3 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1., 0.5]
              dblarr_yrange = [-1., 0.5]
              i_xticks = 3
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
              i_xticks = 5
              dblarr_yrange = [-2.,0.5]
              i_yticks = 5
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = dblarr_mh_calib(indarr)
            b_diff_only = 0
            b_mh = 1
          end else if i eq 4 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_xtitle_hist = '[!4a!3/Fe] [dex]'
            str_ytitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 3
            dblarr_xrange = [0., 0.4]
            dblarr_yrange = [0., 0.4]
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr = indarr_logg(indarr_ext_afe)
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = dblarr_afe_calib(indarr)
            b_diff_only = 0
            b_afe = 1
          end else if i eq 5 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            str_ytitle_diff = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_xrange = [-1000.,1000.]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_dTeff'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_logg))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            b_quadratic = 1
            b_dont_plot_colour_bar = 1
          end else if i eq 6 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            str_ytitle_diff = ' ';([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_xrange = [-1000.,1000.]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_dTeff'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
            b_quadratic = 1
            b_dont_plot_colour_bar = 1
          end else if i eq 7 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            str_ytitle_diff = ' ';([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_xrange = [-1000.,1000.]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_dTeff'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 8 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            str_ytitle_diff = ' ';([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_xrange = [-1000.,1000.]
            dblarr_yrange_diff = [-0.5,0.5]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_dTeff'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_teff,indarr_ext_afe,indarr_ext_teff_afe,indarr_ext_afe_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_afe))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_afe
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 9 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_dMH'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 10 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_dmMH'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 11 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_dlogg'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 12 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_dlogg'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 13 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-0.5,0.5]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_dlogg'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_afe,indarr_ext_logg,indarr_ext_afe_logg,indarr_ext_logg_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 14 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-0.5,0.5]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_dMH'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 15 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_dmMH'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 16 then begin
            int_smooth_mean_sig = 1
            str_xtitle = ' ';([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            str_ytitle_diff = ' ';([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_position_diff=[0.197,0.292,0.92,0.995]
            dblarr_yrange_diff = [-0.5,0.5]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_dmMH'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,1.]
            end else if b_giants_only then begin
              dblarr_xrange = [-1.,1.]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            dblarr_vertical_lines = [0.0000000001]
            ;dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            b_dont_plot_colour_bar = 1
            b_quadratic = 1
          end else if i eq 17 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_logg-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,4.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 18 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_logg-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.0]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,4.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_logg))
            dblarr_x = dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 19 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 20 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_MH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 21 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_mH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 22 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_teff,indarr_ext_afe,indarr_ext_teff_afe,indarr_ext_afe_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_afe))
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 23 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_aFe-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_teff,indarr_ext_afe,indarr_ext_teff_afe,indarr_ext_afe_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_afe))
            dblarr_x = dblarr_afe_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 24 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_Teff-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr = indarr_logg(indarr_ext_teff)
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_teff
            b_teff = 1
          end else if i eq 25 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '(T!Deff, ext!N [K] - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_Teff-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr = indarr_logg(indarr_ext_teff)
            dblarr_x = dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_teff
          end else if i eq 26 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_Teff-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 27 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_Teff-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 28 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_logg-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.0]
            end else if b_giants_only then begin
              dblarr_xrange = [-0.,4.2]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_logg,indarr_ext_mh,indarr_ext_logg_mh,indarr_ext_mh_logg
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 29 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_logg-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.0]
              str_xtickformat = '(F4.1)'
            end else if b_giants_only then begin
              dblarr_xrange = [0.,4.2]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_logg,indarr_ext_mh,indarr_ext_logg_mh,indarr_ext_mh_logg
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 30 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            dblarr_xrange = [0.,0.4]
            str_plotname_root = str_path + 'all_found_dMH_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 31 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            dblarr_xrange = [0.,0.4]
            str_plotname_root = str_path + 'all_found_dMH_vs_aFe-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = dblarr_afe_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 32 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            ;if indarr_clipped_cmh(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
            b_cmh = 1
          end else if i eq 33 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_MH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            ;if indarr_clipped_cmh(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
          end else if i eq 34 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_mH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            ;if indarr_clipped_cmh(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
          end else if i eq 35 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_Teff-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 36 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_Teff-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_teff,indarr_ext_mh,indarr_ext_teff_mh,indarr_ext_mh_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_mh))
            dblarr_x = dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 37 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_logg-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.0]
            end else if b_giants_only then begin
              dblarr_xrange = [-0.,4.2]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_logg,indarr_ext_mh,indarr_ext_logg_mh,indarr_ext_mh_logg
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 38 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_logg-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.0]
              str_xtickformat = '(F4.1)'
            end else if b_giants_only then begin
              dblarr_xrange = [0.,4.2]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_cmh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_logg,indarr_ext_mh,indarr_ext_logg_mh,indarr_ext_mh_logg
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 39 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            dblarr_xrange = [0.,0.4]
            str_plotname_root = str_path + 'all_found_dmMH_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 40 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            dblarr_xrange = [0.,0.4]
            str_plotname_root = str_path + 'all_found_dmMH_vs_aFe-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            match,indarr_ext_mh,indarr_ext_afe,indarr_ext_mh_afe,indarr_ext_afe_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_afe))
            dblarr_x = dblarr_afe_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          end else if i eq 41 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
;            if indarr_clipped_cmh(0) ge 0 then $
;              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
          end else if i eq 42 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_MH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
;            if indarr_clipped_cmh(0) ge 0 then $
;              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
          end else if i eq 43 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_mH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            ;if indarr_clipped_cmh(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
            indarr = indarr_logg(indarr_ext_mh)
            dblarr_x = dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_mh
            b_mh = 1
          end else if i eq 44 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_Teff-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_logg))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 45 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_Teff-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
            indarr = indarr_logg(indarr_ext_teff(indarr_ext_teff_logg))
            dblarr_x = dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 46 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 47 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_MH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 48 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_mH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            end
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
            indarr = indarr_logg(indarr_ext_mh(indarr_ext_mh_logg))
            dblarr_x = dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 49 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_afe,indarr_ext_logg,indarr_ext_afe_logg,indarr_ext_logg_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_logg))
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 50 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_aFe-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_afe,indarr_ext_logg,indarr_ext_afe_logg,indarr_ext_logg_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_logg))
            dblarr_x = dblarr_afe_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 51 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_logg-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,3.7]
            endif
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            ;if indarr_clipped_logg(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            indarr = indarr_logg(indarr_ext_afe)
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_logg
            b_logg = 1
          end else if i eq 52 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_logg-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,3.7]
            endif
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            ;if indarr_clipped_logg(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            indarr = indarr_logg(indarr_ext_logg)
            dblarr_x = dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_logg
          end else if i eq 53 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, ext!N [K]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_Teff-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            match,indarr_ext_afe,indarr_ext_teff,indarr_ext_afe_teff,indarr_ext_teff_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_teff))
            dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 54 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_Teff-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [4500.,7500.]
            end else if b_giants_only then begin
              dblarr_xrange = [3500.,6000.]
            end
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_teff = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            if indarr_clipped_teff(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
            match,indarr_ext_afe,indarr_ext_teff,indarr_ext_afe_teff,indarr_ext_teff_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_teff))
            dblarr_x = dblarr_teff_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 55 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_MH-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            endif
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_afe,indarr_ext_mh,indarr_ext_afe_mh,indarr_ext_mh_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_mh))
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 56 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_MH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            endif
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_afe,indarr_ext_mh,indarr_ext_afe_mh,indarr_ext_mh_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_mh))
            dblarr_x = dblarr_cmh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 57 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_mH-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [-1.,0.5]
            end else if b_giants_only then begin
              dblarr_xrange = [-2.,0.5]
            endif
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_mh = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            if indarr_clipped_mh(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
            match,indarr_ext_afe,indarr_ext_mh,indarr_ext_afe_mh,indarr_ext_mh_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_mh))
            dblarr_x = dblarr_mh_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 58 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!Dext!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_logg-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,3.7]
            endif
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_afe,indarr_ext_logg,indarr_ext_afe_logg,indarr_ext_logg_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_logg))
            dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 59 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_logg-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            if b_dwarfs_only then begin
              dblarr_xrange = [3.3,5.]
            end else if b_giants_only then begin
              dblarr_xrange = [0.,3.7]
            endif
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            if indarr_clipped_afe(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr_ext_logg = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            if indarr_clipped_logg(0) ge 0 then $
              remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
            match,indarr_ext_afe,indarr_ext_logg,indarr_ext_afe_logg,indarr_ext_logg_afe
            indarr = indarr_logg(indarr_ext_afe(indarr_ext_afe_logg))
            dblarr_x = dblarr_logg_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
  ;          indarr_clipped = indarr_clipped_logg
          end else if i eq 60 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_aFe-ext'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
;            if indarr_clipped_afe(0) ge 0 then $
;              remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr = indarr_logg(indarr_ext_afe)
            dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_afe
            b_afe = 1
          end else if i eq 61 then begin
            int_smooth_mean_sig = 1
            str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_aFe-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0.,0.4]
            indarr_ext_afe = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            ;if indarr_clipped_afe(0) ge 0 then $
            ;  remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
            indarr = indarr_logg(indarr_ext_afe)
            dblarr_x = dblarr_afe_calib(indarr)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            ;dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
            indarr_clipped = indarr_clipped_afe
          end else if i eq 62 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'STN'
            str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            dblarr_yrange_diff = [-1000.,1000.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dTeff_vs_STN'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            dblarr_xrange = [0., 200.]
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_teff
            b_teff = 1
          end else if i eq 63 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'STN'
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dMH_vs_STN'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0., 200.]
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_cmh = 1
          end else if i eq 64 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'STN'
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dmMH_vs_STN'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0., 200.]
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_mh = 1
          end else if i eq 65 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'STN'
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_dlogg_vs_STN'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0., 200.]
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_logg
            b_logg = 1
          end else if i eq 66 then begin
            int_smooth_mean_sig = 1
            str_xtitle = 'STN'
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_yrange_diff = [-0.4,0.4]
            dblarr_yrange_hist = 0
            str_plotname_root = str_path + 'all_found_daFe_vs_STN'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            dblarr_xrange = [0., 200.]
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_afe
            b_afe = 1





; --- calibrate
          end else if i eq 60 then begin
            int_do_stn_calib = i_do_stn_calib
            if str_calib eq 'Teff' then $
              int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1000.,1000.]
            str_plotname_root = str_path + 'all_found_calib_dTeff_vs_'+str_calib
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_teff
            b_teff = 1
            str_y = 'Teff'
          end else if i eq 61 then begin
            int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1000.,1000.]
            str_plotname_root = str_path + 'all_found_calib_dTeff_vs_'+str_calib+'-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_teff_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_teff
            b_teff = 1
            str_y = 'Teff'
          end else if i eq 62 then begin
            int_do_stn_calib = i_do_stn_calib
            if str_calib eq 'MH' then $
              int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dMH_vs_'+str_calib
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_cmh = 1
            str_y = 'MH'
          end else if i eq 63 then begin
            int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dMH_vs_'+str_calib+'-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_cmh = 1
            str_y = 'MH'
          end else if i eq 64 then begin
            int_do_stn_calib = i_do_stn_calib
            if str_calib eq 'mH' then $
              int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dmMH_vs_'+str_calib
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_mh = 1
            str_y = 'mH'
          end else if i eq 65 then begin
            int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dmMH_vs_'+str_calib+'-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_mh_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_mh
            b_mh = 1
            str_y = 'mH'
          end else if i eq 66 then begin
            int_do_stn_calib = i_do_stn_calib
            if str_calib eq 'logg' then $
              int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dlogg_vs_'+str_calib
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_logg
            b_logg = 1
            str_y = 'logg'
          end else if i eq 67 then begin
            int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '((log g)!Dext!N - (log g)!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-1.,1.]
            str_plotname_root = str_path + 'all_found_calib_dlogg_vs_'+str_calib+'-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_logg_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_logg
            b_logg = 1
            str_y = 'logg'
          end else if i eq 68 then begin
            int_do_stn_calib = i_do_stn_calib
            if str_calib eq 'aFe' then $
              int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-0.4,0.4]
            str_plotname_root = str_path + 'all_found_calib_daFe_vs_'+str_calib
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_afe
            b_afe = 1
            str_y = 'aFe'
          end else if i eq 69 then begin
            int_do_stn_calib = 0
            int_smooth_mean_sig = 1
            str_xtitle = str_xtitle_calib
            str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
            dblarr_xrange = dblarr_xrange_calib
            dblarr_yrange_diff = [-0.4,0.4]
            str_plotname_root = str_path + 'all_found_calib_daFe_vs_'+str_calib+'-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = str_xtickformat_calib
            str_ytickformat = '(F4.1)'
            b_print_moments = 1
            indarr_ext = where(abs(double(strarr_data(indarr_logg,int_col_afe_ext))) ge 0.0000001)
            indarr = indarr_logg(indarr_ext)
            dblarr_x = dblarr_calib(indarr_ext)
            dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
            b_diff_only = 1
            indarr_clipped = indarr_clipped_afe
            b_afe = 1
            str_y = 'aFe'
          end
          if b_dwarfs_only then begin
            str_plotname_root = str_plotname_root + '_dwarfs'
          end else if b_giants_only then begin
            str_plotname_root = str_plotname_root + '_giants'
          end
          str_plotname_root = str_plotname_root + '_' + strtrim(string(int_sigma_nbins),2) + 'bins'
          if int_smooth_mean_sig gt 0 then $
            str_plotname_root = str_plotname_root + '_' + strtrim(string(int_smooth_mean_sig),2) + 'smoothings'
    ;      if not(b_dwarfs_only and (i ge 22)) then begin
  ;        if iii eq 1 then begin
          str_plotname_root = str_plotname_root + '_' + strtrim(string(int_cal),2)
          str_plotname_root = str_plotname_root + '_run' + strtrim(string(iii),2)
  ;        endif

          indarr_clipped = [-1]

          print,'rave_calibrate_parameter: ii = ',ii
          print,'rave_calibrate_parameter: i = ',i
          print,'rave_calibrate_parameter: iii = ',iii
          print,'rave_calibrate_parameter: int_cal = ',int_cal

          if (i ge 5) and (i le 12) then begin
            dblarr_hist = hist2d(dblarr_x,dblarr_y,MIN=[dblarr_xrange(0)/2.,dblarr_yrange_diff(0)/2.],MAX=[dblarr_xrange(1)/2.,dblarr_yrange_diff(1)/2.],BIN=[(dblarr_xrange(1) - dblarr_xrange(0)) / 20.,(dblarr_yrange_diff(1) - dblarr_yrange_diff(0)) / 20.],/LIST)
            ;dblarr_hist = hist_2d(dblarr_x,dblarr_y,MIN1=dblarr_xrange(0)/2.,MAX1=dblarr_xrange(1)/2.,MIN2=dblarr_yrange(0)/2.,MAX2=dblarr_yrange(1)/2.)
            set_plot,'ps'
            device,filename=str_plotname_root + '_cont.ps'
            contour,dblarr_hist
            device,/close
            set_plot,'x'
;stop
            spawn,'ps2gif '+str_plotname_root +'_cont.ps '+str_plotname_root+'_cont.gif'
            spawn,'epstopdf '+str_plotname_root +'_cont.ps'
            ;reduce_pdf_size,str_plotname_root+'_cont.pdf',str_plotname_root+'_cont_small.pdf'
            printf,lun_html,'<br><hr><br>'+strtrim(string(i),2)+': '+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'<br>'
            printf,lun_html,'Correlation coefficient = '+strtrim(string(correlate(dblarr_x,dblarr_y)),2)+'<br>'
            printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_cont.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_cont.gif"></a><br>'
          endif

          int_sigma_nbins = 20
          if n_elements(dblarr_x) lt 100 then begin
            int_sigma_nbins = n_elements(dblarr_x) / 5
          endif

          compare_two_parameters,dblarr_x,$
                                  dblarr_y,$
                                  str_plotname_root,$
                                  DBLARR_ERR_X             = double(strarr_data(indarr, int_col_err_ext)),$
                                  DBLARR_ERR_Y             = double(strarr_data(indarr, int_col_err_rave)),$
                                  DBLARR_RAVE_SNR          = double(strarr_data(indarr, int_col_stn_rave)),$
                                  STR_XTITLE               = str_xtitle,$
                                  STR_YTITLE               = str_ytitle,$
                                  STR_TITLE                = 1,$
                                  I_PSYM                   = 2,$
                                  DBL_SYMSIZE              = 1.,$
                                  DBL_CHARSIZE             = 1.8,$
                                  DBL_CHARTHICK            = 3.,$
                                  DBL_THICK                = 3.,$
                                  DBLARR_XRANGE            = dblarr_xrange,$
                                  DBLARR_YRANGE            = dblarr_yrange,$
                                  DBLARR_POSITION          = dblarr_position,$
                                  DIFF_DBLARR_YRANGE       = dblarr_yrange_diff,$
                                  DIFF_DBLARR_POSITION     = dblarr_position_diff,$
                                  DIFF_STR_YTITLE          = str_ytitle_diff,$
                                  I_B_DIFF_PLOT_Y_MINUS_X  = 0,$
                                  I_XTICKS                 = i_xticks,$
                                  STR_XTICKFORMAT          = str_xtickformat,$
                                  I_YTICKS                 = i_yticks,$
                                  DBL_REJECTVALUEX         = 0.,$;             --- double
                                  DBL_REJECTVALUE_X_RANGE  = 0.0000001,$;             --- double
                                  ;DBL_REJECTVALUEY         = dbl_rejectvaluex,$;             --- double
                                  ;DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                                  STR_YTICKFORMAT          = str_ytickformat,$
                                  B_PRINTPDF               = 1,$;               --- bool (0/1)
                                  SIGMA_I_NBINS            = int_sigma_nbins,$
                                  I_INT_SMOOTH_MEAN_SIG    = int_smooth_mean_sig,$
                                  SIGMA_I_MINELEMENTS      = int_sigma_minelements,$
                                  I_DBL_SIGMA_CLIP         = dbl_sigma_clip,$
                                  O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$
                                  I_B_USE_WEIGHTED_MEAN    = 0,$
                                  HIST_I_NBINS_SET          = 20,$;            --- int
                                  HIST_I_NBINSMIN          = 20,$;            --- int
                                  HIST_I_NBINSMAX          = 20,$;            --- int
                                  HIST_STR_XTITLE          = str_xtitle_hist,$;            --- string
                                  ;HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
                                  ;HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                                  HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                                  ;HIST_B_POP_ID            = 0,$;             --- bool
                                  ;HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                                  HIST_DBLARR_XRANGE       = dblarr_xrange,$
                                  HIST_DBLARR_YRANGE       = dblarr_yrange_hist,$
                                  HIST_DBLARR_POSITION     = dblarr_position_hist,$;   --- dblarr
                                  ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                                  O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                                  ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                                  DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines,$
                                  ;DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                                  I_DBLARR_YFIT                      = dblarr_yfit,$
                                  B_PRINT_MOMENTS                    = b_print_moments,$
                                  I_DO_SIGMA_CLIPPING                = 1,$
                                  IO_INDARR_CLIPPED                  = indarr_clipped,$
                                  O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                                  I_INTARR_SYMBOLS                   = long(strarr_data(indarr,int_col_source_ext)),$
                                  ;I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                                  ;I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                                  B_DIFF_ONLY                        = b_diff_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                                  I_DBLARR_LINES_IN_DIFF_PLOT        = dblarr_lines_in_diff_plot,$
                                    I_B_QUADRATIC                        = b_quadratic,$
                           I_B_DONT_PLOT_COLOUR_BAR           = b_dont_plot_colour_bar

          ; --- write o_dblarr_diff_mean_sigma to file
          openw,lun_me,str_plotname_root+'_diff_mean_sigma.dat',/GET_LUN
            for ll=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
              if o_dblarr_diff_mean_sigma(ll,3) ge int_sigma_minelements then begin
                str_line = strtrim(string(o_dblarr_diff_mean_sigma(ll,0)),2)
                for lll=1,n_elements(o_dblarr_diff_mean_sigma(0,*))-1 do begin
                  str_line = str_line + ' ' + strtrim(string(o_dblarr_diff_mean_sigma(ll,lll)),2)
                endfor
                printf,lun_me,str_line
              endif
            endfor
          free_lun,lun_me

          ; --- add clipped stars to appropriate indarr_clipped
          if indarr_clipped(0) ge 0 then begin

            if b_teff then begin
              if indarr_clipped_teff(0) lt 0 then begin
                indarr_clipped_teff = indarr_clipped
              end else begin
                indarr_clipped_teff = [indarr_clipped_teff,indarr(indarr_clipped)]
              endelse
            end else if b_logg then begin
              if indarr_clipped_logg(0) lt 0 then begin
                indarr_clipped_logg = indarr_clipped
              end else begin
                indarr_clipped_logg = [indarr_clipped_logg,indarr(indarr_clipped)]
              endelse
            end else if b_mh then begin
              if indarr_clipped_mh(0) lt 0 then begin
                indarr_clipped_mh = indarr_clipped
              end else begin
                indarr_clipped_mh = [indarr_clipped_mh,indarr(indarr_clipped)]
              endelse
            end else if b_cmh then begin
              if indarr_clipped_cmh(0) lt 0 then begin
                indarr_clipped_cmh = indarr_clipped
              end else begin
                indarr_clipped_cmh = [indarr_clipped_cmh,indarr(indarr_clipped)]
              endelse
            end else if b_afe then begin
              if indarr_clipped_afe(0) lt 0 then begin
                indarr_clipped_afe = indarr_clipped
              end else begin
                indarr_clipped_afe = [indarr_clipped_afe,indarr(indarr_clipped)]
              endelse
            endif

          endif

    ;    if i eq 9 then stop
          ;wait,1
          ;reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'
          ;if not b_diff_only then begin
          ;  reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
          ;  reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
          ;endif
          printf,lun_html,'<br><hr><br>'+strtrim(string(i),2)+': '+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'<br>'
          printf,lun_html,'Correlation coefficient = '+strtrim(string(correlate(dblarr_x,dblarr_y)),2)+'<br>'
          if not b_diff_only then $
            printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
          printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
          if not b_diff_only then $
            printf,lun_html,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
          printf,lunmeansig,'i = '+strtrim(string(i),2)+': mean sigma'
          for jjj=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
            printf,lunmeansig,o_dblarr_diff_mean_sigma(jjj,0),o_dblarr_diff_mean_sigma(jjj,1),o_dblarr_diff_mean_sigma(jjj,2),o_dblarr_diff_mean_sigma(jjj,3)
          endfor

          indarr_good = where(o_dblarr_diff_mean_sigma(*,3) ge int_sigma_minelements)
          dbl_mean = 0.
          dbl_sigma = 0.;mean(o_dblarr_diff_mean_sigma(indarr_good(indarr_meansig),1))
          int_nstars_all = total(o_dblarr_diff_mean_sigma(*,3))
          for kkkk = 0, n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
            dbl_weight = o_dblarr_diff_mean_sigma(kkkk,3) / double(int_nstars_all)
            dbl_mean = dbl_mean + o_dblarr_diff_mean_sigma(kkkk,1) * dbl_weight
            dbl_sigma = dbl_sigma + o_dblarr_diff_mean_sigma(kkkk,2) * dbl_weight
          endfor
          printf,lunmeansig,'mean: ',dbl_mean,dbl_sigma
          print,'mean: ',dbl_mean,dbl_sigma

          if (int_do_stn_calib gt 0) and (b_dwarfs_only or b_giants_only) then begin
            if int_do_stn_calib eq 1 then begin
              str_filename_calib = str_plotname_root+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 10 then begin
              str_filename_calib = str_plotname_root+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 11 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_vs_mH-calib_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 12 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_Teff-calib_calib-mH_vs_logg-calib_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 13 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 14 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_MH-calib_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 15 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_MH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 16 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 17 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 18 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_vs_mH-calib_calib-Teff_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 19 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 20 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_calib-mH-calib-Teff_vs_logg-calib_calib-mH_calib-Teff_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 21 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_calib-Teff-calib-logg_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 22 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_Teff-calib_calib-mH-calib-logg_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            end else if int_do_stn_calib eq 23 then begin
              str_filename_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_calib-mH-calib-Teff_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
            endif
            if b_dwarfs_only then begin
              str_filename_calib = str_filename_calib + '_dwarfs'
            endif
            if b_giants_only then begin
              str_filename_calib = str_filename_calib + '_giants'
            endif
  ;          if iii gt 0 then begin
            str_filename_calib = str_filename_calib + '_' + strtrim(string(iii),2)
  ;          endif
              str_filename_calib = str_filename_calib + '.dat'
            openw,lun_cal,str_filename_calib,/GET_LUN
            if (int_do_stn_calib eq 1) or (int_do_stn_calib eq 10) then begin
              printf,lun_cal,'#'+str_calib+' mean('+str_y+'_ext-'+str_y+'_RAVE)'
            end else if int_do_stn_calib eq 11 then begin
              printf,lun_cal,'#MH_RAVE mean(logg_ext-logg_RAVE)'
            end else if int_do_stn_calib eq 12 then begin
              printf,lun_cal,'#logg_RAVE mean(Teff_ext-Teff_RAVE)'
            end else if int_do_stn_calib eq 13 then begin
              printf,lun_cal,'#Teff_RAVE mean(logg_ext-logg_RAVE)'
            end else if int_do_stn_calib eq 14 then begin
              printf,lun_cal,'#Teff_RAVE mean(MH_ext-MH_RAVE)'
            end else if int_do_stn_calib eq 15 then begin
              printf,lun_cal,'#logg_RAVE mean(MH_ext-MH_RAVE)'
            end else if int_do_stn_calib eq 16 then begin
              printf,lun_cal,'#Teff_RAVE mean(MH_ext-mH_RAVE)'
            end else if int_do_stn_calib eq 17 then begin
              printf,lun_cal,'#logg_RAVE mean(MH_ext-mH_RAVE)'
            end else if int_do_stn_calib eq 18 then begin
              printf,lun_cal,'#mH_RAVE mean(aFe_ext-aFe_RAVE)'
            end else if int_do_stn_calib eq 19 then begin
              printf,lun_cal,'#Teff_RAVE mean(aFe_ext-aFe_RAVE)'
            end else if int_do_stn_calib eq 20 then begin
              printf,lun_cal,'#logg_RAVE mean(aFe_ext-aFe_RAVE)'
            end else if int_do_stn_calib eq 21 then begin
              printf,lun_cal,'#aFe_RAVE mean(MH_ext-mH_RAVE)'
            end else if int_do_stn_calib eq 22 then begin
              printf,lun_cal,'#aFe_RAVE mean(Teff_ext-Teff_RAVE)'
            end else if int_do_stn_calib eq 23 then begin
              printf,lun_cal,'#aFe_RAVE mean(logg_ext-logg_RAVE)'
            endif
            j_min = -1
            j_max = -1
            b_first_good = 1
            for j=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
              if o_dblarr_diff_mean_sigma(j,3) ge int_sigma_minelements then begin
                if b_first_good then begin
                  if j gt 0 then begin
                    printf,lun_cal,o_dblarr_diff_mean_sigma(j-1,0),' ', strtrim(string(0.),2)
                  end else begin
                    printf,lun_cal,o_dblarr_diff_mean_sigma(0,0) - (o_dblarr_diff_mean_sigma(1,0) - o_dblarr_diff_mean_sigma(0,0)),' ',strtrim(string(0.),2)
                  endelse
                  b_first_good = 0
                endif
                j_max = j
                printf,lun_cal,o_dblarr_diff_mean_sigma(j,0), o_dblarr_diff_mean_sigma(j,1)
              end else begin
                if j_min eq -1 then $
                  j_min = j
              endelse
            endfor
            printf,lun_cal,o_dblarr_diff_mean_sigma(j_max,0) + (o_dblarr_diff_mean_sigma(1,0) - o_dblarr_diff_mean_sigma(0,0)),' ',strtrim(string(0.),2)
            free_lun,lun_cal

            if (int_do_stn_calib eq 1) or (int_do_stn_calib eq 10) then begin
              if b_teff then begin
                dblarr_to_calibrate = dblarr_teff_calib(indarr_logg)
                dblarr_to_calibrate_all = dblarr_rave_teff(indarr_logg_all)
              end else if b_cmh then begin
                dblarr_to_calibrate = dblarr_cmh_calib(indarr_logg)
                dblarr_to_calibrate_all = dblarr_rave_cmh(indarr_logg_all)
                print,'dblarr_rave_cmh(indarr_logg_all(0:10)) = ',dblarr_rave_cmh(indarr_logg_all(0:10))
                print,'dblarr_calib_all(0:10) = ',dblarr_calib_all(0:10)
              end else if b_mh then begin
                dblarr_to_calibrate = dblarr_mh_calib(indarr_logg)
                dblarr_to_calibrate_all = dblarr_rave_mh(indarr_logg_all)
                print,'dblarr_rave_mh(indarr_logg_all(0:10)) = ',dblarr_rave_mh(indarr_logg_all(0:10))
                print,'dblarr_calib_all(0:10) = ',dblarr_calib_all(0:10)
              end else if b_logg then begin
                dblarr_to_calibrate = dblarr_logg_calib(indarr_logg)
                dblarr_to_calibrate_all = dblarr_rave_logg(indarr_logg_all)
              end else if b_afe then begin
                dblarr_to_calibrate = dblarr_afe_calib(indarr_logg)
                dblarr_to_calibrate_all = dblarr_rave_afe(indarr_logg_all)
              end
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                  IO_DBLARR_PARAMETER_VALUES = dblarr_to_calibrate,$
                                                                  I_DBLARR_X                 = dblarr_calib
              if b_do_all then begin
                ; --- all rave stars
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_to_calibrate_all,$
                                                                    I_DBLARR_X                 = dblarr_calib_all
              endif
              if b_teff then begin
                dblarr_teff_calib(indarr_logg) = dblarr_to_calibrate
                dblarr_rave_teff(indarr_logg_all) = dblarr_to_calibrate_all
              end else if b_cmh then begin
                dblarr_cmh_calib(indarr_logg) = dblarr_to_calibrate
                dblarr_rave_cmh(indarr_logg_all) = dblarr_to_calibrate_all
                print,'new dblarr_rave_cmh(indarr_logg_all(0:10)) = ',dblarr_rave_cmh(indarr_logg_all(0:10))
                ;if not(b_dwarfs_only) or ((abs(dblarr_calib_all(0) - dblarr_rave_stn(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_teff(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_logg(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_afe(indarr_logg_all(0))) gt 0.01)) then $
                ;  stop
              end else if b_mh then begin
                dblarr_mh_calib(indarr_logg) = dblarr_to_calibrate
                dblarr_rave_mh(indarr_logg_all) = dblarr_to_calibrate_all
                print,'new dblarr_rave_mh(indarr_logg_all(0:10)) = ',dblarr_rave_mh(indarr_logg_all(0:10))
                ;if not(b_dwarfs_only) or ((abs(dblarr_calib_all(0) - dblarr_rave_stn(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_teff(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_logg(indarr_logg_all(0))) gt 0.01) and (abs(dblarr_calib_all(0) - dblarr_rave_afe(indarr_logg_all(0))) gt 0.01)) then $
                ;  stop
              end else if b_logg then begin
                dblarr_logg_calib(indarr_logg) = dblarr_to_calibrate
                dblarr_rave_logg(indarr_logg_all) = dblarr_to_calibrate_all
              end else if b_afe then begin
                dblarr_afe_calib(indarr_logg) = dblarr_to_calibrate
                dblarr_rave_afe(indarr_logg_all) = dblarr_to_calibrate_all
              end

;            end else if int_do_stn_calib eq 10 then begin
;              dblarr_teff = dblarr_teff_calib(indarr_logg)
;              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
;                                                                  IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
;                                                                  I_DBLARR_X                 = dblarr_mh_rave_last(indarr_logg)
;              dblarr_teff_calib(indarr_logg) = dblarr_teff
;
;              if b_do_all then begin
;                ; --- all rave stars
;                dblarr_teff = dblarr_rave_teff(indarr_logg_all)
;                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
;                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
;                                                                    I_DBLARR_X                 = dblarr_rave_mh_last(indarr_logg_all)
;                dblarr_rave_teff(indarr_logg_all) = dblarr_teff
;              endif
            end else if int_do_stn_calib eq 11 then begin
              dblarr_logg = dblarr_logg_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB      = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_mh_rave_last(indarr_logg)
              dblarr_logg_calib(indarr_logg) = dblarr_logg

              if b_do_all then begin
                ; --- all rave stars
                dblarr_logg = dblarr_rave_logg(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                    I_DBLARR_X                 = dblarr_rave_mh_last(indarr_logg_all)
                dblarr_rave_logg(indarr_logg_all) = dblarr_logg
              endif
            end else if int_do_stn_calib eq 12 then begin
              dblarr_teff = dblarr_teff_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                I_DBLARR_X                 = dblarr_logg_rave_last(indarr_logg)
              dblarr_teff_calib(indarr_logg) = dblarr_teff

              if b_do_all then begin
                ; --- all rave stars
                dblarr_teff = dblarr_rave_teff(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                    I_DBLARR_X                 = dblarr_rave_logg_last(indarr_logg_all)
                dblarr_rave_teff(indarr_logg_all) = dblarr_teff
              endif
            end else if int_do_stn_calib eq 13 then begin
              dblarr_logg = dblarr_logg_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_teff_rave_last(indarr_logg)
              dblarr_logg_calib(indarr_logg) = dblarr_logg

              if b_do_all then begin
                ; --- all rave stars
                dblarr_logg = dblarr_rave_logg(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                    I_DBLARR_X                 = dblarr_rave_teff_last(indarr_logg_all)
                dblarr_rave_logg(indarr_logg_all) = dblarr_logg
              endif
            end else if int_do_stn_calib eq 14 then begin
              dblarr_mh = dblarr_cmh_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_teff_rave_last(indarr_logg)
              dblarr_cmh_calib(indarr_logg) = dblarr_mh

              if b_do_all then begin
                ; --- all rave stars
                dblarr_mh = dblarr_rave_cmh(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                    I_DBLARR_X                 = dblarr_rave_teff_last(indarr_logg_all)
                dblarr_rave_cmh(indarr_logg_all) = dblarr_mh
              endif
            end else if int_do_stn_calib eq 15 then begin
              dblarr_mh = dblarr_cmh_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_logg_rave_last(indarr_logg)
              dblarr_cmh_calib(indarr_logg) = dblarr_mh

              if b_do_all then begin
                ; --- all rave stars
                dblarr_mh = dblarr_rave_cmh(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                    I_DBLARR_X                 = dblarr_rave_logg_last(indarr_logg_all)
                dblarr_rave_cmh(indarr_logg_all) = dblarr_mh
              endif
            end else if int_do_stn_calib eq 16 then begin
              dblarr_mh = dblarr_mh_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_teff_rave_last(indarr_logg)
              dblarr_mh_calib(indarr_logg) = dblarr_mh

              if b_do_all then begin
                ; --- all rave stars
                dblarr_mh = dblarr_rave_mh(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                    I_DBLARR_X                 = dblarr_rave_teff_last(indarr_logg_all)
                dblarr_rave_mh(indarr_logg_all) = dblarr_mh
              endif
            end else if int_do_stn_calib eq 17 then begin
              dblarr_mh = dblarr_mh_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_logg_rave_last(indarr_logg)
              dblarr_mh_calib(indarr_logg) = dblarr_mh

              if b_do_all then begin
                ; --- all rave stars
                dblarr_mh = dblarr_rave_mh(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                    I_DBLARR_X                 = dblarr_rave_logg_last(indarr_logg_all)
                dblarr_rave_mh(indarr_logg_all) = dblarr_mh
              endif
            end else if int_do_stn_calib eq 18 then begin
              dblarr_afe = dblarr_afe_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_mh_rave_last(indarr_logg)
              dblarr_afe_calib(indarr_logg) = dblarr_afe

              if b_do_all then begin
                ; --- all rave stars
                dblarr_afe = dblarr_rave_afe(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                    I_DBLARR_X                 = dblarr_rave_mh_last(indarr_logg_all)
                dblarr_rave_afe(indarr_logg_all) = dblarr_afe
              endif
            end else if int_do_stn_calib eq 19 then begin
              dblarr_afe = dblarr_afe_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_Teff_rave_last(indarr_logg)
              dblarr_afe_calib(indarr_logg) = dblarr_afe

              if b_do_all then begin
                ; --- all rave stars
                dblarr_afe = dblarr_rave_afe(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                    I_DBLARR_X                 = dblarr_rave_teff_last(indarr_logg_all)
                dblarr_rave_afe(indarr_logg_all) = dblarr_afe
              endif
            end else if int_do_stn_calib eq 20 then begin
              dblarr_afe = dblarr_afe_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_logg_rave_last(indarr_logg)
              dblarr_afe_calib(indarr_logg) = dblarr_afe

              if b_do_all then begin
                ; --- all rave stars
                dblarr_afe = dblarr_rave_afe(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                    I_DBLARR_X                 = dblarr_rave_logg_last(indarr_logg_all)
                dblarr_rave_afe(indarr_logg_all) = dblarr_afe
              endif
            end else if int_do_stn_calib eq 21 then begin
              dblarr_mh = dblarr_mh_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_afe_rave_last(indarr_logg)
              dblarr_mh_calib(indarr_logg) = dblarr_mh

              if b_do_all then begin
                ; --- all rave stars
                dblarr_mh = dblarr_rave_mh(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                    I_DBLARR_X                 = dblarr_rave_afe_last(indarr_logg_all)
                dblarr_rave_mh(indarr_logg_all) = dblarr_mh
              endif
            end else if int_do_stn_calib eq 22 then begin
              dblarr_teff = dblarr_teff_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                I_DBLARR_X                 = dblarr_afe_rave_last(indarr_logg)
              dblarr_teff_calib(indarr_logg) = dblarr_teff

              if b_do_all then begin
                ; --- all rave stars
                dblarr_teff = dblarr_rave_teff(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                    I_DBLARR_X                 = dblarr_rave_afe_last(indarr_logg_all)
                dblarr_rave_teff(indarr_logg_all) = dblarr_teff
              endif
            end else if int_do_stn_calib eq 23 then begin
              dblarr_logg = dblarr_logg_calib(indarr_logg)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_afe_rave_last(indarr_logg)
              dblarr_logg_calib(indarr_logg) = dblarr_logg

              if b_do_all then begin
                ; --- all rave stars
                dblarr_logg = dblarr_rave_logg(indarr_logg_all)
                rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                    I_DBLARR_X                 = dblarr_rave_afe_last(indarr_logg_all)
                dblarr_rave_logg(indarr_logg_all) = dblarr_logg
              endif
            endif
          endif
        endfor
      endfor

      if b_do_calib_x_vs_ext then begin
        for i=0,2 do begin
          b_stn_only = 0
          int_xticks = 0
          int_yticks = 0
          dblarr_logg_rave = dblarr_rave_logg
          dblarr_stn_rave = dblarr_rave_stn
          b_not_do_calib_vs_parameter = 0
    ;      if i eq 1 then begin
    ;        print,'dblarr_rave_stn = ',dblarr_rave_stn
    ;        print,'size(dblarr_rave_stn) = ',size(dblarr_rave_stn)
    ;        stop
    ;      endif
          if i eq 0 then begin
            str_plotname_root = str_path + 'all_found_calib_'+strtrim(string(iii),2)+'_dTeff_vs_'
            dblarr_x = dblarr_teff_calib
            if iii eq 0 then begin
              if b_dwarfs_only then $
                int_nruns_calib = 4 $
              else if b_giants_only then $
                int_nruns_calib = 2
            end else begin
              if b_dwarfs_only then $
                int_nruns_calib = 3 $
              else if b_giants_only then $
                int_nruns_calib = 4
            end
            if b_giants_only then $
              b_not_do_calib_vs_parameter = 1
            dblarr_y = double(strarr_data(*, int_col_teff_ext))
            dblarr_rave = dblarr_rave_teff
            str_xtitle_stn = 'STN!DRAVE!N'
            str_xtitle = 'T!Deff, ext!N [K]'
            str_xtitle_hist = 'T!Deff!N [K]'
            str_ytitle = 'T!Deff, RAVE!N [K]'
            str_ytitle_diff = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
            str_parameter = 'Teff'
            dblarr_xrange_dwarfs = [4500.,7000.]
            dblarr_yrange_dwarfs = [4500.,7000.]
            dblarr_yrange_diff_dwarfs = [-1000.,1000.]
            dblarr_xrange_giants = [3700.,5050.]
            dblarr_yrange_giants = [3200.,5500.]
            dblarr_yrange_diff_giants = [-1000.,1000.]
            dblarr_yrange_hist_dwarfs = [0.,14.5]
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
          endif else if i eq 1 then begin
            str_plotname_root = str_path + 'all_found_calib_'+strtrim(string(iii),2)+'_dlogg_vs_'
            dblarr_x = dblarr_logg_calib
            dblarr_y = double(strarr_data(*, int_col_logg_ext))
            dblarr_rave = dblarr_rave_logg
            str_xtitle_stn = 'STN!DRAVE!N'
            str_xtitle = 'log g!Dext!N [dex]'
            str_xtitle_hist = 'log g [dex]'
            str_ytitle = '(log g)!DRAVE!N [dex]'
            str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
            str_parameter = 'logg'
            dblarr_xrange_dwarfs = [3.3,5.]
            dblarr_yrange_dwarfs = [3.3,5.]
            dblarr_yrange_diff_dwarfs = [-1.,1.]
            dblarr_xrange_giants = [0.,4.2]
            dblarr_yrange_giants = [0.,4.2]
            dblarr_yrange_diff_giants = dblarr_yrange_diff_dwarfs
            str_xtickformat = '(I3)'
            str_ytickformat = '(I3)'
            if iii eq 0 then begin
              if b_dwarfs_only then $
                int_nruns_calib = 4 $
              else if b_giants_only then $
                int_nruns_calib = 1
            end else begin
              if b_dwarfs_only then $
                int_nruns_calib = 2 $
              else if b_giants_only then $
                int_nruns_calib = 1
            end
          end else if i eq 2 then begin
            str_plotname_root = str_path + 'all_found_calib_'+strtrim(string(iii),2)+'_daFe_vs_'
            b_not_do_calib_vs_parameter = 0
            dblarr_x = dblarr_afe_calib
            dblarr_y = double(strarr_data(*, int_col_afe_ext))
            dblarr_rave = dblarr_rave_afe
            str_xtitle_stn = 'STN!DRAVE!N'
            str_xtitle = '[a/Fe]!Dext!N [dex]'
            str_xtitle_hist = '[a/Fe] [dex]'
            str_ytitle = '[a/Fe]!DRAVE!N [dex]'
            str_ytitle_diff = '[a/Fe]!Dext!N - [a/Fe]!DRAVE!N [dex]'
            str_parameter = 'aFe'
            dblarr_xrange_dwarfs = [-0.2,0.5]
            dblarr_yrange_dwarfs = [-0.2,0.5]
            dblarr_yrange_diff_dwarfs = [-0.5,0.5]
            dblarr_xrange_giants = [-0.2,0.5];dblarr_xrange_dwarfs
            dblarr_yrange_giants = [-0.2,0.5];dblarr_yrange_dwarfs
            dblarr_yrange_diff_giants = dblarr_yrange_diff_dwarfs
            dblarr_yrange_hist_dwarfs = 0
            dblarr_yrange_hist_giants = 0
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
            if b_dwarfs_only then $
              int_nruns_calib = 1 $
            else if b_giants_only then $
              int_nruns_calib = 1
            print,'before rave_calibrate_parameter: dblarr_afe_calib = ',dblarr_afe_calib
          endif else if i eq 3 then begin
            str_plotname_root = str_path + 'all_found_calib_'+strtrim(string(iii),2)+'_dmMH_vs_'
            dblarr_x = dblarr_mh_calib
            dblarr_y = double(strarr_data(*, int_col_mh_ext))
            dblarr_rave = dblarr_rave_mh
            str_xtitle_stn = 'STN!DRAVE!N'
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H],[m/H] [dex]'
            str_ytitle = '[m/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
            str_parameter = 'MH'
            dblarr_xrange_dwarfs = [-1.,0.5]
            dblarr_yrange_dwarfs = [-1.,0.5]
            dblarr_yrange_diff_dwarfs = [-1.,1.]
            dblarr_xrange_giants = [-3.,1.];dblarr_xrange_dwarfs
            dblarr_yrange_giants = [-3.,1.];dblarr_yrange_dwarfs
            dblarr_yrange_diff_giants = dblarr_yrange_diff_dwarfs
            dblarr_yrange_hist_dwarfs = 0
            dblarr_yrange_hist_giants = 0
            str_xtickformat = '(I3)'
            str_ytickformat = '(I3)'
            if b_dwarfs_only then begin
              str_xtickformat = '(F4.1)'
              str_ytickformat = '(F4.1)'
            endif
            if iii eq 0 then begin
              if b_dwarfs_only then $
                int_nruns_calib = 2 $
              else if b_giants_only then $
                int_nruns_calib = 2
            end else begin
              if b_dwarfs_only then $
                int_nruns_calib = 2 $
              else if b_giants_only then $
                int_nruns_calib = 2
            end
          endif else if i eq 4 then begin
            str_plotname_root = str_path + 'all_found_calib_'+strtrim(string(iii),2)+'_dMH_vs_'
            dblarr_x = dblarr_cmh_calib
            dblarr_y = double(strarr_data(*, int_col_mh_ext))
            dblarr_rave = dblarr_rave_cmh
            str_xtitle_stn = 'STN!DRAVE!N'
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
            str_parameter = 'MH'
            dblarr_xrange_dwarfs = [-1.,0.5]
            dblarr_yrange_dwarfs = [-1.,0.5]
            dblarr_yrange_diff_dwarfs = [-1.,1.]
            dblarr_xrange_giants = [-3.,1.];dblarr_xrange_dwarfs
            dblarr_yrange_giants = [-3.,1.];dblarr_yrange_dwarfs
            dblarr_yrange_diff_giants = dblarr_yrange_diff_dwarfs
            dblarr_yrange_hist_dwarfs = 0
            dblarr_yrange_hist_giants = 0
            str_xtickformat = '(I3)'
            str_ytickformat = '(I3)'
            if b_dwarfs_only then begin
              str_xtickformat = '(F4.1)'
              str_ytickformat = '(F4.1)'
            endif
;            if iii eq 0 then begin
;              if b_dwarfs_only then $
;                int_nruns_calib = 2 $
;              else if b_giants_only then $
;                int_nruns_calib = 3
;            end else begin
;              if b_dwarfs_only then $
;                int_nruns_calib = 1 $
;              else if b_giants_only then $
;                int_nruns_calib = 3
;            end
             int_nruns_calib = 1
          endif
    ;      if b_giants_only then stop
          indarr_clipped = [-1]
          rave_calibrate_parameter, IO_DBLARR_RAVE                       = dblarr_x,$
                                    I_DBLARR_EXTERNAL                    = dblarr_y,$
                                    IO_DBLARR_ALL_RAVE                   = dblarr_rave,$
                                    I_DBLARR_ALL_STN                     = dblarr_stn_rave,$
                                    I_DBLARR_ALL_LOGG                    = dblarr_logg_rave_last,$
                                    I_DBLARR_LOGG                        = dblarr_logg_ext_rave,$
                                    I_STR_PLOTNAME_ROOT                  = str_plotname_root,$
                                    I_STR_PARAMETER                      = str_parameter,$
                                    I_DBLARR_ERR_RAVE                    = double(strarr_data(*, int_col_eteff_rave)),$
                                    I_DBLARR_ERR_EXTERNAL                = double(strarr_data(*, int_col_eteff_ext)),$
                                    I_DBLARR_SNR                         = double(strarr_data(*, int_col_stn_rave)),$
                                    I_STR_XTITLE                         = str_xtitle,$
                                    I_STR_STN_XTITLE                     = str_xtitle_stn,$
                                    I_STR_HIST_XTITLE                    = str_xtitle_hist,$;            --- string
                                    I_STR_YTITLE                         = str_ytitle,$
                                    I_STR_DIFF_YTITLE                    = str_ytitle_diff,$
                                    I_STR_TITLE                          = 1,$
      ;                              I_INT_PSYM                           = ,$
                                    I_DBL_SYMSIZE                        = 1.0,$
                                    I_DBL_CHARSIZE                       = 1.8,$
                                    I_DBL_CHARTHICK                      = 3.,$
                                    I_DBL_THICK                          = 3.,$
                                    I_DBLARR_XRANGE_STN                  = [0.,200.],$
                                    I_DBLARR_XRANGE_DWARFS               = dblarr_xrange_dwarfs,$
                                    I_DBLARR_YRANGE_DWARFS               = dblarr_yrange_dwarfs,$
                                    I_DBLARR_XRANGE_GIANTS               = dblarr_xrange_giants,$
                                    I_DBLARR_YRANGE_GIANTS               = dblarr_yrange_giants,$
                                    I_DBLARR_YRANGE_DIFF_DWARFS          = dblarr_yrange_diff_dwarfs,$
                                    I_DBLARR_YRANGE_DIFF_GIANTS          = dblarr_yrange_diff_giants,$
                                    I_DBLARR_YRANGE_HIST_DWARFS          = dblarr_yrange_hist_dwarfs,$
                                    I_DBLARR_YRANGE_HIST_GIANTS          = dblarr_yrange_hist_giants,$
                                    I_DBLARR_POSITION                    = dblarr_position,$
                                    I_INT_XTICKS                         = int_xticks,$
                                    I_STR_XTICKFORMAT                    = str_xtickformat,$
                                    I_STR_YTICKFORMAT                    = str_ytickformat,$
                                    I_INT_YTICKS                         = int_yticks,$
                                    I_DBL_REJECTVALUEX                   = 0.000000000001,$;
                                    I_DBL_REJECTVALUE_X_RANGE            = 0.000000001,$;             --- double
                                    I_DBL_REJECTVALUEY                   = 0.000000000001,$;             --- double
                                    I_DBL_REJECTVALUE_Y_RANGE            = 0.000000001,$;             --- double
                                    I_B_PRINT_PDF                        = 1,$;               --- bool (0/1)
                                    I_INT_SIGMA_NBINS                    = int_sigma_nbins,$
      ;                              I_INT_SMOOTH_MEAN_SIG                = 1,$
                                    I_INT_SIGMA_MIN_ELEMENTS             = int_sigma_minelements,$
                                    I_DBL_SIGMA_CLIP                     = 3.,$
                                    ;I_B_USE_WEIGHTED_MEAN                = i_b_use_weighted_mean,$
                                    I_INT_HIST_NBINS_SET                 = 20,$;            --- int
                                    ;I_INT_HIST_NBINS_MIN                 = i_int_hist_nbins_min,$;            --- int
                                    ;I_INT_HIST_NBINS_MAX                 = i_int_hist_nbins_max,$;            --- int
                                    I_B_HIST_PERCENTAGE                  = 1,$;          --- bool (0/1)
                                    ;I_DBLARR_HIST_YRANGE                 = i_dblarr_hist_yrange,$
                                    O_STR_PLOTNAME_HIST                  = o_str_plotname_hist,$
                                    I_B_PRINT_MOMENTS                    = 1,$
                                    I_B_DO_SIGMA_CLIPPING                = 1,$
                                    O_INDARR_DATA                        = o_indarr_data,$
                                    O_INDARR_ALL_LOGG                    = o_indarr_all_logg,$
                                    IO_INDARR_CLIPPED                    = indarr_clipped,$
                                    I_INTARR_SYMBOLS                     = double(strarr_data(*, int_col_source_ext)),$
                                    ;I_DBL_REJECT_DIFF_STARS_BELOW        = i_dbl_reject_diff_stars_below,$
                                    ;I_DBL_REJECT_DIFF_STARS_ABOVE        = i_dbl_reject_diff_stars_above,$
                                    I_B_STN_ONLY                         = b_stn_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                                    I_B_DWARFS_ONLY                      = b_dwarfs_only,$
                                    I_B_GIANTS_ONLY                      = b_giants_only,$
                                    I_DBL_LIMIT_LOGG                     = 3.5,$
                                    I_B_CALIB_FROM_FIT                   = 1,$
                                    I_INT_NRUNS                          = 1,$
                                    I_B_NOT_DO_CALIB_VS_PARAMETER        = b_not_do_calib_vs_parameter,$
                                    I_B_FIT_MEAN                         = 1
          if i eq 0 then begin
            dblarr_teff_calib = dblarr_x
            dblarr_rave_teff = dblarr_rave
            print,'dblarr_teff_calib(o_indarr_data) = ',dblarr_teff_calib(o_indarr_data)
            indarr_clipped_teff = indarr_clipped
    ;        stop
          end else if i eq 1 then begin
            ;indarr_logg_calib = o_indarr_data
            dblarr_logg_calib = dblarr_x
            dblarr_rave_logg = dblarr_rave
            indarr_clipped_logg = indarr_clipped
          end else if i eq 2 then begin
            ;indarr_afe_calib = o_indarr_data
            dblarr_afe_calib = dblarr_x
            print,'after rave_calibrate_parameter: dblarr_afe_calib = ',dblarr_afe_calib
            dblarr_rave_afe = dblarr_rave
            indarr_clipped_afe = indarr_clipped
          end else if i eq 3 then begin
            ;indarr_mh_calib = o_indarr_data
            dblarr_mh_calib = dblarr_x
            dblarr_rave_mh = dblarr_rave
            indarr_clipped_mh = indarr_clipped
          end else if i eq 4 then begin
            ;indarr_cmh_calib = o_indarr_data
            dblarr_cmh_calib = dblarr_x
            dblarr_rave_cmh = dblarr_rave
            indarr_clipped_cmh = indarr_clipped
          endif
          indarr_calib = o_indarr_data
          indarr_logg_all = o_indarr_all_logg
    ;      print,'dblarr_stn_rave(indarr_calib) = ',dblarr_stn_rave(indarr_calib)
    ;      print,'dblarr_rave_stn(indarr_calib) = ',dblarr_rave_stn(indarr_calib)
    ;      stop
        endfor
      endif
    endfor; --- calibration runs
    free_lun,lunmeansig
  endfor; --- dwarfs/giants
  ;  str_filenames = [str_soubiran, str_pastel, str_echelle, str_gcs]
  for i=0,8 do begin
    if i eq 0 then begin
      print,'Soubiran: '
    end else if i eq 1 then begin
      print,'PASTEL: '
    end else if i eq 2 then begin
      print,'Echelle: '
    end else if i eq 3 then begin
      print,'GCS: '
    end else begin
      print,'i=',i
    end
    indarr = where(long(strarr_data(*,int_col_source_ext)) eq i)
    if indarr(0) ge 0 then begin
      print,n_elements(indarr),' stars'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_teff_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with Teff'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_logg_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with logg'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_logg_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with [M/H] / [Fe/H]'
    endif
  endfor
  printf,lun_html,'</center></body></html>'
  free_lun,lun_html

  print,'USE indarr_teff FOR EFFECTIVE TEMPERATURES!!!!!!!!!!!!!!!!!!!!!!!!!!'
end
