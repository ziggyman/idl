pro rave_compare_to_soubiran
  str_file_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_found_soubiran2005.dat'
  str_file_soubiran = '/home/azuri/daten/rave/soubiran2005/soubiran2005_found_rave_internal_dr8_all_no_doubles_maxsnr.dat'

  b_calc_errors = 1

  int_col_rave_teff = 19
  int_col_rave_logg = 20
  int_col_rave_mh = 21
  int_col_rave_afe = 22
  int_col_rave_stn = 35
  int_col_rave_s2n = 34
  int_col_rave_snr = 33

  int_col_soubiran_teff = 27
  int_col_soubiran_logg = 28
  int_col_soubiran_feh = 6

  if b_calc_errors then begin
    dbl_teff_divide_error_by = 1.
    dbl_logg_divide_error_by = 1.
    dbl_mh_divide_error_by = 1.
  endif

  strarr_rave = readfiletostrarr(str_file_rave,' ')
  strarr_soubiran = readfiletostrarr(str_file_soubiran,';')

  ; --- check for consistency
  if n_elements(strarr_rave(*,0)) ne n_elements(strarr_soubiran(*,0)) then begin
    print,'rave_compare_to_soubiran: ERROR: different number of stars in both catalogues'
    stop
  endif

  ; --- populate dblarrs
  dblarr_rave = dblarr(n_elements(strarr_rave(*,0)),8)
  dblarr_rave(*,0) = double(strarr_rave(*,int_col_rave_teff))
  dblarr_rave(*,1) = double(strarr_rave(*,int_col_rave_logg))
  dblarr_rave(*,2) = double(strarr_rave(*,int_col_rave_mh))
  dblarr_rave(*,3) = double(strarr_rave(*,int_col_rave_stn))
  dblarr_rave(*,4) = double(strarr_rave(*,int_col_rave_afe))
  indarr = where(dblarr_rave(*,3) lt 0.)
  if indarr(0) ge 0 then begin
    dblarr_rave(indarr,3) = double(strarr_rave(indarr,int_col_rave_s2n))
  endif
  indarr = where(dblarr_rave(*,3) lt 0.)
  if indarr(0) ge 0 then begin
    dblarr_rave(indarr,3) = double(strarr_rave(indarr,int_col_rave_snr))
  endif
  int_col_rave_teff = 0
  int_col_rave_eteff = 5
  int_col_rave_logg = 1
  int_col_rave_elogg = 6
  int_col_rave_mh = 2
  int_col_rave_emh = 7
  int_col_rave_stn = 3
  int_col_rave_afe = 4
  strarr_rave = 0

  dblarr_soubiran = dblarr(n_elements(strarr_soubiran(*,0)),4)
  dblarr_soubiran(*,0) = double(strarr_soubiran(*,int_col_soubiran_teff))
  dblarr_soubiran(*,1) = double(strarr_soubiran(*,int_col_soubiran_logg))
  dblarr_soubiran(*,2) = double(strarr_soubiran(*,int_col_soubiran_feh))
  int_col_soubiran_teff = 0
  int_col_soubiran_logg = 1
  int_col_soubiran_mh = 2
  int_col_soubiran_feh = 2
  int_col_soubiran_eteff = 3
  int_col_soubiran_elogg = 3
  int_col_soubiran_emh = 3
  int_col_soubiran_efeh = 3
  strarr_soubiran = 0

  indarr_no_soubiran_feh = where(abs(dblarr_soubiran(*,int_col_soubiran_feh)) lt 0.000000001)
  ; --- calculate [M/H] from [Fe/H] using my trafo
  besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_soubiran(*,2),$
                        O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                        I_B_MINE                          = 1,$
                        I_DBLARR_LOGG                     = dblarr_soubiran(*,1)
  dblarr_soubiran(*,int_col_soubiran_mh) = o_dblarr_mh
  dblarr_soubiran(indarr_no_soubiran_feh,int_col_soubiran_mh) = 99.

  ; --- modify colour table
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    blue(l) = 0
    green(l) = l
    red(l) = 255 - l
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 255 then green(l) = 255
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 255 then blue(l) = 255
  endfor
  green(0) = 0
  red(0) = 0
  ltab = 0
  modifyct,ltab,'green-red',red,green,blue,file='colors1_soubiran.tbl'

  ; --- calculate RAVE errors
  if b_calc_errors then begin
    for pp = 0, 2 do begin
      if pp eq 0 then begin; --- Teff
        dbl_divide_error_by = dbl_teff_divide_error_by
        b_teff = 1
        b_logg = 0
        b_mh = 0
        dbl_reject = 0.00001
      end else if pp eq 1 then begin; --- logg
        dbl_divide_error_by = dbl_logg_divide_error_by
        b_teff = 0
        b_logg = 1
        b_mh = 0
        dbl_reject = 99.9
      end else begin; --- [M/H]
        dbl_divide_error_by = dbl_mh_divide_error_by
        b_teff = 0
        b_logg = 0
        b_mh = 1
        dbl_reject = 99.9
      end
      o_dblarr_data = 1

      o_dblarr_err = 1
      rave_besancon_calc_errors,B_TEFF = b_teff,$
                                B_LOGG = b_logg,$
                                B_MH = b_mh,$
                                O_DBLARR_DATA  = o_dblarr_data,$;        --- vector(n)
                                O_DBLARR_ERR = o_dblarr_err,$;       --- vector(n)
                                DBLARR_SNR = dblarr_rave(*,int_col_rave_stn),$; --- I: vector(n)
                                DBLARR_TEFF  = dblarr_rave(*,int_col_rave_teff),$;        --- vector(n)
                                DBLARR_MH    = dblarr_rave(*,int_col_rave_mh),$;          --- vector(n)
                                DBLARR_LOGG  = dblarr_rave(*,int_col_rave_logg),$;        --- vector(n)
                                DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$
                                DBL_REJECT = dbl_reject,$
                                B_REAL_ERR = 1

      if pp eq 0 then begin; --- Teff
        dblarr_rave(*,int_col_rave_eteff) = abs(o_dblarr_err)
      end else if pp eq 1 then begin; --- logg
        dblarr_rave(*,int_col_rave_elogg) = abs(o_dblarr_err)
      end else begin; --- [M/H]
        dblarr_rave(*,int_col_rave_emh) = abs(o_dblarr_err)
      end
    endfor
    o_dblarr_err = 0
    o_dblarr_data = 0
  endif

  str_path = strmid(str_file_soubiran,0,strpos(str_file_soubiran,'/',/REVERSE_SEARCH)+1)+'comparison_to_rave/'
  spawn,'mkdir '+str_path
  ; --- compare
  for i=0ul, 2 do begin
    if i eq 0 then begin
      str_filename_plot_root = str_path + 'Teff'
      int_col_rave = int_col_rave_teff
      int_col_erave = int_col_rave_eteff
      int_col_soubiran = int_col_soubiran_teff
      int_col_esoubiran = int_col_soubiran_eteff
      str_xtitle = 'T!Deff, ref!N [K]'
      str_ytitle = 'T!Deff, RAVE!N [K]'
      str_ytitle_diff = '(T!Deff, RAVE!N - T!Deff, ref!N) [K]'
      dblarr_xrange = [4000.,7200.]
      dblarr_yrange = [4000.,7000.]
