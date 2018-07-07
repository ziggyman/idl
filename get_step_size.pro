function get_step_size,dblarr_in

  indarr_sort = sort(dblarr_in)
  dbl_binwidth = 100000000.
  for i=1ul, n_elements(dblarr_in)-1 do begin
    dbl_width = dblarr_in(indarr_sort(i)) - dblarr_in(indarr_sort(i-1))
    if (abs(dbl_width) gt 0.00000001) and (dbl_binwidth gt dbl_width) then begin
      dbl_binwidth = dbl_width
      print,'get_step_size: dbl_binwidth = ',dbl_binwidth
    endif
  endfor
  indarr_sort = 0

  return,dbl_binwidth
end
