pro xmatch_two_catalogues, I_STR_FILENAME_A = i_str_filename_a,$
                           I_STR_FILENAME_B = i_str_filename_b,$
                           I_STR_DELIMITER_A = i_str_delimiter_a,$
                           I_STR_DELIMITER_B = i_str_delimiter_b,$
                           I_INT_COL_LON_A = i_int_col_lon_a,$
                           I_INT_COL_LON_B = i_int_col_lon_b,$
                           I_INT_COL_LAT_A               = i_int_col_lat_a,$
                           I_INT_COL_LAT_B               = i_int_col_lat_b,$
                           I_B_RADEC_A                   = i_b_radec_a,$
                           I_B_RADEC_B                   = i_b_radec_b,$
                           I_DBL_MAX_DIFF_LON_LAT_ARCSEC = i_dbl_max_diff_lon_lat_arcsec
  if keyword_set(I_STR_FILENAME_A) then begin
    str_cat1 = i_str_filename_a
  end else begin
    str_cat1 = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good_no-doubles-maxsnr.dat'
  endelse
  if keyword_set(I_STR_FILENAME_B) then begin
    str_cat2 = i_str_filename_b
  end else begin
    str_cat2 = '/home/azuri/daten/rave/soubiran2005/soubiran2005.tsv'
  endelse
  if keyword_set(I_STR_DELIMITER_A) then begin
    str_delimiter1 = i_str_delimiter_a
  end else begin
    str_delimiter1 = ' '
  endelse
  if keyword_set(I_STR_DELIMITER_B) then begin
    str_delimiter2 = i_str_delimiter_b
  end else begin
    str_delimiter2 = ';'
  endelse
  if keyword_set(I_INT_COL_LON_A) then begin
    int_col_lon1 = i_int_col_lon_a
  end else begin
    int_col_lon1 = 5
  endelse
  if keyword_set(I_INT_COL_LON_B) then begin
    int_col_lon2 = i_int_col_lon_b
  end else begin
    int_col_lon2 = 2
  endelse
  if keyword_set(I_INT_COL_LAT_A) then begin
    int_col_lat1 = i_int_col_lat_a
  end else begin
    int_col_lat1 = 6
  endelse
  if keyword_set(I_INT_COL_LAT_B) then begin
    int_col_lat2 = i_int_col_lat_b
  end else begin
  int_col_lat2 = 3
  endelse
  if keyword_set(I_DBL_MAX_DIFF_LON_LAT_ARCSEC) then begin
    dbl_maxdiff_lon_lat = i_dbl_max_diff_lon_lat_arcsec
  end else begin
    dbl_maxdiff_lon_lat = 5.; ["]
  endelse

  str_temp = strmid(str_cat2,strpos(str_cat2,'/',/REVERSE_SEARCH)+1)
  str_temp = strmid(str_temp,0,strpos(str_temp,'.',/REVERSE_SEARCH))
  str_file_out1 = strmid(str_cat1,0,strpos(str_cat1,'.',/REVERSE_SEARCH))+'_found_'+str_temp+'.dat'
  str_temp = strmid(str_cat1,strpos(str_cat1,'/',/REVERSE_SEARCH)+1)
  str_temp = strmid(str_temp,0,strpos(str_temp,'.',/REVERSE_SEARCH))
  str_file_out2 = strmid(str_cat2,0,strpos(str_cat2,'.',/REVERSE_SEARCH))+'_found_'+str_temp+'.dat'

  strarr_lines1 = readfilelinestoarr(str_cat1,STR_DONT_READ='#')
  strarr_lines2 = readfilelinestoarr(str_cat2,STR_DONT_READ='#')

  strarr_data1 = readfiletostrarr(str_cat1,str_delimiter1,HEADER=strarr_header1)
  strarr_data2 = readfiletostrarr(str_cat2,str_delimiter2,HEADER=strarr_header2)

  dblarr_lon1 = double(strarr_data1(*,int_col_lon1))
  dblarr_lat1 = double(strarr_data1(*,int_col_lat1))
  strarr_data1 = 0
  if keyword_set(I_B_RADEC_A) then begin
    dblarr_ra = dblarr_lon1
    dblarr_dec = dblarr_lat1
    euler,dblarr_ra,dblarr_dec,dblarr_lon1,dblarr_lat1,1
    dblarr_ra = 0
    dblarr_dec = 0
    print,'dblarr_lon1 = ',dblarr_lon1
    print,'dblarr_lat1 = ',dblarr_lat1
  endif

  dblarr_lon2 = double(strarr_data2(*,int_col_lon2))
  dblarr_lat2 = double(strarr_data2(*,int_col_lat2))
  strarr_data2 = 0
  if keyword_set(I_B_RADEC_A) then begin
      dblarr_ra = dblarr_lon2
      dblarr_dec = dblarr_lat2
      euler,dblarr_ra,dblarr_dec,dblarr_lon2,dblarr_lat2,1
      dblarr_ra = 0
      dblarr_dec = 0
  endif

  openw,lun1,str_file_out1,/GET_LUN
  if n_elements(strarr_header1) gt 0 then begin
    for i=0ul, n_elements(strarr_header1)-1 do begin
      printf,lun1,strarr_header1(i)
    endfor
  endif
  openw,lun2,str_file_out2,/GET_LUN
  if n_elements(strarr_header2) gt 0 then begin
    for i=0ul, n_elements(strarr_header2)-1 do begin
      printf,lun2,strarr_header2(i)
    endfor
  endif

  int_nstars_found = 0ul
  for i=0ul, n_elements(dblarr_lon2)-1 do begin
    indarr_lon = where(abs(dblarr_lon1 - dblarr_lon2(i)) le (dbl_maxdiff_lon_lat / 3600.))
    if indarr_lon(0) ge 0 then begin
      indarr_lat = where(abs(dblarr_lat1(indarr_lon) - dblarr_lat2(i)) le (dbl_maxdiff_lon_lat / 3600.))
      if indarr_lat(0) ge 0 then begin
        printf,lun1,strarr_lines1(indarr_lon(indarr_lat(0)))
        printf,lun2,strarr_lines2(i)
        int_nstars_found = int_nstars_found + 1
      endif
    end
  endfor
  print,'int_nstars_found = ',int_nstars_found

  ; --- clean up
  strarr_lines1 = 0
  dblarr_lon1 = 0
  dblarr_lat1 = 0
  strarr_lines2 = 0
  dblarr_lon2 = 0
  dblarr_lat2 = 0
  indarr_lon = 0
  indarr_lat = 0
  free_lun,lun1
  free_lun,lun2
end
