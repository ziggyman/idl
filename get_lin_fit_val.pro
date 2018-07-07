function get_lin_fit_val,dbl_xa,dbl_xb,dbl_ya,dbl_yb,dbl_x
  if dbl_x lt dbl_xa or dbl_x gt dbl_xb then return,-1

  dbl_y = dbl_ya + (dbl_yb-dbl_ya) * (dbl_x-dbl_xa) / (dbl_xb - dbl_xa)
  return,dbl_y
end
