pro rave_plot_params_doubles
  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good_doubles.dat'

  for ii=0,2 do begin
    strarr_data = readfiletostrarr(str_filename,' ')

    int_col_lon = 5
    int_col_lat = 6
    int_col_vrad = 7
    int_col_teff = 19
    int_col_logg = 20
    int_col_afe = 22
    int_col_mh = 21
    int_col_stn = 35
    int_col_s2n = 34
    int_col_snr = 33

    dblarr_logg = double(strarr_data(*,int_col_logg))

    dblarr_stn = double(strarr_data(*,int_col_stn))
    dblarr_s2n = double(strarr_data(*,int_col_s2n))
    dblarr_snr = double(strarr_data(*,int_col_snr))
    indarr = where(dblarr_stn lt 1., count)
    print,'rave_plot_params_doubles: ',count,' stars without STN'
    if indarr(0) ge 0 then $
      dblarr_stn(indarr) = dblarr_s2n(indarr)
    indarr = where(dblarr_stn lt 1., count)
    print,'rave_plot_params_doubles: ',count,' stars without S2N'
    if indarr(0) ge 0 then $
      dblarr_stn(indarr) = dblarr_snr(indarr)

    dblarr_vrad = double(strarr_data(*,int_col_vrad))
    dblarr_lon = double(strarr_data(*,int_col_lon))
    dblarr_lat = double(strarr_data(*,int_col_lat))
    dblarr_teff = double(strarr_data(*,int_col_teff))
    dblarr_mh = double(strarr_data(*,int_col_mh))
    dblarr_afe = double(strarr_data(*,int_col_afe))

    strarr_data = 0
    dblarr_s2n = 0
    dblarr_snr = 0

    indarr_left = lindgen(n_elements(dblarr_teff))
    int_n_found = 0ul
  ;  i = 0ul
    indarr_x = ulonarr(n_elements(dblarr_teff))
    indarr_y = ulonarr(n_elements(dblarr_teff))
    while indarr_left(0) ge 0 do begin
      ; --- check longitudes
      indarr_lon = where(abs(dblarr_lon(indarr_left) - dblarr_lon(indarr_left(0))) lt 0.0008)
      if indarr_lon(0) lt 0 then begin
        print,'rave_plot_params_doubles: PROBLEM: NO stars found for lon'
        stop
      end else if n_elements(indarr_lon) lt 2 then begin
        print,'rave_plot_params_doubles: PROBLEM: ONLY 1 star found for lon'
        remove_ith_element_from_array,indarr_left,indarr_lon(0)
