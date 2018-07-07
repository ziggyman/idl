pro besancon_plot_feh_mh
;
; NAME:                  plot_two_histograms.pro
; PURPOSE:               plots histograms
; CATEGORY:              rave
; CALLING SEQUENCE:      plot_two_histograms
; INPUTS:                dblarr_data_a... 1-D array (to be normalised)
;                        dblarr_data_b... 1-D array
;                        str_plotname_root... root file name for output plot
;                        XTITLE... xtitle
;                        YTITLE... ytitle
;                        NBINS...  number of bins
;                        TITLE... plot title
;                        XRANGE... xrange
;                        YRANGE... yrange
;                        MAXNORM... normalise to maximum of dblarr_data_b
;                        TOTALNORM... normalise to total number of dblarr_data_b
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

;  print,'plot_two_histograms: dblarr_data = ',dblarr_data

  dbl_xmin = -2.
  dbl_xmax = 1.2
  int_n_data = 1000

  dblarr_x = dblarr(int_n_data)
  dblarr_y = dblarr(int_n_data)

  for i=0ul, int_n_data-1 do begin
    dblarr_x(i) = double(i)
  endfor
  dblarr_x = 0.+dbl_xmin + (dblarr_x * (dbl_xmax - dbl_xmin) / double(int_n_data))
;  indarr = where(dblarr_x lt -0.55)
;  dblarr_y = dblarr_x + 0.11 * (1. + (1. - exp(-3.6 * abs(dblarr_x+0.55))))
;  dblarr_y(indarr) = dblarr_x(indarr) + 0.11 * (1. - (1. - exp(-3.6 * abs(dblarr_x(indarr)+0.55))))
  besancon_calculate_mh,dblarr_x,OUTPUT=dblarr_y

  set_plot,'ps'
  str_psfilename = '/home/azuri/daten/besancon/besancon_plot_feh_mh.ps'
  device,filename=str_psfilename,/color
  loadct,11

  plot,dblarr_x,$
       dblarr_x,$
       xrange=[dbl_xmin,dbl_xmax],$
       yrange=[-2.,1.5],$
       xstyle=1,$
       ystyle=1,$
       color=2,$
       charsize=2.,$
       charthick=2.,$
       thick=2.,$
       xtitle='[Fe/H]',$
       ytitle='[M/H]',$
       position=[0.19,0.175,0.995,0.995]
  oplot,dblarr_x,dblarr_y,color=254
;  dblarr_y = dblarr_x + 0.11 * (1. - (1. - exp(-3.6 * (dblarr_x+0.55))))
;  oplot,dblarr_x,dblarr_y,color=254
;  dbl_ymin = min(dblarr_y)
;  oplot,[dbl_xmin,dbl_xmax],[dbl_ymin,dbl_ymin]

  device,/close
  loadct,0
  spawn,'ps2gif '+str_psfilename+' '+strmid(str_psfilename,0,strpos(str_psfilename,'.',/REVERSE_SEARCH)+1)+'gif'
;  if keyword_set(PRINTPDF) then begin
    spawn,'epstopdf '+str_psfilename
;  endif
;  spawn,'rm '+str_psfilename

end
