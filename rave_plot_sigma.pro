pro rave_plot_sigma
  str_datafile = '/home/azuri/daten/rave/rave_data/sigma_teff_test.rez'

  i_nlines = countdatlines(str_datafile)

  dblarr_data = readfiletodblarr(str_datafile)

;  print,'rave_plot_sigma: dblarr_data(*,0) = ',dblarr_data(*,0)

  print,'rave_plot_sigma: dblarr_data(0:32,2) = ',dblarr_data(0:32,2)

  indarr = where(dblarr_data(*,0) eq 1 and dblarr_data(*,1) eq 0.)
  set_plot,'ps'
  device,filename=strmid(str_datafile,0,strpos(str_datafile,'.'))+'.ps'
  plot,10.^dblarr_data(indarr,2),$
       dblarr_data(indarr,3),$
       /XLOG,$
       xrange=[3000.,40000.],$
       xstyle=1,$
       yrange=[0.,0.3],$
       ystyle=1,$
       thick=3
  for i=0,2 do begin
    for j=0,2 do begin
      if i eq 0 then dbl_logg = 1.
      if i eq 1 then dbl_logg = 3.
      if i eq 2 then dbl_logg = 4.5
      if j eq 0 then dbl_mh = 0.
      if j eq 1 then dbl_mh = -0.5
      if j eq 2 then dbl_mh = -1.
      indarr = where(dblarr_data(*,0) eq dbl_logg and dblarr_data(*,1) eq dbl_mh)
      if indarr(0) ne -1 then begin
        oplot,10.^dblarr_data(indarr,2),dblarr_data(indarr,3)
      endif
    endfor
  endfor
  device,/close

;  dblarr_x = lindgen(184) * 100. + 3700.
;  dblarr_coeffs = svdfit(dblarr_data(*,0),dblarr_data(*,1),/LEGENDRE,YFIT=dblarr_fit)

;  oplot,dblarr_data(*,0),dblarr_fit
end
