pro rave_plot_fields_observed,DBLARR_RAVEDATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                              DBLARR_BESANCONDATA=dblarr_besancondata,$    ; --- dblarr(*,3)
                               DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                               DBL_REJECT=dbl_reject,$      ; --- double
                               DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                               I_LON=i_lon,$                ; --- int
                               I_LAT=i_lat,$
                               I_DAT=i_dat,$
                               I_IMAG=i_imag,$
                               DBLARR_IRANGE=dblarr_irange,$
                               STR_PLOTNAME=str_plotname,$
                               DBL_MAXPERCENTAGE=dbl_maxpercentage
;
; NAME:                  rave_plot_fields_observed.pro
; PURPOSE:               plots the fields in the plot DEC over RA
; CATEGORY:              RAVE
; CALLING SEQUENCE:      rave_plot_fields_observed,dblarr_fields,strarr_meansigfiles,str_plotname
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

  if not keyword_set(I_LON) then i_lon = 0

  i_nfields = n_elements(dblarr_fields) / 4
  lonarr_all_stars_besancon = lonarr(i_nfields)
  lonarr_all_stars_rave = lonarr(i_nfields)
  lonarr_bad_stars = lonarr(i_nfields)

  dblarr_ravedata_plot = dblarr_ravedata
  dblarr_besancondata_plot = dblarr_besancondata
  if keyword_set(DBLARR_IRANGE) and keyword_set(I_IMAG) then begin
  ; --- rave
    indarr = where(dblarr_ravedata_plot(*,i_imag) ge dblarr_irange(0) and dblarr_ravedata_plot(*,i_imag) le dblarr_irange(1))
    dblarr_ravedata_plot = dblarr_ravedata_plot(indarr,*)

    ; --- besancon
    indarr = where(dblarr_besancondata_plot(*,i_imag) ge dblarr_irange(0) and dblarr_besancondata_plot(*,i_imag) le dblarr_irange(1))
    dblarr_besancondata_plot = dblarr_besancondata_plot(indarr,*)
  endif

  for i=0UL, i_nfields-1 do begin
  ; --- rave
    indarr_lon = where((dblarr_ravedata_plot(*,i_lon) ge dblarr_fields(i,0)) and (dblarr_ravedata_plot(*,i_lon) lt dblarr_fields(i,1)))
    print,'rave_plot_fields_observed: rave: n_elements(indarr_lon) = ',n_elements(indarr_lon)

    if n_elements(indarr_lon) eq 1 and indarr_lon(0) eq -1 then begin
      lonarr_all_stars_rave(i) = 0
      lonarr_bad_stars(i) = 0
      print,'rave_plot_fields_observed: rave: n_elements(indarr_lon) eq 1 and indarr_lon(0) eq -1'
    end else begin
      indarr_lat = where((dblarr_ravedata_plot(indarr_lon,i_lat) ge dblarr_fields(i,2)) and (dblarr_ravedata_plot(indarr_lon,i_lat) lt dblarr_fields(i,3)))
      print,'rave_plot_fields_observed: rave: n_elements(indarr_lat) = ',n_elements(indarr_lat)
      if n_elements(indarr_lat) eq 1 and indarr_lat(0) eq -1 then begin
        lonarr_all_stars_rave(i) = 0
        lonarr_bad_stars(i) = 0
        print,'rave_plot_fields_observed: rave: n_elements(indarr_lat) eq 1 and indarr_lat(0) eq -1'
      end else begin
        print,'rave_plot_fields_observed: dblarr_ravedata_plot(indarr_lon(indarr_lat),i_dat) = ',dblarr_ravedata_plot(indarr_lon(indarr_lat),i_dat)
        lonarr_all_stars_rave(i) = n_elements(indarr_lat)
;        print,'rave_plot_fields_observed: dblarr_ravedata_plot(indarr_lon(indarr_lat),i_dat) = ',dblarr_ravedata_plot(indarr_lon(indarr_lat),i_dat)
        indarr_bad_stars = where(abs(dblarr_ravedata_plot(indarr_lon(indarr_lat),i_dat) - dbl_reject) lt dbl_err_reject)
        if n_elements(indarr_bad_stars) eq 1 and indarr_bad_stars(0) eq -1 then begin
          lonarr_bad_stars(i) = 0
          print,'rave_plot_fields_observed: rave: n_elements(indarr_bad_stars) eq 1 and indarr_bad_stars(0) eq -1'
