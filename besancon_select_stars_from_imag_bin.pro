pro besancon_select_stars_from_imag_bin,I_NBINS_I = i_nbins_i,$; --- must be set
                                        DBL_I_MIN = dbl_i_min,$; --- must be set
                                        DBL_I_MAX = dbl_i_max,$; --- must be set
                                        STRARR_BESANCONDATA = strarr_besancondata,$; --- must be set
                                        DBLARR_RAVEDATA = dblarr_ravedata,$; --- must be set
                                        O_DBLARR_BESANCON_IMAG_BINS = o_dblarr_besancon_imag_bins,$; --- output parameter
                                        O_INDARR_RAVE = o_indarr_ravedata,$; --- output parameter
                                                                               ; --- set to 1 to write o_indarr_ravedata
                                        O_INDARR_BESANCON = o_iarr_indarr,$; --- output parameter
                                                                               ; --- set to 1 to write o_iarr_indarr
                                        O_INTARR_NSTARS_BIN_I = o_intarr_nstars_bin_i,$
                                        B_OVERSAMPLE = b_oversample,$
                                        DBL_SEED = dbl_seed

  dbl_binwidth_i = (dbl_i_max - dbl_i_min) / double(i_nbins_i)
  dblarr_i_bins = dblarr(i_nbins_i+1)
  dblarr_i_bins(0) = dbl_i_min
  o_intarr_nstars_bin_i = lonarr(i_nbins_i,2)
  dblarr_besancon_i = double(strarr_besancondata(*,2))

  if keyword_set(O_INDARR_RAVEDATA) then begin
    o_indarr_ravedata = lonarr(n_elements(dblarr_ravedata(*,0)))
    indarr_out = lonarr(n_elements(dblarr_ravedata(*,2)))
    i_n_elements_out = 0
  endif

  for i=0, i_nbins_i-1 do begin
    dblarr_i_bins(i+1) = dblarr_i_bins(i) + dbl_binwidth_i
;    print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i=',i,') = ',dblarr_i_bins(i)
;    print,'besancon_select_stars_from_imag_bins: dblarr_i_bins(i+1=',i+1,') = ',dblarr_i_bins(i+1)

    ; --- rave
    indarr_rave = where((dblarr_ravedata(*,2) ge dblarr_i_bins(i)) and (dblarr_ravedata(*,2) lt dblarr_i_bins(i+1)))
;    print,'besancon_select_stars_from_imag_bins: indarr_rave = ',indarr_rave
    if indarr_rave(0) lt 0 then begin
      o_intarr_nstars_bin_i(i,0) = 0
    end else begin
      o_intarr_nstars_bin_i(i,0) = n_elements(indarr_rave)
    end
;    print,'besancon_select_stars_from_imag_bins: o_intarr_nstars_bin_i(i=',i,',0) = ',o_intarr_nstars_bin_i(i,0)

    ; --- besancon
    indarr_bes = where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)))
;    print,'besancon_select_stars_from_imag_bins: indarr_bes = ',indarr_bes

    if indarr_bes(0) lt 0 then begin
      o_intarr_nstars_bin_i(i,1) = 0
    end else begin
      o_intarr_nstars_bin_i(i,1) = n_elements(indarr_bes)
    end
