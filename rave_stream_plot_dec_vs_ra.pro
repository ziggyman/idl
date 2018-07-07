pro rave_stream_plot_dec_vs_ra
  str_filename_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'

  strarr_stars = readfiletostrarr(str_filename_stars,' ')

  print,'strarr_stars(0,*) = ',strarr_stars(0,*)
  print,'size(strarr_stars) = ',size(strarr_stars)

  int_col_ra = 3
  int_col_dec = 4

  dblarr_ra = double(strarr_stars(*,int_col_ra))
  dblarr_dec = double(strarr_stars(*,int_col_dec))

  set_plot,'ps'
   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_dec_vs_ra.ps',/color
    plot,dblarr_ra,$
         dblarr_dec,$
;         xrange = [10000.,2000.],$
;         xstyle = 1,$
;         yrange = [5.5,0.],$
;         ystyle = 1,$
         psym=2,$
         xtitle = 'RA [deg]',$
         ytitle = 'Dec [deg]'
     loadct,13
     for i=0ul, n_elements(dblarr_ra)-1 do begin
       oplot,[dblarr_ra(i), dblarr_ra(i)],$
             [dblarr_dec(i), dblarr_dec(i)],$
             psym=2,$
             color = i*255/n_elements(dblarr_ra)
     endfor
   device,/close
  set_plot,'x'
end
