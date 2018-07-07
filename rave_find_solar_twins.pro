pro rave_find_solar_twins
;
; NAME:                  rave_find_solar_twins.pro
; PURPOSE:               searches rave data for solar twins
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_find_solar_twins
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  08/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles.dat'

  ;solar parameters and rave errors
  dbl_sun_teff = 5778;K
  dbl_sigma_teff = 0.07 * 6000.
  dbl_sun_logg = 4.44;dex
  dbl_sigma_logg = 0.61
  dbl_sun_metallicity = 0.;log(Z/Z_sun)
  dbl_sigma_metallicity = 0.022

  dbl_maxerr = 0.3;*sigma
  dbl_k_teff = 0.-0.848
  dbl_k_logg = 0.-0.733
  dbl_k_metallicity = 0.-0.703
  dbl_dmaxerr_teff = 500.

  ;build arrays
  strarr_data = readfiletostrarr(str_datafile,' ')
  strarr_datalines = readfilelinestoarr(str_datafile,STR_DONT_READ='#')

  dblarr_teff = double(strarr_data(*,17))
  indarr = where(dblarr_teff ne 0.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  strarr_datalines = strarr_datalines(indarr)
;  print,'dblarr_teff = ',dblarr_teff

  dblarr_logg = double(strarr_data(*,18))
  indarr = where(dblarr_logg ne 0.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  indarr = where(dblarr_logg ne 99.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  strarr_datalines = strarr_datalines(indarr)
;  print,'dblarr_logg = ',dblarr_logg

  dblarr_metallicity = double(strarr_data(*,19))
  indarr = where(dblarr_metallicity ne 99.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  strarr_datalines = strarr_datalines(indarr)
;  print,'dblarr_metallicity = ',dblarr_metallicity

  dblarr_alpha_fe = double(strarr_data(*,20))
  indarr = where(dblarr_alpha_fe ne 99.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_alpha_fe = dblarr_alpha_fe(indarr)
  strarr_datalines = strarr_datalines(indarr)

  dblarr_snr = double(strarr_data(*,31))
  indarr = where(dblarr_snr gt 0.)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_alpha_fe = dblarr_alpha_fe(indarr)
  dblarr_snr = dblarr_snr(indarr)
  strarr_datalines = strarr_datalines(indarr)
;  print,'dblarr_snr = ',dblarr_snr

  dblarr_r = dblarr_snr / 40.
  indarr = where(dblarr_snr gt 80.)
  dblarr_r(indarr) = 2.
;  i_nold = n_elements(dblarr_r)
;  indarr = where(dblarr_r gt 0.)
;  indarr_temp = where(dblarr_r le 0.)
;  print,'dblarr_r(indarr_temp) = ',dblarr_r(indarr_temp)
;  print,'i_nold = ',i_nold,', n_elements(indarr) = ',n_elements(indarr)
;  strarr_data = strarr_data(indarr,*)
;  dblarr_teff = dblarr_teff(indarr)
;  dblarr_logg = dblarr_logg(indarr)
;  dblarr_metallicity = dblarr_metallicity(indarr)
;  dblarr_alpha_fe = dblarr_alpha_fe(indarr)
;  dblarr_snr = dblarr_snr(indarr)
;  dblarr_r = dblarr_r(indarr)
;  print,'n_elements(dblarr_r) = ',n_elements(dblarr_r)
;  print,'dblarr_r = ',dblarr_r
;  print,'n_elements(indarr) = where(abs(dblarr_r) gt 0.000001) ',n_elements(indarr)
  dblarr_sigma_teff = (dblarr_r ^ dbl_k_teff) * dbl_sigma_teff
  print,'n_elements(dblarr_sigma_teff) = ',n_elements(dblarr_sigma_teff)
;  print,'dblarr_sigma_teff = ',dblarr_sigma_teff
;  openw,lun,'/suphys/azuri/daten/rave/rave_data/release3/dblarr_sigma_teff.dat',/GET_LUN
;    printf,lun,dblarr_sigma_teff
;  free_lun,lun
  dblarr_sigma_logg = (dblarr_r ^ dbl_k_logg) * dbl_sigma_logg
  dblarr_sigma_metallicity = (dblarr_r ^ dbl_k_metallicity) * dbl_sigma_metallicity

  ; --- T_eff
  indarr = where((dblarr_teff - (dblarr_sigma_teff * dbl_maxerr) lt dbl_sun_teff) and (dblarr_teff + (dblarr_sigma_teff * dbl_maxerr) gt dbl_sun_teff))
  print,'rave_find_solar_twins: Number of stars with valid temperatures: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_sigma_teff = dblarr_sigma_teff(indarr)
  dblarr_sigma_logg = dblarr_sigma_logg(indarr)
  dblarr_sigma_metallicity = dblarr_sigma_metallicity(indarr)
  strarr_datalines = strarr_datalines(indarr)

  indarr = where(abs(dblarr_teff - dbl_sun_teff) lt dbl_dmaxerr_teff)
  print,'rave_find_solar_twins: Number of stars with valid temperatures: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_sigma_teff = dblarr_sigma_teff(indarr)
  dblarr_sigma_logg = dblarr_sigma_logg(indarr)
  dblarr_sigma_metallicity = dblarr_sigma_metallicity(indarr)
  strarr_datalines = strarr_datalines(indarr)
  ; --- calculate min and max values
  dbl_min_teff = min(dblarr_teff)
  dbl_max_teff = max(dblarr_teff)

  ; --- log_g
  indarr = where((dblarr_logg - (dblarr_sigma_logg * dbl_maxerr) lt dbl_sun_logg) and (dblarr_logg + (dblarr_sigma_logg * dbl_maxerr) gt dbl_sun_logg))
  print,'rave_find_solar_twins: Number of stars with valid log_g: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_sigma_teff = dblarr_sigma_teff(indarr)
  dblarr_sigma_logg = dblarr_sigma_logg(indarr)
  dblarr_sigma_metallicity = dblarr_sigma_metallicity(indarr)
  dbl_min_logg = min(dblarr_logg)
  dbl_max_logg = max(dblarr_logg)
  strarr_datalines = strarr_datalines(indarr)
  print,'dbl_min_logg = ',dbl_min_logg
  print,'dbl_max_logg = ',dbl_max_logg

  ; --- Metallicity
  ; --- Calibrate Metallicities
  indarr = where(dblarr_metallicity ne 0.0)
  dblarr_MH_calibrated = dblarr_metallicity
  dblarr_MH_calibrated(indarr) = (0.938 * dblarr_metallicity(indarr)) + (0.767 * dblarr_alpha_fe(indarr)) - (0.064 * dblarr_logg(indarr)) + 0.404
  dblarr_metallicity = dblarr_MH_calibrated(indarr)
  strarr_datalines = strarr_datalines(indarr)

; --- look for solar analogues
  indarr = where((dblarr_metallicity - (dblarr_sigma_metallicity * dbl_maxerr) lt dbl_sun_metallicity) and (dblarr_metallicity + (dblarr_sigma_metallicity * dbl_maxerr) gt dbl_sun_metallicity))
  print,'rave_find_solar_twins: Number of stars with valid metallicity: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_sigma_teff = dblarr_sigma_teff(indarr)
  dblarr_sigma_logg = dblarr_sigma_logg(indarr)
  dblarr_sigma_metallicity = dblarr_sigma_metallicity(indarr)
  strarr_datalines = strarr_datalines(indarr)
  dbl_min_metallicity = min(dblarr_metallicity)
  dbl_max_metallicity = max(dblarr_metallicity)
  print,'dbl_min_metallicity = ',dbl_min_metallicity
  print,'dbl_max_metallicity = ',dbl_max_metallicity

  ; --- log_g over Teff
  loadct,4
  set_plot,'ps'
  str_temp = strtrim(string(dbl_maxerr),2)
  str_filename = '/suphys/azuri/daten/rave/rave_data/release5/solar_twins_maxerr'+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_Teff_'
  str_temp = strtrim(string(dbl_min_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_logg_'
  str_temp = strtrim(string(dbl_min_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_MH_'
  str_temp = strtrim(string(dbl_min_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_Teff_logg.ps'
  device,filename=str_filename,/color
;  device,filename='/suphys/azuri/daten/rave/rave_data/release5/solar_twins_Teff_logg.ps',/color

  dblarr_position = [0.115,0.175,0.995,0.995]
  plot,dblarr_teff,$
       dblarr_logg,$
       xtitle='T_eff [K]',$
       ytitle='log g [dex]',$
       psym=2,$
       symsize=0.2,$
       color=0,$
       xrange=[dbl_sun_teff - dbl_dmaxerr_teff-20.,dbl_sun_teff+dbl_dmaxerr_teff+20.],$
       yrange=[dbl_min_logg-0.1,dbl_max_logg+0.1],$
       xstyle=1,$
       ystyle=1,$
       charsize=2.,$
       charthick=2.,$
       thick=2.,$
       position=dblarr_position
  oplot,[dbl_sun_teff],[dbl_sun_logg],color=150,psym=4,symsize=2.,thick=3

  device,/close

  ; --- metallicity over Teff
  str_temp = strtrim(string(dbl_maxerr),2)
  str_filename = '/suphys/azuri/daten/rave/rave_data/release5/solar_twins_maxerr'+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_Teff_'
  str_temp = strtrim(string(dbl_min_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_logg_'
  str_temp = strtrim(string(dbl_min_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_MH_'
  str_temp = strtrim(string(dbl_min_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_Teff_MH.ps'
  device,filename=str_filename,/color

  if (dbl_min_metallicity-0.01) lt 0. then begin
    dblarr_position = [0.185,0.175,0.995,0.995]
  end
  plot,dblarr_teff,$
       dblarr_metallicity,$
       xtitle='T_eff [K]',$
       ytitle='[M/H] [dex]',$
       psym=2,$
       symsize=0.2,$
       color=0,$
       xrange=[dbl_sun_teff - dbl_dmaxerr_teff,dbl_sun_teff+dbl_dmaxerr_teff],$
       yrange=[dbl_min_metallicity-0.01,dbl_max_metallicity+0.01],$
       xstyle=1,$
       ystyle=1,$
       charsize=2.,$
       charthick=2.,$
       thick=2.,$
       position=dblarr_position
  oplot,[dbl_sun_teff],[dbl_sun_metallicity],color=150,psym=4,symsize=2.,thick=3

  device,/close

  str_temp = strtrim(string(dbl_maxerr),2)
  str_filename = '/suphys/azuri/daten/rave/rave_data/release5/solar_twins_maxerr'+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_Teff_'
  str_temp = strtrim(string(dbl_min_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_teff),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_logg_'
  str_temp = strtrim(string(dbl_min_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_logg),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'_MH_'
  str_temp = strtrim(string(dbl_min_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'-'
  str_temp = strtrim(string(dbl_max_metallicity),2)
  str_filename = str_filename+strmid(str_temp,0,strpos(str_temp,'.')+3)+'.dat'
  ;'/suphys/azuri/daten/rave/rave_data/release5/solar_twins_Teff_'+strtrim(string(dbl_min_teff),2)+'-'+strtrim(string(dbl_max_teff),2)+'_logg_'+strtrim(string(dbl_min_logg),2)+'-'+strtrim(string(dbl_max_logg),2)+'_MH_'+strtrim(string(dbl_min_metallicity),2)+'-'+strtrim(string(dbl_max_metallicity),2)+'.dat'
  openw,lun,str_filename,/GET_LUN
    printf,lun,'Object-ID RA/deg DEC/deg'
    print,'rave_find_solar_twins: size(strarr_data) = ',size(strarr_data)
    print,'rave_find_solar_twins: size(strarr_datalines) = ',size(strarr_datalines)
    for i=0UL,n_elements(dblarr_teff)-1 do begin
      ;for j=0UL, countcols(str_datafile)-1 do begin
        printf,lun,strarr_datalines(i);+' '+strarr_data(i,1)+' '+strarr_data(i,2)
      ;endfor
    endfor
  free_lun,lun
end
