pro rave_make_datafile_external
  str_rave = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS_STN-gt-20-with-atm-par.dat'
;'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good.dat';_no-doubles-maxsnr.dat'

  b_with_ruchti = 0

  str_soubiran = '/home/azuri/daten/rave/calibration/rave_soubiran_orig.dat';'soubiran2005/soubiran2005.tsv';_found_rave_internal_dr8_all_no_doubles_maxsnr.dat'
  str_pastel = '/home/azuri/daten/pastel/asu.tsv'
  str_echelle = '/home/azuri/daten/rave/calibration/echelle_orig_lon_lat.dat'
;  str_m67 = '/home/azuri/daten/rave/calibration/m67_orig.dat'
;  str_elodie = '/home/azuri/daten/rave/calibration/elodie_orig.dat'
;  str_2_3m = '/home/azuri/daten/rave/calibration/2_3m_orig.dat'
;  str_asiago = '/home/azuri/daten/rave/calibration/asiago_orig1.dat'
;  str_gcs = '/home/azuri/daten/rave/calibration/gcs_orig.dat'
  str_sophie = '/home/azuri/daten/rave/calibration/sophie_orig.dat'
  str_ammons = '/home/azuri/daten/rave/ammons_tycho/all.dat'
  str_katz = '/home/azuri/daten/rave/calibration/katz2011.asu'
  str_katz_elodie = '/home/azuri/daten/rave/calibration/katz2011_elodie.asu'
  str_katz_carelec = '/home/azuri/daten/rave/calibration/katz2011_carelec.asu'
  str_katz_cfht = '/home/azuri/daten/rave/calibration/katz2011_cfht.asu'
  str_allende = '/home/azuri/daten/rave/calibration/allende_prieto_lon_lat.dat'
  str_ruchti = '/home/azuri/daten/rave/rave_data/metal-poor_thick_disk/all_found_raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS_STN-gt-20-with-atm-par.dat';'all_found_rave_internal_dr8_stn_gt_20_good.dat'

  str_filename_check = '/home/azuri/daten/rave/calibration/check_lon_lat.dat'
  openw,lun_check,str_filename_check,/GET_LUN

  str_outfile = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe'
  if b_with_ruchti then $
    str_outfile = str_outfile + '_with-ruchti'
  str_outfile = str_outfile + '.dat'
  openw,lun,str_outfile,/GET_LUN
          ; --- 0: lon,
          ; --- 1: lat,
          ; --- 2: vrad,
          ; --- 3: evrad,
          ; --- 4: Teff,
          ; --- 5: eTeff,
          ; --- 6: logg,
          ; --- 7: elogg,
          ; --- 8: mh,
          ; --- 9: emh,
          ; --- 10: bool_feh,
          ; --- 11: [a/Fe]
          ; --- 12: rave_vrad,
          ; --- 13: rave_teff,
          ; --- 14: rave_eteff,
          ; --- 15: rave_logg,
          ; --- 16: rave_elogg,
          ; --- 17: rave_mh,
          ; --- 18: rave_emh,
          ; --- 19: rave_afe
          ; --- 20: rave_stn,
          ; --- 21: source
          ; --- 22: dist
          ; --- 23: edist
  int_col_lon_out = 0
  int_col_lat_out = 1
  int_col_vrad_out = 2
  int_col_evrad_out = 3
  int_col_teff_out = 4
  int_col_eteff_out = 5
  int_col_logg_out = 6
  int_col_elogg_out = 7
  int_col_mh_out = 8
  int_col_emh_out = 9
  int_col_bool_feh_out = 10
  int_col_afe_out = 11
  int_col_vrad_rave_out = 12
  int_col_teff_rave_out = 13
  int_col_eteff_rave_out = 14
  int_col_logg_rave_out = 15
  int_col_elogg_rave_out = 16
  int_col_mh_rave_out = 17
  int_col_emh_rave_out = 18
  int_col_afe_rave_out = 19
  int_col_stn_rave_out = 20
  int_col_source_out = 21
  int_col_dist_out = 22
  int_col_edist_out = 23

  printf,lun,'#0:lon, 1:lat, 2:vrad, 3:evrad, 4:Teff, 5:eTeff, 6:logg, 7:elogg, 8:mh, 9:emh, 10:bool_feh, 11:[a/Fe], 12:rave_vrad, 13:rave_teff, 14:rave_eteff, 15:rave_logg, 16:rave_elogg, 17:rave_mh, 18:rave_emh, 19:rave_afe, 20:rave_stn, 21:source, 22:dist, 23:edist'

  strarr_filenames = [str_soubiran, str_pastel, str_echelle, str_katz_elodie, str_ruchti];, str_katz_carelec, str_katz_cfht];, str_allende]

  int_col_rave_lon = 5
  int_col_rave_lat = 6
  int_col_rave_imag = 14
  int_col_rave_vrad = 7
  int_col_rave_teff = 19
  int_col_rave_logg = 20
  int_col_rave_mh = 21
  int_col_rave_afe = 22
  int_col_rave_s2n = 34
  int_col_rave_stn = 35

  i_ndatalines = 0
  for i=0,n_elements(strarr_filenames)-1 do begin
    i_ndatalines = i_ndatalines + countdatlines(strarr_filenames(i))
  endfor

  dblarr_data = dblarr(i_ndatalines,23); --- lon, lat, vrad, evrad, Teff, eTeff, logg, elogg, mh, emh, bool_feh, rave_vrad, rave_teff, rave_eteff, rave_logg, rave_elogg, rave_mh, rave_emh, rave_afe, rave_stn, source, dist, edist

  strarr_rave = readfiletostrarr(str_rave, ' ')

  dblarr_stn = double(strarr_rave(*,int_col_rave_stn))
  dblarr_s2n = double(strarr_rave(*,int_col_rave_s2n))
  dblarr_logg_rave = double(strarr_rave(*,int_col_rave_logg))
  indarr = where(dblarr_stn lt 1.)
  if indarr(0) ge 0 then begin
    dblarr_stn(indarr) = dblarr_s2n(indarr)
    strarr_rave(*,int_col_rave_stn) = strtrim(string(dblarr_stn),2)
  endif
  strarr_temp = strarr(n_elements(strarr_rave(*,0)), n_elements(strarr_rave(0,*))+3)
  int_col_rave_eteff = n_elements(strarr_rave(0,*))
  int_col_rave_elogg = n_elements(strarr_rave(0,*))+1
  int_col_rave_emh = n_elements(strarr_rave(0,*))+2
  strarr_temp(*,0:n_elements(strarr_rave(0,*))-1) = strarr_rave
  strarr_rave = strarr_temp
  strarr_temp = 0

