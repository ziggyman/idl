pro besancon_mh_gaussfits
  set_plot,'x'

  str_filename = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_height_rcent_errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00_samplex1_9ltI2MASSlt12_logg_0.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_mh = double(strarr_data(*,8))
  dblarr_logg = double(strarr_data(*,6))
  strarr_data = 0

  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                      O_INDARR_DWARFS  = indarr_dwarfs,$
                                      O_INDARR_GIANTS  = indarr_giants,$
                                      I_DBL_LIMIT_LOGG = 3.5

  int_nbins = 41
  for i=1,1 do begin
    if i eq 0 then begin
      dblarr_test = dblarr_mh(indarr_giants)
    end else begin
      dblarr_test = dblarr_mh(indarr_dwarfs)
    endelse
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
    for j=0,int_nbins-1 do begin
      dblarr_x(j) = dblarr_locations(j) + (dblarr_locations(j+1)-dblarr_locations(j))/2.
    endfor
    print,'dblarr_x = ',dblarr_x

    gaussfits,dblarr_x,dblarr_nstars,0,2,dblarr_pars,dblarr_yfit,dblarr_sigma
    print,'dblarr_pars = ',dblarr_pars
    print,'dblarr_yfit = ',dblarr_yfit
    print,'dblarr_sigma = ',dblarr_sigma

    str_xtitle = '[M/H] [dex]'

    ; --- plot
    set_plot,'ps'
    str_psfilename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH)) + '_gaussians'
    str_psfilename = str_psfilename + '-MH'
    if i eq 0 then begin
      str_psfilename = str_psfilename + '-giants'
    end else begin
      str_psfilename = str_psfilename + '-dwarfs'
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
    for j=1,int_nbins-1 do begin
      oplot,[dblarr_locations(j),dblarr_locations(j)],$
            [dblarr_nstars(j-1),dblarr_nstars(j)],$
            thick=3.
      oplot,[dblarr_locations(j),dblarr_locations(j+1)],$
            [dblarr_nstars(j),dblarr_nstars(j)],$
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
  endfor
  ; --- cleanup
  dblarr_mh = 0
  indarr_reverse = 0
  intarr_hist_cmh = 0
end
