pro get_rave_input_catalogue
  str_filename = '/home/azuri/daten/rave/input catalogue/all_fields.list'
  n_lines = countlines(str_filename)

  strarr_fields = readfiletostrarr(str_filename,' ')

  for i=0ul, n_lines-1 do begin
    spawn,'wget --http-user=azuri --http-password=hei-di http://gavo3.aip.de:8080/RAVE/fields/'+strarr_fields(i,3)
    spawn,'wget --http-user=azuri --http-password=hei-di http://gavo3.aip.de:8080/RAVE/fields/'+strarr_fields(i,4)
  endfor
end
