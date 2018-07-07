pro abundances_compare_to_external

  b_chemical = 1
  b_snr_gt_thirteen = 0
  b_dwarfs_only = 0
  b_giants_only = 0
  b_calc_errors = 1

  b_mh = 0

  str_datafile_ext = '/home/azuri/daten/rave/calibration/all_found.dat'

  for jjj = 0,1 do begin
    if jjj eq 0 then begin
      b_mh = 0
    end else begin
      b_mh = 1
    end
    for ii=0,1 do begin
      if ii eq 0 then begin
        b_chemical = 0
      end else begin
        b_chemical = 1
      endelse
      for jj=0,2 do begin
        if jj eq 0 then begin
          b_dwarfs_only = 0
          b_giants_only = 0
        end else if jj eq 1 then begin
          b_dwarfs_only = 1
          b_giants_only = 0
        end else begin
          b_dwarfs_only = 0
          b_giants_only = 1
        end

        strarr_data_ext = readfiletostrarr(str_datafile_ext,' ')

        str_datafile_rave = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_frac_gt_70.dat'

        if b_dwarfs_only then begin
          dbl_logg_min = 3.5
          dbl_logg_max = 6.
        endif
        if b_giants_only then begin
          dbl_logg_min = 0.
          dbl_logg_max = 3.5
        endif

        i_col_lon_rave = 5
        i_col_lat_rave = 6
        i_col_i_rave = 14
        i_col_snr_rave = 33
        i_col_stn_rave = 35
        i_col_teff_rave = 70
        i_col_logg_rave = 71
        i_col_feh_rave = 68
        if b_mh then $
          i_col_feh_rave = 72
        i_col_aFe_rave = 73

        i_col_lon_ext = 0
        i_col_lat_ext = 1
        i_col_feh_ext = 8
        i_col_efeh_ext = 9
        i_col_bool_feh_ext = 10
        i_col_source_ext = 20

        dbl_max_diff_deg = 0.001389; = 5 arcsec

        if b_calc_errors then begin
          dbl_teff_divide_error_by = 1.
          dbl_logg_divide_error_by = 1.
          dbl_mh_divide_error_by = 1.
        endif

        strarr_data_rave = readfiletostrarr(str_datafile_rave,' ')

        dblarr_snr_rave = double(strarr_data_rave(*,i_col_snr_rave))
        dblarr_stn_rave = double(strarr_data_rave(*,i_col_stn_rave))
        indarr_stn = where(abs(dblarr_stn_rave) lt 0.001)
        if indarr_stn(0) ge 0 then begin
          dblarr_stn_rave(indarr_stn) = dblarr_snr_rave(indarr_stn)
        endif
        dblarr_snr_rave = dblarr_stn_rave
        dblarr_stn_rave = 0
        if b_snr_gt_thirteen then begin
          indarr = where(dblarr_snr_rave gt 13.)
          dblarr_snr_rave = dblarr_snr_rave(indarr)
          strarr_data_rave = strarr_data_rave(indarr,*)
        endif

        if b_dwarfs_only or b_giants_only then begin
          dblarr_logg = double(strarr_data_rave(*,i_col_logg_rave))
          indarr = where(dblarr_logg gt dbl_logg_min and dblarr_logg le dbl_logg_max)
          strarr_data_rave = strarr_data_rave(indarr,*)
          dblarr_snr_rave = dblarr_snr_rave(indarr)
          dblarr_logg = 0
          indarr = 0
        endif
        dblarr_lon_rave = double(strarr_data_rave(*,i_col_lon_rave))
        dblarr_lat_rave = double(strarr_data_rave(*,i_col_lat_rave))
        dblarr_i_rave = double(strarr_data_rave(*,i_col_i_rave))
        dblarr_teff_rave = double(strarr_data_rave(*,i_col_teff_rave))
        dblarr_logg_rave = double(strarr_data_rave(*,i_col_logg_rave))
        dblarr_feh_rave = double(strarr_data_rave(*,i_col_feh_rave))
  ;      dblarr_mh_rave = double(strarr_data_rave(*,i_col_mh_rave))
        dblarr_aFe_rave = double(strarr_data_rave(*,i_col_aFe_rave))

        ;---  i_col_lon_ext = 0
        ;---  i_col_lat_ext = 1
        ;---  i_col_feh_ext = 8
        ;---  i_col_efeh_ext = 9
        ;---  i_col_bool_feh_ext = 10
  ;      dblarr_mh_ext = double(strarr_data_ext(*,i_col_feh_ext))
        intarr_bool_feh_ext = long(strarr_data_ext(*,i_col_bool_feh_ext))
        dblarr_feh_ext = double(strarr_data_ext(*,i_col_feh_ext))
        int_test = 1
        if b_mh then $
          int_test = 0
        indarr_feh = where((intarr_bool_feh_ext eq int_test) and (abs(dblarr_feh_ext) ge 0.00000001),COMPLEMENT=indarr_mh)
  ;      dblarr_mh_ext = dblarr_mh_ext(indarr_mh)
  ;      indarr_mh = where(abs(dblarr_mh_ext) ge 0.00000001)
  ;      dblarr_mh_ext = dblarr_mh_ext(indarr_mh)
        print,'n_elements(indarr_feh) = ',n_elements(indarr_feh)
  ;      stop
        strarr_data_ext = strarr_data_ext(indarr_feh,*)

        dblarr_lon_ext = double(strarr_data_ext(*,i_col_lon_ext))
        dblarr_lat_ext = double(strarr_data_ext(*,i_col_lat_ext))
        dblarr_feh_ext = double(strarr_data_ext(*,i_col_feh_ext))
        dblarr_efeh_ext = double(strarr_data_ext(*,i_col_efeh_ext))
        intarr_source_ext = long(strarr_data_ext(*,i_col_source_ext))

        dblarr_doubles = dblarr(n_elements(dblarr_lon_rave),9)
        i_col_lon = 0
        ; --- 0: LON
        i_col_lat = 1
        ; --- 1: LAT
        i_col_i_rave = 2
        ; --- 2: I
        i_col_feh_rave = 3
        ; --- 3: Fe/H RAVE
        i_col_efeh_rave = 4
        ; --- 4: eFe/H RAVE
        i_col_feh_ext = 5
        ; --- 5: Fe/H ext
        i_col_efeh_ext = 6
        ; --- 6: eFe/H ext
        i_col_snr_rave = 7
        ; --- 7: SNR_RAVE
        i_col_source_ext = 8
        ; --- 8: source


        i_nstars = 0
        str_datafile_new = strmid(str_datafile_rave,0,strpos(str_datafile_rave,'.',/REVERSE_SEARCH))
        str_datafile_new = str_datafile_new+'_abundances';_SNR_gt_20.dat'
        if b_snr_gt_thirteen then begin
          str_datafile_new = str_datafile_new+'_SNR_gt_13'
        endif
        if b_mh then $
          str_datafile_new = str_datafile_new+'_MH'
        if b_dwarfs_only then begin
          str_datafile_new = str_datafile_new+'_dwarfs'
        end else if b_giants_only then begin
          str_datafile_new = str_datafile_new+'_giants'
        end
        str_datafile_new = str_datafile_new+'.dat'
        for i=0ul, n_elements(dblarr_lon_rave)-1 do begin
          indarr_lon = where(abs(dblarr_lon_ext - dblarr_lon_rave(i)) lt (2. * dbl_max_diff_deg), count)
          if count gt 0 then begin
            indarr_lat = where(abs(dblarr_lat_ext(indarr_lon) - dblarr_lat_rave(i)) lt (2. * dbl_max_diff_deg), count)
            if count gt 0 then begin
              indarr_efeh_nzero = where(abs(dblarr_efeh_ext(indarr_lon(indarr_lat))) gt 0.00000001)
              if indarr_efeh_nzero(0) ne -1 then begin
                dbl_emin_feh = min(dblarr_efeh_ext(indarr_lon(indarr_lat(indarr_efeh_nzero))))
                indarr_feh = where(abs(dblarr_efeh_ext(indarr_lon(indarr_lat(indarr_efeh_nzero))) - dbl_emin_feh) lt 0.001)
              endif

      ;        for j=0,n_elements(indarr_lat)-1 do begin
              dblarr_doubles(i_nstars,i_col_lon) = dblarr_lon_rave(i)
              dblarr_doubles(i_nstars,i_col_lat) = dblarr_lat_rave(i)
              dblarr_doubles(i_nstars,i_col_i_rave) = dblarr_i_rave(i)

              ; --- for multiple observations calculate weighted mean
              ; --- [Fe/H] / [M/H]
              dblarr_doubles(i_nstars,i_col_feh_rave) = dblarr_feh_rave(i)
              if indarr_efeh_nzero(0) ne -1 then begin
                if n_elements(indarr_efeh_nzero) gt 1 then begin
                  dbl_fac = 0.
                  for we=0,n_elements(indarr_efeh_nzero)-1 do begin
                    dbl_fac = dbl_fac + (1. / dblarr_efeh_ext(indarr_lon(indarr_lat(indarr_efeh_nzero(we)))))
                  endfor
                  dbl_fac = 1. / dbl_fac
                  dblarr_doubles(i_nstars,i_col_feh_ext) = 0.
                  for we=0,n_elements(indarr_efeh_nzero)-1 do begin
                    dblarr_doubles(i_nstars,i_col_feh_ext) = dblarr_doubles(i_nstars,i_col_feh_ext) + dblarr_feh_ext(indarr_lon(indarr_lat(indarr_efeh_nzero(we)))) * dbl_fac / dblarr_efeh_ext(indarr_lon(indarr_lat(indarr_efeh_nzero(we))))
                  endfor
                end else begin
                  dblarr_doubles(i_nstars,i_col_feh_ext) = dblarr_feh_ext(indarr_lon(indarr_lat(indarr_feh(0))))
                  dblarr_doubles(i_nstars,i_col_efeh_ext) = dblarr_efeh_ext(indarr_lon(indarr_lat(indarr_feh(0))))
                end
              end else begin
                if n_elements(indarr_lat) gt 1 then begin
                  dblarr_moment = moment(dblarr_feh_ext(indarr_lon(indarr_lat)))
                  dblarr_doubles(i_nstars,i_col_feh_ext) = dblarr_moment(0)
                  dblarr_doubles(i_nstars,i_col_efeh_ext) = sqrt(dblarr_moment(1))
                end else begin
                  dblarr_doubles(i_nstars,i_col_feh_ext) = dblarr_feh_ext(indarr_lon(indarr_lat(0)))
                  dblarr_doubles(i_nstars,i_col_efeh_ext) = 0.
                end
              end
              dblarr_doubles(i_nstars,i_col_snr_rave) = dblarr_snr_rave(i)
              dblarr_doubles(i_nstars,i_col_source_ext) = intarr_source_ext(indarr_lon(indarr_lat(0)))
              i_nstars = i_nstars + 1
      ;        endfor
      ;        stop
            end;if n_elements(indarr_lat) gt 0
          end;if n_elements(indarr_lon) gt 0
        end;for i=0ul, n_elements(dblarr_lon_rave)-1 do begin
        dblarr_doubles = dblarr_doubles(0:i_nstars-1,*)

        indarr = where(dblarr_doubles(*,i_col_feh_rave) gt -9.,COMPLEMENT=indarr_comp)
        if (indarr_comp(0) ge 0) then begin
          print,'dblarr_doubles(indarr_comp) = ',dblarr_doubles(indarr_comp,*)
          dblarr_doubles = dblarr_doubles(indarr,*)
  ;        stop
        endif
        print,'min rave = ',min(dblarr_doubles(*,i_col_feh_rave))
        print,'max rave = ',max(dblarr_doubles(*,i_col_feh_rave))
        print,'min ext = ',min(dblarr_doubles(*,i_col_feh_ext))
        print,'max ext = ',max(dblarr_doubles(*,i_col_feh_ext))
  ;      stop

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
        modifyct,ltab,'green-red',red,green,blue,file='colors1_ext.tbl'

        ; --- calculate RAVE errors
  ;      if b_calc_errors then begin
  ;        for pp = 0, 2 do begin
  ;          if pp eq 0 then begin; --- Teff
  ;            dbl_divide_error_by = dbl_teff_divide_error_by
  ;            b_teff = 1
  ;            b_logg = 0
  ;            b_mh = 0
  ;            dbl_reject = 0.00001
  ;          end else if pp eq 1 then begin; --- logg
  ;            dbl_divide_error_by = dbl_logg_divide_error_by
  ;            b_teff = 0
  ;            b_logg = 1
  ;            b_mh = 0
  ;            dbl_reject = 99.9
  ;          end else begin; --- [M/H]
  ;            dbl_divide_error_by = dbl_mh_divide_error_by
  ;            b_teff = 0
  ;            b_logg = 0
  ;            b_mh = 1
  ;            dbl_reject = 99.9
  ;          end
  ;          o_dblarr_data = 1
  ;
  ;          o_dblarr_err = 1
  ;          rave_besancon_calc_errors,B_TEFF = b_teff,$
  ;                                    B_LOGG = b_logg,$
  ;                                    B_MH = b_mh,$
  ;                                    O_DBLARR_DATA  = o_dblarr_data,$;        --- vector(n)
  ;                                    O_DBLARR_ERR = o_dblarr_err,$;       --- vector(n)
  ;                                    DBLARR_SNR = dblarr_doubles(*,i_col_snr_rave),$; --- I: vector(n)
  ;                                    DBLARR_TEFF  = dblarr_doubles(*,i_col_teff_rave),$;        --- vector(n)
  ;                                    DBLARR_MH    = dblarr_doubles(*,i_col_mh_rave),$;          --- vector(n)
  ;                                    DBLARR_LOGG  = dblarr_doubles(*,i_col_logg_rave),$;        --- vector(n)
  ;                                    DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$
  ;                                    DBL_REJECT = dbl_reject,$
  ;                                    B_REAL_ERR = 1
  ;
  ;          if pp eq 0 then begin; --- Teff
  ;    ;      dblarr_teff_temp = o_dblarr_data
  ;            dblarr_doubles(*,i_col_eteff_rave) = abs(o_dblarr_err)
  ;            print,'ext_compare_to_rave: eTeff_RAVE = ',dblarr_doubles(*,i_col_eteff_rave)
  ;    ;      stop
  ;          end else if pp eq 1 then begin; --- logg
  ;    ;      dblarr_logg_temp = o_dblarr_data
  ;            dblarr_doubles(*,i_col_elogg_rave) = abs(o_dblarr_err)
  ;            print,'ext_compare_to_rave: elogg_RAVE = ',dblarr_doubles(*,i_col_elogg_rave)
  ;          end else begin; --- [M/H]
  ;    ;      dblarr_mh_temp = o_dblarr_data
  ;            dblarr_doubles(*,i_col_emh_rave) = abs(o_dblarr_err)
  ;            print,'ext_compare_to_rave: eMH_RAVE = ',dblarr_doubles(*,i_col_emh_rave)
  ;          end
  ;        endfor
  ;        o_dblarr_err = 0
  ;        o_dblarr_data = 0
  ;      endif

        openw,lun,str_datafile_new,/GET_LUN
          printf,lun,'# LON LAT I_RAVE Fe/H_RAVE eFeH_RAVE Fe/H_ext eFe/H_ext SNR_RAVE source'

          for i=0,n_elements(dblarr_doubles(*,0))-1 do begin
            str_temp = strtrim(string(dblarr_doubles(i,0)),2)
            for k=1,n_elements(dblarr_doubles(i,*))-1 do begin
              str_temp = str_temp + ' ' + strtrim(string(dblarr_doubles(i,k)),2)
            endfor
            printf,lun,str_temp
          endfor
        free_lun,lun
      ;  stop
        ; --- plot results
        ; --- T_eff

        str_filename_plot = strmid(str_datafile_new,0,strpos(str_datafile_new,'/',/REVERSE_SEARCH)+1)
        str_filename_plot = str_filename_plot + 'abundances/'
        spawn,'mkdir '+str_filename_plot
        if b_giants_only then $
          str_filename_plot = str_filename_plot+'giants/'
        if b_dwarfs_only then $
          str_filename_plot = str_filename_plot+'dwarfs/'
        spawn,'mkdir '+str_filename_plot
        openw,lun,str_filename_plot+'index.html',/GET_LUN
        printf,lun,'<html><body><center>'

  ;      i_loop_end = 1

  ;      for j=0, i_loop_end do begin
        set_plot,'ps'
        str_filename_plot = strmid(str_datafile_new,0,strpos(str_datafile_new,'/',/REVERSE_SEARCH)+1)
        str_filename_plot = str_filename_plot + 'abundances/'
        if b_giants_only then begin
          str_filename_plot = str_filename_plot+'giants/'
        endif
        if b_dwarfs_only then $
          str_filename_plot = str_filename_plot+'dwarfs/'
        str_filename_plot = str_filename_plot+strmid(str_datafile_new,strpos(str_datafile_new,'/',/REVERSE_SEARCH)+1)
        str_filename_plot = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))
        i_print_moments = 1
        if b_giants_only then $
          i_print_moments = 3
        if b_mh then begin
          str_filename_plot = str_filename_plot+'_MH_vs_MH.ps'
          str_xtitle='[M/H]!Dext!N [dex]'
          str_ytitle='[M/H]!Dchem!N [dex]'
          diff_str_ytitle = '([M/H]!Dext!N - [M/H]!Dchem!N) [dex]'
        end else begin
          str_filename_plot = str_filename_plot+'_FeH_vs_FeH.ps'
          str_xtitle='[Fe/H]!Dext!N [dex]'
          str_ytitle='[Fe/H]!Dchem!N [dex]'
          diff_str_ytitle = '([Fe/H]!Dext!N - [Fe/H]!Dchem!N) [dex]'
        endelse
        i_col_x = i_col_feh_ext
        i_col_y = i_col_feh_rave
        i_col_ex = i_col_efeh_ext
        i_col_ey = i_col_efeh_rave
        i_col_symbol = i_col_source_ext
  ;          indarr_ext = where(abs(dblarr_doubles(*,i_col_feh_ext)) gt 0.0000001)
  ;          print,'ext_compare_to_rave: Pastel: ',n_elements(indarr_ext),' stars with [Fe/H]'
  ;          print,'ext_compare_to_rave: dblarr_doubles(indarr_ext,i_col_feh_ext) = ',dblarr_doubles(indarr_ext,i_col_feh_ext)
  ;          print,'ext_compare_to_rave: dblarr_doubles(indarr_ext,i_col_efeh_ext) = ',dblarr_doubles(indarr_ext,i_col_efeh_ext)
  ;          indarr_rave = where(abs(dblarr_doubles(*,i_col_mh_rave) - 99.9) gt 0.1)
  ;          print,'ext_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with [Fe/H]'
        dblarr_xrange=[-3.,1.1]
        dblarr_yrange=[-3.,1.0]
        diff_dblarr_yrange = [-2.5,2.5]
  ;      dblarr_position=[0.17,0.16,0.935,0.995]
  ;      dblarr_position_diff=[0.17,0.16,0.998,0.995]
  ;      dblarr_position_hist=[0.135,0.175,0.998,0.995]
        dblarr_position=[0.17,0.175,0.932,0.98]
        dblarr_position_diff=[0.17,0.175,0.932,0.98]
        dblarr_position_hist=[0.17,0.175,0.932,0.98]
        str_dim = 'dex'
        i_xticks = 0
        str_xtickformat = '(I3)'
        str_ytickformat = '(I3)'
        dbl_rejectvaluex      = 0.000000001
        dbl_rejectvaluexrange = 0.00000001
        dbl_rejectvaluey      = 99.9
        dbl_rejectvalueyrange = 10.
  ;    if j ne 9 then $
  ;          indarr = lindgen(n_elements(indarr_rave))

        dblarr_error = dblarr_doubles(*,i_col_x) -$
                      dblarr_doubles(*,i_col_y)
        dblarr_error = dblarr_error * dblarr_error
        dbl_sigma = sqrt(total(dblarr_error) / n_elements(dblarr_error))
        print,'ext_compare_to_rave: dbl_sigma = ',dbl_sigma
        str_title = 'sigma = '+strmid(strtrim(string(dbl_sigma),2),0,6)+' '+str_dim


        str_filename_plot_root = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))

        compare_two_parameters,dblarr_doubles(*,i_col_x),$
                              dblarr_doubles(*,i_col_y),$
                              str_filename_plot_root,$
                              DBLARR_ERR_X             = dblarr_doubles(*, i_col_ex),$
                              DBLARR_ERR_Y             = dblarr_doubles(*, i_col_ey),$
                              DBLARR_RAVE_SNR          = dblarr_doubles(*, i_col_snr_rave),$
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
                              DIFF_STR_YTITLE          = diff_str_ytitle,$
    ;                           I_XTICKS                 = i_xticks,$
                              STR_XTICKFORMAT          = str_xtickformat,$
    ;                           I_YTICKS                 = i_yticks,$
                              DBL_REJECTVALUEX         = dbl_rejectvaluex,$;             --- double
                              DBL_REJECTVALUE_X_RANGE  = dbl_rejectvaluexrange,$;             --- double
                              DBL_REJECTVALUEY         = dbl_rejectvaluey,$;             --- double
                              DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalueyrange,$;             --- double
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
                              B_PRINT_MOMENTS          = i_print_moments,$
                              I_DO_SIGMA_CLIPPING      = 1,$
                              I_INTARR_SYMBOLS         = intarr_symbols

        printf,lun,'<h2>'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'</h2><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
        printf,lun,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br><br><hr><br>'
    ;if j eq 1 then stop
        reduce_pdf_size,str_filename_plot_root+'.pdf',str_filename_plot_root+'_small.pdf'
        reduce_pdf_size,str_filename_plot_root+'_diff.pdf',str_filename_plot_root+'_diff_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'


  ;      endfor
        printf,lun,'</center></body></html>'
        free_lun,lun
      endfor
    endfor
  endfor
end
