pro rave_plot_metallicities










; --- plot [Fe/H] calculated from rave [M/H] vs. chemical [Fe/H]
; ---                  remember only interested in real (not complex) values!














  str_filename_in = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_frac_gt_70.dat';_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
  ;str_filename_in = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'

  str_outdir = strmid(str_filename_in,0,strpos(str_filename_in,'/',/REVERSE_SEARCH))+'/html/'
  spawn,'mkdir '+str_outdir
  str_outdir = str_outdir+'metallicities/'
  spawn,'mkdir '+str_outdir

  str_index_html = str_outdir+'index.html'
  openw,lun,str_index_html,/GET_LUN
  printf,lun,'<html><body><center>'
  printf,lun,'<h2>Different Metallicities (RAVE and Chemical Pipeline)</h2><br>'

  i_col_chem_mh = 72
  i_col_chem_feh = 68
  i_col_chem_logg = 71
  i_col_chem_teff = 70
  i_col_chem_afe = 73
  i_col_chem_snr = 35

  i_col_rave_mh = 21
  i_col_rave_logg = 20
  i_col_rave_teff = 19
  i_col_rave_afe = 22
  i_col_rave_snr = 33
  i_col_rave_s2n = 34
  i_col_rave_stn = 35

  rejectvalue = 99.9
  rejectvalue_stn = 0.
  rejecterr = 1.

  i_nbins_sigma = 30

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NDATALINES=i_nlines)

  dblarr_chem_feh = double(strarr_data(*,i_col_chem_feh))
;  print,'dblarr_chem_feh = ',dblarr_chem_feh
;  stop
  dblarr_chem_mh = double(strarr_data(*,i_col_chem_mh))
  dblarr_chem_teff = double(strarr_data(*,i_col_chem_teff))
  dblarr_chem_logg = double(strarr_data(*,i_col_chem_logg))
  dblarr_chem_afe = double(strarr_data(*,i_col_chem_afe))
;  dblarr_chem_snr = double(strarr_data(*,i_col_chem_snr))

  dblarr_rave_mh = double(strarr_data(*,i_col_rave_mh))
  dblarr_rave_teff = double(strarr_data(*,i_col_rave_teff))
  dblarr_rave_logg = double(strarr_data(*,i_col_rave_logg))
  dblarr_rave_afe = double(strarr_data(*,i_col_rave_afe))
  dblarr_rave_stn = double(strarr_data(*,i_col_rave_stn))
  indarr = where(dblarr_rave_stn lt 1.)
  if indarr(0) ge 0 then $
    dblarr_rave_stn(indarr) = double(strarr_data(indarr,i_col_rave_s2n))
  indarr = where(dblarr_rave_stn lt 1.)
  if indarr(0) ge 0 then $
    dblarr_rave_stn(indarr) = double(strarr_data(indarr,i_col_rave_snr))

  indarr = where((abs(dblarr_chem_feh) lt 8.) and (abs(dblarr_chem_mh) lt 8.) and (abs(dblarr_chem_afe) lt 5.) and (dblarr_rave_mh lt 99.))
  dblarr_chem_feh = dblarr_chem_feh(indarr)
  dblarr_chem_mh = dblarr_chem_mh(indarr)
  dblarr_chem_teff = dblarr_chem_teff(indarr)
  dblarr_chem_logg= dblarr_chem_logg(indarr)
  dblarr_chem_afe = dblarr_chem_afe(indarr)

  dblarr_rave_mh = dblarr_rave_mh(indarr)
  dblarr_rave_teff = dblarr_rave_teff(indarr)
  dblarr_rave_logg = dblarr_rave_logg(indarr)
  dblarr_rave_afe = dblarr_rave_afe(indarr)
  dblarr_rave_stn = dblarr_rave_stn(indarr)

  set_plot,'ps'

  str_hist_ytitle = 'Percentage of stars'

  for i=0, 23 do begin
    dblarr_yfit = 0
    dblarr_xrange=[-2.5,1.1]
    dblarr_yrange=[-2.5,1.]
    dblarr_yrange_diff = [-1.5,1.5]
    dblarr_position = [0.175,0.178,0.93,0.97]
    str_xtickformat = '(F6.1)'
    str_plot = str_outdir+strmid(str_filename_in,strpos(str_filename_in,'/',/REVERSE_SEARCH)+1)
    dblarr_vertical_lines_in_plot = 0
    dblarr_vertical_lines_in_diff_plot = 0
    dblarr_vertical_lines_in_hist_plot = 0
    b_print_moments = 1
    if i eq 0 then begin
      str_title = 'RAVE [m/H] vs Chemical [M/H]'
      str_xtitle = '[m/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([m/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[m/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-mH'
      str_y = 'chem-MH'
      dblarr_x = dblarr_rave_mh
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 1 then begin
      str_title = 'RAVE T_eff vs Chemical T_eff'
      str_xtitle = 'T!Deff, chem!N [K]'
      str_ytitle = 'T!Deff, RAVE!N [K]'
      str_ytitle_b = '(T!Deff, chem!N - T!Deff, RAVE!N) [K]'
      str_hist_xtitle = 'T!Deff!N [K]'
      str_x = 'chem-Teff'
      str_y = 'RAVE-Teff'
      indarr_test = where(dblarr_chem_teff ne dblarr_rave_teff)
      if indarr_test(0) ge 0 then begin
        for iiii=0,n_elements(indarr_test)-1 do begin
          print,iiii,': dblarr_rave_teff(',indarr_test(iiii),' = ',dblarr_rave_teff(indarr_test(iiii)),', dblarr_chem_teff(',indarr_test(iiii),' = ',dblarr_chem_teff(indarr_test(iiii))
        endfor
