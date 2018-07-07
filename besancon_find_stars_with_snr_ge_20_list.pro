pro besancon_find_stars_with_snr_ge_20_list
  for j=0ul, 11 do begin
    if j eq 0 then begin
      str_errdivby = '0.25_0.25_0.25_0.25_0.25'
    end else if j eq 1 then begin
      str_errdivby = '0.50_0.50_0.50_0.50_0.50'
    end else if j eq 2 then begin
      str_errdivby = '0.75_0.75_0.75_0.75_0.75'
    end else if j eq 3 then begin
      str_errdivby = '1.00_1.00_1.00_1.00_1.00'
    end else if j eq 4 then begin
      str_errdivby = '1.50_1.50_1.50_1.50_1.50'
    end else if j eq 5 then begin
      str_errdivby = '2.00_2.00_2.00_2.00_2.00'
    end else if j eq 6 then begin
      str_errdivby = '2.50_2.50_2.50_2.50_2.50'
    end else if j eq 7 then begin
      str_errdivby = '3.00_3.00_3.00_3.00_3.00'
    end else if j eq 8 then begin
      str_errdivby = '3.50_3.50_3.50_3.50_3.50'
    end else if j eq 9 then begin
      str_errdivby = '4.00_4.00_4.00_4.00_4.00'
    end else if j eq 10 then begin
      str_errdivby = '4.50_4.50_4.50_4.50_4.50'
    end else begin
      str_errdivby = '5.00_5.00_5.00_5.00_5.00'
    end
    str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snrdec_gt_13_with_errors_height_rcent_errdivby_'+str_errdivby+'.dat'
    besancon_find_stars_with_snr_ge_20,STR_FILENAME=str_datafile
  endfor

end
