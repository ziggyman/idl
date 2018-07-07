pro get_bin_width,DBLARR_DATA_A=dblarr_data_a,$; --- in
                  DBLARR_DATA_B=dblarr_data_b,$; --- in
                  DBLARR_BIN_RANGE=dblarr_bin_range,$; --- in
                  I_NBINS_MIN=i_nbins_min,$; --- in
                  I_NBINS_MAX=i_nbins_max,$; --- in
                  DBL_BIN_WIDTH=dbl_bin_width,$; --- out
                  NBINS=nbins; --- out

  if keyword_set(DBLARR_DATA_A) then begin
    print,'get_bin_width: DBLARR_DATA_A set'
  end else begin
    print,'get_bin_width: DBLARR_DATA_A not set'
  endelse

  if keyword_set(DBLARR_DATA_B) then begin
    print,'get_bin_width: DBLARR_DATA_B set'
  end else begin
    print,'get_bin_width: DBLARR_DATA_B not set'
  endelse

  if keyword_set(DBLARR_BIN_RANGE) then begin
    print,'get_bin_width: DBLARR_BIN_RANGE = ',dblarr_bin_range
  end else begin
    print,'get_bin_width: DBLARR_BIN_RANGE not set'
  endelse

  if keyword_set(I_NBINS_MIN) then begin
    print,'get_bin_width: I_NBINS_MIN = ',i_nbins_min
  end else begin
    print,'get_bin_width: I_NBINS_MIN not set'
  endelse

  if keyword_set(I_NBINS_MAX) then begin
    print,'get_bin_width: I_NBINS_MAX = ',i_nbins_max
  end else begin
    print,'get_bin_width: I_NBINS_MAX not set'
  endelse

  if keyword_set(DBL_BIN_WIDTH) then begin
    print,'get_bin_width: DBL_BIN_WIDTH = ',dbl_bin_width
  end else begin
    print,'get_bin_width: DBL_BIN_WIDTH not set'
  endelse

  if keyword_set(NBINS) then begin
    print,'get_bin_width: NBINS = ',nbins
  end else begin
    print,'get_bin_width: NBINS not set'
  endelse

  if not keyword_set(DBLARR_DATA_A) or not keyword_set(DBLARR_DATA_B) or not keyword_set(DBLARR_BIN_RANGE) or not keyword_set(I_NBINS_MIN) or not keyword_set(I_NBINS_MAX) or not keyword_set(DBL_BIN_WIDTH) or not keyword_set(NBINS) then begin
    print,'get_bin_width: ERROR: Not enough parameters specified'
    print,'get_bin_width: USAGE: get_bin_width,DBLARR_DATA_A=dblarr_data_a, DBLARR_DATA_B=dblarr_data_b, DBLARR_BIN_RANGE=dblarr_bin_range, I_NBINS_MIN=i_nbins_min, I_NBINS_MAX=i_nbins_max, DBL_BIN_WIDTH=dbl_bin_width, NBINS=nbins'
    stop
  end

  print,'get_bin_width: DBLARR_BIN_RANGE = ',dblarr_bin_range
  print,'get_bin_width: I_NBINS_MIN = ',i_nbins_min
  print,'get_bin_width: I_NBINS_MAX = ',i_nbins_max
  print,'get_bin_width: DBL_BIN_WIDTH = ',dbl_bin_width
  print,'get_bin_width: NBINS = ',nbins

  dbl_bin_width_a = get_step_size(dblarr_data_a)
  dbl_bin_width_b = get_step_size(dblarr_data_b)

  dbl_lcd = lowest_common_denominator(dbl_bin_width_a,dbl_bin_width_b)
  print,'get_bin_width: dbl_lcd = ',dbl_lcd
  if dbl_lcd gt 0.00000001 then begin
    nbins = (dblarr_bin_range(1) - dblarr_bin_range(0)) / dbl_lcd
    nbins = long(nbins)+1
    dbl_bin_width = dbl_lcd
  end else begin
    if keyword_set(I_NBINS_MIN) then begin
      nbins = i_nbins_min
    end else begin
      nbins = 20
    end
    dbl_bin_width = (dblarr_bin_range(1) - dblarr_bin_range(0)) / double(nbins)
  end
  if keyword_set(I_NBINS_MIN) then begin
    if nbins lt i_nbins_min then begin
      print,'get_bin_width: nbins(=',nbins,') < i_nbins_min(=',i_nbins_min,')'
      nbins = i_nbins_min
      dbl_bin_width = (dblarr_bin_range(1) - dblarr_bin_range(0)) / double(nbins)
    end
  endif

  if keyword_set(I_NBINS_MAX) then begin
    if i_nbins_max lt nbins then begin
      print,'get_bin_width: nbins(=',nbins,') > i_nbins_max(=',i_nbins_max,')'
      i_nbins_max_binwidth = (dblarr_bin_range(1) - dblarr_bin_range(0)) / double(i_nbins_max)
      dbl_bin_width = double(long(i_nbins_max_binwidth / dbl_lcd)+1) * dbl_lcd
      nbins = (dblarr_bin_range(1) - dblarr_bin_range(0)) / dbl_bin_width
      nbins = long(nbins)+1
      print,'get_bin_width: I_NBINS_MAX set: nbins = ',nbins,', dbl_bin_width = ',dbl_bin_width
    endif
  endif
  print,'get_bin_width: nbins = ',nbins,', dbl_bin_width = ',dbl_bin_width

end
