pro rave_count_bad_stars
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

; --- parameters
  i_nbins = 10
  dbl_binwidth = 3. / i_nbins
  print,'dbl_binwidth = ',dbl_binwidth
  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles-1st_release.dat'

  strarr_data = readfiletostrarr(str_datafile,' ')

  dblarr_teff = double(strarr_data(*,17))
  int_nstars = n_elements(dblarr_teff)
  dblarr_logg = double(strarr_data(*,18))
  dblarr_metallicity = double(strarr_data(*,19))
  dblarr_snr = double(strarr_data(*,31))
  dblarr_Imag = double(strarr_data(*,12))
  intarr_fibre = long(strarr_data(*,16))

  ; --- S/N over Imag
  set_plot,'ps'
  str_psfilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.ps'
  str_giffilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.gif'
  str_tifffilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.tiff'
  str_pdffilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.pdf'
  device,filename=str_psfilename
  plot,dblarr_Imag,$
       dblarr_snr,$
       xrange=[9.,12.],$
       xstyle=1,$
       xtitle='I [mag]',$
       ytitle='S/N',$
       psym=2,$
       symsize=0.2,$
       charsize=2.,$
       charthick=2.,$
       thick=2.
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
  spawn,'rm '+str_tifffilename
  spawn,'gif2tiff '+str_giffilename+' '+str_tifffilename
  spawn,'tiff2pdf -o '+str_pdffilename+' '+str_tifffilename

  ; --- count all stars
  intarr_nstars_in_bin = ulonarr(i_nbins)
  dblarr_bins = dblarr(i_nbins+1)
  dbl_binstart = 9.
  dblarr_bins(0) = dbl_binstart
  for i=0UL, i_nbins-1 do begin
    dbl_binend = dbl_binstart + dbl_binwidth
    indarr = where(dblarr_Imag ge dbl_binstart and dblarr_Imag lt dbl_binend)
    i_nstars = n_elements(indarr)
    print,'i = ',i,': i_nstars = ',i_nstars
    intarr_nstars_in_bin(i) = i_nstars
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

;  indarr = where(dblarr_logg eq 99.9)
;  print,'dblarr_logg = ',dblarr_logg
;  print,'number of stars without logg: ',n_elements(indarr)
;  strarr_data = strarr_data(indarr,*)
;  dblarr_teff = dblarr_teff(indarr)
;  dblarr_logg = dblarr_logg(indarr)
;  dblarr_metallicity = dblarr_metallicity(indarr)
;  dblarr_snr = dblarr_snr(indarr)
;  dblarr_Imag = dblarr_Imag(indarr)
;  intarr_fibre = intarr_fibre(indarr)
;
;  indarr = where(dblarr_metallicity eq 99.9)
;  print,'number of stars without metallicities: ',n_elements(indarr)
;  strarr_data = strarr_data(indarr,*)
;  dblarr_teff = dblarr_teff(indarr)
;  dblarr_logg = dblarr_logg(indarr)
;  dblarr_metallicity = dblarr_metallicity(indarr)
;  dblarr_snr = dblarr_snr(indarr)
;  dblarr_Imag = dblarr_Imag(indarr)
;  intarr_fibre = intarr_fibre(indarr)
;
;  print,'indarr = ',indarr
;  print,'n_elements(dblarr_teff) = ',n_elements(dblarr_teff)

  intarr_nstars_rej_in_bin = intarr(i_nbins)
  dbl_binstart = 9.
  for i=0UL, i_nbins-1 do begin
    dbl_binend = dbl_binstart + dbl_binwidth
    indarr = where(dblarr_Imag ge dbl_binstart and dblarr_Imag lt dbl_binend)
    intarr_nstars_rej_in_bin(i) = n_elements(indarr)
    dbl_binstart = dbl_binend
  endfor
  print,'int_nstars = ',int_nstars
  print,'dblarr_bins = ',dblarr_bins
  print,'intarr_nstars_rej_in_bin = ',intarr_nstars_rej_in_bin

  ; --- number of rejected stars over Imag
  set_plot,'ps'
  str_psfilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_Imag.ps'
  spawn,'rm '+str_tifffilename
  str_giffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_Imag.gif'
  str_tifffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_Imag.tiff'
  str_pdffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_rej_over_Imag.pdf'
  device,filename=str_psfilename

  plot,[9.,12.],$
       [0.,0.],$
       xrange=[9.,12.],$
       yrange=[0,max(intarr_nstars_rej_in_bin)],$
       xstyle=1,$
       ystyle=1,$
       xtitle='I [mag]',$
       ytitle='Number of rejected stars',$
       charsize=2.,$
       charthick=2.,$
       thick=2.
  for i=0, i_nbins-1 do begin
    print,'rave_count_bad_stars: intarr_nstars_rej_in_bin(i=',i,') = ',intarr_nstars_rej_in_bin(i)
    print,'rave_count_bad_stars: intarr_nstars_in_bin(i=',i,') = ',intarr_nstars_in_bin(i)
    oplot,[dblarr_bins(i),dblarr_bins(i)],[0,intarr_nstars_rej_in_bin(i)]
    oplot,[dblarr_bins(i+1),dblarr_bins(i+1)],[0,intarr_nstars_rej_in_bin(i)]
    oplot,[dblarr_bins(i),dblarr_bins(i+1)],[intarr_nstars_rej_in_bin(i),intarr_nstars_rej_in_bin(i)]
  endfor
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
  spawn,'rm '+str_tifffilename
  spawn,'gif2tiff '+str_giffilename+' '+str_tifffilename
  spawn,'tiff2pdf -o '+str_pdffilename+' '+str_tifffilename

  ; --- percentage of rejected stars over Imag
  set_plot,'ps'
  str_psfilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_Imag.ps'
  str_giffilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_Imag.gif'
  str_tifffilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_Imag.tiff'
  str_pdffilename = '/suphys/azuri/daten/rave/rave_data/release5/percentage_rej_over_Imag.pdf'
  device,filename=str_psfilename
  dblarr_plot_y = (double(intarr_nstars_rej_in_bin) / double(intarr_nstars_in_bin)) * 100.
  print,'dblarr_plot_y = ',dblarr_plot_y
  plot,[9.,12.],$
       [0.,0.],$
       xrange=[9.,12.],$
       yrange=[0,max(dblarr_plot_y)],$
       xstyle=1,$
       ystyle=1,$
       xtitle='I [mag]',$
       ytitle='Percentage of rejected stars',$
       charsize=2.,$
       charthick=2.,$
       thick=2.
  for i=0, i_nbins-1 do begin
    print,'rave_count_bad_stars: dblarr_plot_y(i=',i,') = ',dblarr_plot_y(i)
    oplot,[dblarr_bins(i),dblarr_bins(i)],[0,dblarr_plot_y(i)]
    oplot,[dblarr_bins(i+1),dblarr_bins(i+1)],[0,dblarr_plot_y(i)]
    oplot,[dblarr_bins(i),dblarr_bins(i+1)],[dblarr_plot_y(i),dblarr_plot_y(i)]
  endfor
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
  spawn,'rm '+str_tifffilename
  spawn,'gif2tiff '+str_giffilename+' '+str_tifffilename
  spawn,'tiff2pdf -o '+str_pdffilename+' '+str_tifffilename
end
