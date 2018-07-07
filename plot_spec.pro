pro plot_spec, str_filename_in, str_filename_out, xmin, xmax, ymin, ymax, ytitle=ytitle
  dblarr_spec = double(readfiletostrarr(str_filename_in, ' '))
;  dblarr_spec(*,0) = dblarr_spec(*,0) * 1000000000.
  print,'dblarr_spec(0,0) = ',dblarr_spec(0,0)

  set_plot,'ps'
  device,filename=str_filename_out
  plot,dblarr_spec(*,0),$
       dblarr_spec(*,1),$
       thick=3,$
       xtitle='Wavelength ['+STRING("305B)+']',$
       ytitle=ytitle,$
       xrange=[xmin, xmax],$
       xstyle=1,$
       yrange=[ymin, ymax],$
       ystyle=1,$
       charsize=1.8,$
       charthick=2,$
       position=[0.265, 0.16, 0.99, 0.98];,$
;       /YLOG
;       linethick=3
  device,/close
  set_plot,'x'
end
