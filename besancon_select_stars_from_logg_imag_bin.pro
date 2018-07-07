pro besancon_select_stars_from_logg_imag_bin,I_NBINS_I                   = i_nbins_i,$; --- must be set
                                             DBL_I_MIN                   = dbl_i_min,$; --- must be set
                                             DBL_I_MAX                   = dbl_i_max,$; --- must be set
                                             STRARR_BESANCONDATA         = strarr_besancondata,$; --- must be set
                                             DBLARR_RAVEDATA             = dblarr_ravedata,$; --- must be set
                                             O_DBLARR_BESANCON_IMAG_BINS = o_dblarr_besancon_imag_bins,$; --- output parameter
                                             O_INDARR_RAVE               = o_indarr_rave,$; --- output parameter
                                                                                    ; --- set to 1 to write o_indarr_ravedata
                                             O_INDARR_BESANCON           = o_indarr_besancon,$; --- output parameter
                                                                                    ; --- set to 1 to write o_iarr_indarr
                                             DBL_SEED                    = dbl_seed,$
                                             I_COL_I_RAVE                = i_col_i_rave,$
                                             I_COL_I_BESANCON            = i_col_i_besancon,$
                                             I_COL_LOGG_RAVE             = i_col_logg_rave,$
                                             I_COL_LOGG_BESANCON         = i_col_logg_besancon,$
                                             O_INTARR_NSTARS_BIN_I       = o_intarr_nstars_bin_i

  if keyword_set(I_NBINS_I) then $
    print,'besancon_select_stars_from_logg_imag_bin: I_NBINS_I = ',i_nbins_i
  if keyword_set(DBL_I_MIN) then $
    print,'besancon_select_stars_from_logg_imag_bin: DBL_I_MIN = ',dbl_i_min
  if keyword_set(DBL_I_MAX) then $
    print,'besancon_select_stars_from_logg_imag_bin: DBL_I_MIN = ',dbl_i_max
  if keyword_set(STRARR_BESANCONDATA) then $
    print,'besancon_select_stars_from_logg_imag_bin: size(strarr_besancondata) = ',size(strarr_besancondata)
  if keyword_set(DBLARR_RAVEDATA) then $
    print,'besancon_select_stars_from_logg_imag_bin: size(dblarr_ravedata) = ',size(dblarr_ravedata)
  if keyword_set(O_DBLARR_BESANCON_IMAG_BINS) then $
    print,'besancon_select_stars_from_logg_imag_bin: o_dblarr_besancon_imag_bins = ',o_dblarr_besancon_imag_bins
  if keyword_set(O_INDARR_RAVE) then $
    print,'besancon_select_stars_from_logg_imag_bin: o_indarr_rave = ',o_indarr_rave
  if keyword_set(O_INDARR_BESANCON) then $
    print,'besancon_select_stars_from_logg_imag_bin: o_indarr_besancon = ',o_indarr_besancon
  if keyword_set(DBL_SEED) then $
    print,'besancon_select_stars_from_logg_imag_bin: dbl_seed = ',dbl_seed
  if keyword_set(I_COL_I_RAVE) then $
    print,'besancon_select_stars_from_logg_imag_bin: i_col_i_rave = ',i_col_i_rave
  if keyword_set(I_COL_LOGG_RAVE) then $
    print,'besancon_select_stars_from_logg_imag_bin: i_col_logg_rave = ',i_col_logg_rave
  if keyword_set(I_COL_I_BESANCON) then $
    print,'besancon_select_stars_from_logg_imag_bin: i_col_i_besancon = ',i_col_i_besancon
  if keyword_set(I_COL_LOGG_BESANCON) then $
    print,'besancon_select_stars_from_logg_imag_bin: i_col_logg_besancon = ',i_col_logg_besancon
  if keyword_set(O_INTARR_NSTARS_BIN_I) then $
    print,'besancon_select_stars_from_logg_imag_bin: o_intarr_nstars_bin_i = ',o_intarr_nstars_bin_i
