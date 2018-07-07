pro sedm_plot_object_spectra

  str_filename_inputlist = '~/spectra/SEDIFU/commissioning/Aug08/bd+28d4211_5s_ifu20130808_23_05_49r/to_plot.list'
  
  str_filename_aps_object = '~/spectra/SEDIFU/commissioning/Aug08/bd+28d4211_5s_ifu20130808_23_05_49r/bd+28d4211_5s_ifu20130808_23_05_49r_apsObject.list'
  
  str_path = strmid(str_filename_inputlist,0,strpos(str_filename_inputlist,'/',/REVERSE_SEARCH)+1)
  str_htmlfile = str_path+'index.html'
  print,'str_htmlfile = <'+str_htmlfile+'>'
;  stop

  openw,lun,str_htmlfile,/GET_LUN
  printf,lun,'<html><body><center>'
  
  strarr_fnames = readfilelinestoarr(str_filename_inputlist)
  strarr_aps_obj = readfilelinestoarr(str_filename_aps_object)
  
  xmin = 10000.
  xmax = 0.
  ymin = 1000.
  ymax = 0.
  for i=0ul, n_elements(strarr_fnames)-1 do begin
    str_aps = strmid(strarr_fnames(i),strpos(strarr_fnames(i),'_ap')+3)
    str_aps = strmid(str_aps,0,strpos(str_aps,'_'))
    print,'strarr_fnames(',i,') = <'+strarr_fnames(i)+'>'
    print,'str_aps = <'+str_aps+'>'
    for j=0ul, n_elements(strarr_aps_obj)-1 do begin
      if str_aps eq strarr_aps_obj(j) then begin
        dblarr_inputspec = double(readfiletostrarr(str_path+strarr_fnames(i), ' '))
        if min(dblarr_inputspec(*,0)) lt xmin then $
          xmin = min(dblarr_inputspec(*,0))
        if max(dblarr_inputspec(*,0)) gt xmax then $
          xmax = max(dblarr_inputspec(*,0))
        if min(dblarr_inputspec(*,1)) lt ymin then $
          ymin = min(dblarr_inputspec(*,1))
        if max(dblarr_inputspec(*,1)) gt ymax then $
          ymax = max(dblarr_inputspec(*,1))
      endif
    endfor
  endfor
  print,'xmin = ',xmin
  print,'xmax = ',xmax
  print,'ymin = ',ymin
  print,'ymax = ',ymax
;  stop
  dblarr_sum = dblarr(n_elements(dblarr_inputspec(*,0)),2)
  dblarr_sum(*,0) = dblarr_inputspec(*,0)
  dblarr_sum(*,1) = 0.
  for i=0ul, n_elements(strarr_fnames)-1 do begin
    str_aps = strmid(strarr_fnames(i),strpos(strarr_fnames(i),'_ap')+3)
    str_aps = strmid(str_aps,0,strpos(str_aps,'_'))
    print,'strarr_fnames(',i,') = <'+strarr_fnames(i)+'>'
    print,'str_aps = <'+str_aps+'>'
    for j=0ul, n_elements(strarr_aps_obj)-1 do begin
      if str_aps eq strarr_aps_obj(j) then begin
        dblarr_inputspec = double(readfiletostrarr(str_path+strarr_fnames(i), ' '))
        dblarr_sum(*,1) = dblarr_sum(*,1) + dblarr_inputspec(*,1)
        str_plotname_out = str_path+strmid(strarr_fnames(i),0,strpos(strarr_fnames(i), '.', /REVERSE_SEARCH))+'.ps'
        print,'str_plotname_out = <'+str_plotname_out+'>'
;    stop
        set_plot,'ps'
        device,filename=str_plotname_out
        plot,dblarr_inputspec(*,0),$
             dblarr_inputspec(*,1),$
             thick=1,$
             ytitle='Counts [electrons]',$
             xrange=[xmin, xmax],$
             xstyle=1,$
             yrange=[ymin, ymax],$
             ystyle=1,$
             charsize=1.8,$
             charthick=2,$
             position=[0.175, 0.36, 0.98, 0.95],$
             title = strmid(strarr_fnames(i),strpos(strarr_fnames(i),'/',/REVERSE_SEARCH)+1)
  
        device,/close
        set_plot,'x'
 
        str_giffilename = strmid(str_plotname_out,0,strpos(str_plotname_out,'.',/REVERSE_SEARCH))+'.gif'
        print,'str_giffilename = <'+str_giffilename+'>'
;    stop
        spawn,'ps2gif '+str_plotname_out+' '+str_giffilename
        printf,lun,'<a href="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"></a><br>'
      endif
    endfor
  endfor
  str_plotname_out = str_path+'obj_sum.ps'
  print,'str_plotname_out = <'+str_plotname_out+'>'
;    stop
  set_plot,'ps'
  device,filename=str_plotname_out
  plot,dblarr_sum(*,0),$
       dblarr_sum(*,1),$
       thick=1,$
       ytitle='Counts [electrons]',$
       xrange=[xmin, xmax],$
       xstyle=1,$
;       yrange=[ymin, ymax],$
;       ystyle=1,$
       charsize=1.8,$
       charthick=2,$
       position=[0.175, 0.36, 0.98, 0.95],$
       title = 'sum object spectra'
  
  device,/close
  set_plot,'x'
 
  str_giffilename = strmid(str_plotname_out,0,strpos(str_plotname_out,'.',/REVERSE_SEARCH))+'.gif'
  print,'str_giffilename = <'+str_giffilename+'>'
;    stop
  spawn,'ps2gif '+str_plotname_out+' '+str_giffilename
  printf,lun,'<a href="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"></a><br>'
  printf,lun,'</center></body></html>'
  free_lun,lun
end
