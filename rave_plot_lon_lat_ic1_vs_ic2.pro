pro rave_plot_lon_lat_ic1_vs_ic2
  str_ic1 = '/home/azuri/daten/rave/input_catalogue/ric1+2_lon_lat.dat'
  str_ic2 = '/home/azuri/daten/rave/input_catalogue/rave_input_lon_lat.dat'

  int_col_lon_ic1 = 1
  int_col_lat_ic1 = 2

  int_col_lon_ic2 = 1
  int_col_lat_ic2 = 2

  strarr_ic1 = readfiletostrarr(str_ic1,' ')
  strarr_ic2 = readfiletostrarr(str_ic2,' ')

  dblarr_lon_ic1 = double(strarr_ic1(*,int_col_lon_ic1))
  dblarr_lat_ic1 = double(strarr_ic1(*,int_col_lat_ic1))

  dblarr_lon_ic2 = double(strarr_ic2(*,int_col_lon_ic2))
  dblarr_lat_ic2 = double(strarr_ic2(*,int_col_lat_ic2))

  indarr_ic1 = where((dblarr_lon_ic1 ge 300.) and (dblarr_lon_ic1 le 305.) and (dblarr_lat_ic1 ge 30.) and (dblarr_lat_ic1 le 35.))
  indarr_ic2 = where((dblarr_lon_ic2 ge 300.) and (dblarr_lon_ic2 le 305.) and (dblarr_lat_ic2 ge 30.) and (dblarr_lat_ic2 le 35.))

  str_plotname_root = strmid(str_ic1,0,strpos(str_ic1,'.',/REVERSE_SEARCH))+'_vs_ic2_300-305_30-35'
  set_plot,'ps'
  device,filename=str_plotname_root+'.ps'
  plot,dblarr_lon_ic1(indarr_ic1),$
       dblarr_lat_ic1(indarr_ic1),$
       psym=4,$
       symsize=0.7,$
       thick=3.,$
       charthick=3.,$
       charsize=1.,$
       xtitle='Galactic longitude [deg]',$
       ytitle='Galactic latitude [deg]',$
       position=[0.205,0.175,0.932,0.925],$
       xrange=[300.,305.],$
       yrange=[30.,35.],$
       xstyle=1,$
       ystyle=1
  oplot,dblarr_lon_ic2(indarr_ic2),$
        dblarr_lat_ic2(indarr_ic2),$
        psym=1,$
        symsize=0.7
  device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname_root+'.ps'
end
