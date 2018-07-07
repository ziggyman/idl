pro rave_plot_fields_mean_contours, I_STR_PATH = i_str_path,$
                                    I_B_SIGMA = i_b_sigma,$
                                    I_B_NEW_FIELDSFILE = i_b_new_fieldsfile,$
                                    I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                                    I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                                    I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

  if not keyword_set(I_DBL_PIXSIZE_LON) then $
    i_dbl_pixsize_lon = 5.
  if not keyword_set(I_DBL_PIXSIZE_LAT) then $
    i_dbl_pixsize_lat = 5.
  if not keyword_set(I_B_DO_SIGMA_CLIPPING) then $
    i_b_do_sigma_clipping = 0
  if keyword_set(I_B_SIGMA) then begin
    b_sigma = 1
  end else begin
    b_sigma = 0
  end
  if keyword_set(I_B_NEW_FIELDSFILE) then $
    b_new_fieldsfile = 1 $
  else $
    b_new_fieldsfile = 1

;  str_fieldsfile = '/home/azuri/daten/rave/rave_data/fields_lon_lat_10x10.dat'

  if keyword_set(I_STR_PATH) then begin
    str_path = i_str_path
  end else begin
    str_path = '/home/azuri/daten/besancon/lon-lat/html/5x5/calibrated-merged/sample_logg/popid/logg_0.0-3.5/vrad_MH/I9.00-12.0/';best_error_fit/sample_logg/dr3_calib/popid/logg_0.0-3.5/Teff_logg/I9.00-12.0/'
  endelse

;    str_path = str_path + '/Teff_logg/I9.00-12.0/'
  str_filelist = str_path+'meanfiles.list'

  str_xy = str_path
  str_xy = strmid(str_xy,0,strpos(str_xy,'/',/REVERSE_SEARCH))
  str_xy = strmid(str_xy,0,strpos(str_xy,'/',/REVERSE_SEARCH))
  str_xy = strmid(str_xy,strpos(str_xy,'/',/REVERSE_SEARCH)+1)
  str_x = strmid(str_xy,0,strpos(str_xy,'_'))
  str_y = strmid(str_xy,strpos(str_xy,'_')+1)

  spawn,'ls '+str_path+'*/mean_sigma_x_y.dat > '+str_filelist

  strarr_files = readfilelinestoarr(str_filelist)
;  print,'strarr_files = ',strarr_files

;  strarr_fields = readfiletostrarr(str_fieldsfile,' ')


  int_npix_lon = long(360. / i_dbl_pixsize_lon)
  dblarr_pix_lon = dblarr(int_npix_lon)
  dblarr_pix_lon(0) = i_dbl_pixsize_lon / 2.
  for i=1ul, int_npix_lon-1 do begin
    dblarr_pix_lon(i) = dblarr_pix_lon(i-1) + i_dbl_pixsize_lon
  endfor

  int_npix_lat = long(180. / i_dbl_pixsize_lat)
  dblarr_pix_lat = dblarr(int_npix_lat)
  dblarr_pix_lat(0) = -90. + i_dbl_pixsize_lat / 2.
  for i=1ul, int_npix_lat-1 do begin
    dblarr_pix_lat(i) = dblarr_pix_lat(i-1) + i_dbl_pixsize_lat
  endfor

  dblarr_pix_lon_lat = dblarr(int_npix_lon,int_npix_lat,2)
  for i=0ul,int_npix_lon-1 do begin
    dblarr_pix_lon_lat(i,*,1) = dblarr_pix_lat
  endfor
  for i=0ul,int_npix_lat-1 do begin
    dblarr_pix_lon_lat(*,i,0) = dblarr_pix_lon
  endfor

  print,'dblarr_pix_lon_lat(0,0,0) = ',dblarr_pix_lon_lat(0,0,0)
  print,'dblarr_pix_lon_lat(0,0,1) = ',dblarr_pix_lon_lat(0,0,1)
  print,'dblarr_pix_lon_lat(1,0,0) = ',dblarr_pix_lon_lat(1,0,0)
  print,'dblarr_pix_lon_lat(1,0,1) = ',dblarr_pix_lon_lat(1,0,1)
;stop
  for oo=0,3 do begin; --- mean, sigma, skewness, kurtosis
    dblarr_lon = dblarr(n_elements(strarr_files)); center longitude of swath
    dblarr_lat = dblarr(n_elements(strarr_files)); center latitude of swath
    dblarr_diff_mean = dblarr(n_elements(strarr_files),2); rave mean x and y
    dblarr_moments = dblarr(n_elements(strarr_files),6); --- 0... RAVE mean(x)
                                                       ; --- 1... Bes mean(x)
                                                       ; --- 2... Bes sigma(x)
                                                       ; --- 3... RAVE mean(y)
                                                       ; --- 4... Bes mean(y)
                                                       ; --- 5... Bes sigma(y)
    dblarr_nfields_lon = dblarr(n_elements(strarr_files),2); 0: number of swaths with longitude 1
    int_nlons_found = 0
    dblarr_nfields_lat = dblarr(n_elements(strarr_files),2); 0: number of swaths with latitude 1
    int_nlats_found = 0
