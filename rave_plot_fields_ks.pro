pro rave_plot_fields_ks,dblarr_fields,$
                        str_plotname,$
                        STRARR_RAVE_STARS=strarr_rave_stars,$
                        DBLARR_DATA=dblarr_data;,$

;
; NAME:                  rave_plot_fields_ks.pro
; PURPOSE:               plots the fields in the plot DEC over RA
; CATEGORY:              RAVE
; CALLING SEQUENCE:      rave_plot_fields_ks,dblarr_fields,strarr_meansigfiles,str_plotname
; INPUTS:                dblarr_fields: ra_min ra_max dec_min dec_max
;                           50.      56.      -40.     -34.
;                           60.      66.      -40.     -34.
;                           ...
;
;                        strarr_meansigfiles:
;                           /suphys/azuri/daten/besancon/html/170-176_-36--30/mean_sigma_x_y.dat
;                           #data mean_x sigma_x mean_y sigma_y
;                           RAVE 10.641695 0.68141373 1.9085837 30.295611
;                           BESANCON 11.018198 0.64533457 -2.2121607 29.830943
;                           ...
;
;                        str_plotname: name of output file
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  03.01.2008
;
;                        headline
;                        feetline (up to now not used)
;
  if keyword_set(STRARR_RAVE_STARS) then $
    print,'rave_plot_fields_ks: Keyword DATAARR set'

  if n_elements(str_plotname) eq 0 then begin
    print,'rave_plot_fields_ks: ERROR: not enough parameters specified!'
    print,'USAGE: rave_plot_fields_ks,(dblarr)dblarr_fields,(string)strarr_meansigfiles,(string)str_plotname'
    return
  end
  i_nfields = n_elements(dblarr_fields) / 4
  int_dblarr_data_size = n_elements(dblarr_data)
  print,'rave_plot_fields_ks: int_dblarr_data_size = ',int_dblarr_data_size
  if (i_nfields ne int_dblarr_data_size) then begin
    print,'rave_plot_fields_ks: ERROR: i_nfields(=',i_nfields,', size=',size(dblarr_fields),') != int_dblarr_data_size(=',int_dblarr_data_size,')'
    return
  end
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 254 do begin
    red(l) = 255-l;60 - (2*l)
    green(l) = l
    blue(l) = 0
  endfor
  red(255) = 100
  green(255) = 100
  blue(255) = 255
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_kst.tbl'

  print,'rave_plot_fields_ks: creating str_plotname='+str_plotname
  set_plot,'ps'
  device,filename=str_plotname,/color
  loadct,0
  dblarr_longitude = double(strarr_rave_stars(*,0))
  dblarr_latitude = double(strarr_rave_stars(*,1))
  xtitle = 'Galactic Longitude [deg]'
  ytitle = 'Galactic Latitude [deg]'
;  plot,dblarr_longitude,$
;       dblarr_latitude,$
  plot,dblarr_longitude(0:1),$
       dblarr_latitude(0:1),$
       psym=2,$
       symsize=0.1,$
       xrange=[0,360],$
       yrange=[-90,90],$
       xtitle=xtitle,$
       ytitle=ytitle,$
       xstyle=1,$
       ystyle=1,$
       position=[0.16,0.164,0.85,0.99],$;[0.16,0.16,0.99,0.99],$
       thick=3.,$
       yticks=4,$
       yminor=9,$
       xticks=4,$
       xtickinterval=90.,$
       xminor=9,$
       xtickname=['0','90','180','270','360'],$
       xtickformat='(I3)',$
       charthick=3.,$
       charsize=1.8
  dblarr_longitude = 0
  dblarr_latitude = 0
  loadct,ltab,FILE='colors1_kst.tbl'
  for i=0UL, i_nfields-1 do begin
    b_plot = 1
    colorx = 0
    if abs(dblarr_data(i) + 1.) lt 0.0001 then begin
      colorx = 0
      b_plot = 0
      print,'colorx = ',colorx,', b_plot = ',b_plot
    end else begin
      print,'rave_plot_fields_ks: dblarr_data(',i,') = ',dblarr_data(i)
      colorx = long(dblarr_data(i) * 254.)
    end
    print,'rave_plot_fields_ks: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
    if b_plot eq 1 then begin
      print,'rave_plot_fields_ks: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
      box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colorx
    end
  endfor
  for i=0,100 do begin
    xa = 360.
    xb = 370.
    ya = 90.-(180.*i/101.)
    yb = 90.-(180.*(i+1)/101.)
    colorxy = long(254. - 254.*(double(i)/100.))
    box,xa,ya,xb,yb,colorxy
  endfor
  xyouts,372.,$
         83.,$
         '1',$
         charsize=1.6,$
         charthick=4,$
         color=1
  xyouts,372.,$
         -90.,$
         '0',$
         charsize=1.6,$
         charthick=4,$
         color=1

  dbl_xcoord = 360.+(360.) / 25.
  xyouts,dbl_xcoord + (360.) / 25.,$
         0.,$
         'KS probability',$
         charsize=1.6,$
         charthick = 4.,$
         alignment = 0.5,$
         orientation = 90.,$
         color=1


  device,/close
  set_plot,'x'
end
