pro plot_paper_sn
  str_path = '/home/azuri/spectra/wiserep/'
  str_filename = str_path+'fname_type.list'
  strlist_fname_name = readfiletostrarr(str_filename,' ')
  strlist_fname_name(*,0) = str_path+strlist_fname_name(*,0)
  print,'strlist_fname_name = ',strlist_fname_name
  
  set_plot,'ps'
  str_plotname=str_path+'spectra_sn.ps'
  device,filename=str_plotname,/color

  xrange=[3500., 9000.]
  yrange=[0.00001, 1000.]
  
  dbl_x1000_0=xrange(0)
  dbl_x1000_end = dbl_x1000_0 + dbl_x1000_0/2000.
  i_r1000_nelem = 1
  while dbl_x1000_end lt xrange(1) do begin
    i_r1000_nelem = i_r1000_nelem+1
    dbl_x1000_end = dbl_x1000_end + dbl_x1000_end/1000.
  endwhile
  print,'i_r1000_nelem = ',i_r1000_nelem,': dbl_x1000_end = ',dbl_x1000_end
  dblarr_r1000_x = dblarr(i_r1000_nelem)
  dblarr_r1000_y = dblarr(i_r1000_nelem)
  dblarr_r1000_x(0) = dbl_x1000_0 + dbl_x1000_0/2000.
  i_x = 0
  while i_x lt i_r1000_nelem-1 do begin
    i_x = i_x+1
    dblarr_r1000_x(i_x) = dblarr_r1000_x(i_x-1) + dblarr_r1000_x(i_x-1)/1000.
  endwhile
  print,'dblarr_r1000_x = ',size(dblarr_r1000_x),': ',dblarr_r1000_x
  
  dbl_x100_0=xrange(0)
  dbl_x100_end = dbl_x100_0 + dbl_x100_0/200.
  i_r100_nelem = 1
  while dbl_x100_end lt xrange(1) do begin
    i_r100_nelem = i_r100_nelem+1
    dbl_x100_end = dbl_x100_end + dbl_x100_end/100.
  endwhile
  print,'i_r100_nelem = ',i_r100_nelem,': dbl_x100_end = ',dbl_x100_end
  dblarr_r100_x = dblarr(i_r100_nelem)
  dblarr_r100_y = dblarr(i_r100_nelem)
  dblarr_r100_x(0) = dbl_x100_0 + dbl_x100_0/200.
  i_x = 0
  while i_x lt i_r100_nelem-1 do begin
    i_x = i_x+1
    dblarr_r100_x(i_x) = dblarr_r100_x(i_x-1) + dblarr_r100_x(i_x-1)/100.
  endwhile
  print,'dblarr_r100_x = ',size(dblarr_r100_x),': ',dblarr_r100_x
  
;  stop
  for i=0ul, n_elements(strlist_fname_name(*,0))-1 do begin
    strarr_data = readfiletostrarr(strlist_fname_name(i,0),' ')
    print,'i=',i,': strarr_data = ',size(strarr_data),': ',strarr_data
    print,' '
    print,' '
    print,' '
    print,' '
    print,'strarr_data(*,0) = ',strarr_data(*,0)
    print,'strarr_data(1,0) = ',strarr_data(1,0)
    print,'strarr_data(*,1) = ',strarr_data(*,1)
    print,'strarr_data(0,*) = ',strarr_data(0,*)
    print,'strarr_data(1,*) = ',strarr_data(1,*)
    dblarr_data = double(strarr_data)
    print,'i=',i,': dblarr_data = ',dblarr_data
    for i_y=1ul, i_r1000_nelem-2 do begin
      dbl_xa=dblarr_r1000_x(i_y-1)
      dbl_xb=dblarr_r1000_x(i_y+1)
      if (dbl_xb lt dblarr_data(0,0)) or (dbl_xa gt dblarr_data(n_elements(dblarr_data(*,0))-1)) then begin
        dblarr_r1000_y(i_y) = -1.
      end else begin
