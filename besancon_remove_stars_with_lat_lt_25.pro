pro besancon_remove_stars_with_lat_lt_25
  int_mode = 2; 0... Besancon
              ; 1... RAVE IDR8
              ; 2... RAVE IC2

  if int_mode eq 0 then begin
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat'
    int_col_lon = 0
    int_col_lat = 1
  end else if int_mode eq 1 then begin
    str_file_besancon = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all.dat'
    int_col_lon = 5
    int_col_lat = 6
  end else begin
    str_file_besancon = '/home/azuri/daten/rave/input_catalogue/rave_input_lon_lat.dat'
    int_col_lon = 1
    int_col_lat = 2
  endelse
  str_file_out = strmid(str_file_besancon,0,strpos(str_file_besancon,'.',/REVERSE_SEARCH))+'_IbI-ge-25.dat'

  strarr_data = readfiletostrarr(str_file_besancon, ' ', HEADER=strarr_header)
  dblarr_lon = double(strarr_data(*,int_col_lon))
  dblarr_lat = double(strarr_data(*,int_col_lat))
  strarr_data = 0
  strarr_data = readfilelinestoarr(str_file_besancon, STR_DONT_READ='#')
  indarr = where(abs(dblarr_lat) ge 25., int_count)
  print,'n_elements(indarr) = ',int_count

  set_plot,'ps'
  device,filename=strmid(str_file_out,0,strpos(str_file_out,'.',/REVERSE_SEARCH))+'.ps'
  plot,dblarr_lon(indarr),$
       dblarr_lat(indarr),$
       psym=2,$
       symsize=0.1,$
       xrange=[0.,360.],$
       yrange=[-90.,90.],$
       xstyle=1,$
       ystyle=1,$
       xtitle='Galactic Longitude [deg]',$
       ytitle='Galactic Latitude [deg]',$
       yticks=4,$
       ytickformat='(I3)',$
       xticks=4,$
       xtickformat='(I3)',$
       position = [0.16, 0.16, 0.96,0.99],$
       charsize=1.8,$
       thick=3.,$
       charthick=3.
  openw,lun,str_file_out,/GET_LUN
    if n_elements(strarr_header) gt 0 then begin
      for i=0ul, n_elements(strarr_header)-1 do begin
        printf,lun,strarr_header(i)
      endfor
    endif
    for i=0ul, int_count-1 do begin
      printf,lun,strarr_data(indarr(i))
      if i lt 10 then $
        print,'i = ',i,': dblarr_lat(indarr(i)) = ',dblarr_lat(indarr(i))
    endfor
  free_lun,lun
  print,'file <'+str_file_out+'> written'
  device,/close

  indarr = 0
  dblarr_lon = 0
  dblarr_lat = 0
  strarr_data = 0
end
