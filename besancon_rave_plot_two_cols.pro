pro besancon_rave_plot_two_cols,PATH                 = path,$
                                SUBPATH              = subpath,$
                                FIELDSFILE           = fieldsfile,$
                                I_STR_PIXELMAP       = i_str_pixelmap,$
                                RAVEDATAFILE         = ravedatafile,$
                                BESANCONDATAFILE     = besancondatafile,$
                                STRARR_RAVE_DATA     = strarr_rave_data,$
                                STRARR_BESANCON_DATA = strarr_besancon_data,$
                                XCOLRAVE             = xcolrave,$
                                XCOLBESANCON         = xcolbesancon,$
                                XTITLE               = xtitle,$
                                XRANGESET            = xrangeset,$
                                XLOGRAVE             = xlograve,$
                                XLOGBES              = xlogbes,$
                                YLOGRAVE             = ylograve,$
                                YLOGBES              = ylogbes,$
                                YCOLRAVE             = ycolrave,$
                                YCOLBESANCON         = ycolbesancon,$
                                YTITLE               = ytitle,$
                                YRANGESET            = yrangeset,$
                                IRANGE               = irange,$
                                ICOLRAVE             = icolrave,$
                                ICOLBESANCON         = icolbesancon,$
                                FORCEXRANGE          = forcexrange,$
                                FORCEYRANGE          = forceyrange,$
                                REJECTVALUEX         = rejectvaluex,$
                                REJECTVALUEY         = rejectvaluey,$
;                                NREJECTEDX           = nrejectedx,$
;                                NREJECTEDY           = nrejectedy,$
                                LONLAT               = lonlat,$
                                CALCSAMPLES          = calcsamples,$
                                I_NSAMPLES           = i_nsamples,$
                                TEST                 = test,$
                                XYTITLE              = xytitle,$
                                B_HIST               = b_hist,$
                                B_POP_ID             = b_pop_id,$; --- if not set but STAR_TYPES_COL is set then star type is used for colour code in histograms
                                STAR_TYPES_COL       = star_types_col,$
                                B_CALCNBINS          = b_calcnbins,$
                                NBINSMIN             = nbinsmin,$
                                NBINSMAX             = nbinsmax,$
                                B_I_SEARCH           = b_i_search,$
                                DBL_XMAX             = dbl_xmax,$
                                DBL_YMAX             = dbl_ymax,$
                                B_PLOT_MEAN_KST      = b_plot_mean_kst,$
                                I_COL_LON_BESANCON   = i_col_lon_besancon,$
                                I_COL_LAT_BESANCON   = i_col_lat_besancon,$
                                I_COL_LOGG_RAVE      = i_col_logg_rave,$
                                I_COL_LOGG_BESANCON  = i_col_logg_besancon,$
                                I_PLOT_GIANT_TO_DWARF_RATIO = i_plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                                B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                                B_PLOT_CONTOURS       = b_plot_contours,$
                                B_DO_BOXCAR_SMOOTHING = b_do_boxcar_smoothing


;  rave_plot_I_Teff_all

  dbl_r_sun = 8.5
  dbl_seed = 17.

  dblarr_position = [0.16,0.16,0.91,0.99]
                if xtitle eq 'Radial Velocity [km/s]' then begin
                  int_xticks = 6
                  str_xtickformat = '(I6)'
                end else if xtitle eq 'Effective Temperature [K]' then begin
                  int_xticks = 4
                  str_xtickformat = '(I6)'
                end else if (xtitle eq 'Metallicity [dex]') or (xtitle eq 'Iron Abundance [dex]') then begin
                  int_xticks = 6
                  str_xtickformat = '(F4.1)'
                end else if xtitle eq 'Surface Gravity [dex]' then begin
                  int_xticks = 6
                  str_xtickformat = '(I1)'
                end else if strpos(xtitle,'mag') gt 0 then begin
                  int_xticks = 6
                  str_xtickformat = '(F4.1)'
                end else if xtitle eq 'Distance [kpc]' then begin
                  i_xticks = 5
                  str_xtickformat = '(I2)'
                end else if xtitle eq 'z [kpc]' then begin
                  int_xticks = 6
                  str_xtickformat = '(F4.1)'
                end else if xtitle eq 'r!Dcent!N [kpc]' then begin
                  int_xticks = 4
                  str_xtickformat = '(I2)'
                end else begin
                  int_xticks = 6
                  str_xtickformat = '(F4.1)'
                end
                if ytitle eq 'Radial Velocity [km/s]' then begin
                  int_yticks = 6
                  str_ytickformat = '(I6)'
                end else if ytitle eq 'Effective Temperature [K]' then begin
                  int_yticks = 4
                  str_ytickformat = '(I6)'
                end else if (ytitle eq 'Metallicity [dex]') or (ytitle eq 'Iron Abundance [dex]') then begin
                  int_yticks = 6
                  str_ytickformat = '(F4.1)'
                end else if ytitle eq 'Surface Gravity [dex]' then begin
                  int_yticks = 6
                  str_ytickformat = '(I1)'
                end else if strpos(ytitle,'mag') gt 0 then begin
                  int_yticks = 6
                  str_ytickformat = '(F4.1)'
                end else if ytitle eq 'Distance [kpc]' then begin
                  i_yticks = 5
                  str_ytickformat = '(I2)'
                end else if ytitle eq 'z [kpc]' then begin
                  int_yticks = 6
                  str_ytickformat = '(F4.1)'
                end else if ytitle eq 'r_cent [kpc]' then begin
                  int_yticks = 4
                  str_ytickformat = '(I2)'
                end else begin
                  int_yticks = 6
                  str_ytickformat = '(F4.1)'
                end

  if not keyword_set(NBINSMIN) then $
    nbinsmin = 25
  if not keyword_set(NBINSMAX) then $
    nbinsmax = 50

  if (not keyword_set(XLOGRAVE)) then xlograve = 0
  if (not keyword_set(XLOGBES)) then xlogbes = 0
  if (not keyword_set(YLOGRAVE)) then ylograve = 0
  if (not keyword_set(YLOGBES)) then ylogbes = 0
  if (not keyword_set(ICOL)) then icol = 4.
  if (not keyword_set(XCOLRAVE)) then xcolrave = 2
  if keyword_set(XCOLBESANCON) then begin
    i_xcol_besancon = xcolbesancon
  end else begin
    i_xcol_besancon = 12
    print,'besancon_rave_plot_two_cols: keyword XCOLBESANCON not set => set to ',i_xcol_besancon
  end
  if i_xcol_besancon eq 0.0001 then $
    i_xcol_besancon = 0
  if (not keyword_set(YCOLRAVE)) then ycolrave = 3
  if (not keyword_set(YCOLBESANCON)) or ycolbesancon eq 0.0001 then begin
    ycolbesancon = 0
    print,'besancon_rave_plot_two_cols: keyword_set(YCOLBESANCON) == FALSE => ycolbesancon set to 0'
  end
  if (not keyword_set(XTITLE)) then xtitle = 'I [mag]'
  if (not keyword_set(YTITLE)) then ytitle = 'vrad [km/s]'
  if (not keyword_set(SUBPATH)) then subpath = 'I_vrad'
  if (not keyword_set(FORCEYRANGE)) then forceyrange = 0
  if (not keyword_set(REJECTVALUEX)) then rejectvaluex = 0
  if (not keyword_set(REJECTVALUEY)) then rejectvaluey = 0

  d_times_sig_meansig = 1.
  d_times_sig_samples = 3.

  momentx=0.
  momenty=0.
;  meanx=0.
;  sigmax=0.
;  meany=0.
;  sigmay=0.

  if keyword_set(B_CALCNBINS) then begin
    i_nbins = 0
  end else begin
    i_nbins = nbinsmin
  end

  if (not keyword_set(FIELDSFILE)) then $
    fieldsfile = '/suphys/azuri/daten/rave/rave_data/release3/fields.dat'
  i_nfields = countdatlines(fieldsfile)

  if keyword_set(B_CALCNBINS) and keyword_set(I_NSAMPLES) then begin
    dblarr_kst = dblarr(i_nfields,i_nsamples,4)
  endif

  dblarr_dd_x = dblarr(i_nfields)
  dblarr_dd_y = dblarr(i_nfields)
  dblarr_prob_x = dblarr(i_nfields)
  dblarr_prob_y = dblarr(i_nfields)

  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor

  if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
    dblarr_giant_to_dwarf_ratio = dblarr(i_nfields,i_nsamples+1)
    dblarr_giant_to_dwarf = dblarr(i_nfields,3); 0: RAVE, 1: mean(samples), 2: sigma(samples)
  end

  meansigrave = dblarr(i_nfields*2,4)
  meansigbes = dblarr(i_nfields*2,4)
  meansigbes_samples = dblarr(i_nfields,16)
  meansigfiles = strarr(i_nfields)
  dblarr_ra_dec = dblarr(i_nfields,4)
  intarr_nstars = ulonarr(i_nfields,2)
  i_nplots = 0
  i_fieldnr = -1
  problem_rave = 0
  problem_bes = 0

  if keyword_set(BESANCONDATAFILE) then begin
    datafile = besancondatafile
    b_one_besanconfile = 1
  end
  if keyword_set(STRARR_BESANCON_DATA) then begin
    b_one_besanconfile = 1
  end else begin
    datafiles = strarr_fields(*,4)
    b_one_besanconfile = 0
  end

; --- calculate I mag bin width
  print,'besancon_rave_plot_two_cols: Calculating I mag bin width'
  nbins_i = 1
  dbl_bin_width_i = 1.
  get_bin_width,DBLARR_DATA_A=double(strarr_rave_data(*,icolrave)),$; --- in
                DBLARR_DATA_B=double(strarr_besancon_data(*,icolbesancon)),$; --- in
                DBLARR_BIN_RANGE=irange,$; --- in
                I_NBINS_MIN=nbinsmin,$; --- in
                I_NBINS_MAX=nbinsmax,$; --- in
                DBL_BIN_WIDTH=dbl_bin_width_i,$; --- out
                NBINS=nbins_i; --- out
;  openw,lunc,'debug_besancon_rave_plot_two_cols.test',/GET_LUN
  print,'besancon_rave_plot_two_cols: dbl_bin_width_i = ',dbl_bin_width_i
;    printf,lunc,'besancon_rave_plot_two_cols: xrange = ',xrange
;    printf,lunc,'besancon_rave_plot_two_cols: dbl_bin_width_i = ',dbl_bin_width_i
  print,'besancon_rave_plot_two_cols: nbins = ',nbins_i
;    printf,lunc,'besancon_rave_plot_two_cols: nbins = ',nbins_i
;    printf,lunc,'besancon_rave_plot_two_cols: nbinsmin = ',nbinsmin
;    printf,lunc,'besancon_rave_plot_two_cols: nbinsmax = ',nbinsmax
;  free_lun,lunc

  print,'besancon_rave_plot_two_cols: nbins_i = ',nbins_i,', dbl_bin_width_i = ',dbl_bin_width_i

; --- write main index html file
  if not keyword_set(PATH) then begin
    str_path = '/suphys/azuri/daten/besancon/'
    if keyword_set(LONLAT) then begin
      str_path = str_path+'lon-lat/'
    end
    if keyword_set(TEST) then begin
      str_path = str_path+'test/'
    end
    str_path = str_path+'html/'+subpath+'/'
  end else begin
    str_path = path+subpath+'/'
  end
  if irange(0) gt 0. then $
    str_path = str_path + 'I' + strmid(strtrim(string(irange(0)),2),0,4) + '-'
  if irange(1) gt 0. then $
    str_path = str_path + strmid(strtrim(string(irange(1)),2),0,4) + '/'
  print,'besancon_rave_plot_two_cols: str_path = '+str_path
  spawn,'rm -r '+str_path
  spawn,'mkdir '+str_path
  if not keyword_set(LONLAT) then begin
    spawn,'rm '+str_path+'rave_chart.gif'
    spawn,'ln -s /suphys/azuri/daten/rave/rave_data/rave_chart.gif '+str_path+'rave_chart.gif'
  end else begin
    spawn,'rm '+str_path+'rave_chart.gif'
    spawn,'ln -s /suphys/azuri/daten/rave/rave_data/rave_chart_lon_lat.gif '+str_path+'rave_chart.gif'
  end

  lonarr_nrejectedx = lonarr(i_nfields)
  lonarr_nrejectedy = lonarr(i_nfields)

  meansigmasamples = 1
  xrangeset_orig = xrangeset
  yrangeset_orig = yrangeset

  for i=0UL,i_nfields-1 do begin

    html_path = strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+$
                '-'+$
                strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+$
                '_'+$
                strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+$
                '-'+$
                strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))
    print,'besancon_rave_plot_two_cols: html_path = '+html_path

; --- create html doc
    spawn,'rm -r '+str_path+html_path
    spawn,'mkdir '+str_path+html_path

    openw,luna,str_path+html_path+'/kolmogorov-smirnov.dat',/GET_LUN
    if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
      print,'opening '+str_path+html_path+'/giant-to-dwarf_ratio.dat'
      openw,lun_giants_to_dwarf,str_path+html_path+'/giant-to-dwarf_ratio.dat',/GET_LUN
    endif

