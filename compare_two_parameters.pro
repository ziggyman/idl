pro compare_two_parameters,dblarr_x,$
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


  if keyword_set(I_B_Y_VS_X_ONLY) then begin
    diff_dblarr_yrange = dblarr_yrange
    diff_str_ytitle = str_ytitle
    diff_dblarr_position = dblarr_position
  endif




; =====   TODO: plot only boxes with colour of mean of SNR in that box!!!!!!!!!!!!!!!!!!!!!!!!!!!



  if not(keyword_set(I_DBL_SIGMA_CLIP)) then $
    i_dbl_sigma_clip = 3.

  b_plot_guide_line = 1
  if keyword_set(I_B_DONT_PLOT_GUIDE_LINE) then begin
    b_plot_guide_line = 0
  endif

  if not keyword_set(STR_XTITLE) then $
    str_xtitle = 'x'
  if not keyword_set(STR_YTITLE) then $
    str_ytitle = 'y'
  if not keyword_set(STR_TITLE) then $
    str_title = ''
  if not keyword_set(I_PSYM) then $
    i_psym = 2
  if not keyword_set(DBL_SYMSIZE) then $
    dbl_symsize = 2
  if not keyword_set(DBL_CHARSIZE) then $
    dbl_charsize = 2
  if not keyword_set(DBL_CHARTHICK) then $
    dbl_charthick = 2
  if not keyword_set(DBL_THICK) then $
    dbl_thick = 2
  if keyword_set(DBLARR_XRANGE) then begin
    i_xstyle = 1
    if not keyword_set(HIST_DBLARR_XRANGE) then $
      hist_dblarr_xrange = dblarr_xrange
;  end else begin
;    dblarr_xrange = 0
;    i_xstyle = 0
  end
  if keyword_set(DBLARR_YRANGE) then begin
    i_ystyle = 1
;  end else begin
;    dblarr_yrange = 0
;    i_ystyle = 0
  end
;  if not keyword_set(DBLARR_POSITION) then $
;    dblarr_position = 0
  if keyword_set(DIFF_DBLARR_YRANGE) then begin
    i_ystyle_diff = 1
;  end else begin
;    diff_dblarr_yrange = 0
;    i_ystyle_diff = 0
  end
;  if not keyword_set(DIFF_DBLARR_POSITION) then $
;    diff_dblarr_position = 0
  if not keyword_set(DIFF_STR_YTITLE) then begin
    if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
      diff_str_ytitle = 'y-x'
    end else begin
      diff_str_ytitle = 'x-y'
    end
  endif
;  if not keyword_set(I_XTICKS) then $
;    i_xticks = 0
;  if not keyword_set(STR_XTICKFORMAT) then $
;    str_xtickformat = 0
;  if not keyword_set(I_YTICKS) then $
;    i_yticks = 0
;  if not keyword_set(STR_YTICKFORMAT) then $
;    str_ytickformat = 0
  if not keyword_set(SIGMA_I_NBINS) then $
    sigma_i_nbins = 30
  if not keyword_set(SIGMA_I_MINELEMENTS) then $
    sigma_i_minelements = 2
  if not keyword_set(HIST_I_NBINSMIN) then $
    hist_nbinsmin = 30
  if not keyword_set(HIST_I_NBINSMAX) then $
    hist_nbinsmax = 50
  if not keyword_set(HIST_STR_XTITLE) then $
    hist_str_xtitle = str_xtitle
  if not keyword_set(HIST_B_MAXNORM) then begin
    hist_b_maxnorm = 0
  end else begin
    hist_str_ytitle = 'Number of stars'
  end
  if not keyword_set(HIST_B_TOTALNORM) then begin
    hist_b_totalnorm = 0
  end else begin
    hist_str_ytitle = 'Number of stars'
  end
  if not keyword_set(HIST_B_PERCENTAGE) then begin
    hist_b_percentage = 0
    if (not keyword_set(HIST_B_TOTALNORM)) and (not keyword_set(HIST_B_MAXNORM)) then begin
      hist_b_percentage = 1
      hist_str_ytitle = 'Percentage of stars'
    end
  end else begin
    hist_str_ytitle = 'Percentage of stars'
  end
  if not keyword_set(DBL_REJECTVALUE_X_RANGE) then $
    dbl_rejectvalue_x_range = 0.01
  if keyword_set(DBL_REJECTVALUEX) then begin
    i_nelements_x = n_elements(dblarr_x)
    indarr = where(abs(dblarr_x - dbl_rejectvaluex) gt dbl_rejectvalue_x_range)
    dblarr_x = dblarr_x(indarr)
    dblarr_y = dblarr_y(indarr)
    print,'compare_two_parameters: ',i_nelements_x-n_elements(dblarr_x),' stars rejected'
    indarr = 0
  end else begin
    dbl_rejectvaluex = 999999999.
  end
  if not keyword_set(DBL_REJECTVALUE_Y_RANGE) then $
    dbl_rejectvalue_y_range = 0.01
  if keyword_set(DBL_REJECTVALUEY) then begin
    i_nelements_x = n_elements(dblarr_x)
    indarr = where(abs(dblarr_y - dbl_rejectvaluey) gt dbl_rejectvalue_y_range)
    dblarr_x = dblarr_x(indarr)
    dblarr_y = dblarr_y(indarr)
    print,'compare_two_parameters: ',i_nelements_x-n_elements(dblarr_x),' stars rejected'
    indarr = 0
  end else begin
    dbl_rejectvaluey = 999999999.
  end
  if not keyword_set(HIST_B_POP_ID) then $
    hist_b_pop_id = 0
  if not keyword_set(HIST_DBLARR_STAR_TYPES) then $
    hist_dblarr_star_types = 0
  if not keyword_set(B_PRINTPDF) then $
    b_printpdf = 0
  if not keyword_set(HIST_B_RESIDUAL) then $
    hist_b_residual = 0

  if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
    dblarr_y_plot = dblarr_y
  end else begin
    if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
      dblarr_y_plot = dblarr_y - dblarr_x
    end else begin
      dblarr_y_plot = dblarr_x - dblarr_y
    end
  endelse

  if keyword_set(DBLARR_RAVE_SNR) then begin
    if n_elements(dblarr_rave_snr) ne n_elements(dblarr_x) then begin
      print,'compare_two_parameters: ERROR: n_elements(dblarr_rave_snr)=',n_elements(dblarr_rave_snr),' ne n_elements(dblarr_x)=',n_elements(dblarr_x)
      stop
    endif else begin
      ;print,'compare_two_parameters: n_elements(dblarr_rave_snr)=',n_elements(dblarr_rave_snr),' eq n_elements(dblarr_x)=',n_elements(dblarr_x)
      ;stop
    endelse
  endif

  ; --- modify colour table
  str_file_colour = 'colors1_compare.tbl'
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
  modifyct,ltab,'green-red',red,green,blue,file=str_file_colour

