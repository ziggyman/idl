pro rave_find_doubles

; --- pre: rave_dist_write_min_err

  dbl_dist_min_arcsec = 2.

  b_debug = 0
  b_dist = 0
  b_breddels = 0

  b_chem = 0
  i_dr = 10

  b_use_lon_lat = 1; --- 0: compare RAVEObsID's
                   ; --- 1: compare lon and lat

  if b_dist then $
    b_take_smallest_error = 0 $
  else $
    b_take_smallest_error = 0

  str_dist_min_arcsec = strtrim(string(dbl_dist_min_arcsec),2)
  str_dist_min_arcsec = strmid(str_dist_min_arcsec,0,strpos(str_dist_min_arcsec,'.'))

  if b_dist then begin
    str_ravefile = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists.dat'
;    str_ravefile = '/suphys/azuri/daten/rave/rave_data/distances/all_20100201_SN20_lon-lat_all-dists.dat'
    i_col_id  = 0
    i_col_lon = 1
    i_col_lat = 2
    i_col_err = 23
    i_col_snratio = 17
    i_col_stn = 17
    b_calc_lon_lat_from_ra_dec = 1
    if b_breddels then begin
      str_ravefile = '/suphys/azuri/daten/rave/rave_data/distances/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      i_col_id  = 0
      i_col_lon = 3
      i_col_lat = 4
;      i_col_err = 23
      i_col_snratio = 17
      i_col_stn = 17
      b_calc_lon_lat_from_ra_dec = 1
    endif
    if b_take_smallest_error then begin
      str_ravefile_out = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_no-doubles-within-'+str_dist_min_arcsec+'-arcsec-minerr.dat'
    end else begin
      str_ravefile_out = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_no-doubles-within-'+str_dist_min_arcsec+'-arcsec-maxsnr.dat';minerr.dat
    endelse
  end else begin
    if b_chem then begin
      str_ravefile = '/suphys/azuri/daten/rave/rave_data/abundances/RAVE_abd_frac_gt_70_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par.dat'
                                                                   ;RAVE_abd_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS_9ltIlt12_minus_ic1.dat';RAVE_abd_I2MASS_9ltIlt12_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      i_col_id  = 0
      i_col_lon = 5
      i_col_lat = 6
      i_col_snratio = 33
      i_col_stn = 35
    end else if i_dr eq 7 then begin
      str_ravefile = '/suphys/azuri/daten/rave/rave_data/release7/rave_internal_290110.dat'
      i_col_id  = 0
      i_col_lon = 3
      i_col_lat = 4
      i_col_snratio = 32
    end else if i_dr eq 8 then begin
      str_ravefile = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-flag_STN-gt-20-with-atm-par.dat';rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5.dat';rave_internal_dr8_stn_gt_20_good.dat'
;      str_ravefile = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_lt_20_good.dat'
;      str_ravefile = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_IbI-ge-25.dat';_with-2MASS-JK_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      i_col_id  = 0
      i_col_lon = 5
      i_col_lat = 6
      i_col_snratio = 33
      i_col_stn = 35
    end else if i_dr eq 9 then begin
      str_ravefile = '/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_STN-gt-13-with-atm-par_with-2MASS-JK_no-flag.dat'
;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      i_col_id  = 0
      i_col_lon = 5
      i_col_lat = 6
      i_col_snratio = 33
      i_col_stn = 35
    end else if i_dr eq 10 then begin
      str_ravefile = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      i_col_id  = 0
      i_col_lon = 5
      i_col_lat = 6
      i_col_snratio = 33
      i_col_stn = 35
    end
    str_ravefile_out = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_no-doubles-within-'+str_dist_min_arcsec+'-arcsec-maxsnr.dat'
    b_calc_lon_lat_from_ra_dec = 0
  end
;  str_ravefile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808-1st_release.dat'
;  str_ravefile_out = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808-1st_release_no_doubles.dat'
  openw,lun,str_ravefile_out,/GET_LUN

  i_nstars = countdatlines(str_ravefile)

  strarr_ravedata = readfiletostrarr(str_ravefile,' ')
  strarr_ravedata_lines = readfilelinestoarr(str_ravefile,STR_DONT_READ='#')

  strarr_objectid = strarr_ravedata(*,i_col_id)
  if not b_dist then $
    strarr_objectidb = strarr_ravedata(*,i_col_id+1)
  dblarr_lon = double(strarr_ravedata(*,i_col_lon))
  dblarr_lat = double(strarr_ravedata(*,i_col_lat))
  dblarr_stn = double(strarr_ravedata(*,i_col_stn))
  dblarr_snr = double(strarr_ravedata(*,i_col_snratio))
  if b_chem or (i_dr eq 8) then begin
    indarr_snr = where(dblarr_stn eq 0)
    if indarr_snr(0) ge 0 then $
      dblarr_stn(indarr_snr) = dblarr_snr(indarr_snr)
  endif
  if b_take_smallest_error then begin