;        stop
      end else begin

        ; --- check latitudes
        indarr_lat = where(abs(dblarr_lat(indarr_left(indarr_lon)) - dblarr_lat(indarr_left(0))) lt 0.0008)
        if indarr_lat(0) lt 0 then begin
          print,'rave_plot_params_doubles: PROBLEM: NO stars found for lat'
          stop
        end else if n_elements(indarr_lat) lt 2 then begin
          print,'rave_plot_params_doubles: PROBLEM: ONLY 1 star found for lat'
          remove_ith_element_from_array,indarr_left,indarr_lon(indarr_lat(0))
  ;        stop
        end else begin

          ; --- find observation with highest STN
          indarr_maxsnr = where(abs(dblarr_stn(indarr_left(indarr_lon(indarr_lat))) - max(dblarr_stn(indarr_left(indarr_lon(indarr_lat))))) lt 0.00000001, COMPLEMENT=indarr_nmaxsnr)
          if n_elements(indarr_maxsnr) gt 1 then begin
            if indarr_nmaxsnr(0) lt 0 then begin
              indarr_nmaxsnr = indarr_maxsnr(1:n_elements(indarr_maxsnr)-1)
            end else begin
              indarr_nmaxsnr = [indarr_nmaxsnr,indarr_maxsnr(1:n_elements(indarr_maxsnr)-1)]
            endelse
          endif
          indarr_x(int_n_found:int_n_found + n_elements(indarr_lat) - 2) = indarr_left(indarr_lon(indarr_lat(indarr_maxsnr(0))))
          indarr_y(int_n_found:int_n_found + n_elements(indarr_lat) - 2) = indarr_left(indarr_lon(indarr_lat(indarr_nmaxsnr)))
          int_n_found = int_n_found + n_elements(indarr_nmaxsnr)

          ; --- remove indices of doubles found from indarr_left
          for i=0,n_elements(indarr_lat)-1 do begin
            remove_ith_element_from_array,indarr_left,indarr_lon(indarr_lat(n_elements(indarr_lat)-i-1))
          endfor
        endelse
      endelse
    endwhile
    indarr_x = indarr_x(0:int_n_found-1)
    indarr_y = indarr_y(0:int_n_found-1)

    if ii eq 0 then begin
      indarr_logg = lindgen(n_elements(dblarr_logg))
    end else if ii eq 1 then begin
      indarr_logg = where((dblarr_logg(indarr_x) le 3.5) or (dblarr_logg(indarr_y) le 3.5))
    end else begin
      indarr_logg = where((dblarr_logg(indarr_x) gt 3.5) or (dblarr_logg(indarr_y) gt 3.5))
    endelse
    dblarr_logg = dblarr_logg(indarr_logg)
    dblarr_stn = dblarr_stn(indarr_logg)
    dblarr_vrad = dblarr_vrad(indarr_logg)
    dblarr_lon = dblarr_lon(indarr_logg)
    dblarr_lat = dblarr_lat(indarr_logg)
    dblarr_teff = dblarr_teff(indarr_logg)
    dblarr_mh = dblarr_mh(indarr_logg)
    dblarr_afe = dblarr_afe(indarr_logg)

    rave_calibrate_metallicities,dblarr_mh,$
                                dblarr_afe,$
                                DBLARR_TEFF=dblarr_teff,$; --- new calibration
                                DBLARR_LOGG=dblarr_logg,$; --- old calibration
                                DBLARR_STN = dblarr_stn,$; --- calibration from DR3 paper
                                OUTPUT=dblarr_mh_calibrated,$;           --- string array
                                REJECTVALUE=99.,$; --- double
                                REJECTERR=10.,$;       --- double
                                SEPARATE=1

    dblarr_mh_calibrated = double(dblarr_mh_calibrated)
    for j=0,4 do begin
      if j eq 0 then begin
        str_ytitle = '(T - T!Dmax(STN)!N) [K]'
        str_ytickformat = '(I6)'
        str_y = 'dTeff'
        dblarr_y_plot = dblarr_teff(indarr_y) - dblarr_teff(indarr_x)
        dblarr_yrange = [-2000.,2000.]
        i_yticks = 4
      end else if j eq 1 then begin
        str_ytitle = '((log g) - (log g)!Dmax(STN)!N) [K]'
        str_ytickformat = '(I6)'
        str_y = 'dlogg'
        dblarr_y_plot = dblarr_logg(indarr_y) - dblarr_logg(indarr_x)
        dblarr_yrange = [-2.5,2.5]
        i_yticks = 6
      end else if j eq 2 then begin
        str_ytitle = '([m/H] - [m/H]!Dmax(STN)!N) [dex]'
        str_ytickformat = '(F4.1)'
        str_y = 'dmH'
        dblarr_y_plot = dblarr_mh(indarr_y) - dblarr_mh(indarr_x)
        dblarr_yrange = [-1.5,1.5]
        i_yticks = 6
      end else if j eq 3 then begin
        str_ytitle = '([M/H] - [M/H]!Dmax(STN)!N) [dex]'
        str_ytickformat = '(F4.1)'
        str_y = 'dMH'
        dblarr_y_plot = dblarr_mh_calibrated(indarr_y) - dblarr_mh_calibrated(indarr_x)
        dblarr_yrange = [-1.5,1.5]
        i_yticks = 6
      end else begin
        str_ytitle = '(v!Drad!N - v!Drad, max(STN)!N) [km/s]'
        str_ytickformat = '(I6)'
        str_y = 'dvrad'
        dblarr_y_plot = dblarr_vrad(indarr_y) - dblarr_vrad(indarr_x)
        dblarr_yrange = [-100.,100.]
        if ii eq 2 then $
          dblarr_yrange = [-50.,50.]
        i_yticks = 4
      endelse
      for i=0,5 do begin
        if i eq 0 then begin
          str_xtitle = 'T!Dmax(STN)!N [K]'
          dblarr_xrange = [3500.,13500.]
          i_xticks = 5
          if ii eq 1 then begin
            dblarr_xrange = [3500.,9500.]
            i_xticks = 3
          end
          str_xtickformat = '(I6)'
          dbl_rejectvaluex      = 0.0001
          dbl_rejectvaluexrange = 10.
          str_x = 'Teff'
          dblarr_x_plot = dblarr_teff(indarr_x)
          if j eq 0 then begin
            dblarr_lines_in_diff_plot = dblarr(1,4)
            dblarr_lines_in_diff_plot(0,0:1) = [3500.,dblarr_xrange(1)]
            dblarr_lines_in_diff_plot(0,2:3) = [0,dblarr_xrange(0)-dblarr_xrange(1)]