;    print,'besancon_select_stars_from_imag_bins: o_intarr_nstars_bin_i(i=',i,',1) = ',o_intarr_nstars_bin_i(i,1)
;    print,'besancon_select_stars_from_imag_bins: o_intarr_nstars_bin_i(i,*) = ',o_intarr_nstars_bin_i(i,*)

    if o_intarr_nstars_bin_i(i,0) lt 0 then $
      o_intarr_nstars_bin_i(i,0) = 0

    if o_intarr_nstars_bin_i(i,1) lt 0 then $
      o_intarr_nstars_bin_i(i,1) = 0

    if ((o_intarr_nstars_bin_i(i,1) gt 1) and (o_intarr_nstars_bin_i(i,0) ge o_intarr_nstars_bin_i(i,1))) or (o_intarr_nstars_bin_i(i,0) gt o_intarr_nstars_bin_i(i,1)) then begin
      if keyword_set(O_INDARR_RAVEDATA) and (o_intarr_nstars_bin_i(i,1) ne 0) then begin
        if o_intarr_nstars_bin_i(i,1) eq 1 then begin
          indarr_out = lonarr(o_intarr_nstars_bin_i(i,1))
        end else begin
          indarr_out = lonarr(o_intarr_nstars_bin_i(i,1)-1)
        end
        indarr_out(*) = -1
        for j=0ul,n_elements(indarr_out)-1 do begin
          b_free = 0
          while not b_free do begin
            i_randomnr = long(randomu(dbl_seed,/UNIFORM) * double(n_elements(indarr_rave)))
;            print,'besancon_select_stars_from_imag_bin: dbl_seed = ',dbl_seed
            indarr_test = where(indarr_out(0:j-1) eq indarr_rave(i_randomnr))
            if indarr_test(0) eq -1 then begin
              b_free = 1
              indarr_out(j) = indarr_rave(i_randomnr)
              indarr_rave = indarr_rave(where(indarr_rave ne indarr_rave(i_randomnr)))
            endif
          endwhile
        endfor

;        print,'besancon_select_stars_from_imag_bin: indarr_out = ',indarr_out
;        print,'besancon_select_stars_from_imag_bin: n_elements(indarr_out) = ',n_elements(indarr_out)





        o_indarr_ravedata(i_n_elements_out:i_n_elements_out+n_elements(indarr_out)-1) = indarr_out
;        print,'besancon_select_stars_from_imag_bin: o_indarr_ravedata(i_n_elements_out(=',i_n_elements_out,'):i_n_elements_out+o_intarr_nstars_bin_i(i,1)-1(=',i_n_elements_out+o_intarr_nstars_bin_i(i,1)-1,')) = indarr_out(=',indarr_out,')'
        i_n_elements_out = i_n_elements_out + o_intarr_nstars_bin_i(i,1)
      endif
      o_intarr_nstars_bin_i(i,0) = n_elements(indarr_out)
    end else begin
      if keyword_set(O_INDARR_RAVEDATA) then begin
        indarr_out = indarr_rave
;        print,'besancon_select_stars_from_imag_bin: indarr_out = ',indarr_out
;        print,'besancon_select_stars_from_imag_bin: n_elements(indarr_out) = ',n_elements(indarr_out)
        if indarr_out(0) ge 0 then begin
          o_indarr_ravedata(i_n_elements_out:i_n_elements_out + n_elements(indarr_out) - 1) = indarr_out
          i_n_elements_out = i_n_elements_out + n_elements(indarr_out)
        endif
;        print,'besancon_select_stars_from_imag_bin: i_n_elements_out = ',i_n_elements_out
      endif
    end

  endfor
  if keyword_set(O_INDARR_RAVEDATA) then $
    o_indarr_ravedata = o_indarr_ravedata(0:i_n_elements_out-1)
;  stop

  dblarr_i_besancon_divided_by_rave = double(o_intarr_nstars_bin_i(*,1)) / double(o_intarr_nstars_bin_i(*,0))
  dbl_i_bes_by_rave_min = min(dblarr_i_besancon_divided_by_rave)
  int_minpos = where(abs(dblarr_i_besancon_divided_by_rave - dbl_i_bes_by_rave_min) lt 0.00001)
;  print,'besancon_select_stars_from_imag_bins: dbl_i_bes_by_rave_min = ',dbl_i_bes_by_rave_min

  dbl_i_bes_by_rave_max = max(dblarr_i_besancon_divided_by_rave)
;  print,'besancon_select_stars_from_imag_bins: dbl_i_bes_by_rave_max = ',dbl_i_bes_by_rave_max
;  print,'besancon_select_stars_from_imag_bins: int_minpos = ',int_minpos
  intarr_size_strarr_besancondata = size(strarr_besancondata)