;  int_nclipped = 0ul
;  indarr_clipped = lonarr(n_elements(dblarr_x))
  if not keyword_set(IO_INDARR_CLIPPED) then begin
    io_indarr_clipped = [-1.]
  endif

; --- reject stars above and below limits
  indarr_good = lindgen(n_elements(dblarr_x))
  if keyword_set(I_DBL_REJECT_DIFF_STARS_BELOW) then begin
    indarr_clip = where(dblarr_y_plot lt i_dbl_reject_diff_stars_below,COMPLEMENT=indarr_good_below)
    if indarr_clip(0) ge 0 then begin
      if io_indarr_clipped(0) lt 0 then begin
        io_indarr_clipped = indarr_clip
      end else begin
        io_indarr_clipped = [io_indarr_clipped,indarr_clip]
      endelse
      indarr_good = indarr_good_below
    endif
    print,'i_dbl_reject_diff_stars_below = ',i_dbl_reject_diff_stars_below
  endif
  if keyword_set(I_DBL_REJECT_DIFF_STARS_ABOVE) then begin
    indarr_clip = where(dblarr_y_plot(indarr_good) gt i_dbl_reject_diff_stars_above,COMPLEMENT=indarr_good_above)
    if indarr_clip(0) ge 0 then begin
      if io_indarr_clipped(0) lt 0 then begin
        io_indarr_clipped = indarr_good(indarr_clip)
      end else begin
        io_indarr_clipped = [io_indarr_clipped,indarr_good(indarr_clip)]
      endelse
      indarr_good = indarr_good(indarr_good_above)
    endif
    print,'i_dbl_reject_diff_stars_above = ',i_dbl_reject_diff_stars_above
  endif

  ; --- calculate mean and sigma for bins of x
  if not keyword_set(DBLARR_ERR_Y) then $
    dblarr_err_y = dblarr_y * 0.
  b_do_run = 1
;  o_indarr_clipped_old = [1]
  indarr_good_bak = indarr_good
  int_run = 1
  while b_do_run do begin
;    indarr_good = indarr_good_bak
    if IO_INDARR_CLIPPED(0) ge 0 then begin
      indarr_plot = lindgen(n_elements(dblarr_x))
      remove_subarr_from_array,indarr_plot,io_indarr_clipped
    end else begin
      indarr_plot = indarr_good_bak
    endelse
    b_temp = 0
    if keyword_set(b_diff_only) or keyword_set(I_B_Y_VS_X_ONLY) then $
      b_temp = 1
    o_indarr_clipped = [-1]
    get_mean_sig_running, I_INT_NBINS = sigma_i_nbins,$
                          I_DBLARR_DATA_X  = dblarr_x(indarr_plot),$
                          I_DBLARR_DATA_Y  = dblarr_y(indarr_plot),$
                          I_DBLARR_XRANGE  = dblarr_xrange,$
                          I_DBL_SIGMA_CLIP = i_dbl_sigma_clip,$
                          I_B_DIFF_ONLY = b_temp,$
                          I_DBLARR_ERR_Y = dblarr_err_y(indarr_plot),$
                          I_B_USE_WEIGHTED_MEAN = i_b_use_weighted_mean,$
                          I_INT_SIGMA_I_MINELEMENTS = sigma_i_minelements,$
                          O_DBLARR_X_BIN = dblarr_x_bin,$
                          O_DBLARR_LIMITS_X_BIN = dblarr_limits_x_bin,$
                          O_DBLARR_NELEMENTS_X_BIN = dblarr_x_bin_nelements,$
                          IO_INDARR_CLIPPED = o_indarr_clipped,$
                          O_DBLARR_MEAN = dblarr_mean,$
                          O_DBLARR_SIGMA = dblarr_sigma
    print,'dblarr_mean = ',dblarr_mean
    print,'dblarr_sigma = ',dblarr_sigma
    dblarr_mean_bak = dblarr_mean
    dblarr_sigma_bak = dblarr_sigma
    if keyword_set(I_INT_SMOOTH_MEAN_SIG) then begin
      i_smooth_run = 0
      while i_smooth_run lt i_int_smooth_mean_sig do begin
        if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
          dblarr_y_plot = dblarr_y
        end else begin
          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
            dblarr_y_plot = dblarr_y-dblarr_x
          end else begin
            dblarr_y_plot = dblarr_x-dblarr_y
          end
        endelse
        if io_indarr_clipped(0) ge 0 then begin
          indarr_plot = lindgen(n_elements(dblarr_x))
          remove_subarr_from_array,indarr_plot,io_indarr_clipped
        end else begin
          indarr_plot = indarr_good_bak
        endelse
        get_mean_smoothed,IO_DBLARR_MEAN           = dblarr_mean,$
                          IO_DBLARR_SIGMA          = dblarr_sigma,$
                          I_DBLARR_X               = dblarr_x(indarr_plot),$
                          I_DBLARR_Y               = dblarr_y_plot(indarr_plot),$
                          I_DBLARR_LIMITS_X_BINS   = dblarr_limits_x_bin,$
                          I_SIGMA_I_MINELEMENTS    = sigma_i_minelements,$
                          I_B_DO_CLIP              = i_do_sigma_clipping,$
                          I_DBL_SIGMA_CLIP         = i_dbl_sigma_clip,$
                          IO_INDARR_CLIPPED         = o_indarr_clipped
        if o_indarr_clipped(0) ge 0 then begin
          if io_indarr_clipped(0) ge 0 then begin
            remove_subarr_from_array,io_indarr_clipped,indarr_plot(o_indarr_clipped)
            io_indarr_clipped = [io_indarr_clipped,indarr_plot(o_indarr_clipped)]
          endif else begin
            io_indarr_clipped = indarr_plot(o_indarr_clipped)
          endelse
          b_do_run = 1
        end else begin
          b_do_run = 0
        endelse
        indarr_good = indarr_good_bak
        if io_indarr_clipped(0) ge 0 then $
          remove_subarr_from_array,indarr_good,io_indarr_clipped
        i_smooth_run += 1
;        print,'n_elements(dblarr_x) = ',n_elements(dblarr_x)
;        print,'n_elements(o_indarr_clipped) = ',n_elements(o_indarr_clipped)
;        print,'n_elements(io_indarr_clipped) = ',n_elements(io_indarr_clipped)
;        print,'n_elements(indarr_good) = ',n_elements(indarr_good)
        print,'compare_two_parameters: i_smooth_run = ',i_smooth_run,': io_indarr_clipped = ',io_indarr_clipped
      endwhile
