pro rave_plot_two_cols,datafile,$
                       i_xcol,$
                       i_ycol,$
                       str_xtitle,$
                       str_ytitle,$
                       str_plotname,$
                       DATAARR            = dataarr,$
                       XRANGESET          = xrangeset,$
                       YRANGESET          = yrangeset,$
                       FORCEXRANGE        = forcexrange,$
                       FORCEYRANGE        = forceyrange,$
                       REJECTVALUEX       = rejectvaluex,$
                       NREJECTEDX         = nrejectedx,$
                       REJECTVALUEY       = rejectvaluey,$
                       NREJECTEDY         = nrejectedy,$
                       IRANGE             = irange,$
                       ICOL               = icol,$
                       MINDEC             = mindec,$
                       MAXDEC             = maxdec,$
                       COLDEC             = coldec,$
                       MINRA              = minra,$
                       MAXRA              = maxra,$
                       COLRA              = colra,$
                       DEBUG              = debug,$
                       TITLE              = title,$
                       XLOG               = xlog,$
                       YLOG               = ylog,$
                       MOMENTX            = momentx,$
                       MOMENTY            = momenty,$
                       MEANSIGMASAMPLES   = meansigmasamples,$
                       I_NSTARS           = i_nstars,$
                       CALCSAMPLES        = calcsamples,$
                       I_NSAMPLES         = i_nsamples,$
                       B_ONE_BESANCONFILE = b_one_besanconfile,$
                       PROBLEM            = problem,$
                       INDARR_OUT         = indarr_out,$
                       INDARRS_OUT        = indarrs_out,$
                       B_HIST             = b_hist,$
                       B_POP_ID           = b_pop_id,$
                       STAR_TYPES_COL     = star_types_col,$
                       BINWIDTH_I         = binwidth_i,$
                       NBINS_I            = nbins_i,$
                       B_I_SEARCH         = b_i_search,$
                       B_SAMPLES_COLOUR   = b_samples_colour,$
                       IO_PLOT_GIANT_TO_DWARF_RATIO = io_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                       B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                       I_COL_LOGG_BESANCON = i_col_logg_besancon,$
                       DBLARR_RAVEDATA     = dblarr_ravedata,$
;                       INDARR_RAVE         = indarr_rave,$
                       I_COL_I_RAVE        = i_col_i_rave,$
                       I_COL_LOGG_RAVE     = i_col_logg_rave,$
                       DBL_SEED            = dbl_seed
;
; NAME:                  rave_plot_two_cols.pro
; PURPOSE:               plots i_ycol versus i_xcol
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_plot_two_cols,'/suphys/azuri/daten/rave/rave data/rave_dr1.dat',i_xcol,i_ycol,str_xtitle,str_ytitle
; INPUTS:                datafile
;                            r1508268-243910 227.11204167 -24.65302778 338.55967000  28.57959000  -116.8    1.5   -3.3   13.2   -5.8   13.2 4 11.42 20030411    1507m23 2   1  36.1 0.93   61.4    1.2   -2.6    6.3   2.1  24.4 99.999 99.999 99.999 99.999   0653-0321526  0.280 14.26 12.92 13.63 12.64 11.38 A J150826.8-243910  0.122 11.793 0.04 10.951 0.07 10.266 0.06 B 15082687-2439107  0.258 10.932 0.02 10.436 0.02 10.364 0.02 AAA A AA
;                            r1508321-242942 227.13387500 -24.49525000 338.68088000  28.69780000   -54.6    2.1  -10.4   13.2    0.8   13.2 4 11.75 20030411    1507m23 2   3  28.0 0.94   62.6    1.0   -4.9    5.2   3.8  23.8 99.999 99.999 99.999 99.999   0655-0321354  0.154 15.22 13.21 14.66 13.10 12.11 A J150832.1-242942  0.151 12.071 0.03 11.067 0.08 10.153 0.07 A 15083211-2429428  0.204 10.998 0.02 10.297 0.02 10.155 0.02 AAA A AA
;
;                        i_xcol - collumn number for x-axis (0-)
;                        i_ycol - collumn number for y-axis (0-)
;                        str_xtitle - x-axis title
;                        str_ytitle - y-axis title
;                        str_plotname - outfile
;                        XMIN=xmin - minimum x to plot
;                        XMAX=xmax - maximum x to plot
;                        YMIN=ymin - minimum y to plot
;                        YMAX=ymax - minimum y to plot
;                        FORCEXRANGE=forcexrange - cut off values beyond xrange?
;                        FORCEYRANGE=forceyrange - cut off values beyond yrange?
;                        IMIN=imin - minimum I to plot [mag]
;                        IMAX=imax - maximum I to plot [mag]
;                        ICOL=icol - collumn number for apparent I magnitude (0-)
;                        MINDEC=mindec - minimum dec of stars to plot
;                        MAXDEC=maxdec - maximum dec of stars to plot
;                        COLDEC=coldec - column number for dec
;                        MINRA=minra - minimum ra of stars to plot
;                        MAXRA=maxra - maximum ra of stars to plot
;                        COLRA=colra - column number for ra
;                        DEBUG=debug - set this flag to print out debugging information
;                        TITLE=title - title of plot
;                        XLOG=xlog - set this flag if x-data are logarithmic and shall
;                                    be converted
;                        YLOG=ylog - set this flag if y-data are logarithmic and shall
;                                    be converted
;                        MEANX=meanx - output value for mean(x)
;                        SIGMAX=sigmax - output value for sigma(x)
;                        MEANY=meany - output value for mean(y)
;                        SIGMAY=sigmay - output value for sigma(y)
;                        I_NSTARS=i_nstars - input value: number of rave stars in field
;                                            output value: number of besancon stars in field
;                        CALCSAMPLES=calcsamples - calculate random samples of besancon
;                                                  stars with i_nstars
;                        I_NSAMPLES=i_nsamples - number of samples to calculate
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  25/04/2008
;
;                        headline
;                        feetline (up to now not used)
;

  b_debug_i = 0

  b_convolve_i = 0

  if keyword_set(I_COL_LOGG_BESANCON) then $
    i_col_logg = i_col_logg_besancon
;  if keyword_set(I_COL_LOGG_rave) then $
;    i_col_logg = i_col_logg_rave

  if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then begin
    if io_plot_giant_to_dwarf_ratio eq 1 then begin
      i_col_logg = i_xcol
    end else begin
      i_col_logg = i_ycol
    end
    if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
      io_plot_giant_to_dwarf_ratio = dblarr(i_nsamples)
    end; else begin
      ;io_plot_giant_to_dwarf_ratio = dblarr(1)
    ;end
;  print,'i_col_logg = ',i_col_logg
;  stop
  endif