;    dblarr_err = dblarr(n_elements(dblarr_lon));,n_elements(i_col_err))
;    for i=0,n_elements(i_col_err)-1 do begin
      dblarr_err = double(strarr_ravedata(*,i_col_err));(i)))
;    endfor
  endif

  if b_calc_lon_lat_from_ra_dec then begin
    euler,dblarr_lon,dblarr_lat,dblarr_lon_temp,dblarr_lat_temp,SELECT=1
    dblarr_lon = dblarr_lon_temp
    dblarr_lon_temp = 0
    dblarr_lat = dblarr_lat_temp
    dblarr_lat_temp = 0
  end

  str_plot = strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_doubles_within-'+str_dist_min_arcsec+'-arcsec.ps'
  set_plot,'ps'
  device,filename=str_plot
  plot,[0.,360.],[-90.,-90.],xrange=[0.,360.],yrange=[-90.,90.],xstyle=1,ystyle=1
  indarr_objectid_sort = sort(strarr_objectid)
  openw,luna,strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_sorted.dat',/GET_LUN
    for i=0ul,i_nstars-1 do begin
      printf,luna,strarr_objectid(indarr_objectid_sort(i))
    endfor
    if b_debug then $
      print,'rave_find_doubles: sorted file written'
  free_lun,luna

  openw,luna,strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_doubles_within-'+str_dist_min_arcsec+'-arcsec.dat',/GET_LUN

  indarr_found = [-1]
  i=0ul
  i_ndoubles_found = 0
  while i lt i_nstars-1 do begin
;    if b_debug then $
      print,' '
;    if b_debug then $
      print,'rave_find_doubles: checking star number i=',i,': strarr_objectid(indarr_objectid_sort(i)) = ',strarr_objectid(indarr_objectid_sort(i))
    if b_debug then $
      print,' '
    if b_use_lon_lat then begin
      indarr_check_found = where(indarr_found eq i)
      if indarr_check_found(0) lt 0 then begin
        dist_arcsec, I_DBLARR_RA     = dblarr_lon,$
                     I_DBLARR_DEC    = dblarr_lat,$
                     I_DBL_RA        = dblarr_lon(i),$
                     I_DBL_DEC       = dblarr_lat(i),$
                     I_B_LON_LAT     = 1,$
                     I_B_DEGREES     = 1,$
                     O_DBLARR_DIST   = o_dblarr_dist
        indarr = where(o_dblarr_dist lt 5.)
