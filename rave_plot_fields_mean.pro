pro rave_plot_fields_mean,dblarr_fields,$
                          strarr_meansigfiles,$
                          str_plotname,$
                          DATAARR=dataarr,$
                          RADEC=radec,$
                          TIMESSIG=timessig,$
                          MEANSIGSAMPLES=meansigsamples,$
                          DBLARR_MEANSIGRAVE=dblarr_meansigrave,$
                          XYTITLE=xytitle,$
                          SIGMA=sigma,$
                          DBL_XMAX=dbl_xmax,$
                          DBL_YMAX=dbl_ymax

;
; NAME:                  rave_plot_fields_mean.pro
; PURPOSE:               plots the fields in the plot DEC over RA
; CATEGORY:              RAVE
; CALLING SEQUENCE:      rave_plot_fields_mean,dblarr_fields,strarr_meansigfiles,str_plotname
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
  if keyword_set(DATAARR) then $
    print,'rave_plot_fields_mean: Keyword DATAARR set'
  if keyword_set(RADEC) then $
    print,'rave_plot_fields_mean: Keyword RADEC set'
  if keyword_set(TIMESSIG) then $
    print,'rave_plot_fields_mean: Keyword TIMESSIG set'
  if keyword_set(MEANSIGSAMPLES) then begin
    print,'rave_plot_fields_mean: Keyword MEANSIGSAMPLES set'
    ;print,'rave_plot_fields_mean: meansigsamples = ',meansigsamples
  end

  if n_elements(str_plotname) eq 0 then begin
    print,'rave_plot_fields_mean: ERROR: not enough parameters specified!'
    print,'USAGE: rave_plot_fields_mean,(dblarr)dblarr_fields,(string)strarr_meansigfiles,(string)str_plotname'
    return
  end; else begin
;    str_plotname = '/suphys/azuri/daten/rave/rave_data/release3/fields.ps'
;    datafile = '/suphys/azuri/daten/rave/rave_data/release3/fields.dat'

;    print,'dblarr_fields = ',dblarr_fields
;    print,'strarr_meansigfiles = ',strarr_meansigfiles
  i_nfields = n_elements(dblarr_fields) / 4
  i_nmeans = n_elements(strarr_meansigfiles)
  intarr_dataarr_size = size(dataarr)
  print,'rave_plot_fields_mean: intarr_dataarr_size = ',intarr_dataarr_size
  print,'rave_plot_fields_mean: i_nfields = ',i_nfields,', i_nmeans = ',i_nmeans
  if i_nfields ne i_nmeans then begin
    print,'rave_plot_fields_mean: ERROR: i_nfields(=',i_nfields,', size=',size(dblarr_fields),') != i_nmeans(=',i_nmeans,',size=',size(strarr_meansigfiles),')'
    return
  end; else begin
