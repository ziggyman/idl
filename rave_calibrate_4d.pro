pro rave_calibrate_4d, I_DBLARR_Z_REF           = i_dblarr_z_ref,$
                       I_DBLARR_W_RAVE_REF      = i_dblarr_w_rave_ref,$
                       I_DBLARR_X_RAVE_REF      = i_dblarr_x_rave_ref,$
                       I_DBLARR_Y_RAVE_REF      = i_dblarr_y_rave_ref,$
                       IO_DBLARR_Z_RAVE_REF     = io_dblarr_z_rave_ref,$
                       I_DBLARR_W_RAVE_ALL      = i_dblarr_w_rave_all,$
                       I_DBLARR_X_RAVE_ALL      = i_dblarr_x_rave_all,$
                       I_DBLARR_Y_RAVE_ALL      = i_dblarr_y_rave_all,$
                       IO_DBLARR_Z_RAVE_ALL     = io_dblarr_z_rave_all,$
                       I_DBLARR_Z_BES           = i_dblarr_z_bes,$
                       I_INTARR_AGE_BES         = i_intarr_age_bes,$
                       I_STR_WTITLE             = i_str_wtitle,$
                       I_STR_XTITLE             = i_str_xtitle,$
                       I_STR_YTITLE             = i_str_ytitle,$
                       I_STR_ZTITLE             = i_str_ztitle,$
                       I_STR_TITLE_W            = i_str_title_w,$
                       I_STR_TITLE_X            = i_str_title_x,$
                       I_STR_TITLE_Y            = i_str_title_y,$
                       I_STR_TITLE_Z            = i_str_title_z,$
                       I_STR_HIST_XTITLE        = i_str_hist_xtitle,$
                       I_DBLARR_WRANGE          = i_dblarr_wrange,$
                       I_DBLARR_XRANGE          = i_dblarr_xrange,$
                       I_DBLARR_YRANGE          = i_dblarr_yrange,$
                       I_DBLARR_ZRANGE          = i_dblarr_zrange,$
                       I_STR_PLOTNAME_ROOT      = i_str_plotname_root,$
                       I_STR_PLOTNAME_HIST_ROOT = i_str_plotname_hist_root,$
                       I_DBL_REJECTVALUE_Z_REF  = i_dbl_rejectvalue_z_ref,$
                       ;I_DBLARR_GRID_SPACE      = i_dblarr_grid_space,$
                       I_INT_SIGMA_MINELEMENTS  = i_int_sigma_minelements,$
                       I_INT_NBINS_W            = i_int_nbins_w,$
                       I_INT_NBINS_X            = i_int_nbins_x,$
                       I_INT_NBINS_Y            = i_int_nbins_y

  if not keyword_set(I_DBLARR_X_RAVE_ALL) then begin
    str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
    strarr_data_rave = readfiletostrarr(str_filename_rave,' ')

    ; --- column numbers rave file
    int_col_teff_rave_all = 19
    int_col_logg_rave_all = 20
    int_col_mh_rave_all   = 21
    int_col_afe_rave_all  = 22
    int_col_s2n_rave_all  = 34
    int_col_stn_rave_all  = 35

    ; --- fill arrays rave file
    dblarr_w_rave_all = double(strarr_data_rave(*,int_col_stn_rave_all))
    dblarr_x_rave_all = double(strarr_data_rave(*,int_col_teff_rave_all))
    dblarr_y_rave_all = double(strarr_data_rave(*,int_col_logg_rave_all))
    dblarr_z_rave_all = double(strarr_data_rave(*,int_col_mh_rave_all))
    dblarr_afe_rave_all = double(strarr_data_rave(*,int_col_afe_rave_all))
  end else begin
    dblarr_w_rave_all = i_dblarr_w_rave_all
    dblarr_x_rave_all = i_dblarr_x_rave_all
    dblarr_y_rave_all = i_dblarr_y_rave_all
    dblarr_z_rave_all = io_dblarr_z_rave_all
  endelse

  if keyword_set(I_INT_SIGMA_MINELEMENTS) then begin
    int_sigma_minelements = i_int_sigma_minelements
  end else begin
    int_sigma_minelements = 3
  endelse

  if not keyword_set(I_DBLARR_X_RAVE_REF) then begin
    str_filename = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'

    strarr_data = readfiletostrarr(str_filename,' ')

    ; --- column numbers external file
    int_col_teff_ref = 4
    int_col_eteff_ref = 5
    int_col_logg_ref = 6
    int_col_elogg_ref = 7
    int_col_mh_ref = 8
    int_col_emh_ref = 9
    int_col_bool_feh_ref = 10
    int_col_afe_ref = 11
    int_col_teff_rave = 13
    int_col_eteff_rave = 14
    int_col_logg_rave = 15
    int_col_elogg_rave = 16
    int_col_mh_rave = 17
    int_col_emh_rave = 18
    int_col_afe_rave = 19
    int_col_stn_rave = 20
    int_col_source_ref = 21

    ; --- fill arrays external file
