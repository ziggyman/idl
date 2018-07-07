pro rave_calibrate_parameter, IO_DBLARR_RAVE                       = io_dblarr_rave,$
                              IO_DBLARR_ALL_RAVE                   = io_dblarr_all_rave,$
                              I_DBLARR_ALL_STN                     = i_dblarr_all_stn,$
                              I_DBLARR_ALL_logg                    = i_dblarr_all_logg,$
                              I_DBLARR_EXTERNAL                    = i_dblarr_external,$
                              I_DBLARR_LOGG                        = i_dblarr_logg,$
                              I_STR_PLOTNAME_ROOT                  = i_str_plotname_root,$
                              I_STR_PARAMETER                      = i_str_parameter,$
                              I_DBLARR_ERR_RAVE                    = i_dblarr_err_rave,$
                              I_DBLARR_ERR_EXTERNAL                = i_dblarr_err_external,$
                              I_DBLARR_SNR                         = i_dblarr_snr,$
                              I_STR_XTITLE                         = i_str_xtitle,$
                              I_STR_STN_XTITLE                     = i_str_stn_xtitle,$
                              I_STR_YTITLE                         = i_str_ytitle,$
                              I_STR_DIFF_YTITLE                    = i_str_diff_ytitle,$
                              I_STR_HIST_XTITLE                    = i_str_hist_xtitle,$;            --- string
                              I_STR_TITLE                          = i_str_title,$
                              I_INT_PSYM                           = i_int_psym,$
                              I_DBL_SYMSIZE                        = i_dbl_symsize,$
                              I_DBL_CHARSIZE                       = i_dbl_charsize,$
                              I_DBL_CHARTHICK                      = i_dbl_charthick,$
                              I_DBL_THICK                          = i_dbl_thick,$
                              I_DBLARR_XRANGE_STN                  = i_dblarr_xrange_stn,$
                              I_DBLARR_XRANGE_DWARFS               = i_dblarr_xrange_dwarfs,$
                              I_DBLARR_YRANGE_DWARFS               = i_dblarr_yrange_dwarfs,$
                              I_DBLARR_XRANGE_GIANTS               = i_dblarr_xrange_giants,$
                              I_DBLARR_YRANGE_GIANTS               = i_dblarr_yrange_giants,$
                              I_DBLARR_YRANGE_DIFF_DWARFS          = i_dblarr_yrange_diff_dwarfs,$
                              I_DBLARR_YRANGE_DIFF_GIANTS          = i_dblarr_yrange_diff_giants,$
                              I_DBLARR_YRANGE_HIST_DWARFS          = i_dblarr_yrange_hist_dwarfs,$
                              I_DBLARR_YRANGE_HIST_GIANTS          = i_dblarr_yrange_hist_giants,$
                              I_DBLARR_POSITION                    = i_dblarr_position,$
                              I_B_DIFF_PLOT_Y_MINUS_X              = i_b_diff_plot_y_minus_x,$
                              I_INT_XTICKS                         = i_int_xticks,$
                              I_STR_XTICKFORMAT                    = i_str_xtickformat,$
                              I_STR_YTICKFORMAT                    = i_str_ytickformat,$
                              I_INT_YTICKS                         = i_int_yticks,$
                              I_DBL_REJECTVALUEX                   = i_dbl_rejectvaluex,$;
                              I_DBL_REJECTVALUE_X_RANGE            = i_dbl_rejectvalue_x_range,$;             --- double
                              I_DBL_REJECTVALUEY                   = i_dbl_rejectvaluey,$;             --- double
                              I_DBL_REJECTVALUE_Y_RANGE            = i_dbl_rejectvalue_y_range,$;             --- double
                              I_B_PRINT_PDF                        = i_b_print_pdf,$;               --- bool (0/1)
                              I_INT_SIGMA_NBINS                    = i_int_sigma_nbins,$
                              I_INT_SMOOTH_MEAN_SIG                = i_int_smooth_mean_sig,$
                              I_INT_SIGMA_MIN_ELEMENTS             = i_int_sigma_min_elements,$
                              I_DBL_SIGMA_CLIP                     = i_dbl_sigma_clip,$
                              I_B_USE_WEIGHTED_MEAN                = i_b_use_weighted_mean,$
                              I_INT_HIST_NBINS_SET                 = i_int_hist_nbins_set,$;            --- int
                              I_INT_HIST_NBINS_MIN                 = i_int_hist_nbins_min,$;            --- int
                              I_INT_HIST_NBINS_MAX                 = i_int_hist_nbins_max,$;            --- int
                              I_B_HIST_PERCENTAGE                  = i_b_hist_percentage,$;          --- bool (0/1)
                              ;I_B_HIST_RESIDUAL                    = i_b_hist_residual,$;            --- double
                              O_STR_PLOTNAME_HIST                  = o_str_plotname_hist,$
                              I_DBLARR_VERTICAL_LINES_IN_PLOT      = i_dblarr_vertical_lines_in_plot,$
                              I_DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = i_dblarr_vertical_lines,$
                              I_DBLARR_VERTICAL_LINES_IN_HIST_PLOT = i_dblarr_vertical_lines_in_hist_plot,$
                              I_B_PRINT_MOMENTS                    = i_b_print_moments,$
                              I_B_DO_SIGMA_CLIPPING                = i_b_do_sigma_clipping,$
                              O_INDARR_DATA                        = o_indarr_data,$
                              O_INDARR_ALL_LOGG                    = o_indarr_all_logg,$
                              IO_INDARR_CLIPPED                    = io_indarr_clipped,$
                              I_INTARR_SYMBOLS                     = i_intarr_symbols,$
                              I_DBL_REJECT_DIFF_STARS_BELOW        = i_dbl_reject_diff_stars_below,$
                              I_DBL_REJECT_DIFF_STARS_ABOVE        = i_dbl_reject_diff_stars_above,$
                              I_B_STN_ONLY                         = i_b_stn_only,$; --- dblarr_y given as dblarr_x-<some_parameter>
                              ;I_DBLARR_LINES_IN_DIFF_PLOT          = i_dblarr_lines_in_diff_plot,$
                              I_B_DWARFS_ONLY                      = i_b_dwarfs_only,$
                              I_B_GIANTS_ONLY                      = i_b_giants_only,$
                              I_DBL_LIMIT_LOGG                     = i_dbl_limit_logg,$
                              I_B_CALIB_FROM_FIT                   = i_b_calib_from_fit,$
                              I_INT_NRUNS                          = i_int_nruns,$
                              I_B_NOT_DO_CALIB_VS_PARAMETER        = i_b_not_do_calib_vs_parameter,$
                              I_B_FIT_MEAN                         = i_b_fit_mean

  b_do_all = 0
  if keyword_set(I_DBLARR_ALL_STN) and keyword_set(I_DBLARR_ALL_LOGG) and keyword_set(IO_DBLARR_ALL_RAVE) then $
    b_do_all = 1

  print,'rave_calibrate_parameter: 1. io_dblarr_rave = ',io_dblarr_rave

  ; --- set missing parameters
  b_dwarfs_only = 1
  b_giants_only = 0
  if keyword_set(I_B_DWARFS_ONLY) then begin
    b_dwarfs_only = 1
    b_giants_only = 0
  end else if keyword_set(I_B_GIANTS_ONLY) then begin
    b_dwarfs_only = 0
    b_giants_only = 1
  endif
  ; --- preserve input data
  ;dblarr_rave_orig    = io_dblarr_rave
  ;dblarr_rave         = dblarr_rave_orig
  dblarr_err_rave     = i_dblarr_err_rave
  dblarr_ext_orig     = i_dblarr_external
  dblarr_ext          = dblarr_ext_orig
  dblarr_err_ext      = i_dblarr_err_external
  dblarr_snr          = i_dblarr_snr
  intarr_sym          = i_intarr_symbols

  if b_do_all then begin
    dblarr_all_rave_stn = i_dblarr_all_stn
    dblarr_all_rave_logg = i_dblarr_all_logg
  endif

  if not keyword_set(IO_INDARR_CLIPPED) then $
    io_indarr_clipped = [-1]

