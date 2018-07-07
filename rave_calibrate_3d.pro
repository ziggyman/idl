pro rave_calibrate_3d, I_DBLARR_Z_REF           = i_dblarr_z_ref,$
                       I_DBLARR_X_RAVE          = i_dblarr_x_rave,$
                       I_DBLARR_Y_RAVE          = i_dblarr_y_rave,$
                       IO_DBLARR_Z_RAVE         = io_dblarr_z_rave,$
                       I_DBLARR_X_ALL           = i_dblarr_x_all,$
                       I_DBLARR_Y_ALL           = i_dblarr_y_all,$
                       IO_DBLARR_Z_ALL          = io_dblarr_z_all,$
                       I_DBLARR_Z_BES           = i_dblarr_z_bes,$
                       I_INTARR_AGE_BES         = i_intarr_age_bes,$
                       I_STR_XTITLE             = i_str_xtitle,$
                       I_STR_YTITLE             = i_str_ytitle,$
                       I_STR_ZTITLE             = i_str_ztitle,$
                       I_STR_TITLE_X            = i_str_title_x,$
                       I_STR_TITLE_Y            = i_str_title_y,$
                       I_STR_TITLE_Z            = i_str_title_z,$
                       I_STR_HIST_XTITLE        = i_str_hist_xtitle,$
                       I_DBLARR_XRANGE          = i_dblarr_xrange,$
                       I_DBLARR_YRANGE          = i_dblarr_yrange,$
                       I_DBLARR_ZRANGE          = i_dblarr_zrange,$
                       I_STR_PLOTNAME_ROOT      = i_str_plotname_root,$
                       I_STR_PLOTNAME_HIST_ROOT = i_str_plotname_hist_root,$
                       I_DBL_REJECTVALUE_Z_REF  = i_dbl_rejectvalue_z_ref,$
                       I_DBLARR_GRID_SPACE      = i_dblarr_grid_space,$
                       I_INT_SIGMA_MINELEMENTS  = i_int_sigma_minelements

  if not keyword_set(I_DBLARR_X_ALL) then begin
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
    dblarr_x_rave_all = double(strarr_data_rave(*,int_col_teff_rave_all))
    dblarr_y_rave_all = double(strarr_data_rave(*,int_col_logg_rave_all))
    dblarr_z_rave_all = double(strarr_data_rave(*,int_col_mh_rave_all))
    dblarr_afe_rave_all = double(strarr_data_rave(*,int_col_afe_rave_all))
  end else begin
    dblarr_x_rave_all = i_dblarr_x_all
    dblarr_y_rave_all = i_dblarr_y_all
    dblarr_z_rave_all = io_dblarr_z_all
  endelse

  if not keyword_set(I_DBLARR_X_RAVE) then begin
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

    dblarr_x_rave = double(strarr_data(*,int_col_teff_rave))
    dblarr_y_rave = double(strarr_data(*,int_col_logg_rave))
    dblarr_z_rave = double(strarr_data(*,int_col_mh_rave))
;    dblarr_afe_rave = double(strarr_data(*,int_col_afe_rave))
  end else begin
    dblarr_x_rave = i_dblarr_x_rave
    dblarr_y_rave = i_dblarr_y_rave
    dblarr_z_rave = io_dblarr_z_rave
    print,'i_dblarr_x_rave = ',i_dblarr_x_rave

    dblarr_z_ref = i_dblarr_z_ref
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

  dblarr_x = dblarr_x_rave(indarr)
  dblarr_y = dblarr_y_rave(indarr)
  dblarr_z = dblarr_z_ref(indarr) - dblarr_z_rave(indarr)

  print,'dblarr_x = ',dblarr_x
  print,'dblarr_y = ',dblarr_y
  print,'dblarr_z = ',dblarr_z
;  if i_str_title_z eq 'dlogg' then $
;    stop

  set_plot,'ps'
  if keyword_set(I_STR_PLOTNAME_ROOT) then begin
    str_plotname_root = i_str_plotname_root
  end else begin
    str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_Teff-logg'
  endelse

  if keyword_set(I_STR_XTITLE) then begin
    str_xtitle = i_str_xtitle
  end else begin
    str_xtitle = 'T!Deff!N [K]'
  endelse

  if keyword_set(I_STR_XTITLE) then begin
    str_ytitle = i_str_ytitle
  end else begin
    str_ytitle = 'log g [dex]'
  endelse

  if keyword_set(I_STR_XTITLE) then begin
    str_ztitle = i_str_ztitle
  end else begin
    str_ztitle = 'd([M/H]) [dex]'
  endelse

  device,filename = str_plotname_root+'.ps'
    plot_3dbox,dblarr_x,$
               dblarr_y,$
               dblarr_z,$
               psym=2,$
               /XY_PLANE,$
;               /XZ_PLANE,$
               /YZ_PLANE,$
               xtitle = str_xtitle,$
               ytitle = str_ytitle,$
               ztitle = str_ztitle
  device,/close
