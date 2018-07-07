pro besancon_calculate_mh,I_DBLARR_FEH                      = i_dblarr_feh,$
                          O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                          I_INT_VERSION                     = i_int_version,$; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
                          I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
                          I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
                          I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
                          I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
;                          I_DBLARR_COEFFS_B_DWARFS = i_dblarr_coeffs_b_dwarfs,$
;                          I_DBLARR_COEFFS_B_GIANTS = i_dblarr_coeffs_b_giants,$
                          I_DBLARR_LOGG                     = i_dblarr_logg,$
                          I_DBLARR_TEFF                     = i_dblarr_teff

  if not keyword_set(I_INT_VERSION) then stop

  if i_int_version eq 3 and (not(keyword_set(I_DBLARR_LOGG)) or not(keyword_set(I_DBLARR_TEFF))) then stop

;  if keyword_set(I_DBLARR_COEFFS_DWARFS) then $
;    print,'besancon_calculate_mh: I_DBLARR_COEFFS_DWARFS = ',I_DBLARR_COEFFS_DWARFS
;  if keyword_set(I_DBLARR_COEFFS_GIANTS_METAL_POOR) then $
;    print,'besancon_calculate_mh: I_DBLARR_COEFFS_GIANTS_METAL_POOR = ',I_DBLARR_COEFFS_GIANTS_METAL_POOR
;  if keyword_set(I_DBLARR_COEFFS_GIANTS_METAL_RICH) then $
;    print,'besancon_calculate_mh: I_DBLARR_COEFFS_GIANTS_METAL_RICH = ',I_DBLARR_COEFFS_GIANTS_METAL_RICH
;  if keyword_set(I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH) then $
;    print,'besancon_calculate_mh: I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = ',I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH
;  print,'besancon_calculate_mh: n_elements(i_dblarr_feh) = ',n_elements(i_dblarr_feh)
;  print,'besancon_calculate_mh: n_elements(i_dblarr_logg) = ',n_elements(i_dblarr_logg)

  if keyword_set(I_DBLARR_COEFFS_GIANTS_METAL_RICH) then begin
    openw,lun,'coeffs.text',/GET_LUN
      printf,lun,'I_DBLARR_COEFFS_DWARFS            = ',i_dblarr_coeffs_dwarfs
      printf,lun,'I_DBLARR_COEFFS_GIANTS_METAL_POOR = ',i_dblarr_coeffs_giants_metal_poor
      printf,lun,'I_DBLARR_COEFFS_GIANTS_METAL_RICH = ',i_dblarr_coeffs_giants_metal_rich
      printf,lun,'I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = ',i_dblarr_coeffs_giants_very_metal_rich
    free_lun,lun
  endif

  ; --- if my calibration then do
  if i_int_version eq 2 then begin
    i_dblarr_coeffs_dwarfs = [0.0031993339,0.76814896,0.026853846];0.0044323194,0.76363177,0.0014614658]
    i_dblarr_coeffs_giants_metal_poor = [1.1273630,2.2794280,0.42460990];0.85477788,1.8355969,0.24523228]
    i_dblarr_coeffs_giants_metal_rich = [0.00091376985,0.89905825,0.17658445];0.00085171117,0.89849126,0.17538845]
    i_dblarr_coeffs_giants_very_metal_rich = [0.0047670650,0.88925742,-0.21106783];0.0047255738,0.88603368,-0.18844158]
  endif

  ; --- constants for transformation from Zwitter DR2
  dbl_fac = 0.11
  dbl_fac_exp = 7.2

  ; --- create output parameter o_dblarr_mh
  o_dblarr_mh = dblarr(n_elements(i_dblarr_feh))

  if ((i_int_version eq 2) and keyword_set(I_DBLARR_LOGG)) or (keyword_set(I_DBLARR_LOGG) and keyword_set(I_DBLARR_COEFFS_GIANTS_METAL_POOR) and keyword_set(I_DBLARR_COEFFS_GIANTS_METAL_RICH) and keyword_set(I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH) and keyword_set(I_DBLARR_COEFFS_DWARFS)) then begin
    ; --- calculate new calibration from [Fe/H] to [M/H] for giants and dwarfs

    ; --- calculate new calibration from [Fe/H] to [M/H] for giants
    indarr_giants = where(i_dblarr_logg le 3.5, COMPLEMENT=indarr_dwarfs)
    print,'number of giants = ',n_elements(indarr_giants)

    print,'number of dwarfs = ',n_elements(indarr_dwarfs)

    ; --- do polynomial fit for giants
    ; --- metal poor stars ([Fe/H] < -1. dex)
    if indarr_giants(0) ge 0 then begin
