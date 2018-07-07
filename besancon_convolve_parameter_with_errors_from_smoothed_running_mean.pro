pro besancon_convolve_parameter_with_errors_from_smoothed_running_mean,IO_DBLARR_PARAMETER    = io_dblarr_parameter,$
                                                                       I_DBLARR_SNR           = i_dblarr_snr,$
                                                                       I_STR_FILENAME_MEANSIG = i_str_filename_meansig,$; --- e.g. all_found_dTeff_vs_STN_dwarfs_20bins_1smoothings_5_run9_diff_mean_sigma.dat
                                                                       I_DBL_ERRDIVBY         = i_dbl_errdivby
; NAME:
;       besancon_convolve_parameter_with_errors_from_smoothed_running_mean
; PURPOSE:
;       convolve one Besancon parameter with the RAVE uncertainties,
;       accounting for the SNR, divided by I_DBL_ERRDIVBY
; EXPLANATION:
;       - use the smoothed running mean and standard deviations from the
;       plot dx vs. SNR (after final calibration iteration) to assign an
;       error to the Besancon parameter for each star
;       - error will be interpolated from the two bins closest to the SNR
;       - if SNR lt min(SNR) in I_STR_FILENAME_MEANSIG then first row is used
;       - if SNR gt max(SNR) in I_STR_FILENAME_MEANSIG then last row is used
;
; CALLING SEQUENCE:
;       besancon_convolve_parameter_with_errors_from_smoothed_running_mean,
;       IO_DBLARR_PARAMETER = io_dblarr_parameter,I_DBLARR_SNR = i_dblarr_snr,
;       I_STR_FILENAME_MEANSIG = i_str_filename_meansig(,I_DBL_ERRDIVBY = i_dbl_errdivby)
;
; INPUTS:
;       IO_DBLARR_PARAMETER, I_DBLARR_SNR - two double vectors with same number of elements
;       I_STR_FILENAME_MEANSIG            - string containing the path and filename of the
;             datafile containing the SNR, running mean, and sigma to be used
;             for the error convolution
;             columns: STN(middle of the bin) mean sigma
;       I_DBL_ERRDIVBY                    - double: divide error by this number
;
; OUTPUTS:
;       IO_DBLARR_PARAMETER
;
; USES:
;
; PRE: rave_compare_to_external_and_calibrate.pro
;
; POST:
;
; RESTRICTIONS:
;
;       IO_DBLARR_PARAMETER and I_DBLARR_SNR must have same number of elements
;
; DEBUG: set b_debug to 1
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2011-04-25
;-------------------------------------------------------------------------

  if n_elements(io_dblarr_parameter) ne n_elements(i_dblarr_snr) then begin
    print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: ERROR: n_elements(io_dblarr_parameter) ne n_elements(i_dblarr_snr) => stopping program'
    stop
  endif

  dbl_seed = 5.
  b_debug = 0

  if b_debug then print,'i_str_filename_meansig = '+i_str_filename_meansig
  dblarr_mean_sigma = double(readfiletostrarr(i_str_filename_meansig,' '))
  if b_debug then print,'dblarr_mean_sigma = ',dblarr_mean_sigma

  for i=0ul, n_elements(io_dblarr_parameter)-1 do begin
    ; --- get bin with SNR lower or equal to dblarr_snr(i)
    ; --- if dblarr_snr(i) lt bin0 then set to 0
    int_bin_a = max(where(dblarr_mean_sigma(*,0) le i_dblarr_snr(i)))
    if int_bin_a lt 0 then $
      int_bin_a = 0
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: int_bin_a = ',int_bin_a

    ; --- get bin with SNR greater than dblarr_snr(i)
    ; --- if dblarr_snr(i) gt highest bin then set to nbins-1
    int_bin_b = min(where(dblarr_mean_sigma(*,0) gt i_dblarr_snr(i)))
    if int_bin_b lt 0 then $
      int_bin_b = n_elements(dblarr_mean_sigma(*,0))-1
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: int_bin_b = ',int_bin_b

    dbl_snr_a = dblarr_mean_sigma(int_bin_a,0)
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: dbl_snr_a  = ',dbl_snr_a
    dbl_snr_b = dblarr_mean_sigma(int_bin_b,0)
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: dbl_snr_b  = ',dbl_snr_b

    ; --- get mean offset
    dbl_mean_a = dblarr_mean_sigma(int_bin_a,1)
    dbl_mean_b = dblarr_mean_sigma(int_bin_b,1)

    dbl_div_by = dbl_snr_b - dbl_snr_a
    if abs(dbl_div_by) lt 0.00000000001 then begin
      dbl_offset = dbl_mean_a
    end else begin
      dbl_offset = dbl_mean_a + (dbl_mean_b - dbl_mean_a) * (i_dblarr_snr(i) - dbl_snr_a) / dbl_div_by
    endelse
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: dbl_offset  = ',dbl_offset

    ; --- get standard deviation
    dbl_sigma_a = dblarr_mean_sigma(int_bin_a,2)
    dbl_sigma_b = dblarr_mean_sigma(int_bin_b,2)
    if abs(dbl_div_by) lt 0.00000000001 then begin
      dbl_sigma = dbl_sigma_a
    end else begin
      dbl_sigma = dbl_sigma_a + (dbl_sigma_b - dbl_sigma_a) * (i_dblarr_snr(i) - dbl_snr_a) / dbl_div_by
    endelse
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: dbl_sigma  = ',dbl_sigma

    ; --- calculate random error from dbl_sigma
    dbl_rand = RANDOMN(dbl_seed)
    dbl_err = dbl_rand * dbl_sigma

    ; divide error by I_DBL_ERRDIVBY
    if keyword_set(I_DBL_ERRDIVBY) then $
      dbl_err = dbl_err / i_dbl_errdivby

    ; --- add offset
    dbl_err = dbl_err + dbl_offset
    if b_debug then print,'besancon_convolve_parameter_with_errors_from_smoothed_running_mean: dbl_err  = ',dbl_err

    ; --- assign error to parameter value
    io_dblarr_parameter(i) = io_dblarr_parameter(i) + dbl_err
    if b_debug then print,' '
  endfor
end
