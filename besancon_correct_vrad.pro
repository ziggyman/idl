pro besancon_correct_vrad, IO_STR_FILENAME = io_str_filename
; NAME:
;       besancon_correct_vrad
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
;        - created 2011-04-25
;-------------------------------------------------------------------------

;Here is the transformation applied wrongly on the model on line:
;
;this is a transformation (U1,V1,W1) in the referential of the star towards the (U,V,W) in the LSR.
;(in fortran)
;
;        sinalpha1=rm*sin(xl)*cos(xb)/r
;        sinalpha1=dmax1(sinalpha1,-1.d0)
;        sinalpha1=dmin1(sinalpha1,+1.d0)
;        alpha1=asin(sinalpha1)
;        U = U1 * COS(alpha1) + V1 * SIN(alpha1)
;        V = - U1 * SIN(alpha1)+ V1 * COS(alpha1)
;
;xl=longitude in radians
;xb=latitude in radians
;r=galactocentric distance of the star
;r0=sun-center distance
;rm= distance from the observer to the star
;
;in moup0906:
;
;The transformation which should have been applied:
;       SINGL = RM*COS(XB)*SIN(XL)/R
;       COSGL = (R0-RM*COS(XB)*COS(XL))/R
;       U = U1 * COSGL + V1 * SINGL
;       V = - U1 * SINGL + V1 * COSGL
;
;the difference is only for stars at Rm>R0 (the other side of the GC).
;Not sure this is the reason of the discrepancy...
;
;Annie

  i_col_lon = 5
  i_col_lat = 6
  i_col_dist = 9

  str_besanconfile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snr.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_besanconfile = io_str_filename

  strarr_besancondata = readfiletostrarr(str_besanconfile,' ')

  dblarr_lon = double(strarr_besancondata(*,i_col_lon)
  dblarr_lat = double(strarr_besancondata(*,i_col_lat)

end
