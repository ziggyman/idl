pro rave_teff_gaussfits
  set_plot,'x'

  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_no-FeH.dat';MH-fromFeH-calib.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_teff = double(strarr_data(*,19))
  dblarr_logg = double(strarr_data(*,20))
  strarr_data = 0

  dblarr_xrange = [2500.,8000.]

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                      O_INDARR_DWARFS  = indarr_dwarfs,$
                                      O_INDARR_GIANTS  = indarr_giants,$
                                      I_DBL_LIMIT_LOGG = 3.5
  ;dblarr_teff = dblarr_teff(indarr_giants)

  int_nbins = 51
  dblarr_test = dblarr_teff
  print,'dblarr_test(0:10) = ',dblarr_test(0:10)
  intarr_hist_cmh = histogram(dblarr_test,NBINS = int_nbins,MAX = dblarr_xrange(1),MIN = dblarr_xrange(0),REVERSE_INDICES=indarr_reverse,LOCATION=dblarr_locations)

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

  str_xtitle = 'T!Deff, calibrated!N [K]'

  ; --- plot
  set_plot,'ps'
  str_psfilename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH)) + '_gaussians'
  str_psfilename = str_psfilename + '-Teff'
  str_psfilename = str_psfilename + '.ps'
  device,filename = str_psfilename
  dblarr_yrange = [-1.,max(dblarr_nstars)+0.5]
  plot,dblarr_xrange,$
        [0.,0.],$
        xrange=dblarr_xrange,$
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
  xyouts,-1.,$
          dblarr_yrange(1)-(dblarr_yrange(1) - dblarr_yrange(0))/12.,$
          '!4l!3!D2!N='+str_temp,$
          charsize = 1.6,$
          charthick = 3.

  ; --- sigma_2
  str_temp = strtrim(string(dblarr_pars(4)),2)
  str_temp = strmid(str_temp,0,strpos(str_temp,'.')+4)
  xyouts,-1.,$
          dblarr_yrange(1)-(dblarr_yrange(1) - dblarr_yrange(0))/7.,$
          '!4r!3!D2!N='+str_temp,$
          charsize = 1.6,$
          charthick = 3.

  device,/close
  set_plot,'x'

  spawn,'epstopdf '+str_psfilename
  ; --- cleanup
  dblarr_teff = 0
  indarr_reverse = 0
  intarr_hist_cmh = 0
end