; --- write one line of strarr_fields to file and start rave_plot_two_cols_all
    str_ravedatafile = strmid(ravedatafile,strpos(ravedatafile,'/',/REVERSE_SEARCH)+1)
    openw,lunw,path+subpath+strmid(str_ravedatafile,0,strpos(str_ravedatafile,'.',/REVERSE_SEARCH))+'_temp.txt',/GET_LUN
      printf,lunw,strarr_fields(i,0)+' '+strarr_fields(i,1)+' '+strarr_fields(i,2)+' '+strarr_fields(i,3)
    free_lun,lunw

    if xtitle eq 'z [kpc]' then begin
      if strarr_fields(i,2) gt 0 then begin
        xrangeset(0) = 0.
        xrangeset(1) = xrangeset_orig(1)
      end else begin
        xrangeset(0) = xrangeset_orig(0)
        xrangeset(1) = 0.
      end
    end else if xtitle eq 'r!Dcent!N [kpc]' then begin
      if strarr_fields(i,1) lt 90. or strarr_fields(i,0) gt 270. then begin
        xrangeset(0) = xrangeset_orig(0)
        xrangeset(1) = dbl_r_sun
      end else begin
        xrangeset(0) = dbl_r_sun
        xrangeset(1) = xrangeset_orig(1)
      end
    end
    if ytitle eq 'z [kpc]' then begin
      if strarr_fields(i,2) gt 0 then begin
        yrangeset(0) = 0.
        yrangeset(1) = yrangeset_orig(1)
      end else begin
        yrangeset(0) = yrangeset_orig(0)
        yrangeset(1) = 0.
      end
    end else if ytitle eq 'r!Dcent!N [kpc]' then begin
      if strarr_fields(i,1) lt 90. or strarr_fields(i,0) gt 270. then begin
        yrangeset(0) = yrangeset_orig(0)
        yrangeset(1) = dbl_r_sun
      end else begin
        yrangeset(0) = dbl_r_sun
        yrangeset(1) = yrangeset_orig(1)
      end
    end
;    if keyword_set(XRANGESET) then $
    xrange = xrangeset
;    if keyword_set(YRANGESET) then $
    yrange = yrangeset
    yminbak = yrange(0)
    ymaxbak = yrange(1)
    oldymin = yrange(0)
    oldymax = yrange(1)
    if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
      plot_giant_to_dwarf_ratio = i_plot_giant_to_dwarf_ratio
    end else begin
      plot_giant_to_dwarf_ratio = 0
    end
;    print,'besancon_rave_plot_two_cols: plot_giant_to_dwarf_ratio = ',plot_giant_to_dwarf_ratio
;    stop
    str_title_rave = 'RAVE'; l='+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', b='+strarr_fields(i,2)+' - '+strarr_fields(i,3)
    str_ravedatafile = strmid(ravedatafile,strpos(ravedatafile,'/',/REVERSE_SEARCH)+1)
    rave_plot_two_cols_all,FIELDSFILE=path+subpath+strmid(str_ravedatafile,0,strpos(str_ravedatafile,'.',/REVERSE_SEARCH))+'_temp.txt',$
                           RAVEDATAFILE=ravedatafile,$
                           DATAARR=strarr_rave_data,$
                           MOMENTX=momentx,$
                           MOMENTY=momenty,$
                           REJECTVALUEX=rejectvaluex,$
                           REJECTVALUEY=rejectvaluey,$
                           NREJECTEDX=nrejectedx,$
                           NREJECTEDY=nrejectedy,$
                           XCOL=xcolrave,$
                           XRANGESET=xrangeset,$
                           XTITLE=xtitle,$
                           YCOL=ycolrave,$
                           YRANGESET=yrangeset,$
                           YTITLE=ytitle,$
                           XLOG=xlograve,$
                           YLOG=ylograve,$
                           TITLE=str_title_rave,$
                           ICOL=icolrave,$
                           IRANGE=irange,$
                           FORCEXRANGE=forcexrange,$
                           FORCEYRANGE=forceyrange,$
                           SUBPATH=subpath,$
                           I_NSTARS=i_nstars,$
                           PROBLEM=problem_rave,$
                           INDARR_OUT=indarr_out,$
                           ;I_COL_LOGG = i_col_logg_rave,$
                           IO_PLOT_GIANT_TO_DWARF_RATIO = plot_giant_to_dwarf_ratio; --- 0: don't, 1: x=logg, 2: y=logg
    intarr_nstars(i,0) = i_nstars
    i_fieldnr = i_fieldnr + 1
    i_nplots = i_nplots + 1
;    print,'besancon_rave_plot_two_cols: io_plot_giant_to_dwarf_ratio = ',plot_giant_to_dwarf_ratio

;    print,'n_elements(indarr_out) = ',n_elements(indarr_out)
;    print,'momentx = ',momentx
;    print,'momenty = ',momenty
;    print,'i_nstars = ',i_nstars
    print,'problem_rave = ',problem_rave
;      stop
    if problem_rave eq 1 then begin
      momentx(0)=0.
      momenty(0)=0.
      momentx(1)=0.
      momenty(1)=0.
;      meanx = 0.
;      sigmax = 0.
;      meany = 0.
;      sigmay = 0.

      dblarr_dd_x(i) = -1.
      dblarr_prob_x(i) = -1.
      dblarr_dd_y(i) = -1.
      dblarr_prob_y(i) = -1.
      free_lun,luna

      lonarr_nrejectedx(i) = 0
      lonarr_nrejectedy(i) = 0

      if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
        dblarr_giant_to_dwarf_ratio(i,0) = 0.
        dblarr_giant_to_dwarf(i,0) = 0.
      end

    end else begin

; --- write means and sigmas to array meansigrave
      meansigrave(i_fieldnr*2,0)=momentx(0)
      meansigrave(i_fieldnr*2,1)=sqrt(momentx(1))
      meansigrave(i_fieldnr*2,2)=momentx(2)
      meansigrave(i_fieldnr*2,3)=momentx(3)
      meansigrave(i_fieldnr*2+1,0)=momenty(0)
      meansigrave(i_fieldnr*2+1,1)=sqrt(momenty(1))
      meansigrave(i_fieldnr*2+1,2)=momenty(2)
      meansigrave(i_fieldnr*2+1,3)=momenty(3)

      lonarr_nrejectedx(i) = nrejectedx
      lonarr_nrejectedy(i) = nrejectedy

      dblarr_ra_dec(i_fieldnr,*) = dblarr_fields(i,*)

      if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
        dblarr_giant_to_dwarf_ratio(i,0) = plot_giant_to_dwarf_ratio(0)
        dblarr_giant_to_dwarf(i,0) = plot_giant_to_dwarf_ratio(0)
        printf,lun_giants_to_dwarf,'RAVE: '+strtrim(string(dblarr_giant_to_dwarf_ratio(i,0)),2)
;        print,'dblarr_giant_to_dwarf_ratio(i=',i,',0) = ',dblarr_giant_to_dwarf_ratio(i,0)
;        print,'dblarr_giant_to_dwarf(i=',i,',0) = ',dblarr_giant_to_dwarf(i,0)
;        print,'plot_giant_to_dwarf_ratio(0) = ',plot_giant_to_dwarf_ratio(0)
;        stop
      end
      if keyword_set(B_HIST) then begin
        xarrout_rave = double(strarr_rave_data(indarr_out,xcolrave))
        yarrout_rave = double(strarr_rave_data(indarr_out,ycolrave))
        dblarr_ravedata = double(strarr_rave_data(indarr_out,*))
        ;indarr_out_rave = indarr_out
        ;xarrout = 1
        ;yarrout = 1
        indarr_out = 1
      endif

    endelse
    oldymin = yminbak
    oldymax = ymaxbak
    if not keyword_set(STRARR_BESANCON_DATA) then begin
      datafile = datafiles(i)
    end

; --- plot besancon data
    if keyword_set(STRARR_BESANCON_DATA) then begin
      if keyword_set(I_COL_LON_BESANCON) then begin
        colra = i_col_lon_besancon
      end else begin
        colra = 0
      end
      if keyword_set(I_COL_LAT_BESANCON) then begin
        coldec = i_col_lat_besancon
      end else begin
        coldec = 1
      end
      print,'besancon_rave_plot_two_cols: i_col_lon_besancon = ',i_col_lon_besancon
      print,'besancon_rave_plot_two_cols: i_col_lat_besancon = ',i_col_lat_besancon
      print,'besancon_rave_plot_two_cols: colra = ',colra,', coldec = ',coldec
;      stop
      minra = dblarr_fields(i,0)
      if minra eq 0. then minra = 0.0000001
      mindec = dblarr_fields(i,2)
      if mindec eq 0. then mindec = 0.0000001
      maxra = dblarr_fields(i,1)
      if maxra eq 0. then maxra = 0.0000001
      maxdec = dblarr_fields(i,3)
      if maxdec eq 0. then maxdec = 0.0000001
    end else begin
      mindec = 0
      maxdec = 0
      coldec = 0
      minra = 0
      maxra = 0
      colra = 0
    end

    str_plot_out = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_'+subpath+'.ps'
    str_title_bes = 'Besancon'; l='+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', b='+strarr_fields(i,2)+' - '+strarr_fields(i,3)
    str_title_hist = '';l='+strarr_fields(i,0)+'-'+strarr_fields(i,1)+', b='+strarr_fields(i,2)+'-'+strarr_fields(i,3)
    print,'besancon_rave_plot_two_cols: i_xcol_besancon1 = ',i_xcol_besancon
    if keyword_set(STAR_TYPES_COL) then b_colour = 1 else b_colour = 0
    if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
      plot_giant_to_dwarf_ratio = i_plot_giant_to_dwarf_ratio
    end else begin
      plot_giant_to_dwarf_ratio = 0
    end
    rave_plot_two_cols,datafile,$
                       i_xcol_besancon,$
                       ycolbesancon,$
                       xtitle,$
                       ytitle,$
                       str_plot_out,$
                       TITLE              = str_title_bes,$
                       DATAARR            = strarr_besancon_data,$
                       XLOG               = XLOGBES, $
                       YLOG               = YLOGBES, $
                       XRANGESET          = xrangeset,$
                       YRANGESET          = yrangeset,$
                       IRANGE             = irange,$
                       ICOL               = icolbesancon,$
                       MINDEC             = mindec,$
                       MAXDEC             = maxdec,$
                       COLDEC             = coldec,$
                       MINRA              = minra,$
                       MAXRA              = maxra,$
                       COLRA              = colra,$
                       FORCEXRANGE        = forcexrange,$
                       FORCEYRANGE        = forceyrange,$
                       MOMENTX              = momentx,$
                       MOMENTY              = momenty,$
                       MEANSIGMASAMPLES   = meansigmasamples,$
                       I_NSTARS           = i_nstars,$
                       CALCSAMPLES        = calcsamples,$
                       I_NSAMPLES         = i_nsamples,$
                       B_ONE_BESANCONFILE = b_one_besanconfile,$
                       PROBLEM            = problem_bes,$
                       INDARR_OUT         = indarr_out,$
                       INDARRS_OUT        = indarrs_out,$;lonarr(i_nsamples+1, n_elements(dblarr_ravedata))
                       B_HIST             = b_hist,$
                       B_POP_ID           = b_pop_id,$
                       STAR_TYPES_COL     = star_types_col,$
                       BINWIDTH_I         = dbl_bin_width_i,$
                       NBINS_I            = nbins_i,$
                       B_I_SEARCH         = b_i_search,$
                       B_SAMPLES_COLOUR   = b_colour,$
                       I_COL_LOGG_BESANCON= i_col_logg_besancon,$
                       IO_PLOT_GIANT_TO_DWARF_RATIO = plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                       B_SELECT_FROM_IMAG_AND_LOGG = b_select_from_imag_and_logg,$
                       DBLARR_RAVEDATA     = dblarr_ravedata,$
;                       INDARR_RAVE         = indarr_out_rave,$
                       I_COL_I_RAVE        = icolrave,$
                       I_COL_LOGG_RAVE     = i_col_logg_rave,$
                       DBL_SEED            = dbl_seed

    print,'besancon_rave_plot_two_cols: io_plot_giant_to_dwarf_ratio_bes = ',plot_giant_to_dwarf_ratio


;    print,'n_elements(indarrs_out) = ',n_elements(indarrs_out)
;    print,'indarrs_out = ',indarrs_out
;    print,'momentx = ',momentx
;    print,'momenty = ',momenty
;    print,'meansigmasamples = ',meansigmasamples
;    print,'i_nstars = ',i_nstars
;    print,'plot_giant_to_dwarf_ratio = ',plot_giant_to_dwarf_ratio
;    print,'problem_rave = ',problem_bes
;      stop

    intarr_nstars(i,1) = i_nstars
    print,'intarr_nstars(i,*) = ',intarr_nstars(i,*)
;    stop
    if problem_bes eq 1 then begin
      print,'besancon_rave_plot_two_cols: i=',i,': PROBLEM_BES == 1'
      stop
      momentx(0) = meansigrave(i_fieldnr*2,0)
      momentx(1) = 0.
      momentx(2) = 0.
      momentx(3) = 0.
      momenty(0) = meansigrave(i_fieldnr*2+1,0)
      momenty(1) = 0.
      momenty(2) = 0.
      momenty(3) = 0.
      if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
        dblarr_giant_to_dwarf_ratio(i,1:i_nsamples) = 0.
        dblarr_giant_to_dwarf(i,1) = 0.
        dblarr_giant_to_dwarf(i,2) = 0.
      end
    end else begin
      if problem_rave eq 1 then begin
        meansigrave(i_fieldnr*2,0)=momentx(0)
        meansigrave(i_fieldnr*2+1,0)=momenty(0)
      end
      if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
        dblarr_giant_to_dwarf_ratio(i,1:i_nsamples) = plot_giant_to_dwarf_ratio