;-- test arguments
  if n_elements(str_plotname) eq 0 then begin
    print,'rave_plot_two_cols: ERROR: not enough parameters specified!'
    print,'rave_plot_two_cols: Usage: rave_plot_two_cols,(string)datafile,(int)i_xcol,(int)i_ycol,(string)str_xtitle,(string)str_ytitle,(string)str_plotname'
    print,"rave_plot_two_cols: Example: rave_plot_two_cols,'/suphys/azuri/daten/rave/rave_data/rave_dr1.dat',5,6,'vrad','err_vrad','plotname.ps'"
    datafile = '/suphys/azuri/daten/rave/rave_data/rave_dr1.dat'
    i_xcol = 5
    i_ycol = 6
    str_xtitle = 'Radial Velocity [km/s]'
    str_ytitle = 'Error of Radial Velocity'
    str_plotname = 'vrad_errvrad.ps'
  endif

  if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
    i_nravestars = i_nstars
  endif

  print,' '
  print,' '
  print,' '
  print,' '

  print,'rave_plot_two_cols: datafile = ',datafile
  print,'rave_plot_two_cols: i_xcol = ',i_xcol
  print,'rave_plot_two_cols: i_ycol = ',i_ycol
  print,'rave_plot_two_cols: str_xtitle = ',str_xtitle
  print,'rave_plot_two_cols: str_ytitle = ',str_ytitle
  print,'rave_plot_two_cols: str_plotname = '+str_plotname
  i_nstars = 0
  if keyword_set(XRANGESET) then begin
    print,'rave_plot_two_cols: keyword_set(XRANGESET): xrangeset = ',xrangeset
    xrange = xrangeset
  endif
  if keyword_set(YRANGESET) then begin
    print,'rave_plot_two_cols: keyword_set(YRANGESET): yrangeset = ',yrangeset
    yrange = yrangeset
  endif
  if keyword_set(IRANGE) then $
    print,'rave_plot_two_cols: keyword_set(IRANGE): irange = ',irange
  if keyword_set(ICOL) then $
    print,'rave_plot_two_cols: keyword_set(ICOL): icol = ',icol
  if keyword_set(MINDEC) then $
    print,'rave_plot_two_cols: keyword_set(MINDEC): mindec = ',mindec
  if keyword_set(MAXDEC) then $
    print,'rave_plot_two_cols: keyword_set(MAXDEC): maxdec = ',maxdec
  if keyword_set(COLDEC) then begin
    print,'rave_plot_two_cols: keyword_set(COLDEC): coldec = ',coldec
  end else begin
    coldec = 0
  endelse
  if keyword_set(MINRA) then $
    print,'rave_plot_two_cols: keyword_set(MINRA): minra = ',minra
  if keyword_set(MAXRA) then $
    print,'rave_plot_two_cols: keyword_set(MAXRA): maxra = ',maxra
  if keyword_set(COLRA) then begin
    print,'rave_plot_two_cols: keyword_set(COLRA): colra = ',colra
  end else begin
    colra = 0
  endelse
  if keyword_set(DEBUG) then $
    print,'rave_plot_two_cols: keyword_set(DEBUG): debug = ',debug
  if keyword_set(TITLE) then $
    print,'rave_plot_two_cols: keyword_set(TITLE): title = ',title
  if keyword_set(XLOG) then $
    print,'rave_plot_two_cols: keyword_set(XLOG): xlog = ',xlog
  if keyword_set(YLOG) then $
    print,'rave_plot_two_cols: keyword_set(YLOG): ylog = ',ylog
  if keyword_set(REJECTVALUEX) then $
    print,'rave_plot_two_cols: keyword_set(REJECTVALUEX): rejectvaluex = ',rejectvaluex
  if keyword_set(REJECTVALUEY) then $
    print,'rave_plot_two_cols: keyword_set(REJECTVALUEY): rejectvaluey = ',rejectvaluey
  if keyword_set(FORCEXRANGE) then $
    print,'rave_plot_two_cols: keyword_set(FORCEXRANGE): forcexrange = ',forcexrange
  if keyword_set(FORCEYRANGE) then $
    print,'rave_plot_two_cols: keyword_set(FORCEYRANGE): forceyrange = ',forceyrange

  fileend = strmid(datafile,strpos(datafile,'.',/REVERSE_SEARCH)+1)
  print,'rave_plot_two_cols: fileend = "'+fileend+'"'
  if fileend eq 'csv' then begin
    newdatafile = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH)+1)+'dat'
    rave_write_stars,datafile,newdatafile
    datafile = newdatafile
  end else if fileend eq 'resu' then begin
    newdatafile = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH)+1)+'dat'
    print,'rave_plot_two_cols: newdatafile = '+newdatafile
    besancon_write_stars,datafile,newdatafile
    datafile = newdatafile
  end

  print,'rave_plot_two_cols: datafile = "'+datafile+'"'
  str_path = strmid(datafile,0,strpos(datafile,'/',/REVERSE_SEARCH)+1)
  if not keyword_set(DATAARR) then begin
    i_ndatalines = countlines(datafile)
    print,'rave_plot_two_cols: i_ndatalines = ',i_ndatalines
    if i_ndatalines eq 0 then begin
      print,'rave_plot_two_cols: i_ndatalines eq 0 => RETURNING'
      problem=1
      return
    endif
    strarr_data = readfiletostrarr(datafile,' ')
    print,'rave_plot_two_cols: datafile "'+datafile+'" read'
  end else begin
    strarr_data = dataarr
    print,'rave_plot_two_cols: size(strarr_data) = ',size(strarr_data)
  endelse

  print,'rave_plot_two_cols: i_xcol = ',i_xcol
  dblarr_x = double(strarr_data(*,i_xcol))
  dblarr_y = double(strarr_data(*,i_ycol))
  if keyword_set(I_COL_LOGG) then $
    dblarr_logg = double(strarr_data(*,i_col_logg))
  dblarr_i = double(strarr_data(*,icol))
;  print,'dblarr_logg = ',dblarr_logg
;  stop

; --- XLOG
  if keyword_set(XLOG) then begin
    dblarr_x = 10. ^ dblarr_x
  endif

  if keyword_set(STAR_TYPES_COL) then begin
    dblarr_star_types = double(strarr_data(*,star_types_col))
    print,'rave_plot_two_cols: dblarr_star_types set'
  end else begin
    dblarr_star_types=0
    print,'rave_plot_two_cols: dblarr_star_types NOT set'
  endelse

; --- YLOG
  if keyword_set(YLOG) then begin
    dblarr_y = 10. ^ dblarr_y
  endif

  if keyword_set(DEBUG) then begin
    templine = ''
    strarr_lines = strarr(i_ndatalines)
    openr,lun,datafile,/GET_LUN
      for k=0UL, i_ndatalines-1 do begin
        readf,lun,templine
        strarr_lines(k) = templine
      endfor
    free_lun,lun
  endif

; --- IMIN, IMAX, ICOL
  if keyword_set(IRANGE) and keyword_set(ICOL) then begin
    print,'rave_plot_two_cols: IRANGE and ICOL set'
    str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+$
                   '_I'+$
                   strmid(strtrim(string(irange(0)),2),0,4)+$
                   '-'+$
                   strmid(strtrim(string(irange(1)),2),0,4)+$
                   strmid(str_plotname,strpos(str_plotname,'.',/REVERSE_SEARCH))
    print,'rave_plot_two_cols: str_plotname = '+str_plotname
  endif


; --- MINRA, MAXRA, COLRA
  if (keyword_set(MINRA) and keyword_set(MAXRA) and keyword_set(COLRA) and keyword_set(MINDEC) and keyword_set(MAXDEC) and keyword_set(COLDEC)) or keyword_set(B_ONE_BESANCONFILE) then begin
    print,'rave_plot_two_cols: MINRA and MAXRA and COLRA and MINDEC and MAXDEC and COLDEC or B_ONE_BESANCONFILE set'
    print,'rave_plot_two_cols: colra (besancon) = ',colra
    if colra lt 0.9 then $
      colra = 0
    if abs(minra) lt 0.00001 then minra = 0.
    if abs(mindec) lt 0.00001 then mindec = 0.
    dblarr_ra = double(strarr_data(*,colra))
    dblarr_dec = double(strarr_data(*,coldec))
    indarr_out = where((dblarr_ra ge minra) and (dblarr_ra lt maxra) and (dblarr_dec ge mindec) and (dblarr_dec lt maxdec))
    dblarr_ra = 0
    dblarr_dec = 0
    print,'rave_plot_two_cols: ra: size(indarr_out) = ',size(indarr_out)
;      print,'rave_plot_two_cols: n_elements(indarr) = ',n_elements(indarr)
    if indarr_out(0) eq -1 then begin
      print,'rave_plot_two_cols: minra/maxra: n_elements(indarr=',indarr_out,') eq 1 => RETURNING'
      problem = 1
      str_path=0
      strarr_data=0
      strarr_lines=0
      return
    endif
    print,'rave_plot_two_cols: str_plotname = '+str_plotname
    str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+$
                   '_'+$
                   strmid(strtrim(string(minra),2),0,strpos(strtrim(string(minra),2),'.',/REVERSE_SEARCH))+$
                   '-'+$
                   strmid(strtrim(string(maxra),2),0,strpos(strtrim(string(maxra),2),'.',/REVERSE_SEARCH))+$
                   strmid(str_plotname,strpos(str_plotname,'.',/REVERSE_SEARCH))
    str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+$
                   '_'+$
                   strmid(strtrim(string(mindec),2),0,strpos(strtrim(string(mindec),2),'.',/REVERSE_SEARCH))+$
                   '-'+$
                   strmid(strtrim(string(maxdec),2),0,strpos(strtrim(string(maxdec),2),'.',/REVERSE_SEARCH))+$
                   strmid(str_plotname,strpos(str_plotname,'.',/REVERSE_SEARCH))
  endif

