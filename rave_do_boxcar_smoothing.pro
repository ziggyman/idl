pro rave_do_boxcar_smoothing, IO_DBLARR_DATA   = io_dblarr_data,$; --- dblarr(npix_lon, npix_lat)
                              I_DBLARR_PIX_LON = i_dblarr_pix_lon,$; --- dblarr(npix_lon)
                              I_DBLARR_PIX_LAT = i_dblarr_pix_lat,$; --- dblarr(npix_lon)
                              I_DBL_PIXSIZE_LON = i_dbl_pixsize_lon,$
                              I_DBL_PIXSIZE_LAT = i_dbl_pixsize_lat,$
                              I_B_DO_SIGMA_CLIPPING = i_b_do_sigma_clipping

  if (not keyword_set(IO_DBLARR_DATA)) or (not keyword_set(I_DBLARR_PIX_LON)) or (not keyword_set(I_DBLARR_PIX_LAT)) or (not keyword_set(I_DBL_PIXSIZE_LON)) or (not keyword_set(I_DBL_PIXSIZE_LAT)) then begin
    print,'rave_do_boxcar_smoothing: ERROR: Not enough parameters specified'
    stop
  endif

  dblarr_data_out = io_dblarr_data * 0.

; --- run boxcar smoothing
  for iii=0,n_elements(i_dblarr_pix_lon)-1 do begin
    for jjj=0,n_elements(i_dblarr_pix_lat)-1 do begin
      if (abs(io_dblarr_data(iii, jjj)) ge 0.000000001) then begin
        dbl_lon_min = i_dblarr_pix_lon(iii) - (i_dbl_pixsize_lon / 2.)-i_dbl_pixsize_lon
        dbl_lon_max = i_dblarr_pix_lon(iii) + (i_dbl_pixsize_lon / 2.) + i_dbl_pixsize_lon
        indarr_where_lon = where(((dbl_lon_min le i_dblarr_pix_lon) and (dbl_lon_max gt i_dblarr_pix_lon)) or (dbl_lon_min + 360. le i_dblarr_pix_lon) or (dbl_lon_max - 360. gt i_dblarr_pix_lon))
        print,'indarr_where_lon = ',indarr_where_lon

        indarr_where_lat = where((i_dblarr_pix_lat(jjj) - (i_dbl_pixsize_lat / 2.) - i_dbl_pixsize_lat le i_dblarr_pix_lat) and (i_dblarr_pix_lat(jjj) + (i_dbl_pixsize_lat / 2.) + i_dbl_pixsize_lat gt i_dblarr_pix_lat))
        print,'indarr_where_lat = ',indarr_where_lat

        print,'number of pixels in boxcar: ',n_elements(indarr_where_lon) * n_elements(indarr_where_lat)

        int_n_gt_0 = 0
        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          indarr_gt_0 = where(abs(io_dblarr_data(indarr_where_lon(i_lon), indarr_where_lat)) ge 0.000000001)
          if indarr_gt_0(0) ge 0 then $
            int_n_gt_0 += n_elements(indarr_gt_0)
        endfor

        print,'number of non-zero pixels in boxcar: ',int_n_gt_0
        print,'dblarr_data_out(iii,jjj) = ',dblarr_data_out(iii,jjj)

        dblarr_box = dblarr(int_n_gt_0)
        int_n_in_box = 0
        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          indarr_gt_0 = where(abs(io_dblarr_data(indarr_where_lon(i_lon), indarr_where_lat)) ge 0.000000001,int_n_gt_0_in_slice)
          if int_n_gt_0_in_slice ge 1 then begin
            dblarr_box(int_n_in_box:int_n_in_box+int_n_gt_0_in_slice-1) = io_dblarr_data(indarr_where_lon(i_lon),indarr_where_lat(indarr_gt_0))
          endif
          int_n_in_box += int_n_gt_0_in_slice
        endfor
        print,'dblarr_box = ',dblarr_box
        dblarr_moment = moment(dblarr_box)
        print,'dblarr_moment = ',dblarr_moment
        indarr_take = where(abs(dblarr_box - dblarr_moment(0)) le 3. * sqrt(dblarr_moment(1)), int_n_good)
        print,'dblarr_box(indarr_take) = ',dblarr_box(indarr_take)
        if keyword_set(I_B_DO_SIGMA_CLIPPING) then begin
          if int_n_good ge 1 then begin
            dblarr_data_out(iii,jjj) = total(dblarr_box(indarr_take)) / int_n_good
          endif
        end else begin
          if int_n_gt_0 ge 1 then begin
            dblarr_data_out(iii,jjj) = total(dblarr_box) / int_n_gt_0
          endif
        endelse
;        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
;          dblarr_data_out(iii,jjj) += total(io_dblarr_data(indarr_where_lon(i_lon),indarr_where_lat))
;          print,'i_lon = ',i_lon,': dblarr_data_out(iii,jjj) = ',dblarr_data_out(iii,jjj)
;        endfor
        print,'io_dblarr_data(iii,jjj) = ',io_dblarr_data(iii,jjj)
        for i_lon=0, n_elements(indarr_where_lon)-1 do begin
          print,'io_dblarr_data(indarr_where_lon(',i_lon,'),indarr_where_lat) = ',io_dblarr_data(indarr_where_lon(i_lon),indarr_where_lat)
        endfor
        print,'dblarr_data_out(iii,jjj) = ',dblarr_data_out(iii,jjj)
;        stop
      endif
    endfor
  endfor
  io_dblarr_data = dblarr_data_out

; --- clean up
  dblarr_data_out = 0
  indarr_gt_0 = 0
  indarr_where_lat = 0
  indarr_where_lon = 0
end