;      strarr_data = strarr(2*i_nfields,countcols(strarr_meansigfiles(0)))
;      strarr_data = readfiletostrarr(strarr_meansigfiles(i),' ')
  if not keyword_set(TIMESSIG) then timessig = 1.
  dblarr_meanxrave = dblarr(i_nfields)
  dblarr_meanyrave = dblarr(i_nfields)
  dblarr_sigmaxrave = dblarr(i_nfields)
  dblarr_sigmayrave = dblarr(i_nfields)
  dblarr_skewnessxrave = dblarr(i_nfields)
  dblarr_skewnessyrave = dblarr(i_nfields)
  dblarr_kurtosisxrave = dblarr(i_nfields)
  dblarr_kurtosisyrave = dblarr(i_nfields)

  dblarr_meanxbes = dblarr(i_nfields)
  dblarr_meanybes = dblarr(i_nfields)
  dblarr_sigmaxbes = dblarr(i_nfields)
  dblarr_sigmaybes = dblarr(i_nfields)
  dblarr_skewnessxbes = dblarr(i_nfields)
  dblarr_skewnessybes = dblarr(i_nfields)
  dblarr_kurtosisxbes = dblarr(i_nfields)
  dblarr_kurtosisybes = dblarr(i_nfields)
  if (not keyword_set(DBLARR_MEANSIGRAVE)) or (not keyword_set(MEANSIGSAMPLES)) then begin
    for i=0ul, i_nfields-1 do begin
      print,'rave_plot_fields_mean: reading strarr_meansigfiles(i=',i,') = ',strarr_meansigfiles(i)
      if strarr_meansigfiles(i) eq '' then begin
        dblarr_meanxrave(i) = 0.
        dblarr_meanyrave(i) = 0.
        dblarr_meanxbes(i) = 0.
        dblarr_meanybes(i) = 0.
        dblarr_sigmaxrave(i) = 0.
        dblarr_sigmayrave(i) = 0.
        dblarr_sigmaxbes(i) = 0.
        dblarr_sigmaybes(i) = 0.
      end else begin
        strarr_meandata = readfiletostrarr(strarr_meansigfiles(i), ' ')
        print,'rave_plot_fields_mean: strarr_meansigfiles(i=',i,') = ',strarr_meansigfiles(i),' read'
        if not keyword_set(DBLARR_MEANSIGRAVE) then begin
          dblarr_meanxrave(i) = double(strarr_meandata(0,1))
          dblarr_meanyrave(i) = double(strarr_meandata(0,5))
          dblarr_sigmaxrave(i) = double(strarr_meandata(0,2))
          dblarr_sigmayrave(i) = double(strarr_meandata(0,6))
          dblarr_skewnessxrave(i) = double(strarr_meandata(0,3))
          dblarr_skewnessyrave(i) = double(strarr_meandata(0,7))
          dblarr_kurtosisxrave(i) = double(strarr_meandata(0,4))
          dblarr_kurtosisyrave(i) = double(strarr_meandata(0,8))
        endif
        if not keyword_set(MEANSIGSAMPLES) then begin
          dblarr_meanxbes(i) = double(strarr_meandata(1,1))
          dblarr_meanybes(i) = double(strarr_meandata(1,5))
          dblarr_sigmaxbes(i) = double(strarr_meandata(1,2))
          dblarr_sigmaybes(i) = double(strarr_meandata(1,6))
        endif
      endelse
      print,'rave_plot_fields_mean: field ',i,' read'
    endfor
  endif
  if keyword_set(MEANSIGSAMPLES) then begin
    dblarr_meanxbes = meansigsamples(*,0)
    dblarr_meanybes = meansigsamples(*,1)
    dblarr_sigmaxbes = meansigsamples(*,2)
    dblarr_sigmaybes = meansigsamples(*,3)
    print,'rave_plot_fields_mean: meansigsamples = ',meansigsamples,' read'
  end
  if keyword_set(DBLARR_MEANSIGRAVE) then begin
    print,'dblarr_meansigrave = ',dblarr_meansigrave
    dblarr_meanxrave = dblarr_meansigrave(*,0)
    dblarr_meanyrave = dblarr_meansigrave(*,1)
    dblarr_sigmaxrave = dblarr_meansigrave(*,2)
    dblarr_sigmayrave = dblarr_meansigrave(*,3)
;    print,'dblarr_meanxrave = ',dblarr_meanxrave
;    print,'dblarr_meanyrave = ',dblarr_meanyrave
;    print,'dblarr_sigmaxrave = ',dblarr_sigmaxrave
;    print,'dblarr_sigmayrave = ',dblarr_sigmayrave
;    stop
  end else begin
    if keyword_set(SIGMA) then begin
      if sigma eq 1 then begin
        dblarr_meanxrave = dblarr_sigmaxrave
        dblarr_meanyrave = dblarr_sigmayrave
      end else if sigma eq 2 then begin
        dblarr_meanxrave = dblarr_skewnessxrave
        dblarr_meanyrave = dblarr_skewnessyrave
      end else begin
        dblarr_meanxrave = dblarr_kurtosisxrave
        dblarr_meanyrave = dblarr_kurtosisyrave
      end
    endif
  endelse

