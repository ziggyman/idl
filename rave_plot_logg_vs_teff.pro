pro rave_plot_logg_vs_teff
  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good_no-doubles-maxsnr.dat'
  str_plotname = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch1/figs/logg_vs_Teff_300-305_-10--5.ps'

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_lon = double(strarr_data(*,5))
  dblarr_lat = double(strarr_data(*,6))
  dblarr_teff = double(strarr_data(*,19))
  dblarr_logg = double(strarr_data(*,20))

  indarr = where((dblarr_lon gt 300) and (dblarr_lat le 305) and (dblarr_lat gt -10.) and (dblarr_lat le -5.))

  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)

  set_plot,'ps'
  device,filename=str_plotname
    plot,dblarr_teff,$
         dblarr_logg,$
         xtitle = 'Effective temperature [K]',$
         ytitle = 'Surface gravity [dex]',$
         psym=2,$
         thick = 3.,$
         charthick = 3.,$
         charsize = 1.8,$
         position = [0.205,0.175,0.932,0.925],$
         xrange=[3200.,7000.],$
         xstyle = 1
  device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname
end