;            dblarr_lines_in_diff_plot(1,0:1) = dblarr_xrange
;            dblarr_lines_in_diff_plot(1,2:3) = [dblarr_xrange(1)-dblarr_xrange(0),0]
          endif
        end else if i eq 1 then begin
          str_xtitle = '(log g)!Dmax(STN)!N [dex]'
          dblarr_xrange = [0.,5.5]
          str_xtickformat = '(I6)'
          if ii eq 1 then begin
            dblarr_xrange = [0.,4.]
            str_xtickformat = '(F5.1)'
          end else if ii eq 2 then begin
            dblarr_xrange = [3.0,5.5]
            str_xtickformat = '(F5.1)'
          end
          i_xticks = 0
          dbl_rejectvaluex      = 10.
          dbl_rejectvaluexrange = 1.
          str_x = 'logg'
          dblarr_x_plot = dblarr_logg(indarr_x)
          if j eq i then begin
            dblarr_lines_in_diff_plot = dblarr(2,4)
            dblarr_lines_in_diff_plot(0,0:1) = [0.,dblarr_xrange(1)]
            dblarr_lines_in_diff_plot(0,2:3) = [0.,dblarr_xrange(0)-dblarr_xrange(1)]
            dblarr_lines_in_diff_plot(1,0:1) = [0.,5.]
            dblarr_lines_in_diff_plot(1,2:3) = [5.,0.]
          endif
        end else if i eq 2 then begin
          str_xtitle = '[m/H]!Dmax(STN)!N [dex]'
          dblarr_xrange = [-1.5,1.]
          i_xticks = 5
          str_xtickformat = '(I6)'
          dbl_rejectvaluex      = 99.
          dbl_rejectvaluexrange = 10.
          str_x = 'mH'
          dblarr_x_plot = dblarr_mh(indarr_x)
        end else if i eq 3 then begin
          str_xtitle = '[M/H]!Dmax(STN)!N [dex]'
          dblarr_xrange = [-1.5,1.]
          i_xticks = 5
          str_xtickformat = '(I6)'
          dbl_rejectvaluex      = 99.
          dbl_rejectvaluexrange = 10.
          str_x = 'MH'
          dblarr_x_plot = dblarr_mh_calibrated(indarr_x)
        end else if i eq 4 then begin
          str_xtitle = 'v!Drad, max(STN)!N [km/s]'
          dblarr_xrange = [-300.,300.]
          i_xticks = 4
          if ii eq 2 then begin
            dblarr_xrange = [-100.,100.]
          endif
          str_xtickformat = '(I6)'
          dbl_rejectvaluex      = -10000.
          dbl_rejectvaluexrange = 10.
          str_x = 'vrad'
          dblarr_x_plot = dblarr_vrad(indarr_x)
        end else begin
          str_xtitle = 'STN!Dmax(STN)!N [K]'
          dblarr_xrange = [0.,200.]
          i_xticks = 4
          str_xtickformat = '(I6)'
          dbl_rejectvaluex      = 0.0001
          dbl_rejectvaluexrange = 1.
          str_x = 'STN'
          dblarr_x_plot = dblarr_stn(indarr_x)
        endelse
        dblarr_position = [0.205,0.175,0.932,0.995]
        str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_'+str_y+'_vs_'+str_x
        if ii eq 1 then begin
          str_plotname_root = str_plotname_root + '_giants'
        end else if ii eq 2 then begin
          str_plotname_root = str_plotname_root + '_dwarfs'
        end
        compare_two_parameters, dblarr_x_plot,$
                                dblarr_y_plot,$
                                str_plotname_root,$
                                DBLARR_ERR_X             = replicate(0.,n_elements(indarr_x)),$
                                DBLARR_ERR_Y             = replicate(0.,n_elements(indarr_x)),$
                                DBLARR_RAVE_SNR          = dblarr_stn(indarr_y),$
                                STR_XTITLE               = str_xtitle,$
                                STR_YTITLE               = str_ytitle,$
                                STR_TITLE                = str_title,$
                                I_PSYM                   = 2,$
                                DBL_SYMSIZE              = 1,$
                                DBL_CHARSIZE             = 1.8,$
                                DBL_CHARTHICK            = 3.,$
                                DBL_THICK                = 3.,$
                                DBLARR_XRANGE            = dblarr_xrange,$
                                DBLARR_YRANGE            = dblarr_yrange,$
                                DBLARR_POSITION          = dblarr_position,$
                                DIFF_DBLARR_YRANGE       = dblarr_yrange,$
                                DIFF_DBLARR_POSITION     = dblarr_position,$
                                DIFF_STR_YTITLE          = str_ytitle,$
      ;                           I_B_DIFF_PLOT_Y_MINUS_X  = _b_diff_plot_y_minus_x,$
                                I_XTICKS                 = i_xticks,$
                                STR_XTICKFORMAT          = str_xtickformat,$
                                I_YTICKS                 = i_yticks,$
                                DBL_REJECTVALUEX         = dbl_rejectvaluex,$;             --- double
                                DBL_REJECTVALUE_X_RANGE  = dbl_rejectvalue_x_range,$;             --- double
      ;                           DBL_REJECTVALUEY         = dbl_rejectvaluey,$;             --- double
      ;                           DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                                STR_YTICKFORMAT          = str_ytickformat,$
                                B_PRINTPDF               = 1,$;               --- bool (0/1)
                                SIGMA_I_NBINS            = 30,$
                                SIGMA_I_MINELEMENTS      = 3,$
                                HIST_I_NBINSMIN          = 25,$;            --- int
                                HIST_I_NBINSMAX          = 30,$;            --- int
                                HIST_STR_XTITLE          = str_xtitle,$;            --- string
                                HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                                HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                                HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
      ;                           HIST_B_POP_ID            = 0,$;             --- bool
      ;                           HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                                HIST_DBLARR_XRANGE       = dblarr_xrange,$
                                HIST_DBLARR_POSITION     = dblarr_position,$;   --- dblarr
      ;                           HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                                O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
      ;                           DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
      ;                           DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
      ;                           DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
      ;                           I_DBLARR_YFIT                      = i_dblarr_yfit,$
                                B_PRINT_MOMENTS                    = 1,$
                                B_DO_SIGMA_CLIPPING                = 1,$
      ;                           I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
      ;                           I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                                B_DIFF_ONLY                        = 1,$; --- dblarr_y given as dblarr_x-<some_parameter>
                                I_DBLARR_LINES_IN_DIFF_PLOT = dblarr_lines_in_diff_plot
      endfor
    endfor
  endfor
;  set_plot,'ps'
;  device,filename=str_plotname_root+'.ps',/color
;  plot,dblarr_teff(indarr_x),$
;       dblarr_teff(indarr_y)-dblarr_teff(indarr_x),$
;       xtitle='T!Deff,max(STN)!N [K]',$
;       ytitle='(T!Deff,doubles!N - T!Deff,max(STN)!N) [K]',$
;       psym=2,$
;       symsize=0.4
;  device,/close
;  set_plot,'x'
end
