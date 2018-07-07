pro rave_bad_stars_over_snr
;
; NAME:                  rave_bad_stars_over_snr.pro
; PURPOSE:               searches rave data from 2nd data release for stars which don't
;                        give stellar parameters
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_bad_stars_over_snr
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

; --- parameters
  i_nbins = 31
  dbl_start = -10.
  dbl_end = 300.
  dbl_binwidth = (dbl_end - dbl_start) / i_nbins
  print,'dbl_binwidth = ',dbl_binwidth
;  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808-1st_release.dat'
  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles-1st_release.dat'

  strarr_data = readfiletostrarr(str_datafile,' ')

  dblarr_teff = double(strarr_data(*,17))
  int_nstars = n_elements(dblarr_teff)
  dblarr_logg = double(strarr_data(*,18))
  dblarr_metallicity = double(strarr_data(*,19))
  dblarr_snr = double(strarr_data(*,31))
  dblarr_Imag = double(strarr_data(*,12))
  intarr_fibre = long(strarr_data(*,16))

  ; --- count all stars
  intarr_nstars_in_bin = intarr(i_nbins)
  dblarr_bins = dblarr(i_nbins+1)
  dbl_binstart = dbl_start
  dblarr_bins(0) = dbl_binstart
  for i=0UL, i_nbins-1 do begin
    dbl_binend = dbl_binstart + dbl_binwidth
    indarr = where(dblarr_snr ge dbl_binstart and dblarr_snr lt dbl_binend)
    intarr_nstars_in_bin(i) = n_elements(indarr)
    dbl_binstart = dbl_binend
    dblarr_bins(i+1) = dbl_binstart
  endfor
  print,'int_nstars = ',int_nstars
  print,'dblarr_bins = ',dblarr_bins
  print,'intarr_nstars_in_bin = ',intarr_nstars_in_bin

  indarr = where(dblarr_teff eq 0.)
  print,'number of stars without effective Temperatures: ',n_elements(indarr)
  strarr_data = strarr_data(indarr,*)
  dblarr_teff = dblarr_teff(indarr)
  dblarr_logg = dblarr_logg(indarr)
  dblarr_metallicity = dblarr_metallicity(indarr)
  dblarr_snr = dblarr_snr(indarr)
  dblarr_Imag = dblarr_Imag(indarr)
  intarr_fibre = intarr_fibre(indarr)

  intarr_nstars_rej_in_bin = intarr(i_nbins)
  dbl_binstart = dbl_start
  for i=0UL, i_nbins-1 do begin
    dbl_binend = dbl_binstart + dbl_binwidth
    indarr = where(dblarr_snr ge dbl_binstart and dblarr_snr lt dbl_binend)
    intarr_nstars_rej_in_bin(i) = n_elements(indarr)
    dbl_binstart = dbl_binend
  endfor
  print,'int_nstars = ',int_nstars
  print,'dblarr_bins = ',dblarr_bins
  print,'intarr_nstars_rej_in_bin = ',intarr_nstars_rej_in_bin

  ; --- number of rejected stars over Imag
  dbl_plot_max = max(intarr_nstars_rej_in_bin)
;  dbl_plot_max = 50.
  set_plot,'ps'
  if dbl_plot_max eq max(intarr_nstars_rej_in_bin) then begin
    str_psfilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_SNR.ps'
    str_giffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_SNR.gif'
  end else begin
    str_psfilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_SNR_max_'+strtrim(string(long(dbl_plot_max)),2)+'.ps'
    str_giffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_SNR_max_'+strtrim(string(long(dbl_plot_max)),2)+'.gif'
  end
  device,filename=str_psfilename

  plot,[dbl_start,dbl_end],$
       [0.,0.],$
       xrange=[dbl_start,dbl_end],$
       yrange=[0,dbl_plot_max],$
       xstyle=1,$
       ystyle=1,$
       xtitle='S/N',$
       ytitle='Number of rejected stars',$
       charsize=2.,$
       charthick=2.,$
       thick=2.

  for i=0, i_nbins-1 do begin
    oplot,[dblarr_bins(i),dblarr_bins(i)],[0,intarr_nstars_rej_in_bin(i)]
    oplot,[dblarr_bins(i+1),dblarr_bins(i+1)],[0,intarr_nstars_rej_in_bin(i)]
    oplot,[dblarr_bins(i),dblarr_bins(i+1)],[intarr_nstars_rej_in_bin(i),intarr_nstars_rej_in_bin(i)]
  endfor
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename

  ; --- percentage of rejected stars over Imag
  set_plot,'ps'
  str_psfilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_SNR.ps'
  str_giffilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_SNR.gif'
  device,filename=str_psfilename
  dblarr_plot_y = (double(intarr_nstars_rej_in_bin) / double(intarr_nstars_in_bin)) * 100.
  print,'dblarr_plot_y = ',dblarr_plot_y
  plot,[dbl_start,dbl_end],[0.,0.],xrange=[dbl_start,dbl_end],yrange=[0,max(dblarr_plot_y)],xstyle=1,ystyle=1,xtitle='S/N',ytitle='Percentage of rejected stars'
  for i=0, i_nbins-1 do begin
    oplot,[dblarr_bins(i),dblarr_bins(i)],[0,dblarr_plot_y(i)]
    oplot,[dblarr_bins(i+1),dblarr_bins(i+1)],[0,dblarr_plot_y(i)]
    oplot,[dblarr_bins(i),dblarr_bins(i+1)],[dblarr_plot_y(i),dblarr_plot_y(i)]
  endfor
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
end
