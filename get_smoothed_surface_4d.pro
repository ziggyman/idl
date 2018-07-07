pro get_smoothed_surface_4d, R_I_DBLARR_W = r_i_dblarr_w,$
                             R_I_DBLARR_X = r_i_dblarr_x,$
                             R_I_DBLARR_Y = r_i_dblarr_y,$
                             R_I_DBLARR_Z = r_i_dblarr_z,$
                             R_I_DBLARR_RANGE_W = r_i_dblarr_range_w,$
                             R_I_DBLARR_RANGE_X = r_i_dblarr_range_x,$
                             R_I_DBLARR_RANGE_Y = r_i_dblarr_range_y,$
                             R_I_DBLARR_RANGE_Z = r_i_dblarr_zrange,$
                             O_O_INDARR_CLIPPED = o_o_indarr_clipped,$
                             R_I_INT_NBINS_W    = r_i_int_nbins_w,$
                             R_I_INT_NBINS_X    = r_i_int_nbins_x,$
                             R_I_INT_NBINS_Y    = r_i_int_nbins_y,$
                             ;R_I_INT_NBINS_Z    = r_i_int_nbins_z,$
                             R_I_STR_WTITLE     = r_i_str_wtitle,$
                             R_I_STR_XTITLE     = r_i_str_xtitle,$
                             R_I_STR_YTITLE     = r_i_str_ytitle,$
                             R_I_STR_ZTITLE     = r_i_str_ztitle,$
                             R_I_STR_TITLE_W    = r_i_str_title_w,$
                             R_I_STR_TITLE_X    = r_i_str_title_x,$
                             R_I_STR_TITLE_Y    = r_i_str_title_y,$
                             R_I_STR_TITLE_Z    = r_i_str_title_z,$
                             R_O_DBLARR_SMOOTHED_SURFACE = r_o_dblarr_smoothed_surface,$
                             O_I_INT_SIGMA_MIN_ELEMENTS  = o_i_int_sigma_min_elements; set to 5 if not specified

  if keyword_set(O_I_INT_SIGMA_MIN_ELEMENTS) then begin
    int_sigma_min_elements = o_i_int_sigma_min_elements
  end else begin
    int_sigma_min_elements = 5
  endelse

  dbl_dw = (r_i_dblarr_range_w(1) - r_i_dblarr_range_w(0)) / r_i_int_nbins_w
  dbl_dx = (r_i_dblarr_range_x(1) - r_i_dblarr_range_x(0)) / r_i_int_nbins_x
  dbl_dy = (r_i_dblarr_range_y(1) - r_i_dblarr_range_y(0)) / r_i_int_nbins_y

  dbl_w = r_i_dblarr_range_w(0) - (dbl_dw / 2.)
  dbl_x = r_i_dblarr_range_x(0) - (dbl_dx / 2.)
  dbl_y = r_i_dblarr_range_y(0) - (dbl_dy / 2.)

  dblarr_w_grid = dblarr(r_i_int_nbins_w)
  dblarr_x_grid = dblarr(r_i_int_nbins_x)
  dblarr_y_grid = dblarr(r_i_int_nbins_y)

  dblarr_smoothed_surface = dblarr(r_i_int_nbins_w, r_i_int_nbins_x, r_i_int_nbins_y, 6)

  indarr_clipped = [-1]

  b_do_run = 1
  int_run = 0
  while b_do_run do begin
    int_run += 1
    indarr_not_clipped = lindgen(n_elements(r_i_dblarr_x))
    if indarr_clipped(0) ge 0 then begin
      remove_subarr_from_array,indarr_not_clipped,indarr_clipped
    endif
    for i = 0, 5 do begin
      dblarr_z = r_i_dblarr_z(indarr_not_clipped)
      str_ztitle = r_i_str_ztitle
      str_title_z = r_i_str_title_z
      if i eq 0 then begin
        dblarr_w = r_i_dblarr_w(indarr_not_clipped)
        dblarr_x = r_i_dblarr_x(indarr_not_clipped)
        dblarr_y = r_i_dblarr_y(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_w
        int_nbins_x = r_i_int_nbins_x
        int_nbins_y = r_i_int_nbins_y
        dblarr_wrange = r_i_dblarr_range_w
        dblarr_xrange = r_i_dblarr_range_x
        dblarr_yrange = r_i_dblarr_range_y
        dbl_w_i = dbl_w
        dbl_dw_i = dbl_dw
        str_wtitle = r_i_str_wtitle
        str_xtitle = r_i_str_xtitle
        str_ytitle = r_i_str_ytitle
        str_title_w = r_i_str_title_w
        str_title_x = r_i_str_title_x
        str_title_y = r_i_str_title_y
      end else if i eq 1 then begin
        dblarr_w = r_i_dblarr_w(indarr_not_clipped)
        dblarr_x = r_i_dblarr_y(indarr_not_clipped)
        dblarr_y = r_i_dblarr_x(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_w
        int_nbins_x = r_i_int_nbins_y
        int_nbins_y = r_i_int_nbins_x
        dblarr_wrange = r_i_dblarr_range_w
        dblarr_xrange = r_i_dblarr_range_y
        dblarr_yrange = r_i_dblarr_range_x
        dbl_w_i = dbl_w
        str_xtitle = r_i_str_ytitle
        str_ytitle = r_i_str_xtitle
        str_title_x = r_i_str_title_y
        str_title_y = r_i_str_title_x
      end else if i eq 2 then begin
        dblarr_w = r_i_dblarr_x(indarr_not_clipped)
        dblarr_x = r_i_dblarr_w(indarr_not_clipped)
        dblarr_y = r_i_dblarr_y(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_x
        int_nbins_x = r_i_int_nbins_w
        int_nbins_y = r_i_int_nbins_y
        dblarr_wrange = r_i_dblarr_range_x
        dblarr_xrange = r_i_dblarr_range_w
        dblarr_yrange = r_i_dblarr_range_y
        dbl_w_i = dbl_x
        dbl_dw_i = dbl_dx
        str_wtitle = r_i_str_xtitle
        str_xtitle = r_i_str_wtitle
        str_ytitle = r_i_str_ytitle
        str_title_w = r_i_str_title_x
        str_title_x = r_i_str_title_w
        str_title_y = r_i_str_title_y
      end else if i eq 3 then begin
        dblarr_w = r_i_dblarr_x(indarr_not_clipped)
        dblarr_x = r_i_dblarr_y(indarr_not_clipped)
        dblarr_y = r_i_dblarr_w(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_x
        int_nbins_x = r_i_int_nbins_y
        int_nbins_y = r_i_int_nbins_w
        dblarr_wrange = r_i_dblarr_range_x
        dblarr_xrange = r_i_dblarr_range_y
        dblarr_yrange = r_i_dblarr_range_w
        dbl_w_i = dbl_x
        str_xtitle = r_i_str_ytitle
        str_ytitle = r_i_str_wtitle
        str_title_x = r_i_str_title_y
        str_title_y = r_i_str_title_w
      end else if i eq 4 then begin
        dblarr_w = r_i_dblarr_y(indarr_not_clipped)
        dblarr_x = r_i_dblarr_x(indarr_not_clipped)
        dblarr_y = r_i_dblarr_w(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_y
        int_nbins_x = r_i_int_nbins_x
        int_nbins_y = r_i_int_nbins_w
        dblarr_wrange = r_i_dblarr_range_y
        dblarr_xrange = r_i_dblarr_range_x
        dblarr_yrange = r_i_dblarr_range_w
        dbl_w_i = dbl_y
        dbl_dw_i = dbl_dy
        str_wtitle = r_i_str_ytitle
        str_xtitle = r_i_str_xtitle
        str_ytitle = r_i_str_wtitle
        str_title_w = r_i_str_title_y
        str_title_x = r_i_str_title_x
        str_title_y = r_i_str_title_w
      end else if i eq 5 then begin
        dblarr_w = r_i_dblarr_y(indarr_not_clipped)
        dblarr_x = r_i_dblarr_w(indarr_not_clipped)
        dblarr_y = r_i_dblarr_x(indarr_not_clipped)
        int_nbins_w = r_i_int_nbins_y
        int_nbins_x = r_i_int_nbins_w
        int_nbins_y = r_i_int_nbins_x
        dblarr_wrange = r_i_dblarr_range_y
        dblarr_xrange = r_i_dblarr_range_w
        dblarr_yrange = r_i_dblarr_range_x
        dbl_w_i = dbl_y
        str_xtitle = r_i_str_wtitle
        str_ytitle = r_i_str_xtitle
        str_title_x = r_i_str_title_w
        str_title_y = r_i_str_title_x
      endif
      for i_w = 0, r_i_int_nbins_w - 1 do begin
        dbl_w_i += dbl_dw_i
        indarr_w = where(abs(r_i_dblarr_w(indarr_not_clipped) - dbl_w_i) le dbl_dw_i / 2.)
        if i lt 2 then begin
          dblarr_w_grid(i_w) = dbl_w_i
        end else if i lt 4 then begin
          dblarr_x_grid(i_w) = dbl_w_i
        end else if i lt 6 then begin
          dblarr_y_grid(i_w) = dbl_w_i
        endif
        if indarr_w(0) ge 0 then begin
          o_indarr_clipped = [-1]
          dblarr_w_interval_w = dblarr_w(indarr_not_clipped(indarr_w))
          dblarr_x_interval_w = dblarr_x(indarr_not_clipped(indarr_w))
          dblarr_y_interval_w = dblarr_y(indarr_not_clipped(indarr_w))
          dblarr_z_interval_w = dblarr_z(indarr_not_clipped(indarr_w))
          get_smoothed_surface, I_DBLARR_X       = dblarr_x_interval_w,$
                                I_DBLARR_Y       = dblarr_y_interval_w,$
                                I_DBLARR_Z       = dblarr_z_interval_w,$
                                I_INT_NBINS_X    = int_nbins_x,$
                                I_INT_NBINS_Y    = int_nbins_y,$
                                I_DBLARR_RANGE_X = dblarr_xrange,$
                                I_DBLARR_RANGE_Y = dblarr_yrange,$
                                I_DBLARR_RANGE_Z = dblarr_zrange,$
                                I_STR_XTITLE     = str_xtitle,$
                                I_STR_YTITLE     = str_ytitle,$
                                I_STR_ZTITLE     = str_ztitle,$
                                I_STR_TITLE_X     = str_title_x,$
                                I_STR_TITLE_Y     = str_title_y,$
                                I_STR_TITLE_Z     = str_title_z,$
                                O_DBLARR_X_GRID  = dblarr_grid_x,$
                                O_DBLARR_Y_GRID  = dblarr_grid_y,$
                                O_DBLARR_Z       = dblarr_z_out,$
                                IO_INDARR_CLIPPED = o_indarr_clipped,$
                                I_INT_SIGMA_MINELEMENTS = int_sigma_min_elements
          if i eq 0 then begin
            dblarr_smoothed_surface(i_w,*,*,i) = dblarr_z_out
          end else if i eq 1 then begin
            for i_x = 0, int_nbins_x-1 do begin
              dblarr_smoothed_surface(i_w,*,i_x,i) = dblarr_z_out(i_x,*)
            endfor
          end else if i eq 2 then begin
            for i_x = 0, int_nbins_x-1 do begin
              dblarr_smoothed_surface(i_x,i_w,*,i) = dblarr_z_out(i_x,*)
            endfor
          end else if i eq 3 then begin
            for i_x = 0, int_nbins_x-1 do begin
              dblarr_smoothed_surface(*,i_w,i_x,i) = dblarr_z_out(i_x,*)
            endfor
          end else if i eq 4 then begin
            for i_x = 0, int_nbins_x-1 do begin
              dblarr_smoothed_surface(*,i_x,i_w,i) = dblarr_z_out(i_x,*)
            endfor
          end else if i eq 5 then begin
            for i_x = 0, int_nbins_x-1 do begin
              dblarr_smoothed_surface(i_x,*,i_w,i) = dblarr_z_out(i_x,*)
            endfor
          endif
        endif
        print,'get_smoothed_surface_4d: i=',i,', i_w=',i_w,': o_indarr_clipped = ',o_indarr_clipped
      endfor; i_w
      print,'get_smoothed_surface_4d: i=',i,', i_w=',i_w,': o_indarr_clipped = ',o_indarr_clipped
    endfor; i
    if o_indarr_clipped(0) lt 0 then begin
      b_do_run = 0
    end else begin
      if indarr_clipped(0) ge 0 then begin
        indarr_clipped = [indarr_clipped,indarr_not_clipped(o_indarr_clipped)]
      end else begin
        indarr_clipped = o_indarr_clipped
      endelse
    endelse
    print,'get_smoothed_surface_4d: int_run = ',int_run
    if int_run gt 10 then b_do_run = 0
  end
  print,'get_smoothed_surface_4d: indarr_clipped = ',indarr_clipped
  stop
  r_o_dblarr_smoothed_surface = dblarr(r_i_int_nbins_w, r_i_int_nbins_x, r_i_int_nbins_y)
  for i=0, r_i_int_nbins_w-1 do begin
    for j=0, r_i_int_nbins_x-1 do begin
      for k=0, r_i_int_nbins_y-1 do begin
        indarr = where(abs(dblarr_smoothed_surface(i,j,k,*)) ge 0.0000001)
        if indarr(0) ge 0 then begin
          r_o_dblarr_smoothed_surface(i,j,k) = dblarr_smoothed_surface(i,j,k,indarr) / n_elements(indarr)
        endif
      endfor
    endfor
  endfor
  print,'get_smoothed_surface_4d: r_o_dblarr_smoothed_surface = ',r_o_dblarr_smoothed_surface

  print,'get_smoothed_surface_4d: r_o_dblarr_smoothed_surface(0,*,*) = ',r_o_dblarr_smoothed_surface(0,*,*)
  print,'get_smoothed_surface_4d: dblarr_w_grid = ',dblarr_w_grid
  print,'get_smoothed_surface_4d: dblarr_x_grid = ',dblarr_x_grid
  print,'get_smoothed_surface_4d: dblarr_y_grid = ',dblarr_y_grid
  dblarr_plot = dblarr(r_i_int_nbins_x, r_i_int_nbins_y)
  for i=0, r_i_int_nbins_w-1 do begin
    for j=0, r_i_int_nbins_x - 1 do begin
      dblarr_plot(j,*) = r_o_dblarr_smoothed_surface(i,j,*)
    endfor
    print,'get_smoothed_surface_4d: dblarr_plot = ',dblarr_plot
    dblarr_zrange = [min(dblarr_plot), max(dblarr_plot)]
    if max(abs(dblarr_plot)) lt 0.000001 then dblarr_zrange = [-1.,1.]
    cgsurface,dblarr_plot,$
              dblarr_x_grid,$
              dblarr_y_grid,$
              zrange = dblarr_zrange
  endfor
  o_o_indarr_clipped = indarr_clipped
end