;        print,'i_y = ',i_y,': dbl_xa = ',dbl_xa,', dbl_xb = ',dbl_xb
        indarr = where((dblarr_data(*,0) gt dbl_xa) and (dblarr_data(*,0) lt dbl_xb))
        if indarr(0) lt 0 then begin
          dblarr_int_x = [dbl_xa, dbl_xb]
        end else begin
          dblarr_int_x = [dbl_xa, dblarr_data(indarr,0), dbl_xb]
        endelse
;        dblarr_temp_x = dblarr_data(indarr, 0)
;        dblarr_temp_y = dblarr_data(indarr, 1)
        dbl_xa=dblarr_r1000_x(i_y) - (dblarr_r1000_x(i_y)-dblarr_r1000_x(i_y-1))/2.
        dbl_xb=dblarr_r1000_x(i_y) + (dblarr_r1000_x(i_y+1)-dblarr_r1000_x(i_y))/2.

;        dblarr_int_x = dblarr_temp_x
;        print,'i_y = ',i_y,': dblarr_temp_x = ',dblarr_temp_x
;        print,'i_y = ',i_y,': dblarr_temp_y = ',dblarr_temp_y
;        print,'i_y=',i_y,': dblarr_int_x = ',dblarr_int_x
        dblarr_int_y = interpol(dblarr_data(*,1), dblarr_data(*,0), dblarr_int_x)
;        print,'i_y=',i_y,': dblarr_int_y = ',dblarr_int_y
        dblarr_r1000_y(i_y) = int_tabulated(dblarr_int_x, dblarr_int_y)
        if dblarr_r1000_y(i_y) lt 0 then begin
          print,'i_y=',i_y,': dbl_xa = ',dbl_xa,', dbl_xb = ',dbl_xb,', dblarr_data(0,0) = ',dblarr_data(0,0)
          print,'i_y=',i_y,': dblarr_int_x = ',dblarr_int_x
          print,'i_y=',i_y,': dblarr_int_y = ',dblarr_int_y
        endif
      endelse
    endfor
;    print,'dblarr_r1000_y = ',dblarr_r1000_y
    dblarr_tr1000_x = dblarr_r1000_x(1:n_elements(dblarr_r1000_x)-2)
    dblarr_tr1000_y = dblarr_r1000_y(1:n_elements(dblarr_r1000_y)-2)
;    print,'dblarr_r1000_x = ',size(dblarr_r1000_x)
;    print,'dblarr_r1000_y = ',size(dblarr_r1000_y)
    
;    dblarr_tr1000_x = dblarr_data(where(dblarr_data(*,0) ge dblarr_temp_x(0)), 0)
;    dblarr_tr1000_x = dblarr_tr1000_x(where(dblarr_tr1000_x le dblarr_temp_x(n_elements(dblarr_temp_x)-1)))
;    dblarr_tr1000_y = dblarr_data(where(dblarr_data(*,0) ge dblarr_temp_x(0)), 1)
;    dblarr_tr1000_y = dblarr_tr1000_y(where(dblarr_tr1000_x le dblarr_temp_x(n_elements(dblarr_temp_x)-1)))
    dblarr_tr1000_x = dblarr_tr1000_x(where(dblarr_tr1000_y gt 0.))
    dblarr_tr1000_y = dblarr_tr1000_y(where(dblarr_tr1000_y gt 0.))
    print,'dblarr_tr1000_x = ',dblarr_tr1000_x
    print,'dblarr_tr1000_y = ',dblarr_tr1000_y
