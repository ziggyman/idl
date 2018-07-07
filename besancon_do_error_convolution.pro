pro besancon_do_error_convolution, IO_STR_FILENAME     = io_str_filename,$
                                   I_DBLARR_ERRDIVBY   = i_dblarr_errdivby,$
                                   I_B_BREDDELS        = i_b_breddels,$
                                   I_STR_FILENAME_DIST = i_str_filename_dist
; NAME:
;       besancon_do_error_convolution
; PURPOSE:
;       convolve all Besancon stellar parameters (vrad, Teff, logg, [M/H]) with the RAVE
;       uncertainties, accounting for the SNR
;
; EXPLANATION:
;       atmospheric parameters:
;       - use besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean.pro
;         to convolve stellar atmospheric parameters with smoothed running mean
;         and standard deviations from the plot dx vs. SNR (after final calibration
;         iteration) to assign an error to the Besancon parameter for each star
;       - error will be interpolated from the two bins closest to the SNR
;       - if SNR lt min(SNR) in I_STR_FILENAME_MEANSIG then first row is used
;       - if SNR gt max(SNR) in I_STR_FILENAME_MEANSIG then last row is used
;       vrad:
;       - use add_noise.pro
;       dist:
;       - use add_noise.pro
;       - i_b_breddels = 0: calculate distance errors for Zwitter distances
;       - i_b_breddels = 1: calculate distance errors for Breddels distances
;
; CALLING SEQUENCE:
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean(,IO_STR_FILENAME = string)(,I_DBLARR_ERRDIVBY = dblarr)(,I_STR_FILENAME_DIST = string)
;
; INPUTS: IO_STR_FILENAME = string: besancon file name
;         I_DBLARR_ERRDIVBY = dblarr(5): 0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
;         I_B_BREDDELS = boolean: Calculate errors for Breddels distances (i_b_breddels = 1) or Zwitter distances (i_b_breddels = 0)
;         I_STR_FILENAME_DIST: string: ONLY VALID if i_b_breddels = 0 (Zwitter distances)
;
; OUTPUTS: IO_STR_FILENAME = io_str_filename_root + '_with-errors' (+'-errdivby-'+)
;
; PRE: rave_compare_to_external_and_calibrate.pro
;      besancon_add_snr.pro
;      (besancon_calculate_mh_from_feh.pro)
;      (besancon_calculate_vrad_from_uvwlb.pro)
;
; POST: rave_besancon_calc_heights.pro
;
; USES: readfiletostrarr.pro
;       add_noise.pro
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean.pro
;
; RESTRICTIONS: -
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2011-04-26
;
; COPYRIGHT: Andreas Ritter
;-------------------------------------------------------------------------
  str_filename_in = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_adj-mh.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_filename_in = io_str_filename
  str_filename_dist_zwitter = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent.dat'
  if keyword_set(I_STR_FILENAME_DIST) then $
    str_filename_dist_zwitter = i_str_filename_dist

  b_breddels = 0
  if keyword_set(I_B_BREDDELS) then $
    b_breddels = 1

  int_col_lon = 0
  int_col_lat = 1
  int_col_imag = 2
  int_col_vjmag = 3
  int_col_kmag = 4
  int_col_teff = 5
  int_col_logg = 6
  int_col_vrad = 7
  int_col_feh = 8
  int_col_dist = 9
  int_col_type = 10
  int_col_age = 11
  int_col_u = 12
  int_col_v = 13
  int_col_w = 14
  int_col_snr = 15
  int_col_height = 16
  int_col_rcent = 17

  dbl_errdivby_vrad = 0
  if keyword_set(I_DBLARR_ERRDIVBY) then begin
    dbl_errdivby_vrad = i_dblarr_errdivby(0)
  end else begin
    i_dblarr_errdivby = [1., 1.59, 1.53, 1.5, 1., 1., 1.38, 1.5, 1.8, 1.];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
    dbl_errdivby_vrad = i_dblarr_errdivby(0)
  endelse

  ; --- read str_filename_in
  strarr_data = readfiletostrarr(str_filename_in,' ',HEADER=strarr_header)

  ; --- vrad
  dblarr_vrad = double(strarr_data(*,int_col_vrad))
  strarr_data = 0
  add_noise,IO_DBLARR_DATA        = dblarr_vrad,$
            I_DBL_SIGMA           = 2.2,$
            IO_DBL_SEED           = dbl_seed,$
            I_DBL_DIVIDE_ERROR_BY = dbl_errdivby_vrad

  dblarr_errdivby = 0
  if n_elements(i_dblarr_errdivby) eq 5 then begin
    dblarr_errdivby = i_dblarr_errdivby(1:3)
  end else if n_elements(i_dblarr_errdivby) eq 10 then begin
    dblarr_errdivby = [i_dblarr_errdivby(1:3),i_dblarr_errdivby(6:8)]
  endif
  besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean, IO_STR_FILENAME   = str_filename_in,$
                                                                                   I_DBLARR_ERRDIVBY = dblarr_errdivby

  ; --- read str_filename_in
  strarr_data = readfiletostrarr(str_filename_in,' ',HEADER=STRARR_HEADER)

  strarr_data(*,int_col_vrad) = strtrim(string(dblarr_vrad),2)

  ; --- calculate distance error
  dbl_seed = 5.
  dblarr_dist = double(strarr_data(*,int_col_dist))
  dbl_errdivby_dist = 0
  if keyword_set(I_DBLARR_ERRDIVBY) then begin
    dbl_errdivby_dist = i_dblarr_errdivby(4)
  endif
  if b_breddels then begin; --- Breddels distances
    add_noise,IO_DBLARR_DATA        = dblarr_dist,$
              IO_DBL_SEED           = dbl_seed,$
              I_B_PERCENT           = 1,$
              I_DBL_PERCENTAGE      = 22.1,$
              I_DBL_DIVIDE_ERROR_BY = dbl_errdivby_dist
    strarr_data(*,int_col_dist) = strtrim(string(dblarr_dist),2)
  end else begin; --- Zwitter distances
