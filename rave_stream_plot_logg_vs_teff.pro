pro rave_stream_plot_logg_vs_teff
  str_filename_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'

  strarr_stars = readfiletostrarr(str_filename_stars,' ')

  print,'strarr_stars(0,*) = ',strarr_stars(0,*)
  print,'size(strarr_stars) = ',size(strarr_stars)

  int_col_logg = 20
  int_col_teff = 19

  dblarr_logg = double(strarr_stars(*,int_col_logg))
  dblarr_teff = double(strarr_stars(*,int_col_teff))

  set_plot,'ps'
   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_logg_vs_Teff.ps',/color
    plot,dblarr_teff,$
         dblarr_logg,$
         xrange = [10000.,2000.],$
         xstyle = 1,$
         yrange = [5.5,0.],$
         ystyle = 1,$
         psym=2,$
         xtitle = 'Teff [K]',$
         ytitle = 'log g [dex]'
     loadct,13
     for i=0ul, n_elements(dblarr_teff)-1 do begin
       oplot,[dblarr_teff(i), dblarr_teff(i)],$
             [dblarr_logg(i), dblarr_logg(i)],$
             psym=2,$
             color = i*255/n_elements(dblarr_teff)
     endfor
   device,/close
  set_plot,'x'
end
