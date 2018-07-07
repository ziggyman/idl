pro pastel_count_stars_found
  str_filename = '/home/azuri/daten/pastel/asu_abundances.dat';RAVE_SNR_gt_13.dat';abundances.dat'

  i_col_pastel_teff = 7
  i_col_pastel_eteff = 8
  i_col_pastel_logg = 11
  i_col_pastel_elogg = 12
  i_col_pastel_feh = 17
  i_col_pastel_efeh = 16

  strarr_data = readfiletostrarr(str_filename,' ')

  indarr = where(abs(double(strarr_data(*,i_col_pastel_teff))) gt 0.0000001,count)
  print,'stars with T_eff found: ',count

  indarr = where(abs(double(strarr_data(*,i_col_pastel_eteff))) gt 0.0000001,count)
  print,'stars with eT_eff found: ',count

  indarr = where(abs(double(strarr_data(*,i_col_pastel_logg))) gt 0.0000001,count)
  indarr_dwarfs = where(abs(double(strarr_data(*,i_col_pastel_logg))) gt 3.5,count_dwarfs)
  print,'stars with logg found: ',count
  print,'dwarfs found: ',count_dwarfs
  print,'giants found: ',count-count_dwarfs

  indarr = where(abs(double(strarr_data(*,i_col_pastel_elogg))) gt 0.0000001,count)
  print,'stars with elogg found: ',count

  indarr = where(abs(double(strarr_data(*,i_col_pastel_feh))) gt 0.0000001,count)
  print,'stars with feh found: ',count

  indarr = where(abs(double(strarr_data(*,i_col_pastel_efeh))) gt 0.0000001,count)
  print,'stars with efeh found: ',count

end