;if i eq 3 then begin
;  device,/close
;  stop
;endif
    if i eq 0 then begin
      plot,xrange,$
           [yrange(0),yrange(0)],$
           xrange=xrange,$
           yrange=yrange,$
           xstyle=1,$
           ystyle=1,$
           /ylog,$
           thick=3,$
           charsize=1.5,$
           charthick=3,$
           xtitle = 'Wavelength ['+STRING("305B)+']',$
           ytitle = 'Scaled Flux [erg s!E-1!N cm!E-2!N '+STRING("305B)+'!E-1!N]',$
           position=[0.134,0.13,0.96,0.995]
    end
    print,'dblarr_tr1000_y = ',dblarr_tr1000_y
    if max(dblarr_tr1000_y) lt 10e-10 then begin
      dblarr_tr1000_y=dblarr_tr1000_y * 1000000.
      print,'dblarr_tr1000_y multiplied by 1000000.'
;      stop
    endif
    print,'dblarr_tr1000_y = ',dblarr_tr1000_y
    dbl_mean = mean(dblarr_tr1000_y,/DOUBLE)
    print,'i_y = dbl_mean = ',dbl_mean
    if dbl_mean lt 0 then begin
      stop
    endif
    dbl_fac = 0.0001 * 10.^double(i)
    print,'i=',i,': dbl_fac = ',dbl_fac
    dblarr_tr1000_y = dblarr_tr1000_y * dbl_fac
    print,'dblarr_tr1000_y = ',dblarr_tr1000_y
    dblarr_tr1000_y = dblarr_tr1000_y / dbl_mean
    print,'dblarr_tr1000_y = ',dblarr_tr1000_y
    if min(dblarr_tr1000_y) lt 0 then begin
      stop
    endif
    oplot,dblarr_tr1000_x,$
          dblarr_tr1000_y,$
          color=150,$
          thick=8
          
    b_do = 1
    
    if b_do eq 1 then begin
    
    for i_y=1ul, i_r100_nelem-2 do begin
      dbl_xa=dblarr_r100_x(i_y-1)
      dbl_xb=dblarr_r100_x(i_y+1)
      if (dbl_xb lt dblarr_data(0,0)) or (dbl_xa gt dblarr_data(n_elements(dblarr_data(*,0))-1)) then begin
        dblarr_r100_y(i_y) = -1.
      end else begin
;        print,'i_y = ',i_y,': dbl_xa = ',dbl_xa,', dbl_xb = ',dbl_xb
        indarr = where((dblarr_data(*,0) gt dbl_xa) and (dblarr_data(*,0) lt dbl_xb))
        if indarr(0) lt 0 then begin
          dblarr_int_x = [dbl_xa, dbl_xb]
        end else begin
          dblarr_int_x = [dbl_xa, dblarr_data(indarr,0), dbl_xb]
        endelse
;        dblarr_temp_x = dblarr_data(indarr, 0)
;        dblarr_temp_y = dblarr_data(indarr, 1)
        dbl_xa=dblarr_r100_x(i_y) - (dblarr_r100_x(i_y)-dblarr_r100_x(i_y-1))/2.
        dbl_xb=dblarr_r100_x(i_y) + (dblarr_r100_x(i_y+1)-dblarr_r100_x(i_y))/2.

;        dblarr_int_x = dblarr_temp_x
;        print,'i_y = ',i_y,': dblarr_temp_x = ',dblarr_temp_x
;        print,'i_y = ',i_y,': dblarr_temp_y = ',dblarr_temp_y
;        print,'i_y=',i_y,': dblarr_int_x = ',dblarr_int_x
        dblarr_int_y = interpol(dblarr_data(*,1), dblarr_data(*,0), dblarr_int_x)
;        print,'i_y=',i_y,': dblarr_int_y = ',dblarr_int_y
        dblarr_r100_y(i_y) = int_tabulated(dblarr_int_x, dblarr_int_y)
        if dblarr_r100_y(i_y) lt 0 then begin
          print,'i_y=',i_y,': dbl_xa = ',dbl_xa,', dbl_xb = ',dbl_xb,', dblarr_data(0,0) = ',dblarr_data(0,0)
          print,'i_y=',i_y,': dblarr_int_x = ',dblarr_int_x
          print,'i_y=',i_y,': dblarr_int_y = ',dblarr_int_y
        endif
      endelse
    endfor
;    print,'dblarr_r100_y = ',dblarr_r100_y
    dblarr_tr100_x = dblarr_r100_x(1:n_elements(dblarr_r100_x)-2)
    dblarr_tr100_y = dblarr_r100_y(1:n_elements(dblarr_r100_y)-2)
;    print,'dblarr_r100_x = ',size(dblarr_r100_x)
;    print,'dblarr_r100_y = ',size(dblarr_r100_y)
    
;    dblarr_tr100_x = dblarr_data(where(dblarr_data(*,0) ge dblarr_temp_x(0)), 0)
;    dblarr_tr100_x = dblarr_tr100_x(where(dblarr_tr100_x le dblarr_temp_x(n_elements(dblarr_temp_x)-1)))
;    dblarr_tr100_y = dblarr_data(where(dblarr_data(*,0) ge dblarr_temp_x(0)), 1)
;    dblarr_tr100_y = dblarr_tr100_y(where(dblarr_tr100_x le dblarr_temp_x(n_elements(dblarr_temp_x)-1)))
    dblarr_tr100_x = dblarr_tr100_x(where(dblarr_tr100_y gt 0.))
    dblarr_tr100_y = dblarr_tr100_y(where(dblarr_tr100_y gt 0.))
    print,'dblarr_tr100_x = ',dblarr_tr100_x
    print,'dblarr_tr100_y = ',dblarr_tr100_y
;if i eq 3 then begin
;  device,/close
;  stop
;endif
    print,'dblarr_tr100_y = ',dblarr_tr100_y
    if max(dblarr_tr100_y) lt 10e-10 then begin
      dblarr_tr100_y=dblarr_tr100_y * 1000000.
      print,'dblarr_tr100_y multiplied by 1000000.'
;      stop
    endif
    print,'dblarr_tr100_y = ',dblarr_tr100_y
    dbl_mean = mean(dblarr_tr100_y,/DOUBLE)
    print,'i_y = dbl_mean = ',dbl_mean
    if dbl_mean lt 0 then begin
      stop
    endif
    dbl_fac = 0.0001 * 10.^double(i)
    print,'i=',i,': dbl_fac = ',dbl_fac
    dblarr_tr100_y = dblarr_tr100_y * dbl_fac
    print,'dblarr_tr100_y = ',dblarr_tr100_y
    dblarr_tr100_y = dblarr_tr100_y / dbl_mean
    print,'dblarr_tr100_y = ',dblarr_tr100_y
    if min(dblarr_tr100_y) lt 0 then begin
      stop
    endif
    oplot,dblarr_tr100_x(1:n_elements(dblarr_tr100_x)-2),$
          dblarr_tr100_y(1:n_elements(dblarr_tr100_x)-2),$
          thick=3,$
          color=0
;    stop
    endif
;    if i eq 7 then begin
;      device,/close
;      stop
;    endif
  endfor

  for i=0ul, n_elements(strlist_fname_name(*,0))-1 do begin
    if i eq 0 then begin
      x_str = 4500.
      y_str = 0.00015
    end else if i eq 1 then begin
      x_str = 8000.
      y_str = 0.0007
    end else if i eq 2 then begin
      x_str = 8000.
      y_str = 0.008
    end else if i eq 3 then begin
      x_str = 4800.
      y_str = 0.1
    end else if i eq 4 then begin
      x_str = 6400.
      y_str = 1.5
    end else if i eq 5 then begin
      x_str = 5000.
      y_str = 15.
    end else if i eq 6 then begin
      x_str = 7500.
      y_str = 150.
    end
    str_type=strlist_fname_name(i,1)
    if i eq 5 then str_type = str_type+'-like'
    xyouts,x_str,y_str,str_type,charsize=1.4,charthick=3.

  endfor
  
  device,/close
  set_plot,'x'
end
