pro plot_shadesurf_paper_piskunov
  str_filenames_in = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/ap13Rec_1573-1637_914-1363_text.list'
  str_path = strmid(str_filenames_in,0,strpos(str_filenames_in,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'
  strarr_filenames_in = readfilelinestoarr(str_filenames_in)
  
  print,'strarr_filenames_in = ',strarr_filenames_in
  str_htmlfilename = str_path+'shade_surfs.html'
  openw,lun,str_htmlfilename,/GET_LUN
  printf,lun,'<html><body><center>'  
  set_plot,'ps'
  for i=0ul, n_elements(strarr_filenames_in)-1 do begin
    ztitle = 'Counts [ADUs]'
    if (strpos(strarr_filenames_in(i),'SkyRec') gt 0) or (strpos(strarr_filenames_in(i),'SkyFitRec') gt 0) or (strpos(strarr_filenames_in(i),'_sky_') gt 0) then begin
      zrange=[0,40]
    end else if (strpos(strarr_filenames_in(i),'sRec') gt 0) or (strpos(strarr_filenames_in(i),'xRec') gt 0) then begin
      zrange=[0,100]
    end else if (strpos(strarr_filenames_in(i),'Orig') gt 0) or (strpos(strarr_filenames_in(i),'+rec_') gt 0) then begin
      zrange=[-30,130]
    end else if strpos(strarr_filenames_in(i),'Prof') gt 0 then begin
      zrange=[0,0.15]
      ztitle = 'Weight'
    end else begin
      zrange=[0,210]
    end
    dblarr_array = double(readfiletostrarr(str_path+strarr_filenames_in(i), ' '))
    intarr_size = size(dblarr_array)
    print,'intarr_size = ',intarr_size
    dblarr_row = indgen(intarr_size(1)) + 914
    dblarr_col = indgen(intarr_size(2)) + 1573
    str_file_out = str_path+strmid(strarr_filenames_in(i),0,strpos(strarr_filenames_in(i),'.',/REVERSE_SEARCH)) + '.ps'
    print,'str_file_out = <'+str_file_out+'>'
    device,filename=str_file_out
    loadct,0
    shade_surf,dblarr_array,$
               dblarr_row,$
               dblarr_col,$
               zrange = zrange,$
               zstyle=1,$
               xtitle='Row',$
               ytitle='Column',$
               ztitle=ztitle,$
               AX=60,$
               AZ=30,$
               xcharsize = 2.3,$
               ycharsize = 2.3,$
               zcharsize = 3.3,$
               position = [0.2,0.07,0.94,1.8]
    device,/close
    str_gifname = strmid(str_file_out,0,strpos(str_file_out,'.',/REVERSE_SEARCH))+'.gif'
    spawn,'ps2gif '+str_file_out+' '+str_gifname
;    str_pdfname = strmid(str_file_out,0,strpos(str_file_out,'.',/REVERSE_SEARCH))+'.pdf'
    spawn,'epstopdf '+str_file_out
    printf,lun,'<img src='+str_gifname+'><br>'+strarr_filenames_in(i)+'<br><hr><br>'
  endfor
  set_plot,'x'
  printf,lun,'</center></body></html>'
  free_lun,lun
end
