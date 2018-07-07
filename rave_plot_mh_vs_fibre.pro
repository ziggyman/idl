pro rave_plot_mh_vs_fibre
  str_filename_in = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ')
  dblarr_mh = double(strarr_data(*,23))
  ulonarr_fibre = ulong(strarr_data(*,18))
  ulonarr_fp = ulong(strarr_data(*,17))
  dblarr_stn = double(strarr_data(*,35))

  for i=0,3 do begin
    if i eq 0 then begin
      indarr_fp = lindgen(n_elements(ulonarr_fp))
    end else if i eq 1 then begin
      indarr_fp = where(ulonarr_fp eq 1)
    end else if i eq 2 then begin
      indarr_fp = where(ulonarr_fp eq 2)
    end else if i eq 3 then begin
      indarr_fp = where(ulonarr_fp eq 3)
    endif
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_cMH_vs_fibre_fp'+strtrim(string(i),2)
    print,'dblarr_mh(indarr_fp) = ',dblarr_mh(indarr_fp)
    print,'ulonarr_fibre(indarr_fp) = ',ulonarr_fibre(indarr_fp)
      compare_two_parameters,ulonarr_fibre(indarr_fp),$
                           dblarr_mh(indarr_fp),$
                           str_plotname_root,$
                           DBLARR_ERR_X             = dblarr_mh(indarr_fp) * 0.0000000000001,$
                           DBLARR_ERR_Y             = dblarr_mh(indarr_fp) * 0.0000000000001,$
                           DBLARR_RAVE_SNR          = dblarr_stn(indarr_fp),$
                           STR_XTITLE               = 'fibre number',$
                           STR_YTITLE               = 'calibrated [M/H] [dex]',$
                           ;STR_TITLE                = str_title,$
                           I_PSYM                   = 2,$
                           DBL_SYMSIZE              = 0.7,$
                           DBL_CHARSIZE             = 1.8,$
                           DBL_CHARTHICK            = 3.,$
                           DBL_THICK                = 3.,$
                           DBLARR_XRANGE            = [0,154],$
                           DBLARR_YRANGE            = [-2.,1.],$
                           DBLARR_POSITION          = [0.205,0.175,0.932,0.925],$
                           DIFF_DBLARR_YRANGE       = [0.205,0.175,0.932,0.925],$
                           DIFF_DBLARR_POSITION     = [0.205,0.175,0.932,0.925],$
                           ;DIFF_STR_YTITLE          = diff_str_ytitle,$
                           ;I_B_DIFF_PLOT_Y_MINUS_X  = i_b_diff_plot_y_minus_x,$
                           ;I_XTICKS                 = i_xticks,$
                           STR_XTICKFORMAT          = '(I4)',$
                           ;I_YTICKS                 = i_yticks,$
                           ;DBL_REJECTVALUEX         = dbl_rejectvaluex,$;             --- double
                           ;DBL_REJECTVALUE_X_RANGE  = dbl_rejectvalue_x_range,$;             --- double
                           ;DBL_REJECTVALUEY         = dbl_rejectvaluey,$;             --- double
                           ;DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                           STR_YTICKFORMAT          = 'str_ytickformat(F4.1)',$
                           B_PRINTPDF               = 1,$;               --- bool (0/1)
                           SIGMA_I_NBINS            = 154,$
                           SIGMA_I_MINELEMENTS      = 5,$
                           ;I_INT_MEANSIG_SERIES     = i_int_meansig_series,$
                           I_DBL_SIGMA_CLIP         = 3.,$
                           ;I_B_USE_WEIGHTED_MEAN    = i_b_use_weighted_mean,$
                           ;O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$ ; --- dblarr(sigma_i_nbins, 4): x, mean, sigma, nstars
                           ;I_INT_SMOOTH_MEAN_SIG    = i_int_smooth_mean_sig,$
                           ;HIST_I_NBINS_SET         = hist_i_nbins_set,$;            --- int
                           ;HIST_I_NBINSMIN          = hist_i_nbinsmin,$;            --- int
                           ;HIST_I_NBINSMAX          = hist_i_nbinsmax,$;            --- int
                           ;HIST_STR_XTITLE          = hist_str_xtitle,$;            --- string
                           ;HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
                           ;HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                           ;HIST_B_PERCENTAGE        = hist_b_percentage,$;          --- bool (0/1)
                           ;HIST_B_POP_ID            = hist_b_popid,$;             --- bool
                           ;HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                           ;HIST_DBLARR_XRANGE       = hist_dblarr_xrange,$
                           ;HIST_DBLARR_YRANGE       = hist_dblarr_yrange,$
                           ;HIST_DBLARR_POSITION     = hist_dblarr_position,$;   --- dblarr
                           ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                           ;O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                           ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                           ;DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
                           ;DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                           ;I_DBLARR_YFIT                      = i_dblarr_yfit,$
                           ;B_PRINT_MOMENTS                    = b_print_moments,$
                           ;I_DO_SIGMA_CLIPPING                = i_do_sigma_clipping,$
                           ;O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                           ;IO_INDARR_CLIPPED                  = io_indarr_clipped,$
                           ;I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                           ;I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                           I_B_Y_VS_X_ONLY                    = 1;,$; --- dblarr_y given as dblarr_x-<some_parameter>
                           ;B_DIFF_ONLY                        = b_diff_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                           ;I_DBLARR_LINES_IN_PLOT        = i_dblarr_lines_in_plot,$
                           ;I_DBLARR_LINES_IN_DIFF_PLOT        = i_dblarr_lines_in_diff_plot,$
                           ;I_INTARR_SYMBOLS                   = i_intarr_symbols,$
                           ;I_B_FIT_MEAN                  = i_b_fit_mean,$
                           ;O_DBLARR_COEFFS_FIT_MEAN      = o_dblarr_coeffs_fit_mean
  endfor

  ; --- clean up
  dblarr_mh = 0
  dblarr_stn = 0
  ulonarr_fibre = 0
  ulonarr_fp = 0
  indarr_fp = 0
  strarr_data = 0
end
