pro rave_remove_stars_in_box_with_jmk_lt_0_5

  b_dist = 0
  b_breddels = 1
  b_chem = 0
  b_denis = 0; --- 0 for 2MASS

  if b_dist then begin
    b_denis = 0
    i_col_j_denis = 13
    i_col_k_denis = 14
    i_col_j_twomass = 13
    i_col_k_twomass = 14
    i_col_lon = 4
    i_col_lat = 5
    if b_breddels then begin
      i_col_j_denis = 21
      i_col_k_denis = 23
      i_col_j_twomass = 21
      i_col_k_twomass = 23
      i_col_lon = 3
      i_col_lat = 4
    endif
  end else begin
    i_col_j_denis = 52
    i_col_k_denis = 54
    i_col_j_twomass = 59
    i_col_k_twomass = 63
    i_col_lon = 5
    i_col_lat = 6
  endelse

  if b_dist then begin
    str_file_rave = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr.dat'
;    str_file_rave = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr.dat'
;    str_file_rave = '/suphys/azuri/daten/rave/rave_data/distances/all_20100201_SN20_lon_lat_no_doubles_minerr.dat'
    if b_breddels then $
    str_file_rave = '/suphys/azuri/daten/rave/rave_data/distances/breddels/breddels_minus-ic1-ic2.dat'
  end else if b_chem then begin
    str_file_rave = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_9ltIlt12_frac_gt_70.dat'
  end else begin
    str_file_rave = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2.dat'
;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2.dat'
;'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2.dat'
  end

  str_file_rave_out = strmid(str_file_rave,0,strpos(str_file_rave,'.',/REVERSE_SEARCH))+'_230-315_-25-25_JmK'
  if b_denis then begin
    str_file_rave_out = str_file_rave_out+'Denis_gt_0_5.dat'
  end else begin
    str_file_rave_out = str_file_rave_out+'2MASS_gt_0_5.dat'
  end
  print,'str_file_rave_out = <'+str_file_rave_out+'>'

;  dbl_expected_lon = 338.55967
;  dbl_expected_lat = 28.57959
;  dbl_expected_j_denis = 10.951
;  dbl_expected_k_denis = 10.266
;  dbl_expected_j_twomass = 10.932
;  dbl_expected_k_twomass = 10.436

  strarr_rave_lines = readfilelinestoarr(str_file_rave)
  strarr_rave = readfiletostrarr(str_file_rave,' ')

  dblarr_lon = double(strarr_rave(*,i_col_lon))
;  if abs(dblarr_lon(0) - dbl_expected_lon) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_lon(0)(=',dblarr_lon(0),') ne dbl_expected_lon = ',dbl_expected_lon
;    stop
;  endif

  dblarr_lat = double(strarr_rave(*,i_col_lat))
;  if abs(dblarr_lat(0) - dbl_expected_lat) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_lat(0)(=',dblarr_lat(0),') ne dbl_expected_lat = ',dbl_expected_lat
;    stop
;  endif
  if b_dist and b_breddels then begin
    indarr = where(dblarr_lon lt 0.)
    dblarr_lon(indarr) = dblarr_lon(indarr) + 360.
    set_plot,'ps'
    device,filename='/home/azuri/daten/rave/rave_data/distances/breddels/breddels_lon_lat.ps'
      plot,dblarr_lon,dblarr_lat,psym=2,symsize=0.2,xtitle='lon', ytitle='lat'
    device,/close
    set_plot,'x'
  endif

  indarr_inside_box = where(dblarr_lon ge 230. and dblarr_lat lt 315. and dblarr_lat gt -25. and dblarr_lat lt 25., i_nstars_in_box, COMPLEMENT=indarr_outside_box, NCOMPLEMENT=i_nstars_outside_box)
  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ',i_nstars_in_box,' stars in box'

  strarr_rave_lines_out = strarr_rave_lines
  strarr_rave_lines_out(0:i_nstars_outside_box-1) = strarr_rave_lines_out(indarr_outside_box)

  strarr_rave_lines_box = strarr_rave_lines(indarr_inside_box)
  strarr_rave_box = strarr_rave(indarr_inside_box,*)

  dblarr_j_denis = double(strarr_rave_box(*,i_col_j_denis))
;  if abs(dblarr_j_denis(0) - dbl_expected_j_denis) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_j_denis(0)(=',dblarr_j_denis(0),') ne dbl_expected_j_denis = ',dbl_expected_j_denis
;    stop
;  endif

  dblarr_k_denis = double(strarr_rave_box(*,i_col_k_denis))
;  if abs(dblarr_j_denis(0) - dbl_expected_j_denis) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_k_denis(0)(=',dblarr_k_denis(0),') ne dbl_expected_k_denis = ',dbl_expected_k_denis
;    stop
;  endif

  dblarr_j_twomass = double(strarr_rave_box(*,i_col_j_twomass))
;  if abs(dblarr_j_twomass(0) - dbl_expected_j_twomass) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_j_twomass(0)(=',dblarr_j_twomass(0),') ne dbl_expected_j_twomass = ',dbl_expected_j_twomass
;    stop
;  endif

;  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: k (2Mass) = strarr_rave_box(*,i_col_k_twomass = ',i_col_k_twomass,') = ',strarr_rave_box(*,i_col_k_twomass)
;  indarr_k_twomass_xxx = where(strarr_rave_box(*,i_col_k_twomass) eq 'XXX')
;  strarr_rave_box(indarr_k_twomass_xxx,i_col_k_twomass) = '99.99'
  dblarr_k_twomass = double(strarr_rave_box(*,i_col_k_twomass))
