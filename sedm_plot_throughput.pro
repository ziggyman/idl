pro sedm_plot_throughput
  str_path = '/run/media/azuri/data/azuri/spectra/SEDIFU/Aug06/'
  str_filelist = str_path+'stdobs_divby_std.list'

  strarr_files = readfilelinestoarr(str_filelist)

  set_plot,'ps'
  str_plotname = strmid(str_filelist,0,strpos(str_filelist,'.',/REVERSE_SEARCH))+'.ps'
  device,filename=str_plotname,/color
  yrange=[0.,20]
  for i=0ul, n_elements(strarr_files)-1 do begin
    dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
    if i eq 0 then begin
      xrange=[min(dblarr_data(*,0)), max(dblarr_data(*,0))]
      plot,dblarr_data(*,0),$
           dblarr_data(*,1) * 100.,$
           xrange=xrange,$
           xstyle=1,$
           yrange=yrange,$
           ystyle=1,$
           xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
           ytitle='Throughput [%]',$
           position=[0.13,0.15,0.99,0.995],$
           thick=3,$
           charsize=1.2,$
           charthick=3.
      loadct,13
    endif
    oplot,dblarr_data(*,0),$
          dblarr_data(*,1) * 100.,$
          thick=3,$
          color = 2 + 252*i/n_elements(strarr_files)
    oplot,[3800,4100],$
          [yrange(1) - yrange(1)/20. - yrange(1)*i/20.,yrange(1) - yrange(1)/20. - yrange(1)*i/20.],$
          color = 2 + 252*i/n_elements(strarr_files),$
          thick=3
    str_star = strmid(strarr_files(i),strpos(strarr_files(i),'/')+1)
    str_star = strmid(str_star, 0, strpos(str_star,'_'))
    xyouts,4200,yrange(1) - yrange(1)/17. - yrange(1)*i/20.,str_star,charsize=1.2,charthick=3.
  endfor

  device,/close
  set_plot,'x'
end

