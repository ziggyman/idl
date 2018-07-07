pro rave_check_calib_mh
  str_soubiran_in = '/home/azuri/daten/rave/calibration/rave_soubiran_orig.dat'

  str_filename_calib_in = '/home/azuri/daten/rave/calibration/all_found.dat'
  str_filename_calib_out = '/home/azuri/daten/rave/calibration/all_found_calib.dat'

  str_filename_rave_in = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  str_filename_rave_out = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib.dat'

  strarr_soubiran = readfiletostrarr(str_soubiran_in,' ')

  strarr_calib_in = readfiletostrarr(str_filename_calib_in,' ')
  strarr_calib_out = readfiletostrarr(str_filename_calib_out,' ')

  strarr_rave_in = readfiletostrarr(str_filename_rave_in,' ')
  strarr_rave_out = readfiletostrarr(str_filename_rave_out,' ')

  int_nfound = 0
  for i=0ul, n_elements(strarr_soubiran(*,0))-1 do begin
    str_date = strarr_soubiran(i,16)
    str_field = strarr_soubiran(i,17)
    str_fibre = strarr_soubiran(i,18)
    str_search = str_date+'_'+str_field+'_'+str_fibre
    indarr_found = where(strarr_rave_in(*,2) eq str_search)
    if indarr_found(0) ge 0 then begin
      int_nfound = int_nfound + 1
      print,'star ',int_nfound,' found: str_search = '+str_search
    endif
  endfor

end
