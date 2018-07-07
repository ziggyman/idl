pro ucles_get_xe_lines
  str_filename_in = '/home/azuri/daten/ThAr-Atlanten/UCLES/Xe_nist.dat'
  str_filename_out = '/home/azuri/daten/ThAr-Atlanten/UCLES/Xe.dat'

  strarr_data = readfiletostrarr(str_filename_in,'|',I_NCOLS=i_ncols,I_NDATALINES=i_ndatalines)

  print,'strarr_data(0,*) = ',strarr_data(0,*)

  openw,lun,str_filename_out,/GET_LUN
    printf,lun,'# Wavelength[Angstroems] Ion RelativeIntensity Source'
    for i=0ul,i_ndatalines-1 do begin
      if strarr_data(i,0) ne '' then begin
        if strarr_data(i,3) eq '' then $
          strarr_data(i,3) = '0'
        print,'strarr_data(i,3) = <'+strarr_data(i,3)+'>'
        printf,lun,strarr_data(i,1) + ' ' + strmid(strarr_data(i,0),0,strpos(strarr_data(i,0),' ')) + strmid(strarr_data(i,0),strpos(strarr_data(i,0),' ')+1) + ' ' + strarr_data(i,3) + ' ' + strarr_data(i,13)
      endif
    endfor
  free_lun,lun

end
