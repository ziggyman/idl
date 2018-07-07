pro sedm_plot_spec, str_filename_in
  dblarr_spec = double(readfiletostrarr(str_filename_in, ' '))
  str_plotname = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'.ps'

  set_plot,'ps'
  device,filename=str_plotname
    plot,dblarr_spec(*,0),dblarr_spec(*,1),title=strmid(str_plotname,strpos(str_plotname,'/',/REVERSE_SEARCH)+1)
  device,/close
  set_plot,'x'
end