;  openw,lunb,'debug_dblarr_x_lon_lat.dat',/GET_LUN
;    printf,lunb,dblarr_x
;  free_lun,lunb
;  openw,lunb,'debug_dblarr_y_lon_lat.dat',/GET_LUN
;    printf,lunb,dblarr_y
;  free_lun,lunb

  if keyword_set(IRANGE) and keyword_set(ICOL) then begin
    if irange(0) gt 0. and irange(1) gt 0. then begin
      if irange(0) lt 0.00001 then irange(0) = 0.
      print,'rave_plot_two_cols: irange = ',irange
;      dblarr_i = double(strarr_data(*,icol))
      indarr = where((dblarr_i(indarr_out) ge irange(0)) and (dblarr_i(indarr_out) le irange(1)))
      print,'rave_plot_two_cols: irange: size(indarr_i) = ',size(indarr)
      if indarr(0) eq -1 then begin
        print,'rave_plot_two_cols: irange: n_elements(indarr_i=',indarr,') eq 1 => RETURNING'
        problem = 1
        str_path=0
        strarr_data=0
        strarr_lines=0
        return
      endif
      indarr_out = indarr_out(indarr)
      indarr = 0
;      strarr_data = strarr_data(indarr,*)
;      dblarr_x = dblarr_x(indarr)
;      dblarr_y = dblarr_y(indarr)
;      dblarr_i = dblarr_i(indarr)
;      if keyword_set(STAR_TYPES_COL) then $
;        dblarr_star_types = dblarr_star_types(indarr)
;      indarr = 0
    endif
  endif
;  openw,lunb,'debug_dblarr_x_lon_lat_irange.dat',/GET_LUN
;    printf,lunb,dblarr_x
;  free_lun,lunb
;  openw,lunb,'debug_dblarr_y_lon_lat_irange.dat',/GET_LUN
;    printf,lunb,dblarr_y
;  free_lun,lunb

; --- count bad stars
  nstarsall = n_elements(dblarr_x(indarr_out))

; --- REJECTVALUEX
  if keyword_set(REJECTVALUEX) then begin
    print,'rave_plot_two_cols: REJECTVALUEX: rejectvaluex = ',rejectvaluex
    indarr = where(abs(dblarr_x(indarr_out) - rejectvaluex) gt 0.0001)
    print,'rave_plot_two_cols: rejectvaluex: size(indarr) = ',size(indarr)
    nrejectedx = nstarsall - n_elements(indarr)
    if n_elements(indarr) eq 1 and indarr(0) eq -1 then begin
      print,'rave_plot_two_cols: rejectvaluex n_elements(indarr=',indarr,') eq 1 => RETURNING'
      problem = 1
      str_path=0
      strarr_data=0
      strarr_lines=0
      return
    endif
    indarr_out = indarr_out(indarr)
;    if not keyword_set(REJECTVALUEY) then begin
;      strarr_data = strarr_data(indarr,*)
;      dblarr_x = dblarr_x(indarr)
;      dblarr_y = dblarr_y(indarr)
;      dblarr_i = dblarr_i(indarr)
;      if keyword_set(STAR_TYPES_COL) then $
;        dblarr_star_types = dblarr_star_types(indarr)
;    endif
    indarr = 0
  endif
;  openw,lunb,'debug_dblarr_x_lon_lat_irange_xrej.dat',/GET_LUN
;    printf,lunb,dblarr_x
;  free_lun,lunb
;  openw,lunb,'debug_dblarr_y_lon_lat_irange_xrej.dat',/GET_LUN
;    printf,lunb,dblarr_y
;  free_lun,lunb

; --- REJECTVALUEY
  if keyword_set(REJECTVALUEY) then begin
    print,'rave_plot_two_cols: REJECTVALUEY: rejectvaluey = ',rejectvaluey
    indarr = where(abs(dblarr_y(indarr_out) - rejectvaluey) gt 0.0001)
    nrejectedy = nstarsall - n_elements(indarr)
    print,'rave_plot_two_cols: rejectvaluex: size(indarr) = ',size(indarr)
    if n_elements(indarr) eq 1 and indarr(0) eq -1 then begin
      print,'rave_plot_two_cols: rejectvaluey: n_elements(indarr=',indarr,') eq 1 => RETURNING'
      problem = 1
      str_path=0
      strarr_data=0
      strarr_lines=0
      return
    endif
    indarr_out = indarr_out(indarr)
    indarr = 0
  endif

; --- FORCEXRANGE
  if keyword_set(FORCEXRANGE) then begin
    print,'rave_plot_two_cols: FORCEXRANGE set'
    indarr = where(dblarr_x(indarr_out) ge xrange(0) and dblarr_x(indarr_out) le xrange(1))
    print,'rave_plot_two_cols: forcexrange: size(indarr) = ',size(indarr)
    if n_elements(indarr) eq 1 and indarr(0) eq -1 then begin
      print,'rave_plot_two_cols: forcexrange: n_elements(indarr=',indarr,') eq 1 => RETURNING'
      problem = 1
      str_path=0
      strarr_data=0
      strarr_lines=0
      return
    endif
    indarr_out = indarr_out(indarr)
    indarr = 0
  endif

; --- FORCEYRANGE
  if keyword_set(FORCEYRANGE) then begin
    print,'rave_plot_two_cols: FORCEYRANGE set'
    indarr = where(dblarr_y(indarr_out) ge yrange(0) and dblarr_y(indarr_out) le yrange(1))
    print,'rave_plot_two_cols: forceyrange: size(indarr) = ',size(indarr)
    if n_elements(indarr) eq 1 and indarr(0) eq -1 then begin
      print,'rave_plot_two_cols: forceyrange: n_elements(indarr=',indarr,') eq 1 => RETURNING'
      problem = 1
      str_path=0
      strarr_data=0
      strarr_lines=0
      return
    endif
    indarr_out = indarr_out(indarr)
    indarr = 0
  endif

  minx = min(dblarr_x(indarr_out))
  maxx = max(dblarr_x(indarr_out))

; --- XMIN, XMAX
  if keyword_set(XRANGESET) then begin
    print,'rave_plot_two_cols: keyword_set(XRANGESET): setting x.range to ',xrange
    print,'rave_plot_two_cols: keyword_set(XRANGESET): minx=',minx,', maxx=',maxx,']'
    !x.range = xrange
    !x.style = 1
  end else begin
    print,'rave_plot_two_cols: !keyword_set(XRANGESET): setting x.range to [minx=',minx,',maxx=',maxx,']'
    !x.range = [minx,maxx]
    !x.style = 0
  endelse

  miny = min(dblarr_y(indarr_out))
  maxy = max(dblarr_y(indarr_out))

