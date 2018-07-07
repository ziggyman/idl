pro besancon_get_ravesample,I_STR_FILENAME_RAVE = i_str_filename_rave,$
                            I_STR_FILENAME_BES  = i_str_filename_bes,$
                            STR_ERRDIVBY=str_errdivby,$
                            B_CHEM = b_chem,$
                            B_DIST = b_dist

  ; pre: besancon_do_error_convolution
  ; pre: rave_besancon_calc_heights

  str_XxY = '10x10'

  if not keyword_set(B_DIST) then $
    b_dist = 0
  if not keyword_set(B_CHEM) then $
    b_chem = 0
  b_without_errors = 0
  if not keyword_set(STR_ERRDIVBY) then $
    str_errdivby = 'dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50';'1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe';-giants-1_00-1_22-1_26-1_61-1_00';dwarfs-1_00-1_66-1_60-1_90-1_00-giants-1_00-1_50-1_80-2_00-1_00'
;    b_without_errors = 1

  b_breddels = 0

  if b_breddels then $
    b_dist = 1
  dbl_seed = 13.
  i_n_samples = 1
  i_rave_dr = 10
  i_nbins_i_min = 30
  i_nbins_i_max = 35
  i_nbins_snr = 30
  dbl_i_min = 9.
  dbl_i_max = 12.
  int_which_sample = 2; --- 1: besancon_select_stars_from_imag_bin
                      ; --- 2: besancon_select_stars_from_logg_imag_bin
                      ; --- 3: besancon_select_stars_from_logg_snr_imag_bin - not necessary!!!
  dblarr_range_i = [dbl_i_min,dbl_i_max]

  i_col_bes_lon = 0;5
  i_col_bes_lat = 1;6
  i_col_bes_i   = 2
  i_col_bes_logg = 6
  i_col_bes_snr = 15

  str_fieldsfile = '/rave/fields_lon_lat_small_new-'+str_XxY+'.dat'
;  str_fieldsfile = '/rave/fields_lon_lat_small_new-5x5_new.dat'
;  str_besanconfile = '/home/azuri/daten/besancon/sanjib_mh+snr.dat'

;  if not keyword_set(STR_ERRDIVBY) then $
;    str_errdivby = '1.00_1.00_1.00_1.00_1.00'
    ;str_errdivby = '1.56_2.37_2.75_1.50_2.00'



;  str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr_with_errors_height_rcent_errdivby_1.56_2.37_2.75_1.00_1.00.dat'
;  str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snrdec_gt_20.dat'
;  str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr.dat'
  ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_+snrdec_gt_20_dwarfs+giants_with_errors_errdivby_4.00-1.19_1.10-2.00_4.00-1.80_0.25-2.00_2.00-2.00.dat'

;  if keyword_set(STR_DATAFILE) then $
;    str_besanconfile = str_datafile

  print,'b_dist = ',b_dist
  print,'b_chem = ',b_chem

  if b_dist then begin
    if b_breddels then begin
      i_col_rave_lon = 3
      i_col_rave_lat = 4
      i_col_rave_i = 52
      i_col_rave_logg = 13
      i_col_rave_stn = 53
      ;i_col_rave_dist = 28
      str_ravefile = '/rave/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS-9ltIlt12-lb+stn_height_rcent.dat'
    end else begin
      i_col_rave_lon = 4
      i_col_rave_lat = 5
      i_col_rave_i = 12
      i_col_rave_logg = 19
      i_col_rave_stn = 21
      str_ravefile = '/rave/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent.dat';Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_lb_minus_ic1_height_rcent.dat'
    endelse
    str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb';/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1'
    if b_without_errors then begin
      str_besanconfile = str_besanconfile + '_height_rcent.dat'
    end else begin
      str_besanconfile = str_besanconfile +$ ;'_with_errors_height_rcent_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
      '_with-errors_height_rcent_errdivby-'+str_errdivby+'.dat'
    endelse
