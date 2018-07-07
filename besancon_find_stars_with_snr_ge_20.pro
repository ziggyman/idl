pro besancon_find_stars_with_snr_ge_20,STR_FILENAME=str_filename

  if not keyword_set(str_filename) then $
    str_filename = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snr-i-dec-minus-ic1_gt_13_with_errors_height_rcent_errdivby_1.56_2.37_2.75_1.50_2.00.dat'

  str_filename_out = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_snr-ge-20.dat'

  strarr_data = readfiletostrarr(str_filename,' ')
  strarr_data_lines  = readfilelinestoarr(str_filename)

  openw,lun,str_filename_out,/GET_LUN
    for i=0ul, n_elements(strarr_data(*,0))-1 do begin
      if double(strarr_data(i,15)) ge 20. then $
        printf,lun,strarr_data_lines(i)
    endfor
  free_lun,lun
end
