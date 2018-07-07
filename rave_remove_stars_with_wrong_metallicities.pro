pro rave_remove_stars_with_wrong_metallicities
  str_filename_in = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr_I2MASS-9ltIlt12_STN-gt-20-with-atm-par.dat'
  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_MH-good.dat'
  strarr_data = readfiletostrarr(str_filename_in,' ',I_NLines=i_nlines,I_NCols=i_ncols)
  strarr_lines = readfilelinestoarr(str_filename_in)
  for i=0ul, i_ncols-1 do begin
    print,'strarr_data(0,',i,') = ',strarr_data(0,i)
  endfor
  dblarr_mh = double(strarr_data(*,21))
  print,dblarr_mh
  indarr = where(dblarr_mh gt 2.,COMPLEMENT=indarr_good)
  print,'size(indarr) = ',size(indarr)
  for i=0ul, n_elements(indarr)-1 do begin
    print,'dblarr_mh(indarr(',i,')=',indarr(i),') = ',dblarr_mh(indarr(i)),', dblarr_teff(',indarr(i),',19)=',strarr_data(indarr(i),19)
    print,strarr_lines(indarr(i))
  endfor
  openw,lun,str_filename_out,/GET_LUN
  for i=0ul, n_elements(indarr_good)-1 do begin
    printf,lun,strarr_lines(indarr_good(i))
  endfor
  free_lun,lun
end