;    dblarr_nfields_lon = dblarr(n_elements(strarr_files),2)

    dblarr_pix_lon_lat_data = dblarr(int_npix_lon,int_npix_lat,6); --- 0... RAVE mean(x)
                                                            ; --- 1... Bes mean(x)
                                                            ; --- 2... Bes sigma(x)
                                                            ; --- 3... RAVE mean(y)
                                                            ; --- 4... Bes mean(y)
                                                            ; --- 5... Bes sigma(y)

;    dblarr_pix_lon_lat_data_out = dblarr(int_npix_lon,int_npix_lat,2); --- 0... diff mean(x) (absolute or in sigmas)
                                                            ; --- 1... diff mean(y) (absolute or in sigmas)

    for i=0ul, n_elements(strarr_files)-1 do begin; --- for all fields
      str_lon_lat = strmid(strarr_files(i),strlen(str_path))
      print,'str_lon_lat = '+str_lon_lat
      dbl_lon_start = double(strmid(str_lon_lat,0,strpos(str_lon_lat,'-')))
      str_lon_lat = strmid(str_lon_lat,strpos(str_lon_lat,'-')+1)
      dbl_lon_end = double(strmid(str_lon_lat,0,strpos(str_lon_lat,'_')))
      dblarr_lon(i) = (dbl_lon_start + dbl_lon_end) / 2.

;      indarr_there = where(abs(dblarr_nfields_lon(*,1) - dblarr_lon(i)) lt 0.001)
;      if indarr_there(0) lt 0 then begin
;        dblarr_nfields_lon(int_nlons_found,1) = dblarr_lon(i)
;        dblarr_nfields_lon(int_nlons_found,0) = 1.
;        int_nlons_found += 1
;      end else begin
;        print,'indarr_there = ',indarr_there
;        dblarr_nfields_lon(indarr_there,0) += 1.
;      endelse

      str_lon_lat = strmid(str_lon_lat,strpos(str_lon_lat,'_')+1)
      if strmid(str_lon_lat,0,1) eq '-' then begin
        str_lon_lat = strmid(str_lon_lat,1)
        dbl_lat_start = 0. - double(strmid(str_lon_lat,0,strpos(str_lon_lat,'-')))
      end else begin
        dbl_lat_start = double(strmid(str_lon_lat,0,strpos(str_lon_lat,'-')))
      endelse
      str_lon_lat = strmid(str_lon_lat,strpos(str_lon_lat,'-')+1)
      dbl_lat_end = double(strmid(str_lon_lat,0,strpos(str_lon_lat,'/')))
      dblarr_lat(i) = (dbl_lat_start + dbl_lat_end) / 2.

      indarr_where_lon = where((dbl_lon_start le dblarr_pix_lon) and (dbl_lon_end gt dblarr_pix_lon))
      print,'dbl_lon_start = ',dbl_lon_start
      print,'dbl_lon_end = ',dbl_lon_end
      print,'dblarr_pix_lon(indarr_where_lon) = ',dblarr_pix_lon(indarr_where_lon)

      indarr_where_lat = where((dbl_lat_start le dblarr_pix_lat) and (dbl_lat_end gt dblarr_pix_lat))
      print,'dbl_lat_start = ',dbl_lat_start
      print,'dbl_lat_end = ',dbl_lat_end
      print,'dblarr_pix_lat(indarr_where_lat) = ',dblarr_pix_lat(indarr_where_lat)
;stop
;      indarr_there = where(abs(dblarr_nfields_lat(*,1) - dblarr_lat(i)) lt 0.001)
;      if indarr_there(0) lt 0 then begin
;        dblarr_nfields_lat(int_nlats_found,1) = dblarr_lat(i)
;        dblarr_nfields_lat(int_nlats_found,0) = 1.
;        int_nlats_found += 1
;      end else begin
;        print,'indarr_there = ',indarr_there
;        dblarr_nfields_lat(indarr_there,0) += 1.
;      endelse
;  ;    print,'dblarr_lon(i=',i,') = ',dblarr_lon(i)
;  ;    print,'dblarr_lat(i=',i,') = ',dblarr_lat(i)

      ; --- read mean file
      strarr_data = readfiletostrarr(strarr_files(i),' ')

      if abs(double(strarr_data(2,2))) ge 0.000000000000001 then begin
        dblarr_diff_mean(i,0) = double(strarr_data(0,1+oo))
        dblarr_diff_mean(i,1) = double(strarr_data(0,5+oo))

        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,0) = dblarr_diff_mean(i,0)
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,3) = dblarr_diff_mean(i,1)
        endfor

        dblarr_moments(i,0) = dblarr_diff_mean(i,0)
        dblarr_moments(i,3) = dblarr_diff_mean(i,1)

        dblarr_mean_bes = double(strarr_data(2:n_elements(strarr_data(*,0))-1,0+oo))
        dblarr_moment = moment(dblarr_mean_bes)
        dblarr_diff_mean(i,0) = dblarr_diff_mean(i,0) - dblarr_moment(0)

        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,1) = dblarr_moment(0)
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,2) = sqrt(dblarr_moment(1))
        endfor

        dblarr_moments(i,1) = dblarr_moment(0)
        dblarr_moments(i,2) = sqrt(dblarr_moment(1))

        dblarr_mean_bes = double(strarr_data(2:n_elements(strarr_data(*,0))-1,4+oo))
        dblarr_moment = moment(dblarr_mean_bes)
        dblarr_diff_mean(i,1) = dblarr_diff_mean(i,1) - dblarr_moment(0)

        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,4) = dblarr_moment(0)
          dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,5) = sqrt(dblarr_moment(1))
          print,'dblarr_pix_lon_lat_data(indarr_where_lon(i_lon=',i_lon,'),indarr_where_lat,*) = ',dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,*)
        endfor

