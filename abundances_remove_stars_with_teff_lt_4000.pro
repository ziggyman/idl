pro abundances_remove_stars_with_teff_lt_4000
  b_besancon = 1

  if b_besancon then begin
    str_datafile = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1.dat';_with_errors_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00.dat'
    int_col_teff = 5
    b_log_teff = 1
  end else begin
    str_datafile = '/suphys/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_no-doubles-maxsnr.dat';_chemsample_logg_0_dwarfs_errdivby_2.70_1.10_3.00_1.00_4.00_giants_1.50_2.00_1.80_1.50_2.00.dat'
    int_col_teff = 70
    b_log_teff = 0
  end
  str_file_out = strmid(str_datafile,0,strpos(str_datafile,'.',/REVERSE_SEARCH))+'_teff-gt-4000.dat'

  strarr_lines = readfilelinestoarr(str_datafile,str_dont_read='#')
  strarr_data = readfiletostrarr(str_datafile,' ',HEADER=strarr_header)
  dblarr_teff = double(strarr_data(*,int_col_teff))
  if b_log_teff then $
    dblarr_teff = 10. ^ dblarr_teff
  strarr_data = 0

  openw,lun,str_file_out,/GET_LUN
    int_nstars_rejected = 0ul
    for i=0ul, n_elements(dblarr_teff)-1 do begin
      if dblarr_teff(i) gt 4000. then begin
        printf,lun,strarr_lines(i)
      end else begin
        int_nstars_rejected = int_nstars_rejected + 1
      endelse
    endfor
  free_lun,lun
  print,int_nstars_rejected,' stars rejected'
  print,str_file_out,' ready'
  ; --- clean up
  strarr_lines = 0
  dblarr_teff = 0
end
