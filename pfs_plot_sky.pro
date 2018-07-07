pro pfs_plot_sky
  filename_spec = '/home/azuri/spectra/pfs/IR-23-0-centerSkyx2_EcProf_ap0_x2028_y2017.text'
  dblarr_sky = double(readfiletostrarr(filename_spec,' '))
  
  filename_wave = '/home/azuri/spectra/pfs/WAVE_IR_fiber0.text'
  dblarr_wave = double(readfiletostrarr(filename_wave,' '))

  dblarr_wave = dblarr_wave(55:3985)
  
  print,dblarr_wave(1310:2670)
  
  set_plot,'ps'
  device,filename='/home/azuri/entwicklung/tex/talks/PFS_Marseille/images/extracted_sky.eps'
  plot,dblarr_wave(1310:2670),$
       dblarr_sky(1310:2670),$
       xrange=[dblarr_wave(1310),dblarr_wave(2670)],$
       yrange=[0,15000],$
       xstyle=1,$
       ystyle=2,$
       xtickformat='(I8)',$
       ytickformat='(I8)',$
       xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
       ytitle='Counts [ADU]',$
       charsize=1.,$
       position=[0.11,0.2,0.98,0.99],$
       charthick=3.
  device,/close
  set_plot,'x'
end