;      if b_chemical then begin
;        dblarr_xrange = [3000.,7200.]
;        dblarr_yrange = [3000.,7000.]
;      endif
      diff_dblarr_yrange = [-2000.,2000.]
      dblarr_position = [0.205,0.175,0.932,0.995]
      dblarr_position_diff=[0.205,0.175,0.932,0.995]
      dblarr_position_hist=[0.205,0.175,0.932,0.995]
      i_xticks = 5
      str_xtickformat = '(I6)'
      str_ytickformat = '(I6)'
      indarr_soubiran = where(abs(dblarr_soubiran(*,int_col_soubiran_teff)) gt 0.1)
      print,'rave_compare_to_soubiran: Soubiran: ',n_elements(indarr_soubiran),' stars with T_eff'
      indarr_rave = where(abs(dblarr_rave(indarr_soubiran,int_col_rave_teff)) gt 0.1)
      print,'rave_compare_to_soubiran: RAVE: ',n_elements(indarr_rave),' stars with T_eff'
      str_dim = 'K'
      dbl_rejectvalue_rave      = 0.0001
      dbl_rejectvalue_range_rave = 10.
      dbl_rejectvalue_soubiran  = 0.00000001
      dbl_rejectvalue_range_soubiran = 0.0000001
      b_print_moments = 0
      i_dbl_reject_diff_stars_below = -700.
    end else if i eq 1 then begin
      str_filename_plot_root = str_path + 'logg'
      int_col_rave = int_col_rave_logg
      int_col_erave = int_col_rave_elogg
      int_col_soubiran = int_col_soubiran_logg
      int_col_esoubiran = int_col_soubiran_elogg
      str_xtitle = '(log g)!Dref!N [dex]'
      str_ytitle = '(log g)!DRAVE!N [dex]'
      str_ytitle_diff = '((log g)!DRAVE!N - (log g)!Dref!N) [dex]'
      dblarr_xrange=[0.,5.65]
      dblarr_yrange=[0.,5.5]
      diff_dblarr_yrange = [-2.5,2.5]
      i_xticks = 0
      str_xtickformat = '(I6)'
      str_ytickformat = '(I6)'
      str_dim = 'dex'
      dbl_rejectvalue_rave      = 99.9
      dbl_rejectvalue_range_rave = 10.
      dbl_rejectvalue_soubiran      = 0.00000001
      dbl_rejectvalue_range_soubiran = 0.0000001
      dblarr_position = [0.205,0.175,0.932,0.995]
      dblarr_position_diff=[0.205,0.175,0.932,0.995]
      dblarr_position_hist=[0.205,0.175,0.932,0.995]
      indarr_soubiran = where(abs(dblarr_soubiran(*,int_col_soubiran_logg)) gt 0.0000001)
      print,'rave_compare_to_soubiran: Soubiran: ',n_elements(indarr_soubiran),' stars with logg'
      indarr_rave = where(abs(dblarr_rave(indarr_soubiran,int_col_rave_logg)) lt 20.)
      print,'rave_compare_to_soubiran: RAVE: ',n_elements(indarr_rave),' stars with log g'
      b_print_moments = 0
      i_dbl_reject_diff_stars_below = -1.
    end else if i eq 2 then begin
      str_filename_plot_root = str_path + 'MH'
      ; --- calibrate metallicities with new calibration
      rave_calibrate_metallicities,dblarr_rave(*,int_col_rave_mh),$
                                   dblarr_rave(*,int_col_rave_afe),$
                                   DBLARR_TEFF=dblarr_rave(*,int_col_rave_teff),$; --- new calibration
                                   DBLARR_LOGG=dblarr_rave(*,int_col_rave_logg),$; --- old calibration
                                   DBLARR_STN=dblarr_rave(*,int_col_rave_stn),$; --- old calibration
                                   REJECTVALUE=99.9,$
                                   REJECTERR=1.,$
                                   OUTPUT=output,$
                                   SEPARATE=1
      dblarr_rave(*,int_col_rave_mh) = output
      int_col_rave = int_col_rave_mh
      int_col_erave = int_col_rave_emh
      int_col_soubiran = int_col_soubiran_mh
      int_col_esoubiran = int_col_soubiran_emh
      str_xtitle = '[M/H]!Dref!N [dex]'
      str_ytitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle_diff = '([M/H]!DRAVE!N - [M/H]!Dref!N) [dex]'
      dblarr_xrange=[-1.5,0.56]
      dblarr_yrange=[-3.,1.0]
      diff_dblarr_yrange = [-1.5,1.5]
      str_dim = 'dex'
      i_xticks = 0
      str_xtickformat = '(F4.1)'
      str_ytickformat = '(F4.1)'
      dbl_rejectvalue_rave      = 99.9
      dbl_rejectvalue_range_rave = 10.
      dbl_rejectvalue_soubiran      = 99.
      dbl_rejectvalue_range_soubiran = 10.
      dblarr_position = [0.205,0.175,0.932,0.995]
      dblarr_position_diff=[0.205,0.175,0.932,0.995]
      dblarr_position_hist=[0.205,0.175,0.932,0.995]
      indarr_soubiran = where(abs(dblarr_soubiran(*,int_col_soubiran_mh)) lt 20.)
      print,'rave_compare_to_soubiran: Soubiran: ',n_elements(indarr_soubiran),' stars with [M/H]'
      indarr_rave = where(abs(dblarr_rave(indarr_soubiran,int_col_rave_mh)) lt 20.)
      print,'rave_compare_to_soubiran: RAVE: ',n_elements(indarr_rave),' stars with [M/H]'
      b_print_moments = 1
      i_dbl_reject_diff_stars_below = 0
    end
    compare_two_parameters,dblarr_soubiran(indarr_soubiran(indarr_rave),int_col_soubiran),$
                           dblarr_rave(indarr_soubiran(indarr_rave),int_col_rave),$
                           str_filename_plot_root,$
                           DBLARR_ERR_X             = dblarr_soubiran(indarr_soubiran(indarr_rave), int_col_esoubiran),$
                           DBLARR_ERR_Y             = dblarr_rave(indarr_soubiran(indarr_rave), int_col_erave),$
                           DBLARR_RAVE_SNR          = dblarr_rave(indarr_soubiran(indarr_rave), int_col_rave_stn),$
                           STR_XTITLE               = str_xtitle,$
                           STR_YTITLE               = str_ytitle,$
                           STR_TITLE                = str_title,$
                           I_PSYM                   = 7,$
                           DBL_SYMSIZE              = 1.5,$
                           DBL_CHARSIZE             = 1.8,$
                           DBL_CHARTHICK            = 3.,$
                           DBL_THICK                = 4.,$
                           DBLARR_XRANGE            = dblarr_xrange,$
                           DBLARR_YRANGE            = dblarr_yrange,$
                           DBLARR_POSITION          = dblarr_position,$
                           DIFF_DBLARR_YRANGE       = diff_dblarr_yrange,$
                           DIFF_DBLARR_POSITION     = dblarr_position_diff,$
                           DIFF_STR_YTITLE          = str_ytitle_diff,$
