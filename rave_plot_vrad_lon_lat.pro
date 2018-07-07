pro rave_plot_vrad_lon_lat, str_path,$
                   I_NSAMPLES=i_nsamples,$
                   I_COL_VRAD = i_col_vrad,$; --- 0 for X, 1 for Y
                   STR_RAVEFILENAME = str_ravefilename,$
                   DBL_XMAX = dbl_xmax

  if not keyword_set(STR_RAVEFILENAME) then begin
    print,"usage: rave_fit_vrad,'/media/murphy-home/daten/besancon/lon-lat/html/5x5/best_error_fit/I_vrad/I9.00-12.0/',I_NSAMPLES=30,I_COL_VRAD=1,STR_RAVEFILENAME='/home/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat',DBL_XMAX=25."
;    return
  end
;
; NAME:                  rave_fit_vrad.pro
; PURPOSE:               plots the fields in the plot DEC versus RA
; CATEGORY:              RAVE
; CALLING SEQUENCE:      rave_fit_vrad
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

  if not keyword_set(I_NSAMPLES) then $
    i_nsamples = 30
  if not keyword_set(I_COL_VRAD) then $
    i_col_vrad = 1
  if not keyword_set(DBL_XMAX) then $
    dbl_xmax = 20.
  if not keyword_set(STR_RAVEFILENAME) then $
    str_ravefilename = '/home/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'

  print,'rave_fit_vrad: str_path = '+str_path

  str_meanfiles_list = str_path+'meanfiles.list'
  spawn,'ls '+str_path+'*/mean_sigma_x_y.dat > '+str_meanfiles_list

  i_nfields = countlines(str_meanfiles_list)
  print,'rave_fit_vrad: i_nfields = ',i_nfields
  strarr_meansigfiles = readfiletostrarr(str_meanfiles_list,' ')

  dblarr_mean_vrad_rave = dblarr(i_nfields)
  dblarr_mean_mean_vrad_bes = dblarr(i_nfields)
  dblarr_fields_lon_lat = dblarr(i_nfields, 4)
  dblarr_fields_ra_dec = dblarr(i_nfields, 2)

  for i=0ul,i_nfields-1 do begin
    str_path_rel = strmid(strarr_meansigfiles(i),0,strpos(strarr_meansigfiles(i),'/',/REVERSE_SEARCH)+1)

    str_temp = strmid(strarr_meansigfiles(i),0,strpos(strarr_meansigfiles(i),'/',/REVERSE_SEARCH))
    str_temp = strmid(str_temp,strpos(str_temp,'/',/REVERSE_SEARCH)+1)
    for j=0ul, 3 do begin
;      print,'rave_fit_vrad: j=',j,' str_temp = "'+str_temp+'"'
      if strmid(str_temp,0,1) eq '-' then begin
        dbl_temp = -1.
        str_temp = strmid(str_temp,1)
      end else begin
        dbl_temp = 1.
      end
      if j eq 0 or j eq 2 then begin
        dblarr_fields_lon_lat(i,j) = double(strmid(str_temp,0,strpos(str_temp,'-')))
        str_temp = strmid(str_temp,strpos(str_temp,'-')+1)
      end else if j eq 1 then begin
        dblarr_fields_lon_lat(i,j) = double(strmid(str_temp,0,strpos(str_temp,'_')))
        str_temp = strmid(str_temp,strpos(str_temp,'_')+1)
      end else begin
        dblarr_fields_lon_lat(i,j) = double(str_temp)
      end
      dblarr_fields_lon_lat(i,j) = dbl_temp *  dblarr_fields_lon_lat(i,j)
    endfor
    dbl_mean_lon = mean(dblarr_fields_lon_lat(i,0:1))
    dbl_mean_lat = mean(dblarr_fields_lon_lat(i,2:3))
;    print,'rave_fit_vrad: dblarr_fields_lon_lat(i=',i,',*) = ',dblarr_fields_lon_lat(i,*),': dbl_mean_lon = ',dbl_mean_lon,', dbl_mean_lat = ',dbl_mean_lat

    euler,dbl_mean_lon,dbl_mean_lat,dbl_ra,dbl_dec,2
    dblarr_fields_ra_dec(i,0) = dbl_ra
    dblarr_fields_ra_dec(i,1) = dbl_dec
