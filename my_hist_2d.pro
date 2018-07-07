pro my_hist_2d,DBLARR_X=dblarr_x,$; in
               DBLARR_Y=dblarr_y,$; in
               DBL_BINWIDTH_X=dbl_binwidth_x,$; in
               DBL_BINWIDTH_Y=dbl_binwidth_y,$; in
               DBL_MIN_X=dbl_min_x,$; in
               DBL_MIN_Y=dbl_min_y,$; in
               DBL_MAX_X=dbl_max_x,$; in
               DBL_MAX_Y=dbl_max_y,$; in
               O_DBLARR_X = o_dblarr_x,$; out
               O_DBLARR_Y = o_dblarr_y,$; out
               INTARR2D_HIST=intarr2d_hist,$; out
               INTARR3D_INDEX=intarr3d_index; out

  if n_elements(dblarr_x) ne n_elements(dblarr_y) then begin
    print,'my_hist_2d: error: n_elements(dblarr_x) ne n_elements(dblarr_y)'
    return
  endif

  print,'dblarr_x = ',dblarr_x
  print,'dblarr_y = ',dblarr_y

  i_nbins_x = long((dbl_max_x - dbl_min_x) / dbl_binwidth_x)
  i_nbins_y = long((dbl_max_y - dbl_min_y) / dbl_binwidth_y)

  print,'i_nbins_x = ',i_nbins_x
  print,'i_nbins_y = ',i_nbins_y

  o_dblarr_x = dblarr(i_nbins_x)
  o_dblarr_y = dblarr(i_nbins_y)

  intarr2d_hist = lonarr(i_nbins_x, i_nbins_y)
  intarr3d_index = lonarr(i_nbins_x, i_nbins_y, long(n_elements(dblarr_x)))
  intarr3d_index(*,*,*)=-1

  i_maxelements = 0

  for i=0ul, i_nbins_x-1 do begin
    indarr_x = where(dblarr_x ge dbl_min_x + i*dbl_binwidth_x and dblarr_x lt dbl_min_x + (i+1)*dbl_binwidth_x)
    print,'i = ',i,': n_elements(indarr_x) = ',n_elements(indarr_x)
    o_dblarr_x(i) = dbl_min_x + i*dbl_binwidth_x + ((i+1)*dbl_binwidth_x - i*dbl_binwidth_x)/2.
    print,'my_hist_2d: xmin = ',dbl_min_x + i*dbl_binwidth_x
    print,'my_hist_2d: xmax = ',dbl_min_x + (i+1)*dbl_binwidth_x
    print,'my_hist_2d: o_dblarr_x(i=',i,') = ',o_dblarr_x(i)
    for j=0ul, i_nbins_y-1 do begin
      o_dblarr_y(j) = dbl_min_y + j*dbl_binwidth_y + ((j+1)*dbl_binwidth_y - j*dbl_binwidth_y)/2.
      print,'my_hist_2d: ymin = ',dbl_min_y + j*dbl_binwidth_y
      print,'my_hist_2d: ymax = ',dbl_min_y + (j+1)*dbl_binwidth_y
      print,'my_hist_2d: o_dblarr_y(j=',j,') = ',o_dblarr_y(j)
      if indarr_x(0) ge 0 then begin
        indarr_y = where(dblarr_y(indarr_x) ge dbl_min_y + j*dbl_binwidth_y and dblarr_y(indarr_x) lt dbl_min_y + (j+1)*dbl_binwidth_y)
        print,'j = ',j,': n_elements(indarr_y) = ',n_elements(indarr_y)
        if indarr_y(0) ge 0 then begin
          i_ny = n_elements(indarr_y)
          intarr2d_hist(i,j) = i_ny
          print,'my_hist_2d: intarr2d_hist(',i,',',j,') = ',intarr2d_hist(i,j)
          intarr3d_index(i,j,0:i_ny-1) = indarr_x(indarr_y)
;          print,'my_hist_2d: intarr3d_index(',i,',',j,',0:',i_ny-1,') = ',intarr3d_index(i,j,0:i_ny-1)
          if i_ny gt i_maxelements then $
            i_maxelements = i_ny
        end else begin
          intarr2d_hist(i,j) = 0
        end
      end else begin
        intarr2d_hist(i,*) = 0
      endelse
    endfor
  endfor
  print,'my_hist_2d: i_maxelements = ',i_maxelements
  print,'my_hist_2d: o_dblarr_x = ',o_dblarr_x
  print,'my_hist_2d: o_dblarr_y = ',o_dblarr_y
  intarr3d_index = intarr3d_index(*,*,0:i_maxelements-1)
  print,'my_hist_2d: intarr2d_hist = ',intarr2d_hist
;  print,'my_hist_2d: intarr3d_index = ',intarr3d_index
end