;      stop
    endif
;    b_all_good = 1
;    int_run_ind = 0
;    if n_elements(o_indarr_clipped) ne n_elements(o_indarr_clipped_old) then $
;      b_all_good = 0
;    while b_all_good and (int_run_ind lt n_elements(o_indarr_clipped)) do begin
;      if o_indarr_clipped(int_run_ind) ne o_indarr_clipped_old(int_run_ind) then b_all_good = 0
;      int_run_ind = int_run_ind + 1
;    endwhile
;    o_indarr_clipped_old = o_indarr_clipped
;    if b_all_good then $
;      b_do_run = 0
    print,'compare_two_parameters: int_run = ',int_run,': io_indarr_clipped = ',io_indarr_clipped
    int_run = int_run + 1
    if int_run gt 10 then b_do_run = 0
  endwhile
;  stop
;  if keyword_set(I_DO_SIGMA_CLIPPING) then begin
;    if o_indarr_clipped(0) ge 0 then begin
;      indarr_clipped(int_nclipped:int_nclipped+n_elements(o_indarr_clipped)-1) = o_indarr_clipped
;      int_nclipped = int_nclipped + n_elements(o_indarr_clipped)
;    endif
;  endif
  o_dblarr_diff_mean_sigma = dblarr(sigma_i_nbins,4)
  o_dblarr_diff_mean_sigma(*,0) = dblarr_x_bin
  o_dblarr_diff_mean_sigma(*,1) = dblarr_mean
  o_dblarr_diff_mean_sigma(*,2) = dblarr_sigma
  o_dblarr_diff_mean_sigma(*,3) = dblarr_x_bin_nelements
  if keyword_set(I_B_FIT_MEAN) then begin
    indarr_fit = where(o_dblarr_diff_mean_sigma(*,3) ge sigma_i_minelements)
    o_dblarr_coeffs_fit_mean = svdfit(o_dblarr_diff_mean_sigma(indarr_fit,0),o_dblarr_diff_mean_sigma(indarr_fit,1),2)
  endif
;  if int_nclipped gt 0 then begin
;    indarr_clipped = indarr_clipped(0:int_nclipped-1)
;  end else begin
;    indarr_clipped = [-1]
;  endelse

