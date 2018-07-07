pro rave_besancon_plot_histograms,STR_ERRDIVBY    =str_errdivby,$
                                  STR_PATH_IN     =str_path_in,$
                                  STR_DATAFILE_BESANCON_IN       = str_datafile_besancon_in,$
                                  I_CALIBRATE_RAVE_METALLICITIES = i_calibrate_rave_metallicities,$  ; --- 1: [M/H] = [m/H] + 0.2 for RAVE, no calibration for iron abundances                        ; --- 2: old calib (with logg)                                                                                                     ; --- 3: new calib (with teff)                                                                                                     ; --- 4: new calib DR3 seperate dwarfs/giants (with teff, logg, stn)
                                  B_DWARFS_ONLY   = b_dwarfs_only,$
                                  B_GIANTS_ONLY   = b_giants_only,$
                                  B_LOW_LAT_ONLY  = b_low_lat_only,$
                                  B_HIGH_LAT_ONLY = b_high_lat_only,$
                                  B_POPID         = b_popid,$
                                  B_STARTYPES     = b_startypes,$
                                  B_SAMPLE_LOGG   = b_sample_logg,$
                                  B_ABUNDANCES    = b_abundances

; --- pre: * rave_dist_write_min_err
; ---      * rave_find_doubles
; ---      * rave_find_good_stars
; ---      * besancon_get_ravesample (*2 - once for dist and once without)
; ---      * rave_besancon_calc_heights (*2 - once for distsample and once for samplex1)
; ---      * rave_besancon_plot_all(calc_errors+, b_dist+, do_*-)

  !P.CHARSIZE=1.2
  !P.CHARTHICK=2

  if not keyword_set(B_ABUNDANCES) then $
    b_abundances = 0
  b_calc_besancon_sample = 0
  b_one_besanconfile = 1
  b_lonlat = 1
  b_colorcut = 0
  if keyword_set(STR_ERRDIVBY) then begin
    b_without_errors = 0
  end else begin
    b_without_errors = 0
  endelse
;  if not keyword_set(B_ABUNDANCES) then begin
;    b_four_errors_only_for_samplex1 = 1
;  end else begin
  b_four_errors_only_for_samplex1 = 1
;  end

  if not(keyword_set(B_GIANTS_ONLY)) and not(keyword_set(B_DWARFS_ONLY)) then begin
    b_giants_only = 0
    b_dwarfs_only = 0
  endif
  if not(keyword_set(B_SAMPLE_LOGG)) then $
    b_sample_logg = 1

  i_nbins = 0
  nbins_max = 50
  nbins_min = 40

;  for ooo=0,5 do begin
;    if ooo lt 3 then begin
;      b_sample_logg = 0
;    end else begin
;      b_sample_logg = 1
;    endelse

;    if (ooo eq 0) or (ooo eq 3) then begin
;      b_giants_only = 0
;      b_dwarfs_only = 0
;    end else if (ooo eq 1) or (ooo eq 4) then begin
;      b_giants_only = 1
;      b_dwarfs_only = 0
;    end else if (ooo eq 2) or (ooo eq 5) then begin
;      b_giants_only = 0
;      b_dwarfs_only = 1
;    end

;  if b_abundances then begin
;    b_calculate_mh = 0
;  end else begin
;    b_calculate_mh = 0
;  end
  if not(keyword_set(B_LOW_LAT_ONLY)) then $
    b_low_lat_only = 0
  if not(keyword_set(B_HIGH_LAT_ONLY)) then $
    b_high_lat_only = 0

  if not(keyword_set(I_CALIBRATE_RAVE_METALLICITIES)) then $
    i_calibrate_rave_metallicities = 0
  ; --- 0: no calibration
  ; --- 1: [M/H] = [m/H] + 0.2 for RAVE, no calibration for iron abundances
  ; --- 2: old calib (with logg)
  ; --- 3: new calib (with teff)
  ; --- 4: new calib DR3 seperate dwarfs/giants (with teff, logg, stn)
  if b_abundances then $
    i_calibrate_rave_metallicities = 1

  if b_giants_only then begin
    dbl_logg_min = 0.
    dbl_logg_max = 3.5
    str_logg_only = 'giants/'
  endif
  if b_dwarfs_only then begin
    dbl_logg_min = 3.5
    dbl_logg_max = 10.
    str_logg_only = 'dwarfs/'
  endif

  if b_low_lat_only then begin
    dbl_lat_min = 0.
    dbl_lat_max = 25.
    dbl_lon_min = 230.
    dbl_lon_max = 315.
    str_lat = 'lat_lt_25/'
  endif
  if b_high_lat_only then begin
    dbl_lat_min = 25.
    dbl_lat_max = 90.
    str_lat = 'lat_gt_25/'
  endif
  if (not keyword_set(B_STARTYPES)) and (not keyword_set(B_POPID)) then begin
    b_startypes = 0
    b_popid = 1
  end else begin
    if not(keyword_set(B_STARTYPES)) then $
      b_startypes = 0
    if not(keyword_set(B_POPID)) then $
      b_popid = 0
  endelse
  d_BV_min = 0.4
  d_BV_max = 1.2
  dbl_i_max_a = 12.0
  dbl_i_max_b = 10.0
  dbl_i_min = 9.0
  i_nbins_i = 43

  i_col_rave_ra       = 3
  i_col_rave_dec      = 4
  i_col_rave_lon      = 5
  i_col_rave_lat      = 6
  i_col_rave_vrad     = 7; --- vrad
  i_col_rave_i        = 14; --- I [mag]
  i_col_rave_denis_j  = 52; --- Denis J [mag]
  i_col_rave_denis_k  = 54; --- Denis K [mag]
  i_col_rave_2mass_j  = 59; --- 2MASS J [mag]
  i_col_rave_2mass_k  = 63; --- 2MASS K [mag]
  i_col_rave_tycho_Bt = 36; --- Tycho Bt [mag]
  i_col_rave_tycho_Vt = 38; --- Tycho Vt [mag]
  i_col_rave_teff     = 19; --- Teff [K]
  i_col_rave_mh       = 21; --- [m/H]
  i_col_rave_mh_calib = 24; --- [m/H]
  i_col_rave_cmh_calib= 23; --- [M/H]
  i_col_rave_afe      = 22; --- [alpha/Fe]
  i_col_rave_logg     = 20; --- log g
  i_col_rave_id       = 0; --- ID
  i_col_rave_snr      = 33; --- SNR
  i_col_rave_s2n      = 34; --- S2N
  i_col_rave_stn      = 35; --- STN
  i_col_rave_bt       = 36; --- Tycho2 Bt
  i_col_rave_vt       = 38; --- Tycho2 Vt
  if b_abundances then begin
    i_col_rave_teff     = 70; --- Teff [K]
    i_col_rave_feh      = 68; --- [Fe/H]
    i_col_rave_mh       = i_col_rave_feh;72; --- [Fe/H]
    i_col_rave_afe      = 73; --- [alpha/Fe]
    i_col_rave_logg     = 71; --- log g
  endif

  i_col_rave_dist_ra       = 2
  i_col_rave_dist_dec      = 3
  i_col_rave_dist_lon      = 4
  i_col_rave_dist_lat      = 5
  i_col_rave_dist_vrad     = 6; --- vrad
  i_col_rave_dist_i        = 12; --- I [mag]
  i_col_rave_dist_dist_yy   = 22; --- dist
  i_col_rave_dist_dist_dart = 24; --- dist
  i_col_rave_dist_dist_padova = 26; --- dist
  i_col_rave_dist_height   = 28; --- height
  i_col_rave_dist_rcent    = 29; --- rcent
  i_col_rave_dist_logg     = 19

  i_col_rave_breddels_ra       = 1
  i_col_rave_breddels_dec      = 2
  i_col_rave_breddels_lon      = 3
  i_col_rave_breddels_lat      = 4
  i_col_rave_breddels_vrad     = 5; --- vrad
  i_col_rave_breddels_i        = 52; --- I [mag]
  i_col_rave_breddels_dist   = 28; --- dist
  i_col_rave_breddels_height   = 54; --- height
  i_col_rave_breddels_rcent    = 55; --- rcent
  i_col_rave_breddels_logg     = 13

  i_col_lon_besancon = 0
  i_col_lat_besancon = 1
  i_col_imag_besancon = 2
  i_col_vjmag_besancon = 3
  i_col_kmag_besancon = 4
  i_col_teff_besancon = 5
  i_col_logg_besancon = 6
  i_col_vrad_besancon = 7
  i_col_feh_besancon = 8
  i_col_dist_besancon = 9
  i_col_type_besancon = 10
  i_col_age_besancon = 11
