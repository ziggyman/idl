pro rave_stream_find_stars

  i_rave_dr = 10
  
  dbl_lon_min = 0.;30.
  dbl_lon_max = 30.;75.
  dbl_lat_min = -70.
  dbl_lat_max = -50.
  dbl_vrad_min = 150.
  dbl_vrad_max = 1000.
;  dbl_mh_min = -0.5
  dbl_mh_min = -2.5
  dbl_mh_max = 1.5
  dbl_logg_min = 0.
  dbl_logg_max = 3.5

;  str_filename_rave = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with2MASSJK_noFlag_minusIC1-IC2_230-315_-25-25_JmK2MASSgt0_5_noDBLS-within2arcsec-maxSNR_I2MASS-9ltIlt12_STNgt20WithAtmPar_MHgood.dat'
  str_filename_old_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\).dat'
  strarr_old_stars = readfiletostrarr(str_filename_old_stars,' ')
  int_col_old_stars_id = 2
  int_col_old_stars_stn = 35
  int_col_old_stars_vrad = 7
  int_col_old_stars_mh = 21
  int_col_old_stars_teff = 19
  int_col_old_stars_logg = 20
  int_col_old_stars_afe = 22
  strarr_old_star_id = strarr_old_stars(*,int_col_old_stars_id)
  
  str_filename_bes = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_height_rcent_samplex1_9ltI2MASSlt12_logg_0.dat';/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20.dat'
  i_col_lon_besancon = 0
  i_col_lat_besancon = 1
  i_col_imag_besancon = 2
  i_icol_besancon = 2
  i_col_vjmag_besancon = 3
  i_col_kmag_besancon = 4
  i_col_teff_besancon = 5
  i_col_logg_besancon = 6
  i_col_vrad_besancon = 7
  i_col_feh_besancon = 8
  i_col_snr_besancon = 15
  strarr_bes = readfiletostrarr(str_filename_bes,' ')
  
  dblarr_bes_snr = double(strarr_bes(*,i_col_snr_besancon))
  indarr = where(dblarr_bes_snr ge 13)
  strarr_bes = strarr_bes(indarr,*)

  dblarr_bes_lon = double(strarr_bes(*,i_col_lon_besancon))
  indarr = where((dblarr_bes_lon ge dbl_lon_min) and (dblarr_bes_lon le dbl_lon_max))
  strarr_bes = strarr_bes(indarr,*)

  dblarr_bes_lat = double(strarr_bes(*,i_col_lat_besancon))
  indarr = where((dblarr_bes_lat ge dbl_lat_min) and (dblarr_bes_lat le dbl_lat_max))
  strarr_bes = strarr_bes(indarr,*)
  
  dblarr_bes_lon = double(strarr_bes(*,i_col_lon_besancon))
  dblarr_bes_lat = double(strarr_bes(*,i_col_lat_besancon))
  dblarr_bes_vrad = double(strarr_bes(*,i_col_vrad_besancon))
  dblarr_bes_feh = double(strarr_bes(*,i_col_feh_besancon))
  dblarr_bes_snr = double(strarr_bes(*,i_col_snr_besancon))

  if i_rave_dr eq 9 then begin
    str_filename_rave = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111.dat'
    str_delimiter = ' '
    str_rave_dr = 'dr9'

    int_col_lon = 5
    int_col_lat = 6
    int_col_vrad = 7
    int_col_mh = 21
    int_col_teff = 19
    int_col_pm_ra = 9
    int_col_pm_dec = 11
    int_col_logg = 20
    int_col_id = 0
    int_col_rave_id = 2
    int_col_afe = 22
    int_col_stn = 35
    int_col_snr = 33

  end else if i_rave_dr eq 10 then begin
    str_filename_rave = '/home/azuri/daten/rave/rave_data/release10/raveinternal_VDR3_20120515.csv'
    str_delimiter = ';'
    str_rave_dr = 'dr10'

    int_col_lon = 5
    int_col_lat = 6
    int_col_vrad = 7
    int_col_mh = 63
    int_col_teff = 61
    int_col_pm_ra = 9
    int_col_pm_dec = 11
    int_col_logg = 62
    int_col_id = 1
    int_col_rave_id = 0
    int_col_afe = 64
    int_col_stn = 26
    int_col_snr = 25
  endif

  str_filename_dist = '/home/azuri/daten/rave/rave_data/distances/all_20100819_SN20.rez'
  str_filename_out = '/home/azuri/daten/rave/stream/red\ overdensity/stream_'+str_rave_dr+'.dat'

