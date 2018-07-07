; pro rave_list_bad_stars
;
; NAME:                  rave_count_bad_stars.pro
; PURPOSE:               searches rave data from 2nd data release for stars which don't
;                        give stellar parameters
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_count_bad_stars
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

;  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808-1st_release.dat'
  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles.dat'

  strarr_data = readfiletostrarr(str_datafile,' ')
  strarr_lines = readfilelinestoarr(str_datafile,STR_DONT_READ='#')

  dblarr_teff = double(strarr_data(*,17))
  int_nstars = n_elements(dblarr_teff)
  dblarr_logg = double(strarr_data(*,18))
  dblarr_metallicity = double(strarr_data(*,19))
  dblarr_snr = double(strarr_data(*,31))
  dblarr_Imag = double(strarr_data(*,12))
  intarr_fibre = long(strarr_data(*,16))
  strarr_obsdate = strarr_data(*,13)
  strarr_fieldname = strarr_data(*,14)

  indarr = where(dblarr_teff eq 0.)
  print,'number of stars without effective Temperatures: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  strarr_lines = strarr_lines(indarr)
  strarr_obsdate = strarr_obsdate(indarr)
  strarr_fieldname = strarr_fieldname(indarr)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_Imag = dblarr_Imag(indarr)
  intarr_fibre = intarr_fibre(indarr)

; --- print data array for stars without T_eff
  str_outfile = strmid(str_datafile,0,strpos(str_datafile,'.',/REVERSE_SEARCH))+'_no_teff.dat'

  openw,lun,str_outfile,/GET_LUN
  for i=0UL, n_elements(strarr_lines)-1 do begin
    printf,lun,strarr_lines(i)
  endfor
  free_lun,lun

; --- print IDs for stars without T_eff
  str_outfile = strmid(str_datafile,0,strpos(str_datafile,'.',/REVERSE_SEARCH))+'_no_teff_ID.dat'

  openw,lun,str_outfile,/GET_LUN
  for i=0UL, n_elements(strarr_lines)-1 do begin
    printf,lun,strarr_obsdate(i)+' '+strarr_fieldname(i)+' '+strtrim(string(intarr_fibre(i)),2)
    print,'i = ',i,': strarr_obsdate="'+strarr_obsdate(i)+'", strarr_fieldname="'+strarr_fieldname(i)+'",intarr_fibre="',intarr_fibre(i),'"'
  endfor
  free_lun,lun

end
