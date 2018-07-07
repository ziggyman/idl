pro rave_check_metallicities
  str_filename_in = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_frac_gt_70.dat';_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ')

  i_col_rave_mh = 21
  i_col_rave_logg = 20
  i_col_rave_teff = 19
  i_col_rave_afe = 22
  i_col_rave_snr = 33
  i_col_rave_s2n = 34
  i_col_rave_stn = 35

  i_col_chem_feh = 68

  dblarr_mh = double(strarr_data(*,i_col_rave_mh))
  dblarr_logg = double(strarr_data(*,i_col_rave_logg))
  dblarr_teff = double(strarr_data(*,i_col_rave_teff))
  dblarr_afe = double(strarr_data(*,i_col_rave_afe))
  dblarr_stn = double(strarr_data(*,i_col_rave_stn))
  dblarr_s2n = double(strarr_data(*,i_col_rave_s2n))
  dblarr_feh = double(strarr_data(*,i_col_chem_feh))

  indarr = where(dblarr_stn lt 1.)
  if indarr(0) ge 0 then $
    dblarr_stn(indarr) = dblarr_s2n(indarr)

  rave_calibrate_metallicities,dblarr_mh,$
                               dblarr_afe,$
                               DBLARR_TEFF=dblarr_teff,$; --- new calibration
                               DBLARR_LOGG=dblarr_logg,$; --- old calibration
                               DBLARR_STN = dblarr_stn,$; --- calibration from DR3 paper
                               OUTPUT=strarr_output,$;           --- string array
                               REJECTVALUE=99.,$; --- double
                               REJECTERR=10.,$;       --- double
                               SEPARATE=1
  plot_histogram,double(strarr_output),$
                 strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_MH-DR3-calib-sep',$
                 XTITLE='Metallicity [dex]',$
                 YTITLE='Percentage of stars',$
                 NBINS=30,$
;                 TITLE=0,$
                 XRANGE=[-3.,1.],$
                 YRANGE=0,$
;                 OVERPLOT=overplot,$
;                 MORETOCOME=moretocome,$
;                 NORMALISE=normalise,$
                 I_B_PLOT_GAUSSFIT = 1

  besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh,$
                        O_DBLARR_MH                       = o_dblarr_mh ; --- dblarr
;                        I_B_MINE                          = 0,$
;                        I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
;                        I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
;                        I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
;                        I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
;                          I_DBLARR_COEFFS_B_DWARFS = i_dblarr_coeffs_b_dwarfs,$
;                          I_DBLARR_COEFFS_B_GIANTS = i_dblarr_coeffs_b_giants,$
;                        I_DBLARR_LOGG                     = i_dblarr_logg

  plot_histogram,o_dblarr_mh,$
                 strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_MH-from-FeH',$
                 XTITLE='Metallicity [dex]',$
                 YTITLE='Percentage of stars',$
                 NBINS=30,$
;                 TITLE=0,$
                 XRANGE=[-3.,1.],$
                 YRANGE=0,$
;                 OVERPLOT=overplot,$
;                 MORETOCOME=moretocome,$
;                 NORMALISE=normalise,$
                 I_B_PLOT_GAUSSFIT = 1

  besancon_calculate_mh,I_DBLARR_FEH                      = dblarr_feh,$
                        O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                        I_B_MINE                          = 1,$
;                        I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
;                        I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
;                        I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
;                        I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
;                          I_DBLARR_COEFFS_B_DWARFS = i_dblarr_coeffs_b_dwarfs,$
;                          I_DBLARR_COEFFS_B_GIANTS = i_dblarr_coeffs_b_giants,$
                        I_DBLARR_LOGG                     = dblarr_logg

  plot_histogram,o_dblarr_mh,$
                 strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_MH-from-FeH-mine',$
                 XTITLE='Metallicity [dex]',$
                 YTITLE='Percentage of stars',$
                 NBINS=30,$
;                 TITLE=0,$
                 XRANGE=[-3.,1.],$
                 YRANGE=0,$
;                 OVERPLOT=overplot,$
;                 MORETOCOME=moretocome,$
;                 NORMALISE=normalise,$
                 I_B_PLOT_GAUSSFIT = 1

end
