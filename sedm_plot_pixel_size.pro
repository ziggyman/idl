pro sedm_plot_pixel_size
  dblarr_measure = dblarr(11,2)
      dblarr_measure[0,0] = 3836.;
    dblarr_measure[0,1] = 3838.572 - 3833.376;

    dblarr_measure[1,0] = 4500.;
    dblarr_measure[1,1] = 4516.302-4497.471;
    
    dblarr_measure[2,0] = 5000.;
    dblarr_measure[2,1] = 5001.81 - 4981.891;
    
    dblarr_measure[3,0] = 5500.;
    dblarr_measure[3,1] = 5523.83 - 5501.729;
    
    dblarr_measure[4,0] = 6000.;
    dblarr_measure[4,1] = 6017.374 - 5992.525;
    
    dblarr_measure[5,0] = 6500.;
    dblarr_measure[5,1] = 6517.175 - 6489.445;
    
    dblarr_measure[6,0] = 7000.;
    dblarr_measure[6,1] = 6984.832 - 6954.092;
    
    dblarr_measure[7,0] = 7500.;
    dblarr_measure[7,1] = 7520.518 - 7484.129;
    
    dblarr_measure[8,0] = 8000.;
    dblarr_measure[8,1] = 8047.624 - 8002.889;
    
    dblarr_measure[9,0] = 8500.;
    dblarr_measure[9,1] = 8550.522 - 8495.083;
    
    dblarr_measure[10,0] = 9000.;
    dblarr_measure[10,1] = 9046.391 - 8978.573;

    dblarr_coeffs = [  -1123.71,  0.836434, -0.000241579, 3.44497e-08, -2.43109e-12, 6.88977e-17  ]

    dblarr_lam = dblarr_measure(*,0)
    dblarr_calc = poly(dblarr_lam, dblarr_coeffs)

    set_plot,'ps'
    str_plotname = '/home/azuri/spectra/SEDIFU/Ang_per_pixel.ps'
    device,filename=str_plotname
    plot,dblarr_measure(*,0),$ 
         dblarr_measure(*,1),$
         psym = 4,$
         xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
         ytitle = STRING("305B)+'ngstr'+STRING("366B)+'ms per pixel',$
         xrange=[3500.,9500.],$
         xstyle=1,$
         charsize=1.8,$
         thick=3.
    oplot,dblarr_lam,dblarr_calc,thick=3.
    device,/close
    spawn,'epstopdf '+str_plotname
    set_plot,'x'
end