;    print,'rave_fit_vrad: dbl_mean_lon = ',dbl_mean_lon,', dbl_mean_lat = ',dbl_mean_lat,' ra = ',dblarr_fields_ra_dec(i,0),', dec = ',dblarr_fields_ra_dec(i,1)

    strarr_mean_sigma_x_y = readfiletostrarr(strarr_meansigfiles(i),' ')
    dblarr_mean_sigma_x_y = double(strarr_mean_sigma_x_y(2:(i_nsamples+1),*))

    dblarr_mean_vrad_rave(i) = double(strarr_mean_sigma_x_y(0,1+(2*i_col_vrad)))
    dblarr_mean_mean_vrad_bes(i) = mean(dblarr_mean_sigma_x_y(*,2*i_col_vrad))
    print,'rave_fit_vrad: dblarr_mean_vrad_rave(i=',i,') = ',dblarr_mean_vrad_rave(i),', dblarr_mean_mean_vrad_bes(i) = ',dblarr_mean_mean_vrad_bes(i)
  endfor

  if not keyword_set(DBL_XMAX) then begin
    intarr_indarr = where(abs(dblarr_mean_mean_vrad_bes) gt 0.0000001)
    dbl_xmax = max(abs(dblarr_mean_vrad_rave(intarr_indarr) - dblarr_mean_mean_vrad_bes(intarr_indarr)))
    print,'rave_fit_vrad: dbl_xmax = ',dbl_xmax
  endif

  ; --- read positions of RAVE stars
  strarr_rave = readfiletostrarr(str_ravefilename,' ')
  intarr_dataarr_size = size(strarr_rave)

  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    if l le 127 then begin
      red(l) = 0;60 - (2*l)
      green(l) = 2 * l
      blue(l) = 255 - (2 * l)
    end else if l le 254 then begin
      blue(l) = 0
      green(l) = 255;2 * (l-127)
      red(l) = 2 * (l-127)
;          blue(l) = 0
;          green(l) = 255 - (2 * (l-127))
;          red(l) = 2 * (l-127)
    end else begin
      blue(l) = 0
      green(l) = 0
      red(l) = 255
    end
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 254 then green(l) = 254
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 254 then blue(l) = 254
  endfor
;      print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'

  str_plotname = str_path + 'meanfields_ra_dec_vrad_'+strmid(strtrim(string(dbl_xmax),2),0,2)+'.ps'
  set_plot,'ps'
  device,filename = str_plotname,/color
    if intarr_dataarr_size(2) lt 15 then begin
      dblarr_ra = double(strarr_rave(*,1))
      dblarr_dec = double(strarr_rave(*,2))
      stop
    end else begin
      dblarr_ra = double(strarr_rave(*,2))
      dblarr_dec = double(strarr_rave(*,3))
    end
    loadct,0
    strarr_rave = 0
    xtitle = 'RA [deg]'
    ytitle = 'Dec [deg]'
    plot,dblarr_ra,$
         dblarr_dec,$
         psym=2,$
         symsize=0.1,$
         xrange=[360,-10],$
         yrange=[-90,0],$
         xtitle=xtitle,$
         ytitle=ytitle,$
         xstyle=1,$
         ystyle=1,$
         title='colour range = [-'+strmid(strtrim(string(dbl_xmax),2),0,4)+','+strmid(strtrim(string(dbl_xmax),2),0,4)+'] km/s',$
         position=[0.175,0.17,0.995,0.905],$
         thick=2.,$
         charthick=2.,$
         charsize=2.

  loadct,ltab,FILE='colors1.tbl'
  plotsym,0,1,FILL=1,THICK=1

  for i=0, i_nfields-1 do begin
;
    b_plot = 1
    colorx = 0
;
    if (abs(dblarr_mean_vrad_rave(i)) lt 0.0000001) or $
       (abs(dblarr_mean_mean_vrad_bes(i)) lt 0.0000001) then begin
      colorx = 0
      colory = 0
      b_plot = 0
      print,'colorx = ',colorx,', b_plot = ',b_plot
    end else begin;if ((dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.)) or ((dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.)) then begin
      colorx = 127 + long(127 * (dblarr_mean_vrad_rave(i) - dblarr_mean_mean_vrad_bes(i)) / dbl_xmax)
    end
    if colorx lt 1 then colorx = 1
    if colorx gt 254 then colorx = 254
    print,'rave_fit_vrad: dbl_xmax = ',dbl_xmax,'colorx = ',colorx

    if b_plot eq 1 then begin
      oplot,[dblarr_fields_ra_dec(i,0),dblarr_fields_ra_dec(i,0)],$
            [dblarr_fields_ra_dec(i,1),dblarr_fields_ra_dec(i,1)],$
            psym=8,$
            symsize=3.,$
            color=colorx

    end;if b_plot eq 1 then begin

  end; --- for i=0, i_nfields - 1

  ; plot colour explainations
  i_ncolours = 100
  for i=0,i_ncolours do begin
    xa = -10.
    xb = 0.
    ya = 0.-(90.*i/(i_ncolours+1.))
    yb = 0.-(90.*(i+1)/(i_ncolours+1.))
    colorxy = long(254.*(double(i)/i_ncolours))
    box,xa,ya,xb,yb,colorxy
  endfor
  xyouts,90.,-4.,'RAVE < Besancon',charthick=4;,color=255
  xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
  xyouts,90.,-88.,'RAVE > Besancon',charthick=4;,color=255
  device,/close
  set_plot,'x'
  spawn,'ps2gif '+str_plotname
end
