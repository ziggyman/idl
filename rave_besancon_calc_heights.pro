pro rave_besancon_calc_heights, I_STR_DATAFILE = i_str_datafile,$
                                I_INT_I        = i_int_i
; --- calculates distances above plane and radius from galactic centre for the RAVE and Besancon stars and writes files *_height_rcent.dat

  b_breddels = 0
  b_zwitter = 0
  b_abundances = 0

  b_without_errors = 0

  if b_zwitter then begin
    str_datafile_rave = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb.dat';Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb_minus_ic1.dat'
    i_col_rave_lon = 4
    i_col_rave_lat = 5
    i_col_rave_dist = 22
  endif
  if b_breddels then begin
    str_datafile_rave = '/suphys/azuri/daten/rave/rave_data/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS-9ltIlt12-lb+stn.dat'
    i_col_rave_lon = 3
    i_col_rave_lat = 4
    i_col_rave_dist = 28
  endif
;  str_datafile_rave = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK_gt_0_5_distsample_0.dat'
;  str_datafile_rave = '/home/azuri/daten/rave/rave_data/distances/all_20100201_SN20_lon_lat_no_doubles_minerr_distsample.dat'


  if b_abundances then begin
    str_datafile_besancon = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_teff-gt-4000'
  end else begin
    str_datafile_besancon = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb';'_with-errors'
  endelse
   if b_without_errors then begin
     str_datafile_besancon = str_datafile_besancon + '.dat'
   end else begin
     str_datafile_besancon = str_datafile_besancon +$
     ;'_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
     '_with-errors_errdivby-dwarfs-1_00-1_48-1_41-1_55-1_00-giants-1_00-1_22-1_26-1_61-1_00-MH-from-FeH-and-aFe.dat';dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00.dat';errdivby_1.00_1.00_1.00_1.00_1.00.dat'
   endelse
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_1.56_2.37_2.75_1.50_2.00.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_errdivby_1.56_2.37_2.75_1.50_2.00.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/extinction/new/besancon_with_extinction_new_mh+snr_with_errors_errdivby_1.56_2.37_2.75_1.50_2.00.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors_errdivby_1.00_1.00_1.00_1.00.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_samplex1.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_samplex1_with_errors_errdivby_1.56_2.37_2.75_1.50_1.00.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors_errdivby_1.56_2.37_2.75_1.50_2.00.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_distsample.dat'
;  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_with_errors_errdivby_1.78_2.34_2.61_1.00_3.98.dat'


  str_datafile_sanjib = '/home/azuri/daten/besancon/sanjib_with_errors_errdivby_2.36_3.64_2.84_1.00+snr.dat'
;  str_datafile_sanjib = '/home/azuri/daten/besancon/sanjib_mh+snr_with_errors_errdivby_1.56_2.37_2.75_1.50_2.00.dat'
;  str_datafile_sanjib = '/home/azuri/daten/besancon/sanjib_distsample.dat'
;  str_datafile_sanjib = '/home/azuri/daten/besancon/sanjib_with_errors_errdivby_1.78_2.34_2.61_1.00_3.98.dat'


  i_col_besancon_lon = 0
  i_col_besancon_lat = 1
  i_col_besancon_dist = 9

  i_col_sanjib_lon = 5
  i_col_sanjib_lat = 6
  i_col_sanjib_dist = 9

  dbl_r_sun = 8.5; kpc

  i=1
  if keyword_set(I_INT_I) then $
    i=i_int_i
;  for i=0,2 do begin
    if i eq 0 then begin
      str_datafile = str_datafile_rave
      if keyword_set(I_STR_DATAFILE) then $
        str_datafile = i_str_datafile
      i_col_lon = i_col_rave_lon
      i_col_lat = i_col_rave_lat
      i_col_dist = i_col_rave_dist
    end else if i eq 1 then begin
      str_datafile = str_datafile_besancon
      if keyword_set(I_STR_DATAFILE) then $
        str_datafile = i_str_datafile
      i_col_lon = i_col_besancon_lon
      i_col_lat = i_col_besancon_lat
      i_col_dist = i_col_besancon_dist
    end else begin
      str_datafile = str_datafile_sanjib
      if keyword_set(I_STR_DATAFILE) then $
        str_datafile = i_str_datafile
      i_col_lon = i_col_sanjib_lon
      i_col_lat = i_col_sanjib_lat
      i_col_dist = i_col_sanjib_dist
    end
    strarr_data = readfiletostrarr(str_datafile,' ',I_NLINES=i_nlines,I_NCOLS=i_ncols)
    strarr_data_lines = readfilelinestoarr(str_datafile,STR_DONT_READ='#')
    print,'rave_besancon_calc_heights: datafile '+str_datafile+' contains ',i_nlines,' lines and ',i_ncols,' cols'

    dblarr_dist = double(strarr_data(*,i_col_dist))
    dblarr_lon = double(strarr_data(*,i_col_lon)) / !RADEG
    dblarr_lat = double(strarr_data(*,i_col_lat)) / !RADEG
;    dblarr_height = dblarr_dist * sin(dblarr_lat)
;    dblarr_height = dblarr_height + dbl_distance_of_sun_from_galactic_plane
    dblarr_height = rave_get_height(DBLARR_DIST = dblarr_dist,$
                                    DBLARR_LAT = dblarr_lat)

    dblarr_r = rave_get_r(DBLARR_LON = dblarr_lon,$
                          DBLARR_DIST = dblarr_dist)

    dblarr_lon = 0
    dblarr_lat = 0

    i_pos = strpos(str_datafile,'_errdivby')
    if i_pos lt 0 then $
      i_pos = strpos(str_datafile,'.',/REVERSE_SEARCH)
    str_datafile_out = strmid(str_datafile,0,i_pos)+'_height_rcent'+strmid(str_datafile,i_pos)

    openw,lun,str_datafile_out,/GET_LUN
      for j=0ul,n_elements(dblarr_dist)-1 do begin
        printf,lun,strarr_data_lines(j)+' '+strtrim(string(dblarr_height(j)),2)+' '+strtrim(string(dblarr_r(j)),2)
      endfor
    free_lun,lun
    dblarr_height = 0
    dblarr_r = 0
    strarr_data = 0
    strarr_data_lines = 0
    print,'rave_besancon_calc_heights: <'+str_datafile_out+'> written'
;  endfor
end
