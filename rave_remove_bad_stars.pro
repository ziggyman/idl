pro rave_remove_bad_stars

  i_rave_dr = 10

  i_col_flag_rave = 68
  i_col_flag_2mass = 65
  delimiter = ' '
  
  if i_rave_dr eq 10 then begin    
    str_filename = '/home/azuri/daten/rave/rave_data/release10/raveinternal_VDR3_20120515.csv'
;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_STN-gt-13-with-atm-par.dat'
;'/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5.dat'
;rave_internal_dr8_all_with-2MASS-JK_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12.dat';_no_doubles_maxsnr.dat';_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat'
    i_col_flag_rave = 59
    i_col_flat_2mass = 56
    delimiter = ';'
  endif
  str_filename_out = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))
  if strpos(str_filename,'_with-2MASS-JK') lt 0 then begin
    str_filename_out_a = str_filename_out+'_with-2MASS-JK.dat'
    str_filename_out_b = str_filename_out+'_with-2MASS-JK_no-flag.dat'
  end else begin
    str_filename_out_a = ''
    str_filename_out_b = str_filename_out+'_no-flag.dat'
  end

  strarr_data = readfiletostrarr(str_filename,delimiter)
  strarr_data_lines = readfilelinestoarr(str_filename)

  if n_elements(strarr_data_lines) ne n_elements(strarr_data(*,0)) then stop
  
  print,strarr_data(*,i_col_flag_rave)
  stop

  if str_filename_out_a ne '' then $
    openw,luna,str_filename_out_a,/GET_LUN
   openw,lunb,str_filename_out_b,/GET_LUN

    i_nbad_a = 0ul
    i_nbad_b = 0ul
    for i=0ul, n_elements(strarr_data(*,0))-1 do begin
      if strmid(strarr_data(i,i_col_flag_2mass),0,1) ne 'A' or strmid(strarr_data(i,i_col_flag_2mass),2,1) ne 'A' then begin
        print,'problem: star ',i,': rave_flag = <'+strarr_data(i,i_col_flag_rave)+'>, 2mass_flag = <'+strarr_data(i,i_col_flag_2mass)+'>'
        i_nbad_a = i_nbad_a+1
        i_nbad_b = i_nbad_b+1
      end else begin
        if str_filename_out_a ne '' then $
          printf,luna,strarr_data_lines(i)
        if strarr_data(i,i_col_flag_rave) eq '' then begin
          printf,lunb,strarr_data_lines(i)
        end else begin
          i_nbad_b = i_nbad_b+1
        endelse
      endelse
    endfor
   free_lun,lunb
  if str_filename_out_a ne '' then $
    free_lun,luna
  print,i_nbad_a,' bad stars found for file <*_with-2MASS-JK.dat>'
  print,i_nbad_b,' bad stars found for file <*_good.dat>'
end