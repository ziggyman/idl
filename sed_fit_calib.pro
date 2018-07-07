pro sed_fit_calib
  str_filename = '/home/azuri/daten/SEDIFU/run_61f_temp_0degC.txt'
  dblarr_data = double(readfiletostrarr(str_filename,' '))
  dblarr_lambda = dblarr_data(*,3)*10000.
  dblarr_pix = dblarr_data(*,5)/0.0135
  
  set_plot,'ps'
  device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_lambda_y.ps',/color
    loadct,13
    plot,dblarr_pix,$
         dblarr_lambda,$
         ytitle='wavelength ['+string(197B)+']',$
         xtitle='y position [pix]',$
         yrange=[3400,9100],$
         xrange=[-115,115],$
         xstyle=1,$
         ystyle=1,$
         color=1
  
    for i=3,10 do begin
      coeffs=POLY_FIT(dblarr_pix,dblarr_lambda,i,YFIT=dblarr_fit)
      print,'order = ',i,': coeffs=',coeffs
      print,'y-yfit = ',dblarr_lambda-dblarr_fit
      rms = sqrt((total((dblarr_lambda-dblarr_fit)^2.))/n_elements(dblarr_pix)) 
      print,'rms = ',rms
      oplot,dblarr_pix,$
            dblarr_fit,$
            color=255*i/7
      oplot,[-110,-100],$
            [9100-(i-2)*200,9100-(i-2)*200],$
            color=255*i/7
      xyouts,-95,9150-(i-2)*200-80,strtrim(string(i),2)+'rd order, rms='+strtrim(string(rms),2)+string(197B)
    endfor
  device,/close

  device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_lambda_y_svdfit.ps',/color
    loadct,13
    plot,dblarr_pix,$
         dblarr_lambda,$
         ytitle='wavelength ['+string(197B)+']',$
         xtitle='y position [mm]',$
         yrange=[3400.,9100.],$
         xrange=[-115,115],$
         xstyle=1,$
         ystyle=1,$
         color=1
  
    for i=4,11 do begin
      coeffs=SVDFIT(dblarr_pix,dblarr_lambda,i,YFIT=dblarr_fit)
      print,'order = ',i,': coeffs=',coeffs
      print,'y-yfit = ',dblarr_lambda-dblarr_fit
      rms = sqrt((total((dblarr_lambda-dblarr_fit)^2.))/n_elements(dblarr_pix)) 
      print,'rms = ',rms
      oplot,dblarr_pix,$
            dblarr_fit,$
            color=255*i/7
      oplot,[-110,-100],$
            [9100-(i-3)*200,9100-(i-3)*200],$
            color=255*i/7
      xyouts,-95,9150-(i-3)*200-80,strtrim(string(i-1),2)+'rd order, rms='+strtrim(string(rms),2)+string(197B)
    endfor
  device,/close
  set_plot,'x'
end
