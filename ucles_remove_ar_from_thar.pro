pro ucles_remove_ar_from_thar
  str_filename_in = '/home/azuri/daten/ThAr-Atlanten/UCLES/LovisC+PalmerB+WhalingW+NorlenG_v3000-v11000.dat'
  str_filename_out = '/home/azuri/daten/ThAr-Atlanten/UCLES/LovisC+PalmerB+WhalingW+NorlenG_v3000-v11000_Th.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NLINES=nlines,I_NCols=ncols)
  strarr_wlen = strarr_data(*,1)
  strarr_element = strarr_data(*,3)
  strarr_ion = strarr_data(*,4)
  indarr = where(strarr_element ne 'Ar')

  openw,lun,str_filename_out,/GET_LUN
  for i=0ul,n_elements(indarr)-1 do begin
    printf,lun,strarr_wlen(indarr(i))+' '+strarr_element(indarr(i))+strarr_ion(indarr(i))
  endfor
  free_lun,lun
end