;  for i=0,2 do begin
;    if i eq 0 then begin
;      b_teff = 1
;      b_logg = 0
;      b_mh = 0
;      int_col_err = int_col_rave_eteff
;    end else if i eq 1 then begin
;      b_teff = 0
;      b_logg = 1
;      b_mh = 0
;      int_col_err = int_col_rave_elogg
;    end else begin
;      b_teff = 0
;      b_logg = 0
;      b_mh = 1
;      int_col_err = int_col_rave_emh
;    end
;    rave_besancon_calc_errors,B_TEFF        = b_teff,$; --- I: boolean
;                              B_LOGG        = b_logg,$; --- I: boolean
;                              B_MH          = b_mh,$; --- I: boolean
;                              O_DBLARR_DATA = o_dblarr_data,$; --- O: vector(n)
;                              O_DBLARR_ERR  = o_dblarr_err,$; --- O: vector(n)
;                              DBLARR_SNR    = double(strarr_rave(*,int_col_rave_stn)),$; --- I: vector(n)
;                              DBLARR_TEFF   = double(strarr_rave(*,int_col_rave_teff)),$; --- I: vector(n)
;                              DBLARR_MH     = double(strarr_rave(*,int_col_rave_mh)),$;   --- I: vector(n)
;                              DBLARR_LOGG   = double(strarr_rave(*,int_col_rave_logg)),$; --- I: vector(n)
;                              DBL_DIVIDE_ERROR_BY = 1.,$; --- I: dbl
;                              DBL_REJECT    = -99.,$
;                              B_REAL_ERR = 0
;    strarr_rave(*,int_col_err) = o_dblarr_err
;  endfor

  int_line = 0
  i=0

  ; --- plot found stars
  plot,[0,360],$
       [-90.,-90.],$
       xrange = [0.,360.],$
       yrange = [-90.,90.],$
       xtitle = 'Galactic longitude [deg]',$
       ytitle = 'Galactic latitude [deg]'

  ;[str_soubiran, str_pastel, str_echelle, str_katz, str_katz_elodie, str_katz_carelec, str_katz_cfht, str_allende]
  intarr_nfound = ulonarr(n_elements(strarr_filenames))
  intarr_ndwarfs_found = ulonarr(n_elements(strarr_filenames))
  intarr_ngiants_found = ulonarr(n_elements(strarr_filenames))
  intarr_nteffs_dwarfs_found = ulonarr(n_elements(strarr_filenames))
  intarr_nteffs_giants_found = ulonarr(n_elements(strarr_filenames))
  intarr_nloggs_dwarfs_found = ulonarr(n_elements(strarr_filenames))
  intarr_nloggs_giants_found = ulonarr(n_elements(strarr_filenames))
  intarr_nmhs_dwarfs_found = ulonarr(n_elements(strarr_filenames))
  intarr_nmhs_giants_found = ulonarr(n_elements(strarr_filenames))

  i_loop_end = n_elements(strarr_filenames)-1
  if not b_with_ruchti then $
    i_loop_end -= 1

  for i=0, i_loop_end do begin
    if i eq 0 then begin; --- Soubiran & Girard
      b_ra_dec = 1
      str_delimiter = ' '
      int_col_lon = 0
      int_col_lat = 1
      int_col_imag = 0
      b_feh = 0
      int_col_mh = 3
      int_col_emh = -1
      int_col_vrad = -1
      int_col_evrad = -1
      int_col_teff = 12
      b_log_teff = 0
      int_col_afe = 14
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_eteff = -1
      int_col_logg = 13
      int_col_elogg = -1
      int_col_vrad_rave = 19
      int_col_teff_rave = 23
      int_col_logg_rave = 24
      int_col_mh_rave = 25
      int_col_afe_rave = 26
      int_col_stn_rave = 29
      int_col_s2n_rave = -1

      dblarr_s_mh = feh_and_afe_to_metallicity(I_STR_FILENAME=strarr_filenames(i), I_STR_DELIMITER = ' ', I_INT_COL_FEH=3, I_INT_COL_AFE=14);abundances_to_mh(I_STR_FILENAME=strarr_filenames(i))