;  print,'rave_calibrate_parameter: io_dblarr_rave = ',io_dblarr_rave
;  print,'rave_calibrate_parameter: i_dblarr_logg = ',i_dblarr_logg
;  print,'rave_calibrate_parameter: dblarr_ext = ',dblarr_ext
;  print,'rave_calibrate_parameter: size(indarr) = ',size(indarr)
;  print,'rave_calibrate_parameter: b_dwarfs_only = ',b_dwarfs_only
;  stop

  indarr_rave = where(abs(io_dblarr_rave) ge 0.0000001)
  if b_dwarfs_only or b_giants_only then begin
    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = i_dblarr_logg(indarr_rave),$
                                       O_INDARR_DWARFS  = indarr_dwarfs,$
                                       O_INDARR_GIANTS  = indarr_giants,$
                                       I_DBL_LIMIT_LOGG = i_dbl_limit_logg
    if b_dwarfs_only then begin
      indarr_logg = indarr_dwarfs
    end else begin
      indarr_logg = indarr_giants
    endelse
  endif else begin
    indarr_logg = lindgen(n_elements(i_dblarr_logg))
  endelse
  o_indarr_data = indarr_rave(indarr_logg)
  indarr_ext = where(abs(dblarr_ext(indarr_rave(indarr_logg))) ge 0.0000001)
  ;print,'i_dblarr_snr(o_indarr_data) = ',i_dblarr_snr(o_indarr_data)
  ;stop
;  dblarr_rave = dblarr_rave(indarr)
;  dblarr_err_rave  = dblarr_err_rave(indarr)
;  dblarr_ext = dblarr_ext(indarr)
;  dblarr_err_ext  = dblarr_err_ext(indarr)
;  dblarr_snr = dblarr_snr(indarr)
;  intarr_sym = intarr_sym(indarr)
;  print,'rave_calibrate_parameter: i_dblarr_logg(indarr) = ',i_dblarr_logg(indarr)

  if b_do_all then begin
    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_all_rave_logg,$
                                       O_INDARR_DWARFS  = indarr_dwarfs_all,$
                                       O_INDARR_GIANTS  = indarr_giants_all,$
                                       I_DBL_LIMIT_LOGG = i_dbl_limit_logg
    if b_dwarfs_only then begin
      indarr_logg_all = indarr_dwarfs_all
    end else if b_giants_only then begin
      indarr_logg_all = indarr_giants_all
    end else begin
      indarr_logg_all = lindgen(n_elements(dblarr_all_rave_logg))
    endelse
    ;dblarr_all_rave_stn = dblarr_all_rave_stn(indarr_logg_all)
    ;io_dblarr_all_rave = io_dblarr_all_rave(indarr_logg_all)
  endif

