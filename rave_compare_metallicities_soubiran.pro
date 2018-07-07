pro rave_compare_metallicities_soubiran
  str_filename_all_elements = '/home/azuri/daten/rave/calibration/all_found.dat'
  str_filename_feh_and_afe = '/home/azuri/daten/rave/calibration/all_found_mh-from-feh-afe.dat'

  strarr_data_all_elements = readfiletostrarr(str_filename_all_elements,' ')
  strarr_data_feh_and_afe = readfiletostrarr(str_filename_feh_and_afe,' ')

  intarr_source_all_elements = ulong(strarr_data_all_elements(*,21))
  intarr_source_feh_and_afe = ulong(strarr_data_feh_and_afe(*,21))

  indarr = where(intarr_source_all_elements eq 0)

  dblarr_mh_all_elements = double(strarr_data_all_elements(indarr,8))
  dblarr_mh_feh_and_afe = double(strarr_data_feh_and_afe(indarr,8))

  set_plot,'ps'
  str_filename_out = strmid(str_filename_all_elements,0,strpos(str_filename_all_elements,'/',/REVERSE_SEARCH)+1)+'soubiran_mh-all-elements_vs_mh-from-feh-and-afe.ps'
  device,filename=str_filename_out
    plot,dblarr_mh_feh_and_afe,$
         dblarr_mh_all_elements

  device,/close
  set_plot,'x'
end
