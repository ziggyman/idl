pro besancon_calculate_mh_from_feh,IO_STR_FILENAME = io_str_filename,$
                                   I_INT_VERSION   = i_int_version; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
; NAME:
;       besancon_calculate_mh_from_feh
; PURPOSE:
;       calculate [M/H] from Besancon [Fe/H]
;
; EXPLANATION:
;       - int_version = either
;        1 - Zwitter's formula from DR2 paper
;        2 - My version from the chemical pipeline with different constants for
;            dwarfs and giants (uses rave_get_indarrs_dwarfs_and_giants)
;        3 - My version from Soubiran (uses calculate_mh_from_feh.pro)
;
; CALLING SEQUENCE:
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean(,IO_STR_FILENAME=string)(,I_INT_VERSION=int[1,2,3])
;
; INPUTS: IO_STR_FILENAME: string - Besancon data file
;         I_INT_VERSION  : int[1,2,3] - See EXPLANATION
;
; OUTPUTS: IO_STR_FILENAME - output file name
;          writes output file name
;
; PRE: -
;
; POST: -
;
; USES: readfiletostrarr
;       rave_get_indarrs_dwarfs_and_giants (int_version == 2)
;       calculate_mh_from_feh (int_version == 3)
;
; RESTRICTIONS: -
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2011-04-25
;-------------------------------------------------------------------------

  int_version = 3; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
  if keyword_set(I_INT_VERSION) then $
    int_version = i_int_version

  str_filename_in = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_filename_in = io_str_filename

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH)) + '_mh.dat'

  int_col_logg_besancon = 6
  int_col_teff_besancon = 5
  int_col_feh_besancon = 8

;  str_besancondatafile = strmid(besancondatafile,0,strpos(besancondatafile,'/',/REVERSE_SEARCH)+1)+'besancon_temp.dat'
;  spawn,'cp -p '+besancondatafile+' '+str_besancondatafile
;  str_temp = str_besancondatafile
;  str_besancondatafile = besancondatafile
;  besancondatafile = str_temp
;  str_temp = 0
;  print,'rave_besancon_plot_all: besancondatafile = '+besancondatafile

  strarr_besancondata = readfiletostrarr(str_filename_in,$
                                         ' ',$
                                         I_NLINES=i_ndatalines,$
                                         I_NCOLS=i_ncols,$
                                         HEADER=strarr_header)
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end

