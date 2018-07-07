pro rave_allende_x_hipparcos
  str_allende = '/home/azuri/daten/rave/calibration/allende_prieto.asu'
  str_hipparcos = '/home/azuri/daten/hipparcos/asu.tsv'

  str_out = strmid(str_allende,0,strpos(str_allende,'.',/REVERSE_SEARCH))+'_lon_lat.dat'

  int_col_allende_hip_num = 1
  int_col_allende_teff = 2
  int_col_allende_eteff = 3
  int_col_allende_logg = 4
  int_col_allende_elogg = 5
  int_col_allende_feh = 6

  int_col_hip_lon = 0
  int_col_hip_lat = 1

  strarr_allende = readfiletostrarr(str_allende,';')
  strarr_hipparcos = readfiletostrarr(str_hipparcos,';')

  intarr_hip_num = ulong(strarr_allende(*,int_col_allende_hip_num))

  openw,lun,str_out,/GET_LUN
  printf,lun,'#lon lat Teff eTeff logg elogg feh'
  for i=0ul, n_elements(strarr_allende(*,0))-1 do begin
    str_line = strarr_hipparcos(intarr_hip_num(i), int_col_hip_lon)
    str_line = str_line + ' ' + strarr_hipparcos(intarr_hip_num(i), int_col_hip_lat)
    str_line = str_line + ' ' + strarr_allende(i,int_col_allende_teff)
    str_line = str_line + ' ' + strarr_allende(i,int_col_allende_eteff)
    str_line = str_line + ' ' + strarr_allende(i,int_col_allende_logg)
    str_line = str_line + ' ' + strarr_allende(i,int_col_allende_elogg)
    str_line = str_line + ' ' + strarr_allende(i,int_col_allende_feh)
    printf,lun,str_line
  endfor
  free_lun,lun
end
