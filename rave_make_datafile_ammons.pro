pro rave_make_datafile_ammons

  b_xmatch_rave_ammons = 1

  str_datafile_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_STN-gt-20-with-atm-par.dat';_SNR_gt_20.dat'
;    if b_snr_gt_thirteen then $
;      str_datafile_rave = strmid(str_datafile_rave,0,strpos(str_datafile_rave,'all',/REVERSE_SEARCH))+'stn_gt_20_no_doubles_maxsnr.dat'

  str_datafile_ammons = '/home/azuri/daten/rave/ammons_tycho/all.dat'
  str_datafile_out = strmid(str_datafile_ammons,0,strpos(str_datafile_ammons,'.',/REVERSE_SEARCH))+'_rave.dat'


  i_col_lon_ammons = 0
  i_col_lat_ammons = 1
  i_col_2massj_ammons = 2
  i_col_2massk_ammons = 3
  i_col_teff_ammons = 4
  i_col_eteff_ammons = 5
  i_col_dist_ammons = 6
  i_col_edist_ammons = 7
  i_col_feh_ammons = 8
  i_col_efeh_ammons = 9

  i_col_lon_rave = 5
  i_col_lat_rave = 6

  dbl_max_diff_deg = 0.001389; = 5 arcsec

  if b_xmatch_rave_ammons then begin

    strarr_data_ammons = readfiletostrarr(str_datafile_ammons,' ')
    strarr_data_rave = readfiletostrarr(str_datafile_rave,' ')

    dblarr_lon_ammons = double(strarr_data_ammons(*,i_col_lon_ammons))
    dblarr_lat_ammons = double(strarr_data_ammons(*,i_col_lat_ammons))

    dblarr_lon_rave = double(strarr_data_rave(*,i_col_lon_rave))
    dblarr_lat_rave = double(strarr_data_rave(*,i_col_lat_rave))

    indarr_ammons = lindgen(n_elements(strarr_data_ammons(*,0)))
    openw,lun,str_datafile_out,/GET_LUN
    int_nstars_found = 0ul
    for i=0ul, n_elements(strarr_data_rave(*,0))-1 do begin
      indarr_lon = where(abs(dblarr_lon_ammons(indarr_ammons) - dblarr_lon_rave(i)) le dbl_max_diff_deg)
      if indarr_lon(0) ge 0 then begin
        indarr_lat = where(abs(dblarr_lat_ammons(indarr_ammons(indarr_lon)) - dblarr_lat_rave(i)) le dbl_max_diff_deg)
        if indarr_lat(0) ge 0 then begin
          str_line_out = strarr_data_rave(i,0)
          int_nstars_found = int_nstars_found + 1
          print,'i=',i,': ',int_nstars_found,' stars found'
  ;        print,'dblarr_lon_rave(i) = ',dblarr_lon_rave(i)
  ;        print,'dblarr_lon_ammons(indarr_ammons(indarr_lon(indarr_lat))) = ',dblarr_lon_ammons(indarr_ammons(indarr_lon(indarr_lat)))
          for j=1,n_elements(strarr_data_rave(0,*))-2 do begin
            str_line_out = str_line_out + ' ' + strarr_data_rave(i,j)
          endfor
          for j=4,n_elements(strarr_data_ammons(0,*))-1 do begin
            str_line_out = str_line_out + ' ' + strarr_data_ammons(indarr_ammons(indarr_lon(indarr_lat(0))),j)
          endfor
          printf,lun,str_line_out
          remove_ith_element_from_array,indarr_ammons,indarr_lon(indarr_lat(0))
        endif
      endif
    endfor
    free_lun,lun
    strarr_data_ammons = 0
  endif

  str_datafile_rave = str_datafile_out
  strarr_data_rave = readfiletostrarr(str_datafile_rave,' ')
  dblarr_lon_rave = double(strarr_data_rave(*,i_col_lon_rave))
  dblarr_lat_rave = double(strarr_data_rave(*,i_col_lat_rave))

  str_datafile_dist = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5.dat'

  strarr_data_dist = readfiletostrarr(str_datafile_dist,' ')

  dblarr_lon_dist = double(strarr_data_dist(*,4))
  dblarr_lat_dist = double(strarr_data_dist(*,5))

  indarr_dist = lindgen(n_elements(strarr_data_dist(*,0)))
  str_datafile_out = strmid(str_datafile_rave,0,strpos(str_datafile_rave,'.',/REVERSE_SEARCH))+'_dist.dat'
  openw,lun,str_datafile_out,/GET_LUN
  int_nstars_found = 0ul
  for i=0ul, n_elements(strarr_data_rave(*,0))-1 do begin
    indarr_lon = where(abs(dblarr_lon_dist(indarr_dist) - dblarr_lon_rave(i)) le dbl_max_diff_deg)
    if indarr_lon(0) ge 0 then begin
      indarr_lat = where(abs(dblarr_lat_dist(indarr_dist(indarr_lon)) - dblarr_lat_rave(i)) le dbl_max_diff_deg)
      if indarr_lat(0) ge 0 then begin
        str_line_out = strarr_data_rave(i,0)
        int_nstars_found = int_nstars_found + 1
        print,'i=',i,': ',int_nstars_found,' stars found'
;        print,'dblarr_lon_rave(i) = ',dblarr_lon_rave(i)
;        print,'dblarr_lon_ammons(indarr_ammons(indarr_lon(indarr_lat))) = ',dblarr_lon_ammons(indarr_ammons(indarr_lon(indarr_lat)))
        for j=1,n_elements(strarr_data_rave(0,*))-1 do begin
          str_line_out = str_line_out + ' ' + strarr_data_rave(i,j)
        endfor
        for j=22,n_elements(strarr_data_dist(0,*))-1 do begin
          str_line_out = str_line_out + ' ' + strarr_data_dist(indarr_dist(indarr_lon(indarr_lat(0))),j)
        endfor
        printf,lun,str_line_out
        remove_ith_element_from_array,indarr_dist,indarr_lon(indarr_lat(0))
      endif
    endif
  endfor
  free_lun,lun

end
