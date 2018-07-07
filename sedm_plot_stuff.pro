pro sedm_plot_stuff
;  dblarr_line = [[580.,       600.],[612.963,       600.]]
dblarr_rect = [[612.963, 600],[645.926,600],[ 645.926, 650],[612.963,650]]
dblarr_fig = [[2.37202e-310, 2.37202e-310],[ 833.423, 725],[ 1182.38, 733],[ 1314.39, 724],[1401.39, 734],[522.396,736]]
;dblarr_fig =[[ 602.647, 587.883],[621.262, 565.649],[649.784, 571.768],[660.525,602.785],[ 641.499, 625.607],[ 613.157, 619.401]]
;dblarr_fig = [[   524.678,    817.27],[  543.067,   795.181],[  572.01,   801.268],[ 582.033,   831.005],[  563.908,   852.233],[  535.591,    846.77 ]]
;  dblarr_fig = [[517.916,    1324.5],[    510.237,    1371.5],[  537.411,      1341],[   533.402,    1364.5],[  541.414,    1317.5],[529.407,      1387 ]]
dblarr_overlap = [[   612.963, 600],[645.926, 600],[ 645.926,   620.297],[ 612.963,   618.819],[ 602.647,   587.883],[ 641.499,   625.607],[ 613.157,   619.401 ]]

  set_plot,'ps'
  device,filename='/home/azuri/spectra/SEDIFU/test_calcoverlapfig.ps',/color
  plot,[dblarr_fig(0,0),dblarr_fig(0,5)],$
       [dblarr_fig(1,0),dblarr_fig(1,5)],$
       color=4,$
       xrange = [0.,1450.],$
       yrange = [0.,740.]
  loadct,13
  for i=0, 4 do begin
    oplot,[dblarr_fig(0,i),dblarr_fig(0,i+1)],$
          [dblarr_fig(1,i),dblarr_fig(1,i+1)],$
          color=4
  endfor
  oplot,[dblarr_rect(0,0), dblarr_rect(0,3)],$
        [dblarr_rect(1,0), dblarr_rect(1,3)]
  for i=0, 2 do begin
    oplot,[dblarr_rect(0,i),dblarr_rect(0,i+1)],$
          [dblarr_rect(1,i),dblarr_rect(1,i+1)],$
          color=150
  endfor
  for i=0, 5 do begin
    oplot,[dblarr_overlap(0,i),dblarr_overlap(0,i+1)],$
          [dblarr_overlap(1,i),dblarr_overlap(1,i+1)],$
          color=250
    oplot,[dblarr_overlap(0,0),dblarr_overlap(0,6)],$
          [dblarr_overlap(1,0),dblarr_overlap(1,6)],$
          color=250
  endfor
  device,/close
  set_plot,'x'
end