;  stop
;  print,'total(o_intarr_nstars_bin_i(*,0)) * long(dbl_i_bes_by_rave_min) = ',total(o_intarr_nstars_bin_i(*,0)) * long(dbl_i_bes_by_rave_min)
  if keyword_set(B_OVERSAMPLE) then begin
    int_fac = long(dbl_i_bes_by_rave_min)
  end else begin
    int_fac = 1.
  end
;  print,'besancon_select_stars_from_imag_bins: int_fac = ',int_fac
  o_dblarr_besancon_imag_bins = dblarr(i_nbins_i,max(o_intarr_nstars_bin_i(*,0)) * int_fac,intarr_size_strarr_besancondata(2))
;  print,'besancon_select_stars_from_imag_bins: size(o_dblarr_besancon_imag_bins) = ',size(o_dblarr_besancon_imag_bins)

  if keyword_set(O_IARR_INDARR) then begin
    o_iarr_indarr = lonarr(total(o_intarr_nstars_bin_i(*,0) * int_fac))
    print,'size(o_iarr_indarr) = ',size(o_iarr_indarr)
;    stop
  end
;  i_n_elements = 0
  if not keyword_set(dbl_seed) then $
    dbl_seed = 5.
  k = 0ul
  for i=0ul, i_nbins_i-1 do begin
    if o_intarr_nstars_bin_i(i,0) gt 0 then begin
      intarr_besancon_i = lonarr(o_intarr_nstars_bin_i(i,0) * int_fac)
      intarr_besancon_i(*) = -2
      indarr = where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)))
      if indarr(0) ge 0 then begin
        int_loop_end = (o_intarr_nstars_bin_i(i,0) * int_fac) - 1
;        print,'besancon_select_stars_from_imag_bins: int_loop_end = ',int_loop_end
        for j=0ul, int_loop_end do begin
          do_run = 1ul
          i_run = 0
          while do_run do begin
;            print,'besancon_select_stars_from_imag_bins: n_elements(indarr) = ',n_elements(indarr)
            random_nr = long(RANDOMU(dbl_seed,/UNIFORM) * (n_elements(indarr)))
;            print,'besancon_select_stars_from_imag_bin: dbl_seed = ',dbl_seed
;            print,'besancon_select_stars_from_imag_bins: i=',i,', j=',j,', k=',k,', random_nr = ',random_nr
            indarr_random_test = where(intarr_besancon_i eq random_nr)
;            print,'besancon_select_stars_from_imag_bins: indarr_random_test = ',indarr_random_test
            if indarr_random_test(0) eq -1 then begin
              intarr_besancon_i(j) = random_nr
;              print,'besancon_select_stars_from_imag_bins: i = ',i,', j = ',j,', k = ',k
              o_dblarr_besancon_imag_bins(i,j,*) = double(strarr_besancondata(indarr(random_nr),*))
;            print,'besancon_select_stars_from_imag_bins: o_dblarr_besancon_imag_bins(i,j,*) = ',o_dblarr_besancon_imag_bins(i,j,*)
              if keyword_set(O_IARR_INDARR) then begin
                o_iarr_indarr(k) = indarr(random_nr)
              end
              do_run = 0
              k = k+1
            endif
            if i_run gt 100 then $
              stop
            i_run = i_run + 1
          endwhile
        endfor
        o_intarr_nstars_bin_i(i,1) = int_loop_end+1
      end else begin
        o_intarr_nstars_bin_i(i,1) = 0
      end
    end else begin
      o_intarr_nstars_bin_i(i,1) = 0
    end
  endfor
  if k gt 0 then begin
    o_iarr_indarr = o_iarr_indarr(0:k-1)
    o_indarr_ravedata = o_indarr_ravedata(0:k-1)
  end else begin
    o_iarr_indarr = [-1]
  end
end
