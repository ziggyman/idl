pro rave_abundances_plot_teff_logg
  str_filename = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_frac_gt_70.dat';RAVE_abd_imag_frac_gt_70.dat'

  i_col_teff_r = 19
  i_col_logg_r = 20
  i_col_teff_c = 70
  i_col_logg_c = 71

  strarr_data = readfiletostrarr(str_filename, ' ', I_NDATALINES=i_ndatalines)

  dblarr_teff_r = double(strarr_data(*,i_col_teff_r))
  dblarr_logg_r = double(strarr_data(*,i_col_logg_r))
  dblarr_teff_c = double(strarr_data(*,i_col_teff_c))
  dblarr_logg_c = double(strarr_data(*,i_col_logg_c))

  indarr = where(dblarr_teff_r ne dblarr_teff_c)
  print,'indarr = ',indarr
  if indarr(0) ge 0 then begin
    for i=0ul, n_elements(indarr)-1 do begin
      print,i,': dblarr_teff_r(',indarr(i),') = ',dblarr_teff_r(indarr(i)),', dblarr_teff_c(',indarr(i),') = ',dblarr_teff_c(indarr(i))
    endfor
  endif

  set_plot,'ps'
  device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_logg.ps'
  plot,dblarr_logg_r,dblarr_logg_c,xtitle='log g RAVE',ytitle='log g Chem',psym=2,symsize=0.4,xrange=[0.,5.],yrange=[0.,5.],xstyle=1,ystyle=1
  device,/close

  device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_teff.ps'
  plot,dblarr_teff_r,dblarr_teff_c,xtitle='Teff RAVE',ytitle='Teff Chem',psym=2,symsize=0.4,xrange=[3500.,8000.],yrange=[3500.,8000.],xstyle=1,ystyle=1
  device,/close
  set_plot,'x'

  dblarr_teff_r = 0
  dblarr_logg_r = 0
  dblarr_teff_c = 0
  dblarr_logg_c = 0
  strarr_data = 0
end
