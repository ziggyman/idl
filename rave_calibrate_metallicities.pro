pro rave_calibrate_metallicities,I_DBLARR_MH            = i_dblarr_mH,$
                                 I_DBLARR_AFE           = i_dblarr_aFe,$
                                 I_DBLARR_TEFF          = i_dblarr_teff,$; --- new calibration
                                 I_DBLARR_LOGG          = i_dblarr_logg,$; --- old calibration
                                 I_DBLARR_STN           = i_dblarr_stn,$; --- calibration from DR3 paper
                                 O_STRARR_MH_CALIBRATED = o_strarr_mh_calibrated,$;           --- string array
                                 I_DBL_REJECTVALUE      = i_dbl_rejectvalue,$; --- double
                                 I_DBL_REJECTERR        = rejecterr,$;       --- double
                                 I_B_SEPARATE           = separate

  if keyword_set(I_DBL_REJECTVALUE) and keyword_set(I_DBL_REJECTERR) then begin
    indarr = where(abs(i_dblarr_mH - i_dbl_rejectvalue) gt i_dbl_rejecterr)
  end else begin
    indarr = lindgen(n_elements(i_dblarr_mH))
  endelse
  dblarr_MH_calibrated = i_dblarr_mH
  if keyword_set(DBLARR_TEFF) then begin; --- new calibration
    if keyword_set(DBLARR_STN) then begin
      if keyword_set(SEPARATE) then begin
        indarr_giants = where(i_dblarr_logg(indarr) lt 3.5, complement=indarr_dwarfs)

        ; --- giants
        c0 = 0.239
        c1 = 1.154
        c2 = 1.217
        c3 = -0.006
        c4 = -0.08
        c5 = 0.001
        if indarr_giants(0) ge 0 then $
          dblarr_MH_calibrated(indarr(indarr_giants)) = c0 + c1 * i_dblarr_mH(indarr(indarr_giants)) + c2 * dblarr_afe(indarr(indarr_giants)) + c3 * i_dblarr_teff(indarr(indarr_giants)) / 5040. + c4 * i_dblarr_logg(indarr(indarr_giants)) + c5 * i_dblarr_stn(indarr(indarr_giants))

        ; --- dwarfs
        c0 = -0.170
        c1 = 1.063
        c2 = 1.586
        c3 = -0.751
        c4 = 0.219
        c5 = 0.001
        if indarr_dwarfs(0) ge 0 then $
        dblarr_MH_calibrated(indarr(indarr_dwarfs)) = c0 + c1 * i_dblarr_mH(indarr(indarr_dwarfs)) + c2 * dblarr_afe(indarr(indarr_dwarfs)) + (c3 * i_dblarr_teff(indarr(indarr_dwarfs)) / 5040.) + (c4 * i_dblarr_logg(indarr(indarr_dwarfs))) + (c5 * i_dblarr_stn(indarr(indarr_dwarfs)))
      end else begin
        c0 = 0.429
        c1 = 1.101
        c2 = 1.171
        c3 = -0.391
        c4 = -0.018
        c5 = 0.001
        dblarr_MH_calibrated(indarr) = c0 + (c1 * i_dblarr_mH(indarr)) + (c2 * dblarr_afe(indarr)) + (c3 * i_dblarr_teff(indarr) / 5040.) + (c4 * i_dblarr_logg(indarr)) + (c5 * i_dblarr_stn(indarr))
      endelse
    end else begin
      c0 = 0.29
      c1 = 0.933
      c2 = 0.819
      c3 = 0.208
      dblarr_MH_calibrated(indarr) = c0 + (c1 * i_dblarr_mH(indarr)) + (c2 * i_dblarr_aFe(indarr)) - (c3 * i_dblarr_teff(indarr) / 5040.)
    end
  end else begin; --- old calibration
    dblarr_MH_calibrated(indarr) = (0.938 * i_dblarr_mH(indarr)) + (0.767 * i_dblarr_aFe(indarr)) - (0.064 * i_dblarr_logg(indarr)) + 0.404
  end
  o_strarr_mh_calibrated = string(dblarr_MH_calibrated)

;  openw,lun,'MH_calibrated.text',/GET_LUN
;  for i=0UL,n_elements(dblarr_MH_calibrated)-1 do begin
;    printf,lun,dblarr_MH_calibrated(i)
;  endfor
;  free_lun,lun

end