;        stop
      endif
      dblarr_x = dblarr_chem_teff
      dblarr_y = dblarr_rave_teff
      dblarr_rave_stn_plot = dblarr_rave_stn
      dblarr_xrange=[3000.,7500.]
      dblarr_yrange=[3000.,7500.]
      dblarr_yrange_diff = [-500.,500.]
      ;dblarr_position = [0.175,0.178,0.93,0.98]
      str_xtickformat = '(F6.1)'
      b_print_moments = 0
      b_do_sigma_clipping = 0
    end else if i eq 2 then begin
      str_title = 'RAVE log g vs Chemical log g'
      str_xtitle = '(log g)!Dchem!N [dex]'
      str_ytitle = '(log g)!DRAVE!N [dex]'
      str_ytitle_b = '((log g)!Dchem!N - (log g)!DRAVE!N) [dex]'
      str_hist_xtitle = 'log g [dex]'
      str_x = 'chem-logg'
      str_y = 'RAVE-logg'
      dblarr_x = dblarr_chem_logg
      dblarr_y = dblarr_rave_logg
      dblarr_rave_stn_plot = dblarr_rave_stn
      dblarr_xrange=[0.,6.]
      dblarr_yrange=[0.,6.]
      dblarr_yrange_diff = [-1.5,1.5]
      str_xtickformat = '(F6.1)'
      b_print_moments = 0
      b_do_sigma_clipping = 0
    end else if i eq 3 then begin
      str_title = 'RAVE [M/H] (DR2 calibration) vs Chemical [M/H]'
      rave_calibrate_metallicities,dblarr_rave_mh,$
                                   dblarr_rave_afe,$
                                   ;DBLARR_TEFF=dblarr_rave_teff,$; --- new calibration
                                   DBLARR_LOGG=dblarr_rave_logg,$; --- old calibration
                                   OUTPUT=strarr_mh_calibrated,$;  --- string array
                                   REJECTVALUE=rejectvalue,$; --- double
                                   REJECTERR=rejecterr;       --- double
      dblarr_rave_mh_calibrated = double(strarr_mh_calibrated)
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-DR2'
      str_y = 'chem-MH'
      dblarr_x = dblarr_rave_mh_calibrated
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 4 then begin
      str_title = 'RAVE [M/H] (new calibration from Fulbright 2010) vs Chemical [M/H]'
      rave_calibrate_metallicities,dblarr_rave_mh,$
                                   dblarr_rave_afe,$
                                   DBLARR_TEFF=dblarr_rave_teff,$; --- new calibration
                                   ;DBLARR_LOGG=dblarr_rave_logg,$; --- old calibration
                                   OUTPUT=strarr_mh_calibrated,$;  --- string array
                                   REJECTVALUE=rejectvalue,$; --- double
                                   REJECTERR=rejecterr;       --- double
      dblarr_rave_mh_calibrated = double(strarr_mh_calibrated)
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-Fulbright'
      str_y = 'chem-MH'
      dblarr_x = dblarr_rave_mh_calibrated
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 5 then begin
      str_title = 'Chemical [M/H] vs Chemical [Fe/H]'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [M/H]!DChem!N [dex]'
      str_x = 'chem-FeH'
      str_y = 'chem-MH'
      dblarr_x = dblarr_chem_feh
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs = svdfit(dblarr_x,$
;                                 ;dblarr_x-
;                                 dblarr_y,$
;                                 3,$
;                                 measure_errors = dblarr_measure_errors,$
;                                 yfit=dblarr_yfit)
;      dblarr_yfit = dblarr_x - dblarr_yfit
      b_do_sigma_clipping = 1
    end else if i eq 6 then begin
      str_title = 'Chemical [M/H] vs Chemical [Fe/H] - dwarfs only'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [M/H]!DChem!N [dex]'
      str_x = 'chem-FeH-dwarfs'
      str_y = 'chem-MH-dwarfs'
      indarr = where(dblarr_chem_logg gt 3.5); and dblarr_chem_logg gt 3.5)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr)
      dblarr_x = dblarr_chem_feh(indarr)
      dblarr_y = dblarr_chem_mh(indarr)
      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
      indarr_lt_40 = where(dblarr_rave_stn(indarr) lt 40., COMPLEMENT=indarr_ge_40)
      dblarr_measure_errors(indarr_lt_40) = 0.25
      dblarr_measure_errors(indarr_ge_40) = 0.175
      dblarr_fit_coeffs_dwarfs = svdfit(dblarr_x,$
                                        ;dblarr_x-
                                        dblarr_y,$
                                        3,$
                                        measure_errors = dblarr_measure_errors,$
                                        yfit=dblarr_yfit)

      dblarr_yfit = dblarr(n_elements(dblarr_x))
      for j=0,n_elements(dblarr_fit_coeffs_dwarfs)-1 do begin
        dblarr_yfit = dblarr_yfit + $
                      dblarr_fit_coeffs_dwarfs(j) * dblarr_x^double(j)
      endfor
