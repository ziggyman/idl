pro plot_density,I_DBLARR_X          = i_dblarr_x,$
                 I_DBLARR_Y          = i_dblarr_y,$
                 I_DBLARR_RANGE_X    = i_dblarr_range_x,$
                 I_DBLARR_RANGE_Y    = i_dblarr_range_y,$
                 I_STR_PLOTNAME_ROOT = i_str_plotname_root,$
                 I_DBL_THICK         = i_dbl_thick,$
                 I_DBL_CHARTHICK     = i_dbl_charthick,$
                 I_DBL_CHARSIZE      = i_dbl_charsize,$
                 I_STR_XTITLE        = i_str_xtitle,$
                 I_STR_YTITLE        = i_str_ytitle,$
                 I_DBLARR_POSITION   = i_dblarr_position,$
                 I_INT_XTICKS        = i_int_xticks,$
                 I_INT_YTICKS        = i_int_yticks,$
                 I_STR_XTICKFORMAT   = i_str_xtickformat,$
                 I_STR_YTICKFORMAT   = i_str_ytickformat,$
                 I_INT_NBINS_MIN_X   = i_int_nbins_min_x,$
                 I_INT_NBINS_MAX_X   = i_int_nbins_max_x,$
                 I_INT_NBINS_MIN_Y   = i_int_nbins_min_y,$
                 I_INT_NBINS_MAX_Y   = i_int_nbins_max_y,$
                 I_DBL_MAX_VALUE     = i_dbl_max_value

  int_nbins_min_x = 200
  int_nbins_max_x = 500
  int_nbins_min_y = 200
  int_nbins_max_y = 500

  if keyword_set(I_INT_NBINS_MIN_X) then $
    int_nbins_min_x = i_int_nbins_min_x
  if keyword_set(I_INT_NBINS_MAX_X) then $
    int_nbins_max_x = i_int_nbins_max_x
  if keyword_set(I_INT_NBINS_MIN_Y) then $
    int_nbins_min_y = i_int_nbins_min_y
  if keyword_set(I_INT_NBINS_MAX_Y) then $
    int_nbins_max_y = i_int_nbins_max_y

  if not keyword_set(I_DBLARR_POSITION) then $
    i_dblarr_position = [0.18, 0.16, 0.91, 0.995]

  dbl_pixsize_x = 1
  int_npix_x = 1
  dbl_pixsize_y = 1
  int_npix_y = 1

  if int_nbins_min_x ne int_nbins_max_x then begin
    get_bin_width,DBLARR_DATA_A    = i_dblarr_x,$; --- in
                  DBLARR_DATA_B    = i_dblarr_x,$; --- in
                  DBLARR_BIN_RANGE = i_dblarr_range_x,$; --- in
                  I_NBINS_MIN      = int_nbins_min_x,$; --- in
                  I_NBINS_MAX      = int_nbins_max_x,$; --- in
                  DBL_BIN_WIDTH    = dbl_pixsize_x,$; --- out
                  NBINS            = int_npix_x; --- out
  end else begin
    int_npix_x = int_nbins_min_x
    dbl_pixsize_x = 360. / double(int_npix_x)
  end

  if int_nbins_min_y ne int_nbins_max_y then begin
    get_bin_width,DBLARR_DATA_A    = i_dblarr_y,$; --- in
                  DBLARR_DATA_B    = i_dblarr_y,$; --- in
                  DBLARR_BIN_RANGE = i_dblarr_range_y,$; --- in
                  I_NBINS_MIN      = int_nbins_min_y,$; --- in
                  I_NBINS_MAX      = int_nbins_max_y,$; --- in
                  DBL_BIN_WIDTH    = dbl_pixsize_y,$; --- out
                  NBINS            = int_npix_y; --- out
  end else begin
    int_npix_y = int_nbins_min_y
    dbl_pixsize_y = 180. / double(int_npix_y)
  end
;  int_npix_x = 360
;  int_npix_y = 200

;  dbl_pixsize_x = (i_dblarr_range_x(1) - i_dblarr_range_x(0)) / int_npix_x
;  dbl_pixsize_y = (i_dblarr_range_y(1) - i_dblarr_range_y(0)) / int_npix_y
  print,'plot_density: dbl_pixsize_x = ',dbl_pixsize_x
  print,'plot_density: dbl_pixsize_y = ',dbl_pixsize_y
  print,'plot_density: i_dblarr_range_x = ',i_dblarr_range_x
  print,'plot_density: i_dblarr_range_y = ',i_dblarr_range_y
;  stop

  intarr_elements_pix = intarr(int_npix_x, int_npix_y)
  dblarr_bin = dblarr(int_npix_x+1, int_npix_y+1, 2)
  dblarr_bin(0,*,0) = i_dblarr_range_x(0)
  dblarr_bin(*,0,1) = i_dblarr_range_y(0)

  set_plot,'ps'
  device,filename=i_str_plotname_root+'.ps',/color
  plot,[0.,0.],$
       [0.,0.],$
       xrange = i_dblarr_range_x,$
       xstyle = 1,$
       yrange = i_dblarr_range_y,$
       ystyle = 1,$
       thick = i_dbl_thick,$
       charthick = i_dbl_charthick,$
       charsize = i_dbl_charsize,$
       xtitle = i_str_xtitle,$
       ytitle = i_str_ytitle,$
       position = i_dblarr_position,$
       xticks = i_int_xticks,$
       yticks = i_int_yticks,$
       xtickformat = i_str_xtickformat,$
       ytickformat = i_str_ytickformat
  for i=1ul, int_npix_x do begin
    dblarr_bin(i,*,0) = dblarr_bin(i-1,*,0) + dbl_pixsize_x