;        indarr = where((abs(dblarr_lon - dblarr_lon(i)) lt 0.0001) and (abs(dblarr_lat - dblarr_lat(i)) lt 0.0001))
        if n_elements(indarr) gt 1 then begin
          for iii=0, n_elements(indarr)-1 do begin
            printf,luna,strarr_ravedata_lines(indarr(iii))
            indarr_check_found = where(indarr_found eq indarr(iii),count_found_already)
            if count_found_already gt 0 then begin
              print,'strarr_ravedata_lines(i=',i,') = ',strarr_ravedata_lines(i)
              print,'strarr_ravedata_lines(indarr(iii)=',indarr(iii),') = ',strarr_ravedata_lines(indarr(iii))
              print,'strarr_ravedata_lines(indarr_found(indarr_check_found)=',indarr_found(indarr_check_found),'-1) = ',strarr_ravedata_lines(indarr_found(indarr_check_found)-1)
              print,'strarr_ravedata_lines(indarr_found(indarr_check_found)=',indarr_found(indarr_check_found),') = ',strarr_ravedata_lines(indarr_found(indarr_check_found))
              print,'strarr_ravedata_lines(indarr_found(indarr_check_found)=',indarr_found(indarr_check_found),'+1) = ',strarr_ravedata_lines(indarr_found(indarr_check_found)+1)

              print,'PROBLEM: count_found_already > 1'

              dist_arcsec, I_DBLARR_RA     = dblarr_lon(indarr_found(indarr_check_found)-1:indarr_found(indarr_check_found)+1),$
                          I_DBLARR_DEC    = dblarr_lat(indarr_found(indarr_check_found)-1:indarr_found(indarr_check_found)+1),$
                          I_DBL_RA        = dblarr_lon(i),$
                          I_DBL_DEC       = dblarr_lat(i),$
                          I_B_LON_LAT     = 1,$
                          I_B_DEGREES     = 1,$
                          O_DBLARR_DIST   = o_dblarr_dist_temp
              print,'o_dblarr_dist_temp = ',o_dblarr_dist_temp
              if iii eq n_elements(indarr)-1 then $
                stop
            endif
          endfor
          print,'star ',i,' found ',n_elements(indarr),' times'
          i_ndoubles_found = i_ndoubles_found + n_elements(indarr) - 1
          maxsnr = max(dblarr_snr(indarr))
          ind_maxsnr = where(dblarr_snr(indarr) eq maxsnr)
          ind_maxsnr = ind_maxsnr(n_elements(ind_maxsnr)-1)
          oplot,[dblarr_lon(indarr(ind_maxsnr)),dblarr_lon(indarr(ind_maxsnr))],$
                [dblarr_lat(indarr(ind_maxsnr)),dblarr_lat(indarr(ind_maxsnr))],$
                psym=2,$
                symsize=0.1
          printf,lun,strarr_ravedata_lines(indarr(ind_maxsnr))
        end else begin
          printf,lun,strarr_ravedata_lines(i)
        end
        if indarr_found(0) eq -1 then begin
          indarr_found = indarr
        end else begin
          indarr_found = [indarr_found,indarr]
        endelse
      endif
      i = i+1
    end else begin
      indarr = where(strarr_objectid(indarr_objectid_sort) eq strarr_objectid(indarr_objectid_sort(i)), count)
      if strarr_objectid(indarr_objectid_sort(indarr(0))) ne 'MOON' then begin
        if count gt 1 then begin
          for iii=0, count-1 do begin
            printf,luna,strarr_ravedata_lines(indarr(iii))
          endfor
          i_ndoubles_found = i_ndoubles_found + count - 1
          oplot,dblarr_lon(indarr_objectid_sort(indarr)),$
                dblarr_lat(indarr_objectid_sort(indarr)),$
                psym=2,$
                symsize=0.1

          if b_debug then $
            print,strarr_objectid(indarr_objectid_sort(i))+' exists ',count,' times'

          if not b_take_smallest_error then begin
            if b_debug then $
              print,'rave_find_doubles: dblarr_snr(indarr_objectid_sort(indarr)) = ',dblarr_snr(indarr_objectid_sort(indarr))
            maxsnr = max(dblarr_snr(indarr_objectid_sort(indarr)))
            ind_maxsnr = where(dblarr_snr(indarr_objectid_sort(indarr)) eq maxsnr)
            ind_maxsnr = ind_maxsnr(n_elements(ind_maxsnr)-1)
            if b_debug then $
                print,'rave_find_doubles: dblarr_snr(indarr_objectid_sort(indarr(ind_maxsnr)) = ',dblarr_snr(indarr_objectid_sort(indarr(ind_maxsnr)))
          end else begin
            indarr_minerr = lonarr(n_elements(i_col_err))
            dbl_err_min = 100000.
            if b_debug then $
              print,'rave_find_doubles: dblarr_err(indarr_objectid_sort(indarr)) = ',dblarr_err(indarr_objectid_sort(indarr))
            dbl_minerr = min(dblarr_err(indarr_objectid_sort(indarr)))
            if b_debug then $
              print,'rave_find_doubles: dbl_minerr = ',dbl_minerr
            indarr_min = where(dblarr_err(indarr_objectid_sort(indarr)) eq dbl_minerr)
            ind_minerr = indarr_min(0)
            if b_debug then $
              print,'rave_find_doubles: ind_minerr = ',ind_minerr
            ind_maxsnr = ind_minerr
            if b_debug then $
              print,'rave_find_doubles: ind_maxsnr = ',ind_maxsnr
          end
          if not b_dist then begin
            str_temp = strtrim(strmid(strarr_ravedata_lines(indarr_objectid_sort(indarr(ind_maxsnr))),strpos(strarr_ravedata_lines(indarr_objectid_sort(indarr(ind_maxsnr))),' ')+1),2)

            str_temp = strtrim(strmid(str_temp,strpos(str_temp,' ')+1),2)

            strarr_ravedata_lines(indarr_objectid_sort(indarr(ind_maxsnr))) = strarr_objectid(indarr_objectid_sort(indarr(0))) + ' ' + $
            strarr_objectidb(indarr_objectid_sort(indarr(0))) + ' ' + $
            str_temp
          endif
          print,'rave_find_doubles: printing star '+strarr_ravedata_lines(indarr_objectid_sort(indarr(ind_maxsnr)))
          printf,lun,strarr_ravedata_lines(indarr_objectid_sort(indarr(ind_maxsnr)))
        end else begin
          if b_debug then $
            print,'rave_find_doubles: i=',i,': indarr(0) = ',indarr(0)
          print,'rave_find_doubles: printing star '+strarr_ravedata_lines(indarr_objectid_sort(i))
          printf,lun,strarr_ravedata_lines(indarr_objectid_sort(i))
        end
      end
      i = i+count
    end
  end

  free_lun,lun
  free_lun,luna
  device,/close
  set_plot,'x'

  print,'i_ndoubles_found = ',i_ndoubles_found
  print,'file <'+str_ravefile_out+'> written'
end