;      dblarr_yfit = dblarr_x - dblarr_yfit
      b_do_sigma_clipping = 1
    end else if i eq 7 then begin
      str_title = 'Chemical [M/H] vs Chemical [Fe/H] - giants only'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [M/H]!DChem!N [dex]'
      str_x = 'chem-FeH-giants'
      str_y = 'chem-MH-giants'
      indarr = where(dblarr_chem_logg le 3.5); and dblarr_chem_logg lt 3.5)
      dblarr_x = dblarr_chem_feh(indarr)
      dblarr_y = dblarr_chem_mh(indarr)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr)
      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
      indarr_lt_40 = where(dblarr_rave_stn(indarr) lt 40., COMPLEMENT=indarr_ge_40)
      dblarr_measure_errors(indarr_lt_40) = 0.25
      dblarr_measure_errors(indarr_ge_40) = 0.175
      indarr_metal_poor = where(dblarr_x lt -1.)
      dblarr_fit_coeffs_giants_metal_poor = svdfit(dblarr_x(indarr_metal_poor),$
                                                   ;dblarr_x(indarr_metal_poor)-
                                                   dblarr_y(indarr_metal_poor),$
                                                   3,$
                                                   measure_errors = dblarr_measure_errors(indarr_metal_poor),$
                                                   yfit=dblarr_yfit_metal_poor)

      dblarr_yfit = dblarr(n_elements(dblarr_x))
      dblarr_yfit(indarr_metal_poor) = dblarr_yfit_metal_poor;dblarr_x(indarr_metal_poor) -

      indarr_metal_rich = where(dblarr_x ge -1. and dblarr_x lt 0.1)
      dblarr_fit_coeffs_giants_metal_rich = svdfit(dblarr_x(indarr_metal_rich),$
                                                   ;dblarr_x(indarr_metal_rich)-
                                                   dblarr_y(indarr_metal_rich),$
                                                   3,$
                                                   measure_errors = dblarr_measure_errors(indarr_metal_rich),$
                                                   yfit=dblarr_yfit_metal_rich)
      dblarr_yfit(indarr_metal_rich) = dblarr_yfit_metal_rich;dblarr_x(indarr_metal_rich) -

      indarr_very_metal_rich = where(dblarr_x ge 0.1)
      dblarr_fit_coeffs_giants_very_metal_rich = svdfit(dblarr_x(indarr_very_metal_rich),$
                                                        ;dblarr_x(indarr_metal_rich)-
                                                        dblarr_y(indarr_very_metal_rich),$
                                                        3,$
                                                        measure_errors = dblarr_measure_errors(indarr_very_metal_rich),$
                                                        yfit=dblarr_yfit_very_metal_rich)
      dblarr_yfit(indarr_very_metal_rich) = dblarr_yfit_very_metal_rich;dblarr_x(indarr_metal_rich) -

      dblarr_vertical_lines_in_plot = [-1.,0.1]
      dblarr_vertical_lines_in_diff_plot = dblarr_vertical_lines_in_plot
;      dblarr_vertical_lines_in_hist_plot = dblarr_vertical_lines_in_plot

      ; --- clean up
      indarr_metal_poor = 0
      indarr_metal_rich = 0
      indarr_very_metal_rich = 0
      dblarr_yfit_metal_poor = 0
      dblarr_yfit_metal_rich = 0
      dblarr_yfit_very_metal_rich = 0
      dblarr_measure_errors = 0
      b_do_sigma_clipping = 1
    end else if i eq 8 then begin
      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit'
      besancon_calculate_mh,I_DBLARR_FEH                           = dblarr_chem_feh,$
                            O_DBLARR_MH                            = dblarr_chem_mh_calculated,$ ; --- dblarr
                            I_DBLARR_COEFFS_DWARFS                 = dblarr_fit_coeffs_dwarfs,$
                            I_DBLARR_COEFFS_GIANTS_METAL_POOR      = dblarr_fit_coeffs_giants_metal_poor,$
                            I_DBLARR_COEFFS_GIANTS_METAL_RICH      = dblarr_fit_coeffs_giants_metal_rich,$
                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = dblarr_fit_coeffs_giants_very_metal_rich,$
                            I_DBLARR_LOGG                          = dblarr_chem_logg
;stop
      str_xtitle = '[M/H]!DChem,calc!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H] [dex]'
      str_x = 'chem-MH-calc-new'
      str_y = 'chem-MH'
      dblarr_x = dblarr_chem_mh_calculated
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs = svdfit(dblarr_x,$
;                                 ;dblarr_x-
;                                 dblarr_y,$
;                                 3,$
;                                 measure_errors = dblarr_measure_errors,$
;                                 yfit=dblarr_yfit)
;;      dblarr_yfit = dblarr_x - dblarr_yfit
      b_do_sigma_clipping = 1
    end else if i eq 9 then begin
      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit giants only'
      str_xtitle = '[M/H]!DChem,calc!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H] [dex]'
      str_x = 'chem-MH-calc-new-giants'
      str_y = 'chem-MH-giants'
      indarr_giants = where(dblarr_chem_logg le 3.5, complement=indarr_dwarfs)
      dblarr_x = dblarr_chem_mh_calculated(indarr_giants)
      dblarr_y = dblarr_chem_mh(indarr_giants)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_giants)
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn(indarr_giants) lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs_giants_b = svdfit(dblarr_x,$
;                                          ;dblarr_x-
;                                          dblarr_y,$
;                                          3,$
;                                          measure_errors = dblarr_measure_errors,$
;                                          yfit=dblarr_yfit)
;;      dblarr_yfit = dblarr_x - dblarr_yfit
      besancon_calculate_mh,I_DBLARR_FEH                           = [-0.99999,-1.00001,0.099999,0.1000001],$
                            O_DBLARR_MH                            = dblarr_vertical_lines_in_plot,$ ; --- dblarr
                            I_DBLARR_COEFFS_DWARFS                 = dblarr_fit_coeffs_dwarfs,$
                            I_DBLARR_COEFFS_GIANTS_METAL_POOR      = dblarr_fit_coeffs_giants_metal_poor,$
                            I_DBLARR_COEFFS_GIANTS_METAL_RICH      = dblarr_fit_coeffs_giants_metal_rich,$
                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = dblarr_fit_coeffs_giants_very_metal_rich,$
                            I_DBLARR_LOGG                          = [1.,1.,1.,1.]

      dblarr_vertical_lines_in_diff_plot = dblarr_vertical_lines_in_plot
