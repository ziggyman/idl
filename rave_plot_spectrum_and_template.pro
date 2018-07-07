pro rave_plot_spectrum_and_template, str_spec_in, str_temp_in, str_plot_out, STR_TITLE=str_title
  dblarr_spec = double(readfiletostrarr(str_spec_in,' '))
  dblarr_temp = double(readfiletostrarr(str_temp_in,' '))

  set_plot,'ps'
  device,filename=str_plot_out+'.ps',/color
  if not(keyword_set(STR_TITLE)) then $
    str_title = ' '
  plot,dblarr_spec(*,0),$
       dblarr_spec(*,1),$
       xtitle='Wavelength ['+STRING("305B)+']',$
       ytitle='Normalised Flux',$
       color=0,$
       charsize = 1.3,$
       charthick = 3.,$
       thick=3.,$
       title=str_title,$
       position=[0.10,0.115,0.95,0.94]
  loadct,13
  oplot,dblarr_temp(*,0),$
        dblarr_temp(*,1),$
        color=50,$
        thick=3
  device,/close
  set_plot,'x'
;  spawn,'ps2gif '+str_plot_out
end