;        print,'besancon_rave_plot_two_cols: plot_giant_to_dwarf_ratio = ',plot_giant_to_dwarf_ratio
;        print,'besancon_rave_plot_two_cols: dblarr_giant_to_dwarf_ratio(i,*) = ',dblarr_giant_to_dwarf_ratio(i,*)
;        stop

        printf,lun_giants_to_dwarf,'Besancon: '+strtrim(string(plot_giant_to_dwarf_ratio(0)),2)
        for ikl = 0, i_nsamples-1 do begin
          printf,lun_giants_to_dwarf,strtrim(string(plot_giant_to_dwarf_ratio(ikl)),2)
        endfor
        dblarr_moment = moment(plot_giant_to_dwarf_ratio)
        dblarr_giant_to_dwarf(i,1) = dblarr_moment(0)
        dblarr_giant_to_dwarf(i,2) = sqrt(dblarr_moment(1))
        print,'dblarr_giant_to_dwarf_ratio(i=',i,',0:i_nsamples=',i_nsamples,') = ',dblarr_giant_to_dwarf_ratio(i,*)
        print,'dblarr_giant_to_dwarf(i=',i,',1) = ',dblarr_giant_to_dwarf(i,1)
        print,'dblarr_giant_to_dwarf(i=',i,',2) = ',dblarr_giant_to_dwarf(i,2)
        print,'plot_giant_to_dwarf_ratio = ',plot_giant_to_dwarf_ratio
;        stop
      end
    end
    if keyword_set(B_HIST) then begin
      if problem_bes ne 1 then begin
;        print,'besancon_rave_plot_two_cols: indarrs_out = ',indarrs_out
        print,'besancon_rave_plot_two_cols: meansigmasamples = ',meansigmasamples
;        stop
        xarrout_bes = double(strarr_besancon_data(*,i_xcol_besancon))
        xarrout_bes = xarrout_bes(indarrs_out)
        yarrout_bes = double(strarr_besancon_data(*,ycolbesancon))
        yarrout_bes = yarrout_bes(indarrs_out)
        if keyword_set(STAR_TYPES_COL) then begin
          typesarrout = double(strarr_besancon_data(*,star_types_col))
          typesarrout = typesarrout(indarrs_out)
        endif
        indarr_zero = where(indarrs_out(1,*) eq 0)
        if indarr_zero(0) eq 0 then $
          remove_ith_element_from_array, indarr_zero, 0
        xarrout_bes(1:n_elements(indarrs_out(*,0))-1,indarr_zero) = 0
        yarrout_bes(1:n_elements(indarrs_out(*,0))-1,indarr_zero) = 0
        if keyword_set(STAR_TYPES_COL) then begin
          typesarrout(1:n_elements(indarrs_out(*,0))-1,indarr_zero) = -1
;          print,'typesarrout = ',typesarrout
;          stop
        endif
;        print,'xarrout_bes = ',xarrout_bes
;        stop
;        xarrout = 1
;        yarrout = 1
      end else begin
        print,'besancon_rave_plot_two_cols: PROBLEM: problem_bes eq 1'
        print,'besancon_rave_plot_two_cols: meansigmasamples = ',meansigmasamples
;        stop
      end
    end

; --- write means and sigmas to dblarr meansigbes
    meansigbes(i_fieldnr*2,0)=momentx(0)
    meansigbes(i_fieldnr*2,1)=sqrt(momentx(1))
    meansigbes(i_fieldnr*2,2)=momentx(2)
    meansigbes(i_fieldnr*2,3)=momentx(3)
    meansigbes(i_fieldnr*2+1,0)=momenty(0)
    meansigbes(i_fieldnr*2+1,1)=sqrt(momenty(1))
    meansigbes(i_fieldnr*2+1,2)=momenty(2)
    meansigbes(i_fieldnr*2+1,3)=momenty(3)

; --- write means and sigmas to dblarr meansigbes_samples
;    print,'besancon_rave_plot_two_cols: n_elements(meansigmasamples) = ',n_elements(meansigmasamples)
    if n_elements(meansigmasamples) eq 1 then begin
;          for ll=0,7 do begin
      meansigbes_samples(i_fieldnr,0:15) = 0.
;          endfor
    end else begin
      if problem_bes eq 0 then begin
      ;  meansigmasamples(i,0) = momentx_plot(0)
      ;  meansigmasamples(i,1) = momenty_plot(0)
      ;  meansigmasamples(i,2) = sqrt(momentx_plot(1))
      ;  meansigmasamples(i,3) = sqrt(momenty_plot(1))
      ;  meansigmasamples(i,4) = momentx_plot(2)
      ;  meansigmasamples(i,5) = momenty_plot(2)
      ;  meansigmasamples(i,6) = momentx_plot(3)
      ;  meansigmasamples(i,7) = momenty_plot(3)

        moment_samples = moment(meansigmasamples(*,0))
        meansigbes_samples(i_fieldnr,0)=moment_samples(0);mean(meansigmasamples(*,0))      ; -- mean(mean(x))
        meansigbes_samples(i_fieldnr,1)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,0)); -- sigma(mean(x))

        moment_samples = moment(meansigmasamples(*,1))
        meansigbes_samples(i_fieldnr,2)=moment_samples(0);mean(meansigmasamples(*,1))      ; -- mean(mean(y))
        meansigbes_samples(i_fieldnr,3)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,1)); -- sigma(mean(y))

        moment_samples = moment(meansigmasamples(*,2))
        meansigbes_samples(i_fieldnr,4)=moment_samples(0);mean(meansigmasamples(*,2))      ; -- mean(sigma(x))
        meansigbes_samples(i_fieldnr,5)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,2)); -- sigma(sigma(x))

        moment_samples = moment(meansigmasamples(*,3))
        meansigbes_samples(i_fieldnr,6)=moment_samples(0);mean(meansigmasamples(*,3))      ; -- mean(sigma(y))
        meansigbes_samples(i_fieldnr,7)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,3)); -- sigma(sigma(y))

        moment_samples = moment(meansigmasamples(*,4))
        meansigbes_samples(i_fieldnr,8)=moment_samples(0);mean(meansigmasamples(*,0))      ; -- mean(skewness(x))
        meansigbes_samples(i_fieldnr,9)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,0)); -- sigma(skewness(x))

        moment_samples = moment(meansigmasamples(*,5))
        meansigbes_samples(i_fieldnr,10)=moment_samples(0);mean(meansigmasamples(*,1))      ; -- mean(skewness(y))
        meansigbes_samples(i_fieldnr,11)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,1)); -- sigma(skewness(y))

        moment_samples = moment(meansigmasamples(*,6))
        meansigbes_samples(i_fieldnr,12)=moment_samples(0);mean(meansigmasamples(*,2))      ; -- mean(kurtosis(x))
        meansigbes_samples(i_fieldnr,13)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,2)); -- sigma(kurtosis(x))

        moment_samples = moment(meansigmasamples(*,7))
        meansigbes_samples(i_fieldnr,14)=moment_samples(0);mean(meansigmasamples(*,3))      ; -- mean(kurtosis(y))
        meansigbes_samples(i_fieldnr,15)=sqrt(moment_samples(1));meanabsdev(meansigmasamples(*,3)); -- sigma(kurtosis(y))
      end else begin
        meansigbes_samples(i_fieldnr,*)=0.
;        stop
      end
    end

    if problem_rave ne 1 then begin

; --- check x and y ranges
      if (abs(yminbak-oldymin) gt 0.0001) or (abs(ymaxbak-oldymax) gt 0.0001) then   begin
        if abs(yminbak-oldymin) gt 0.0001 then begin
          print,'besancon_rave_plot_two_cols: WWWAAARRRNNNIIINNNGGG: yminbak(=',yminbak,') != oldymin(=',oldymin,')'
        end
        if abs(ymaxbak-oldymax) gt 0.0001 then begin
          print,'besancon_rave_plot_two_cols: WWWAAARRRNNNIIINNNGGG: ymaxbak(=',ymaxbak,') != oldymax(=',oldymax,')'
        end
        if (not keyword_set(FORCEYRANGE)) then begin
; --- plot RAVE data again mit new x and y ranges
stop
          if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
            plot_giant_to_dwarf_ratio = i_plot_giant_to_dwarf_ratio
          end else begin
            plot_giant_to_dwarf_ratio = 0
          end
          str_ravedatafile = strmid(ravedatafile,strpos(ravedatafile,'/',/REVERSE_SEARCH)+1)
          rave_plot_two_cols_all,FIELDSFILE=path+subpath+strmid(str_ravedatafile,0,strpos(str_ravedatafile,'.',/REVERSE_SEARCH))+'_temp.txt',$
                                 MOMENTX=momentx,$
                                 MOMENTY=momenty,$
                                 REJECTVALUEX=rejectvaluex,$
                                 REJECTVALUEY=rejectvaluey,$
                                 NREJECTEDX=nrejectedx,$
                                 NREJECTEDY=nrejectedy,$
                                 XCOL=xcolrave,$
                                 XRANGESET=xrangeset,$
                                 XTITLE=xtitle,$
                                 YCOL=ycolrave,$
                                 YRANGESET=yrangeset,$
                                 YTITLE=ytitle,$
                                 TITLE=str_title_rave,$
                                 ICOL=icolrave,$
                                 IRANGE=irange,$
                                 FORCEXRANGE=forcexrange,$
                                 FORCEYRANGE=forceyrange,$
                                 SUBPATH=subpath,$
                                 I_NSTARS = i_nstars,$
                                 PROBLEM=problem_rave,$
                                 ;I_COL_LOGG  = i_col_logg_rave,$
                                 IO_PLOT_GIANT_TO_DWARF_RATIO = plot_giant_to_dwarf_ratio,$; --- 0: don't, 1: x=logg, 2: y=logg
                           RAVEDATAFILE=ravedatafile,$
                           DATAARR=strarr_rave_data,$
                           XLOG=xlograve,$
                           YLOG=ylograve,$
                           INDARR_OUT=indarr_out



          intarr_nstars(i,0) = i_nstars
          if problem_rave eq 1 then begin
            if problem_bes eq 0 then begin
              momentx(0) = meansigbes(2*i_fieldnr,0)
              momentx(1) = 0.
              momenty(0) = meansigbes(2*i_fieldnr+1,0)
              momenty(1) = 0.
            end else begin
              momentx(0) = 0.
              momentx(1) = 0.
              momenty(0) = 0.
              momenty(1) = 0.
            end
            lonarr_nrejectedx(i) = 0
            lonarr_nrejectedy(i) = 0
            if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
              dblarr_giant_to_dwarf_ratio(i,0) = 0.
              dblarr_giant_to_dwarf(i,0) = 0.
            end
          end else begin
            if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
              dblarr_giant_to_dwarf_ratio(i,0) = plot_giant_to_dwarf_ratio(0)
              dblarr_giant_to_dwarf(i,0) = plot_giant_to_dwarf_ratio(0)
            end
          end
          if keyword_set(B_HIST) then begin
            if problem_rave ne 1 then begin
              xarrout_rave = xarrout
              yarrout_rave = yarrout
              xarrout = 0
              yarrout = 0
            end; else begin

          end

; --- write means and sigmas to meansigrave
          meansigrave(i_fieldnr*2+0,0)=momentx(0)
          meansigrave(i_fieldnr*2+0,1)=sqrt(momentx(1))
          meansigrave(i_fieldnr*2+0,2)=momentx(2)
          meansigrave(i_fieldnr*2+0,3)=momentx(3)
          meansigrave(i_fieldnr*2+1,0)=momenty(0)
          meansigrave(i_fieldnr*2+1,1)=sqrt(momenty(1))
          meansigrave(i_fieldnr*2+1,2)=momenty(2)
          meansigrave(i_fieldnr*2+1,3)=momenty(3)

          lonarr_nrejectedx(i) = nrejectedx
          lonarr_nrejectedy(i) = nrejectedy

        end
      end

; --- create histograms
      if keyword_set(B_HIST) then begin
        if problem_bes ne 1 then begin
          xarrout_bes_size = size(xarrout_bes)
;          print,'besancon_rave_plot_two_cols: xarrout_bes_size = ',xarrout_bes_size
;          stop
          if (not keyword_set(I_NSAMPLES)) or (not keyword_set(CALCSAMPLES)) or problem_rave ne 0 or (n_elements(xarrout_rave) ge n_elements(xarrout_bes)) or xarrout_bes_size(0) eq 1 then begin
;            print,'besancon_rave_plot_two_cols: Variante 1'
          end else begin
;            print,'besancon_rave_plot_two_cols: Variante 2'
            if problem_rave eq 0 then begin
              if xtitle ne 'Effective Temperature [K]' and not keyword_set(XRANGESET) then begin
                xrange=[min([min(xarrout_rave),min(xarrout_bes(0,*))]),max([max(xarrout_rave),max(xarrout_bes(0,*))])]
              end
              if ytitle ne 'Effective Temperature [K]' then begin
                yrange=[min([min(yarrout_rave),min(yarrout_bes(0,*))]),max([max(yarrout_rave),max(yarrout_bes(0,*))])]
              end
            end; else begin
          end

          str_plotname_hist = strmid(ravedatafile,0,strpos(ravedatafile,'.',/REVERSE_SEARCH))+'_'+subpath+'_I' + strmid(strtrim(string(irange(0)),2),0,4) + '-' + strmid(strtrim(string(irange(1)),2),0,4)+'_'+html_path+'_'+xytitle(0)
          if problem_rave eq 0 and problem_bes eq 0 then begin

