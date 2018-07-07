pro sedm_plot_aperture_centers
;  str_filename_in = '/home/azuri/spectra/SEDIFU/commissioning/June18/Wave_bEcSum_apcenters.dat'
;  str_cornerlist_in = '/home/azuri/spectra/SEDIFU/commissioning/June18/cornerfiles.list'
;  str_plotname = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_problem.ps'

;  dblarr_corners = [[   1396.83,     104.5],[ 1421.64  ,    99.5],[ 1428.93 ,     80.5],[ 1379.37 ,  88],[1414.28, 120.5],[ 1372.09 ,    108.5 ]]
;  print,'dblarr_corners = ',size(dblarr_corners),': ',dblarr_corners
;  set_plot,'ps'
;  device,filename=str_plotname
;    plot,[dblarr_corners(0,0),dblarr_corners(0,0)],$
;    [dblarr_corners(1,0),dblarr_corners(1,0)],psym=2,symsize=1.,xrange=[1370,1430],xstyle=1,yrange=[79,122],ystyle=1
;    for i=1, 5 do begin
;      oplot,[dblarr_corners(0,i),dblarr_corners(0,i)],[dblarr_corners(1,i),dblarr_corners(1,i)],psym=2
;    endfor
;  device,/close
;  set_plot,'x'


  str_filename_in = '/home/azuri/spectra/SEDIFU/commissioning/June19/apcenters.dat'
  str_cornerlist_in = '/home/azuri/spectra/SEDIFU/commissioning/June19/cornerfiles.list'
  strlist_collapsed_spectra_in = '/home/azuri/spectra/SEDIFU/commissioning/June19/collapsed_files.list'
