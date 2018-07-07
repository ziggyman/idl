pro rave_combine_input_catalogues
  str_filename = '/home/azuri/daten/rave/input_catalogue/all_fields.list'
  n_lines = countlines(str_filename)

  strarr_fields = readfiletostrarr(str_filename,' ')
  str_path = '/home/azuri/daten/rave/input_catalogue/'

  openw,lun_all,'/home/azuri/daten/rave/input_catalogue/ric1+2.dat',/GET_LUN
  openw,lun_one,'/home/azuri/daten/rave/input_catalogue/ric1.dat',/GET_LUN
  openw,lun_two,'/home/azuri/daten/rave/input_catalogue/ric2.dat',/GET_LUN
  for i=0UL, n_lines-1 do begin
  ; --- first catalogue
    strarr_lines = readfilelinestoarr(str_path+strarr_fields(i,3),STR_DONT_READ='#')
    n_datalines = countlines(str_path+strarr_fields(i,3))
    for j=4UL, n_datalines-1 do begin
      printf,lun_all,strarr_lines(j)
      printf,lun_one,strarr_lines(j)
    endfor

  ; --- second catalogue
    strarr_lines = readfilelinestoarr(str_path+strarr_fields(i,4),STR_DONT_READ='#')
    n_datalines = countlines(str_path+strarr_fields(i,4))
    for j=4UL, n_datalines-1 do begin
      printf,lun_all,strarr_lines(j)
      printf,lun_two,strarr_lines(j)
    endfor
  endfor
  free_lun,lun_all
  free_lun,lun_one
  free_lun,lun_two
end