;      dblarr_vertical_lines_in_hist_plot = dblarr_vertical_lines_in_plot
      b_do_sigma_clipping = 1
    end else if i eq 10 then begin
      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit dwarfs only'
      str_xtitle = '[M/H]!DChem,calc!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H] [dex]'
      str_x = 'chem-MH-calc-new-dwarfs'
      str_y = 'chem-MH-dwarfs'
      dblarr_x = dblarr_chem_mh_calculated(indarr_dwarfs)
      dblarr_y = dblarr_chem_mh(indarr_dwarfs)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_dwarfs)
      b_do_sigma_clipping = 1
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn(indarr_dwarfs) lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs_dwarfs_b = svdfit(dblarr_x,$
;                                          ;dblarr_x-
;                                          dblarr_y,$
;                                          3,$
;                                          measure_errors = dblarr_measure_errors,$
;                                          yfit=dblarr_yfit)



;      dblarr_yfit = dblarr_x - dblarr_yfit

;    end else if i eq 11 then begin
;      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit2'
;      besancon_calculate_mh,I_DBLARR_FEH             = dblarr_chem_feh,$
;                            O_DBLARR_MH              = dblarr_chem_mh_calculated,$ ; --- dblarr
;                            I_DBLARR_COEFFS_DWARFS   = dblarr_fit_coeffs_dwarfs,$
;                            I_DBLARR_COEFFS_GIANTS   = dblarr_fit_coeffs_giants,$
;                            I_DBLARR_COEFFS_B_DWARFS = dblarr_fit_coeffs_dwarfs_b,$
;                            I_DBLARR_COEFFS_B_GIANTS = dblarr_fit_coeffs_giants_b,$
;                            I_DBLARR_LOGG            = dblarr_chem_logg
;      str_xtitle = '[M/H]!DChem,calc!N [dex]'
;      str_ytitle = '[M/H]!DChem!N [dex]'
;      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
;      str_hist_xtitle = '[M/H] [dex]'
;      str_x = 'chem-MH-calc-new-b'
;      str_y = 'chem-MH'
;      dblarr_x = dblarr_chem_mh_calculated
;      dblarr_y = dblarr_chem_mh
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs = svdfit(dblarr_x,dblarr_x-dblarr_y,3,measure_errors = dblarr_measure_errors, yfit=dblarr_yfit)
;      dblarr_yfit = dblarr_x - dblarr_yfit
;    end else if i eq 12 then begin
;      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit2 giants only'
;      str_xtitle = '[M/H]!DChem,calc!N [dex]'
;      str_ytitle = '[M/H]!DChem!N [dex]'
;      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
;      str_hist_xtitle = '[M/H] [dex]'
;      str_x = 'chem-MH-calc-new-giants-b'
;      str_y = 'chem-MH-giants'
;      indarr_giants = where(dblarr_chem_logg le 3.5, complement=indarr_dwarfs)
;      dblarr_x = dblarr_chem_mh_calculated(indarr_giants)
;      dblarr_y = dblarr_chem_mh(indarr_giants)
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn(indarr_giants) lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs = svdfit(dblarr_x,dblarr_x-dblarr_y,3,measure_errors = dblarr_measure_errors, yfit=dblarr_yfit)
;      dblarr_yfit = dblarr_x - dblarr_yfit
;    end else if i eq 13 then begin
;      str_title = 'Chemical [M/H] vs Chemical [M/H] from fit2 dwarfs only'
;      str_xtitle = '[M/H]!DChem,calc!N [dex]'
;      str_ytitle = '[M/H]!DChem!N [dex]'
;      str_ytitle_b = '([M/H]!DChem,calc!N - [M/H]!DChem!N) [dex]'
;      str_hist_xtitle = '[M/H] [dex]'
;      str_x = 'chem-MH-calc-new-dwarfs-b'
;      str_y = 'chem-MH-dwarfs'
;      dblarr_x = dblarr_chem_mh_calculated(indarr_dwarfs)
;      dblarr_y = dblarr_chem_mh(indarr_dwarfs)
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn(indarr_dwarfs) lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs_dwarfs_b = svdfit(dblarr_x,dblarr_x-dblarr_y,3,measure_errors = dblarr_measure_errors, yfit=dblarr_yfit)
;      dblarr_yfit = dblarr_x - dblarr_yfit
    end else if i eq 11 then begin
      str_title = 'RAVE [m/H] vs Chemical [Fe/H]'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[m/H]!DRAVE!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N-[m/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [m/H]!DRAVE!N [dex]'
      str_x = 'chem-FeH'
      str_y = 'rave-mH'
      dblarr_x = dblarr_chem_feh
      dblarr_y = dblarr_rave_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 12 then begin
      str_title = 'RAVE [m/H] vs Chemical [Fe/H], giants only'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[m/H]!DRAVE!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N-[m/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [m/H]!DRAVE!N [dex]'
      str_x = 'chem-FeH-giants'
      str_y = 'rave-mH-giants'
      dblarr_x = dblarr_chem_feh(indarr_giants)
      dblarr_y = dblarr_rave_mh(indarr_giants)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_giants)
      b_do_sigma_clipping = 1
    end else if i eq 13 then begin
      str_title = 'RAVE [m/H] vs Chemical [Fe/H], dwarfs only'
      str_xtitle = '[Fe/H]!DChem!N [dex]'
      str_ytitle = '[m/H]!DRAVE!N [dex]'
      str_ytitle_b = '([Fe/H]!DChem!N-[m/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[Fe/H]!DChem!N and [m/H]!DRAVE!N [dex]'
      str_x = 'chem-FeH-dwarfs'
      str_y = 'rave-mH-dwarfs'
      dblarr_x = dblarr_chem_feh(indarr_dwarfs)
      dblarr_y = dblarr_rave_mh(indarr_dwarfs)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_dwarfs)
      b_do_sigma_clipping = 1
    end else if i eq 14 then begin
      str_title = 'Chemical [M/H] vs Chemical [M/H] calculated from [Fe/H] (Zwitter trafo)'
      besancon_calculate_mh,I_DBLARR_FEH=dblarr_chem_feh,$
                            O_DBLARR_MH=dblarr_chem_mh_calculated ; --- dblarr
      indarr_rej = where(abs(dblarr_chem_feh) lt 3. and abs(dblarr_rave_mh) lt 3.)
      dblarr_chem_mh = dblarr_chem_mh(indarr_rej)
      dblarr_chem_mh_calculated = dblarr_chem_mh_calculated(indarr_rej)
      dblarr_chem_feh = dblarr_chem_feh(indarr_rej)
      dblarr_chem_teff = dblarr_chem_teff(indarr_rej)
      dblarr_chem_logg= dblarr_chem_logg(indarr_rej)
      dblarr_chem_afe = dblarr_chem_afe(indarr_rej)
      dblarr_rave_mh = dblarr_rave_mh(indarr_rej)
      dblarr_rave_teff = dblarr_rave_teff(indarr_rej)
      dblarr_rave_logg = dblarr_rave_logg(indarr_rej)
      dblarr_rave_afe = dblarr_rave_afe(indarr_rej)
      dblarr_rave_stn = dblarr_rave_stn(indarr_rej)
      indarr_rej = 0
      str_xtitle = '[M/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem,[Fe/H]!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N-[M/H]!DChem,[Fe/H]!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem!N and [M/H]!DChem,[Fe/H]!N [dex]'
      str_x = 'chem-MH'
      str_y = 'chem-MH-from-FeH'
      dblarr_x = dblarr_chem_mh
      dblarr_y = dblarr_chem_mh_calculated
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 15 then begin
      str_title = 'giants: Chemical [M/H] vs Chemical [M/H] calculated from [Fe/H] (Zwitter trafo)'