;    i_col_vmi_besancon = 10; V-I, JmK: I-J
;    i_col_vmk_besancon = 11; V-K, JmK: I-K
  i_col_u_besancon = 12
  i_col_v_besancon = 13
  i_col_w_besancon = 14
  i_col_snr_besancon = 15
  i_col_height_besancon = 16
  i_col_rcent_besancon = 17
  if b_popid then begin
    i_col_startypes_besancon = 11
  end else begin
    i_col_startypes_besancon = 10
  end


;  str_err_div_by = 0
;  str_err_div_by = '0.50_0.50_0.50_0.50_0.50'
;  str_err_div_by = '1.00_1.00_1.00_1.00_1.00'
  if keyword_set(STR_ERRDIVBY) then begin
    str_err_div_by = str_errdivby
  end else begin
;    str_err_div_by = '0.25_0.25_0.25_0.25_0.25';'_2.00'
    if b_abundances then begin
      str_err_div_by = 'dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00';errdivby_1.56_2.37_2.75_1.50_2.00'
    end else begin
      str_err_div_by = '1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe';-giants-1_00-1_22-1_26-1_61-1_00';errdivby-dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00';1.00_1.00_1.00_1.00_1.00'
      ;str_err_div_by = 'dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00'
    end
  endelse
  if b_four_errors_only_for_samplex1 then begin
    str_err_div_by = strmid(str_err_div_by,0,strpos(str_err_div_by,'_',/REVERSE_SEARCH))
  endif
;  str_err_div_by = '1.56_2.37_2.75_1.50_1.00'
  print,'rave_besancon_plot_histograms: str_err_div_by = '+str_err_div_by

;  dbl_binwidth_i = (dbl_i_max_a - dbl_i_min) / double(i_nbins_i)

  str_logg = ''
  if b_sample_logg then begin
    str_logg = '_logg'
  endif

  ravedatafile = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-20-with-atm-par_samplex1_logg_0_errdivby_dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50.dat';'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1'+str_logg+'_0'



;  if b_without_errors then begin
;    ravedatafile = ravedatafile + '.dat'
;  end else begin
;    ravedatafile = ravedatafile + '_errdivby_'+str_err_div_by+'.dat'
;  end
  print,'ravedatafile = <'+ravedatafile+'>'
;  stop
  ;rave_internal_dr8_stn_gt_20_good_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_samplex1_0_errdivby_'+str_err_div_by+'.dat'
  if b_abundances then begin
    ravedatafile = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000_chemsample'+str_logg+'_0'
    if b_without_errors then begin
      ravedatafile = ravedatafile + '.dat'
    end else begin
      ravedatafile = ravedatafile + '_errdivby_'+str_err_div_by+'.dat'
      ;RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13_chemsample_logg_0_errdivby_'+str_err_div_by+'.dat'
    endelse
  endif
  if b_four_errors_only_for_samplex1 then $
    str_err_div_by  = str_err_div_by + strmid(str_err_div_by,strpos(str_err_div_by,'_',/REVERSE_SEARCH))
  if b_calc_besancon_sample then begin
    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr-i-dec-giant-dwarf-minus-ic1_gt_20_with_errors_height_rcent_errdivby-'+str_err_div_by+'.dat'
  end else begin

    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_with-errors_errdivby-dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50_vrad-from-uvwlb.dat';'/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh'
    ;besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1'
    if b_abundances then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_teff-gt-4000'
    end





