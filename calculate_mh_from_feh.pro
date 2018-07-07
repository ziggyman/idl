pro calculate_mh_from_feh,I_STR_FILENAME_CALIB = i_str_filename_calib,$
                          I_DBLARR_FEH         = i_dblarr_feh,$
                          O_DBLARR_MH          = o_dblarr_mh,$
                          I_DBLARR_LOGG        = i_dblarr_logg,$
                          I_DBLARR_TEFF        = i_dblarr_teff
; NAME:
;       besancon_add_snr
; PURPOSE:
;       add SNR to besancondata
;
; EXPLANATION:
;       - randomly selects a RAVE with similar Imag, DEC, (and log g) and
;         adopts its SNR value each star
;
; CALLING SEQUENCE:
;       besancon_add_snr,(I_STR_FILENAME_IN_BES=filename(,I_STR_FILENAME_IN_RAVE=filename(,I_INT_WHICH_GET_SNR=int)))
;
; INPUTS: I_STR_FILEAME_IN_BES - file name Besancon data file
;         I_STR_FILEAME_IN_RAVE - file name RAVE data file
;         I_INT_WHICH_GET_SNR - int 1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
;                                   2 --- besancon_get_snr_i_dec
;                                   3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
;                                   4 --- besancon_get_snr_i_dec_giant_dwarf
;
; OUTPUTS: writes <I_STR_FILENAME_IN_BES_root>+'_+snr-i-dec(-logg/giant-dwarf)(_minus-ic1)'.dat
;                 <I_STR_FILENAME_IN_BES_root>+'_+snr-i-dec(-logg/giant-dwarf)(_minus-ic1)'-gt-20.dat
;
; RESTRICTIONS: -
;
; PRE: -
;
; USES: - readfiletostrarr.pro
;       - euler.pro
;       - besancon_get_snr.pro
;       - besancon_get_snr_i_dec.pro
;       - besancon_get_snr_i_dec_logg.pro
;       - besancon_get_snr_i_dec_giant_dwarf.pro
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2011-04-15
;-------------------------------------------------------------------------
  if not keyword_set(I_STR_FILENAME_CALIB) then $
    i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dwarfs.dat'

  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_feh = ',i_dblarr_feh(0:20)
  o_dblarr_mh = i_dblarr_feh
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_feh
  dblarr_correction = i_dblarr_feh - o_dblarr_mh
  o_dblarr_mh = i_dblarr_feh  + dblarr_correction

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH_vs_Teff_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_teff

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH_vs_logg_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_logg

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH_vs_FeH_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_feh

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH-calib_vs_Teff_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_teff

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH-calib_vs_logg_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_logg

  i_str_filename_calib = '/home/azuri/daten/rave/soubiran2005/mh-from-feh-and-afe/calibration_MH_from_FeH_Soubiran_dMH-calib_vs_FeH_dwarfs.dat'
  ;print,'calculate_mh_from_feh: before ',i_str_filename_calib,': dblarr_mh = ',o_dblarr_mh(0:20)
  rave_calibrate_parameter_values_from_smoothed_mean,I_STR_FILENAME_CALIB       = i_str_filename_calib,$
                                                     IO_DBLARR_PARAMETER_VALUES = o_dblarr_mh,$
                                                     I_DBLARR_X                 = i_dblarr_feh
;stop
end