;  dbl_lon_min = 240.
;  dbl_lon_max = 255.
;  dbl_lat_min = 5.
;  dbl_lat_max = 15.

  int_col_dist_id = 0
  int_col_dist_dist_pn = 16
  int_col_dist_dist_pnr = 18

  strarr_data = readfiletostrarr(str_filename_rave,str_delimiter)
  strarr_lines = readfilelinestoarr(str_filename_rave)
  strarr_dist = readfiletostrarr(str_filename_dist,' ')

  ; --- cross check old stars and release
  strarr_new_data_of_old_stars = strarr(n_elements(strarr_old_stars(*,0)), n_elements(strarr_data(0,*)))
  n_found = 0
  for i=0ul, n_elements(strarr_old_star_id)-1 do begin
    indarr_found = where(strarr_data(*,int_col_rave_id) eq strarr_old_star_id(i))
    if indarr_found(0) ne -1 then begin
      strarr_new_data_of_old_stars(n_found,*) = strarr_data(indarr_found(0),*)
      n_found = n_found+1
    endif
  endfor
  print,n_found,' out of ',n_elements(strarr_old_star_id),' stars found'
  print,'STN old stars = ',strarr_old_stars(*,int_col_old_stars_stn)
  print,'STN new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_stn)
  print,'[m/H] old stars = ',strarr_old_stars(*,int_col_old_stars_mh)
  print,'[m/H] new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_mh)
  print,'vrad old stars = ',strarr_old_stars(*,int_col_old_stars_vrad)
  print,'vrad new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_vrad)
  print,'Teff old stars = ',strarr_old_stars(*,int_col_old_stars_teff)
  print,'Teff new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_teff)
  print,'logg old stars = ',strarr_old_stars(*,int_col_old_stars_logg)
  print,'logg new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_logg)
  print,'aFe old stars = ',strarr_old_stars(*,int_col_old_stars_afe)
  print,'aFe new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_afe)

  dblarr_lon = double(strarr_data(*,int_col_lon))
  dblarr_lat = double(strarr_data(*,int_col_lat))
  indarr_lon_lat = where((dblarr_lon ge dbl_lon_min) and (dblarr_lon le dbl_lon_max) and (dblarr_lat ge dbl_lat_min) and (dblarr_lat le dbl_lat_max))
  print,'stars found in lon-lat: ',n_elements(indarr_lon_lat)

  strarr_data = strarr_data(indarr_lon_lat, *)
  strarr_lines = strarr_lines(indarr_lon_lat)

  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  dblarr_mh = double(strarr_data(*,int_col_mh))
  dblarr_afe = double(strarr_data(*,int_col_afe))
  dblarr_teff = double(strarr_data(*,int_col_teff))
  dblarr_logg = double(strarr_data(*,int_col_logg))

  ; --- calibrate metallicities
  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh,$
                               I_DBLARR_AFE           = dblarr_afe,$
                               I_DBLARR_TEFF          = dblarr_teff,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_logg,$; --- old calibration
                               I_DBLARR_STN           = i_dblarr_stn,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = o_strarr_mh_calibrated,$;           --- string array
                               ;I_DBL_REJECTVALUE      = i_dbl_rejectvalue,$; --- double
                               ;I_DBL_REJECTERR        = rejecterr,$;       --- double
                               I_B_SEPARATE           = true

  dblarr_cmh = double(o_strarr_mh_calibrated)

  str_lon = strtrim(string(dbl_lon_min), 2)
  str_lon = strmid(str_lon,0,strpos(str_lon,'.'))
  str_area = str_lon+'-'
  str_lon = strtrim(string(dbl_lon_max), 2)
  str_lon = strmid(str_lon,0,strpos(str_lon,'.'))
  str_area = str_area + str_lon+'_'
  str_lat = strtrim(string(dbl_lat_min), 2)
  str_lat = strmid(str_lat,0,strpos(str_lat,'.'))
  str_area = str_area + str_lat + '-'
  str_lat = strtrim(string(dbl_lat_max), 2)
  str_lat = strmid(str_lat,0,strpos(str_lat,'.'))
  str_area = str_area + str_lat
  print,'str_area = <'+str_area+'>'
