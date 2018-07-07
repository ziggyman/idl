pro rave_replace_imag_with_denis_dist

  i_col_i_input = 14
  i_col_idenis = 50
  i_col_j2mass = 59
  i_col_k2mass = 63
  i_col_raveid = 1
  i_col_objectid = 2
  i_col_lon = 5
  i_col_lat = 6

  i_col_i_dist = 12
  i_col_objectid_dist = 1
  i_col_raveid_dist = 0
  i_col_lon_dist = 4
  i_col_lat_dist = 5

  str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5_IDenis2MASS.dat'
  str_filename_dist_in = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK_gt_0_5.dat'
  str_filename_out = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_IDenis2MASS_lb.dat'
  str_filename_out_ilt12 = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_IDenis2MASS_9ltIlt12_lb.dat'

  strarr_header = strarr(1)
  strarr_header(0) = '-1'
  strarr_header_dist = strarr(1)
  strarr_header_dist(0) = '-1'

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NLines=i_nlines,I_NCols=i_ncols,HEADER=strarr_header)
  strarr_data_dist = readfiletostrarr(str_filename_dist_in,' ',I_NLines=i_nlines_dist,I_NCols=i_ncols_dist,HEADER=strarr_header_dist)

  strarr_raveid = strarr_data(*,i_col_raveid)
  strarr_raveid_dist = strarr_data_dist(*,i_col_raveid_dist)
  strarr_objectid = strarr_data(*,i_col_objectid)
  strarr_objectid_dist = strarr_data_dist(*,i_col_objectid_dist)

  dblarr_lon = double(strarr_data(*,i_col_lon))
  dblarr_lat = double(strarr_data(*,i_col_lat))
  dblarr_lon_dist = double(strarr_data_dist(*,i_col_lon_dist))
  dblarr_lat_dist = double(strarr_data_dist(*,i_col_lat_dist))
;  dblarr_lon_dist = dblarr_lon_dist + 180.
  print,'dblarr_lon_dist = ',dblarr_lon_dist
  print,'dblarr_lat_dist = ',dblarr_lat_dist

  b = 0ul
  openw,lun,str_filename_out,/GET_LUN
  openw,luna,str_filename_out_ilt12,/GET_LUN
  if strarr_header(0) ne '-1' then begin
    for i=0ul,n_elements(strarr_header_dist)-1 do begin
      printf,lun,strarr_header_dist(i)
    endfor
  endif
  for i=0ul, n_elements(strarr_raveid_dist)-1 do begin
    dblarr_sub = dblarr_lon - dblarr_lon_dist(i)
    print,'min(abs(dblarr_sub_lon)) = ',min(abs(dblarr_sub))
    indarr_lon = where(abs(dblarr_lon - dblarr_lon_dist(i)) lt 0.001)
    print,'abs(dblarr_lon(0)=',dblarr_lon(0),' - dblarr_lon_dist(i)=',dblarr_lon_dist(i),') = ',abs(dblarr_lon(0) - dblarr_lon_dist(i))
    if indarr_lon(0) eq -1 then begin
      print,'i=',i,': indarr_lon(0) == -1: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
;      stop
    end else begin
      dblarr_sub = dblarr_lat - dblarr_lat_dist(i)
      print,'min(abs(dblarr_sub_lat)) = ',min(abs(dblarr_sub))
      indarr_lat = where(abs(dblarr_lat(indarr_lon) - dblarr_lat_dist(i)) lt 0.001)
      print,'abs(dblarr_lat(0)=',dblarr_lat(0),' - dblarr_lat_dist(i)=',dblarr_lat_dist(i),') = ',abs(dblarr_lat(0) - dblarr_lat_dist(i))
    ;indarr = where((strarr_raveid eq strarr_raveid_dist(i)) or (strarr_objectid eq strarr_objectid_dist(i)) or (strarr_raveid eq strarr_objectid_dist(i)) or (strarr_objectid eq strarr_raveid_dist(i)))
      if indarr_lat(0) eq -1 then begin
        print,'i=',i,': indarr_lat(0) == -1: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
;      stop
      end else begin
        print,'i=',i,': found: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
        if double(strarr_data(indarr_lon(indarr_lat(0)),i_col_idenis)) lt 99. then begin
          print,'old imag = '+strarr_data_dist(i,i_col_i_dist)+', new imag(denis) = '+strarr_data(indarr_lon(indarr_lat(0)),i_col_idenis)
          strarr_data_dist(i,i_col_i_dist) = strarr_data(indarr_lon(indarr_lat(0)),i_col_idenis)
        end
        str_line = strarr_data_dist(i,0)
        for i_col=1ul, i_ncols_dist-1 do begin
          str_line = str_line + ' ' + strarr_data_dist(i,i_col)
        endfor
        printf,lun,str_line
        if double(strarr_data_dist(i,i_col_i_dist)) ge 9. and double(strarr_data_dist(i,i_col_i_dist)) le 12. then begin
          printf,luna,str_line
          b = b+1
        endif
      endelse
    endelse
  endfor
  print,'b = ',b
  free_lun,lun
  free_lun,luna
end
