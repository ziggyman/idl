pro plot_wlen_vs_row
;  str_fname = '/run/media/azuri/data/azuri/spectra/SEDIFU/ofek/b_ifu20130805_23_10_39_SpecB.text'
  str_fnamelist = '/run/media/azuri/data/azuri/spectra/SEDIFU/Aug05/mine_and_ofeks_spectra.list'
  
  strarr_fnames = readfilelinestoarr(str_fnamelist)
  
  xmin = 0
  xmax = 0
  ymin = 100000
  ymax = 0
  for i=0, n_elements(strarr_fnames)-1 do begin
    dblarr_data = double(readfiletostrarr(strarr_fnames(i),' '))
    i_nrows = n_elements(dblarr_data(*,0))
    if i_nrows gt xmax then xmax = i_nrows
    if min(dblarr_data(*,0)) lt ymin then ymin = min(dblarr_data(*,0))
    if max(dblarr_data(*,0)) gt ymax then ymax = max(dblarr_data(*,0))
  endfor
  
  set_plot,'ps'
  str_plotname=strmid(str_fnamelist,0, strpos(str_fnamelist,'.',/REVERSE_SEARCH))+'_wlen_vs_row.ps'
  print,'str_plotname='+str_plotname
  device,filename=str_plotname
    for i=0, n_elements(strarr_fnames)-1 do begin
      dblarr_data = double(readfiletostrarr(strarr_fnames(i),' '))
      i_nrows = n_elements(dblarr_data(*,0))
      iarr_rows = indgen(i_nrows)
      if i eq 0 then begin
        plot,iarr_rows,$
             dblarr_data(*,0),$
             title=strmid(str_fnamelist,strpos(str_fnamelist,'/',/REVERSE_SEARCH)+1),$
             xrange=[xmin,xmax],$
             yrange=[ymin,ymax],$
             xstyle = 1,$
             ystyle = 1,$
             xtitle = 'Pixel number',$
             ytitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]'
        oplot,[xmin+((xmax-xmin)/20),xmin+((xmax-xmin)/10)],$
              [ymax-((ymax-ymin)/20)*2,ymax-((ymax-ymin)/20)*2]
        xyouts,xmin+((xmax-xmin)/9),ymax-((ymax-ymin)/20)*2-((ymax-ymin)/100),'Ofek pipeline'
      end else begin
        oplot,iarr_rows,$
              dblarr_data(*,0),$
              linestyle=i
        oplot,[xmin+((xmax-xmin)/20),xmin+((xmax-xmin)/10)],$
              [ymax-((ymax-ymin)/20)*(2+i),ymax-((ymax-ymin)/20)*(2+i)],$
              linestyle=i
        xyouts,xmin+((xmax-xmin)/9),ymax-((ymax-ymin)/20)*(2+i)-((ymax-ymin)/100),'Ritter pipeline'
      endelse
    endfor
  device,/close
  set_plot,'x'
end
