pro rave_thesis_plot_spectra_teff
  str_list_spec = '/home/azuri/daten/papers/rave/spc/spectra_plot.list'
  str_plot = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch1/figs/spectra_teff.ps'

  strarr_filenames = readfiletostrarr(str_list_spec,' ',I_NDATALINES=i_nspec)
  dblarr_teff = double(strarr_filenames(*,1))
  print,'strarr_filenames = ',strarr_filenames

  set_plot,'ps'
  device,filename=str_plot
  for i=0ul, i_nspec-1 do begin
    dblarr_spec = double(readfiletostrarr(strmid(str_list_spec,0,strpos(str_list_spec,'/',/REVERSE_SEARCH)+1)+strarr_filenames(i,0),' '))

    if i eq 0 then begin
      plot,dblarr_spec(*,0),$
           dblarr_spec(*,1),$
           yrange = [0.,9.7],$
           ystyle=1,$
           xtitle='Wavelength ['+STRING("305B)+']',$
           ytitle= 'Normalized Flux + constant',$
           thick=3.,$
           charsize=1.,$
           charthick=3.,$
           position=[0.055,0.09,0.97,0.995]
    end else begin
      oplot,dblarr_spec(*,0),dblarr_spec(*,1)+double(i)*2./3.,thick=3.
    end
    xyouts,8410.,1.05+I*2./3.,strarr_filenames(i,1)+' K',charthick=3.,charsize=1.
  endfor
  device,/close
  spawn,'epstopdf '+str_plot
end
