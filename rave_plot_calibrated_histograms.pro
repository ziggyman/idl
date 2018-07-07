pro rave_plot_calibrated_histograms
  str_filename = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged_samplex1_logg_0_errdivby_1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_logg = double(strarr_data(*,20))

  plot_histogram,dblarr_logg,$
                 strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_hist-logg',$
                   XTITLE='log(g)',$
                   YTITLE='Percentage of stars',$
                   NBINS=50,$
                   ;TITLE=title,$
                   XRANGE=[0.,5.5];,$
                   ;YRANGE=yrange,$
                   ;OVERPLOT=overplot,$
                   ;MORETOCOME=moretocome,$
                   ;NORMALISE=normalise,$
                   ;I_B_PLOT_GAUSSFIT = i_b_plot_gaussfit

end