;      b_ra_dec = 0
;      str_delimiter = ';'
;      int_col_lon = 2
;      int_col_lat = 3
;      int_col_imag = -1
;      b_feh = 1
;      int_col_mh = 6
;      int_col_emh = -1
;      int_col_vrad = -1
;      int_col_evrad = -1
;      int_col_teff = 27
;      b_log_teff = 0
;      int_col_dist = -1
;      int_col_edist = -1
;      int_col_eteff = -1
;      int_col_logg = 28
;      int_col_elogg = -1
;      int_col_vrad_rave = -1
;      int_col_teff_rave = -1
;      int_col_logg_rave = -1
;      int_col_mh_rave = -1
;      int_col_afe_rave = -1
;      int_col_stn_rave = -1
    end else if i eq 1 then begin; --- PASTEL
      str_delimiter = ';'
      b_ra_dec = 0
      int_col_lon = 0
      int_col_lat = 1
      int_col_teff = 18
      int_col_eteff = 19
      b_log_teff = 0
      int_col_dist = -1
      int_col_edist = -1
      int_col_logg = 20
      int_col_elogg = 21
      int_col_mh = 22
      int_col_emh = 24
      b_feh = 1
      int_col_afe = -1
      int_col_eafe = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = -1
      int_col_logg_rave = -1
      int_col_mh_rave = -1
      int_col_afe_rave = -1
      int_col_stn_rave = -1
    end else if i eq 2 then begin; --- Echelle
      str_delimiter = ' '
      b_ra_dec = 0
      int_col_lon = 23
      int_col_lat = 24
      int_col_teff = 7
      b_log_teff = 0
      int_col_eteff = -1
      int_col_logg = 8
      int_col_elogg = -1
      int_col_mh = 9
      int_col_emh = -1
      b_feh = 0
      int_col_afe = 10
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = 16
      int_col_logg_rave = 17
      int_col_mh_rave = 18
      int_col_afe_rave = 19
      int_col_stn_rave = 22
      int_col_s2n_rave = 21
;    end else if i eq 3 then begin; --- GCS
;      str_delimiter = ' '
;      b_ra_dec = 0
;      int_col_lon = -1
;      int_col_lat = -1
;      int_col_teff = 4
;      b_log_teff = 1
;      int_col_eteff = -1
;      int_col_logg = -1
;      int_col_elogg = -1
;      int_col_mh = 5
;      int_col_emh = -1
;      b_feh = 1
;      int_col_dist = -1
;      int_col_edist = -1
;      int_col_vrad_rave = 12
;      int_col_teff_rave = 14
;      int_col_logg_rave = 15
;      int_col_mh_rave = 16
;      int_col_afe_rave = 17
;      int_col_stn_rave = 18
;      int_col_s2n_rave = -1
    end else if i eq 3 then begin; --- Katz
;      str_delimiter = ' '
;      b_ra_dec = 0
;      int_col_lon = 0
;      int_col_lat = 1
;      int_col_teff = 4
;      b_log_teff = 0
;      int_col_eteff = 5
;      int_col_logg = -1
;      int_col_elogg = -1
;      int_col_mh = 8
;      int_col_emh = 9
;      b_feh = 1
;      int_col_dist = 6
;      int_col_edist = 7
;      int_col_vrad_rave = -1
;      int_col_teff_rave = -1
;      int_col_logg_rave = -1
;      int_col_mh_rave = -1
;      int_col_stn_rave = -1
;      int_col_s2n_rave = -1
;    end else if i eq 5 then begin
;      str_delimiter = ';'
;      b_ra_dec = 0
;      int_col_lon = 0
;      int_col_lat = 1
;      int_col_teff = 18
;      b_log_teff = 0
;      int_col_eteff = -1
;      int_col_logg = 19
;      int_col_elogg = -1
;      int_col_mh = 20
;      int_col_emh = -1
;      b_feh = 1
;      int_col_afe = -1
;      int_col_eafe = -1
;      int_col_dist = -1
;      int_col_edist = -1
;      int_col_vrad_rave = -1
;      int_col_teff_rave = -1
;      int_col_logg_rave = -1
;      int_col_mh_rave = -1
;      int_col_stn_rave = -1
;      int_col_s2n_rave = -1
;    end else if i eq 4 then begin; --- Katz Elodie
      str_delimiter = ';'
      b_ra_dec = 0
      int_col_lon = 0
      int_col_lat = 1
      int_col_teff = 6
      b_log_teff = 0
      int_col_eteff = -1
      int_col_logg = 7
      int_col_elogg = -1
      int_col_mh = 8
      int_col_emh = -1
      b_feh = 1
      int_col_afe = -1
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = -1
      int_col_logg_rave = -1
      int_col_mh_rave = -1
      int_col_afe_rave = -1
      int_col_stn_rave = -1
      int_col_s2n_rave = -1
    end else if i eq 4 then begin; --- Ruchti
      str_delimiter = ' '
      b_ra_dec = 0
      int_col_lon = 1
      int_col_lat = 2
      int_col_teff = 3
      b_log_teff = 0
      int_col_eteff = -1
      int_col_logg = 4
      int_col_elogg = -1
      int_col_mh = 6
      int_col_emh = -1
      b_feh = 0
      int_col_afe = 5
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = 7
      int_col_logg_rave = 8
      int_col_mh_rave = 10
      int_col_afe_rave = 9
      int_col_stn_rave = 11
      int_col_s2n_rave = -1
    end else if i eq 5 then begin; --- Katz Carelec
      str_delimiter = ';'
      b_ra_dec = 0
      int_col_lon = 0
      int_col_lat = 1
      int_col_teff = 6
      b_log_teff = 0
      int_col_eteff = -1
      int_col_logg = 7
      int_col_elogg = -1
      int_col_mh = 8
      int_col_emh = -1
      b_feh = 1
      int_col_afe = -1
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = -1
      int_col_logg_rave = -1
      int_col_mh_rave = -1
      int_col_stn_rave = -1
      int_col_s2n_rave = -1
    end else if i eq 6 then begin; --- Katz CFHT
      str_delimiter = ';'
      b_ra_dec = 0
      int_col_lon = 0
      int_col_lat = 1
      int_col_teff = 7
      b_log_teff = 0
      int_col_eteff = -1
      int_col_logg = 8
      int_col_elogg = -1
      int_col_mh = 9
      int_col_emh = -1
      b_feh = 1
      int_col_afe = -1
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = -1
      int_col_logg_rave = -1
      int_col_mh_rave = -1
      int_col_stn_rave = -1
      int_col_s2n_rave = -1
    end else if i eq 7 then begin; --- Allende
      str_delimiter = ' '
      b_ra_dec = 0
      int_col_lon = 0
      int_col_lat = 1
      int_col_teff = 2
      b_log_teff = 0
      int_col_eteff = 3
      int_col_logg = 4
      int_col_elogg = 5
      int_col_mh = -1
      int_col_emh = -1
      b_feh = 1
      int_col_afe = -1
      int_col_eafe = -1
      int_col_dist = -1
      int_col_edist = -1
      int_col_vrad_rave = -1
      int_col_teff_rave = -1
      int_col_logg_rave = -1
      int_col_mh_rave = -1
      int_col_stn_rave = -1
      int_col_s2n_rave = -1
    end