;    if b_without_errors then begin
;      besancondatafile = besancondatafile + '_height_rcent_samplex1_9ltI2MASSlt12'+str_logg+'_0.dat'
;    end else begin
;      besancondatafile = besancondatafile + '_with-errors_height_rcent_errdivby-'+str_err_div_by+'_samplex1_9ltI2MASSlt12_calib'+str_logg+'_0.dat'
;      ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_err_div_by+'_snr-ge-20_samplex1_9ltI2MASSlt12_0.dat'
;    endelse
    if b_abundances then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1'
      if b_without_errors then begin
        besancondatafile = besancondatafile + '_height_rcent_chemsample_9ltI2MASSlt12_logg_0.dat'
      end else begin
        besancondatafile = besancondatafile + '_with_errors_errdivby_'+str_err_div_by+'_chemsample_9ltI2MASSlt12'+str_logg+'_0.dat'
        ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snrdec_gt_13_with_errors_errdivby_'+str_err_div_by+'_chemsample_9ltI2MASSlt12_logg_0.dat'
      endelse
    endif
  endelse

  str_temp = '/home/azuri/daten/besancon/lon-lat/'
  str_htmlpath = str_temp+'html/'
  str_path = str_temp
  str_temp = 'histograms/dr9/';'8/calib-merged/'
  spawn,'mkdir '+str_path+str_temp
  spawn,'mkdir '+str_htmlpath+str_temp
  if keyword_set(STR_PATH_IN) then begin
    str_temp = str_temp+str_path_in
    spawn,'mkdir '+str_path+str_temp
    spawn,'mkdir '+str_htmlpath+str_temp
  endif

  if strpos(ravedatafile,'sample') gt 0 then begin
    if strpos(strmid(ravedatafile,strpos(ravedatafile,'sample')),'_logg') gt 0 then begin
      str_temp = str_temp+'sample_logg/'
      spawn,'mkdir '+str_path+str_temp
      spawn,'mkdir '+str_htmlpath+str_temp
    end else begin
      str_temp = str_temp+'sample_no_logg/'
      spawn,'mkdir '+str_path+str_temp
      spawn,'mkdir '+str_htmlpath+str_temp
    endelse
  endif




  if i_calibrate_rave_metallicities eq 0 then begin
    str_temp = str_temp+'calibrated/'
  end else if i_calibrate_rave_metallicities eq 1 then begin
    if b_abundances then begin
      str_temp = str_temp+'abundances/'
    end else begin
      str_temp = str_temp+'mh+0.2/'
    end
  end else if i_calibrate_rave_metallicities eq 2 then begin
    str_temp = str_temp+'old_calib/'
  end else if i_calibrate_rave_metallicities eq 3 then begin
    str_temp = str_temp+'new_calib/'
  end else if i_calibrate_rave_metallicities eq 4 then begin
    str_temp = str_temp+'new_calib_DR3/'
  endif
  spawn,'mkdir '+str_path+str_temp
  spawn,'mkdir '+str_htmlpath+str_temp

  str_temp = str_temp+'vrad_coskunoglu/'
  spawn,'mkdir '+str_path+str_temp
  spawn,'mkdir '+str_htmlpath+str_temp

  if b_popid then begin
    str_temp = str_temp + 'popid/'
  end else if b_startypes then begin
    str_temp = str_temp + 'types/'
  end
  spawn,'mkdir '+str_path+str_temp
  spawn,'mkdir '+str_htmlpath+str_temp

  if not b_without_errors then begin
    str_temp = str_temp + 'errdivby_'+str_err_div_by
    ;str_temp = str_temp + strmid(str_err_div_by,strpos(str_err_div_by,'_',/REVERSE_SEARCH))
    str_temp = str_temp+'/'
    spawn,'mkdir '+str_path+str_temp
    spawn,'mkdir '+str_htmlpath+str_temp
  endif
  if b_giants_only or b_dwarfs_only then begin
    str_temp = str_temp+str_logg_only
    spawn,'mkdir '+str_path+str_temp
    spawn,'mkdir '+str_htmlpath+str_temp
  endif
  if b_low_lat_only or b_high_lat_only then begin
    str_temp = str_temp+str_lat
    spawn,'mkdir '+str_path+str_temp
    spawn,'mkdir '+str_htmlpath+str_temp
  endif
  str_htmlpath = str_htmlpath+str_temp
  str_path = str_path+str_temp
;  spawn,'rm -f '+str_htmlpath+'*'
  spawn,'mkdir '+str_htmlpath
;  spawn,'rm -f '+str_path+'*'
  spawn,'mkdir '+str_path
  str_time_file = str_htmlpath+'times.text'
  openw,lun_t,str_time_file,/GET_LUN
  printf,lun_t,'start time:',systime()

  str_temp = strtrim(string(dbl_i_min),2)
  str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
  str_htmlfile = str_htmlpath+'index_I'+str_temp+'-'
  str_temp = strtrim(string(dbl_i_max_a),2)
  str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
  str_htmlfile = str_htmlfile+str_temp
  if not i_nbins then begin
    str_htmlfile = str_htmlfile + '_'+strtrim(string(nbins_min),2)+'-'+strtrim(string(nbins_max),2)+'bins'
  end else begin
    str_htmlfile = str_htmlfile +'_'+strtrim(string(i_nbins),2)+'bins'
  end
;  if b_calculate_mh eq 1 then begin
;    str_htmlfile = str_htmlfile + '_besMH'
;  endif
  str_htmlfile = str_htmlfile+'.html'
  print,'rave_besancon_plot_histograms: str_htmlfile = <'+str_htmlfile+'>'
  openw,lun_html,str_htmlfile,/GET_LUN
  printf,lun_html,'<html>'
  printf,lun_html,'<body>'

  i_ndatalines_rave = countlines(ravedatafile)
  print,'rave_besancon_plot_histograms: ravedatafile <'+ravedatafile+'> contains i_ndatalines_rave = ',i_ndatalines_rave
  if i_ndatalines_rave eq 0 then begin
    problem=1
    free_lun,lun_t
    free_lun,lun_html
    return
  end
  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
  if b_low_lat_only or b_high_lat_only then begin
    dblarr_lat_rave = double(strarr_ravedata_all(*,i_col_rave_lat))
    indarr = where(abs(dblarr_lat_rave) ge dbl_lat_min and abs(dblarr_lat_rave) le dbl_lat_max)
    strarr_ravedata_all = strarr_ravedata_all(indarr,*)
    dblarr_lat_rave = 0
  endif
  if b_low_lat_only then begin
    if b_lonlat eq 1 then begin
      dblarr_lon_rave = double(strarr_ravedata_all(*,i_col_rave_lon))
    end else begin
      dblarr_lon_rave = double(strarr_ravedata_all(*,i_col_rave_ra))
    endelse
    indarr = where(dblarr_lon_rave ge dbl_lon_min and dblarr_lon_rave le dbl_lon_max)
    strarr_ravedata_all = strarr_ravedata_all(indarr,*)
  endif
  strarr_ravedata = strarr(n_elements(strarr_ravedata_all(*,0)),17)
  if b_lonlat eq 1 then begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_lon)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_lat)
    i_col_rave_lon = 0
    i_col_rave_lat = 1
  end else begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_ra)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_dec)
    i_col_rave_ra = 0
    i_col_rave_dec = 1
  end
  print,'rave_besancon_plot_histograms: ravedatafile "'+ravedatafile+'" read'
  strarr_ravedata(*,2) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
  strarr_ravedata(*,3) = strarr_ravedata_all(*,i_col_rave_vrad) ; --- vrad
  strarr_ravedata(*,4) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
  strarr_ravedata(*,5) = strarr_ravedata_all(*,i_col_rave_teff) ; --- Teff [K]
  strarr_ravedata(*,6) = strarr_ravedata_all(*,i_col_rave_mh); --- [Fe/H]
  strarr_ravedata(*,7) = strarr_ravedata_all(*,i_col_rave_afe); --- [alpha/Fe]
  strarr_ravedata(*,8) = strarr_ravedata_all(*,i_col_rave_logg); --- log g
  strarr_ravedata(*,9) = strarr_ravedata_all(*,i_col_rave_bt); --- BT
  strarr_ravedata(*,10) = strarr_ravedata_all(*,i_col_rave_vt); --- VT
  strarr_ravedata(*,11) = strarr_ravedata_all(*,i_col_rave_snr); --- VT
  strarr_ravedata(*,12) = strarr_ravedata_all(*,i_col_rave_s2n); --- VT
  strarr_ravedata(*,13) = strarr_ravedata_all(*,i_col_rave_stn); --- VT
  strarr_ravedata(*,14) = strarr_ravedata_all(*,i_col_rave_cmh_calib); --- [Fe/H]
  strarr_ravedata(*,15) = strarr_ravedata_all(*,i_col_rave_mh_calib); --- [Fe/H]

