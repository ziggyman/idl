pro get_smoothed_surface, I_DBLARR_X       = i_dblarr_x,$
                          I_DBLARR_Y       = i_dblarr_y,$
                          I_DBLARR_Z       = i_dblarr_z,$
                          I_INT_NBINS_X    = i_int_nbins_x,$
                          I_INT_NBINS_Y    = i_int_nbins_y,$
                          I_DBLARR_RANGE_X = i_dblarr_range_x,$
                          I_DBLARR_RANGE_Y = i_dblarr_range_y,$
                          I_DBLARR_RANGE_Z = i_dblarr_range_z,$
                          I_STR_XTITLE     = i_str_xtitle,$
                          I_STR_YTITLE     = i_str_ytitle,$
                          I_STR_ZTITLE     = i_str_ztitle,$
                          I_STR_TITLE_X     = i_str_title_x,$
                          I_STR_TITLE_Y     = i_str_title_y,$
                          I_STR_TITLE_Z     = i_str_title_z,$
                          O_DBLARR_X_GRID  = o_dblarr_x_grid,$
                          O_DBLARR_Y_GRID  = o_dblarr_y_grid,$
                          O_DBLARR_Z       = o_dblarr_z,$
                          I_INT_SIGMA_MINELEMENTS = i_int_sigma_minelements,$
                          IO_INDARR_CLIPPED        = io_indarr_clipped



  ; --- TODO: interpolate missing data points between 2 existing ones
  ; ---       all 3d surfaces with log g?


  int_sigma_minelements = 3
  if keyword_set(I_INT_SIGMA_MINELEMENTS) then $
    int_sigma_minelements = i_int_sigma_minelements

  print,'get_smoothed_surface: i_dblarr_x = ',i_dblarr_x
  print,'get_smoothed_surface: i_dblarr_y = ',i_dblarr_y
  print,'get_smoothed_surface: i_dblarr_z = ',i_dblarr_z

  print,'get_smoothed_surface: i_int_nbins_x = ',i_int_nbins_x

  print,'get_smoothed_surface: i_dblarr_range_x = ',i_dblarr_range_x

  dblarr_x_bin = dblarr(i_int_nbins_x)
  dblarr_y_bin = dblarr(i_int_nbins_y)
  o_dblarr_z = dblarr(i_int_nbins_x, i_int_nbins_y)

  dbl_stepsize_x = (i_dblarr_range_x(1) - i_dblarr_range_x(0)) / i_int_nbins_x
  dbl_stepsize_y = (i_dblarr_range_y(1) - i_dblarr_range_y(0)) / i_int_nbins_y
