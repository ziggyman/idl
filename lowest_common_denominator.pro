function lowest_common_denominator,x,y

  b_run = 1
  i_run = 0UL
  if x eq 0. or y eq 0. then begin
    c = 0.
    return,c
  end

  while x * 10. le y do begin
    x = x * 10.
  end

  while y * 10. le x do begin
    y = y * 10.
  end

  i_y_run = 1UL
  while b_run do begin
    i_run = i_run + 1
    dbl_x_test = double(x) * double(i_run)
    if dbl_x_test lt 0. then begin
      c = 0.
      return,c
    endif
;    print,'lowest_common_denominator: dbl_x_test = ',dbl_x_test
    b_y_run = 1
    i_y_run = i_y_run - 1
    while b_y_run do begin
      i_y_run = i_y_run + 1
      dbl_y_test = double(y) * double(i_y_run)
;      print,'lowest_common_denominator: dbl_y_test = ',dbl_y_test
        if abs(dbl_x_test - dbl_y_test) lt 0.00000001 then begin
          print,'lowest_common_denominator: lowest_common_denominator for ',x,' and ',y,' = ',string(dbl_x_test)
          return,dbl_x_test
        end
      if dbl_y_test gt dbl_x_test then begin
        b_y_run = 0
;        print,'lowest_common_denominator: i_y_run = ',i_y_run
      endif
    end
    if i_run gt 10000 then begin
      b_run = 0
      print,'lowest_common_denominator: i_run = ',i_run
    end
  end
  c = 0.
  return,c
end