;    str_ravefile = '/rave/distances/all_20100201_SN20_lon_lat_no_doubles_minerr.dat'
  end else begin
    if i_rave_dr eq 7 then begin
      i_col_rave_lon = 4
      i_col_rave_lat = 5
      i_col_rave_i = 13
      str_ravefile = '/rave/release7/rave_internal_290110_no_doubles_maxsnr_SNR_gt_20.dat'
      str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_errdivby+'_snr-ge-20.dat'
    end else if i_rave_dr eq 8 then begin
      i_col_rave_lon = 5
      i_col_rave_lat = 6
      i_col_rave_i = 14
      i_col_rave_logg = 20
      i_col_rave_snr = 33
      i_col_rave_s2n = 34
      i_col_rave_stn = 35
;      str_ravefile = '/rave/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5.dat'
;      str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_all_rave_stars_samplex1.dat'
      if b_chem then begin
        str_ravefile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000.dat'
                                                                  ; RAVE_abd_frac_gt_70_with-2MASS-JK_minus-
        ;ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_teff-gt-4000.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with_errors_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00_teff-gt-4000_height_rcent.dat'
        endelse
          ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
      end else begin
        str_ravefile = '/rave/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged.dat';_STN-gt-20-with-atm-par.dat'
        ;rave_internal_dr8_stn_gt_20_good_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12.dat';rave_internal_dr8_all_good_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh';_with-errors'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_vrad-from-uvwlb'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_height_rcent.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with-errors_height_rcent_errdivby-'+str_errdivby+'.dat';-MH-from-FeH-and-aFe.dat';dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
          print,'str_besanconfile = ',str_besanconfile
        endelse
        print,'str_besanconfile = ',str_besanconfile
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-
       ;new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_errdivby_'+str_errdivby+'.dat'
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_errdivby+'_snr-ge-20.dat'
      endelse
    end else if i_rave_dr eq 9 then begin
      i_col_rave_lon = 5
      i_col_rave_lat = 6
      i_col_rave_i = 14
      i_col_rave_logg = 20
      i_col_rave_snr = 33
      i_col_rave_s2n = 34
      i_col_rave_stn = 35
;      str_ravefile = '/rave/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5.dat'
;      str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_all_rave_stars_samplex1.dat'
      if b_chem then begin
        str_ravefile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000.dat'
                                                                  ; RAVE_abd_frac_gt_70_with-2MASS-JK_minus-
        ;ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_teff-gt-4000.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with_errors_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00_teff-gt-4000_height_rcent.dat'
        endelse
         ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
      end else begin
        str_ravefile = '/rave/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-20-with-atm-par.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20';_vrad-from-uvwlb_adj-mh';_with-errors'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_vrad-from-uvwlb'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_height_rcent.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with-errors_errdivby-'+str_errdivby+'.dat';-MH-from-FeH-and-aFe.dat';dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
          print,'str_besanconfile = ',str_besanconfile
        endelse
          print,'str_besanconfile = ',str_besanconfile
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-
       ;new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_errdivby_'+str_errdivby+'.dat'
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_errdivby+'_snr-ge-20.dat'
      end
    end else if i_rave_dr eq 10 then begin
      i_col_rave_lon = 5
      i_col_rave_lat = 6
      i_col_rave_i = 14
      i_col_rave_logg = 20
      i_col_rave_snr = 33
      i_col_rave_s2n = 34
      i_col_rave_stn = 35
