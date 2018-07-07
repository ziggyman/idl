pro fit_siblings_data

  j=0
  for j=0,3 do begin
    if j eq 0 then begin
      str_datafile = '/home/azuri/daten/rave/rave_data/distances/d_pm_1.dat'
    end else if j eq 1 then begin
      str_datafile = '/home/azuri/daten/rave/rave_data/distances/d_pm_2.dat'
    end else if j eq 2 then begin
      str_datafile = '/home/azuri/daten/rave/rave_data/distances/d_pm_3.dat'
    end else begin
      str_datafile = '/home/azuri/daten/rave/rave_data/distances/d_pm_4.dat'
    end
    dblarr_data = readfiletodblarr(str_datafile)

    if j eq 0 then begin
      set_plot,'ps'
      str_filename = '/home/azuri/daten/rave/rave_data/distances/d_pm.ps'
      device,filename=str_filename,/color
      plot,dblarr_data(*,0),dblarr_data(*,1),/XLOG,/YLOG,xrange=[1.,11000.],yrange=[0.1,1000.],xstyle=1,ystyle=1,xtitle='d [pc]',ytitle='pm [mas/yr]',charsize=2,charthick=2,thick=2,position=[0.13,0.01,0.99,0.99]
      red = intarr(256)
      green = intarr(256)
      blue = intarr(256)
      red(0) = 0
      green(0) = 0
      blue(0) = 0
      red(1) = 255
      green(1) = 0
      blue(1) = 0
      ltab = 0
      modifyct,ltab,'black-red',red,green,blue,file='black_red.tbl'
      loadct,ltab,FILE='black_red.tbl'
    end; else begin
    oplot,dblarr_data(*,0),dblarr_data(*,1),color=1
;    end
;    dblarr_polyfit_coeffs = poly_fit(dblarr_data(*,0),dblarr_data(*,1),3)

;    dblarr_x = dblarr(100000)
;    for i=0ul,99999 do begin
;      dblarr_x(i) = i/10.
;  endfor
;  calc_values_from_polyfit_coeffs,DBLARR_DATA=dblarr_x,DBLARR_COEFFS=dblarr_polyfit_coeffs,DBLARR_OUT=dblarr_data_fit

;  oplot,dblarr_x,dblarr_data_fit
  end
  device,/close
  set_plot,'x'
  spawn,'ps2gif '+str_filename+' '+strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.gif'
  spawn,'giftrans -t \#ffffff '+strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'.gif > '+strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_trans.gif'
end
