pro rave_besancon_calc_errors,B_TEFF        = b_teff,$; --- I: boolean
                              B_LOGG        = b_logg,$; --- I: boolean
                              B_MH          = b_mh,$; --- I: boolean
                              O_DBLARR_DATA = o_dblarr_data,$; --- O: vector(n)
                              O_DBLARR_ERR  = o_dblarr_err,$; --- O: vector(n)
                              DBLARR_SNR    = dblarr_snr,$; --- I: vector(n)
                              DBLARR_TEFF   = dblarr_teff,$; --- I: vector(n)
                              DBLARR_MH     = dblarr_mh,$;   --- I: vector(n)
                              DBLARR_LOGG   = dblarr_logg,$; --- I: vector(n)
                              DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$; --- I: dbl
                              DBL_REJECT    = dbl_reject,$
                              B_REAL_ERR = b_real_err


; --- B_TEFF,B_LOGG,B_MH:    only ONE can be set to '1'
  if keyword_set(B_TEFF) then begin
    dbl_k = -0.848
    o_dblarr_data = dblarr_teff
    str_sigma_filename = '/home/azuri/daten/rave/rave_data/sigma_teff.rez'
  end else if keyword_set(B_LOGG) then begin
    dbl_k = -0.733
    o_dblarr_data = dblarr_logg
    str_sigma_filename = '/home/azuri/daten/rave/rave_data/sigma_logg.rez'
  end else begin; --- [M/H]
    dbl_k = -0.703
    o_dblarr_data = dblarr_mh
    str_sigma_filename = '/home/azuri/daten/rave/rave_data/sigma_mh.rez'
  end
  dbl_seed = 5.

  dblarr_sigma = readfiletodblarr(str_sigma_filename)
  if keyword_set(B_TEFF) then $
    dblarr_sigma(*,3) = dblarr_sigma(*,3) * (10.^dblarr_sigma(*,2))
  o_dblarr_err = dblarr(n_elements(dblarr_teff))
  add_noise,IO_DBLARR_DATA  = o_dblarr_data,$;        --- vector(n)
            O_DBLARR_ERR = o_dblarr_err,$;       --- vector(n)
            I_DBLARR_SNR_BESANCON = dblarr_snr,$; --- I: vector(n)
            I_DBLARR_TEFF  = dblarr_teff,$;        --- vector(n)
            I_DBLARR_MH    = dblarr_mh,$;          --- vector(n)
            I_DBLARR_LOGG  = dblarr_logg,$;        --- vector(n)
            I_DBLARR_SIGMA = dblarr_sigma,$; --- dblarr(m,10)
                                         ;  --- (*,0): Teff, (*,1:9): sigma40
                                         ;  --- (*,1): M/H = 0, log g = 4.5
                                         ;  --- (*,2): M/H = 0, log g = 3.0
                                         ;  --- (*,3): M/H = 0, log g = 1.0
                                         ;  --- (*,4): M/H = -0.5, log g = 4.5
                                         ;  --- (*,5): M/H = -0.5, log g = 3.0
                                         ;  --- (*,6): M/H = -0.5, log g = 1.0
                                         ;  --- (*,7): M/H = -1.0, log g = 4.5
                                         ;  --- (*,8): M/H = -1.0, log g = 3.0
                                         ;  --- (*,9): M/H = -1.0, log g = 1.0
            I_DBL_K        = dbl_k,$;              --- double
            IO_DBL_SEED     = dbl_seed,$;           --- double
            I_DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$
            I_DBL_REJECT   = dbl_reject,$
            I_B_REAL_ERR = b_real_err

end