;    if i ne 4 then begin
      ; --- read file
    strarr_data_temp = readfiletostrarr(strarr_filenames(i), str_delimiter)
    if i eq 0 then begin
      strarr_data_temp(*,int_col_mh) = dblarr_s_mh
    endif
;    if i eq 3 then begin
;      print,'GCS: n_elements(strarr_data_temp(*,0)) = ',n_elements(strarr_data_temp(*,0))
;      stop
;    endif

    ; --- convert ra-dec to lon-lat
    if b_ra_dec then begin
      dblarr_ra = double(strarr_data_temp(*,int_col_lon))
      dblarr_dec = double(strarr_data_temp(*,int_col_lat))
      euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,1
      strarr_data_temp(*,int_col_lon) = strtrim(string(dblarr_lon),2)
      strarr_data_temp(*,int_col_lat) = strtrim(string(dblarr_lat),2)
      dblarr_lon = 0
      dblarr_lat = 0
      dblarr_ra = 0
      dblarr_dec = 0
    endif
    dblarr_lon_ext = double(strarr_data_temp(*,int_col_lon))
    dblarr_lat_ext = double(strarr_data_temp(*,int_col_lat))

    dblarr_lon_rave = double(strarr_rave(*,int_col_rave_lon))
    ;print,'dblarr_lon_rave(0:10) = ',dblarr_lon_rave(0:10)
    dblarr_lat_rave = double(strarr_rave(*,int_col_rave_lat))
;    euler,dblarr_lon_rave,dblarr_lat_rave,dblarr_ra,dblarr_dec,2

    ;print,'dblarr_lat_rave(0:10) = ',dblarr_lat_rave(0:10)
;      dblarr_data(int_line + int_nfound,0) = double(strarr_data(*,int_col_vrad))
    int_nfound = 0ul
    indarr_test = lindgen(n_elements(strarr_data_temp(*,0)))
    int_while_run = 0ul
    while indarr_test(0) ge 0 do begin;for j=0ul,n_elements(strarr_data_temp(*,0))-1 do begin
      print,'int_while_run = ',int_while_run
      ; --- 0: lon,
      ; --- 1: lat,
      ; --- 2: vrad,
      ; --- 3: evrad,
      ; --- 4: Teff,
      ; --- 5: eTeff,
      ; --- 6: logg,
      ; --- 7: elogg,
      ; --- 8: mh,
      ; --- 9: emh,
      ; --- 10: bool_feh,
      ; --- 11: [a/Fe]
      ; --- 12: rave_vrad,
      ; --- 13: rave_teff,
      ; --- 14: rave_eteff,
      ; --- 15: rave_logg,
      ; --- 16: rave_elogg,
      ; --- 17: rave_mh,
      ; --- 18: rave_emh,
      ; --- 19: rave_afe
      ; --- 20: rave_stn,
      ; --- 21: source
      ; --- 22: dist
      ; --- 23: edist

;      print,'i = ',i,': int_col_vrad_rave = ',int_col_vrad_rave
;      print,'i = ',i,': int_col_teff_rave = ',int_col_teff_rave
;      print,'i = ',i,': int_col_logg_rave = ',int_col_logg_rave
;      print,'i = ',i,': int_col_mh_rave = ',int_col_mh_rave
      if ((int_col_vrad_rave lt 0) and (int_col_teff_rave lt 0) and (int_col_logg_rave lt 0) and (int_col_mh_rave lt 0) and (int_col_stn_rave lt 0)) then begin
        b_no_rave_data = 1
      end else begin
        b_no_rave_data = 0
      endelse
      ;print,'i = ',i,': b_no_rave_data = ',b_no_rave_data

      if b_no_rave_data then begin
        dbl_lon_ext = double(strarr_data_temp(indarr_test(0),int_col_lon))
        dbl_lat_ext = double(strarr_data_temp(indarr_test(0),int_col_lat))
        ;print,'strarr_data_temp(indarr_test(0)=',indarr_test(0),',*) = ',strarr_data_temp(indarr_test(0),*)
        dist_arcsec, I_DBLARR_RA     = dblarr_lon_rave,$
                     I_DBLARR_DEC    = dblarr_lat_rave,$
                     I_DBL_RA        = dbl_lon_ext,$
                     I_DBL_DEC       = dbl_lat_ext,$
                     I_B_LON_LAT     = 1,$
                     I_B_DEGREES     = 1,$
                     O_DBLARR_DIST   = dblarr_dist_arcsec
        print,'min(dblarr_dist_arcsec) = ',min(dblarr_dist_arcsec)
