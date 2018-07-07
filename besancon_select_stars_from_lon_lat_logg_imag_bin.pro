pro besancon_select_stars_from_lon_lat_logg_imag_bin,I_NBINS_I = i_nbins_i,$; --- must be set
                                                     DBL_I_MIN = dbl_i_min,$; --- must be set
                                                     DBL_I_MAX = dbl_i_max,$; --- must be set
                                                     STRARR_BESANCONDATA = strarr_besancondata,$; --- must be set
                                                     DBLARR_RAVEDATA = dblarr_ravedata,$; --- must be set
                                                     DBLARR_BESANCON_IMAG_BINS = dblarr_besancon_imag_bins,$; --- output parameter
                                                     O_INDARR_RAVEDATA = o_indarr_ravedata,$; --- output parameter
                                                                               ; --- set to 1 to write o_indarr_ravedata
                                                     O_IARR_INDARR = o_iarr_indarr,$; --- output parameter
                                                                                            ; --- set to 1 to write o_iarr_indarr
                                                     B_OVERSAMPLE = b_oversample,$
                                                     DBL_SEED = dbl_seed,$
                                                     I_INT_COL_RAVE_I = i_int_col_rave_i,$
                                                     I_INT_COL_RAVE_LOGG = i_int_col_rave_logg,$
                                                     I_INT_COL_RAVE_LON = i_int_col_rave_lon,$
                                                     I_INT_COL_RAVE_LAT = i_int_col_rave_lat,$
                                                     I_INT_COL_BESANCON_I = i_int_col_besancon_i,$
                                                     I_INT_COL_BESANCON_LOGG = i_int_col_besancon_logg,$
                                                     I_INT_COL_BESANCON_LON = i_int_col_besancon_lon,$
                                                     I_INT_COL_BESANCON_LAT = i_int_col_besancon_lat

  dbl_binwidth_i = (dbl_i_max - dbl_i_min) / double(i_nbins_i)
  dblarr_i_bins = dblarr(i_nbins_i+1)
  dblarr_i_bins(0) = dbl_i_min
  intarr_nstars_bin_i = lonarr(i_nbins_i,2)
  dblarr_besancon_i = double(strarr_besancondata(*,i_int_col_besancon_i))
  dblarr_besancon_logg = double(strarr_besancondata(*,i_int_col_besancon_logg))
  dblarr_besancon_lon = double(strarr_besancondata(*,i_int_col_besancon_lon))
  dblarr_besancon_lat = double(strarr_besancondata(*,i_int_col_besancon_lat))

z  if keyword_set(O_INDARR_RAVEDATA) then begin
    o_indarr_ravedata = lonarr(n_elements(dblarr_ravedata(*,0)))
;    indarr_out = lonarr(n_elements(dblarr_ravedata(*,2)))
    i_n_elements_out = 0
  endif

  for i=0, i_nbins_i-1 do begin
    dblarr_i_bins(i+1) = dblarr_i_bins(i) + dbl_binwidth_i