;stop

        dblarr_moments(i,4) = dblarr_moment(0)
        dblarr_moments(i,5) = sqrt(dblarr_moment(1))
      endif
    endfor; all fields

    for iii=0,n_elements(dblarr_pix_lon)-1 do begin
      for jjj=0,n_elements(dblarr_pix_lat)-1 do begin
        print,'dblarr_pix_lon_lat_data(iii,jjj,*) = ',dblarr_pix_lon(iii),dblarr_pix_lat(jjj),dblarr_pix_lon_lat_data(iii,jjj,0),dblarr_pix_lon_lat_data(iii,jjj,1),dblarr_pix_lon_lat_data(iii,jjj,2),dblarr_pix_lon_lat_data(iii,jjj,3),dblarr_pix_lon_lat_data(iii,jjj,4),dblarr_pix_lon_lat_data(iii,jjj,5)
      endfor
    endfor

    ; --- reject Ken Russel's stars
    indarr_reject_lon = where((dblarr_pix_lon_lat(*,0,0) lt 220.) or (dblarr_pix_lon_lat(*,0,0) gt 315.))
    for iii=0ul, n_elements(indarr_reject_lon)-1 do begin
      indarr_reject_lat = where(abs(dblarr_pix_lon_lat(indarr_reject_lon(iii),*,1)) lt 25.,count)
      if count ge 1 then begin
        print,'dblarr_pix_lon_lat_data(indarr_reject_lon(',iii,',indarr_reject_lat,*) = ',dblarr_pix_lon_lat_data(indarr_reject_lon(iii),indarr_reject_lat,*)
        dblarr_pix_lon_lat_data(indarr_reject_lon(iii),indarr_reject_lat,*) = 0.
      endif
    endfor
;    stop

    dblarr_pix_lon_lat_data_rave_x = dblarr_pix_lon_lat_data(*,*,0)
    dblarr_pix_lon_lat_data_bes_x = dblarr_pix_lon_lat_data(*,*,1)
    dblarr_pix_lon_lat_data_bes_xsig = dblarr_pix_lon_lat_data(*,*,2)
    dblarr_pix_lon_lat_data_rave_y = dblarr_pix_lon_lat_data(*,*,3)
    dblarr_pix_lon_lat_data_bes_y = dblarr_pix_lon_lat_data(*,*,4)
    dblarr_pix_lon_lat_data_bes_ysig = dblarr_pix_lon_lat_data(*,*,5)

    if b_sigma then begin
      indarr_good = where(abs(dblarr_pix_lon_lat_data_bes_xsig) ge 0.000000001 )
      dblarr_pix_lon_lat_data_rave_minus_bes_x = dblarr_pix_lon_lat_data_bes_xsig
      dblarr_pix_lon_lat_data_rave_minus_bes_x(indarr_good) = (dblarr_pix_lon_lat_data_rave_x(indarr_good) - dblarr_pix_lon_lat_data_bes_x(indarr_good)) / dblarr_pix_lon_lat_data_bes_xsig(indarr_good)

      indarr_good = where(abs(dblarr_pix_lon_lat_data_bes_ysig) ge 0.000000001 )
      dblarr_pix_lon_lat_data_rave_minus_bes_y = dblarr_pix_lon_lat_data_bes_ysig
      dblarr_pix_lon_lat_data_rave_minus_bes_y(indarr_good) = (dblarr_pix_lon_lat_data_rave_y(indarr_good) - dblarr_pix_lon_lat_data_bes_y(indarr_good)) / dblarr_pix_lon_lat_data_bes_ysig(indarr_good)
    end else begin
      dblarr_pix_lon_lat_data_rave_minus_bes_x = dblarr_pix_lon_lat_data_rave_x - dblarr_pix_lon_lat_data_bes_x
      dblarr_pix_lon_lat_data_rave_minus_bes_y = dblarr_pix_lon_lat_data_rave_y - dblarr_pix_lon_lat_data_bes_y
    endelse

    dblarr_pix_lon_lat_data_rave_x_smoothed_once = dblarr_pix_lon_lat_data_rave_x
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_x_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_x_smoothed_twice = dblarr_pix_lon_lat_data_rave_x_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_x_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_y_smoothed_once = dblarr_pix_lon_lat_data_rave_y
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_y_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_y_smoothed_twice = dblarr_pix_lon_lat_data_rave_y_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_y_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_bes_x_smoothed_once = dblarr_pix_lon_lat_data_bes_x
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_bes_x_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_bes_x_smoothed_twice = dblarr_pix_lon_lat_data_bes_x_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_bes_x_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_bes_y_smoothed_once = dblarr_pix_lon_lat_data_bes_y
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_bes_y_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_bes_y_smoothed_twice = dblarr_pix_lon_lat_data_bes_y_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_bes_y_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_once = dblarr_pix_lon_lat_data_rave_minus_bes_x
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_twice = dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_once = dblarr_pix_lon_lat_data_rave_minus_bes_y
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_once,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

    dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_twice = dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_once
    rave_do_boxcar_smoothing, IO_DBLARR_DATA   = dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_twice,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

