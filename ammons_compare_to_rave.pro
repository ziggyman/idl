pro ammons_compare_to_rave

  b_dwarfs_only = 0
  b_giants_only = 0
  b_calc_errors = 0

  for ii=0,1 do begin
    if ii eq 0 then begin
      b_dist = 0
    end else begin
      b_dist = 1
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

      str_datafile_chem = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_imag_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_IDenis2MASS.dat'

      str_datafile_ammons = '/home/azuri/daten/rave/ammons_tycho/all_rave.dat'
      str_datafile_ammons_dist = '/home/azuri/daten/rave/ammons_tycho/all_rave_dist.dat'

      i_ncols_ammons = countcols(str_datafile_ammons,DELIMITER=' ')
      print,'ammons_compare_to_rave: i_ncols_ammons = ',i_ncols_ammons

      if b_dwarfs_only then begin
        dbl_logg_min = 3.5
        dbl_logg_max = 10.
      endif
      if b_giants_only then begin
        dbl_logg_min = 0.
        dbl_logg_max = 3.5
      endif

      i_col_lon_ammons = 5
      i_col_lat_ammons = 6
      i_col_2massj_ammons = 52
      i_col_2massk_ammons = 54
      i_col_teff_ammons = 68
      i_col_eteff_ammons = 69
      i_col_feh_ammons = 72
      i_col_efeh_ammons = 73
      i_col_mh_ammons = 24
      i_col_dist_ammons = 70
      i_col_edist_ammons = 71

      i_col_snr = 35
      i_col_s2n = 34
      i_col_teff_rave = 19
      i_col_eteff_rave = 16
      i_col_logg_rave = 20
      i_col_elogg_rave = 17
      i_col_mh_rave = 21
      i_col_emh_rave = 18
      i_col_afe_rave = 22
      i_col_dist_yy = 74
      i_col_edist_yy = 75
      i_col_dist_dart = 76
      i_col_edist_dart = 77
      i_col_dist_padova = 78
      i_col_edist_padova = 79

    ; dbl_max_diff_deg = 0.001389; = 5 arcsec

      strarr_data = readfiletostrarr(str_datafile_ammons,' ')
      strarr_data_dist = readfiletostrarr(str_datafile_ammons_dist,' ')

