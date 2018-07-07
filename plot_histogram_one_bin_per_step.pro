pro rave_check_i

  i_n_digits = 2

  ravedatafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_dobles.dat'

  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')

  strarr_i = strarr_ravedata_all(*,12)

  intarr_size = size(strarr_ravedata_all)
  print,'intarr_size = ',intarr_size

  strarr_i_second_digit = strarr(intarr_size(1))

  for i=0ul,intarr_size(1)-1 do begin
    strarr_i_second_digit(i) = strmid(strarr_i(i),strpos(strarr_i(i),'.')+3-i_n_digits)
    if long(strarr_i_second_digit(i)) lt 10 then begin
      print,'strarr_i(i=',i,') = ',strarr_i(i),': strarr_i_second_digit(i=',i,') = ',strarr_i_second_digit(i)
    endif
  endfor
  lonarr_i_second_digit = long(strarr_i_second_digit)

;  print,'strarr_i_second_digit = ',strarr_i_second_digit

  intarr_hist = ulonarr(10^i_n_digits)

  for i=0ul, (10^i_n_digits)-1 do begin
    indarr = where(lonarr_i_second_digit eq i)
    intarr_hist(i) = n_elements(indarr)
    print,'intarr_hist(i=',i,') = ',intarr_hist(i)
    if i lt 12 then begin
      if n_elements(indarr) ne 1 or indarr(0) ne -1 then begin
        print,'strarr_i_second_digit(indarr) = ',strarr_i_second_digit(indarr)
      endif
    endif
  endfor
  print,'intarr_hist = ',intarr_hist

  set_plot,'ps'
  str_filename = '/home/azuri/daten/rave/rave_data/release5/I_'
  if i_n_digits eq 1 then begin
    str_filename = str_filename+'second_digit_behind_dot.ps'
  end else begin
    str_filename = str_filename+'both_digits_behind_dot.ps'
  end
  device,filename=

  plot,[-.5,(10.^i_n_digits)- .5],[0.,0.],xrange=[-.5,(10.^i_n_digits)- .5],yrange=[0.,double(max(intarr_hist))+(double(max(intarr_hist))/20.)],xstyle=1,ystyle=1,xtitle='I magnitude second digit',ytitle='Number of stars'
  for i=0ul, (10^i_n_digits)-1 do begin
    oplot,[double(i)-.5,double(i)+.5],[double(intarr_hist(i)),double(intarr_hist(i))]
    oplot,[double(i)-.5,double(i)-.5],[0.,double(intarr_hist(i))]
    oplot,[double(i)+.5,double(i)+.5],[0.,double(intarr_hist(i))]
;    oplot,[double(i)-5./(10.^i_n_digits),double(i)+5./(10.^i_n_digits)],[double(intarr_hist(i)),double(intarr_hist(i))]
;    oplot,[double(i)-5./(10.^i_n_digits),double(i)-5./(10.^i_n_digits)],[0.,double(intarr_hist(i))]
;    oplot,[double(i)+5./(10.^i_n_digits),double(i)+5./(10.^i_n_digits)],[0.,double(intarr_hist(i))]
  endfor
  device,/close
  set_plot,'x'

end