;  print,'rave_calibrate_parameter: dblarr_rave = ',dblarr_rave
;  print,'rave_calibrate_parameter: dblarr_ext = ',dblarr_ext
;  print,'rave_calibrate_parameter: dblarr_ext - dblarr_rave = ',dblarr_ext-dblarr_rave
;  print,'rave_calibrate_parameter: size(indarr) = ',size(indarr)
;  print,'rave_calibrate_parameter: b_dwarfs_only = ',b_dwarfs_only
;  stop

  dblarr_position = i_dblarr_position
  int_sigma_nbins = 20
  if keyword_set(I_INT_SIGMA_NBINS) then $
    int_sigma_nbins = i_int_sigma_nbins

  int_sigma_min_elements = 3
  if keyword_set(I_INT_SIGMA_MIN_ELEMENTS) then $
    int_sigma_min_elements = i_int_sigma_min_elements

  dbl_sigma_clip = 3.
  b_do_sigma_clipping = 1
  dblarr_err_x = i_dblarr_snr / 1000000000.
  dblarr_err_y = dblarr_err_x

  str_filename_index = i_str_plotname_root
  if b_dwarfs_only then begin
    str_filename_index = str_filename_index + 'dwarfs'
  end else if b_giants_only then begin
    str_filename_index = str_filename_index + 'giants'
  endif
  str_filename_index = str_filename_index + '.html'
  openw,lun_html,str_filename_index,/GET_LUN
  printf,lun_html,'<html><body><center>'

  str_filename_meansig = i_str_plotname_root+'_mean_sig_diff'
  if b_dwarfs_only then $
    str_filename_meansig = str_filename_meansig + '_dwarfs'
  if b_giants_only then $
    str_filename_meansig = str_filename_meansig + '_giants'
  str_filename_meansig = str_filename_meansig + '.dat'
  openw,lunmeansig,str_filename_meansig,/GET_LUN

  int_nruns = 5
  if keyword_set(I_INT_NRUNS) then $
    int_nruns = i_int_nruns

  int_print_moments = 0
  print,'rave_calibrate_parameter: int_nruns = ',int_nruns
  for i=0ul,int_nruns do begin
    int_j_end = 3
    if keyword_set(I_B_NOT_DO_CALIB_VS_PARAMETER) then $
      int_j_end = 1
    if i eq int_nruns then $
      int_j_end = 0
    print,'rave_calibrate_parameter: int_j_end = ',int_j_end
    for j=0,int_j_end do begin
      dblarr_vertical_lines = 0
      dblarr_yfit = 0
      int_do_stn_calib = 0
      int_do_teff_calib = 0
      dblarr_yrange_hist = 0
      int_smooth_mean_sig = 0
      dblarr_lines_in_diff_plot = 0
      dblarr_lines_in_plot = 0
      if j eq 0 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        ; --- smooth mean and calibrate T_eff
;        print,'dblarr_ext(indarr_rave(indarr_logg(indarr_ext))) = ',dblarr_ext(indarr_rave(indarr_logg(indarr_ext)))
;        print,'io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext))) = ',io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
;        print,'dblarr_snr(indarr_rave(indarr_logg(indarr_ext))) = ',dblarr_snr(indarr_rave(indarr_logg(indarr_ext)))
        if i ne int_nruns then $
          int_do_stn_calib = 1
        dblarr_x = dblarr_snr(indarr_rave(indarr_logg(indarr_ext)))
        dblarr_y = dblarr_ext(indarr_rave(indarr_logg(indarr_ext))) - io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        str_xtitle = i_str_stn_xtitle
        str_xtitle_hist = i_str_hist_xtitle
        str_ytitle = i_str_ytitle
        str_ytitle_diff = i_str_diff_ytitle
        dblarr_xrange = i_dblarr_xrange_stn
        if b_dwarfs_only then begin
          dblarr_yrange = i_dblarr_yrange_dwarfs
          dblarr_yrange_diff = i_dblarr_yrange_diff_dwarfs
        end else if b_giants_only then begin
          dblarr_yrange = i_dblarr_yrange_giants
          dblarr_yrange_diff = i_dblarr_yrange_diff_giants
;          dbl_sigma_clip = 2.5
        endif
        str_plotname_root = i_str_plotname_root + 'STN-RAVE'
        if i gt 0 then begin
          for ii=1,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
            if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
              str_plotname_root = str_plotname_root + 's'
          endfor
        endif
        i_xticks = i_int_xticks
        i_yticks = i_int_yticks
        str_xtickformat = '(I6)'
        str_ytickformat = '(I6)'
        if keyword_set(I_B_PRINT_MOMENTS) then $
          int_print_moments = 1
        int_smooth_mean_sig = 1
