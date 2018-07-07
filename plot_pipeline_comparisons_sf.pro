pro plot_pipeline_comparisons_sf
  str_path = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/'
  str_filelist = str_path+'to_compare_piskunov_sf_text.list'
  strarr_files = readfilelinestoarr(str_filelist)
  print,'strarr_files = ',strarr_files
  
  str_plotname=strmid(str_filelist,0,strpos(str_filelist,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
    device,filename=str_plotname,/color
      for i=0ul, n_elements(strarr_files)-1 do begin
        dblarr_data = double(readfiletostrarr(str_path+strarr_files(i), ' '))
        if i eq 0 then begin
          dblarr_rev = dblarr(n_elements(dblarr_data))
          for j=0ul, n_elements(dblarr_data)-1 do begin
            dblarr_rev(j) = dblarr_data(n_elements(dblarr_data)-j-1)
          endfor
          indarr = lindgen(n_elements(dblarr_rev))
          plot,indarr-130,$
               dblarr_rev,$
               xtitle = 'Relative sub-pixel number',$
               ytitle='Spatial profile'
        end else begin
          if i eq 1 then begin; or i eq 2 then begin
            dblarr_data = dblarr_data(*,1)
          endif
          oplot,dblarr_data,$
                color = 255 * i / n_elements(strarr_files)
        endelse
      endfor
    device,/close
  set_plot,'x'
end
