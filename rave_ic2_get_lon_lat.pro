pro rave_ic2_get_lon_lat

  str_filename = '/home/azuri/daten/rave/input_catalogue/rave_input.dat';_I2MASS.dat'

  strarr_ic = readfiletostrarr(str_filename,' ')
    dblarr_ra = double(strarr_ic(*,1))
    dblarr_dec = double(strarr_ic(*,2))
    euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,1
    openw,lun,strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_lon_lat.dat',/GET_LUN
      printf,lun,'#ID   lon   lat    P   9   I_2MASS   I_input   J_2MASS   K_2MASS    RA    DEC'
      for j=0ul,n_elements(dblarr_ra)-1 do begin
        printf,lun,strarr_ic(j,0)+' '+string(dblarr_lon(j),FORMAT='(F15.6)')+' '+string(dblarr_lat(j),FORMAT='(F15.6)')+' '+strarr_ic(j,3)+' '+strarr_ic(j,4)+' '+strarr_ic(j,5)+' '+strarr_ic(j,6)+' '+strarr_ic(j,7)+' '+strarr_ic(j,8)+' '+string(dblarr_ra(j),FORMAT='(F15.6)')+' '+string(dblarr_dec(j),FORMAT='(F15.6)')
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
end