;            if keyword_set(STAR_TYPES_COL) then begin
;              dblarr_star_types = typesarrout;double(strarr_besancon_data(*,star_types_col))
;            end else begin
;              dblarr_star_types = 0
;            end

            if xarrout_bes_size(0) eq 1 then begin
              if xarrout_bes ne 0 then begin
                strarr_giffilenames = strarr(1,2)
                str_plotname_hist = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+xytitle(0)
                plot_two_histograms,xarrout_rave,$
                                    xarrout_bes,$
                                    STR_PLOTNAME_ROOT=str_plotname_hist,$
                                    XTITLE=xtitle,$
                                    YTITLE='Percentage of Stars',$
                                    TITLE=str_title_rave,$
                                    I_NBINS=i_nbins,$
                                    NBINSMIN=nbinsmin,$
                                    NBINSMAX=nbinsmax,$
                                    XRANGE=xrange,$
                                    PERCENTAGE=1,$
                                    B_POP_ID = b_pop_id,$
                                    DBLARR_STAR_TYPES=typesarrout,$
                                    COLOUR=1,$
                                    I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                    I_DBL_THICK = 3.,$;
                                    I_INT_XTICKS = int_xticks,$
                                    I_STR_XTICKFORMAT = str_xtickformat,$
                                    I_DBL_CHARSIZE = 1.8,$
                                    I_DBL_CHARTHICK = 3.
                strarr_giffilenames(0,0) = str_plotname_hist

                str_plotname_hist = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+strmid(ytitle,0,strpos(ytitle,' '))
                plot_two_histograms,yarrout_rave,$
                                    yarrout_bes,$
                                    STR_PLOTNAME_ROOT=str_plotname_hist,$
                                    XTITLE=ytitle,$
                                    YTITLE='Percentage of Stars',$
                                    TITLE=str_title_hist,$
                                    I_NBINS=i_nbins,$
                                    NBINSMIN=nbinsmin,$
                                    NBINSMAX=nbinsmax,$
                                    XRANGE=yrange,$
                                    PERCENTAGE=1,$
                                    B_POP_ID = b_pop_id,$
                                    DBLARR_STAR_TYPES=typesarrout,$
                                    COLOUR=1,$
                                    I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                    I_DBL_THICK = 3.,$;
                                    I_INT_XTICKS = int_yticks,$
                                    I_STR_XTICKFORMAT = str_ytickformat,$
                                    I_DBL_CHARSIZE = 1.8,$
                                    I_DBL_CHARTHICK = 3.
                strarr_giffilenames(0,1) = str_plotname_hist
              end
            end else begin
              strarr_giffilenames = strarr(xarrout_bes_size(1),2)
;              print,'xarrout_bes(0,*) = ',xarrout_bes(0,*)
;              stop
              for kk=0UL,xarrout_bes_size(1)-1 do begin
                if kk eq 0 then begin
                  str_plotname_hist_x = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+xytitle(0)
                  str_plotname_hist_y = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+xytitle(1)
                  plot_two_histograms,xarrout_rave,$
                                      xarrout_bes(kk,*),$
                                      STR_PLOTNAME_ROOT=str_plotname_hist_x,$
                                      XTITLE=xtitle,$
                                      YTITLE='Percentage of Stars',$
                                      TITLE=str_title_hist,$
                                      I_NBINS=i_nbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      XRANGE=xrange,$
                                      PERCENTAGE=1,$
                                      B_POP_ID = b_pop_id,$
                                      DBLARR_STAR_TYPES=typesarrout(kk,*),$
                                      COLOUR=1,$
                                      I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                      I_DBL_THICK = 3.,$;
                                      I_INT_XTICKS = int_xticks,$
                                      I_STR_XTICKFORMAT = str_xtickformat,$
                                      I_DBL_CHARSIZE = 1.8,$
                                      I_DBL_CHARTHICK = 3.
                  strarr_giffilenames(kk,0) = str_plotname_hist_x
                  plot_two_histograms,yarrout_rave,$
                                      yarrout_bes(kk,*),$
                                      STR_PLOTNAME_ROOT=str_plotname_hist_y,$
                                      XTITLE=ytitle,$
                                      YTITLE='Percentage of Stars',$
                                      TITLE=str_title_hist,$
                                      I_NBINS=i_nbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      XRANGE=yrange,$
                                      PERCENTAGE=1,$
                                      B_POP_ID = b_pop_id,$
                                      DBLARR_STAR_TYPES=typesarrout(kk,*),$
                                      COLOUR=1,$
                                      I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                      I_DBL_THICK = 3.,$;
                                      I_INT_XTICKS = int_yticks,$
                                      I_STR_XTICKFORMAT = str_ytickformat,$
                                      I_DBL_CHARSIZE = 1.8,$
                                      I_DBL_CHARTHICK = 3.
                  strarr_giffilenames(kk,1) = str_plotname_hist_y
                  printf,luna,'d_'+xytitle(0)+' P_'+xytitle(0)+' d_'+xytitle(1)+' P_'+xytitle(1)
                end else begin
;                  print,'besancon_rave_plot_two_cols: xarrout_rave = ',xarrout_rave
;                  print,'besancon_rave_plot_two_cols: xarrout_bes(kk=',kk,',0:n_elements(xarrout_rave)-1) = ',xarrout_bes(kk,0:n_elements(xarrout_rave)-1)
                  str_plotname_hist_x = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+xytitle(0)+'_'+strtrim(string(kk-1),2)
                  str_plotname_hist_y = strmid(str_plot_out,0,strpos(str_plot_out,'.',/REVERSE_SEARCH))+'_'+xytitle(1)+'_'+strtrim(string(kk-1),2)
;                  print,'typesarrout(kk,0:n_elements(xarrout_rave)-1) = ',typesarrout(kk,0:n_elements(xarrout_rave)-1)
;                  stop
                  plot_two_histograms,xarrout_rave,$
                                      xarrout_bes(kk,0:n_elements(xarrout_rave)-1),$
                                      STR_PLOTNAME_ROOT=str_plotname_hist_x,$
                                      XTITLE=xtitle,$
                                      YTITLE='Percentage of Stars',$
                                      TITLE=str_title_hist,$
                                      I_NBINS=i_nbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      XRANGE=xrange,$
                                      PERCENTAGE=1,$
                                      B_POP_ID = b_pop_id,$
                                      DBLARR_STAR_TYPES=typesarrout(kk,0:n_elements(xarrout_rave)-1),$
                                      COLOUR=1,$
                                      I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                      I_DBL_THICK = 3.,$;
                                      I_INT_XTICKS = int_xticks,$
                                      I_STR_XTICKFORMAT = str_xtickformat,$
                                      I_DBL_CHARSIZE = 1.8,$
                                      I_DBL_CHARTHICK = 3.
                  strarr_giffilenames(kk,0) = str_plotname_hist_x
                  plot_two_histograms,yarrout_rave,$
                                      yarrout_bes(kk,0:n_elements(xarrout_rave)-1),$
                                      STR_PLOTNAME_ROOT=str_plotname_hist_y,$
                                      XTITLE=ytitle,$
                                      YTITLE='Percentage of Stars',$
                                      TITLE=str_title_hist,$
                                      I_NBINS=i_nbins,$
                                      NBINSMIN=nbinsmin,$
                                      NBINSMAX=nbinsmax,$
                                      XRANGE=yrange,$
                                      B_POP_ID = b_pop_id,$
                                      DBLARR_STAR_TYPES=typesarrout(kk,0:n_elements(xarrout_rave)-1),$
                                      PERCENTAGE=1,$
                                      COLOUR=1,$
                                      I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                      I_DBL_THICK = 3.,$;
                                      I_INT_XTICKS = int_yticks,$
                                      I_STR_XTICKFORMAT = str_ytickformat,$
                                      I_DBL_CHARSIZE = 1.8,$
                                      I_DBL_CHARTHICK = 3.
                  strarr_giffilenames(kk,1) = str_plotname_hist_y
                  kstwo,DBLARR_DATA_A=xarrout_rave,$
                        DBLARR_DATA_B=xarrout_bes(kk,0:n_elements(xarrout_rave)-1),$
                        PROB=prob,$
                        DD=dd
;                    kstwo,DBLARR_DATA_A=xarrout_bes(0,*),$
;                          DBLARR_DATA_B=xarrout_bes(kk,0:n_elements(xarrout_rave)-1),$
;                          PROB=prob,$
;                          DD=dd
                  dbl_prob_x = prob
                  dbl_dd_x = dd
                  dblarr_kst(i,kk-1,0) = dbl_dd_x
                  dblarr_kst(i,kk-1,1) = dbl_prob_x

                  kstwo,DBLARR_DATA_A=yarrout_rave,$
                        DBLARR_DATA_B=yarrout_bes(kk,0:n_elements(yarrout_rave)-1),$
                        PROB=prob,$
                        DD=dd
;                    kstwo,DBLARR_DATA_A=yarrout_bes(0,*),$
;                          DBLARR_DATA_B=yarrout_bes(kk,0:n_elements(yarrout_rave)-1),$
;                          PROB=prob,$
;                          DD=dd
                  dbl_prob_y = prob
                  dbl_dd_y = dd
                  dblarr_kst(i,kk-1,2) = dbl_dd_y
                  dblarr_kst(i,kk-1,3) = dbl_prob_y
                  printf,luna,strtrim(string(dbl_dd_x),2)+' '+strtrim(string(dbl_prob_x),2)+' '+strtrim(string(dbl_dd_y),2)+' '+strtrim(string(dbl_prob_y),2)
                  if kk eq (xarrout_bes_size(1)-1) then begin
                    printf,luna,'Mean: '+strtrim(string(mean(dblarr_kst(i,*,0))),2)+' '+strtrim(string(mean(dblarr_kst(i,*,1))),2)+' '+strtrim(string(mean(dblarr_kst(i,*,2))),2)+' '+strtrim(string(mean(dblarr_kst(i,*,3))),2)
                  endif
;                  print,'besancon_rave_plot_two_cols: xarrout_rave = ',xarrout_rave
;                  print,'besancon_rave_plot_two_cols: xarrout_bes(kk=',kk,',*) = ',xarrout_bes(kk,*)
                end
              endfor
;              free_lun,lund
            end
          end
        end
      end; if keyword_set(B_HIST)

; --- write meansigfiles
      meansigfiles(i_fieldnr) = str_path + html_path + "/mean_sigma_x_y.dat"

      openw,lunm,meansigfiles(i_fieldnr),/GET_LUN
        printf,lunm,'#data mean_x sigma_x skewness_x kurtosis_x mean_y sigma_y skewness_y kurtosis_y'
        printf,lunm,'RAVE '+$
                     strtrim(string(meansigrave(i_fieldnr*2,0)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2,1)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2,2)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2,3)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2+1,0)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2+1,1)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2+1,2)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_fieldnr*2+1,3)),2)

        printf,lunm,'BESANCON '+$
                    strtrim(string(meansigbes(i_fieldnr*2,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2,1)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2,2)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2,3)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2+1,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2+1,1)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2+1,2)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_fieldnr*2+1,3)),2)
        if n_elements(meansigmasamples) gt 1 then begin
          for i_samplenr=0,i_nsamples-1 do begin
            printf,lunm,strtrim(string(meansigmasamples(i_samplenr,0)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,2)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,4)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,6)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,1)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,3)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,5)),2)+' '+strtrim(string(meansigmasamples(i_samplenr,7)),2)
          endfor
        endif
      free_lun,lunm
;      print,'meansigfile meansigfiles(i_fieldnr)='+meansigfiles(i_fieldnr)+' written'
;      print,'meansigmasamples = ',meansigmasamples
 ;     stop