;dblarr_d_arcsec = sqrt((dblarr_ra * cos(dblarr_dec))^2. + (dblarr_ra * sin(dblarr_dec))^2.) * 240.
        indarr_rave = where(dblarr_dist_arcsec lt 5.);((abs(dblarr_lon_rave - double(strarr_data_temp(indarr_test(0),int_col_lon))) lt 0.0014) and (abs(dblarr_lat_rave - double(strarr_data_temp(indarr_test(0),int_col_lat))) lt 0.0014))
        print,'i = ',i,': int_while_run = ',int_while_run,': indarr_rave = ',indarr_rave
        if indarr_rave(0) ge 0 then begin
          oplot,[dbl_lon_ext,dbl_lon_ext],$
                [dbl_lat_ext,dbl_lat_ext],$
                psym = 2
          oplot,dblarr_lon_rave(indarr_rave),$
                dblarr_lat_rave(indarr_rave),$
                psym=4,$
                symsize = 3.
          dblarr_dist_lon = abs(dblarr_lon_rave(indarr_rave) - dbl_lon_ext)
          dblarr_dist_lat = abs(dblarr_lat_rave(indarr_rave) - dbl_lat_ext)
          if (max(dblarr_dist_lon) gt 0.0014) or (max(dblarr_dist_lat) gt 0.0014) then begin
            for i_rave = 0, n_elements(indarr_rave)-1 do begin
              printf,lun_check,dbl_lon_ext,dbl_lat_ext,dblarr_lon_rave(indarr_rave(i_rave)),dblarr_lat_rave(indarr_rave(i_rave)),dblarr_dist_lon(i_rave),dblarr_dist_lat(i_rave)
            endfor
          endif
        endif
      endif else begin
        indarr_rave = [-1]
      endelse
      indarr_mult = [0]
      if (not(b_no_rave_data)) or (b_no_rave_data and (indarr_rave(0) ge 0)) then begin
        ; --- check for multiple external observations
        dbl_lon_ext = dblarr_lon_ext(indarr_test(0))
        dbl_lat_ext = dblarr_lat_ext(indarr_test(0))
        dist_arcsec, I_DBLARR_RA     = dblarr_lon_ext(indarr_test),$
                     I_DBLARR_DEC    = dblarr_lat_ext(indarr_test),$
                     I_DBL_RA        = dbl_lon_ext,$
                     I_DBL_DEC       = dbl_lat_ext,$
                     I_B_LON_LAT     = 1,$
                     I_B_DEGREES     = 1,$
                     O_DBLARR_DIST   = dblarr_dist_arcsec
        indarr_mult = where(dblarr_dist_arcsec lt 5.)
;        indarr_mult = where((abs(double(strarr_data_temp(indarr_test,int_col_lon)) - double(strarr_data_temp(indarr_test(0),int_col_lon))) lt 0.0014) and (abs(double(strarr_data_temp(indarr_test,int_col_lat)) - double(strarr_data_temp(indarr_test(0),int_col_lat))) lt 0.0014))
        print,'indarr_mult = ',indarr_mult
        intarr_nfound(i) += n_elements(indarr_mult)
        indarr_teffs = where(abs(double(strarr_data_temp(indarr_test(indarr_mult), int_col_teff))) ge 0.000001)
        indarr_loggs = where(abs(double(strarr_data_temp(indarr_test(indarr_mult), int_col_logg))) ge 0.000001)
        indarr_mhs = where(abs(double(strarr_data_temp(indarr_test(indarr_mult), int_col_mh))) ge 0.000001)
        if b_no_rave_data then begin
          if dblarr_logg_rave(indarr_rave(0)) lt 3.5 then begin
            intarr_ngiants_found(i) += n_elements(indarr_mult)
            if indarr_teffs(0) ge 0 then $
              intarr_nteffs_giants_found(i) += n_elements(indarr_teffs)
            if indarr_loggs(0) ge 0 then $
              intarr_nloggs_giants_found(i) += n_elements(indarr_loggs)
            if indarr_mhs(0) ge 0 then $
              intarr_nmhs_giants_found(i) += n_elements(indarr_mhs)
          end else begin
            intarr_ndwarfs_found(i) += n_elements(indarr_mult)
            if indarr_teffs(0) ge 0 then $
              intarr_nteffs_dwarfs_found(i) += n_elements(indarr_teffs)
            if indarr_loggs(0) ge 0 then $
              intarr_nloggs_dwarfs_found(i) += n_elements(indarr_loggs)
            if indarr_mhs(0) ge 0 then $
              intarr_nmhs_dwarfs_found(i) += n_elements(indarr_mhs)
          endelse
        endif