;  if keyword_set(I_INT_SMOOTH_MEAN_SIG) then $
;    str_plotname_root  = str_plotname_root + strtrim(string(long(i_int_smooth_mean_sig)),2)
  if (not keyword_set(B_DIFF_ONLY)) and (not keyword_set(I_B_Y_VS_X_ONLY)) then begin
    str_plot = str_plotname_root+'.ps'
    set_plot,'ps'
    if keyword_set(I_B_QUADRATIC) then begin
      ;stop
      device,LANGUAGE_LEVEL=2,filename=str_plot,/color,/encapsulated,xsize=10,ysize=10
      dbl_charsize_temp = dbl_charsize * 0.8
    end else begin
      device,LANGUAGE_LEVEL=2,filename=str_plot,/color,/encapsulated,xsize=17.75,ysize=12.72
      dbl_charsize_temp = dbl_charsize
    endelse
      if keyword_set(DBLARR_ERR_X) and keyword_set(DBLARR_ERR_Y) and keyword_set(DBLARR_RAVE_SNR) then begin
        if keyword_set(I_INTARR_SYMBOLS) then begin
          if i_intarr_symbols(0) eq 0 then begin
            i_psym = 1
          end else if i_intarr_symbols(0) eq 1 then begin
            i_psym = 2
          end else if i_intarr_symbols(0) eq 2 then begin
            i_psym = 4
          end else if i_intarr_symbols(0) eq 3 then begin
            i_psym = 5
          end else if i_intarr_symbols(0) eq 4 then begin
            i_psym = 6
  ;        end else if i_intarr_symbols(0) eq 5 then begin
  ;          i_psym = 7
          end else begin
            i_psym = 7
          end
        endif
        if keyword_set(STR_TITLE) then begin
          if long(str_title) eq 1 then begin
            str_c = strtrim(string(correlate(dblarr_x,dblarr_y)),2)
            str_c = strmid(str_c,0,strpos(str_c,'.')+3)
            str_title_temp = 'correlation coefficient='+str_c
          end
        end else begin
          str_title = ''
        endelse
        plot,[dblarr_x(0),dblarr_x(0)],$
            [dblarr_y(0),dblarr_y(0)],$
            psym        = i_psym,$
            symsize     = dbl_symsize,$
            xtitle      = str_xtitle,$
            ytitle      = str_ytitle,$
            title = str_title_temp,$
            charsize    = dbl_charsize_temp,$
            thick       = dbl_thick,$
            charthick   = dbl_charthick,$
            xrange      = dblarr_xrange,$
            xstyle      = i_xstyle,$
            yrange      = dblarr_yrange,$
            ystyle      = i_ystyle,$
            xticks      = i_xticks,$
            xtickformat = str_xtickformat,$
            yticks      = i_yticks,$
            ytickformat = str_ytickformat,$
            position    = dblarr_position

        print,'compare_two_parameters: ltab = ',ltab
        print,'compare_two_parameters: str_file_colour = ',str_file_colour
        print,'compare_two_parameters: str_plotname_root = ',str_plotname_root
        loadct,ltab,FILE=str_file_colour
        for i=0ul,n_elements(dblarr_x)-1 do begin
          i_colour = long( 2.5 * dblarr_rave_snr(i))
          if i_colour lt 1 then i_colour = 1
          if i_colour gt 255 then i_colour = 255
          if keyword_set(I_INTARR_SYMBOLS) then begin
            if i_intarr_symbols(i) eq 0 then begin
              i_psym = 1
            end else if i_intarr_symbols(i) eq 1 then begin
              i_psym = 2
            end else if i_intarr_symbols(i) eq 2 then begin
              i_psym = 4
            end else if i_intarr_symbols(i) eq 3 then begin
              i_psym = 5
            end else if i_intarr_symbols(i) eq 4 then begin
              i_psym = 6
            end else begin
              i_psym = 7
            end
          endif
          ;print,'compare_two_parameters: i=',i,': i_psym = ',i_psym
          oplot,[dblarr_x(i),dblarr_x(i)],$
                [dblarr_y(i),dblarr_y(i)],$
                color=i_colour,$
                psym=i_psym,$
                symsize=dbl_symsize,$
                thick=dbl_thick
          ; --- plot error bars
          oplot,[dblarr_x(i)-dblarr_err_x(i),dblarr_x(i)+dblarr_err_x(i)],$
                [dblarr_y(i),dblarr_y(i)],$
                color=i_colour,$
                thick=1.5
          oplot,[dblarr_x(i),dblarr_x(i)],$
                [dblarr_y(i) - dblarr_err_y(i),dblarr_y(i) + dblarr_err_y(i)],$
                color=i_colour,$
                thick=1.5;i_dbl_thick
        endfor

        ; --- guide line
        if (not keyword_set(B_DIFF_ONLY)) and (not keyword_set(I_B_Y_VS_X_ONLY)) and (b_plot_guide_line) then $
          oplot,dblarr_yrange,dblarr_yrange,thick=3;,color=140

        ; --- vertical lines
        if keyword_set(DBLARR_VERTICAL_LINES_IN_PLOT) then begin
          for i=0, n_elements(dblarr_vertical_lines_in_plot)-1 do begin
            plot_vertical_lines,dblarr_vertical_lines_in_plot(i),dblarr_yrange
          endfor
        endif

        ; --- other lines
        if keyword_set(I_DBLARR_LINES_IN_PLOT) then begin
          for i=0, n_elements(i_dblarr_lines_in_plot(*,0))-1 do begin
            oplot,i_dblarr_lines_in_plot(i,0:1),$
                  i_dblarr_lines_in_plot(i,2:3),$
                  linestyle = 2,$
                  thick = 5
          endfor
  ;        print,'i_dblarr_lines_in_plot = ',i_dblarr_lines_in_plot
  ;        print,'str_plot = ',str_plot
  ;        stop
        endif

        ; --- plot fit
        if keyword_set(I_DBLARR_YFIT) then begin
          oplot,dblarr_x,i_dblarr_yfit,psym=1,symsize=0.3,color=70
        endif

        ; --- plot fit mean
  ;      if keyword_set(I_B_FIT_MEAN) then begin
  ;        oplot,[dblarr_xrange(0),dblarr_xrange(1),
  ;      endif

        ; --- plot colour bar
      end else begin
        ; --- no snr array given
        if keyword_set(I_INTARR_SYMBOLS) then begin
          if i_intarr_symbols(0) eq 0 then begin
            i_psym = 1
          end else if i_intarr_symbols(0) eq 1 then begin
            i_psym = 2
          end else if i_intarr_symbols(0) eq 2 then begin
            i_psym = 4
          end else if i_intarr_symbols(0) eq 3 then begin
            i_psym = 5
          end else if i_intarr_symbols(0) eq 4 then begin
            i_psym = 6
          end else begin
            i_psym = 7
          end
  ;        i_psym = i_intarr_symbols(0)+4
          ;print,'compare_two_parameters: no snr: i=',i,': i_psym = ',i_psym
          if keyword_set(STR_TITLE) then begin
            if long(str_title) eq 1 then begin
              str_c = strtrim(string(correlate(dblarr_x,dblarr_y)),2)
              str_c = strmid(str_c,0,strpos(str_c,'.')+3)
              str_title_temp = 'correlation coefficient='+str_c
            end
          end else begin
            str_title = ''
          endelse
          plot,[dblarr_x(0),dblarr_x(0)],$
              [dblarr_y(0),dblarr_y(0)],$
              psym        = i_psym,$
              symsize     = dbl_symsize,$
              xtitle      = str_xtitle,$
              ytitle      = str_ytitle,$
              title = str_title_temp,$
              charsize    = dbl_charsize_temp,$
              thick       = dbl_thick,$
              charthick   = dbl_charthick,$
              xrange      = dblarr_xrange,$
              xstyle      = i_xstyle,$
              yrange      = dblarr_yrange,$
              ystyle      = i_ystyle,$
              xticks      = i_xticks,$
              xtickformat = str_xtickformat,$
              yticks      = i_yticks,$
              ytickformat = str_ytickformat,$
              position    = dblarr_position
          for ii = 1,n_elements(i_intarr_symbols(0))-1 do begin
            if i_intarr_symbols(ii) eq 0 then begin
              i_psym = 1
            end else if i_intarr_symbols(ii) eq 1 then begin
              i_psym = 2
            end else if i_intarr_symbols(ii) eq 2 then begin
              i_psym = 4
            end else if i_intarr_symbols(ii) eq 3 then begin
              i_psym = 5
            end else if i_intarr_symbols(ii) eq 4 then begin
              i_psym = 6
            end else begin
              i_psym = 7
            end
            oplot,[dblarr_x(ii),dblarr_x(ii)],$
                  [dblarr_y(ii), dblarr_y(ii)],$
                  psym = i_psym,$
                  symsize = dbl_symsize,$
                  thick = dbl_thick
          endfor
        end else begin
          if keyword_set(STR_TITLE) then begin
            if long(str_title) eq 1 then begin
              str_c = strtrim(string(correlate(dblarr_x,dblarr_y)),2)
              str_c = strmid(str_c,0,strpos(str_c,'.')+3)
              str_title_temp = 'correlation coefficient='+str_c
            end
          end else begin
            str_title = ''
          endelse
          plot,dblarr_x,$
              dblarr_y,$
              psym        = i_psym,$
              symsize     = dbl_symsize,$
              xtitle      = str_xtitle,$
              ytitle      = str_ytitle,$
              title = str_title_temp,$
              charsize    = dbl_charsize_temp,$
              thick       = dbl_thick,$
              charthick   = dbl_charthick,$
              xrange      = dblarr_xrange,$
              xstyle      = i_xstyle,$
              yrange      = dblarr_yrange,$
              ystyle      = i_ystyle,$
              xticks      = i_xticks,$
              xtickformat = str_xtickformat,$
              yticks      = i_yticks,$
              ytickformat = str_ytickformat,$
              position    = dblarr_position
        endelse
        loadct,13
        ; --- guide line
        if  b_plot_guide_line then $
          oplot,dblarr_yrange,dblarr_yrange,thick=3,color=140

        ; --- vertical lines
        if keyword_set(DBLARR_VERTICAL_LINES_IN_PLOT) then begin
          for i=0, n_elements(dblarr_vertical_lines_in_plot)-1 do begin
            plot_vertical_lines,dblarr_vertical_lines_in_plot(i),dblarr_yrange
          endfor
        endif
        if keyword_set(I_DBLARR_YFIT) then begin
          oplot,dblarr_x,i_dblarr_yfit,psym=1,symsize=0.3,color=70
        endif

        ; --- other lines
        if keyword_set(I_DBLARR_LINES_IN_PLOT) then begin
          for i=0, n_elements(i_dblarr_lines_in_plot(*,0))-1 do begin
            oplot,i_dblarr_lines_in_plot(i,0:1),$
                  i_dblarr_lines_in_plot(i,2:3),$
                  linestyle = 2,$
                  thick = 5
          endfor
  ;        print,'i_dblarr_lines_in_plot = ',i_dblarr_lines_in_plot
  ;        stop
        endif
      end

      ; --- mark clipped data
      if keyword_set(I_DO_SIGMA_CLIPPING) and io_indarr_clipped(0) ge 0 then begin
        loadct,0
        for i=0,n_elements(io_indarr_clipped)-1 do begin
          plotsym,0,dbl_symsize+1.,THICK=dbl_thick + 3.
          oplot,dblarr_x(io_indarr_clipped),$
                dblarr_y(io_indarr_clipped),$
  ;              thick=dbl_thick + 3.,$
                psym=8;,$
  ;            symsize=dbl_symsize
        endfor
      endif
      o_indarr_y_good = lindgen(n_elements(dblarr_y))
      remove_subarr_from_array,o_indarr_y_good,io_indarr_clipped
      if keyword_set(DBLARR_RAVE_SNR) and not(keyword_set(I_B_DONT_PLOT_COLOUR_BAR)) then begin
        print,'compare_two_parameters: ltab = ',ltab
        print,'compare_two_parameters: str_file_colour = ',str_file_colour
        print,'compare_two_parameters: str_plotname_root = ',str_plotname_root
        loadct,ltab,FILE=str_file_colour
        for i=0,254 do begin
          oplot,[dblarr_xrange(1) - (dblarr_xrange(1) - dblarr_xrange(0)) / 37.67,dblarr_xrange(1)],$
                [dblarr_yrange(0)+((dblarr_yrange(1)-dblarr_yrange(0))*(double(i)/254.)),$
                dblarr_yrange(0)+((dblarr_yrange(1)-dblarr_yrange(0))*(double(i)/254.))],$
                color=i+1,$
                thick=5.
        endfor
        xyouts,dblarr_xrange(1)+(dblarr_xrange(1) - dblarr_xrange(0))/100.,dblarr_yrange(0),'0',charsize=dbl_charsize,charthick=dbl_charthick
        xyouts,dblarr_xrange(1),dblarr_yrange(1)-(dblarr_yrange(1)-dblarr_yrange(0))/23.,'100',charsize=dbl_charsize,charthick=dbl_charthick
        xyouts,dblarr_xrange(1)+(dblarr_xrange(1) - dblarr_xrange(0))/20.,dblarr_yrange(0)+(dblarr_yrange(1)-dblarr_yrange(0))/3.,'STN RAVE',charsize=dbl_charsize,orientation=90,charthick=dbl_charthick
        loadct,0
      endif
    device,/close
    set_plot,'x'
  ;  print,'str_plot = ',str_plot
  ;  print,'dblarr_position = ',dblarr_position
  ;  stop
  ;  loadct,0
    str_giffile = str_plotname_root+'.gif'

    spawn,'ps2gif '+str_plot+' '+str_giffile
    print,str_giffile+' written'
    if b_printpdf then begin
      spawn,'epstopdf '+str_plot
      print,strmid(str_giffile,0,strpos(str_giffile,'.',/REVERSE_SEARCH))+'.pdf written'
    endif
    ;make_pdf,str_plot
    str_plotname_hist = str_plotname_root+'_good_hist'
    if keyword_set(HIST_I_NBINS_SET) then begin
      hist_i_nbinsmin = 0
      hist_i_nbinsmax = 0
      ;print,'compare_two_paramters: hist_i_nbins_set = ',hist_i_nbins_set
      ;print,'compare_two_paramters: hist_i_nbinsmin = ',hist_i_nbinsmin
      ;print,'compare_two_paramters: hist_i_nbinsmax = ',hist_i_nbinsmax
      ;stop
    endif
    indarr_plot = lindgen(n_elements(dblarr_x))
    if io_indarr_clipped(0) ge 0 then begin
      remove_subarr_from_array,indarr_plot,io_indarr_clipped
    endif
    print,'compare_two_parameters: end: io_indarr_clipped = ',io_indarr_clipped
;    stop
;    if keyword_set(hist_dblarr_yrange) then begin
;      if hist_dblarr_yrange(1) lt max(dblarr_y(indarr_plot)) then $
;        hist_dblarr_yrange(1) = max(dblarr_y(indarr_plot)) + max(dblarr_y(indarr_plot)) / 20.
;    endif
    plot_two_histograms,dblarr_x(indarr_plot),$;                                --- RAVE
                        dblarr_y(indarr_plot),$;                                --- BESANCON
                        STR_PLOTNAME_ROOT   = str_plotname_hist,$; --- string
                        XTITLE              = hist_str_xtitle,$;   --- string
                        YTITLE              = hist_str_ytitle,$;   --- string
                        I_NBINS             = hist_i_nbins_set,$;                           --- int
                        NBINSMIN            = hist_i_nbinsmin,$;                --- int
                        NBINSMAX            = hist_i_nbinsmax,$;                --- int
                        XRANGE              = hist_dblarr_xrange,$;     --- dblarr
                        YRANGE              = hist_dblarr_yrange,$;     --- dblarr
                        MAXNORM             = hist_b_maxnorm,$;                 --- bool (0/1)
                        TOTALNORM           = hist_b_totalnorm,$;                 --- bool (0/1)
                        PERCENTAGE          = hist_b_percentage,$;                 --- bool (0/1)
                        REJECTVALUEX        = dbl_rejectvaluex,$;              --- double
                        B_POP_ID            = hist_b_pop_id,$;                 --- bool
                        DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;                 --- dblarr
                        PRINTPDF            = b_printpdf,$;                 --- bool (0/1)
  ;                      DEBUGA              = 0,$;                 --- bool (0/1)
  ;                      DEBUGB              = 0,$;                 --- bool (0/1)
  ;                      DEBUG_OUTFILES_ROOT = 0,$;                 --- string
                        COLOUR              = 1,$;                 --- bool (0/1)
                        B_RESIDUAL          = hist_b_residual,$;                 --- double
                        I_DBL_THICK         = dbl_thick,$;
                        I_INT_XTICKS        = i_xticks,$
                        I_STR_XTICKFORMAT   = str_xtickformat,$
                        I_DBLARR_POSITION   = hist_dblarr_position,$
                        I_DBL_CHARSIZE      = dbl_charsize,$
                        I_DBL_CHARTHICK     = dbl_charthick,$
                        DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_hist_plot,$
                        B_PRINT_MOMENTS     = b_print_moments
    print,'compare_two_parameters: str_plotname_hist set to <'+str_plotname_hist+'>'
    o_str_plotname_hist = str_plotname_hist
  endif

  ; --- dblarr_x vs dblarr_x - dblarr_y
  if keyword_set(I_B_Y_VS_X_ONLY) then begin
    str_plot = str_plotname_root+'.ps'
  end else begin
    str_plot = str_plotname_root+'_diff.ps'
  endelse
  set_plot,'ps'
  if keyword_set(I_B_QUADRATIC) then begin
    ;stop
    device,LANGUAGE_LEVEL=2,filename=str_plot,/color,/encapsulated,xsize=10,ysize=10
    dbl_charsize_temp = dbl_charsize * 0.8
  end else begin
    device,LANGUAGE_LEVEL=2,filename=str_plot,/color,/encapsulated,xsize=17.75,ysize=12.72
    dbl_charsize_temp = dbl_charsize
  endelse

    if keyword_set(DBLARR_ERR_X) and keyword_set(DBLARR_ERR_Y) and keyword_set(DBLARR_RAVE_SNR) then begin
      if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
        dblarr_y_plot = dblarr_y
      end else begin
        if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
          dblarr_y_plot = dblarr_y - dblarr_x
        end else begin
          dblarr_y_plot = dblarr_x - dblarr_y
        end
      endelse
      if keyword_set(I_INTARR_SYMBOLS) then begin
        if i_intarr_symbols(0) eq 0 then begin
          i_psym = 1
        end else if i_intarr_symbols(0) eq 1 then begin
          i_psym = 2
        end else if i_intarr_symbols(0) eq 2 then begin
          i_psym = 4
        end else if i_intarr_symbols(0) eq 3 then begin
          i_psym = 5
        end else if i_intarr_symbols(0) eq 4 then begin
          i_psym = 6
;        end else if i_intarr_symbols(0) eq 5 then begin
;          i_psym = 6
        end else begin
          i_psym = 7
        end
      endif
        if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
          dblarr_y_plot = dblarr_y
        end else begin
          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
            dblarr_y_plot = dblarr_y - dblarr_x
          end else begin
            dblarr_y_plot = dblarr_x - dblarr_y
          end
        endelse
      if keyword_set(STR_TITLE) then begin
        if long(str_title) eq 1 then begin
          indarr_mean_no_zero = where(abs(dblarr_mean) gt 0.000000001)
          if indarr_mean_no_zero(0) lt 0 then begin
            dbl_mean = 0.
            int_length = 3
          end else begin
            dbl_mean = mean(dblarr_mean(indarr_mean_no_zero))
            if (dbl_mean gt 100.) or (dbl_mean lt -100.) then begin
              int_length = 0
            end else if (dbl_mean gt 10.) or (dbl_mean lt -10.) then begin
              int_length = 2
            end else begin
              int_length = 3
            endelse
          endelse
          str_mean = strtrim(string(dbl_mean),2)
          if strpos(str_mean,'e') lt 0 then begin
            str_mean = strmid(str_mean,0,strpos(str_mean,'.')+int_length)
          end else begin
            str_mean = strmid(str_mean,0,strpos(str_mean,'.')+2)+strmid(str_mean,strpos(str_mean,'e'))
          endelse

          indarr_sigma_no_zero = where(abs(dblarr_sigma) gt 0.00000000001)
          if indarr_sigma_no_zero(0) lt 0 then begin
            dbl_sigma = 0.
            int_length = 3
          end else begin
            dbl_sigma = mean(dblarr_sigma(indarr_sigma_no_zero))
            if (dbl_sigma gt 100.) or (dbl_sigma lt -100.) then begin
              int_length = 0
            end else if (dbl_sigma gt 10.) or (dbl_sigma lt -10.) then begin
              int_length = 2
            end else begin
              int_length = 3
            endelse
          endelse
          str_sigma = strtrim(string(dbl_sigma),2)
          str_sigma = strmid(str_sigma,0,strpos(str_sigma,'.')+int_length)

          indarr_good = where((strtrim(string(dblarr_x),2) ne 'NaN') and (strtrim(string(dblarr_y_plot),2) ne 'NaN'),COMPLEMENT=indarr_nan)
          str_c = strtrim(string(correlate(dblarr_x(indarr_good),dblarr_y_plot(indarr_good))),2)
          str_c = strmid(str_c,0,strpos(str_c,'.')+3)
          str_title_temp = '!4l!3(!4l!3)='+str_mean+', !4l!3(!4r!3)='+str_sigma+', c='+str_c
        end
      end else begin
        str_title_temp = ''
      endelse
      plot,[dblarr_x(0),dblarr_x(0)],$
           [dblarr_y_plot(0),dblarr_y_plot(0)],$
           psym        = i_psym,$
           symsize     = dbl_symsize,$
           xtitle      = str_xtitle,$
           ytitle      = diff_str_ytitle,$
           title = str_title_temp,$
           charsize    = dbl_charsize_temp,$
           thick       = dbl_thick,$
           charthick   = dbl_charthick,$
           xrange      = dblarr_xrange,$
           xstyle      = i_xstyle,$
           yrange      = diff_dblarr_yrange,$
           ystyle      = i_ystyle,$
           xticks      = i_xticks,$
           xtickformat = str_xtickformat,$
           position    = diff_dblarr_position
      print,'compare_two_parameters: ltab = ',ltab
      print,'compare_two_parameters: str_file_colour = ',str_file_colour
      print,'compare_two_parameters: str_plotname_root = ',str_plotname_root
      loadct,ltab,FILE=str_file_colour







;        if n_elements(dblarr_x) gt 300 then begin
;          dblarr_x = dblarr_x(0:long(n_elements(dblarr_x)/10))
;          dblarr_y = dblarr_y(0:long(n_elements(dblarr_y)/10))
;        end







      for i=0ul,n_elements(dblarr_x)-1 do begin
        i_colour = long( 2.5 * dblarr_rave_snr(i))
        if i_colour lt 1 then i_colour = 1
        if i_colour gt 255 then i_colour = 255
        if keyword_set(I_INTARR_SYMBOLS) then begin
          if i_intarr_symbols(i) eq 0 then begin
            i_psym = 1
          end else if i_intarr_symbols(i) eq 1 then begin
            i_psym = 2
          end else if i_intarr_symbols(i) eq 2 then begin
            i_psym = 4
          end else if i_intarr_symbols(i) eq 3 then begin
            i_psym = 5
          end else if i_intarr_symbols(i) eq 4 then begin
            i_psym = 6
;          end else if i_intarr_symbols(i) eq 5 then begin
;            i_psym = 6
          end else begin
            i_psym = 7
          end
        endif
        oplot,[dblarr_x(i),dblarr_x(i)],$
              [dblarr_y_plot(i),dblarr_y_plot(i)],$
              color   = i_colour,$
              psym    = i_psym,$
              symsize = dbl_symsize,$
              thick   = dbl_thick
        ; --- plot error bars
;        if keyword_set(B_DIFF_ONLY) then begin
;          dblarr_y_plot = [dblarr_y(i),dblarr_y(i)]
;        end else begin
;          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
;            dblarr_y_plot = [dblarr_y(i) - dblarr_x(i),dblarr_y(i) - dblarr_x(i)]
;          end else begin
;            dblarr_y_plot = [dblarr_x(i) - dblarr_y(i),dblarr_x(i) - dblarr_y(i)]
;          end
;        endelse
        oplot,[dblarr_x(i)-dblarr_err_x(i),dblarr_x(i)+dblarr_err_x(i)],$
              [dblarr_y_plot(i),dblarr_y_plot(i)],$
              color=i_colour,$
              thick = 1.5;dbl_thick
;        if keyword_set(B_DIFF_ONLY) then begin
;          dblarr_y_plot = [dblarr_y(i) - dblarr_err_y(i),dblarr_y(i) + dblarr_err_y(i)]
;        end else begin
;          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
;            dblarr_y_plot = [dblarr_y(i) - dblarr_x(i) - dblarr_err_y(i),dblarr_y(i) - dblarr_x(i) + dblarr_err_y(i)]
;          end else begin
;            dblarr_y_plot = [dblarr_x(i) - dblarr_y(i) - dblarr_err_y(i),dblarr_x(i) - dblarr_y(i) + dblarr_err_y(i)]
;          end
;        endelse
        oplot,[dblarr_x(i),dblarr_x(i)],$
              [dblarr_y_plot(i),dblarr_y_plot(i)],$
              color=i_colour,$
              thick = 1.5;dbl_thick
      endfor

      ; --- plot guide line
      loadct,0
      if  b_plot_guide_line then $
        oplot,[dblarr_xrange(0),dblarr_xrange(1) - (dblarr_xrange(1) - dblarr_xrange(0)) / 37.67],[0.,0.],thick=3;,color=140

      ; --- vertical lines
      if keyword_set(DBLARR_VERTICAL_LINES_IN_DIFF_PLOT) then begin
;        print,'dblarr_vertical_lines_in_plot_diff_plot = ',dblarr_vertical_lines_in_diff_plot
;        stop
        for i=0, n_elements(dblarr_vertical_lines_in_diff_plot)-1 do begin
          plot_vertical_lines,dblarr_vertical_lines_in_diff_plot(i),diff_dblarr_yrange
        endfor
      endif

      ; --- other lines
      if keyword_set(I_DBLARR_LINES_IN_DIFF_PLOT) then begin
        for i=0, n_elements(i_dblarr_lines_in_diff_plot(*,0))-1 do begin
          oplot,i_dblarr_lines_in_diff_plot(i,0:1),$
                i_dblarr_lines_in_diff_plot(i,2:3),$
                linestyle = 2,$
                thick = 5
        endfor
      endif

      ; --- plot fit
      if keyword_set(I_DBLARR_YFIT) then begin
        if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
          dblarr_y_plot = i_dblarr_yfit
        end else begin
          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
            dblarr_y_plot = dblarr_y - i_dblarr_yfit
          end else begin
            dblarr_y_plot = dblarr_x - i_dblarr_yfit
          end
        endelse
        oplot,dblarr_x,$
              dblarr_y_plot,$
              psym=1,$
              symsize=0.3,$
              color=70
      endif

      ; --- plot fit mean
      if keyword_set(I_B_FIT_MEAN) then begin
        oplot,[dblarr_xrange(0),dblarr_xrange(1)],$
              [dblarr_xrange(0) * o_dblarr_coeffs_fit_mean(1) + o_dblarr_coeffs_fit_mean(0),dblarr_xrange(1) * o_dblarr_coeffs_fit_mean(1) + o_dblarr_coeffs_fit_mean(0)],$
              linestyle = 1,$
              thick = 5
      endif

    end else begin
      if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
        dblarr_y_plot = dblarr_y
      end else begin
        if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
          dblarr_y_plot = dblarr_y - dblarr_x
        end else begin
          dblarr_y_plot = dblarr_x - dblarr_y
        end
      endelse
      if keyword_set(STR_TITLE) then begin
        if long(str_title) eq 1 then begin
          dbl_mean = mean(dblarr_mean)
          if (dbl_mean gt 100.) or (dbl_mean lt -100.) then begin
            int_length = 0
          end else if (dbl_mean gt 10.) or (dbl_mean lt -10.) then begin
            int_length = 2
          end else begin
            int_length = 3
          endelse
          str_mean = strtrim(string(dbl_mean),2)
          if strpos(str_mean,'e') lt 0 then begin
            str_mean = strmid(str_mean,0,strpos(str_mean,'.')+int_length)
          end else begin
            str_mean = strmid(str_mean,0,strpos(str_mean,'.')+2)+strmid(str_mean,strpos(str_mean,'e'))
          endelse

          dbl_sigma = mean(dblarr_sigma)
          if (dbl_sigma gt 100.) or (dbl_sigma lt -100.) then begin
            int_length = 0
          end else if (dbl_sigma gt 10.) or (dbl_sigma lt -10.) then begin
            int_length = 2
          end else begin
            int_length = 3
          endelse
          str_sigma = strtrim(string(dbl_sigma),2)
          str_sigma = strmid(str_sigma,0,strpos(str_sigma,'.')+int_length)

          indarr_good = where((strtrim(string(dblarr_x),2) ne 'NaN') and (strtrim(string(dblarr_y_plot),2) ne 'NaN'),COMPLEMENT=indarr_nan)
          str_c = strtrim(string(correlate(dblarr_x(indarr_good),dblarr_y_plot(indarr_good))),2)
          str_c = strmid(str_c,0,strpos(str_c,'.')+3)
          str_title_temp = '!4l!3(!4l!3)='+str_mean+', !4l!3(!4r!3)='+str_sigma+', c='+str_c
        end
      end else begin
        str_title = ''
      endelse
      plot,dblarr_x,$
           dblarr_y_plot,$
           psym        = i_psym,$
           symsize     = dbl_symsize,$
           xtitle      = str_xtitle,$
           ytitle      = diff_str_ytitle,$
           title = str_title_temp,$
           charsize    = dbl_charsize_temp,$
           thick       = dbl_thick,$
           charthick   = dbl_charthick,$
           xrange      = dblarr_xrange,$
           xstyle      = i_xstyle,$
           yrange      = diff_dblarr_yrange,$
           ystyle      = i_ystyle,$
           xticks      = i_xticks,$
           xtickformat = str_xtickformat,$
           position    = diff_dblarr_position
      loadct,13

      ; --- plot guide line
      if  b_plot_guide_line then $
        oplot,[dblarr_xrange(0),dblarr_xrange(1) - (dblarr_xrange(1) - dblarr_xrange(0)) / 37.67],[0.,0.],thick=3,color=140

      ; --- vertical lines
      if keyword_set(DBLARR_VERTICAL_LINES_IN_DIFF_PLOT) then begin
;        print,'dblarr_vertical_lines_in_diff_plot = ',dblarr_vertical_lines_in_diff_plot
;        stop
        for i=0, n_elements(dblarr_vertical_lines_in_diff_plot)-1 do begin
          plot_vertical_lines,dblarr_vertical_lines_in_diff_plot(i),dblarr_yrange
        endfor
      endif

      ; --- other lines
      if keyword_set(I_DBLARR_LINES_IN_DIFF_PLOT) then begin
        for i=0, n_elements(i_dblarr_lines_in_diff_plot(*,0))-1 do begin
          oplot,i_dblarr_lines_in_diff_plot(i,0:1),$
                i_dblarr_lines_in_diff_plot(i,2:3),$
                linestyle = 1,$
                thick = 3
        endfor
      endif

      ; --- plot fit
      if keyword_set(I_DBLARR_YFIT) then begin
        if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
          dblarr_y_plot = i_dblarr_yfit
        end else begin
          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
            dblarr_y_plot = dblarr_y - i_dblarr_yfit
          end else begin
            dblarr_y_plot = dblarr_x - i_dblarr_yfit
          end
        endelse
        oplot,dblarr_x,$
              dblarr_y_plot,$
              psym=1,$
              symsize=0.3,$
              color=70
      endif

      ; --- plot fit mean
      if keyword_set(I_B_FIT_MEAN) then begin
        oplot,[dblarr_xrange(0),dblarr_xrange(1)],$
              [dblarr_xrange(0) * o_dblarr_coeffs_fit_mean(1) + o_dblarr_coeffs_fit_mean(0),dblarr_xrange(1) * o_dblarr_coeffs_fit_mean(1) + o_dblarr_coeffs_fit_mean(0)],$
              linestyle = 1,$
              thick = 5
      endif
    end
    ; --- plot mean and sigma
    loadct,13
    indarr = where(dblarr_x_bin_nelements gt sigma_i_minelements);abs(dblarr_mean) ne 999.99)
    if indarr(0) ge 0 then begin
      oplot,dblarr_x_bin(indarr),$
            dblarr_mean(indarr),$
            thick=dbl_thick + 3.,$
            color=70
      oplot,dblarr_x_bin(indarr),$
            dblarr_mean(indarr) - dblarr_sigma(indarr),$
            thick=dbl_thick + 3.,$
            linestyle=2,$
            color=70
      oplot,dblarr_x_bin(indarr),$
            dblarr_mean(indarr) + dblarr_sigma(indarr),$
            thick=dbl_thick + 3.,$
            linestyle=2,$
            color=70
    endif

    ; --- mark clipped data
    loadct,0

    if keyword_set(I_DO_SIGMA_CLIPPING) and io_indarr_clipped(0) ge 0 then begin
      if keyword_set(B_DIFF_ONLY) or keyword_set(I_B_Y_VS_X_ONLY) then begin
        dblarr_y_plot = dblarr_y(io_indarr_clipped)
      end else begin
        if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
          dblarr_y_plot = dblarr_y(io_indarr_clipped)-dblarr_x(io_indarr_clipped)
        end else begin
          dblarr_y_plot = dblarr_x(io_indarr_clipped)-dblarr_y(io_indarr_clipped)
        end
      endelse
      if keyword_set(I_DO_SIGMA_CLIPPING) and io_indarr_clipped(0) ge 0 then begin
        loadct,0
        for i=0,n_elements(io_indarr_clipped)-1 do begin
          plotsym,0,dbl_symsize+1.,THICK=dbl_thick + 3.
          oplot,dblarr_x(io_indarr_clipped),$
                dblarr_y_plot,$
  ;              thick=dbl_thick + 3.,$
                psym=8;,$
  ;            symsize=dbl_symsize
        endfor
      endif