;      print,'i_dblarr_logg(indarr_giants) = ',i_dblarr_logg(indarr_giants)
      indarr_giants_metal_poor = where(i_dblarr_feh(indarr_giants) lt -1.)
      print,'number of very metal poor giants = ',n_elements(indarr_giants_metal_poor)
      if indarr_giants_metal_poor(0) ge 0 then begin
        print,'number of very metal poor giants = ',n_elements(indarr_giants_metal_poor)
;        print,'i_dblarr_feh(indarr_giants(indarr_giants_metal_poor)) = ',i_dblarr_feh(indarr_giants(indarr_giants_metal_poor))
        for i=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) $; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    + i_dblarr_coeffs_giants_metal_poor(i) * i_dblarr_feh(indarr_giants(indarr_giants_metal_poor))^double(i); + i_dblarr_feh(indarr_giants)
        endfor
      endif

      ; metal rich stars (-1. dex <= [Fe/H] < 0.1 dex)
      indarr_giants_metal_rich = where(i_dblarr_feh(indarr_giants) ge -1. and i_dblarr_feh(indarr_giants) lt 0.1)
      if indarr_giants_metal_rich(0) ge 0 then begin
        print,'number of metal poor giants = ',n_elements(indarr_giants_metal_rich)
;        print,'i_dblarr_feh(indarr_giants(indarr_giants_metal_rich)) = ',i_dblarr_feh(indarr_giants(indarr_giants_metal_rich))
        for i=0, n_elements(i_dblarr_coeffs_giants_metal_rich)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) $; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    + i_dblarr_coeffs_giants_metal_rich(i) * i_dblarr_feh(indarr_giants(indarr_giants_metal_rich))^double(i); + i_dblarr_feh(indarr_giants)
        endfor
      endif

      ; very metal rich ([Fe/H] > 0.1)
      indarr_giants_very_metal_rich = where(i_dblarr_feh(indarr_giants) ge 0.1)
      if indarr_giants_very_metal_rich(0) ge 0 then begin
        print,'number of metal rich giants = ',n_elements(indarr_giants_very_metal_rich)
;        print,'i_dblarr_feh(indarr_giants(indarr_giants_very_metal_rich)) = ',i_dblarr_feh(indarr_giants(indarr_giants_very_metal_rich))
        for i=0, n_elements(i_dblarr_coeffs_giants_very_metal_rich)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_very_metal_rich)) = o_dblarr_mh(indarr_giants(indarr_giants_very_metal_rich)) +$; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    i_dblarr_coeffs_giants_very_metal_rich(i) * i_dblarr_feh(indarr_giants(indarr_giants_very_metal_rich))^double(i); + i_dblarr_feh(indarr_giants)
        endfor
      endif

      ; --- make smooth connection between fitting functions
  ;    indarr_sort = sort(i_dblarr_feh(indarr_giants))

      ; --- first connection metal poor <-> metal rich
      dbl_feh_min = -1.1
      dbl_feh_max = -0.9
      indarr_connection = where((i_dblarr_feh(indarr_giants) ge dbl_feh_min) and (i_dblarr_feh(indarr_giants) le dbl_feh_max))
      print,'number of very metal poor and metal poor giants in first merging area = ',n_elements(indarr_connection)
      if indarr_connection(0) ge 0 then begin
;        print,'1st: i_dblarr_feh(indarr_giants(indarr_connection)) = ',i_dblarr_feh(indarr_giants(indarr_connection))
  ;      for i=0, n_elements(indarr_connection)-1 do begin
        dblarr_weight_low = (cos((i_dblarr_feh(indarr_giants(indarr_connection)) - dbl_feh_min) * !DPI / (dbl_feh_max - dbl_feh_min)) + 1.) / 2.
        dblarr_weight_high = 1. - dblarr_weight_low