; --- YMIN
  if keyword_set(YRANGESET) then begin; and keyword_set(YMAX) then begin
    !y.range = yrange
    !y.style = 1
    print,'rave_plot_two_cols: keyword_set(YRANGESET): setting y.range to ',yrange
    print,'rave_plot_two_cols: keyword_set(YRANGESET): miny=',miny,',maxy=',maxy
    if miny lt yrange(0) then begin; or maxy gt yrange(1) then begin
      indarr = where(dblarr_y(indarr_out) lt yrange(0))
      print,'rave_plot_two_cols: keyword_set(YRANGESET): WWWAAARRRNNNIIINNNGGG!!!'
      print,'rave_plot_two_cols: keyword_set(YRANGESET): miny(=',miny,') lt yrange(0)(=',yrange(0),')'; or maxy(=',maxy,') gt yrange(1)(=',yrange(1),')'
      if indarr(0) eq -1 then begin
        print,'rave_plot_two_cols: yrange(0): n_elements(indarr=',indarr,') eq 1 => RETURNING'
        problem = 1
        str_path=0
        strarr_data=0
        strarr_lines=0
        return
      endif
      yrange(0) = miny
      print,'rave_plot_two_cols: keyword_set(YRANGESET): setting y.range to [miny=',miny,',yrange(1)=',yrange(1),']'
      !y.range = [yrange(0),yrange(1)]
      !y.style = 0
      indarr = 0
    endif
    if maxy gt yrange(1) then begin; or maxy gt yrange(1) then begin
      indarr = where(dblarr_y(indarr_out) gt yrange(1))
      print,'rave_plot_two_cols: keyword_set(YRANGESET): WWWAAARRRNNNIIINNNGGG!!!'
      print,'rave_plot_two_cols: keyword_set(YRANGESET): maxy(=',maxy,') gt yrange(1)(=',yrange(1),')'; or maxy(=',maxy,') gt yrange(1)(=',yrange(1),')'
      if n_elements(indarr) eq 1 and indarr(0) eq -1 then begin
        print,'rave_plot_two_cols: yrange(1) n_elements(indarr=',indarr,') eq 1 => RETURNING'
        problem = 1
        str_path=0
        strarr_data=0
        strarr_lines=0
        return
      endif
      yrange(1) = maxy
      print,'rave_plot_two_cols: keyword_set(YRANGESET): setting y.range to [yrange(0)=',yrange(0),',yrange(1)=',yrange(1),']'
      !y.range = [yrange(0),yrange(1)]
      !y.style = 0
      indarr = 0
    endif
  end else begin
    yrange(0) = miny
    yrange(1) = maxy
    print,'rave_plot_two_cols: !keyword_set(YRANGESET): setting y.range to [yrange(0)=',yrange(0),',yrange(1)=',yrange(1),']'
    !y.range = [miny,yrange(1)]
    !y.style = 0
  endelse

; --- TITLE
  if (not keyword_set(TITLE)) then begin
    title = ''
  endif
  if n_elements(indarr_out) gt 1 then begin
    momentx = moment(dblarr_x(indarr_out))
    momenty = moment(dblarr_y(indarr_out))
  end else if n_elements(indarr_out) eq 1 then begin
    momentx = [dblarr_x(indarr_out(0)),0.,0.,0.]
    momenty = [dblarr_y(indarr_out(0)),0.,0.,0.]
  end else begin
    momentx = [0.,0.,0.,0.]
    momenty = [0.,0.,0.,0.]
  endelse
  meanx = momentx(0)
  sigmax = sqrt(momentx(1));meanabsdev(dblarr_x)

  meany = momenty(0);mean(dblarr_y)
  sigmay = sqrt(momenty(1));meanabsdev(dblarr_y)

  i_nstars = size(dblarr_x(indarr_out))
  if i_nstars(0) eq 0 then begin
    i_nstars=0
  end else begin
    i_nstars = i_nstars(1)
  endelse
  if i_nstars lt 0 then i_nstars = 0
  print,'rave_plot_two_cols: meanx = ',meanx,', sigmax = ',sigmax
  print,'rave_plot_two_cols: meany = ',meany,', sigmay = ',sigmay
  print,'rave_plot_two_cols: str_xtitle = ',str_xtitle
  print,'rave_plot_two_cols: str_ytitle = ',str_ytitle
  xtitle = str_xtitle
  ytitle = str_ytitle
  print,'rave_plot_two_cols: n_elements(dblarr_x) = ',n_elements(dblarr_x(indarr_out))
  print,'rave_plot_two_cols: n_elements(dblarr_y) = ',n_elements(dblarr_y(indarr_out))

  if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
    indarrs_out = lonarr(i_nsamples + 1, n_elements(indarr_out))
    indarrs_out(0,*) = indarr_out
  endif

  ; --- plot all data
  set_plot,'ps'
  loadct,0
  print,'rave_plot_two_cols: str_plotname = '+str_plotname
  i_nxticks = 0
  if (xtitle eq 'Effective Temperature [K]') then begin
    i_nxticks = 4
    xtickformat='(I6)'
  end else if xtitle eq 'Radial Velocity [km/s]' then begin
    xtickformat = '(I6)'
  end else begin
    xtickformat = '(F6.1)'
  endelse
  if (ytitle eq 'Effective Temperature [K]') or (ytitle eq 'Radial Velocity [km/s]') or (ytitle eq 'log g [dex]') or (ytitle eq 'Surface Gravity [dex]') then begin
    ytickformat='(I6)'
  end else begin
    ytickformat = '(F6.1)'
  endelse

  ; --- plot y value versus x value
  if not keyword_set(STAR_TYPES_COL) then begin
    print,'rave_plot_two_cols: STAR_TYPES_COL not set'
    device,filename=str_plotname
      plot,dblarr_x(indarr_out),$
           dblarr_y(indarr_out),$
           TITLE=title,$
           XTITLE=xtitle,$
           YTITLE=ytitle,$
           PSYM=2,$
           charsize=1.8,$
           charthick=3.,$
           thick=3.,$
           xticks=i_nxticks,$
           xtickformat=xtickformat,$
           ytickformat=ytickformat,$
           position = [0.17,0.16,0.99,0.99]
    device,/close
    set_plot,'x'
;stop
  end else begin
    print,'rave_plot_two_cols: STAR_TYPES_COL set'
    print,'rave_plot_two_cols: n_elements(dblarr_x) = ',n_elements(dblarr_x(indarr_out))
    device,filename=str_plotname,/color
      plot,[dblarr_x(indarr_out(0)),dblarr_x(indarr_out(0))],$
           [dblarr_y(indarr_out(0)),dblarr_y(indarr_out(0))],$
           TITLE=title,$
           XTITLE=xtitle,$
           YTITLE=ytitle,$
           PSYM=2,$
           charsize=1.8,$
           charthick=3.,$
           thick=3.,$
           xticks=i_nxticks,$
           xtickformat=xtickformat,$
           ytickformat=ytickformat,$
           position = [0.17,0.16,0.91,0.99]

      rave_get_colour_table,B_POP_ID    = b_pop_id,$
                            RED         = red,$
                            GREEN       = green,$
                            BLUE        = blue,$
                            DBL_N_TYPES = dbl_n_types

;        print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
      ltab = 0
      modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_rave_plot_two_cols.tbl'
      loadct,ltab,FILE='colors1_rave_plot_two_cols.tbl'

      box,xrange(1),yrange(0),xrange(1)+((xrange(1)-xrange(0))/15.),yrange(0)+((yrange(1)-yrange(0))*(1)/dbl_n_types),1
      print,'rave_plot_two_cols: min(dblarr_star_types) = ',min(dblarr_star_types(indarr_out))
      print,'rave_plot_two_cols: max(dblarr_star_types) = ',max(dblarr_star_types(indarr_out))
      for l=0,long(dbl_n_types)-1 do begin
        if b_pop_id then begin
          if l eq 0 then begin
            m = 6
          end else if l eq 1 then begin
            m = 5
          end else if l eq 2 then begin
            m = 4
          end else if l eq 3 then begin
            m = 3
          end else if l eq 4 then begin
            m = 2
          end else if l eq 5 then begin
            m = 1
          end else if l eq 6 then begin
            m = 0
          end else if l eq 7 then begin
            m = 7
          end else if l eq 8 then begin
            m = 8
          end else begin
            m = 9
          endelse
        end else begin
          if l eq 0 then begin
            m = 2
          end else if l eq 1 then begin
            m = 4
          end else if l eq 2 then begin
            m = 3
          end else if l eq 3 then begin
            m = 1
          end else if l eq 4 then begin
            m = 0
          end else if l eq 5 then begin
            m = 5
          end else begin
            m = 6
          endelse
        endelse
        print,'rave_plot_two_cols: colour = ',m+1,': red = ',red(m+1),', green = ',green(m+1),', blue = ',blue(m+1)
        indarr = where(dblarr_star_types(indarr_out) eq m+1)
        print,'rave_plot_two_cols: size(indarr(m=',m,')) = ',size(indarr)
        if n_elements(indarr) ne 1 or indarr(0) ne -1 then begin
          oplot,dblarr_x(indarr_out(indarr)),$
                dblarr_y(indarr_out(indarr)),$
                PSYM=2,$
                thick=2.,$
                color=m+1
        endif
        box,xrange(1),yrange(0)+((yrange(1)-yrange(0))*m/dbl_n_types),xrange(1)+((xrange(1)-xrange(0))/15.),yrange(0)+((yrange(1)-yrange(0))*(m+1)/dbl_n_types),m+1

        rave_print_colour_id,B_POP_ID      = b_pop_id,$
                             INT_M         = m+1,$
                             DBLARR_XRANGE = xrange,$
                             DBLARR_YRANGE = yrange,$
                             DBL_N_TYPES   = dbl_n_types

      endfor
    device,/close
    set_plot,'x'

