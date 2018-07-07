pro rave_besancon_plot_histograms_all

  i_calibrate_rave_metallicities = 4
  ; --- 0: no calibration
  ; --- 1: [M/H] = [m/H] + 0.2 for RAVE, no calibration for iron abundances
  ; --- 2: old calib (with logg), no calibration for iron abundances
  ; --- 3: new calib (with teff), no calibration for iron abundances
  ; --- 4: new calib DR3 seperate dwarfs/giants (with teff, logg, stn), no calibration for iron abundances

  b_low_lat_only = 0
  b_high_lat_only = 0

  for kkk = 0, 1 do begin

    if kkk eq 0 then begin
      b_popid = 1
      b_startypes = 0
    end else begin
      b_popid = 0
      b_startypes = 1
    end

    for k = 0,0 do begin
      if k eq 0 then begin
        b_abundances = 0
      end else begin
        b_abundances = 1
      end
      for j=0,5 do begin
        if j lt 3 then begin
          b_sample_logg = 1
        end else begin
          b_sample_logg = 0
        end
        if (j eq 0) or (j eq 3) then begin
          b_dwarfs_only = 0
          b_giants_only = 0
        end else if (j eq 1) or (j eq 4) then begin
          b_dwarfs_only = 1
          b_giants_only = 0
        end else if (j eq 2) or (j eq 5) then begin
          b_dwarfs_only = 0
          b_giants_only = 1
        end
        i_end = 10
        if i_calibrate_rave_metallicities gt 0 then $
          i_end = 11
        for i=0ul, i_end do begin
          if i_calibrate_rave_metallicities gt 0 then begin
            if i eq 0 then begin
              str_errdivby = '0.25_0.25_0.25_0.25_0.25'
            end else if i eq 1 then begin
              str_errdivby = '0.50_0.50_0.50_0.50_0.50'
            end else if i eq 2 then begin
              str_errdivby = '0.75_0.75_0.75_0.75_0.75'
            end else if i eq 3 then begin
              str_errdivby = '1.00_1.00_1.00_1.00_1.00'
            end else if i eq 4 then begin
              str_errdivby = '1.25_1.25_1.25_1.25_1.25'
            end else if i eq 5 then begin
              str_errdivby = '1.50_1.50_1.50_1.50_1.50'
            end else if i eq 6 then begin
              str_errdivby = '1.75_1.75_1.75_1.75_1.75'
            end else if i eq 7 then begin
              str_errdivby = '2.00_2.00_2.00_2.00_2.00'
            end else if i eq 8 then begin
              str_errdivby = '2.50_2.50_2.50_2.50_2.50'
            end else if i eq 9 then begin
              str_errdivby = '3.00_3.00_3.00_3.00_3.00'
            end else if i eq 10 then begin
              str_errdivby = '3.50_3.50_3.50_3.50_3.50'
            end else if i eq 11 then begin
              str_errdivby = '4.00_4.00_4.00_4.00_4.00'
            end
          end else begin
            if i eq 0 then begin
              str_errdivby = '1.00-1.00-1.00-1.00-1.00'
            end else if i eq 1 then begin
              str_errdivby = '1.10-1.10-1.10-1.10-1.10'
            end else if i eq 2 then begin
              str_errdivby = '1.20-1.20-1.20-1.20-1.20'
            end else if i eq 3 then begin
              str_errdivby = '1.30-1.30-1.30-1.30-1.30'
            end else if i eq 4 then begin
              str_errdivby = '1.40-1.40-1.40-1.40-1.40'
            end else if i eq 5 then begin
              str_errdivby = '1.50-1.50-1.50-1.50-1.50'
            end else if i eq 6 then begin
              str_errdivby = '1.60-1.60-1.60-1.60-1.60'
            end else if i eq 7 then begin
              str_errdivby = '1.70-1.70-1.70-1.70-1.70'
            end else if i eq 8 then begin
              str_errdivby = '1.80-1.80-1.80-1.80-1.80'
            end else if i eq 9 then begin
              str_errdivby = '1.90-1.90-1.90-1.90-1.90'
            end else if i eq 10 then begin
              str_errdivby = '2.00-2.00-2.00-2.00-2.00'
            endif
          endelse
          rave_besancon_plot_histograms,STR_ERRDIVBY=str_errdivby,$
                                        I_CALIBRATE_RAVE_METALLICITIES = i_calibrate_rave_metallicities,$
                                        B_DWARFS_ONLY   = b_dwarfs_only,$
                                        B_GIANTS_ONLY   = b_giants_only,$
                                        B_LOW_LAT_ONLY  = b_low_lat_only,$
                                        B_HIGH_LAT_ONLY = b_high_lat_only,$
                                        B_POPID         = b_popid,$
                                        B_STARTYPES     = b_startypes,$
                                        B_SAMPLE_LOGG   = b_sample_logg,$
                                        B_ABUNDANCES    = b_abundances
        endfor
      endfor
    endfor
  endfor
end
