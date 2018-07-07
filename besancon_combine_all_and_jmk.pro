pro besancon_combine_all_and_jmk,STR_BES_ALL = str_bes_all,$
                                 STR_BES_JMK = str_bes_jmk,$
                                 STR_OUTFILE = str_outfile

  i_col_l = 0
  i_col_b = 1

  if not keyword_set(STR_BES_ALL) then begin
    str_bes_all = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat'
  end
  if not keyword_set(STR_BES_JMK) then begin
    str_bes_jmk = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/besancon_with_extinction_new.dat'
;    str_bes_jmk = '/suphys/azuri/daten/besancon/lon-lat/besancon_230-320_-25-25_JmK_vrad.dat'
  end
  if not keyword_set(STR_OUTFILE) then begin
    str_outfile = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_new.dat'
  end

  strarr_all_lines = readfilelinestoarr(str_bes_all,STR_DONT_READ='#')
  strarr_all = readfiletostrarr(str_bes_all,' ',HEADER=strarr_header)

  dblarr_l = double(strarr_all(*,i_col_l))
  dblarr_b = double(strarr_all(*,i_col_b))

  indarr = where(dblarr_l lt 230. or dblarr_l gt 315. or dblarr_b lt -25. or dblarr_b gt 25.)

  print,'besancon_combine_all_and_JmK: size(indarr) = ',size(indarr)

  openw,lun,str_outfile,/get_lun
    for i=0ul, n_elements(strarr_header)-1 do begin
      printf,lun,strarr_header(i)
    endfor
    for i=0ul, n_elements(indarr)-1 do begin
      printf,lun,strarr_all_lines(indarr(i))
    endfor

    strarr_all_lines = 0
    strarr_all = 0

    strarr_all_lines = readfilelinestoarr(str_bes_jmk,STR_DONT_READ='#')
    strarr_all = readfiletostrarr(str_bes_jmk,' ')

    dblarr_l = double(strarr_all(*,i_col_l))
    dblarr_b = double(strarr_all(*,i_col_b))

    indarr = where(dblarr_l ge 230. and dblarr_l le 315. and dblarr_b ge -25. and dblarr_b le 25.)
    for i=0ul, n_elements(indarr)-1 do begin
      printf,lun,strarr_all_lines(indarr(i))
    endfor
  free_lun,lun
  spawn,'wc '+str_outfile

end
