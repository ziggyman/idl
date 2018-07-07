pro plot_vertical_line,dbl_x,dblarr_yrange,LINESTYLE=linestyle
  if not keyword_set(LINESTYLE) then $
    linestyle = 0
  oplot,[dbl_x,dbl_x],$
        [dblarr_yrange(0),dblarr_yrange(1)],$
        thick=3,$
;        color=160,$
        linestyle=linestyle

end