;  stop
  
  set_plot,'ps'
  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_mH_vs_vrad_'+str_rave_dr+'_'+str_area+'_allall.ps'
  plot,dblarr_vrad,$
       dblarr_mh,$
       xtitle='Radial Velocity [km/s]',$
       ytitle='Uncalibrated Metallicity [dex]',$
       psym=2,$
       title=str_rave_dr
  device,/close

  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_MH_vs_vrad_'+str_rave_dr+'_'+str_area+'_allall.ps'
  plot,dblarr_vrad,$
       dblarr_cmh,$
       xtitle='Radial Velocity [km/s]',$
       ytitle='Calibrated Metallicity [dex]',$
       psym=2,$
       title=str_rave_dr
  device,/close

  ; --- check for no-existant or bad stellar atmospheric parameters
  ; --- mH
  indarr_mh_good = where(strarr_data(*,int_col_mh) ne 'NULL')
  strarr_data = strarr_data(indarr_mh_good,*)

  ; --- Teff
  indarr_teff_good = where(strarr_data(*,int_col_teff) ne 'NULL')
  strarr_data = strarr_data(indarr_teff_good,*)

  ; --- logg
  indarr_logg_good = where(strarr_data(*,int_col_logg) ne 'NULL')
  strarr_data = strarr_data(indarr_logg_good,*)

  ; --- aFe
  indarr_afe_bad = where(strarr_data(*,int_col_afe) eq 'NULL')
  strarr_data(indarr_afe_bad,int_col_afe) = strtrim(string(0.0),2)

  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  dblarr_mh = double(strarr_data(*,int_col_mh))
  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_mH_vs_vrad_'+str_rave_dr+'_'+str_area+'_allSTNs.ps'
  plot,dblarr_vrad,$
       dblarr_mh,$
       xtitle='Radial Velocity [km/s]',$
       ytitle='Uncalibrated Metallicity [dex]',$
       psym=2,$
       title=str_rave_dr
  device,/close

  ; --- cross check old stars and release
  strarr_new_data_of_old_stars = strarr(n_elements(strarr_old_stars(*,0)), n_elements(strarr_data(0,*)))
  n_found = 0
  for i=0ul, n_elements(strarr_old_star_id)-1 do begin
    indarr_found = where(strarr_data(*,int_col_rave_id) eq strarr_old_star_id(i))
    if indarr_found(0) ne -1 then begin
      strarr_new_data_of_old_stars(n_found,*) = strarr_data(indarr_found(0),*)
      n_found = n_found+1
    endif
  endfor
  print,'with atm par:',n_found,' out of ',n_elements(strarr_old_star_id),' stars found'
  print,'with atm par:','STN old stars = ',strarr_old_stars(*,int_col_old_stars_stn)
  print,'with atm par:','STN new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_stn)
  print,'with atm par:','[m/H] old stars = ',strarr_old_stars(*,int_col_old_stars_mh)
  print,'with atm par:','[m/H] new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_mh)
  print,'with atm par:','vrad old stars = ',strarr_old_stars(*,int_col_old_stars_vrad)
  print,'with atm par:','vrad new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_vrad)

  ; --- STN
  dblarr_stn = double(strarr_data(*,int_col_stn))
  indarr_stn_acceptable = where(dblarr_stn ge 13.)
  strarr_data = strarr_data(indarr_stn_acceptable,*)

  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  dblarr_mh = double(strarr_data(*,int_col_mh))
  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_mH_vs_vrad_'+str_rave_dr+'_'+str_area+'_goodSTNs.ps'
  plot,dblarr_vrad,$
       dblarr_mh,$
       xtitle='Radial Velocity [km/s]',$
       ytitle='Uncalibrated Metallicity [dex]',$
       psym=2,$
       xrange=[-400.,300.],$
       xstyle=1,$
       yrange=[-3.,1.],$
       ystyle=1,$
       title=str_rave_dr
  oplot,[mean(dblarr_vrad), mean(dblarr_vrad)],[-3.,1.]
  device,/close

  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_mH_vs_vrad_besancon_'+'_'+str_area+'goodSTNs.ps'
  plot,dblarr_bes_vrad,$
       dblarr_bes_feh,$
       xtitle='Besancon Radial Velocity [km/s]',$
       ytitle='Besancon Iron Abundance [dex]',$
       psym=2,$
       xrange=[-400.,300.],$
       xstyle=1,$
       yrange=[-3.,1.],$
       ystyle=1,$
       title='Besancon Model'
  oplot,[mean(dblarr_bes_vrad), mean(dblarr_bes_vrad)],[-3.,1.]
  device,/close
  
  ; --- cross check old stars and release
  strarr_new_data_of_old_stars = strarr(n_elements(strarr_old_stars(*,0)), n_elements(strarr_data(0,*)))
  n_found = 0
  for i=0ul, n_elements(strarr_old_star_id)-1 do begin
    indarr_found = where(strarr_data(*,int_col_rave_id) eq strarr_old_star_id(i))
    if indarr_found(0) ne -1 then begin
      strarr_new_data_of_old_stars(n_found,*) = strarr_data(indarr_found(0),*)
      n_found = n_found+1
    endif
  endfor
  print,'with STN: ',n_found,' out of ',n_elements(strarr_old_star_id),' stars found'
  print,'with STN: ','STN old stars = ',strarr_old_stars(*,int_col_old_stars_stn)
  print,'with STN: ','STN new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_stn)
  print,'with STN: ','[m/H] old stars = ',strarr_old_stars(*,int_col_old_stars_mh)
  print,'with STN: ','[m/H] new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_mh)
  print,'with STN: ','vrad old stars = ',strarr_old_stars(*,int_col_old_stars_vrad)
  print,'with STN: ','vrad new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_vrad)

  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  indarr_vrad = where(((dblarr_vrad ge dbl_vrad_min) and (dblarr_vrad le dbl_vrad_max)) or ((dblarr_vrad ge (0.-dbl_vrad_max)) and (dblarr_vrad le (0.-dbl_vrad_min))))
  print,'stars found in lon-lat with vrad: ',n_elements(indarr_vrad)
  strarr_data = strarr_data(indarr_vrad,*)
  strarr_lines = strarr_lines(indarr_vrad)

  ; --- cross check old stars and release
  strarr_new_data_of_old_stars = strarr(n_elements(strarr_old_stars(*,0)), n_elements(strarr_data(0,*)))
  n_found = 0
  for i=0ul, n_elements(strarr_old_star_id)-1 do begin
    indarr_found = where(strarr_data(*,int_col_rave_id) eq strarr_old_star_id(i))
    if indarr_found(0) ne -1 then begin
      strarr_new_data_of_old_stars(n_found,*) = strarr_data(indarr_found(0),*)
      n_found = n_found+1
    endif
  endfor
  print,'with vrad: ',n_found,' out of ',n_elements(strarr_old_star_id),' stars found'
  print,'with vrad: ','STN old stars = ',strarr_old_stars(*,int_col_old_stars_stn)
  print,'with vrad: ','STN new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_stn)
  print,'with vrad: ','[m/H] old stars = ',strarr_old_stars(*,int_col_old_stars_mh)
  print,'with vrad: ','[m/H] new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_mh)
  print,'with vrad: ','vrad old stars = ',strarr_old_stars(*,int_col_old_stars_vrad)
  print,'with vrad: ','vrad new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_vrad)

