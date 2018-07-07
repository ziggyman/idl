pro rave_plot_snr
;
; NAME:                  rave_plot_snr.pro
; PURPOSE:               plots histograms for snr in Imag-bins
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_plot_snr
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

; --- parameters
  i_nbins_imag = 10
  i_nbins = 10
  str_datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles-1st_release.dat'

  strarr_data = readfiletostrarr(str_datafile,' ')

  dblarr_snr = double(strarr_data(*,31))
  dblarr_Imag = double(strarr_data(*,12))

  ; --- S/N over Imag
  set_plot,'ps'
  str_psfilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.ps'
  str_giffilename = '/suphys/azuri/daten/rave/rave_data/release5/SNR_over_Imag.gif'
  device,filename=str_psfilename
  plot,dblarr_Imag,dblarr_snr,xrange=[9.,12.],xstyle=1,xtitle='I [mag]',ytitle='S/N',psym=2,symsize=0.2
  device,/close
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename

  ; --- Imag bin ranges
  dblarr_bins_imag = dblarr(i_nbins_imag+1)
  dblarr_bins_imag(0) = 9.

  ; --- snr bin ranges
  dblarr_bins = dblarr(i_nbins+2)
  dblarr_bins(0) = -10.

  ; --- snr bin counts
  intarr_snr_bins = dblarr(i_nbins+2)

  dbl_binwidth_imag = 3. / i_nbins_imag
  print,'dbl_binwidth_imag = ',dbl_binwidth_imag

  openw,lun,'/suphys/azuri/daten/rave/rave_data/release5/html/index.html',/GET_LUN
  printf,lun,'<html><body><center>'
  printf,lun,'S/N for different Imag bins<br><hr>'
  printf,lun,'<br>NOTE: If no S/N is given in the data release, S/N was set to -10<br>'
  printf,lun,'This does not mean that the star did not deliver stellar parameters<br><br><hr>'

  for i=0,i_nbins_imag-1 do begin
    dblarr_bins_imag(i+1) = dblarr_bins_imag(i) + dbl_binwidth_imag
    print,'i = ',i,': imag = ',dblarr_bins_imag(i),'...',dblarr_bins_imag(i+1)
    indarr = where((dblarr_Imag ge dblarr_bins_imag(i)) and (dblarr_Imag lt dblarr_bins_imag(i+1)))

    ; --- array of stars' Imags in imag bin
    dblarr_imag_bin = dblarr_Imag(indarr)

    ; --- array of stars' SNRs in imag bin
    dblarr_snr_bin = dblarr_snr(indarr)

    dbl_max_snr = 100.;max(dblarr_snr_bin)
    dbl_binwidth = dbl_max_snr / i_nbins
    print,'dbl_binwidth = ',dbl_binwidth
    for j=0,i_nbins do begin
      if j eq 0 then begin
        dblarr_bins(1) = 0.
      end else begin
        dblarr_bins(j+1) = dblarr_bins(j)+dbl_binwidth
      end
      indarr = where((dblarr_snr_bin ge dblarr_bins(j)) and (dblarr_snr_bin lt dblarr_bins(j+1)))
      intarr_snr_bins(j) = n_elements(indarr)
    endfor

    ; --- number of rejected stars over Imag
    set_plot,'ps'
    str_psfilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_snr_Imag_'+strtrim(string(dblarr_bins_imag(i)),2)+'-'+strtrim(string(dblarr_bins_imag(i+1)),2)+'.ps'
    str_giffilename='/suphys/azuri/daten/rave/rave_data/release5/html/nstars_snr_Imag_'+strtrim(string(dblarr_bins_imag(i)),2)+'-'+strtrim(string(dblarr_bins_imag(i+1)),2)+'.gif'
    str_from = strtrim(string(dblarr_bins_imag(i)),2)
    str_to = strtrim(string(dblarr_bins_imag(i+1)),2)
    str_pdffilename='/suphys/azuri/daten/rave/rave_data/release5/nstars_snr_Imag_'+strmid(str_from,0,strpos(str_from,'.'))+'_'+strmid(str_from,strpos(str_from,'.')+1,1)+'-'+strmid(str_to,0,strpos(str_to,'.'))+'_'+strmid(str_to,strpos(str_to,'.')+1,1)+'.pdf'
    device,filename=str_psfilename

    plot,[-10.,dbl_max_snr],$
         [0.,0.],$
         xrange=[-10.,dbl_max_snr],$
         yrange=[0,max(intarr_snr_bins)],$
         xstyle=1,$
         ystyle=1,$
         xtitle='S/N',$
         ytitle='Number of stars',title=strmid(str_from,0,strpos(str_from,'.')+2)+' <= I <= '+strmid(str_to,0,strpos(str_to,'.')+2),$
         charsize=2.,$
         charthick=2.,$
         thick=2.
    for k=0, i_nbins-1 do begin
      oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_snr_bins(k)]
      oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_snr_bins(k)]
      oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_snr_bins(k),intarr_snr_bins(k)]
    endfor
    device,/close
    spawn,'ps2gif '+str_psfilename+' '+str_giffilename
    spawn,'epstopdf '+str_psfilename
    print,'moving '+strmid(str_psfilename,0,strpos(str_psfilename,'.',/REVERSE_SEARCH))+'.pdf to '+str_pdffilename
    spawn,'mv '+strmid(str_psfilename,0,strpos(str_psfilename,'.',/REVERSE_SEARCH))+'.pdf '+str_pdffilename

    printf,lun,'Imag = '+strtrim(string(dblarr_bins_imag(i)),2)+'-'+strtrim(string(dblarr_bins_imag(i+1)),2)
    printf,lun,'<br><img src="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"><br><hr><br>'
  endfor

  printf,lun,'</body></html>'
  free_lun,lun

end