;        if b_no_rave_data then $
;          stop

        ; --- merge multiple external observations
        if b_no_rave_data and (n_elements(indarr_mult) gt 1) then begin
          if int_col_teff ge 0 then begin
            dblarr_teff_temp = double(strarr_data_temp(indarr_test(indarr_mult), int_col_teff))
            indarr_good_temp = where(abs(dblarr_teff_temp) ge 0.000001)
            if indarr_good_temp(0) ge 0 then $
              strarr_data_temp(indarr_test(0),int_col_teff) = strtrim(string(mean(dblarr_teff_temp(indarr_good_temp))),2)
          endif
          if int_col_logg ge 0 then begin
            dblarr_logg_temp = double(strarr_data_temp(indarr_test(indarr_mult), int_col_logg))
            indarr_good_temp = where(abs(dblarr_logg_temp) ge 0.000001)
            if indarr_good_temp(0) ge 0 then $
              strarr_data_temp(indarr_test(0),int_col_logg) = strtrim(string(mean(dblarr_logg_temp(indarr_good_temp))),2)
          endif
          if int_col_mh ge 0 then begin
            dblarr_mh_temp = double(strarr_data_temp(indarr_test(indarr_mult), int_col_mh))
            indarr_good_temp = where(abs(dblarr_mh_temp) ge 0.000001)
            if indarr_good_temp(0) ge 0 then $
              strarr_data_temp(indarr_test(0),int_col_mh) = strtrim(string(mean(dblarr_mh_temp(indarr_good_temp))),2)
          endif
          if int_col_afe ge 0 then begin
            dblarr_afe_temp = double(strarr_data_temp(indarr_test(indarr_mult), int_col_afe))
            indarr_good_temp = where(abs(dblarr_afe_temp) ge 0.000001)
            if indarr_good_temp(0) ge 0 then $
              strarr_data_temp(indarr_test(0),int_col_afe) = strtrim(string(mean(dblarr_afe_temp(indarr_good_temp))),2)
          endif
        endif

        ; --- write external data to dblarr_data
        if b_no_rave_data then begin
          int_nstars = n_elements(indarr_rave)
        end else begin
          int_nstars = n_elements(indarr_mult)
        endelse
        print,'int_nstars = ',int_nstars

        ; --- lon
        if int_col_lon ge 0 then $
          dblarr_data(int_line + int_nfound, int_col_lon_out) = double(strarr_data_temp(indarr_test(0),int_col_lon))

        ; --- lat
        if int_col_lat ge 0 then $
          dblarr_data(int_line + int_nfound, int_col_lat_out) = double(strarr_data_temp(indarr_test(0),int_col_lat))

        ; --- vrad
        if int_col_vrad ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_vrad_out) = double(strarr_data_temp(indarr_test(0),int_col_vrad))
          if (abs(dblarr_data(int_line + int_nfound,int_col_vrad_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_vrad) ne '') then dblarr_data(int_line + int_nfound,int_col_vrad_out) = 0.0001
        endif

        ; --- evrad
        if int_col_evrad ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_evrad_out) = double(strarr_data_temp(indarr_test(0),int_col_evrad))
          if (abs(dblarr_data(int_line + int_nfound,int_col_evrad_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_evrad) ne '') then dblarr_data(int_line + int_nfound,int_col_evrad_out) = 0.0001
        endif

        ; --- Teff
        if int_col_teff ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_teff_out) = double(strarr_data_temp(indarr_test(0),int_col_teff))
          if b_log_teff then begin
            dblarr_data(int_line + int_nfound, int_col_teff_out) = 10. ^ dblarr_data(int_line + int_nfound, int_col_teff_out)
          endif
        endif

        ; --- eteff
        if int_col_eteff ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_eteff_out) = double(strarr_data_temp(indarr_test(0),int_col_eteff))
          if (abs(dblarr_data(int_line + int_nfound, int_col_eteff_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_eteff) ne '') then dblarr_data(int_line + int_nfound, int_col_eteff_out) = 0.0001
        endif

        ; --- logg
        if int_col_logg ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_logg_out) = double(strarr_data_temp(indarr_test(0),int_col_logg))
          if (abs(dblarr_data(int_line + int_nfound, int_col_logg_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_logg) ne '') then dblarr_data(int_line + int_nfound, int_col_logg_out) = 0.0001
        endif

        ; --- elogg
        if int_col_elogg ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_elogg_out) = double(strarr_data_temp(indarr_test(0),int_col_elogg))
          if (abs(dblarr_data(int_line + int_nfound, int_col_elogg_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_elogg) ne '') then dblarr_data(int_line + int_nfound, int_col_elogg_out) = 0.0001
        endif

        ; --- dist
        if int_col_dist ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_dist_out) = double(strarr_data_temp(indarr_test(0),int_col_dist))
          if (abs(dblarr_data(int_line + int_nfound, int_col_dist_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_dist) ne '') then dblarr_data(int_line + int_nfound, int_col_dist_out) = 0.0001
        endif

        ; --- edist
        if int_col_edist ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_edist_out) = double(strarr_data_temp(indarr_test(0),int_col_edist))
          if (abs(dblarr_data(int_line + int_nfound, int_col_edist_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_edist) ne '') then dblarr_data(int_line + int_nfound, int_col_edist_out) = 0.0001
        endif

        ; --- mh
        if int_col_mh ge 0 then begin
          dblarr_data(int_line + int_nfound,  int_col_mh_out) = double(strarr_data_temp(indarr_test(0),int_col_mh))
          if (abs(dblarr_data(int_line + int_nfound, int_col_mh_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_mh) ne '') then dblarr_data(int_line + int_nfound, int_col_mh_out) = 0.0001
        endif

        ; --- emh
        if int_col_emh ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_emh_out) = double(strarr_data_temp(indarr_test(0),int_col_emh))
          if (abs(dblarr_data(int_line + int_nfound, int_col_emh_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_emh) ne '') then dblarr_data(int_line + int_nfound, int_col_emh_out) = 0.0001
        endif

        ; --- b_feh
        if b_feh then $
          dblarr_data(int_line + int_nfound,  int_col_bool_feh_out) = 1

        ; --- aFe
        if int_col_afe ge 0 then begin
          dblarr_data(int_line + int_nfound, int_col_afe_out) = double(strarr_data_temp(indarr_test(0),int_col_afe))
          if (abs(dblarr_data(int_line + int_nfound, int_col_afe_out)) lt 0.00001) and (strarr_data_temp(indarr_test(0), int_col_afe) ne '') then dblarr_data(int_line + int_nfound, int_col_afe_out) = 0.0001
        endif

        ; --- source
        dblarr_data(int_line + int_nfound, int_col_source_out) = double(i)
        print,'dblarr_data(int_line + int_nfound,*) = ',dblarr_data(int_line + int_nfound,*)
        ;stop
        ; --- no RAVE data in data file => compare to RAVE data file
        if b_no_rave_data and (int_col_lon ge 0) then begin
          if indarr_rave(0) ge 0 then begin
            int_nstars = n_elements(indarr_rave)
            print,'i=',i,': found star ',int_nfound
            ; --- 1 RAVE star
            if n_elements(indarr_rave) eq 1 then begin
              dblarr_data(int_line + int_nfound, int_col_vrad_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_vrad))
              dblarr_data(int_line + int_nfound, int_col_teff_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_teff))
              dblarr_data(int_line + int_nfound, int_col_eteff_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_eteff))
              dblarr_data(int_line + int_nfound, int_col_logg_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_logg))
              dblarr_data(int_line + int_nfound, int_col_elogg_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_elogg))
              dblarr_data(int_line + int_nfound, int_col_mh_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_mh))
              dblarr_data(int_line + int_nfound, int_col_emh_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_emh))
              dblarr_data(int_line + int_nfound, int_col_afe_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_afe))
              dblarr_data(int_line + int_nfound, int_col_stn_rave_out) = double(strarr_rave(indarr_rave(0),int_col_rave_stn))
            end else begin; --- multiple RAVE observations
              dblarr_data(int_line + int_nfound, int_col_vrad_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_vrad)))
              dblarr_data(int_line + int_nfound, int_col_teff_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_teff)))
              dblarr_data(int_line + int_nfound, int_col_eteff_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_eteff)))
              dblarr_data(int_line + int_nfound, int_col_logg_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_logg)))
              dblarr_data(int_line + int_nfound, int_col_elogg_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_elogg)))
              dblarr_data(int_line + int_nfound, int_col_mh_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_mh)))
              dblarr_data(int_line + int_nfound, int_col_emh_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_emh)))
              dblarr_data(int_line + int_nfound, int_col_afe_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_afe)))
              dblarr_data(int_line + int_nfound, int_col_stn_rave_out) = mean(double(strarr_rave(indarr_rave,int_col_rave_stn)))
            endelse
          endif; --- indarr_rave(0) ge 0
        endif else begin; --- RAVE stars in external data file

          ; --- multiple observations