;        int_sigma_nbins = 20;30
        b_diff_only = 1
        dblarr_temp = svdfit(dblarr_x,dblarr_y,2);,YFIT=dblarr_yfit)




      end else if j eq 1 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        dblarr_y = dblarr_ext(indarr_rave(indarr_logg(indarr_ext))) - io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        int_smooth_mean_sig = 0
        str_plotname_root = i_str_plotname_root + 'STN-RAVE'
        if i gt 0 then begin
          for ii=1,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
            if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
              str_plotname_root = str_plotname_root + 's'
          endfor
        endif
        str_plotname_root = str_plotname_root + '_cs'




      end else if j eq 2 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        dblarr_x = dblarr_ext(indarr_rave(indarr_logg(indarr_ext)))
        dblarr_y = io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        str_xtitle = i_str_xtitle
        str_xtitle_hist = i_str_hist_xtitle
        str_ytitle = i_str_ytitle
        str_ytitle_diff = i_str_diff_ytitle
        i_xticks = i_int_xticks
        i_yticks = i_int_yticks
        if keyword_set(I_B_PRINT_MOMENTS) then $
          int_print_moments = 1
        str_file = i_str_plotname_root + i_str_parameter + '-ext_' + 'coeffs_calib_'+strtrim(string(i),2)
        if keyword_set(I_B_PRINT_MOMENTS) then $
          int_print_moments = 1
        indarr_fit = lindgen(n_elements(indarr_ext))
        if io_indarr_clipped(0) ge 0 then $
          remove_subarr_from_array,indarr_fit,io_indarr_clipped
        if b_dwarfs_only then begin
          dblarr_xrange = i_dblarr_xrange_dwarfs
          dblarr_yrange = i_dblarr_yrange_dwarfs
          if keyword_set(I_DBLARR_YRANGE_HIST_DWARFS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_dwarfs
          dblarr_yrange_diff = i_dblarr_yrange_diff_dwarfs
          i_xticks = i_int_xticks
          i_fit_order = 2
          indarr_temp = lindgen(n_elements(indarr_fit))
          str_file = str_file + '_dwarfs.dat'
        end else if b_giants_only then begin
          dblarr_xrange = i_dblarr_xrange_giants
          dblarr_yrange = i_dblarr_yrange_giants
          if keyword_set(I_DBLARR_YRANGE_HIST_GIANTS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_giants
          dblarr_yrange_diff = i_dblarr_yrange_diff_giants
;          dbl_sigma_clip = 3.0
          i_xticks = i_int_xticks
          i_yticks = i_int_yticks
          i_fit_order = 2
          indarr_temp = lindgen(n_elements(indarr_fit))
          str_file = str_file + '_giants'
          if i_str_parameter eq 'Teff' then begin
            indarr_temp = where(dblarr_x(indarr_fit) lt 5000.)
            str_file = str_file + '-lt-5000'
          endif
          str_file = str_file + '.dat'
        endif else begin
          str_file = str_file + '.dat'
        endelse
        if keyword_set(I_B_CALIB_FROM_FIT) then begin
          if not(keyword_set(I_B_FIT_MEAN)) then begin
            dblarr_coeffs = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),i_fit_order);,measure_errors = double(strarr_data(indarr, int_col_err_rave)))
            openw,lun_calib,str_file,/GET_LUN
            str_print = strtrim(string(dblarr_coeffs(0)),2)
            for i_cal=1,n_elements(dblarr_coeffs)-1 do begin
              str_print = str_print+' '+strtrim(string(dblarr_coeffs(i_cal)),2)
            endfor
            printf,lun_calib,str_print
            free_lun,lun_calib
            ;dblarr_yfit = dblarr_x * dblarr_coeffs(1) + dblarr_coeffs(0)
            dblarr_lines_in_plot = dblarr(1,4)
            dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0),dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0)]
            ;print,'dblarr_lines_in_plot = ',dblarr_lines_in_plot
            ;stop
            dblarr_lines_in_diff_plot = dblarr(1,4)
              dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0))]
            print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
            stop
          endif
        endif else begin
          int_smooth_mean_sig = 1
          int_do_teff_calib = 1
        endelse
;        stop
        str_plotname_root = i_str_plotname_root + i_str_parameter + '-ext'
        if i gt 0 then begin
          for ii=1,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
            if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
              str_plotname_root = str_plotname_root + 's'
          endfor
        endif
        str_plotname_root = str_plotname_root + '_cs'
        str_xtickformat = i_str_xtickformat
        str_ytickformat = i_str_xtickformat
        b_diff_only = 0



      end else if j eq 3 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        int_smooth_mean_sig = 1

        if keyword_set(I_B_CALIB_FROM_FIT) then begin
          int_smooth_mean_sig = 1
          ; --- use poly fit coeffs to calibrate RAVE Teff
          dblarr_calc = io_dblarr_rave(indarr_rave(indarr_logg))
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            dblarr_calc_all = io_dblarr_all_rave(indarr_logg_all)
          endif
          if keyword_set(I_B_FIT_MEAN) then begin
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_rave(indarr_rave(indarr_logg)),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_all_rave(indarr_logg_all),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
            print,'i=',i,': j=',j,': after calib_from_fit_dx_vs_x: io_dblarr_rave = ',io_dblarr_rave
          end else begin
            rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                        IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            ; --- calibrate all RAVE data
            if keyword_set(IO_DBLARR_ALL_RAVE) then begin
              rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                          IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
            endif
            print,'i=',i,': j=',j,': after calib_from_fit_rave_vs_ext: io_dblarr_rave = ',io_dblarr_rave
          endelse
          io_dblarr_rave(indarr_rave(indarr_logg)) = dblarr_calc
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            io_dblarr_all_rave(indarr_logg_all) = dblarr_calc_all
          endif
        endif

        indarr_fit = lindgen(n_elements(indarr_ext))
        if io_indarr_clipped(0) ge 0 then $
          remove_subarr_from_array,indarr_fit,io_indarr_clipped

        str_plotname_root = i_str_plotname_root + i_str_parameter + '-ext'
        for ii=1,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
          if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
            str_plotname_root = str_plotname_root + 's'
        endfor
        str_plotname_root = str_plotname_root + '_cs_ct'

        str_file = i_str_plotname_root + i_str_parameter + '-ext_' + 'coeffs_calib_'+strtrim(string(i),2)
        if b_dwarfs_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_DWARFS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_dwarfs
          indarr_temp = lindgen(n_elements(indarr_fit))
          str_file = str_file + '_dwarfs'
        end else if b_giants_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_GIANTS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_giants
          indarr_temp = lindgen(n_elements(indarr_fit))
