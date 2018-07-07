pro rave_combine_calibrations
  str_filename_mh = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe.dat'
  str_filename_cmh = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe.dat'
  str_filename_mh_cmh = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe.dat'

  str_filename_out = strmid(str_filename_mh,0,strpos(str_filename_mh,'-STN-Teff'))+'.dat'

  strarr_mh = readfiletostrarr(str_filename_mh,' ')
  strarr_cmh = readfiletostrarr(str_filename_cmh,' ')
  strarr_mh_cmh = readfiletostrarr(str_filename_mh_cmh,' ')

  strarr_mh_cmh(*,24) = strarr_cmh(*,24)
  strarr_mh_cmh(*,23) = strarr_mh(*,23)

  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, n_elements(strarr_mh(*,0))-1 do begin
      str_line = strarr_mh_cmh(i,0)
      for j=1ul, n_elements(strarr_mh(0,*))-1 do begin
        str_line = str_line + ' ' + strarr_mh_cmh(i,j)
      endfor
      printf,lun,str_line
    endfor
  free_lun,lun

  ; --- clean up
  strarr_mh = 0
  strarr_cmh = 0
  strarr_mh_cmh = 0
end