;    strarr_temp = strarr(n_elements(strarr_data(*,0)),n_elements(strarr_data(0,*))+2)
;    strarr_temp(0:n_elements(strarr_data(*,0))-1,0:n_elements(strarr_data(0,*))-1) = strarr_data
;    strarr_data = strarr_temp
;    strarr_temp = 0
    int_col_logg_rave   = 19
    strarr_ravedata_dist = readfiletostrarr(str_filename_dist_zwitter,' ')
;    for i=0,2 do begin
;      if i eq 0 then begin
        int_col_dist_rave   = 22
        int_col_edist_rave  = 23
;      end else if i eq 1 then begin
;        int_col_dist_rave   = 24
;        int_col_edist_rave  = 25
;      end else begin
;        int_col_dist_rave   = 26
;        int_col_edist_rave  = 27
;      endelse
      indarr_good = where(double(strarr_ravedata_dist(*,int_col_dist_rave) lt 15.))
      strarr_ravedata_dist = strarr_ravedata_dist(indarr_good,*)
      dblarr_logg_temp = double(strarr_data(*,int_col_logg))
      dblarr_dist_temp = dblarr_dist

      add_noise,IO_DBLARR_DATA        = dblarr_dist_temp,$
                I_DBLARR_LOGG         = dblarr_logg_temp,$
                IO_DBL_SEED           = dbl_seed,$
                I_B_PERCENT           = 1,$
                I_DBLARR_RAVE_LOGG    = double(strarr_ravedata_dist(*,int_col_logg_rave)),$
                I_DBLARR_RAVE_DIST    = double(strarr_ravedata_dist(*,int_col_dist_rave)),$
                I_DBLARR_RAVE_EDIST   = double(strarr_ravedata_dist(*,int_col_edist_rave)),$
                I_DBL_DIVIDE_ERROR_BY = dbl_errdivby_dist
;      if i eq 0 then begin
        strarr_data(*,int_col_dist) = strtrim(string(dblarr_dist_temp),2)
;      end else if i eq 1 then begin
;        strarr_data(n_elements(strarr_data(0,*))-2,int_col_dist) = strtrim(string(dblarr_dist_temp),2)
;      end else begin
;        strarr_data(n_elements(strarr_data(0,*))-1,int_col_dist) = strtrim(string(dblarr_dist_temp),2)
;      endelse
;    endfor
    strarr_ravedata_dist = 0
    dblarr_dist_temp = 0
  endelse
  dblarr_dist = 0
  dblarr_logg_temp = 0

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'with-errors')+11)
  if keyword_set(I_DBLARR_ERRDIVBY) then begin
    str_filename_out = str_filename_out + '_errdivby'
    for i=0,4 do begin
      str_temp = strtrim(string(i_dblarr_errdivby(i)),2)
      str_filename_out = str_filename_out + '-'+strmid(str_temp,0,strpos(str_temp,'.')+3)
    endfor
    if b_breddels then $
      str_filename_out = str_filename_out + '-breddels'
  endif
  str_filename_out = str_filename_out + '-MH-from-FeH-and-aFe.dat'
  write_file, I_STRARR_DATA   = strarr_data,$
              I_STRARR_HEADER = strarr_header,$
              I_STR_FILENAME  = str_filename_out

  ; --- clean up
  strarr_data = 0
end