;          if i_str_parameter eq 'Teff' then $
;            indarr_temp = where(dblarr_x(indarr_fit) le 5000.)
          str_file = str_file + '_giants'
          if i_str_parameter eq 'Teff' then begin
            indarr_temp = where(dblarr_x(indarr_rave(indarr_logg(indarr_ext(indarr_fit)))) lt 5000.)
            str_file = str_file + '-lt-5000'
          endif
        endif
        str_file = str_file + '.dat'
        dblarr_y = io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        dblarr_vertical_lines = 0
        if int_j_end gt j then begin
          if keyword_set(I_B_CALIB_FROM_FIT) then begin
            if not(keyword_set(I_B_FIT_MEAN)) then begin
              dblarr_coeffs = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),i_fit_order);,measure_errors = double(strarr_data(indarr, int_col_err_rave)))
              openw,lun_calib,str_file,/GET_LUN
              str_print = strtrim(string(dblarr_coeffs(0)),2)
              for i_cal=1,n_elements(dblarr_coeffs)-1 do begin
                str_print = str_print+' '+strtrim(string(dblarr_coeffs(i_cal)),2)
              endfor
              printf,lun_calib,str_print
              free_lun,lun_calib
              ;dblarr_yfit = dblarr_x * dblarr_coeffs(1) + dblarr_coeffs(0)
              dblarr_lines_in_plot = dblarr(1,4)
              dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0),dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0)]
              dblarr_lines_in_diff_plot = dblarr(1,4)
              dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0))]
  ;            print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
              stop
            endif
          endif else begin
            int_smooth_mean_sig = 1
            int_do_teff_calib = 1
          endelse
        endif else begin
          dblarr_coeffs = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),2);,YFIT=dblarr_yfit)
          dblarr_lines_in_plot = dblarr(1,4)
          dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0),dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0)]
          dblarr_lines_in_diff_plot = dblarr(1,4)
          dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0))]
        endelse




      end else if j eq 4 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        int_smooth_mean_sig = 1

        if keyword_set(I_B_CALIB_FROM_FIT) then begin
          int_smooth_mean_sig = 1
          ; --- use poly fit coeffs to calibrate RAVE Teff
          dblarr_calc = io_dblarr_rave(indarr_rave(indarr_logg))
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            dblarr_calc_all = io_dblarr_all_rave(indarr_logg_all)
          endif
          if keyword_set(I_B_FIT_MEAN) then begin
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_rave(indarr_rave(indarr_logg)),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_all_rave(indarr_logg_all),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
          end else begin
            rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                        IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            ; --- calibrate all RAVE data
            if keyword_set(IO_DBLARR_ALL_RAVE) then begin
              dblarr_calc = io_dblarr_all_rave(indarr_logg_all)
              rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                          IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
            endif
          endelse
          io_dblarr_rave(indarr_rave(indarr_logg)) = dblarr_calc
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            io_dblarr_all_rave(indarr_logg_all) = dblarr_calc_all
          endif
        endif

        indarr_fit = lindgen(n_elements(indarr_ext))
        if io_indarr_clipped(0) ge 0 then $
          remove_subarr_from_array,indarr_fit,io_indarr_clipped

        str_plotname_root = i_str_plotname_root + i_str_parameter + '-ext'
        for ii=1,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
          if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
            str_plotname_root = str_plotname_root + 's'
        endfor
        str_plotname_root = str_plotname_root + '_cs_ct_ct'
        str_file = i_str_plotname_root + i_str_parameter + '-ext_' + 'coeffs_calib_'+strtrim(string(i),2)
        if b_dwarfs_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_DWARFS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_dwarfs
          indarr_temp = lindgen(n_elements(indarr_fit))
          str_file = str_file + '_dwarfs'
        endif
        if b_giants_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_GIANTS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_giants
          indarr_temp = lindgen(n_elements(indarr_fit))