;      besancon_calculate_mh,I_DBLARR_FEH=dblarr_chem_feh,$
;                            O_DBLARR_MH=dblarr_chem_mh_calculated ; --- dblarr
;      indarr_rej = where(abs(dblarr_x) lt 3. and abs(dblarr_y) lt 3.)
;      dblarr_chem_mh = dblarr_chem_mh(indarr_rej)
;      dblarr_chem_mh_calculated = dblarr_chem_mh_calculated(indarr_rej)
;      dblarr_chem_feh = dblarr_chem_feh(indarr_rej)
;      dblarr_chem_teff = dblarr_chem_teff(indarr_rej)
;      dblarr_chem_logg= dblarr_chem_logg(indarr_rej)
;      dblarr_chem_afe = dblarr_chem_afe(indarr_rej)
;      dblarr_rave_mh = dblarr_rave_mh(indarr_rej)
;      dblarr_rave_teff = dblarr_rave_teff(indarr_rej)
;      dblarr_rave_logg = dblarr_rave_logg(indarr_rej)
;      dblarr_rave_afe = dblarr_rave_afe(indarr_rej)
;      dblarr_rave_stn = dblarr_rave_stn(indarr_rej)
;      indarr_rej = 0
      str_xtitle = '[M/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem,[Fe/H]!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N-[M/H]!DChem,[Fe/H]!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem!N and [M/H]!DChem,[Fe/H]!N [dex]'
      str_x = 'chem-MH-giants'
      str_y = 'chem-MH-from-FeH-giants'
      indarr_giants = where(dblarr_rave_logg lt 3.5)
      dblarr_x = dblarr_chem_mh(indarr_giants)
      dblarr_y = dblarr_chem_mh_calculated(indarr_giants)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_giants)
      b_do_sigma_clipping = 1
    end else if i eq 16 then begin
      str_title = 'dwarfs: Chemical [M/H] vs Chemical [M/H] calculated from [Fe/H] (Zwitter trafo)'
