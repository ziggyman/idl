pro besancon_get_ravesample_all

  b_calibrated = 1

  j_end = 11
  if b_calibrated then $
    j_end = 10
  for i=0,0 do begin
    b_dist = 1
    if i eq 0 then $
      b_dist = 0
    for j=0ul, j_end do begin
      if b_calibrated then begin
        if j eq 0 then begin
          str_errdivby = '1.00-1.00-1.00-1.00-1.00'
        end else if j eq 1 then begin
          str_errdivby = '1.10-1.10-1.10-1.10-1.10'
        end else if j eq 2 then begin
          str_errdivby = '1.20-1.20-1.20-1.20-1.20'
        end else if j eq 3 then begin
          str_errdivby = '1.30-1.30-1.30-1.30-1.30'
        end else if j eq 4 then begin
          str_errdivby = '1.40-1.40-1.40-1.40-1.40'
        end else if j eq 5 then begin
          str_errdivby = '1.50-1.50-1.50-1.50-1.50'
        end else if j eq 6 then begin
          str_errdivby = '1.60-1.60-1.60-1.60-1.60'
        end else if j eq 7 then begin
          str_errdivby = '1.70-1.70-1.70-1.70-1.70'
        end else if j eq 8 then begin
          str_errdivby = '1.80-1.80-1.80-1.80-1.80'
        end else if j eq 9 then begin
          str_errdivby = '1.90-1.90-1.90-1.90-1.90'
        end else if j eq 10 then begin
          str_errdivby = '2.00-2.00-2.00-2.00-2.00'
        endif
      end else begin
        if j eq 0 then begin
          str_errdivby = '0.25_0.25_0.25_0.25_0.25'
        end else if j eq 1 then begin
          str_errdivby = '0.50_0.50_0.50_0.50_0.50'
        end else if j eq 2 then begin
          str_errdivby = '0.75_0.75_0.75_0.75_0.75'
        end else if j eq 3 then begin
          str_errdivby = '1.00_1.00_1.00_1.00_1.00'
        end else if j eq 4 then begin
          str_errdivby = '1.25_1.25_1.25_1.25_1.25'
        end else if j eq 5 then begin
          str_errdivby = '1.50_1.50_1.50_1.50_1.50'
        end else if j eq 6 then begin
          str_errdivby = '1.75_1.75_1.75_1.75_1.75'
        end else if j eq 7 then begin
          str_errdivby = '2.00_2.00_2.00_2.00_2.00'
        end else if j eq 8 then begin
          str_errdivby = '2.50_2.50_2.50_2.50_2.50'
        end else if j eq 9 then begin
          str_errdivby = '3.00_3.00_3.00_3.00_3.00'
        end else if j eq 10 then begin
          str_errdivby = '3.50_3.50_3.50_3.50_3.50'
        end else if j eq 11 then begin
          str_errdivby = '4.00_4.00_4.00_4.00_4.00'
        end
      endelse
  ;    str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_errdivby_'+str_errdivby+'.dat'
      besancon_get_ravesample,STR_ERRDIVBY=str_errdivby,$
                              B_CHEM = 0,$
                              B_DIST = b_dist
                              ;STR_DATAFILE=str_datafile
    endfor
  endfor
end
