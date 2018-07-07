pro rave_plot_ic1

  str_ic_root = '/home/azuri/daten/rave/input_catalogue/ric'

  for i=0,1 do begin
    if i eq 0 then begin
      str_filename = str_ic_root+'1.dat'
    end else begin
      str_filename = str_ic_root+'2.dat'
    end
    strarr_ic = readfiletostrarr(str_filename,' ')
    dblarr_ra_hour = double(strarr_ic(*,1))
    dblarr_ra_min = double(strarr_ic(*,2))
    dblarr_ra_sec = double(strarr_ic(*,3))
    dblarr_dec_deg = double(strarr_ic(*,4))
    dblarr_dec_arcmin = double(strarr_ic(*,5))
    dblarr_dec_arcsec = double(strarr_ic(*,6))
    dblarr_ra = 360.*dblarr_ra_hour/24. + 15.*dblarr_ra_min/60. + 15.*dblarr_ra_sec/3600.
    dblarr_dec = dblarr_dec_deg + dblarr_dec_arcmin/60. + dblarr_dec_arcsec/3600.
    euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,1
    openw,lun,strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_lon_lat.dat',/GET_LUN
      for j=0ul,n_elements(dblarr_ra)-1 do begin
        printf,lun,strarr_ic(j,0)+' '+string(dblarr_lon(j),FORMAT='(F15.6)')+' '+string(dblarr_lat(j),FORMAT='(F15.6)')+' '+strarr_ic(j,7)+' '+strarr_ic(j,8)+' '+strarr_ic(j,9)+' '+strarr_ic(j,10)+' '+strarr_ic(j,11)
      endfor
    free_lun,lun

    set_plot,'ps'
      device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.ps'
        plot,dblarr_lon,$
             dblarr_lat,$
             psym=2,$
             symsize=0.05,$
             xtitle='Longitude [deg]',$
             ytitle='Latitude [deg]',$
             charsize=2.,$
             charthick=3.,$
             thick=3.
      device,/close
    set_plot,'x'
    if i eq 0 then begin
      strarr_ic1 = strarr_ic
      dblarr_lon1 = dblarr_lon
      dblarr_lat1 = dblarr_lat
    end else begin
      strarr_ic2 = strarr_ic
      dblarr_lon2 = dblarr_lon
      dblarr_lat2 = dblarr_lat
    end
  endfor
  dblarr_lon = [dblarr_lon1,dblarr_lon2]
  dblarr_lat = [dblarr_lat1,dblarr_lat2]
  strarr_ic = [strarr_ic1,strarr_ic2]
  set_plot,'ps'
    device,filename=strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH)-1)+'1+2.ps'
      plot,dblarr_lon,$
           dblarr_lat,$
           psym=2,$
           symsize=0.05,$
           xtitle='Longitude [deg]',$
           ytitle='Latitude [deg]',$
           charsize=2.,$
           charthick=3.,$
           thick=3.
    device,/close
  set_plot,'x'
  openw,lun,strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH)-1)+'1+2_lon_lat.dat',/GET_LUN
    for j=0ul,n_elements(dblarr_lon)-1 do begin
        printf,lun,strarr_ic(j,0)+' '+string(dblarr_lon(j),FORMAT='(F15.6)')+' '+string(dblarr_lat(j),FORMAT='(F15.6)')+' '+strarr_ic(j,7)+' '+strarr_ic(j,8)+' '+strarr_ic(j,9)+' '+strarr_ic(j,10)+' '+strarr_ic(j,11)
    endfor
  free_lun,lun
end