;      print,'strarr_data_dist(*,i_col_dist_ammons) = ',strarr_data_dist(*,i_col_dist_ammons)
;      print,'strarr_data_dist(*,i_col_dist_yy) = ',strarr_data_dist(*,i_col_dist_yy)

      indarr_temp = where((double(strarr_data_dist(*,i_col_dist_yy)) lt 20.) and (double(strarr_data_dist(*,i_col_dist_dart)) lt 20.) and (double(strarr_data_dist(*,i_col_dist_padova)) lt 20.))
      strarr_data_dist = strarr_data_dist(indarr_temp,*)

    ;  dblarr_stn = double(strarr_data(*,i_col_snr))
    ;  indarr_stn = where(dblarr_stn lt 0.1)
    ;  strarr_data(indarr_stn,i_col_snr) = strarr_data(indarr_stn,i_col_s2n)
    ;  indarr_stn = 0
    ;  dblarr_stn = 0

      if b_dwarfs_only or b_giants_only then begin
        dblarr_logg = double(strarr_data(*,i_col_logg_rave))
        indarr = where(dblarr_logg gt dbl_logg_min and dblarr_logg lt dbl_logg_max)
        strarr_data = strarr_data(indarr,*)

        dblarr_logg = double(strarr_data_dist(*,i_col_logg_rave))
        indarr = where(dblarr_logg gt dbl_logg_min and dblarr_logg lt dbl_logg_max)
        strarr_data_dist = strarr_data_dist(indarr,*)

        indarr = 0
        dblarr_logg = 0
      endif
      dblarr_teff_rave = double(strarr_data(*,i_col_teff_rave))
    ;  dblarr_eteff_rave = double(strarr_data(*,i_col_eteff_rave))
      dblarr_logg_rave = double(strarr_data(*,i_col_logg_rave))
    ;  dblarr_elogg_rave = double(strarr_data(*,i_col_elogg_rave))
      dblarr_mh_rave = double(strarr_data(*,i_col_mh_rave))
    ;  dblarr_emh_rave = double(strarr_data(*,i_col_emh_rave))
      dblarr_aFe_rave = double(strarr_data(*,i_col_aFe_rave))

      dblarr_teff_ammons = double(strarr_data(*,i_col_teff_ammons))
    ;  dblarr_eteff_ammons = double(strarr_data(*,i_col_eteff_ammons))
    ;  dblarr_logg_ammons = double(strarr_data(*,i_col_logg_ammons))
    ;  dblarr_elogg_ammons = double(strarr_data(*,i_col_elogg_ammons))
      dblarr_feh_ammons = double(strarr_data(*,i_col_feh_ammons))
    ;  dblarr_efeh_ammons = double(strarr_data(*,i_col_efeh_ammons))

      besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh_ammons,$
                            O_DBLARR_MH                       = dblarr_mh_ammons,$ ; --- dblarr
                            I_B_MINE                          = 1,$
                            I_DBLARR_LOGG                     = dblarr_logg_rave
    ;  dblarr_mh_ammons = dblarr_feh_ammons
      strarr_data(*,i_col_mh_ammons) = strtrim(string(dblarr_mh_ammons),2)

      print,'strarr_data(0:100,i_col_feh_ammons) = ',strarr_data(0:100,i_col_feh_ammons)
      print,'strarr_data(0:100,i_col_mh_ammons) = ',strarr_data(0:100,i_col_mh_ammons)

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
      modifyct,ltab,'green-red',red,green,blue,file='colors1_ammons.tbl'

    ;  ; --- calculate RAVE errors
      if b_calc_errors then begin
        for pp = 0, 2 do begin
          if pp eq 0 then begin; --- Teff
    ;        dbl_divide_error_by = dbl_teff_divide_error_by
            b_teff = 1
            b_logg = 0
            b_mh = 0
            dbl_reject = 0.00001
          end else if pp eq 1 then begin; --- logg
    ;        dbl_divide_error_by = dbl_logg_divide_error_by
            b_teff = 0
            b_logg = 1
            b_mh = 0
            dbl_reject = 99.9
          end else begin; --- [M/H]
    ;        dbl_divide_error_by = dbl_mh_divide_error_by
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
                                    DBLARR_SNR = double(strarr_data(*,i_col_snr)),$; --- I: vector(n)
                                    DBLARR_TEFF  = double(strarr_data(*,i_col_teff_rave)),$;        --- vector(n)
                                    DBLARR_MH    = double(strarr_data(*,i_col_mh_rave)),$;          --- vector(n)
                                    DBLARR_LOGG  = double(strarr_data(*,i_col_logg_rave)),$;        --- vector(n)
                                    DBL_DIVIDE_ERROR_BY = 1.,$
                                    DBL_REJECT = dbl_reject,$
                                    B_REAL_ERR = 1;

          if pp eq 0 then begin; --- Teff
    ;      dblarr_teff_temp = o_dblarr_data
            strarr_data(*,i_col_eteff_rave) = strtrim(string(abs(o_dblarr_err)),2)
    ;        print,'ammons_compare_to_rave: eTeff_RAVE = ',dblarr_doubles(*,i_col_eteff_rave)
    ;      stop
          end else if pp eq 1 then begin; --- logg
    ;      dblarr_logg_temp = o_dblarr_data
            strarr_data(*,i_col_elogg_rave) = strtrim(string(abs(o_dblarr_err)),2)
    ;        print,'ammons_compare_to_rave: elogg_RAVE = ',dblarr_doubles(*,i_col_elogg_rave)
          end else begin; --- [M/H]
    ;      dblarr_mh_temp = o_dblarr_data
            strarr_data(*,i_col_emh_rave) = strtrim(string(abs(o_dblarr_err)),2)
    ;        print,'ammons_compare_to_rave: eMH_RAVE = ',dblarr_doubles(*,i_col_emh_rave)
          end
        endfor
        o_dblarr_err = 0
        o_dblarr_data = 0
      end else begin
        strarr_data(*,i_col_eteff_rave) = strtrim(string(0.),2)
        strarr_data(*,i_col_elogg_rave) = strtrim(string(0.),2)
        strarr_data(*,i_col_emh_rave) = strtrim(string(0.),2)
        strarr_data(*,i_col_eteff_ammons) = strtrim(string(0.),2)
        strarr_data(*,i_col_edist_ammons) = strtrim(string(0.),2)
        strarr_data(*,i_col_efeh_ammons) = strtrim(string(0.),2)

        strarr_data_dist(*,i_col_eteff_rave) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_elogg_rave) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_emh_rave) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_eteff_ammons) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_edist_ammons) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_edist_yy) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_edist_dart) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_edist_padova) = strtrim(string(0.),2)
        strarr_data_dist(*,i_col_efeh_ammons) = strtrim(string(0.),2)
      endelse
    ;;  print,'dblarr_doubles(0,*) = ',dblarr_doubles(0,*)
    ;;stop
    ;;  print,'ammons_compare_to_rave: '

    ;  openw,lun,str_datafile_new,/GET_LUN
    ;    printf,lun,'# RA DEC LON LAT I_RAVE Teff_RAVE eTeff_RAVE Teff_Pastel eTeff_Pastel logg_RAVE elogg_RAVE logg_Pastel elogg_Pastel M/H_RAVE eMH_RAVE M/H_Pastel eMH_Pastel Fe/H_Pastel alpha/Fe_RAVE SNR_RAVE'

    ;    for i=0,n_elements(dblarr_doubles(*,0))-1 do begin
    ;      str_temp = strtrim(string(dblarr_doubles(i,0)),2)
    ;      for k=1,n_elements(dblarr_doubles(i,*))-1 do begin
    ;        str_temp = str_temp + ' ' + strtrim(string(dblarr_doubles(i,k)),2)
    ;      endfor
    ;      printf,lun,str_temp
    ;    endfor
    ;  free_lun,lun
    ;;  stop

      ; --- plot results
      ; --- T_eff

      str_filename_plot = strmid(str_datafile_ammons,0,strpos(str_datafile_ammons,'/',/REVERSE_SEARCH))+'/rave/'
    ;  if b_chemical then begin
    ;    str_filename_plot = str_filename_plot+'/chemical/'
    ;  end else begin
    ;    str_filename_plot = str_filename_plot+'/rave/'
    ;  end
    ;  spawn,'mkdir '+str_filename_plot
      if b_giants_only then $
        str_filename_plot = str_filename_plot+'giants/'
      if b_dwarfs_only then $
        str_filename_plot = str_filename_plot+'dwarfs/'
      spawn,'mkdir '+str_filename_plot
      openw,lun,str_filename_plot+'index.html',/GET_LUN
      printf,lun,'<html><body><center>'

      i_loop_end = 5
    ;  if b_chemical then $
    ;    i_loop_end = 2

      for j=0, i_loop_end do begin
        set_plot,'ps'
        str_filename_plot = strmid(str_datafile_ammons,0,strpos(str_datafile_ammons,'/',/REVERSE_SEARCH))
        str_filename_plot = str_filename_plot+'/rave/'
        if b_giants_only then $
          str_filename_plot = str_filename_plot+'giants/'
        if b_dwarfs_only then $
          str_filename_plot = str_filename_plot+'dwarfs/'
        str_filename_plot = str_filename_plot+strmid(str_datafile_ammons,strpos(str_datafile_ammons,'/',/REVERSE_SEARCH)+1)
        str_filename_plot = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))
        if j eq 0 then begin; --- T_eff
          strarr_plot = strarr_data
          str_filename_plot = str_filename_plot + '_Teff-Ammons_vs_Teff-RAVE.ps'
          i_col_x = i_col_teff_rave
          i_col_y = i_col_teff_ammons
          i_col_ex = i_col_eteff_rave
          i_col_ey = i_col_eteff_ammons
          str_xtitle = 'T!Deff!N [K] (RAVE)'
          str_ytitle = 'T!Deff!N [K] (Ammons)'
          diff_str_ytitle = '(T!Deff,RAVE!N - T!Deff,Ammons!N) [K]'
          dblarr_xrange = [3000.,12200.]
          dblarr_yrange = [0.,12000.]
          diff_dblarr_yrange = [-5000.,5000.]
          if b_giants_only then begin
            dblarr_xrange = [3000.,8200.]
            dblarr_yrange = [0.,10000.]
            diff_dblarr_yrange = [-5000.,5000.]
          end else if b_dwarfs_only then begin
            dblarr_xrange = [3000.,8200.]
            dblarr_yrange = [0.,10000.]
            diff_dblarr_yrange = [-5000.,5000.]
          end
          dblarr_position = [0.205,0.175,0.932,0.995]
          dblarr_position_diff=[0.205,0.175,0.932,0.995]
          dblarr_position_hist=[0.205,0.175,0.932,0.995]
          i_xticks = 5
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_ammons = where(abs(double(strarr_data(*,i_col_teff_ammons))) gt 0.1)
          print,'ammons_compare_to_rave: Ammons: ',n_elements(indarr_ammons),' stars with T_eff'
          indarr_rave = where(abs(double(strarr_data(indarr_ammons,i_col_teff_rave))) gt 0.1)
          print,'ammons_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with T_eff'
          str_dim = 'K'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 0.000000001
          dbl_rejectvalueyrange = 0.00000001
          i_print_moments = 3
          if b_dwarfs_only then $
            i_print_moments = 1
        end else if j eq 1 then begin; --- [M/H] uncalibrated vs. [Fe/H]
          str_filename_plot = str_filename_plot+'FeH-Ammons_vs_mH-RAVE.ps'
          str_xtitle='[m/H] [dex] (RAVE)'
          str_ytitle='[Fe/H] [dex] (Ammons)'
          diff_str_ytitle = '([m/H]!DRAVE!N - [Fe/H]!DAmmons!N) [dex]'
          i_col_x = i_col_mh_rave
          i_col_y = i_col_feh_ammons
          i_col_ex = i_col_emh_rave
          i_col_ey = i_col_efeh_ammons
          dblarr_xrange = [-3.,1.]
          dblarr_yrange = [-3.,3.5]
          diff_dblarr_yrange = [-3.,3.]