; --- run boxcar smoothing
;    for iii=0,n_elements(dblarr_pix_lon)-1 do begin
;      for jjj=0,n_elements(dblarr_pix_lat)-1 do begin
;        if (abs(dblarr_pix_lon_lat_data(iii, jjj, 0)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(iii, jjj, 1)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(iii, jjj, 2)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(iii, jjj, 3)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(iii, jjj, 4)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(iii, jjj, 5)) ge 0.000000001) then begin
;          indarr_where_lon = where((dblarr_pix_lon(iii) - (i_dbl_pixsize_lon / 2.)-i_dbl_pixsize_lon le dblarr_pix_lon) and (dblarr_pix_lon(iii) + (i_dbl_pixsize_lon / 2.) + i_dbl_pixsize_lon gt dblarr_pix_lon))
;          print,'indarr_where_lon = ',indarr_where_lon

;          indarr_where_lat = where((dblarr_pix_lat(jjj) - (i_dbl_pixsize_lat / 2.) - i_dbl_pixsize_lat le dblarr_pix_lat) and (dblarr_pix_lat(jjj) + (i_dbl_pixsize_lat / 2.) + i_dbl_pixsize_lat gt dblarr_pix_lat))
;          print,'indarr_where_lat = ',indarr_where_lat

;          print,'number of pixels in boxcar: ',n_elements(indarr_where_lon) * n_elements(indarr_where_lat)

;          int_n_gt_0 = 0
;          for i_lon=0, n_elements(indarr_where_lon)-1 do begin
;            indarr_gt_0 = where((abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,0)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,1)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,2)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,3)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,4)) ge 0.000000001) and (abs(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon), indarr_where_lat,5)) ge 0.000000001))
;            if indarr_gt_0(0) ge 0 then $
;              int_n_gt_0 += n_elements(indarr_gt_0)
;          endfor

;          print,'number of non-zero pixels in boxcar: ',int_n_gt_0
;          print,'dblarr_pix_lon_lat_data_out(iii,jjj,*) = ',dblarr_pix_lon_lat_data_out(iii,jjj,*)
;
;          for i_lon=0, n_elements(indarr_where_lon)-1 do begin
;            if b_sigma then begin
;              dblarr_pix_lon_lat_data_out(iii,jjj,0) += total((dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,0) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,1)) / dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,2))
;              dblarr_pix_lon_lat_data_out(iii,jjj,1) += (total((dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,3) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,4)) / dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,5)))
;            end else begin
;              print,'dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,0) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,1) = ',dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,0) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,1)
;              dblarr_pix_lon_lat_data_out(iii,jjj,0) += total(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,0) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,1))
;              dblarr_pix_lon_lat_data_out(iii,jjj,1) += total(dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,3) - dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,4))
;            endelse
;            print,'i_lon = ',i_lon,': dblarr_pix_lon_lat_data_out(iii,jjj,0) = ',dblarr_pix_lon_lat_data_out(iii,jjj,0),', dblarr_pix_lon_lat_data_out(iii,jjj,1) = ',dblarr_pix_lon_lat_data_out(iii,jjj,1)
;          endfor
;          dblarr_pix_lon_lat_data_out(iii,jjj,0) = dblarr_pix_lon_lat_data_out(iii,jjj,0) / int_n_gt_0
;          dblarr_pix_lon_lat_data_out(iii,jjj,1) = dblarr_pix_lon_lat_data_out(iii,jjj,1) / int_n_gt_0
;          print,'dblarr_pix_lon_lat_data(iii,jjj,*) = ',dblarr_pix_lon_lat_data(iii,jjj,*)
;          for i_lon=0, n_elements(indarr_where_lon)-1 do begin
;            print,'dblarr_pix_lon_lat_data(indarr_where_lon(',i_lon,'),indarr_where_lat,*) = ',dblarr_pix_lon_lat_data(indarr_where_lon(i_lon),indarr_where_lat,*)
;          endfor
;          print,'dblarr_pix_lon_lat_data_out(iii,jjj,0) = ',dblarr_pix_lon_lat_data_out(iii,jjj,0),', dblarr_pix_lon_lat_data_out(iii,jjj,1) = ',dblarr_pix_lon_lat_data_out(iii,jjj,1)
;stop
;        endif
;      endfor
;    endfor
;    stop

 ;   dblarr_nfields_lon = dblarr_nfields_lon(0:int_nlons_found-1,*)
 ;   print,'dblarr_nfields_lon(*,0) = ',dblarr_nfields_lon(*,0)
 ;   print,'dblarr_nfields_lon(*,1) = ',dblarr_nfields_lon(*,1)
 ;   indarr_lons_sort = sort(dblarr_nfields_lon(*,1))
 ;   dblarr_nfields_lon = dblarr_nfields_lon(indarr_lons_sort,*)
 ;   print,'dblarr_nfields_lon(*,0) = ',dblarr_nfields_lon(*,0)
 ;   print,'dblarr_nfields_lon(*,1) = ',dblarr_nfields_lon(*,1)

