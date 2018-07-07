pro rave_compare_feh_to_mh_with_afe
  str_filename_in = '/home/azuri/daten/rave/soubiran2005/soubiran2005.tsv'

  int_col_FeH = 6
  int_col_OFe = 7
  int_col_NaFe = 8
  int_col_MgFe = 9
  int_col_AlFe = 10
  int_col_SiFe = 11
  int_col_CaFe = 12
  int_col_TiFe = 13
  int_col_NiFe = 14
  int_col_logg = 28
  int_col_teff = 27
  int_col_afe = 29

  str_indexfile = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/mh-from-feh-and-afe_calib-with-afe/index.html'
  openw,lun_index,str_indexfile,/GET_LUN
  printf,lun_index,'<html><body><center>'
;  for j=0,1 do begin
;    if j eq 0 then begin
;      b_dwarfs_only = 0
;      b_giants_only = 0
;      dbl_logg_min = -1.
;      dbl_logg_max = 10.
;    end else if j eq 1 then begin
      b_dwarfs_only = 1
      b_giants_only = 0
      dbl_logg_min = 3.5
      dbl_logg_max = 10.
;    end else begin
;      b_dwarfs_only = 0
;      b_giants_only = 1
;      dbl_logg_min = -1.
;      dbl_logg_max = 3.5
;    endelse

    strarr_data = readfiletostrarr(str_filename_in,';')

    dblarr_logg = double(strarr_data(*,int_col_logg))
    ;print,dblarr_logg
    ;stop
    indarr_logg = where((dblarr_logg ge dbl_logg_min) and (dblarr_logg lt dbl_logg_max))
    strarr_data = strarr_data(indarr_logg,*)

    dblarr_feh = double(strarr_data(*,int_col_FeH))
    indarr = where(strarr_data(*,int_col_FeH) ne '', COMPLEMENT=indarr_bad)
    strarr_data = strarr_data(indarr,*)
    dblarr_logg = double(strarr_data(*,int_col_logg))
    dblarr_feh = double(strarr_data(*,int_col_FeH))
    dblarr_logg = double(strarr_data(*,int_col_logg))
    dblarr_teff = double(strarr_data(*,int_col_teff))
    dblarr_afe = double(strarr_data(*,int_col_afe))
  ;  if indarr_bad(0) ge 0 then $
  ;    dblarr_feh(indarr_bad) = 99.9

    dblarr_mh = feh_and_afe_to_metallicity(I_STR_FILENAME = str_filename_in,$
                                          I_STR_DELIMITER = ';',$
                                          I_INT_COL_FEH  = int_col_feh,$
                                          I_INT_COL_AFE  = int_col_afe)
