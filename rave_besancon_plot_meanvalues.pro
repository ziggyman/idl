pro rave_besancon_plot_meanvalues, STR_PATH = str_path,$
                                   I_NSAMPLES = i_nsamples,$
                                   STR_RAVEFILENAME = str_ravefilename,$
                                   STR_X_DIM = str_x_dim,$
                                   STR_Y_DIM = str_y_dim,$
                                   STR_XTITLE = str_xtitle,$
                                   STR_YTITLE = str_ytitle
;                                   I_COL_VRAD = i_col_vrad,$; --- 0 for X, 1 for Y
;                                   DBL_XMAX = dbl_xmax

  if not keyword_set(STR_RAVEFILENAME) then begin
    print,"usage: rave_besancon_plot_meanvalues,STR_PATH='/media/murphy-home/daten/besancon/lon-lat/html/5x5/best_error_fit/I_vrad/I9.00-12.0/',I_NSAMPLES=30,STR_RAVEFILENAME='/home/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'"
    print,' '
;    return
  end
;
; NAME:                  rave_besancon_plot_meanvalues.pro
; PURPOSE:               plots the colour-coded mean values for RAVE and Besancon
;                        x and y and the differences in LON/LAT and DEC/RA
; CATEGORY:              RAVE
; CALLING SEQUENCE:      rave_besancon_plot_meanvalues
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

  if not keyword_set(STR_PATH) then $
    str_path = '/home/azuri/daten/besancon/lon-lat/html/5x5/best_error_fit/I_vrad/I9.00-12.0/'
  if not keyword_set(I_NSAMPLES) then $
    i_nsamples = 30
;  if not keyword_set(I_COL_VRAD) then $
;    i_col_vrad = 1
;  if not keyword_set(DBL_XMAX) then $
;    dbl_xmax = 20.
  if not keyword_set(STR_RAVEFILENAME) then $
    str_ravefilename = '/home/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'
  if not keyword_set(STR_X_DIM) then $
    str_x_dim = 'mag'
  if not keyword_set(STR_Y_DIM) then $
    str_y_dim = 'km/s'

  print,'rave_besancon_plot_meanvalues: str_path = '+str_path

  str_meanfiles_list = str_path+'meanfiles.list'
  spawn,'ls '+str_path+'*/mean_sigma_x_y.dat > '+str_meanfiles_list

  i_nfields = countlines(str_meanfiles_list)
  print,'rave_besancon_plot_meanvalues: i_nfields = ',i_nfields
  strarr_meansigfiles = readfiletostrarr(str_meanfiles_list,' ')

  dblarr_mean_I_rave = dblarr(i_nfields)
  dblarr_mean_vrad_rave = dblarr(i_nfields)
  dblarr_mean_mean_I_bes = dblarr(i_nfields)
  dblarr_mean_mean_vrad_bes = dblarr(i_nfields)
  dblarr_fields_lon_lat = dblarr(i_nfields, 4)
  dblarr_fields_ra_dec = dblarr(i_nfields, 2)

  spawn,'mkdir '+str_path+'meanfields/'
  openw,lun,str_path+'meanfields/index.html',/GET_LUN
  printf,lun,'<html><body>'
;    printf,luni,'<center><img src="rave_chart.gif" width=60%><br><br>'

; --- read lon and lat of fields
  for i=0ul,i_nfields-1 do begin
    str_path_rel = strmid(strarr_meansigfiles(i),0,strpos(strarr_meansigfiles(i),'/',/REVERSE_SEARCH)+1)

    str_temp = strmid(strarr_meansigfiles(i),0,strpos(strarr_meansigfiles(i),'/',/REVERSE_SEARCH))
    str_temp = strmid(str_temp,strpos(str_temp,'/',/REVERSE_SEARCH)+1)
    for j=0ul, 3 do begin
;      print,'rave_besancon_plot_meanvalues: j=',j,' str_temp = "'+str_temp+'"'
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
;    print,'rave_besancon_plot_meanvalues: dblarr_fields_lon_lat(i=',i,',*) = ',dblarr_fields_lon_lat(i,*),': dbl_mean_lon = ',dbl_mean_lon,', dbl_mean_lat = ',dbl_mean_lat

    euler,dbl_mean_lon,dbl_mean_lat,dbl_ra,dbl_dec,2
    dblarr_fields_ra_dec(i,0) = dbl_ra
    dblarr_fields_ra_dec(i,1) = dbl_dec
