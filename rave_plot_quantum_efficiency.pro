pro rave_plot_quantum_efficiency
  str_filename = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch1/figs/quantum-efficiency.dat'

  dblarr_data = double(readfiletostrarr(str_filename,','))

  str_plotname = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
  device,filename=str_plotname,/color
    plot,dblarr_data(*,0),$
         dblarr_data(*,1),$
         yrange=[0.,100.],$
         xtitle = 'Wavelength [nm]',$
         ytitle = 'Quantum efficiency [%]',$
         thick = 3.,$
         charthick = 3.,$
         charsize = 1.8,$
         xtickformat = '(I4)',$
         xticklen = 1.,$
         yticklen = 1.,$
         position=[0.205,0.175,0.932,0.925]
    loadct,13
    box,840.,0.,890.,100.,100
    oplot,dblarr_data(*,0),$
          dblarr_data(*,1),$
          thick = 3.

  device,/close
  set_plot,'x'
end
