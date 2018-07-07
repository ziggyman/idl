pro rave_combine_with_dist
  str_dist = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK_gt_0_5.dat'
  str_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_minus_ic1.dat'

  str_outfile = strmid(str_dist,0,strpos(str_dist,'.',/REVERSE_SEARCH))+'_I2MASS_minus_ic1.dat'

  strarr_dist = readfiletostrarr(str_dist,' ',HEADER=strarr_header_dist)
  strarr_rave = readfiletostrarr(str_rave,' ',HEADER=strarr_header_rave)

  i_col_dist_objectid = 0
  i_col_dist_raveid = 1
  i_col_dist_dist = 22
  i_col_dist_edist = 23
  i_col_dist_whichmu = 24

  i_col_rave_obsid = 0
  i_col_rave_id = 1
  i_col_rave_objectid = 2

  strarr_dist_objectid = strarr_dist(*,i_col_dist_objectid)
  strarr_dist_raveid = strarr_dist(*,i_col_dist_raveid)
  strarr_dist_dist = strarr_dist(*,i_col_dist_dist)
  strarr_dist_edist = strarr_dist(*,i_col_edist_dist)
  strarr_dist_whichmu = strarr_dist(*,i_col_dist_whichmu)

  strarr_rave_obsid = strarr_rave(*,i_col_rave_obsid)
  strarr_rave_id = strarr_rave(*,i_col_rave_id)
  strarr_rave_objectid = strarr_rave(*,i_col_rave_objectid)

  for i=0ul,n_elements(strarr_rave_id)-1 do begin
    indarr = where((strarr_dist_objectid eq strarr_rave_id(i)) or (strarr_dist_objectid eq strarr_rave_obsid(i)) or (strarr_dist_objectid eq strarr_rave_objectid(i)) or (strarr_dist_raveid eq strarr_rave_id(i)) or (strarr_dist_raveid eq strarr_rave_obsid(i)) or (strarr_dist_raveid eq strarr_rave_objectid(i)))
    if indarr(0) ge 0 then begin

    endif
  endfor

end