;    print,'rave_besancon_plot_meanvalues: dbl_mean_lon = ',dbl_mean_lon,', dbl_mean_lat = ',dbl_mean_lat,' ra = ',dblarr_fields_ra_dec(i,0),', dec = ',dblarr_fields_ra_dec(i,1)

    strarr_mean_sigma_x_y = readfiletostrarr(strarr_meansigfiles(i),' ')
    if n_elements(strarr_mean_sigma_x_y(*,0)) gt 2 then begin
      dblarr_mean_sigma_x_y = double(strarr_mean_sigma_x_y(2:(i_nsamples+1),*))
    endif

    dblarr_mean_I_rave(i) = double(strarr_mean_sigma_x_y(0,1))
    dblarr_mean_vrad_rave(i) = double(strarr_mean_sigma_x_y(0,5))
    if n_elements(strarr_mean_sigma_x_y(*,0)) gt 2 then begin
      dblarr_mean_mean_I_bes(i) = mean(dblarr_mean_sigma_x_y(*,0))
      dblarr_mean_mean_vrad_bes(i) = mean(dblarr_mean_sigma_x_y(*,4))
    end else begin
      dblarr_mean_mean_I_bes(i) = 0.
      dblarr_mean_mean_vrad_bes(i) = 0.
    end
    print,'rave_besancon_plot_meanvalues: dblarr_mean_vrad_rave(i=',i,') = ',dblarr_mean_vrad_rave(i),', dblarr_mean_mean_vrad_bes(i) = ',dblarr_mean_mean_vrad_bes(i)
  endfor


  ; --- read positions of RAVE stars
  strarr_rave = readfiletostrarr(str_ravefilename,' ')
  intarr_dataarr_size = size(strarr_rave)

  rave_get_colour_table,B_POP_ID    = 2,$
                        RED         = red,$
                        GREEN       = green,$
                        BLUE        = blue;,$
;                        DBL_N_TYPES = dbl_n_types
;      print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_rave_besancon_plot_meanvalues.tbl'

  if not keyword_set(STR_XTITLE) then begin
    str_x = strmid(str_path,0,strpos(str_path,'/',/REVERSE_SEARCH))
    print,'rave_besancon_plot_meanvalues: str_x = '+str_x
    str_x = strmid(str_x,0,strpos(str_x,'/',/REVERSE_SEARCH))
    print,'rave_besancon_plot_meanvalues: str_x = '+str_x
    str_y = strmid(str_x,strpos(str_x,'_',/REVERSE_SEARCH)+1)
    str_x = strmid(str_x,strpos(str_x,'/',/REVERSE_SEARCH)+1,strpos(str_x,'_',/REVERSE_SEARCH)-strpos(str_x,'/',/REVERSE_SEARCH)-1)
    print,'rave_besancon_plot_meanvalues: str_x = '+str_x+', str_y = '+str_y
  end else begin
    str_x = str_xtitle
    str_y = str_ytitle
  end

;  stop
;  if intarr_dataarr_size(2) lt 30 then begin
;    dblarr_ra = double(strarr_rave(*,1))
;    dblarr_dec = double(strarr_rave(*,2))
;    dblarr_lon = double(strarr_rave(*,3))
;    dblarr_lat = double(strarr_rave(*,4))
;    stop
;  end else begin
    dblarr_ra = double(strarr_rave(*,2))
    dblarr_dec = double(strarr_rave(*,3))
    dblarr_lon = double(strarr_rave(*,4))
    dblarr_lat = double(strarr_rave(*,5))
;  end

  for j=0,11 do begin