;    stop
  endelse

  i_nbins_x = 10
  i_nbins_y = 10
  if n_elements(indarr_out) gt 150 then begin
    i_nbins_x = 15
    i_nbins_y = 15
  endif
  dbl_min_x = min(dblarr_x(indarr_out)) - ((max(dblarr_x(indarr_out)) - min(dblarr_x(indarr_out)))/double(i_nbins_x))
  dbl_max_x = max(dblarr_x(indarr_out)) + ((max(dblarr_x(indarr_out)) - min(dblarr_x(indarr_out)))/double(i_nbins_x))
  dbl_min_y = min(dblarr_y(indarr_out)) - ((max(dblarr_y(indarr_out)) - min(dblarr_y(indarr_out)))/double(i_nbins_y))
  dbl_max_y = max(dblarr_y(indarr_out)) + ((max(dblarr_y(indarr_out)) - min(dblarr_y(indarr_out)))/double(i_nbins_y))
  my_hist_2d,DBLARR_X=dblarr_x(indarr_out),$; in
	      DBLARR_Y=dblarr_y(indarr_out),$; in
	      DBL_BINWIDTH_X=(dbl_max_x - dbl_min_x)/double(i_nbins_x),$; in
	      DBL_BINWIDTH_Y=(dbl_max_y - dbl_min_y)/double(i_nbins_y),$; in
	      DBL_MIN_X=dbl_min_x,$; in
	      DBL_MIN_Y=dbl_min_y,$; in
	      DBL_MAX_X=dbl_max_x,$; in
	      DBL_MAX_Y=dbl_max_y,$; in
	      O_DBLARR_X = o_dblarr_x,$; out
	      O_DBLARR_Y = o_dblarr_y,$; out
	      INTARR2D_HIST=intarr2d_hist,$; out
	      INTARR3D_INDEX=intarr3d_index; out
  str_plotname_cont = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'_cont.ps'
  set_plot,'ps'
  device,filename=str_plotname_cont
    contour,intarr2d_hist,$
	    o_dblarr_x,$
	    o_dblarr_y,$
	    /CLOSED,$
	    XTITLE=xtitle,$
	    YTITLE=ytitle,$
	    charsize=1.8,$
	    charthick=3.,$
	    thick=3.,$
	    xticks=i_nxticks,$
	    xtickformat=xtickformat,$
	    ytickformat=ytickformat,$
	    position = [0.17,0.16,0.91,0.99],$
            nlevels=10
  device,/close
  set_plot,'x'
  print,'rave_plot_two_cols: str_plotname_cont <'+str_plotname_cont+'> finished'

  ; --- create and plot random samples
  if not keyword_set(I_NSAMPLES) then $
    i_nsamples = 0





    ; put (indarr_out) behind all data arrays
    ; add dblarr_rave, indarr_rave, i_col_i_rave, i_col_logg_rave, i_col_lon_rave, i_col_lat_rave to keywords




;  if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then $
;    indarr_rave = intarr(nbins_i,n_elements(iarrout))

  if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
    print,'rave_plot_two_cols: CALCSAMPLES and I_NSAMPLES set'
    if i_nravestars gt 0 and i_nravestars lt n_elements(dblarr_x(indarr_out)) then begin
      if b_debug_i then $
        openw,lun_html,strmid(str_plotname,0,strpos(str_plotname,'/',/REVERSE_SEARCH)+1)+'index_samples.html',/GET_LUN
      if keyword_set(B_HIST) then begin
        indarr_out_bes=lonarr(I_NSAMPLES+1,n_elements(indarr_out))
        indarr_out_bes(0,*) = indarr_out
;        xarrout(0,*) = dblarr_x
;        yarrout=dblarr(I_NSAMPLES+1,n_elements(dblarr_x))
;        yarrout(0,*) = dblarr_y
;        if keyword_set(STAR_TYPES_COL) then begin
;          typesarrout = dblarr(I_NSAMPLES+1,n_elements(dblarr_x))
;          typesarrout(0,*) = dblarr_star_types
;        endif
      endif

; --- calculate i bins for rave data
;      print,'rave_plot_two_cols: iarrout = ',iarrout
;      print,'rave_plot_two_cols: size(iarrout) = ',size(iarrout)
;      dblarr_bins_i = dblarr(nbins_i+1)
;      intarr_bin_counts_rave_sampes = lonarr(i_nsamples)
;      intarr_bin_counts_i_besancon = lonarr(nbins_i)
;      dblarr_bins_i(0) = irange(0)
      if b_debug_i then begin
        dblarr_mean_i_rave = dblarr(nbins_i)
        dblarr_mean_i_bes = dblarr(nbins_i)
      endif
      ;indarr_i_bins_rave = ulonarr(nbins_i,n_elements(dblarr_ravedata(*,0)))
      ; --- calculate i bins and count rave stars in bin
;      for i=0,nbins_i-1 do begin
;        dblarr_bins_i(i+1) = dblarr_bins_i(i) + binwidth_i
;;          print,'i = ',i,': binrange = ',dblarr_bins(i),'...',dblarr_bins(i+1)
;        if i eq 0 then begin
;          indarr = where((dblarr_ravedata(*,i_col_i_rave) ge dblarr_bins_i(i)) and (dblarr_ravedata(*, i_col_i_rave) le dblarr_bins_i(i+1)))
;        end else begin
;          indarr = where((dblarr_ravedata(*, i_col_i_rave) gt dblarr_bins_i(i)) and (dblarr_ravedata(*, i_col_i_rave) le dblarr_bins_i(i+1)))
;        endelse
;        if indarr(0) lt 0 then begin
;          intarr_bin_counts_i_rave(i) = 0
;        end else begin
;          intarr_bin_counts_i_rave(i) = n_elements(indarr)
;          ;indarr_i_bins_rave(i,0:intarr_bin_counts_i_rave(i)-1) = indarr
;          if b_debug_i then $
;            dblarr_mean_i_rave(i) = mean(dblarr_ravedata(indarr, i_col_i_rave))
;        endelse
;        if b_debug_i then begin
;          if i lt 5 then $
;            print,'rave_plot_two_cols: i_rave(i=0) = dblarr_ravedata(indarr, i_col_i_rave) = ',dblarr_ravedata(indarr, i_col_i_rave)
;          print,'rave_plot_two_cols: dblarr_mean_i_rave(i=',i,') = ',dblarr_mean_i_rave(i)
;        endif
;      endfor
;      print,'rave_plot_two_cols: size(intarr_bin_counts_i_rave) = ',size(intarr_bin_counts_i_rave)
;      print,'rave_plot_two_cols: intarr_bin_counts_i_rave = ',intarr_bin_counts_i_rave
;      print,'rave_plot_two_cols: dblarr_bins_i=',dblarr_bins_i
;      stop

      meansigmasamples = dblarr(I_NSAMPLES,8)
      indarr_plot = ulonarr(i_nravestars); --- stores number of element of
      for i=0, i_nsamples-1 do begin
        indarr_plot(*) = -1
        str_plotname_sample = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'_'+strtrim(string(i),2)+strmid(str_plotname,strpos(str_plotname,'.',/REVERSE_SEARCH))
        print,'rave_plot_two_cols: i=',i,': str_plotname_sample = '+str_plotname_sample

        dblarr_x_plot = dblarr(i_nravestars)
        dblarr_y_plot = dblarr(i_nravestars)
        if not keyword_set(B_I_SEARCH) then begin; --- create random samples regardless the I-mag distribution of the RAVE stars in the field
          print,'rave_plot_two_cols: keyword B_I_SEARCH not set'
          for j=0, i_nravestars-1 do begin
            k = 0
            l = 0
            while (k eq 0) do begin
              l = l+1
              random_nr = long(RANDOMU(seed,/UNIFORM) * (n_elements(indarr_out)))
              random_pos = where(indarr_plot eq random_nr)
              if random_pos(0) eq -1 then k = 1
              if l gt 10 * i_nravestars then stop
            endwhile
            indarr_plot(j) = random_nr