;          if i_str_parameter eq 'Teff' then $
;            indarr_temp = where(dblarr_x(indarr_fit) le 5000.)
          str_file = str_file + '_giants'
          if i_str_parameter eq 'Teff' then begin
            indarr_temp = where(dblarr_x(indarr_rave(indarr_logg(indarr_ext(indarr_fit)))) lt 5000.)
            str_file = str_file + '-lt-5000'
          endif
        endif
        dblarr_y = io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        if int_j_end gt j then begin
          if keyword_set(I_B_CALIB_FROM_FIT) then begin
            if not(keyword_set(I_B_FIT_MEAN)) then begin
              dblarr_coeffs = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),i_fit_order);,measure_errors = double(strarr_data(indarr, int_col_err_rave)))
              openw,lun_calib,str_file,/GET_LUN
              str_print = strtrim(string(dblarr_coeffs(0)),2)
              for i_cal=1,n_elements(dblarr_coeffs)-1 do begin
                str_print = str_print+' '+strtrim(string(dblarr_coeffs(i_cal)),2)
              endfor
              printf,lun_calib,str_print
              free_lun,lun_calib
              ;dblarr_yfit = dblarr_x * dblarr_coeffs(1) + dblarr_coeffs(0)
              dblarr_lines_in_plot = dblarr(1,4)
              dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0),dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0)]
              dblarr_lines_in_diff_plot = dblarr(1,4)
              dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_coeffs(1) + dblarr_coeffs(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_coeffs(1) + dblarr_coeffs(0))]
  ;            print,'dblarr_lines_in_diff_plot = ',dblarr_lines_in_diff_plot
              stop
            endif
          endif else begin
            int_smooth_mean_sig = 1
            int_do_teff_calib = 1
          endelse
        end else begin
          dblarr_vertical_lines = 0
          dblarr_temp = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),2);,YFIT=dblarr_yfit)
          dblarr_lines_in_plot = dblarr(1,4)
          dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_temp(1) + dblarr_temp(0),dblarr_xrange(1) * dblarr_temp(1) + dblarr_temp(0)]
          dblarr_lines_in_diff_plot = dblarr(1,4)
          dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_temp(1) + dblarr_temp(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_temp(1) + dblarr_temp(0))]
        endelse



      end else if j eq 5 then begin
        print,'i=',i,': start j=',j,': io_dblarr_rave = ',io_dblarr_rave
        int_smooth_mean_sig = 1

        if keyword_set(I_B_CALIB_FROM_FIT) then begin
          int_smooth_mean_sig = 1
          ; --- use poly fit coeffs to calibrate RAVE Teff
          dblarr_calc = io_dblarr_rave(indarr_rave(indarr_logg))
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            dblarr_calc_all = io_dblarr_all_rave(indarr_logg_all)
          endif
          if keyword_set(I_B_FIT_MEAN) then begin
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_rave(indarr_rave(indarr_logg)),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            rave_calibrate_parameter_values_from_linear_fit_dx_vs_x,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                    I_DBLARR_X                 = io_dblarr_all_rave(indarr_logg_all),$
                                                                    IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
          end else begin
            rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                        IO_DBLARR_PARAMETER_VALUES = dblarr_calc
            ; --- calibrate all RAVE data
            if keyword_set(IO_DBLARR_ALL_RAVE) then begin
              dblarr_calc = io_dblarr_all_rave(indarr_logg_all)
              rave_calibrate_parameter_values_from_linear_fit_rave_vs_ext,I_STR_FILENAME_CALIB       = str_file,$; --- #x Par_ext-Par_RAVE
                                                                          IO_DBLARR_PARAMETER_VALUES = dblarr_calc_all
            endif
          endelse
          io_dblarr_rave(indarr_rave(indarr_logg)) = dblarr_calc
          if keyword_set(IO_DBLARR_ALL_RAVE) then begin
            io_dblarr_all_rave(indarr_logg_all) = dblarr_calc_all
          endif
        endif

        indarr_fit = lindgen(n_elements(indarr_ext))
        if io_indarr_clipped(0) ge 0 then $
          remove_subarr_from_array,indarr_fit,io_indarr_clipped

        if b_dwarfs_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_DWARFS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_dwarfs
          indarr_temp = lindgen(n_elements(indarr_fit))
        endif
        if b_giants_only then begin
          if keyword_set(I_DBLARR_YRANGE_HIST_GIANTS) then $
            dblarr_yrange_hist = i_dblarr_yrange_hist_giants
          indarr_temp = lindgen(n_elements(indarr_fit))
          if i_str_parameter eq 'Teff' then $
            indarr_temp = where(dblarr_x(indarr_fit) le 5000.)
        endif
        str_plotname_root = i_str_plotname_root + i_str_parameter + '-ext'
        for ii=0,i do begin
            str_plotname_root = str_plotname_root + '_cs'
            for jj=3,int_j_end do begin
              str_plotname_root = str_plotname_root + '_ct'
            endfor
          if not(keyword_set(I_B_CALIB_FROM_FIT)) then $
            str_plotname_root = str_plotname_root + 's'
        endfor
        dblarr_y = io_dblarr_rave(indarr_rave(indarr_logg(indarr_ext)))
        dblarr_vertical_lines = 0
        dblarr_temp = svdfit(dblarr_x(indarr_fit(indarr_temp)),dblarr_y(indarr_fit(indarr_temp)),2);,YFIT=dblarr_yfit)
        dblarr_lines_in_plot = dblarr(1,4)
        dblarr_lines_in_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) * dblarr_temp(1) + dblarr_temp(0),dblarr_xrange(1) * dblarr_temp(1) + dblarr_temp(0)]
        dblarr_lines_in_diff_plot = dblarr(1,4)
        dblarr_lines_in_diff_plot(0,0:3) = [dblarr_xrange(0),dblarr_xrange(1),dblarr_xrange(0) - (dblarr_xrange(0) * dblarr_temp(1) + dblarr_temp(0)),dblarr_xrange(1) - (dblarr_xrange(1) * dblarr_temp(1) + dblarr_temp(0))]
        stop
      endif

      if b_dwarfs_only then begin
        str_plotname_root = str_plotname_root + '_dwarfs'
      end else if b_giants_only then begin
        str_plotname_root = str_plotname_root + '_giants'
      endif
      str_plotname_root = str_plotname_root + '_' + strtrim(string(long(int_sigma_nbins)),2) + 'bins'
      if int_smooth_mean_sig gt 0 then $
        str_plotname_root = str_plotname_root + '_' + strtrim(string(long(int_smooth_mean_sig)),2) + 'smoothings'

      ; --- remove clipped stars
