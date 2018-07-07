pro resample_uves_paper_piskunov
  str_filename_signal = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/resampled_ff_science_redu_0000_ap4_plot.text'
  str_filename_out_signal = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/resampled_ff_science_redu_0000_ap4_plot_wlen.text'
  str_filename_out_plot_signal = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/resampled_ff_science_redu_0000_ap4_5886_8-5896_5.text'
  str_filename_interp_plot_signal = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/resampled_ff_science_redu_0000_ap4_interp_5886_8-5896_5.text'
  str_filename_sigma = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/sigma_ff_science_redu_0000_ap4.text'
  str_filename_out_sigma = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/sigma_ff_science_redu_0000_ap4_plot_wlen.text'
  str_filename_out_plot_sigma = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/sigma_ff_science_redu_0000_ap4_5886_8-5896_5.text'
  str_filename_stella = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/Tel1_no_xcor/LMC-X1_rl_2000-01-12T01-48-55.757_564_1200s_botzfxsEcTel1_ap13DSNR.text'
  str_filename_snr = '/home/azuri/spectra/elaina/gasgano_out/blazecorr/tiltcorr/resampled_ff_science_redu_0000_ap4_interp_5886_8-5896_5_SNR.text'
  
  d_wlen_start = 5886.8
  d_wlen_end = 5896.5
  
  w_start = 5817.75740614463
  
  strarr_sigma = readfiletostrarr(str_filename_sigma,' ')
  print,'strarr_sigma = ',size(strarr_sigma),': ',strarr_sigma
  
  strarr_stella = readfiletostrarr(str_filename_stella,' ')
  print,'strarr_stella = ',size(strarr_stella),': ',strarr_stella
  
  openw,lun,str_filename_out_sigma,/GET_LUN
    for i=0ul, n_elements(strarr_sigma)-1 do begin
      printf,lun,strarr_stella(n_elements(strarr_sigma)-i-1,0)+' '+strarr_sigma(i)
    endfor
  free_lun,lun
  
  dblarr_sigma = double(readfiletostrarr(str_filename_out_sigma,' '))
  dblarr_signal = double(readfiletostrarr(str_filename_signal,' '))
  dblarr_signal(*,0) = dblarr_signal(*,0) + w_start
  
  size_signal = size(dblarr_signal)
  print,'size(dblarr_signal) = ',size_signal
  openw,lun,str_filename_out_signal,/GET_LUN
    for i=0ul, size_signal(1)-1 do begin
      printf,lun,dblarr_signal(i,0),' ',dblarr_signal(i,1)
    endfor
  free_lun,lun
  
  indarr_signal = where(dblarr_signal(*,0) ge d_wlen_start)
  dblarr_signal = dblarr_signal(indarr_signal,*)
  indarr_signal = where(dblarr_signal(*,0) le d_wlen_end)
  dblarr_signal = dblarr_signal(indarr_signal,*)
  size_signal = size(dblarr_signal)
  print,'size(dblarr_signal) = ',size_signal
  openw,lun,str_filename_out_plot_signal,/GET_LUN
    for i=0ul, size_signal(1)-1 do begin
      printf,lun,dblarr_signal(i,0),' ',dblarr_signal(i,1)
    endfor
  free_lun,lun
  
  indarr_sigma = where(dblarr_sigma(*,0) ge d_wlen_start)
  dblarr_sigma = dblarr_sigma(indarr_sigma,*)
  indarr_sigma = where(dblarr_sigma(*,0) le d_wlen_end)
  dblarr_sigma = dblarr_sigma(indarr_sigma,*)
  size_sigma = size(dblarr_sigma)
  print,'size(dblarr_sigma) = ',size_sigma
  openw,lun,str_filename_out_plot_sigma,/GET_LUN
    for i=0ul, size_sigma(1)-1 do begin
      printf,lun,dblarr_sigma(i,0),' ',dblarr_sigma(i,1)
    endfor
  free_lun,lun

  dblarr_wlen_sigma = dblarr_sigma(*,0)
  dblarr_interp_signal = interpol(dblarr_signal(*,1), dblarr_signal(*,0), dblarr_wlen_sigma)
  
  dblarr_signal = dblarr(n_elements(dblarr_wlen_sigma),2)
  dblarr_signal(*,0) = dblarr_wlen_sigma
  dblarr_signal(*,1) = dblarr_interp_signal
  openw,lun,str_filename_interp_plot_signal,/GET_LUN
    for i=0ul, n_elements(dblarr_wlen_sigma)-1 do begin
      printf,lun,dblarr_signal(i,0),' ',dblarr_signal(i,1)
    endfor
  free_lun,lun

  openw,lun,str_filename_snr,/GET_LUN
    for i=0ul, n_elements(dblarr_wlen_sigma)-1 do begin
      printf,lun,dblarr_signal(i,0),' ',dblarr_signal(i,1) / dblarr_sigma(i,1)
    endfor
  free_lun,lun
  
end
