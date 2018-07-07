pro plot_vertical_lines,dblarr_x,dblarr_yrange
  for ilin = 0, n_elements(dblarr_x)-1 do begin
    print,'plot_vertical_lines: ilin = ',ilin,': plotting line at x = ',dblarr_x(ilin)
;    if ilin eq n_elements(dblarr_x)-1 then stop
    plot_vertical_line,dblarr_x(ilin),dblarr_yrange,LINESTYLE=ilin;+1
  endfor
end
