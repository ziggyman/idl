pro besancon_select_stars_from_logg_snr_imag_bin,I_NBINS_I                   = i_nbins_i,$; --- must be set
                                             DBL_I_MIN                   = dbl_i_min,$; --- must be set
                                             DBL_I_MAX                   = dbl_i_max,$; --- must be set
                                             I_NBINS_SNR                 = i_nbins_snr,$; --- must be set
;                                             DBL_SNR_MIN                 = dbl_snr_min,$; --- must be set
;                                             DBL_SNR_MAX                 = dbl_snr_max,$; --- must be set
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
                                             I_COL_SNR_RAVE             = i_col_snr_rave,$
                                             I_COL_SNR_BESANCON         = i_col_snr_besancon

  dbl_binwidth_i = (dbl_i_max - dbl_i_min) / double(i_nbins_i)
  dblarr_i_bins = dblarr(i_nbins_i+1)
  dblarr_i_bins(0) = dbl_i_min

;  print,'strarr_besancondata(0:10,*) = ',strarr_besancondata(0:10,*)
;  print,'dblarr_ravedata(0:10,*) = ',dblarr_ravedata(0:10,*)
  print,'i_col_i_rave = ',i_col_i_rave
  print,'i_col_logg_rave = ',i_col_logg_rave
  print,'i_col_snr_rave = ',i_col_snr_rave
  print,'i_col_i_besancon = ',i_col_i_besancon
  print,'i_col_logg_besancon = ',i_col_logg_besancon
  print,'i_col_snr_besancon = ',i_col_snr_besancon
  print,'I_NBINS_I = ',i_nbins_i

  dbl_snr_min = 0.
  dbl_snr_max = 200.
  if not keyword_set(I_NBINS_SNR) then $
    i_nbins_snr = 50
  print,'I_NBINS_SNR = ',i_nbins_snr

  dbl_binwidth_snr = (dbl_snr_max - dbl_snr_min) / double(i_nbins_snr)
  dblarr_snr_bins = dblarr(i_nbins_snr+1)
  dblarr_snr_bins(0) = dbl_snr_min

  print,'dbl_binwidth_i = ',dbl_binwidth_i
  print,'dbl_binwidth_snr = ',dbl_binwidth_snr

;  stop

  intarr_nstars_bin_i = lonarr(i_nbins_i,2)
  dblarr_besancon_i = double(strarr_besancondata(*,i_col_i_besancon))
  dblarr_besancon_logg = double(strarr_besancondata(*,i_col_logg_besancon))
  dblarr_besancon_snr = double(strarr_besancondata(*,i_col_snr_besancon))

  o_indarr_rave = lonarr(n_elements(dblarr_ravedata(*,0)))
  o_indarr_besancon = lonarr(n_elements(strarr_besancondata(*,0)))
  o_dblarr_besancon_imag_bins = dblarr(n_elements(strarr_besancondata(*,0)),n_elements(strarr_besancondata(0,*)))
