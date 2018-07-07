pro ravechem_make_datafile
  str_filename_catalogue = '/home/azuri/daten/rave/rave_data/abundances/RAVE_abd_extract'
  str_filename_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all.dat'

  i_col_cat_objectid = 0
  i_col_cat_obsid = 1
  i_col_cat_raveid = 2
  i_col_cat_feh = 4
  i_col_cat_n = 5
  i_col_cat_t = 6
  i_col_cat_logg = 7
  i_col_cat_mhr = 8
  i_col_cat_ar = 9
  i_col_cat_mhc = 10
  i_col_cat_ac = 11
  i_col_cat_stn = 12
  i_col_cat_s2n = 13
  i_col_cat_frac = 14
  i_col_cat_ntot = 15
  i_col_cat_chisq = 16

  i_col_rave_objectid = 2
  i_col_rave_obsid = 0
  i_col_rave_raveid = 1
  i_col_rave_ra = 3
  i_col_rave_dec = 4
  i_col_rave_lon = 5
  i_col_rave_lat = 6
  i_col_rave_vrad = 7
  i_col_rave_i2mass = 14
  i_col_rave_idenis = 50
  i_col_rave_j2mass = 59
  i_col_rave_k2mass = 63
  i_col_rave_jdenis = 52
  i_col_rave_kdenis = 54
  i_col_rave_snratio = 33
  i_col_rave_s2n = 34
  i_col_rave_stn = 35

  strarr_cat = readfiletostrarr(str_filename_catalogue,' ',I_NLINES=i_nlines_cat,I_NCOLS=i_ncols_cat)
  strarr_rave = readfiletostrarr(str_filename_rave,' ',I_NLINES=i_nlines_rave,I_NCOLS=i_ncols_rave)

  for i=0ul, i_nlines_cat-1 do begin
    str_objectid = strarr_cat(i_col_cat_objectid)
    str_obsid = strarr_cat(i_col_cat_obsid)
    str_raveid = strarr_cat(i_col_cat_raveid)
    indarr = where((strarr_rave(*,i_col_rave_objectid) eq str_objectid) or (strarr_rave(*,i_col_rave_obsid) eq str_obsid) or (strarr_rave(*,i_col_raveid) eq str_raveid))
    if indarr(0) eq -1 then begin
      print,'i=',i,': star <'+str_objectid+'> not found'
    end else begin
      print,'i=',i,': star <'+str_objectid+'> found'
      dblarr_stn = double(strarr_rave(indarr,i_col_rave_stn))
      dblarr_s2n = double(strarr_rave(indarr,i_col_rave_s2n))
      for j=0,i_elements(indarr)-1 do begin
        indarr_snr = where(dblarr_stn eq 0)
        if indarr_snr(0) ge 0 then begin
          dblarr_stn(indarr_snr) = dblarr_s2n(indarr_snr)
          indarr_s2n = where(dblarr_s2n eq 0)
          if indarr_s2n(0) ge 0 then begin
            dblarr_stn(indarr_snr(indarr_s2n)) = dblarr_snratio(indarr_snr(indarr_s2n))
          end
        end
      endfor
      indarr_max = where(dblarr_stn eq max(dblarr_stn))
      str_line = strarr_rave(indarr(0),i_col_rave_obsid)
      for j=1,i_ncols_rave-1 do begin
        str_line = str_line + ' ' + strarr_rave(indarr(indarr_max(0)),j)
      endfor
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_feh)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_n)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_mhc)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_ac)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_frac)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_ntot)
      str_line = str_line + ' ' + strarr_cat(i,i_col_cat_chisq)
    endelse
  endfor
end