;    dblarr_nfields_lat = dblarr_nfields_lat(0:int_nlats_found-1,*)
;    print,'dblarr_nfields_lat = ',dblarr_nfields_lat
;    indarr_lats_sort = sort(dblarr_nfields_lat(*,1))
;    dblarr_nfields_lat = dblarr_nfields_lat(indarr_lats_sort,*)
;    print,'dblarr_nfields_lat = ',dblarr_nfields_lat
;    stop

;    print,'dblarr_diff_mean = ',dblarr_diff_mean
;;    if oo eq 1 then begin
;      print,'dblarr_lon = ',dblarr_lon
;      print,'dblarr_lat = ',dblarr_lat
;      print,'dblarr_moments = ',dblarr_moments
;
;      indarr_temp = where(dblarr_lat lt -85.)
;      print,'dblarr_lon(lat < -85) = ',dblarr_lon(indarr_temp)
;      print,'dblarr_lat(lat < -85) = ',dblarr_lat(indarr_temp)
;      print,'dblarr_moments(lat < -85) = ',dblarr_moments(indarr_temp,*)
;;      stop
;;    endif
;    dblarr_moment = 0
;    dblarr_mean_bes = 0

    for int_n_smoothings = 0,2 do begin; --- smoothings
      for ll = 0, 1 do begin; --- x and y
        if ll eq 0 then begin
          str_xy = str_x
        end else begin
          str_xy = str_y
        end
        str_plotname_root = str_path
        if oo eq 0 then begin
          str_plotname_root = str_plotname_root+'mean'
        end else if oo eq 1 then begin
          str_plotname_root = str_plotname_root+'sigma'
        end else if oo eq 2 then begin
          str_plotname_root = str_plotname_root+'skewness'
        end else begin
          str_plotname_root = str_plotname_root+'kurtosis'
        end
        str_plotname_root = str_plotname_root + '_contours_'+str_xy
        str_plotname_root = str_plotname_root+'_'+strtrim(string(int_n_smoothings),2)+'smoothings'
        if b_sigma then begin
          str_plotname_root = str_plotname_root + '_meansig'
        endif
        str_plotname_root_temp = str_plotname_root
        if b_sigma then $
          int_loop_end = 0 $
        else $
          int_loop_end = 2
        for i_plot=0,int_loop_end do begin
          if i_plot eq 1 then begin
            str_plotname_root = str_plotname_root_temp + '_abs-rave'
          end else if i_plot eq 2 then begin
            str_plotname_root = str_plotname_root_temp + '_abs-bes'
          end
          set_plot,'ps'
          device,filename=str_plotname_root+'.ps',/color
          loadct,0
          plot,[0,360],$
              [-90.,-90.],$
              xrange = [0.,360.],$
              xstyle=1,$
              yrange = [-90.,90.],$
              ystyle=1,$
              xtitle = 'Galactic Longitude [deg]',$
              ytitle = 'Galactic Latitude [deg]',$
              position=[0.16,0.164,0.85,0.99],$
              thick=3.,$
              charthick=3.,$
              charsize=1.8,$
              yticks=4,$
              yminor=9,$
              xticks=4,$
              xtickinterval=90.,$
              xminor=9,$
              xtickname=['0','90','180','270','360'],$
              xtickformat='(I4)',$
              ytickformat='(I3)'

          red = intarr(256)
          green = intarr(256)
          blue = intarr(256)
          rave_get_colour_table,B_POP_ID    = 2,$
                                RED         = red,$
                                GREEN       = green,$
                                BLUE        = blue;,$
  ;                              DBL_N_TYPES = dbl_n_types
        ;      print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
          ltab = 0
          modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_rave_plot_fields_mean.tbl'
          loadct,ltab,FILE='colors1_rave_plot_fields_mean.tbl'
          for i=0ul,n_elements(dblarr_pix_lon)-1 do begin; --- all rows
            for j=0ul,n_elements(dblarr_pix_lat)-1 do begin; --- all cols
              if (abs(dblarr_pix_lon_lat_data(i,j,0)) ge 0.000000000000001) or (abs(dblarr_pix_lon_lat_data(i,j,1)) ge 0.000000000000001) or (abs(dblarr_pix_lon_lat_data(i,j,2)) ge 0.000000000000001) or (abs(dblarr_pix_lon_lat_data(i,j,3)) ge 0.000000000000001) or (abs(dblarr_pix_lon_lat_data(i,j,4)) ge 0.000000000000001) or (abs(dblarr_pix_lon_lat_data(i,j,5)) ge 0.000000000000001) then begin
                if i eq 0 then begin
                  x0 = 0.
                  x1 = (dblarr_pix_lon(i) + dblarr_pix_lon(i+1)) / 2.
                end else if i eq n_elements(dblarr_pix_lon)-1 then begin
                  x0 = (dblarr_pix_lon(i-1) + dblarr_pix_lon(i)) / 2.
                  x1 = 360.
                end else begin
                  x0 = (dblarr_pix_lon(i-1) + dblarr_pix_lon(i)) / 2.
                  x1 = (dblarr_pix_lon(i) + dblarr_pix_lon(i+1)) / 2.
                endelse

                if j eq 0 then begin
                  y0 = -90.
                  y1 = (dblarr_pix_lat(j) + dblarr_pix_lat(j+1)) / 2.
                end else if j eq n_elements(dblarr_pix_lat)-1 then begin
                  y0 = (dblarr_pix_lat(j-1) + dblarr_pix_lat(j)) / 2.
                  y1 = 90.
                end else begin
                  y0 = (dblarr_pix_lat(j-1) + dblarr_pix_lat(j)) / 2.
                  y1 = (dblarr_pix_lat(j) + dblarr_pix_lat(j+1)) / 2.
                endelse
                if i_plot eq 0 then begin
                  if ll eq 0 then begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_x
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_x_smoothed_twice
                    endelse
                  end else begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_y
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_minus_bes_y_smoothed_twice
                    endelse
                  endelse
                end else if i_plot eq 1 then begin
                  if ll eq 0 then begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_x
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_x_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_x_smoothed_twice
                    endelse
                  end else begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_y
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_y_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_rave_y_smoothed_twice
                    endelse
                  endelse
                end else begin
                  if ll eq 0 then begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_x
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_x_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_x_smoothed_twice
                    endelse
                  end else begin
                    if int_n_smoothings eq 0 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_y
                    end else if int_n_smoothings eq 1 then begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_y_smoothed_once
                    end else begin
                      dblarr_plot = dblarr_pix_lon_lat_data_bes_y_smoothed_twice
                    endelse
                  endelse
                endelse
                if b_sigma then begin
                  dbl_diff_min = 0. - 3.;min(dblarr_plot(indarr))
                  dbl_diff_max = 3.;max(dblarr_plot(indarr))
                  int_colour = (254 / 2) + long(dblarr_plot(i,j) * 254. / 6.)
                end else begin
                  indarr = where(abs(dblarr_plot) gt 0.)
                  ;if i_plot eq 0 then begin
                  if i_plot eq 0 then begin
                    dbl_diff_min = min(dblarr_plot(indarr))
                    dbl_diff_max = max(dblarr_plot(indarr))
                  end else begin
                    if ll eq 0 then begin
                      if int_n_smoothings eq 0 then begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_x(indarr),dblarr_pix_lon_lat_data_bes_x(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_x(indarr),dblarr_pix_lon_lat_data_bes_x(indarr)])
                      end else if int_n_smoothings eq 1 then begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_x_smoothed_once(indarr),dblarr_pix_lon_lat_data_bes_x_smoothed_once(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_x_smoothed_once(indarr),dblarr_pix_lon_lat_data_bes_x_smoothed_once(indarr)])
                      end else begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_x_smoothed_twice(indarr),dblarr_pix_lon_lat_data_bes_x_smoothed_twice(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_x_smoothed_twice(indarr),dblarr_pix_lon_lat_data_bes_x_smoothed_twice(indarr)])
                      endelse
                    end else begin
                      if int_n_smoothings eq 0 then begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_y(indarr),dblarr_pix_lon_lat_data_bes_y(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_y(indarr),dblarr_pix_lon_lat_data_bes_y(indarr)])
                      end else if int_n_smoothings eq 1 then begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_y_smoothed_once(indarr),dblarr_pix_lon_lat_data_bes_y_smoothed_once(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_y_smoothed_once(indarr),dblarr_pix_lon_lat_data_bes_y_smoothed_once(indarr)])
                      end else begin
                        dbl_diff_min = min([dblarr_pix_lon_lat_data_rave_y_smoothed_twice(indarr),dblarr_pix_lon_lat_data_bes_y_smoothed_twice(indarr)])
                        dbl_diff_max = max([dblarr_pix_lon_lat_data_rave_y_smoothed_twice(indarr),dblarr_pix_lon_lat_data_bes_y_smoothed_twice(indarr)])
                      endelse
                    endelse
                  endelse
                  int_colour = long((dblarr_plot(i,j) - dbl_diff_min) * 254. / (dbl_diff_max - dbl_diff_min)); + 3
                  ;end else if i_plot eq 1 then begin
                  ;  int_colour = long((dblarr_plot(i,j) - min([dblarr_plot(indarr),dblarr_plot(indarr)])) * 254. / (max([dblarr_plot(indarr),dblarr_plot(indarr)]) - min([dblarr_plot(indarr),dblarr_plot(indarr)]))); + 3
                  ;end else begin
                  ;  int_colour = long((dblarr_absolute_bes_smooth(i,j) - min([dblarr_absolute_bes_smooth(indarr),dblarr_absolute_bes_smooth(indarr)])) * 254. / (max([dblarr_absolute_rave_smooth(indarr),dblarr_absolute_bes_smooth(indarr)]) - min([dblarr_absolute_rave_smooth(indarr),dblarr_absolute_bes_smooth(indarr)]))); + 3
                  ;endelse
                endelse
                if int_colour lt 1 then int_colour = 1
                if int_colour gt 254 then int_colour = 254
    ;            print,'i=',i,', j=',j,': x0 = ',x0,', x1 = ',x1,', y0 = ',y0,', y1 = ',y1,' dblarr_diff_smooth(i,j) = ',dblarr_diff_smooth(i,j),' int_colour = ',int_colour
                box,x0,y0,x1,y1,int_colour
              endif
            endfor; --- all cols
          endfor; --- all rows

        ;  if int_method eq 0 then begin
        ;    print,'dblarr_2d = ',dblarr_2d
        ;    shade_surf,dblarr_2d,$
        ;              dblarr_x,$
        ;              dblarr_y,$
        ;  ;             /IRREGULAR,$
        ;              ax=30,$
        ;              az=30
        ;  ;  contour,dblarr_surf,$
        ;  ;          dblarr_lon,$
        ;  ;          dblarr_lat,$
        ;  ;          /IRREGULAR
        ;  ;  ;        /OVERPLOT
        ;  end else if int_method eq 1 then begin
        ;    shade_surf,dblarr_surf,$
        ;;              dblarr_x,$
        ;;              dblarr_y,$
        ;  ;             /IRREGULAR,$
        ;              ax=90,$
        ;              az=0
        ;  end else begin
        ;;    shade_surf,dblarr_diff_smooth,$
        ;;              dblarr_x_smooth,$
        ;;              dblarr_y_smooth,$
        ;;  ;             /IRREGULAR,$
        ;;              ax=30,$
        ;;              az=30
          loadct,0
          indarr = where(abs(dblarr_plot) gt 0.)

          dblarr_c_thick = replicate(3.,8)
          if strtrim(string(dbl_diff_max),2) eq 'Infinity' then begin
            print,'rave_plot_fields_mean_contours: PROBLEM: dbl_diff_max == Infinity'
            stop
          endif
          if strtrim(string(dbl_diff_max),2) eq 'NaN' then begin
            print,'rave_plot_fields_mean_contours: PROBLEM: dbl_diff_max == NaN'
            stop
          endif
          if strtrim(string(dbl_diff_min),2) eq 'NaN' then begin
            print,'rave_plot_fields_mean_contours: PROBLEM: dbl_diff_min == NaN'
            stop
          endif
          if b_sigma then begin