;            print,'rave_plot_two_cols: i=',i,', j=',j,': indarr_plot(j) = ',indarr_plot(j)
          endfor
          dblarr_x_plot = dblarr_x(indarr_out(indarr_plot))
          dblarr_y_plot = dblarr_y(indarr_out(indarr_plot))
          if keyword_set(STAR_TYPES_COL) then begin
            dblarr_star_types_plot = dblarr_star_types(indarr_out(indarr_plot))
          end
        end else begin; --- create random samples with the same I-mag distribution of the RAVE stars in the field
          print,'rave_plot_two_cols: keyword B_I_SEARCH set'
          ;if intarr_bin_counts_i_rave(i) ge 1 then begin
;            print,'rave_plot_two_cols: intarr_bin_counts_i_rave(i=',i,') = ',intarr_bin_counts_i_rave(i),' >= 1'
            dblarr_besancondata = dblarr(n_elements(indarr_out),3)
            dblarr_besancondata(*,2) = dblarr_i(indarr_out)
            dblarr_ravedata_plot = dblarr(n_elements(dblarr_ravedata(*,0)),3)
            dblarr_ravedata_plot(*,2) = dblarr_ravedata(*, i_col_i_rave)
            o_indarr_besancondata = 1
            o_indarr_ravedata = 1
            o_dblarr_besancon_imag_bins = 1
            o_intarr_nstars_bin_i = 1
            if not keyword_set(B_SELECT_FROM_IMAG_AND_LOGG) then begin
              print,'rave_plot_two_cols: keyword B_SELECT_FROM_IMAG_AND_LOGG not set'
              besancon_select_stars_from_imag_bin,I_NBINS_I = nbins_i,$; --- must be set
                                                  DBL_I_MIN = irange(0),$; --- must be set
                                                  DBL_I_MAX = irange(1),$; --- must be set
                                                  STRARR_BESANCONDATA = dblarr_besancondata,$; --- must be set
                                                  DBLARR_RAVEDATA = dblarr_ravedata_plot,$; --- must be set
                                                  O_DBLARR_BESANCON_IMAG_BINS = o_dblarr_besancon_imag_bins,$; --- output parameter
                                                  O_INDARR_RAVE = o_indarr_ravedata,$; --- output parameter
                                                                                        ; --- set to 1 to write o_indarr_ravedata
                                                  O_INDARR_BESANCON = o_indarr_besancondata,$; --- output parameter
                                                                                ; --- set to 1 to write o_indarr_besancondata
                                                  O_INTARR_NSTARS_BIN_I = o_intarr_nstars_bin_i,$
                                                  DBL_SEED = dbl_seed
;              print,'rave_plot_two_cols: size(dblarr_besancondata) = ',size(dblarr_besancondata)
;              print,'rave_plot_two_cols: size(dblarr_ravedata) = ',size(dblarr_ravedata_plot)
;              print,'rave_plot_two_cols: intarr_bin_counts_i_rave(i) = ',intarr_bin_counts_i_rave(i)
;              print,'rave_plot_two_cols: size(o_indarr_ravedata) = ',size(o_indarr_ravedata)
;              print,'rave_plot_two_cols: size(o_indarr_besancondata) = ',size(o_indarr_besancondata)
;              print,'rave_plot_two_cols: size(o_dblarr_besancon_imag_bins) = ',size(o_dblarr_besancon_imag_bins)
              indarr_imag_bins_out = where(o_dblarr_besancon_imag_bins gt 0.)
;              print,'rave_plot_two_cols: n_elements(indarr_imag_bins_out) = ',n_elements(indarr_imag_bins_out)
;              print,'rave_plot_two_cols: nbins_i = ',nbins_i
;              print,'rave_plot_two_cols: o_intarr_nstars_bin_i = ',o_intarr_nstars_bin_i
;              print,'rave_plot_two_cols: total(o_intarr_nstars_bin_i) = ',total(o_intarr_nstars_bin_i)
              ;print,'dbl_seed = ',dbl_seed
;              stop
            end else begin
              print,'rave_plot_two_cols: keyword B_SELECT_FROM_IMAG_AND_LOGG set'
              dblarr_besancondata(*,1) = dblarr_logg(indarr_out)
              ;if intarr_bin_counts_i_rave(i) gt 0 then begin
;                print,'rave_plot_two_cols: intarr_bin_counts_i_rave(i=',i,') = ',intarr_bin_counts_i_rave(i),' > 0'
                dblarr_ravedata_plot(*,1) = $;0:intarr_bin_counts_i_rave(i)-1,1) =
                                            dblarr_ravedata(*,i_col_logg_rave);indarr_i_bins_rave(i,0:intarr_bin_counts_i_rave(i)-1), i_col_logg_rave)
                dblarr_ravedata_plot(*,2) = $;0:intarr_bin_counts_i_rave(i)-1,2) =
                                            dblarr_ravedata(*,i_col_i_rave);indarr_i_bins_rave(i,0:intarr_bin_counts_i_rave(i)-1), i_col_i_rave)
;                print,'rave_plot_two_cols: dbl_seed = ',dbl_seed
                besancon_select_stars_from_logg_imag_bin,I_NBINS_I                   = nbins_i,$; --- must be set
                                                        DBL_I_MIN                   = irange(0),$; --- must be set
                                                        DBL_I_MAX                   = irange(1),$; --- must be set
                                                        STRARR_BESANCONDATA         = dblarr_besancondata,$; --- must be set
                                                        DBLARR_RAVEDATA             = dblarr_ravedata_plot,$; --- must be set
                                                        O_DBLARR_BESANCON_IMAG_BINS = o_dblarr_besancon_imag_bins,$; --- output parameter
                                                        O_INDARR_RAVE               = o_indarr_ravedata,$; --- output parameter
                                                                                    ; --- set to 1 to write o_indarr_ravedata
                                                        O_INDARR_BESANCON           = o_indarr_besancondata,$; --- output parameter
                                                                                    ; --- set to 1 to write o_indarr_besancondata
                                                        O_INTARR_NSTARS_BIN_I       = o_intarr_nstars_bin_i,$
                                                        DBL_SEED                    = dbl_seed,$
                                                        I_COL_I_RAVE                = 2,$
                                                        I_COL_I_BESANCON            = 2,$
                                                        I_COL_LOGG_RAVE             = 1,$
                                                        I_COL_LOGG_BESANCON         = 1
;                print,'rave_plot_two_cols: dbl_seed = ',dbl_seed
;                print,'rave_plot_two_cols: o_indarr_besancon = ',o_indarr_besancondata
;                print,'rave_plot_two_cols: dblarr_besancondata(o_indarr_besancondata,1) = ',dblarr_besancondata(o_indarr_besancondata,1)
;              end else begin
;                print,'rave_plot_two_cols: intarr_bin_counts_i_rave(i=',i,') = ',intarr_bin_counts_i_rave(i),' <= 0'
;                o_indarr_besancondata = [-1]
;                o_indarr_ravedata = [-1]
;                o_dblarr_besancon_imag_bins = [-1]
;              endelse
            endelse
