pro rave_compare_to_external_and_calibrate_teff
  str_filename = '/home/azuri/daten/rave/calibration/all_found.dat'
  str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  str_filename_rave_out = strmid(str_filename_rave,0,strpos(str_filename_rave,'.',/REVERSE_SEARCH))+'_calib-new.dat'

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
  indarr_stn = where(dblarr_rave_stn lt 1.)
  if indarr_stn(0) ge 0 then $
    dblarr_rave_stn(indarr_stn) = dblarr_rave_s2n(indarr_stn)
  dblarr_rave_s2n = 0
  dblarr_rave_logg_orig = dblarr_rave_logg

  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_rave_mh,$
                               I_DBLARR_AFE           = dblarr_rave_afe,$
                               I_DBLARR_TEFF          = dblarr_rave_teff,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_rave_logg,$; --- old calibration
                               I_DBLARR_STN           = dblarr_rave_stn,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = strarr_rave_mh_calibrated,$;           --- string array
                               I_DBL_REJECTVALUE      = 9.99,$; --- double
                               I_DBL_REJECTERR        = 1,$;       --- double
                               I_B_SEPARATE           = 1
  dblarr_rave_mh_calibrated = double(strarr_rave_mh_calibrated)

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_rave_logg,$
                                    O_INDARR_DWARFS  = indarr_dwarfs_all,$
                                    O_INDARR_GIANTS  = indarr_giants_all,$
                                    I_DBL_LIMIT_LOGG = 3.5

  str_htmlfile = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/index_calib_teff.html'
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

  for ii=1,2 do begin
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
    besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_feh), int_col_mh_ext)),$
                          O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                          I_INT_VERSION                     = 3;,$
    ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
    ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
    ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
    ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
;                          I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_feh), int_col_logg_rave))
          ;endif
    strarr_data(indarr(indarr_feh), int_col_mh_ext) = strtrim(string(o_dblarr_mh),2)
    str_filename_meansig = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_mean_sig_diff'
    if b_dwarfs_only then $
      str_filename_meansig = str_filename_meansig + '_dwarfs'
    if b_giants_only then $
      str_filename_meansig = str_filename_meansig + '_giants'
    str_filename_meansig = str_filename_meansig + '.dat'
    openw,lunmeansig,str_filename_meansig,/GET_LUN

    dblarr_teff_rave_orig = double(strarr_data(*,int_col_teff_rave))
    dblarr_logg_rave_orig = double(strarr_data(*,int_col_logg_rave))
    dblarr_mh_rave_orig   = double(strarr_data(*,int_col_mh_rave))
    dblarr_afe_rave_orig   = double(strarr_data(*,int_col_afe_rave))

    rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh_rave_orig,$
                                  I_DBLARR_AFE           = double(strarr_data(*,int_col_afe_rave)),$
                                  I_DBLARR_TEFF          = dblarr_teff_rave_orig,$; --- new calibration
                                  I_DBLARR_LOGG          = dblarr_logg_rave_orig,$; --- old calibration
                                  I_DBLARR_STN           = double(strarr_data(*,int_col_stn_rave)),$; --- calibration from DR3 paper
                                  O_STRARR_MH_CALIBRATED = strarr_mh_rave_calibrated_orig,$;           --- string array
                                  I_DBL_REJECTVALUE      = 9.99,$; --- double
                                  I_DBL_REJECTERR        = 1,$;       --- double
                                  I_B_SEPARATE           = 1

    dblarr_position = [0.205,0.175,0.932,0.925]
    dblarr_position_diff=[0.205,0.175,0.932,0.925]
    dblarr_position_hist=[0.205,0.175,0.932,0.925]

    indarr = where((abs(double(strarr_data(*,int_col_teff_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_teff_rave))) ge 0.0000001))
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_teff_rave_orig = ',dblarr_teff_rave_orig
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_teff_ext = ',strarr_data(*, int_col_teff_ext)
    print,'rave_compare_to_external_and_calibrate_teff: size(dblarr_teff_rave_orig) = ',size(dblarr_teff_rave_orig)
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_logg_ext = ',strarr_data(*, int_col_logg_ext)
    dblarr_logg_ext_rave = double(strarr_data(*, int_col_logg_ext))
    indarr_no_logg = where(abs(dblarr_logg_ext_rave) lt 0.0000000001)
    if indarr_no_logg(0) ge 0 then $
      dblarr_logg_ext_rave(indarr_no_logg) = dblarr_logg_rave_orig(indarr_no_logg)
    print,'rave_compare_to_external_and_calibrate_teff: dblarr_logg_ext_rave = ',dblarr_logg_ext_rave