;    dblarr_x_ref = double(strarr_data(*,int_col_teff_ref))
;    dblarr_y_ref = double(strarr_data(*,int_col_logg_ref))
    dblarr_z_ref = double(strarr_data(*,int_col_mh_ref))

    dblarr_w_rave = double(strarr_data(*,int_col_stn_rave))
    dblarr_x_rave = double(strarr_data(*,int_col_teff_rave))
    dblarr_y_rave = double(strarr_data(*,int_col_logg_rave))
    dblarr_z_rave = double(strarr_data(*,int_col_mh_rave))
;    dblarr_afe_rave = double(strarr_data(*,int_col_afe_rave))
  end else begin
    dblarr_z_ref = i_dblarr_z_ref

    dblarr_w_rave = i_dblarr_w_rave_ref
    dblarr_x_rave = i_dblarr_x_rave_ref
    dblarr_y_rave = i_dblarr_y_rave_ref
    dblarr_z_rave = io_dblarr_z_rave_ref
    print,'i_dblarr_x_rave_ref = ',i_dblarr_x_rave_ref
  endelse
  print,'dblarr_x_rave = ',dblarr_x_rave
;stop
  if (not keyword_set(I_DBLARR_Z_BES)) or (not keyword_set(I_INTARR_AGE_BES)) then begin
    str_filename_besancon = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh_with-errors_height_rcent_errdivby-1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe_samplex1_9ltI2MASSlt12_calib_logg_0.dat'
    strarr_data_besancon = readfiletostrarr(str_filename_besancon,' ')
    int_col_teff_bes = 5
    int_col_logg_bes = 6
    int_col_mh_bes = 8
    int_col_age_bes = 11
    dblarr_x_bes = double(strarr_data_besancon(*,int_col_teff_bes))
    dblarr_y_bes = double(strarr_data_besancon(*,int_col_logg_bes))
    dblarr_z_bes = double(strarr_data_besancon(*,int_col_mh_bes))
    intarr_age_bes = long(strarr_data_besancon(*,int_col_age_bes))
    dblarr_data_besancon = 0
  end else begin
    dblarr_z_bes = i_dblarr_z_bes
    intarr_age_bes = i_intarr_age_bes
  endelse

  if not keyword_set(I_DBL_REJECTVALUE_Z_REF) then $
    i_dbl_rejectvalue_z_ref = 0.
  indarr = where(abs(dblarr_z_ref - i_dbl_rejectvalue_z_ref) ge 0.000000001)

  dblarr_w = dblarr_w_rave(indarr)
  dblarr_x = dblarr_x_rave(indarr)
  dblarr_y = dblarr_y_rave(indarr)
  dblarr_z = dblarr_z_ref(indarr) - dblarr_z_rave(indarr)

  print,'dblarr_w = ',dblarr_w
  print,'dblarr_x = ',dblarr_x
  print,'dblarr_y = ',dblarr_y
  print,'dblarr_z = ',dblarr_z
;  if i_str_title_z eq 'dlogg' then $
;    stop

  set_plot,'ps'
  if keyword_set(I_STR_PLOTNAME_ROOT) then begin
    str_plotname_root = i_str_plotname_root
  end else begin
    str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_STN-Teff-logg'
  endelse

  if keyword_set(I_STR_WTITLE) then begin
    str_wtitle = i_str_wtitle
    str_title_w = i_str_title_w
  end else begin
    str_wtitle = 'STN'
    str_title_w = 'STN'
  endelse

  if keyword_set(I_STR_XTITLE) then begin
    str_xtitle = i_str_xtitle
    str_title_x = i_str_title_x
  end else begin
    str_xtitle = 'T!Deff!N [K]'
    str_title_x = 'Teff'
  endelse

  if keyword_set(I_STR_YTITLE) then begin
    str_ytitle = i_str_ytitle
    str_title_y = i_str_title_y
  end else begin
    str_ytitle = 'log g [dex]'
    str_title_y = 'logg'
  endelse

  if keyword_set(I_STR_ZTITLE) then begin
    str_ztitle = i_str_ztitle
    str_title_z = i_str_title_z
  end else begin
    str_ztitle = 'd([M/H]) [dex]'
    str_title_z = 'dMH'
  endelse