;      str_ravefile = '/rave/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5.dat'
;      str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_all_rave_stars_samplex1.dat'
      if b_chem then begin
        str_ravefile = '/rave/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000.dat'
                                                                  ; RAVE_abd_frac_gt_70_with-2MASS-JK_minus-
        ;ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat';RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_teff-gt-4000.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with_errors_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00_teff-gt-4000_height_rcent.dat'
        endelse
         ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
      end else begin
        str_ravefile = '/rave/release10/raveinternal_150512_with2MASSJK_noFlag_minusIC1-IC2_230-315_-25-25_JmK2MASSgt0_5_noDBLS-within2arcsec-maxSNR_I2MASS-9ltIlt12_STNgt20WithAtmPar_MHgood.dat'
        str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20';_vrad-from-uvwlb_adj-mh';_with-errors'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_vrad-from-uvwlb'
        if b_without_errors then begin
          str_besanconfile = str_besanconfile + '_height_rcent.dat'
        end else begin
          str_besanconfile = str_besanconfile + '_with-errors_errdivby-'+str_errdivby+'.dat';-MH-from-FeH-and-aFe.dat';dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
          print,'str_besanconfile = ',str_besanconfile
        endelse
          print,'str_besanconfile = ',str_besanconfile
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-
       ;new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_dwarfs_errdivby_2.70_0.75_3.00_1.00_giants_errdivby_1.50_1.50_1.80_1.50_2.00.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_errdivby_'+str_errdivby+'.dat'
        ;str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_errdivby_'+str_errdivby+'.dat'
                                                                ;besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_'+str_errdivby+'_snr-ge-20.dat'
      end
;      str_ravefile = '/rave/release8/rave_internal_dr8_stn_lt_20_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5.dat'
;      str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_rave_stn_lt_20_samplex1.dat'
    end
  end

  if keyword_set(I_STR_FILENAME_BES) then begin
    str_besanconfile = i_str_filename_bes
  end
  if b_dist then begin
    str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_distsample-'+str_XxY+'_9ltI2MASSlt12'
    if b_breddels then $
      str_outfile_root = str_outfile_root + '_breddels'
  end else if b_chem then begin
    str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_chemsample-'+str_XxY+'_9ltI2MASSlt12'
  end else begin
    str_outfile_root = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_samplex1-'+str_XxY+'_9ltI2MASSlt12_calib'
  endelse

  if keyword_set(I_STR_FILENAME_RAVE) then begin
    str_ravefile = i_str_filename_rave
  end

  if int_which_sample eq 2 then begin
    str_outfile_root = str_outfile_root+'_logg'
  end else if int_which_sample eq 3 then begin
    str_outfile_root = str_outfile_root+'_logg_snr'
  end
;  str_outfile_root = str_outfile_root+'.dat'

  strarr_fields = readfiletostrarr(str_fieldsfile,' ')
  i_nfields = countdatlines(str_fieldsfile)

  dblarr_fields = double(strarr_fields(*,0:3))
  print,'besancon_get_ravesample: dblarr_fields(0,*) = ',dblarr_fields(0,*)

  strarr_besancondata = readfiletostrarr(str_besanconfile,' ')
  i_nbesanconstars = countdatlines(str_besanconfile)
  dblarr_besancondata_fields = dblarr(i_nbesanconstars,5)
  dblarr_besancondata_fields(*,0) = double(strarr_besancondata(*,i_col_bes_lon)); --- lon
  dblarr_besancondata_fields(*,1) = double(strarr_besancondata(*,i_col_bes_lat)); --- lat
  dblarr_besancondata_fields(*,2) = double(strarr_besancondata(*,i_col_bes_i)); --- I mag
  dblarr_besancondata_fields(*,3) = double(strarr_besancondata(*,i_col_bes_logg)); --- log g
  dblarr_besancondata_fields(*,4) = double(strarr_besancondata(*,i_col_bes_snr)); --- SNR

  dblarr_besancon_lon = dblarr_besancondata_fields(*,0)
  dblarr_besancon_lat = dblarr_besancondata_fields(*,1)
  strarr_besancondata = 0
  strarr_besancondata = readfilelinestoarr(str_besanconfile,STR_DONT_READ='#')

  print,'besancon_get_ravesample: strarr_besancondata(0,*) = ',strarr_besancondata(0,*)

