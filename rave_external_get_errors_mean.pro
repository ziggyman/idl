pro rave_external_get_errors_mean
  b_all = 0
  b_pastel = 0
  b_soubiran = 1

  for ii=0,2 do begin
    if ii eq 0 then begin
      str_filename = '/home/azuri/daten/rave/calibration/all_found.dat'
      str_delimiter = ' '
      int_col_logg = 15
      int_col_eteff = 5
      int_col_elogg = 7
      int_col_emh = 9
      b_feh = 0
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
    end else if ii eq 1 then begin
      str_filename = '/home/azuri/daten/pastel/asu.tsv'
      str_delimiter = ';'
      int_col_logg = 13
      int_col_eteff = 12
      int_col_elogg = 14
      int_col_emh = 17
      b_feh = 1
    end else if ii eq 2 then begin
      str_filename = '/home/azuri/daten/rave/calibration/allende_prieto_lon_lat.dat'
      str_delimiter = ' '
      int_col_eteff = 3
      int_col_logg = 4
      int_col_elogg = 5
      int_col_emh = -1
      b_feh = 1
    endif
    strarr_data = readfiletostrarr(str_filename,str_delimiter)
    dblarr_logg = double(strarr_data(*,int_col_logg))
    if ii eq 1 then begin
      indarr_good = where(strarr_data(*,int_col_logg) ne '',COMPLEMENT = indarr_bad)
      print,'PASTEL: n_elements(indarr_no_logg) = ',n_elements(indarr_bad)
      strarr_data = strarr_data(indarr_good,*)
      dblarr_logg = double(strarr_data(*,int_col_logg))
    endif

    if int_col_eteff ge 0 then begin
      dblarr_eteff = double(strarr_data(*,int_col_eteff))
    end else begin
      dblarr_eteff = [-10.,-10.]
    endelse
    if int_col_elogg ge 0 then begin
      dblarr_elogg = double(strarr_data(*,int_col_elogg))
    end else begin
      dblarr_elogg = [-10.,-10.]
    endelse
    if int_col_emh ge 0 then begin
      dblarr_emh = double(strarr_data(*,int_col_emh))
    end else begin
      dblarr_emh = [-10.,-10.]
    endelse

    ; --- dwarfs and giants
    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                      O_INDARR_DWARFS  = o_indarr_dwarfs,$
                                      O_INDARR_GIANTS  = o_indarr_giants,$
                                      I_DBL_LIMIT_LOGG = 3.5

    if ii eq 0 then begin
      ; --- add transformation error to iron abundances
      indarr_emh = where(abs(dblarr_emh) gt 0.00000001)
      indarr_feh = where(long(strarr_data(indarr_emh,10)) eq 1)
      dblarr_emh(indarr_emh(indarr_feh)) += 0.03
    end else if ii eq 1 then begin
      print,' '
      print,'PASTEL:'
    end else if ii eq 2 then begin
      print,' '
      print,'Allende:'
    endif

    for i=0,2 do begin
      print,' '
      if i eq 0 then begin
        indarr_logg = lindgen(n_elements(dblarr_elogg))
        print,'all:'
      end else if i eq 1 then begin
        indarr_logg = o_indarr_dwarfs
        print,'dwarfs:'
      end else begin
        indarr_logg = o_indarr_giants
        print,'giants:'
      endelse

      ; --- remove stars without error estimates
      ; --- Teff
      indarr_eteff = where(abs(dblarr_eteff(indarr_logg)) gt 0.00000001)

      ; --- logg
      indarr_elogg = where(abs(dblarr_elogg(indarr_logg)) gt 0.00000001)

      ; --- [M/H]
      indarr_emh = where(abs(dblarr_emh(indarr_logg)) gt 0.00000001)

      print,'mean(dblarr_eteff) = ',mean(dblarr_eteff(indarr_logg(indarr_eteff)))
      print,'mean(dblarr_elogg) = ',mean(dblarr_elogg(indarr_logg(indarr_elogg)))
      print,'mean(dblarr_emh) = ',mean(dblarr_emh(indarr_logg(indarr_emh)))

    endfor

    ; --- print resulting errors for PASTEL
    if ii eq 0 then begin
      for i=0,2 do begin
        print,' '
        if i eq 0 then begin
          indarr_logg = lindgen(n_elements(dblarr_elogg))
          print,'PASTEL all:'
        end else if i eq 1 then begin
          indarr_logg = o_indarr_dwarfs
          print,'PASTEL dwarfs:'
        end else begin
          indarr_logg = o_indarr_giants
          print,'PASTEL giants:'
        endelse
        indarr_temp = where(long(strarr_data(indarr_logg,21)) eq 1)

        ; --- remove stars without error estimates
        ; --- Teff
        indarr_eteff = where(abs(dblarr_eteff(indarr_logg(indarr_temp))) gt 0.00000001)

        ; --- logg
        indarr_elogg = where(abs(dblarr_elogg(indarr_logg(indarr_temp))) gt 0.00000001)

        ; --- [M/H]
        indarr_emh = where(abs(dblarr_emh(indarr_logg(indarr_temp))) gt 0.00000001)

        print,'mean(dblarr_eteff) = ',mean(dblarr_eteff(indarr_logg(indarr_temp(indarr_eteff))))
        print,'mean(dblarr_elogg) = ',mean(dblarr_elogg(indarr_logg(indarr_temp(indarr_elogg))))
        print,'mean(dblarr_emh) = ',mean(dblarr_emh(indarr_logg(indarr_temp(indarr_emh))))

      endfor
    endif
  endfor
  ; --- clean up
  indarr_logg = 0
  o_indarr_dwarfs = 0
  o_indarr_giants = 0
  indarr_eteff = 0
  indarr_elogg = 0
  indarr_emh = 0
  dblarr_logg = 0
  dblarr_elogg = 0
  dblarr_eteff = 0
  dblarr_emh = 0
end
