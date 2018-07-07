pro rave_mh_gaussfits, I_STR_FILENAME     = i_str_filename,$
                       I_STR_OUTFILENAME = i_str_outfilename,$
                       I_B_DWARFS         = i_b_dwarfs,$
                       I_INT_COL_FIT      = i_int_col_fit
  set_plot,'x'

  b_dwarfs = 0
  if keyword_set(I_B_DWARFS) then $
    b_dwarfs = 1

  jj_start = 5
  jj_end   = 7

  if keyword_set(I_STR_FILENAME) then begin
    str_filename = i_str_filename
    jj_start = 10
    jj_end   = 10
  endif

  for jj = jj_start, jj_end do begin
    if jj eq 0 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_no-FeH.dat';MH-fromFeH-calib.dat'
    end else if jj eq 1 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_no-FeH.dat';MH-fromFeH-calib.dat'
    end else if jj eq 2 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_no-FeH.dat';MH-fromFeH-calib.dat'
    end else if jj eq 3 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_MH-from-FeH-and-aFe.dat';MH-fromFeH-calib.dat'
    end else if jj eq 4 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_MH-from-FeH-and-aFe.dat';MH-fromFeH-calib.dat'
    end else if jj eq 5 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_MH-from-FeH-and-aFe.dat';MH-fromFeH-calib.dat'
    end else if jj eq 6 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib.dat';MH-fromFeH-calib.dat'
    end else if jj eq 7 then begin
      str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-merged.dat'
    end else if jj eq 8 then begin
      str_filename = '/home/azuri/daten/rave/3d/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib.dat'
    endif
    strarr_data = readfiletostrarr(str_filename,' ')

    dblarr_cmh = double(strarr_data(*,23))
    dblarr_mh = double(strarr_data(*,24))
    dblarr_logg = double(strarr_data(*,20))

    if keyword_set(I_INT_COL_FIT) then $
      dblarr_cmh = double(strarr_data(*,i_int_col_fit))

    strarr_data = 0

    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                        O_INDARR_DWARFS  = indarr_dwarfs,$
                                        O_INDARR_GIANTS  = indarr_giants,$
                                        I_DBL_LIMIT_LOGG = 3.5
    if b_dwarfs then begin
      dblarr_cmh = dblarr_cmh(indarr_dwarfs)
      dblarr_mh = dblarr_mh(indarr_dwarfs)
    end else begin
      dblarr_cmh = dblarr_cmh(indarr_giants)
      dblarr_mh = dblarr_mh(indarr_giants)
    endelse

    int_nbins = 51

    int_j_start = 0
    int_j_end   = 1

    if keyword_set(I_INT_COL_FIT) then $
      int_j_end = 0

    for j=int_j_start, int_j_end do begin
      if j eq 0 then begin
        dblarr_test = dblarr_cmh
      end else if j eq 1 then begin
        dblarr_test = dblarr_mh
      endif
      print,'dblarr_test(0:10) = ',dblarr_test(0:10)
      intarr_hist_cmh = histogram(dblarr_test,NBINS = int_nbins,MAX = 1.,MIN = -2.,REVERSE_INDICES=indarr_reverse,LOCATION=dblarr_locations)

      dblarr_nstars = double(intarr_hist_cmh)
  ;    dblarr_nstars = dblarr(int_nbins)
  ;    for i=0,int_nbins-1 do begin
  ;      dblarr_nstars(i) = double(indarr_reverse(i+1) - indarr_reverse(i))
  ;    endfor
      dblarr_nstars = dblarr_nstars * 100. / total(dblarr_nstars)
      print,'dblarr_nstars = ',dblarr_nstars

  ;    dbl_stepsize = 3. / double(int_nbins)

      dblarr_locations = [dblarr_locations,dblarr_locations(int_nbins-1)+dblarr_locations(1)-dblarr_locations(0)]
      dblarr_x = dblarr(int_nbins)
  ;    dblarr_x(0) = -2. + dbl_stepsize/2.
      for i=0,int_nbins-1 do begin
        dblarr_x(i) = dblarr_locations(i) + (dblarr_locations(i+1)-dblarr_locations(i))/2.
      endfor
      print,'dblarr_x = ',dblarr_x

      gaussfits,dblarr_x,dblarr_nstars,0,2,dblarr_pars,dblarr_yfit,dblarr_sigma
      print,'dblarr_pars = ',dblarr_pars
      print,'dblarr_yfit = ',dblarr_yfit
      print,'dblarr_sigma = ',dblarr_sigma

      if j eq 0 then begin
        str_xtitle = '[M/H]!Dcalibrated!N [dex]'
      end else begin
        str_xtitle = '[m/H]!Dcalibrated!N [dex]'
      endelse

      ; --- plot
      set_plot,'ps'
      if keyword_set(I_STR_OUTFILENAME) then begin
        str_psfilename = i_str_outfilename
      end else begin
        str_psfilename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH)) + '_gaussians'
        if j eq 0 then begin
          str_psfilename = str_psfilename + '-MH'
        end else begin
          str_psfilename = str_psfilename + '-mH'
        endelse
      endelse
      if b_dwarfs then begin
        str_psfilename = str_psfilename + '_dwarfs'
      end else begin
        str_psfilename = str_psfilename + '_giants'
      endelse
      str_psfilename = str_psfilename + '.ps'
      device,filename = str_psfilename
      dblarr_yrange = [-1.,max(dblarr_nstars)+0.5]
      plot,[-2.,1.],$
          [0.,0.],$
          xrange=[-2.,1.],$
          yrange = dblarr_yrange,$
          xstyle = 1,$
          ystyle = 1,$
          xtitle=str_xtitle,$
          ytitle='Percentage of stars',$
          thick = 1.,$
          charthick = 3.,$
          charsize = 1.8,$
          position = [0.125,0.16,0.91,0.99]
      for i=1,int_nbins-1 do begin
        oplot,[dblarr_locations(i),dblarr_locations(i)],$
              [dblarr_nstars(i-1),dblarr_nstars(i)],$
              thick=3.
        oplot,[dblarr_locations(i),dblarr_locations(i+1)],$
              [dblarr_nstars(i),dblarr_nstars(i)],$
              thick=3.
      endfor

      ; --- plot 1st Gaussian
      dblarr_z = (dblarr_x - dblarr_pars(0)) / dblarr_pars(1)
      dblarr_y_a = dblarr_pars(2) * exp(-(dblarr_z^2.) / 2.)
      oplot,dblarr_x,$
            dblarr_y_a,$
            linestyle=1,$
            thick = 3.

      ; --- plot 2nd Gaussian
      dblarr_z = (dblarr_x - dblarr_pars(3)) / dblarr_pars(4)
      dblarr_y_b = dblarr_pars(5) * exp(-(dblarr_z^2.) / 2.)
      oplot,dblarr_x,$
            dblarr_y_b,$
            linestyle=2,$
            thick = 3.

      ; --- plot sum of Gaussians
      dblarr_y = dblarr_y_a + dblarr_y_b
      oplot,dblarr_x,$
            dblarr_y,$
            linestyle=3,$
            thick = 3.

      ; --- plot difference
      oplot,dblarr_x,$
            dblarr_nstars - dblarr_y,$
            psym = 1,$
            thick = 3.
      ; --- mu_1
      str_temp = strtrim(string(dblarr_pars(0)),2)
      str_temp = strmid(str_temp,0,strpos(str_temp,'.')+4)
      xyouts,-1.85,$
            dblarr_yrange(1)-(dblarr_yrange(1) - dblarr_yrange(0))/12.,$
            '!4l!3!D1!N='+str_temp,$
            charsize = 1.6,$
            charthick = 3.

      ; --- sigma_1
      str_temp = strtrim(string(dblarr_pars(1)),2)
      str_temp = strmid(str_temp,0,strpos(str_temp,'.')+4)
      xyouts,-1.85,$
            dblarr_yrange(1)-(dblarr_yrange(1) - dblarr_yrange(0))/7.,$
            '!4r!3!D1!N='+str_temp,$
            charsize = 1.6,$
            charthick = 3.

      ; --- mu_2
      str_temp = strtrim(string(dblarr_pars(3)),2)
      str_temp = strmid(str_temp,0,strpos(str_temp,'.')+4)
      xyouts,-1.85,$
            dblarr_yrange(1) - (dblarr_yrange(1) - dblarr_yrange(0))/12. - 2.6*((dblarr_yrange(1) - dblarr_yrange(0))/7. - (dblarr_yrange(1) - dblarr_yrange(0))/12.),$
            '!4l!3!D2!N='+str_temp,$
            charsize = 1.6,$
            charthick = 3.

      ; --- sigma_2
      str_temp = strtrim(string(dblarr_pars(4)),2)
      str_temp = strmid(str_temp,0,strpos(str_temp,'.')+4)
      xyouts,-1.85,$
            dblarr_yrange(1) - (dblarr_yrange(1) - dblarr_yrange(0))/12. - 3.6*((dblarr_yrange(1) - dblarr_yrange(0))/7. - (dblarr_yrange(1) - dblarr_yrange(0))/12.),$
            '!4r!3!D2!N='+str_temp,$
            charsize = 1.6,$
            charthick = 3.

      device,/close
      set_plot,'x'

      spawn,'epstopdf '+str_psfilename
    endfor
  endfor
  ; --- cleanup
  dblarr_mh = 0
  dblarr_cmh = 0
  indarr_reverse = 0
  intarr_hist_cmh = 0
end
