pro ucles_remove_double_entries_from_line_list
  str_filename = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThXe_good_no_doubles_no_doubles.dat'

  strarr_data = readfiletostrarr(str_filename,' ')
  dblarr_wlen = double(strarr_data(*,0))

  indarr_sort = sort(dblarr_wlen)

  str_filename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_no_doubles.dat'
  openw,lun,str_filename,/GET_LUN
    i=0ul
    while i lt n_elements(dblarr_wlen) - 1 do begin
      indarr = where(abs(dblarr_wlen - dblarr_wlen(indarr_sort(i))) lt 0.0000001)
      printf,lun,strarr_data(indarr_sort(i),0)+' '+strarr_data(indarr_sort(i),1)+' '+strarr_data(indarr_sort(i),2)+' '+strarr_data(indarr_sort(i),3)
      i = i+n_elements(indarr)
    end
  free_lun,lun
end