;          if i_dat eq 6 and i eq i_nfields-1 then $
;            stop
        end else begin
          print,'rave_plot_fields_observed: dblarr_ravedata_plot(indarr_lon(indarr_lat(indarr_bad_stars)),i_dat) = ',dblarr_ravedata_plot(indarr_lon(indarr_lat(indarr_bad_stars)),i_dat)
          lonarr_bad_stars(i) = n_elements(indarr_bad_stars)
          print,'rave_plot_fields_observed: rave: lonarr_bad_stars(',i,') = ',lonarr_bad_stars(i)
;          print,'rave_plot_fields_observed: rave: dblarr_ravedata_plot(indarr_lon(indarr_lat(indarr_bad_stars)),i_dat) = ',dblarr_ravedata_plot(indarr_lon(indarr_lat(indarr_bad_stars)),i_dat)
        end
      end
    end

; --- besancon
    indarr_lon = where((dblarr_besancondata_plot(*,i_lon) ge dblarr_fields(i,0)) and (dblarr_besancondata_plot(*,i_lon) lt dblarr_fields(i,1)))
    print,'rave_plot_fields_observed: besancon: n_elements(indarr_lon) = ',n_elements(indarr_lon)

    if n_elements(indarr_lon) eq 1 and indarr_lon(0) eq -1 then begin
      lonarr_all_stars_besancon(i) = 0
      lonarr_bad_stars(i) = 0
    end else begin
      indarr_lat = where((dblarr_besancondata_plot(indarr_lon,i_lat) ge dblarr_fields(i,2)) and (dblarr_besancondata_plot(indarr_lon,i_lat) lt dblarr_fields(i,3)))
      print,'rave_plot_fields_observed: besancon: n_elements(indarr_lat) = ',n_elements(indarr_lat)
      if n_elements(indarr_lat) eq 1 and indarr_lat(0) eq -1 then begin
        lonarr_all_stars_besancon(i) = 0
        lonarr_bad_stars(i) = 0
        print,'rave_plot_fields_observed: besancon: n_elements(indarr_lat) eq 1 and indarr_lat(0) eq -1'
      end else begin
        lonarr_all_stars_besancon(i) = n_elements(indarr_lat)
        print,'rave_plot_fields_observed: besancon: lonarr_all_stars_besancon(',i,') set to ',lonarr_all_stars_besancon(i)
      end
    end
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
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'

; --- observed stars vs. besancon stars
  print,'rave_plot_fields_observed: creating str_plotname='+str_plotname
  set_plot,'ps'
  device,filename=str_plotname,/color
  loadct,0
  xtitle = 'Galactic Longitude [deg]'
  ytitle = 'Galactic Latitude [deg]'
  plot,dblarr_ravedata_plot(*,i_lon),$
       dblarr_ravedata_plot(*,i_lat),$
       psym=2,$
       symsize=0.1,$
       xrange=[0,370],$
       yrange=[-90,90],$
       xtitle=xtitle,$
       ytitle=ytitle,$
       xstyle=1,$
       ystyle=1,$
       position=[0.09,0.095,0.99,0.99],$
       thick=2.,$
       charthick=2.,$
       charsize=2.
  loadct,ltab,FILE='colors1.tbl'
  for i=0UL, i_nfields-1 do begin
    b_plot = 1
    colorx = 0
    if lonarr_all_stars_rave(i) lt 1 then begin
      b_plot = 0
      print,'colorx = ',colorx,', b_plot = ',b_plot
    end else begin
      print,'rave_plot_fields_observed: lonarr_all_stars_rave(',i,') = ',lonarr_all_stars_rave(i),', lonarr_all_stars_besancon(',i,') = ',lonarr_all_stars_besancon(i)
      dbl_percentage = (double(lonarr_all_stars_rave(i)) / double(lonarr_all_stars_besancon(i))) * 100.
      print,'rave_plot_fields_observed: dbl_percentage = ',dbl_percentage
      colorx = long((dbl_percentage / dbl_maxpercentage) * 254.)
      if colorx lt 0 then colorx = 0
      if colorx gt 254 then colorx = 254
      print,'rave_plot_fields_observed: colorx = ',colorx
    end