;  stop


  dblarr_mh = double(strarr_data(*,int_col_mh))
  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  dblarr_afe = double(strarr_data(*,int_col_afe))
  dblarr_teff = double(strarr_data(*,int_col_teff))
  dblarr_logg = double(strarr_data(*,int_col_logg))
  dblarr_stn = double(strarr_data(*,int_col_stn))
  print,'dblarr_vrad = ',dblarr_vrad
  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  dblarr_mh = double(strarr_data(*,int_col_mh))

  set_plot,'ps'
  device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_mH_vs_vrad_'+str_rave_dr+'_'+str_area+'_all_with_par.ps'
  plot,dblarr_vrad,$
       dblarr_mh,$
       xtitle='Radial Velocity [km/s]',$
       ytitle='Uncalibrated Metallicity [dex]',$
       psym=2,$
       title=str_rave_dr
  device,/close

  ; --- calibrate metallicities
  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh,$
                               I_DBLARR_AFE           = dblarr_afe,$
                               I_DBLARR_TEFF          = dblarr_teff,$; --- new calibration
                               I_DBLARR_LOGG          = dblarr_logg,$; --- old calibration
                               I_DBLARR_STN           = i_dblarr_stn,$; --- calibration from DR3 paper
                               O_STRARR_MH_CALIBRATED = o_strarr_mh_calibrated,$;           --- string array
                               ;I_DBL_REJECTVALUE      = i_dbl_rejectvalue,$; --- double
                               ;I_DBL_REJECTERR        = rejecterr,$;       --- double
                               I_B_SEPARATE           = true

  dblarr_cmh = double(o_strarr_mh_calibrated)

  for j=0,1 do begin
    if j eq 0 then begin
      str_title_mh = 'Uncalibrated Metallicity [dex]'
      str_plot_suffix = 'mH'
    end else begin
      dblarr_mh = dblarr_cmh
      str_title_mh = 'Calibrated Metallicity [dex]'
      str_plot_suffix = 'MH'
    endelse

    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_'+str_plot_suffix+'_vs_vrad_'+str_rave_dr+'_'+str_area+'_all.ps'
    plot,dblarr_vrad,$
         dblarr_mh,$
         xtitle='Radial Velocity [km/s]',$
         ytitle=str_title_mh,$
         psym=2,$
         title=str_rave_dr + ' ' + str_plot_suffix
    device,/close

    indarr_mh = where((dblarr_mh ge dbl_mh_min) and (dblarr_mh le dbl_mh_max))
    print,'stars found in lon-lat with vrad and [m/H]: ',n_elements(indarr_mh)