;    if not keyword_set(DBL_XMAX) then begin
      ; --- 0-3,8,9: lon-lat
      ;     0: x_rave
      ;     1: y_rave
      ;     2: x_bes
      ;     3: y_bes
      ;     8: x rave - bes
      ;     9: y rave - bes
      ; --- 4-7,10,11: ra-dec
      if j eq 0 then begin
        dblarr_plot = dblarr_mean_I_rave
        str_plotname = str_path + 'meanfields_'+str_x+'_rave_lon-lat_'
        str_title = 'mean('+str_x+'_RAVE)'
      end else if j eq 1 then begin
        dblarr_plot = dblarr_mean_vrad_rave
        str_plotname = str_path + 'meanfields_'+str_y+'_rave_lon-lat_'
        str_title = 'mean('+str_y+'_RAVE)'
      end else if j eq 2 then begin
        dblarr_plot = dblarr_mean_mean_I_bes
        str_plotname = str_path + 'meanfields_'+str_x+'_bes_lon-lat_'
        str_title = 'mean('+str_x+'_Besancon)'
      end else if j eq 3 then begin
        dblarr_plot = dblarr_mean_mean_vrad_bes
        str_plotname = str_path + 'meanfields_'+str_y+'_bes_lon-lat_'
        str_title = 'mean('+str_y+'_Besancon)'
      end else if j eq 4 then begin
        dblarr_plot = dblarr_mean_I_rave
        str_plotname = str_path + 'meanfields_'+str_x+'_rave_ra-dec_'
        str_title = 'mean('+str_x+'_RAVE)'
      end else if j eq 5 then begin
        dblarr_plot = dblarr_mean_vrad_rave
        str_plotname = str_path + 'meanfields_'+str_y+'_rave_ra-dec_'
        str_title = 'mean('+str_y+'_RAVE)'
      end else if j eq 6 then begin
        dblarr_plot = dblarr_mean_mean_I_bes
        str_plotname = str_path + 'meanfields_'+str_x+'_bes_ra-dec_'
        str_title = 'mean('+str_x+'_Besancon)'
      end else if j eq 7 then begin
        dblarr_plot = dblarr_mean_mean_vrad_bes
        str_plotname = str_path + 'meanfields_'+str_y+'_bes_ra-dec_'
        str_title = 'mean('+str_y+'_Besancon)'
      end else if j eq 8 then begin
        dblarr_plot = dblarr_mean_I_rave - dblarr_mean_mean_I_bes
        str_plotname = str_path + 'meanfields_'+str_x+'_rave-bes_lon-lat_'
        str_title = 'mean('+str_x+'_RAVE) - mean('+str_x+'_Bes)'
      end else if j eq 9 then begin
        dblarr_plot = dblarr_mean_vrad_rave - dblarr_mean_mean_vrad_bes
        str_plotname = str_path + 'meanfields_'+str_y+'_rave-bes_lon-lat_'
        str_title = 'mean('+str_y+'_RAVE) - mean('+str_y+'_Bes)'
      end else if j eq 10 then begin
        dblarr_plot = dblarr_mean_I_rave - dblarr_mean_mean_I_bes
        str_plotname = str_path + 'meanfields_'+str_x+'_rave-bes_ra-dec_'
        str_title = 'mean('+str_x+'_RAVE) - mean('+str_x+'_Bes)'
      end else if j eq 11 then begin
        dblarr_plot = dblarr_mean_vrad_rave - dblarr_mean_mean_vrad_bes
        str_plotname = str_path + 'meanfields_'+str_y+'_rave-bes_ra-dec_'
        str_title = 'mean('+str_y+'_RAVE) - mean('+str_y+'_Bes)'
      end
      intarr_indarr = where(abs(dblarr_plot) gt 0.0000001)
      dbl_xmin = min(dblarr_plot(intarr_indarr))
      dbl_xmax = max(dblarr_plot(intarr_indarr))
      if j ge 8 then begin
        dbl_xmax = max(abs([dbl_xmin, dbl_xmax]))
        dbl_xmin = -dbl_xmax
      endif
      print,'rave_besancon_plot_meanvalues: dbl_xmin = ',dbl_xmin,', dbl_xmax = ',dbl_xmax
      str_plotname = str_plotname + strmid(strtrim(string(dbl_xmin),2),0,4)+'-' + strmid(strtrim(string(dbl_xmax),2),0,4)+'.ps'
      str_gifplotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
      printf,lun,'<center><img src="'+str_gifplotname+'" width=60%><br>'
      printf,lun,str_gifplotname+'</center><br><br>'
;    endif

;    if abs(long(j / 2.) - (double(j) / 2.)) lt 0.4 then begin
;      str_title = str_title + ' [' + str_x_dim + ']'
;    end else begin
;      str_title = str_title + ' [' + str_y_dim + ']'
;    end
    if j lt 4 or (j eq 8) or (j eq 9) then begin
      xtitle = 'Galactic Longitude [deg]'
      ytitle = 'Galactic Latitude [deg]'
      dblarr_x = dblarr_lon
      dblarr_y = dblarr_lat
      dblarr_yrange = [-90.,90.]
      dblarr_xrange = [0.,370.]
      int_xticks=4
      int_yticks=2
      intarr_xtickv=[0,90,180,270,360]
      str_xtickformat='(I4)'
      str_ytickformat='(I4)'
    end else begin
      xtitle = 'RA [deg]'
      ytitle = 'Dec [deg]'
      dblarr_x = dblarr_ra
      dblarr_y = dblarr_dec
      dblarr_xrange=[360.,-10.]
      dblarr_yrange = [-90.,0.]
      int_xticks=4
      int_yticks=2
      intarr_xtickv=[360,270,180,90,0]
      str_xtickformat='(I4)'
      str_ytickformat='(I4)'
    end

    set_plot,'ps'
    device,filename = str_plotname,/color
      loadct,0