;  device,filename = str_plotname_root+'.ps'
;    plot_3dbox,dblarr_x,$
;               dblarr_y,$
;               dblarr_z,$
;               psym=2,$
;               /XY_PLANE,$
;;               /XZ_PLANE,$
;               /YZ_PLANE,$
;               xtitle = str_xtitle,$
;               ytitle = str_ytitle,$
;               ztitle = str_ztitle
;  device,/close
;  Triangulate, dblarr_x, dblarr_y, triangles, boundaryPts
;;
;  if keyword_set(I_DBLARR_GRID_SPACE) then begin
;    gridSpace = i_dblarr_grid_space
;  end else begin
;    gridSpace = [300., 0.15]
;  endelse
;  griddedData = TriGrid(dblarr_x, dblarr_y, dblarr_z, triangles, gridSpace, $
;                        XGrid=xvector, YGrid=yvector);), MIN_VALUE=-1.5,MAX_VALUE=1.6);, Extrapolate=boundaryPts, /Quintic
;;
;  print,'size(griddedData) = ',size(griddedData)
;  print,'griddedData = ',griddedData
;
;  dblarr_smoothed = smooth(griddedData,3)
;
;
;
  if keyword_set(I_DBLARR_WRANGE) then begin
    dblarr_wrange = i_dblarr_wrange
  end else begin
    dblarr_wrange = [0.,200.]
  endelse
  if keyword_set(I_DBLARR_XRANGE) then begin
    dblarr_xrange = i_dblarr_xrange
  end else begin
    dblarr_xrange = [3000.,8000.]
  endelse
  if keyword_set(I_DBLARR_YRANGE) then begin
    dblarr_yrange = i_dblarr_yrange
  end else begin
    dblarr_yrange = [0.,5.5]
  endelse
  if keyword_set(I_DBLARR_ZRANGE) then begin
    dblarr_zrange = i_dblarr_zrange
  end else begin
    dblarr_zrange = [-1.,1.]
  endelse

  if keyword_set(I_INT_NBINS_W) then begin
    int_nbins_w = i_int_nbins_w
  end else begin
    int_nbins_w = 10
  endelse
  if keyword_set(I_INT_NBINS_X) then begin
    int_nbins_x = i_int_nbins_x
  end else begin
    int_nbins_x = 10
  endelse
  if keyword_set(I_INT_NBINS_Y) then begin
    int_nbins_y = i_int_nbins_y
  end else begin
    int_nbins_y = 10
  endelse

  ; --- calculate step sizes
  dbl_dw = (dblarr_wrange(1) - dblarr_wrange(0)) / int_nbins_w
  dbl_dx = (dblarr_xrange(1) - dblarr_xrange(0)) / int_nbins_x
  dbl_dy = (dblarr_yrange(1) - dblarr_yrange(0)) / int_nbins_y

  dbl_w = dblarr_wrange(0) - dbl_dw
  dbl_x = dblarr_xrange(0) - dbl_dx
  dbl_y = dblarr_yrange(0) - dbl_dy

  ; --- create vectors for w, x, y
  wvector = dblarr(int_nbins_w)
  xvector = dblarr(int_nbins_x)
  yvector = dblarr(int_nbins_y)

  for i=0, int_nbins_w-1 do begin
    dbl_w += dbl_dw
    wvector(i) = dbl_w
  endfor
  for i=0, int_nbins_x-1 do begin
    dbl_x += dbl_dx
    xvector(i) = dbl_x
  endfor
  for i=0, int_nbins_y-1 do begin
    dbl_y += dbl_dy
    yvector(i) = dbl_y
  endfor

  get_smoothed_surface_4d, R_I_DBLARR_W = dblarr_w,$
                           R_I_DBLARR_X = dblarr_x,$
                           R_I_DBLARR_Y = dblarr_y,$
                           R_I_DBLARR_Z = dblarr_z,$
                           R_I_DBLARR_RANGE_W = dblarr_wrange,$
                           R_I_DBLARR_RANGE_X = dblarr_xrange,$
                           R_I_DBLARR_RANGE_Y = dblarr_yrange,$
                           R_I_DBLARR_RANGE_Z = dblarr_zrange,$
                           O_O_INDARR_CLIPPED = o_indarr_clipped,$
                           R_I_INT_NBINS_W    = int_nbins_w,$
                           R_I_INT_NBINS_X    = int_nbins_x,$
                           R_I_INT_NBINS_Y    = int_nbins_y,$
                           R_I_STR_WTITLE     = str_wtitle,$
                           R_I_STR_XTITLE     = str_xtitle,$
                           R_I_STR_YTITLE     = str_ytitle,$
                           R_I_STR_ZTITLE     = str_ztitle,$
                           R_I_STR_TITLE_W    = str_title_w,$
                           R_I_STR_TITLE_X    = str_title_x,$
                           R_I_STR_TITLE_Y    = str_title_y,$
                           R_I_STR_TITLE_Z    = str_title_z,$
                           R_O_DBLARR_SMOOTHED_SURFACE = o_dblarr_smoothed_surface,$
                           O_I_INT_SIGMA_MIN_ELEMENTS  = int_sigma_minelements; set to 5 if not specified

