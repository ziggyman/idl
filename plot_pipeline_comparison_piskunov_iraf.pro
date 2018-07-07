pro plot_pipeline_comparison_piskunov_iraf
  str_path = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/'
  str_filelist_in = str_path+'to_compare_piskunov_iraf_text.list'
  strarr_files = readfilelinestoarr(str_filelist_in)
  
  str_plotname = strmid(str_filelist_in,0,strpos(str_filelist_in,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
    device,filename=str_plotname,/color
      for i=0ul, n_elements(strarr_files)-1 do begin
        dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
        if i eq 0 then begin
          plot,dblarr_data(*,0),$
               dblarr_data(*,1),$
               xrange = [1970.,2355.],$
               xstyle = 1,$
               charsize = 1.4,$
               charthick = 2.,$
               xtitle = 'Pixel number',$
;               xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
               ytitle = 'Counts [ADUs] - const',$
               ytickformat='(I9)',$
               position=[0.154,0.115,0.995,0.995],$
               yrange = [20000,70000],$
               ystyle=1,$
               color=1,$
               thick=3.
          oplot,[2035,2050],[35000,35000],thick=3.,color=1

          loadct,13
        end else begin
          oplot,dblarr_data(*,0),$
                dblarr_data(*,1) - i * 5000.,$
                color=180 * i / n_elements(strarr_files),$
                thick=3.
          if i eq 1 then begin
            oplot,[2035,2050],[32000,32000],color=180 * i / n_elements(strarr_files),thick=3.
          end else if i eq 2 then begin
            oplot,[2035,2050],[29000,29000],color=180 * i / n_elements(strarr_files),thick=3.
          end else if i eq 3 then begin
            oplot,[2035,2050],[26000,26000],color=180 * i / n_elements(strarr_files),thick=3.
          end else begin
            oplot,[2035,2050],[23000,23000],color=180 * i / n_elements(strarr_files),thick=3.
          endelse
        endelse
      endfor
      xyouts,2055,34500,'REDUCE pipeline',charsize = 1.3,charthick = 2.
      xyouts,2055,31500,'STELLA: IRAF sum',charsize = 1.3,charthick = 2.
      xyouts,2055,28500,'STELLA: IRAF fit1d',charsize = 1.3,charthick = 2.
      xyouts,2055,25500,'STELLA: IRAF fit2d',charsize = 1.3,charthick = 2.
      xyouts,2055,22500,'STELLA: our P&V re-implementation',charsize = 1.3,charthick = 2.
    device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname  
end
