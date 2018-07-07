pro sedm_plot_lenslet_array
  str_filename = '/home/azuri/daten/SEDIFU/run_61f_temp_0degC_full.txt'
  str_filename_aps_centers = '/home/azuri/spectra/SEDIFU/commissioning/June19/hg+neon+xenon_aperture_positions.text';'/home/azuri/spectra/SEDIFU/aps_centers.dat'
  str_file_out = '/home/azuri/spectra/SEDIFU/commissioning/June19/aperture_center_pos_to_FP.dat';'/home/azuri/daten/SEDIFU/aperture_center_pos_to_FP.dat'
  str_filename_lensletpositions_aps = '/home/azuri/spectra/SEDIFU/obs_dr_text_aperture_lenslet_positions.dat';SN_datacube_lenslet_pos.dat'
  str_filename_corners = '/home/azuri/spectra/SEDIFU/filelist_corners_lenslets.list'
  
  strarr_files_corners = readfilelinestoarr(str_filename_corners)
  
  dblarr_lensletpositions_aps = double(readfiletostrarr(str_filename_lensletpositions_aps,' '))
  
  dbl_focal_length = 6096; mm
  int_nlenslets = 3600;
  int_nrows = 2048
  int_ncols = 2048
  nrecs_x=27
  nrecs_y=17
  
  strarr_data = readfiletostrarr(str_filename,' ')
  intarr_lenslet_num = lindgen(int_nlenslets)
  intarr_lenslet_num_arr = long(double(strarr_data(*,0)))
  dblarr_lenslet_x_in_deg = double(strarr_data(*,1))
  dblarr_lenslet_y_in_deg = double(strarr_data(*,2))
  dblarr_lenslet_x_in_mm = double(strarr_data(*,1)) / dbl_focal_length
  dblarr_lenslet_y_in_mm = double(strarr_data(*,2)) / dbl_focal_length
  dblarr_lenslet_x_out_mm = double(strarr_data(*,4))
  dblarr_lenslet_y_out_mm = double(strarr_data(*,5))
  
  dblarr_lenslet_x_out_pix = dblarr_lenslet_x_out_mm / 0.0135 + double(int_ncols)/2.
  dblarr_lenslet_y_out_pix = dblarr_lenslet_y_out_mm / 0.0135 + double(int_nrows)/2.
  indarr = where(abs(dblarr_lenslet_x_out_pix - int_ncols/2) lt 0.5)
  dblarr_lenslet_x_out_pix(indarr) = 10000.
  dblarr_lenslet_y_out_pix(indarr) = 10000.
  
  dblarr_aps_centers = double(readfiletostrarr(str_filename_aps_centers,' '))
  
  dblarr_center = dblarr(int_nlenslets,2)
  dblarr_lenslet = dblarr(int_nlenslets,2)
  for i=0ul, int_nlenslets-1 do begin
    print,'i=',i,': intarr_lenslet_num(i) = ',intarr_lenslet_num(i)
    indarr = where(intarr_lenslet_num_arr eq intarr_lenslet_num(i)+1)
    dbl_xmin = dblarr_lenslet_x_out_pix(indarr(0))
    dbl_xmax = dblarr_lenslet_x_out_pix(indarr(n_elements(indarr)-1))
    dblarr_center(i,0) = dbl_xmin + (dbl_xmax - dbl_xmin)/2.
    print,'dblarr_center(i,0) = ',dblarr_center(i,0)
    
    dbl_xmin = dblarr_lenslet_x_in_deg(indarr(0))
    dbl_xmax = dblarr_lenslet_x_in_deg(indarr(n_elements(indarr)-1))
    dblarr_lenslet(i,0) = dbl_xmin + (dbl_xmax - dbl_xmin)/2.
    print,'dblarr_lenslet(i,0) = ',dblarr_lenslet(i,0)
    
    dbl_ymin = dblarr_lenslet_y_out_pix(indarr(0))
    dbl_ymax = dblarr_lenslet_y_out_pix(indarr(n_elements(indarr)-1))
    dblarr_center(i,1) = dbl_ymin + (dbl_ymax - dbl_ymin)/2.
    print,'dblarr_center(i,1) = ',dblarr_center(i,1)
    
    dbl_ymin = dblarr_lenslet_y_in_deg(indarr(0))
    dbl_ymax = dblarr_lenslet_y_in_deg(indarr(n_elements(indarr)-1))
    dblarr_lenslet(i,1) = dbl_ymin + (dbl_ymax - dbl_ymin)/2.
    print,'dblarr_lenslet(i,1) = ',dblarr_lenslet(i,1)
  endfor
  
  set_plot,'ps'
  device,filename=strmid(str_filename_aps_centers,0,strpos(str_filename_aps_centers,'.',/REVERSE_SEARCH))+'.ps',/COLOR
  loadct,0
  plot,dblarr_aps_centers(*,0),$
       dblarr_aps_centers(*,1),$
       psym=2,$
       symsize=0.3,$
       xtitle='row [pix]',$
       ytitle='column [pix]',$
       xrange=[450,1600],$
       yrange=[550,1500],$
       xstyle=1,$
       ystyle=1
 
  loadct,13
  for i=0ul, int_nlenslets-1 do begin
    oplot,[dblarr_center(i,0), dblarr_center(i,0)],$
          [dblarr_center(i,1), dblarr_center(i,1)],$
          color=255*i/int_nlenslets,$
          psym=2,$
          symsize=0.3
  endfor
  for i=0ul, n_elements(dblarr_lensletpositions_aps(*,0))-1 do begin
    color=2
