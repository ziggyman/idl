pro rave_dist_get_snr
  str_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr.dat'
  str_dist = '/home/azuri/daten/rave/rave_data/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS-9ltIlt12-lb.dat'

  str_out = strmid(str_dist,0,strpos(str_dist,'.',/REVERSE_SEARCH)) + '+stn.dat'

  int_col_rave_obsid = 0
  int_col_rave_id = 1
  int_col_rave_objectid = 2
  int_col_rave_denisid= 48
  int_col_rave_snr = 33
  int_col_rave_s2n = 34
  int_col_rave_stn = 35

  int_col_dist_id = 0

  strarr_header = ['0']
  strarr_rave = readfiletostrarr(str_rave,' ')
  strarr_dist = readfiletostrarr(str_dist,' ',HEADER = strarr_header)
  strarr_dist_lines = readfilelinestoarr(str_dist,STR_DONT_READ='#')

  strarr_dist_id = strarr_dist(*,int_col_dist_id)

  strarr_rave_obsid = strarr_rave(*,int_col_rave_obsid)
  strarr_rave_id = strarr_rave(*,int_col_rave_id)
  strarr_rave_objectid = strarr_rave(*,int_col_rave_objectid)
  strarr_rave_denisid = strarr_rave(*,int_col_rave_denisid)

  dblarr_rave_stn = double(strarr_rave(*,int_col_rave_stn))
  dblarr_rave_s2n = double(strarr_rave(*,int_col_rave_s2n))
  dblarr_rave_snr = double(strarr_rave(*,int_col_rave_snr))

  indarr = where(abs(dblarr_rave_stn) lt 0.0001)
  if indarr(0) ge 0 then begin
    dblarr_rave_stn(indarr) = dblarr_rave_s2n(indarr)
    indarr = where(abs(dblarr_rave_stn) lt 0.0001)
    if indarr(0) ge 0 then begin
      dblarr_rave_stn(indarr) = dblarr_rave_snr(indarr)
    endif
  endif

  openw,lun,str_out,/GET_LUN
  if strarr_header(0) ne '0' then begin
    for i=0ul, n_elements(strarr_header)-1 do begin
      printf,lun,strarr_header(i)+' STN'
    endfor
  endif
  for i=0ul, n_elements(strarr_dist_id)-1 do begin
    indarr = where((strarr_rave_obsid eq strarr_dist_id(i)) or (strarr_rave_id eq strarr_dist_id(i)) or (strarr_rave_objectid eq strarr_dist_id(i)) or (strarr_rave_denisid eq strarr_dist_id(i)))
    if indarr(0) ge 0 then begin
      if n_elements(indarr) gt 1 then $
        print,'rave_dist_get_snr: PROBLEM: more than 1 star found for id '+strarr_dist_id(i)
      printf,lun,strarr_dist_lines(i)+' '+strtrim(string(dblarr_rave_stn(indarr(0))),2)
    end else begin
      print,'rave_dist_get_snr: PROBLEM: Could not find star strarr_dist_id(i=',i,') = '+strarr_dist_id(i)
    end
  endfor
  free_lun,lun
end
