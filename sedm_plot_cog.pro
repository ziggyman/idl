pro sedm_plot_cog
  str_path = '/home/azuri/spectra/SEDIFU/commissioning/Aug08/'
  str_objlist = str_path + 'cog_objects.list'
  str_extwidth_list = str_path+'cog_extraction_widths.list'
  
  strlist_objects = readfilelinestoarr(str_objlist)
  strlist_extwidth_paths = readfilelinestoarr(str_extwidth_list)
  
  for k=0,2 do begin
    for i=0ul, n_elements(strlist_objects)-1 do begin
      dbl_ymax = 0.
      for j=0ul, n_elements(strlist_extwidth_paths)-1 do begin
        if k eq 0 then begin
          dblarr_plot = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum.text')
        end else if k eq 1 then begin
          dblarr_plot = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum_Flux.text')
        end else begin
          dblarr_sky = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_SkyMedian.text')
          dblarr_plot(*,1) = dblarr_sky
        endelse
        if dbl_ymax lt max(dblarr_plot(*,1)) then $
          dbl_ymax = max(dblarr_plot(*,1))
      endfor
      for j=0ul, n_elements(strlist_extwidth_paths)-1 do begin
        str_extraction_width = strmid(strlist_extwidth_paths(j), strlen(strlist_extwidth_paths(j))-5, 3)
        print,'i=',i,', j=',j,': str_extraction_width = <'+str_extraction_width+'>'
        if k eq 0 then begin
          dblarr_obs = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum.text')
          print,'dblarr_obs(*,0) = ',dblarr_obs(*,0)
          dblarr_plot = dblarr_obs
          str_plotname = str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum.ps'
          str_title = strlist_objects(i)+'EcDR_Obs-Sky_Sum'
          str_ytitle = 'Counts [photons]'
        end else if k eq 1 then begin
          dblarr_obs = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum_Flux.text')
          print,'dblarr_obs(*,0) = ',dblarr_obs(*,0)
          dblarr_plot = dblarr_obs
          str_plotname = str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_Obs-Sky_Sum_Flux.ps'
          str_title = strlist_objects(i)+'EcDR_Obs-Sky_Sum_Flux'
          str_ytitle = 'Flux [ergs/Ang/s/cm^2]'
        end else begin
          dblarr_sky = readfiletodblarr(str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_SkyMedian.text')
          print,'dblarr_sky = ',dblarr_sky
          print,'n_elements(dblarr_plot(*,1)) = ',n_elements(dblarr_plot(*,1))
          print,'n_elements(dblarr_sky) = ',n_elements(dblarr_sky)
          dblarr_plot(*,1) = dblarr_sky
          str_plotname = str_path+strlist_extwidth_paths(j)+'/'+strlist_objects(i)+'/'+strlist_objects(i)+'EcDR_SkyMedian.ps'
          str_title = strlist_objects(i)+'EcDR_SkyMedian'
          str_ytitle = 'Counts [photons]'
        endelse
        print,'i = ',i,', = ',j,', k = ',k,': str_plotname = <'+str_plotname+'>'
        print,'i = ',i,', = ',j,', k = ',k,': str_title = <'+str_title+'>'
        if j eq 0 then begin
          set_plot,'ps'
          device,filename=str_plotname,/color
          plot,dblarr_plot(*,0),$
               dblarr_plot(*,1),$
               color = 1,$
               xtitle = 'Wavelength [Ang]',$
               ytitle = str_ytitle,$
               xrange = [min(dblarr_plot(*,0)), max(dblarr_plot(*,0))],$
               xstyle = 1,$
               yrange = [0.,dbl_ymax*1.1],$
               ystyle = 1,$
               title = str_title,$
               position=[0.15,0.10,0.98,0.95]
          loadct,13
          oplot,dblarr_plot(*,0),$
                dblarr_plot(*,1),$
                color=1
        end else begin
          oplot,dblarr_plot(*,0),$
                dblarr_plot(*,1),$
                color=253 * j / n_elements(strlist_extwidth_paths) + 1
        endelse
        oplot,[7000,7300],$
              [dbl_ymax-(j*dbl_ymax/20.),dbl_ymax-(j*dbl_ymax/20.)],$
              color=253 * j / n_elements(strlist_extwidth_paths) + 1
        xyouts,7400,dbl_ymax-(j*dbl_ymax/20.)-dbl_ymax/80.,str_extraction_width+' pixels extraction radius'
      
        if j eq n_elements(strlist_extwidth_paths)-1 then begin
          device,/close
          set_plot,'x'
        endif
      endfor
    endfor
  endfor
end