;    print,'plot_density: dblarr_bin(i-1=',i-1,',0,0) = ',dblarr_bin(i-1,0,0)
;    print,'plot_density: dblarr_bin(i=',i,',0,0) = ',dblarr_bin(i,0,0)
    indarr_x = where((i_dblarr_x ge dblarr_bin(i-1,0,0)) and (i_dblarr_x lt dblarr_bin(i,0,0)))
;    print,'plot_density: n_elements(indarr_x) = ',n_elements(indarr_x)
    if indarr_x(0) lt 0 then begin
      intarr_elements_pix(i-1,*) = 0
    end else begin
;      print,'plot_density: i_dblarr_x(indarr_x) = ',i_dblarr_x(indarr_x)
;      print,'plot_density: i_dblarr_y(indarr_x) = ',i_dblarr_y(indarr_x)
      for j=1ul, int_npix_y do begin
        dblarr_bin(*,j,1) = dblarr_bin(*,j-1,1) + dbl_pixsize_y
;        print,'plot_density: dblarr_bin(0,j-1=',j-1,',1) = ',dblarr_bin(0,j-1,1)
;        print,'plot_density: dblarr_bin(0,j=',j,',1) = ',dblarr_bin(0,j,1)
        indarr = where((i_dblarr_y(indarr_x) ge dblarr_bin(0,j-1,1)) and (i_dblarr_y(indarr_x) lt dblarr_bin(0,j,1)))
        if indarr(0) lt 0 then begin
          intarr_elements_pix(i-1,j-1) = 0
        end else begin
          intarr_elements_pix(i-1,j-1) = n_elements(indarr)
        endelse
;        print,'plot_density: intarr_elements_pix(i-1=',i-1,',j-1=',j-1,') = ',intarr_elements_pix(i-1,j-1)
      endfor
    endelse
  endfor

  ; --- modify colour table
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    if l lt 64 then begin
      blue(l) = 4 * l
      green(l) = 0
      red(l) = 0
    end else if l lt 128 then begin
      blue(l) = 256 - 4 * (l-64)
      green(l) = 0
      red(l) = 4 * (l-64)
    end else if l lt 192 then begin
      blue(l) = 4 * (l-128)
      green(l) = 4 * (l-128)
      red(l) = 256 - 4 * (l-128)
    end else begin
      blue(l) = 256-4*(l-192)
      green(l) = 256
      red(l) = 0
    end
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 255 then green(l) = 255
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 255 then blue(l) = 255
  endfor
  green(0) = 0
  red(0) = 0
  ltab = 0
  modifyct,ltab,'green-red',red,green,blue,file='colors1_density.tbl'
  loadct,ltab,FILE='colors1_density.tbl'

  ; --- plot colours
  for i=0ul, int_npix_x-1 do begin
    for j=0ul, int_npix_y-1 do begin
      if dblarr_bin(i,0,0) gt 11.9 then begin
        print,'intarr_elements_pix(i=',i,',j=',j,') = ',intarr_elements_pix(i,j)
      endif
      if intarr_elements_pix(i,j) gt 0 then begin
        if not keyword_set(I_DBL_MAX_VALUE) then begin
          int_colour = long(254. * double(intarr_elements_pix(i,j)) / double(max(intarr_elements_pix)))+1
        end else begin
          if  max(intarr_elements_pix) gt i_dbl_max_value then begin
            int_colour = long(254. * double(intarr_elements_pix(i,j)) / double(i_dbl_max_value))+1
          end else begin
            int_colour = long(254. * double(intarr_elements_pix(i,j)) / double(max(intarr_elements_pix)))+1
          end
        endelse
        if int_colour lt 1 then int_colour = 1
        if int_colour gt 254 then int_colour = 254
        print,'int_colour = ',int_colour
        box,dblarr_bin(i,0,0),$
            dblarr_bin(0,j,1),$
            dblarr_bin(i+1,0,0),$
            dblarr_bin(0,j+1,1),$
            int_colour
      endif
    endfor
  endfor
  plot_colour_legend, I_DBLARR_XRANGE = i_dblarr_range_x,$
                      I_DBLARR_YRANGE = i_dblarr_range_y
  dbl_xcoord = i_dblarr_range_x(1)+(i_dblarr_range_x(1) - i_dblarr_range_x(0)) / 25.
  xyouts,dbl_xcoord,$
         i_dblarr_range_y(0),$
         '1',$
         charsize=i_dbl_charsize,$
         charthick = i_dbl_charthick
  if keyword_set(I_DBL_MAX_VALUE) then begin
    if  max(intarr_elements_pix) gt i_dbl_max_value then begin
      str_print = strtrim(string(i_dbl_max_value),2)
    end else begin
      str_print = strtrim(string(max(intarr_elements_pix)),2)
    endelse
  end else begin
    str_print = strtrim(string(max(intarr_elements_pix)),2)
  endelse
  xyouts,dbl_xcoord,$
         i_dblarr_range_y(1) - ((i_dblarr_range_y(1) - i_dblarr_range_y(0)) * i_dbl_charsize / 40.),$
         str_print,$
         charsize=i_dbl_charsize,$
         charthick = i_dbl_charthick
  str_legend = 'Number of stars per pixel'
  if max(intarr_elements_pix) lt 100 then $
    str_legend = 'Percentage of RAVE stars'
  xyouts,dbl_xcoord + ((i_dblarr_range_x(1) - i_dblarr_range_x(0)) / 25.),$
         i_dblarr_range_y(0) + ((i_dblarr_range_y(1) - i_dblarr_range_y(0)) / 2.),$
         str_legend,$
         charsize=i_dbl_charsize,$
         charthick = i_dbl_charthick,$
         alignment = 0.5,$
         orientation = 90.

  device,/close

end