;  strarr_lines = strarr_lines(indarr_mh)
;  strarr_data = strarr_data(indarr_mh,*)

    dblarr_mh = dblarr_mh(indarr_mh)
    print,'dblarr_mh(indarr_mh) = ',dblarr_mh(indarr_mh)
    dblarr_vrad = double(strarr_data(indarr_mh, int_col_vrad))
    print,'strarr_data(indarr_mh, int_col_vrad) = ',strarr_data(indarr_mh, int_col_vrad)
    dblarr_teff = double(strarr_data(indarr_mh,int_col_teff))
    print,'strarr_data(indarr_mh, int_col_teff) = ',strarr_data(indarr_mh, int_col_teff)
    dblarr_pm_ra = double(strarr_data(indarr_mh,int_col_pm_ra))
    print,'strarr_data(indarr_mh, int_col_pm_ra) = ',strarr_data(indarr_mh, int_col_pm_ra)
    dblarr_pm_dec = double(strarr_data(indarr_mh,int_col_pm_dec))
    print,'strarr_data(indarr_mh, int_col_pm_dec) = ',strarr_data(indarr_mh, int_col_pm_dec)
    dblarr_logg = double(strarr_data(indarr_mh,int_col_logg))
    print,'strarr_data(indarr_mh, int_col_logg) = ',strarr_data(indarr_mh, int_col_logg)