;          if n_elements(indarr_mult) gt 1 then begin

            ; --- vrad
            if int_col_vrad_rave ge 0 then begin
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_vrad_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_vrad_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_vrad_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_vrad_rave))
              endelse
              if abs(dblarr_data(int_line + int_nfound, int_col_vrad_rave_out)) lt 0.00001 then $
                dblarr_data(int_line + int_nfound, int_col_vrad_rave_out) = 0.0001
            endif

            ; --- teff
            if int_col_teff_rave ge 0 then begin
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_teff_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_teff_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_teff_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_teff_rave))
              endelse
            endif

            ; --- logg
            if int_col_logg_rave ge 0 then begin
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_logg_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_logg_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_logg_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_logg_rave))
              endelse
              if abs(dblarr_data(int_line + int_nfound, int_col_logg_rave_out)) lt 0.00001 then $
              dblarr_data(int_line + int_nfound, int_col_logg_rave_out) = 0.0001
            endif

            ; --- mh
            if int_col_mh_rave ge 0 then begin
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_mh_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_mh_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_mh_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_mh_rave))
              endelse
              if abs(dblarr_data(int_line + int_nfound, int_col_mh_rave_out)) lt 0.00001 then $
                dblarr_data(int_line + int_nfound, int_col_mh_rave_out) = 0.0001
            endif

            ; --- aFe
            if int_col_afe_rave ge 0 then begin
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_afe_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_afe_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_afe_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_afe_rave))
              endelse
              if abs(dblarr_data(int_line + int_nfound, int_col_afe_rave_out)) lt 0.00001 then $
                dblarr_data(int_line + int_nfound, int_col_afe_rave_out) = 0.0001
            endif

            ; --- STN
            if int_col_stn_rave ge 0 then begin
              if int_col_s2n_rave ge 0 then begin
                dblarr_stn = double(strarr_data_temp(indarr_test(indarr_mult),int_col_stn_rave))
                dblarr_s2n = double(strarr_data_temp(indarr_test(indarr_mult),int_col_s2n_rave))
                indarr = where(dblarr_stn lt 1.)
                if indarr(0) ge 0 then begin
                  dblarr_stn(indarr) = dblarr_s2n(indarr)
                  strarr_data_temp(indarr_test(indarr_mult),int_col_stn_rave) = strtrim(string(dblarr_stn),2)
                endif
              endif
              if n_elements(indarr_mult) gt 1 then begin
                dblarr_data(int_line + int_nfound, int_col_stn_rave_out) = mean(double(strarr_data_temp(indarr_test(indarr_mult),int_col_stn_rave)))
              end else begin
                dblarr_data(int_line + int_nfound, int_col_stn_rave_out) = double(strarr_data_temp(indarr_test(indarr_mult),int_col_stn_rave))
              endelse
            endif
        endelse; --- RAVE parameters in external data file

      endif; --- if (b_no_rave_data or (indarr_rave(0) ge 0))
      print,'strarr_data_temp(indarr_test(indarr_mult),*) = ',strarr_data_temp(indarr_test(indarr_mult),*)
      print,'dblarr_data(int_line + int_nfound:int_line+int_nfound+n_elements(indarr_mult)-1,*) = ',dblarr_data(int_line + int_nfound:int_line+int_nfound+n_elements(indarr_mult)-1,*)
      ;print,'indarr_test = ',indarr_test
      print,'indarr_test(indarr_mult) = ',indarr_test(indarr_mult)
      print,'int_nfound = ',int_nfound
      ;stop
      ; --- remove star from array
      remove_subarr_from_array,indarr_test,indarr_test(indarr_mult)
      ;print,'indarr_test = ',indarr_test
      int_while_run = int_while_run + 1
      if b_no_rave_data then begin
        if indarr_rave(0) ge 0 then $
          int_nfound = int_nfound + 1;n_elements(indarr_rave);n_elements(indarr_lat)
      end else begin
        int_nfound = int_nfound + 1;n_elements(indarr_mult)
      endelse
    endwhile

    if int_nfound gt 0 then $
      print,'rave_make_datafile_external: dblarr_data(int_line=',int_line,':int_line+int_nfound=',int_nfound,'-1,*) = ',dblarr_data(int_line:int_line+int_nfound-1,*)
