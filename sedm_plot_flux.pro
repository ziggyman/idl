pro sedm_plot_flux
  str_filename_sedm_flux = '/home/azuri/spectra/SEDIFU/commissioning/June20/BD332642_360s_ifu20130619_22_36_02/BD332642_360s_ifu20130619_22_36_02EcDR_ObsSum_Flux.text'
  str_filename_sedm_photons = '/home/azuri/spectra/SEDIFU/commissioning/June20/BD332642_360s_ifu20130619_22_36_02/BD332642_360s_ifu20130619_22_36_02EcDR_ObsSum_Flux.text'
  str_filename_std = '/home/azuri/stella/standards/fbd33d2642.dat'
  
  str_plotname = strmid(str_filename_sedm, 0, strpos(str_filename_sedm,'.',/REVERSE_SEARCH))+'.ps'
  
  dblarr_sedm = double(readfiletostrarr(str_filename_sedm, ' '))  
  print,'dblarr_sedm(*,0) = ',dblarr_sedm(*,0)
  print,'dblarr_sedm(*,1) = ',dblarr_sedm(*,1)
  
  dblarr_std = double(readfiletostrarr(str_filename_std,' '))
  dblarr_std(*,1) = dblarr_std(*,1) * 1e-16
  print,'dblarr_std(*,1) = ',dblarr_std(*,1)
  
  set_plot,'ps'
   device,filename=str_plotname
     plot,dblarr_sedm(*,0),$
          alog10(dblarr_sedm(*,1)),$
          xrange = [5200.,9500.],$
          xstyle = 1,$
          yrange = [-15.5,-12.],$
          ystyle = 1
          
     oplot,dblarr_std(*,0),$
           alog10(dblarr_std(*,1)),$
           linestyle=2
   device,/close
  set_plot,'x'
  
end
