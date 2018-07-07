pro plot_sky_paper_piskunov
  str_filelist_sky = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/sky_ecs_text.list'
  str_filelist_obj = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/obs_ecs_text.list'
  str_filelist_snr = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/obs_ecs_snr_text.list'
  str_file_legend = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/legend.list'
  
  str_path = strmid(str_filelist_obj,0,strpos(str_filelist_obj,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'
  
  str_plotname = str_path+'obs_and_sky_and_snr.ps'
  
  strarr_sky = readfilelinestoarr(str_filelist_sky)
  strarr_obj = readfilelinestoarr(str_filelist_obj)
  strarr_obsnr = readfilelinestoarr(str_filelist_snr)

  xmin = 5886.8
  xmax = 5896.5
  ymin = 0.
  ymax = 1900.
  
  title = ' '
  xtitle = 'Row'
  ytitle = 'Counts [ADUs] + C'
  
  set_plot,'ps'
  device,filename=str_plotname,/color
   for i=0ul, n_elements(strarr_obj)-1 do begin
     dblarr_data = double(readfiletostrarr(str_path+strarr_obj(i),' '))
     if i eq 0 then $
       dblarr_data(*,1) = dblarr_data(*,1) * 3.4
;     print,dblarr_data(*,0)
;     stop
     if i eq 0 then begin
       plot,dblarr_data(*,0),$
            dblarr_data(*,1),$
            position=[0.115,0.6,0.995,0.995],$
            title=title,$
            ytitle=ytitle,$
            charsize=1.1,$
            xstyle=1,$
            ystyle=1,$
            xrange=[xmin,xmax],$
            yrange=[ymin,ymax],$
;            xticks=1,$
            xtickname=[' ',' ',' ',' ',' '],$
;            ytickformat='(F9.0)',$
            color=0,$
            charthick=2;,yticks=4,xtickformat='(F9.2)'
       loadct,13
       oplot,dblarr_data(*,0),dblarr_data(*,1),color=1,thick=3
       oplot,[5887.1,5887.5],[500,500],color=1,thick=3.
            
     end else begin
       oplot,dblarr_data(*,0),$
             dblarr_data(*,1)+i*200.,$
             color = 180 * i / n_elements(strarr_obj),thick=3;
       if i eq 1 then begin
         oplot,[5887.1,5887.5],[250.,250.],color = 180 * i / n_elements(strarr_obj),thick=3.
       end else if i eq 2 then begin
         oplot,[5891.1,5891.5],[500.,500.],color = 180 * i / n_elements(strarr_obj),thick=3.
       end else begin
         oplot,[5891.1,5891.5],[250.,250.],color = 180 * i / n_elements(strarr_obj),thick=3.
       endelse
     endelse
     ; --- plot legend
     xyouts,5887.55,450.,'UVES pipeline * Norm'
     xyouts,5887.55,200.,'P&V original implementation'
     xyouts,5891.55,450.,'P&V our re-implementation'
     xyouts,5891.55,200.,'Our new algorithm'
     
     
;     loadct,0
;     oplot,[
     
   endfor
   
   ytitle = 'Sky [ADUs] + C'
   ymin = 0.
   ymax = 95.
   
   for i=0ul, n_elements(strarr_sky)-1 do begin
     dblarr_data = double(readfiletostrarr(str_path+strarr_sky(i),' '))
     if i eq 0 then $
       dblarr_data(*,1) = dblarr_data(*,1) / 2.
     if i eq 0 then begin
       plot,dblarr_data(*,0),$
            dblarr_data(*,1),$
            position=[0.115,0.3,0.995,0.6],$
            title=title,$
            ytitle=ytitle,$
            charsize=1.1,$
            xstyle=1,$
            ystyle=1,$
            xrange=[xmin,xmax],$
            yrange=[ymin,ymax],$
;            xticks=1,$
            xtickname=[' ',' ',' ',' ',' '],$
;            ytickformat='(F9.0)',$
            color=0,$
            /NOERASE,$
            charthick=2;,yticks=4,xtickformat='(F9.2)',thick=3.
            
     end else begin
       oplot,dblarr_data(*,0),$
             dblarr_data(*,1) + i*15.,$
             color = 230 * i / n_elements(strarr_obj),$
             thick=3.;
     endelse
   endfor
   
   ytitle = 'SNR'
   ymin = 0.
   ymax = 34.
   
   for i=0ul, n_elements(strarr_obsnr)-1 do begin
     dblarr_data = double(readfiletostrarr(str_path+strarr_obsnr(i),' '))
     if i eq 0 then begin
       plot,dblarr_data(*,0),$
            dblarr_data(*,1),$
            position=[0.115,0.10,0.995,0.3],$
            title=title,$
            ytitle=ytitle,$
            charsize=1.1,$
            xstyle=1,$
            ystyle=1,$
            xrange=[xmin,xmax],$
            yrange=[ymin,ymax],$
;            xticks=1,$
;            xtickname=[' ',' '],$
;            yticks=7,$
;            ytickname=['0',' ','10',' ','20',' ','30',' '],$
;            ytickformat='(F9.0)',$
            ytickinterval=10,$
            color=0,$
            xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
            /NOERASE,$
            charthick=2;,yticks=4,xtickformat='(F9.2)',thick=3.
            
     end else begin
       oplot,dblarr_data(*,0),$
             dblarr_data(*,1),$
             color = 230 * i / n_elements(strarr_obj),thick=3.;
     endelse
   endfor
  device,/close
  set_plot,'x'
  
  spawn,'epstopdf '+str_plotname  
  
end
