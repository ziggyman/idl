pro plot_histogram,dblarr_data,$
                   str_plotname_root,$
                   XTITLE=xtitle,$
                   YTITLE=ytitle,$
                   NBINS=nbins,$
                   TITLE=title,$
                   XRANGE=xrange,$
                   YRANGE=yrange,$
                   OVERPLOT=overplot,$
                   MORETOCOME=moretocome,$
                   NORMALISE=normalise,$
                   I_B_PLOT_GAUSSFIT = i_b_plot_gaussfit
;
; NAME:                  plot_histogram.pro
; PURPOSE:               plots histogram
; CATEGORY:              rave
; CALLING SEQUENCE:      plot_histogram
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

;  print,'plot_histogram: dblarr_data = ',dblarr_data

; --- parameters
  if not keyword_set(NBINS) then begin
    nbins = 10
  end
  print,'plot_histogram: nbins = ',nbins
  if not keyword_set(XRANGE) then begin
    xrange_plot=dblarr(2)
    xrange_plot(0) = min(dblarr_data)
    xrange_plot(1) = max(dblarr_data)
  end else begin
    xrange_plot = xrange
  end
  print,'plot_histogram: xrange = ',xrange
  if not keyword_set(YRANGE) then begin
    yrange_plot=dblarr(2)
    yrange_plot(0) = 0
  end else begin
    yrange_plot = yrange
  end

  ; --- snr bin ranges
  dblarr_bins = dblarr(nbins+1)
  dblarr_bins(0) = xrange(0)

  ; --- snr bin counts
  intarr_bin_counts = dblarr(nbins)

  dbl_binwidth = (xrange(1) - xrange(0)) / nbins
  print,'plot_histogram: dbl_binwidth = ',dbl_binwidth

;  openw,lun,'/home/azuri/daten/rave/rave_data/release5/html/index.html',/GET_LUN
;  printf,lun,'<html><body><center>'
;  printf,lun,'S/N for different Imag bins<br><hr>'
;  printf,lun,'<br>NOTE: If no S/N is given in the data release, S/N was set to -10<br>'
;  printf,lun,'This does not mean that the star did not deliver stellar parameters<br><br><hr>'

  for i=0,nbins-1 do begin
    dblarr_bins(i+1) = dblarr_bins(i) + dbl_binwidth
;    print,'i = ',i,': binrange = ',dblarr_bins(i),'...',dblarr_bins(i+1)
    if i eq 0 then begin
      indarr = where((dblarr_data ge dblarr_bins(i)) and (dblarr_data le dblarr_bins(i+1)))
    end else begin
      indarr = where((dblarr_data gt dblarr_bins(i)) and (dblarr_data le dblarr_bins(i+1)))
    end

    intarr_bin_counts(i) = n_elements(indarr)
    if intarr_bin_counts(i) eq 1 then begin
      if indarr eq -1 then intarr_bin_counts(i) = 0
    end
  end
  if keyword_set(NORMALISE) then begin
    intarr_bin_counts = double(intarr_bin_counts) * normalise
  endif

; --- number of rejected stars over Imag
  if not keyword_set(OVERPLOT) then begin
    set_plot,'ps'
    str_psfilename=str_plotname_root+'.ps'
    str_giffilename=str_plotname_root+'.gif'
    str_pdffilename=str_plotname_root+'.pdf'
    device,filename=str_psfilename
  endif
  if not keyword_set(YRANGE) then begin
    yrange_plot(1) = max(intarr_bin_counts)+(max(intarr_bin_counts)/20.)
  endif
  if not keyword_set(OVERPLOT) then begin
    plot,[xrange_plot(0),xrange_plot(1)],$
         [0.,0.],$
         xrange=xrange_plot,$
         yrange=yrange_plot,$
         xstyle=1,$
         ystyle=1,$
         xtitle=xtitle,$
         ytitle=ytitle,$
         title=title,$
         thick=2.,$
         charsize=2.,$
         charthick=2.,$
         xticks=4
  endif
;    print,'plot_histogram: plotting intarr_bin_counts = ',intarr_bin_counts
  for k=0, nbins-1 do begin
;    print,'plot_histogram: ',dblarr_bins(k),'-',dblarr_bins(k+1),': ',intarr_bin_counts(k)
    if not keyword_set(OVERPLOT) then begin
      oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_bin_counts(k)]
      oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_bin_counts(k)]
      oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_bin_counts(k),intarr_bin_counts(k)]
    end else begin
      oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_bin_counts(k)],linestyle=2
      oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_bin_counts(k)],linestyle=2
      oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_bin_counts(k),intarr_bin_counts(k)],linestyle=2
    end
  endfor
  if keyword_set(I_B_PLOT_GAUSSFIT) then begin
    dblarr_x = dblarr_bins(0:n_elements(dblarr_bins)-2) + ((dblarr_bins(1:n_elements(dblarr_bins)-1)-dblarr_bins(0:n_elements(dblarr_bins)-2)) / 2.)
    dblarr_fit = gaussfit(dblarr_x, intarr_bin_counts, dblarr_gaussfit_coeffs, NTERMS=3, MEASURE_ERRORS=sqrt(intarr_bin_counts))
    print,'dblarr_fit = ',dblarr_fit
    print,'dblarr_gaussfit_coeffs = ',dblarr_gaussfit_coeffs
    oplot,dblarr_x,dblarr_fit,linestyle=0,thick=3
    dblarr_moments = moment(dblarr_data)
    dblarr_moments(1) = sqrt(dblarr_moments(1))
    print_moments,I_DBLARR_MOMENT = dblarr_moments,$
                  I_DBLARR_XRANGE = xrange_plot,$
                  I_DBLARR_YRANGE = yrange_plot
  endif
  if not keyword_set(MORETOCOME) then begin
    device,/close
    spawn,'ps2gif '+str_psfilename+' '+str_giffilename
    spawn,'epstopdf '+str_psfilename
    spawn,'rm '+str_psfilename
  end

end