;    stop
    for iii = 0,1 do begin
      for i=0,4 do begin
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
          if iii eq 0 then begin
            dblarr_x = dblarr_teff_rave_orig
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff_vs_'
            if b_dwarfs_only then $
              int_nruns_calib = 4 $
            else if b_giants_only then $
              int_nruns_calib = 2
          end else if iii eq 1 then begin
            dblarr_x = dblarr_teff_calib
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_vs_'
            if b_dwarfs_only then $
              int_nruns_calib = 4 $
            else if b_giants_only then $
              int_nruns_calib = 4
          end
          dblarr_y = double(strarr_data(*, int_col_teff_ext))
          dblarr_rave = dblarr_rave_teff
          str_xtitle_stn = 'STN!DRAVE!N'
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          str_parameter = 'Teff'
          dblarr_xrange_dwarfs = [4500.,7500.]
          dblarr_yrange_dwarfs = [4500.,7500.]
          dblarr_yrange_diff_dwarfs = [-1000.,1000.]
          dblarr_xrange_giants = [3700.,5050.]
          dblarr_yrange_giants = [3200.,5500.]
          dblarr_yrange_diff_giants = [-1000.,1000.]
          dblarr_yrange_hist_dwarfs = [0.,14.5]
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
        endif else if i eq 1 then begin
          if iii eq 0 then begin
            dblarr_x = double(strarr_data(*, int_col_mh_rave))
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH_vs_'
          end else if iii eq 1 then begin
            dblarr_x = dblarr_mh_calib
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_vs_'
          end
          dblarr_y = double(strarr_data(*, int_col_mh_ext))
          dblarr_rave = dblarr_rave_mh
          str_xtitle_stn = 'STN!DRAVE!N'
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H],[m/H] [dex]'
          str_ytitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          str_parameter = 'MH'
          dblarr_xrange_dwarfs = [-1.5,1.]
          dblarr_yrange_dwarfs = [-1.5,1.]
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
          if b_dwarfs_only then $
            int_nruns_calib = 4 $
          else if b_giants_only then $
            int_nruns_calib = 4
        endif else if i eq 2 then begin
          if iii eq 0 then begin
            dblarr_x = double(strarr_mh_rave_calibrated_orig)
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_'
          end else if iii eq 1 then begin
            dblarr_x = dblarr_cmh_calib
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_vs_'
          end
          dblarr_y = double(strarr_data(*, int_col_mh_ext))
          dblarr_rave = dblarr_rave_mh_calibrated
          str_xtitle_stn = 'STN!DRAVE!N'
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          str_parameter = 'MH'
          dblarr_xrange_dwarfs = [-1.5,1.]
          dblarr_yrange_dwarfs = [-1.5,1.]
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
          if b_dwarfs_only then $
            int_nruns_calib = 4 $
          else if b_giants_only then $
            int_nruns_calib = 4
        endif else if i eq 3 then begin
          if iii eq 0 then begin
            dblarr_x = dblarr_logg_rave_orig
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_'
          end else if iii eq 1 then begin
            dblarr_x = dblarr_logg_calib
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_'
          end
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
          dblarr_xrange_giants = [-1.,3.8]
          dblarr_yrange_giants = [-1.,3.8]
          dblarr_yrange_diff_giants = dblarr_yrange_diff_dwarfs
          str_xtickformat = '(I3)'
          str_ytickformat = '(I3)'
          if b_dwarfs_only then $
            int_nruns_calib = 4 $
          else if b_giants_only then $
            int_nruns_calib = 4
        end else begin
          if iii eq 0 then begin
            dblarr_x = double(strarr_data(*, int_col_afe_rave))
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe_vs_'
            b_not_do_calib_vs_parameter = 1
          end else if iii eq 1 then begin
            dblarr_x = dblarr_afe_calib
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_vs_'
          end
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
        endelse
  ;      if b_giants_only then stop
        indarr_clipped = [-1]
        rave_calibrate_parameter, IO_DBLARR_RAVE                       = dblarr_x,$
                                  I_DBLARR_EXTERNAL                    = dblarr_y,$
                                  IO_DBLARR_ALL_RAVE                   = dblarr_rave,$
                                  I_DBLARR_ALL_STN                     = dblarr_stn_rave,$
                                  I_DBLARR_ALL_LOGG                    = dblarr_logg_rave_orig,$
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
                                  I_INT_SIGMA_NBINS                    = 20,$
    ;                              I_INT_SMOOTH_MEAN_SIG                = 1,$
                                  I_INT_SIGMA_MIN_ELEMENTS             = 2,$
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
                                  I_INT_NRUNS                          = int_nruns_calib,$
                                  I_B_NOT_DO_CALIB_VS_PARAMETER        = b_not_do_calib_vs_parameter
        if i eq 0 then begin
          dblarr_teff_calib = dblarr_x
          dblarr_teff_all_calib = dblarr_rave
          print,'dblarr_teff_calib(o_indarr_data) = ',dblarr_teff_calib(o_indarr_data)
          indarr_clipped_teff = indarr_clipped
  ;        stop
        end else if i eq 1 then begin
          ;indarr_mh_calib = o_indarr_data
          dblarr_mh_calib = dblarr_x
          dblarr_mh_all_calib = dblarr_rave
          indarr_clipped_mh = indarr_clipped
        end else if i eq 2 then begin
          ;indarr_cmh_calib = o_indarr_data
          dblarr_cmh_calib = dblarr_x
          dblarr_cmh_all_calib = dblarr_rave
          indarr_clipped_cmh = indarr_clipped
        end else if i eq 3 then begin
          ;indarr_logg_calib = o_indarr_data
          dblarr_logg_calib = dblarr_x
          dblarr_logg_all_calib = dblarr_rave
          indarr_clipped_logg = indarr_clipped
        end else begin
          ;indarr_afe_calib = o_indarr_data
          dblarr_afe_calib = dblarr_x
          dblarr_afe_all_calib = dblarr_rave
          indarr_clipped_afe = indarr_clipped
        endelse
        indarr_calib = o_indarr_data
        indarr_logg_all = o_indarr_all_logg
  ;      print,'dblarr_stn_rave(indarr_calib) = ',dblarr_stn_rave(indarr_calib)
  ;      print,'dblarr_rave_stn(indarr_calib) = ',dblarr_rave_stn(indarr_calib)
  ;      stop
      endfor

      rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_ext_rave,$
                                        O_INDARR_DWARFS  = indarr_dwarfs,$
                                        O_INDARR_GIANTS  = indarr_giants,$
                                        I_DBL_LIMIT_LOGG = 3.5
      if b_dwarfs_only then begin
        indarr_logg = indarr_dwarfs
        indarr_logg_all = indarr_dwarfs_all
      end else if b_giants_only then begin
        indarr_logg = indarr_giants
        indarr_logg_all = indarr_dwarfs_all
      end else begin
        indarr_logg = lindgen(n_elements(dblarr_logg_ext_rave))
        indarr_logg_all = lindgen(n_elements(dblarr_rave_logg))
      endelse
      int_col_err_ext = int_col_elogg_rave
      int_col_err_rave = int_col_elogg_rave
      for i=0,78 do begin
        print,'ii=',ii,', i=',i
        int_smooth_mean_sig = 0
        int_sigma_nbins = 15
        int_sigma_minelements = 2
        dbl_sigma_clip = 3.
        i_do_stn_calib = 0
        b_diff_plot_y_minus_x = 0
        dblarr_coeffs_dlogg_vs_dteff_giants = 0
        dblarr_lines_in_diff_plot = 0
        dblarr_vertical_lines = 0
        dblarr_yfit = 0
        indarr_clipped = 0
        if i eq 0 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          dblarr_xrange = [3500.,7500.]
          dblarr_yrange = [3500.,7500.]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          i_xticks = 0
          i_yticks = 4
          b_print_moments = 1
          dblarr_yfit = 0
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            dblarr_yrange = [4500.,7500.]
            i_xticks = 0
            b_print_moments = 1
          endif
          if b_giants_only then begin
            b_print_moments = 3
            dbl_sigma_clip = 3.
            i_xticks = 0
            i_yticks = 0
          endif
          indarr_ext = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext)
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = dblarr_teff_calib(indarr)
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_Teff-RAVE_vs_Teff-ext'
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_diff_only = 0
          dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          indarr_clipped = indarr_clipped_teff
        end else if i eq 1 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext)
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
          indarr_clipped = indarr_clipped_teff
        end else if i eq 2 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_dTeff'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_dteff'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - double(strarr_data(indarr, int_col_teff_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          print,double(strarr_data(indarr, int_col_logg_ext))
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
          indarr_clipped = indarr_clipped_logg
        end else if i eq 3 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dTeff'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dteff'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - double(strarr_data(indarr, int_col_teff_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
          dblarr_vertical_lines = [0.0000000001]
          indarr_clipped = indarr_clipped_logg
        end else if i eq 4 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dTeff-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dteff-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
          indarr_clipped = indarr_clipped_logg
        end else if i eq 5 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_Teff-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_teff-ext'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [4500., 7500.]
            i_xticks = 6
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,6500.]
            i_xticks = 6
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
          indarr_clipped = indarr_clipped_logg
        end else if i eq 6 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_Teff-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_teff-ext'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500., 7500.]
            str_file_calib = str_file_calib + '_dwarfs'
            i_xticks = 6
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,6500.]
            i_xticks = 6
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
          indarr_clipped = indarr_clipped_logg
        end else if i eq 7 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_Teff-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_teff-calib'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500., 7500.]
            str_file_calib = str_file_calib + '_dwarfs'
            i_xticks = 6
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,6500.]
            i_xticks = 6
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_teff,indarr_ext_logg,indarr_ext_teff_logg,indarr_ext_logg_teff
          indarr = indarr_calib(indarr_ext_teff(indarr_ext_teff_logg))
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 8 then begin
          str_xtitle = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_dmMH'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_dmMH'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_data(indarr, int_col_mh_rave))
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 9 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dmMH'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dmMH'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_data(indarr, int_col_mh_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 10 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dmMH-calib'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dmMH'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 11 then begin
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_MH-ext'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 4
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          b_diff_only = 1
          dblarr_vertical_lines = 0
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 12 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_MH-ext'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
            str_xtickformat = '(I4)'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 13 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_mH-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_mH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
            str_xtickformat = '(I4)'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dmh(0),dblarr_coeffs_dlogg_vs_dmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 14 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg_vs_dMH'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_dMH'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated_orig(indarr))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 15 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dMH'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dMH'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated_orig(indarr))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 16 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_dMH-calib'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_dMH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.,1.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          match,indarr_ext_mh,indarr_ext_logg,indarr_ext_mh_logg,indarr_ext_logg_mh
          indarr = indarr_calib(indarr_ext_mh(indarr_ext_mh_logg))
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000000001]
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 17 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_vs_logg-calib'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dTeff-calib_vs_logg-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [2.7,5.5]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,4.2]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 18 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_vs_Teff-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_vs_Teff-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [4500.,7500.]
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [3500.,6000.]
            i_xticks = 5
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 19 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_vs_logg-calib'
          i_xticks = 0
          i_yticks = 4
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_vs_logg-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [3.3,5.5]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-1.,3.7]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 20 then begin
          i_do_stn_calib = 10
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 4
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_vs_mH-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dTeff-calib_vs_mH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_mh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_mh(0),dblarr_coeffs_dlogg_vs_mh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 21 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib_vs_mH-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dTeff-calib_calib-mH_vs_mH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          if n_elements(dblarr_mh_calib) ne n_elements(dblarr_teff_calib) then stop
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 22 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_teff)
          remove_subarr_from_array,indarr,indarr_clipped_teff
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 23 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_hist = 'Percentage of stars'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_xrange = [3500., 7000.]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange = [3500., 7000.]
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            dblarr_yrange = [4500.,7500.]
          end else if b_giants_only then begin
            b_print_moments = 3
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib_vs_Teff-ext'
          i_yticks = 0
          i_xticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_teff)
          remove_subarr_from_array,indarr,indarr_clipped_teff
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = dblarr_teff_calib(indarr)
          b_diff_only = 0
        end else if i eq 24 then begin
          i_do_stn_calib = 11
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_vs_mH-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_vs_mH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
          end
            str_file_calib = str_file_calib + '.dat'
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_mh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_mh(0),dblarr_coeffs_dlogg_vs_mh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 25 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_calib-mH_vs_mH-calib'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib_calib-mH_vs_mH-calib'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
            dblarr_xrange = [-1.5,1.]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-3.,1.]
          end
          str_file_calib = str_file_calib + '.dat'
          if n_elements(dblarr_mh_calib) ne n_elements(dblarr_logg_calib) then stop
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 26 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_calib-mH-calib_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_logg);(indarr_teff_calib)
          remove_subarr_from_array,indarr,indarr_clipped_logg
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave));double(strarr_data(indarr, int_col_logg_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 27 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!Dext!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_hist = 'Percentage of stars'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_xrange = [0., 5.5]
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3, 5.2]
            dblarr_yrange = [3.3, 5.2]
          end else if b_giants_only then begin
            dblarr_xrange = [0.,3.7]
            dblarr_yrange = [0.,3.7]
          endif
          dblarr_yrange_diff = [-1.5,1.5]
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_calib-mH-calib_vs_logg-ext'
          i_yticks = 0
          i_xticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_logg)
          remove_subarr_from_array,indarr,indarr_clipped_logg
          dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
          dblarr_y = dblarr_logg_calib(indarr)
          b_diff_only = 0
        end else if i eq 28 then begin
          i_do_stn_calib = 12
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH_vs_logg-calib_calib-mH'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dTeff-calib_calib-mH_vs_logg-calib_calib-mH'
          if b_dwarfs_only then begin
            dblarr_xrange = [2.7,5.5]
            str_xtickformat = '(F4.1)'
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-1.,4.2]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 29 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH_calib-logg_vs_logg-calib_calib-mH'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [2.7,5.5]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            dblarr_xrange = [-1.,4.2]
          end
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 30 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH_calib-logg_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 31 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_hist = 'Percentage of stars'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          dblarr_xrange = [3500., 7500.]
          dblarr_yrange = [3500., 7500.]
          dblarr_yrange_diff = [-1000.,1000.]
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            dblarr_yrange = [4500.,7500.]
          end else if b_giants_only then begin
            b_print_moments = 3
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH_calib-logg_vs_Teff-ext'
          i_yticks = 0
          i_xticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = dblarr_teff_calib(indarr)
          b_diff_only = 0
        end else if i eq 32 then begin
          ; --- calib dlogg vs Teff
          i_do_stn_calib = 13
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib-mH_vs_Teff-calib-mH-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg-calib-mH_vs_Teff-calib-mH-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500., 7500.]
            i_xticks = 6
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,6500.]
            i_xticks = 6
            str_file_calib = str_file_calib + '_giants'
          end
            str_file_calib = str_file_calib + '.dat'
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dteff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dteff(0),dblarr_coeffs_dlogg_vs_dteff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 33 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib-mH-Teff_vs_Teff-calib-mH-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [4500., 7500.]
            i_xticks = 6
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,6500.]
            i_xticks = 6
          end
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 34 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_calib-mH_calib-Teff_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_logg)
          remove_subarr_from_array,indarr,indarr_clipped_logg
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 35 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!Dext!N [dex]'
          str_xtitle_hist = '(log g) [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_calib-mH_calib-Teff_vs_logg-ext'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3, 5.2]
            dblarr_yrange = [3.3, 5.2]
            i_xticks = 0
          end else if b_giants_only then begin
            dblarr_xrange = [-0.5, 3.7]
            dblarr_yrange = [-0.5, 3.7]
            i_xticks = 0
          end
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
          dblarr_y = dblarr_logg_calib(indarr)
          b_diff_only = 0
        end else if i eq 36 then begin
          ; calib dMH vs Teff
          i_do_stn_calib = 14
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [3500.,6000.]
            i_xticks = 5
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 37 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [3500.,6000.]
            i_xticks = 5
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
        end else if i eq 38 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff-calib-mH-calib-logg_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_mh)
          remove_subarr_from_array,indarr,indarr_clipped_cmh
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
        end else if i eq 39 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff-calib-mH-calib-logg_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5, 1.]
            dblarr_yrange = [-1.5, 1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            dblarr_yrange = [-3.,1.]
            i_xticks = 4
          end
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = dblarr_cmh_calib(indarr)
          b_diff_only = 0
        end else if i eq 40 then begin
          ; calib dMH vs logg
          i_do_stn_calib = 15
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-teff'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.2]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-0.2,3.7]
            i_xticks = 0
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dcmh_vs_logg = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dcmh_vs_logg(0),dblarr_coeffs_dcmh_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 41 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff_calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dMH-calib_calib-Teff_calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.2]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-0.2,3.7]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
        end else if i eq 42 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([M/H]!Dext!N - [M/H]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff-calib-mH-calib-logg_calib-logg-calib-mH-calib-Teff_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_mh)
          remove_subarr_from_array,indarr,indarr_clipped_cmh
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_cmh_calib(indarr)
          b_diff_only = 1
        end else if i eq 43 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH-calib_calib-Teff-calib-mH-calib-logg_calib-logg-calib-mH-calib-Teff_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5, 1.]
            dblarr_yrange = [-1.5, 1.]
            i_xticks = 5
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            dblarr_yrange = [-3.,1.]
            i_xticks = 4
          end
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_cmh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = dblarr_cmh_calib(indarr)
          b_diff_only = 0
        end else if i eq 44 then begin
          ; calib dMH vs Teff
          i_do_stn_calib = 16
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1

          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmH-calib_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [3500.,6000.]
            i_xticks = 5
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dlogg_vs_dcmh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dlogg_vs_dcmh(0),dblarr_coeffs_dlogg_vs_dcmh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 45 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmH-calib_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [3500.,6000.]
            i_xticks = 5
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
        end else if i eq 46 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff-calib-mH-calib-logg_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_mh)
          remove_subarr_from_array,indarr,indarr_clipped_mh
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
        end else if i eq 47 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff-calib-mH-calib-logg_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5, 1.]
            dblarr_yrange = [-1.5, 1.]
            str_xtickformat = '(F4.1)'
            i_xticks = 5
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            dblarr_yrange = [-3.,1.]
            i_xticks = 4
          end
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = dblarr_mh_calib(indarr)
          b_diff_only = 0
        end else if i eq 48 then begin
          ; calib dMH vs logg
          i_do_stn_calib = 17
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-teff'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.2]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-0.2,3.7]
            i_xticks = 0
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dcmh_vs_logg = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dcmh_vs_logg(0),dblarr_coeffs_dcmh_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 49 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff_calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmH-calib_calib-Teff_calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.2]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
            dblarr_xrange = [-0.2,3.7]
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
        end else if i eq 50 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff-calib-mH-calib-logg_calib-logg-calib-mH-calib-Teff_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_mh)
          remove_subarr_from_array,indarr,indarr_clipped_mh
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
        end else if i eq 51 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmH-calib_calib-Teff-calib-mH-calib-logg_calib-logg-calib-mH-calib-Teff_vs_MH-ext'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5, 1.]
            dblarr_yrange = [-1.5, 1.]
            i_xticks = 5
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            dblarr_yrange = [-3.,1.]
            i_xticks = 4
          end
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = dblarr_mh_calib(indarr)
          b_diff_only = 0
        end else if i eq 52 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 6
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          dblarr_xrange = [-0.1,0.4]
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_vs_aFe'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1

          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmMH-calib_vs_aFe'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dmh_vs_afe(0),dblarr_coeffs_dmh_vs_afe(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 53 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.5,0.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,7500.]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_teff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_teff(0),dblarr_coeffs_dafe_vs_teff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 54 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.5,0.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_vs_logg-calib_calib-mH_calib-Teff'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.5]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-0.2,3.7]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_logg = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_logg(0),dblarr_coeffs_dafe_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 55 then begin
          i_do_stn_calib = 18
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_vs_mH-calib_calib-Teff_calib-logg'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_vs_mH-calib_calib-Teff_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5,1.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_mh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_mh(0),dblarr_coeffs_dafe_vs_mh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 56 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH_vs_mH-calib_calib-Teff_calib-logg'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_calib-mH_vs_mH-calib_calib-Teff_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5,1.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-3.,1.]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_mh_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_mh = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_mh(0),dblarr_coeffs_dafe_vs_mh(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 57 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_afe)
          remove_subarr_from_array,indarr,indarr_clipped_afe
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
        end else if i eq 58 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
          str_xtitle_hist = '[!4a!3/Fe] [dex]'
          str_ytitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH_vs_aFe-ext'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 3
          dblarr_xrange = [0., 0.4]
          dblarr_yrange = [0., 0.4]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
          dblarr_y = dblarr_afe_calib(indarr)
          b_diff_only = 0
        end else if i eq 59 then begin
          i_do_stn_calib = 19
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.5,0.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,7500.]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_teff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_teff(0),dblarr_coeffs_dafe_vs_teff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 60 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.5,0.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_calib-mH_calib-Teff_vs_Teff-calib_calib-mH_calib-logg'
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [3500.,7500.]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_teff_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_teff = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_teff(0),dblarr_coeffs_dafe_vs_teff(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 61 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_afe)
          remove_subarr_from_array,indarr,indarr_clipped_afe
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
        end else if i eq 62 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
          str_xtitle_hist = '[!4a!3/Fe] [dex]'
          str_ytitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff_vs_aFe-ext'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 3
          dblarr_xrange = [0., 0.4]
          dblarr_yrange = [0., 0.4]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
          dblarr_y = dblarr_afe_calib(indarr)
          b_diff_only = 0
        end else if i eq 63 then begin
          i_do_stn_calib = 20
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff_vs_logg-calib_calib-mH_calib-Teff'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_calib-mH-calib-Teff_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.5]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-0.2,3.7]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_logg = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_logg(0),dblarr_coeffs_dafe_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 64 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '[!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff-calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_daFe-calib_calib-mH-calib-Teff-calib-logg_vs_logg-calib_calib-mH_calib-Teff'
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3,5.5]
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            dblarr_xrange = [-0.2,3.7]
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = dblarr_logg_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dafe_vs_logg = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_logg(0),dblarr_coeffs_dafe_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 65 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff-calib-logg_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_afe)
          remove_subarr_from_array,indarr,indarr_clipped_afe
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_afe_ext)) - dblarr_afe_calib(indarr)
          b_diff_only = 1
        end else if i eq 66 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!Dext!N [dex]'
          str_xtitle_hist = '[!4a!3/Fe] [dex]'
          str_ytitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '([!4a!3/Fe]!Dext!N - [!4a!3/Fe]!DRAVE!N) [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-0.4,0.4]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_daFe-calib_calib-mH-calib-Teff-calib-logg_vs_aFe-ext'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 3
          dblarr_xrange = [0., 0.4]
          dblarr_yrange = [0., 0.4]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_afe,indarr_clipped_afe
          indarr = indarr_calib(indarr_ext_afe)
          dblarr_x = double(strarr_data(indarr, int_col_afe_ext))
          dblarr_y = dblarr_afe_calib(indarr)
          b_diff_only = 0
        end else if i eq 67 then begin
          i_do_stn_calib = 21
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_xrange = [0.,0.4]
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_calib-Teff-calib-logg_vs_afe-calib_calib-mH-calib-Teff-calib-logg'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmMH-calib_calib-Teff-calib-logg_vs_afe-calib_calib-mH-calib-Teff-calib-logg'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_logg(0),dblarr_coeffs_dafe_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 68 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 0
          dblarr_xrange = [0.,0.4]
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_calib-Teff-calib-logg-calib-afe_vs_afe-calib_calib-mH-calib-Teff-calib-logg'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          str_file_calib = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dmMH-calib_calib-Teff-calib-logg-calib-afe_vs_afe-calib_calib-mH-calib-Teff-calib-logg'
          if b_dwarfs_only then begin
            str_file_calib = str_file_calib + '_dwarfs'
          end else if b_giants_only then begin
            str_file_calib = str_file_calib + '_giants'
          end
          str_file_calib = str_file_calib + '.dat'
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
          dblarr_coeffs_dmh_vs_afe = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          openw,lun_calib,str_file_calib,/GET_LUN
            printf,lun_calib,dblarr_coeffs_dafe_vs_logg(0),dblarr_coeffs_dafe_vs_logg(1)
          free_lun,lun_calib
          print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
        end else if i eq 69 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_calib-Teff-calib-logg-calib-afe_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_afe = where(abs(double(strarr_data(indarr_calib,int_col_afe_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_mh)
          remove_subarr_from_array,indarr,indarr_clipped_mh
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - dblarr_mh_calib(indarr)
          b_diff_only = 1
        end else if i eq 70 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[m/H]!DRAVE!N [dex]'
          str_ytitle_diff = '([M/H]!Dext!N - [m/H]!DRAVE!N) [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.,1.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dmMH-calib_calib-Teff-calib-logg-calib-afe_vs_mh-ext'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          dblarr_xrange = [-3., 1.]
          dblarr_yrange = [-3., 1.]
          if b_dwarfs_only then begin
            dblarr_xrange = [-1.5, 1.]
            dblarr_yrange = [-1.5, 1.]
          end else if b_giants_only then begin
            dblarr_xrange = [-2.5, 0.5]
            dblarr_yrange = [-2.5, 0.5]
          endif
          b_print_moments = 3
          indarr_ext_mh = where(abs(double(strarr_data(indarr_calib,int_col_mh_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_mh,indarr_clipped_mh
          indarr = indarr_calib(indarr_ext_mh)
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = dblarr_mh_calib(indarr)
          b_diff_only = 0
        end else if i eq 71 then begin
          i_do_stn_calib = 22
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 4
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_xrange = [0.,0.4]
          str_xtickformat = '(F4.1)'
          i_xticks = 0
          dblarr_yrange_hist = 0
          i_yticks = 0
          str_ytickformat = '(I6)'
          b_print_moments = 1
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 72 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3/Fe]!DRAVE!N [dex]'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_xrange = [0.,0.4]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib-logg_vs_aFe-calib-calib-mH-calib-Teff-calib-logg'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_teff,indarr_clipped_teff
          indarr = indarr_calib(indarr_ext_teff)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 73 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib-logg-calib-aFe_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_teff)
          remove_subarr_from_array,indarr,indarr_clipped_teff
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_teff_ext)) - dblarr_teff_calib(indarr)
          b_diff_only = 1
        end else if i eq 74 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_hist = 'Percentage of stars'
          str_ytitle_diff = '(T!Deff, ext!N - T!Deff, RAVE!N) [K]'
          i_xticks = 5
          dblarr_xrange = [3500., 7000.]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange_diff = [-1000.,1000.]
          dblarr_yrange = [3500., 7000.]
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            dblarr_yrange = [4500.,7500.]
          end else if b_giants_only then begin
            b_print_moments = 3
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dTeff-calib_calib-mH-calib-logg-calib-aFe_vs_Teff-ext'
          i_yticks = 0
          i_xticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_ext_teff = where(abs(double(strarr_data(indarr_calib,int_col_teff_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_teff)
          remove_subarr_from_array,indarr,indarr_clipped_teff
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = dblarr_teff_calib(indarr)
          b_diff_only = 0
        end else if i eq 75 then begin
          ; --- calib dlogg vs Teff
          i_do_stn_calib = 23
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [0.,0.4]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_mH-calib_Teff-calib_vs_aFe-calib_mH-calib_Teff-calib_logg-calib'
          i_xticks = 4
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 76 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '[!4a!3]!DRAVE!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1000.,1000.]
          i_xticks = 4
          dblarr_yrange = [-1.5, 1.5]
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          dblarr_xrange = [0., 0.4]
          i_xticks = 4
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_mH-calib_Teff-calib_aFe-calib_vs_aFe-calib_mH-calib_Teff-calib_logg-calib'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = dblarr_afe_calib(indarr)
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 77 then begin
          int_smooth_mean_sig = 1
          str_xtitle = 'STN'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N) [dex]'
          i_xticks = 5
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_mH-calib_Teff-calib_aFe-calib_vs_STN'
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          dblarr_xrange = [0., 200.]
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          indarr = indarr_calib(indarr_ext_logg)
          remove_subarr_from_array,indarr,indarr_clipped_logg
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_ext)) - dblarr_logg_calib(indarr)
          b_diff_only = 1
        end else if i eq 78 then begin
          int_smooth_mean_sig = 1
          str_xtitle = '(log g)!Dext!N [dex]'
          str_xtitle_hist = '(log g) [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          i_xticks = 4
          dblarr_yrange_diff = [-1.5,1.5]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dlogg-calib_mH-calib_Teff-calib_aFe-calib_vs_logg-ext'
          i_yticks = 0
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3, 5.2]
            dblarr_yrange = [3.3, 5.2]
            i_xticks = 0
          end else if b_giants_only then begin
            dblarr_xrange = [-0.5, 3.7]
            dblarr_yrange = [-0.5, 3.7]
            i_xticks = 0
          end
          indarr_ext_logg = where(abs(double(strarr_data(indarr_calib,int_col_logg_ext))) ge 0.0000001)
          remove_subarr_from_array,indarr_ext_logg,indarr_clipped_logg
          indarr = indarr_calib(indarr_ext_logg)
          dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
          dblarr_y = dblarr_logg_calib(indarr)
          b_diff_only = 0










        end else if i eq 58 then begin
          dblarr_yfit = 0
          if not b_dwarfs_only then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_elogg_rave
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
  ;          if b_giants_only then begin
  ;            dblarr_yrange_hist = [0.,21.]
  ;          endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext-no-FeH_vs_MH-RAVE-giants'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            b_diff_only = 0
            dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          endif else begin
            dblarr_yfit = 0
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_elogg_rave
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = 'STN!DRAVE!N'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
            dblarr_xrange = [0., 200.]
            dblarr_yrange = [-2.5, 0.5]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_STN-RAVE-calib'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(I6)'
            str_ytickformat = '(I6)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
    ;        strarr_data(indarr, int_col_rave) = output
            dblarr_mh = double(strarr_mh_rave_calibrated(indarr))
            dblarr_mh_new = dblarr_mh + (double(strarr_data(indarr, int_col_stn_rave)) * dblarr_coeffs_mh_vs_stn(1) + dblarr_coeffs_mh_vs_stn(0))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(dblarr_mh_new),2)
            dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
            dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
            b_diff_only = 1
            dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          endelse
        end else if i eq 59 then begin
          dblarr_yfit = 0
          if not b_dwarfs_only then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_elogg_rave
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DZwitter!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DZwitter!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
    ;        if b_giants_only then begin
    ;          dblarr_yrange_hist = [0.,21.]
    ;        endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-RAVE_vs_MH-ext-giants-from-FeH-Zwitter'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
              besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_giants), int_col_mh_rave)),$
                                    O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                                    I_INT_VERSION = 1
    ;                                I_B_MINE                          = 1,$
      ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
      ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
    ;                                I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_giants), int_col_logg_rave))
    ;        strarr_data(indarr, int_col_rave) = output
    ;        dblarr_x = o_dblarr_mh
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(o_dblarr_mh),2)
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            print,'dblarr_x = ',dblarr_x
            print,'dblarr_y = ',dblarr_y
    ;        if b_giants_only then $
    ;          stop
            b_diff_only = 0
            dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          endif else begin
            dblarr_yfit = 0
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_elogg_rave
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2.5, 0.5]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
            if b_dwarfs_only then begin
              dblarr_xrange = [-2.,0.5]
            endif
    ;        if b_giants_only then $
    ;          dblarr_yrange_hist = [0.,21.]
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-RAVE_vs_MH-ext-calib-stn'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            b_diff_only = 0
            dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          endelse
        end else if i eq 60 then begin
          dblarr_yfit = 0
          if not b_dwarfs_only then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_elogg_rave
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRitter!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRitter!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-1.,1.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
  ;          if b_giants_only then begin
  ;            dblarr_yrange_hist = [0.,21.]
  ;          endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext_vs_MH-RAVE-giants-from-FeH-mine'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
              besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_giants), int_col_mh_rave)),$
                                    O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                                    I_INT_VERSION                     = 2,$
      ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
      ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
                                    I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_giants), int_col_logg_rave))
    ;        strarr_data(indarr, int_col_rave) = output
    ;        dblarr_x = o_dblarr_mh
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(o_dblarr_mh),2)
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            b_diff_only = 0
            dblarr_vertical_lines = 0
            dblarr_temp = svdfit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit)
          endif
        end
        if b_dwarfs_only then begin
          str_plotname_root = str_plotname_root + '_dwarfs'
        end else if b_giants_only then begin
          str_plotname_root = str_plotname_root + '_giants'
        end
        if int_smooth_mean_sig gt 0 then $
          str_plotname_root = str_plotname_root + '_' + strtrim(string(long(int_smooth_mean_sig)),2) + 'smoothings'
  ;      if not(b_dwarfs_only and (i ge 22)) then begin
        if iii eq 1 then begin
          str_plotname_root = str_plotname_root + '_' + strtrim(string(iii),2)
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
                                I_DBLARR_LINES_IN_DIFF_PLOT        = dblarr_lines_in_diff_plot
  ;    if i eq 9 then stop
        reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'
        reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
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

        indarr_good = where(abs(o_dblarr_diff_mean_sigma(*,3) ge int_sigma_minelements) gt 0.01)
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

        if (i_do_stn_calib gt 0) and (b_dwarfs_only or b_giants_only) then begin
          if i_do_stn_calib eq 10 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_Teff-calib_vs_mH-calib_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 11 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_vs_mH-calib_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 12 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_Teff-calib_calib-mH_vs_logg-calib_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 13 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 14 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_MH-calib_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 15 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_MH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 16 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 17 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_calib-Teff_vs_logg-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 18 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_vs_mH-calib_calib-Teff_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 19 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_calib-mH_vs_Teff-calib_calib-mH_calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 20 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_aFe-calib_calib-mH-calib-Teff_vs_logg-calib_calib-mH_calib-Teff_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 21 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_mH-calib_calib-Teff-calib-logg_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 22 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_Teff-calib_calib-mH-calib-logg_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          end else if i_do_stn_calib eq 23 then begin
            str_calib = '/home/azuri/daten/rave/rave_data/release8/calib_logg-calib_calib-mH-calib-Teff_vs_afe-calib_calib-mH_calib-Teff-calib-logg_'+strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins'
          endif
          if b_dwarfs_only then begin
            str_calib = str_calib + '_dwarfs'
          endif
          if b_giants_only then begin
            str_calib = str_calib + '_giants'
          endif
          if iii eq 1 then begin
            str_calib = str_calib + '_' + strtrim(string(iii),2)
          endif
            str_calib = str_calib + '.dat'
          openw,lun_cal,str_calib,/GET_LUN
          if i_do_stn_calib eq 10 then begin
            printf,lun_cal,'#MH_RAVE mean(Teff_ext-Teff_RAVE)'
          end else if i_do_stn_calib eq 11 then begin
            printf,lun_cal,'#MH_RAVE mean(logg_ext-logg_RAVE)'
          end else if i_do_stn_calib eq 12 then begin
            printf,lun_cal,'#logg_RAVE mean(Teff_ext-Teff_RAVE)'
          end else if i_do_stn_calib eq 13 then begin
            printf,lun_cal,'#Teff_RAVE mean(logg_ext-logg_RAVE)'
          end else if i_do_stn_calib eq 14 then begin
            printf,lun_cal,'#Teff_RAVE mean(MH_ext-MH_RAVE)'
          end else if i_do_stn_calib eq 15 then begin
            printf,lun_cal,'#logg_RAVE mean(MH_ext-MH_RAVE)'
          end else if i_do_stn_calib eq 16 then begin
            printf,lun_cal,'#Teff_RAVE mean(MH_ext-mH_RAVE)'
          end else if i_do_stn_calib eq 17 then begin
            printf,lun_cal,'#logg_RAVE mean(MH_ext-mH_RAVE)'
          end else if i_do_stn_calib eq 18 then begin
            printf,lun_cal,'#mH_RAVE mean(aFe_ext-aFe_RAVE)'
          end else if i_do_stn_calib eq 19 then begin
            printf,lun_cal,'#Teff_RAVE mean(aFe_ext-aFe_RAVE)'
          end else if i_do_stn_calib eq 20 then begin
            printf,lun_cal,'#logg_RAVE mean(aFe_ext-aFe_RAVE)'
          end else if i_do_stn_calib eq 21 then begin
            printf,lun_cal,'#aFe_RAVE mean(MH_ext-mH_RAVE)'
          end else if i_do_stn_calib eq 22 then begin
            printf,lun_cal,'#aFe_RAVE mean(Teff_ext-Teff_RAVE)'
          end else if i_do_stn_calib eq 23 then begin
            printf,lun_cal,'#aFe_RAVE mean(logg_ext-logg_RAVE)'
          endif
          j_min = -1
          j_max = -1
          b_first_good = 1
          for j=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
            if o_dblarr_diff_mean_sigma(j,3) ge int_sigma_minelements then begin
              if b_first_good and (i_do_stn_calib lt 5) then begin
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
          free_lun,lun_cal

          if i_do_stn_calib eq 10 then begin
              dblarr_teff = dblarr_teff_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                 I_DBLARR_X                 = dblarr_mh_calib(indarr_calib)
              dblarr_teff_calib(indarr_calib) = dblarr_teff

              ; --- all rave stars
              dblarr_teff = dblarr_rave_teff(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                 I_DBLARR_X                 = dblarr_rave_mh(indarr_logg_all)
              dblarr_rave_teff(indarr_logg_all) = dblarr_teff
          end else if i_do_stn_calib eq 11 then begin
              dblarr_logg = dblarr_logg_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_mh_calib(indarr_calib)
              dblarr_logg_calib(indarr_calib) = dblarr_logg

              ; --- all rave stars
              dblarr_logg = dblarr_rave_logg(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                 I_DBLARR_X                 = dblarr_rave_mh(indarr_logg_all)
              dblarr_rave_logg(indarr_logg_all) = dblarr_logg
          end else if i_do_stn_calib eq 12 then begin
              dblarr_teff = dblarr_teff_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                I_DBLARR_X                 = dblarr_logg_calib(indarr_calib)
              dblarr_teff_calib(indarr_calib) = dblarr_teff

              ; --- all rave stars
              dblarr_teff = dblarr_rave_teff(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                 I_DBLARR_X                 = dblarr_rave_logg(indarr_logg_all)
              dblarr_rave_teff(indarr_logg_all) = dblarr_teff
          end else if i_do_stn_calib eq 13 then begin
              dblarr_logg = dblarr_logg_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_teff_calib(indarr_calib)
              dblarr_logg_calib(indarr_calib) = dblarr_logg

              ; --- all rave stars
              dblarr_logg = dblarr_rave_logg(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                 I_DBLARR_X                 = dblarr_rave_teff(indarr_logg_all)
              dblarr_rave_logg(indarr_logg_all) = dblarr_logg
          end else if i_do_stn_calib eq 14 then begin
              dblarr_mh = dblarr_cmh_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_teff_calib(indarr_calib)
              dblarr_cmh_calib(indarr_calib) = dblarr_mh

              ; --- all rave stars
              dblarr_mh = dblarr_rave_mh_calibrated(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                 I_DBLARR_X                 = dblarr_rave_teff(indarr_logg_all)
              dblarr_rave_mh_calibrated(indarr_logg_all) = dblarr_mh
          end else if i_do_stn_calib eq 15 then begin
              dblarr_mh = dblarr_cmh_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_logg_calib(indarr_calib)
              dblarr_cmh_calib(indarr_calib) = dblarr_mh

              ; --- all rave stars
              dblarr_mh = dblarr_rave_mh_calibrated(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                 I_DBLARR_X                 = dblarr_rave_logg(indarr_logg_all)
              dblarr_rave_mh_calibrated(indarr_logg_all) = dblarr_mh
          end else if i_do_stn_calib eq 16 then begin
              dblarr_mh = dblarr_mh_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_teff_calib(indarr_calib)
              dblarr_mh_calib(indarr_calib) = dblarr_mh

              ; --- all rave stars
              dblarr_mh = dblarr_rave_mh(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                 I_DBLARR_X                 = dblarr_rave_teff(indarr_logg_all)
              dblarr_rave_mh(indarr_logg_all) = dblarr_mh
          end else if i_do_stn_calib eq 17 then begin
              dblarr_mh = dblarr_mh_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_logg_calib(indarr_calib)
              dblarr_mh_calib(indarr_calib) = dblarr_mh

              ; --- all rave stars
              dblarr_mh = dblarr_rave_mh(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                 I_DBLARR_X                 = dblarr_rave_logg(indarr_logg_all)
              dblarr_rave_mh(indarr_logg_all) = dblarr_mh
          end else if i_do_stn_calib eq 18 then begin
              dblarr_afe = dblarr_afe_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_mh_calib(indarr_calib)
              dblarr_afe_calib(indarr_calib) = dblarr_afe

              ; --- all rave stars
              dblarr_afe = dblarr_rave_afe(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                 I_DBLARR_X                 = dblarr_rave_mh(indarr_logg_all)
              dblarr_rave_afe(indarr_logg_all) = dblarr_afe
          end else if i_do_stn_calib eq 19 then begin
              dblarr_afe = dblarr_afe_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_Teff_calib(indarr_calib)
              dblarr_afe_calib(indarr_calib) = dblarr_afe

              ; --- all rave stars
              dblarr_afe = dblarr_rave_afe(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                 I_DBLARR_X                 = dblarr_rave_teff(indarr_logg_all)
              dblarr_rave_afe(indarr_logg_all) = dblarr_afe
          end else if i_do_stn_calib eq 20 then begin
              dblarr_afe = dblarr_afe_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                I_DBLARR_X                 = dblarr_logg_calib(indarr_calib)
              dblarr_afe_calib(indarr_calib) = dblarr_afe

              ; --- all rave stars
              dblarr_afe = dblarr_rave_afe(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_afe,$
                                                                 I_DBLARR_X                 = dblarr_rave_logg(indarr_logg_all)
              dblarr_rave_afe(indarr_logg_all) = dblarr_afe
          end else if i_do_stn_calib eq 21 then begin
              dblarr_mh = dblarr_mh_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                I_DBLARR_X                 = dblarr_afe_calib(indarr_calib)
              dblarr_mh_calib(indarr_calib) = dblarr_mh

              ; --- all rave stars
              dblarr_mh = dblarr_rave_mh(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                                                 I_DBLARR_X                 = dblarr_rave_afe(indarr_logg_all)
              dblarr_rave_mh(indarr_logg_all) = dblarr_mh
          end else if i_do_stn_calib eq 22 then begin
              dblarr_teff = dblarr_teff_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                I_DBLARR_X                 = dblarr_afe_calib(indarr_calib)
              dblarr_teff_calib(indarr_calib) = dblarr_teff

              ; --- all rave stars
              dblarr_teff = dblarr_rave_teff(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                                                 I_DBLARR_X                 = dblarr_rave_afe(indarr_logg_all)
              dblarr_rave_teff(indarr_logg_all) = dblarr_teff
          end else if i_do_stn_calib eq 23 then begin
              dblarr_logg = dblarr_logg_calib(indarr_calib)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                I_DBLARR_X                 = dblarr_afe_calib(indarr_calib)
              dblarr_logg_calib(indarr_calib) = dblarr_logg

              ; --- all rave stars
              dblarr_logg = dblarr_rave_logg(indarr_logg_all)
              rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                                 IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                                                 I_DBLARR_X                 = dblarr_rave_afe(indarr_logg_all)
              dblarr_rave_logg(indarr_logg_all) = dblarr_logg
          endif
        endif
      endfor
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
