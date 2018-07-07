pro besancon_calculate_mh,I_DBLARR_FEH                      = i_dblarr_feh,$
                          O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                          I_B_MINE                          = i_b_mine,$
                          I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
                          I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
                          I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
;                          I_DBLARR_COEFFS_B_DWARFS = i_dblarr_coeffs_b_dwarfs,$
;                          I_DBLARR_COEFFS_B_GIANTS = i_dblarr_coeffs_b_giants,$
                          I_DBLARR_LOGG                     = i_dblarr_logg

  ; --- if my calibration of Zwitter DR2 with different constants then do
  if not keyword_set(I_B_MINE) then begin
    dbl_fac = 0.11
    dbl_fac_exp = 3.6
  end else begin
    ; --- otherwise use constants for calibration of Zwitter DR2
    dbl_fac = 0.11
    dbl_fac_exp = 7.2
  end
  ; --- create output parameter o_dblarr_mh
  o_dblarr_mh = dblarr(n_elements(i_dblarr_feh))

  if keyword_set(I_DBLARR_LOGG) and keyword_set(I_DBLARR_COEFFS_GIANTS) and keyword_set(I_DBLARR_COEFFS_DWARFS) then begin
    ; --- calculate new calibration from [Fe/H] to [M/H] for giants and dwarfs

    ; --- calculate new calibration from [Fe/H] to [M/H] for giants
    indarr_giants = where(i_dblarr_logg le 3.5, COMPLEMENT=indarr_dwarfs)

    ; --- do polynomial fit for giants
    indarr_giants_metal_poor = where(i_dblarr_feh(indarr_giants) lt -1., COMPLEMENT=indarr_giants_metal_rich)
    for i=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
      o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) $; --- last value
                                                               ; --- plus A_i * [Fe/H]_i
                                 + i_dblarr_coeffs_giants_metal_poor(i) * i_dblarr_feh(indarr_giants(indarr_giants_metal_poor))^double(i); + i_dblarr_feh(indarr_giants)
    endfor
    for i=0, n_elements(i_dblarr_coeffs_giants_metal_rich)-1 do begin
      o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) $; --- last value
                                                               ; --- plus A_i * [Fe/H]_i
                                 + i_dblarr_coeffs_giants_metal_rich(i) * i_dblarr_feh(indarr_giants(indarr_giants_metal_rich))^double(i); + i_dblarr_feh(indarr_giants)
    endfor

    ; --- calculate new calibration from [Fe/H] to [M/H] for dwarfs
    ; --- do polynomial fit for dwarfs
    for i=0, n_elements(i_dblarr_coeffs_dwarfs)-1 do begin
      o_dblarr_mh(indarr_dwarfs) = o_dblarr_mh(indarr_dwarfs) $; --- last value
                                                               ; --- plus A_i
                                 + i_dblarr_coeffs_dwarfs(i) * i_dblarr_feh(indarr_dwarfs)^double(i); + i_dblarr_feh(indarr_dwarfs)
    endfor
    o_dblarr_mh = i_dblarr_feh - o_dblarr_mh
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
    ; --- clean up
    indarr_giants = 0
    indarr_giants_metal_poor = 0
    indarr_giants_metal_rich = 0
    indarr_dwarfs = 0
  end else begin
    ; --- calibration [Fe/H] -> [M/H] from Zwitter DR2 paper

    ; --- [Fe/H] < -0.55
    indarr_feh_lt_minus055 = where(i_dblarr_feh lt (0.-0.55), COMPLEMENT=indarr_feh_ge_minus055)
    if indarr_feh_lt_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_lt_minus055) = i_dblarr_feh(indarr_feh_lt_minus055) + dbl_fac * (1. + (1. - exp(-dbl_fac_exp*abs(i_dblarr_feh(indarr_feh_lt_minus055)+0.55))))

    ; --- [Fe/H] >= -0.55
    if indarr_feh_ge_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_ge_minus055) = i_dblarr_feh(indarr_feh_ge_minus055) + dbl_fac * (1. - (1. - exp(-dbl_fac_exp*abs(i_dblarr_feh(indarr_feh_ge_minus055)+0.55))))
  endelse
end
