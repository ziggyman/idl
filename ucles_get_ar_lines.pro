pro ucles_get_ar_lines
  str_filename_in = '/home/azuri/daten/ThAr-Atlanten/UCLES/LovisC+PalmerB+WhalingW+NorlenG_v3000-v11000.dat'
  str_filename_out = '/home/azuri/daten/ThAr-Atlanten/UCLES/Ar.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NCOLS=i_ncols,I_NDATALINES=i_ndatalines)

  print,'strarr_data(0,*) = ',strarr_data(0,*)

  openw,lun,str_filename_out,/GET_LUN
    printf,lun,'# Wavelength[Angstroems] Ion RelativeIntensity Source'
    for i=0ul,i_ndatalines-1 do begin
      if strarr_data(i,3) eq 'Ar' then $
        printf,lun,strarr_data(i,1) + ' ' + strarr_data(i,3) + strarr_data(i,4) + ' ' + strarr_data(i,2) + ' Murphy'
    endfor
  free_lun,lun

end