;stop

    ; --- cross check old stars and release
    strarr_new_data_of_old_stars = strarr(n_elements(strarr_old_stars(*,0)), n_elements(strarr_data(0,*)))
    n_found = 0
    for i=0ul, n_elements(strarr_old_star_id)-1 do begin
      indarr_found = where(strarr_data(*,int_col_rave_id) eq strarr_old_star_id(i))
      if indarr_found(0) ne -1 then begin
        strarr_new_data_of_old_stars(n_found,*) = strarr_data(indarr_found(0),*)
        n_found = n_found+1
      endif
    endfor
    print,'with '+str_plot_suffix+': ',n_found,' out of ',n_elements(strarr_old_star_id),' stars found'
    print,'with '+str_plot_suffix+': ','STN old stars = ',strarr_old_stars(*,int_col_old_stars_stn)
    print,'with '+str_plot_suffix+': ','STN new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_stn)
    print,'with '+str_plot_suffix+': ','[m/H] old stars = ',strarr_old_stars(*,int_col_old_stars_mh)
    print,'with '+str_plot_suffix+': ','[m/H] new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_mh)
    print,'with '+str_plot_suffix+': ','vrad old stars = ',strarr_old_stars(*,int_col_old_stars_vrad)
    print,'with '+str_plot_suffix+': ','vrad new data of old stars = ',strarr_new_data_of_old_stars(*,int_col_vrad)

    print,n_elements(dblarr_mh),' stars found in [m/H]'
    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_'+str_plot_suffix+'_vs_vrad_'+str_rave_dr+'_'+str_area+'.ps'
    plot,dblarr_vrad,$
         dblarr_mh,$
         xtitle='Radial Velocity [km/s]',$
         ytitle=str_title_mh,$
         psym=2,$
         title=str_rave_dr + ' ' + str_plot_suffix
    device,/close
    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_'+str_plot_suffix+'_vs_Teff_'+str_rave_dr+'_'+str_area+'.ps'
    plot,dblarr_teff,$
         dblarr_mh,$
         xtitle='Effective Temperature [K]',$
         ytitle=str_title_mh,$
         psym=2,$
         title=str_rave_dr + ' ' + str_plot_suffix
    device,/close

    dblarr_pm = sqrt((dblarr_pm_ra * dblarr_pm_ra) + (dblarr_pm_dec * dblarr_pm_dec))
    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_pm_vs_vrad-'+str_plot_suffix+'_'+str_rave_dr+'_'+str_area+'.ps'
    plot,dblarr_vrad,$
         dblarr_pm,$
         xtitle='Radial Velocity [km/s]',$
         ytitle='Reduced Proper Motion [mas/yr]',$
         psym=2,$
         title=str_rave_dr + ' ' + str_plot_suffix
    device,/close

    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_logg_vs_Teff-'+str_plot_suffix+'_'+str_rave_dr+'_'+str_area+'.ps'
    plot,dblarr_teff,$
         dblarr_logg,$
         xtitle='Effective Temperature [K]',$
         ytitle='Surface Gravity [dex]',$
         psym=2,$
         xrange=[10000.,3000.],$
         yrange=[5.5,0.],$
         xstyle = 1,$
         ystyle = 1,$
         title=str_rave_dr + ' ' + str_plot_suffix
    device,/close

    openw,lun,str_filename_out,/GET_LUN
    for i=0ul, n_elements(strarr_lines)-1 do begin
      printf,lun,strarr_lines(i)
    endfor
    free_lun,lun

    indarr_stars = ulonarr(1)
    indarr_dist = ulonarr(1)
    strarr_stars_id = strarr_data(*,int_col_id)
    strarr_dist_id = strarr_dist(*,int_col_dist_id)
    int_nfound = 0
    for i=0ul, n_elements(strarr_stars_id)-1 do begin
      indarr_dist_id = where(strarr_dist_id eq strarr_stars_id(i))
      print,'i = ',i,': indarr_dist_id = ',indarr_dist_id
      if indarr_dist_id(0) ne -1 then begin
        indarr_stars(int_nfound) = i
        indarr_dist(int_nfound) = indarr_dist_id(0)
        indarr_stars_temp = ulonarr(int_nfound+2)
        indarr_stars_temp(0:int_nfound) = indarr_stars
        indarr_dist_temp = ulonarr(int_nfound+2)
        indarr_dist_temp(0:int_nfound) = indarr_dist
        indarr_stars = indarr_stars_temp
        indarr_dist = indarr_dist_temp
        int_nfound = int_nfound+1
      endif
    endfor
    indarr_stars = indarr_stars(0:int_nfound-1)
    indarr_dist = indarr_dist(0:int_nfound-1)
    print,'indarr_stars = ',indarr_stars
    print,'indarr_dist = ',indarr_dist

    dblarr_vrad = dblarr_vrad(indarr_stars)
    dblarr_dist_pn = double(strarr_dist(indarr_dist, int_col_dist_dist_pn))
    dblarr_dist_pnr = double(strarr_dist(indarr_dist, int_col_dist_dist_pnr))

    device,filename=strmid(str_filename_out,0,strpos(str_filename_out,'.',/REVERSE_SEARCH))+'_dist_vs_vrad-'+str_plot_suffix+'_'+str_rave_dr+'_'+str_area+'.ps'
    plot,dblarr_vrad,$
         dblarr_dist_pn,$
         xtitle='Radial Velocity [km/s]',$
         ytitle='Distance [kpc]',$
         psym=2,$
         title=str_rave_dr + ' ' + str_plot_suffix
    oplot,dblarr_vrad,$
          dblarr_dist_pnr,$
          psym=3
    device,/close
  endfor


end
