pro rave_get_colour_table,B_POP_ID    = b_pop_id,$; --- 0: for histograms with star type for colour code
                                                  ; --- 1: for histograms with population ID for colour code
                                                  ; --- 2: for summary plots
                          RED         = red,$
                          GREEN       = green,$
                          BLUE        = blue,$
                          DBL_N_TYPES = dbl_n_types
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    if l le 255/4 then begin; --- red->yellow
      blue(l) = 0;255 - (2 * l)
      green(l) = 4 * l
      red(l) = 255;60 - (2*l)
    end else if l le 255/2 then begin; --- yellow -> green
      blue(l) = 0
      green(l) = 255;2 * (l-127)
      red(l) = 255 - 4*(l-255/4)
    end else if l le 3*255/4 then begin; --- green -> blue
      blue(l) = 4*(l-255/2)
      green(l) = 255 - 4*(l-255/2);2 * (l-127)
      red(l) = 0
    end else begin; --- blue -> violet
      blue(l) = 255
      green(l) = 0;2 * (l-127)
      red(l) = 4*(l-3*255/4)
    end
    blue(255) = 0
    green(255) = 0
    red(255) = 255
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 254 then green(l) = 254
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 254 then blue(l) = 254
  endfor
  if keyword_set(B_POP_ID) then begin
    if b_pop_id eq 1 then begin
      red(1) = 255
      red(2) = 255
      red(3) = 255
      red(4) = 127
      red(5) = 0
      red(6) = 0
      red(7) = 0
      red(8) = 0
      red(9) = 155
      red(10) = 255
      red(0) = 0

      green(1) = 0
      green(2) = 127
      green(3) = 255
      green(4) = 255
      green(5) = 200
      green(6) = 200
      green(7) = 255
      green(8) = 0
      green(9) = 0
      green(10) = 0
      green(0) = 0

      blue(1) = 0
      blue(2) = 0
      blue(3) = 0
      blue(4) = 0
      blue(5) = 0
      blue(6) = 200
      blue(7) = 255
      blue(8) = 255
      blue(9) = 255
      blue(10) = 227
      blue(0) = 0

      dbl_n_types = 10.
    end else begin; --- summary plots

    end
  end else begin; --- star types
      red(1) = 255
      red(2) = 255
      red(3) = 255
      red(4) = 127
      red(5) = 0
      red(6) = 0
      red(7) = 255
      red(0) = 0

      green(1) = 0
      green(2) = 127
      green(3) = 255
      green(4) = 255
      green(5) = 255
      green(6) = 0
      green(7) = 0
      green(0) = 0

      blue(1) = 0
      blue(2) = 0
      blue(3) = 0
      blue(4) = 0
      blue(5) = 255
      blue(6) = 255
      blue(7) = 255
      blue(0) = 0

      dbl_n_types = 7.
  end
end
