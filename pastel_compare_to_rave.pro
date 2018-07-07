pro pastel_compare_to_rave

  b_chemical = 0
  b_snr_gt_thirteen = 0
  b_dwarfs_only = 0
  b_giants_only = 0
  b_calc_errors = 1

  str_datafile_ext = '/home/azuri/daten/rave/calibration/all_found.dat'
  strarr_ext = readfiletostrarr(str_datafile_ext,' ')

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

      if b_chemical then begin
        str_datafile_rave = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_imag_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_IDenis2MASS.dat'
      end else begin
        str_datafile_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_STN-gt-20-with-atm-par.dat';_SNR_gt_20.dat'
    ;    if b_snr_gt_thirteen then $
    ;      str_datafile_rave = strmid(str_datafile_rave,0,strpos(str_datafile_rave,'all',/REVERSE_SEARCH))+'stn_gt_20_no_doubles_maxsnr.dat'
      end

      str_datafile_pastel = '/home/azuri/daten/pastel/asu.tsv'

      i_ncols_pastel = countcols(str_datafile_pastel,DELIMITER=';')
      print,'pastel_compare_to_rave: i_ncols_pastel = ',i_ncols_pastel

      if b_dwarfs_only then begin
        dbl_logg_min = 3.5
        dbl_logg_max = 6.
      endif
      if b_giants_only then begin
        dbl_logg_min = 0.
        dbl_logg_max = 3.5
      endif

      i_col_ra_rave = 3
      i_col_dec_rave = 4
      i_col_lon_rave = 5
      i_col_lat_rave = 6
      i_col_i_rave = 14
      i_col_snr_rave = 33
      i_col_stn_rave = 35
      if b_chemical then begin
        i_col_teff_rave = 70
        i_col_logg_rave = 71
        i_col_mh_rave = 68
        i_col_aFe_rave = 73
      end else begin
        i_col_teff_rave = 19
        i_col_logg_rave = 20
        i_col_mh_rave = 21
        i_col_aFe_rave = 22
      end

      i_col_ra_pastel = 2
      i_col_dec_pastel = 3
    ;  i_col_i_pastel = 6
      i_col_teff_pastel = 11
      i_col_eteff_pastel = 12
      i_col_logg_pastel = 13
      i_col_elogg_pastel = 14
      i_col_feh_pastel = 15
      i_col_efeh_pastel = 17
      if b_chemical then begin
        i_col_lon_ext = 0
        i_col_lat_ext = 1
        i_col_feh_ext = 8
        i_col_efeh_ext = 9
        i_col_bool_feh_ext = 10
      endif

      dbl_max_diff_deg = 0.001389; = 5 arcsec

      if b_calc_errors then begin
        dbl_teff_divide_error_by = 1.
        dbl_logg_divide_error_by = 1.
        dbl_mh_divide_error_by = 1.
      endif

      strarr_data_rave = readfiletostrarr(str_datafile_rave,' ')
      strarr_data_pastel = readfiletostrarr(str_datafile_pastel,';')
      print,'pastel_compare_to_rave: strarr_data_pastel(0:10,i_col_ra_pastel) = ',strarr_data_pastel(0:10,i_col_ra_pastel)
    ;  stop

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
      dblarr_ra_rave = double(strarr_data_rave(*,i_col_ra_rave))
      dblarr_dec_rave = double(strarr_data_rave(*,i_col_dec_rave))
      dblarr_lon_rave = double(strarr_data_rave(*,i_col_lon_rave))
      dblarr_lat_rave = double(strarr_data_rave(*,i_col_lat_rave))
      dblarr_i_rave = double(strarr_data_rave(*,i_col_i_rave))
      dblarr_teff_rave = double(strarr_data_rave(*,i_col_teff_rave))
      dblarr_logg_rave = double(strarr_data_rave(*,i_col_logg_rave))
      dblarr_mh_rave = double(strarr_data_rave(*,i_col_mh_rave))
      dblarr_aFe_rave = double(strarr_data_rave(*,i_col_aFe_rave))

;      if b_dwarfs_only or b_giants_only then begin
;        dblarr_logg = double(strarr_data_pastel(*,i_col_logg_pastel))
;        indarr = where(dblarr_logg gt dbl_logg_min and dblarr_logg lt dbl_logg_max)
;        strarr_data_pastel = strarr_data_pastel(indarr,*)
;        dblarr_logg = 0
;      endif
      dblarr_ra_pastel = double(strarr_data_pastel(*,i_col_ra_pastel))
      dblarr_dec_pastel = double(strarr_data_pastel(*,i_col_dec_pastel))
    ;  dblarr_i_pastel = double(strarr_data_pastel(*,i_col_i_pastel))
      dblarr_teff_pastel = double(strarr_data_pastel(*,i_col_teff_pastel))
      dblarr_eteff_pastel = double(strarr_data_pastel(*,i_col_eteff_pastel))
      dblarr_logg_pastel = double(strarr_data_pastel(*,i_col_logg_pastel))
      dblarr_elogg_pastel = double(strarr_data_pastel(*,i_col_elogg_pastel))
      dblarr_feh_pastel = double(strarr_data_pastel(*,i_col_feh_pastel))
      dblarr_efeh_pastel = double(strarr_data_pastel(*,i_col_efeh_pastel))

    ;  indarr_temp = where(strarr_data_pastel(*,i_col_efeh_pastel) eq '')
    ;  print,'pastel_compare_to_rave: strarr_data_pastel(indarr_temp,i_col_efeh_pastel) = ',strarr_data_pastel(indarr_temp,i_col_efeh_pastel)
    ;  print,'pastel_compare_to_rave: dblarr_efeh_pastel(indarr_temp) = ',dblarr_efeh_pastel(indarr_temp)
    ;  stop

      if not b_chemical then begin
        ; --- calculate Pastel [M/H] from [Fe/H] using my new transformation - set I_B_MINE to 0 for Zwitters trafo
        besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh_pastel,$
                              O_DBLARR_MH                       = dblarr_mh_pastel;,$ ; --- dblarr