;  if strpos(str_plotname,'giant_to_dwarf') ge 0 then begin
;    print,'dblarr_meanxrave = ',dblarr_meanxrave
;    print,'dblarr_meanyrave = ',dblarr_meanyrave
;    print,'dblarr_meanxbes = ',dblarr_meanxbes
;    print,'dblarr_meanybes = ',dblarr_meanybes
;    print,'dblarr_sigmaxbes = ',dblarr_sigmaxbes
;    print,'dblarr_sigmaybes = ',dblarr_sigmaybes
;    stop
;  endif

  indarr = where(abs(dblarr_meanxbes) gt 0.00000001)
  if indarr(0) lt 0 then begin
    print,'rave_plot_fields_mean: PROBLEM: indarr = where(abs(dblarr_meanxbes) gt 0.00000001) == -1'
    return
  endif
  maxdiffmeanx = max(abs(dblarr_meanxrave(indarr) - dblarr_meanxbes(indarr)));,abs(dblarr_meanxbes - dblarr_meanxrave)])
  if keyword_set(DBL_XMAX) then begin
    if abs(dbl_xmax-1.) lt 0.00001 then begin
      dbl_xmax = maxdiffmeanx
    endif
  end else begin
    dbl_xmax = 0.
  end

  maxdiffmeany = max(abs(dblarr_meanyrave(indarr) - dblarr_meanybes(indarr)));,abs(dblarr_meanybes - dblarr_meanyrave)])
  if keyword_set(DBL_YMAX) then begin
    if abs(dbl_ymax-1.) lt 0.00001 then begin
      dbl_ymax = maxdiffmeany
    endif
  end else begin
    dbl_ymax = 0.
  endelse
  if (xytitle(0) eq 'Teff' and dbl_xmax gt 5000.) or (xytitle(1) eq 'Teff' and dbl_ymax gt 5000.) then begin
    print,'rave_plot_fields_mean: dbl_xmax = ',dbl_xmax,' or dbl_ymax = ',dbl_ymax,' gt 5000. => stop'
    if xytitle(0) eq 'Teff' then begin
      dbl_xmax = 3000.
    end else begin
      dbl_ymax = 3000.
    end
;    stop
  endif
  if xytitle(1) eq 'logg' and dbl_ymax gt 2.8 then begin
    print,'rave_plot_fields_mean: dbl_ymax = ',dbl_ymax,' gt 2.8. => stop'
    dbl_ymax = 2.8
;    stop
  endif
  if xytitle(0) eq 'I' and dbl_xmax gt 1.8 then begin
    print,'rave_plot_fields_mean: xtitle='+xytitle(0)+': dbl_xmax = ',dbl_xmax,' gt 1.8. => stop'
    stop
  endif

  print,'rave_plot_fields_mean: maxdiffmeanx = ',maxdiffmeanx
  print,'rave_plot_fields_mean: maxdiffmeany = ',maxdiffmeany

;      strarr_data = readfiletostrarr(datafile,' ')
;      dblarr_fields = dblarr(i_nfields,4)
;      dblarr_fields(*,0) = double(strarr_data(*,0))
;      dblarr_fields(*,1) = double(strarr_data(*,1))
;      dblarr_fields(*,2) = double(strarr_data(*,2))
;      dblarr_fields(*,3) = double(strarr_data(*,3))
;      print,'dblarr_fields = ',dblarr_fields

  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  rave_get_colour_table,B_POP_ID    = 2,$
                        RED         = red,$
                        GREEN       = green,$
                        BLUE        = blue,$
                        DBL_N_TYPES = dbl_n_types
;      print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_rave_plot_fields_mean.tbl'

  if keyword_set(MEANSIGSAMPLES) or keyword_set(XYTITLE) then begin
    i_loopend = 2
  end else begin
    i_loopend = 1
  end

;      str_plotname = '/suphys/azuri/temp/meanfields_test.ps'
  for l=1,i_loopend do begin
;        if keyword_set(MEANSIGSAMPLES) then begin
;          if l eq 1 then begin
;            str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'_mean.ps'
;          end else begin
;            str_plotname = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH))+'_sigma.ps'
;          end
;        endif
    if keyword_set(XYTITLE) then begin
      if l eq 1 then begin
        if keyword_set(DBL_XMAX) then begin
          str_temp = strtrim(string(dbl_xmax),2)
          str_temp = strmid(str_temp,0,4)
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(0)+'_'+str_temp+'.ps'
        end else begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(0)+'.ps'
        end
      end else begin
        if keyword_set(DBL_YMAX) then begin
          str_temp = strtrim(string(dbl_ymax),2)
          str_temp = strmid(str_temp,0,4)
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(1)+'_'+str_temp+'.ps'
        end else begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH))+'_'+xytitle(1)+'.ps'
        end
      end
    endif
    print,'rave_plot_fields_mean: creating str_plotname_temp='+str_plotname_temp
    set_plot,'ps'
