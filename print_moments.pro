pro print_moments, I_DBLARR_MOMENTS = i_dblarr_moments,$
                   I_DBLARR_XRANGE  = i_dblarr_xrange,$
                   I_DBLARR_YRANGE  = i_dblarr_yrange,$
                   B_RIGHT          = b_right; --- print moments in upper right corner? otherwise upper left

  intarr_size_moments = size(i_dblarr_moments)

  dbl_x_start = i_dblarr_xrange(0)
  dbl_fac_a = 0.3
  if (max(abs(i_dblarr_moments)) lt 10.) and (min(i_dblarr_moments) gt 0.) then begin
    dbl_fac_b = 0.8
    dbl_fac_c = 1.8
    if keyword_set(B_RIGHT) then begin
      if intarr_size_moments(0) eq 2 then begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 3.6 / 6.
      end else begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 4.1 / 6.
      endelse
    endif
  end else if (max(abs(i_dblarr_moments)) lt 100.) or ((max(abs(i_dblarr_moments)) lt 10.) and (min(i_dblarr_moments) lt 0.)) then begin
    dbl_fac_b = 0.9
    dbl_fac_c = 2.0
    if keyword_set(B_RIGHT) then begin
      if intarr_size_moments(0) eq 2 then begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 3.6 / 6.
      end else begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 4.1 / 6.
      endelse
    endif
  end else if (max(abs(i_dblarr_moments)) lt 1000.) or ((max(abs(i_dblarr_moments)) lt 100.) and (min(i_dblarr_moments) lt 0.)) then begin
    dbl_fac_b = 1.0
    dbl_fac_c = 2.2
    if keyword_set(B_RIGHT) then begin
      if intarr_size_moments(0) eq 2 then begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 3.5 / 6.
      end else begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 4. / 6.
      endelse
    endif
  end else begin
    dbl_fac_b = 1.1
    dbl_fac_c = 2.4
    if keyword_set(B_RIGHT) then begin
      if intarr_size_moments(0) eq 2 then begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 3.3 / 6.
      end else begin
        dbl_x_start = i_dblarr_xrange(0) + (i_dblarr_xrange(1) - i_dblarr_xrange(0)) * 3.9 / 6.
      endelse
    endif
  endelse
  if intarr_size_moments(0) eq 2 then begin
;    xyouts,i_dblarr_xrange(0)+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * 1. /8.5,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) / 14.,charsize=1.5,charthick=3.,alignment=0.5,'Moment'
;    xyouts,i_dblarr_xrange(0)+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * 2.1 /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) / 14.,charsize=1.5,charthick=3.,alignment=0.5,'black'
;    xyouts,i_dblarr_xrange(0)+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * 3. /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) / 14.,charsize=1.5,charthick=3.,alignment=0.5,'red',color=1

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_a /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 1. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'!4l!X'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_b /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 1. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(0,0),f='(F8.2)')
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_c /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 1. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(1,0),f='(F8.2)'),color=1

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_a /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 2. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'!4r!X'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_b /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 2. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(0,1),f='(F8.2)')
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_c /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 2. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(1,1),f='(F8.2)'),color=1

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_a /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 3. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'s'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_b /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 3. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(0,2),f='(F8.2)')
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_c /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 3. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(1,2),f='(F8.2)'),color=1

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_a /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 4. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'k'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_b /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 4. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(0,3),f='(F8.2)')
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * dbl_fac_c /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 4. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(1,3),f='(F8.2)'),color=1
  end else begin
    ; --- don't print column name and only one column
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_a + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 1. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'!4l!X'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_b + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 1. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(0),f='(F8.3)')

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_a + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 2. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'!4r!X'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_b + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 2. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(sqrt(i_dblarr_moments(1)),f='(F8.3)')

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_a + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 3. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'s'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_b + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 3. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(2),f='(F8.3)')

    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_a + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 4. / 14.,charsize=1.5,charthick=3.,alignment=0.5,'k'
    xyouts,dbl_x_start+(i_dblarr_xrange(1)-i_dblarr_xrange(0)) * (dbl_fac_b + 0.1) /7.,i_dblarr_yrange(1)-(i_dblarr_yrange(1) - i_dblarr_yrange(0)) * 4. / 14.,charsize=1.5,charthick=3.,alignment=0.5,string(i_dblarr_moments(3),f='(F8.3)')
  end

end
