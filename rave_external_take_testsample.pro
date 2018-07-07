pro rave_external_take_testsample
  int_n_sample_stars = 100; number of randomly selected stars for testsample

  str_filename_external = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'

  str_filename_external_out = strmid(str_filename_external,0,strpos(str_filename_external,'.',/REVERSE_SEARCH))
  str_filename_testsample_out = str_filename_external_out + '_testsample.dat'
  str_filename_external_out = str_filename_external_out + '_minus-testsample.dat'

  strarr_data = readfilelinestoarr,str_filename_external,STR_DONT_READ='#',NLINES=int_n_stars

  indarr_sample = lonarr(int_n_sample_stars)
  for i=0ul, int_n_sample_stars-1 do begin
    indarr_sample = long(randomu(seed) * int_n_stars)
  endfor

  openw,lun_a,str_filename_external_out,/GET_LUN
  openw,lun_b,str_filename_testsample_out,/GET_LUN
  for i=0ul, int_n_stars-1 do begin
    indarr_temp = where(indarr_sample eq i,count)
    if count eq 0 then begin
      lun = lun_a
    end else begin
      lun = lun_a
    endelse
    printf,lun,strarr_data(i)
  endfor
  free_lun,lun_a
  free_lun,lun_b
end