;      strarr_rave = 0
      plot,dblarr_x,$
           dblarr_y,$
           psym=2,$
           symsize=0.1,$
           xrange=dblarr_xrange,$
           yrange=dblarr_yrange,$
           xtitle=xtitle,$
           ytitle=ytitle,$
           xstyle=1,$
           ystyle=1,$
           title=str_title,$
           position=[0.16,0.16,0.99,0.99],$
           thick=3.,$
           charthick=3.,$
           charsize=1.8,$
           xticks=int_xticks,$
           yticks=int_yticks,$
           xtickv=intarr_xtickv,$
           xtickformat=str_xtickformat,$
           ytickformat=str_ytickformat,$
           xminor = 9,$
           yminor = 9

    loadct,ltab,FILE='colors1_rave_besancon_plot_meanvalues.tbl'
    plotsym,0,1,FILL=1,THICK=1

    for i=0, i_nfields-1 do begin
;
      b_plot = 1
      colorx = 0
;
;      if (j eq 0) or (j eq 4) then begin
      if abs(dblarr_plot(i)) lt 0.0000001 then begin
        colorx = 0
        colory = 0
        b_plot = 0
        print,'colorx = ',colorx,', b_plot = ',b_plot
      end else begin;if ((dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.)) or ((dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.)) then begin
        colorx = long(254. * (dblarr_plot(i) - dbl_xmin) / (dbl_xmax - dbl_xmin))
      end
      if colorx lt 1 then colorx = 1
      if colorx gt 254 then colorx = 254
      print,'rave_besancon_plot_meanvalues: dblarr_plot(i=',i,') = ',dblarr_plot(i),': colorx = ',colorx

      if b_plot eq 1 then begin
        if (j le 3) or (j eq 8) or (j eq 9) then begin
          box,dblarr_fields_lon_lat(i,0),$
              dblarr_fields_lon_lat(i,2),$
              dblarr_fields_lon_lat(i,1),$
              dblarr_fields_lon_lat(i,3),$
              colorx
        end else begin
          oplot,[dblarr_fields_ra_dec(i,0),dblarr_fields_ra_dec(i,0)],$
                [dblarr_fields_ra_dec(i,1),dblarr_fields_ra_dec(i,1)],$
                psym=8,$
                symsize=3.,$
                color=colorx
        end
      endif;if b_plot eq 1 then begin

    endfor; --- for i=0, i_nfields - 1

  ; plot colour explainations
    i_ncolours = 100
    for i=0,i_ncolours do begin
      if (j le 3) or (j eq 8) or (j eq 9) then begin
        xa = 360.
        xb = 370.
        ya = -90. + (180.*i/(i_ncolours+1.))
        yb = -90. + (180.*(i+1)/(i_ncolours+1.))
      end else begin
        xa = -10.
        xb = 0.
        ya = -90.+(90.*i/(i_ncolours+1.))
        yb = -90.+(90.*(i+1)/(i_ncolours+1.))
      end
      colorxy = long(254.*(double(i)/i_ncolours))
      box,xa,ya,xb,yb,colorxy
    endfor
    if j eq 0 then begin
      xyouts,212.,82.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,267.,-4.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,212.,-86.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else if j eq 1 then begin
      xyouts,196.,82.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,267.,-4.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,196.,-86.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end else if j eq 2 then begin
      xyouts,185.,82.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,185.,-86.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else if j eq 3 then begin
      xyouts,171.,82.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,171.,-86.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end else if j eq 4 then begin
      xyouts,148.,-4.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,148.,-88.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else if j eq 5 then begin
      xyouts,165.,-4.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,165.,-88.,'mean(RAVE) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end else if j eq 6 then begin
      xyouts,177.,-4.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,177.,-88.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else if j eq 7 then begin
      xyouts,189.,-4.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,189.,-88.,'mean(Besancon) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end else if j eq 8 then begin
      xyouts,128.,82.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,128.,-86.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else if j eq 9 then begin
      xyouts,118.,82.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,118.,-86.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end else if j eq 10 then begin
      xyouts,230.,-4.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,230.,-88.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_x_dim+']',charthick=4,color=255
    end else begin
      xyouts,244.,-4.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
;      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,244.,-88.,'mean(RAVE) - mean(Bes) = '+strmid(strtrim(string(dbl_xmin),2),0,4)+' ['+str_y_dim+']',charthick=4,color=255
    end
    device,/close
    set_plot,'x'
    spawn,'ps2gif '+str_plotname+' '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
    print,'rave_besancon_plot_meanvalues: '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif ready'
  endfor
  printf,lun,'</body></html>'
  free_lun,lun
end