;      indarr_good = lindgen(n_elements(dblarr_x))
;      if io_indarr_clipped(0) ge 0 then $
;        remove_subarr_from_array,indarr_good,io_indarr_clipped

      compare_two_parameters,dblarr_x,$
                             dblarr_y,$
                             str_plotname_root,$
                             DBLARR_ERR_X             = dblarr_err_x(indarr_rave(indarr_logg(indarr_ext))),$
                             DBLARR_ERR_Y             = dblarr_err_y(indarr_rave(indarr_logg(indarr_ext))),$
                             DBLARR_RAVE_SNR          = dblarr_snr(indarr_rave(indarr_logg(indarr_ext))),$
                             STR_XTITLE               = str_xtitle,$
                             STR_YTITLE               = str_ytitle,$
                             STR_TITLE                = 1,$
;                              I_PSYM                   = 2,$
                             DBL_SYMSIZE              = 1.,$
                             DBL_CHARSIZE             = 1.8,$
                             DBL_CHARTHICK            = 3.,$
                             DBL_THICK                = 3.,$
                             DBLARR_XRANGE            = dblarr_xrange,$
                             DBLARR_YRANGE            = dblarr_yrange,$
                             DBLARR_POSITION          = dblarr_position,$
                             DIFF_DBLARR_YRANGE       = dblarr_yrange_diff,$
                             DIFF_DBLARR_POSITION     = dblarr_position,$
                             DIFF_STR_YTITLE          = str_ytitle_diff,$
;                              I_B_DIFF_PLOT_Y_MINUS_X  = 0,$
;                              I_XTICKS                 = i_xticks,$
                             STR_XTICKFORMAT          = str_xtickformat,$
;                              I_YTICKS                 = i_yticks,$
;                              DBL_REJECTVALUEX         = 0.,$;             --- double
;                              DBL_REJECTVALUE_X_RANGE  = 0.0000001,$;             --- double
;                              ;DBL_REJECTVALUEY         = dbl_rejectvaluex,$;             --- double
;                              ;DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                             STR_YTICKFORMAT          = str_ytickformat,$
                             B_PRINTPDF               = 1,$;               --- bool (0/1)
                             SIGMA_I_NBINS            = int_sigma_nbins,$
                             I_INT_SMOOTH_MEAN_SIG    = int_smooth_mean_sig,$
                             SIGMA_I_MINELEMENTS      = int_sigma_min_elements,$
                             I_DBL_SIGMA_CLIP         = dbl_sigma_clip,$
                             O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$
;                              I_B_USE_WEIGHTED_MEAN    = 0,$
                             HIST_I_NBINS_SET          = 20,$;            --- int
;                              HIST_I_NBINSMIN          = 20,$;            --- int
;                              HIST_I_NBINSMAX          = 20,$;            --- int
                             HIST_STR_XTITLE          = str_xtitle_hist,$;            --- string
;                              ;HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
;                              ;HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                             HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
;                              ;HIST_B_POP_ID            = 0,$;             --- bool
;                              ;HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
;                              HIST_DBLARR_XRANGE       = dblarr_xrange,$
                             HIST_DBLARR_YRANGE       = dblarr_yrange_hist,$
                             HIST_DBLARR_POSITION     = dblarr_position,$;   --- dblarr
;                              ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                             O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
;                              ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
;                              DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines,$
;                              I_DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
;                              I_DBLARR_YFIT                      = i_dblarr_yfit,$
                             B_PRINT_MOMENTS                  = int_print_moments,$
                             I_DO_SIGMA_CLIPPING                = b_do_sigma_clipping,$
                             O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                             IO_INDARR_CLIPPED                  = io_indarr_clipped,$
                             I_INTARR_SYMBOLS                   = intarr_sym(indarr_rave(indarr_logg(indarr_ext))),$
;                              I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
;                              I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                             B_DIFF_ONLY                        = b_diff_only,$; --- dblarr_y given as dblarr_x minus <some_parameter>
                             I_DBLARR_LINES_IN_DIFF_PLOT        = dblarr_lines_in_diff_plot,$
                             I_DBLARR_LINES_IN_PLOT        = dblarr_lines_in_plot,$
                             I_B_FIT_MEAN                  = i_b_fit_mean,$
                             O_DBLARR_COEFFS_FIT_MEAN      = dblarr_coeffs_fit_mean