;      oplot,dblarr_x(indarr_clipped),$
;            dblarr_y_plot,$
;            thick=dbl_thick + 3.,$
;            psym=7,$
;            symsize=dbl_symsize
    endif
    ; --- plot colour bar
    if keyword_set(DBLARR_RAVE_SNR) and not(keyword_set(I_B_DONT_PLOT_COLOUR_BAR)) then begin
      print,'compare_two_parameters: ltab = ',ltab
      print,'compare_two_parameters: str_file_colour = ',str_file_colour
      print,'compare_two_parameters: str_plotname_root = ',str_plotname_root
      loadct,ltab,FILE=str_file_colour
      for i=0,254 do begin
        oplot,[dblarr_xrange(1) - (dblarr_xrange(1) - dblarr_xrange(0)) / 37.67,dblarr_xrange(1)],$
              [diff_dblarr_yrange(0)+((diff_dblarr_yrange(1)-diff_dblarr_yrange(0))*(double(i)/254.)),$
               diff_dblarr_yrange(0)+((diff_dblarr_yrange(1)-diff_dblarr_yrange(0))*(double(i)/254.))],$
              color=i+1,$
              thick=5.
      endfor
      loadct,0
      xyouts,dblarr_xrange(1)+(dblarr_xrange(1) - dblarr_xrange(0))/100.,diff_dblarr_yrange(0),'0',charsize=dbl_charsize,charthick=dbl_charthick
      xyouts,dblarr_xrange(1),diff_dblarr_yrange(1)-(diff_dblarr_yrange(1)-diff_dblarr_yrange(0))/23.,'100',charsize=dbl_charsize,charthick=dbl_charthick
      xyouts,dblarr_xrange(1)+(dblarr_xrange(1) - dblarr_xrange(0))/20.,diff_dblarr_yrange(0)+(diff_dblarr_yrange(1)-diff_dblarr_yrange(0))/3.,'STN RAVE',charsize=dbl_charsize,orientation=90,charthick=dbl_charthick
    endif

  device,/close
  set_plot,'x'
  str_giffile = strmid(str_plot,0,strpos(str_plot,'.',/REVERSE_SEARCH))+'.gif'
  spawn,'ps2gif '+str_plot+' '+str_giffile
  if b_printpdf then $
    spawn,'epstopdf '+str_plot

end
