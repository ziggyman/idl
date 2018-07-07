pro rave_plot_1_fibre
  str_filename = '/home/azuri/spectra/rave/scatter/fibre_023_FP1.text'

  dblarr_data = double(readfiletostrarr(str_filename,' '))

  str_plotname = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
  device,filename=str_plotname
    plot,dblarr_data(*,0),$
         dblarr_data(*,1),$
         xrange = [0,1100],$
         xstyle = 1,$
         yrange = [915.,1020.],$
         ystyle = 1,$
         position=[0.205,0.175,0.932,0.925],$
         thick=3.,$
         xtitle='Column number',$
         ytitle = 'Flux [arbitrary units]',$
         charsize = 1.8,$
         charthick = 3.
  device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname
end