;                              I_B_MINE                          = 0,$
;                              I_DBLARR_LOGG                     = dblarr_logg_pastel
      end else begin
        dblarr_mh_pastel = dblarr_feh_pastel
      end

      print,'pastel_compare_to_rave: dblarr_ra_rave(0:20) = ',dblarr_ra_rave(0:20)
      print,'pastel_compare_to_rave: dblarr_dec_rave(0:20) = ',dblarr_dec_rave(0:20)
      print,'pastel_compare_to_rave: dblarr_ra_pastel(0:20) = ',dblarr_ra_pastel(0:20)
      print,'pastel_compare_to_rave: dblarr_dec_pastel(0:20) = ',dblarr_dec_pastel(0:20)

    ;stop

    ;  indarr_ra = where(abs(dblarr_ra_pastel) lt 0.00001)
    ;  print,'pastel_compare_to_rave: indarr_ra = ',indarr_ra
    ;  print,'pastel_compare_to_rave: dblarr_ra_pastel(indarr_ra) = ',dblarr_ra_pastel(indarr_ra)
    ;  print,'pastel_compare_to_rave: strarr_data_pastel(indarr_ra,1) = ',strarr_data_pastel(indarr_ra,1)

    ;  indarr_dec = where(abs(dblarr_dec_pastel) lt 0.00001)
    ;  print,'pastel_compare_to_rave: indarr_dec = ',indarr_dec
    ;  print,'pastel_compare_to_rave: dblarr_dec_pastel(indarr_dec) = ',dblarr_dec_pastel(indarr_dec)
    ;  print,'pastel_compare_to_rave: strarr_data_pastel(indarr_dec,1) = ',strarr_data_pastel(indarr_dec,1)
    ;  stop

      dblarr_doubles = dblarr(n_elements(dblarr_ra_rave),20)
      i_col_ra = 0
      ; --- 0: RA
      i_col_dec = 1
      ; --- 1: DEC
      i_col_lon = 2
      ; --- 2: LON
      i_col_lat = 3
      ; --- 3: LAT
      i_col_i = 4
      ; --- 4: I
    ;  i_col_i_pastel = 5
      ; --- 5: I_Pastel
      i_col_teff_rave = 5
      ; --- 5: Teff_RAVE
      i_col_eteff_rave = 6
      ; --- 6: eTeff_RAVE
      i_col_teff_pastel = 7
      ; --- 7: Teff_Pastel
      i_col_eteff_pastel = 8
      ; --- 8: eTeff_Pastel
      i_col_logg_rave = 9
      ; --- 9: logg_RAVE
      i_col_elogg_rave = 10
      ; --- 10: elogg_RAVE
      i_col_logg_pastel = 11
      ; --- 11: logg_Pastel
      i_col_elogg_pastel = 12
      ; --- 12: elogg_Pastel
      i_col_mh_rave = 13
      ; --- 13: M/H_RAVE
      i_col_emh_rave = 14
      ; --- 14: eM/H_RAVE
      i_col_mh_pastel = 15
      ;i_col_feh_pastel = 15
      ; --- 15: M/H_Pastel
      i_col_emh_pastel = 16
      i_col_efeh_pastel = 16
      ; --- 16: eM/H_Pastel
      i_col_feh_pastel = 17
      ; --- 17: Fe/H_Pastel
      i_col_afe_rave = 18
      ; --- 18: alpha/Fe_RAVE
      i_col_snr_rave = 19
      ; --- 19: SNR_RAVE


      i_nstars = 0
      if b_chemical then begin
        str_datafile_new = strmid(str_datafile_pastel,0,strpos(str_datafile_pastel,'.',/REVERSE_SEARCH))+'_abundances.dat';_SNR_gt_20.dat'
      end else begin
        str_datafile_new = strmid(str_datafile_pastel,0,strpos(str_datafile_pastel,'.',/REVERSE_SEARCH))+'_RAVE.dat';_SNR_gt_20.dat'
      end
      if b_snr_gt_thirteen then begin
        str_datafile_new = strmid(str_datafile_new,0,strpos(str_datafile_new,'.',/REVERSE_SEARCH))+'_SNR_gt_13'+strmid(str_datafile_new,strpos(str_datafile_new,'.',/REVERSE_SEARCH))
      endif
      if b_dwarfs_only then begin
        str_datafile_new = strmid(str_datafile_new,0,strpos(str_datafile_new,'.',/REVERSE_SEARCH))+'_dwarfs.dat'
      endif
      if b_giants_only then begin
        str_datafile_new = strmid(str_datafile_new,0,strpos(str_datafile_new,'.',/REVERSE_SEARCH))+'_giants.dat'
      endif
      for i=0ul, n_elements(dblarr_ra_rave)-1 do begin
        indarr_ra = where(abs(dblarr_ra_pastel - dblarr_ra_rave(i)) lt dbl_max_diff_deg, count)
        if count gt 0 then begin
          indarr_dec = where(abs(dblarr_dec_pastel(indarr_ra) - dblarr_dec_rave(i)) lt dbl_max_diff_deg, count)
          if count gt 0 then begin
            print,'pastel_compare_to_rave: found RAVE star (i=',i,') with RA = dblarr_ra_rave(i) = ',dblarr_ra_rave(i),', dblarr_ra_pastel(indarr_ra) = ',dblarr_ra_pastel(indarr_ra(indarr_dec))
            print,'pastel_compare_to_rave: found RAVE star (i=',i,') with DEC = dblarr_dec_rave(i) = ',dblarr_dec_rave(i),', dblarr_dec_pastel(indarr_ra(indarr_dec)) = ',dblarr_dec_pastel(indarr_ra(indarr_dec))

            indarr_eteff_nzero = where(abs(dblarr_eteff_pastel(indarr_ra(indarr_dec))) gt 0.000001)
            if indarr_eteff_nzero(0) ne -1 then begin
              dbl_emin_teff = min(dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero))))
              indarr_teff = where(abs(dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero))) - dbl_emin_teff) lt 0.1)
            endif

            indarr_elogg_nzero = where(abs(dblarr_elogg_pastel(indarr_ra(indarr_dec))) gt 0.00000001)
            if indarr_elogg_nzero(0) ne -1 then begin
              dbl_emin_logg = min(dblarr_elogg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero))))
              indarr_logg = where(abs(dblarr_elogg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero))) - dbl_emin_logg) lt 0.001)
            endif

            indarr_efeh_nzero = where(abs(dblarr_efeh_pastel(indarr_ra(indarr_dec))) gt 0.00000001)
            if indarr_efeh_nzero(0) ne -1 then begin
              dbl_emin_feh = min(dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero))))
              indarr_feh = where(abs(dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero))) - dbl_emin_feh) lt 0.001)
            endif

    ;        for j=0,n_elements(indarr_dec)-1 do begin
            dblarr_doubles(i_nstars,i_col_ra) = dblarr_ra_rave(i)
            dblarr_doubles(i_nstars,i_col_dec) = dblarr_dec_rave(i)
            dblarr_doubles(i_nstars,i_col_lon) = dblarr_lon_rave(i)
            dblarr_doubles(i_nstars,i_col_lat) = dblarr_lat_rave(i)
            dblarr_doubles(i_nstars,i_col_i_rave) = dblarr_i_rave(i)
    ;          dblarr_doubles(i_nstars,i_col_i_pastel) = dblarr_i_pastel(indarr_ra(indarr_dec(0)))

            ; --- for multiple observations calculate weighted mean
            ; --- T_eff
            dblarr_doubles(i_nstars,i_col_teff_rave) = dblarr_teff_rave(i)
            ;dblarr_doubles(i_nstars,i_col_eteff_rave) = dblarr_teff_rave(i)
            if indarr_eteff_nzero(0) ne -1 then begin
              ;print,'indarr_eteff_nzero(0) ne -1'
              if n_elements(indarr_eteff_nzero) gt 1 then begin
                ;print,'n_elements(indarr_eteff_nzero) = ',n_elements(indarr_eteff_nzero),' gt 1'
                ;print,'dblarr_teff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero))) = ',dblarr_teff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero)))
                dbl_fac = 0.
                for we=0,n_elements(indarr_eteff_nzero)-1 do begin
                  dbl_fac = dbl_fac + (1. / dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we)))))
                  ;print,'we = ',we,': dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we)))) = ',dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we))))
                  ;print,'we = ',we,': dbl_fac set to ',dbl_fac
                endfor
                dbl_fac = 1. / dbl_fac
                dblarr_doubles(i_nstars,i_col_teff_pastel) = 0.
                dblarr_doubles(i_nstars,i_col_eteff_pastel) = 0.
                for we=0,n_elements(indarr_eteff_nzero)-1 do begin
                  dblarr_doubles(i_nstars,i_col_teff_pastel) = dblarr_doubles(i_nstars,i_col_teff_pastel) + dblarr_teff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we)))) * dbl_fac / dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we))))
                  dblarr_doubles(i_nstars,i_col_eteff_pastel) = dblarr_doubles(i_nstars,i_col_eteff_pastel) + dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we)))) * dbl_fac / dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(we))))
                  ;print,'we = ',we,': dblarr_doubles(i_nstars,i_col_teff_pastel) set to ',dblarr_doubles(i_nstars,i_col_teff_pastel)
                endfor
              end else begin
                ;print,'n_elements(indarr_eteff_nzero) = ',n_elements(indarr_eteff_nzero),' eq 1'
                dblarr_doubles(i_nstars,i_col_teff_pastel) = dblarr_teff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(indarr_teff(0)))))
                dblarr_doubles(i_nstars,i_col_eteff_pastel) = dblarr_eteff_pastel(indarr_ra(indarr_dec(indarr_eteff_nzero(indarr_teff(0)))))
              end
            end else begin
              ;print,'indarr_eteff_nzero(0) eq -1'
              if n_elements(indarr_dec) gt 1 then begin
                ;print,'n_elements(indarr_dec) = ',n_elements(indarr_dec),' gt 1'
                dblarr_moment = moment(dblarr_teff_pastel(indarr_ra(indarr_dec)))
                dblarr_doubles(i_nstars,i_col_teff_pastel) = dblarr_moment(0)
                dblarr_doubles(i_nstars,i_col_eteff_pastel) = sqrt(dblarr_moment(1))
              end else begin
                ;print,'n_elements(indarr_dec) = ',n_elements(indarr_dec),' eq 1'
                dblarr_doubles(i_nstars,i_col_teff_pastel) = dblarr_teff_pastel(indarr_ra(indarr_dec(0)))
                dblarr_doubles(i_nstars,i_col_eteff_pastel) = 0.
              end
            end


    ;print,'dblarr_doubles(0,*) = ',dblarr_doubles(0,*)
    ;stop

            ; --- log g
            dblarr_doubles(i_nstars,i_col_logg_rave) = dblarr_logg_rave(i)
            ;dblarr_doubles(i_nstars,i_col_elogg_rave) = dblarr_logg_rave(i)
            if indarr_elogg_nzero(0) ne -1 then begin
              if n_elements(indarr_elogg_nzero) gt 1 then begin
                dbl_fac = 0.
                for we=0,n_elements(indarr_elogg_nzero)-1 do begin
                  dbl_fac = dbl_fac + (1. / dblarr_elogg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero(we)))))
                endfor
                dbl_fac = 1. / dbl_fac
                dblarr_doubles(i_nstars,i_col_logg_pastel) = 0.
                for we=0,n_elements(indarr_elogg_nzero)-1 do begin
                  dblarr_doubles(i_nstars,i_col_logg_pastel) = dblarr_doubles(i_nstars,i_col_logg_pastel) + dblarr_logg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero(we)))) * dbl_fac / dblarr_elogg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero(we))))
                endfor
              end else begin
                dblarr_doubles(i_nstars,i_col_logg_pastel) = dblarr_logg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero(indarr_logg(0)))))
                dblarr_doubles(i_nstars,i_col_elogg_pastel) = dblarr_elogg_pastel(indarr_ra(indarr_dec(indarr_elogg_nzero(indarr_logg(0)))))
              end
            end else begin
              if n_elements(indarr_dec) gt 1 then begin
                dblarr_moment = moment(dblarr_logg_pastel(indarr_ra(indarr_dec)))
                dblarr_doubles(i_nstars,i_col_logg_pastel) = dblarr_moment(0)
                dblarr_doubles(i_nstars,i_col_elogg_pastel) = sqrt(dblarr_moment(1))
              end else begin
                dblarr_doubles(i_nstars,i_col_logg_pastel) = dblarr_logg_pastel(indarr_ra(indarr_dec(0)))
                dblarr_doubles(i_nstars,i_col_elogg_pastel) = 0.
              end
            end

            ; --- [Fe/H] / [M/H]
            dblarr_doubles(i_nstars,i_col_mh_rave) = dblarr_mh_rave(i)
              ;dblarr_doubles(i_nstars,i_col_emh_rave) = dblarr_mh_rave(i)
            if indarr_efeh_nzero(0) ne -1 then begin
              if n_elements(indarr_efeh_nzero) gt 1 then begin
                dbl_fac = 0.
                for we=0,n_elements(indarr_efeh_nzero)-1 do begin
                  dbl_fac = dbl_fac + (1. / dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(we)))))
                endfor
                dbl_fac = 1. / dbl_fac
                dblarr_doubles(i_nstars,i_col_feh_pastel) = 0.
                dblarr_doubles(i_nstars,i_col_mh_pastel) = 0.
                for we=0,n_elements(indarr_efeh_nzero)-1 do begin
                  dblarr_doubles(i_nstars,i_col_feh_pastel) = dblarr_doubles(i_nstars,i_col_feh_pastel) + dblarr_feh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(we)))) * dbl_fac / dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(we))))

                  dblarr_doubles(i_nstars,i_col_mh_pastel) = dblarr_doubles(i_nstars,i_col_mh_pastel) + dblarr_mh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(we)))) * dbl_fac / dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(we))))
                endfor
              end else begin
                dblarr_doubles(i_nstars,i_col_feh_pastel) = dblarr_feh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(indarr_feh(0)))))
                dblarr_doubles(i_nstars,i_col_mh_pastel) = dblarr_mh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(indarr_feh(0)))))
                dblarr_doubles(i_nstars,i_col_efeh_pastel) = dblarr_efeh_pastel(indarr_ra(indarr_dec(indarr_efeh_nzero(indarr_feh(0)))))
              end
            end else begin
              if n_elements(indarr_ra(indarr_dec)) gt 1 then begin
                dblarr_moment = moment(dblarr_feh_pastel(indarr_ra(indarr_dec)))
                dblarr_doubles(i_nstars,i_col_feh_pastel) = dblarr_moment(0)
                dblarr_doubles(i_nstars,i_col_efeh_pastel) = sqrt(dblarr_moment(1))

                dblarr_moment = moment(dblarr_mh_pastel(indarr_ra(indarr_dec)))
                dblarr_doubles(i_nstars,i_col_mh_pastel) = dblarr_moment(0)
              end else begin
                dblarr_doubles(i_nstars,i_col_feh_pastel) = dblarr_feh_pastel(indarr_ra(indarr_dec(0)))
                dblarr_doubles(i_nstars,i_col_mh_pastel) = dblarr_feh_pastel(indarr_ra(indarr_dec(0)))
                dblarr_doubles(i_nstars,i_col_efeh_pastel) = 0.
              end
            end
            dblarr_doubles(i_nstars,i_col_aFe_rave) = dblarr_aFe_rave(i)
            dblarr_doubles(i_nstars,i_col_snr_rave) = dblarr_snr_rave(i)
            i_nstars = i_nstars + 1
    ;        endfor
    ;        stop
          end;if n_elements(indarr_dec) gt 0
        end;if n_elements(indarr_ra) gt 0
      end;for i=0ul, n_elements(dblarr_ra_rave)-1 do begin
      dblarr_doubles = dblarr_doubles(0:i_nstars-1,*)

      if b_chemical then begin
        indarr = where(abs(dblarr_doubles(*,i_col_mh_rave) - dblarr_doubles(*,i_col_feh_pastel)) lt 3.,COMPLEMENT=indarr_comp)
        if (indarr_comp(0) ge 0) then begin
          print,'dblarr_doubles(indarr_comp) = ',dblarr_doubles(indarr_comp,*)
          dblarr_doubles = dblarr_doubles(indarr,*)
        endif
      endif

    ;  i_col_teff_rave = 6
    ;  i_col_teff_pastel = 7
    ;  i_col_logg_rave = 8
    ;  i_col_logg_pastel = 9
    ;  i_col_mh_rave = 10
    ;  i_col_mh_pastel = 11
    ;  i_col_feh_pastel = 12
    ;  i_col_aFe_rave = 13
    ;  i_col_snr_rave = 14

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
      modifyct,ltab,'green-red',red,green,blue,file='colors1_pastel.tbl'

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
                                    DBLARR_SNR = dblarr_doubles(*,i_col_snr_rave),$; --- I: vector(n)
                                    DBLARR_TEFF  = dblarr_doubles(*,i_col_teff_rave),$;        --- vector(n)
                                    DBLARR_MH    = dblarr_doubles(*,i_col_mh_rave),$;          --- vector(n)
                                    DBLARR_LOGG  = dblarr_doubles(*,i_col_logg_rave),$;        --- vector(n)
                                    DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$
                                    DBL_REJECT = dbl_reject,$
                                    B_REAL_ERR = 1

          if pp eq 0 then begin; --- Teff
    ;      dblarr_teff_temp = o_dblarr_data
            dblarr_doubles(*,i_col_eteff_rave) = abs(o_dblarr_err)
            print,'pastel_compare_to_rave: eTeff_RAVE = ',dblarr_doubles(*,i_col_eteff_rave)
    ;      stop
          end else if pp eq 1 then begin; --- logg
    ;      dblarr_logg_temp = o_dblarr_data
            dblarr_doubles(*,i_col_elogg_rave) = abs(o_dblarr_err)
            print,'pastel_compare_to_rave: elogg_RAVE = ',dblarr_doubles(*,i_col_elogg_rave)
          end else begin; --- [M/H]
    ;      dblarr_mh_temp = o_dblarr_data
            dblarr_doubles(*,i_col_emh_rave) = abs(o_dblarr_err)
            print,'pastel_compare_to_rave: eMH_RAVE = ',dblarr_doubles(*,i_col_emh_rave)
          end
        endfor
        o_dblarr_err = 0
        o_dblarr_data = 0
      endif
    ;  print,'dblarr_doubles(0,*) = ',dblarr_doubles(0,*)
    ;stop
    ;  print,'pastel_compare_to_rave: '

      openw,lun,str_datafile_new,/GET_LUN
        printf,lun,'# RA DEC LON LAT I_RAVE Teff_RAVE eTeff_RAVE Teff_Pastel eTeff_Pastel logg_RAVE elogg_RAVE logg_Pastel elogg_Pastel M/H_RAVE eMH_RAVE M/H_Pastel eMH_Pastel Fe/H_Pastel alpha/Fe_RAVE SNR_RAVE'

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

      str_filename_plot = strmid(str_datafile_new,0,strpos(str_datafile_new,'/',/REVERSE_SEARCH))
      if b_chemical then begin
        str_filename_plot = str_filename_plot+'/chemical/'
      end else begin
        str_filename_plot = str_filename_plot+'/rave/'
      end
      if b_giants_only then $
        str_filename_plot = str_filename_plot+'giants/'
      if b_dwarfs_only then $
        str_filename_plot = str_filename_plot+'dwarfs/'
      openw,lun,str_filename_plot+'index.html',/GET_LUN
      printf,lun,'<html><body><center>'

      i_loop_end = 9
      if b_chemical then $
        i_loop_end = 2

      for j=0, i_loop_end do begin
        set_plot,'ps'
        str_filename_plot = strmid(str_datafile_new,0,strpos(str_datafile_new,'/',/REVERSE_SEARCH))
        if b_chemical then begin
          str_filename_plot = str_filename_plot+'/chemical/'
        end else begin
          str_filename_plot = str_filename_plot+'/rave/'
        end
        if b_giants_only then begin
          str_filename_plot = str_filename_plot+'giants/'
        endif
        if b_dwarfs_only then $
          str_filename_plot = str_filename_plot+'dwarfs/'
        str_filename_plot = str_filename_plot+strmid(str_datafile_new,strpos(str_datafile_new,'/',/REVERSE_SEARCH)+1)
        str_filename_plot = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))
        i_print_moments = 1
        if j eq 0 then begin; --- T_eff
          str_filename_plot = str_filename_plot + '_Teff.ps'
          i_col_x = i_col_teff_pastel
          i_col_y = i_col_teff_rave
          i_col_ex = i_col_eteff_pastel
          i_col_ey = i_col_eteff_rave
          str_xtitle = 'T!Deff!N [K] (PASTEL)'
          str_ytitle = 'T!Deff!N [K] (RAVE)'
          diff_str_ytitle = '(T!Deff,PASTEL!N - T!Deff,RAVE!N) [K]'
          dblarr_xrange = [3000.,8400.]
          dblarr_yrange = [3000.,8200.]
          if b_chemical then begin
            dblarr_xrange = [3000.,7200.]
            dblarr_yrange = [3000.,7000.]
          endif
          if b_giants_only then begin
            i_print_moments = 3
          endif
          diff_dblarr_yrange = [-1000.,1000.]
    ;      dblarr_position = [0.185,0.16,0.937,0.995]
    ;      dblarr_position_diff=[0.205,0.165,0.998,0.995]
    ;      dblarr_position_hist=[0.135,0.175,0.998,0.995]
          dblarr_position = [0.205,0.175,0.932,0.98]
          dblarr_position_diff=[0.205,0.175,0.932,0.98]
          dblarr_position_hist=[0.205,0.175,0.932,0.98]
          i_xticks = 5
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_pastel = where(abs(dblarr_doubles(*,i_col_teff_pastel)) gt 0.1)
          print,'pastel_compare_to_rave: Pastel: ',n_elements(indarr_pastel),' stars with T_eff'
          indarr_rave = where(abs(dblarr_doubles(indarr_pastel,i_col_teff_rave)) gt 0.1)
          print,'pastel_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with T_eff'
          str_dim = 'K'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 0.0001
          dbl_rejectvalueyrange = 10.
        end else if j eq 1 then begin; --- log g
          str_filename_plot = str_filename_plot + '_logg.ps'
          i_col_x = i_col_logg_pastel
          i_col_y = i_col_logg_rave
          i_col_ex = i_col_elogg_pastel
          i_col_ey = i_col_elogg_rave
          str_xtitle='log g [dex] (PASTEL)'
          str_ytitle='log g [dex] (RAVE)'
          diff_str_ytitle = '((log g)!DPASTEL!N - (log g)!DRAVE!N) [dex]'
          dblarr_xrange=[0.,5.65]
          dblarr_yrange=[0.,5.5]
          diff_dblarr_yrange = [-2.5,2.5]
    ;      dblarr_position=[0.115,0.16,0.937,0.995]
    ;      dblarr_position_diff=[0.135,0.16,0.998,0.995]
    ;      dblarr_position_hist=[0.135,0.175,0.995,0.99]
          dblarr_position=[0.135,0.175,0.932,0.98]
          dblarr_position_diff=[0.135,0.175,0.932,0.98]
          dblarr_position_hist=[0.135,0.175,0.932,0.98]
          i_xticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          indarr_pastel = where(abs(dblarr_doubles(*,i_col_logg_pastel)) gt 0.0000001)
          print,'pastel_compare_to_rave: Pastel: ',n_elements(indarr_pastel),' stars with log g'
          indarr_rave = where(abs(dblarr_doubles(indarr_pastel,i_col_logg_rave) - 99.9) gt 0.1)
          print,'pastel_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with log g'
          str_dim = 'dex'
          dbl_rejectvaluex      = 0.00000001
          dbl_rejectvaluexrange = 0.0000001
          dbl_rejectvaluey      = 99.9
          dbl_rejectvalueyrange = 10.
          if b_giants_only then begin
            i_print_moments = 3
          endif
        end else if j eq 2 then begin; --- [M/H] uncalibrated vs. [Fe/H]
          if b_chemical then begin
            str_filename_plot = str_filename_plot+'_FeH_vs_FeH.ps'
            str_xtitle='[Fe/H] [dex] (PASTEL)'
            str_ytitle='[Fe/H] [dex] (chem)'
            diff_str_ytitle = '([Fe/H]!DPASTEL!N - [Fe/H]!Dchem!N) [dex]'
            i_col_x = i_col_mh_pastel
            i_col_y = i_col_mh_rave
            i_col_ex = i_col_efeh_pastel
            i_col_ey = i_col_emh_rave
          end else begin; --- [m/H] vs. [M/H]
            str_filename_plot = str_filename_plot+'_mH_vs_MH.ps'
            str_xtitle='[m/H] [dex] (PASTEL)'
            str_ytitle='[M/H] [dex] (RAVE)'
            diff_str_ytitle = '([m/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
            i_col_x = i_col_mh_pastel
            i_col_y = i_col_mh_rave
            i_col_ex = i_col_efeh_pastel
            i_col_ey = i_col_emh_rave
          end
          indarr_pastel = where(abs(dblarr_doubles(*,i_col_feh_pastel)) gt 0.0000001)
          print,'pastel_compare_to_rave: Pastel: ',n_elements(indarr_pastel),' stars with [Fe/H]'
          print,'pastel_compare_to_rave: dblarr_doubles(indarr_pastel,i_col_feh_pastel) = ',dblarr_doubles(indarr_pastel,i_col_feh_pastel)
          print,'pastel_compare_to_rave: dblarr_doubles(indarr_pastel,i_col_efeh_pastel) = ',dblarr_doubles(indarr_pastel,i_col_efeh_pastel)
          indarr_rave = where(abs(dblarr_doubles(indarr_pastel,i_col_mh_rave) - 99.9) gt 0.1)
          print,'pastel_compare_to_rave: RAVE: ',n_elements(indarr_rave),' stars with [Fe/H]'
        end else if j eq 3 then begin; --- [m/H] vs. [Fe/H]
          str_filename_plot = str_filename_plot+'_mH_vs_FeH.ps'
          i_col_x = i_col_feh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[Fe/H] [dex] (PASTEL)'
          str_ytitle='[m/H] [dex] (RAVE)'
          diff_str_ytitle = '([Fe/H]!DPASTEL!N - [m/H]!DRAVE!N) [dex]'
        end else if j eq 4 then begin; --- [m/H] + 0.2 vs. [M/H]
          str_filename_plot = str_filename_plot+'_mH+0_2_vs_MH.ps'
          i_col_x = i_col_mh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[M/H] [dex] (Pastel)'
          str_ytitle='([m/H] + 0.2) [dex] (RAVE)'
          diff_str_ytitle = '([M/H]!DPASTEL!N - [m/H]!DRAVE!N+0.2) [dex]'
          dblarr_mh_rave_uncalibrated = dblarr_doubles(*,i_col_mh_rave)
          dblarr_doubles(*,i_col_mh_rave) = dblarr_mh_rave_uncalibrated + 0.2
        end else if j eq 5 then begin; --- [M/H] DR2 calibration vs. [M/H]
          str_filename_plot = str_filename_plot+'_MH-DR2_vs_MH.ps'
          i_col_x = i_col_mh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[M/H] [dex] (PASTEL)'
          str_ytitle='[M/H] [dex] (RAVE)'
          diff_str_ytitle = '([M/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
          rave_calibrate_metallicities,dblarr_mh_rave_uncalibrated,$
                                      dblarr_doubles(*,i_col_aFe_rave),$
    ;                                   DBLARR_TEFF=dblarr_teff,$; --- new calibration
                                      DBLARR_LOGG=dblarr_doubles(*,i_col_logg_rave),$; --- old calibration
                                      REJECTVALUE=99.9,$
                                      REJECTERR=1.,$
                                      OUTPUT=output
          dblarr_doubles(*,i_col_mh_rave) = output
        end else if j eq 6 then begin; --- [M/H] DR2 calibration vs. [Fe/H]
          str_filename_plot = str_filename_plot+'_MH-DR2_vs_FeH.ps'
          i_col_x = i_col_feh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[Fe/H] [dex] (Pastel)'
          str_ytitle='[M/H] [dex] (RAVE)'
          diff_str_ytitle = '([Fe/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
        end else if j eq 7 then begin; --- [M/H] DR3 calibration vs. M/H
          str_filename_plot = str_filename_plot+'_MH-DR3_vs_MH.ps'
          i_col_x = i_col_mh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[M/H] [dex] (PASTEL)'
          str_ytitle='[M/H] [dex] (RAVE)'
          diff_str_ytitle = '([M/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
          ; --- calibrate metallicities with new calibration
          rave_calibrate_metallicities,dblarr_mh_rave_uncalibrated,$
                                      dblarr_doubles(*,i_col_aFe_rave),$
                                      DBLARR_TEFF=dblarr_doubles(*,i_col_teff_rave),$; --- new calibration
                                      DBLARR_LOGG=dblarr_doubles(*,i_col_logg_rave),$; --- old calibration
                                      DBLARR_STN=dblarr_doubles(*,i_col_snr_rave),$; --- old calibration
                                      REJECTVALUE=99.9,$
                                      REJECTERR=1.,$
                                      OUTPUT=output,$
                                      SEPARATE=1
          dblarr_doubles(*,i_col_mh_rave) = output
        end else if j eq 8 then begin; --- [M/H] DR3 calibration vs. [Fe/H]
          str_filename_plot = str_filename_plot+'_MH-DR3_vs_FeH.ps'
          i_col_x = i_col_feh_pastel
          i_col_y = i_col_mh_rave
          i_col_ex = i_col_efeh_pastel
          i_col_ey = i_col_emh_rave
          str_xtitle='[Fe/H] [dex] (Pastel)'
          str_ytitle='[M/H] [dex] (RAVE)'
          diff_str_ytitle = '([Fe/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
        end else begin
          if not b_chemical then begin
            indarr = where((abs(dblarr_doubles(*,i_col_feh_pastel)) ge 0.00001) and (abs(dblarr_doubles(*,i_col_logg_rave)) lt 90.))
            ; --- calculate Pastel [M/H] from [Fe/H] using my new transformation - set I_B_MINE to 0 for Zwitters trafo
            besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_doubles(indarr,i_col_feh_pastel),$
                                  O_DBLARR_MH                       = dblarr_mh_pastel_temp,$ ; --- dblarr
                                  I_B_MINE                          = 1,$
                                  I_DBLARR_LOGG                     = dblarr_doubles(indarr,i_col_logg_rave)
            str_filename_plot = str_filename_plot+'_MH-DR3_vs_MH-from-FeH-new.ps'
            dblarr_doubles(indarr,i_col_mh_pastel) = dblarr_mh_pastel_temp
            i_col_x = i_col_mh_pastel
            i_col_y = i_col_mh_rave
            i_col_ex = i_col_emh_pastel
            i_col_ey = i_col_emh_rave
            str_xtitle='[M/H] [dex] (PASTEL, new trafo)'
            str_ytitle='[M/H] [dex] (RAVE)'
            diff_str_ytitle = '([M/H]!DPASTEL!N - [M/H]!DRAVE!N) [dex]'
          end
        end

        if j ge 2 then begin
          dblarr_xrange=[-3.,1.1]
          dblarr_yrange=[-3.,1.0]
          diff_dblarr_yrange = [-2.5,2.5]
    ;      dblarr_position=[0.17,0.16,0.935,0.995]
    ;      dblarr_position_diff=[0.17,0.16,0.998,0.995]
    ;      dblarr_position_hist=[0.135,0.175,0.998,0.995]
          if b_chemical then begin
            dblarr_position=[0.17,0.175,0.932,0.98]
            dblarr_position_diff=[0.17,0.175,0.932,0.98]
            dblarr_position_hist=[0.17,0.175,0.932,0.98]
          end else begin
            dblarr_position=[0.17,0.175,0.932,0.98]
            dblarr_position_diff=[0.17,0.175,0.932,0.98]
            dblarr_position_hist=[0.17,0.175,0.932,0.98]
          end
          str_dim = 'dex'
          i_xticks = 0
          str_xtickformat = '(I3)'
          str_ytickformat = '(I3)'
          dbl_rejectvaluex      = 0.000000001
          dbl_rejectvaluexrange = 0.00000001
          dbl_rejectvaluey      = 99.9
          dbl_rejectvalueyrange = 10.
        end
    ;    if j ne 9 then $
          indarr = lindgen(n_elements(indarr_rave))

        dblarr_error = dblarr_doubles(indarr_pastel(indarr_rave(indarr)),i_col_x) -$
                      dblarr_doubles(indarr_pastel(indarr_rave(indarr)),i_col_y)
        dblarr_error = dblarr_error * dblarr_error
        dbl_sigma = sqrt(total(dblarr_error) / n_elements(dblarr_error))
        print,'pastel_compare_to_rave: dbl_sigma = ',dbl_sigma
        str_title = 'sigma = '+strmid(strtrim(string(dbl_sigma),2),0,6)+' '+str_dim


        str_filename_plot_root = strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))

        compare_two_parameters,dblarr_doubles(indarr_pastel(indarr_rave(indarr)),i_col_x),$
                              dblarr_doubles(indarr_pastel(indarr_rave(indarr)),i_col_y),$
                              str_filename_plot_root,$
                              DBLARR_ERR_X             = dblarr_doubles(indarr_pastel(indarr_rave(indarr)), i_col_ex),$
                              DBLARR_ERR_Y             = dblarr_doubles(indarr_pastel(indarr_rave(indarr)), i_col_ey),$
                              DBLARR_RAVE_SNR          = dblarr_doubles(indarr_pastel(indarr_rave(indarr)), i_col_snr_rave),$
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
                              B_DO_SIGMA_CLIPPING      = 1

        printf,lun,'<h2>'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'</h2><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
        printf,lun,'<a href="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_filename_plot_root,strpos(str_filename_plot_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
        printf,lun,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br><br><hr><br>'
    ;if j eq 1 then stop
        reduce_pdf_size,str_filename_plot_root+'.pdf',str_filename_plot_root+'_small.pdf'
        reduce_pdf_size,str_filename_plot_root+'_diff.pdf',str_filename_plot_root+'_diff_small.pdf'
        reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'

    ;    device,filename = str_filename_plot,/color
    ;      plot,dblarr_doubles(indarr_pastel(indarr_rave),i_col_x),$
    ;           dblarr_doubles(indarr_pastel(indarr_rave),i_col_y),$
    ;           psym=7,$
    ;           symsize=1.5,$
    ;           xtitle=str_xtitle,$
    ;           ytitle=str_ytitle,$
    ;           charsize=2.,$
    ;;           charsize=1.6,$
    ;           charthick=2,$
    ;           xrange=dblarr_xrange,$
    ;           yrange=dblarr_yrange,$
    ;           xstyle=1,$
    ;           ystyle=1,$
    ;           position=dblarr_position,$
    ;           title = str_title
    ;      oplot,dblarr_yrange,dblarr_yrange
    ;      loadct,ltab,FILE='colors1_pastel.tbl'
    ;      for i=0ul,n_elements(indarr_rave)-1 do begin
    ;       if b_snr_gt_thirteen and dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_snr_rave) lt 20. then begin
    ;        print,'pastel_compare_to_rave: SNR for RAVE star i=',i,' lt 20'
    ;       end else begin
    ;        i_colour = long( 2.5 * dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_snr_rave))
    ;        if i_colour lt 1 then i_colour = 1
    ;        if i_colour gt 255 then i_colour = 255
    ;        oplot,[dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_x),dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_x)],$
    ;              [dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y),dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y)],$
    ;              color=i_colour,$
    ;              psym=7,$
    ;              symsize=1.5
    ;        ; --- plot error bars
    ;        oplot,[dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_x)-dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_ex),dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_x)+dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_ex)],$
    ;              [dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y),dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y)],$
    ;              color=i_colour
    ;        oplot,[dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_x),dblarr_doubles(indarr_pastel(indarr_rave(i)), i_col_x)],$
    ;              [dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y) - dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_ey),dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y) + dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_ey)],$
    ;              color=i_colour
    ;        print,'pastel_compare_to_rave: Pastel data = dblarr_doubles(indarr_pastel(indarr_rave(i=',i,')=',indarr_rave(i),'),i_col_y=',i_col_y,') = ',dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y)
    ;        print,'pastel_compare_to_rave: Pastel data = dblarr_doubles(indarr_pastel(indarr_rave(i=',i,')=',indarr_rave(i),'),i_col_ey=',i_col_ey,') = ',dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_ey)
    ;        if abs(dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_ey)) lt 0.0001 then begin
    ;          print,'pastel_compare_to_rave: dblarr_doubles(indarr_pastel(indarr_rave(i=',i,')),i_col_y=',i_col_y,') = ',dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_y)
    ;          print,'pastel_compare_to_rave: dblarr_doubles(indarr_pastel(indarr_rave(i=',i,')),i_col_ey=',i_col_ey,') = ',dblarr_doubles(indarr_pastel(indarr_rave(i)),i_col_ey)
    ;        endif
    ;       endelse
    ;      endfor
    ;      if j eq 0 then begin
    ;        for i=long(dblarr_yrange(0)),long(dblarr_yrange(1)) do begin
    ;          oplot,[dblarr_yrange(1),dblarr_xrange(1)],[i,i],color=long((double(i)-dblarr_yrange(0))*254./(dblarr_yrange(1) - dblarr_yrange(0)))+1
    ;        endfor
    ;        xyouts,12380.,3000.,'0',charsize=1.6
    ;        xyouts,12330.,11680.,'100',charsize=1.6
    ;        xyouts,12730.,5900.,'SNR RAVE',charsize=1.6,orientation=90
    ;      end else if j eq 1 then begin
    ;        for i=0ul,5500 do begin
    ;          oplot,[dblarr_yrange(1),dblarr_xrange(1)],[i/1000.,i/1000.],color=long((double(i))*254./5000.)+1
    ;        endfor
    ;        xyouts,5.7,0.,'0',charsize=1.6
    ;        xyouts,5.66,5.3,'100',charsize=1.6
    ;        xyouts,5.88,1.9,'SNR RAVE',charsize=1.6,orientation=90
    ;      end else begin
    ;        for i=0ul,4000 do begin
    ;          oplot,[1.,1.1],[i/1000.-3.,i/1000.-3.],color=long((double(i))*254./4000.)+1
    ;        endfor
    ;        xyouts,1.12,-3.,'0',charsize=1.6
    ;        xyouts,1.105,0.865,'100',charsize=1.6
    ;        xyouts,1.25,-1.55,'SNR RAVE',charsize=1.6,orientation=90
    ;      end
    ;    device,/close
    ;    spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'
    ;    spawn,'epstopdf '+str_filename_plot
    ;    print,'pastel_compare_to_rave: dbl_sigma = ',dbl_sigma

    ;    if j eq 0 then $
    ;      dblarr_yrange = [3000.,10000.]


        ; --- plot histograms
    ;    plot_two_histograms,dblarr_doubles(indarr_pastel(indarr_rave),i_col_x),$; --- RAVE
    ;                        dblarr_doubles(indarr_pastel(indarr_rave),i_col_y),$; --- BESANCON
    ;                        STR_PLOTNAME_ROOT=strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'_hist',$;     --- string
    ;                        XTITLE=strmid(str_xtitle,0,strpos(str_xtitle,'(')-1),$;                           --- string
    ;                        YTITLE='Percentage of stars',$;                           --- string
    ;                        I_NBINS=0,$;                           --- int
    ;                        NBINSMAX=30,$;                       --- int
    ;                        NBINSMIN=20,$;                       --- int
    ;                        TITLE='',$;                             --- string
    ;                        XRANGE=dblarr_yrange,$;                           --- dblarr
    ;                        YRANGE=yrange,$;                           --- dblarr
    ;                        MAXNORM=0,$;                         --- bool (0/1)
    ;                        TOTALNORM=0,$;                     --- bool (0/1)
    ;                        PERCENTAGE=1,$;                   --- bool (0/1)
    ;                        REJECTVALUEX=99999999999.,$;               --- double
    ;                        B_POP_ID = 0,$;                     --- bool
    ;                        DBLARR_STAR_TYPES=0,$;     --- dblarr
    ;                        PRINTPDF=1,$;                       --- bool (0/1)
    ;                        DEBUGA=0,$;                           --- bool (0/1)
    ;                        DEBUGB=0,$;                           --- bool (0/1)
    ;                        DEBUG_OUTFILES_ROOT=0,$; --- string
    ;                        COLOUR=1,$;                           --- bool (0/1)
    ;                        B_RESIDUAL=0,$;                 --- double
    ;                        I_DBLARR_POSITION=dblarr_position_hist,$
    ;                        I_DBL_THICK=3.,$
    ;                        I_INT_XTICKS = i_xticks,$
    ;                        I_STR_XTICKFORMAT = str_xtickformat

      endfor
      printf,lun,'</center></body></html>'
      free_lun,lun
    endfor
  endfor
end