; --- plot mean_sigma_x_y
      str_plotname = str_path + html_path + "/mean_sigma_x_y.ps"
      str_gifplotname = str_path + html_path + "/mean_sigma_x_y.gif"
      set_plot,'ps'
      device,filename=str_plotname,/color
        red = intarr(256)
        green = intarr(256)
        blue = intarr(256)
        for l=0ul, 255 do begin
          if l le 127 then begin
            red(l) = 60 - (2*l)
            green(l) = 2 * l
            blue(l) = 255 - (2 * l)
          end else begin
            blue(l) = 0
            green(l) = 255 - (2 * (l-127))
            red(l) = 2 * (l-127)
          end
          if red(l) lt 0 then red(l) = 0
          if red(l) gt 255 then red(l) = 255
          if green(l) lt 0 then green(l) = 0
          if green(l) gt 255 then green(l) = 255
          if blue(l) lt 0 then blue(l) = 0
          if blue(l) gt 255 then blue(l) = 255
        endfor
        ltab = 0
        modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'
        plot,[meansigrave(i_fieldnr*2,0)-meansigrave(i_fieldnr*2,1),meansigrave(i_fieldnr*2,0)+meansigrave(i_fieldnr*2,1)],$
             [meansigrave(i_fieldnr*2+1,0),meansigrave(i_fieldnr*2+1,0)],$
             xtitle=xtitle,$
             ytitle=ytitle,$
             xrange=[min([meansigrave(i_fieldnr*2,0)-meansigrave(i_fieldnr*2,1),meansigbes(i_fieldnr*2+0,0)-meansigbes(i_fieldnr*2+0,1)])-meansigbes(i_fieldnr*2+0,1),max([meansigrave(i_fieldnr*2,0)+meansigrave(i_fieldnr*2,1),meansigbes(i_fieldnr*2,0)+meansigbes(i_fieldnr*2,1)])+meansigbes(i_fieldnr*2+0,1)],$
             yrange=[min([meansigrave(i_fieldnr*2+1,0)-meansigrave(i_fieldnr*2+1,1),meansigbes(i_fieldnr*2+1,0)-meansigbes(i_fieldnr*2+1,1)])-meansigbes(i_fieldnr*2+1,1),max([meansigrave(i_fieldnr*2+1,0)+meansigrave(i_fieldnr*2+1,1),meansigbes(i_fieldnr*2+1,0)+meansigbes(i_fieldnr*2+1,1)])+meansigbes(i_fieldnr*2+1,1)],$
             linestyle=0,$
             thick=3.,$
             charsize=1.8,$
             charthick=3.,$
             xtickformat=str_xtickformat,$
             ytickformat=str_ytickformat,$
             position=[0.17,0.16,0.97,0.99]
        loadct,ltab,FILE='colors1.tbl'
        if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) and n_elements(MEANSIGMASAMPLES) gt 1 then begin
          for m=0,i_nsamples-1 do begin
            oplot,[meansigmasamples(m,0)-meansigmasamples(m,2),meansigmasamples(m,0)+meansigmasamples(m,2)],[meansigmasamples(m,1),meansigmasamples(m,1)],linestyle=0,thick=3,color=254
            oplot,[meansigmasamples(m,0),meansigmasamples(m,0)],[meansigmasamples(m,1)-meansigmasamples(m,3),meansigmasamples(m,1)+meansigmasamples(m,3)],linestyle=0,thick=3,color=254
          endfor
        endif
        oplot,[meansigrave(i_fieldnr*2,0)-meansigrave(i_fieldnr*2,1),meansigrave(i_fieldnr*2,0)+meansigrave(i_fieldnr*2,1)],[meansigrave(i_fieldnr*2+1,0),meansigrave(i_fieldnr*2+1,0)],linestyle=0,thick=6,color=1
        oplot,[meansigrave(i_fieldnr*2,0),meansigrave(i_fieldnr*2,0)],[meansigrave(i_fieldnr*2+1,0)-meansigrave(i_fieldnr*2+1,1),meansigrave(i_fieldnr*2+1,0)+meansigrave(i_fieldnr*2+1,1)],linestyle=0,thick=6,color=1
        oplot,[meansigbes(i_fieldnr*2,0)-meansigbes(i_fieldnr*2,1),meansigbes(i_fieldnr*2,0)+meansigbes(i_fieldnr*2,1)],[meansigbes(i_fieldnr*2+1,0),meansigbes(i_fieldnr*2+1,0)],linestyle=0,thick=6,color=150
        oplot,[meansigbes(i_fieldnr*2,0),meansigbes(i_fieldnr*2,0)],[meansigbes(i_fieldnr*2+1,0)-meansigbes(i_fieldnr*2+1,1),meansigbes(i_fieldnr*2+1,0)+meansigbes(i_fieldnr*2+1,1)],linestyle=0,thick=6,color=150

      device,/close
      set_plot,'x'
      print,'besancon_rave_plot_two_cols: 1. Converting '+str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
;        spawn,'rm '+str_plotname

; --- Kolmogorov-Smirnov Test
      if n_elements(xarrout_rave) gt 0 and n_elements(xarrout_bes) gt 0 then begin
        if keyword_set(I_NSAMPLES) and i_nsamples gt 1 then begin
          kstwo,DBLARR_DATA_A=xarrout_rave,$
                DBLARR_DATA_B=xarrout_bes(0,*),$
                PROB=prob,$
                DD=dd
        end else begin
          kstwo,DBLARR_DATA_A=xarrout_rave,$
                DBLARR_DATA_B=xarrout_bes,$
                PROB=prob,$
                DD=dd
        end
        print,'besancon_rave_plot_two_cols: i = ',i,': dd = ',dd,', prob = ',prob
        dblarr_dd_x(i) = dd
        dblarr_prob_x(i) = prob

        if keyword_set(I_NSAMPLES) and i_nsamples gt 1 then begin
          kstwo,DBLARR_DATA_A=yarrout_rave,$
                DBLARR_DATA_B=yarrout_bes(0,*),$
                PROB=prob,$
                DD=dd
        end else begin
          kstwo,DBLARR_DATA_A=yarrout_rave,$
                DBLARR_DATA_B=yarrout_bes,$
                PROB=prob,$
                DD=dd
        end
        dblarr_dd_y(i) = dd
        dblarr_prob_y(i) = prob
        printf,luna,'d_x P_x d_y P_y'
        printf,luna,strtrim(string(dblarr_dd_x(i)),2)+' '+strtrim(string(dblarr_prob_x(i)),2)+' '+strtrim(string(dblarr_dd_y(i)),2)+' '+strtrim(string(dblarr_prob_y(i)),2)
        if keyword_set(B_PLOT_MEAN_KST) then begin
          dblarr_prob_x(i) = mean(dblarr_kst(i,*,0))
          dblarr_prob_x(i) = mean(dblarr_kst(i,*,2))
        end
      end else begin
        dblarr_dd_x(i) = -1.
        dblarr_prob_x(i) = -1.
        dblarr_dd_y(i) = -1.
        dblarr_prob_y(i) = -1.
      end
    end else begin; if problem_rave eq 1
      str_gifplotname = str_path + html_path + "/mean_sigma_x_y.gif"
    end

    if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
      dblarr_giant_to_dwarf(i,0) = dblarr_giant_to_dwarf_ratio(i,0)
      dblarr_moment = moment(dblarr_giant_to_dwarf_ratio(i,1:i_nsamples))
      dblarr_giant_to_dwarf(i,1) = dblarr_moment(0)
      dblarr_giant_to_dwarf(i,2) = sqrt(dblarr_moment(1))
    end

    if keyword_set(RAVEDATAFILE) then begin
      str_ravefile = strmid(ravedatafile,0,strpos(ravedatafile,'.',/REVERSE_SEARCH))
    end else begin
      str_ravefile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles_SNR_gt_20'
    end
    str_ravefile = str_ravefile+'_'+subpath+'_'
    if irange(0) gt 0. then $
      str_ravefile = str_ravefile+$
                     'I'+$
                     strmid(strtrim(string(irange(0)),2),0,4)+$
                     '-'+$
                     strmid(strtrim(string(irange(1)),2),0,4)+$
                     '_'
    str_ravefile = str_ravefile+strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+'-'+strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+'_'+strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+'-'+strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))+'.ps'
    print,'besancon_rave_plot_two_cols: str_ravefile = "'+str_ravefile+'"'

    str_besanconfile = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_'+subpath+'.ps'

    if irange(0) gt 0. then begin
      str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_I'+strmid(strtrim(string(irange(0)),2),0,4)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
    endif
    if irange(1) gt 0. then begin
      str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'-'+strmid(strtrim(string(irange(1)),2),0,4)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
    endif
    if keyword_set(STRARR_BESANCON_DATA) then begin
      str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_'+strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+'-'+strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+'_'+strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+'-'+strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
    end
    print,'besancon_rave_plot_two_cols: str_besanconfile = "'+str_besanconfile+'"'

    if keyword_set(TEST) then begin
      str_htmlpath = 'test/html/'+subpath
    end else begin
      str_htmlpath = 'html/'+subpath
    end

    print,'besancon_rave_plot_two_cols: str_path = '+str_path+', str_htmlpath = '+str_htmlpath+', html_path = '+html_path
    do_htmldoc_rave_besancon,str_besanconfile,$
                             str_ravefile,$
                             str_htmlpath,$
;                                 IMIN=imin,$
;                                 IMAX=imax,$
                             IRANGE=irange,$
                             CALCSAMPLES=calcsamples,$
                             I_NSAMPLES=i_nsamples,$
;                                 I_NBINS=i_nbins,$
;                                 NBINSMIN=nbinsmin,$
;                                 NBINSMAX=nbinsmax,$
                             B_ONE_BESANCONFILE=b_one_besanconfile,$
                             B_HIST=b_hist,$
                             TITLES=[xytitle(0),xytitle(1)],$
                             PATH=str_path+html_path+'/',$
                             GIFFILENAMES=strarr_giffilenames

;        endif; problem eq 0
    free_lun,luna
    if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then $
      free_lun,lun_giants_to_dwarf


  endfor; --- every field

  str_i_nstars_file = ''
  if keyword_set(LONLAT) then begin
    str_i_nstars_file = str_path+'n_stars_lon_lat.dat'
  end else begin
    str_i_nstars_file = str_path+'n_stars_ra_dec.dat'
  end
  openw,luns,str_i_nstars_file,/GET_LUN
    if keyword_set(LONLAT) then begin
      printf,luns,'#lon_1 lon_2 lat_1 lat_2 n_stars_rave n_stars_besancon'
    end else begin
      printf,luns,'#ra_1 ra_2 dec_1 dec_2 n_stars_rave n_stars_besancon'
    end
    for i=0,i_nfields-1 do begin
      printf,luns,strtrim(string(dblarr_ra_dec(i,0)),2)+' '+strtrim(string(dblarr_ra_dec(i,1)),2)+' '+strtrim(string(dblarr_ra_dec(i,2)),2)+' '+strtrim(string(dblarr_ra_dec(i,3)),2)+' '+strtrim(string(intarr_nstars(i,0)),2)+' '+strtrim(string(intarr_nstars(i,1)),2)
    endfor
  free_lun,luns

; --- create meanfields
  print,'besancon_rave_plot_two_cols: i_nplots = ',i_nplots
  if i_nplots gt 0 then begin
    dblarr_ra_dec = dblarr_ra_dec(0:i_nplots-1,*)
    meansigfiles = meansigfiles(0:i_nplots-1,*)
;      meansigfiles_samples = meansigfiles_samples(0:i_nplots-1,*)

    if not keyword_set(LONLAT) then begin
; --- plot mean fields in RA and Dec
      str_plotname = str_path + "meanfields_ra_dec.ps"
      str_gifplotname = str_path + "meanfields_ra_dec.gif"
      rave_plot_fields_mean,dblarr_ra_dec,$
                            meansigfiles,$
                            str_plotname,$
                            DATAARR=strarr_rave_data,$
                            RADEC=1,$
                            XYTITLE=xytitle
      print,'besancon_rave_plot_two_cols: 2. Converting '+str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
      spawn,'epstopdf '+str_plotname
      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
;      spawn,'rm '+str_plotname
; --- plot mean fields in Galactic Longitude and Latitude
      dblarr_lon_lat = dblarr_ra_dec
      euler,dblarr_ra_dec[*,0],dblarr_ra_dec[*,2],lon,lat,1
      dblarr_lon_lat[*,0] = lon
      dblarr_lon_lat[*,2] = lat
      euler,dblarr_ra_dec[*,1],dblarr_ra_dec[*,3],lon,lat,1
      dblarr_lon_lat[*,1] = lon
      dblarr_lon_lat[*,3] = lat
      str_plotname = str_path + "meanfields_lon_lat.ps"
      str_gifplotname = str_path + "meanfields_lon_lat.gif"
      rave_plot_fields_mean,dblarr_lon_lat,$
                            meansigfiles,$
                            str_plotname,$
                            DATAARR=strarr_rave_data,$
                            RADEC=0,$
                            XYTITLE=xytitle
      print,'besancon_rave_plot_two_cols: 3. Converting '+ str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
      spawn,'epstopdf '+str_plotname
      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
;      spawn,'rm '+str_plotname
    end else begin
; --- plot mean fields in Lon and Lat
      d_times_sig_meansig = -1.
      d_times_sig_samples = -1.
      dblarr_meansamples = dblarr(i_nfields,4)
      for ll=0,2 do begin
        d_times_sig_meansig = d_times_sig_meansig + 2.
        d_times_sig_samples = d_times_sig_samples + 2.
        str_sig = strtrim(string(d_times_sig_meansig),2)
        str_sig = strmid(str_sig,0,1)
        str_plotname = str_path + 'meanfields_lon_lat_'+str_sig+'_.ps'
        rave_plot_fields_mean,dblarr_ra_dec,$
                              meansigfiles,$
                              str_plotname,$
                              DATAARR=strarr_rave_data,$
                              RADEC=0,$
                              TIMESSIG=d_times_sig_meansig,$
                              XYTITLE=xytitle
        if keyword_set(XYTITLE) then begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 5. Converting '+ str_plotname_temp
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
;          spawn,'rm '+str_plotname

          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
;            spawn,'rm '+str_plotname
        end
        str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
        print,'besancon_rave_plot_two_cols: 6. Converting '+ str_plotname_temp + ' to ' + str_gifplotname
        spawn,'ps2gif ' + str_plotname_temp + ' '+str_gifplotname
        spawn,'epstopdf '+str_plotname_temp
        str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;        reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

        if keyword_set(CALCSAMPLES) then begin
