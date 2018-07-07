pro kstwo,DBLARR_DATA_A=dblarr_data_a,$
          DBLARR_DATA_B=dblarr_data_b,$
          PROB=prob,$
          DD=dd
  ; --- Kolmogorov-Smirnov-Test for two data sets from Numerical Receipes

  j1 = 0UL
  j2 = 0UL

  dd = 0.
  d1 = 0.
  d2 = 0.
  dt = 0.
  en1 = 0.
  en2 = 0.
  en = 0.
  fn1 = 0.
  fn2 = 0.

  dblarr_data_a_sort = sort(dblarr_data_a)
  dblarr_data_b_sort = sort(dblarr_data_b)

  en1 = n_elements(dblarr_data_a)
  en2 = n_elements(dblarr_data_b)
;  print,'kstwo: en1 = ',en1,', en2 = ',en2

  while (j1 lt en1) and (j2 lt en2) do begin
    d1 = dblarr_data_a(dblarr_data_a_sort(j1))
    d2 = dblarr_data_b(dblarr_data_b_sort(j2))
;    print,'kstwo: d1 = ',d1,', d2 = ',d2
    if d1 le d2 then begin
      j1 = j1+1
;      print,'kstwo: j1 = ',j1
      fn1 = double(j1) / double(en1)
;      print,'kstwo: j1 = ',j1,', fn1 = ',fn1
    end
    if d2 le d1 then begin
      j2 = j2+1
;      print,'kstwo: j2 = ',j2
      fn2 = double(j2) / double(en2)
;      print,'kstwo: j2 = ',j2,', fn2 = ',fn2
    end
    dt = abs(fn2-fn1)
;    print,'kstwo: dt = ',dt
    if dt gt dd then begin
      dd = dt
;      print,'kstwo: dd = ',dd
    end
  end

  en = sqrt(double(en1) * double(en2) / (double(en1) + double(en2)))
;  print,'kstwo: en = ',en
  prob = probks((double(en)+0.12+0.11/double(en))*dd)
  print,'kstwo: prob = ',prob

end
