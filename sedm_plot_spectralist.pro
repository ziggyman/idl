pro sedm_plot_spectralist
  str_path = '/media/external/azuri/spectra/SEDIFU/Jun21/';Aug06/';BD+28d_180s_ifu20130805_23_10_39rot/';xe60+ne40+hg300rots/'
;  str_filelist = str_path+'stdobs_sum_flux.list'
;  str_ytitle = 'Flux [erg s!E-1!N cm!E-2!N '+STRING("305B)+'!E-1!N]'
  str_ytitle = 'Throughput'
;  str_filelist = str_path+'stdobs-sky.list'
;  str_filelist = str_path+'stdobs_sky_t.list'
;  str_ytitle = 'ADUs ???'
;  str_ytitle = 'Counts [photons]'
;  str_ytitle = 'Counts [photons, re-binned]'
;  str_filelist = str_path+'to_plot_ngc6210.list'
;  str_filelist = str_path+'sum.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEcDR_Obs-Sky_Sum_toFlux.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEcDR_Obs-Sky_Sum-Ext_Throughput.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEc_ap829_x1001_y965D.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEcD_apsObject_Sum_toFlux.list'
;  str_filelist = str_path+'b_ifu20130805_23_10_39_SpecBDR_Flux_throughput.list'
;  str_filelist = str_path+'b_ifu20130805_23_10_39_SpecBG_Flux_Throughput.list'
;  str_filelist = str_path+'obs_D_with_sky_sum.list'
;  str_filelist = str_path+'throughputs.list'
;  str_filelist = str_path+'objects_airmasscorr_part9.list'
;  str_filelist = str_path+'throughputs_with_extcor.list'
;  str_filelist = str_path+'throughputs_good_fit.list'
;  str_filelist = str_path+'throughputs+fit.list'
;  str_filelist = str_path+'objects_fluxcalib.list'
;  str_filelist = str_path+'objects_airmasscorr.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEcD_apsObject_text.list'
;  str_filelist = str_path+'objects_Sum.list'
;  str_filelist = str_path+'BD+28d_180s_ifu20130805_23_10_39rotEcDR_Obs-Sky_Sum.list'
;  str_filelist = str_path+'sao_10s_ifu20130805_20_35_38rot_apsObjectD.list'
;  str_filelist = str_path+'hygiea_120s_ifu20130806_03_17_27rot_apsObjectD.list'
  str_filelist = str_path+'std_throughputs_fit.list'
;  str_filelist = str_path+'std_flux.list'

  i_ycol = 1

  b_plot_legend = 1
  b_plot_lines = 1
;  str_linelist = '/home/azuri/stella/linelists/SEDMIFU_s_wlen_pix_255long_14lines.dat'
;  str_linelist = str_path+'lines_ngc.dat'
  str_linelist = str_path+'lines_aband.dat'
  strarr_lines = double(readfiletostrarr(str_linelist, ' '))

  strarr_files = readfilelinestoarr(str_filelist)
  
  dbl_xmin = 9000.
  dbl_xmax = 100.
  dbl_ymax = 0.
  for i=0ul, n_elements(strarr_files)-1 do begin
    dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
    if dbl_xmin gt min(dblarr_data(*,0)) then dbl_xmin = min(dblarr_data(*,0))
    if dbl_xmax lt max(dblarr_data(*,0)) then dbl_xmax = max(dblarr_data(*,0))
    if dbl_ymax lt max(dblarr_data(*,1)) then dbl_ymax = max(dblarr_data(*,i_ycol))
  endfor
  xrange=[dbl_xmin, dbl_xmax]
  yrange=[0., 0.3];
  xrange=[3600.,9500.]

  dbl_legend_x = xrange(0) + ((xrange(1) - xrange(0)) / 2.5)
  dbl_legend_y = yrange(1) - (yrange(1)/ 30)

  set_plot,'ps'
  str_plotname = strmid(str_filelist,0,strpos(str_filelist,'.',/REVERSE_SEARCH))+'.ps'
  device,filename=str_plotname,/color
  for i=0ul, n_elements(strarr_files)-1 do begin
    dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
    if i eq 0 then begin
      plot,dblarr_data(*,0),$
           dblarr_data(*,i_ycol),$
           xrange=xrange,$
           xstyle=1,$
           yrange=yrange,$
           ystyle=1,$
           xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
           ytitle=str_ytitle,$
           position=[0.15,0.11,0.99,0.95],$
           thick=3,$
           charsize=1.,$
           charthick=3.,$
           title=strmid(str_filelist,strpos(str_filelist,'/',/REVERSE_SEARCH)+1)
      loadct,13
    endif
    oplot,dblarr_data(*,0),$
          dblarr_data(*,i_ycol),$
          thick=3,$
          color = 2 + 252*i/n_elements(strarr_files)
    if b_plot_legend eq 1 then begin
      oplot,[dbl_legend_x,dbl_legend_x+((xrange(1)-xrange(0))/15.)],$
            [dbl_legend_y - yrange(1)*i/20.,dbl_legend_y - yrange(1)*i/20.],$
            color = 2 + 252*i/n_elements(strarr_files),$
            thick=3
      str_star = strmid(strarr_files(i),strpos(strarr_files(i),'/')+1)
      str_star = strmid(str_star, 0, strpos(str_star,'_'))
      xyouts,dbl_legend_x+((xrange(1)-xrange(0))/13.),dbl_legend_y - yrange(1)/80. - yrange(1)*i/20.,str_star,charsize=1.2,charthick=3.
    endif
  endfor

  loadct,0
  if b_plot_lines eq 1 then begin
    for i=0ul, n_elements(strarr_lines(*,0))-1 do begin
      print,'i = ',i,': line at ',strarr_lines(i,0)
      oplot,[double(strarr_lines(i,0)),double(strarr_lines(i,0))], yrange
    endfor
  endif
  
  device,/close
  set_plot,'x'
end

