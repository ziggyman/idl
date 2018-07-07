pro rave_plot_dist_errors
  str_ravefile = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr.dat'
;  str_ravefile = '/home/azuri/daten/rave/rave_data/distances/rave_DR2.v1g2.TJK.uniform.final.post_Imag.dat'

  icol_dist = 22
  icol_dist_err = 23
  icol_teff = 18
  icol_logg = 19
;  icol_dist = 28
;  icol_dist_err = 29
;  icol_teff = 11
;  icol_logg = 13

  strarr_ravedata = readfiletostrarr(str_ravefile,' ')

  dblarr_dist = double(strarr_ravedata(*,icol_dist))
  dblarr_dist_err = double(strarr_ravedata(*,icol_dist_err))
  dblarr_teff = double(strarr_ravedata(*,icol_teff))
  dblarr_logg = double(strarr_ravedata(*,icol_logg))

  dblarr_percent = dblarr_dist_err / dblarr_dist * 100.

  str_plotfile_root = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))
  set_plot,'ps'
  device,filename=str_plotfile_root+'_logg_err.ps'
  plot,dblarr_logg,dblarr_percent,xtitle='log g [dex]',ytitle='100*dr/r',psym=2,symsize=0.1,yrange=[0.,100.],ystyle=1
  set_plot,'x'
  spawn,'ps2gif '+str_plotfile_root+'_logg_err.ps '+str_plotfile_root+'_logg_err.gif'

  set_plot,'ps'
  device,filename=str_plotfile_root+'_teff_err.ps'
  plot,dblarr_teff,dblarr_percent,xtitle='T_eff [K]',ytitle='100*dr/r',psym=2,symsize=0.1,xrange=[3000.,8000.],xstyle=1,yrange=[0.,100.],ystyle=1
  set_plot,'x'
  spawn,'ps2gif '+str_plotfile_root+'_teff_err.ps '+str_plotfile_root+'_teff_err.gif'

  dblarr_fit_logg = [0.1,0.25,0.5,0.75,1.,1.25,1.5,1.75,2.,2.25,2.5,2.75,3.,3.25,3.5,3.75,4.,4.25,4.5]
  dblarr_fit_percent = [13.,18.,21.,25.,$
                        34.,43.,55.,57.,$
                        54.,56.,57.,63.,$
                        56.,48.,47.,51.,$
                        47.,40.,28.]

  dblarr_fit_coeffs = poly_fit(dblarr_fit_logg,dblarr_fit_percent,7)
  print,'rave_plot_dist_errors: dblarr_fit_coeffs = ',dblarr_fit_coeffs

  dblarr_fit_logg = [1.,1.25,1.5,1.75,2.,2.25,2.5]
  dblarr_fit_percent = [35.,36.,35.,32.,$
                        36.,55.,57.]
  dblarr_fit_coeffs_b = poly_fit(dblarr_fit_logg,dblarr_fit_percent,4)
  print,'rave_plot_dist_errors: dblarr_fit_coeffs_b = ',dblarr_fit_coeffs_b

  set_plot,'ps'
  device,filename=str_plotfile_root+'_logg_err_fit.ps'
  plot,dblarr_logg,dblarr_percent,xtitle='logg [dex]',ytitle='100*dr/r',psym=2,symsize=0.1,yrange=[0.,100.],ystyle=1;,xrange=[3.,4.5],xstyle=1
  dblarr_fit_x = dblarr(1000)
  dblarr_fit_x_b = dblarr(1000)
  for i=0ul,999 do begin
    dblarr_fit_x(i) = double(i) / 1000. * 4.5
    dblarr_fit_x_b(i) = 1. + double(i) / 1000. * 1.5
  endfor
  calc_values_from_polyfit_coeffs,DBLARR_DATA=dblarr_fit_x,$
                                  DBLARR_COEFFS=dblarr_fit_coeffs,$
                                  DBLARR_OUT = dblarr_percent_fit
  calc_values_from_polyfit_coeffs,DBLARR_DATA=dblarr_fit_x_b,$
                                  DBLARR_COEFFS=dblarr_fit_coeffs_b,$
                                  DBLARR_OUT = dblarr_percent_fit_b
  oplot,dblarr_fit_x,dblarr_percent_fit,psym=2,symsize=0.5
  oplot,dblarr_fit_x_b,dblarr_percent_fit_b,psym=2,symsize=0.5
  set_plot,'x'
  spawn,'ps2gif '+str_plotfile_root+'_logg_err_fit.ps '+str_plotfile_root+'_logg_err_fit.gif'

end
