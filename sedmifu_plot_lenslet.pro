pro sedmifu_plot_lenslet
  dblarr_center = [1034.42, 1129.]
  dblarr_points = [[   1038.42,      1105],$ 
                   [   1057.41,      1120],$ 
                   [   1053.92,    1144.5],$
                   [   1030.42,      1154],$
                   [   1010.92,    1137.5],$
                   [   1014.92,      1113]]
  print,'dblarr_points = ',size(dblarr_points),': ',dblarr_points
  
  dblarr_points_sorted = [[   1038.42,      1105],$ 
                          [   1057.41,      1120],$ 
                          [   1053.92,    1144.5],$
                          [   1030.42,      1154],$
                          [   1010.92,    1137.5],$
                          [   1014.92,      1113]]
  dblarr_points_half = [[   1047.91,    1112.5],$
                        [   1055.66,   1132.25],$
                        [   1042.17,   1149.25],$
                        [   1020.67,   1145.75],$
                        [   1012.92,   1125.25],$
                        [   1026.67,      1109.]]
  dblarr_points_corners = [[   1052.34,   1107.09  ],$
                           [   1062.73,   1133.33  ],$
                           [   1044.79,   1156.08  ],$
                           [   1015.99,   1151.45  ],$
                           [   1005.86,   1124.02  ],$
                           [   1024.08,   1102.32  ]]

  set_plot,'ps'
  device,filename='/home/azuri/daten/SEDIFU/lenslet.ps'
    plot,dblarr_points(0,*),$
         dblarr_points(1,*),$
         psym=2,$
         xrange=[1000.,1070.],$
         yrange=[1100.,1160.],$
         xstyle=1,$
         ystyle=1
    oplot,[dblarr_center(0),dblarr_center(0)],$
          [dblarr_center(1),dblarr_center(1)],$
          psym=2
    for i=0ul, 4 do begin
      oplot,[dblarr_points_sorted(0,i),dblarr_points_sorted(0,i+1)],$
            [dblarr_points_sorted(1,i),dblarr_points_sorted(1,i+1)]
    endfor
    oplot,[dblarr_points_sorted(0,0),dblarr_points_sorted(0,5)],$
          [dblarr_points_sorted(1,0),dblarr_points_sorted(1,5)]
    oplot,dblarr_points_half(0,*),$
          dblarr_points_half(1,*),$
          psym=2
    oplot,dblarr_points_corners(0,*),$
          dblarr_points_corners(1,*);,$
;          psym=2
    oplot,[dblarr_points_corners(0,0),dblarr_points_corners(0,5)],$
    [dblarr_points_corners(1,0),dblarr_points_corners(1,5)]
  device,/close
  set_plot,'x'
end