; ---        meansigbes_samples(i_fieldnr,0)=mean(meansigmasamples(*,0))
; ---        meansigbes_samples(i_fieldnr,1)=meanabsdev(meansigmasamples(*,0))
; ---        meansigbes_samples(i_fieldnr,2)=mean(meansigmasamples(*,1))
; ---        meansigbes_samples(i_fieldnr,3)=meanabsdev(meansigmasamples(*,1))
; ---        meansigbes_samples(i_fieldnr,4)=mean(meansigmasamples(*,2))
; ---        meansigbes_samples(i_fieldnr,5)=meanabsdev(meansigmasamples(*,2))
; ---        meansigbes_samples(i_fieldnr,6)=mean(meansigmasamples(*,3))
; ---        meansigbes_samples(i_fieldnr,7)=meanabsdev(meansigmasamples(*,3))

; --- from rave_besancon_plot_two_cols
; ---        meansigmasamples(i,0) = meanx_plot
; ---        meansigmasamples(i,1) = meany_plot
; ---        meansigmasamples(i,2) = sigmax_plot
; ---        meansigmasamples(i,3) = sigmay_plot

; --- in rave_plot_fields_mean
; ---        strarr_meandata = readfiletostrarr(strarr_meansigfiles(i), ' ')
; ---        dblarr_meanxrave(i) = double(strarr_meandata(0,1))
; ---        dblarr_meanyrave(i) = double(strarr_meandata(0,3))
; ---        dblarr_meanxbes(i) = double(strarr_meandata(1,1))
; ---        dblarr_meanybes(i) = double(strarr_meandata(1,3))
; ---        dblarr_sigmaxrave(i) = double(strarr_meandata(0,2))
; ---        dblarr_sigmayrave(i) = double(strarr_meandata(0,4))
; ---        dblarr_sigmaxbes(i) = double(strarr_meandata(1,2))
; ---        dblarr_sigmaybes(i) = double(strarr_meandata(1,4))
; ---   with MEANSIGSAMPLES:
; ---        dblarr_meanxbes = meansigsamples(*,0)
; ---        dblarr_meanybes = meansigsamples(*,1)
; ---        dblarr_sigmaxbes = meansigsamples(*,2)
; ---        dblarr_sigmaybes = meansigsamples(*,3)

; --- plot mean fields comparing to the random samples in Lon and Lat
; --- mean samples
;          if problem_bes eq 0 then begin
          dblarr_meansamples(*,0) = meansigbes_samples(*,0) ; --- mean(meanxbes)
          dblarr_meansamples(*,1) = meansigbes_samples(*,2) ; --- mean(meanybes)
          dblarr_meansamples(*,2) = meansigbes_samples(*,1) ; --- sigma(meanxbes)
          dblarr_meansamples(*,3) = meansigbes_samples(*,3) ; --- sigma(meanybes)
          str_plotname = str_path + 'meanfields_lon_lat_samples_'+str_sig+'_mean_.ps'
          print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
          rave_plot_fields_mean,dblarr_ra_dec,$
                                meansigfiles,$
                                str_plotname,$
                                DATAARR=strarr_rave_data,$
                                RADEC=0,$
                                TIMESSIG=d_times_sig_samples,$
                                MEANSIGSAMPLES=dblarr_meansamples,$
                                XYTITLE=xytitle
          if keyword_set(XYTITLE) then begin
            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
            str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
            print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp
            spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
            spawn,'epstopdf '+str_plotname_temp
            str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;            reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
          end
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to '+str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

; --- sigma samples
;          dblarr_meansamples = dblarr(i_nfields,4)
          dblarr_meansamples(*,0) = meansigbes_samples(*,4) ; --- mean(sigmaxbes)
          dblarr_meansamples(*,1) = meansigbes_samples(*,6) ; --- mean(sigmaybes)
          dblarr_meansamples(*,2) = meansigbes_samples(*,5) ; --- sigma(sigmaxbes)
          dblarr_meansamples(*,3) = meansigbes_samples(*,7) ; --- sigma(sigmaybes)
          str_plotname = str_path + 'meanfields_lon_lat_samples_'+str_sig+'_sigma_.ps'
          print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
          ;print,'besancon_rave_plot_two_cols: dblarr_meansamples = ',dblarr_meansamples
          rave_plot_fields_mean,dblarr_ra_dec,$
                                meansigfiles,$
                                str_plotname,$
                                DATAARR=strarr_rave_data,$
                                RADEC=0,$
                                TIMESSIG=d_times_sig_samples,$
                                MEANSIGSAMPLES=dblarr_meansamples,$
                                XYTITLE=xytitle,$
                                SIGMA=1
          if keyword_set(XYTITLE) then begin
            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
            str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
            print,'besancon_rave_plot_two_cols: 12. Converting '+ str_plotname_temp
            spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
            spawn,'epstopdf '+str_plotname_temp
            str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;            reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
          end
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 13. Converting '+ str_plotname_temp+' to '+str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

; --- skewness samples
;          if problem_bes eq 0 then begin
          dblarr_meansamples(*,0) = meansigbes_samples(*,8) ; --- mean(skewnessxbes)
          dblarr_meansamples(*,1) = meansigbes_samples(*,10) ; --- mean(skewnessybes)
          dblarr_meansamples(*,2) = meansigbes_samples(*,9) ; --- sigma(skewnessxbes)
          dblarr_meansamples(*,3) = meansigbes_samples(*,11) ; --- sigma(skewnessybes)
          str_plotname = str_path + 'meanfields_lon_lat_samples_'+str_sig+'_skewness_.ps'
          print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
          rave_plot_fields_mean,dblarr_ra_dec,$
                                meansigfiles,$
                                str_plotname,$
                                DATAARR=strarr_rave_data,$
                                RADEC=0,$
                                TIMESSIG=d_times_sig_samples,$
                                MEANSIGSAMPLES=dblarr_meansamples,$
                                XYTITLE=xytitle,$
                                SIGMA=2
          if keyword_set(XYTITLE) then begin
            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
            str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
            print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp
            spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
            spawn,'epstopdf '+str_plotname_temp
            str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;            reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
          end
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to '+str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

; --- kurtosis samples
;          if problem_bes eq 0 then begin
          dblarr_meansamples(*,0) = meansigbes_samples(*,12) ; --- mean(kurtosisxbes)
          dblarr_meansamples(*,1) = meansigbes_samples(*,14) ; --- mean(kurtosisybes)
          dblarr_meansamples(*,2) = meansigbes_samples(*,13) ; --- sigma(kurtosisxbes)
          dblarr_meansamples(*,3) = meansigbes_samples(*,15) ; --- sigma(kurtosisybes)

          str_plotname = str_path + 'meanfields_lon_lat_samples_'+str_sig+'_kurtosis_.ps'
          print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
          rave_plot_fields_mean,dblarr_ra_dec,$
                                meansigfiles,$
                                str_plotname,$
                                DATAARR=strarr_rave_data,$
                                RADEC=0,$
                                TIMESSIG=d_times_sig_samples,$
                                MEANSIGSAMPLES=dblarr_meansamples,$
                                XYTITLE=xytitle,$
                                SIGMA=3
          if keyword_set(XYTITLE) then begin
            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
            str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
            print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp
            spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
            spawn,'epstopdf '+str_plotname_temp
            str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;            reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

            str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
          end
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to '+str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

          if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
; --- giant-to-dwarf ratio samples
;          if problem_bes eq 0 then begin
            dblarr_meansamples(*,0) = dblarr_giant_to_dwarf(*,1) ; --- mean(bes)
            dblarr_meansamples(*,1) = dblarr_giant_to_dwarf(*,1) ; --- mean(bes)
            dblarr_meansamples(*,2) = dblarr_giant_to_dwarf(*,2) ; --- sigma(bes)
            dblarr_meansamples(*,3) = dblarr_giant_to_dwarf(*,2) ; --- sigma(bes)

            dblarr_giant_to_dwarf_rave = dblarr(i_nfields,4)
            dblarr_giant_to_dwarf_rave(*,0) = dblarr_giant_to_dwarf(*,0)
            dblarr_giant_to_dwarf_rave(*,1) = dblarr_giant_to_dwarf(*,0)
            dblarr_giant_to_dwarf_rave(*,2) = 1.
            dblarr_giant_to_dwarf_rave(*,3) = 1.

;            print,'dblarr_meansamples = ',dblarr_meansamples
;            print,'dblarr_giant_to_dwarf_rave = ',dblarr_giant_to_dwarf_rave
            ;stop

            str_plotname = str_path + 'meanfields_lon_lat_samples_'+str_sig+'_giant_to_dwarf_ratio_.ps'
            print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
            rave_plot_fields_mean,dblarr_ra_dec,$
                                  meansigfiles,$
                                  str_plotname,$
                                  DATAARR=strarr_rave_data,$
                                  RADEC=0,$
                                  TIMESSIG=d_times_sig_samples,$
                                  MEANSIGSAMPLES=dblarr_meansamples,$
                                  DBLARR_MEANSIGRAVE=dblarr_giant_to_dwarf_rave,$
                                  XYTITLE=xytitle;,$
;                                  SIGMA=3
            if keyword_set(XYTITLE) then begin
              str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(0)+'.ps'
              str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
              print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp
              spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
              spawn,'epstopdf '+str_plotname_temp
              str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;              reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

              str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'_',/REVERSE_SEARCH)+1)+xytitle(1)+'.ps'
            end
            str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
            print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to '+str_gifplotname
            spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
            spawn,'epstopdf '+str_plotname_temp
            str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;            reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
          endif
        end
      endfor





; --- plot mean fields comparing to the random samples in Lon and Lat
; --- mean samples colour range =[-dbl_xmax,dbl_xmax]
;          if problem_bes eq 0 then begin
      if keyword_set(CALCSAMPLES) and keyword_set(DBL_XMAX) and keyword_set(DBL_YMAX) then begin
        dbl_xmax_work = dbl_xmax
        dbl_ymax_work = dbl_ymax
        dblarr_meansamples = dblarr(i_nfields,4)
        dblarr_meansamples(*,0) = meansigbes_samples(*,0) ; --- mean(meanxbes)
        dblarr_meansamples(*,1) = meansigbes_samples(*,2) ; --- mean(meanybes)
        dblarr_meansamples(*,2) = meansigbes_samples(*,1) ; --- sigma(meanxbes)
        dblarr_meansamples(*,3) = meansigbes_samples(*,3) ; --- sigma(meanybes)
        str_plotname = str_path + 'meanfields_lon_lat_samples_tot_.ps'
        print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
        d_times_sig_samples = 0;
        rave_plot_fields_mean,dblarr_ra_dec,$
                              meansigfiles,$
                              str_plotname,$
                              DATAARR=strarr_rave_data,$
                              RADEC=0,$
                              TIMESSIG=d_times_sig_samples,$
                              MEANSIGSAMPLES=dblarr_meansamples,$
                              XYTITLE=xytitle,$
                              DBL_XMAX=dbl_xmax_work,$
                              DBL_YMAX=dbl_ymax_work
        if keyword_set(XYTITLE) then begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax_work),2),0,4)+'.ps'
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp + ' to '+ str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
;            spawn,'rm '+str_plotname

          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax_work),2),0,4)+'.ps'
;              spawn,'rm '+str_plotname
        end
        str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
        print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to ' + str_gifplotname
        spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
        spawn,'epstopdf '+str_plotname_temp
        str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;        reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'

      ; --- dbl_xmax / 2. and dbl_ymax / 2.
        str_plotname = str_path + 'meanfields_lon_lat_samples_tot_.ps'
        print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
        d_times_sig_samples = 0;
        dbl_xmax_work = dbl_xmax / 2.
        dbl_ymax_work = dbl_ymax / 2.
        rave_plot_fields_mean,dblarr_ra_dec,$
                              meansigfiles,$
                              str_plotname,$
                              DATAARR=strarr_rave_data,$
                              RADEC=0,$
                              TIMESSIG=d_times_sig_samples,$
                              MEANSIGSAMPLES=dblarr_meansamples,$
                              XYTITLE=xytitle,$
                              DBL_XMAX=dbl_xmax_work,$
                              DBL_YMAX=dbl_ymax_work
        if keyword_set(XYTITLE) then begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax_work),2),0,4)+'.ps'
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp + ' to '+ str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
;            spawn,'rm '+str_plotname

          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax_work),2),0,4)+'.ps'
;            spawn,'rm '+str_plotname
        end
        str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
        print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to ' + str_gifplotname
        spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
        spawn,'epstopdf '+str_plotname_temp
        str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;        reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'


      ; --- calculate dbl_xmax and dbl_ymax
        dbl_xmax_work = 1.
        dbl_ymax_work = 1.
        str_plotname = str_path + 'meanfields_lon_lat_samples_tot_.ps'
        print,'besancon_rave_plot_two_cols: starting rave_plot_fields_mean: str_plotname = '+str_plotname
        d_times_sig_samples = 0;
        rave_plot_fields_mean,dblarr_ra_dec,$
                              meansigfiles,$
                              str_plotname,$
                              DATAARR=strarr_rave_data,$
                              RADEC=0,$
                              TIMESSIG=d_times_sig_samples,$
                              MEANSIGSAMPLES=dblarr_meansamples,$
                              XYTITLE=xytitle,$
                              DBL_XMAX=dbl_xmax_work,$
                              DBL_YMAX=dbl_ymax_work
        if keyword_set(XYTITLE) then begin
          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax_work),2),0,4)+'.ps'
          str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
          print,'besancon_rave_plot_two_cols: 8. Converting '+ str_plotname_temp + ' to '+ str_gifplotname
          spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
          spawn,'epstopdf '+str_plotname_temp
          str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;          reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