;  stop

  strarr_ravedata_all = 0
  i_col_rave_i = 2
  i_col_rave_vrad = 3
  i_col_rave_teff = 5
  i_col_rave_mh = 6
  i_col_rave_afe = 7
  i_col_rave_logg = 8
  i_col_rave_bt = 9
  i_col_rave_vt = 10
  i_col_rave_snr = 11
  i_col_rave_s2n = 12
  i_col_rave_stn = 13
  i_col_rave_cmh_calib = 14
  i_col_rave_mh_calib = 15
  i_col_rave_cmh = 16

  dblarr_ravedata = double(strarr_ravedata)
  strarr_ravedata = 0
  if b_giants_only or b_dwarfs_only then begin
    indarr_logg = where(dblarr_ravedata(*,8) lt dbl_logg_max and dblarr_ravedata(*,8) ge dbl_logg_min)
    dblarr_ravedata = dblarr_ravedata(indarr_logg,*)
  endif

  if b_one_besanconfile eq 1 then begin
    i_ndatalines = countlines(besancondatafile)
    print,'rave_besancon_plot_histograms: i_ndatalines = ',i_ndatalines,' in besancondatafile <'+besancondatafile+'>'
    if i_ndatalines eq 0 then begin
      problem=1
      free_lun,lun_t
      free_lun,lun_html
      return
    endif
    strarr_besancondata = readfiletostrarr(besancondatafile,' ')
    print,'rave_besancon_plot_histograms: besancondatafile "'+besancondatafile+'" read'
  end else begin
    strarr_besancondata = 0
  endelse
  if b_without_errors then $
    strarr_besancondata(*,i_col_teff_besancon) = string(10.^double(strarr_besancondata(*,i_col_teff_besancon)))
  if b_low_lat_only or b_high_lat_only then begin
    dblarr_lat_bes = double(strarr_besancondata(*,i_col_lat_besancon))
    indarr = where(abs(dblarr_lat_bes) ge dbl_lat_min and abs(dblarr_lat_bes) le dbl_lat_max)
    strarr_besancondata = strarr_besancondata(indarr,*)
    if b_low_lat_only then begin
      dblarr_lon_bes = double(strarr_besancondata(*,i_col_lon_besancon))
      indarr = where(dblarr_lon_bes ge dbl_lon_min and dblarr_lon_bes le dbl_lon_max)
      strarr_besancondata = strarr_besancondata(indarr,*)
      dblarr_lon_bes = 0
    endif
    dblarr_lat_bes = 0
  endif

; --- log cut
  dblarr_logg = double(strarr_besancondata(*,i_col_logg_besancon))
  if b_giants_only or b_dwarfs_only then begin
    indarr_logg = where(dblarr_logg lt dbl_logg_max and dblarr_logg ge dbl_logg_min)
    strarr_besancondata = strarr_besancondata(indarr_logg,*)
  endif

  ; --- calibrate Metallicities
  dblarr_mH = dblarr_ravedata(*,i_col_rave_mh)
  dblarr_aFe = dblarr_ravedata(*,i_col_rave_afe)
  dblarr_teff = dblarr_ravedata(*,i_col_rave_teff)
  dblarr_logg = dblarr_ravedata(*,i_col_rave_logg)
  dblarr_stn = dblarr_ravedata(*,i_col_rave_stn)
  dblarr_snr = dblarr_ravedata(*,i_col_rave_snr)
  indarr = where(abs(dblarr_stn) lt 0.0000001)
  if indarr(0) ge 0 then $
    dblarr_stn(indarr) = dblarr_snr(indarr)
  print,'rave_besancon_plot_histograms: ',n_elements(dblarr_mH),' stars in RAVE'
  if i_calibrate_rave_metallicities eq 1 then begin
    if b_abundances then begin
      dblarr_MH_calibrated = dblarr_mH
    end else begin
      dblarr_MH_calibrated = dblarr_mH + 0.2
    endelse
  end else if i_calibrate_rave_metallicities eq 2 then begin
    rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mH,$
                                 I_DBLARR_AFE           = dblarr_aFe,$
                                 I_DBLARR_LOGG          = dblarr_logg,$
                                 I_DBL_REJECTVALUE      = 99.9,$
                                 I_DBL_REJECTERR        = 1.,$
                                 O_STRARR_MH_CALIBRATED = dblarr_MH_calibrated
  end else if i_calibrate_rave_metallicities eq 3 then begin
    rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mH,$
                                 I_DBLARR_AFE           = dblarr_aFe,$
                                 I_DBLARR_TEFF          = dblarr_teff,$
                                 I_DBL_REJECTVALUE      = 99.9,$
                                 I_DBL_REJECTERR        = 1.,$
                                 O_STRARR_MH_CALIBRATED = dblarr_MH_calibrated
  end else if (i_calibrate_rave_metallicities eq 4) or (i_calibrate_rave_metallicities eq 0) then begin
    rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mH,$
                                 I_DBLARR_AFE           = dblarr_aFe,$
                                 I_DBLARR_TEFF          = dblarr_teff,$
                                 I_DBLARR_LOGG          = dblarr_logg,$
                                 I_DBLARR_STN           = dblarr_stn,$; --- calibration from DR3 paper
                                 I_DBL_REJECTVALUE      = 99.9,$
                                 I_DBL_REJECTERR        = 1.,$
                                 O_STRARR_MH_CALIBRATED = strarr_mh_calibrated,$
                                 I_B_SEPARATE           = 1
  endif
  if i_calibrate_rave_metallicities eq 0 then begin
    dblarr_ravedata(*,i_col_rave_cmh) = double(strarr_mh_calibrated); --- [Fe/H]
  end else begin
    dblarr_ravedata(*,i_col_rave_mh) = double(strarr_mh_calibrated)
  endelse

  ; --- count bad stars
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_teff)) lt 0.01)
  i_nstars_teff = n_elements(dblarr_ravedata(*,i_col_rave_teff)) - n_elements(indarr)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without Teff'