; --- calculate Besancon Metallicities
  dblarr_besancon_feh = double(strarr_besancondata(*,int_col_feh_besancon))
  dblarr_besancon_logg = double(strarr_besancondata(*,int_col_logg_besancon))
  dblarr_besancon_teff = double(strarr_besancondata(*,int_col_teff_besancon))
  o_dblarr_mh = dblarr(n_elements(dblarr_besancon_feh))

  ; --- if my calibration then do
  if int_version eq 2 then begin
    i_dblarr_coeffs_dwarfs = [0.0031993339,0.76814896,0.026853846];0.0044323194,0.76363177,0.0014614658]
    i_dblarr_coeffs_giants_metal_poor = [1.1273630,2.2794280,0.42460990];0.85477788,1.8355969,0.24523228]
    i_dblarr_coeffs_giants_metal_rich = [0.00091376985,0.89905825,0.17658445];0.00085171117,0.89849126,0.17538845]
    i_dblarr_coeffs_giants_very_metal_rich = [0.0047670650,0.88925742,-0.21106783];0.0047255738,0.88603368,-0.18844158]

    ; --- calculate new calibration from [Fe/H] to [M/H] for giants and dwarfs

    ; --- calculate new calibration from [Fe/H] to [M/H] for giants
    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_besancon_logg,$
                                       O_INDARR_DWARFS  = indarr_dwarfs,$
                                       O_INDARR_GIANTS  = indarr_giants,$
                                       I_DBL_LIMIT_LOGG = 3.5
    print,'number of giants = ',n_elements(indarr_giants)
    print,'number of dwarfs = ',n_elements(indarr_dwarfs)

    ; --- do polynomial fit for giants
    ; --- metal poor stars ([Fe/H] < -1. dex)
    if indarr_giants(0) ge 0 then begin
      indarr_giants_metal_poor = where(dblarr_besancon_feh(indarr_giants) lt -1.)
      print,'number of very metal poor giants = ',n_elements(indarr_giants_metal_poor)
      if indarr_giants_metal_poor(0) ge 0 then begin
        print,'number of very metal poor giants = ',n_elements(indarr_giants_metal_poor)
        for i=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_poor)) $; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    + i_dblarr_coeffs_giants_metal_poor(i) * dblarr_besancon_feh(indarr_giants(indarr_giants_metal_poor))^double(i)
        endfor
      endif

      ; metal rich stars (-1. dex <= [Fe/H] < 0.1 dex)
      indarr_giants_metal_rich = where(dblarr_besancon_feh(indarr_giants) ge -1. and dblarr_besancon_feh(indarr_giants) lt 0.1)
      if indarr_giants_metal_rich(0) ge 0 then begin
        print,'number of metal poor giants = ',n_elements(indarr_giants_metal_rich)
        for i=0, n_elements(i_dblarr_coeffs_giants_metal_rich)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) = o_dblarr_mh(indarr_giants(indarr_giants_metal_rich)) $; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    + i_dblarr_coeffs_giants_metal_rich(i) * dblarr_besancon_feh(indarr_giants(indarr_giants_metal_rich))^double(i)
        endfor
      endif

      ; very metal rich ([Fe/H] > 0.1)
      indarr_giants_very_metal_rich = where(dblarr_besancon_feh(indarr_giants) ge 0.1)
      if indarr_giants_very_metal_rich(0) ge 0 then begin
        print,'number of metal rich giants = ',n_elements(indarr_giants_very_metal_rich)
        for i=0, n_elements(i_dblarr_coeffs_giants_very_metal_rich)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_giants_very_metal_rich)) = o_dblarr_mh(indarr_giants(indarr_giants_very_metal_rich)) +$; --- last value
                                                                  ; --- plus A_i * [Fe/H]_i
                                    i_dblarr_coeffs_giants_very_metal_rich(i) * dblarr_besancon_feh(indarr_giants(indarr_giants_very_metal_rich))^double(i)
        endfor
      endif

      ; --- first connection metal poor <-> metal rich
      dbl_feh_min = -1.1
      dbl_feh_max = -0.9
      indarr_connection = where((dblarr_besancon_feh(indarr_giants) ge dbl_feh_min) and (dblarr_besancon_feh(indarr_giants) le dbl_feh_max))
      print,'number of very metal poor and metal poor giants in first merging area = ',n_elements(indarr_connection)
      if indarr_connection(0) ge 0 then begin
        dblarr_weight_low = (cos((dblarr_besancon_feh(indarr_giants(indarr_connection)) - dbl_feh_min) * !DPI / (dbl_feh_max - dbl_feh_min)) + 1.) / 2.
        dblarr_weight_high = 1. - dblarr_weight_low
        o_dblarr_mh(indarr_giants(indarr_connection)) = 0.
        i_maxind = 10
        if n_elements(indarr_connection) lt 11 then $
          i_maxind = n_elements(indarr_connection)-1
        for j=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          print,' '
          o_dblarr_mh(indarr_giants(indarr_connection)) = o_dblarr_mh(indarr_giants(indarr_connection)) + $
                                                          dblarr_weight_low * (i_dblarr_coeffs_giants_metal_poor(j) *$
                                                                               (dblarr_besancon_feh(indarr_giants(indarr_connection))^double(j))) +$
                                                          dblarr_weight_high * (i_dblarr_coeffs_giants_metal_rich(j) *$
                                                                                (dblarr_besancon_feh(indarr_giants(indarr_connection))^double(j)))
        endfor
      endif

      ; --- second connection metal rich <-> very metal rich
      dbl_feh_min = 0.
      dbl_feh_max = 0.2
      indarr_connection = where((dblarr_besancon_feh(indarr_giants) ge dbl_feh_min) and (dblarr_besancon_feh(indarr_giants) le dbl_feh_max))
      print,'number of metal poor and metal rich giants in second merging area = ',n_elements(indarr_connection)
      if indarr_connection(0) ge 0 then begin
        dblarr_weight_low = (cos((dblarr_besancon_feh(indarr_giants(indarr_connection)) - dbl_feh_min) * !DPI / (dbl_feh_max - dbl_feh_min)) + 1.) / 2.
        dblarr_weight_high = 1. - dblarr_weight_low
        o_dblarr_mh(indarr_giants(indarr_connection)) = 0.
        for j=0, n_elements(i_dblarr_coeffs_giants_metal_poor)-1 do begin
          o_dblarr_mh(indarr_giants(indarr_connection)) = o_dblarr_mh(indarr_giants(indarr_connection)) + $
                                                          dblarr_weight_low * (i_dblarr_coeffs_giants_metal_rich(j) *$
                                                                               dblarr_besancon_feh(indarr_giants(indarr_connection))^double(j)) +$
                                                          dblarr_weight_high * (i_dblarr_coeffs_giants_very_metal_rich(j) *$
                                                                                dblarr_besancon_feh(indarr_giants(indarr_connection))^double(j))
        endfor
      endif

      ; --- clean up
      indarr_connection = 0
      indarr_giants = 0
    endif

    ; --- calculate new calibration from [Fe/H] to [M/H] for dwarfs
    ; --- do polynomial fit for dwarfs
    if indarr_dwarfs(0) ge 0 then begin
      for i=0, n_elements(i_dblarr_coeffs_dwarfs)-1 do begin
        o_dblarr_mh(indarr_dwarfs) = o_dblarr_mh(indarr_dwarfs) +$; --- last value
                                                                ; --- plus A_i
                                     i_dblarr_coeffs_dwarfs(i) * dblarr_besancon_feh(indarr_dwarfs)^double(i)
      endfor
    endif
    ; --- clean up
    indarr_giants = 0
    indarr_giants_metal_poor = 0
    indarr_giants_metal_rich = 0
    indarr_dwarfs = 0
  end else if int_version eq 1 then begin
    ; --- calibration [Fe/H] -> [M/H] from Zwitter DR2 paper

    ; --- constants for transformation from Zwitter DR2
    dbl_fac = 0.11
    dbl_fac_exp = 7.2

    ; --- [Fe/H] < -0.55
    indarr_feh_lt_minus055 = where(dblarr_besancon_feh lt (0.-0.55), COMPLEMENT=indarr_feh_ge_minus055)
    if indarr_feh_lt_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_lt_minus055) = dblarr_besancon_feh(indarr_feh_lt_minus055) + dbl_fac * (1. + (1. - exp(-dbl_fac_exp*abs(dblarr_besancon_feh(indarr_feh_lt_minus055)+0.55))))

    ; --- [Fe/H] >= -0.55
    if indarr_feh_ge_minus055(0) ge 0 then $
      o_dblarr_mh(indarr_feh_ge_minus055) = dblarr_besancon_feh(indarr_feh_ge_minus055) + dbl_fac * (1. - (1. - exp(-dbl_fac_exp*abs(dblarr_besancon_feh(indarr_feh_ge_minus055)+0.55))))
  end else if int_version eq 3 then begin
    calculate_mh_from_feh,I_DBLARR_FEH         = dblarr_besancon_feh,$
                          ;I_STR_FILENAME_CALIB = i_str_filename_calib,$
                          O_DBLARR_MH          = o_dblarr_mh,$
                          I_DBLARR_LOGG        = dblarr_besancon_logg,$
                          I_DBLARR_TEFF        = dblarr_besancon_teff

  endif

  ; --- write outfile
  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, n_elements(strarr_besancondata(*,0))-1 do begin
      str_line = strarr_besancondata(i,0)
      for j=1ul, n_elements(strarr_besancondata(0,*))-1 do begin
        if j eq int_col_feh_besancon then begin
          str_line = str_line + ' ' + strtrim(string(o_dblarr_mh(i)),2)
        endif else begin
          str_line = str_line + ' ' + strarr_besancondata(i,j)
        endelse
      endfor
      printf,lun,str_line
    endfor
  free_lun,lun
  io_str_filename = str_filename_out

  ; --- clean up
  o_dblarr_mh = 0
  dblarr_besancon_logg = 0
  dblarr_besancon_feh = 0
end
