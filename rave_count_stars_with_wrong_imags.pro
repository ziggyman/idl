pro rave_count_stars_with_wrong_imags
  b_input = 0

  if b_input then begin
    str_filename = '/suphys/azuri/daten/rave/input_catalogue/rave_input_I2MASS.dat'
    int_col_imag = 5
  end else begin
    str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_I2MASS.dat'
    int_col_imag = 14
  endelse

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_imag = double(strarr_data(*,int_col_imag))

  n_too_big = n_elements(where(dblarr_imag gt 12.))
  n_too_small = n_elements(where(dblarr_imag lt 9.))

  print,'n_too_big = ',n_too_big,' equals ',n_too_big * 100. / n_elements(dblarr_imag)
  print,'n_too_small = ',n_too_small,' equals ',n_too_small * 100. / n_elements(dblarr_imag)
end
