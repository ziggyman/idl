pro plot_colour_legend, I_DBLARR_XRANGE = i_dblarr_xrange,$
                        I_DBLARR_YRANGE = i_dblarr_yrange,$
;                        B_BOTTOM_TO_TOP = b_bottom_to_top,$
                        I_INT_NBOXES    = i_int_nboxes,$
                        I_B_OUTSIDE     = i_b_outside
;                        I_STR_TITLE     = i_str_title
  int_nboxes = 254
  if keyword_set(I_INT_NBOXES) then $
    int_nboxes = i_int_nboxes

  dbl_x_a = i_dblarr_xrange(1)
  dbl_x_b = dbl_x_a + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) / 30.
  for i=1ul, int_nboxes do begin
;    if keyword_set(B_BOTTOM_TO_TOP) then begin
      dbl_y_a = i_dblarr_yrange(0) + (i_dblarr_yrange(1) - i_dblarr_yrange(0)) * double(i-1) / double(int_nboxes)
      dbl_y_b = i_dblarr_yrange(0) + (i_dblarr_yrange(1) - i_dblarr_yrange(0)) * double(i) / double(int_nboxes)
      dbl_y_b = dbl_y_b + (dbl_y_b - dbl_y_a) / 10.
;    end else begin
;      dbl_y_a = i_dblarr_yrange(0) + (i_dblarr_yrange(1) - i_dblarr_yrange(0)) * double(i-1) / double(int_nboxes)
;      dbl_y_b = i_dblarr_yrange(0) + (i_dblarr_yrange(1) - i_dblarr_yrange(0)) * double(i) / double(int_nboxes)
;      dbl_y_b = dbl_y_b + (dbl_y_b - dbl_y_a) / 10.
;    endelse
    box,dbl_x_a,$
        dbl_y_a,$
        dbl_x_b,$
        dbl_y_b,$
        i
  endfor
end
