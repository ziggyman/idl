pro create_rave_html_maps
  for j=0, 1 do begin
    if j eq 0 then begin
     str_fieldsfile = '/home/azuri/daten/rave/rave_data/fields_lon_lat_small_new-5x5_new.dat'
     str_map_out = '/home/azuri/daten/rave/rave_data/map_5x5.html'
    end else begin
     str_fieldsfile = '/home/azuri/daten/rave/rave_data/fields_lon_lat_small_new-10x10.dat'
     str_map_out = '/home/azuri/daten/rave/rave_data/map_10x10.html'
    endelse
     i_size_x = 520
     i_size_y = 373
     
     i_data_x_ll = 87
     i_data_y_ll = 307
     i_data_x_ur = 493
     i_data_y_ur = 10
     
     d_lon_ll = 0.
     d_lat_ll = -90.
     d_lon_ur = 360.
     d_lat_ur = 90.
     
     strarr_data = readfiletostrarr(str_fieldsfile, ' ')
     dblarr_lon_min = double(strarr_data(*,0))
     dblarr_lon_max = double(strarr_data(*,1))
     dblarr_lat_min = double(strarr_data(*,2))
     dblarr_lat_max = double(strarr_data(*,3))
     
     openw,lun,str_map_out,/GET_LUN
     printf,lun,'<map name="pixelmap">'
     for i=0ul, n_elements(dblarr_lat_max)-1 do begin
        i_x0 = long(double(i_data_x_ll) + ((double(i_data_x_ur) - double(i_data_x_ll)) * dblarr_lon_min(i) / 360.)) + 1
        i_x1 = long(double(i_data_x_ll) + ((double(i_data_x_ur) - double(i_data_x_ll)) * dblarr_lon_max(i) / 360.))
        i_y0 = long(double(i_data_y_ll) - ((double(i_data_y_ll) - double(i_data_y_ur)) * (90. + dblarr_lat_max(i)) / 180.)) + 1
        i_y1 = long(double(i_data_y_ll) - ((double(i_data_y_ll) - double(i_data_y_ur)) * (90. + dblarr_lat_min(i)) / 180.))
        
        printf,lun,'<area shape="rect" coords="'+strtrim(string(i_x0),2)+','+strtrim(string(i_y0),2)+','+strtrim(string(i_x1),2)+','+strtrim(string(i_y1),2)+'" href="#'+strmid(strtrim(string(strarr_data(i,0)),2),0,strpos(strtrim(string(strarr_data(i,0)),2),'.',/REVERSE_SEARCH)+3)+$
               '-'+$
               strmid(strtrim(string(strarr_data(i,1)),2),0,strpos(strtrim(string(strarr_data(i,1)),2),'.',/REVERSE_SEARCH)+3)+$
               '_'+$
               strmid(strtrim(string(strarr_data(i,2)),2),0,strpos(strtrim(string(strarr_data(i,2)),2),'.',/REVERSE_SEARCH)+3)+$
               '-'+$
               strmid(strtrim(string(strarr_data(i,3)),2),0,strpos(strtrim(string(strarr_data(i,3)),2),'.',/REVERSE_SEARCH)+3)+'" alt="" />'
     endfor
     printf,lun,'</map>'
     free_lun,lun
  endfor
end
