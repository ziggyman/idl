pro plot_kriging_result
  str_filename = '/home/azuri/spectra/SEDIFU/SEDM-deep-sim-flat-2012-05-14_ScatterOnly.text'
  str_filename_fit = '/home/azuri/spectra/SEDIFU/SEDM-deep-sim-flat-2012-05-14_ScatterFit_new.text'
  str_filename_res = '/home/azuri/spectra/SEDIFU/SEDM-deep-sim-flat-2012-05-14_ScatterRes.text'
  str_plotname = '/home/azuri/entwicklung/tex/papers/SEDIFU_pipeline/images/krig_scattered_light_input.ps'
  str_plotname_shade = '/home/azuri/entwicklung/tex/papers/SEDIFU_pipeline/images/krig_scattered_light_input_shade.ps'
  str_plotname_fit_shade = '/home/azuri/entwicklung/tex/papers/SEDIFU_pipeline/images/krig_fit_shade.ps'
  str_plotname_res_shade = '/home/azuri/entwicklung/tex/papers/SEDIFU_pipeline/images/krig_res_shade.ps'
  dblarr_krig = double(readfiletostrarr(str_filename,' '))
  dblarr_fit = double(readfiletostrarr(str_filename_fit,' '))
  dblarr_res = double(readfiletostrarr(str_filename_res,' '))
;  size_krig = size(dblarr_krig)
;  dblarr_krig = dblarr_krig(0:size_krig(1)-1, 0:size_krig(2)-2)

  set_plot,'ps'
  device,filename=str_plotname
  contour,dblarr_krig,NLEVELS=10
  device,/close
  device,filename=str_plotname_shade
  shade_surf,dblarr_krig,$
             xtitle = 'Column No.',$
             ytitle = 'Row No.',$
             ztitle = 'Pixel Value [ADUs]',$
             charsize = 2.5,$
             xrange = [0,2048],$
             yrange = [0,2048],$
             zrange = [0.,140.],$
             xstyle = 1,$
             ystyle = 1,$
             zstyle = 1
  device,/close

  device,filename=str_plotname_fit_shade
  shade_surf,dblarr_fit,$
             xtitle = 'Column No.',$
             ytitle = 'Row No.',$
             ztitle = 'Pixel Value [ADUs]',$
             charsize = 2.5,$
             xrange = [0,2048],$
             yrange = [0,2048],$
             zrange = [0.,140.],$
             xstyle = 1,$
             ystyle = 1,$
             zstyle = 1

  device,/close

  device,filename=str_plotname_res_shade
  shade_surf,dblarr_res,$
             xtitle = 'Column No.',$
             ytitle = 'Row No.',$
             ztitle = 'Pixel Value [ADUs]',$
             charsize = 2.5,$
             xrange = [0,2048],$
             yrange = [0,2048],$
             xstyle = 1,$
             ystyle = 1

  device,/close
  set_plot,'x'

  print,'size(dblarr_krig) = ',size(dblarr_krig)
  print,'size(dblarr_res) = ',size(dblarr_fit)
  print,'size(dblarr_res) = ',size(dblarr_res)

end
