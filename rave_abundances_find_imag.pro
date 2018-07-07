pro rave_abundances_find_imag
  str_datafile_corrado = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd.dat'
  str_datafile_out = strmid(str_datafile_corrado, 0, strpos(str_datafile_corrado,'.',/REVERSE_SEARCH))+'_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
  str_datafile_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
                                                                 ;rave_internal_dr8_all_good_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1_STN_gt_20.dat'

  i_col_abundances_id = 0
  i_col_abundances_feh = 1
  i_col_abundances_n = 2
  i_col_abundances_teff = 3
  i_col_abundances_logg = 4
  i_col_abundances_mhr = 5
  i_col_abundances_ar = 6
  i_col_abundances_mhc = 7
  i_col_abundances_ac = 8
  i_col_abundances_stn = 9
  i_col_abundances_s2n = 10
  i_col_abundances_frac = 11
  i_col_abundances_ntot = 12
  i_col_abundances_chisq = 13

  i_pos_ab_id = 0
  i_pos_ab_id_end = 31
  i_pos_ab_feh = 138
  i_pos_ab_feh_end = 146
  i_pos_ab_n = 146
  i_pos_ab_n_end = 149
  i_pos_ab_mhc = 172
  i_pos_ab_mhc_end = 179
  i_pos_ab_ac = 179
  i_pos_ab_ac_end = 184
  i_pos_ab_frac = 193
  i_pos_ab_frac_end = 199
  i_pos_ab_ntot = 199
  i_pos_ab_ntot_end = 206
  i_pos_ab_chisq = 206
  i_pos_ab_chisq_end = 216

  i_col_rave_obsid = 1
  i_col_rave_id = 2
  i_col_rave_imag = 14
  i_col_rave_lon = 5
  i_col_rave_lat = 6
  i_col_rave_vrad = 7

  strarr_abundances = readfiletostrarr(str_datafile_corrado,' ',I_NDATALINES=i_ndatalines)
;  strarr_rave_lines = readfilelinestoarr(str_datafile_rave, STR_DONT_READ='#')
  strarr_rave = readfiletostrarr(str_datafile_rave,' ',HEADER=strarr_header,I_NCOLS=i_ncols)

;  strarr_ab_id = strtrim(strmid(strarr_abundances(*),i_pos_ab_id, i_pos_ab_id_end-i_pos_ab_id),2)
;  print,'strarr_ab_id = ',strarr_ab_id
;  strarr_ab_feh = strtrim(strmid(strarr_abundances(*),i_pos_ab_feh, i_pos_ab_feh_end-i_pos_ab_feh),2)
;  print,'strarr_ab_feh = ',strarr_ab_feh
;  strarr_ab_n = strtrim(strmid(strarr_abundances(*),i_pos_ab_n, i_pos_ab_n_end-i_pos_ab_n),2)
;  print,'strarr_ab_n = ',strarr_ab_n
;  strarr_ab_mh = strtrim(strmid(strarr_abundances(*),i_pos_ab_mhc, i_pos_ab_mhc_end-i_pos_ab_mhc),2)
;  print,'strarr_ab_mh = ',strarr_ab_mh
;  strarr_ab_ac = strtrim(strmid(strarr_abundances(*),i_pos_ab_ac, i_pos_ab_ac_end-i_pos_ab_ac),2)
;  print,'strarr_ab_ac = ',strarr_ab_ac
;  strarr_ab_frac = strtrim(strmid(strarr_abundances(*),i_pos_ab_frac, i_pos_ab_frac_end-i_pos_ab_frac),2)
;  print,'strarr_ab_frac = ',strarr_ab_frac
;  strarr_ab_ntot = strtrim(strmid(strarr_abundances(*),i_pos_ab_ntot, i_pos_ab_ntot_end-i_pos_ab_ntot),2)
;  print,'strarr_ab_ntot = ',strarr_ab_ntot
;  strarr_ab_chisq = strtrim(strmid(strarr_abundances(*),i_pos_ab_chisq, i_pos_ab_chisq_end-i_pos_ab_chisq),2)
;  print,'strarr_ab_chisq = ',strarr_ab_chisq
;stop

  strarr_rave_id = strarr_rave(*,i_col_rave_id)
  strarr_rave_obsid = strarr_rave(*,i_col_rave_obsid)

  openw,lun,str_datafile_out,/GET_LUN
  if n_elements(strarr_header) gt 0 then begin
    for i=0ul, n_elements(strarr_header)-1 do begin
      printf,lun,strarr_header(i)+' '
    endfor
  endif
  for i=0ul, i_ndatalines-1 do begin
    indarr = where(strarr_rave_id eq strarr_abundances(i,i_col_abundances_id))
    if indarr(0) lt 0 then $
      indarr = where(strarr_rave_obsid eq strarr_abundances(i,i_col_abundances_id))
    if indarr(0) ge 0 then begin
      print,'star '+strarr_abundances(i,i_col_abundances_id)+' found in RAVE file'
      if double(strarr_abundances(i,i_col_abundances_frac)) ge 0.7 then begin
        str_out = ''
        for j=0ul, i_ncols-1 do begin
          str_out = str_out+strarr_rave(indarr(0),j)+' '
        endfor
        str_out = str_out+strarr_abundances(i,i_col_abundances_feh)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_n)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_teff)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_logg)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_mhc)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_ac)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_frac)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_ntot)+' '
        str_out = str_out+strarr_abundances(i,i_col_abundances_chisq);+' '
;        str_out = str_out+strarr_rave(indarr(0),i_ncols-1)
        printf,lun,str_out
;        if double(strarr_rave(indarr(0),19)) gt 3000. then begin
;          print,'strarr_abundances(i,*) = ',strarr_abundances(i,*)
;          print,'strarr_rave(indarr(0),*) = ',strarr_rave(indarr(0),*)
;          stop
;        endif
      end else begin
        print,'PROBLEM: star '+strarr_abundances(i,i_col_abundances_id)+': frac < 0.7'
      endelse
    end else begin
      print,'PROBLEM: star '+strarr_abundances(i,i_col_abundances_id)+' NOT found in RAVE file'
    endelse
  endfor
  free_lun,lun

; --- clean up
  strarr_abundances = 0
  strarr_rave = 0
  strarr_rave_id = 0
  strarr_rave_obsid = 0
end