;        print,'1st: dblarr_weight_low = ',dblarr_weight_low
;        print,'1st: dblarr_weight_high = ',dblarr_weight_high
        o_dblarr_mh(indarr_giants(indarr_connection)) = 0.
        i_maxind = 10
        if n_elements(indarr_connection) lt 11 then $
          i_maxind = n_elements(indarr_connection)-1
        for j=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          print,' '
;          print,'j=',j,': o_dblarr_mh(indarr_giants(indarr_connection(0:i_maxind))) = ',o_dblarr_mh(indarr_giants(indarr_connection(0:i_maxind)))
;          print,'j=',j,': dblarr_weight_low(0:i_maxind=',dblarr_weight_low(0:i_maxind),')'
;          print,'     * (i_dblarr_coeffs_giants_metal_poor(j=',j,'=',i_dblarr_coeffs_giants_metal_poor(j),')'
;          print,'        * i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind))=',i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind))),')'
;          print,'          ^double(j)) = ',dblarr_weight_low(0:i_maxind) * (i_dblarr_coeffs_giants_metal_poor(j) * (i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind))))^double(j))
;          print,' '
;          print,'j=',j,': dblarr_weight_high(0:i_maxind=',dblarr_weight_high(0:i_maxind),') '
;          print,'     * (i_dblarr_coeffs_giants_metal_rich(j=',j,'=',i_dblarr_coeffs_giants_metal_rich(j),')'
;          print,'        * i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind))=',i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind))),')'
;          print,'          ^double(j)) = ',dblarr_weight_high(0:i_maxind) * ((i_dblarr_coeffs_giants_metal_rich(j) * i_dblarr_feh(indarr_giants(indarr_connection(0:i_maxind)))^double(j)))
          o_dblarr_mh(indarr_giants(indarr_connection)) = o_dblarr_mh(indarr_giants(indarr_connection)) + $
                                                          dblarr_weight_low * (i_dblarr_coeffs_giants_metal_poor(j) *$
                                                                               (i_dblarr_feh(indarr_giants(indarr_connection))^double(j))) +$
                                                          dblarr_weight_high * (i_dblarr_coeffs_giants_metal_rich(j) *$
                                                                                (i_dblarr_feh(indarr_giants(indarr_connection))^double(j)))
        endfor
;        print,' '
;        print,'1st: o_dblarr_mh(indarr_giants(indarr_connection(0:i_maxind))) = ',o_dblarr_mh(indarr_giants(indarr_connection(0:i_maxind)))
  ;      endfor
;        stop
      endif

      ; --- second connection metal rich <-> very metal rich
      dbl_feh_min = 0.
      dbl_feh_max = 0.2
      indarr_connection = where((i_dblarr_feh(indarr_giants) ge dbl_feh_min) and (i_dblarr_feh(indarr_giants) le dbl_feh_max))
      print,'number of metal poor and metal rich giants in second merging area = ',n_elements(indarr_connection)
      if indarr_connection(0) ge 0 then begin
;      for i=0, n_elements(indarr_connection)-1 do begin
;        print,'2nd: i_dblarr_feh(indarr_giants(indarr_connection)) = ',i_dblarr_feh(indarr_giants(indarr_connection))
        dblarr_weight_low = (cos((i_dblarr_feh(indarr_giants(indarr_connection)) - dbl_feh_min) * !DPI / (dbl_feh_max - dbl_feh_min)) + 1.) / 2.
        dblarr_weight_high = 1. - dblarr_weight_low
;        print,'2nd: dblarr_weight_low = ',dblarr_weight_low
;        print,'2nd: dblarr_weight_high = ',dblarr_weight_high
        o_dblarr_mh(indarr_giants(indarr_connection)) = 0.
        for j=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_connection)) = o_dblarr_mh(indarr_giants(indarr_connection)) + $
                                                          dblarr_weight_low * (i_dblarr_coeffs_giants_metal_rich(j) *$
                                                                               i_dblarr_feh(indarr_giants(indarr_connection))^double(j)) +$
                                                          dblarr_weight_high * (i_dblarr_coeffs_giants_very_metal_rich(j) *$
                                                                                i_dblarr_feh(indarr_giants(indarr_connection))^double(j))
        endfor