;    stop
;        if i eq 0 then stop
    int_line = int_line + int_nfound
    print,'i=',i,': int_line = ',int_line
    ;endif
  endfor
  dblarr_data = dblarr_data(0:int_line-1,*)
  ; --- calculate RAVE errors
    ;if ((int_col_vrad_rave ge 0) or (int_col_teff_rave ge 0) or (int_col_logg_rave ge 0) or (int_col_mh_rave ge 0) or (int_col_stn_rave ge 0)) and (int_col_lon ge 0) then begin
  for iii=0,2 do begin
    if iii eq 0 then begin
      b_teff = 1
      b_logg = 0
      b_mh = 0
      int_col_err =  int_col_eteff_rave_out
    end else if iii eq 1 then begin
      b_teff = 0
      b_logg = 1
      b_mh = 0
      int_col_err =  int_col_elogg_rave_out
    end else begin
      b_teff = 0
      b_logg = 0
      b_mh = 1
      int_col_err = int_col_emh_rave_out
    end
    rave_besancon_calc_errors,B_TEFF        = b_teff,$; --- I: boolean
                              B_LOGG        = b_logg,$; --- I: boolean
                              B_MH          = b_mh,$; --- I: boolean
                              O_DBLARR_DATA = o_dblarr_data,$; --- O: vector(n)
                              O_DBLARR_ERR  = o_dblarr_err,$; --- O: vector(n)
                              DBLARR_SNR    = dblarr_data(*, int_col_stn_rave_out),$; --- I: vector(n)
                              DBLARR_TEFF   = dblarr_data(*, int_col_teff_rave_out),$; --- I: vector(n)
                              DBLARR_MH     = dblarr_data(*, int_col_mh_rave_out),$;   --- I: vector(n)
                              DBLARR_LOGG   = dblarr_data(*, int_col_logg_rave_out),$; --- I: vector(n)
                              DBL_DIVIDE_ERROR_BY = 1.,$; --- I: dbl
                              DBL_REJECT    = -9999.,$
                              B_REAL_ERR = 0
    dblarr_data(*,int_col_err) = o_dblarr_err

  endfor

  ; --- add errors for Soubiran & Girard stars
  indarr = where(long(dblarr_data(*, int_col_source_out)) eq 0)
  dblarr_data(indarr,5) = 82.
  dblarr_data(indarr,9) = 0.057

  ; --- add errors for Echelle stars
  indarr = where(long(dblarr_data(*, int_col_source_out)) eq 2)
  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_data(indarr,6),$
                                     O_INDARR_DWARFS  = indarr_dwarfs,$
                                     O_INDARR_GIANTS  = indarr_giants,$
                                     I_DBL_LIMIT_LOGG = 3.5
  dblarr_data(indarr, int_col_eteff_out) = 60.
  dblarr_data(indarr(indarr_dwarfs), int_col_elogg_out) = 0.065
  dblarr_data(indarr(indarr_giants), int_col_elogg_out) = 0.14
  dblarr_data(indarr(indarr_dwarfs), int_col_emh_out) = 0.05
  dblarr_data(indarr(indarr_giants), int_col_emh_out) = 0.08

  print,'rave_make_datafile_external: dblarr_data = ',dblarr_data
;  stop
  for j=0, n_elements(dblarr_data(*,0))-1 do begin
    str_line = strtrim(string(dblarr_data(j,0)),2)
    for jj=1, n_elements(dblarr_data(0,*))-1 do begin
      str_line = str_line + ' ' + strtrim(string(dblarr_data(j,jj)),2)
    endfor
    printf,lun,str_line
  endfor
  free_lun,lun
  for i=0,n_elements(strarr_filenames)-1 do begin
    indarr = where(long(dblarr_data(*, int_col_source_out)) eq i)
    print,'i=',i,': ',n_elements(indarr),' stars found'
    print,'i=',i,': ',intarr_nfound(i),' observations'
    print,'i=',i,': ',intarr_ndwarfs_found(i),' dwarf observations'
    print,'i=',i,': ',intarr_ngiants_found(i),' giant observations'
    if indarr(0) ge 0 then begin
      rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_data(indarr, int_col_logg_rave_out),$
                                        O_INDARR_DWARFS  = o_indarr_dwarfs,$
                                        O_INDARR_GIANTS  = o_indarr_giants,$
                                        I_DBL_LIMIT_LOGG = 3.5
      if o_indarr_dwarfs(0) ge 0 then begin
        print,'i=',i,': ',n_elements(o_indarr_dwarfs),' dwarfs'
        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_dwarfs), int_col_teff_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' Teffs from ',intarr_nteffs_dwarfs_found(i),' observations'

        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_dwarfs), int_col_logg_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' log gs from ',intarr_nloggs_dwarfs_found(i),' observations'

        indarr_logg = where(abs(dblarr_data(indarr(o_indarr_dwarfs(indarr_teff)), int_col_logg_out)) lt 3.5)
        if indarr_logg(0) ge 0 then begin
          print,'i=',i,': ',n_elements(indarr_logg),' are actually giants'
          print,'dblarr_data(indarr(o_indarr_dwarfs(indarr_logg)),int_col_logg_out) = ',dblarr_data(indarr(o_indarr_dwarfs(indarr_teff(indarr_logg))),int_col_logg_out)
          print,'dblarr_data(indarr(o_indarr_dwarfs(indarr_logg)),*) = ',dblarr_data(indarr(o_indarr_dwarfs(indarr_teff(indarr_logg))),*)
        endif

        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_dwarfs), int_col_mh_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' [M/H]s from ',intarr_nmhs_dwarfs_found(i),' observations'

        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_dwarfs), int_col_afe_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' [a/Fe]s'
      endif
      if o_indarr_giants(0) ge 0 then begin
        print,'i=',i,': ',n_elements(o_indarr_giants),' giants'
        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_giants), int_col_teff_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' Teffs from ',intarr_nteffs_giants_found(i),' observations'
        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_giants), int_col_logg_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' log gs from ',intarr_nloggs_giants_found(i),' observations'
        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_giants), int_col_mh_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' [M/H]s from ',intarr_nmhs_giants_found(i),' observations'
        indarr_teff = where(abs(dblarr_data(indarr(o_indarr_giants), int_col_afe_out)) ge 0.000001)
        if indarr_teff(0) ge 0 then $
          print,'i=',i,': ',n_elements(indarr_teff),' [a/Fe]s'
      endif
    endif
  endfor
  free_lun,lun_check

end
