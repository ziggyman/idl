pro rave_plot_snr_vs_imag_and_dec

  str_ravefile = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_good_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12.dat'
  str_filename_out = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_snr_vs_imag_and_dec.ps'
  i_col_snr = 35
  i_col_dec = 4
  i_col_imag = 14

  dbl_pixsize_x = 2.
  dbl_pixsize_y = 0.1

  dbl_min_imag = 9.
  dbl_max_imag = 12.

  dbl_min_dec = -90.
  dbl_max_dec = 0.

  strarr_data = readfiletostrarr(str_ravefile, ' ', I_NDATALINES=i_ndatalines)

  dblarr_snr = double(strarr_data(*,i_col_snr))
  dblarr_imag = double(strarr_data(*,i_col_imag))
  dblarr_dec = double(strarr_data(*,i_col_dec))

  strarr_data = 0

  my_hist_2d,DBLARR_X=dblarr_dec,$; in
             DBLARR_Y=dblarr_imag,$; in
             DBL_BINWIDTH_X=dbl_pixsize_x,$; in
             DBL_BINWIDTH_Y=dbl_pixsize_y,$; in
             DBL_MIN_X=dbl_min_dec,$; in
             DBL_MIN_Y=dbl_min_imag,$; in
             DBL_MAX_X=dbl_max_dec,$; in
             DBL_MAX_Y=dbl_max_imag,$; in
             INTARR2D_HIST=intarr2d_hist,$; out
             INTARR3D_INDEX=intarr3d_index; out

  dbl_max_snr = 0.
  dbl_min_snr = 100.
  for i=0ul, n_elements(intarr2d_hist(*,0))-1 do begin
    for j=0ul, n_elements(intarr2d_hist(0,*))-1 do begin
      if intarr3d_index(i,j,0) ge 0 then begin
        i_ngood = n_elements(where(intarr3d_index(i,j,*) ge 0))
        if i_ngood eq 1 then begin
          dblarr_moment_snr = dblarr_snr(where(intarr3d_index(i,j,0:i_ngood-1) ge 0))
        end else begin
          dblarr_moment_snr = moment(dblarr_snr(where(intarr3d_index(i,j,0:i_ngood-1) ge 0)))
        endelse
        if dbl_max_snr lt dblarr_moment_snr(0) then $
          dbl_max_snr = dblarr_moment_snr(0)
        if dbl_min_snr gt dblarr_moment_snr(0) then $
          dbl_min_snr = dblarr_moment_snr(0)
      endif
    endfor
  endfor

  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    if l le 127 then begin
      blue(l) = 2 * l
      green(l) = 0
      red(l) = 255 - 2*l;60 - (2*l)
    end else if l le 255 then begin
      blue(l) = 255 - 2*(l - 127)
      green(l) = 2 * (l-127);2 * (l-127)
      red(l) = 0
;    end else begin; --- last colour red
;      blue(l) = 0
;      green(l) = 0
;      red(l) = 255
    end
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 254 then green(l) = 254
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 254 then blue(l) = 254
  endfor

  ltab = 0
  modifyct,ltab,'red-green',red,green,blue,file='colors1_rave_snr_vs_imag.tbl'

  set_plot,'ps'
  device,filename=str_filename_out,/color

  loadct,0
  plot,[0.,0.],[0.,0.],xrange=[dbl_min_dec,dbl_max_dec],xstyle=1,yrange=[dbl_min_imag,dbl_max_imag],ystyle=1,xtitle='Declination [deg]',ytitle='I!D2MASS!N [mag]',charsize=1.2,charthick=2,position=[0.11,0.11,0.93,0.995]

;  dbl_min_snr = 40.
;  dbl_max_snr = 52.

  xpos = dbl_max_dec+(dbl_max_dec - dbl_min_dec)/27.
  str_label = strtrim(string(dbl_min_snr),2)
  str_label = strmid(str_label,0,strpos(str_label,'.'))
  xyouts,xpos,dbl_min_imag,str_label,charsize=1.2, charthick=2

  str_label = strtrim(string(dbl_max_snr),2)
  str_label = strmid(str_label,0,strpos(str_label,'.'))
  xyouts,xpos,dbl_max_imag-(dbl_max_imag-dbl_min_imag)/28.,str_label,charsize=1.2,charthick=2

  xyouts,xpos+(dbl_max_dec-dbl_min_dec)/40.,dbl_min_imag+(dbl_max_imag-dbl_min_imag)/2.7,'Mean S/N',orientation=90.,charsize=1.2,charthick=2

  loadct,ltab,FILE='colors1_rave_snr_vs_imag.tbl'
;  loadct,13

  i_max = max(intarr2d_hist)
  for i=0ul, n_elements(intarr2d_hist(*,0))-1 do begin
    for j=0ul, n_elements(intarr2d_hist(0,*))-1 do begin
      if intarr2d_hist(i,j) gt 0 then begin
        if intarr2d_hist(i,j) eq 1 then begin
          dblarr_moment_snr = dblarr_snr(where(intarr3d_index(i,j,*) ge 0))
        end else begin
          dblarr_moment_snr = moment(dblarr_snr(where(intarr3d_index(i,j,*) ge 0)))
        endelse
        i_colour = (dblarr_moment_snr(0) - dbl_min_snr) * 255 / (dbl_max_snr - dbl_min_snr)
        if i_colour lt 0 then i_colour = 0
        if i_colour gt 255 then i_colour = 255
        box,dbl_min_dec+i*dbl_pixsize_x,dbl_min_imag+j*dbl_pixsize_y,dbl_min_dec+(i+1)*dbl_pixsize_x,dbl_min_imag+(j+1)*dbl_pixsize_y,i_colour
      endif
    endfor
  endfor
  for i=0,127 do begin
    xmin = dbl_max_dec
    xmax = dbl_max_dec+(dbl_max_dec - dbl_min_dec)/30.
    ymin = dbl_min_imag+(dbl_max_imag-dbl_min_imag) * 2 * i / 256. - 0.0001
    ymax = dbl_min_imag+(dbl_max_imag-dbl_min_imag) * 2 * (i+1) / 256.
    print,'i = ',i,': xmin = ',xmin,', xmax = ',xmax,', ymin = ',ymin,', ymax = ',ymax
    box,xmin,ymin,xmax,ymax,2*i
  endfor

  loadct,0
  oplot,[-90.,0.],[9.8,9.8],thick=3.
  oplot,[-90.,0.],[10.5,10.5],thick=3.
  oplot,[-90.,0.],[11.3,11.3],thick=3.

  device,/close

  set_plot,'x'

  spawn,'epstopdf '+str_filename_out

  intarr2d_hist = 0
  intarr3d_index = 0
  dblarr_imag = 0
  dblarr_dec = 0
  dblarr_snr = 0

end
