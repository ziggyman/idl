pro rave_compare_to_ref, dblarr_x,$
                         dblarr_y
  ; --- compare (calibrated) rave values to external reference values

  compare_two_parameters,dblarr_x,$
                           dblarr_y,$
                           str_plotname_root,$
                           DBLARR_ERR_X             = dblarr_err_x,$
                           DBLARR_ERR_Y             = dblarr_err_y,$
                           DBLARR_RAVE_SNR          = dblarr_rave_snr,$
                           STR_XTITLE               = str_xtitle,$
                           STR_YTITLE               = str_ytitle,$
                           STR_TITLE                = str_title,$
                           I_PSYM                   = i_psym,$
                           DBL_SYMSIZE              = dbl_symsize,$
                           DBL_CHARSIZE             = dbl_charsize,$
                           DBL_CHARTHICK            = dbl_charthick,$
                           DBL_THICK                = dbl_thick,$
                           DBLARR_XRANGE            = dblarr_xrange,$
                           DBLARR_YRANGE            = dblarr_yrange,$
                           DBLARR_POSITION          = dblarr_position,$
                           DIFF_DBLARR_YRANGE       = diff_dblarr_yrange,$
                           DIFF_DBLARR_POSITION     = diff_dblarr_position,$
                           DIFF_STR_YTITLE          = diff_str_ytitle,$
                           I_B_DIFF_PLOT_Y_MINUS_X  = i_b_diff_plot_y_minus_x,$
                           I_XTICKS                 = i_xticks,$
                           STR_XTICKFORMAT          = str_xtickformat,$
                           I_YTICKS                 = i_yticks,$
                           DBL_REJECTVALUEX         = dbl_rejectvaluex,$;             --- double
                           DBL_REJECTVALUE_X_RANGE  = dbl_rejectvalue_x_range,$;             --- double
                           DBL_REJECTVALUEY         = dbl_rejectvaluey,$;             --- double
                           DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                           STR_YTICKFORMAT          = str_ytickformat,$
                           B_PRINTPDF               = b_printpdf,$;               --- bool (0/1)
                           SIGMA_I_NBINS            = sigma_i_nbins,$
                           SIGMA_I_MINELEMENTS      = sigma_i_minelements,$
                           I_INT_MEANSIG_SERIES     = i_int_meansig_series,$
                           I_DBL_SIGMA_CLIP         = i_dbl_sigma_clip,$
                           I_B_USE_WEIGHTED_MEAN    = i_b_use_weighted_mean,$
                           O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$ ; --- dblarr(sigma_i_nbins, 4): x, mean, sigma, nstars
                           I_INT_SMOOTH_MEAN_SIG    = i_int_smooth_mean_sig,$
                           HIST_I_NBINS_SET         = hist_i_nbins_set,$;            --- int
                           HIST_I_NBINSMIN          = hist_i_nbinsmin,$;            --- int
                           HIST_I_NBINSMAX          = hist_i_nbinsmax,$;            --- int
                           HIST_STR_XTITLE          = hist_str_xtitle,$;            --- string
                           HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
                           HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                           HIST_B_PERCENTAGE        = hist_b_percentage,$;          --- bool (0/1)
                           HIST_B_POP_ID            = hist_b_popid,$;             --- bool
                           HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                           HIST_DBLARR_XRANGE       = hist_dblarr_xrange,$
                           HIST_DBLARR_YRANGE       = hist_dblarr_yrange,$
                           HIST_DBLARR_POSITION     = hist_dblarr_position,$;   --- dblarr
                           HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                           O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                           DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                           DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
                           DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                           I_DBLARR_YFIT                      = i_dblarr_yfit,$
                           B_PRINT_MOMENTS                    = b_print_moments,$
                           I_DO_SIGMA_CLIPPING                = i_do_sigma_clipping,$
                           O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                           IO_INDARR_CLIPPED                  = io_indarr_clipped,$
                           I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                           I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                           I_B_Y_VS_X_ONLY                    = i_b_y_vs_x_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                           B_DIFF_ONLY                        = b_diff_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                           I_DBLARR_LINES_IN_PLOT        = i_dblarr_lines_in_plot,$
                           I_DBLARR_LINES_IN_DIFF_PLOT        = i_dblarr_lines_in_diff_plot,$
                           I_INTARR_SYMBOLS                   = i_intarr_symbols,$
                           I_B_FIT_MEAN                  = i_b_fit_mean,$
                           O_DBLARR_COEFFS_FIT_MEAN      = o_dblarr_coeffs_fit_mean,$
                           I_B_DONT_PLOT_GUIDE_LINE           = i_b_dont_plot_guide_line,$
                           I_B_QUADRATIC                      = i_b_quadratic,$
                           I_B_DONT_PLOT_COLOUR_BAR           = i_b_dont_plot_colour_bar

end
