pro sedm_plot_spectra, str_filename_inputspec,$
                       str_filename_outputspec,$
                       str_plotname_out,$
                       xmin,$
                       xmax,$
                       ymin,$
                       ymax,$
                       STR_FILENAME_BLAZE=str_filename_blaze
  dblarr_inputspec = double(readfiletostrarr(str_filename_inputspec, ' '))
  dblarr_inputspec(*,1) = dblarr_inputspec(*,1) * dblarr_inputspec(*,0)
;  dblarr_inputspec(*,0) = dblarr_inputspec(*,0) * 10000000000.
  print,'dblarr_inputspec(0,*) = ',dblarr_inputspec(0,*)
  if keyword_set(STR_FILENAME_BLAZE) then $
    dblarr_blaze=readfiletostrarr(str_filename_blaze,' ')
  
  print,string(dblarr_inputspec)
  
;  write_file,I_STRARR_DATA=strtrim(string(dblarr_inputspec),2),I_STR_FILENAME= strmid(str_filename_inputspec,0,strpos(str_filename_inputspec,'.',/REVERSE_SEARCH))+'_ang.dat'
  
  dblarr_outputspec = double(readfiletostrarr(str_filename_outputspec, ' '))

  if keyword_set(STR_FILENAME_BLAZE) then $
    indarr_blaze = where(dblarr_blaze(*,0) ge 3700. and dblarr_blaze(*,0) le 9200.)
  indarr_outputspec = where(dblarr_outputspec(*,0) ge 3700. and dblarr_outputspec(*,0) le 9200.)
  indarr_inputspec = where(dblarr_inputspec(*,0) ge 3700. and dblarr_inputspec(*,0) le 9200.)
  if n_elements(indarr_inputspec) ne n_elements(indarr_outputspec) then begin
    print,'n_elements(indarr_inputspec)=',n_elements(indarr_inputspec),' ne n_elements(indarr_outputspec)=',n_elements(indarr_outputspec)
    stop
  endif
  if keyword_set(STR_FILENAME_BLAZE) then $
    dblarr_inputspec(indarr_inputspec,1) = dblarr_inputspec(indarr_inputspec,1) / dblarr_blaze(indarr_blaze,1)
  dblarr_inputspec(*,1) = dblarr_inputspec(*,1) * mean(dblarr_outputspec(*,1)) / mean(dblarr_inputspec(*,1))
  dblarr_res = dblarr_inputspec(indarr_inputspec,*)
  dblarr_res(*,1) = dblarr_inputspec(indarr_inputspec,1) - dblarr_outputspec(indarr_outputspec, 1)
  
  if keyword_set(STR_FILENAME_BLAZE) then begin
    set_plot,'ps'
    device,filename=strmid(str_filename_blaze,0,strpos(str_filename_blaze,'.',/REVERSE_SEARCH))+'.ps'
    plot,dblarr_blaze(*,0),$
         dblarr_blaze(*,1),$
         ytitle='Flux [ADU]',$
         xrange=[xmin, xmax],$
         xstyle=1,$
         charsize=1.8,$
         charthick=2,$
         thick=3
    device,/close
    set_plot,'x'
    spawn,'ps2gif '+strmid(str_filename_blaze,0,strpos(str_filename_blaze,'.',/REVERSE_SEARCH))+'.ps'+' '+strmid(str_filename_blaze,0,strpos(str_filename_blaze,'.',/REVERSE_SEARCH))+'.gif'
  endif

  set_plot,'ps'
  device,filename=str_plotname_out,/color
  loadct,13
  plot,dblarr_inputspec(*,0),$
       dblarr_inputspec(*,1),$
       thick=1,$
       ytitle='Flux [ADU]           ',$
       xrange=[xmin, xmax],$
       xstyle=1,$
       yrange=[ymin, ymax],$
       ystyle=1,$
       xtickname=[' ',' ',' ',' ',' ',' '],$
       charsize=1.8,$
       charthick=2,$
;       color=100,$
       position=[0.175, 0.36, 0.98, 0.99];,$
;       /YLOG
;       linethick=3

; --- plot input spectrum
  oplot,dblarr_inputspec(*,0),$
        dblarr_inputspec(*,1),$
        thick=3,$
        color=50
  oplot,[xmax-(xmax-xmin)/3.,xmax-(xmax-xmin)/3.+(xmax-xmin)/10.],$
        [ymax-(ymax-ymin)/10.,ymax-(ymax-ymin)/10.],$
        color=50
  xyouts,xmax-(xmax-xmin)/3.+(xmax-xmin)/9.5,ymax-(ymax-ymin)/9.,'Input Spectrum'
; --- plot output spectrum
  oplot,dblarr_outputspec(*,0),$
        dblarr_outputspec(*,1),$
        color=250,$
        thick=3
  oplot,[xmax-(xmax-xmin)/3.,xmax-(xmax-xmin)/3.+(xmax-xmin)/10.],$
        [ymax-1.6*(ymax-ymin)/10.,ymax-1.6*(ymax-ymin)/10.],$
        color=250
  xyouts,xmax-(xmax-xmin)/3.+(xmax-xmin)/9.5,ymax-1.7*(ymax-ymin)/10.,'Output Spectrum'
        
  plot,dblarr_res(*,0),$
       dblarr_res(*,1),$
       xrange=[xmin,xmax],$
       yrange=[min(dblarr_res(*,1)),max(dblarr_res(*,1))],$
       xstyle=1,$
       charsize=1.8,$
       charthick=2,$
       /noerase,$
       position=[0.175, 0.165,0.98,0.36],$
       xtitle='Wavelength ['+STRING("305B)+']'
  
  device,/close
  set_plot,'x'
  
  spawn,'ps2gif '+str_plotname_out+' '+strmid(str_plotname_out,0,strpos(str_plotname_out,'.',/REVERSE_SEARCH))+'.gif'
end