;  gridSpace = [xvector(1)-xvector(0),yvector(1)-yvector(0)]

  print,'size(o_dblarr_smoothed_surface) = ',size(o_dblarr_smoothed_surface)
  print,'size(dblarr_w) = ',size(dblarr_w)
  print,'size(dblarr_x) = ',size(dblarr_x)
  print,'size(dblarr_y) = ',size(dblarr_y)
  print,'size(xvector) = ',size(xvector)
  print,'size(yvector) = ',size(yvector)

;  xsurface, dblarr_smoothed
           ;griddedData;,$
;          xvector,$
;          yvector,$
;          charsize=2.5,$
;          MIN_VALUE=-1.5,$
;          MAX_VALUE=1.6,$
;          xtitle='T!Deff!N [K]',$
;          ytitle='log g [dex]',$
;          ztitle = 'd([M/H]) [dex]'
;  cgSurf, griddedData, xvector, yvector, XStyle=1, YStyle=1

;  device,filename = str_plotname_root+'.ps'
;  SHADE_SURF, dblarr_smoothed,$
;  set_plot,'x'
;  cgSURFACE, dblarr_smoothed,$
;              xvector,$
;              yvector,$
;;              charsize    = 2.5,$
;;              thick       = 3.,$
;;              xtickformat = '(I6)',$
;              xtitle      = str_xtitle,$
;              ytitle      = str_ytitle,$
;              ztitle      = str_ztitle

              ;AZ = 015
