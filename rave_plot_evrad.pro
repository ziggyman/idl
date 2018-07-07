pro rave_plot_evrad
  str_filename = '/home/azuri/entwicklung/idl/temp_vrad.dat'

  strarr_data = readfiletostrarr(str_filename,' ')
  dblarr_data = double(strarr_data)
  strarr_data = 0

  str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
  xtitle = 'Error radial velocity [km/s]'
  ytitle = 'Number of stars'
  xrange = [-4.,4.]


  plot_histogram,dblarr_data,$
                   str_plotname_root,$
                   XTITLE=xtitle,$
                   YTITLE=ytitle,$
                   NBINS=nbins,$
;                   TITLE=title,$
                   XRANGE=xrange,$
                   I_B_PLOT_GAUSSFIT = 1;,$
;                   YRANGE=yrange,$
;                   OVERPLOT=overplot,$
;                   MORETOCOME=moretocome,$
;                   NORMALISE=normalise

end
