pro get_mean_sig_running, I_INT_NBINS = i_int_nbins,$
                          I_DBLARR_DATA_X  = i_dblarr_data_x,$
                          I_DBLARR_DATA_Y  = i_dblarr_data_y,$
                          I_DBLARR_XRANGE  = i_dblarr_xrange,$
                          I_DBL_SIGMA_CLIP = i_dbl_sigma_clip,$
                          O_DBLARR_X_BIN = o_dblarr_x_bin,$
                          O_DBLARR_LIMITS_X_BIN = o_dblarr_limits_x_bin,$
                          O_DBLARR_NELEMENTS_X_BIN = o_dblarr_nelements_x_bin,$
                          IO_INDARR_CLIPPED = io_indarr_clipped,$
                          O_DBLARR_MEAN = o_dblarr_mean,$
                          O_DBLARR_SIGMA = o_dblarr_sigma,$
                          I_B_DIFF_ONLY = i_b_diff_only,$
                          I_DBLARR_ERR_Y = i_dblarr_err_y,$
                          I_B_USE_WEIGHTED_MEAN = i_b_use_weighted_mean,$
                          I_INT_SIGMA_I_MINELEMENTS = i_int_sigma_i_minelements
  print,'get_mean_sig_running: i_dblarr_data_y = ',i_dblarr_data_y

  o_dblarr_limits_x_bin = dblarr(i_int_nbins+1)
  o_dblarr_x_bin = dblarr(i_int_nbins)
  o_dblarr_nelements_x_bin = dblarr(i_int_nbins)
  o_dblarr_mean = dblarr(i_int_nbins)
  o_dblarr_sigma = dblarr(i_int_nbins)
  o_dblarr_limits_x_bin(0) = i_dblarr_xrange(0)

  indarr_not_clipped = lindgen(n_elements(i_dblarr_data_x))
  if keyword_set(IO_INDARR_CLIPPED) then begin
    if io_indarr_clipped(0) ge 0 then begin
      int_nclipped = n_elements(io_indarr_clipped)
      remove_subarr_from_array,indarr_not_clipped,io_indarr_clipped
      io_indarr_clipped = [io_indarr_clipped,lonarr(n_elements(i_dblarr_data_x))]
    end else begin
      int_nclipped = 0ul
      io_indarr_clipped = lonarr(n_elements(i_dblarr_data_x))
    endelse
  end else begin
    int_nclipped = 0ul
    io_indarr_clipped = lonarr(n_elements(i_dblarr_data_x))
  endelse
  for j=1,i_int_nbins do begin
    o_dblarr_limits_x_bin(j) = o_dblarr_limits_x_bin(j-1) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) / i_int_nbins
    o_dblarr_x_bin(j-1) = o_dblarr_limits_x_bin(j-1) + ((o_dblarr_limits_x_bin(j) - o_dblarr_limits_x_bin(j-1)) / 2.)
    indarr = where(i_dblarr_data_x(indarr_not_clipped) gt o_dblarr_limits_x_bin(j-1) and i_dblarr_data_x(indarr_not_clipped) le o_dblarr_limits_x_bin(j))
;    if indarr(0) lt 0 then begin
;      o_dblarr_nelements_x_bin(j-1) = 0
;    end else begin
;    endelse
    if indarr(0) ge 0 then begin;n_elements(indarr) ge i_int_sigma_i_minelements then begin
      o_dblarr_nelements_x_bin(j-1) = n_elements(indarr)
      indarr_clip = [0]
;      indarr_good = lindgen(n_elements(indarr))
      i_run = 0
      while (indarr_clip(0) ge 0) and (n_elements(indarr) ge i_int_sigma_i_minelements) and (i_run lt 1) do begin
        print,'get_mean_sig_running: bin ',j,': i_dblarr_data_y(indarr) = ',i_dblarr_data_y(indarr_not_clipped(indarr))
        if keyword_set(I_B_DIFF_ONLY) then begin
          dblarr_y_plot = i_dblarr_data_y(indarr_not_clipped(indarr))
        end else begin
          if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
            dblarr_y_plot = i_dblarr_data_y(indarr_not_clipped(indarr)) - i_dblarr_data_x(indarr_not_clipped(indarr))
          end else begin
            dblarr_y_plot = i_dblarr_data_x(indarr_not_clipped(indarr)) - i_dblarr_data_y(indarr_not_clipped(indarr))
          end
        endelse
        print,'get_mean_sig_running: bin ',j,': dblarr_y_plot = ',dblarr_y_plot
        dblarr_moment = moment(dblarr_y_plot,/NAN)
        if keyword_set(I_DBLARR_ERR_Y) and keyword_set(I_B_USE_WEIGHTED_MEAN) then begin
          dbl_sigma = 1
          o_dblarr_mean(j-1) = wmean(dblarr_y_plot,i_dblarr_err_y(indarr_not_clipped(indarr)),error=dbl_sigma);dblarr_moment(0)
          o_dblarr_sigma(j-1) = dbl_sigma
