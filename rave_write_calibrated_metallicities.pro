pro rave_write_calibrated_metallicities
  str_filename_in = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-13-with-atm-par.dat'
  str_filename_out = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-13-with-atm-par_MH.dat'
  
  strarr_data = readfiletostrarr(str_filename_in,' ')
  dblarr_mh = double(strarr_data(*,21))
  indarr_mh_good = where(dblarr_mh lt 2.)
  strarr_data = strarr_data(indarr_mh_good,*)
  dblarr_mh = double(strarr_data(*,21))
  dblarr_logg = double(strarr_data(*,20))
  dblarr_teff = double(strarr_data(*,19))
  dblarr_stn = double(strarr_data(*,35))
  dblarr_s2n = double(strarr_data(*,34))
  dblarr_snr = double(strarr_data(*,33))
  dblarr_afe = double(strarr_data(*,22))
  
;  indarr_stn_good = where(dblarr_stn gt 10.,COMPLEMENT=indarr_stn_bad)
;  if n_elements(indarr_stn_bad gt 1) then begin
;    dblarr_stn(indarr_stn_bad) = dblarr_s2n(indarr_stn_bad)
;    indarr_stn_good = where(dblarr_stn gt 10.,COMPLEMENT=indarr_stn_bad)
;    if n_elements(indarr_stn_bad gt 1) then begin
;      dblarr_stn(indarr_stn_bad) = dblarr_snr(indarr_stn_bad)
;    endif
;  endif
  
  rave_calibrate_metallicities,I_DBLARR_MH            = dblarr_mh,$
                                 I_DBLARR_AFE           = dblarr_afe,$
                                 I_DBLARR_TEFF          = dblarr_teff,$; --- new calibration
                                 I_DBLARR_LOGG          = dblarr_logg,$; --- old calibration
                                 I_DBLARR_STN           = dblarr_stn,$; --- calibration from DR3 paper
                                 O_STRARR_MH_CALIBRATED = o_strarr_mh_calibrated,$;           --- string array
                                 I_B_SEPARATE           = true
                                 
  strarr_data(*,21) = o_strarr_mh_calibrated
  write_file, I_STRARR_DATA   = strarr_data,$
                I_STR_FILENAME  = str_filename_out
  
end
