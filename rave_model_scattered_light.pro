pro rave_model_scattered_light
  str_path = '/home/azuri/spectra/rave/scatter/'
  str_filelist = str_path + 'to_apedit.list'

  strarr_filelist = readfiletostrarr(str_filelist,' ')

  intarr_fibre_number = ulonarr(n_elements(strarr_filelist))
  dblarr_center = dblarr(n_elements(strarr_filelist),9,2)

  for j=0,n_elements(strarr_filelist)-1 do begin
    intarr_fibre_number(j) = ulong(strmid(strarr_filelist(j),strpos(strarr_filelist(j),'fp1_')+4,3))
    print,'intarr_fibre_number(j=',j,') = ',intarr_fibre_number(j)

    str_database_entry = str_path+'database/ap'+strmid(strarr_filelist(j),0,strpos(strarr_filelist(j),'.',/REVERSE_SEARCH))
    print,'j=',j,': str_database_entry = ',str_database_entry

    read_iraf_database_file,str_database_entry,strarr_apertures

    b_ap_found = 0
    for k=0,8 do begin
      for i=0ul, n_elements(strarr_apertures(*,0))-1 do begin
	print,'j=',j,': i=',i,': ',strarr_apertures(i,0),', ',strarr_apertures(i,1)
	if strarr_apertures(i,0) eq 'aperture' and strarr_apertures(i,1) eq strtrim(string(k+1),2) then begin
	  b_ap_found = 1
	  print,'j=',j,': i=',i,': b_ap_found = true'
	endif
	if strarr_apertures(i,0) eq '' then begin
	  b_ap_found = 0
	  print,'j=',j,': i=',i,': b_ap_found = false'
	endif
	if b_ap_found then begin
	  if strarr_apertures(i,0) eq 'center' then begin
	    dblarr_center(j,k,0) = double(strarr_apertures(i,1))
	    dblarr_center(j,k,1) = double(strarr_apertures(i,2))
	    print,'dblarr_center(j=',j,',k=',k,') = ',dblarr_center(j,k,*)
	  endif
	endif
      endfor
    endfor
  endfor

  dblarr_fit_coeffs = poly_fit(intarr_fibre_number,dblarr_center(*,0,0),3,YFIT=dblarr_fit)
  print,'dblarr_fit = ',dblarr_fit

  set_plot,'ps'
  str_psfilename = strmid(str_filelist,0,strpos(str_filelist,'.',/REVERSE_SEARCH))+'.ps'
  print,'str_psfilename = '+str_psfilename
  device,filename=str_psfilename
    plot,intarr_fibre_number,$
         dblarr_center(*,0,0),$
         psym = 2,$
         xtitle = 'fibre number',$
         ytitle = 'column'
    oplot,intarr_fibre_number,dblarr_fit
    for i=1,8 do begin
      oplot,intarr_fibre_number,$
            dblarr_center(*,i,0),$
            psym=2
    endfor
  device,/close
  set_plot,'x'
end
