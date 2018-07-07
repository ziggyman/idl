pro stella_plot_performance

  str_datafile = '/home/azuri/spectra/feros/times_extract.dat'
  str_plotname_root = strmid(str_datafile,0,strpos(str_datafile,'.',/REVERSE_SEARCH))

  strarr_data = readfiletostrarr(str_datafile,' ',I_NLINES = i_nlines, I_NCOLS = i_ncols)
  print,'stella_plot_performance: i_nlines = ',i_nlines,', i_ncols = ',i_ncols

  dblarr_data = double(strarr_data(*,1:i_ncols-1))
  print,'stella_plot_performance: dblarr_data = ',dblarr_data

  set_plot,'ps'
  str_psfilename=str_plotname_root+'.ps'
  str_giffilename=str_plotname_root+'.gif'
  str_pdffilename=str_plotname_root+'.pdf'
  device,filename=str_psfilename,/color
  plot,[0.,10.],$
       [0.,0.],$
       xrange=[0.,6.6],$
       yrange=[0.,20.],$
       xstyle=1,$
       ystyle=1,$
       ytitle = 'computing time [s]',$
       charthick = 3.,$
       charsize = 2.,$
       position=[0.14,0.16,0.99,0.99],$
       xthick = 3.,$
       ythick = 3.,$
       xticks = 3,$
       xtickv = [0.,1.3,3.3,5.3],$
       xtickname=[' ','1.7 GHz','2.7 GHz','2.7 GHz'],$
       xticklen=0.0001
  xyouts,[0.52,2.7,4.7],[-3.5,-3.6,-3.4],['Dual Core','i7 32bit','i7 64bit'],charsize=2.,charthick=3.
  loadct,13
  for i=0,i_nlines-2 do begin
    box,2.*double(i)+1.,0.,2.*double(i)+1.3,dblarr_data(i,0),100
    box,2.*double(i)+1.3,0.,2.*double(i)+1.6,dblarr_data(i,1),50
  endfor
  ; --- legend
  box,4.,17.,4.5,18.5,100
  xyouts,4.65,17.2,'STELLA',charsize=2.,charthick=3.
  box,4.,15.,4.5,16.5,50
  xyouts,4.65,15.2,'REDUCE',charsize=2.,charthick=3.
  device,/close
  set_plot,'x'

  spawn,'epstopdf '+str_psfilename
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
end
