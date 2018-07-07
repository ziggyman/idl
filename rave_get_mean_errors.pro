pro rave_get_mean_errors
  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat';rave_internal_dr8_stn_gt_20.dat'

  int_col_teff = 19
  int_col_logg = 20
  int_col_mh = 21
  int_col_stn = 35
  int_col_s2n = 34

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_teff = double(strarr_data(*,int_col_teff))
  dblarr_logg = double(strarr_data(*,int_col_logg))
  dblarr_mh = double(strarr_data(*,int_col_mh))
  dblarr_stn = double(strarr_data(*,int_col_stn))
  dblarr_s2n = double(strarr_data(*,int_col_s2n))
  indarr = where(dblarr_stn lt 10.)
  if indarr(0) ge 0 then $
    dblarr_stn(indarr) = dblarr_s2n(indarr)
  indarr = 0

  for i=0,2 do begin
    if i eq 0 then begin
      b_teff = 1
      b_logg = 0
      b_mh = 0
    end else if i eq 1 then begin
      b_teff = 0
      b_logg = 1
      b_mh = 0
    end else begin
      b_teff = 0
      b_logg = 0
      b_mh = 1
    end
    o_dblarr_data = 1
    o_dblarr_err = 1
    rave_besancon_calc_errors,B_TEFF        = b_teff,$; --- I: boolean
                              B_LOGG        = b_logg,$; --- I: boolean
                              B_MH          = b_mh,$; --- I: boolean
                              O_DBLARR_DATA = o_dblarr_data,$; --- O: vector(n)
                              O_DBLARR_ERR  = o_dblarr_err,$; --- O: vector(n)
                              DBLARR_SNR    = dblarr_stn,$; --- I: vector(n)
                              DBLARR_TEFF   = dblarr_teff,$; --- I: vector(n)
                              DBLARR_MH     = dblarr_mh,$;   --- I: vector(n)
                              DBLARR_LOGG   = dblarr_logg,$; --- I: vector(n)
                              ;DBL_DIVIDE_ERROR_BY = dbl_divide_error_by,$; --- I: dbl
                              ;DBL_REJECT    = dbl_reject,$
                              B_REAL_ERR = 0;b_real_err
    if i eq 0 then begin
      dblarr_err_teff = o_dblarr_err
    end else if i eq 1 then begin
      dblarr_err_logg = o_dblarr_err
    end else begin
      dblarr_err_mh = o_dblarr_err
    end
  endfor
  indarr_dwarfs = where(dblarr_logg ge 3.5,COMPLEMENT=indarr_giants)
  for i=0,2 do begin
    if i eq 0 then begin
      print,'Teff: mean(dblarr_err_teff) = ',mean(abs(dblarr_err_teff))
      print,'Teff: mean(dblarr_err_teff(indarr_dwarfs)) = ',mean(abs(dblarr_err_teff(indarr_dwarfs)))
      print,'Teff: mean(dblarr_err_teff(indarr_giants)) = ',mean(abs(dblarr_err_teff(indarr_giants)))
    end else if i eq 1 then begin
      print,'Teff: mean(o_dblarr_logg) = ',mean(abs(dblarr_err_logg))
      print,'Teff: mean(o_dblarr_logg(indarr_dwarfs)) = ',mean(abs(dblarr_err_logg(indarr_dwarfs)))
      print,'Teff: mean(o_dblarr_logg(indarr_giants)) = ',mean(abs(dblarr_err_logg(indarr_giants)))
    end else begin
      print,'Teff: mean(o_dblarr_mh) = ',mean(abs(dblarr_err_mh))
      print,'Teff: mean(o_dblarr_mh(indarr_dwarfs)) = ',mean(abs(dblarr_err_mh(indarr_dwarfs)))
      print,'Teff: mean(o_dblarr_mh(indarr_giants)) = ',mean(abs(dblarr_err_mh(indarr_giants)))
    endelse
  endfor
  stop
end
