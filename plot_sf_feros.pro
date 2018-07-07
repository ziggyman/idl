pro plot_sf_feros
  str_path = '/home/azuri/spectra/feros/SF/'
  str_file_sf = str_path+'cfits_sf_5_Ap0_IBin12_IRunTel0_Tel0_Tel0.dat'
  str_file_im = str_path+'ImTimesMask_IterSF5_Ap0_IBin12_IRunTel0_Tel0.text'
 
  dblarr_sf = double(readfilelinestoarr(str_file_sf))
  print,'dblarr_sf = ',dblarr_sf
  
  dblarr_im = double(readfiletostrarr(str_file_im,' '))
  print,'dblarr_im(41,*) = ',dblarr_im(41,*)
  dblarr_plot_41 = dblarr_im(41,*) / total(dblarr_im(41,*))
  dblarr_plot_42 = dblarr_im(42,*) / total(dblarr_im(42,*))
  dblarr_plot_23 = dblarr_im(23,*) / total(dblarr_im(23,*))
 
  str_plotname=str_path+'plot_sf_feros.ps'
  set_plot,'ps'
;    loadct,13
    device,filename=str_plotname,/color
      indarr = lindgen(n_elements(dblarr_sf)) - 5
      plot,indarr,$
           dblarr_sf,$
           xtitle = 'Relative sub-pixel number',$
           ytitle='Spatial profile',$
           thick=6.,$
           color=0,$
           xrange=[0,n_elements(dblarr_sf)-6],$
           xstyle=1,$
           charsize=1.8,$
           charthick=3.,$
           position=[0.165,0.16,0.995,0.995]
      oplot,indarr,$
            dblarr_sf,$
            color=200,$
            thick=2.
      oplot,[145.,159.],[0.14,0.14],color=0,thick=6
      oplot,[145.,159.],[0.14,0.14],color=200,thick=2
      xyouts,160,0.138,'Profiles'

      oplot,[145.,159.],[0.13,0.13],linestyle=2
      xyouts,160,0.128,'CCD row 41'
      oplot,[145.,159.],[0.12,0.12],linestyle=3
      xyouts,160,0.118,'CCD row 42'
      oplot,[145.,159.],[0.11,0.11],linestyle=4
      xyouts,160,0.108,'CCD row 23'

      for i=0ul, n_elements(dblarr_plot_23)-1 do begin
        oplot,[i*10.,i*10.],$
              [0., dblarr_plot_41(i)],$
              linestyle=2
        oplot,[(i+1)*10.,(i+1)*10.],$
              [0., dblarr_plot_41(i)],$
              linestyle=2
        oplot,[i*10.,(i+1)*10.],$
              [dblarr_plot_41(i), dblarr_plot_41(i)],$
              linestyle=2
              
        oplot,[i*10.,i*10.],$
              [0., dblarr_plot_42(i)],$
              linestyle=3
        oplot,[(i+1)*10.,(i+1)*10.],$
              [0., dblarr_plot_42(i)],$
              linestyle=3
        oplot,[i*10.,(i+1)*10.],$
              [dblarr_plot_42(i), dblarr_plot_42(i)],$
              linestyle=3
              
        oplot,[i*10.,i*10.],$
              [0., dblarr_plot_23(i)],$
              linestyle=4
        oplot,[(i+1)*10.,(i+1)*10.],$
              [0., dblarr_plot_23(i)],$
              linestyle=4
        oplot,[i*10.,(i+1)*10.],$
              [dblarr_plot_23(i), dblarr_plot_23(i)],$
              linestyle=4
      endfor
    device,/close
  set_plot,'x'
end
