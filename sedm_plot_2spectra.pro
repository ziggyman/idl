pro sedm_plot_2spectra
  str_filename_in_a = '/home/azuri/spectra/SEDIFU/commissioning/June18/Wave_EcSum_ap805_x1729_y825.text'
  str_filename_in_b = '/home/azuri/spectra/SEDIFU/commissioning/June18/Wave_EcSum_ap992_x1158_y1032.text'
  
  dblarr_a = double(readfiletostrarr(str_filename_in_a,' '))
  dblarr_b = double(readfiletostrarr(str_filename_in_b,' '))
  print,'dblarr_a(*,0) = ',dblarr_a(*,0)
  print,'dblarr_a(*,1) = ',dblarr_a(*,1)
  
  set_plot,'ps'
  device,filename='/home/azuri/spectra/SEDIFU/commissioning/June18/Wave_EcSum_ap805_x1729_y825_and_ap992_x1158_y1032.ps'
  plot,dblarr_a(*,0),dblarr_a(*,1)
  oplot,dblarr_b(*,0)+7,dblarr_b(*,1)
  device,/close
  set_plot,'x'
end