;  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: dblarr_k_twomass(indarr_k_twomass_xxx) = ',dblarr_k_twomass(indarr_k_twomass_xxx)
;  dblarr_k_twomass(indarr_k_twomass_xxx) = 99.99
;  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: dblarr_k_twomass(indarr_k_twomass_xxx) = ',dblarr_k_twomass(indarr_k_twomass_xxx)
;  if abs(dblarr_k_twomass(0) - dbl_expected_k_twomass) gt 0.0001 then begin
;    print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ERROR: dblarr_k_twomass(0)(=',dblarr_k_twomass(0),') ne dbl_expected_k_twomass = ',dbl_expected_k_twomass
;    stop
;  endif

  i_nelements_old = 0UL
  i_nelements_old = n_elements(dblarr_j_denis)
  indarr_j = where((abs(dblarr_j_denis - 99.99) gt 1.) or (abs(dblarr_j_twomass - 99.99) gt 1.), count_j)
;  strarr_rave_lines = strarr_rave_lines(indarr_j)
;  strarr_rave = strarr_rave(indarr_j)
  dblarr_j_denis = dblarr_j_denis(indarr_j)
  dblarr_k_denis = dblarr_k_denis(indarr_j)
  dblarr_j_twomass = dblarr_j_twomass(indarr_j)
  dblarr_k_twomass = dblarr_k_twomass(indarr_j)
  strarr_rave_lines_box = strarr_rave_lines_box(indarr_j)
  indarr_j = 0
;  print,'i_nelements_old = ',i_nelements_old
;  print,'count_j = ',count_j
  i_nstars_rejected = i_nelements_old - count_j
  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: J: ',i_nelements_old-count_j,' stars without J rejected'

  i_nelements_old = n_elements(dblarr_j_denis)
  indarr_k = where((abs(dblarr_k_denis - 99.99) gt 1.) or (abs(dblarr_k_twomass - 99.99) gt 1.), count_k)
;  strarr_rave_lines = strarr_rave_lines(indarr_k)
;  strarr_rave = strarr_rave(indarr_k)
  dblarr_j_denis = dblarr_j_denis(indarr_k)
  dblarr_k_denis = dblarr_k_denis(indarr_k)
  dblarr_j_twomass = dblarr_j_twomass(indarr_k)
  dblarr_k_twomass = dblarr_k_twomass(indarr_k)
  strarr_rave_lines_box = strarr_rave_lines_box(indarr_k)
  indarr_k = 0
  i_nstars_rejected = i_nstars_rejected + i_nelements_old - count_k
  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: K: ',i_nelements_old-count_k,' stars without K rejected'

  indarr_j_denis = where(abs(dblarr_j_denis - 99.99) lt 1., COMPLEMENT=indarr_j_denis_comp)
  indarr_k_denis = where(abs(dblarr_k_denis - 99.99) lt 1., COMPLEMENT=indarr_k_denis_comp)
  indarr_j_twomass = where(abs(dblarr_j_twomass - 99.99) lt 1., COMPLEMENT=indarr_j_twomass_comp)
  indarr_k_twomass = where(abs(dblarr_k_twomass - 99.99) lt 1., COMPLEMENT=indarr_k_twomass_comp)

  if b_denis eq 1 then begin
    if indarr_j_denis(0) ge 0 then begin
      dblarr_j_denis(indarr_j_denis) = dblarr_j_twomass(indarr_j_denis)
    end
    if indarr_k_denis(0) ge 0 then begin
      dblarr_k_denis(indarr_k_denis) = dblarr_k_twomass(indarr_k_denis)
    end
  end else begin
    if indarr_j_twomass(0) ge 0 then begin
      dblarr_j_twomass(indarr_j_twomass) = dblarr_j_denis(indarr_j_twomass)
    end
    if indarr_k_twomass(0) ge 0 then begin
      dblarr_k_twomass(indarr_k_twomass) = dblarr_k_denis(indarr_k_twomass)
    end
  end

  if b_denis eq 1 then begin; --- DENIS
    dblarr_jmk = dblarr_j_denis - dblarr_k_denis
  end else begin; --- 2MASS
    dblarr_jmk = dblarr_j_twomass - dblarr_k_twomass
  end
  indarr_jmk = where(dblarr_jmk le 0.5, count_jmk, COMPLEMENT=indarr_jmk_comp, NCOMPLEMENT=i_ngood_stars)
  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: ',count_jmk,' stars with J-K lt 0.5 found'

  i_nstars_rejected = i_nstars_rejected + count_jmk
  print,'rave_remove_stars_in_box_with_jmk_lt_0_5: i_nstars_rejected = ',i_nstars_rejected

  strarr_rave_lines_box = strarr_rave_lines_box(indarr_jmk_comp)

  strarr_rave_lines_out(i_nstars_outside_box:i_nstars_outside_box+i_ngood_stars-1) = strarr_rave_lines_box

  strarr_rave_lines_out = strarr_rave_lines_out(0:i_nstars_outside_box + i_ngood_stars - 1)

  openw,lun,str_file_rave_out,/GET_LUN
    for i=0ul, n_elements(strarr_rave_lines_out)-1 do begin
      printf,lun,strarr_rave_lines_out(i)
    endfor
  free_lun,lun
end