;            spawn,'rm '+str_plotname

          str_plotname_temp = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax_work),2),0,4)+'.ps'
;            spawn,'rm '+str_plotname
        end
        str_gifplotname = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))+'.gif'
        print,'besancon_rave_plot_two_cols: 9. Converting '+ str_plotname_temp + ' to ' + str_gifplotname
        spawn,'ps2gif '+str_plotname_temp+' '+str_gifplotname
        spawn,'epstopdf '+str_plotname_temp
        str_plotname_temp = strmid(str_plotname_temp,0,strpos(str_plotname_temp,'.',/REVERSE_SEARCH))
;        reduce_pdf_size,str_plotname_temp+'.pdf',str_plotname_temp+'_small.pdf'
      endif

      if keyword_set(CALCSAMPLES) then $
        print,'besancon_rave_plot_two_cols: keyword_set(CALCSAMPLES) == TRUE'
      if keyword_set(DBL_XMAX) then $
        print,'besancon_rave_plot_two_cols: keyword_set(DBL_XMAX) == TRUE, dbl_xmax = ',dbl_xmax
      if keyword_set(DBL_YMAX) then $
        print,'besancon_rave_plot_two_cols: keyword_set(DBL_YMAX) == TRUE, dbl_ymax = ',dbl_ymax

;      stop



; --- plot Kolmogorov-Smirnov Test in RA and Dec
      openw,lunprob,str_path+'prob_xy.dat',/GET_LUN
        if not keyword_set(LONLAT) then begin
          printf,lunprob,'#RA_0 RA_1 DEC_0 DEC_1 P_X P_Y'
        end else begin
          printf,lunprob,'#l_0 l_1 b_0 b_1 P_x P_y'
        endelse
        for xxx=0,n_elements(dblarr_prob_x)-1 do begin
          printf,lunprob,strtrim(string(dblarr_ra_dec(xxx,0)),2)+' '+strtrim(string(dblarr_ra_dec(xxx,1)),2)+' '+strtrim(string(dblarr_ra_dec(xxx,2)),2)+' '+strtrim(string(dblarr_ra_dec(xxx,3)),2)+' '+strtrim(string(dblarr_prob_x(xxx)),2)+' '+strtrim(string(dblarr_prob_y(xxx)),2)
        endfor
      free_lun,lunprob
      str_plotname = str_path+'fields_kst_'+xytitle(0)+'.ps'
      rave_plot_fields_ks,dblarr_ra_dec,$
                          str_plotname,$
                          STRARR_RAVE_STARS=strarr_rave_data,$
                          DBLARR_DATA=dblarr_prob_x;,$
      spawn,'ps2gif '+str_plotname+' '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
      spawn,'epstopdf '+str_plotname
      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
      spawn,'epstopdf '+str_plotname+'.ps'
;      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
;      spawn,'rm '+str_plotname

      str_plotname = str_path+'fields_kst_'+xytitle(1)+'.ps'
      rave_plot_fields_ks,dblarr_ra_dec,$
                          str_plotname,$
                          STRARR_RAVE_STARS=strarr_rave_data,$
                          DBLARR_DATA=dblarr_prob_y;,$
      spawn,'ps2gif '+str_plotname+' '+strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
      spawn,'epstopdf '+str_plotname
      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
      spawn,'epstopdf '+str_plotname+'.ps'
;      str_plotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))
;      reduce_pdf_size,str_plotname+'.pdf',str_plotname+'_small.pdf'
;      spawn,'rm '+str_plotname


    endelse

  endif


  str_x = strmid(subpath,0,strpos(subpath,'_'))
  str_y = strmid(subpath,strpos(subpath,'_')+1)
  openw,luni,str_path+'index.html',/GET_LUN
    printf,luni,'<html>'
    printf,luni,'<body>'
; --- show field images
    printf,luni,'<center><img src="rave_chart.gif" width="520" height="373" usemap="#pixelmap"><br><br>'
    if not keyword_set(LONLAT) then begin
      if not keyword_set(XYTITLE) then begin
        printf,luni,'<img src="meanfields_ra_dec.gif" width="520" height="373" usemap="#pixelmap"><br>Lower triangle: Mean('+str_x+'), Upper triangle: Mean('+str_y+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
      end else begin
        printf,luni,'<img src="meanfields_ra_dec_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
        printf,luni,'<img src="meanfields_ra_dec_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
      end
    end else begin; if keyword_set(LONLAT)

      ; --- plot mean(RAVE) vs. mean and sigma(Besancon)
      d_times_sig_meansig = -1.
      for ll=0,2 do begin
        d_times_sig_meansig = d_times_sig_meansig + 2.
        str_sig = strtrim(string(d_times_sig_meansig),2)
        str_sig = strmid(str_sig,0,1)
        if not keyword_set(XYTITLE) then begin
          printf,luni,'<img src="meanfields_lon_lat_'+str_sig+'.gif" width="520" height="373" usemap="#pixelmap"><br>Mean('+str_x+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
        end else begin
          printf,luni,'<img src="meanfields_lon_lat_'+str_sig+'_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_'+str_sig+'_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+')<br>Color range: Mean_Besancon - ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon) ... Mean_Besancon + ('+strmid(strtrim(string(d_times_sig_meansig),2),0,1)+' * Sigma_Besancon)<br><br>'
        end
      endfor

      ; --- plot mean(RAVE) vs. mean(mean(Besancon)) and sigma(mean(Besancon))
      d_times_sig_samples = -1.
      for ll=0,2 do begin
        d_times_sig_samples = d_times_sig_samples + 2.
        str_sig = strtrim(string(d_times_sig_samples),2)
        str_sig = strmid(str_sig,0,1)
        if keyword_set(CALCSAMPLES) then begin
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_'+str_sig+'_mean'+'_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the random samples.<br>Color range: Mean(Mean_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i)) ... Mean(Mean_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i))<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_'+str_sig+'_mean'+'_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the random samples.<br>Color range: Mean(Mean_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i)) ... Mean(Mean_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i))<br><br>'
        endif
        if (ll gt 0) and (b_do_boxcar_smoothing or b_plot_contours) then begin
          ; --- plot contours
          int_nsmoothings = 0
          for lll=0,2 do begin
            if keyword_set(CALCSAMPLES) then begin
              if ((lll eq 0) or ((lll gt 0) and (b_do_boxcar_smoothing))) then begin
                printf,luni,'<hr><br><img src="mean_contours_'+xytitle(0)+'_'+strtrim(string(long(int_nsmoothings)),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the random samples.<br>Color range: Mean(Mean_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i)) ... Mean(Mean_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i))<br><br>'
                printf,luni,'<hr><br><img src="mean_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the random samples.<br>Color range: Mean(Mean_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i)) ... Mean(Mean_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Mean_Besancon_i))<br><br>'
              endif
            endif
            int_nsmoothings = int_nsmoothings + 1
          endfor
        endif
      endfor
      ; --- plot contours
      if (b_plot_contours or b_do_boxcar_smoothing) then begin
        int_nsmoothings = 0
        for ll=0,2 do begin
          if keyword_set(CALCSAMPLES) then begin
            if ((ll eq 0) or ((ll gt 0) and (b_do_boxcar_smoothing))) then begin
              printf,luni,'<hr><br><img src="mean_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the random samples.<br>Color range: min(Mean(RAVE) - Mean(Mean_Besancon_i)) ... max(Mean(RAVE) - Mean(Mean_Besancon_i))<br><br>'
              printf,luni,'<hr><br><img src="mean_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the random samples.<br>Color range: min(Mean(RAVE) - Mean(Mean_Besancon_i)) ... max(Mean(RAVE) - Mean(Mean_Besancon_i))<br><br>'
            endif
          endif
          int_nsmoothings = int_nsmoothings + 1
        endfor
      endif

      ; --- plot sigma(RAVE) vs. mean(sigma(Besancon)) and sigma(sigma(Besancon))
      d_times_sig_samples = -1.
      for ll=0,2 do begin
        d_times_sig_samples = d_times_sig_samples + 2.
        str_sig = strtrim(string(d_times_sig_samples),2)
        str_sig = strmid(str_sig,0,1)
        if keyword_set(CALCSAMPLES) then begin
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_'+str_sig+'_sigma'+'_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_x+'_RAVE) to the random samples.<br> Color range: Mean(Sigma_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i)) ... Mean(Sigma_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i))<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_'+str_sig+'_sigma'+'_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_y+'_RAVE) to the random samples.<br> Color range: Mean(Sigma_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i)) ... Mean(Sigma_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i))<br><br>'
        endif
        ; --- plot contours
        int_nsmoothings = 0
        for lll=0,2 do begin
          if keyword_set(CALCSAMPLES) then begin
            if ((lll eq 0) or ((lll gt 0) and (b_do_boxcar_smoothing))) then begin
              printf,luni,'<hr><br><img src="sigma_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_x+'_RAVE) to the random samples.<br>Color range: Mean(Sigma_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i)) ... Mean(Sigma_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i))<br><br>'
              printf,luni,'<hr><br><img src="sigma_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_y+'_RAVE) to the random samples.<br>Color range: Mean(Sigma_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i)) ... Mean(Sigma_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Sigma_Besancon_i))<br><br>'
            endif
          endif
          int_nsmoothings = int_nsmoothings + 1
        endfor
      endfor
      if b_plot_contours then begin
        ; --- plot contours
        int_nsmoothings = 0
        for ll=0,2 do begin
          if keyword_set(CALCSAMPLES) then begin
            if ((ll eq 0) or ((ll gt 0) and (b_do_boxcar_smoothing))) then begin
              printf,luni,'<hr><br><img src="sigma_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_x+'_RAVE) to the random samples.<br>Color range: min(Sigma(RAVE) - Mean(Sigma_Besancon_i)) ... max(Sigma(RAVE) - Mean(Sigma_Besancon_i))<br><br>'
              printf,luni,'<hr><br><img src="sigma_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Sigma('+str_y+'_RAVE) to the random samples.<br>Color range: min(Sigma(RAVE) - Mean(Sigma_Besancon_i)) ... max(Sigma(RAVE) - Mean(Sigma_Besancon_i))<br><br>'
            endif
          endif
          int_nsmoothings = int_nsmoothings + 1
        endfor
      endif

      ; --- plot skewness(RAVE) vs. mean(skewness(Besancon)) and sigma(skewness(Besancon))
      d_times_sig_samples = -1.
      for ll=0,2 do begin
        d_times_sig_samples = d_times_sig_samples + 2.
        str_sig = strtrim(string(d_times_sig_samples),2)
        str_sig = strmid(str_sig,0,1)
        if keyword_set(CALCSAMPLES) then begin
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_'+str_sig+'_skewness'+'_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_x+'_RAVE) to the random samples.<br> Color range: Mean(Skewness_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i)) ... Mean(Skewness_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i))<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_'+str_sig+'_skewness'+'_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_y+'_RAVE) to the random samples.<br> Color range: Mean(Skewness_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i)) ... Mean(Skewness_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i))<br><br>'
        endif
        if b_plot_contours then begin
          ; --- plot contours
          int_nsmoothings = 0
          for lll=0,2 do begin
            if keyword_set(CALCSAMPLES) then begin
              if ((lll eq 0) or ((lll gt 0) and (b_do_boxcar_smoothing))) then begin
                printf,luni,'<hr><br><img src="skewness_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_x+'_RAVE) to the random samples.<br>Color range: Mean(Skewness_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i)) ... Mean(Skewness_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i))<br><br>'
                printf,luni,'<hr><br><img src="skewness_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_y+'_RAVE) to the random samples.<br>Color range: Mean(Skewness_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i)) ... Mean(Skewness_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Skewness_Besancon_i))<br><br>'
              endif
              int_nsmoothings = int_nsmoothings + 1
            endif
          endfor
        endif
      endfor
      ; --- plot contours
      if b_plot_contours then begin
        int_nsmoothings = 0
        for ll=0,2 do begin
          if ((ll eq 0) or ((ll gt 0) and (b_do_boxcar_smoothing))) then begin
            if keyword_set(CALCSAMPLES) then begin
              printf,luni,'<hr><br><img src="skewness_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_x+'_RAVE) to the random samples.<br>Color range: min(Skewness(RAVE) - Mean(Skewness_Besancon_i)) ... max(Skewness(RAVE) - Mean(Skewness_Besancon_i))<br><br>'
              printf,luni,'<hr><br><img src="skewness_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Skewness('+str_y+'_RAVE) to the random samples.<br>Color range: min(Skewness(RAVE) - Mean(Skewness_Besancon_i)) ... max(Skewness(RAVE) - Mean(Skewness_Besancon_i))<br><br>'
            endif
            int_nsmoothings = int_nsmoothings + 1
          endif
        endfor
      endif

      ; --- plot kurtosis(RAVE) vs. mean(kurtosis(Besancon)) and sigma(kurtosis(Besancon))
      d_times_sig_samples = -1.
      for ll=0,2 do begin
        d_times_sig_samples = d_times_sig_samples + 2.
        str_sig = strtrim(string(d_times_sig_samples),2)
        str_sig = strmid(str_sig,0,1)
        if keyword_set(CALCSAMPLES) then begin
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_'+str_sig+'_kurtosis'+'_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_x+'_RAVE) to the random samples.<br> Color range: Mean(Kurtosis_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i)) ... Mean(Kurtosis_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i))<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_'+str_sig+'_kurtosis'+'_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_y+'_RAVE) to the random samples.<br> Color range: Mean(Kutosis_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i)) ... Mean(Kurtosis_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i))<br><br>'
        endif
        if b_plot_contours then begin
          ; --- plot contours
          int_nsmoothings = 0
          for lll=0,2 do begin
            if keyword_set(CALCSAMPLES) then begin
              if ((lll eq 0) or ((lll gt 0) and (b_do_boxcar_smoothing))) then begin
                printf,luni,'<hr><br><img src="kurtosis_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_x+'_RAVE) to the random samples.<br>Color range: Mean(Kurtosis_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i)) ... Mean(Kurtosis_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i))<br><br>'
                printf,luni,'<hr><br><img src="kurtosis_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings_meansig.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_y+'_RAVE) to the random samples.<br>Color range: Mean(Kurtosis_Besancon_i) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i)) ... Mean(Kurtosis_Besancon_i) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Kurtosis_Besancon_i))<br><br>'
              endif
              int_nsmoothings = int_nsmoothings + 1
            endif
          endfor
        endif
      endfor
      ; --- plot contours
      if b_plot_contours then begin
        int_nsmoothings = 0
        for ll=0,2 do begin
          if keyword_set(CALCSAMPLES) then begin
            if ((ll eq 0) or ((ll gt 0) and (b_do_boxcar_smoothing))) then begin
              printf,luni,'<hr><br><img src="kurtosis_contours_'+xytitle(0)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_x+'_RAVE) to the random samples.<br>Color range: min(Kurtosis(RAVE) - Mean(Kurtosis_Besancon_i)) ... max(Kurtosis(RAVE) - Mean(Kurtosis_Besancon_i))<br><br>'
              printf,luni,'<hr><br><img src="kurtosis_contours_'+xytitle(1)+'_'+strtrim(string(int_nsmoothings),2)+'smoothings.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Kurtosis('+str_y+'_RAVE) to the random samples.<br>Color range: min(Kurtosis(RAVE) - Mean(Kurtosis_Besancon_i)) ... max(Kurtosis(RAVE) - Mean(Kurtosis_Besancon_i))<br><br>'
            endif
            int_nsmoothings = int_nsmoothings + 1
          endif
        endfor
      endif

      if keyword_set(I_PLOT_GIANT_TO_DWARF_RATIO) then begin
        ; --- plot giant-to-dwarf ratio
        d_times_sig_samples = -1.
        for ll=0,2 do begin
          d_times_sig_samples = d_times_sig_samples + 2.
          str_sig = strtrim(string(d_times_sig_samples),2)
          str_sig = strmid(str_sig,0,1)
          if keyword_set(CALCSAMPLES) then begin
            printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_'+str_sig+'_giant_to_dwarf_ratio_'+xytitle(i_plot_giant_to_dwarf_ratio-1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Giant-to-Dwarf ratio to the random samples.<br> Color range: Mean(Giant-to-Dwarf ratio Besancon) - ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Giant-to-Dwarf ratio Besancon)) ... Mean(Giant-to-Dwarf ratio Besancon) + ('+strmid(strtrim(string(d_times_sig_samples),2),0,1)+' * Sigma(Giant-to-Dwarf ratio Besancon))<br><br>'
          endif
        endfor
      endif

      ; --- plot total differences of mean values
      if keyword_set(CALCSAMPLES) then begin
        if not keyword_set(XYTITLE) then begin
          printf,luni,'<hr><br><img src="meanfields_lon_lat_'+str_sig+'.gif" width="520" height="373" usemap="#pixelmap"><br>Mean('+str_x+')<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_xmax),2),0,4)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_xmax),2),0,4)+'<br><br>'
        end else begin
          ; --- set dbl_xmax and dbl_ymax
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_tot_'+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_xmax),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_xmax),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+'<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_tot_'+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_ymax),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_ymax),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+'<br><br>'

          ; --- set dbl_xmax and dbl_ymax / 2.
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_tot_'+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax/2.),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_xmax/2.),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_xmax/2.),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+'<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_tot_'+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax/2.),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_ymax/2.),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_ymax/2.),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+'<br><br>'

          ; --- dbl_xmax and dbl_ymax set to maximum values
          printf,luni,'<hr><br><img src="meanfields_lon_lat_samples_tot_'+xytitle(0)+'_'+strmid(strtrim(string(dbl_xmax_work),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_x+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_xmax_work),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_xmax_work),2),0,4)+' '+strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1)+'<br><br>'
          printf,luni,'<img src="meanfields_lon_lat_samples_tot_'+xytitle(1)+'_'+strmid(strtrim(string(dbl_ymax_work),2),0,4)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Comparison of Mean('+str_y+'_RAVE) to the mean value of the mean values of the random samples taken from the Besancon data<br>Color range: Mean_Besancon - '+strmid(strtrim(string(dbl_ymax_work),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+' ... Mean_Besancon + '+strmid(strtrim(string(dbl_ymax_work),2),0,4)+' '+strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1)+'<br><br>'
        endelse
      endif
    endelse

    str_xtitle = xytitle(0)
    if strpos(str_xtitle,' ') ge 0 then $
      str_xtitle = strmid(str_xtitle,0,strpos(str_xtitle,' '))
    str_ytitle = xytitle(1)
    if strpos(str_ytitle,' ') ge 0 then $
      str_ytitle = strmid(str_ytitle,0,strpos(str_ytitle,' '))

    rave_besancon_plot_meanvalues, STR_PATH = str_path,$
                                   I_NSAMPLES = i_nsamples,$
                                   STR_RAVEFILENAME = ravedatafile,$
                                   STR_X_DIM = strmid(xtitle,strpos(xtitle,'[')+1,strpos(xtitle,']')-strpos(xtitle,'[')-1),$
                                   STR_Y_DIM = strmid(ytitle,strpos(ytitle,'[')+1,strpos(ytitle,']')-strpos(ytitle,'[')-1),$
                                   STR_XTITLE = str_xtitle,$
                                   STR_YTITLE = str_ytitle


    printf,luni,'<hr><br><a href="meanfields/index.html">Mean values for RAVE and Besancon fields</a><br><br>'
    printf,luni,'<hr><br><img src="fields_kst_'+xytitle(0)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Kolmogorov-Smirnov Probability that RAVE and Besancon samples of '+str_x+' are drawn from the same distribution<br><br>'
    printf,luni,'<img src="fields_kst_'+xytitle(1)+'.gif" width="520" height="373" usemap="#pixelmap"><br>Kolmogorov-Smirnov Probability that RAVE and Besancon samples of '+str_y+' are drawn from the same distribution<br><br>'
    for i=0UL,i_nfields-1 do begin
