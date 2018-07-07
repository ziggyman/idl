pro rave_plot_I_vs_J
;
; NAME:                  rave_plot_I_vs_J.pro
; PURPOSE:               plots histograms for snr in Imag-bins
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_plot_I_vs_J
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

; --- parameters
  b_input = 1

  str_datafile = '/suphys/azuri/daten/rave/input_catalogue/rave_input.dat'
;  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles-1st_release.dat'

  strarr_data = readfiletostrarr(str_datafile,' ')

  if b_input then begin
    dblarr_Imag = double(strarr_data(*,5))
    dblarr_Jmag = double(strarr_data(*,5))

    for ii=0UL, n_elements(dblarr_Jmag)-1 do begin
      if strlen(strarr_data(ii,7)) lt 4 then begin
        dblarr_Jmag(ii) = double(strmid(strarr_data(ii,8),0,5)); --- J [mag]
;          if strlen(strarr_ravedata_all(ii,8)) lt 10 then begin
;            strarr_ravedata(ii,4) = strmid(strarr_ravedata_all(ii,9),0,5); --- K [mag]
;          end else begin
;            strarr_ravedata(ii,4) = strmid(strarr_ravedata_all(ii,8),8,6); --- K [mag]
;          endelse
      end else begin
        dblarr_Jmag(ii) = double(strmid(strarr_data(ii,7),2,6)); --- J [mag]
;          if strlen(strarr_ravedata_all(ii,7)) lt 13 then begin
;            strarr_ravedata(ii,4) = strmid(strarr_ravedata_all(ii,8),0,5); --- K [mag]
;          end else begin
;            strarr_ravedata(ii,4) = strmid(strarr_ravedata_all(ii,7),11,6); --- K [mag]
;          endelse
      end
    endfor


  end else begin
    dblarr_Imag = double(strarr_data(*,31))
    dblarr_Jmag = double(strarr_data(*,12))
  end

  ; --- S/N over Imag
  set_plot,'ps'
  str_psfilename = '/suphys/azuri/daten/rave/rave_data/release5/input_catalogue_I_vs_J.ps'
  str_giffilename = '/suphys/azuri/daten/rave/rave_data/release5/input_catalogue_I_vs_J.gif'
  device,filename=str_psfilename
  plot,dblarr_Imag,dblarr_Jmag,xrange=[9.,12.],xstyle=1,xtitle='I [mag]',ytitle='J [mag]',psym=2,symsize=0.2
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename

end