;  device,/close
;  set_plot,'x'

  print,'size(o_dblarr_smoothed_surface) = ',size(o_dblarr_smoothed_surface)
  print,'o_dblarr_smoothed_surface = ',o_dblarr_smoothed_surface

  dblarr_z_calib = dblarr_z_rave_all

  if keyword_set(I_DBLARR_ZRANGE) then begin
    dblarr_xrange = i_dblarr_zrange
  end else begin
    dblarr_xrange = [-2.5,1.]
  endelse

  if keyword_set(I_STR_PLOTNAME_HIST_ROOT) then begin
    str_plotname_root_hist = i_str_plotname_hist_root
  end else begin
    str_plotname_root_hist = str_plotname_root+'_hist'
  endelse

  if keyword_set(I_STR_HIST_XTITLE) then begin
    str_xtitle_hist = i_str_hist_xtitle
  end else begin
    str_xtitle_hist = 'T!Deff!N [K]'
  endelse

  plot_two_histograms,dblarr_z_calib,$; --- RAVE
                      dblarr_z_bes,$; --- BESANCON
                      STR_PLOTNAME_ROOT   = str_plotname_root_hist,$;     --- string
                      XTITLE              = str_xtitle_hist,$;                           --- string
                      YTITLE              = 'Percentage of stars',$;                           --- string
                      I_NBINS             = 50,$;                           --- int
                      ;NBINSMAX            = 30,$;                       --- int
                      ;NBINSMIN            = 50,$;                       --- int
                      ;TITLE=title,$;                             --- string
                      XRANGE              = dblarr_xrange,$;                           --- dblarr
                      ;YRANGE              = dblarr_yrange,$;                           --- dblarr
                      ;MAXNORM=maxnorm,$;                         --- bool (0/1)
                      ;TOTALNORM=totalnorm,$;                     --- bool (0/1)
                      PERCENTAGE          = 1,$;                   --- bool (0/1)
                      ;REJECTVALUEX        = rejectvaluex,$;               --- double
                      B_POP_ID            = 1,$;                     --- bool
                      DBLARR_STAR_TYPES   = intarr_age_bes,$;     --- dblarr
                      PRINTPDF            = 1,$;                       --- bool (0/1)
                      ;DEBUGA=debuga,$;                           --- bool (0/1)
                      ;DEBUGB=debugb,$;                           --- bool (0/1)
                      ;DEBUG_OUTFILES_ROOT = debug_outfiles_root,$; --- string
                      COLOUR              = 1,$;                           --- bool (0/1)
                      ;B_RESIDUAL         = b_residual,$;                 --- double
                      I_DBLARR_POSITION   = [0.205,0.175,0.932,0.925],$; --- dblarr[x1,y1,x2,y2]
                      I_DBL_THICK         = 3.,$;
                      ;I_INT_XTICKS = i_int_xticks,$
                      ;I_STR_XTICKFORMAT = i_str_xtickformat,$
                      I_DBL_CHARSIZE      = 1.8,$
                      I_DBL_CHARTHICK     = 3.,$
                      ;DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                      B_PRINT_MOMENTS     = 1; --- 0: do not print moments


  ; --- calibrate RAVE data
  for i=0ul, n_elements(indarr)-1 do begin
    dbl_w = dblarr_w_rave(indarr(i))
    dbl_x = dblarr_x_rave(indarr(i))
    dbl_y = dblarr_y_rave(indarr(i))
    dbl_z = dblarr_z_rave(indarr(i))

    print,'dbl_z = ',dbl_z

    rave_interpolate_4d, I_DBL_W                   = dbl_w,$
                         I_DBL_X                   = dbl_x,$
                         I_DBL_Y                   = dbl_y,$
                         IO_DBL_Z                  = dbl_z,$
                         I_DBLVEC_W                = wvector,$
                         I_DBLVEC_X                = xvector,$
                         I_DBLVEC_Y                = yvector,$
                         I_DBLARR_SMOOTHED_SURFACE = o_dblarr_smoothed_surface

    print,'dbl_z = ',dbl_z
    dblarr_z_rave(indarr(i)) = dbl_z
    print,'dblarr_z_rave(indarr(i=',i,')=',indarr(i),') = ',dblarr_z_rave(indarr(i))
;    if i eq 100 then stop
  endfor


  ; --- calibrate all RAVE data
  for i=0ul, n_elements(dblarr_x_rave_all)-1 do begin
    dbl_w = dblarr_w_rave_all(i)
    dbl_x = dblarr_x_rave_all(i)
    dbl_y = dblarr_y_rave_all(i)
    dbl_z = dblarr_z_calib(i)

    rave_interpolate_4d, I_DBL_W                   = dbl_w,$
                         I_DBL_X                   = dbl_x,$
                         I_DBL_Y                   = dbl_y,$
                         IO_DBL_Z                  = dbl_z,$
                         I_DBLVEC_W                = wvector,$
                         I_DBLVEC_X                = xvector,$
                         I_DBLVEC_Y                = yvector,$
                         I_DBLARR_SMOOTHED_SURFACE = o_dblarr_smoothed_surface