;  if b_dist then begin
;    strarr_ravedata = readfiletostrarr(str_ravefile,',')
;  end else begin
    strarr_ravedata = readfiletostrarr(str_ravefile,' ',I_NDATALINES=i_nravestars)
;  end
;  i_nravestars = countdatlines(str_ravefile)
  dblarr_ravedata = dblarr(i_nravestars,5)
  dblarr_ravedata(*,0) = double(strarr_ravedata(*,i_col_rave_lon)); --- lon
  dblarr_ravedata(*,1) = double(strarr_ravedata(*,i_col_rave_lat)); --- lat
  dblarr_ravedata(*,2) = double(strarr_ravedata(*,i_col_rave_i)); --- Imag
  dblarr_ravedata(*,3) = double(strarr_ravedata(*,i_col_rave_logg)); --- log g

  if not b_dist then begin
    dblarr_snr = double(strarr_ravedata(*,i_col_rave_snr))
    dblarr_s2n = double(strarr_ravedata(*,i_col_rave_s2n))
    dblarr_stn = double(strarr_ravedata(*,i_col_rave_stn))

    indarr = where(dblarr_stn lt 0.0001)
    if indarr(0) ge 0 then $
      dblarr_stn(indarr) = dblarr_s2n(indarr)
    indarr = where(dblarr_stn lt 0.0001)
    if indarr(0) ge 0 then $
      dblarr_stn(indarr) = dblarr_snr(indarr)
    dblarr_snr = 0
    dblarr_s2n = 0
    dblarr_ravedata(*,4) = dblarr_stn
    dblarr_stn = 0
  end else begin
    dblarr_ravedata(*,4) = double(strarr_ravedata(*,i_col_rave_stn))
  end

  nbins_i = 1
  dbl_bin_width_i = 1.
  get_bin_width,DBLARR_DATA_A    = dblarr_ravedata(*,2),$; --- in
                DBLARR_DATA_B    = dblarr_besancondata_fields(*,2),$; --- in
                DBLARR_BIN_RANGE = dblarr_range_i,$; --- in
                I_NBINS_MIN      = i_nbins_i_min,$; --- in
                I_NBINS_MAX      = i_nbins_i_max,$; --- in
                DBL_BIN_WIDTH    = dbl_bin_width_i,$; --- out
                NBINS            = nbins_i; --- out


  if b_dist then begin
;    dblarr_ravedata(*,0) = double(strarr_ravedata(*,i_col_rave_lon)); --- lon
;    dblarr_ravedata(*,1) = double(strarr_ravedata(*,i_col_rave_lat)); --- lat
;    dblarr_ravedata(*,2) = double(strarr_ravedata(*,i_col_rave_i)); --- Imag
    indarr_temp = where(dblarr_ravedata(*,0) lt 0.,count)
    if indarr_temp(0) ne -1 then begin
      print,'besancon_get_ravesample: ERROR: lon < 0 ',count,' times'
      print,'besancon_get_ravesample: dblarr_ravedata(indarr_temp,0) = ',dblarr_ravedata(indarr_temp,0)
      stop
    endif
    indarr_temp = where(dblarr_ravedata(*,1) gt 90.,count)
    if indarr_temp(0) ne -1 then begin
      print,'besancon_get_ravesample: ERROR: lat > 90 ',count,' times'
      print,'besancon_get_ravesample: dblarr_ravedata(indarr_temp,1) = ',dblarr_ravedata(indarr_temp,1)
      stop
    endif
    indarr_temp = where(dblarr_ravedata(*,0) lt -90.,count)
    if indarr_temp(0) ne -1 then begin
      print,'besancon_get_ravesample: ERROR: lon < -90 ',count,' times'
      print,'besancon_get_ravesample: dblarr_ravedata(indarr_temp,1) = ',dblarr_ravedata(indarr_temp,1)
      stop
    endif
