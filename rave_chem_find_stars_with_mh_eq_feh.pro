pro rave_chem_find_stars_with_mh_eq_feh
  str_filename_in = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_I2MASS_frac_gt_70.dat'

  strarr_lines = readfilelinestoarr(str_filename_in,STR_DONT_READ='#')
  strarr_data = readfiletostrarr(str_filename_in,' ')

  i_col_chem_mh = 72
  i_col_chem_feh = 68
  i_col_chem_logg = 71
  i_col_chem_teff = 70
  i_col_chem_afe = 73
  i_col_chem_snr = 35

  dblarr_mh = double(strarr_data(*,i_col_chem_mh))
  dblarr_feh = double(strarr_data(*,i_col_chem_feh))
  dblarr_afe = double(strarr_data(*,i_col_chem_afe))

  indarr = where(dblarr_mh lt -2. and dblarr_feh lt -2. and dblarr_mh gt -9. and dblarr_mh lt 8. and abs(dblarr_afe) lt 5.)

  openw,lun,strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_strange.dat',/GET_LUN
    for i=0ul, n_elements(indarr)-1 do begin
      printf,lun,strarr_lines(indarr(i))
    endfor
  free_lun,lun
end