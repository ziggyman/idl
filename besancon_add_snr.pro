pro besancon_add_snr,IO_STR_FILENAME_BES    = io_str_filename_bes,$
                     I_STR_FILENAME_IN_RAVE = i_str_filename_in_rave,$
                     I_INT_WHICH_GET_SNR    = i_int_which_get_snr; 1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
                                                                 ; 2 --- besancon_get_snr_i_dec
                                                                 ; 3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
                                                                 ; 4 --- besancon_get_snr_i_dec_giant_dwarf

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
;       besancon_add_snr,(IO_STR_FILENAME_BES=filename(,I_STR_FILENAME_IN_RAVE=filename(,I_INT_WHICH_GET_SNR=int)))
;
; INPUTS: IO_STR_FILEAME_BES    - file name Besancon data file
;         I_STR_FILEAME_IN_RAVE - file name RAVE data file
;         I_INT_WHICH_GET_SNR   - int 1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
;                                   2 --- besancon_get_snr_i_dec
;                                   3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
;                                   4 --- besancon_get_snr_i_dec_giant_dwarf
;
; OUTPUTS: IO_STR_FILENAME_BES - output file name =<IO_STR_FILENAME_BES_root>+'_+snr-i-dec(-logg/giant-dwarf)(_minus-ic1)'.dat
;          writes IO_STR_FILENAME_BES output
;                 <IO_STR_FILENAME_BES_root>+'-ge-20.dat': Besancon stars with SNR lt 20 removed
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

  int_which_get_snr = 4 ;1 --- besancon_get_snr --- NOT IMPLEMENTED ANYMORE
                        ;2 --- besancon_get_snr_i_dec
                        ;3 --- besancon_get_snr_i_dec_logg --- NOT NECESSARY
                        ;4 --- besancon_get_snr_i_dec_giant_dwarf
  if keyword_set(I_INT_WHICH_GET_SNR) then $
    int_which_get_snr = i_int_which_get_snr

  dbl_snr_maxdiff_i = 0.05
  dbl_snr_maxdiff_dec = 2.
  dbl_snr_maxdiff_logg = 0.2

  b_sanjib = 0
  b_corrado = 0
  b_input = 0

  b_lonlat = 1

  i_col_lon_besancon = 0
  i_col_lat_besancon = 1
  i_col_imag_besancon = 2
  i_icol_besancon = 2
  i_col_vjmag_besancon = 3
  i_col_kmag_besancon = 4
  i_col_teff_besancon = 5
  i_col_logg_besancon = 6
  i_col_vrad_besancon = 7
  i_col_feh_besancon = 8
  i_col_dist_besancon = 9
  i_col_type_besancon = 10
  i_col_age_besancon = 11
  i_col_u_besancon = 12
  i_col_v_besancon = 13
  i_col_w_besancon = 14
  i_col_snr_besancon = 15
  i_col_height_besancon = 16
  i_col_rcent_besancon = 17

  if b_sanjib then $
    i_col_snr_besancon = 10
  i_col_height_san = 11
  i_col_rcent_san = 12

  fieldsfile = '/home/azuri/daten/rave/rave_data/fields_lon_lat_small_new-5x5_new.dat'

  if b_input eq 1 then begin
    ravedatafile = '/home/azuri/daten/rave/rave_data/input_catalogue/rave_input_final.dat'
    i_col_rave_ra = 1
    i_col_rave_dec = 2
    i_col_rave_lon = 3
    i_col_rave_lat = 4
    i_col_rave_i = 5
    i_col_rave_j = 6
    i_col_rave_k = 7
  end else begin
    ; --- pre: rave_find_doubles, rave_find_good_stars

    if b_corrado then begin
      ravedatafile = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr_teff-gt-4000_chemsample_logg_0'
    end else begin
      ravedatafile = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib'
    endelse
    ravedatafile = ravedatafile + '.dat'
    i_col_rave_ra       = 3
    i_col_rave_dec      = 4
    i_col_rave_lon      = 5
    i_col_rave_lat      = 6
    i_col_rave_vrad     = 7; --- vrad
    i_col_rave_i        = 14; --- I [mag]
    i_col_rave_teff     = 19; --- Teff [K]
    i_col_rave_mh       = 21; --- [Fe/H]
    i_col_rave_afe      = 22; --- [alpha/Fe]
    i_col_rave_logg     = 20; --- log g
    i_col_rave_id       = 0; --- ID
    i_col_rave_snr      = 33; --- SNR
    i_col_rave_s2n      = 34; --- S2N
    i_col_rave_stn      = 35; --- STN
    if b_corrado then begin
      i_col_rave_mh      = 68; --- [Fe/H]
      i_col_rave_teff    = 70; --- T_eff [K]
      i_col_rave_afe     = 73; --- [alpha/Fe]
      i_col_rave_logg    = 71; --- log g [dex]
    endif
  endelse
  if keyword_set(I_STR_FILENAME_IN_RAVE) then $
    ravedatafile = i_str_filename_in_rave
  if b_sanjib then begin
    besancondatafile = '/home/azuri/daten/besancon/sanjib_mh+snr_with_errors_height_rcent.dat'
  end else begin
    besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh.dat'
    if b_corrado then begin
      besancondatafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_teff-gt-4000.dat'
    endif
  endelse
  if keyword_set(IO_STR_FILENAME_BES) then $
    besancondatafile = io_str_filename_bes
  i_ndatalines = countlines(ravedatafile)
  i_nravelines = i_ndatalines
  print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end

  print,'rave_besancon_plot_all: ravedatafile = ',ravedatafile
  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
  if b_input eq 1 then begin
    strarr_ravedata = strarr(i_ndatalines,6)
  end else begin
    strarr_ravedata = strarr(i_ndatalines,13)
  endelse

  if b_lonlat eq 1 then begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_lon)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_lat)
  end else begin
    strarr_ravedata(*,0) = strarr_ravedata_all(*,i_col_rave_ra)
    strarr_ravedata(*,1) = strarr_ravedata_all(*,i_col_rave_dec)
  endelse
  print,'rave_besancon_plot_all: ravedatafile "'+ravedatafile+'" read'

  strarr_ravedata(*,2) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
  strarr_ravedata(*,3) = strarr_ravedata_all(*,i_col_rave_vrad) ; --- vrad
  strarr_ravedata(*,4) = strarr_ravedata_all(*,i_col_rave_i); --- I [mag]
  strarr_ravedata(*,5) = strarr_ravedata_all(*,i_col_rave_teff) ; --- Teff [K]
  strarr_ravedata(*,6) = strarr_ravedata_all(*,i_col_rave_mh); --- [Fe/H]
  strarr_ravedata(*,7) = strarr_ravedata_all(*,i_col_rave_afe); --- [alpha/Fe]
  strarr_ravedata(*,8) = strarr_ravedata_all(*,i_col_rave_logg); --- log g
  strarr_ravedata(*,9) = strarr_ravedata_all(*,i_col_rave_id); --- ID
  dblarr_rave_stn = double(strarr_ravedata_all(*,i_col_rave_stn))
  dblarr_rave_s2n = double(strarr_ravedata_all(*,i_col_rave_s2n))
  dblarr_rave_snr = double(strarr_ravedata_all(*,i_col_rave_snr))
  indarr_snr_temp = where(dblarr_rave_stn lt 0.1)
  if indarr_snr_temp(0) ge 0 then begin
    dblarr_rave_stn(indarr_snr_temp) = dblarr_rave_s2n(indarr_snr_temp)
  endif
  indarr_snr_temp = where(dblarr_rave_stn lt 0.1)
  if indarr_snr_temp(0) ge 0 then begin
    dblarr_rave_stn(indarr_snr_temp) = dblarr_rave_snr(indarr_snr_temp)
  endif
  strarr_ravedata(*,10) = strtrim(string(dblarr_rave_stn),2); --- SNR
  dblarr_rave_stn = 0
  dblarr_rave_s2n = 0
  dblarr_rave_snr = 0
  indarr_snr_temp = 0

  i_col_lon_rave = 0
  i_col_lat_rave = 1
  i_col_i_rave = 2
  i_col_vrad_rave = 3
  i_col_teff_rave = 5
  i_col_mh_rave = 6
  i_col_afe_rave = 7
  i_col_logg_rave = 8
  i_col_id_rave = 9
  i_col_snr_rave = 10

  strarr_besancondata = readfiletostrarr(besancondatafile,$
                                         ' ',$
                                         I_NLINES=i_ndatalines,$
                                         I_NCOLS=i_ncols,$
                                         HEADER=strarr_header)
  print,'rave_besancon_plot_all: besancondatafile "'+besancondatafile+'" read'
  print,'rave_besancon_plot_all: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end

  dblarr_snr_besancon = dblarr(n_elements(strarr_besancondata(*,0)))

  euler,double(strarr_besancondata(*,i_col_lon_besancon)),double(strarr_besancondata(*,i_col_lat_besancon)),dblarr_ra_besancon,dblarr_dec_besancon,SELECT=2
  dblarr_ra_besancon = 0
  euler,double(strarr_ravedata(*,0)),double(strarr_ravedata(*,1)),dblarr_ra_rave,dblarr_dec_rave,SELECT=2
  dblarr_ra_rave = 0

  if int_which_get_snr eq 1 then begin
    besancon_get_snr,I_STRARR_BESANCONDATA  = strarr_besancondata,$
                     I_STRARR_RAVEDATA      = strarr_ravedata,$
                     I_INT_ICOL_BESANCON    = i_icol_besancon,$
                     I_INT_ICOL_RAVE        = i_col_i_rave,$
                     I_DBLARR_DEC_BESANCON  = dblarr_dec_besancon,$
                     I_DBLARR_DEC_RAVE      = dblarr_dec_rave,$
                     I_INT_SNRCOL_RAVE      = i_col_snr_rave,$
                     O_DBLARR_SNR_BESANCON  = dblarr_snr_besancon,$
                     I_DBL_SEED             = dbl_seed

  end else if int_which_get_snr eq 2 then begin
    besancon_get_snr_i_dec,I_STRARR_BESANCONDATA  = strarr_besancondata,$
                            I_STRARR_RAVEDATA     = strarr_ravedata,$
                            I_INT_COL_I_BESANCON  = i_icol_besancon,$
                            I_INT_COL_I_RAVE      = i_col_i_rave,$
                            I_DBLARR_DEC_BESANCON = dblarr_dec_besancon,$
                            I_DBLARR_DEC_RAVE     = dblarr_dec_rave,$
                            I_INT_COL_SNR_RAVE    = i_col_snr_rave,$
                            O_DBLARR_SNR_BESANCON = dblarr_snr_besancon,$
                            I_DBL_SEED            = dbl_seed,$
                            I_DBL_MAXDIFF_I       = dbl_snr_maxdiff_i,$
                            I_DBL_MAXDIFF_DEC     = dbl_snr_maxdiff_dec
  end else if int_which_get_snr eq 3 then begin
    besancon_get_snr_i_dec_logg,I_STRARR_BESANCONDATA   = strarr_besancondata,$
                                I_STRARR_RAVEDATA       = strarr_ravedata,$
                                I_INT_COL_I_BESANCON    = i_icol_besancon,$
                                I_INT_COL_I_RAVE        = i_col_i_rave,$
                                I_INT_COL_LOGG_BESANCON = i_col_logg_besancon,$
                                I_INT_COL_LOGG_RAVE     = i_col_logg_rave,$
                                I_DBLARR_DEC_BESANCON   = dblarr_dec_besancon,$
                                I_DBLARR_DEC_RAVE       = dblarr_dec_rave,$
                                I_INT_COL_SNR_RAVE      = i_col_snr_rave,$
                                O_DBLARR_SNR_BESANCON   = dblarr_snr_besancon,$
                                I_DBL_SEED              = dbl_seed,$
                                I_DBL_MAXDIFF_I         = dbl_snr_maxdiff_i,$
                                I_DBL_MAXDIFF_DEC       = dbl_snr_maxdiff_dec,$
                                I_DBL_MAXDIFF_LOGG      = dbl_snr_maxdiff_logg
  end else begin
    besancon_get_snr_i_dec_giant_dwarf,I_STRARR_BESANCONDATA   = strarr_besancondata,$
                                       I_STRARR_RAVEDATA       = strarr_ravedata,$
                                       I_INT_COL_I_BESANCON    = i_icol_besancon,$
                                       I_INT_COL_I_RAVE        = i_col_i_rave,$
                                       I_INT_COL_LOGG_BESANCON = i_col_logg_besancon,$
                                       I_INT_COL_LOGG_RAVE     = i_col_logg_rave,$
                                       I_DBLARR_DEC_BESANCON   = dblarr_dec_besancon,$
                                       I_DBLARR_DEC_RAVE       = dblarr_dec_rave,$
                                       I_INT_COL_SNR_RAVE      = i_col_snr_rave,$
                                       O_DBLARR_SNR_BESANCON   = dblarr_snr_besancon,$
                                       I_DBL_SEED              = dbl_seed,$
                                       I_DBL_MAXDIFF_I         = dbl_snr_maxdiff_i,$
                                       I_DBL_MAXDIFF_DEC       = dbl_snr_maxdiff_dec
  endelse
  dblarr_dec_besancon = 0

  i_loop_end = 1
  for iii=0,i_loop_end do begin
    str_snrfilename_out = strmid(besancondatafile,0,strpos(besancondatafile,'.',/REVERSE_SEARCH))+'_+snr'
    if int_which_get_snr eq 1 then begin
      str_snrfilename_out = str_snrfilename_out+'-i'
    end else if int_which_get_snr eq 2 then begin
      str_snrfilename_out = str_snrfilename_out+'-i-dec'
    end else if int_which_get_snr eq 3 then begin
      str_snrfilename_out = str_snrfilename_out+'-i-dec-logg'
    end else begin
      str_snrfilename_out = str_snrfilename_out+'-i-dec-giant-dwarf'
    end
    if (strpos(ravedatafile,'minus-ic1') ge 0) or (strpos(ravedatafile,'minus_ic1') ge 0) then $
      str_snrfilename_out = str_snrfilename_out + '-minus-ic1'
    if iii eq 1 then begin
      str_snrfilename_out = str_snrfilename_out+'-ge-20'
    endif
    str_snrfilename_out = str_snrfilename_out + '.dat'
    if iii eq 0 then $
      io_str_filename_bes = str_snrfilename_out
    openw,lune,str_snrfilename_out,/GET_LUN
      intarr_size = size(strarr_besancondata)
      if n_elements(strarr_header) gt 0 then begin
        for ll = 0ul, n_elements(strarr_header) - 1 do begin
          printf,lune,strarr_header(ll)
        endfor
      endif
      for ll=0ul,intarr_size(1)-1 do begin
        str_line = strarr_besancondata(ll,0)
        for mm=1ul,intarr_size(2)-1 do begin
          str_line = str_line + ' ' + strarr_besancondata(ll,mm)
        endfor
        str_line = str_line + ' ' + string(dblarr_snr_besancon(ll))
        if iii eq 0 or dblarr_snr_besancon(ll) ge 20. then $
          printf,lune,str_line
      endfor
    free_lun,lune
  endfor
end