;    print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i=',i,') = ',dblarr_i_bins(i)
;    print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i+1=',i+1,') = ',dblarr_i_bins(i+1)

    ; --- rave
    indarr_rave = where((dblarr_ravedata(*,i_int_col_rave_i) ge dblarr_i_bins(i)) and (dblarr_ravedata(*,i_int_col_rave_i) lt dblarr_i_bins(i+1)))
    print,'besancon_select_stars_from_imag_bins: indarr_rave = ',indarr_rave
    if indarr_rave(0) lt 0 then begin
      intarr_nstars_bin_i(i,0) = 0
    end else begin
      intarr_nstars_bin_i(i,0) = n_elements(indarr_rave)
    end
    print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i=',i,',0) = ',intarr_nstars_bin_i(i,0)

    ; --- besancon
    indarr_bes = where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)))
    print,'besancon_select_stars_from_imag_bins: indarr_bes = ',indarr_bes

    if indarr_bes(0) lt 0 then begin
      intarr_nstars_bin_i(i,1) = 0
    end else begin
      intarr_nstars_bin_i(i,1) = n_elements(indarr_bes)
    end
    print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i=',i,',1) = ',intarr_nstars_bin_i(i,1)
    print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i,*) = ',intarr_nstars_bin_i(i,*)

    if intarr_nstars_bin_i(i,0) lt 0 then $
      intarr_nstars_bin_i(i,0) = 0

    if intarr_nstars_bin_i(i,1) lt 0 then $
      intarr_nstars_bin_i(i,1) = 0

    if ((intarr_nstars_bin_i(i,1) gt 1) and (intarr_nstars_bin_i(i,0) ge intarr_nstars_bin_i(i,1))) or (intarr_nstars_bin_i(i,0) gt intarr_nstars_bin_i(i,1)) then begin
      if keyword_set(O_INDARR_RAVEDATA) and (intarr_nstars_bin_i(i,1) ne 0) then begin
        if intarr_nstars_bin_i(i,1) eq 1 then begin
          indarr_out = lonarr(intarr_nstars_bin_i(i,1))
        end else begin
          indarr_out = lonarr(intarr_nstars_bin_i(i,1)-1)
        end
        indarr_out(*) = -1
        for j=0ul,n_elements(indarr_out)-1 do begin
          b_free = 0
          while not b_free do begin
            i_randomnr = long(randomu(dbl_seed,/UNIFORM) * double(n_elements(indarr_rave)))
            indarr_test = where(indarr_out eq indarr_rave(i_randomnr))
            if indarr_test(0) eq -1 then begin
              b_free = 1
              indarr_out(j) = indarr_rave(i_randomnr)
              indarr_rave = indarr_rave(where(indarr_rave ne indarr_rave(i_randomnr)))
            endif
          endwhile
        endfor

        print,'besancon_select_stars_from_imag_bin: indarr_out = ',indarr_out
        print,'besancon_select_stars_from_imag_bin: n_elements(indarr_out) = ',n_elements(indarr_out)





        o_indarr_ravedata(i_n_elements_out:i_n_elements_out+n_elements(indarr_out)-1) = indarr_out
        print,'besancon_select_stars_from_imag_bin: o_indarr_ravedata(i_n_elements_out(=',i_n_elements_out,'):i_n_elements_out+intarr_nstars_bin_i(i,1)-1(=',i_n_elements_out+intarr_nstars_bin_i(i,1)-1,')) = indarr_out(=',indarr_out,')'
        i_n_elements_out = i_n_elements_out + intarr_nstars_bin_i(i,1)
      endif
      intarr_nstars_bin_i(i,0) = intarr_nstars_bin_i(i,1)
    end else begin
      if keyword_set(O_INDARR_RAVEDATA) then begin
        indarr_out = indarr_rave
        print,'besancon_select_stars_from_imag_bin: indarr_out = ',indarr_out
        print,'besancon_select_stars_from_imag_bin: n_elements(indarr_out) = ',n_elements(indarr_out)
        if indarr_out(0) ge 0 then begin
          o_indarr_ravedata(i_n_elements_out:i_n_elements_out+intarr_nstars_bin_i(i,0)-1) = indarr_out
          i_n_elements_out = i_n_elements_out + intarr_nstars_bin_i(i,0)
        endif
        print,'besancon_select_stars_from_imag_bin: i_n_elements_out = ',i_n_elements_out
      endif
    end

  endfor
  if keyword_set(O_INDARR_RAVEDATA) then $
    o_indarr_ravedata = o_indarr_ravedata(0:i_n_elements_out-1)
;  stop

  dblarr_i_besancon_divided_by_rave = double(intarr_nstars_bin_i(*,1)) / double(intarr_nstars_bin_i(*,0))
  dbl_i_bes_by_rave_min = min(dblarr_i_besancon_divided_by_rave)
  int_minpos = where(abs(dblarr_i_besancon_divided_by_rave - dbl_i_bes_by_rave_min) lt 0.00001)
  print,'besancon_select_stars_from_imag_bins: dbl_i_bes_by_rave_min = ',dbl_i_bes_by_rave_min

  dbl_i_bes_by_rave_max = max(dblarr_i_besancon_divided_by_rave)
  print,'besancon_select_stars_from_imag_bins: dbl_i_bes_by_rave_max = ',dbl_i_bes_by_rave_max
  print,'besancon_select_stars_from_imag_bins: int_minpos = ',int_minpos
  intarr_size_strarr_besancondata = size(strarr_besancondata)
;  stop
  print,'total(intarr_nstars_bin_i(*,0)) * long(dbl_i_bes_by_rave_min) = ',total(intarr_nstars_bin_i(*,0)) * long(dbl_i_bes_by_rave_min)
  if keyword_set(B_OVERSAMPLE) then begin
    int_fac = long(dbl_i_bes_by_rave_min)
  end else begin
    int_fac = 1.2
  end
  print,'besancon_select_stars_from_imag_bins: int_fac = ',int_fac
  dblarr_besancon_imag_bins = dblarr(total(intarr_nstars_bin_i(*,0)) * int_fac,intarr_size_strarr_besancondata(2))
  print,'besancon_select_stars_from_imag_bins: size(dblarr_besancon_imag_bins) = ',size(dblarr_besancon_imag_bins)

  if keyword_set(O_IARR_INDARR) then begin
    o_iarr_indarr = lonarr(total(intarr_nstars_bin_i(*,0) * int_fac))
  end