;          print,'o_dblarr_mean(j-1) = ',o_dblarr_mean(j-1)
;          print,'dbl_sigma = ',dbl_sigma
        end else begin
          o_dblarr_mean(j-1) = dblarr_moment(0)
          o_dblarr_sigma(j-1) = sqrt(dblarr_moment(1))
;          if o_dblarr_sigma(j-1) gt 3000. then stop
        endelse
        indarr_clip = where(abs(dblarr_y_plot - o_dblarr_mean(j-1)) gt i_dbl_sigma_clip * o_dblarr_sigma(j-1),COMPLEMENT=indarr_good)
        if indarr_clip(0) ge 0 then begin
          io_indarr_clipped(int_nclipped:int_nclipped+n_elements(indarr_clip)-1) = indarr_not_clipped(indarr(indarr_clip))
          int_nclipped = int_nclipped + n_elements(indarr_clip)
        endif

;        print,'compare_two_parameters: j=',j,': o_dblarr_x_bin(j) = ',o_dblarr_x_bin(j-1)
;        print,'compare_two_parameters: j=',j,': o_dblarr_mean(j) = ',o_dblarr_mean(j-1)
;        print,'compare_two_parameters: j=',j,': o_dblarr_sigma(j) = ',o_dblarr_sigma(j-1)
        print,' '
        if indarr_good(0) ge 0 then begin
          indarr = indarr(indarr_good)
        end else begin
          indarr = [-1]
        endelse
        if n_elements(indarr) ge 2 then begin
          i_run = i_run + 1
          if keyword_set(I_DO_SIGMA_CLIPPING) then begin
            if keyword_set(I_B_DIFF_ONLY) then begin
              dblarr_y_plot = i_dblarr_data_y(indarr_not_clipped(indarr))
            end else begin
              if keyword_set(I_B_DIFF_PLOT_Y_MINUS_X) then begin
                dblarr_y_plot = i_dblarr_data_y(indarr_not_clipped(indarr)) - i_dblarr_data_x(indarr_not_clipped(indarr))
              end else begin
                dblarr_y_plot = i_dblarr_data_x(indarr_not_clipped(indarr)) - i_dblarr_data_y(indarr_not_clipped(indarr))
              end
            endelse
            dblarr_moment = moment(dblarr_y_plot,/NAN)
            if keyword_set(I_DBLARR_ERR_Y) and keyword_set(I_B_USE_WEIGHTED_MEAN) then begin
              dbl_sigma = 1
              o_dblarr_mean(j-1) = wmean(dblarr_y_plot,i_dblarr_err_y(indarr_not_clipped(indarr)),error=dbl_sigma);dblarr_moment(0)
              o_dblarr_sigma(j-1) = dbl_sigma
;              print,'o_dblarr_mean(j-1) = ',o_dblarr_mean(j-1)
;              print,'dbl_sigma = ',dbl_sigma
            end else begin
              print,'get_mean_sig_running: bin ',j,': dblarr_moment = ',dblarr_moment
              o_dblarr_mean(j-1) = dblarr_moment(0)
              o_dblarr_sigma(j-1) = sqrt(dblarr_moment(1))
              if o_dblarr_sigma(j-1) gt 3000. then stop
            endelse
          end else begin
            i_run = 100
          endelse
        end else begin
          o_dblarr_mean(j-1) = dblarr_y_plot(0)
          o_dblarr_sigma(j-1) = 0.
        endelse
      endwhile
;    end else begin
;      o_dblarr_mean(j-1) = 999.99
;      o_dblarr_sigma(j-1) = 999.99
    end
;    if abs(o_dblarr_mean(j-1) + o_dblarr_sigma(j-1)) gt i_dblarr_xrange(1) or abs(o_dblarr_mean(j-1) - o_dblarr_sigma(j-1)) gt i_dblarr_xrange(1) then begin
;      if indarr(0) ge 0 then begin
;        print,'compare_two_parameters: i_dblarr_data_x(indarr) = ',i_dblarr_data_x(indarr)
;        print,'compare_two_parameters: i_dblarr_data_y(indarr) = ',i_dblarr_data_y(indarr)
;        print,'compare_two_parameters: i_dblarr_data_x(indarr) - i_dblarr_data_y(indarr) = ',i_dblarr_data_x(indarr) - i_dblarr_data_y(indarr)
;      endif
;    endif
  endfor
  if int_nclipped gt 0 then begin
    io_indarr_clipped = io_indarr_clipped(0:int_nclipped-1)
  end else begin
    io_indarr_clipped = [-1]
  endelse

  print,'get_mean_sig_running: o_dblarr_mean = ',o_dblarr_mean

end