;print,'io_indarr_clipped = ',io_indarr_clipped
;stop
      ;print,'o_dblarr_diff_mean_sigma = ',o_dblarr_diff_mean_sigma
      ;stop
      reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'
      if not b_diff_only then begin
        reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
        printf,lun_html,'<br><hr><br>'+strtrim(string(i),2)+': '+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'<br>'
        printf,lun_html,'Correlation coefficient = '+strtrim(string(correlate(dblarr_x,dblarr_y)),2)+'<br>'
        printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
      endif
      printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
      if not b_diff_only then $
        printf,lun_html,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
      printf,lunmeansig,'j = '+strtrim(string(j),2)+': mean sigma'
      for jjj=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
        printf,lunmeansig,o_dblarr_diff_mean_sigma(jjj,0),o_dblarr_diff_mean_sigma(jjj,1),o_dblarr_diff_mean_sigma(jjj,2),o_dblarr_diff_mean_sigma(jjj,3)
      endfor

      if j gt 1 then begin
        if keyword_set(I_B_CALIB_FROM_FIT) then begin
          if (keyword_set(I_B_FIT_MEAN)) then begin
            openw,lun_calib,str_file,/GET_LUN
            str_print = strtrim(string(dblarr_coeffs_fit_mean(0)),2)
            for i_cal=1,n_elements(dblarr_coeffs_fit_mean)-1 do begin
              str_print = str_print+' '+strtrim(string(dblarr_coeffs_fit_mean(i_cal)),2)
            endfor
            printf,lun_calib,str_print
            free_lun,lun_calib
          endif
        endif
      endif

      dbl_mean = 0.
      dbl_sigma = 0.;mean(o_dblarr_diff_mean_sigma(indarr_good(indarr_meansig),1))
      int_nstars_all = total(o_dblarr_diff_mean_sigma(*,3))
      for kkkk = 0, n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
        dbl_weight = o_dblarr_diff_mean_sigma(kkkk,3) / double(int_nstars_all)
        dbl_mean = dbl_mean + o_dblarr_diff_mean_sigma(kkkk,1) * dbl_weight
        dbl_sigma = dbl_sigma + o_dblarr_diff_mean_sigma(kkkk,2) * dbl_weight
      endfor
      printf,lunmeansig,'mean: ',dbl_mean,dbl_sigma
;      print,'mean: ',dbl_mean,dbl_sigma

      if (int_do_stn_calib gt 0) or (int_do_teff_calib gt 0) then begin
        str_calib = str_plotname_root + '_' + strtrim(string(long(int_sigma_nbins)),2)+'sigma-bins_calib'+strtrim(string(int_do_stn_calib),2)
        str_calib = str_calib + '.dat'
        openw,lun_cal,str_calib,/GET_LUN
        if int_do_stn_calib gt 0 then begin
          printf,lun_cal,'#STN mean(ext-RAVE)'
        end else if int_do_teff_calib gt 0 then begin
          printf,lun_cal,'#Teff mean(ext-RAVE)'
        endif
        j_min = -1
        j_max = -1
        b_first_good = 1
        for jj=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
          if o_dblarr_diff_mean_sigma(jj,3) ge int_sigma_min_elements then begin
            if b_first_good then begin
              if jj gt 0 then begin
                printf,lun_cal,o_dblarr_diff_mean_sigma(jj-1,0),' ', strtrim(string(0.),2)
              end else begin
                printf,lun_cal,o_dblarr_diff_mean_sigma(0,0) - o_dblarr_diff_mean_sigma(1,0), strtrim(string(0.),2)
              endelse
              b_first_good = 0
            endif
            j_max = jj
            printf,lun_cal,o_dblarr_diff_mean_sigma(jj,0), o_dblarr_diff_mean_sigma(jj,1)
          end else begin
            if j_min eq -1 then $
              j_min = jj
          endelse
        endfor
        printf,lun_cal,o_dblarr_diff_mean_sigma(j_max,0) + (o_dblarr_diff_mean_sigma(j_max,0) - o_dblarr_diff_mean_sigma(j_max-1,0)), ' ', strtrim(string(0.),2)
        free_lun,lun_cal

        if int_do_stn_calib gt 0 then begin
          dblarr_x_calib = dblarr_snr(indarr_rave(indarr_logg))
        end else if int_do_teff_calib gt 0 then begin
          dblarr_x_calib = io_dblarr_rave(indarr_rave(indarr_logg))
        endif
        dblarr_calc = io_dblarr_rave(indarr_rave(indarr_logg))
        rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                           IO_DBLARR_PARAMETER_VALUES = dblarr_calc,$
                                                           I_DBLARR_X                 = dblarr_x_calib
        io_dblarr_rave(indarr_rave(indarr_logg)) = dblarr_calc

        ; --- calibrate all RAVE data
        if keyword_set(IO_DBLARR_ALL_RAVE) and keyword_set(I_DBLARR_ALL_STN) then begin
          dblarr_calc = io_dblarr_all_rave(indarr_logg_all)
          rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$
                                                             IO_DBLARR_PARAMETER_VALUES = dblarr_calc,$
                                                             I_DBLARR_X                 = dblarr_all_rave_stn(indarr_logg_all)
          io_dblarr_all_rave(indarr_logg_all) = dblarr_calc
        endif
      endif
    endfor
  endfor

  printf,lun_html,'</center></body></html>'
  free_lun,lun_html
  free_lun,lunmeansig

;  print,'io_dblarr_rave(indarr_rave(indarr_logg)) = ',io_dblarr_rave(indarr_rave(indarr_logg))
  o_indarr_all_logg = indarr_logg_all
end