;    indarr_teff = where(abs(dblarr_x_rave_all(i) - xvector) le dbl_dx)
;    indarr_logg = where(abs(dblarr_y_rave_all(i) - yvector) le dbl_dlogg)
;
;    print,'indarr_teff = ',indarr_teff
;    print,'indarr_logg = ',indarr_logg
;
;    if (indarr_teff(0) ge 0) and (indarr_logg(0) ge 0) then begin
;
;      if n_elements(indarr_teff) lt 2 then begin
;        if indarr_teff(0) eq n_elements(xvector)-1 then begin
;          indarr_teff = [indarr_teff(0) - 1, indarr_teff(0)]
;        end else begin
;          indarr_teff = [indarr_teff(0), indarr_teff(0) + 1]
;        endelse
;      endif
;      if n_elements(indarr_logg) lt 2 then begin
;        if indarr_logg(0) eq n_elements(yvector)-1 then begin
;          indarr_logg = [indarr_logg(0) - 1, indarr_logg(0)]
;        end else begin
;          indarr_logg = [indarr_logg(0), indarr_logg(0) + 1]
;        endelse
;      endif
;
;      ; --- interpolate in Teff
;      dbl_dist_teff_0 = (dblarr_x_rave_all(i) - xvector(indarr_teff(0))) / (xvector(indarr_teff(1)) - xvector(indarr_teff(0)))
;
;      ; --- interpolate in logg
;      dbl_dist_logg_0 = (dblarr_y_rave_all(i) - yvector(indarr_logg(0))) / (yvector(indarr_logg(1)) - yvector(indarr_logg(0)))
;
;      ; --- interpolate [M/H]
;      dbl_dmh = interpolate(dblarr_smoothed, indarr_teff(0) + dbl_dist_teff_0, indarr_logg(0) + dbl_dist_logg_0)
;      print,'dbl_dmh = ',dbl_dmh
;
;      print,'dblarr_z_calib(i=',i,') = ',dblarr_z_calib(i)
;      dblarr_z_calib(i) += dbl_dmh
;    endif
    dblarr_z_calib(i) = dbl_z
    print,'dblarr_z_calib(i=',i,') = ',dblarr_z_calib(i)
;    stop
  endfor

  str_plotname_root_hist = str_plotname_root_hist+'_calib'
  print,'str_plotname_root_hist = <'+str_plotname_root_hist+'>'
;  stop
  plot_two_histograms,dblarr_z_calib,$; --- RAVE
                      dblarr_z_bes,$; --- BESANCON
                      STR_PLOTNAME_ROOT   = str_plotname_root_hist,$;     --- string
                      XTITLE              = str_ztitle,$;                           --- string
                      YTITLE              = 'Percentage of stars',$;                           --- string
                      I_NBINS             = 50,$;                           --- int
                      ;NBINSMAX            = 30,$;                       --- int
                      ;NBINSMIN            = 50,$;                       --- int
                      ;TITLE=title,$;                             --- string
                      XRANGE              = dblarr_xrange,$;                           --- dblarr
                      ;YRANGE              = dblarr_yrange,$;                           --- dblarr
                      ;MAXNORM=maxnorm,$;                         --- bool (0/1)
                      ;TOTALNORM=totalnorm,$;                     --- bool (0/1)
                      PERCENTAGE          = 1,$;                   --- bool (0/1)
                      ;REJECTVALUEX        = rejectvaluex,$;               --- double
                      B_POP_ID            = 1,$;                     --- bool
                      DBLARR_STAR_TYPES   = intarr_age_bes,$;     --- dblarr
                      PRINTPDF            = 1,$;                       --- bool (0/1)
                      ;DEBUGA=debuga,$;                           --- bool (0/1)
                      ;DEBUGB=debugb,$;                           --- bool (0/1)
                      ;DEBUG_OUTFILES_ROOT = debug_outfiles_root,$; --- string
                      COLOUR              = 1,$;                           --- bool (0/1)
                      ;B_RESIDUAL         = b_residual,$;                 --- double
                      I_DBLARR_POSITION   = [0.205,0.175,0.932,0.925],$; --- dblarr[x1,y1,x2,y2]
                      I_DBL_THICK         = 3.,$;
                      ;I_INT_XTICKS = i_int_xticks,$
                      ;I_STR_XTICKFORMAT = i_str_xtickformat,$
                      I_DBL_CHARSIZE      = 1.8,$
                      I_DBL_CHARTHICK     = 3.,$
                      ;DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                      B_PRINT_MOMENTS     = 1; --- 0: do not print moments

;  print,'io_dblarr_z_rave_all(0:100) = ',io_dblarr_z_rave_all(0:100)
  if keyword_set(IO_DBLARR_Z_RAVE_REF) then $
    io_dblarr_z_rave_ref(indarr) = dblarr_z_rave(indarr)
  if keyword_set(IO_DBLARR_Z_RAVE_ALL) then $
    io_dblarr_z_rave_all = dblarr_z_calib
;  print,'io_dblarr_z_rave_all(0:100) = ',io_dblarr_z_rave_all(0:100)
;  stop

  ; --- clean up
  dblarr_z_ref = 0
  dblarr_x_rave = 0
  dblarr_y_rave = 0
  dblarr_z_rave = 0
  dblarr_x_rave_all = 0
  dblarr_y_rave_all = 0
  dblarr_z_rave_all = 0
  xvector = 0
  yvector = 0
  o_dblarr_smoothed_surface = 0

end
