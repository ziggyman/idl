pro rave_xmatch_to_ruchti

  b_rave_raw = 1; --- 0: calibrated RAVE data
                ; --- 1: raw RAVE data

  if b_rave_raw then begin
;    str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good.dat';rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-flag_STN-gt-20-with-atm-par_no-doubles-within-2-arcsec-maxsnr.dat'
    str_filename_rave = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS_STN-gt-20-with-atm-par.dat'
;'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  end else begin
    str_filename_rave = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-MH-from-FeH-and-aFe-merged.dat';_samplex1_logg_0_errdivby_1.00-1.59-1.53-1.50-1.00-MH-from-FeH-and-aFe.dat'
  endelse
  str_filename_ruchti = '/home/azuri/daten/rave/rave_data/metal-poor_thick_disk/ruchti.dat'

  str_filename_out = '/home/azuri/daten/rave/rave_data/metal-poor_thick_disk/all_found'
;  if b_rave_raw then begin
    str_filename_out = str_filename_out + '_' + strmid(str_filename_rave,strpos(str_filename_rave,'/',/REVERSE_SEARCH)+1)
;  end else begin
;    str_filename_out = str_filename_out + '_calib'
;  endelse
;  str_filename_out = str_filename_out + '.dat'

  int_col_rave_obsid    = 0
  int_col_rave_id       = 1
  int_col_rave_objectid = 2
  int_col_rave_lon      = 5
  int_col_rave_lat      = 6
  int_col_rave_teff     = 19
  int_col_rave_logg     = 20
  int_col_rave_afe      = 22
  int_col_rave_mh       = 24
  if b_rave_raw then $
    int_col_rave_mh     = 21
  int_col_rave_stn      = 35
  int_col_rave_s2n      = 34

  int_col_ruchti_id     = 0
  int_col_ruchti_teff   = 1
  int_col_ruchti_logg   = 2
  int_col_ruchti_feh    = 3
  int_col_ruchti_mgfe   = 5
  int_col_ruchti_sife   = 6
  int_col_ruchti_cafe   = 7
  int_col_ruchti_ti1fe1 = 8
  int_col_ruchti_ti2fe2 = 9

  strarr_data_rave = readfiletostrarr(str_filename_rave,' ',I_NDATALINES = i_ndatalines_rave)
  strarr_data_ruchti = readfiletostrarr(str_filename_ruchti,' ',I_NDATALINES = i_ndatalines_ruchti)

  dblarr_rave_stn = double(strarr_data_rave(*,int_col_rave_stn))
  dblarr_rave_s2n = double(strarr_data_rave(*,int_col_rave_s2n))
  indarr = where(dblarr_rave_stn lt 1., count)
  print,count,' stars without STN'
  if count ge 1 then $
    dblarr_rave_stn(indarr) = dblarr_rave_s2n(indarr)

  ; --- convert Ruchti et al. elemental abundances to [a/Fe] and [M/H]
  dblarr_ruchti_feh = double(strarr_data_ruchti(*,int_col_ruchti_feh))
  dblarr_ruchti_afes = dblarr(i_ndatalines_ruchti,5)
  dblarr_ruchti_afes(*,0) = double(strarr_data_ruchti(*,int_col_ruchti_mgfe))
  dblarr_ruchti_afes(*,1) = double(strarr_data_ruchti(*,int_col_ruchti_sife))
  dblarr_ruchti_afes(*,2) = double(strarr_data_ruchti(*,int_col_ruchti_cafe))
  dblarr_ruchti_afes(*,3) = double(strarr_data_ruchti(*,int_col_ruchti_ti1fe1))
  dblarr_ruchti_afes(*,4) = double(strarr_data_ruchti(*,int_col_ruchti_ti2fe2))

  dblarr_ruchti_afe = dblarr(i_ndatalines_ruchti)
  dblarr_ruchti_mh = dblarr(i_ndatalines_ruchti)

  for i=0ul, i_ndatalines_ruchti-1 do begin
    int_n_afes = 0
    for j=0ul, 4 do begin
      if dblarr_ruchti_afes(i,j) gt -90. then begin
        dblarr_ruchti_afe(i) += dblarr_ruchti_afes(i,j)
        int_n_afes += 1
      endif
    endfor
    dblarr_ruchti_afe(i) = dblarr_ruchti_afe(i) / int_n_afes
  endfor

  ; --- conversion from [Fe/H] and [a/Fe] to [M/H] from Salaris 1993
  dblarr_ruchti_mh = feh_and_afe_to_metallicity(I_DBLARR_FEH = dblarr_ruchti_feh, I_DBLARR_AFE   = dblarr_ruchti_afe)

  ; --- cross-match catalogues and write output file
  openw,lun,str_filename_out,/GET_LUN
  printf,lun,'#0:rave_obsid 1:lon 2:lat 3:ruchti_teff 4:ruchti_logg 5:ruchti_afe 6:ruchti_mh 7:rave_teff 8:rave_logg 9:rave_afe 10:rave_mh 11:rave_stn'
  for i=0ul, i_ndatalines_ruchti-1 do begin
    indarr_found = where((strarr_data_rave(*,int_col_rave_obsid) eq strarr_data_ruchti(i,int_col_ruchti_id)) or (strarr_data_rave(*,int_col_rave_id) eq strarr_data_ruchti(i,int_col_ruchti_id)) or (strarr_data_rave(*,int_col_rave_objectid) eq strarr_data_ruchti(i,int_col_ruchti_id)), count)
    if count eq 0 then begin
      print,'PROBLEM: line = ',i,': Star '+strarr_data_ruchti(i,int_col_ruchti_id)+' not found'
    end else if count gt 1 then begin
      print,'PROBLEM: line = ',i,': Star '+strarr_data_ruchti(i,int_col_ruchti_id)+' found ',count,' times'
      indarr_higher_stn = where(abs(dblarr_rave_stn(indarr_found) - max(dblarr_rave_stn(indarr_found))) lt 0.001)
      indarr_found = indarr_found(indarr_higher_stn)
      count = 1
      print,'chose ',strarr_data_rave(indarr_found,*)
    endif
    if count eq 1 then begin
      str_line = strarr_data_rave(indarr_found,0)
      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_lon)
      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_lat)

      str_line = str_line + ' ' + strarr_data_ruchti(i,int_col_ruchti_teff)
      str_line = str_line + ' ' + strarr_data_ruchti(i,int_col_ruchti_logg)
      str_line = str_line + ' ' + strtrim(string(dblarr_ruchti_afe(i)),2)
      str_line = str_line + ' ' + strtrim(string(dblarr_ruchti_mh(i)),2)

      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_teff)
      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_logg)
      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_afe)
      str_line = str_line + ' ' + strarr_data_rave(indarr_found,int_col_rave_mh)
      str_line = str_line + ' ' + strtrim(string(dblarr_rave_stn(indarr_found)),2)
      printf,lun,str_line
    endif
  endfor
  free_lun,lun

  ; --- clean up
  dblarr_ruchti_afes = 0
  dblarr_ruchti_afe = 0
  dblarr_ruchti_mh = 0
  strarr_data_ruchti = 0
  strarr_data_rave = 0
end
