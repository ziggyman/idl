pro besancon_get_snr,I_STRARR_BESANCONDATA  = i_strarr_besancondata,$
                     I_STRARR_RAVEDATA      = i_strarr_ravedata,$
                     I_INT_ICOL_BESANCON    = i_int_icol_besancon,$
                     I_INT_ICOL_RAVE        = i_int_icol_rave,$
                     I_INT_COL_DEC_BESANCON = i_int_col_dec_besancon,$
                     I_DBLARR_DEC_BESANCON  = i_dblarr_dec_besancon,$
                     I_INT_COL_DEC_RAVE     = i_int_col_dec_rave,$
                     I_DBLARR_DEC_RAVE      = i_dblarr_dec_rave,$
                     I_INT_SNRCOL_RAVE      = i_int_snrcol_rave,$
                     O_DBLARR_SNR_BESANCON  = o_dblarr_snr_besancon,$
                     I_DBL_SEED             = i_dbl_seed
  if not keyword_set(DBL_SEED) then i_dbl_seed = 5.

  dblarr_besancondata = double(i_strarr_besancondata)
;  stop
  dblarr_ravedata = double(i_strarr_ravedata)
  print,'besancon_get_snr: i_strarr_besancondata(0:9,*) = ',i_strarr_besancondata(0:9,*)
  print,'besancon_get_snr: dblarr_besancondata(0:9,*) = ',dblarr_besancondata(0:9,*)
  print,' '
  print,' '
  print,' '
  print,' '
  print,'besancon_get_snr: i_strarr_ravedata(0:9,*) = ',i_strarr_ravedata(0:9,*)
  print,'besancon_get_snr: dblarr_ravedata(0:9,*) = ',dblarr_ravedata(0:9,*)
;  stop

  for i=0ul, n_elements(i_strarr_besancondata(*,0))-1 do begin
    i_run = 0
    while (i_run lt 1000) and (o_dblarr_snr_besancon(i) lt 0.01) do begin
      i_run = i_run + 1
      i_bes = dblarr_besancondata(i,i_int_icol_besancon)
      if i_bes lt 9. then i_bes = 9.
      if i_bes gt 12. then i_bes = 12.
      indarr = where(abs(dblarr_ravedata(*,i_int_icol_rave) - i_bes) lt 0.05)
      print,'besancon_get_snr: dblarr_besancondata(i=',i,', i_int_icol_besancon=',i_int_icol_besancon,') = ',dblarr_besancondata(i,i_int_icol_besancon)
      print,'besancon_get_snr: n_elements(indarr) = ',n_elements(indarr)
      print,'besancon_get_snr: indarr(0) = ',indarr(0)
      if ((keyword_set(I_COL_DEC_BESANCON) or keyword_set(DBLARR_DEC_BESANCON)) and (keyword_set(I_COL_DEC_RAVE) or keyword_set(DBLARR_DEC_BESANCON))) then begin
        if keyword_set(I_COL_DEC_BESANCON) then begin
          i_dblarr_dec_besancon = dblarr_besancondata(i,i_int_col_dec_besancon)
        end
        if keyword_set(I_COL_DEC_RAVE) then begin
          i_dblarr_dec_rave = dblarr_ravedata(i,i_int_col_dec_rave)
        end
        indarr_dec = where(abs(i_dblarr_dec_rave(indarr) - i_dblarr_dec_besancon) lt 5.)
        indarr = indarr(indarr_dec)
      endif
      dbl_random = randomu(i_dbl_seed)
      i_random = long(dbl_random * double(n_elements(indarr)))
      print,'besancon_get_snr: i_random = ',i_random,', indarr(i_random) = ',indarr(i_random)
      print,'besancon_get_snr: dblarr_ravedata(indarr(i_random),*) = ',dblarr_ravedata(indarr(i_random),*)
      print,'besancon_get_snr: i_int_snrcol_rave = ',i_int_snrcol_rave
      o_dblarr_snr_besancon(i) = dblarr_ravedata(indarr(i_random),i_int_snrcol_rave)
      if i_run eq 1000 then stop
    endwhile
    print,'besancon_get_snr: o_dblarr_snr_besancon(i=',i,') = ',o_dblarr_snr_besancon(i)
  endfor
  dblarr_besancondata = 0
  dblarr_ravedata = 0
end
