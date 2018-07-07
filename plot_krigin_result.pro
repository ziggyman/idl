pro plot_krigin_result
  str_filename = '/home/azuri/entwicklung/cpp/krigin/krig.csv'
  str_plotname = '/home/azuri/entwicklung/cpp/krigin/krig.ps'
  dblarr_krig = double(readfiletostrarr(str_filename,','))

  set_plot,'ps'
  device,filename=str_plotname
  contour,dblarr_krig
  set_plot,'x'
end
