pro stella_plot_psfkriging
  str_filename = '/home/azuri/spectra/pfs/2014-10-28/debug/kriging.dat'
  str_plotname = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
  dblarr_krig = double(readfiletostrarr(str_filename,' '))

  print,'dblarr_krig(*,0) = ',dblarr_krig(*,0)
  
  set_plot,'ps'
  device,filename=str_plotname,/color
;  contour,dblarr_krig
    xrange = [min(dblarr_krig(*,0)),max(dblarr_krig(*,0))]
    yrange = [min(dblarr_krig(*,1)),max(dblarr_krig(*,1))]
    plot,[dblarr_krig(0,0),dblarr_krig(0,0)],$
         [dblarr_krig(0,1),dblarr_krig(0,1)],$
         psym=2,$
         xrange=xrange,$
         yrange=yrange,$
         xstyle=1,$
         ystyle=1
    loadct,11
    maxval = max(dblarr_krig(*,2))
    for i=0ul, n_elements(dblarr_krig(*,0))-1 do begin
      oplot,[dblarr_krig(i,0),dblarr_krig(i,0)],$
            [dblarr_krig(i,1),dblarr_krig(i,1)],$
            psym=2,$
            color = 255 * dblarr_krig(i,2) / maxval
    endfor
    plot_colour_legend, I_DBLARR_XRANGE = xrange,$
                        I_DBLARR_YRANGE = yrange,$
                        I_INT_NBOXES    = 255,$
                        I_B_OUTSIDE     = 1

  device,/close
  set_plot,'x'
end