;                           I_XTICKS                 = i_xticks,$
                           STR_XTICKFORMAT          = str_xtickformat,$
;                           I_YTICKS                 = i_yticks,$
                           DBL_REJECTVALUEX         = dbl_rejectvalue_soubiran,$;             --- double
                           DBL_REJECTVALUE_X_RANGE  = dbl_rejectvalue_range_soubiran,$;             --- double
                           DBL_REJECTVALUEY         = dbl_rejectvalue_rave,$;             --- double
                           DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_range_rave,$;             --- double
                           STR_YTICKFORMAT          = str_ytickformat,$
                           B_PRINTPDF               = 1,$;               --- bool (0/1)
                           SIGMA_I_NBINS            = 20,$
                           SIGMA_I_MINELEMENTS      = 2,$
                           HIST_I_NBINSMIN          = 20,$;            --- int
                           HIST_I_NBINSMAX          = 25,$;            --- int
                           HIST_STR_XTITLE          = strmid(str_xtitle,0,strpos(str_xtitle,'(')-1),$;            --- string
                           HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                           HIST_DBLARR_POSITION     = dblarr_position_hist,$;   --- dblarr
                           O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
;                           DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
;                           DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
;                           DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
;                           I_DBLARR_YFIT                      = i_dblarr_yfit,$
                           B_PRINT_MOMENTS          = b_print_moments,$
                           B_DO_SIGMA_CLIPPING      = 1,$
                           I_B_DIFF_PLOT_Y_MINUS_X  = 1,$
                           I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                           I_DBL_REJECT_DIFF_STARS_ABOVE      = 0.-i_dbl_reject_diff_stars_below
  endfor
end