;      besancon_calculate_mh,I_DBLARR_FEH=dblarr_chem_feh,$
;                            O_DBLARR_MH=dblarr_chem_mh_calculated ; --- dblarr
;      indarr_rej = where(abs(dblarr_x) lt 3. and abs(dblarr_y) lt 3.)
;      dblarr_chem_mh = dblarr_chem_mh(indarr_rej)
;      dblarr_chem_mh_calculated = dblarr_chem_mh_calculated(indarr_rej)
;      dblarr_chem_feh = dblarr_chem_feh(indarr_rej)
;      dblarr_chem_teff = dblarr_chem_teff(indarr_rej)
;      dblarr_chem_logg= dblarr_chem_logg(indarr_rej)
;      dblarr_chem_afe = dblarr_chem_afe(indarr_rej)
;      dblarr_rave_mh = dblarr_rave_mh(indarr_rej)
;      dblarr_rave_teff = dblarr_rave_teff(indarr_rej)
;      dblarr_rave_logg = dblarr_rave_logg(indarr_rej)
;      dblarr_rave_afe = dblarr_rave_afe(indarr_rej)
;      dblarr_rave_stn = dblarr_rave_stn(indarr_rej)
;      indarr_rej = 0
      str_xtitle = '[M/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DChem,[Fe/H]!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N-[M/H]!DChem,[Fe/H]!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem!N and [M/H]!DChem,[Fe/H]!N [dex]'
      str_x = 'chem-MH-dwarfs'
      str_y = 'chem-MH-from-FeH-dwarfs'
      indarr_dwarfs = where(dblarr_rave_logg ge 3.5)
      dblarr_x = dblarr_chem_mh(indarr_dwarfs)
      dblarr_y = dblarr_chem_mh_calculated(indarr_dwarfs)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_dwarfs)
      b_do_sigma_clipping = 1
