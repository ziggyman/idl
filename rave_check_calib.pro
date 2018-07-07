pro rave_check_calib
  str_filename_in = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib.dat'

  int_col_teff = 19
  int_col_logg = 20
  int_col_mh = 21
  int_col_afe = 22
  int_col_cmh = 23
  int_col_mh_calib = 24
  int_col_stn = 35

  strarr_data = readfiletostrarr(str_filename_in,' ')

  dblarr_teff_rave = double(strarr_data(*,int_col_teff))
  dblarr_logg_rave = double(strarr_data(*,int_col_logg))
  dblarr_mh_rave = double(strarr_data(*,int_col_mh))
  dblarr_cmh_calib_rave = double(strarr_data(*,int_col_cmh))
  dblarr_mh_calib_rave = double(strarr_data(*,int_col_mh_calib))
  dblarr_afe_rave = double(strarr_data(*,int_col_afe))
  dblarr_stn_rave = double(strarr_data(*,int_col_stn))

  rave_calibrate_metallicities,I_DBLARR_MH = double(strarr_data(*,int_col_mh)),$
                               I_DBLARR_AFE = double(strarr_data(*,int_col_afe)),$
                               I_DBLARR_TEFF=double(strarr_data(*,int_col_teff)),$; --- new calibration
                               I_DBLARR_LOGG=double(strarr_data(*,int_col_logg)),$; --- old calibration
                               I_DBLARR_STN = double(strarr_data(*,int_col_stn)),$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED=strarr_mh_rave_calibrated,$;           --- string array
                               I_DBL_REJECTVALUE=9.99,$; --- double
                               I_DBL_REJECTERR=1,$;       --- double
                               I_B_SEPARATE=1
  dblarr_cmh_rave = double(strarr_mh_rave_calibrated)

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg_rave,$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5
  dblarr_position = [0.205,0.175,0.932,0.925]
  str_htmlfile = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/index_calib.html'
  openw,lun_html,str_htmlfile,/GET_LUN
  printf,lun_html,'<html><body><center>'
  b_diff_only = 0
  int_sigma_nbins = 20
  for i=0,1 do begin
    b_dwarfs_only = 0
    b_giants_only = 0
    if i eq 0 then begin; --- dwarfs
      b_dwarfs_only = 1
      dblarr_logg = dblarr_logg_rave(indarr_dwarfs)
      indarr_logg = indarr_dwarfs
    end else begin; --- giants
      b_giants_only = 1
      dblarr_logg = dblarr_logg_rave(indarr_giants)
      indarr_logg = indarr_giants
    endelse

    for j=0,7 do begin
      b_y_vs_x_only = 0
      if j eq 0 then begin
        int_smooth_mean_sig = 1
        str_xtitle = '[m/H]!Dcalib!N [dex]'
        str_xtitle_hist = '[m/H] [dex]'
        str_ytitle = '[m/H] [dex]'
        str_ytitle_diff = '[m/H]!Dcalib!N - [m/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/mH_vs_mH-calib'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(F4.1)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        if b_dwarfs_only then begin
          dblarr_xrange = [-2., 1.]
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          dblarr_xrange = [-2.,1.]
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_mh_calib_rave(indarr_logg)
        dblarr_y = dblarr_mh_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 1 then begin
        int_smooth_mean_sig = 1
        str_xtitle = '[M/H]!Dcalib!N [dex]'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[M/H] [dex]'
        str_ytitle_diff = '[M/H]!Dcalib!N - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/MH_vs_MH-calib'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(F4.1)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        if b_dwarfs_only then begin
          dblarr_xrange = [-2., 1.]
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          dblarr_xrange = [-2.,1.]
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_cmh_calib_rave(indarr_logg)
        dblarr_y = dblarr_cmh_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 2 then begin
        int_smooth_mean_sig = 1
        str_xtitle = '[m/H] [dex]'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[M/H] [dex]'
        str_ytitle_diff = '[m/H] - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/MH_vs_mH'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(F4.1)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        if b_dwarfs_only then begin
          dblarr_xrange = [-2., 1.]
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          dblarr_xrange = [-2.,1.]
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_mh_rave(indarr_logg)
        dblarr_y = dblarr_cmh_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 3 then begin
        int_smooth_mean_sig = 1
        str_xtitle = '[m/H]!Dcalib!N [dex]'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[M/H] [dex]'
        str_ytitle_diff = '[m/H]!Dcalib!N - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/MH_vs_mH-calib'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(F4.1)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        if b_dwarfs_only then begin
          dblarr_xrange = [-2., 1.]
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          dblarr_xrange = [-2.,1.]
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_mh_calib_rave(indarr_logg)
        dblarr_y = dblarr_cmh_rave(indarr_logg)
        b_diff_only = 0



      end else if j eq 4 then begin
        b_y_vs_x_only = 1
        int_smooth_mean_sig = 1
        str_xtitle = 'STN'
        str_xtitle_hist = '[m/H] [dex]'
        str_ytitle = '[m/H] [dex]'
        str_ytitle_diff = '[m/H]!Dcalib!N - [m/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/mH_vs_STN'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(I6)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        if b_dwarfs_only then begin
          dblarr_xrange = [0., 200.]
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          dblarr_xrange = [0.,200.]
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_stn_rave(indarr_logg)
        dblarr_y = dblarr_mh_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 5 then begin
        b_y_vs_x_only = 1
        int_smooth_mean_sig = 1
        str_xtitle = 'STN'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[m/H]!Dcalib!N [dex]'
        str_ytitle_diff = '[M/H]!Dcalib!N - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/mH-calib_vs_STN'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(I6)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        dblarr_xrange = [0., 200.]
        if b_dwarfs_only then begin
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_stn_rave(indarr_logg)
        dblarr_y = dblarr_mh_calib_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 6 then begin
        b_y_vs_x_only = 1
        int_smooth_mean_sig = 1
        str_xtitle = 'STN'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[M/H] [dex]'
        str_ytitle_diff = '[m/H] - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/MH_vs_STN'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(I6)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        dblarr_xrange = [0., 200.]
        if b_dwarfs_only then begin
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_stn_rave(indarr_logg)
        dblarr_y = dblarr_cmh_rave(indarr_logg)
        b_diff_only = 0
      end else if j eq 7 then begin
        b_y_vs_x_only = 1
        int_smooth_mean_sig = 1
        str_xtitle = 'STN'
        str_xtitle_hist = '[M/H] [dex]'
        str_ytitle = '[M/H]!Dcalib!N [dex]'
        str_ytitle_diff = '[m/H]!Dcalib!N - [M/H] [dex]'
        dblarr_yrange_diff = [-1.,1.]
        dblarr_yrange_hist = 0
        str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/check_calib/MH-calib_vs_STN'
        i_xticks = 0
        i_yticks = 0
        str_xtickformat = '(I6)'
        str_ytickformat = '(F4.1)'
        b_print_moments = 1
        dblarr_xrange = [0., 200.]
        if b_dwarfs_only then begin
          dblarr_yrange = [-2., 1.]
        end else if b_giants_only then begin
          i_xticks = 5
          dblarr_yrange = [-2.,1.]
        end
        dblarr_x = dblarr_stn_rave(indarr_logg)
        dblarr_y = dblarr_cmh_calib_rave(indarr_logg)
        b_diff_only = 0
      endif
      if b_dwarfs_only then begin
        str_plotname_root = str_plotname_root + '_dwarfs'
      end else if b_giants_only then begin
        str_plotname_root = str_plotname_root + '_giants'
      end
      str_plotname_root = str_plotname_root + '_' + strtrim(string(int_sigma_nbins),2) + 'bins'
      if int_smooth_mean_sig gt 0 then $
        str_plotname_root = str_plotname_root + '_' + strtrim(string(int_smooth_mean_sig),2) + 'smoothings'
      compare_two_parameters,dblarr_x,$
                              dblarr_y,$
                              str_plotname_root,$
                              DBLARR_ERR_X             = double(strarr_data(indarr_logg, int_col_logg)) * 0.,$
                              DBLARR_ERR_Y             = double(strarr_data(indarr_logg, int_col_logg)) * 0.,$
                              DBLARR_RAVE_SNR          = dblarr_stn_rave(indarr_logg),$
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
                              DIFF_DBLARR_POSITION     = dblarr_position,$
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
                              SIGMA_I_NBINS            = 20,$;int_sigma_nbins,$
                              I_INT_SMOOTH_MEAN_SIG    = 1,$
                              SIGMA_I_MINELEMENTS      = 5,$
                              I_DBL_SIGMA_CLIP         = 3.,$