;    dblarr_ravedata(indarr_temp,0) = 360. + dblarr_ravedata(indarr_temp,0)
  end; else begin
;  end
  print,'besancon_get_ravesample: dblarr_ravedata(0,*) = ',dblarr_ravedata(0,*)
;  stop
  strarr_ravedata = 0
  strarr_ravedata = readfilelinestoarr(str_ravefile)

  for ii=0ul, i_n_samples-1 do begin
    o_strarr_rave_all = dblarr(n_elements(dblarr_ravedata(*,0)),n_elements(dblarr_ravedata(0,*)))
    i_n_out_rave_stars = 0

    str_outfile = str_outfile_root + '-'+str_XxY+'_' + strtrim(string(ii),2) + '.dat'
    ;str_outfile = strmid(str_outfile_root,0,strpos(str_outfile_root,'.',/REVERSE_SEARCH)) + '_' + strtrim(string(ii),2) + strmid(str_outfile_root,strpos(str_outfile_root,'.',/REVERSE_SEARCH))

    openw,lun,str_outfile,/GET_LUN
      str_outfile_rave = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))
      if b_dist then begin
        str_outfile_rave = str_outfile_rave + '_distsample-'+str_XxY
      end else begin
        if b_chem then begin
          str_outfile_rave = str_outfile_rave + '_chemsample-'+str_XxY
        end else begin
          str_outfile_rave = str_outfile_rave + '_samplex1-'+str_XxY
        end
      end
      if int_which_sample eq 2 then begin
        str_outfile_rave = str_outfile_rave + '_logg'
      end else if int_which_sample eq 3 then begin
        str_outfile_rave = str_outfile_rave + '_logg_snr'
      end
      str_outfile_rave = str_outfile_rave + '_' + strtrim(string(ii),2)
      if not b_without_errors then $
        str_outfile_rave = str_outfile_rave + '_errdivby_'+str_errdivby
      str_outfile_rave = str_outfile_rave + strmid(str_ravefile,strpos(str_ravefile,'.',/REVERSE_SEARCH))
      openw,luna,str_outfile_rave,/GET_LUN
        for i=0ul, i_nfields-1 do begin
          indarr_rave = where(dblarr_ravedata(*,0) ge dblarr_fields(i,0) and dblarr_ravedata(*,0) lt dblarr_fields(i,1) and dblarr_ravedata(*,1) ge dblarr_fields(i,2) and dblarr_ravedata(*,1) lt dblarr_fields(i,3))

          indarr_bes = where(dblarr_besancon_lon ge dblarr_fields(i,0) and dblarr_besancon_lon lt dblarr_fields(i,1) and dblarr_besancon_lat ge dblarr_fields(i,2) and dblarr_besancon_lat lt dblarr_fields(i,3))

          print,'besancon_get_ravesample: field ',i,': n_elements(indarr_rave) = ',n_elements(indarr_rave),', n_elements(indarr_bes) = ',n_elements(indarr_bes)

          if indarr_bes(0) ge 0 and indarr_rave(0) ge 0 then begin
            o_indarr_bes = 1
            o_indarr_rave = 1
            if int_which_sample eq 1 then begin
              besancon_select_stars_from_imag_bin,I_NBINS_I = nbins_i,$
                                                  DBL_I_MIN = dbl_i_min,$
                                                  DBL_I_MAX = dbl_i_min + (nbins_i * dbl_bin_width_i),$
                                                  STRARR_BESANCONDATA = dblarr_besancondata_fields(indarr_bes,*),$
                                                  DBLARR_RAVEDATA = dblarr_ravedata(indarr_rave,*),$
                                                  O_DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins,$
                                                  O_INDARR_BESANCON = o_indarr_bes,$
                                                  B_OVERSAMPLE = 0,$
                                                  O_INDARR_RAVE = o_indarr_rave,$
                                                  DBL_SEED = dbl_seed
            end else if int_which_sample eq 2 then begin
              besancon_select_stars_from_logg_imag_bin,I_NBINS_I                   = nbins_i,$; --- must be set
                                                      DBL_I_MIN                   = dbl_i_min,$; --- must be set
                                                      DBL_I_MAX                   = dbl_i_min + (nbins_i * dbl_bin_width_i),$; --- must be set
                                                      STRARR_BESANCONDATA         = dblarr_besancondata_fields(indarr_bes,*),$; --- must be set
                                                      DBLARR_RAVEDATA             = dblarr_ravedata(indarr_rave,*),$; --- must be set
                                                      O_DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins,$; --- output parameter
                                                      O_INDARR_RAVE               = o_indarr_rave,$; --- output parameter
                                                                                                    ; --- set to 1 to write o_indarr_ravedata
                                                      O_INDARR_BESANCON           = o_indarr_bes,$; --- output parameter
                                                                                                  ; --- set to 1 to write o_o_indarr_bes
                                                      DBL_SEED                    = dbl_seed,$
                                                      I_COL_I_RAVE                = 2,$
                                                      I_COL_I_BESANCON            = 2,$
                                                      I_COL_LOGG_RAVE             = 3,$
                                                      I_COL_LOGG_BESANCON         = 3
            end else begin
              besancon_select_stars_from_logg_snr_imag_bin,I_NBINS_I                   = nbins_i,$; --- must be set
                                                           I_NBINS_SNR                 = i_nbins_snr,$; --- must be set
                                                           DBL_I_MIN                   = dbl_i_min,$; --- must be set
                                                           DBL_I_MAX                   = dbl_i_min + (nbins_i * dbl_bin_width_i),$; --- must be set
                                                           STRARR_BESANCONDATA         = dblarr_besancondata_fields(indarr_bes,*),$; --- must be set
                                                           DBLARR_RAVEDATA             = dblarr_ravedata(indarr_rave,*),$; --- must be set
                                                           O_DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins,$; --- output parameter
                                                           O_INDARR_RAVE               = o_indarr_rave,$; --- output parameter
                                                                                                        ; --- set to 1 to write o_indarr_ravedata
                                                           O_INDARR_BESANCON           = o_indarr_bes,$; --- output parameter
                                                                                                      ; --- set to 1 to write o_o_indarr_bes
                                                           DBL_SEED                    = dbl_seed,$
                                                           I_COL_I_RAVE                = 2,$
                                                           I_COL_I_BESANCON            = 2,$
                                                           I_COL_LOGG_RAVE             = 3,$
                                                           I_COL_LOGG_BESANCON         = 3,$
                                                           I_COL_SNR_BESANCON          = 4,$
                                                           I_COL_SNR_RAVE              = 4
            end
            print,'field i=',i,': dblarr_fields(i,*) = ',dblarr_fields(i,*)
            print,'size(indarr_rave) = ',size(indarr_rave)
            print,'size(indarr_bes) = ',size(indarr_bes)
            print,'size(o_indarr_rave) = ',size(o_indarr_rave)
            print,'size(o_indarr_bes) = ',size(o_indarr_bes)
            print,'size(dblarr_besancon_imag_bins) = ',size(dblarr_besancon_imag_bins)
            for j=0ul,n_elements(o_indarr_bes)-1 do begin
              printf,lun,strarr_besancondata(indarr_bes(o_indarr_bes(j)))
              printf,luna,strarr_ravedata(indarr_rave(o_indarr_rave(j)))
            endfor
          endif
        endfor
      free_lun,luna
    free_lun,lun
  endfor
  print,'besancon_get_ravesample ready'
  print,'size(o_indarr_bes) = ',size(o_indarr_bes)
  print,'size(o_indarr_rave) = ',size(o_indarr_rave)
  print,'str_outfile = <'+str_outfile+'>'
  print,'str_outfile_rave = <'+str_outfile_rave+'>'
end
