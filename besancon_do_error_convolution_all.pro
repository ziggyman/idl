pro besancon_do_error_convolution_all
; NAME:
;       besancon_do_error_convolution_all
; PURPOSE:
;       convolve all Besancon stellar parameters (vrad, Teff, logg, [M/H]) with the RAVE
;       uncertainties, accounting for the SNR, dividing the errors 1.0, 1.1, 1.2, 1.3, 1.4, 1.5
;
; EXPLANATION:
;       - use besancon_do_error_convolution to calculate errors
;       - b_breddels = 0: calculate distance errors for Zwitter distances
;       - b_breddels = 1: calculate distance errors for Breddels distances
;
; CALLING SEQUENCE:
;       besancon_do_error_convolution_all
;
; INPUTS: -
;
; OUTPUTS: IO_STR_FILENAME = io_str_filename_root + '_with-errors' (+'-errdivby-'+...)+'.dat'
;          IO_STR_FILENAME = io_str_filename_root + '_with-errors' (+'-errdivby-'+...)+'_height_rcent.dat'
;
; PRE: rave_compare_to_external_and_calibrate.pro
;      besancon_add_snr.pro
;      (besancon_calculate_mh_from_feh.pro)
;      (besancon_calculate_vrad_from_uvwlb.pro)
;
; POST: besancon_get_ravesample
;
; USES: besancon_do_error_convolution.pro
;       rave_besancon_calc_heights.pro
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
  str_filename_in = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_filename_in = io_str_filename
  str_filename_dist_zwitter = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2_I2MASS-9ltIlt12-lb_height_rcent.dat'

  b_breddels = 0
  for i=0,0 do begin
    if i eq 1 then $
      b_breddels = 1
    for j=6,7 do begin
      if j eq 0 then begin
        dblarr_errdivby = [1., 1., 1. , 1., 1.];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 1 then begin
        dblarr_errdivby = [1.1, 1.1, 1.1 , 1.1, 1.1];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 2 then begin
        dblarr_errdivby = [1.2, 1.2, 1.2 , 1.2, 1.2];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 3 then begin
        dblarr_errdivby = [1.3, 1.3, 1.3 , 1.3, 1.3];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 4 then begin
        dblarr_errdivby = [1.4, 1.4, 1.4 , 1.4, 1.4];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 5 then begin
        dblarr_errdivby = [1.5, 1.5, 1.5 , 1.5, 1.5];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 6 then begin
        dblarr_errdivby = [1.6, 1.6, 1.6 , 1.6, 1.6];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 7 then begin
        dblarr_errdivby = [1.7, 1.7, 1.7 , 1.7, 1.7];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 8 then begin
        dblarr_errdivby = [1.8, 1.8, 1.8 , 1.8, 1.8];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 9 then begin
        dblarr_errdivby = [1.9, 1.9, 1.9 , 1.9, 1.9];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      end else if j eq 10 then begin
        dblarr_errdivby = [2., 2., 2. , 2., 2.];0: vrad, 1: Teff, 2: log g, 3: [M/H], 4: dist
      endif
      str_filename = str_filename_in
      besancon_do_error_convolution, IO_STR_FILENAME     = str_filename,$
                                     I_DBLARR_ERRDIVBY   = dblarr_errdivby,$
                                     I_B_BREDDELS        = b_breddels,$
                                     I_STR_FILENAME_DIST = str_filename_dist_zwitter
      rave_besancon_calc_heights, I_STR_DATAFILE = str_filename,$
                                  I_INT_I        = 1
    endfor
  endfor
end