;  i_n_elements = 0
  seed = 5.
  k = 0ul
  for i=0ul, i_nbins_i-1 do begin
    if intarr_nstars_bin_i(i,0) gt 0 then begin
      intarr_besancon_i = lonarr(intarr_nstars_bin_i(i,0) * int_fac)
      intarr_besancon_i(*) = -2
      print,'besancon_select_stars_from_imag_bins: intarr_besancon_i = ',intarr_besancon_i
      indarr = where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)))
      if indarr(0) ge 0 then begin
        print,'besancon_select_stars_from_imag_bins: n_elements(indarr) = ',n_elements(indarr)
        print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i=',i,') = ',dblarr_i_bins(i)
;    print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i+1=',i+1,') = ',dblarr_i_bins(i+1)
;    print,'besancon_select_stars_from_imag_bins: bes: n_elements(indarr) = ',n_elements(indarr)
        print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i=',i,',*) = ',intarr_nstars_bin_i(i,*)
;    indarr_temp = where(int_minpos eq i)
;    if indarr_temp(0) ne -1 then begin
;      dblarr_besancon_imag_bins(k:k+n_elements(indarr)-1,*) = double(strarr_besancondata(indarr,*))
;      if keyword_set(O_IARR_INDARR) then begin
;        o_iarr_indarr(k:k+n_elements(indarr)-1) = indarr
;      end
;      print,'besancon_select_stars_from_imag_bins: i = ',i,', k = ',k
;      k = k + n_elements(indarr)
;;      print,'besancon_select_stars_from_imag_bins: i=',i,', k=',k,': random stars found: ',dblarr_besancon_imag_bins(k-6:k-1,*)
;      stop
;      if k gt total(intarr_nstars_bin_i(0:i,0)) then begin
;        print,'besancon_select_stars_from_imag_bins: k(=',k,') gt total(intarr_nstars_bin_i(0:i,0) = ',total(intarr_nstars_bin_i(0:i,0))
;        stop
;      end
;    end else begin
        int_loop_end = (intarr_nstars_bin_i(i,0) * int_fac) - 1
        print,'besancon_select_stars_from_imag_bins: int_loop_end = ',int_loop_end
        for j=0ul, int_loop_end do begin
          do_run = 1
          i_run = 0
          while do_run do begin
            print,'besancon_select_stars_from_imag_bins: n_elements(indarr) = ',n_elements(indarr)
            random_nr = long(RANDOMU(seed,/UNIFORM) * (n_elements(indarr)))
            print,'besancon_select_stars_from_imag_bins: i=',i,', j=',j,', k=',k,', random_nr = ',random_nr
            indarr_random_test = where(intarr_besancon_i eq random_nr)
            print,'besancon_select_stars_from_imag_bins: indarr_random_test = ',indarr_random_test
            if indarr_random_test(0) eq -1 then begin
              intarr_besancon_i(j) = random_nr-1
              print,'besancon_select_stars_from_imag_bins: i = ',i,', j = ',j,', k = ',k
              dblarr_besancon_imag_bins(k,*) = double(strarr_besancondata(indarr(random_nr),*))
;            print,'besancon_select_stars_from_imag_bins: dblarr_besancon_imag_bins(k,*) = ',dblarr_besancon_imag_bins(k,*)
              if keyword_set(O_IARR_INDARR) then begin
                o_iarr_indarr(k) = indarr(random_nr)
              end
              do_run = 0
              if j gt int_loop_end - 5 then $
                print,'besancon_select_stars_from_imag_bins: i=',i,', j=',j,', k=',k,': new random star found: ',dblarr_besancon_imag_bins(k,2)
;            stop
              k = k+1
            endif
            if i_run gt 20 then $
              stop
            i_run = i_run + 1
          endwhile
        endfor
      end
;    endelse
;    i_n_elements = j-1
    end
  endfor
;  print,'besancon_select_stars_from_imag_bins: dblarr_besancon_imag_bins = ',dblarr_besancon_imag_bins;(total(intarr_nstars_bin_i(*,0)) * int_fac-1,*)
  print,'besancon_select_stars_from_imag_bins: size(dblarr_besancon_imag_bins) = ',size(dblarr_besancon_imag_bins);(total(intarr_nstars_bin_i(*,0)) * int_fac-1,*)
;  stop
end