;        device,filename='/suphys/azuri/daten/besancon/lon-lat/html/temp'+strtrim(string(l),2)+'.ps',/color
    device,filename=str_plotname_temp,/color
    loadct,0
    if KEYWORD_SET(RADEC) then begin
      if intarr_dataarr_size(2) lt 15 then begin
        dblarr_longitude = double(dataarr(*,0))
        dblarr_latitude = double(dataarr(*,1))
      end else begin
        dblarr_longitude = double(dataarr(*,1))
        dblarr_latitude = double(dataarr(*,2))
      end
      xtitle = 'RA [deg]'
      ytitle = 'Dec [deg]'
;      plot,dblarr_longitude,$
;           dblarr_latitude,$
      plot,dblarr_longitude(0:1),$
           dblarr_latitude(0:1),$
           psym=2,$
           symsize=0.1,$
           xrange=[360,-10],$
           yrange=[-90,0],$
           xtitle=xtitle,$
           ytitle=ytitle,$
           xstyle=1,$
           ystyle=1,$
           position=[0.16,0.16,0.99,0.99],$
           thick=3.,$
           charthick=3.,$
           charsize=1.8,$
           yticks=2,$
           yminor=9,$
           xticks=4,$
           xtickinterval=90.,$
           xminor=9,$
           xtickname=['360','270','180','90','0'],$
           xtickformat='(I4)',$
           ytickformat='(I3)'
    end else begin; if KEYWORD_SET(RADEC) then begin
      if intarr_dataarr_size(2) lt 15 then begin
        dblarr_longitude = double(dataarr(*,0))
        dblarr_latitude = double(dataarr(*,1))
      end else begin
        dblarr_longitude = double(dataarr(*,3))
        dblarr_latitude = double(dataarr(*,4))
      end
      xtitle = 'Galactic Longitude [deg]'
      ytitle = 'Galactic Latitude [deg]'
;      plot,dblarr_longitude,$
;           dblarr_latitude,$
      plot,dblarr_longitude(0:1),$
           dblarr_latitude(0:1),$
           psym=2,$
           symsize=0.1,$
           xrange=[0,370],$
           yrange=[-90,90],$
           xtitle=xtitle,$
           ytitle=ytitle,$
           xstyle=1,$
           ystyle=1,$
           position=[0.16,0.164,0.99,0.99],$
           thick=3.,$
           charthick=3.,$
           charsize=1.8,$
           yticks=4,$
           yminor=9,$
           xticks=4,$
           xtickinterval=90.,$
           xminor=9,$
           xtickname=['0','90','180','270','360'],$
           xtickformat='(I4)',$
           ytickformat='(I3)'
      dblarr_longitude = 0
      dblarr_latitude = 0
    endelse
    loadct,ltab,FILE='colors1_rave_plot_fields_mean.tbl'

    for i=0, i_nfields-1 do begin
;
      b_plot = 1
      colorx = 0
      colory = 0
;
      if ((dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.)) or $
         ((dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.)) then begin
        print,'((dblarr_sigmaxrave(i=',i,')=',dblarr_sigmaxrave(i),' eq 0.) and (dblarr_sigmayrave(i)=',dblarr_sigmayrave(i),' eq 0.)) or ((dblarr_sigmaxbes(i)=',dblarr_sigmaxbes(i),' eq 0.) and (dblarr_sigmaybes(i)=',dblarr_sigmaybes(i),' eq 0.))'
        if (dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.) then begin
;;            print,'rave_plot_fields_mean: i=',i,': no stars in RAVE field -> Setting colorx=colory=0'
          colorx = 0
          colory = 0
          b_plot = 0
        end
        if (dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.) then begin
          if (dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.) then begin
            colorx = 255/2
            colory = 255/2
;;              print,'rave_plot_fields_mean: i=',i,': no stars in RAVE nor in BESANCON field -> Setting colorx=colory=255/2'
          end else begin
;              print,'rave_plot_fields_mean: i=',i,': no stars in BESANCON field -> Setting colorx=colory=255'
            colorx = 254
            colory = 254
          end
          b_plot = 0
        end
        if keyword_set(MEANSIGSAMPLES) then b_plot = 0
        print,'colorx = ',colorx,', colory = ',colory,', b_plot = ',b_plot
      end else begin;if ((dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.)) or ((dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.)) then begin
        if not keyword_set(MEANSIGSAMPLES) then begin
          print,'Keyword MEANSIGSAMPLES not set'
          colorx = 127 + long((255 * (dblarr_meanxrave(i) - dblarr_meanxbes(i)) / (2. * dblarr_sigmaxbes(i) * timessig)))
          colory = 127 + long((255 * (dblarr_meanyrave(i) - dblarr_meanybes(i)) / (2. * dblarr_sigmaybes(i) * timessig)))
        end else begin
          print,'Keyword MEANSIGSAMPLES set'
          if dblarr_sigmaxbes(i) eq 0. then begin
            b_plot = 0
            print,'b_plot set to 0'
          end else begin