;  i_n_elements_out = 0

  if not keyword_set(DBL_SEED) then dbl_seed = 5.

  k = 0ul; --- number of element in o_indarr_besancon and o_indarr_rave
  ; --- create dblarr_i_bins and count RAVE stars and Besancon stars in Imag bin
  for i=0, i_nbins_i-1 do begin
    dblarr_i_bins(i+1) = dblarr_i_bins(i) + dbl_binwidth_i

    for l=0, i_nbins_snr-1 do begin
      dblarr_snr_bins(l+1) = dblarr_snr_bins(l) + dbl_binwidth_snr
      for kk=0,1 do begin
        if kk eq 0 then begin; --- giants
          dbl_logg_min = 0.
          dbl_logg_max = 3.5
        end else begin; --- dwarfs
          dbl_logg_min = 3.5
          dbl_logg_max = 10.
        end

        ; --- rave
        indarr_rave = where((dblarr_ravedata(*,i_col_i_rave) ge dblarr_i_bins(i)) and $
                            (dblarr_ravedata(*,i_col_i_rave) lt dblarr_i_bins(i+1)) and $
                            (dblarr_ravedata(*,i_col_snr_rave) ge dblarr_snr_bins(l)) and $
                            (dblarr_ravedata(*,i_col_snr_rave) lt dblarr_snr_bins(l+1)) and $
                            (dblarr_ravedata(*,i_col_logg_rave) lt dbl_logg_max) and $
                            (dblarr_ravedata(*,i_col_logg_rave) ge dbl_logg_min))
        print,'besancon_select_stars_from_imag_bins: indarr_rave = ',indarr_rave
        if indarr_rave(0) lt 0 then begin
          intarr_nstars_bin_i(i,0) = 0
          intarr_nstars_bin_i(i,1) = 0
          if kk eq 0 then begin
            int_ngiants_rave = 0
          end else begin
            int_ndwarfs_rave = 0
          end
        end else begin
          intarr_nstars_bin_i(i,0) = n_elements(indarr_rave)
          if kk eq 0 then begin
            int_ngiants_rave = n_elements(indarr_rave)
          end else begin
            int_ndwarfs_rave = n_elements(indarr_rave)
          end
        print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i=',i,',0) = ',intarr_nstars_bin_i(i,0)

        ; --- besancon
        indarr_bes = where((dblarr_besancon_i ge dblarr_i_bins(i)) and $
                           (dblarr_besancon_i lt dblarr_i_bins(i+1)) and $
                           (dblarr_besancon_snr ge dblarr_snr_bins(l)) and $
                           (dblarr_besancon_snr lt dblarr_snr_bins(l+1)) and $
                           (dblarr_besancon_logg lt dbl_logg_max) and $
                           (dblarr_besancon_logg ge dbl_logg_min))
        print,'besancon_select_stars_from_imag_bins: indarr_bes = ',indarr_bes

        if indarr_bes(0) lt 0 then begin
          intarr_nstars_bin_i(i,1) = 0
          intarr_nstars_bin_i(i,0) = 0
          indarr_rave = [-1]
          if kk eq 0 then begin
            int_ngiants_bes = 0
            int_ngiants_rave = 0
          end else begin
            int_ndwarfs_bes = 0
            int_ndwarfs_rave = 0
          end
        end else begin
          intarr_nstars_bin_i(i,1) = n_elements(indarr_bes)
          if kk eq 0 then begin
            int_ngiants_bes = n_elements(indarr_bes)
          end else begin
            int_ndwarfs_bes = n_elements(indarr_bes)
          end
        end

        ; --- randomly remove too many rave stars
        if (intarr_nstars_bin_i(i,1) gt 0) and (intarr_nstars_bin_i(i,0) ge intarr_nstars_bin_i(i,1)) then begin
          for j=0ul, intarr_nstars_bin_i(i,0) - intarr_nstars_bin_i(i,1) do begin
            random_nr = long(RANDOMU(seed,/UNIFORM) * (intarr_nstars_bin_i(i,0)))
            remove_ith_element_from_array,indarr_rave,random_nr
            intarr_nstars_bin_i(i,0) = intarr_nstars_bin_i(i,0)-1
            if kk eq 0 then begin
              int_ngiants_rave = int_ngiants_rave - 1
            end else begin
              int_ndwarfs_rave = int_ndwarfs_rave - 1
            end
            print,'rave star ',j,' removed from indarr_rave'
          endfor
        endif
        print,'besancon_select_stars_from_imag_bins: intarr_nstars_bin_i(i,*) = ',intarr_nstars_bin_i(i,*)

        if intarr_nstars_bin_i(i,0) gt 0 then begin
          for j=0ul, intarr_nstars_bin_i(i,0)-1 do begin
            o_indarr_rave(k) = indarr_rave(j)
            do_run = 1
            i_run = 0

            while do_run eq 1 do begin
              print,'besancon_select_stars_from_imag_bins: n_elements(indarr_bes) = ',n_elements(indarr_bes)
              print,'besancon_select_stars_from_imag_bins: n_elements(indarr_rave) = ',n_elements(indarr_rave)
              random_nr = long(RANDOMU(seed,/UNIFORM) * n_elements(indarr_bes))
              print,'besancon_select_stars_from_imag_bins: i=',i,', j=',j,', k=',k,', random_nr = ',random_nr
              if k gt 0 then begin
                indarr_random_test = where(o_indarr_besancon(0:k-1) eq indarr_bes(random_nr))
              end else begin
                indarr_random_test = [-1]
              end
              print,'besancon_select_stars_from_imag_bins: indarr_random_test = ',indarr_random_test
              if indarr_random_test(0) eq -1 then begin
                o_indarr_besancon(k) = indarr_bes(random_nr)
                o_dblarr_besancon_imag_bins(k,*) = double(strarr_besancondata(indarr_bes(random_nr),*))
                do_run = 0
                print,'rave_star: dblarr_ravedata(indarr_rave(j),*) = ',dblarr_ravedata(indarr_rave(j),*)
                print,'bes_star: strarr_besancondata(indarr_bes(random_nr),*) = ',strarr_besancondata(indarr_bes(random_nr),*)
                ;stop
                print,'besancon_select_stars_from_imag_bins: i=',i,', j=',j,', k=',k,': new random star found: ',o_dblarr_besancon_imag_bins(k,2)
                remove_ith_element_from_array,indarr_bes,random_nr
                k = k+1
              endif
              if i_run gt 100 then begin
                print,'strarr_besancondata(indarr_bes,*) = ',strarr_besancondata(indarr_bes,*)
                print,'o_dblarr_besancon_imag_bins(0:k-1,*) = ',o_dblarr_besancon_imag_bins(0:k-1,*)
                stop
              end
              i_run = i_run + 1
            endwhile
          endfor
        end else begin

        end
        end
      endfor
    endfor
    if k eq 0 then begin
      print,'dblarr_i_bins(i) = ',dblarr_i_bins(i)
      print,'dblarr_i_bins(i+1) = ',dblarr_i_bins(i+1)
      print,'where((dblarr_ravedata(*,i_col_i_rave) ge dblarr_i_bins(i)) and (dblarr_ravedata(*,i_col_i_rave) lt dblarr_i_bins(i+1))) = ',where((dblarr_ravedata(*,i_col_i_rave) ge dblarr_i_bins(i)) and (dblarr_ravedata(*,i_col_i_rave) lt dblarr_i_bins(i+1)))
      print,'where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1))) = ',where((dblarr_besancon_i ge dblarr_i_bins(i)) and (dblarr_besancon_i lt dblarr_i_bins(i+1)))
      print,'number of besancon stars found in imag bin = ',k
      if i eq i_nbins_i-1 then $
        stop
    end
  endfor
  print,'number of besancon stars found in field: ',k
  if k gt 0 then begin
    o_dblarr_besancon_imag_bins = o_dblarr_besancon_imag_bins(0:k-1,*)
    o_indarr_rave = o_indarr_rave(0:k-1)
    o_indarr_besancon = o_indarr_besancon(0:k-1)
  end else begin
    o_dblarr_besancon_imag_bins = 0.
    o_indarr_rave = -1
    o_indarr_besancon = -1
  end
end
