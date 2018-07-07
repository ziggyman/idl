pro rave_stream_plot_mh_vs_vrad
  str_filename_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'

  strarr_stars = readfiletostrarr(str_filename_stars,' ')

  print,'strarr_stars(0,*) = ',strarr_stars(0,*)
  print,'size(strarr_stars) = ',size(strarr_stars)

  int_col_vrad = 7
  int_col_mh = 21

  dblarr_vrad = double(strarr_stars(*,int_col_vrad))
  dblarr_mh = double(strarr_stars(*,int_col_mh))

  set_plot,'ps'
   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_mH_vs_vrad.ps',/color
    plot,dblarr_vrad,$
         dblarr_mh,$
;         xrange = [10000.,2000.],$
;         xstyle = 1,$
;         yrange = [5.5,0.],$
;         ystyle = 1,$
         psym=2,$
         xtitle = 'Radial velocity [km/s]',$
         ytitle = '[m/H] [dex]'
     loadct,13
     for i=0ul, n_elements(dblarr_vrad)-1 do begin
       oplot,[dblarr_vrad(i), dblarr_vrad(i)],$
             [dblarr_mh(i), dblarr_mh(i)],$
             psym=2,$
             color = i*255/n_elements(dblarr_vrad)
     endfor
   device,/close
  set_plot,'x'
end
