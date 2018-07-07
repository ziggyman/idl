pro rave_calib_echelle_get_lon_lat
  str_file_echelle = '/home/azuri/daten/rave/calibration/echelle_orig.dat'
  str_file_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all.dat'

  str_file_out = strmid(str_file_echelle,0,strpos(str_file_echelle,'.',/REVERSE_SEARCH))+'_lon_lat.dat'
  openw,lun,str_file_out,/GET_LUN

  strarr_echelle = readfiletostrarr(str_file_echelle,' ')
  strarr_rave = readfiletostrarr(str_file_rave,' ')

  int_col_echelle_obsdate = 11
  int_col_echelle_fieldname = 12
  int_col_echelle_fibre = 13

  int_col_rave_obsdate = 15
  int_col_rave_fieldname = 16
  int_col_rave_fibre = 18
  int_col_rave_lon = 5
  int_col_rave_lat = 6

  for i=0ul, n_elements(strarr_echelle(*,0))-1 do begin
    indarr = where((strarr_echelle(i,int_col_echelle_obsdate) eq strarr_rave(*,int_col_rave_obsdate)) and (strarr_echelle(i,int_col_echelle_fieldname) eq strarr_rave(*,int_col_rave_fieldname)) and (strarr_echelle(i,int_col_echelle_fibre) eq strarr_rave(*,int_col_rave_fibre)))
    if indarr(0) lt 0 then begin
      print,'PROBLEM: Star i = ',i,' not found'
    end else begin
      str_out = strarr_echelle(i,0)
      for j=1,n_elements(strarr_echelle(0,*))-1 do begin
        str_out = str_out + ' ' + strarr_echelle(i,j)
      endfor
      str_out = str_out + ' ' + strarr_rave(indarr(0),int_col_rave_lon)
      str_out = str_out + ' ' + strarr_rave(indarr(0),int_col_rave_lat)
      printf,lun,str_out
    endelse
  endfor
  free_lun,lun
end