;  stop

  dbl_binwidth_i = (dbl_i_max - dbl_i_min) / double(i_nbins_i)
  dblarr_i_bins = dblarr(i_nbins_i+1)
  dblarr_i_bins(0) = dbl_i_min
  o_intarr_nstars_bin_i = lonarr(i_nbins_i,2)
  dblarr_besancon_i = double(strarr_besancondata(*,i_col_i_besancon))
  dblarr_besancon_logg = double(strarr_besancondata(*,i_col_logg_besancon))

  o_indarr_rave = lonarr(n_elements(dblarr_ravedata(*,0)))
  o_indarr_rave(*) = -1
  o_indarr_besancon = lonarr(n_elements(strarr_besancondata(*,0)))
  o_dblarr_besancon_imag_bins = dblarr(n_elements(strarr_besancondata(*,0)),n_elements(strarr_besancondata(0,*)))
  i_n_elements_out = 0

  if not keyword_set(DBL_SEED) then dbl_seed = 5.

  k = 0ul; --- number of element in o_indarr_besancon and o_indarr_rave
  ; --- create dblarr_i_bins and count RAVE stars and Besancon stars in Imag bin
  for i=0, i_nbins_i-1 do begin
    dblarr_i_bins(i+1) = dblarr_i_bins(i) + dbl_binwidth_i

    for kk=0,1 do begin
      if kk eq 0 then begin; --- giants
        dbl_logg_min = 0.
        dbl_logg_max = 3.5
      end else begin; --- dwarfs
        dbl_logg_min = 3.5
        dbl_logg_max = 10.
      end

      ; --- rave
      indarr_rave = where((dblarr_ravedata(*,i_col_i_rave) ge dblarr_i_bins(i)) and (dblarr_ravedata(*,i_col_i_rave) lt dblarr_i_bins(i+1)) and (dblarr_ravedata(*,i_col_logg_rave) lt dbl_logg_max) and (dblarr_ravedata(*,i_col_logg_rave) ge dbl_logg_min))

;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': dbl_logg_min = ',dbl_logg_min
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': dbl_logg_max = ',dbl_logg_max
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': dblarr_i_bins(i) = ',dblarr_i_bins(i)
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': dblarr_i_bins(i+1) = ',dblarr_i_bins(i+1)
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_rave = ',indarr_rave
;      if indarr_rave(0) ge 0 then $
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': dblarr_ravedata(indarr_rave, *) = ',dblarr_ravedata(indarr_rave, *)
      if indarr_rave(0) lt 0 then begin
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_rave(0) lt 0'
        if kk eq 0 then begin
          int_ngiants_rave = 0
          o_intarr_nstars_bin_i(i,0) = 0
;          print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',0) set to 0'
        end else begin
          int_ndwarfs_rave = 0
        end
      end else begin
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_rave(0) ge 0'
        if kk eq 0 then begin
          o_intarr_nstars_bin_i(i,0) = n_elements(indarr_rave)
          int_ngiants_rave = n_elements(indarr_rave)
        end else begin
          o_intarr_nstars_bin_i(i,0) = o_intarr_nstars_bin_i(i,0) + n_elements(indarr_rave)
          int_ndwarfs_rave = n_elements(indarr_rave)
        end
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',0) set to ',o_intarr_nstars_bin_i(i,0)
      end
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',0) = ',o_intarr_nstars_bin_i(i,0)

      ; --- besancon
      indarr_bes = where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)) and (dblarr_besancon_logg lt dbl_logg_max) and (dblarr_besancon_logg ge dbl_logg_min))
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_bes = ',indarr_bes

      if indarr_bes(0) lt 0 then begin
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_bes(0) = ',indarr_bes(0),' < 0'
        if kk eq 0 then begin
          o_intarr_nstars_bin_i(i,1) = 0
          int_ngiants_bes = 0
;          int_ngiants_rave = 0
        end else begin
          if o_intarr_nstars_bin_i(i,1) eq 0 then begin
            o_intarr_nstars_bin_i(i,0) = 0
            indarr_rave = [-1]
          endif
          int_ndwarfs_bes = 0
;          int_ndwarfs_rave = 0
        end
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',*) set to 0'
      end else begin
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': indarr_bes(0) = ',indarr_bes(0),' >= 0'
        if kk eq 0 then begin
          o_intarr_nstars_bin_i(i,1) = n_elements(indarr_bes)
          int_ngiants_bes = n_elements(indarr_bes)
        end else begin
          o_intarr_nstars_bin_i(i,1) = o_intarr_nstars_bin_i(i,1) + n_elements(indarr_bes)
          int_ndwarfs_bes = n_elements(indarr_bes)
        endelse
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',1) set to ',o_intarr_nstars_bin_i(i,1)
      end

      ; --- randomly remove too many rave stars
      if kk eq 0 then begin
        nstars_bes = int_ngiants_bes
        nstars_rave = int_ngiants_rave
      end else begin
        nstars_bes = int_ndwarfs_bes
        nstars_rave = int_ndwarfs_rave
      endelse
      if (nstars_bes gt 0) and (nstars_rave ge nstars_bes) then begin
;        print,'besancon_select_stars_from_logg_imag_bin: i=',i,': removing too many rave stars'
        for j=0ul, nstars_rave - nstars_bes do begin
          random_nr = long(RANDOMU(dbl_seed,/UNIFORM) * (nstars_rave))
          remove_ith_element_from_array,indarr_rave,$
                                        random_nr
          o_intarr_nstars_bin_i(i,0) = o_intarr_nstars_bin_i(i,0)-1
