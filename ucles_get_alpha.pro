pro ucles_get_alpha
  str_filename = '/home/azuri/spectra/hermes/ThXe/file_list_alpha.list'
  str_index = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/index.html'
  openw,lun,str_index,/GET_LUN
  printf,lun,'<html><body><center>'

  strarr_files = readfilelinestoarr(str_filename)

  str_wc_argument = ''
  for i=0,n_elements(strarr_files)-1 do begin
    str_wc_argument = str_wc_argument + strarr_files(i)+' '
  endfor
  str_wc_out = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_wc-out.text'
  spawn,'wc '+str_wc_argument+' > '+str_wc_out

  strarr_wc_out = readfiletostrarr(str_wc_out,' ')

  for i=0, n_elements(strarr_wc_out(*,0))-2 do begin
    int_ndatalines = countdatlines(strarr_wc_out(i,3))
    print,'strarr_wc_out(i=',i,',3) = ',strarr_wc_out(i,3),': int_ndatalines = ',int_ndatalines
    if int_ndatalines gt 0 then begin
      dblarr_intensities = readfiletodblarr(strarr_wc_out(i,3))
      print,'ucles_get_alpha: dblarr_intensities = ',dblarr_intensities

      set_plot,'ps'
      str_plotname = strmid(strarr_wc_out(i,3),0,strpos(strarr_wc_out(i,3),'.',/REVERSE_SEARCH))+'_log.ps'
      device,filename=str_plotname
        indarr = where(dblarr_intensities(*,0) gt 0.)
        print,'i = ',i,': total(indarr) = ',total(indarr)
        if indarr(0) ge 0. then begin
          dblarr_log_ref = alog10(dblarr_intensities(indarr,0))
          dblarr_log_meas = alog10(dblarr_intensities(indarr,1))
          plot,dblarr_log_ref,$
               dblarr_log_meas,$
               xtitle = 'log(I!Dref!N)',$
               ytitle = 'log(I!Dmeasured!N)',$
               psym = 2,$
               thick=3.,$
               charsize = 2.,$
               charthick = 2.
          alpha = median(dblarr_log_meas / dblarr_log_ref)
          oplot,dblarr_log_ref,alpha*dblarr_log_ref
          alpha = mean(dblarr_log_meas / dblarr_log_ref)
          oplot,dblarr_log_ref,alpha*dblarr_log_ref,linestyle=5
          dblarr_linfit = linfit(dblarr_log_ref,dblarr_log_meas)
          alpha = dblarr_linfit(1)
          oplot,dblarr_log_ref,alpha*dblarr_log_ref+dblarr_linfit(0),linestyle=2
        endif
      device,/close
      str_giffile = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
      spawn,'ps2gif '+str_plotname+' '+str_giffile
      printf,lun,'<h2>'+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'</h2><br>'
      printf,lun,'<a href="'+str_giffile+'"><img src="'+str_giffile+'"></a><br><br><hr><br>'
    endif
  endfor
  printf,lun,'</center></body></html>'
  free_lun,lun
end