;  dbl_stepsize_z = i_dblarr_zrange(1) = i_dblarr_zrange(0) / i_int_nbins_z

  print,'get_smoothed_surface: dbl_stepsize_x = ',dbl_stepsize_x

  dbl_bin_center_x = i_dblarr_range_x(0) - (dbl_stepsize_x / 2.)
  dbl_bin_center_y = i_dblarr_range_y(0) - (dbl_stepsize_y / 2.)

  dblarr_smoothed_mean_x = dblarr(i_int_nbins_x,i_int_nbins_y)
  dblarr_smoothed_sigma_x = dblarr(i_int_nbins_x,i_int_nbins_y)
  dblarr_smoothed_mean_y = dblarr(i_int_nbins_x,i_int_nbins_y)
  dblarr_smoothed_sigma_y = dblarr(i_int_nbins_x,i_int_nbins_y)
  dblarr_smoothed_x = dblarr(i_int_nbins_x)
  dblarr_smoothed_y = dblarr(i_int_nbins_y)

  str_path = '/home/azuri/daten/rave/calibration/smoothed_surface/'
  spawn,'mkdir '+str_path
  openw,lun,str_path+'index_'+i_str_title_x+'_'+i_str_title_y+'_'+i_str_title_z+'_'+i_str_title_x+'.html',/GET_LUN
  printf,lun,'<html><body><center>'
  for i_x = 0, i_int_nbins_x-1 do begin

    dbl_bin_center_x += dbl_stepsize_x
    dblarr_smoothed_x(i_x) = dbl_bin_center_x
    dbl_bin_x_start = dbl_bin_center_x - (dbl_stepsize_x / 2.)
    dbl_bin_x_end = dbl_bin_center_x + (dbl_stepsize_x / 2.)
    indarr_x = where((i_dblarr_x ge dbl_bin_x_start) and (i_dblarr_x lt dbl_bin_x_end))

    print,'get_smoothed_surface: i_x = ',i_x,': dbl_bin_center_x = ',dbl_bin_center_x
    print,'get_smoothed_surface: i_x = ',i_x,': dbl_bin_x_start = ',dbl_bin_x_start
    print,'get_smoothed_surface: i_x = ',i_x,': dbl_bin_x_end = ',dbl_bin_x_end
    print,'get_smoothed_surface: i_x = ',i_x,': indarr_x = ',indarr_x

    if indarr_x(0) ge 0 then begin
      dblarr_x = i_dblarr_x(indarr_x)
      dblarr_y = i_dblarr_y(indarr_x)
      dblarr_z = i_dblarr_z(indarr_x)

      get_mean_sig_running, I_INT_NBINS = i_int_nbins_y,$
                            I_DBLARR_DATA_X  = dblarr_y,$
                            I_DBLARR_DATA_Y  = dblarr_z,$
                            I_DBLARR_XRANGE  = i_dblarr_range_y,$
                            I_DBL_SIGMA_CLIP = 3.,$
                            I_B_DIFF_ONLY = 1,$
                            ;I_DBLARR_ERR_Y = dblarr_err_y(indarr_plot),$
                            ;I_B_USE_WEIGHTED_MEAN = i_b_use_weighted_mean,$
                            I_INT_SIGMA_I_MINELEMENTS = int_sigma_minelements,$
                            O_DBLARR_X_BIN = dblarr_y_bin,$
                            O_DBLARR_LIMITS_X_BIN = dblarr_limits_y_bins,$
                            O_DBLARR_NELEMENTS_X_BIN = dblarr_y_bin_nelements,$
                            IO_INDARR_CLIPPED = io_indarr_clipped,$
                            O_DBLARR_MEAN = dblarr_mean,$
                            O_DBLARR_SIGMA = dblarr_sigma


      ; --- plot data and smoothed running mean
      set_plot,'ps'
        str_plotname_temp = str_path+i_str_title_z+'_vs_'+i_str_title_y+'_'+i_str_title_x+'='+strtrim(string(dbl_bin_center_x),2)
        device,filename = str_plotname_temp+'.ps',/color
        plot,dblarr_y,$
             dblarr_z,$
             psym=2,$
             title='x='+strtrim(string(dbl_bin_center_x),2),$
             xrange=i_dblarr_range_y
        oplot,dblarr_y_bin,$
              dblarr_mean
        oplot,dblarr_y_bin,$
              dblarr_mean + dblarr_sigma,$
              linestyle=2
        oplot,dblarr_y_bin,$
              dblarr_mean - dblarr_sigma,$
              linestyle=2
        oplot,dblarr_y(io_indarr_clipped),$
              dblarr_z(io_indarr_clipped),$
              psym=4,$
              symsize=2.

      get_mean_smoothed,IO_DBLARR_MEAN = dblarr_mean,$
                        IO_DBLARR_SIGMA = dblarr_sigma,$
                        I_DBLARR_X = dblarr_y,$
                        I_DBLARR_Y = dblarr_z,$
                        I_DBLARR_LIMITS_X_BINS = dblarr_limits_y_bins,$
                        I_SIGMA_I_MINELEMENTS = 3,$
                        I_B_DO_CLIP = 1,$
                        I_DBL_SIGMA_CLIP = 3.,$
                        IO_INDARR_CLIPPED = io_indarr_clipped

      dblarr_smoothed_y = dblarr_y_bin
      dblarr_smoothed_mean_x(i_x,*) = dblarr_mean
      dblarr_smoothed_sigma_x(i_x,*) = dblarr_sigma



      print,'get_smoothed_surface: dblarr_y_bin = ',dblarr_y_bin

      print,'get_smoothed_surface: dblarr_smoothed_mean_x(i_x=',i_x,',*) = ',dblarr_smoothed_mean_x(i_x,*)

        loadct,13
        oplot,dblarr_y_bin,$
              dblarr_mean,$
              color=100
        oplot,dblarr_y_bin,$
              dblarr_mean + dblarr_sigma,$
              linestyle=2,$
              color=100
        oplot,dblarr_y_bin,$
              dblarr_mean - dblarr_sigma,$
              linestyle=2,$
              color=100
        oplot,dblarr_y(io_indarr_clipped),$
              dblarr_z(io_indarr_clipped),$
              psym=4,$
              symsize=2.,$
              color=100

        device,/close
      set_plot,'x'
      spawn,'ps2gif '+str_plotname_temp+'.ps '+str_plotname_temp+'.gif'
      printf,lun,'<a href="'+strmid(str_plotname_temp,strpos(str_plotname_temp,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_temp,strpos(str_plotname_temp,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
    endif
    print,'get_smoothed_surface: i_x = ',i_x
  endfor
  print,'get_smoothed_surface: dblarr_smoothed_mean_x = ',dblarr_smoothed_mean_x
  print,'get_smoothed_surface: dblarr_smoothed_sigma_x = ',dblarr_smoothed_sigma_x

  printf,lun,'</center></body></html>'
  free_lun,lun

;  dblarr_xy = dblarr(i_int_nbins_x,i_int_nbins_y)
;
;  for i_x=0, i_int_nbins_x-1 do begin
;    for i_y-0, i_int_nbins_y-1 do begin
;      dblarr_xy(i_x,i_y) =
;    endfor
;  endfor


;  cgsurface,dblarr_smoothed_mean_x,dblarr_x_bin,dblarr_y_bin

  dblarr_smoothed_mean_bak = dblarr_smoothed_mean_x

  spawn,'mkdir '+str_path
  openw,lun,str_path+'index_'+i_str_title_x+'_'+i_str_title_y+'_'+i_str_title_z+'_'+i_str_title_y+'.html',/GET_LUN
  printf,lun,'<html><body><center>'

  for i_y = 0, i_int_nbins_y-1 do begin

    dbl_bin_center_y += dbl_stepsize_y
    dblarr_smoothed_y(i_y) = dbl_bin_center_y
    dbl_bin_y_start = dbl_bin_center_y - (dbl_stepsize_y / 2.)
    dbl_bin_y_end = dbl_bin_center_y + (dbl_stepsize_y / 2.)
    indarr_y = where((i_dblarr_y ge dbl_bin_y_start) and (i_dblarr_y lt dbl_bin_y_end))

    print,'get_smoothed_surface: i_y = ',i_y,': dbl_bin_center_y = ',dbl_bin_center_y
    print,'get_smoothed_surface: i_y = ',i_y,': dbl_bin_y_start = ',dbl_bin_y_start
    print,'get_smoothed_surface: i_y = ',i_y,': dbl_bin_y_end = ',dbl_bin_y_end
    print,'get_smoothed_surface: i_y = ',i_y,': indarr_y = ',indarr_y

    if indarr_y(0) ge 0 then begin
      dblarr_x = i_dblarr_x(indarr_y)
      dblarr_y = i_dblarr_y(indarr_y)
      dblarr_z = i_dblarr_z(indarr_y)

      print,'get_smoothed_surface: dblarr_z = ',dblarr_z

      get_mean_sig_running, I_INT_NBINS = i_int_nbins_x,$
                            I_DBLARR_DATA_X  = dblarr_x,$
                            I_DBLARR_DATA_Y  = dblarr_z,$
                            I_DBLARR_XRANGE  = i_dblarr_range_x,$
                            I_DBL_SIGMA_CLIP = 3.,$
                            I_B_DIFF_ONLY = 1,$
                            ;I_DBLARR_ERR_Y = dblarr_err_y(indarr_plot),$
                            ;I_B_USE_WEIGHTED_MEAN = i_b_use_weighted_mean,$
                            I_INT_SIGMA_I_MINELEMENTS = 3,$
                            O_DBLARR_X_BIN = dblarr_x_bin,$
                            O_DBLARR_LIMITS_X_BIN = dblarr_limits_x_bins,$
                            O_DBLARR_NELEMENTS_X_BIN = dblarr_x_bin_nelements,$
                            IO_INDARR_CLIPPED = io_indarr_clipped,$
                            O_DBLARR_MEAN = dblarr_mean,$
                            O_DBLARR_SIGMA = dblarr_sigma


      ; --- plot data and smoothed running mean
      set_plot,'ps'
        str_plotname_temp = str_path+i_str_title_z+'_vs_'+i_str_title_x+'_'+i_str_title_y+'='+strtrim(string(dbl_bin_center_y),2)
        device,filename = str_plotname_temp+'.ps',/color
        plot,dblarr_x,$
             dblarr_z,$
             psym=2,$
             title='y='+strtrim(string(dbl_bin_center_y),2),$
             xrange=i_dblarr_range_x
        oplot,dblarr_x_bin,$
              dblarr_mean
        oplot,dblarr_x_bin,$
              dblarr_mean + dblarr_sigma,$
              linestyle=2
        oplot,dblarr_x_bin,$
              dblarr_mean - dblarr_sigma,$
              linestyle=2
        oplot,dblarr_x(io_indarr_clipped),$
              dblarr_z(io_indarr_clipped),$
              psym=4,$
              symsize=2.

      get_mean_smoothed,IO_DBLARR_MEAN = dblarr_mean,$
                        IO_DBLARR_SIGMA = dblarr_sigma,$
                        I_DBLARR_X = dblarr_x,$
                        I_DBLARR_Y = dblarr_z,$
                        I_DBLARR_LIMITS_X_BINS = dblarr_limits_x_bins,$
                        I_SIGMA_I_MINELEMENTS = 3,$
                        I_B_DO_CLIP = 1,$
                        I_DBL_SIGMA_CLIP = 3.,$
                        IO_INDARR_CLIPPED = io_indarr_clipped

      dblarr_smoothed_x = dblarr_x_bin
      dblarr_smoothed_mean_y(*,i_y) = dblarr_mean
      dblarr_smoothed_sigma_y(*,i_y) = dblarr_sigma
      print,'get_smoothed_surface: dblarr_x_bin = ',dblarr_x_bin

      print,'get_smoothed_surface: dblarr_mean = ',dblarr_mean

      print,'get_smoothed_surface: dblarr_smoothed_mean_y(i_y=',i_y,',*) = ',dblarr_smoothed_mean_y(*,i_y)
      ;stop
        loadct,13
        oplot,dblarr_x_bin,$
              dblarr_mean,$
              color=100
        oplot,dblarr_x_bin,$
              dblarr_mean + dblarr_sigma,$
              linestyle=2,$
              color=100
        oplot,dblarr_x_bin,$
              dblarr_mean - dblarr_sigma,$
              linestyle=2,$
              color=100
        oplot,dblarr_x(io_indarr_clipped),$
              dblarr_z(io_indarr_clipped),$
              psym=4,$
              symsize=2.,$
              color=100

        device,/close
      set_plot,'x'
      spawn,'ps2gif '+str_plotname_temp+'.ps '+str_plotname_temp+'.gif'
      printf,lun,'<a href="'+strmid(str_plotname_temp,strpos(str_plotname_temp,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_temp,strpos(str_plotname_temp,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
    endif
    print,'get_smoothed_surface: i_y = ',i_y
  endfor
  print,'get_smoothed_surface: dblarr_smoothed_mean_y = ',dblarr_smoothed_mean_y
  print,'get_smoothed_surface: dblarr_smoothed_sigma_y = ',dblarr_smoothed_sigma_y

  printf,lun,'</center></body></html>'
  free_lun,lun
;  dblarr_xy = dblarr(i_int_nbins_x,i_int_nbins_y)

;  for i_x=0, i_int_nbins_x-1 do begin
;    for i_y-0, i_int_nbins_y-1 do begin
;      dblarr_xy(i_x,i_y) =
;    endfor
;  endfor

;  cgsurface,dblarr_smoothed_mean_y,dblarr_x_bin,dblarr_y_bin
;  cgsurface,dblarr_smoothed_mean_bak - dblarr_smoothed_mean_y,dblarr_x_bin,dblarr_y_bin

  dblarr_smoothed_mean = (dblarr_smoothed_mean_x + dblarr_smoothed_mean_y) / 2.
  dblarr_smoothed_sigma = (dblarr_smoothed_sigma_x + dblarr_smoothed_sigma_y) / 2.

  ; --- replace zero values surrounded by non-zero values by mean of surrounding values
  for i_x=1,i_int_nbins_x-2 do begin
    for i_y=1, i_int_nbins_y-2 do begin
      if abs(dblarr_smoothed_sigma(i_x,i_y)) lt 0.00001 then begin
        if (abs(dblarr_smoothed_sigma(i_x-1, i_y)) gt 0.) and (abs(dblarr_smoothed_sigma(i_x+1, i_y) gt 0.)) then begin
          if (abs(dblarr_smoothed_sigma(i_x, i_y-1)) gt 0.) and (abs(dblarr_smoothed_sigma(i_x, i_y+1) gt 0.)) then begin
            dblarr_smoothed_mean(i_x, i_y) = (dblarr_smoothed_mean(i_x-1, i_y) + dblarr_smoothed_mean(i_x+1, i_y) + dblarr_smoothed_mean(i_x, i_y-1) + dblarr_smoothed_mean(i_x, i_y+1)) / 4.
            print,'get_smoothed_surface: dblarr_smoothed_mean(',i_x,',',i_y,') set to ',dblarr_smoothed_mean(i_x,i_y)
          end else begin
            dblarr_smoothed_mean(i_x, i_y) = (dblarr_smoothed_mean(i_x-1, i_y) + dblarr_smoothed_mean(i_x+1, i_y)) / 2.
            print,'get_smoothed_surface: dblarr_smoothed_mean(',i_x,',',i_y,') set to ',dblarr_smoothed_mean(i_x,i_y)
          endelse
        end else if (abs(dblarr_smoothed_sigma(i_x, i_y-1)) gt 0.) and (abs(dblarr_smoothed_sigma(i_x, i_y+1) gt 0.)) then begin
          dblarr_smoothed_mean(i_x, i_y) = (dblarr_smoothed_mean(i_x, i_y-1) + dblarr_smoothed_mean(i_x, i_y+1)) / 2.
          print,'get_smoothed_surface: dblarr_smoothed_mean(',i_x,',',i_y,') set to ',dblarr_smoothed_mean(i_x,i_y)
        endif
      endif
    endfor
  endfor
;  cgsurface,dblarr_smoothed_mean,$
;            dblarr_x_bin,$
;            dblarr_y_bin,$
;            xtitle = i_str_xtitle,$
;            ytitle = i_str_ytitle,$
;            ztitle = i_str_ztitle

  o_dblarr_x_grid = dblarr_x_bin
  o_dblarr_y_grid = dblarr_y_bin
  o_dblarr_z = dblarr_smoothed_mean

end