;            indarr_temp = where(abs(dblarr_meansig_smooth(indarr) - dbl_diff_min) lt 0.0000000001)
;            print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_pix_lat(min) = ',dblarr_pix_lon(indarr(indarr_temp))
;            print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_pix_lon(min) = ',dblarr_pix_lat(indarr(indarr_temp))
;            indarr_temp = where(abs(dblarr_meansig_smooth(indarr) - dbl_diff_max) lt 0.0000000001)
;            print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_pix_lat(max) = ',dblarr_pix_lon(indarr(indarr_temp))
;            print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_pix_lat(max) = ',dblarr_pix_lat(indarr(indarr_temp))
            dblarr_levels=indgen(8)
            dblarr_levels= 0. - 3. + dblarr_levels * 6. / 7.
            print,'dblarr_levels = ',dblarr_levels
          end else begin
;            if i_plot eq 0 then begin
;              dbl_diff_min = min(dblarr_plot(indarr))
;              dbl_diff_max = max(dblarr_plot(indarr))
;              indarr_temp = where(abs(dblarr_plot - dbl_diff_min) lt 0.0000000001)
;              print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_(min) = ',dblarr_x_smooth(indarr_temp)
;              print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_y_smooth(min) = ',dblarr_y_smooth(indarr_temp)
;              indarr_temp = where(abs(dblarr_diff_smooth - dbl_diff_max) lt 0.00000000001)
;              print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_x_smooth(max) = ',dblarr_x_smooth(indarr_temp)
;              print,'int_n_smoothings = ',int_n_smoothings,', ll = ',ll,': dblarr_y_smooth(max) = ',dblarr_y_smooth(indarr_temp)
;              dblarr_contour_plot = dblarr_plot
;            end else if i_plot eq 1 then begin
;              dbl_diff_min = min([dblarr_absolute_rave_smooth(indarr),dblarr_absolute_bes_smooth(indarr)])
;              dbl_diff_max = max([dblarr_absolute_rave_smooth(indarr),dblarr_absolute_bes_smooth(indarr)])
;              dblarr_contour_plot = dblarr_plot
;            end else begin
;              dbl_diff_min = min([dblarr_absolute_bes_smooth(indarr),dblarr_absolute_rave_smooth(indarr)])
;              dbl_diff_max = max([dblarr_absolute_bes_smooth(indarr),dblarr_absolute_rave_smooth(indarr)])
;              dblarr_contour_plot = dblarr_absolute_bes_smooth
;            endelse
            dblarr_levels=indgen(8)
            dblarr_levels=dbl_diff_min + dblarr_levels * (dbl_diff_max - dbl_diff_min) / 7.
            print,'dblarr_levels = ',dblarr_levels
