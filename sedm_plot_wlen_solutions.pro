pro sedm_plot_wlen_solutions
  str_list_in = '/home/azuri/spectra/SEDIFU/commissioning/June20/ne+hg+xe_20130621_ssEcSum_aps_coeffs.list'
  
  str_skylist_in = '/media/ubuntu64/azuri/spectra/SEDIFU/commissioning/June20/BD332642_360s_ifu20130619_22_36_02/BD332642_360s_ifu20130619_22_36_02_apsSky.list'
  str_objectlist_in = '/media/ubuntu64/azuri/spectra/SEDIFU/commissioning/June20/BD332642_360s_ifu20130619_22_36_02/BD332642_360s_ifu20130619_22_36_02_apsObject.list'

  intarr_aps_sky = long(readfilelinestoarr(str_skylist_in))
  intarr_aps_obj = long(readfilelinestoarr(str_objectlist_in))
  
  print,'intarr_aps_obj = ',intarr_aps_obj
  print,'intarr_aps_sky = ',intarr_aps_sky
  
  strarr_in = readfilelinestoarr(str_list_in)
  str_path = strmid(str_list_in,0,strpos(str_list_in,'/',/REVERSE_SEARCH)+1)
  print,'str_path = ',str_path
  
  openw,lun,str_path+'index_wlen.html',/GET_LUN
  printf,lun,'<html><body><center>'
  set_plot,'ps'
  for i=0ul, n_elements(strarr_in)-1 do begin
    indarr_sky = where(intarr_aps_sky eq i, count_sky)
    indarr_obj = where(intarr_aps_obj eq i, count_obj)

    if count_obj + count_sky gt 0 then begin
      print,'i = ',i
      print,'count_obj = ',count_obj
      print,'count_sky = ',count_sky
;      stop
      str_pix_wlen_fit = str_path+strmid(strarr_in(i),0,strpos(strarr_in(i),'.',/REVERSE_SEARCH))+'_PixWLenFit.dat'
      strarr_pix_wlen = readfiletostrarr(str_pix_wlen_fit,' ')
      print,'strarr_pix_wlen = ',strarr_pix_wlen
    
      str_spec = str_path+strmid(strarr_in(i),0,strpos(strarr_in(i),'_',/REVERSE_SEARCH)+1)+'d.text'
      print,'str_spec = <'+str_spec+'>'
      dblarr_spec = double(readfiletostrarr(str_spec,' '))
      str_plotname = strmid(str_spec,0,strpos(str_spec,'.',/REVERSE_SEARCH))
      print,'str_plotname = <'+str_plotname+'>'
      if n_elements(dblarr_spec) gt 2 then begin
        device,filename=str_plotname+'.ps'
          plot,dblarr_spec(*,0),$
               dblarr_spec(*,1),$
               xtitle = 'Wavelength',$
               ytitle = 'Photons',$
               xrange=[4000.,11000.],$
               xstyle=1
        device,/close
        spawn,'ps2gif '+str_plotname+'.ps '+str_plotname+'.gif'
        printf,lun,'<img src="'+strmid(str_plotname,strpos(str_plotname,'/',/REVERSE_SEARCH)+1)+'.gif"><br>'+strmid(str_plotname,strpos(str_plotname,'/',/REVERSE_SEARCH)+1)+'<br><hr>'
      endif
    endif
  endfor
  set_plot,'x'
  
  printf,lun,'</center></body></html>'
  free_lun,lun
end
