pro rave_stream_plot_h_vs_j_minus_k
  str_filename_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'

  strarr_stars = readfiletostrarr(str_filename_stars,' ')

  print,'strarr_stars(0,*) = ',strarr_stars(0,*)
  print,'size(strarr_stars) = ',size(strarr_stars)

  int_col_j = 59
  int_col_k = 63
  int_col_pm_ra = 9
  int_col_pm_dec = 11

  dblarr_j = double(strarr_stars(*,int_col_j))
  dblarr_k = double(strarr_stars(*,int_col_k))
  print,'dblarr_j = ',dblarr_j
  print,'dblarr_k = ',dblarr_k
  dblarr_pm_ra = double(strarr_stars(*,int_col_pm_ra)) / 1000.
  dblarr_pm_dec = double(strarr_stars(*,int_col_pm_dec)) / 1000.

  dblarr_pm = sqrt((dblarr_pm_ra * dblarr_pm_ra) + (dblarr_pm_dec * dblarr_pm_dec))
  dblarr_j_minus_k = dblarr_j - dblarr_k

  dblarr_hj = dblarr_j + (5.*alog10(dblarr_pm)) + 5.

  set_plot,'ps'
   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_H_vs_J-K.ps',/color
    plot,dblarr_j_minus_k,$
         dblarr_hj,$
         xrange = [0.,1.5],$
         yrange = [max(dblarr_hj) + max(dblarr_hj)/10.,0.],$
         xstyle = 1,$
         ystyle = 1,$
         xtitle = '2Mass J - K',$
         ytitle = 'H',$
         psym=2
     loadct,13
     for i=0ul, n_elements(dblarr_hj)-1 do begin
       oplot,[dblarr_j_minus_k(i), dblarr_j_minus_k(i)],$
             [dblarr_hj(i), dblarr_hj(i)],$
             psym=2,$
             color = i*255/n_elements(dblarr_hj)
     endfor
   device,/close
  set_plot,'x'
end