; --- from besancon_rave_plot_two_cols:
; ---     dblarr_meansamples(*,0) = meansigbes_samples(*,0) ; --- mean(meanxbes)
; ---     dblarr_meansamples(*,1) = meansigbes_samples(*,2) ; --- mean(meanybes)
; ---     dblarr_meansamples(*,2) = meansigbes_samples(*,1) ; --- sigma(meanxbes)
; ---     dblarr_meansamples(*,3) = meansigbes_samples(*,3) ; --- sigma(meanybes)
; ---        dblarr_meanxbes = meansigsamples(*,0) --- mean(mean/sigma_x_bes)
; ---        dblarr_meanybes = meansigsamples(*,2) --- mean(mean/sigma_y_bes)
; ---        dblarr_sigmaxbes = meansigsamples(*,1) --- sigma(mean/sigma_x_bes)
; ---        dblarr_sigmaybes = meansigsamples(*,3) --- sigma(mean/sigma_y_bes)
;                if l eq 1 then begin
            if keyword_set(TIMESSIG) then begin
              colorx = 127 + long((255 * (dblarr_meanxrave(i) - dblarr_meanxbes(i)) / (2. * dblarr_sigmaxbes(i) * timessig)))
              print,'dblarr_meanxrave(i=',i,')=',dblarr_meanxrave(i),', dblarr_meanxbes(i)=',dblarr_meanxbes(i),', dblarr_sigmaxbes(i)=',dblarr_sigmaxbes(i),', timessig = ',timessig,' => colorx = ',colorx
              colory = 127 + long((255 * (dblarr_meanyrave(i) - dblarr_meanybes(i)) / (2. * dblarr_sigmaybes(i) * timessig)))
              print,'dblarr_meanyrave(i=',i,')=',dblarr_meanyrave(i),', dblarr_meanybes(i)=',dblarr_meanybes(i),', dblarr_sigmaybes(i)=',dblarr_sigmaybes(i),', timessig = ',timessig,' => colory = ',colory
;                end else begin
;                  colorx = 127 + long((255 * (dblarr_sigmaxrave(i) - dblarr_meanxrave(i)) / (2. * meansigsamples(i,5) * timessig)))
;                  print,'dblarr_sigmaxrave(i=',i,')=',dblarr_sigmaxrave(i),', meansigsamples(i,4)=',meansigsamples(i,4),', meansigsamples(i,5)=',meansigsamples(i,5),', timessig = ',timessig,' => colorx = ',colorx
;                end
              print,'l = ',l,': colorx = ',colorx
            end
            if keyword_set(DBL_XMAX) then begin
              colorx = 127 + long(127 * (dblarr_meanxrave(i) - dblarr_meanxbes(i)) / dbl_xmax)
              print,'dblarr_meanxrave(i=',i,')=',dblarr_meanxrave(i),', dblarr_meanxbes(i)=',dblarr_meanxbes(i),', dblarr_sigmaxbes(i)=',dblarr_sigmaxbes(i),', dbl_xmax = ',dbl_xmax,' => colorx = ',colorx
              colory = 127 + long(127 * (dblarr_meanyrave(i) - dblarr_meanybes(i)) / dbl_ymax)
              print,'dblarr_meanyrave(i=',i,')=',dblarr_meanyrave(i),', dblarr_meanybes(i)=',dblarr_meanybes(i),', dblarr_sigmaybes(i)=',dblarr_sigmaybes(i),', dbl_ymax = ',dbl_ymax,' => colory = ',colory