;          print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i=',i,',1) set to ',o_intarr_nstars_bin_i(i,1)
          if kk eq 0 then begin
            int_ngiants_rave = int_ngiants_rave - 1
          end else begin
            int_ndwarfs_rave = int_ndwarfs_rave - 1
          end
          nstars_rave = nstars_rave - 1
          print,'besancon_select_stars_from_logg_imag_bin: i=',i,', kk=',kk,': rave star ',j,' removed from indarr_rave'
        endfor
      endif
;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i,*) = ',o_intarr_nstars_bin_i(i,*)

;      print,'besancon_select_stars_from_logg_imag_bin: i=',i,': o_intarr_nstars_bin_i(i,0) = ',o_intarr_nstars_bin_i(i,0)

      if nstars_rave gt 0 and nstars_bes gt 0 then begin
        print,'besancon_select_stars_from_logg_imag_bin: i=',i,', kk=',kk,': (nstars_rave = ',nstars_rave,' gt 0) and (nstars_bes = ',nstars_bes,' gt 0)'
        for j=0ul, nstars_rave-1 do begin
          o_indarr_rave(k) = indarr_rave(j)

          do_run = 1
          i_run = 0

          while do_run eq 1 do begin
            ;print,'besancon_select_stars_from_logg_imag_bin: i=',i,': for j(=',j,')=0ul, o_intarr_nstars_bin_i(i,0)-1 do begin: while: n_elements(indarr_bes) = ',n_elements(indarr_bes)
            ;print,'besancon_select_stars_from_logg_imag_bin: i=',i,': for j(=',j,')=0ul, o_intarr_nstars_bin_i(i,0)-1 do begin: while: n_elements(indarr_rave) = ',n_elements(indarr_rave)
            random_nr = long(RANDOMU(dbl_seed,/UNIFORM) * n_elements(indarr_bes))
            ;print,'besancon_select_stars_from_logg_imag_bin: i=',i,', j=',j,', k=',k,', random_nr = ',random_nr
            if k gt 0 then begin
              indarr_random_test = where(o_indarr_besancon(0:k-1) eq indarr_bes(random_nr))
            end else begin
              indarr_random_test = [-1]
            end
            ;print,'besancon_select_stars_from_logg_imag_bin: i=',i,': for j(=',j,')=0ul, o_intarr_nstars_bin_i(i,0)-1 do begin: while: indarr_random_test = ',indarr_random_test
            if indarr_random_test(0) eq -1 then begin
              o_indarr_besancon(k) = indarr_bes(random_nr)
              o_dblarr_besancon_imag_bins(k,*) = double(strarr_besancondata(indarr_bes(random_nr),*))
  ;            print,'besancon_select_stars_from_logg_imag_bin: dblarr_besancon_imag_bins(k,*) = ',dblarr_besancon_imag_bins(k,*)
              do_run = 0
  ;              if j gt int_loop_end - 5 then $
              print,'besancon_select_stars_from_logg_imag_bin: i=',i,', kk=',kk,': j=',j,', k=',k,': new random star found: ',o_dblarr_besancon_imag_bins(k,2)
  ;            stop
              remove_ith_element_from_array,indarr_bes,random_nr
              k = k+1
            endif
            if i_run gt 100 then begin
;              print,'besancon_select_stars_from_logg_imag_bin: i=',i,': for j(=',j,')=0ul, o_intarr_nstars_bin_i(i,0)-1 do begin: while: strarr_besancondata(indarr_bes,*) = ',strarr_besancondata(indarr_bes,*)
;              print,'besancon_select_stars_from_logg_imag_bin: i=',i,': for j(=',j,')=0ul, o_intarr_nstars_bin_i(i,0)-1 do begin: while: o_dblarr_besancon_imag_bins(0:k-1,*) = ',o_dblarr_besancon_imag_bins(0:k-1,*)
              stop
            end
            i_run = i_run + 1
          endwhile
        endfor
      end else begin
        print,'besancon_select_stars_from_logg_imag_bin: i=',i,', kk=',kk,': (nstars_rave = ',nstars_rave,' le 0) or (nstars_bes = ',nstars_bes,' le 0)'
      end
;      if kk eq 1 then begin
;        intarr_nstars_bin_i(i,0)
;      endif
    endfor
  endfor
;  print,'besancon_select_stars_from_logg_imag_bin: o_intarr_nstars_bin_i = ',o_intarr_nstars_bin_i
  if k gt 0 then begin
    o_dblarr_besancon_imag_bins = o_dblarr_besancon_imag_bins(0:k-1,*)
    o_indarr_rave = o_indarr_rave(0:k-1)
    o_indarr_besancon = o_indarr_besancon(0:k-1)
  end else begin
    o_dblarr_besancon_imag_bins = [0.]
    o_indarr_rave = [-1]
    o_indarr_besancon = [-1]
  end
end
