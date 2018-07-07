pro pfs_plot_fits_spectrum
  fname_spec = '/home/azuri/spectra/pfs/2014-09-26/IR-23-0-centerFlatx2_trace0_spec.fits'
  dblarr_spec = readfits(fname_spec, h)
  
  set_plot,'ps'
  device,filename=strmid(fname_spec,0,strpos(fname_spec,'.',/REVERSE_SEARCH))+'.ps'
  plot,dblarr_spec,$
       xrange=[1000,1100],$
       yrange=[53000.,55000.],$
       ystyle=1
  device,/close
  set_plot,'x'
end