;          dblarr_position = [0.205,0.175,0.932,0.995]
;          dblarr_position_diff=[0.205,0.175,0.932,0.995]
;          dblarr_position_hist=[0.205,0.175,0.932,0.995]
          i_xticks = 0
          str_xtickformat = '(I3)'
          str_ytickformat = '(I3)'
          indarr_ammons = where(abs(double(strarr_data(*,i_col_feh_ammons))) gt 0.0000001)
          print,'ammons_compare_to_rave: Pastel: ',n_elements(indarr_ammons),' stars with [Fe/H]'
          indarr_rave = where(abs(double(strarr_data(indarr_ammons,i_col_mh_rave)) - 99.9) gt 10.)
          print,'ammons_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with [Fe/H]'
          str_dim = 'dex'
          dbl_rejectvaluex      = 0.000000001
          dbl_rejectvaluexrange = 0.00000001
          dbl_rejectvaluey      = 99.9
          dbl_rejectvalueyrange = 10.
          i_print_moments = 1
        end else if j eq 2 then begin; --- [M/H] DR2 calibration vs. [M/H]
          str_filename_plot = str_filename_plot+'_MH-Ammons_vs_MH-DR3-RAVE.ps'
          i_col_x = i_col_mh_rave
          i_col_y = i_col_mh_ammons
          i_col_ex = i_col_emh_rave
          i_col_ey = i_col_efeh_ammons
          str_xtitle='[M/H] [dex] (RAVE)'
          str_ytitle='[M/H] [dex] (Ammons)'
          diff_str_ytitle = '([M/H]!DRAVE!N - [M/H]!DAmmons!N) [dex]'
          dblarr_mh_rave_uncalibrated = double(strarr_data(*,i_col_mh_rave))
          rave_calibrate_metallicities,dblarr_mh_rave_uncalibrated,$
                                      double(strarr_data(*,i_col_aFe_rave)),$
                                      DBLARR_TEFF=double(strarr_data(*,i_col_teff_rave)),$; --- new calibration
                                      DBLARR_LOGG=double(strarr_data(*,i_col_logg_rave)),$; --- old calibration
                                      DBLARR_STN=double(strarr_data(*,i_col_snr)),$; --- old calibration
                                      REJECTVALUE=99.9,$
                                      REJECTERR=1.,$
                                      OUTPUT=output
          strarr_data(*,i_col_mh_rave) = strtrim(string(output),2)
          i_print_moments = 1
        end else if j eq 3 then begin; --- dist
          strarr_plot = strarr_data_dist
          strarr_plot(*,i_col_dist_ammons) = strtrim(string(double(strarr_plot(*,i_col_dist_ammons)) / 1000.),2)
          str_filename_plot = str_filename_plot + '_dist-Ammons_vs_dist-YY.ps'
          i_col_x = i_col_dist_ammons
          i_col_y = i_col_dist_yy
          i_col_ex = i_col_edist_ammons
          i_col_ey = i_col_edist_yy
          str_xtitle = 'dist [kpc] (YY)'
          str_ytitle = 'dist [kpc] (Ammons)'
          diff_str_ytitle = '(dist!DYY!N - dist!DAmmons!N) [kpc]'
          dblarr_xrange = [0.,10.]
          dblarr_yrange = [0.,10.]
          diff_dblarr_yrange = [-5.,5.]
          if b_giants_only then begin
            dblarr_xrange = [0.,12.]
            dblarr_yrange = [0.,12.]
            diff_dblarr_yrange = [-5.,5.]
          end else if b_dwarfs_only then begin
            dblarr_xrange = [0.,1.]
            dblarr_yrange = [0.,1.]
            diff_dblarr_yrange = [-0.5,0.5]
          end
          dblarr_position = [0.205,0.175,0.932,0.995]
          dblarr_position_diff=[0.205,0.175,0.932,0.995]
          dblarr_position_hist=[0.205,0.175,0.932,0.995]
          i_xticks = 5
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          indarr_ammons = where(abs(double(strarr_data_dist(*,i_col_dist_ammons))) gt 0.0000001)
          print,'ammons_compare_to_rave: Ammons: ',n_elements(indarr_ammons),' stars with dist'
          indarr_rave = where(abs(double(strarr_data_dist(indarr_ammons,i_col_dist_yy))) gt 0.0000001)
          print,'ammons_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with dist'
          str_dim = 'kpc'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 0.000001
          dbl_rejectvalueyrange = 0.00001
          i_print_moments = 3
        end else if j eq 4 then begin; --- dist dart
          strarr_plot = strarr_data_dist
          strarr_plot(*,i_col_dist_ammons) = strtrim(string(double(strarr_plot(*,i_col_dist_ammons)) / 1000.),2)
          str_filename_plot = str_filename_plot + '_dist-Ammons_vs_dist-dart.ps'
          i_col_x = i_col_dist_ammons
          i_col_y = i_col_dist_dart
          i_col_ex = i_col_edist_ammons
          i_col_ey = i_col_edist_dart
          str_xtitle = 'dist [kpc] (Dartmouth)'
          str_ytitle = 'dist [kpc] (Ammons)'
          diff_str_ytitle = '(dist!DDart!N - dist!DAmmons!N) [kpc]'
          dblarr_xrange = [0.,10.]
          dblarr_yrange = [0.,10.]
          diff_dblarr_yrange = [-5.,5.]
          if b_giants_only then begin
            dblarr_xrange = [0.,12.]
            dblarr_yrange = [0.,12.]
            diff_dblarr_yrange = [-5.,5.]
          end else if b_dwarfs_only then begin
            dblarr_xrange = [0.,1.]
            dblarr_yrange = [0.,1.]
            diff_dblarr_yrange = [-0.5,0.5]
          end
          dblarr_position = [0.205,0.175,0.932,0.995]
          dblarr_position_diff=[0.205,0.175,0.932,0.995]
          dblarr_position_hist=[0.205,0.175,0.932,0.995]
          i_xticks = 5
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          indarr_ammons = where(abs(double(strarr_data_dist(*,i_col_dist_ammons))) gt 0.0000001)
          print,'ammons_compare_to_rave: Ammons: ',n_elements(indarr_ammons),' stars with dist'
          indarr_rave = where(abs(double(strarr_data_dist(indarr_ammons,i_col_dist_dart))) gt 0.0000001)
          print,'ammons_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with dist'
          str_dim = 'kpc'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 0.000001
          dbl_rejectvalueyrange = 0.00001
          i_print_moments = 3
        end else if j eq 5 then begin; --- dist Padova
          strarr_plot = strarr_data_dist
          strarr_plot(*,i_col_dist_ammons) = strtrim(string(double(strarr_plot(*,i_col_dist_ammons)) / 1000.),2)
          str_filename_plot = str_filename_plot + '_dist-Ammons_vs_dist-padova.ps'
          i_col_x = i_col_dist_ammons
          i_col_y = i_col_dist_padova
          i_col_ex = i_col_edist_ammons
          i_col_ey = i_col_edist_padova
          str_xtitle = 'dist [kpc] (Padova)'
          str_ytitle = 'dist [kpc] (Ammons)'
          diff_str_ytitle = '(dist!DPadova!N - dist!DAmmons!N) [kpc]'
          dblarr_xrange = [0.,10.]
          dblarr_yrange = [0.,10.]
          diff_dblarr_yrange = [-5.,5.]
          if b_giants_only then begin
            dblarr_xrange = [0.,12.]
            dblarr_yrange = [0.,12.]
            diff_dblarr_yrange = [-5.,5.]
          end else if b_dwarfs_only then begin
            dblarr_xrange = [0.,1.]
            dblarr_yrange = [0.,1.]
            diff_dblarr_yrange = [-0.5,0.5]
          end
          dblarr_position = [0.205,0.175,0.932,0.995]
          dblarr_position_diff=[0.205,0.175,0.932,0.995]
          dblarr_position_hist=[0.205,0.175,0.932,0.995]
          i_xticks = 5
          str_xtickformat = '(F4.1)'
          str_ytickformat = '(F4.1)'
          indarr_ammons = where(abs(double(strarr_data_dist(*,i_col_dist_ammons))) gt 0.0000001)
          print,'ammons_compare_to_rave: Ammons: ',n_elements(indarr_ammons),' stars with dist'
          indarr_rave = where(abs(double(strarr_data_dist(indarr_ammons,i_col_dist_padova))) gt 0.0000001)
          print,'ammons_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with dist'
          str_dim = 'kpc'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 0.000001
          dbl_rejectvalueyrange = 0.00001
          i_print_moments = 3
        end

        indarr = lindgen(n_elements(indarr_rave))

        str_filename_plot_root = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))

        compare_two_parameters,double(strarr_plot(indarr_ammons(indarr_rave(indarr)),i_col_x)),$
                              double(strarr_plot(indarr_ammons(indarr_rave(indarr)),i_col_y)),$
                              str_filename_plot_root,$
                              DBLARR_ERR_X             = double(strarr_plot(indarr_ammons(indarr_rave(indarr)), i_col_ex)),$
                              DBLARR_ERR_Y             = double(strarr_plot(indarr_ammons(indarr_rave(indarr)), i_col_ey)),$
                              DBLARR_RAVE_SNR          = double(strarr_plot(indarr_ammons(indarr_rave(indarr)), i_col_snr)),$
                              STR_XTITLE               = str_xtitle,$
                              STR_YTITLE               = str_ytitle,$
                              STR_TITLE                = str_title,$
                              I_PSYM                   = 7,$
                              DBL_SYMSIZE              = 0.3,$
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
                              SIGMA_I_NBINS            = 50,$
                              SIGMA_I_MINELEMENTS      = 5,$
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
                              I_DO_SIGMA_CLIPPING      = 3

        printf,lun,'<h2>'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'</h2><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
        printf,lun,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br><br><hr><br>'
    ;if j eq 1 then stop
        reduce_pdf_size,str_filename_plot_root+'.pdf',str_filename_plot_root+'_small.pdf'
        reduce_pdf_size,str_filename_plot_root+'_diff.pdf',str_filename_plot_root+'_diff_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'


      endfor
      printf,lun,'</center></body></html>'
      free_lun,lun
    endfor
  endfor
end
