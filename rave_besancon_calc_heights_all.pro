pro rave_besancon_calc_heights_all

  b_calibrated = 1

  j_end = 11
  if b_calibrated then $
    j_end = 10
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
  ;    end else if j eq 10 then begin
  ;      str_errdivby = '4.50_4.50_4.50_4.50_4.50'
  ;    end else begin
  ;      str_errdivby = '5.00_5.00_5.00_5.00_5.00'
      end
    endelse
    str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_vrad-from-uvwlb_with_errors_errdivby_'+str_errdivby+'.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snrdec_gt_13_with_errors_errdivby_'+str_errdivby+'.dat';_distsample_9ltI2MASSlt12_logg_0.dat'
    if b_calibrated then $
    str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb_with-errors_errdivby-'+str_errdivby+'-MH-from-FeH-and-aFe.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_mh+snrdec_gt_13_with_errors_errdivby_'+str_errdivby+'.dat';_distsample_9ltI2MASSlt12_logg_0.dat'
    rave_besancon_calc_heights,I_STR_DATAFILE=str_datafile,I_INT_I=1
  endfor

end
