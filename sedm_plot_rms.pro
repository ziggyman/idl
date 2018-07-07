pro sedm_plot_rms
  str_centers_in = '/media/external/azuri/spectra/SEDIFU/Jun21/apcenters.dat'
  str_cornerlist_in = '/media/external/azuri/spectra/SEDIFU/Jun21/cornerfiles.list'
  strlist_coeffs_in = '/media/external/azuri/spectra/SEDIFU/Jun21/identified_coeffs.list'

  str_path = strmid(strlist_coeffs_in, 0, strpos(strlist_coeffs_in,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'

  dblarr_centers = double(readfiletostrarr(str_centers_in,' '))
  print,'dblarr_centers(0,*) = ',dblarr_centers(0,*)

  strfiles_coeffs = readfilelinestoarr(strlist_coeffs_in)
  strarr_coeffs_aps = strarr(n_elements(strfiles_coeffs))
  
  strarr_corners_apertures = readfilelinestoarr(str_cornerlist_in)
  strarr_corners_aps = strarr(n_elements(strarr_corners_apertures))
  for i=0ul, n_elements(strarr_corners_apertures)-1 do begin
    strarr_corners_aps(i) = strmid(strarr_corners_apertures(i),16,strpos(strarr_corners_apertures(i),'.')-16)
    print,'strarr_corners_aps(',i,') = ',strarr_corners_aps(i)
  endfor
  print,'strarr_corners_aps = ',size(strarr_corners_aps),': ',strarr_corners_aps
;  stop
  
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 254 do begin
    red(l) = l;60 - (2*l)
    green(l) = 255-l
    blue(l) = 0
  endfor
  red(255) = 100
  green(255) = 100
  blue(255) = 255
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_kst.tbl'

  openw,lun,str_path+'ap_rms_colour.dat',/GET_LUN
  
  b_did_plot = 0
  set_plot,'ps'
  str_plotname = str_path + 'rms_lenslet.ps'
  str_gifname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
  device,filename=str_plotname,/color
    loadct,0
    plot,dblarr_centers(*,0),$
         dblarr_centers(*,1),$
         psym=2,$
         symsize=0.1,$
         xtitle="CCD column",$
         ytitle="CCD row",$
         xrange=[0,2100],$
         yrange=[0,2050],$
         xstyle=1,$
         ystyle=1,$
         charsize=2.
    for i_file=0ul, n_elements(strfiles_coeffs)-1 do begin
      str_coeffs_in = str_path+strfiles_coeffs(i_file)
      print,'reading file '+str_coeffs_in
    
      if file_test(str_coeffs_in) then begin
        strarr_coeffs = readfiletostrarr(str_coeffs_in, ' ')
        dbl_rms = double(strarr_coeffs(n_elements(strarr_coeffs(*,0))-1,1))
      end else begin
        dbl_rms = 500.
      endelse
      print,'dbl_rms = ',dbl_rms
    
      str_ap = strmid(str_coeffs_in,strpos(str_coeffs_in,'_ap')+3)
      str_ap = strmid(str_ap,0,strpos(str_ap,'_x'))
      print,'aperture ',str_ap
      int_ap = long(str_ap)
      print,'aperture ',int_ap
    

      i_ap = where(strarr_corners_aps eq str_ap)
      print,'str_ap = '+str_ap+': i_ap = ',i_ap
      print,'n_elements(i_ap) = ',n_elements(i_ap)
      print,'i_ap(0) =  ',i_ap(0)
      if ((n_elements(i_ap) eq 1) and (i_ap(0) ge 0)) then begin
        str_file = str_path+strarr_corners_apertures(i_ap)
        print,'str_file = <'+str_file+'>'
        dblarr_corners = double(readfiletostrarr(str_file,' '))
        print,'dblarr_corners = ',size(dblarr_corners),': ',dblarr_corners
        size_corners = size(dblarr_corners)
        maxlength = 0.
        loadct,0
        for j=0ul, size_corners(1)-2 do begin
          length = sqrt((dblarr_corners(j+1,0) - dblarr_corners(j,0))^2 + (dblarr_corners(j+1,1) - dblarr_corners(j,1))^2)
          if length gt maxlength then $
            maxlength = length
          if length lt 100 then $;(dblarr_corners(j,0) ne 0) and (dblarr_corners(j+1,0) ne 0) and (dblarr_corners(j,1) ne 0) and (dblarr_corners(j+1,1) ne 0) then $
            oplot,[dblarr_corners(j,0),dblarr_corners(j+1,0)],[dblarr_corners(j,1),dblarr_corners(j+1,1)]
        endfor
        length = sqrt((dblarr_corners(5,0) - dblarr_corners(0,0))^2 + (dblarr_corners(5,1) - dblarr_corners(0,1))^2)
        if length gt maxlength then $
          maxlength = length
        if length lt 100 then $;      if (dblarr_corners(5,0) ne 0) and (dblarr_corners(0,0) ne 0) and (dblarr_corners(5,1) ne 0) and (dblarr_corners(0,1) ne 0) then $
          oplot,[dblarr_corners(5,0),dblarr_corners(0,0)],[dblarr_corners(5,1),dblarr_corners(0,1)]
        color = dbl_rms * 255 / 100
        if color gt 254 then $
          color = 254
        if dbl_rms lt 0.01 then $
          color = 254
        print,'dbl_rms = ',dbl_rms
        print,'color=',color
        print,'i = ',i,': dblarr_corners = ',dblarr_corners
        printf,lun,str_ap+' '+strtrim(string(dbl_rms),2)+' '+strtrim(string(color),2)
        if maxlength lt 100 then begin
          loadct,0,FILE='colors1_kst.tbl'
          polyfill,dblarr_corners(*,0),dblarr_corners(*,1),color=color
        end
      end else begin
        print,'ERROR: Aperture '+str_ap+' not found'
      endelse
;      loadct,13
;      for i=0ul, n_elements(strarr_corners_apertures)-1 do begin
;        xyouts,dblarr_centers(i,0)+2,dblarr_centers(i,1)+2,strtrim(string(i),2),charsize=0.3,color=100
;      endfor
    endfor
    loadct,0,FILE='colors1_kst.tbl'
    for i=0ul, 254 do begin
      ya=2050.*i/255.
      yb=2050.*(i+1.)/255.
      box,2050,ya,2100,yb,i
    endfor
    loadct,0
    xyouts,2115,0,'0',charsize=2.
    xyouts,2115,1950,'100',charsize=2.
    xyouts,2205,1025,'RMS',ALIGNMENT=0.5,ORIENTATION=90,charsize=2.
  device,/close
  spawn,'ps2gif '+str_plotname+' '+str_gifname
  spawn,'epstopdf '+str_plotname
  set_plot,'x'
  
  free_lun,lun

end
