pro get_mean_smoothed,IO_DBLARR_MEAN = io_dblarr_mean,$
                      IO_DBLARR_SIGMA = io_dblarr_sigma,$
                      I_DBLARR_X = i_dblarr_x,$
                      I_DBLARR_Y = i_dblarr_y,$
                      I_DBLARR_LIMITS_X_BINS = i_dblarr_limits_x_bins,$
                      I_SIGMA_I_MINELEMENTS = i_sigma_i_minelements,$
                      I_B_DO_CLIP = i_b_do_clip,$
                      I_DBL_SIGMA_CLIP = i_dbl_sigma_clip,$
                      IO_INDARR_CLIPPED = io_indarr_clipped

  indarr_not_clipped = lindgen(n_elements(i_dblarr_x))
  if keyword_set(IO_INDARR_CLIPPED) then begin
    if io_indarr_clipped(0) ge 0 then begin
      int_nclipped = n_elements(io_indarr_clipped)
      remove_subarr_from_array,indarr_not_clipped,io_indarr_clipped
      io_indarr_clipped = [io_indarr_clipped,lonarr(n_elements(i_dblarr_x))]
    end else begin
      io_indarr_clipped = lonarr(n_elements(i_dblarr_x))
      int_nclipped = 0
    endelse
  end else begin
    io_indarr_clipped = lonarr(n_elements(i_dblarr_x))
    int_nclipped = 0
  endelse
  dblarr_mean_temp = io_dblarr_mean
  dblarr_sigma_temp = io_dblarr_sigma
  intarr_x_bin_nelements = ulonarr(n_elements(io_dblarr_mean))
  for i=0,n_elements(io_dblarr_mean)-1 do begin
    indarr = where(i_dblarr_x(indarr_not_clipped) gt i_dblarr_limits_x_bins(i) and i_dblarr_x(indarr_not_clipped) le i_dblarr_limits_x_bins(i+1))
    if indarr(0) ge 0 then $
      intarr_x_bin_nelements(i) = n_elements(indarr)
  endfor

  indarr_no_data = where(intarr_x_bin_nelements lt i_sigma_i_minelements, COMPLEMENT=indarr_good_data)
  for ii = 0,n_elements(io_dblarr_mean)-1 do begin
    indarr = where(i_dblarr_x(indarr_not_clipped) gt i_dblarr_limits_x_bins(ii) and i_dblarr_x(indarr_not_clipped) le i_dblarr_limits_x_bins(ii+1))
    if n_elements(indarr) ge i_sigma_i_minelements then begin
      if ii eq 0 then begin
        indarr_temp = where(indarr_good_data gt ii)
        if indarr_temp(0) ge 0 then begin
          int_next_good_plus = min(indarr_good_data(indarr_temp))
        end else begin
          int_next_good_plus = -1
        endelse
        int_next_good_minus = 0
        dbl_weight_minus = 0.
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_minus = -1'
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_plus = ',int_next_good_plus
        if (int_next_good_plus ge 0) then begin
          dbl_weight_plus = double(long((int_next_good_plus - ii + 1) / 2))
          dbl_weight = double(int_next_good_plus - ii + 1) - dbl_weight_plus
;          print,'get_mean_smoothed: weights: ',dbl_weight_minus,dbl_weight,dbl_weight_plus
        ;  stop
        end else begin
          dbl_weight_plus = 0.
          dbl_weight = 1.
          int_next_good_plus = 0
        endelse
      end else if ii eq (n_elements(io_dblarr_mean)-1) then begin
        indarr_temp = where(indarr_good_data lt ii)
        if indarr_temp(0) ge 0 then begin
          int_next_good_minus = max(indarr_good_data(indarr_temp))
        end else begin
          int_next_good_minus = -1
        endelse
        int_next_good_plus = 0
        dbl_weight_plus = 0.
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_minus = ',int_next_good_minus
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_plus = -1'
        if (int_next_good_minus ge 0) then begin
          dbl_weight_minus = double(long((ii - int_next_good_minus + 1) / 2))
          dbl_weight = double(ii - int_next_good_minus + 1) - dbl_weight_minus
;          print,'get_mean_smoothed: weights: ',dbl_weight_minus,dbl_weight,dbl_weight_plus
        ;  stop
        end else begin
          dbl_weight_minus = 0.
          dbl_weight = 1.
          int_next_good_minus = 0
        endelse
      end else begin
        indarr_temp = where(indarr_good_data lt ii)
        if indarr_temp(0) ge 0 then begin
          int_next_good_minus = max(indarr_good_data(indarr_temp))
        end else begin
          int_next_good_minus = -1
        endelse
;            int_next_good_minus = max(where(indarr_good_data lt ii))
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_minus = ',int_next_good_minus

        indarr_temp = where(indarr_good_data gt ii)
        if indarr_temp(0) ge 0 then begin
          int_next_good_plus = min(indarr_good_data(indarr_temp))
        end else begin
          int_next_good_plus = -1
        endelse
