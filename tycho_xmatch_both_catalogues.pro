pro tycho_xmatch_both_catalogues
  str_all = '/home/azuri/daten/rave/ammons_tycho/asu.tsv'
  str_dwarfs = '/home/azuri/daten/rave/ammons_tycho/dwarfs.tsv'

  str_out = '/home/azuri/daten/rave/ammons_tycho/all.dat'

  int_col_all_id = 5
  int_col_all_lon = 0
  int_col_all_lat = 1
  int_col_all_teff = 22
  int_col_all_eteff = 23
  int_col_all_dist = 25
  int_col_all_edist = 26
  int_col_all_jmag = 16
  int_col_all_kmag = 20

  int_col_dwarfs_id = 5
  int_col_dwarfs_teff = 27
  int_col_dwarfs_eteff = 28
  int_col_dwarfs_dist = 24
  int_col_dwarfs_edist = 25
  int_col_dwarfs_feh = 30
  int_col_dwarfs_efeh = 31

  strarr_all = readfiletostrarr(str_all,';')
  strarr_dwarfs = readfiletostrarr(str_dwarfs,';')

  i_n_lines_done = countdatlines(str_out)
  if i_n_lines_done gt 1 then begin
    i_start = i_n_lines_done
    openw,lun,str_out,/GET_LUN,/APPEND
  end else begin
    i_start = 0ul
    openw,lun,str_out,/GET_LUN
    printf,lun,'#lon lat 2MASS-Jmag 2MASS-Kmag teff eteff dist edist feh efeh'
  endelse
  indarr_dwarfs = lindgen(n_elements(strarr_dwarfs(*,0)))
  for i=i_start, n_elements(strarr_all(*,0))-1 do begin
    strarr_out = strarr(10)

    strarr_out(0) = strarr_all(i,int_col_all_lon)
    strarr_out(1) = strarr_all(i,int_col_all_lat)
    strarr_out(2) = strarr_all(i,int_col_all_jmag)
    strarr_out(3) = strarr_all(i,int_col_all_kmag)
    strarr_out(4) = strarr_all(i,int_col_all_teff)
    strarr_out(5) = strarr_all(i,int_col_all_eteff)
    strarr_out(6) = strarr_all(i,int_col_all_dist)
    strarr_out(7) = strarr_all(i,int_col_all_edist)
    strarr_out(8) = '0.'
    strarr_out(9) = '0.'

    int_ndwarfs_found = 0
    indarr= where(strarr_dwarfs(indarr_dwarfs,int_col_dwarfs_id) eq strarr_all(i,int_col_all_id))
    if n_elements(indarr) gt 1 then $
      print,'PROBLEM: more than one dwarf found with id <'+strarr_all(i,int_col_all_id)+'>'
    if indarr(0) ge 0 then begin
      print,'star i=',i,' found'
      strarr_out(4) = strarr_dwarfs(indarr_dwarfs(indarr(0)),int_col_dwarfs_teff)
      strarr_out(5) = strarr_dwarfs(indarr_dwarfs(indarr(0)),int_col_dwarfs_eteff)
      strarr_out(8) = strarr_dwarfs(indarr_dwarfs(indarr(0)),int_col_dwarfs_feh)
      strarr_out(9) = strarr_dwarfs(indarr_dwarfs(indarr(0)),int_col_dwarfs_efeh)
      remove_ith_element_from_array,indarr_dwarfs,indarr(0)
      int_ndwarfs_found = int_ndwarfs_found + 1
    endif

    print,'printing star ',i
    printf,lun,strarr_out(0)+' '+strarr_out(1)+' '+strarr_out(2)+' '+strarr_out(3)+' '+strarr_out(4)+' '+strarr_out(5)+' '+strarr_out(6)+' '+strarr_out(7)+' '+strarr_out(8)+' '+strarr_out(9)
  endfor
  free_lun,lun
  print,'int_ndwarfs_found = ',int_ndwarfs_found
end