;            contour,dblarr_contour_plot,$
;                    dblarr_x_smooth,$
;                    dblarr_y_smooth,$
;                    /IRREGULAR,$
;                    /DOWNHILL,$
;                    /OVERPLOT,$
;                    levels = dblarr_levels,$
;                    c_thick = dblarr_c_thick
      ;              min_value = dbl_diff_min,$
      ;              max_value = dbl_diff_max,$
      ;              /FOLLOW,$
      ;              /PATH_DOUBLE
      ;              c_labels=[0,0,0,0,0,0,0,0,0,0];[1,1,1,1,1,1,1,1,1,1]
          endelse
          if int_n_smoothings eq 0 then b_plot_contours = 0 else b_plot_contours = 1
          if b_plot_contours then begin
            contour,dblarr_plot,$
                    dblarr_pix_lon_lat(*,*,0),$
                    dblarr_pix_lon_lat(*,*,1),$
                    /IRREGULAR,$
                    /DOWNHILL,$
                    /OVERPLOT,$
                    levels = dblarr_levels,$
                    c_thick = dblarr_c_thick
          endif
          ; --- plot colour legend
          loadct,ltab,FILE='colors1_rave_plot_fields_mean.tbl'
          i_ncolours_legend = 254
          for i=0,i_ncolours_legend do begin
            xa = 360.
            xb = 370.
            ya = -90.+(180.*i/(i_ncolours_legend+1.))
            yb = -90.+(180.*(i+1)/(i_ncolours_legend+1.))
            colorxy = long(254.*(double(i)/double(i_ncolours_legend)))
            if colorxy eq 0 then colorxy = 1
            box,xa,ya,xb,yb,colorxy
          endfor
  ;        loadct,0
          ; --- print colour legend labels
          if b_sigma then begin
            str_temp_a = '-3!4r!3'
            str_temp_b = '+3!4r!3'
            str_legend = '!4l!3(!4l!3!Di!N) - !4l!3!Dparent!N'
            xyouts,372.,$
                   83.,$
                   '+3!4r!3',$
                   charsize=1.6,$
                   charthick=4,$
                   ;alignment=1,$
                   color=255
            xyouts,372.,$
                   -3.5,$
                   '0.',$
                   charsize=1.6,$
                   charthick=4,$
                   ;alignment=1,$
                   color=255
            xyouts,372.,$
                   -90.,$
                   '-3!4r!3',$
                   charsize=1.6,$
                   charthick=4,$
                   ;alignment=1,$
                   color=255
          end else begin
            str_temp = strtrim(string(dbl_diff_max),2)
            print,'dbl_diff_max = ',dbl_diff_max
            int_precision = 0
            if abs(dbl_diff_max) lt 100. then $
              int_precision = 1
            if abs(dbl_diff_max) lt 10. then $
              int_precision = 2
            if abs(dbl_diff_max) lt 1. then $
              int_precision = 3
            print,'strmid(str_temp,0,strpos(str_temp,.)+int_precision=',int_precision,') = ',strmid(str_temp,0,strpos(str_temp,'.')+int_precision)
