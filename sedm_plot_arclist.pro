pro sedm_plot_arclist
;  str_path = '/run/media/azuri/data/azuri/spectra/SEDIFU/Aug05/xe60+ne40+hg300rots_test/'
  str_path = '/run/media/azuri/data/azuri/spectra/SEDIFU/Aug05/'
;  str_filelist = str_path+'rebinned.list'
  str_filelist = str_path+'all_arcs_D.list'
;  str_filelist = str_path+'to_rebin.list'
;  str_filelist = str_path+'XeD_good.list'
;  str_coeffslist = str_path+'coeffs.list'
  str_coeffslist = str_path+'all_good_arcs_coeffs.list'
  str_ytitle = 'Counts [photons]'
  str_linelist = '/home/azuri/stella/linelists/SEDMIFU_s_wlen_pix_255long_14lines.dat'

  strarr_files = readfilelinestoarr(str_filelist)
  strarr_cfiles = readfilelinestoarr(str_coeffslist)
  strarr_lines = double(readfiletostrarr(str_linelist, ' '))
  dbl_xmin = 9000.
  dbl_xmax = 100.
  dbl_ymax = 0.
  dbl_maxrms = 50.
  dblarr_rms = dblarr(n_elements(strarr_cfiles))
  for i=0ul, n_elements(strarr_files)-1 do begin
    strarr_coeffs = readfiletostrarr(str_path+strarr_cfiles(i),' ')
    size_strarr_coeffs = size(strarr_coeffs)
    dblarr_rms(i) = double(strarr_coeffs(size_strarr_coeffs(1)-1,1))
    print,'dblarr_rms(',i,') = ',dblarr_rms(i)
    if (dblarr_rms(i) lt dbl_maxrms) and (dblarr_rms(i) ge 0.00001) then begin
      dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
      if dbl_xmin gt min(dblarr_data(*,0)) then dbl_xmin = min(dblarr_data(*,0))
      if dbl_xmax lt max(dblarr_data(*,0)) then dbl_xmax = max(dblarr_data(*,0))
      if dbl_ymax lt max(dblarr_data(*,1)) then dbl_ymax = max(dblarr_data(*,1))
    endif
  endfor
  yrange=[0, dbl_ymax]
  xrange=[3300., 10000.]

  set_plot,'ps'
  str_plotname = strmid(str_filelist,0,strpos(str_filelist,'.',/REVERSE_SEARCH))+'.ps'
  device,filename=str_plotname,/color
  plotted = 0
  for i=0ul, n_elements(strarr_files)-1 do begin
    dblarr_data = double(readfiletostrarr(str_path+strarr_files(i),' '))
    if dblarr_rms(i) lt dbl_maxrms then begin
      if plotted eq 0 then begin
        plot,dblarr_data(*,0),$
             dblarr_data(*,1),$
             xrange=xrange,$
             xstyle=1,$
             yrange=yrange,$
             ystyle=1,$
             xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
             ytitle=str_ytitle,$
             position=[0.15,0.15,0.97,0.995],$
             thick=1,$
             charsize=1.2,$
             charthick=3.
        loadct,13
        plotted = 1
      endif
      oplot,dblarr_data(*,0),$
            dblarr_data(*,1),$
            thick=1,$
            color = 2 + 252*i/n_elements(strarr_files)
;      oplot,[7500,7800],$
;            [yrange(1) - yrange(1)/20. - yrange(1)*i/20.,yrange(1) - yrange(1)/20. - yrange(1)*i/20.],$
;            color = 2 + 252*i/n_elements(strarr_files),$
;            thick=3
;      str_star = strmid(strarr_files(i),strpos(strarr_files(i),'/')+1)
;      str_star = strmid(str_star, 0, strpos(str_star,'_'))
;      xyouts,7900,yrange(1) - yrange(1)/17. - yrange(1)*i/20.,str_star,charsize=1.2,charthick=3.
    endif
  endfor

  loadct,0
  for i=0ul, n_elements(strarr_lines(*,0))-1 do begin
    print,'i = ',i,': line at ',strarr_lines(i,0)
    oplot,[double(strarr_lines(i,0)),double(strarr_lines(i,0))], yrange
  endfor
  
  device,/close
  set_plot,'x'
end

