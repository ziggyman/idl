pro rave_remove_ic2_from_ic1
  str_filename_ic1 = '/home/azuri/daten/rave/input_catalogue/ric1+2_lon_lat.dat'
  str_filename_ic2 = '/home/azuri/daten/rave/input_catalogue/rave_input_lon_lat.dat'

  strarr_ic1 = readfiletostrarr(str_filename_ic1,' ')
  strarr_ic1_lines = readfilelinestoarr(str_filename_ic1,STR_DONT_READ='#')
  dblarr_lon_ic1 = double(strarr_ic1(*,1))
  dblarr_lat_ic1 = double(strarr_ic1(*,2))

  strarr_ic2 = readfiletostrarr(str_filename_ic2,' ')
  dblarr_lon_ic2 = double(strarr_ic2(*,1))
  dblarr_lat_ic2 = double(strarr_ic2(*,2))

  dbl_limit = 0.0014;0.0005
  int_nstars_found = 0ul
  openw,lun,strmid(str_filename_ic1,0,strpos(str_filename_ic1,'.',/REVERSE_SEARCH))+'_minus-ic2.dat',/GET_LUN
  for i=0ul, n_elements(dblarr_lon_ic1)-1 do begin
    indarr_lon = where(abs(dblarr_lon_ic2 - dblarr_lon_ic1(i)) lt dbl_limit)
    if indarr_lon(0) ge 0 then begin
      indarr_lat = where(abs(dblarr_lat_ic2(indarr_lon) - dblarr_lat_ic1(i)) lt dbl_limit)
      if indarr_lat(0) lt 0 then begin
        printf,lun,strarr_ic1_lines(i)
      endif else begin
        int_nstars_found = int_nstars_found + 1
        print,'rave_remove_ic2_from_ic1: i = ',i,': found ',n_elements(indarr_lat),' entries in IC2:'
        print,'rave_remove_ic2_from_ic1:     d_lon = ',abs(dblarr_lon_ic2(indarr_lon(indarr_lat)) - dblarr_lon_ic1(i))
        print,'rave_remove_ic2_from_ic1:     d_lat = ',abs(dblarr_lat_ic2(indarr_lon(indarr_lat)) - dblarr_lat_ic1(i))
        print,strarr_ic2(indarr_lon(indarr_lat),0)
      endelse
    end else begin
      printf,lun,strarr_ic1_lines(i)
    end
  endfor
  free_lun,lun
  print,int_nstars_found,' stars found in both catalogues'

  ; --- clean up
  strarr_ic1 = 0
  strarr_ic1_lines = 0
  strarr_ic2 = 0
  dblarr_lon_ic1 = 0
  dblarr_lat_ic1 = 0
  dblarr_lon_ic2 = 0
  dblarr_lat_ic2 = 0
end