;              end else begin
;                  colorx = 127 + long((255 * (dblarr_sigmaxrave(i) - dblarr_meanxrave(i)) / (2. * meansigsamples(i,5) * timessig)))
;                  print,'dblarr_sigmaxrave(i=',i,')=',dblarr_sigmaxrave(i),', meansigsamples(i,4)=',meansigsamples(i,4),', meansigsamples(i,5)=',meansigsamples(i,5),', timessig = ',timessig,' => colorx = ',colorx
;                end
              print,'l = ',l,': colorx = ',colorx
              print,'l = ',l,': colory = ',colory
            end
          end; else begin
        end; else begin
        print,'y: l = ',l,': colorx = ',colorx
        if colorx lt 1 then colorx = 1
        if colorx gt 254 then colorx = 254
        print,'y: l = ',l,': colorx = ',colorx

        print,'y: l = ',l,': colory = ',colory
        if colory lt 1 then colory = 1
        if colory gt 254 then colory = 254
        print,'y: l = ',l,': colory = ',colory

;        stop

;;          colorx = 192 * (dblarr_meanxrave(i) - dblarr_meanxbes(i) + maxdiffmeanx) / (2. * maxdiffmeanx)
;;          colory = 192 * (dblarr_meanyrave(i) - dblarr_meanybes(i) + maxdiffmeany) / (2. * maxdiffmeany)
;;          print,'rave_plot_fields_mean: i=',i,': Setting colorx to ',colorx,', colory to ',colory
      end; end else begin;if ((dblarr_sigmaxrave(i) eq 0.) and (dblarr_sigmayrave(i) eq 0.)) or ((dblarr_sigmaxbes(i) eq 0.) and (dblarr_sigmaybes(i) eq 0.)) then begin
;      print,'rave_plot_fields_mean: starting to plot field: colorx = ',colorx,', colory=',colory,', b_plot = ',b_plot
      if b_plot eq 1 then begin
        print,'rave_plot_fields_mean: starting to plot field: colorx = ',colorx,', colory=',colory,', b_plot = ',b_plot
        if KEYWORD_SET(RADEC) then begin
          if not keyword_set(XYTITLE) then begin
            triangle,dblarr_fields(i,1),dblarr_fields(i,2),dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,0),dblarr_fields(i,3),colorx
            triangle,dblarr_fields(i,0),dblarr_fields(i,3),dblarr_fields(i,1),dblarr_fields(i,3),dblarr_fields(i,1),dblarr_fields(i,2),colory
          end else begin
            if l eq 1 then colors=colorx else colors=colory
            box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colors
          end
        end else begin
          if not keyword_set(XYTITLE) then begin
            print,'RADEC-: plotting triangles'
            triangle,dblarr_fields(i,1),dblarr_fields(i,2),dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colorx
            triangle,dblarr_fields(i,0),dblarr_fields(i,3),dblarr_fields(i,1),dblarr_fields(i,3),dblarr_fields(i,0),dblarr_fields(i,2),colory
          end else begin
            if l eq 1 then colors=colorx else colors=colory
            box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),colors
          end
        end
      end;if b_plot eq 1 then begin
;      box,dblarr_fields(i,0),dblarr_fields(i,2),dblarr_fields(i,1),dblarr_fields(i,3),20
    endfor; for i=0, i_nfields-1 do begin
    i_ncolours_legend = 100
    if KEYWORD_SET(RADEC) then begin
      for i=0,i_ncolours_legend do begin
        xa = -10.
        xb = 0.
        ya = 0.-(90.*i/(i_ncolours_legend+1.))
        yb = 0.-(90.*(i+1)/(i_ncolours_legend+1.))
        colorxy = long(254.*(double(i)/double(i_ncolours_legend)))
        box,xa,ya,xb,yb,colorxy
      endfor
      xyouts,90.,-4.,'RAVE < Besancon',charthick=4;,color=255
      xyouts,90.,-47.,'RAVE = Besancon',charthick=4;,color=255
      xyouts,90.,-88.,'RAVE > Besancon',charthick=4;,color=255
    end else begin
      for i=0,i_ncolours_legend do begin
        xa = 360.
        xb = 370.
        ya = 90.-(180.*i/(i_ncolours_legend+1.))
        yb = 90.-(180.*(i+1)/(i_ncolours_legend+1.))
        colorxy = long(254.*(double(i)/double(i_ncolours_legend)))
        if colorxy eq 0 then colorxy = 1
        box,xa,ya,xb,yb,colorxy
      endfor
      xyouts,267.,82.,'RAVE < Besancon',charthick=4,color=255
      xyouts,267.,-2.,'RAVE = Besancon',charthick=4,color=255
      xyouts,267.,-86.,'RAVE > Besancon',charthick=4,color=255
    end; else begin
    device,/close
    set_plot,'x'
  endfor; for l=1,i_loopend do begin
end