;                              O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$
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
                              HIST_DBLARR_POSITION     = dblarr_position,$;   --- dblarr
                              ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                              O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                              ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                              DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = 0,$
                              ;DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                              I_DBLARR_YFIT                      = 0,$
                              B_PRINT_MOMENTS                    = 1,$
                              I_DO_SIGMA_CLIPPING                = 0,$
                              IO_INDARR_CLIPPED                  = 0,$
                              O_INDARR_Y_GOOD                    = 0,$
                              I_INTARR_SYMBOLS                   = 0,$
                              ;I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                              ;I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                              B_DIFF_ONLY                        = 0,$; --- dblarr_y given as dblarr_x-<some_parameter>
                              I_DBLARR_LINES_IN_DIFF_PLOT        = 0,$
                              I_B_Y_VS_X_ONLY                    = b_y_vs_x_only
      reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'

      if (not b_diff_only) and (not b_y_vs_x_only) then begin
        reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
      endif
      printf,lun_html,'<br><hr><br>'+strtrim(string(i),2)+': '+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'<br>'
      printf,lun_html,'Correlation coefficient = '+strtrim(string(correlate(dblarr_x,dblarr_y)),2)+'<br>'
      if (not b_diff_only) and (not b_y_vs_x_only) then $
        printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
      printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
      if (not b_diff_only) and (not b_y_vs_x_only) then $
        printf,lun_html,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
    endfor
  endfor
  printf,lun_html,'</center></body></html>'
  free_lun,lun_html
end
