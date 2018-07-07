pro sedm_plot_wlen_vs_pixel
;  str_filename = '/home/azuri/spectra/SEDIFU/commissioning/June19/lines_wlen_pix_all.dat'
  str_filename = '/home/azuri/spectra/SEDIFU/commissioning/June20/lines_wlen_pix_ref_ne+hg+xe_155long.dat'
  
  dblarr_data = double(readfiletostrarr(str_filename,' '))
  
  dblarr_coeffs2 = poly_fit(dblarr_data(*,0),dblarr_data(*,1),2,YFIT=dblarr_fit2)
  dblarr_coeffs3 = poly_fit(dblarr_data(*,0),dblarr_data(*,1),3,YFIT=dblarr_fit3)
  dblarr_coeffs4 = poly_fit(dblarr_data(*,0),dblarr_data(*,1),4,YFIT=dblarr_fit4)
  
  set_plot,'ps'
   device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
    plot,dblarr_data(*,0),$
         dblarr_data(*,1),$
         psym=2,$
         xtitle='Wavelength [Ang]',$
         ytitle='pixel'
;    oplot,dblarr_data(*,0),dblarr_data(*,1)
    oplot,dblarr_data(*,0),dblarr_fit2,linestyle=2
    oplot,[8000,8500],[50,50],linestyle=2
    xyouts,8530,48,'2'
    oplot,dblarr_data(*,0),dblarr_fit3,linestyle=3
    oplot,[8000,8500],[40,40],linestyle=3
    xyouts,8530,38,'3'
    oplot,dblarr_data(*,0),dblarr_fit2,linestyle=4
    oplot,[8000,8500],[30,30],linestyle=4
    xyouts,8530,28,'4'
   device,/close
  set_plot,'x'
end
