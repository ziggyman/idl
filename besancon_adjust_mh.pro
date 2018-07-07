pro besancon_adjust_mh
  str_filename = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb.dat';_with-errors_height_rcent_errdivby-dwarfs-1_00-1_48-1_41-1_55-1_00-giants-1_00-1_22-1_26-1_61-1_00-MH-from-FeH-and-aFe.dat';besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb.dat'

  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_mh = double(strarr_data(*,8))
  intarr_age = ulong(strarr_data(*,11))
  dblarr_logg = double(strarr_data(*,6))

  indarr_dwarfs = where(dblarr_logg ge 3.5, COMPLEMENT=indarr_giants)

  for i=0,1 do begin
    if i eq 0 then begin
      indarr_logg = indarr_dwarfs
      dbl_mh_thin = -0.146
      dbl_mh_thick = -0.548
    end else begin
      indarr_logg = indarr_giants
      dbl_mh_thin = -0.251
      dbl_mh_thick = -0.871
    end
    indarr_thick = where(intarr_age(indarr_logg) eq 8)

    dbl_mean_thick = mean(dblarr_mh(indarr_logg(indarr_thick)))
    print,'mean [M/H] thick disk = ',dbl_mean_thick

    indarr_thin = where(intarr_age(indarr_logg) lt 8)
    dbl_mean_thin = mean(dblarr_mh(indarr_logg(indarr_thin)))
    print,'mean [M/H] thin disk = ',dbl_mean_thin

    ; --- set mean [M/H] of the thin disk to -0.281
    dblarr_mh(indarr_logg(indarr_thin)) -= dbl_mean_thin - dbl_mh_thin

    ; --- set mean [M/H] of the thick disk to -0.740
    dblarr_mh(indarr_logg(indarr_thick)) -= dbl_mean_thick - dbl_mh_thick

  endfor
  strarr_data(*,8) = strtrim(string(dblarr_mh),2)

  str_filename_out = strmid(str_filename, 0, strpos(str_filename,'.',/REVERSE_SEARCH))+'_adj-mh.dat'
  openw,lun,str_filename_out,/GET_LUN
  for i=0ul, n_elements(dblarr_mh)-1 do begin
    str_line = strarr_data(i,0)
    for j=1ul, n_elements(strarr_data(0,*))-1 do begin
      str_line = str_line + ' ' + strarr_data(i,j)
    endfor
    printf,lun,str_line
  endfor
  free_lun,lun

  ; --- clean up
  indarr_thick = 0
  indarr_thin = 0
  dblarr_mh = 0
  intarr_age = 0
  strarr_data = 0
end
