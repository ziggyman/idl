pro sedm_plot_scattered_light
  str_filelist_in = '/home/azuri/spectra/SEDIFU/commissioning/June20/BD332642_360s_ifu20130619_22_36_02/to_plot_scattered_light.text'
  
  str_path = strmid(str_filelist_in,0,strpos(str_filelist_in,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'
  strlist_in = readfilelinestoarr(str_filelist_in)
  
  set_plot,'ps'
  for i=0ul, n_elements(strlist_in)-1 do begin
    str_plotname_root = str_path+strmid(strlist_in(i),0,strpos(strlist_in(i),'.',/REVERSE_SEARCH))
    print,'str_plotname_root = <'+str_plotname_root+'>'
    dblarr_data = double(readfiletostrarr(str_path+strlist_in(i),' '))
    if i eq 0 then begin
      max_dblarr_data = max(dblarr_data)
      dblarr_x = lindgen(1001)+680
      dblarr_y = lindgen(1001)+400
    end else begin
      dblarr_x = lindgen(2048)
      dblarr_y = lindgen(2048)
    endelse
    device,filename=str_plotname_root+'.ps'
     shade_surf,dblarr_data,$
                dblarr_x,$
                dblarr_y,$
                xrange=[0,2047],$
                yrange=[0,2047],$
                zrange=[0,max_dblarr_data]
    device,/close
    print,str_plotname_root+'.ps written'
  endfor
  set_plot,'x'
end