; --- create one html index file per subdir
      html_path = strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+$
                  '-'+$
                  strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+$
                  '_'+$
                  strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+$
                  '-'+$
                  strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))
      str_gifplotname = str_path + html_path + "/mean_sigma_x_y.gif"
      str_gifplotdir = strmid(str_gifplotname,0,strpos(str_gifplotname,'/',/REVERSE_SEARCH))
      str_gifplotdir = strmid(str_gifplotdir,strpos(str_gifplotdir,'/',/REVERSE_SEARCH)+1)
      if not keyword_set(LONLAT) then begin
        euler,dblarr_fields(i,0),dblarr_fields(i,2),lona,lata,1
        euler,dblarr_fields(i,1),dblarr_fields(i,3),lonb,latb,1
        str_print = '<hr><a href="'+$
                    html_path+$
                    '/index.html"><img src="'+str_gifplotdir+'/'+strmid(str_gifplotname,strpos(str_gifplotname,'/',/REVERSE_SEARCH)+1)+'"<br>RA = '+$
                    strmid(strtrim(string(strarr_fields(i,0)),2),0,strpos(strtrim(string(strarr_fields(i,0)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' - '+$
                    strmid(strtrim(string(strarr_fields(i,1)),2),0,strpos(strtrim(string(strarr_fields(i,1)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' deg, DEC = '+$
                    strmid(strtrim(string(strarr_fields(i,2)),2),0,strpos(strtrim(string(strarr_fields(i,2)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' - '+$
                    strmid(strtrim(string(strarr_fields(i,3)),2),0,strpos(strtrim(string(strarr_fields(i,3)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' deg<br>l = '+strmid(strtrim(string(lona),2),0,strpos(strtrim(string(lona),2),'.',/REVERSE_SEARCH)+3)+' - '+strmid(strtrim(string(lonb),2),0,strpos(strtrim(string(lonb),2),'.',/REVERSE_SEARCH)+3)+' deg, b = '+strmid(strtrim(string(lata),2),0,strpos(strtrim(string(lata),2),'.',/REVERSE_SEARCH)+3)+' - '+strmid(strtrim(string(latb),2),0,strpos(strtrim(string(latb),2),'.',/REVERSE_SEARCH)+3)+' deg<br>'+strtrim(string(intarr_nstars(i,0)),2)+' RAVE stars, '+strtrim(string(intarr_nstars(i,1)),2)+' Besancon stars</a><br>'
      end else begin
        euler,dblarr_fields(i,0),dblarr_fields(i,2),lona,lata,2
        euler,dblarr_fields(i,1),dblarr_fields(i,3),lonb,latb,2
        print,'besancon_rave_plot_two_cols: n_elements(nrejectedx) = ',n_elements(nrejectedx)
        if n_elements(nrejectedx) eq 0 then nrejectedx = 0
        if n_elements(nrejectedy) eq 0 then nrejectedy = 0
        str_print = '<hr><a name="'+strmid(strtrim(string(strarr_fields(i,0)),2),0,strpos(strtrim(string(strarr_fields(i,0)),2),'.',/REVERSE_SEARCH)+3)+$
                    '-'+$
                    strmid(strtrim(string(strarr_fields(i,1)),2),0,strpos(strtrim(string(strarr_fields(i,1)),2),'.',/REVERSE_SEARCH)+3)+$
                    '_'+$
                    strmid(strtrim(string(strarr_fields(i,2)),2),0,strpos(strtrim(string(strarr_fields(i,2)),2),'.',/REVERSE_SEARCH)+3)+$
                    '-'+$
                    strmid(strtrim(string(strarr_fields(i,3)),2),0,strpos(strtrim(string(strarr_fields(i,3)),2),'.',/REVERSE_SEARCH)+3)+'"><a href="'+$
                    html_path+$
                    '/index.html"><img src="'+str_gifplotdir+'/'+strmid(str_gifplotname,strpos(str_gifplotname,'/',/REVERSE_SEARCH)+1)+'"<br>l = '+$
                    strmid(strtrim(string(strarr_fields(i,0)),2),0,strpos(strtrim(string(strarr_fields(i,0)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' - '+$
                    strmid(strtrim(string(strarr_fields(i,1)),2),0,strpos(strtrim(string(strarr_fields(i,1)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' deg, b = '+$
                    strmid(strtrim(string(strarr_fields(i,2)),2),0,strpos(strtrim(string(strarr_fields(i,2)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' - '+$
                    strmid(strtrim(string(strarr_fields(i,3)),2),0,strpos(strtrim(string(strarr_fields(i,3)),2),'.',/REVERSE_SEARCH)+3)+$
                    ' deg<br>RA = '+strmid(strtrim(string(lona),2),0,strpos(strtrim(string(lona),2),'.',/REVERSE_SEARCH)+3)+' - '+strmid(strtrim(string(lonb),2),0,strpos(strtrim(string(lonb),2),'.',/REVERSE_SEARCH)+3)+' deg, Dec = '+strmid(strtrim(string(lata),2),0,strpos(strtrim(string(lata),2),'.',/REVERSE_SEARCH)+3)+' - '+strmid(strtrim(string(latb),2),0,strpos(strtrim(string(latb),2),'.',/REVERSE_SEARCH)+3)+' deg<br>'+strtrim(string(intarr_nstars(i,0)),2)+' RAVE stars counted ('+strtrim(string(long(nrejectedx)),2)+' without '+xytitle(0)+', '+strtrim(string(long(nrejectedy)),2)+' without '+xytitle(1)+')<br>'+strtrim(string(intarr_nstars(i,1)),2)+' Besancon stars</a><br>green: all Besancon stars, red: random samples of Besancon stars with I-mag distribution or RAVE stars, blue: RAVE stars'
      endelse
      printf,luni,str_print
    endfor
    printf,luni,'</center>'
    if keyword_set(I_STR_PIXELMAP) then begin
      strarr_pixelmap_lines = readfilelinestoarr(i_str_pixelmap,STR_DONT_READ='#')
      for i=0ul, n_elements(strarr_pixelmap_lines)-1 do begin
        printf,luni,strarr_pixelmap_lines(i)
      endfor
    endif
    printf,luni,'</body>'
    printf,luni,'</html>'
  free_lun,luni
  if b_plot_contours then begin
    rave_plot_fields_mean_contours,I_STR_PATH=str_path,$
                                   I_B_SIGMA = 0,$
                                   I_B_NEW_FIELDSFILE = 1
    rave_plot_fields_mean_contours,I_STR_PATH=str_path,$
                                   I_B_SIGMA = 1,$
                                   I_B_NEW_FIELDSFILE = 1
  endif
;  xtitle=0
;  ytitle=0
  subpath=0
  strarr_fields=0
  str_path=0
  str_plotname=0
  str_gifplotname=0
  str_gifplotdir=0
  str_print=0
  str_ravefile=0
  str_besanconfile=0
  str_i_nstars_file=0
;  end
end
