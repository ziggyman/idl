pro stella_plot_psf
  str_filename = '/home/azuri/spectra/pfs/2014-11-02/debug/psf_x_y_in_fit.dat'
  str_plotname = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))
  dblarr_psf = double(readfiletostrarr(str_filename,' '))
  str_filename = '/home/azuri/spectra/pfs/2014-11-02/debug/kriging_in_pix_x_y_val.dat'
  str_krig_plotname = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))
  dblarr_krig = double(readfiletostrarr(str_filename,' '))
  
  print,'dblarr_krig(*,0) = ',dblarr_krig(*,0)
  print,'dblarr_krig(*,1) = ',dblarr_krig(*,1)
  print,'dblarr_krig(*,2) = ',dblarr_krig(*,2)
;  stop
  set_plot,'ps'
  
          red = intarr(256)
        green = intarr(256)
        blue = intarr(256)
        for l=0ul, 255 do begin
          if l le 127 then begin
            red(l) = 60 - (2*l)
            green(l) = 2 * l
            blue(l) = 255 - (2 * l)
          end else begin
            blue(l) = 0
            green(l) = 255 - (2 * (l-127))
            red(l) = 2 * (l-127)
          end
          if red(l) lt 0 then red(l) = 0
          if red(l) gt 255 then red(l) = 255
          if green(l) lt 0 then green(l) = 0
          if green(l) gt 255 then green(l) = 255
          if blue(l) lt 0 then blue(l) = 0
          if blue(l) gt 255 then blue(l) = 255
        endfor
        ltab = 0
        modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'

  ; --- plot pixel values
  device,filename=str_plotname+'_orig.ps',/color
;  contour,dblarr_psf
    xrange = [min(dblarr_psf(*,0)),max(dblarr_psf(*,0))]
    yrange = [min(dblarr_psf(*,1)),max(dblarr_psf(*,1))]
    plot,[dblarr_psf(0,0),dblarr_psf(0,0)],$
         [dblarr_psf(0,1),dblarr_psf(0,1)],$
         psym=2,$
         xrange=xrange,$
         yrange=yrange,$
         xstyle=1,$
         ystyle=1,$
         position=[0.1,0.05,0.75,0.94],$
         title=str_plotname+'_orig'
    loadct,ltab,FILE='colors1.tbl'
    maxval = max(dblarr_psf(*,2))
    for i=0ul, n_elements(dblarr_psf(*,0))-1 do begin
      oplot,[dblarr_psf(i,0),dblarr_psf(i,0)],$
            [dblarr_psf(i,1),dblarr_psf(i,1)],$
            psym=2,$
            color = 255 * dblarr_psf(i,2) / maxval
    endfor
    plot_colour_legend, I_DBLARR_XRANGE = xrange,$
                        I_DBLARR_YRANGE = yrange,$
                        I_INT_NBOXES    = 255,$
                        I_B_OUTSIDE     = 1
    loadct,0
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(0), strtrim(string(0.),2)
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(1), strtrim(string(maxval),2)

  device,/close

    
  ; --- plot kriging input values
  device,filename=str_krig_plotname+'.ps',/color
;  contour,dblarr_krig
    xrange = [min(dblarr_krig(*,0)),max(dblarr_krig(*,0))]
    yrange = [min(dblarr_krig(*,1)),max(dblarr_krig(*,1))]
    plot,[dblarr_krig(0,0),dblarr_krig(0,0)],$
         [dblarr_krig(0,1),dblarr_krig(0,1)],$
         psym=2,$
         xrange=xrange,$
         yrange=yrange,$
         xstyle=1,$
         ystyle=1,$
         position=[0.1,0.05,0.75,0.94],$
         title=str_krig_plotname
    loadct,ltab,FILE='colors1.tbl'
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

    loadct,0
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(0), strtrim(string(0.),2)
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(1), strtrim(string(maxval),2)
  device,/close
  
  ; --- plot fitted pixel values
  device,filename=str_plotname+'_fitted.ps',/color
;  contour,dblarr_psf
    xrange = [min(dblarr_psf(*,0)),max(dblarr_psf(*,0))]
    yrange = [min(dblarr_psf(*,1)),max(dblarr_psf(*,1))]
    plot,[dblarr_psf(0,0),dblarr_psf(0,0)],$
         [dblarr_psf(0,1),dblarr_psf(0,1)],$
         psym=2,$
         xrange=xrange,$
         yrange=yrange,$
         xstyle=1,$
         ystyle=1,$
         position=[0.1,0.05,0.75,0.94],$
         title=str_plotname+'_fitted'
    loadct,ltab,FILE='colors1.tbl'
    maxval = max(dblarr_psf(*,3))
    for i=0ul, n_elements(dblarr_psf(*,0))-1 do begin
      oplot,[dblarr_psf(i,0),dblarr_psf(i,0)],$
            [dblarr_psf(i,1),dblarr_psf(i,1)],$
            psym=2,$
            color = 255 * dblarr_psf(i,3) / maxval
    endfor
    plot_colour_legend, I_DBLARR_XRANGE = xrange,$
                        I_DBLARR_YRANGE = yrange,$
                        I_INT_NBOXES    = 255,$
                        I_B_OUTSIDE     = 1
    loadct,0
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(0), strtrim(string(0.),2)
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(1), strtrim(string(maxval),2)
  device,/close
  
  ; --- plot fitted pixel values
  device,filename=str_plotname+'_res.ps',/color
;  contour,dblarr_psf
    xrange = [min(dblarr_psf(*,0)),max(dblarr_psf(*,0))]
    yrange = [min(dblarr_psf(*,1)),max(dblarr_psf(*,1))]
    plot,[dblarr_psf(0,0),dblarr_psf(0,0)],$
         [dblarr_psf(0,1),dblarr_psf(0,1)],$
         psym=2,$
         xrange=xrange,$
         yrange=yrange,$
         xstyle=1,$
         ystyle=1,$
         position=[0.1,0.05,0.75,0.94],$
         title=str_plotname+'_res'
    loadct,ltab,FILE='colors1.tbl'
    minval = -0.005;min(dblarr_psf(*,2)-dblarr_psf(*,3))
    maxval = 0.005;max(dblarr_psf(*,2)-dblarr_psf(*,3))
    for i=0ul, n_elements(dblarr_psf(*,0))-1 do begin
      color = 255 * ((dblarr_psf(i,2)-dblarr_psf(i,3)) - minval) / (maxval-minval)
      if color lt 0 then color = 0
      if color gt 255 then color = 255
      oplot,[dblarr_psf(i,0),dblarr_psf(i,0)],$
            [dblarr_psf(i,1),dblarr_psf(i,1)],$
            psym=2,$
            color = color
    endfor
    plot_colour_legend, I_DBLARR_XRANGE = xrange,$
                        I_DBLARR_YRANGE = yrange,$
                        I_INT_NBOXES    = 255,$
                        I_B_OUTSIDE     = 1
    loadct,0
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(0), strtrim(string(minval),2)
    xyouts,xrange(1)+((xrange(1)-xrange(0))/15.), yrange(1), strtrim(string(maxval),2)
  device,/close
  set_plot,'x'
end