;  str_filename_in = '/home/azuri/spectra/SEDIFU/commissioning/June20/apcenters_combinedDomeFlat_bs.dat'
;  str_cornerlist_in = '/home/azuri/spectra/SEDIFU/commissioning/June20/cornerfiles.list'
;  strlist_collapsed_spectra_in = '/home/azuri/spectra/SEDIFU/commissioning/June21/collapsed_files.list'

  str_path = strmid(strlist_collapsed_spectra_in, 0, strpos(strlist_collapsed_spectra_in,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'

  dblarr_centers = double(readfiletostrarr(str_filename_in,' '))
  print,'dblarr_centers(0,*) = ',dblarr_centers(0,*)

  strlist_spectra = readfilelinestoarr(strlist_collapsed_spectra_in)
  
  openw,lun,str_path+'collapsed_spectra.html',/GET_LUN
  printf,lun,'<html><body><center>'
  
  for i_file=0ul, n_elements(strlist_spectra)-1 do begin
    str_collapsed_spectra_in = str_path+strlist_spectra(i_file)
    
    dblarr_collapsed_spectra = double(readfiletostrarr(str_collapsed_spectra_in, ' '))
    size_col = size(dblarr_collapsed_spectra)
    print,'size = ',size_col
    strarr_collapsed_spectra_aps = strarr(size_col(1))
    print,'n_elements(strarr_collapsed_spectra_aps) = ',n_elements(strarr_collapsed_spectra_aps)
    for i=0ul, size_col(1)-1 do begin
      strarr_collapsed_spectra_aps(i) = strtrim(string(dblarr_collapsed_spectra(i,0)),2)
      strarr_collapsed_spectra_aps(i) = strmid(strarr_collapsed_spectra_aps(i),0,strpos(strarr_collapsed_spectra_aps(i),'.'))
      print,'dblarr_collapsed_spectra(i,0) = ',dblarr_collapsed_spectra(i,0),': strarr_collapsed_spectra_aps(',i,') = ',strarr_collapsed_spectra_aps(i)
    endfor
  
    dblarr_center_x = dblarr_centers(*,0)
    dblarr_center_y = dblarr_centers(*,1)
    for i=0ul, n_elements(dblarr_center_x)-1 do begin
      if (dblarr_center_x(i) gt 600.) and (dblarr_center_x(i) lt 700.) then begin
        if (dblarr_center_y(i) gt 500.) and (dblarr_center_y(i) lt 600.) then begin
          print,'problematic aperture: ',i
        endif
      endif
    endfor
;  stop
  
    strarr_corners_apertures = readfilelinestoarr(str_cornerlist_in)
    strarr_corners_aps = strarr(n_elements(strarr_corners_apertures))
    for i=0ul, n_elements(strarr_corners_apertures)-1 do begin
      strarr_corners_aps(i) = strmid(strarr_corners_apertures(i),16,strpos(strarr_corners_apertures(i),'.')-16)
      print,'strarr_corners_aps(',i,') = ',strarr_corners_aps(i)
    endfor
    print,'strarr_corners_apertures = ',size(strarr_corners_apertures),': ',strarr_corners_apertures
    print,'strarr_corners_apertures(0) = ',strarr_corners_apertures(0)
  
    str_plotname = strmid(str_collapsed_spectra_in,0,strpos(str_collapsed_spectra_in,'.',/REVERSE_SEARCH))+'.ps'
    str_gifname = strmid(str_collapsed_spectra_in,0,strpos(str_collapsed_spectra_in,'.',/REVERSE_SEARCH))+'.gif'

    print,'dblarr_collapsed_spectra(*,3) = ',dblarr_collapsed_spectra(*,3)
;  stop
    dbl_max = max(dblarr_collapsed_spectra(*,3))
    print,'dbl_max = ',dbl_max
    dbl_median = median(dblarr_collapsed_spectra(*,3))
    print,'dbl_median = ',dbl_median
    indarr = where(dblarr_collapsed_spectra(*,3) lt dbl_median,complement=indarr_good)
    print,'indarr = ',indarr
    dblarr_collapsed_spectra(indarr,3) = dbl_median
    print,'dblarr_collapsed_spectra(*,3) = ',dblarr_collapsed_spectra(*,3)
;  stop
  
    dbl_min = min(dblarr_collapsed_spectra(*,3))
    print,'dbl_min = ',dbl_min
;  stop
    set_plot,'ps'
    printf,lun,'<img src="'+str_gifname+'"><br>'+str_gifname+'<br><hr>'
    device,filename=str_plotname,/color
      loadct,0
      plot,dblarr_centers(*,0),dblarr_centers(*,1),psym=2,symsize=0.1
      oplot,[dblarr_centers(1016, 0), dblarr_centers(1016, 0)], [dblarr_centers(1016,1),dblarr_centers(1016,1)],psym=2, symsize=0.5
      for i=0ul, n_elements(strarr_corners_apertures)-1 do begin
        str_ifile = strmid(str_cornerlist_in,0,strpos(str_cornerlist_in,'/',/REVERSE_SEARCH)+1)+strarr_corners_apertures(i)
        print,'str_ifile = <'+str_ifile+'>'
        dblarr_corners = double(readfiletostrarr(str_ifile,' '))
        print,'dblarr_corners = ',size(dblarr_corners),': ',dblarr_corners
        size_corners = size(dblarr_corners)
        maxlength = 0.
        for j=0ul, size_corners(1)-2 do begin
          length = sqrt((dblarr_corners(j+1,0) - dblarr_corners(j,0))^2 + (dblarr_corners(j+1,1) - dblarr_corners(j,1))^2)
          if length gt maxlength then maxlength = length
          if length lt 100 then $;(dblarr_corners(j,0) ne 0) and (dblarr_corners(j+1,0) ne 0) and (dblarr_corners(j,1) ne 0) and (dblarr_corners(j+1,1) ne 0) then $
            oplot,[dblarr_corners(j,0),dblarr_corners(j+1,0)],[dblarr_corners(j,1),dblarr_corners(j+1,1)]
        endfor
        length = sqrt((dblarr_corners(5,0) - dblarr_corners(0,0))^2 + (dblarr_corners(5,1) - dblarr_corners(0,1))^2)
        if length gt maxlength then maxlength = length
        if length lt 100 then $;      if (dblarr_corners(5,0) ne 0) and (dblarr_corners(0,0) ne 0) and (dblarr_corners(5,1) ne 0) and (dblarr_corners(0,1) ne 0) then $
          oplot,[dblarr_corners(5,0),dblarr_corners(0,0)],[dblarr_corners(5,1),dblarr_corners(0,1)]
        i_collapsed = where(strarr_collapsed_spectra_aps eq strarr_corners_aps(i))
        if n_elements(i_collapsed) eq 1 and i_collapsed(0) ge 0 then begin
          color=(dblarr_collapsed_spectra(i_collapsed(0),3) - dbl_min) * 255 / (dbl_max - dbl_min)
          print,'dblarr_collapsed_spectra(i_collapsed=',i_collapsed(0),',3) = ',dblarr_collapsed_spectra(i_collapsed(0),3)
          print,'color=',color
 ;     stop
          print,'i = ',i,': dblarr_corners = ',dblarr_corners
          print,'strarr_corners_aps(i) = ',strarr_corners_aps(i)
          print,'strarr_collapsed_spectra_aps(i_collapsed=',i_collapsed,') = ',strarr_collapsed_spectra_aps(i_collapsed(0))
;          stop
          if maxlength lt 100 then $
          polyfill,dblarr_corners(*,0),dblarr_corners(*,1),color=color
        end else begin
          print,'aperture ',strarr_corners_aps(i),' not found in strarr_collapsed_spectra_aps'
;        stop
        endelse
        oplot,[dblarr_centers(1016, 0), dblarr_centers(1016, 0)], [dblarr_centers(1016,1),dblarr_centers(1016,1)],psym=2, symsize=0.5,color=80
        if strarr_corners_aps(i) eq '150' then begin
          oplot,[dblarr_centers(1016, 0), dblarr_centers(1016, 0)], [dblarr_centers(1016,1),dblarr_centers(1016,1)],psym=2, symsize=0.5,color=80
;          stop
        endif
      endfor
      loadct,13
      for i=0ul, n_elements(strarr_corners_apertures)-1 do begin
        xyouts,dblarr_centers(i,0)+2,dblarr_centers(i,1)+2,strtrim(string(i),2),charsize=0.3,color=100
      endfor
      loadct,0
    device,/close
    spawn,'ps2gif '+str_plotname+' '+str_gifname
  endfor
  printf,lun,'</center></body></html>'
  free_lun,lun
  set_plot,'x'
end
