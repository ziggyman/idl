pro rave_remove_ic1_from_rave_data
  b_dist = 0
  b_chem = 0

  b_dist_breddels = 1

  str_delimiter = ' '

  if b_dist then begin
    str_rave = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5.dat'
    i_col_rave_lon = 4
    i_col_rave_lat = 5

    if b_dist_breddels then begin
      str_rave = '/home/azuri/daten/rave/rave_data/distances/breddels/breddels.csv'
      str_delimiter = ','
      i_col_rave_lon = 3
      i_col_rave_lat = 4
    endif
;    str_rave = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb.dat'
  end else begin
    if b_chem then begin
      str_rave = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr.dat'
    end else begin
      ;str_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS.dat';_9ltIlt12.dat'
      str_rave = '/home/azuri/daten/rave/rave_data/release10/raveinternal_VDR3_20120515_with-2MASS-JK_no-flag.dat'
;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag.dat'
;'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK.dat'
;rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr.dat';with-2MASS-JK.dat';_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12.dat'
      str_delimiter = ';'
    end
    i_col_rave_lon = 5
    i_col_rave_lat = 6
  end
  str_ic = '/home/azuri/daten/rave/input_catalogue/ric1+2_lon_lat_minus-ic2.dat'
  i_col_ic_lon = 1
  i_col_ic_lat = 2

  str_outfile = strmid(str_rave,0,strpos(str_rave,'.',/REVERSE_SEARCH))+'_minus-ic1-ic2.dat'

  strarr_header=[-1]

  strarr_rave = readfiletostrarr(str_rave,str_delimiter,HEADER=strarr_header)
  strarr_ic = readfiletostrarr(str_ic,' ')

  strarr_ic_id = strarr_ic(*,0)
  strarr_rave_obsid = strarr_rave(*,0)
  strarr_rave_id = strarr_rave(*,1)
  strarr_rave_objectid = strarr_rave(*,2)

  dblarr_rave_lon = double(strarr_rave(*,i_col_rave_lon))
  dblarr_rave_lat = double(strarr_rave(*,i_col_rave_lat))

  dblarr_ic_lon = double(strarr_ic(*,i_col_ic_lon))
  dblarr_ic_lat = double(strarr_ic(*,i_col_ic_lat))

  indarr_all = [-1]
  for i=0ul, n_elements(strarr_ic_id)-1 do begin
    indarr = where((strarr_rave_obsid eq strarr_ic_id(i)) or (strarr_rave_id eq strarr_ic_id(i))); or (strarr_rave_objectid eq strarr_ic_id(i)))
    ;indarr = where((abs(dblarr_rave_lon - dblarr_ic_lon(i)) lt 0.0001) and (abs(dblarr_rave_lat - dblarr_ic_lat(i)) lt 0.0001))
    if indarr(0) ge 0 then begin
      dbl_lon_min = min(abs(dblarr_rave_lon(indarr) - dblarr_ic_lon(i)))
      dbl_lat_min = min(abs(dblarr_rave_lat(indarr) - dblarr_ic_lat(i)))
      print,'star i=',i,' found: '+strarr_ic_id(i)+': dbl_lon_min = ',dbl_lon_min,', dbl_lat_min = ',dbl_lat_min
      ;indarr2 = where((abs(abs(dblarr_rave_lon(indarr) - dblarr_ic_lon(i)) - dbl_lon_min) lt 0.00001) and (abs(abs(dblarr_rave_lat(indarr) - dblarr_ic_lat(i)) - dbl_lat_min) lt 0.00001))
      ;if indarr2(0) ge 0 then begin
;      for j=0ul, n_elements(indarr)-1 do begin
;        remove_ith_element_from_array,strarr_rave,indarr(j)
;        remove_ith_element_from_array,strarr_rave_obsid,indarr(j)
;        remove_ith_element_from_array,strarr_rave_id,indarr(j)
;        remove_ith_element_from_array,strarr_rave_objectid,indarr(j)
;      endfor
        if indarr_all(0) lt 0 then begin
          indarr_all = indarr
        end else begin
          indarr_all = [indarr_all,indarr]
        end
;        print,'remove_ic1_from_rave_data: star i=',i,' '+strarr_ic_id(i)+' found in RAVE data'
      ;endif
    end else begin
      print,'remove_ic1_from_rave_data: star i=',i,' '+strarr_ic_id(i)+' not found'
    end
  endfor

  openw,lun,str_outfile,/GET_LUN
    if strarr_header(0) ge 0 then begin
      for j=0ul, n_elements(strarr_header)-1 do begin
        printf,lun,strarr_header(j)
      endfor
    endif
    for i=0ul, n_elements(strarr_rave(*,0))-1 do begin
      indarr = where(indarr_all eq i)
      if indarr(0) lt 0 then begin
        str_line = strarr_rave(i,0)
        for j=1ul, n_elements(strarr_rave(0,*))-1 do begin
          str_line = str_line+' '+strarr_rave(i,j)
        endfor
        printf,lun,str_line
      endif
    endfor
  free_lun,lun
  print,n_elements(indarr_all),' stars removed'
end