;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;      indarr = where(dblarr_rave_stn lt 40., COMPLEMENT=indarr_40)
;      dblarr_measure_errors(indarr) = 0.25
;      dblarr_measure_errors(indarr_40) = 0.175
;      dblarr_fit_coeffs = svdfit(dblarr_x,dblarr_y,4,measure_errors = dblarr_measure_errors, yfit=dblarr_yfit)
;    end else if i eq 13 then begin
;      str_title = 'Chemical [M/H] vs Chemical [M/H] calculated from [Fe/H] my way'
;      besancon_calculate_mh,I_DBLARR_FEH = dblarr_chem_feh,$
;                            O_DBLARR_MH = dblarr_chem_mh_calculated,$ ; --- dblarr
;                            I_B_MINE = 1
;      indarr_rej = where(abs(dblarr_x) lt 3. and abs(dblarr_y) lt 3.)
;      dblarr_chem_mh = dblarr_chem_mh(indarr_rej)
;      dblarr_chem_mh_calculated = dblarr_chem_mh_calculated(indarr_rej)
;      dblarr_chem_feh = dblarr_chem_feh(indarr_rej)
;      dblarr_chem_teff = dblarr_chem_teff(indarr_rej)
;      dblarr_chem_logg= dblarr_chem_logg(indarr_rej)
;      dblarr_chem_afe = dblarr_chem_afe(indarr_rej)
;      dblarr_rave_mh = dblarr_rave_mh(indarr_rej)
;      dblarr_rave_teff = dblarr_rave_teff(indarr_rej)
;      dblarr_rave_logg = dblarr_rave_logg(indarr_rej)
;      dblarr_rave_afe = dblarr_rave_afe(indarr_rej)
;      dblarr_rave_stn = dblarr_rave_stn(indarr_rej)
;      indarr_rej = 0
;      str_xtitle = '[M/H]!DChem!N [dex]'
;      str_ytitle = '[M/H]!DChem,[Fe/H]!N [dex]'
;      str_ytitle_b = '([M/H]!DChem!N-[M/H]!DChem,[Fe/H]!N) [dex]'
;      str_hist_xtitle = '[M/H]!DChem!N and [M/H]!DChem,[Fe/H]!N [dex]'
;      str_x = 'chem-MH'
;      str_y = 'chem-MH-from-FeH'
;      dblarr_x = dblarr_chem_mh
;      dblarr_y = dblarr_chem_mh_calculated
;;      dblarr_measure_errors = dblarr(n_elements(dblarr_y))
;;      indarr = where(dblarr_rave_stn lt 40., COMPLEMENT=indarr_40)
;;      dblarr_measure_errors(indarr) = 0.25
;;      dblarr_measure_errors(indarr_40) = 0.175
;;      dblarr_fit_coeffs = svdfit(dblarr_x,dblarr_y,4,measure_errors = dblarr_measure_errors, yfit=dblarr_yfit)
    end else if i eq 17 then begin
      str_title = 'RAVE [M/H] (DR3 calibration, STN >= 13) vs Chemical [M/H]'
      indarr = where(dblarr_rave_stn ge 13.)
      dblarr_chem_feh = dblarr_chem_feh(indarr)
      dblarr_chem_mh = dblarr_chem_mh(indarr)
      dblarr_chem_teff = dblarr_chem_teff(indarr)
      dblarr_chem_logg= dblarr_chem_logg(indarr)
      dblarr_chem_afe = dblarr_chem_afe(indarr)
      dblarr_rave_mh = dblarr_rave_mh(indarr)
      dblarr_rave_teff = dblarr_rave_teff(indarr)
      dblarr_rave_logg = dblarr_rave_logg(indarr)
      dblarr_rave_afe = dblarr_rave_afe(indarr)
      dblarr_rave_stn = dblarr_rave_stn(indarr)
      rave_calibrate_metallicities,dblarr_rave_mh,$
                                   dblarr_rave_afe,$
                                   DBLARR_TEFF=dblarr_rave_teff,$; --- new calibration
                                   DBLARR_LOGG=dblarr_rave_logg,$; --- old calibration
                                   DBLARR_STN = dblarr_rave_stn,$; --- dr3 calibration
                                   OUTPUT=strarr_mh_calibrated,$;  --- string array
                                   REJECTVALUE=rejectvalue,$; --- double
                                   REJECTERR=rejecterr;       --- double
      dblarr_rave_mh_calibrated = double(strarr_mh_calibrated)
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-DR3-STNge13'
      str_y = 'chem-MH'
      dblarr_x = dblarr_rave_mh_calibrated
      dblarr_y = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 18 then begin
      str_title = 'dwarfs: RAVE [M/H] (DR3 calibration, STN >= 13) vs Chemical [M/H]'
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-DR3-STNge13-dwarfs'
      str_y = 'chem-MH-dwarfs'
      indarr_dwarfs = where(dblarr_rave_logg ge 3.5)
      dblarr_x = dblarr_rave_mh_calibrated(indarr_dwarfs)
      dblarr_y = dblarr_chem_mh(indarr_dwarfs)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_dwarfs)
      b_do_sigma_clipping = 1
    end else if i eq 19 then begin
      str_title = 'giants: RAVE [M/H] (DR3 calibration, STN >= 13) vs Chemical [M/H]'
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-DR3-STNge13-giants'
      str_y = 'chem-MH-giants'
      indarr_giants = where(dblarr_rave_logg lt 3.5)
      dblarr_x = dblarr_rave_mh_calibrated(indarr_giants)
      dblarr_y = dblarr_chem_mh(indarr_giants)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_giants)
      b_do_sigma_clipping = 1
    end else if i eq 20 then begin
      str_title = 'RAVE [M/H] (DR3 calibration, separate for dwarfs and giants, STN >= 13) vs Chemical [M/H]'
      rave_calibrate_metallicities,dblarr_rave_mh,$
                                   dblarr_rave_afe,$
                                   DBLARR_TEFF=dblarr_rave_teff,$; --- new calibration
                                   DBLARR_LOGG=dblarr_rave_logg,$; --- old calibration
                                   DBLARR_STN = dblarr_rave_stn,$; --- dr3 calibration
                                   OUTPUT=strarr_mh_calibrated,$;  --- string array
                                   REJECTVALUE=rejectvalue,$; --- double
                                   REJECTERR=rejecterr,$;       --- double
                                   SEPARATE=1
      dblarr_rave_mh_calibrated = double(strarr_mh_calibrated)
      str_xtitle = '[M/H]!DChem!N [dex]'
      str_ytitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N - [M/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem!N and [M/H]!DRAVE!N [dex]'
      str_x = 'chem-MH'
      str_y = 'RAVE-MH-DR3sep-STNge13'
      dblarr_y = dblarr_rave_mh_calibrated
      dblarr_x = dblarr_chem_mh
      dblarr_rave_stn_plot = dblarr_rave_stn
      b_do_sigma_clipping = 1
    end else if i eq 21 then begin
      str_title = 'giants only: RAVE [M/H] (DR3 calibration, separate for dwarfs and giants, STN >= 13) vs. Chemical [M/H]'
      str_xtitle = '[M/H]!DChem, giants!N [dex]'
      str_ytitle = '[M/H]!DRAVE, giants!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N - [M/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem, giants!N and [M/H]!DRAVE, giants!N [dex]'
      str_x = 'chem-MH-giants'
      str_y = 'RAVE-MH-DR3sep-STNge13-giants'
      indarr_logg_lt_3_5 = where(dblarr_rave_logg lt 3.5,COMPLEMENT=indarr_logg_ge_3_5)
      dblarr_x = dblarr_chem_mh(indarr_logg_lt_3_5)
      dblarr_y = dblarr_rave_mh_calibrated(indarr_logg_lt_3_5)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_logg_lt_3_5)
      b_do_sigma_clipping = 1
    end else if i eq 22 then begin
      str_title = 'dwarfs only: RAVE [M/H] (DR3 calibration, separate for dwarfs and giants, STN >= 13) vs. Chemical [M/H]'
      str_xtitle = '[M/H]!DChem, dwarfs!N [dex]'
      str_ytitle = '[M/H]!DRAVE, dwarfs!N [dex]'
      str_ytitle_b = '([M/H]!DChem!N - [M/H]!DRAVE!N) [dex]'
      str_hist_xtitle = '[M/H]!DChem, dwarfs!N and [M/H]!DRAVE, dwarfs!N [dex]'
      str_x = 'chem-MH-dwarfs'
      str_y = 'RAVE-MH-DR3sep-STNge13-dwarfs'
      dblarr_x = dblarr_chem_mh(indarr_logg_ge_3_5)
      dblarr_y = dblarr_rave_mh_calibrated(indarr_logg_ge_3_5)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_logg_ge_3_5)
      b_do_sigma_clipping = 1
    end else if i eq 23 then begin
      indarr_giants = where(dblarr_rave_logg lt 3.5)
      besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_rave_mh(indarr_giants),$
                            O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                            I_B_MINE                          = 1,$
                            ;I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