;                print,'rave_plot_two_cols: dblarr_ravedata_plot = ',dblarr_ravedata_plot
;                print,'rave_plot_two_cols: o_dblarr_besancon_imag_bins = ',o_dblarr_besancon_imag_bins
;                print,'rave_plot_two_cols: o_indarr_besancondata = ',o_indarr_besancondata
;                print,'rave_plot_two_cols: o_indarr_ravedata = ',o_indarr_ravedata
;                print,'rave_plot_two_cols: o_intarr_nstars_bin_i = ',o_intarr_nstars_bin_i
;                stop
          ;end else begin
          ;  print,'rave_plot_two_cols: intarr_bin_counts_i_rave(i=',i,') = ',intarr_bin_counts_i_rave(i),' < 1'
          ;  ;o_indarr_ravedata = [-1]
          ;end

          if o_indarr_ravedata(0) ge 0 then begin
            print,'rave_plot_two_cols: o_indarr_ravedata(0) = ',o_indarr_ravedata(0),' >= 0'
;            intarr_bin_counts_rave_samples(i) = n_elements(o_indarr_ravedata)
            indarr_plot = indarr_out(o_indarr_besancondata)
;            n = n_elements(o_indarr_besancondata)-1
            if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then begin
              dblarr_logg_sample = dblarr_logg(indarr_plot)
              indarr_giants = where(dblarr_logg_sample lt 3.5, COMPLEMENT=indarr_dwarfs)
;              print,'rave_plot_two_cols: i=',i,': indarr_giants = ',indarr_giants
;              print,'rave_plot_two_cols: i=',i,': indarr_dwarfs = ',indarr_dwarfs

              if indarr_giants(0) lt 0 then $
                dbl_giant_to_dwarf_ratio = 0.
              if indarr_dwarfs(0) lt 0 then $
                dbl_giant_to_dwarf_ratio = 999999999.
              if indarr_giants(0) ge 0 and indarr_dwarfs(0) ge 0 then $
                dbl_giant_to_dwarf_ratio = double(n_elements(indarr_giants)) / double(n_elements(indarr_dwarfs))
;              print,'rave_plot_two_cols: dbl_giant_to_dwarf_ratio = ',dbl_giant_to_dwarf_ratio

              if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
                io_plot_giant_to_dwarf_ratio(i) = dbl_giant_to_dwarf_ratio
              end else begin
                io_plot_giant_to_dwarf_ratio = [dbl_giant_to_dwarf_ratio]
              end
;              print,'rave_plot_two_cols: io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
              dblarr_logg_sample = 0
              indarr_giants = [0]
              indarr_dwarfs = [0]
            endif
          end else begin
;            print,'rave_plot_two_cols: o_indarr_ravedata(0) = ',o_indarr_ravedata(0),' < 0'
;            intarr_bin_counts_rave_samples(i) = 0
;            n = -1
            indarr_plot = [-1]
          endelse
          o_indarr_besancondata = 0

          if b_debug_i then begin
            for lll=0,nbins_i-1 do begin
              dblarr_mean_i_bes(lll) = mean(o_dblarr_besancon_imag_bins(lll,0:o_intarr_nstars_bin_i(lll,1)-1,2))
            endfor
            print,'rave_plot_two_cols: mean(dblarr_mean_i_bes) = ',mean(dblarr_mean_i_bes)
            print,'rave_plot_two_cols: mean(dblarr_mean_i_rave) = ',mean(dblarr_mean_i_rave)
            dblarr_mean_i_bes_min_rave = dblarr_mean_i_bes - dblarr_mean_i_rave
            print,'rave_plot_two_cols: dblarr_mean_i_bes - dblarr_mean_i_rave = ',dblarr_mean_i_bes_min_rave
            print,'rave_plot_two_cols: mean(dblarr_mean_i_bes - dblarr_mean_i_rave) = ',mean(dblarr_mean_i_bes_min_rave)
            stop
          endif
          if indarr_plot(0) lt 0 then begin
            dblarr_x_plot = 0.
            dblarr_y_plot = 0.
            if keyword_set(STAR_TYPES_COL) then begin
              dblarr_star_types_plot = 0.
            endif
          end else begin
            dblarr_x_plot = dblarr_x(indarr_plot)
            dblarr_y_plot = dblarr_y(indarr_plot)
            if keyword_set(STAR_TYPES_COL) then begin
              dblarr_star_types_plot = dblarr_star_types(indarr_plot)
            endif
          endelse
        endelse; --- create random samples with the same I-mag distribution of the RAVE stars in the field

        if n_elements(dblarr_x_plot) gt 1 then begin
          momentx_plot = moment(dblarr_x_plot)
          momenty_plot = moment(dblarr_y_plot)
        end else if n_elements(dblarr_x_plot) eq 1 then begin
          momentx_plot = [dblarr_x_plot,0.,0.,0.]
          momenty_plot = [dblarr_y_plot,0.,0.,0.]
        end else begin
          momentx_plot = [0.,0.,0.,0.]
          momenty_plot = [0.,0.,0.,0.]
        end
        meanx_plot = momentx_plot(0);mean(dblarr_x_plot)
        sigmax_plot = sqrt(momentx_plot(1));meanabsdev(dblarr_x_plot)

        meany_plot = momenty_plot(0);mean(dblarr_y_plot)
        sigmay_plot = sqrt(momenty_plot(1));meanabsdev(dblarr_y_plot)
;        print,'rave_plot_two_cols: i=',i,', j=',j,': meanx_plot=',meanx_plot,', sigmax_plot=',sigmax_plot,', meany_plot=',meany_plot,', sigmay_plot=',sigmay_plot

        meansigmasamples(i,0) = momentx_plot(0)
        meansigmasamples(i,1) = momenty_plot(0)
        meansigmasamples(i,2) = sqrt(momentx_plot(1))
        meansigmasamples(i,3) = sqrt(momenty_plot(1))
        meansigmasamples(i,4) = momentx_plot(2)
        meansigmasamples(i,5) = momenty_plot(2)
        meansigmasamples(i,6) = momentx_plot(3)
        meansigmasamples(i,7) = momenty_plot(3)
        ;if keyword_set(CALCSAMPLES) then begin
          ;print,'dblarr_x_plot = ',dblarr_x_plot
          ;print,'dblarr_y_plot = ',dblarr_y_plot
          ;print,'n_elements(dblarr_x_plot) = ',n_elements(dblarr_x_plot)
          ;print,'n_elements(dblarr_y_plot) = ',n_elements(dblarr_y_plot)
          ;print,'meansigmasamples(i=',i,',*) = ',meansigmasamples(i,*)
          ;stop
        ;endif
        xtitle = str_xtitle;+' mean = '+strtrim(string(meanx_plot),2)+', sigma = '+strtrim(string(sigmax_plot),2)
        ytitle = str_ytitle;+' mean = '+strtrim(string(meany_plot),2)+', sigma = '+strtrim(string(sigmay_plot),2)
        if xtitle eq 'Effective Temperature [K]' then begin
          i_nxticks = 4
        end else begin
          i_nxticks = 0
        end
        if n_elements(dblarr_x_plot) gt 1 or (dblarr_x_plot(0) ne -1 and abs(dblarr_x_plot(0)) gt 0.00000000001) then begin
          set_plot,'ps'
          if not keyword_set(B_SAMPLES_COLOUR) then begin
            device,filename=str_plotname_sample
              plot,dblarr_x_plot,$
                   dblarr_y_plot,$
                   title=title,$
                   xtitle=xtitle,$
                   ytitle=ytitle,$
                   psym=2,$
                   thick=3.,$
                   charsize=1.8,$
                   charthick=3.,$
                   xticks = i_nxticks,$
                   xtickformat=xtickformat,$
                   ytickformat=ytickformat,$
                   position = [0.17,0.16,0.91,0.99]
            device,/close
          end else begin
            device,filename=str_plotname_sample,/color
            plot,[dblarr_x_plot(0),dblarr_x_plot(0)],$
                 [dblarr_y_plot(0),dblarr_y_plot(0)],$
                 TITLE=title,$
                 XTITLE=xtitle,$
                 YTITLE=ytitle,$
                 PSYM=2,$
                 charsize=1.8,$
                 charthick=3.,$
                 thick=3.,$
                 xticks=i_nxticks,$
                 xtickformat=xtickformat,$
                 ytickformat=ytickformat,$
                 position = [0.17,0.16,0.91,0.99]

