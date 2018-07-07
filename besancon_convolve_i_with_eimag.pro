pro besancon_convolve_i_with_eimag
  str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_good_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_13.dat'
  str_filename_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK.dat'

  str_filename_out = strmid(str_filename_besancon,0,strpos(str_filename_besancon,'.',/REVERSE_SEARCH))+'_eI.dat'

  strarr_rave = readfiletostrarr(str_filename_rave,' ')
  strarr_besancon = readfiletostrarr(str_filename_besancon,' ')

  dblarr_besancon_i = double(strarr_besancon(*,2))

  dblarr_rave_i = double(strarr_rave(*,14))
  dblarr_rave_ei = double(strarr_rave(*,15))

  dbl_seed = 99.
  dbl_seed_err = 5.

  for i=0ul, n_elements(dblarr_besancon_i)-1 do begin
    indarr = where(abs(dblarr_rave_i - dblarr_besancon_i(i)) lt 0.005)
    if indarr(0) lt 0 then begin
      print,'ERROR: dblarr_besancon_i(i=',i,') = ',dblarr_besancon_i(i),' not found in RAVE data'
    end
    ind_sigma_err = long(randomu(dbl_seed) * n_elements(indarr))
    dbl_err = randomn(dbl_seed_err) * dblarr_rave_ei(ind_sigma_err)
    dblarr_besancon_i(i) = dblarr_besancon_i(i) + dbl_err
    print,'i=',i,': strarr_besancon(i,2) = ',strarr_besancon(i,2),' ind_sigma_err = ',ind_sigma_err,', dblarr_rave_ei(ind_sigma_err) = ',dblarr_rave_ei(ind_sigma_err),' dbl_err = ',dbl_err,', dblarr_besancon_i(i) = ',dblarr_besancon_i(i)
    strarr_besancon(i,2) = string(dblarr_besancon_i(i))
  endfor
  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, n_elements(dblarr_besancon_i)-1 do begin
      str_line = strarr_besancon(i,0)
      for j=1, n_elements(strarr_besancon(0,*))-1 do begin
        str_line = str_line + ' '+strarr_besancon(i,j)
      endfor
      printf,lun,str_line
    endfor
  free_lun,lun
  print,str_filename_out,' written'
end
