pro ucles_combine_th_and_ar_lines
  b_remove_close_lines = 1

  str_filename_th = '/home/azuri/daten/ThAr-Atlanten/UCLES/Th.dat'
  str_filename_ar = '/home/azuri/daten/ThAr-Atlanten/UCLES/Ar.dat'
  str_filename_out = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThAr'
  if b_remove_close_lines then $
    str_filename_out = str_filename_out+'_no_blends'
  str_filename_out = str_filename_out+'.dat'

  strarr_data_th = readfiletostrarr(str_filename_th,' ',I_NCOLS=i_ncols,I_NDATALINES=i_ndatalines_th)
  strarr_data_ar = readfiletostrarr(str_filename_ar,' ',I_NCOLS=i_ncols,I_NDATALINES=i_ndatalines_ar)

  dblarr_data_th_intens = double(strarr_data_th(*,2))
  dblarr_data_th_intens = 10.^dblarr_data_th_intens
  strarr_data_th(*,2) = strtrim(string(dblarr_data_th_intens),2)
  dblarr_data_th_intens = 0

  dblarr_data_ar_intens = double(strarr_data_ar(*,2))
  dblarr_data_ar_intens = 10.^dblarr_data_ar_intens
  strarr_data_ar(*,2) = strtrim(string(dblarr_data_ar_intens),2)
  dblarr_data_ar_intens = 0

  print,'i_ndatalines_th = ',i_ndatalines_th
  print,'i_ndatalines_ar = ',i_ndatalines_ar

  strarr_data = strarr(i_ndatalines_th + i_ndatalines_ar,i_ncols)
  strarr_data(0:i_ndatalines_th-1,*) = strarr_data_th
  strarr_data(i_ndatalines_th:i_ndatalines_th+i_ndatalines_ar-1,*) = strarr_data_ar

  indarr = sort(double(strarr_data(*,0)))

  strarr_data = strarr_data(indarr,*)
  dblarr_wlen = double(strarr_data(*,0))

  openw,lun,str_filename_out,/GET_LUN
    printf,lun,'# Wavelength[Angstroems] Ion RelativeIntensity Source'
  ; --- remove lines within 13 km/s of each other
    dbl_speed_of_light = 299792458.;m/s
    for i=0ul, n_elements(dblarr_wlen)-1 do begin
      if b_remove_close_lines then begin
        dbl_lambda_min = dblarr_wlen(i) / (1. + 13000./dbl_speed_of_light)
        dbl_lambda_max = dblarr_wlen(i) / (1. - 13000./dbl_speed_of_light)
        print,'dbl_lambda_min = ',dbl_lambda_min
        print,'dbl_lambda_max = ',dbl_lambda_max
        indarr = where(dblarr_wlen ge dbl_lambda_min and dblarr_wlen le dbl_lambda_max)
        print,'indarr = ',indarr
      endif else begin
        indarr=[1]
      end
      if n_elements(indarr) eq 1 then begin
        printf,lun,strarr_data(i,0) + ' ' + strarr_data(i,1) + ' ' + strarr_data(i,2) + ' ' + strarr_data(i,3)
      endif
    endfor
  free_lun,lun

end
