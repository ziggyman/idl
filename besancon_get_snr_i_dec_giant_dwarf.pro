pro besancon_get_snr_i_dec_giant_dwarf,I_STRARR_BESANCONDATA   = i_strarr_besancondata,$
                                       I_STRARR_RAVEDATA       = i_strarr_ravedata,$
                                       I_INT_COL_I_BESANCON    = i_int_col_i_besancon,$
                                       I_INT_COL_I_RAVE        = i_int_col_i_rave,$
                                       I_INT_COL_LOGG_BESANCON = i_int_col_logg_besancon,$
                                       I_INT_COL_LOGG_RAVE     = i_int_col_logg_rave,$
                                       I_INT_COL_DEC_BESANCON  = i_int_col_dec_besancon,$
                                       I_DBLARR_DEC_BESANCON   = i_dblarr_dec_besancon,$
                                       I_INT_COL_DEC_RAVE      = i_int_col_dec_rave,$
                                       I_DBLARR_DEC_RAVE       = i_dblarr_dec_rave,$
                                       I_INT_COL_SNR_RAVE      = i_int_col_snr_rave,$
                                       O_DBLARR_SNR_BESANCON   = o_dblarr_snr_besancon,$
                                       I_DBL_SEED              = i_dbl_seed,$
                                       I_DBL_MAXDIFF_I         = i_dbl_maxdiff_i,$
                                       I_DBL_MAXDIFF_DEC       = i_dbl_maxdiff_dec
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
;        - created 2010-10-15
;-------------------------------------------------------------------------
  if not keyword_set(DBL_SEED) then i_dbl_seed = 5.
  if not keyword_set(DBL_MAXDIFF_I) then i_dbl_maxdiff_i = 0.05
  if not keyword_set(DBL_MAXDIFF_DEC) then i_dbl_maxdiff_dec = 5.
  if not keyword_set(DBL_MAXDIFF_LOGG) then i_dbl_maxdiff_logg = 0.05

  dblarr_besancondata = double(i_strarr_besancondata)
;  stop
  dblarr_ravedata = double(i_strarr_ravedata)
  print,'besancon_get_snr: i_strarr_besancondata(0:9,*) = ',i_strarr_besancondata(0:9,*)
  print,'besancon_get_snr: dblarr_besancondata(0:9,*) = ',dblarr_besancondata(0:9,*)
  print,' '
  print,' '
  print,' '
  print,' '
  print,'besancon_get_snr: i_strarr_ravedata(0:9,*) = ',i_strarr_ravedata(0:9,*)
  print,'besancon_get_snr: dblarr_ravedata(0:9,*) = ',dblarr_ravedata(0:9,*)

  indarr = where(dblarr_ravedata(*,i_int_col_snr_rave) lt 20.)
  print,'indarr = ',indarr
  if indarr(0) ge 0 then $
    print,dblarr_ravedata(indarr,i_int_col_snr_rave)

  o_dblarr_snr_besancon = dblarr(n_elements(i_strarr_besancondata(*,0)))
  print,size(i_strarr_besancondata)
  print,size(o_dblarr_snr_besancon)

  for i=0ul, n_elements(i_strarr_besancondata(*,0))-1 do begin
    i_run = 0
    while (i_run lt 1000) and (o_dblarr_snr_besancon(i) lt 0.01) do begin
      i_run = i_run + 1
      if double(i_strarr_besancondata(i,i_int_col_logg_besancon)) lt 3.5 then begin
        indarr_giants_dwarfs = where(dblarr_ravedata(*,i_int_col_logg_rave) lt 3.5)
      end else begin
        indarr_giants_dwarfs = where(dblarr_ravedata(*,i_int_col_logg_rave) ge 3.5)
      end
      if keyword_set(I_COL_DEC_RAVE) then begin
        if keyword_set(I_COL_DEC_BESANCON) then begin
          indarr = where((abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_dec_rave) - double(i_strarr_besancondata(i,i_int_col_dec_besancon))) lt i_dbl_maxdiff_dec) and $
                         (abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_i_rave) - double(i_strarr_besancondata(i,i_int_col_i_besancon))) lt i_dbl_maxdiff_i))
        end else begin
          indarr = where((abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_dec_rave) - i_dblarr_dec_besancon(i)) lt i_dbl_maxdiff_dec) and $
                         (abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_i_rave) - double(i_strarr_besancondata(i,i_int_col_i_besancon))) lt i_dbl_maxdiff_i))
        end
      end else begin
        if keyword_set(I_COL_DEC_BESANCON) then begin
          indarr = where((abs(i_dblarr_dec_rave(indarr_giants_dwarfs) - double(i_strarr_besancondata(i,i_int_col_dec_besancon))) lt i_dbl_maxdiff_dec) and $
                          (abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_i_rave) - double(i_strarr_besancondata(i,i_int_col_i_besancon))) lt i_dbl_maxdiff_i))
        end else begin
          indarr = where((abs(i_dblarr_dec_rave(indarr_giants_dwarfs) - i_dblarr_dec_besancon(i)) lt i_dbl_maxdiff_dec) and $
                          (abs(dblarr_ravedata(indarr_giants_dwarfs,i_int_col_i_rave) - double(i_strarr_besancondata(i,i_int_col_i_besancon))) lt i_dbl_maxdiff_i))
        end
      end
      if indarr(0) lt 0 then begin
        o_dblarr_snr_besancon(i) = 0.
        i_run = 1000
        print,'could not assign a SNR to i_strarr_besancondata(i=',i,',*) = ',i_strarr_besancondata(i,*)
      end else begin
        print,'besancon_get_snr: n_elements(indarr) = ',n_elements(indarr)
        if min(dblarr_ravedata(indarr_giants_dwarfs(indarr),i_int_col_snr_rave)) lt 20. then begin
          print,'min(dblarr_ravedata(indarr,i_int_col_snr_rave)) < 20.'
          stop
        end
        dbl_random = randomu(i_dbl_seed)
        i_random = long(dbl_random * double(n_elements(indarr)))
        print,'besancon_get_snr: i_random = ',i_random,', indarr(i_random) = ',indarr(i_random)
        print,'besancon_get_snr: i_int_col_snr_rave = ',i_int_col_snr_rave
        o_dblarr_snr_besancon(i) = dblarr_ravedata(indarr_giants_dwarfs(indarr(i_random)),i_int_col_snr_rave)
        if o_dblarr_snr_besancon(i) lt 20. then stop
      end
    endwhile
    print,'besancon_get_snr: o_dblarr_snr_besancon(i=',i,') = ',o_dblarr_snr_besancon(i)
  endfor
  dblarr_besancondata = 0
  dblarr_ravedata = 0
end
