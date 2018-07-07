;common maxn,dlambda,lambda,flux

pro rave_plot_fields
;common maxn,dlambda,lambda,flux

;
; NAME:                  plot_starcolors.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_starcolors,spectruma,spectrumb,linelist,OUTFILE=outfile,D_XMIN=xmin,D_XMAX=xmax,D_MAXRESINTENS=maxresintens,legenda
; INPUTS:                spectruma (output of ATLAS synthe):
;                           5880.0063      0.15201110E-05      0.38394624E-05     0.395918
;                           5880.0161      0.17347011E-05      0.38394703E-05     0.451807
;                           ...
;
;                        spectrumb (output of ATLAS synthe):
;                           5880.0063      0.15201110E-05
;                           5880.0161      0.17347011E-05
;                           ...
;
;                        linelist (output of ATLAS synthe):
;                           588.2705 -3.690  2.0   62669.727  1.0   79664.000    14.00  KP     1.0000
;                           588.3052 -2.621  2.0   48451.730  1.0   65445.000    20.00  K88    1.0000
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  03.01.2008
;
;                        headline
;                        feetline (up to now not used)
;
  str_plotname = '/home/azuri/daten/rave/rave_data/release3/fields.ps'
  datafile = '/home/azuri/daten/rave/rave_data/release3/fields.dat'

  i_nfields = countdatlines(datafile)
  strarr_data = readfiletostrarr(datafile,' ')
  dblarr_data = dblarr(i_nfields,4)
  dblarr_data(*,0) = double(strarr_data(*,0))
  dblarr_data(*,1) = double(strarr_data(*,1))
  dblarr_data(*,2) = double(strarr_data(*,2))
  dblarr_data(*,3) = double(strarr_data(*,3))
  print,'dblarr_data = ',dblarr_data

  loadct,2
  set_plot,'ps'
  device,filename=str_plotname,/color
  plot,[dblarr_data(0,0),dblarr_data(0,1)],[dblarr_data(0,2),dblarr_data(0,2)],xrange=[360,0],yrange=[-88,0],xtitle='RA [deg]',ytitle='Dec [deg]',xstyle=1,ystyle=1
  for i=0, i_nfields-1 do begin
    box,dblarr_data(i,0),dblarr_data(i,2),dblarr_data(i,1),dblarr_data(i,3),20
  endfor
  device,/close
  set_plot,'x'
end
