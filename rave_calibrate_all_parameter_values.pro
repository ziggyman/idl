pro rave_calibrate_all_parameter_values

  str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_calib.dat'

  int_col_teff = 19
  int_col_logg = 20
  int_col_mh   = 21
  int_col_afe  = 22
  int_col_s2n  = 34
  int_col_stn  = 35

  ; --- teff
  ; --- STN, Teff < 7000 K, STN, Teff < 7000 K
  ; --- giants calibrated from Teff < 5000, valid for Teff < 7000
  str_filename_calib_dteff_vs_stn_a = '/home/azuri/daten/rave/rave_data/release8/calib_Teff_STN_20sigma-bins_calib1'
  str_filename_calib_dteff_vs_stn_b = '/home/azuri/daten/rave/rave_data/release8/calib_Teff_STN_20sigma-bins_calib2'
  str_filename_calib_dteff_vs_stn_c = '/home/azuri/daten/rave/rave_data/release8/calib_Teff_STN_20sigma-bins_calib3'

  str_filename_calib_dteff_vs_mh = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dTeff_vs_MH_1';'/home/azuri/daten/rave/rave_data/release8/calib_Teff_STN_20sigma-bins_calib2'

  str_filename_calib_dteff_vs_teff_a = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_teff_1';coeffs_calib_teff_1_giants-lt5000
  str_filename_calib_dteff_vs_teff_b = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_teff_2';coeffs_calib_teff_2_giants-lt5000
  str_filename_calib_dteff_vs_teff_c = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_teff_2';coeffs_calib_teff_2_giants-lt5000

  ; --- logg
  str_filename_calib_dlogg_vs_stn_a = '/home/azuri/daten/rave/rave_data/release8/calib_logg_STN_20sigma-bins_calib1'
  str_filename_calib_dlogg_vs_stn_b = '/home/azuri/daten/rave/rave_data/release8/calib_logg_STN_20sigma-bins_calib2'
  str_filename_calib_dlogg_vs_stn_c = '/home/azuri/daten/rave/rave_data/release8/calib_logg_STN_20sigma-bins_calib3'

  str_filename_calib_dlogg_vs_dteff = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_dlogg_vs_dteff'
  str_filename_calib_dlogg_vs_mh = '/home/azuri/daten/rave/rave_data/release8/calib_logg_MH_20sigma-bins'

  ; --- mh
  str_filename_calib_dmh_vs_stn_a = '/home/azuri/daten/rave/rave_data/release8/calib_MH_STN_20sigma-bins_calib1'
  str_filename_calib_dmh_vs_stn_b = '/home/azuri/daten/rave/rave_data/release8/calib_MH_STN_20sigma-bins_calib2'
  str_filename_calib_dmh_vs_stn_c = '/home/azuri/daten/rave/rave_data/release8/calib_MH_STN_20sigma-bins_calib3'

  str_filename_calib_dmh_vs_mh = '/home/azuri/daten/rave/rave_data/release8/coeffs_calib_MH_1'

  str_filename_calib_dlogg_vs_mh = '/home/azuri/daten/rave/rave_data/release8/calib_logg_MH_20sigma-bins'

  strarr_data = readfiletostrarr(str_filename_in,' ',HEADER=strarr_header)

  dblarr_teff_orig = double(strarr_data(*,int_col_teff))
  dblarr_logg_orig = double(strarr_data(*,int_col_logg))
  dblarr_mh_orig = double(strarr_data(*,int_col_mh))
  dblarr_afe_orig = double(strarr_data(*,int_col_afe))
  dblarr_s2n_orig = double(strarr_data(*,int_col_s2n))
  dblarr_stn_orig = double(strarr_data(*,int_col_stn))
  indarr = where(dblarr_stn_orig lt 1.)
  if indarr(0) ge 0 then $
    dblarr_stn_orig(indarr) = dblarr_s2n_orig(indarr)

  dblarr_teff = dblarr(n_elements(dblarr_teff_orig))
  dblarr_logg = dblarr(n_elements(dblarr_teff_orig))
  dblarr_mh = dblarr(n_elements(dblarr_teff_orig))

  indarr_giants = where(dblarr_logg_orig lt 3.5, COMPLEMENT = indarr_dwarfs)

  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh_orig,$
                               I_DBLARR_AFE           = dblarr_afe_orig,$
                               I_DBLARR_TEFF          = dblarr_teff_orig,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_logg_orig,$; --- old calibration
                               I_DBLARR_STN           = dblarr_stn_orig,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = strarr_mh_rave_calibrated,$;           --- string array
                               I_DBL_REJECTVALUE      = 9.99,$; --- double
                               I_DBL_REJECTERR        = 1.,$;       --- double
                               I_B_SEPARATE           = 1
  dblarr_mh_orig = double(strarr_mh_rave_calibrated)

  for i=0,1 do begin
    if i eq 0 then begin
      b_dwarfs_only = 1
      b_giants_only = 0
      str_suffix = '_dwarfs.dat'
      indarr_logg = indarr_dwarfs
    end else begin
      b_dwarfs_only = 0
      b_giants_only = 1
      str_suffix = '_giants.dat'
      indarr_logg = indarr_giants
    endelse
    dblarr_teff = dblarr_teff_orig(indarr_logg)
    dblarr_logg = dblarr_logg_orig(indarr_logg)
    dblarr_mh = dblarr_mh_orig(indarr_logg)
    dblarr_stn = dblarr_stn_orig(indarr_logg)

    ; --- T_eff
    for j=0,1 do begin
      if j eq 0 then begin
        str_filename_calib = str_filename_calib_dteff_vs_stn_a + str_suffix
      end else begin
        str_filename_calib = str_filename_calib_dteff_vs_stn_b + str_suffix
      endelse

      ; --- dTeff vs STN
      rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                      IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                      I_DBLARR_X                 = dblarr_stn

      if b_dwarfs_only then begin
        if j eq 0 then begin
          str_filename_calib = str_filename_calib_dteff_vs_teff_a + str_suffix
        end else begin
          str_filename_calib = str_filename_calib_dteff_vs_teff_b + str_suffix
        endelse
      end else begin
        if j eq 0 then begin
          str_filename_calib = str_filename_calib_dteff_vs_teff_a + '_giants-lt5000.dat'
        end else begin
          str_filename_calib = str_filename_calib_dteff_vs_teff_b + '_giants-lt5000.dat'
        endelse
      endelse

      ; --- dTeff vs Teff-ext
      dblarr_coeffs = double(readfiletostrarr(str_filename_calib,' '))
      indarr_lt_7000 = where(dblarr_teff lt 7000.)
      dblarr_teff_old = dblarr_teff(indarr_lt_7000)
      i_fit_order_teff_vs_teff = n_elements(dblarr_coeffs)
      if i_fit_order_teff_vs_teff eq 2 then begin
        dblarr_teff_new = (dblarr_teff_old - dblarr_coeffs(0)) / dblarr_coeffs(1)
      end else if i_fit_order_teff_vs_teff eq 3 then begin
        dblarr_sqrt = sqrt((dblarr_teff_old / dblarr_coeffs(2)) + ((dblarr_coeffs(1)^2.) / (4. * (dblarr_coeffs(2)^2.))) - (dblarr_coeffs(0) / dblarr_coeffs(2)))
        print,'dblarr_sqrt = ',dblarr_sqrt
        dbl_test = (dblarr_coeffs(1) / (2. * dblarr_coeffs(2)))
        print,'dbl_test = ',dbl_test
        dblarr_teff_new = dblarr_sqrt + dbl_test
        if max(dblarr_teff_new) lt 0. then $
          dblarr_teff_new = 0. - (dblarr_sqrt + dbl_test)
        if min(dblarr_teff_new) gt 15000. then $
          dblarr_teff_new = dblarr_sqrt - dbl_test
      endif
      print,'dblarr_teff_new = ',dblarr_teff_new
      dblarr_teff(indarr_lt_7000) = dblarr_teff_new

    endfor

    ; --- log g
    ; --- calibrate logg from dlogg vs dteff
    dblarr_coeffs_dlogg_vs_dteff = double(readfiletostrarr(str_filename_calib_dlogg_vs_dteff + str_suffix,' '))
    dblarr_logg_old  = dblarr_logg
    dblarr_dteff = dblarr_teff_orig(indarr_logg) - dblarr_teff
    dblarr_logg_new = dblarr_logg_old - dblarr_coeffs_dlogg_vs_dteff(1) * dblarr_dteff - dblarr_coeffs_dlogg_vs_dteff(0)
    dblarr_logg = dblarr_logg_new

    ; --- dlogg vs STN
    str_filename_calib = str_filename_calib_dlogg_vs_stn_a + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                    I_DBLARR_X                 = dblarr_stn

    ; --- dlogg vs STN
    str_filename_calib = str_filename_calib_dlogg_vs_stn_b + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                    I_DBLARR_X                 = dblarr_stn

    ; --- [M/H]
    ; --- dMH vs STN
    str_filename_calib = str_filename_calib_dmh_vs_stn_a + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_mh,$
                                    I_DBLARR_X                 = dblarr_stn

    ; --- dMH vs MH-ext
    ;dblarr_coeffs_dmh_vs_mh = double(readfiletostrarr(str_filename_calib_dmh_vs_mh,' '))

    ; --- dTeff vs MH-ext
    dblarr_coeffs_dteff_vs_mh = double(readfiletostrarr(str_filename_calib_dteff_vs_mh + str_suffix,' '))
    dblarr_teff_old = dblarr_teff
    dblarr_teff_new = dblarr_teff_old + dblarr_mh * dblarr_coeffs_dteff_vs_mh(1) + dblarr_coeffs_dteff_vs_mh(0)
    dblarr_teff = dblarr_teff_new

    ; --- dTeff vs STN
    str_filename_calib = str_filename_calib_dteff_vs_stn_c + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_teff,$
                                    I_DBLARR_X                 = dblarr_stn

    if b_dwarfs_only then begin
      str_filename_calib = str_filename_calib_dteff_vs_teff_c + str_suffix
    end else begin
      str_filename_calib = str_filename_calib_dteff_vs_teff_c + '_giants-lt5000.dat'
    endelse

    ; --- dTeff vs Teff-ext
    dblarr_coeffs = double(readfiletostrarr(str_filename_calib,' '))
    indarr_lt_7000 = where(dblarr_teff lt 7000.)
    dblarr_teff_old = dblarr_teff(indarr_lt_7000)
    i_fit_order_teff_vs_teff = n_elements(dblarr_coeffs)
    if i_fit_order_teff_vs_teff eq 2 then begin
      dblarr_teff_new = (dblarr_teff_old - dblarr_coeffs(0)) / dblarr_coeffs(1)
    end else if i_fit_order_teff_vs_teff eq 3 then begin
      dblarr_sqrt = sqrt((dblarr_teff_old / dblarr_coeffs(2)) + ((dblarr_coeffs(1)^2.) / (4. * (dblarr_coeffs(2)^2.))) - (dblarr_coeffs(0) / dblarr_coeffs(2)))
      print,'dblarr_sqrt = ',dblarr_sqrt
      dbl_test = (dblarr_coeffs(1) / (2. * dblarr_coeffs(2)))
      print,'dbl_test = ',dbl_test
      dblarr_teff_new = dblarr_sqrt + dbl_test
      if max(dblarr_teff_new) lt 0. then $
        dblarr_teff_new = 0. - (dblarr_sqrt + dbl_test)
      if min(dblarr_teff_new) gt 15000. then $
        dblarr_teff_new = dblarr_sqrt - dbl_test
    endif
    print,'dblarr_teff_new = ',dblarr_teff_new
    dblarr_teff(indarr_lt_7000) = dblarr_teff_new

    ; --- dlogg vs [M/H]
    str_filename_calib = str_filename_calib_dlogg_vs_mh + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                    I_DBLARR_X                 = dblarr_mh

    ; --- dlogg vs STN
    str_filename_calib = str_filename_calib_dlogg_vs_stn_c + str_suffix
    rave_calibrate_parameter_values,I_STR_FILENAME_CALIB       = str_filename_calib,$
                                    IO_DBLARR_PARAMETER_VALUES = dblarr_logg,$
                                    I_DBLARR_X                 = dblarr_stn

    dblarr_teff_orig(indarr_logg) = dblarr_teff
    dblarr_logg_orig(indarr_logg) = dblarr_logg
    dblarr_mh_orig(indarr_logg) = dblarr_mh
  endfor

  ; --- write out file
  openw,lun,str_filename_out,/GET_LUN
    if n_elements(strarr_header) gt 0 then begin
      for i=0ul, n_elements(strarr_header) - 1 do begin
        printf,lun,strarr_header(i)
      endfor
    endif
    for i=0ul, n_elements(dblarr_teff)-1 do begin
      str_print = strarr_data(i,0)
      for j=1,n_elements(strarr_data(0,*))-1 do begin
        if j eq int_col_teff then begin
          str_print = str_print + ' ' + strtrim(string(dblarr_teff(i)),2)
        end else if j eq int_col_logg then begin
          str_print = str_print + ' ' + strtrim(string(dblarr_logg(i)),2)
        end else if j eq int_col_mh then begin
          str_print = str_print + ' ' + strtrim(string(dblarr_mh(i)),2)
        end else begin
          str_print = str_print + ' ' + strarr_data(i,j)
        endelse
      endfor
      printf,lun,str_print
    endfor
  free_lun,lun

end