;  print,'rave_besancon_plot_histograms: Teff = ',strarr_ravedata(*,6)
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_mh) - 99.999) lt 0.0001)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without [M/H]'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_mh) - 99.999) lt 0.0001 or abs(dblarr_ravedata(*,i_col_rave_mh) - 99.99) lt 0.001)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without [M/H]'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_mh) - 99.9) lt 0.01 or abs(dblarr_ravedata(*,i_col_rave_mh) - 99.99) lt 0.001 or abs(dblarr_ravedata(*,i_col_rave_mh) - 99.999) lt 0.0001)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without [M/H]'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_mh) - 99.9) lt 1.)
  i_nstars_mh = n_elements(dblarr_ravedata(*,i_col_rave_mh)) - n_elements(indarr)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without [M/H]'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_logg) - 99.9) lt 1.)
  i_nstars_logg = n_elements(dblarr_ravedata(*,i_col_rave_logg)) - n_elements(indarr)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without logg'
;  stop
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_afe) - 99.9) lt 1.)
  i_nstars_afe = n_elements(dblarr_ravedata(*,i_col_rave_afe)) - n_elements(indarr)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without [alpha/Fe]'
;  indarr = where(abs(dblarr_ravedata(*,8)) lt 0.1)
;  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without log g'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_bt) - 99.9) lt 1.)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without BT'
  indarr = where(abs(dblarr_ravedata(*,i_col_rave_vt) - 99.9) lt 1.)
  print,'rave_besancon_plot_histograms: ',n_elements(indarr),' stars without VT'

  if b_calc_besancon_sample then begin
    ; --- fill RAVE-I bins with randomly selected Besancon stars
    besancon_select_stars_from_imag_bin,I_NBINS_I = i_nbins_i,$
                                        DBL_I_MIN = dbl_i_min,$
                                        DBL_I_MAX = dbl_i_max_a,$
                                        STRARR_BESANCONDATA = strarr_besancondata,$
                                        DBLARR_RAVEDATA = dblarr_ravedata,$
                                        DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins
  end else begin
    dblarr_besancon_imag_bins = double(strarr_besancondata)
  endelse

  dblarr_star_types_plot = dblarr_besancon_imag_bins(*,i_col_startypes_besancon)

  str_i_max_a = strtrim(string(dbl_i_max_a),2)
  str_i_max_a = strmid(str_i_max_a,0,strpos(str_i_max_a,'.')+2)
  printf,lun_html,'<center>9.0 < I < '+str_i_max_a+'</center><br>'
  printf,lun_html,'<center>'+strtrim(string(n_elements(dblarr_star_types_plot)),2)+' besancon stars</center><br>'
  printf,lun_html,'<center>'+strtrim(string(n_elements(dblarr_ravedata(*,3))),2)+' rave stars with v_rad</center><br>'
  printf,lun_html,'<center>'+strtrim(string(i_nstars_teff),2)+' rave stars with T_eff</center><br>'
  printf,lun_html,'<center>'+strtrim(string(i_nstars_mh),2)+' rave stars with [M/H]</center><br>'
  printf,lun_html,'<center>'+strtrim(string(i_nstars_logg),2)+' rave stars with log g</center><br>'
  printf,lun_html,'<center>'+strtrim(string(i_nstars_afe),2)+' rave stars with [alpha/Fe]</center><br>'
  print,'rave_besancon_plot_histograms: n_elements(dblarr_ravedata(*,2)) = ',n_elements(dblarr_ravedata(*,2))

  dbl_thick = 3.
  dblarr_position = [0.125,0.16,0.91,0.99]
  dbl_charsize = 1.8
  dbl_charthick = 3.

  for lll=0,3 do begin
    if lll eq 0 then begin
      i_col_rave_dist_dist = i_col_rave_dist_dist_yy
      ravedatafile_dist = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent_distsample'
      str_which_dist = 'yy'
      iii_start = 0
    end else if lll eq 1 then begin
      i_col_rave_dist_dist = i_col_rave_dist_dist_dart
      ravedatafile_dist = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent_distsample'
      str_which_dist = 'dart'
      iii_start = 10
    end else if lll eq 2 then begin
      i_col_rave_dist_dist = i_col_rave_dist_dist_padova
      ravedatafile_dist = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent_distsample'
      str_which_dist = 'padova'
      iii_start = 10
    end else begin
      i_col_rave_dist_dist = i_col_rave_breddels_dist
      i_col_rave_dist_ra       = i_col_rave_breddels_ra
      i_col_rave_dist_dec      = i_col_rave_breddels_dec
      i_col_rave_dist_lon      = i_col_rave_breddels_lon
      i_col_rave_dist_lat      = i_col_rave_breddels_lat
      i_col_rave_dist_vrad     = i_col_rave_breddels_vrad
      i_col_rave_dist_i        = i_col_rave_breddels_i
      i_col_rave_dist_height   = i_col_rave_breddels_height
      i_col_rave_dist_rcent    = i_col_rave_breddels_rcent
      i_col_rave_dist_logg     = i_col_rave_breddels_logg
      ravedatafile_dist = '/home/azuri/daten/rave/rave_data/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS-9ltIlt12-lb+stn_height_rcent_distsample'
      str_which_dist = 'breddels'
      iii_start = 10
    endelse

    for iii = iii_start, 12 do begin
      if iii eq 0 then begin
        str_filename_root = str_path+'I_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
      ;  if (i eq 0) or (i eq 2) then begin
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        dbl_i_max = dbl_i_max_a
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        print,'rave_besancon_plot_histograms: size(dblarr_star_types_plot) = ',size(dblarr_star_types_plot)
        print,'rave_besancon_plot_histograms: size(dblarr_besancon_imag_bins) = ',size(dblarr_besancon_imag_bins)
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_i)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_imag_besancon)
        print,'n_elements(dblarr_star_types_plot) = ',n_elements(dblarr_star_types_plot)
        print,'n_elements(dblarr_besancondata_plot) = ',n_elements(dblarr_besancondata_plot)
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        str_xtitle = 'I [mag]'
        dblarr_xrange=[dbl_i_min,dbl_i_max]
        dbl_rejectvaluex = 0
        b_print_moments = 0
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 1 then begin
        print,'rave_besancon_plot_histograms: n_elements(dblarr_ravedata(*,3)) = ',n_elements(dblarr_ravedata(*,3))
        str_filename_root=str_path+'vrad_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_vrad)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_vrad_besancon)
        str_xtickformat = '(I6)'
        str_xtitle = 'Radial Velocity [km/s]'
        dbl_rejectvaluex = 0
        dblarr_xrange = [-150.,150.]
        b_print_moments = 1
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 2 then begin
        dblarr_teff = dblarr_ravedata(*,i_col_rave_teff)
        print,'rave_besancon_plot_histograms: n_elements(dblarr_teff) = ',n_elements(dblarr_teff)
        str_filename_root=str_path+'Teff_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_teff
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_teff_besancon)
  ;      print,'dblarr_ravedata_plot = ',dblarr_ravedata_plot
  ;      print,'dblarr_besancondata_plot = ',dblarr_besancondata_plot
  ;      stop
        intarr_indarr = where(abs(dblarr_ravedata_plot) gt .1)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)

        int_xticks = 0
        str_xtitle = 'Effective Temperature [K]'
        dblarr_xrange = [3000.,8000.]
        dbl_rejectvaluex = 0.0000001
        i_nbins = 0
        nbins_max = 44
        nbins_min = 30
        if b_giants_only then begin
          b_print_moments = 3
          dblarr_xrange = [3000.,6500.]
          int_xticks = 7
        end else if b_dwarfs_only then begin
          b_print_moments = 1
          int_xticks = 5
        end else begin
          b_print_moments = 0
        endelse
      end else if iii eq 3 then begin
        str_filename_root=str_path+'mMH_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_mh)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_feh_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot - 99.9) gt 10.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        str_xtitle = '[m/H] [dex]'
        if b_abundances then $
          str_xtitle = '[Fe/H] [dex]'
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        dblarr_xrange = [-2.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 1
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 4 then begin
        str_filename_root=str_path+'mMH_calib_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_mh_calib)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_feh_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot - 99.9) gt 10.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        str_xtitle = '[m/H]!Dcalib!N [dex]'
        if b_abundances then $
          str_xtitle = '[Fe/H] [dex]'
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        dblarr_xrange = [-2.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 1
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 5 then begin
        str_filename_root=str_path+'MH_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_cmh)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_feh_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot - 99.9) gt 10.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        str_xtitle = '[M/H] [dex]'
        if b_abundances then $
          str_xtitle = '[Fe/H] [dex]'
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        dblarr_xrange = [-2.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 1
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 6 then begin
        str_filename_root=str_path+'MH-calib_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_cmh_calib)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_feh_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot - 99.9) gt 10.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        str_xtitle = '[M/H]!Dcalib!N [dex]'
        if b_abundances then $
          str_xtitle = '[Fe/H] [dex]'
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        dblarr_xrange = [-2.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 1
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 7 then begin

        print,'rave_besancon_plot_histograms: n_elements(dblarr_ravedata(*,8)) = ',n_elements(dblarr_ravedata(*,8))
        str_filename_root=str_path+'logg_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_logg)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_logg_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot - 99.9) gt 10.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        int_xticks = 0
        str_xtickformat = '(F4.1)'
        str_xtitle='log g [dex]'
        dblarr_xrange = [0.,5.5]
        dbl_rejectvaluex = 99.9
        i_nbins = 0
        nbins_max = 30
        nbins_min = 20
        if b_giants_only then begin
          dblarr_xrange = [0.,3.5]
          b_print_moments = 1
        end else if b_dwarfs_only then begin
          dblarr_xrange = [3.5,5.5]
          b_print_moments = 3
        end else begin
          b_print_moments = 0
        endelse
      end else if iii eq 8 then begin
        str_filename_root=str_path+'snr_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_snr)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_snr_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot) gt 0.)
        dblarr_ravedata_plot = dblarr_ravedata_plot(intarr_indarr)
        int_xticks = 6
        str_xtickformat = '(I3)'
        str_xtitle = 'SNR'
        dblarr_xrange = [0.,120.]
        dbl_rejectvaluex = 0.00000001
        b_print_moments = 3
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 9 then begin
        str_filename_root=str_path+'stn_rave_besancon'
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = dblarr_ravedata(*,i_col_rave_stn)
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_snr_besancon)
        intarr_indarr = where(abs(dblarr_ravedata_plot) lt 0.001)
        if intarr_indarr(0) ge 0 then begin
          dblarr_ravedata_plot(intarr_indarr) = dblarr_ravedata(intarr_indarr,i_col_rave_s2n)
          print,n_elements(intarr_indarr),' stars without STN'
        endif
        intarr_indarr = where(abs(dblarr_ravedata_plot) lt 0.001)
        if intarr_indarr(0) ge 0 then begin
          dblarr_ravedata_plot(intarr_indarr) = dblarr_ravedata(intarr_indarr,i_col_rave_snr)
          print,n_elements(intarr_indarr),' stars without S2N'
        endif
        dblarr_xrange = [0.,120.]
        dbl_rejectvaluex = 0.000001
        str_xtickformat = '(I3)'
        str_xtitle = 'STN'
        b_print_moments = 3
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 10 then begin
        printf,lun_html,'<br>'
        if not b_calc_besancon_sample then begin
  ;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_distsample_height_rcent.dat'

  ;      if not b_without_errors then begin
  ;        if keyword_set(STR_ERRDIVBY) then begin
  ;          if b_four_errors_only_for_samplex1 then begin
  ;            str_err_div_by = str_errdivby;+strmid(str_errdivby,strpos(str_errdivby,'_',/REVERSE_SEARCH))
  ;          endif
  ;        end else begin
  ;          if b_four_errors_only_for_samplex1 then begin
  ;            str_err_div_by = str_err_div_by+strmid(str_err_div_by,strpos(str_errdivby,'_',/REVERSE_SEARCH))
  ;          endif
  ;        end
  ;          str_err_div_by = 'dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00'
  ;      endif

  ;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors_height_rcent_errdivby_'+str_err_div_by+'_distsample_0.dat'
          besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb'
          if b_without_errors then begin
            besancondatafile = besancondatafile + '_height_rcent_distsample_9ltI2MASSlt12'
          end else begin
            besancondatafile = besancondatafile + '_with-errors_height_rcent_errdivby-'+str_err_div_by+'_distsample_9ltI2MASSlt12'
          endelse
          if lll eq 3 then $
            besancondatafile = besancondatafile + '_breddels'
          besancondatafile = besancondatafile +str_logg+'_0.dat'
      ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_err_div_by+'_snr-ge-20_distsample_9ltI2MASSlt12_0.dat'

  ;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_distsample_with_errors_heights_errdivby_'+str_err_div_by+'.dat'
  ;    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_distsample_with_errors_errdivby_'+str_err_div_by+'.dat'
          strarr_besancondata = readfiletostrarr(besancondatafile,' ')
        endif
        ravedatafile = ravedatafile_dist+str_logg+'_0'
        ;'/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb_minus_ic1_height_rcent_distsample'+str_logg+'_0'
        if b_without_errors then begin
          ravedatafile = ravedatafile + '.dat'
        end else begin
          ravedatafile = ravedatafile + '_errdivby_'+str_err_div_by+'.dat'
        endelse
        ;ravedatafile = 'Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK_gt_0_5_IDenis2MASS_9ltIlt12_lb_height_rcent_distsample_logg_0.dat'
      ;  ravedatafile = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK_gt_0_5_distsample_0_height_rcent.dat'
        i_ndatalines = countdatlines(ravedatafile)
        print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines
        strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
        print,'rave_besancon_plot_all: strarr_ravedata_all(0,*) = ',strarr_ravedata_all(0,*)

        dblarr_dist_temp = double(strarr_ravedata_all(*,i_col_rave_dist_dist))
        indarr_good = where(dblarr_dist_temp lt 20.)
        strarr_ravedata_all = strarr_ravedata_all(indarr_good,*)

        if b_low_lat_only or b_high_lat_only then begin
          dblarr_lat_rave = double(strarr_ravedata_all(*,i_col_rave_dist_lat))
          indarr = where(abs(dblarr_lat_rave) ge dbl_lat_min and abs(dblarr_lat_rave) le dbl_lat_max)
          strarr_ravedata_all = strarr_ravedata_all(indarr,*)
          dblarr_lat_rave = 0
          indarr = 0
        endif
        if b_giants_only or b_dwarfs_only then begin
          dblarr_logg_dist = double(strarr_ravedata_all(*,i_col_rave_dist_logg))
          indarr = where(dblarr_logg_dist lt dbl_logg_max and dblarr_logg_dist ge dbl_logg_min)
          strarr_ravedata_all = strarr_ravedata_all(indarr,*)
          dblarr_logg_dist = 0
          indarr = 0
          dblarr_logg_bes = double(strarr_besancondata(*,i_col_logg_besancon))
          indarr_logg_bes = where(dblarr_logg_bes lt dbl_logg_max and dblarr_logg_bes ge dbl_logg_min)
          strarr_besancondata = strarr_besancondata(indarr_logg_bes,*)
          dblarr_logg_bes = 0
          indarr_logg_bes = 0
          print,'size(strarr_besancondata) = ',size(strarr_besancondata)
          print,'size(strarr_ravedata_all) = ',size(strarr_ravedata_all)
        endif

        strarr_ravedata_dist = strarr(n_elements(strarr_ravedata_all(*,i_col_rave_dist_dist)),5)
        if b_lonlat eq 1 then begin
          strarr_ravedata_dist(*,0) = strarr_ravedata_all(*,i_col_rave_dist_lon)
          strarr_ravedata_dist(*,1) = strarr_ravedata_all(*,i_col_rave_dist_lat)
          i_col_rave_dist_lon_plot = 0
          i_col_rave_dist_lat_plot = 1
        end else begin
          strarr_ravedata_dist(*,0) = strarr_ravedata_all(*,i_col_rave_dist_ra)
          strarr_ravedata_dist(*,1) = strarr_ravedata_all(*,i_col_rave_dist_dec)
          i_col_rave_dist_ra_plot = 0
          i_col_rave_dist_dec_plot = 1
        endelse
        print,'rave_besancon_plot_histograms: ravedatafile "'+ravedatafile+'" read'

        strarr_ravedata_dist(*,2) = strarr_ravedata_all(*,i_col_rave_dist_i); --- Imag
        strarr_ravedata_dist(*,3) = strarr_ravedata_all(*,i_col_rave_dist_dist); --- distance
        strarr_ravedata_dist(*,4) = strarr_ravedata_all(*,i_col_rave_dist_height); --- height
        i_col_rave_dist_i_plot = 2
        i_col_rave_dist_dist_plot = 3
        i_col_rave_dist_height_plot = 4

        str_filename_root=str_path+'dist_rave_besancon_'+str_which_dist
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'

        if b_calc_besancon_sample then begin
          ; --- fill RAVE-I bins with randomly selected Besancon stars
          besancon_select_stars_from_imag_bin,I_NBINS_I = i_nbins_i,$
                                              DBL_I_MIN = dbl_i_min,$
                                              DBL_I_MAX = dbl_i_max_a,$
                                              STRARR_BESANCONDATA = strarr_besancondata,$
                                              DBLARR_RAVEDATA = double(strarr_ravedata_dist),$
                                              DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins
        end else begin
          dblarr_besancon_imag_bins = double(strarr_besancondata)
        endelse

        dblarr_ravedata_plot = double(strarr_ravedata_dist(*,i_col_rave_dist_dist_plot))
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_dist_besancon)
        dblarr_star_types_plot = dblarr_besancon_imag_bins(*,i_col_startypes_besancon)
        int_xticks = 0
        str_xtickformat = '(I2)'
        if b_dwarfs_only then $
          str_xtickformat = '(F4.1)'
        str_xtitle = 'Distance [kpc]'
        dblarr_xrange = [0.,6.]
        if b_dwarfs_only then $
          dblarr_xrange = [0.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 3
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 11 then begin
        str_filename_root=str_path+'height_rave_besancon_'+str_which_dist
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        dblarr_ravedata_plot = double(strarr_ravedata_dist(*,i_col_rave_dist_height_plot))
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_height_besancon)
  ;      print,'dblarr_ravedata_plot = ',dblarr_ravedata_plot
  ;      print,'dblarr_besancondata_plot = ',dblarr_besancondata_plot
  ;      stop
        int_xticks = 4
        str_xtickformat = '(I2)'
        if b_dwarfs_only then $
          str_xtickformat = '(F4.1)'
        str_xtitle = 'z [kpc]'
        dblarr_xrange = [-4.,4.]
        if b_dwarfs_only then $
          dblarr_xrange = [-1.,1.]
        dbl_rejectvaluex = 99.9
        b_print_moments = 3
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end else if iii eq 12 then begin
        str_filename_root = str_path+'Idist_rave_besancon_'+str_which_dist
        str_temp = strtrim(string(dbl_i_min),2)
        str_temp = strmid(str_temp,0,strpos(str_temp,'.'))
        str_temp_max_a = strtrim(string(dbl_i_max_a),2)
        str_filename_root = str_filename_root+'_I'+str_temp+'-'+strmid(str_temp_max_a,0,strpos(str_temp_max_a,'.'))
        dbl_i_max = dbl_i_max_a
        if i_nbins ne 0 then $
          str_filename_root = str_filename_root+'_'+strtrim(string(i_nbins),2)+'bins'
        print,'rave_besancon_plot_histograms: size(dblarr_star_types_plot) = ',size(dblarr_star_types_plot)
        print,'rave_besancon_plot_histograms: size(dblarr_besancon_imag_bins) = ',size(dblarr_besancon_imag_bins)

        dblarr_ravedata_plot = double(strarr_ravedata_dist(*,i_col_rave_dist_i_plot))
        dblarr_besancondata_plot = dblarr_besancon_imag_bins(*,i_col_imag_besancon)
        dblarr_position = [0.125,0.16,0.91,0.99]
        int_xticks = 6
        str_xtickformat = '(F4.1)'
        str_xtitle = 'I [mag]'
        dblarr_xrange = [dbl_i_min,dbl_i_max]
        dbl_rejectvaluex = 0
        b_print_moments = 0
        i_nbins = 0
        nbins_max = 50
        nbins_min = 40
      end





      str_meansig_file = str_filename_root+'_mean_sigma.dat'
      openw,lun_mean,str_meansig_file,/GET_LUN
        printf,lun_mean,'mean_rave = ',mean(dblarr_ravedata_plot),', mean_besancon = ',mean(dblarr_besancondata_plot)
        printf,lun_mean,'sigma_rave = ',meanabsdev(dblarr_ravedata_plot),', sigma_besancon = ',meanabsdev(dblarr_besancondata_plot)
      free_lun,lun_mean
      spawn,'cp '+str_meansig_file+' '+str_htmlpath+'/'

      str_moments_file = str_filename_root+'_moments.dat'
      openw,lun_moments,str_moments_file,/GET_LUN
        printf,lun_moments,'#mean stddev skewness kurtosis'
        dblarr_moments_temp = moment(dblarr_ravedata_plot)
        printf,lun_moments,'#rave:'
        printf,lun_moments,strtrim(string(dblarr_moments_temp(0)),2)+' '+strtrim(string(sqrt(dblarr_moments_temp(1))),2)+' '+strtrim(string(dblarr_moments_temp(2)),2)+' '+strtrim(string(dblarr_moments_temp(3)),2)
        dblarr_moments_temp = moment(dblarr_besancondata_plot)
        printf,lun_moments,'#besancon:'
        printf,lun_moments,strtrim(string(dblarr_moments_temp(0)),2)+' '+strtrim(string(sqrt(dblarr_moments_temp(1))),2)+' '+strtrim(string(dblarr_moments_temp(2)),2)+' '+strtrim(string(dblarr_moments_temp(3)),2)
      free_lun,lun_moments
      spawn,'cp '+str_moments_file+' '+str_htmlpath+'/'

      print,'n_elements(dblarr_besancondata_plot) = ',n_elements(dblarr_besancondata_plot)
      print,'n_elements(dblarr_star_types_plot) = ',n_elements(dblarr_star_types_plot)
      if n_elements(dblarr_besancondata_plot) ne n_elements(dblarr_star_types_plot) then $
        stop

      plot_two_histograms,dblarr_ravedata_plot,$
                          dblarr_besancondata_plot,$
                          STR_PLOTNAME_ROOT=str_filename_root,$
                          XTITLE=str_xtitle,$
                          YTITLE='Percentage of Stars',$
                          NBINSMAX = nbins_max,$
                          NBINSMIN = nbins_min,$
                          TITLE='',$
                          XRANGE=dblarr_xrange,$
                          YRANGE=0,$
                          MAXNORM=0,$
                          PERCENTAGE=1,$
                          PRINTPDF=1,$
                          COLOUR=1,$
                          I_NBINS=i_nbins,$
                          DBLARR_STAR_TYPES=dblarr_star_types_plot,$
                          B_POP_ID = b_popid,$
                          B_RESIDUAL=1,$
                          REJECTVALUEX=dbl_rejectvaluex,$
                          I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                          I_DBL_THICK = dbl_thick,$;
                          I_INT_XTICKS = int_xticks,$
                          I_STR_XTICKFORMAT = str_xtickformat,$
                          I_DBL_CHARSIZE = dbl_charsize,$
                          I_DBL_CHARTHICK = dbl_charthick,$
                          B_PRINT_MOMENTS = b_print_moments
      print,'rave_besancon_plot_histograms: n_elements(dblarr_ravedata(*,2)) = ',n_elements(dblarr_ravedata(*,2))
      spawn,'mv '+str_filename_root+'.gif '+str_htmlpath
      printf,lun_html,'<a href="'+strmid(str_filename_root,strpos(str_filename_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_filename_root,strpos(str_filename_root,'/',/REVERSE_SEARCH)+1)+'.gif"'
    endfor
  endfor


  printf,lun_html,'</body>'
  printf,lun_html,'</html>'
  free_lun,lun_html

  printf,lun_t,'end time:',systime()
  free_lun,lun_t
  dblarr_ravedata_plot = 0
  dblarr_besancondata_plot = 0
  dblarr_aFe = 0
  dblarr_besancon_feh = 0
  dblarr_besancon_i = 0
  dblarr_besancon_logg = 0
  dblarr_besancon_mh = 0
  dblarr_besancon_temp = 0
  dblarr_BT = 0
  dblarr_BV = 0
  dblarr_gravity = 0
  dblarr_i_sn_rave = 0
  dblarr_Imag = 0
  dblarr_logg = 0
  dblarr_lon = 0
  dblarr_metallicity = 0
  dblarr_mH = 0
  dblarr_MH_calibrated = 0
  dblarr_ravedata = 0
  dblarr_star_types = 0
  dblarr_star_types_plot = 0
  dblarr_teff = 0
  dblarr_teff_sigma = 0
  dblarr_temp = 0
  dblarr_temperature = 0
  dblarr_VT = 0
  strarr_besancondata = 0
;  strarr_besancondata_plot = 0
  dblarr_besancon_imag_bins = 0
  strarr_ravedata = 0
  strarr_ravedata_all = 0
  strarr_ravedata_dist = 0
;  strarr_ravedata_plot = 0
;  stop
end
