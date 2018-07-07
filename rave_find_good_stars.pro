pro rave_find_good_stars

  b_dist = 0
  b_chem = 0
  i_release = 10
  dbl_min_snr = 20.;13.;20.
  delimiter = ' '

  if b_dist then begin
    str_ravedatafile = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr.dat'
    i_col_stn = 21
    i_col_s2n = 21
    i_col_snratio = 21
  end else begin
    if i_release eq 7 then begin
      str_ravedatafile = '/suphys/azuri/daten/rave/rave_data/release7/rave_internal_290110_no_doubles_maxsnr.dat'
      i_col_stn = 34
      i_col_s2n = 33
      i_col_snratio = 32
    end else if i_release eq 8 then begin
      if b_chem then begin
        str_ravedatafile = '/suphys/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat'
      end else begin
        str_ravedatafile = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-flag.dat';rave_internal_dr8_all_no_doubles_maxsnr.dat';rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good.dat'
      endelse
      i_col_stn = 35
      i_col_s2n = 34
      i_col_snratio = 33
      i_col_logg = 20
    end else if i_release eq 9 then begin
      str_ravedatafile = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111.dat'
      ;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12.dat'
      i_col_stn = 35
      i_col_s2n = 34
      i_col_snratio = 33
      i_col_logg = 20
    end else if i_release eq 10 then begin
      str_ravedatafile = '/home/azuri/daten/rave/rave_data/release10/raveinternal_VDR3_20120515_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12.dat'
      ;'/home/azuri/daten/rave/rave_data/release10/raveinternal_VDR3_20120515.csv'
      i_col_stn = 35
      i_col_s2n = 34
      i_col_snratio = 33
      i_col_logg = 20
      delimiter = ';'
    end
  endelse
  str_min_snr = strtrim(string(dbl_min_snr),2)
  str_min_snr = strmid(str_min_snr,0,strpos(str_min_snr,'.'))
  str_ravedatafile_out = strmid(str_ravedatafile,0,strpos(str_ravedatafile,'.',/REVERSE_SEARCH))+'_STN-gt-'+str_min_snr+'-with-atm-par.dat'
;  str_ravedatafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles.dat'
;  str_ravedatafile_out = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles_SNR_gt_20.dat'
;  i_col = 31
  strarr_ravedata_lines = readfilelinestoarr(str_ravedatafile,STR_DONT_READ='#')
  strarr_ravedata = readfiletostrarr(str_ravedatafile,delimiter)
  dblarr_rave_logg = double(strarr_ravedata(*,i_col_logg))
  dblarr_rave_sn = double(strarr_ravedata(*,i_col_stn))
  dblarr_rave_snr_temp = double(strarr_ravedata(*,i_col_s2n))
  indarr_snr = where(abs(dblarr_rave_sn) lt 0.1)
  if indarr_snr(0) gt 0 then $
    dblarr_rave_sn(indarr_snr) = dblarr_rave_snr_temp(indarr_snr)
  dblarr_rave_snr_temp = double(strarr_ravedata(*,i_col_snratio))
  indarr_snr = where(abs(dblarr_rave_sn) lt 0.1)
  if indarr_snr(0) gt 0 then $
    dblarr_rave_sn(indarr_snr) = dblarr_rave_snr_temp(indarr_snr)
  indarr_snr = 0
  dblarr_rave_snr_temp = 0
  print,'rave_find_good_stars: dblarr_rave_sn = ',dblarr_rave_sn
  if b_dist then begin
    indarr = where(dblarr_rave_sn ge dbl_min_snr); or dblarr_rave_sn lt 0.00000001)
  end else begin
    indarr = where((dblarr_rave_sn ge dbl_min_snr) and (dblarr_rave_logg le 10.)); or dblarr_rave_sn lt 0.00000001)); and strarr_ravedata(*,66) eq '')
  endelse

  openw,lun,str_ravedatafile_out,/GET_LUN
    for i=0UL, n_elements(indarr) - 1 do begin
      print,'rave_find_good_stars: printing star i=',i;+strarr_ravedata_lines(indarr(i))
      printf,lun,strarr_ravedata_lines(indarr(i))
    endfor
  free_lun,lun

  print,'str_ravedatafile_out = <'+str_ravedatafile_out+'> ready'
end