;    indarr = where((dblarr_lensletpositions_aps(*,2) eq dblarr_lensletpositions_aps(i,2)) and (dblarr_lensletpositions_aps(*,3) eq dblarr_lensletpositions_aps(i,3)), nind)
;    if nind gt 1 then 
    color=250
    
    oplot,[dblarr_lensletpositions_aps(i,0), dblarr_lensletpositions_aps(i,0)],$
          [dblarr_lensletpositions_aps(i,1), dblarr_lensletpositions_aps(i,1)],$
          color=color,$
          psym=2,$
          symsize=0.3
    xyouts,dblarr_lensletpositions_aps(i,0),dblarr_lensletpositions_aps(i,1),strtrim(string(i),2),charsize=0.5
  endfor
  oplot,[580.,1470.],[600.,600.],color=250
  oplot,[580.,1470.],[1450.,1450.],color=250
  oplot,[580.,580.],[600.,1450.],color=250
  oplot,[1470.,1470.],[600.,1450.],color=250
  
  dx = (1470.-580.)/double(nrecs_x)
  dy = (1450.-600.)/double(nrecs_y)
  xa = 580.
  for i_x=0, nrecs_x-1 do begin
    xb = xa+dx
    ya = 600.
    for i_y=0, nrecs_y-1 do begin
      yb = ya+dy
        oplot,[xa,xb,xb,xa,xa],$
              [ya,ya,yb,yb,ya],$
              color=200
      ya = yb
    endfor
    xa = xb
  endfor
  
  ; --- plot lenslets
  for i=0ul, n_elements(strarr_files_corners)-1 do begin
    dblarr_corners = double(readfiletostrarr(strarr_files_corners(i), ' '))
    print,'i=',i,': size(dblarr_corners) = ',size(dblarr_corners)
    print,'i=',i,': n_elements(dblarr_corners(*,0)) = ',n_elements(dblarr_corners(*,0))
    print,'i=',i,': dblarr_corners = ',dblarr_corners
    
    for j=0, n_elements(dblarr_corners(*,0))-1 do begin
      if j eq n_elements(dblarr_corners(*,0))-1 then begin
        px = [dblarr_corners(j,0), dblarr_corners(0,0)]
        py = [dblarr_corners(j,1), dblarr_corners(0,1)]
      end else begin
        px = [dblarr_corners(j,0), dblarr_corners(j+1,0)]
        py = [dblarr_corners(j,1), dblarr_corners(j+1,1)]
      endelse
      print,'i=',i,': j=',j,': px = ',px
      print,'i=',i,': j=',j,': py = ',py
      dist = sqrt((px(1) - px(0))^2 + (py(1) - py(0))^2)
      if dist lt dx*2 then $;(px(0) ge 400.) and (px(1) ge 400.) and (py(0) ge 500.) and (py(1) ge 500.) then $
        oplot,px,py,color=150
    endfor
  endfor
  
  loadct,0
  device,/close

  device,filename=strmid(str_filename_aps_centers,0,strpos(str_filename_aps_centers,'.',/REVERSE_SEARCH))+'_sky.ps',/COLOR
  loadct,0
  plot,dblarr_lenslet(*,0),$
       dblarr_lenslet(*,1),$
       psym=2,$
       symsize=0.3,$
       xtitle='row [pix]',$
       ytitle='column [pix]';,$
;       xrange=[500,1550],$
;       yrange=[600,1450],$
;       xstyle=1,$
;       ystyle=1
 
  loadct,13
  for i=0ul, int_nlenslets-1 do begin
    oplot,[dblarr_lenslet(i,0), dblarr_lenslet(i,0)],$
          [dblarr_lenslet(i,1), dblarr_lenslet(i,1)],$
          color=255*i/int_nlenslets,$
          psym=2,$
          symsize=0.3
  endfor
  for i=0ul, n_elements(dblarr_lensletpositions_aps(*,0))-1 do begin
    color=2
    indarr = where((dblarr_lensletpositions_aps(*,2) eq dblarr_lensletpositions_aps(i,2)) and (dblarr_lensletpositions_aps(*,3) eq dblarr_lensletpositions_aps(i,3)), nind)
    if nind gt 1 then color=255
    
    oplot,[dblarr_lensletpositions_aps(i,2), dblarr_lensletpositions_aps(i,2)],$
          [dblarr_lensletpositions_aps(i,3), dblarr_lensletpositions_aps(i,3)],$
          color=color,$
          psym=2,$
          symsize=0.3
  endfor
  
  loadct,0
  device,/close
  set_plot,'x'
  
  openw,lun,str_file_out,/GET_LUN
    printf,lun,'#aperture_center_x[pix] aperture_center_y[pix] lenslet_pos_x[deg] lenslet_pos_y[deg]'
    for i=0ul, int_nlenslets-1 do begin
      printf,lun,strtrim(string(dblarr_center(i,0)),2)+' '+strtrim(string(dblarr_center(i,1)),2)+' '+strtrim(string(dblarr_lenslet(i,0)),2)+' '+strtrim(string(dblarr_lenslet(i,1)),2)
    endfor
  free_lun,lun
  
end