;      endfor
;        print,'2nd: o_dblarr_mh(indarr_giants(indarr_connection)) = ',o_dblarr_mh(indarr_giants(indarr_connection))
      endif
;      stop

      ; --- clean up
      indarr_connection = 0
;      indarr_sort = 0
      indarr_giants = 0
    endif

    ; --- calculate new calibration from [Fe/H] to [M/H] for dwarfs
    ; --- do polynomial fit for dwarfs
    if indarr_dwarfs(0) ge 0 then begin
;      print,'i_dblarr_logg(indarr_dwarfs) = ',i_dblarr_logg(indarr_dwarfs)
      for i=0, n_elements(i_dblarr_coeffs_dwarfs)-1 do begin
        o_dblarr_mh(indarr_dwarfs) = o_dblarr_mh(indarr_dwarfs) +$; --- last value
                                                                ; --- plus A_i
                                     i_dblarr_coeffs_dwarfs(i) * i_dblarr_feh(indarr_dwarfs)^double(i); + i_dblarr_feh(indarr_dwarfs)
      endfor
    endif
;    o_dblarr_mh = i_dblarr_feh - o_dblarr_mh
;    dblarr_mh = o_dblarr_mh

    ; --- do polynomial fit for giants the second time
;    if keyword_set(I_DBLARR_COEFFS_B_GIANTS) then begin
;      for i=0, n_elements(i_dblarr_coeffs_b_giants)-1 do begin
;        o_dblarr_mh(indarr_giants) = o_dblarr_mh(indarr_giants) $; --- last value
;                                                                 ; --- plus A_i * [Fe/H]_i
;                                   + i_dblarr_coeffs_b_giants(i) * dblarr_mh(indarr_giants)^double(i); + i_dblarr_feh(indarr_giants)
;      endfor
;      o_dblarr_mh(indarr_giants) = dblarr_mh(indarr_giants) - o_dblarr_mh(indarr_giants)
;    endif
;
;
;    ; --- do polynomial fit for dwarfs the second time
;    if keyword_set(I_DBLARR_COEFFS_B_DWARFS) then begin
;      for i=0, n_elements(i_dblarr_coeffs_b_dwarfs)-1 do begin
;        o_dblarr_mh(indarr_dwarfs) = o_dblarr_mh(indarr_dwarfs) $; --- last value
;                                                                ; --- plus A_i
;                                  + i_dblarr_coeffs_b_dwarfs(i) * dblarr_mh(indarr_dwarfs)^double(i); + i_dblarr_feh(indarr_dwarfs)
;      endfor
;      o_dblarr_mh(indarr_dwarfs) = i_dblarr_feh(indarr_dwarfs) - o_dblarr_mh(indarr_dwarfs)
;    endif
;
;stop
    ; --- clean up
    indarr_giants = 0
    indarr_giants_metal_poor = 0
    indarr_giants_metal_rich = 0
    indarr_dwarfs = 0
  end else if i_int_version eq 1 then begin
    ; --- calibration [Fe/H] -> [M/H] from Zwitter DR2 paper

    ; --- [Fe/H] < -0.55
    indarr_feh_lt_minus055 = where(i_dblarr_feh lt (0.-0.55), COMPLEMENT=indarr_feh_ge_minus055)
    if indarr_feh_lt_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_lt_minus055) = i_dblarr_feh(indarr_feh_lt_minus055) + dbl_fac * (1. + (1. - exp(-dbl_fac_exp*abs(i_dblarr_feh(indarr_feh_lt_minus055)+0.55))))

    ; --- [Fe/H] >= -0.55
    if indarr_feh_ge_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_ge_minus055) = i_dblarr_feh(indarr_feh_ge_minus055) + dbl_fac * (1. - (1. - exp(-dbl_fac_exp*abs(i_dblarr_feh(indarr_feh_ge_minus055)+0.55))))
  end else if i_int_version eq 3 then begin
    calculate_mh_from_feh,I_DBLARR_FEH         = i_dblarr_feh,$
                          ;I_STR_FILENAME_CALIB = i_str_filename_calib,$
                          O_DBLARR_MH          = o_dblarr_mh,$
                          I_DBLARR_TEFF        = i_dblarr_teff,$
                          I_DBLARR_LOGG        = i_dblarr_logg

  endif
end