;    dblarr_mh = abundances_to_mh(I_STR_FILENAME=str_filename_in,$
;                                I_INT_COL_FEH = int_col_feh,$
;                                I_INT_COL_OFE = int_col_ofe,$
;                                I_INT_COL_NAFE = int_col_nafe,$
;                                I_INT_COL_MGFE = int_col_mgfe,$
;                                I_INT_COL_ALFE = int_col_alfe,$
;                                I_INT_COL_SIFE = int_col_sife,$
;                                I_INT_COL_CAFE = int_col_cafe,$
;                                I_INT_COl_TIFE = int_col_tife,$
;                                I_INT_COL_NIFE = int_col_nife,$
;                                I_STR_DELIMITER = ';')
    dblarr_mh = dblarr_mh(indarr_logg)
    dblarr_mh = dblarr_mh(indarr)

    for i=0,25 do begin
      int_sigma_minelements = 3
      b_diff_only = 0
      dblarr_xrange = [-1.2,0.5]
      str_xtickformat = '(F4.1)'
      str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/mh-from-feh-and-afe_calib-with-afe/'
      if i eq 0 then begin; --- Zwitter
        besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh,$
                              O_DBLARR_MH                       = dblarr_mh_from_feh,$ ; --- dblarr
                              I_INT_VERSION = 1
        str_plotname_root = str_plotname_root + 'MH-from-FeH-Zwitter_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!DDR2!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!DDR2!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_from_feh
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 1 then begin
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!DDR2!N [dex]'
        diff_str_ytitle = '[Fe/H]!DS&G!N - [M/H]!DDR2!N [dex]'
        str_plotname_root = str_plotname_root + 'MH-from-FeH-Zwitter_vs_FeH'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh_from_feh
        dblarr_yrange_diff = [-0.5,0.2]
      end else if i eq 2 then begin; --- mine
        dblarr_logg = double(strarr_data(*,int_col_logg))
        print,'dblarr_logg = ',dblarr_logg
        besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh,$
                              O_DBLARR_MH                       = dblarr_mh_from_feh,$ ; --- dblarr
                              I_INT_VERSION                     = 2,$
                              I_DBLARR_LOGG                     = dblarr_logg
        str_plotname_root = str_plotname_root + 'MH-from-FeH-Ritter_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!DRitter!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!DRitter!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_from_feh
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 3 then begin
        str_plotname_root = str_plotname_root + 'MH-from-FeH-Ritter_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!DRitter!N [dex]'
        diff_str_ytitle = '[Fe/H]!DS&G!N - [M/H]!DRitter!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh_from_feh
        dblarr_yrange_diff = [-0.5,0.2]
      end else if i eq 4 then begin
        str_plotname_root = str_plotname_root + 'MH_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H] [dex]'
        diff_str_ytitle = '[Fe/H]!DS&G!N - [M/H]!DS&G!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh
        dblarr_yrange_diff = [-0.5,0.2]
      end else if i eq 5 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH-from-FeH-smoothed-mean_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[Fe/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.2]
      end else if i eq 6 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH-from-FeH-smoothed-mean_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 7 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        b_diff_only = 1
      end else if i eq 8 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean_vs_aFe'
        str_xtitle = '[!4a!3/Fe] [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_afe
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [0.,0.5]
        b_diff_only = 1
        str_xtickformat = '(F4.1)'
      end else if i eq 9 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean_vs_Teff'
        str_xtitle = 'T!Deff!N [K]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_teff
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [4500.,7000.]
        b_diff_only = 1
        str_xtickformat = '(I6)'
      end else if i eq 10 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean_vs_logg'
        str_xtitle = 'log g [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_logg
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_xrange = [dbl_logg_min,4.8]
        dblarr_yrange_diff = [-0.5, 0.5]
        b_diff_only = 1
      end else if i eq 11 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib_vs_FeH'
        str_xtitle = '[Fe/H] [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_afe
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_xrange = [0.,0.5]
        dblarr_yrange_diff = [-0.5, 0.5]
        b_diff_only = 1
      end else if i eq 12 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH-from-FeH-smoothed-mean-calib_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 13 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib_vs_aFe'
        str_xtitle = '[!4a!3/Fe] [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_afe
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [0.,0.5]
        b_diff_only = 1
        str_xtickformat = '(F4.1)'
      end else if i eq 14 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib_vs_Teff'
        str_xtitle = 'T!Deff!N [K]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_teff
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [4500.,7000.]
        b_diff_only = 1
        str_xtickformat = '(I6)'
      end else if i eq 15 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib_vs_logg'
        str_xtitle = 'log g [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_logg
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_xrange = [dbl_logg_min,4.8]
        dblarr_yrange_diff = [-0.5, 0.5]
        b_diff_only = 1
      end else if i eq 16 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        b_diff_only = 1
      end else if i eq 17 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH-from-FeH-smoothed-mean-calib-calib_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 18 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib_vs_aFe'
        str_xtitle = '[!4a!3/Fe] [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_afe
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [0.,0.5]
        b_diff_only = 1
        str_xtickformat = '(F4.1)'
      end else if i eq 19 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib_vs_Teff'
        str_xtitle = 'T!Deff!N [K]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_teff
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [4500.,7000.]
        b_diff_only = 1
        str_xtickformat = '(I6)'
      end else if i eq 20 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib_vs_logg'
        str_xtitle = 'log g [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_logg
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_xrange = [dbl_logg_min,4.8]
        dblarr_yrange_diff = [-0.5, 0.5]
        b_diff_only = 1
      end else if i eq 21 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib-calib_vs_FeH'
        str_xtitle = '[Fe/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_feh
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        b_diff_only = 1
      end else if i eq 22 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH-from-FeH-smoothed-mean-calib-calib-calib_vs_MH'
        str_xtitle = '[M/H]!DS&G!N [dex]'
        str_ytitle = '[M/H]!Dnew!N [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_mh
        dblarr_y = dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
      end else if i eq 23 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib-calib_vs_aFe'
        str_xtitle = '[!4a!3/Fe] [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_afe
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [0.,0.5]
        b_diff_only = 1
        str_xtickformat = '(F4.1)'
      end else if i eq 24 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib-calib_vs_Teff'
        str_xtitle = 'T!Deff!N [K]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_teff
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_yrange_diff = [-0.5,0.5]
        dblarr_xrange = [4500.,7000.]
        b_diff_only = 1
        str_xtickformat = '(I6)'
      end else if i eq 25 then begin; --- mine
        str_plotname_root = str_plotname_root + 'MH_-_MH-from-FeH-smoothed-mean-calib-calib-calib_vs_logg'
        str_xtitle = 'log g [dex]'
        diff_str_ytitle = '[M/H]!DS&G!N - [M/H]!Dnew!N [dex]'
        dblarr_x = dblarr_logg
        dblarr_y = dblarr_mh - dblarr_mh_calib_new
        dblarr_xrange = [dbl_logg_min,4.8]
        dblarr_yrange_diff = [-0.5, 0.5]
        b_diff_only = 1
      endif

  ;    indarr_strange = where((dblarr_mh(indarr) - dblarr_mh_from_feh) lt -0.5, COMPLEMENT=indarr_good)
  ;    print,'dblarr_feh(indarr(indarr_strange)) = ',dblarr_feh(indarr(indarr_strange))
  ;    print,'strarr_data(indarr(indarr_strange),int_col_ofe) = ',strarr_data(indarr(indarr_strange),int_col_ofe)
  ;    print,'strarr_data(indarr(indarr_good),int_col_ofe) = ',strarr_data(indarr(indarr_good),int_col_ofe)
  ;    print,'strarr_data(indarr(indarr_strange),int_col_nafe) = ',strarr_data(indarr(indarr_strange),int_col_nafe)
  ;    print,'strarr_data(indarr(indarr_good),int_col_nafe) = ',strarr_data(indarr(indarr_good),int_col_nafe)
  ;    print,'dblarr_mh(indarr(indarr_strange)) = ',dblarr_mh(indarr(indarr_strange))
  ;    print,'dblarr_mh_from_feh(indarr_strange) = ',dblarr_mh_from_feh(indarr_strange)
  ;    stop
      dblarr_position=[0.17,0.16,0.97,0.92]

      if b_dwarfs_only then $
        str_plotname_root = str_plotname_root + '_dwarfs'
      if b_giants_only then $
        str_plotname_root = str_plotname_root + '_giants'

      print,'i=',i

      compare_two_parameters,dblarr_x,$
                             dblarr_y,$
                            str_plotname_root,$
  ;                           DBLARR_ERR_X             = dblarr_err_x,$
  ;                           DBLARR_ERR_Y             = dblarr_err_y,$
  ;                           DBLARR_RAVE_SNR          = dblarr_rave_snr,$
                            STR_XTITLE               = str_xtitle,$
                            STR_YTITLE               = str_ytitle,$
                            STR_TITLE                = 1,$
                            I_PSYM                   = 2,$
                            DBL_SYMSIZE              = 1.3,$
                            DBL_CHARSIZE             = 1.8,$
                            DBL_CHARTHICK            = 3.,$
                            DBL_THICK                = 3.,$
                            DBLARR_XRANGE            = dblarr_xrange,$
                            DBLARR_YRANGE            = [-1.2,0.5],$
                            DBLARR_POSITION          = dblarr_position,$
                            DIFF_DBLARR_YRANGE       = dblarr_yrange_diff,$
                            DIFF_DBLARR_POSITION     = dblarr_position,$
                            DIFF_STR_YTITLE          = diff_str_ytitle,$
                            ;I_B_DIFF_PLOT_Y_MINUS_X  = i_b_diff_plot_y_minus_x,$
                            ;I_XTICKS                 = i_xticks,$
                            STR_XTICKFORMAT          = str_xtickformat,$
                            ;I_YTICKS                 = i_yticks,$
                            ;DBL_REJECTVALUEX         = dbl_rejectvaluex,$;             --- double
                            ;DBL_REJECTVALUE_X_RANGE  = dbl_rejectvalue_x_range,$;             --- double
                            ;DBL_REJECTVALUEY         = dbl_rejectvaluey,$;             --- double
                            ;DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                            STR_YTICKFORMAT          = '(F4.1)',$
                            B_PRINTPDF               = 1,$;               --- bool (0/1)
                            SIGMA_I_NBINS            = 20,$
                            SIGMA_I_MINELEMENTS      = int_sigma_minelements,$
                            ;I_INT_MEANSIG_SERIES     = i_int_meansig_series,$
                            I_DBL_SIGMA_CLIP         = 3.,$
                            ;I_B_USE_WEIGHTED_MEAN    = i_b_use_weighted_mean,$
                            O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$ ; --- dblarr(sigma_i_nbins, 4): x, mean, sigma, nstars
                            I_INT_SMOOTH_MEAN_SIG    = 1,$
                            HIST_I_NBINSMIN          = 20,$;            --- int
                            HIST_I_NBINSMAX          = 30,$;            --- int
                            HIST_STR_XTITLE          = '[M/H] [dex]',$;            --- string
                            ;HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
                            ;HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                            HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                            ;HIST_B_POP_ID            = hist_b_popid,$;             --- bool
                            ;HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                            HIST_DBLARR_XRANGE       = [-1.2,0.5],$
                            ;HIST_DBLARR_YRANGE       = hist_dblarr_yrange,$
                            HIST_DBLARR_POSITION     = dblarr_position,$;   --- dblarr
                            ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                            O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                            ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                            ;DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
                            ;DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                            ;I_DBLARR_YFIT                      = i_dblarr_yfit,$
                            B_PRINT_MOMENTS                    = 1,$
                            I_DO_SIGMA_CLIPPING                = 1,$
                            O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                            ;I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                            ;I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                            B_DIFF_ONLY                        = b_diff_only;,$; --- dblarr_y given as dblarr_x-<some_parameter>
                            ;I_DBLARR_LINES_IN_DIFF_PLOT        = i_dblarr_lines_in_diff_plot,$
                            ;I_INTARR_SYMBOLS                   = i_intarr_symbols
      printf,lun_index,i,str_plotname_root+'<br>'
      printf,lun_index,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
      printf,lun_index,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br><hr><br>'

      ; --- write smoothed mean of [M/H]_Soubiran vs [Fe/H]_Soubiran to calibration file
      if (i eq 4) or (i eq 8) or (i eq 9) or (i eq 10) or (i eq 11) or (i eq 13) or (i eq 14) or (i eq 15) or (i eq 16) or (i eq 18) or (i eq 19) or (i eq 20) or (i eq 21)then begin
        str_calib = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH)+1)
        if i eq 4 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran'
        end else if i eq 8 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH_vs_aFe'
        end else if i eq 9 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH_vs_Teff'
        end else if i eq 10 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH_vs_logg'
        end else if i eq 11 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH_vs_FeH'
        end else if i eq 13 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib_vs_aFe'
        end else if i eq 14 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib_vs_Teff'
        end else if i eq 15 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib_vs_logg'
        end else if i eq 16 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib_vs_FeH'
        end else if i eq 18 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib-calib_vs_aFe'
        end else if i eq 19 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib-calib_vs_Teff'
        end else if i eq 20 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib-calib_vs_logg'
        end else if i eq 21 then begin
          str_calib = str_calib+'calibration_MH_from_FeH_Soubiran_dMH-calib-calib_vs_FeH'
        endif
        if b_dwarfs_only then $
          str_calib = str_calib + '_dwarfs'
        if b_giants_only then $
          str_calib = str_calib + '_giants'
        str_calib = str_calib + '.dat'
        openw,lun_cal,str_calib,/GET_LUN
        if (i eq 4) or (i eq 11) or (i eq 16) or (i eq 21) then begin
          printf,lun_cal,'#[Fe/H] mean([M/H]-[m/H])'
        end else if (i eq 8) or (i eq 13) or (i eq 18) then begin
          printf,lun_cal,'#[a/Fe] mean([M/H]-[m/H])'
        end else if (i eq 9) or (i eq 14) or (i eq 19) then begin
          printf,lun_cal,'#Teff mean([M/H]-[m/H])'
        end else if (i eq 10) or (i eq 15) or (i eq 20) then begin
          printf,lun_cal,'#log_g mean([M/H]-[m/H])'
        endif
        for j=0,n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
          if o_dblarr_diff_mean_sigma(j,3) gt int_sigma_minelements then begin
            printf,lun_cal,o_dblarr_diff_mean_sigma(j,0), o_dblarr_diff_mean_sigma(j,1)
          endif
        endfor
        free_lun,lun_cal

        if i eq 4 then begin
          print,'i = ',i
          dblarr_mh_calib_new = dblarr_x
          rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$; --- #x Par_ext-Par_RAVE
                                                              I_DBLARR_X                 = dblarr_x,$
                                                              IO_DBLARR_PARAMETER_VALUES = dblarr_mh_calib_new
          dblarr_correction = dblarr_x - dblarr_mh_calib_new
          dblarr_mh_calib_new = dblarr_feh  + dblarr_correction
;          calculate_mh_from_feh,I_STR_FILENAME_CALIB = str_calib,$
;                                I_DBLARR_FEH         = dblarr_feh,$
;                                O_DBLARR_MH          = dblarr_mh_calib_new,$
;                                I_DBLARR_LOGG        = dblarr_logg,$
;                                I_DBLARR_TEFF        = dblarr_teff
        end else begin
          print,'i = ',i
          rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = str_calib,$; --- #x Par_ext-Par_RAVE
                                                              I_DBLARR_X                 = dblarr_x,$
                                                              IO_DBLARR_PARAMETER_VALUES = dblarr_mh_calib_new

        endelse
      endif

    endfor
;  endfor
  printf,lun_index,'</center></body></html>'
  free_lun,lun_index
end