;            int_next_good_plus = min(where(indarr_good_data gt ii))
;        print,'get_mean_smoothed: ii=',ii,': int_next_good_plus = ',int_next_good_plus

        if (int_next_good_minus ge 0) and (int_next_good_plus ge 0) then begin
          dbl_weight_minus = double(long((ii - int_next_good_minus + 1) / 2))
          dbl_weight_plus = double(long((int_next_good_plus - ii + 1) / 2))
          dbl_weight = double(int_next_good_plus - int_next_good_minus + 1) - (dbl_weight_minus + dbl_weight_plus)
        end else if int_next_good_minus lt 0 then begin
          dbl_weight_minus = 0.
          dbl_weight_plus = double(long((int_next_good_plus - ii + 1) / 2))
          dbl_weight = (int_next_good_plus - ii + 1) - dbl_weight_plus
          int_next_good_minus = 0
        end else if int_next_good_plus lt 0 then begin
          dbl_weight_minus = double(long((ii - int_next_good_minus + 1) / 2))
          dbl_weight_plus = 0.
          dbl_weight = (ii - int_next_good_minus + 1) - dbl_weight_minus
          int_next_good_plus = 0
        end else begin
          dbl_weight_minus = 0.
          dbl_weight_plus = 0.
          dbl_weight = 1.
          int_next_good_minus = 0
          int_next_good_plus = 0
        endelse
      endelse
;      print,'get_mean_smoothed: weights: ',dbl_weight_minus,dbl_weight,dbl_weight_plus
      if (int_next_good_minus lt 0) or (int_next_good_plus lt 0) then begin
        io_dblarr_mean(ii) = dblarr_mean_temp(ii)
        io_dblarr_sigma(ii) = dblarr_sigma_temp(ii)
      end else begin
        io_dblarr_mean(ii) = ((dbl_weight_minus * dblarr_mean_temp(int_next_good_minus)) + (dbl_weight * dblarr_mean_temp(ii)) + (dbl_weight_plus * dblarr_mean_temp(int_next_good_plus))) / (dbl_weight_minus + dbl_weight + dbl_weight_plus)
        io_dblarr_sigma(ii) = ((dbl_weight_minus * dblarr_sigma_temp(int_next_good_minus)) + (dbl_weight * dblarr_sigma_temp(ii)) + (dbl_weight_plus * dblarr_sigma_temp(int_next_good_plus))) / (dbl_weight_minus + dbl_weight + dbl_weight_plus)
      endelse

;      print,'get_mean_smoothed: dblarr_mean_temp(ii) = ',dblarr_mean_temp(ii)
;      print,'get_mean_smoothed: dblarr_mean_temp(',int_next_good_minus,') = ',dblarr_mean_temp(int_next_good_minus)
;      print,'get_mean_smoothed: dblarr_mean_temp(',int_next_good_plus,') = ',dblarr_mean_temp(int_next_good_plus)
;      print,'get_mean_smoothed: io_dblarr_mean(ii) = ',io_dblarr_mean(ii)
;      print,'get_mean_smoothed: io_dblarr_sigma(ii) = ',io_dblarr_sigma(ii)
;      print,'get_mean_smoothed: i_dblarr_limits_x_bins(ii) = ',i_dblarr_limits_x_bins(ii)
;      print,'get_mean_smoothed: i_dblarr_limits_x_bins(ii+1) = ',i_dblarr_limits_x_bins(ii+1)
      if keyword_set(I_B_DO_CLIP) then begin
        ; --- do sigma_clipping
        if indarr(0) ge 0 then begin
          indarr_clip = where(abs(i_dblarr_y(indarr_not_clipped(indarr)) - io_dblarr_mean(ii)) gt i_dbl_sigma_clip * io_dblarr_sigma(ii),COMPLEMENT=indarr_good)
          if indarr_clip(0) ge 0 then begin
            io_indarr_clipped(int_nclipped:int_nclipped+n_elements(indarr_clip)-1) = indarr_not_clipped(indarr(indarr_clip))
            int_nclipped = int_nclipped + n_elements(indarr_clip)
;            print,'get_mean_smoothed: indarr_clip = ',indarr_clip
;            print,'get_mean_smoothed: i_dblarr_y(indarr(indarr_clip)) = ',i_dblarr_y(indarr(indarr_clip))
          endif
        endif
      endif
;      if i_dblarr_limits_x_bins(ii) gt 134. then stop
    endif
    if strpos(strtrim(string(io_dblarr_mean(ii)),2),'Inf') ge 0 then begin
      print,'get_mean_smoothed: ERROR: io_dblarr_mean(ii) = ',io_dblarr_mean(ii)
      stop
    endif

  endfor

  if keyword_set(I_B_DO_CLIP) then begin
    if int_nclipped eq 0 then begin
      io_indarr_clipped = [-1]
    end else begin
      io_indarr_clipped = io_indarr_clipped(0:int_nclipped-1)
    endelse
;    print,'int_nclipped = ',int_nclipped
;    print,'o_indarr_clipped = ',o_indarr_clipped
;    stop
  end else begin
    io_indarr_clipped = [-1]
  endelse
end
