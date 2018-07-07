pro rave_stream_get_stars
  i_rave_dr = 10

  if i_rave_dr eq 9 then begin
    str_filename_rave = ''
  end else if i_rave_dr eq 10 then begin
    str_filename_rave = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12.dat';_STN-gt-13-with-atm-par.dat'
  end
  
  str_filename_besancon='/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20.dat'
  
  dbl_lon_min = 240
  dbl_lon_max = 250
  dbl_lat_min = -10
  dbl_lat_max = -5
  
  vrad_min = -1200.
  vrad_max = 1200.
  
  mh_min = -3.
  mh_max = 1.
  
  i_col_lon = 5
  i_col_lat = 6
  i_col_vrad = 7
  i_col_mh = 21
  i_col_stn = 35
  i_col_snr = 33
  i_col_s2n = 34
  
  i_col_bes_lon = 0
  i_col_bes_lat = 1
  i_col_bes_imag = 2
  i_col_bes_teff = 5
  i_col_bes_logg = 6
  i_col_bes_vrad = 7
  i_col_bes_feh = 8
  
  strarr_bes = readfiletostrarr(str_filename_besancon, ' ')
  dblarr_bes_lon = double(strarr_bes(*, i_col_bes_lon))
  dblarr_bes_lat = double(strarr_bes(*, i_col_bes_lat))
  indarr_where_lon = where((dblarr_bes_lon ge dbl_lon_min) and (dblarr_bes_lon lt dbl_lon_max))
  indarr_where_lat = where((dblarr_bes_lat(indarr_where_lon) ge dbl_lat_min) and (dblarr_bes_lat(indarr_where_lon) lt dbl_lat_max))
  strarr_bes = strarr_bes(indarr_where_lon(indarr_where_lat), *)

  dblarr_bes_vrad = double(strarr_bes(*, i_col_bes_vrad))
  dblarr_bes_mh = double(strarr_bes(*, i_col_bes_feh))
  
  str_plotname_dir='/home/azuri/daten/rave/stream/red\ overdensity/'
  str_plotname_root = str_plotname_dir+strmid(str_filename_besancon,strpos(str_filename_besancon,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
  str_plotname_root = str_plotname_root+'_mH_vs_vrad_'+strmid(strtrim(string(dbl_lon_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lon_max),2),0,3)+'_'+strmid(strtrim(string(dbl_lat_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lat_max),2),0,3)
  
  set_plot,'ps'
   device,filename=str_plotname_root+'.ps'
    loadct,0
    plot,dblarr_bes_vrad,$
         dblarr_bes_mh,$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='Metallicity [dex]',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[mh_min, mh_max]
   device,/close
   print,str_plotname_root+'.ps written'
  
  strarr_rave = readfiletostrarr(str_filename_rave,' ')
  dblarr_lon = double(strarr_rave(*,i_col_lon))
  dblarr_lat = double(strarr_rave(*,i_col_lat))
  print,'dblarr_lon = ',dblarr_lon
  print,'dblarr_lat = ',dblarr_lat
  
  indarr_where_lon = where((dblarr_lon ge dbl_lon_min) and (dblarr_lon lt dbl_lon_max))
  print,'indarr_where_lon = ',indarr_where_lon
  indarr_where_lat = where((dblarr_lat(indarr_where_lon) ge dbl_lat_min) and (dblarr_lat(indarr_where_lon) lt dbl_lat_max))
  
  strarr_rave = strarr_rave(indarr_where_lon(indarr_where_lat), *)
  dblarr_lon = dblarr_lon(indarr_where_lon(indarr_where_lat))
  print,'dblarr_lon = ',dblarr_lon
  print,'dblarr_lat = ',dblarr_lat
  
  dblarr_vrad = double(strarr_rave(*,i_col_vrad))
  print,'dblarr_vrad = ',dblarr_vrad
  dblarr_mh = double(strarr_rave(*,i_col_mh))
  print,'dblarr_mh = ', dblarr_mh
  dblarr_stn = double(strarr_rave(*,i_col_stn))
  print,'dblarr_stn = ',dblarr_stn
  dblarr_snr = double(strarr_rave(*,i_col_snr))
  dblarr_s2n = double(strarr_rave(*,i_col_s2n))
;  stop
  
  str_plotname_root = str_plotname_dir+strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
  str_plotname_root = str_plotname_root+'_mH_vs_vrad_'+strmid(strtrim(string(dbl_lon_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lon_max),2),0,3)+'_'+strmid(strtrim(string(dbl_lat_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lat_max),2),0,3)
   device,filename=str_plotname_root+'.ps'
    loadct,0
    plot,dblarr_vrad,$
         dblarr_mh,$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='Uncalibrated metallicity [dex]',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[mh_min, mh_max]
    oplot,[mean(dblarr_vrad), mean(dblarr_vrad)],$
          [mh_min,mh_max]
    oplot,[vrad_min, vrad_max],$
          [mean(dblarr_mh),mean(dblarr_mh)]
    oplot,[mean(dblarr_vrad)-stddev(dblarr_vrad), mean(dblarr_vrad)-stddev(dblarr_vrad)],$
          [mh_min,mh_max]
    oplot,[mean(dblarr_vrad)+stddev(dblarr_vrad), mean(dblarr_vrad)+stddev(dblarr_vrad)],$
          [mh_min,mh_max]
    oplot,[vrad_min, vrad_max],$
          [mean(dblarr_mh)-stddev(dblarr_mh),mean(dblarr_mh)-stddev(dblarr_mh)]
    oplot,[vrad_min, vrad_max],$
          [mean(dblarr_mh)+stddev(dblarr_mh),mean(dblarr_mh)+stddev(dblarr_mh)]
   device,/close
   print,str_plotname_root+'.ps written'

   device,filename=str_plotname_root+'_stn-gt-13.ps'
    indarr_stn = where(dblarr_stn ge 13)
    loadct,0
    plot,dblarr_vrad(indarr_stn),$
         dblarr_mh(indarr_stn),$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='Uncalibrated metallicity [dex]',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[mh_min, mh_max]
   device,/close
   print,str_plotname_root+'_stn-gt-13.ps written'

  str_plotname_root = str_plotname_dir+strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
  str_plotname_root = str_plotname_root+'_STN_vs_vrad_'+strmid(strtrim(string(dbl_lon_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lon_max),2),0,3)+'_'+strmid(strtrim(string(dbl_lat_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lat_max),2),0,3)
   device,filename=str_plotname_root+'.ps'
    loadct,0
    indarr_stn = where(dblarr_stn ge 20.)
    dblarr_stn(indarr_stn) = 19.9
    plot,dblarr_vrad,$
         dblarr_stn,$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='STN',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[0.,20.]
   device,/close

  str_plotname_root = str_plotname_dir+strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
   str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
   str_plotname_root = str_plotname_root+'_SNR_vs_vrad_'+strmid(strtrim(string(dbl_lon_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lon_max),2),0,3)+'_'+strmid(strtrim(string(dbl_lat_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lat_max),2),0,3)
   device,filename=str_plotname_root+'.ps'
    loadct,0
    indarr_snr = where(dblarr_snr ge 20.)
    dblarr_snr(indarr_snr) = 19.9
    plot,dblarr_vrad,$
         dblarr_snr,$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='SNR',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[0.,20.]
   device,/close

  str_plotname_root = str_plotname_dir+strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
   str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
   str_plotname_root = str_plotname_root+'_S2N_vs_vrad_'+strmid(strtrim(string(dbl_lon_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lon_max),2),0,3)+'_'+strmid(strtrim(string(dbl_lat_min),2),0,3)+'-'+strmid(strtrim(string(dbl_lat_max),2),0,3)
   device,filename=str_plotname_root+'.ps'
    loadct,0
    indarr_s2n = where(dblarr_s2n ge 20.)
    dblarr_s2n(indarr_s2n) = 19.9
    plot,dblarr_vrad,$
         dblarr_s2n,$
         xtitle='Heliocentric radial velocity [km/s]',$
         ytitle='S2N',$
         psym=4,$
         symsize=1.4,$
         charsize=1.8,$
         xrange=[vrad_min, vrad_max],$
         yrange=[0.,20.]
   device,/close
   
   indarr_vrad = where(dblarr_vrad lt -80. or dblarr_vrad gt 200.)
   indarr_mh = where(dblarr_mh(indarr_vrad) gt -0.2)
   
   print,'strarr_rave(indarr_vrad(indarr_mh), 0:2) = ', strarr_rave(indarr_vrad(indarr_mh), 0:2)
   print,'strarr_rave(indarr_vrad(indarr_mh), i_col_stn) = ', strarr_rave(indarr_vrad(indarr_mh), i_col_stn)

   set_plot,'x'
end