;            if dbl_diff_max lt 1. then $
;            stop
;            if (str_xy eq 'Teff') and ((oo eq 0) or (oo eq 1)) then $
;              int_precision = 0
            xyouts,372.,$
                   83.,$
                   strmid(str_temp,0,strpos(str_temp,'.')+int_precision),$
                   charsize=1.6,$
                   charthick=4,$
                   ;alignment=1,$
                   color=255
            dbl_y_temp = -90. - dbl_diff_min * 180. / (dbl_diff_max - dbl_diff_min)
            if dbl_y_temp gt -85. and dbl_y_temp lt 80. then $
              xyouts,372.,$
                     dbl_y_temp - 3.5,$
                     '0.0',$
                     charsize=1.6,$
                     charthick=4,$
                     ;alignment=1,$
                     color=255
            str_temp = strtrim(string(dbl_diff_min),2)
            int_precision = 0
            if abs(dbl_diff_min) lt 100. then $
              int_precision = 1
            if abs(dbl_diff_min) lt 10. then $
              int_precision = 2
            if abs(dbl_diff_min) lt 1. then $
              int_precision = 3
            xyouts,372.,$
                   -90.,$
                   strmid(str_temp,0,strpos(str_temp,'.')+int_precision),$
                   charsize=1.6,$
                   charthick=4,$
                   ;alignment=1,$
                   color=255
          endelse
          device,/close
          spawn,'ps2gif '+str_plotname_root+'.ps '+str_plotname_root+'.gif'
          spawn,'epstopdf '+str_plotname_root+'.ps'
          reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
        endfor; i_plot
      endfor
    endfor
  endfor
;  endfor
;  min_curve_surf,
;  contour,
;stop
end