;            device,/close
;            stop

            rave_get_colour_table,B_POP_ID    = b_pop_id,$
                                  RED         = red,$
                                  GREEN       = green,$
                                  BLUE        = blue,$
                                  DBL_N_TYPES = dbl_n_types
;        print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
            ltab = 0
            modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_rave_plot_two_cols.tbl'
            loadct,ltab,FILE='colors1_rave_plot_two_cols.tbl'

            box,xrange(1),yrange(0),xrange(1)+((xrange(1)-xrange(0))/15.),yrange(0)+((yrange(1)-yrange(0))*(1)/dbl_n_types),1
;            print,'rave_plot_two_cols: min(dblarr_star_types) = ',min(dblarr_star_types(indarr_plot))
;            print,'rave_plot_two_cols: max(dblarr_star_types) = ',max(dblarr_star_types(indarr_plot))
            for l=0,long(dbl_n_types)-1 do begin
              if b_pop_id then begin
                if l eq 0 then begin
                  m = 6
                end else if l eq 1 then begin
                  m = 5
                end else if l eq 2 then begin
                  m = 4
                end else if l eq 3 then begin
                  m = 3
                end else if l eq 4 then begin
                  m = 2
                end else if l eq 5 then begin
                  m = 1
                end else if l eq 6 then begin
                  m = 0
                end else if l eq 7 then begin
                  m = 7
                end else if l eq 8 then begin
                  m = 8
                end else begin
                  m = 9
                end
              end else begin
                if l eq 0 then begin
                  m = 2
                end else if l eq 1 then begin
                  m = 4
                end else if l eq 2 then begin
                  m = 3
                end else if l eq 3 then begin
                  m = 1
                end else if l eq 4 then begin
                  m = 0
                end else if l eq 5 then begin
                  m = 5
                end else begin
                  m = 6
                end
              endelse
              print,'rave_plot_two_cols: colour = ',m+1,': red = ',red(m+1),', green = ',green(m+1),', blue = ',blue(m+1)
              indarr = where(dblarr_star_types_plot eq m+1)
              print,'rave_plot_two_cols: size(indarr(m=',m,')) = ',size(indarr)
              if indarr(0) ne -1 then begin
                oplot,dblarr_x_plot(indarr),$
                      dblarr_y_plot(indarr),$
                      PSYM=2,$
                      thick=2.,$
                      color=m+1
              endif
              box,xrange(1),yrange(0)+((yrange(1)-yrange(0))*m/dbl_n_types),xrange(1)+((xrange(1)-xrange(0))/15.),yrange(0)+((yrange(1)-yrange(0))*(m+1)/dbl_n_types),m+1
              rave_print_colour_id,B_POP_ID      = b_pop_id,$
                                   INT_M         = m+1,$
                                   DBLARR_XRANGE = xrange,$
                                   DBLARR_YRANGE = yrange,$
                                   DBL_N_TYPES   = dbl_n_types
            endfor
            device,/close
          endelse
          set_plot,'x'



	  i_nbins_x = 10
	  i_nbins_y = 10
	  if n_elements(dblarr_x_plot) gt 150 then begin
	    i_nbins_x = 15
	    i_nbins_y = 15
	  endif
	  dbl_min_x = min(dblarr_x_plot) - ((max(dblarr_x_plot) - min(dblarr_x_plot))/double(i_nbins_x))
	  dbl_max_x = max(dblarr_x_plot) + ((max(dblarr_x_plot) - min(dblarr_x_plot))/double(i_nbins_x))
	  dbl_min_y = min(dblarr_y_plot) - ((max(dblarr_y_plot) - min(dblarr_y_plot))/double(i_nbins_y))
	  dbl_max_y = max(dblarr_y_plot) + ((max(dblarr_y_plot) - min(dblarr_y_plot))/double(i_nbins_y))
	  my_hist_2d,DBLARR_X=dblarr_x_plot,$; in
		    DBLARR_Y=dblarr_y_plot,$; in
		    DBL_BINWIDTH_X=(dbl_max_x - dbl_min_x)/double(i_nbins_x),$; in
		    DBL_BINWIDTH_Y=(dbl_max_y - dbl_min_y)/double(i_nbins_y),$; in
		    DBL_MIN_X=dbl_min_x,$; in
		    DBL_MIN_Y=dbl_min_y,$; in
		    DBL_MAX_X=dbl_max_x,$; in
		    DBL_MAX_Y=dbl_max_y,$; in
		    O_DBLARR_X = o_dblarr_x,$; out
		    O_DBLARR_Y = o_dblarr_y,$; out
		    INTARR2D_HIST=intarr2d_hist,$; out
		    INTARR3D_INDEX=intarr3d_index; out
	  str_plotname_cont = strmid(str_plotname_sample,0,strpos(str_plotname_sample,'.',/REVERSE_SEARCH))+'_cont.ps'
	  set_plot,'ps'
	  device,filename=str_plotname_cont
	    contour,intarr2d_hist,$
		    o_dblarr_x,$
		    o_dblarr_y,$
		    /CLOSED,$
		    XTITLE=xtitle,$
		    YTITLE=ytitle,$
		    charsize=1.8,$
		    charthick=3.,$
		    thick=3.,$
		    xticks=i_nxticks,$
		    xtickformat=xtickformat,$
		    ytickformat=ytickformat,$
		    position = [0.17,0.16,0.91,0.99],$
                    nlevels=10
	  device,/close
	  set_plot,'x'
	  print,'rave_plot_two_cols: str_plotname_cont <'+str_plotname_cont+'> finished'

;          print,'rave_plot_two_cols: n_elements(dblarr_x) = ',n_elements(dblarr_x)
;          print,'rave_plot_two_cols: n_elements(dblarr_y) = ',n_elements(dblarr_y)
;          stop
          if keyword_set(B_HIST) and keyword_set(INDARRS_OUT) then begin
            indarrs_out(i+1,0:n_elements(indarr_plot)-1) = indarr_plot
            ;print,'rave_plot_two_cols: indarr_out = ',indarr_out
            ;print,'rave_plot_two_cols: indarr_plot = ',indarr_plot
            ;print,'rave_plot_two_cols: indarrs_out(i+1=',i+1,', 0:n_elements(indarr_plot)-1) = ',indarrs_out(i+1,0:n_elements(indarr_plot)-1)
;            stop
          endif
        endif
;        if i eq 1 then stop
      endfor; nsamples
      if b_debug_i then begin
        free_lun,lun_html
        stop
      endif
    end else begin
      meansigmasamples = 0
    endelse
  end else begin;if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
    meansigmasamples = 0
;    print,'dblarr_logg(indarr_out) = ',dblarr_logg(indarr_out)
;    print,'io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
;    stop
    if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then begin
      indarr_giants = where(dblarr_logg(indarr_out) lt 3.5, COMPLEMENT=indarr_dwarfs)
      io_plot_giant_to_dwarf_ratio = [double(n_elements(indarr_giants)) / double(n_elements(indarr_dwarfs))]
      if indarr_giants(0) lt 0 then begin
        io_plot_giant_to_dwarf_ratio = 0.
      endif
      if indarr_dwarfs(0) lt 0 then begin
        io_plot_giant_to_dwarf_ratio = 999999.
      endif
      print,'rave_plot_two_cols: n_elements(indarr_giants) = ',n_elements(indarr_giants)
      print,'rave_plot_two_cols: n_elements(indarr_dwarfs) = ',n_elements(indarr_dwarfs)
      print,'rave_plot_two_cols: io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
      indarr_giants = 0
      indarr_dwarfs = 0
;      stop
    endif
  end


  problem=0
  str_path=0
  strarr_data=0
  strarr_lines=0
end