;                          I_DBLARR_COEFFS_B_DWARFS = i_dblarr_coeffs_b_dwarfs,$
;                          I_DBLARR_COEFFS_B_GIANTS = i_dblarr_coeffs_b_giants,$
                            I_DBLARR_LOGG                     = dblarr_rave_logg

      str_title = 'giants: Chemical [M/H] vs. RAVE [M/H] (FeH->M/H, STN >= 13)'
      str_xtitle = '[M/H]!DRAVE!N [dex]'
      str_ytitle = '[M/H]!DChem!N [dex]'
      str_ytitle_b = '([M/H]!DRAVE!N - [M/H]!DChem!N) [dex]'
      str_hist_xtitle = '[M/H]!DRAVE!N and [M/H]!DChem!N [dex]'
      str_x = 'RAVE-MH-from-FeH'
      str_y = 'chem-MH'
;      dblarr_rave_mh_calibrated(indarr_giants) = o_dblarr_mh
      dblarr_x = o_dblarr_mh
      dblarr_y = dblarr_chem_mh(indarr_giants)
      dblarr_rave_stn_plot = dblarr_rave_stn(indarr_giants)
      b_do_sigma_clipping = 1
    end

    str_plotname_root = strmid(str_plot,0,strpos(str_plot,'.',/REVERSE_SEARCH))+'_'+str_y+'_vs_'+str_x

    dblarr_err_x = dblarr(n_elements(dblarr_x))
    dblarr_err_y = dblarr(n_elements(dblarr_x))

    compare_two_parameters,dblarr_x,$
                           dblarr_y,$
                           str_plotname_root,$
                           DBLARR_ERR_X             = dblarr_err_x,$
                           DBLARR_ERR_Y             = dblarr_err_y,$
                           DBLARR_RAVE_SNR          = dblarr_rave_stn_plot,$
                           STR_XTITLE               = str_xtitle,$
                           STR_YTITLE               = str_ytitle,$
;                           STR_TITLE                = 0,$
                           I_PSYM                   = 2,$
                           DBL_SYMSIZE              = 0.2,$
                           DBL_CHARSIZE             = 1.8,$
                           DBL_CHARTHICK            = 3.,$
                           DBL_THICK                = 3.,$
                           DBLARR_XRANGE            = dblarr_xrange,$
                           DBLARR_YRANGE            = dblarr_yrange,$
                           DBLARR_POSITION          = dblarr_position,$;dblarr_position,$
                           DIFF_DBLARR_YRANGE       = dblarr_yrange_diff,$
                           DIFF_DBLARR_POSITION     = dblarr_position,$;diff_dblarr_position,$
                           DIFF_STR_YTITLE          = str_ytitle_b,$
;                           I_XTICKS                 = 7,$
                           STR_XTICKFORMAT          = str_xtickformat,$
;                           I_YTICKS                 = 0,$
                           DBL_REJECTVALUEX         = 99.9,$;             --- double
                           DBL_REJECTVALUEY         = -9.,$;             --- double
;                           STR_YTICKFORMAT          = 0,$
                           B_PRINTPDF               = 1,$;               --- bool (0/1)
;                           SIGMA_I_NBINS            = i_nbins_sigma,$
;                           SIGMA_I_MINELEMENTS      = 4,$
                           HIST_I_NBINSMIN          = 25,$;            --- int
                           HIST_I_NBINSMAX          = 30,$;            --- int
                           HIST_STR_XTITLE          = str_hist_xtitle,$;             --- bool (0/1)
;                           HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
;                           HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                           HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
;                           HIST_B_POP_ID            = 0,$;             --- bool
;                           HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                           HIST_DBLARR_POSITION     = dblarr_position,$;   --- dblarr
;                           HIST_B_RESIDUAL          = 0;            --- double
                           O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                           DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                           DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines_in_diff_plot,$
                           DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                           I_DBLARR_YFIT            = dblarr_yfit,$
                           B_PRINT_MOMENTS          = b_print_moments,$
                           B_DO_SIGMA_CLIPPING      = 0; b_do_sigma_clipping

    reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
    reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'
    reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
    spawn,'cp -p '+str_plotname_root+'_small.pdf /home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch4/figs/metallicities/'
    spawn,'cp -p '+str_plotname_root+'_diff_small.pdf /home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch4/figs/metallicities/'
    spawn,'cp -p '+o_str_plotname_hist+'_small.pdf /home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch4/figs/metallicities/'

    str_giffile = str_plotname_root+'.gif'
    printf,lun,'<hr><br><h3>'+str_title+'</h3><a href="'+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'"></a><br>'
    o_str_plotname_hist = strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)
    o_str_plotname_hist = o_str_plotname_hist+'.gif'
    printf,lun,'<a href="'+o_str_plotname_hist+'"><img src="'+o_str_plotname_hist+'"></a><br>'

    str_giffile = str_plotname_root+'_diff.gif'
    printf,lun,'<br><h3>'+str_xtitle+' vs. '+str_ytitle+' - '+str_xtitle+'</h3><a href="'+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'"></a><br>'

    ;stop
  endfor

  printf,lun,'</center></body></html>'
  free_lun,lun
  print,'dblarr_fit_coeffs_dwarfs = ',dblarr_fit_coeffs_dwarfs
  print,'dblarr_fit_coeffs_giants_metal_poor = ',dblarr_fit_coeffs_giants_metal_poor
  print,'dblarr_fit_coeffs_giants_metal_rich = ',dblarr_fit_coeffs_giants_metal_rich
  print,'dblarr_fit_coeffs_giants_very_metal_rich = ',dblarr_fit_coeffs_giants_very_metal_rich
end