;  Triangulate, dblarr_x, dblarr_y, triangles, boundaryPts
;;
  if keyword_set(I_DBLARR_GRID_SPACE) then begin
    gridSpace = i_dblarr_grid_space
  end else begin
    gridSpace = [300., 0.15]
  endelse
;  griddedData = TriGrid(dblarr_x, dblarr_y, dblarr_z, triangles, gridSpace, $
;                        XGrid=xvector, YGrid=yvector);), MIN_VALUE=-1.5,MAX_VALUE=1.6);, Extrapolate=boundaryPts, /Quintic
;
;  print,'size(griddedData) = ',size(griddedData)
;  print,'griddedData = ',griddedData

;  dblarr_smoothed = smooth(griddedData,3)

  print,'rave_calibrate_3d: dblarr_x(0:10) = ',dblarr_x(0:10)
  print,'rave_calibrate_3d: dblarr_y(0:10) = ',dblarr_y(0:10)
  print,'rave_calibrate_3d: dblarr_z(0:10) = ',dblarr_z(0:10)
;  stop

  get_smoothed_surface, I_DBLARR_X = dblarr_x,$
                        I_DBLARR_Y = dblarr_y,$
                        I_DBLARR_Z = dblarr_z,$
                        I_INT_NBINS_X = 10,$
                        I_INT_NBINS_Y = 10,$
                        I_DBLARR_RANGE_X = i_dblarr_xrange,$
                        I_DBLARR_RANGE_Y = i_dblarr_yrange,$
                        I_DBLARR_RANGE_Z = i_dblarr_zrange,$
                        I_STR_XTITLE     = i_str_xtitle,$
                        I_STR_YTITLE     = i_str_ytitle,$
                        I_STR_ZTITLE     = i_str_ztitle,$
                        I_STR_TITLE_X     = i_str_title_x,$
                        I_STR_TITLE_Y     = i_str_title_y,$
                        I_STR_TITLE_Z     = i_str_title_z,$
                        O_DBLARR_X_GRID = xvector,$
                        O_DBLARR_Y_GRID = yvector,$
                        O_DBLARR_Z = dblarr_smoothed,$
                          I_INT_SIGMA_MINELEMENTS = i_int_sigma_minelements

  gridSpace = [xvector(1)-xvector(0),yvector(1)-yvector(0)]

  print,'size(dblarr_smoothed) = ',size(dblarr_smoothed)
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
  set_plot,'x'
  cgSURFACE, dblarr_smoothed,$
              xvector,$
              yvector,$
;              charsize    = 2.5,$
;              thick       = 3.,$
;              xtickformat = '(I6)',$
              xtitle      = str_xtitle,$
              ytitle      = str_ytitle,$
              ztitle      = str_ztitle

              ;AZ = 015
;  device,/close
;  set_plot,'x'

  print,'size(dblarr_smoothed) = ',size(dblarr_smoothed)
  print,'dblarr_smoothed = ',dblarr_smoothed

  ; --- calculate step sizes
  dbl_dteff = xvector(1) - xvector(0)
  dbl_dlogg = yvector(1) - yvector(0)

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
    dbl_x = dblarr_x_rave(indarr(i))
    dbl_y = dblarr_y_rave(indarr(i))
    dbl_z = dblarr_z_rave(indarr(i))

    print,'dbl_z = ',dbl_z

    rave_interpolate_3d, I_DBL_X                   = dbl_x,$
                         I_DBL_Y                   = dbl_y,$
                         IO_DBL_Z                  = dbl_z,$
                         I_DBLVEC_X                = xvector,$
                         I_DBLVEC_Y                = yvector,$
                         I_DBLARR_SMOOTHED_SURFACE = dblarr_smoothed

    print,'dbl_z = ',dbl_z
    dblarr_z_rave(indarr(i)) = dbl_z
    print,'dblarr_z_rave(indarr(i=',i,')=',indarr(i),') = ',dblarr_z_rave(indarr(i))
;    if i eq 100 then stop
  endfor


  ; --- calibrate all RAVE data
  for i=0ul, n_elements(dblarr_x_rave_all)-1 do begin
    dbl_x = dblarr_x_rave_all(i)
    dbl_y = dblarr_y_rave_all(i)
    dbl_z = dblarr_z_calib(i)

    rave_interpolate_3d, I_DBL_X                   = dbl_x,$
                         I_DBL_Y                   = dbl_y,$
                         IO_DBL_Z                  = dbl_z,$
                         I_DBLVEC_X                = xvector,$
                         I_DBLVEC_Y                = yvector,$
                         I_DBLARR_SMOOTHED_SURFACE = dblarr_smoothed

;    indarr_teff = where(abs(dblarr_x_rave_all(i) - xvector) le dbl_dteff)
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
  if keyword_set(IO_DBLARR_Z_RAVE) then $
    io_dblarr_z_rave(indarr) = dblarr_z_rave(indarr)
  if keyword_set(IO_DBLARR_Z_ALL) then $
    io_dblarr_z_all = dblarr_z_calib
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
  dblarr_smoothed = 0
end