;    print,'rave_plot_fields_observed: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
    if b_plot eq 1 then begin
;      print,'rave_plot_fields_observed: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
      box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colorx
    end
  endfor
  for i=0,20 do begin
    xa = 360.
    xb = 370.
    ya = 90.-(180.*i/21.)
    yb = 90.-(180.*(i+1)/21.)
    colorxy = long(254. - 254.*(double(i)/20.))
    box,xa,ya,xb,yb,colorxy
  endfor
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  xyouts,315.,79.,str_maxpercentage+' %',charthick=4,charsize=2,color=255
  xyouts,325.,-89.,'0 %',charthick=4,charsize=2,color=255
  device,/close
  set_plot,'x'

  spawn,'rm temp.tiff'
  spawn,'ps2gif '+str_plotname+' '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
  spawn,'gif2tiff '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif temp.tiff'
  spawn,'tiff2pdf -o '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.pdf'+' temp.tiff'


; --- observed stars with parameters vs. besancon stars
  str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'_obs-bad'+strmid(str_plotname,strpos(str_plotname,'.',/REVERSE_SEARCH))
  print,'rave_plot_fields_observed: creating str_plotname='+str_plotname
  set_plot,'ps'
  device,filename=str_plotname,/color
  loadct,0
  xtitle = 'Galactic Longitude [deg]'
  ytitle = 'Galactic Latitude [deg]'
  plot,dblarr_ravedata_plot(*,i_lon),$
       dblarr_ravedata_plot(*,i_lat),$
       psym=2,$
       symsize=0.1,$
       xrange=[0,370],$
       yrange=[-90,90],$
       xtitle=xtitle,$
       ytitle=ytitle,$
       xstyle=1,$
       ystyle=1,$
       position=[0.09,0.095,0.99,0.99],$
       thick=2.,$
       charthick=2.,$
       charsize=2.
  loadct,ltab,FILE='colors1.tbl'
  for i=0UL, i_nfields-1 do begin
    b_plot = 1
    colorx = 0
    if lonarr_all_stars_rave(i) lt 1 then begin
      b_plot = 0
      print,'colorx = ',colorx,', b_plot = ',b_plot
    end else begin
      print,'rave_plot_fields_observed: dblarr_fields(',i,',*) = ',dblarr_fields(i,*)
      print,'lonarr_all_stars_rave(',i,') = ',lonarr_all_stars_rave(i),', lonarr_bad_stars(',i,') = ',lonarr_bad_stars(i),', lonarr_all_stars_besancon(',i,') = ',lonarr_all_stars_besancon(i)
      dbl_percentage = double(lonarr_all_stars_rave(i) - lonarr_bad_stars(i)) / double(lonarr_all_stars_besancon(i)) * 100.
      print,'rave_plot_fields_observed: dbl_percentage = ',dbl_percentage
      colorx = long(dbl_percentage / dbl_maxpercentage * 254.)
      if colorx lt 0 then colorx = 0
      if colorx gt 254 then colorx = 254
      print,'rave_plot_fields_observed: colorx = ',colorx
    end
;    print,'rave_plot_fields_observed: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
    if b_plot eq 1 then begin
;      print,'rave_plot_fields_observed: starting to plot field: colorx = ',colorx,', b_plot = ',b_plot
      box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colorx
    end
  endfor
  for i=0,20 do begin
    xa = 360.
    xb = 370.
    ya = 90.-(180.*i/21.)
    yb = 90.-(180.*(i+1)/21.)
    colorxy = long(254. - 254.*(double(i)/20.))
    box,xa,ya,xb,yb,colorxy
  endfor
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  xyouts,315.,79.,str_maxpercentage+' %',charthick=4,charsize=2,color=255
  xyouts,325.,-89.,'0 %',charthick=4,charsize=2,color=255
  device,/close
  set_plot,'x'

  spawn,'rm temp.tiff'
  spawn,'ps2gif '+str_plotname+' '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
  spawn,'gif2tiff '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif temp.tiff'
  spawn,'tiff2pdf -o '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.pdf'+' temp.tiff'


end
