pro besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean, IO_STR_FILENAME   = io_str_filename,$
                                                                                     I_DBLARR_ERRDIVBY = i_dblarr_errdivby
; NAME:
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean
; PURPOSE:
;       convolve all Besancon stellar atmospheric parameters with the RAVE
;       uncertainties, accounting for the SNR
;
; EXPLANATION:
;       - use the besancon_convolve_parameter_with_errors_from_smoothed_running_mean.pro
;         to convolve stellar atmospheric parameters with smoothed running mean
;         and standard deviations from the plot dx vs. SNR (after final calibration
;         iteration) to assign an error to the Besancon parameter for each star
;       - error will be interpolated from the two bins closest to the SNR
;       - if SNR lt min(SNR) in I_STR_FILENAME_MEANSIG then first row is used
;       - if SNR gt max(SNR) in I_STR_FILENAME_MEANSIG then last row is used
;
; CALLING SEQUENCE:
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean(,IO_STR_FILENAME = string)(,I_DBLARR_ERRDIVBY = dblarr)
;
; INPUTS: IO_STR_FILENAME = string: besancon file name
;         I_DBLARR_ERRDIVBY = dblarr(3): 0: Teff, 1: log g, 2: [M/H]
;
; OUTPUTS: IO_STR_FILENAME = io_str_filename_root + '_with-errors' (+'-errdivby-'+)
;
; PRE: rave_compare_to_external_and_calibrate.pro
;      besancon_add_snr.pro
;      (besancon_calculate_mh_from_feh.pro)
;
; POST: -
;
; USES: readfiletostrarr.pro
;       besancon_convolve_parameter_with_errors_from_smoothed_running_mean.pro
;
; RESTRICTIONS: -
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2011-04-25
;
; COPYRIGHT: Andreas Ritter
;-------------------------------------------------------------------------

  str_filename_in = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_filename_in = io_str_filename

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_with-errors'
  if keyword_set(I_DBLARR_ERRDIVBY) then begin
    if (n_elements(i_dblarr_errdivby) ne 3) and (n_elements(i_dblarr_errdivby) ne 6) then stop
    str_filename_out = str_filename_out + '_errdivby'
    if n_elements(i_dblarr_errdivby) gt 3 then $
      str_filename_out = str_filename_out + '-dwarfs'
    for i=0,n_elements(i_dblarr_errdivby)-1 do begin
      if i eq 3 then $
        str_filename_out = str_filename_out + '-giants'
      str_filename_out = str_filename_out + '-' + strtrim(string(i_dblarr_errdivby(i)),2)
    endfor
  endif
  str_filename_out = str_filename_out + '.dat'

  b_sanjib = 0
  b_corrado = 0
  b_input = 0

  b_lonlat = 1

  int_col_lon = 0
  int_col_lat = 1
  int_col_imag = 2
  int_col_teff = 5
  int_col_logg = 6
  int_col_vrad = 7
  int_col_mh = 8
  int_col_dist = 9
  int_col_type = 10
  int_col_age = 11
  int_col_snr = 15
  if b_sanjib then $
    int_col_snr = 10

  ; --- read input file
  strarr_data = readfiletostrarr(str_filename_in,$
                                 ' ',$
                                 I_NLINES=i_ndatalines,$
                                 I_NCOLS=i_ncols,$
                                 HEADER=strarr_header)
  if i_ndatalines eq 0 then stop

  dblarr_teff = double(strarr_data(*,int_col_teff))
  dblarr_logg = double(strarr_data(*,int_col_logg))
  dblarr_mh = double(strarr_data(*,int_col_mh))
  dblarr_snr = double(strarr_data(*,int_col_snr))

  ; --- split data into dwarfs and giants
  rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                      O_INDARR_DWARFS  = indarr_dwarfs,$
                                      O_INDARR_GIANTS  = indarr_giants,$
                                      I_DBL_LIMIT_LOGG = 3.5


  ; --- add errors to atmospheric parameters
  dbl_errdivby = 0
  for ii=0,1 do begin
    if ii eq 0 then begin
      indarr_logg = indarr_dwarfs
      b_dwarfs_only = 1
      b_giants_only = 0
    end else begin
      indarr_logg = indarr_giants
      b_dwarfs_only = 0
      b_giants_only = 1
    endelse
    for i=0,2 do begin
      if keyword_set(I_DBLARR_ERRDIVBY) then begin
        if n_elements(i_dblarr_errdivby) eq 3 then begin
          dbl_errdivby = i_dblarr_errdivby(i)
        end else begin
          if b_dwarfs_only then begin
            dbl_errdivby = i_dblarr_errdivby(i)
          end else begin
            dbl_errdivby = i_dblarr_errdivby(i+3)
          endelse
        endelse
      endif
      if i eq 0 then begin; --- Teff
        dblarr_par = 10. ^ dblarr_teff(indarr_logg)
        if b_dwarfs_only then begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-mH_MH-from-FeH-and-aFe/all_found_dTeff_vs_STN_dwarfs_20bins_1smoothings_5_run9_diff_mean_sigma.dat'
        end else begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-mH_MH-from-FeH-and-aFe/all_found_dTeff_vs_STN_giants_17bins_1smoothings_5_run9_diff_mean_sigma.dat'
        endelse
      end else if i eq 1 then begin; --- logg
        dblarr_par = dblarr_logg(indarr_logg)
        if b_dwarfs_only then begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-mH_MH-from-FeH-and-aFe/all_found_dlogg_vs_STN_dwarfs_20bins_1smoothings_5_run9_diff_mean_sigma.dat'
        end else begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-mH-MH_MH-from-FeH-and-aFe/all_found_dlogg_vs_STN_giants_20bins_1smoothings_6_run9_diff_mean_sigma.dat'
        endelse
      end else begin; --- [m/H]
        dblarr_par = dblarr_mh(indarr_logg)
        if b_dwarfs_only then begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-MH_MH-from-FeH-and-aFe/all_found_dMH_vs_STN_dwarfs_20bins_1smoothings_5_run9_diff_mean_sigma.dat'
        end else begin
          str_calibfile = '/home/azuri/daten/rave/calibration/calib-mH_MH-from-FeH-and-aFe/all_found_dMH_vs_STN_giants_20bins_1smoothings_5_run9_diff_mean_sigma.dat'
        endelse
      endelse
      besancon_convolve_parameter_with_errors_from_smoothed_running_mean,IO_DBLARR_PARAMETER    = dblarr_par,$
                                                                        I_DBLARR_SNR           = dblarr_snr(indarr_logg),$
                                                                        I_STR_FILENAME_MEANSIG = str_calibfile,$
                                                                        I_DBL_ERRDIVBY         = dbl_errdivby
      if i eq 0 then begin
        strarr_data(indarr_logg,int_col_teff) = strtrim(string(dblarr_par),2)
      end else if i eq 1 then begin
        strarr_data(indarr_logg,int_col_logg) = strtrim(string(dblarr_par),2)
      end else begin
        strarr_data(indarr_logg,int_col_mh) = strtrim(string(dblarr_par),2)
      endelse
    endfor
  endfor
  write_file, I_STRARR_DATA   = strarr_data,$
              I_STRARR_HEADER = strarr_header,$
              I_STR_FILENAME  = str_filename_out
  io_str_filename = str_filename_out

  ; --- clean up
  dblarr_teff = 0
  dblarr_logg = 0
  dblarr_mh = 0
  dblarr_snr = 0
  strarr_data = 0
  indarr_logg = 0
  indarr_dwarfs = 0
  indarr_giants = 0

end
