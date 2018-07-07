pro rave_find_solar_siblings
  str_ravefile = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_heights.dat'

  str_ravefile_all = '/home/azuri/daten/rave/rave_data/release7/rave_internal_290110_no_doubles.dat'

  str_rmag_time = '/home/azuri/daten/rave/rave_data/distances/rmag_t_sn.txt'

  i_col_lon   = 4
  i_col_lat   = 5
  i_col_ra    = 2
  i_col_dec   = 3
  i_col_vrad  = 6
  i_col_pmra  = 8
  i_col_pmdec = 10
  i_col_mh    = 20
  i_col_dist  = 22
  i_col_height = 25

  i_col_bt = 34
  i_col_vt = 36
  i_col_r_a = 41
  i_col_r_b = 43

  d_suns_dist_from_center = 8.5
  d_suns_height_above_plane = 0.02
  d_emh = 0.2
  d_max_lat = 5.
  d_max_diff_r = 1.
  d_max_pm = 10.
  d_max_height = 0.02
  d_max_vrad = 5.

  strarr_ravedata = readfiletostrarr(str_ravefile,' ',I_NLINES=i_nlines,I_NCOLS=i_ncols)

  dblarr_lon = double(strarr_ravedata(*,i_col_lon))
  dblarr_lat = double(strarr_ravedata(*,i_col_lat))
  dblarr_ra = double(strarr_ravedata(*,i_col_ra))
  dblarr_dec = double(strarr_ravedata(*,i_col_dec))

  strarr_ravedata_all = readfiletostrarr(str_ravefile_all,' ',I_NLINES=i_nlines_all,I_NCOLS=i_ncols_all)

  strarr_raveid_all = strarr_ravedata_all(*,0)
  dblarr_bt = double(strarr_ravedata_all(*,i_col_bt))
  dblarr_vt = double(strarr_ravedata_all(*,i_col_vt))
  dblarr_v = dblarr_vt - (0.09 * (dblarr_bt - dblarr_vt))
  dblarr_r_a = double(strarr_ravedata_all(*,i_col_r_a))
  dblarr_r_b = double(strarr_ravedata_all(*,i_col_r_b))

  set_plot,'ps'
  device,filename=strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_lon_lat.ps'
  plot,dblarr_lon,dblarr_lat,xrange=[0.,360.],xstyle=1,yrange=[-90.,90.],ystyle=1,psym=2,xtitle='Galactic Longitude',ytitle='Galactic Latitude',charsize=1.5,charthick=2
  device,/close

  ; --- r from center of Galaxy
  dblarr_r = sqrt((d_suns_dist_from_center - (double(strarr_ravedata(*,i_col_dist)) * cos(double(strarr_ravedata(*,i_col_lon)))))^2. + (double(strarr_ravedata(*,i_col_dist)) * (sin(double(strarr_ravedata(*,i_col_lon))))^2.))
  indarr = where(dblarr_r lt d_suns_dist_from_center + d_max_diff_r and dblarr_r gt d_suns_dist_from_center - d_max_diff_r)
  strarr_ravedata = strarr_ravedata(indarr,*)
  print,'rave_find_solar_siblings: r: ',n_elements(indarr),' stars in range'

  ; --- proper motions and distances
  dblarr_d_pm_a = readfiletodblarr('/home/azuri/daten/rave/rave_data/distances/d_pm_1.dat')
  dblarr_d_pm_b = readfiletodblarr('/home/azuri/daten/rave/rave_data/distances/d_pm_2.dat')
  dblarr_d_pm_c = readfiletodblarr('/home/azuri/daten/rave/rave_data/distances/d_pm_3.dat')
  dblarr_d_pm_d = readfiletodblarr('/home/azuri/daten/rave/rave_data/distances/d_pm_4.dat')
  dblarr_pm = sqrt((double(strarr_ravedata(*,i_col_pmdec)))^2. + (double(strarr_ravedata(*,i_col_pmra)))^2.)
  dblarr_dist = double(strarr_ravedata(*,i_col_dist))

  indarr_pm = where(dblarr_pm gt 0.2 and dblarr_pm lt 600.)
  indarr_d = where(dblarr_dist(indarr_pm) gt 0.035 and dblarr_dist(indarr_pm) lt 10.)

  indarr = lonarr(n_elements(indarr_d))
  i_n_good_stars = 0ul
  for i=0ul,n_elements(indarr_d)-1 do begin
    dbl_dist = dblarr_dist(indarr_pm(indarr_d(i)))
    dbl_pm = dblarr_pm(indarr_pm(indarr_d(i)))
    print,'rave_find_solar_siblings: checking star with dbl_dist = ',dbl_dist,', dbl_pm = ',dbl_pm
    if dbl_dist lt 0.2 then begin
      dblarr_aa = dblarr_d_pm_c
      dblarr_bb = dblarr_d_pm_d
      print,'case 0'
    end else if dbl_dist ge 0.200 and dbl_dist lt 0.78 then begin
      dblarr_aa = dblarr_d_pm_c
      dblarr_bb = dblarr_d_pm_a
      print,'case 1'
    end else begin
      dblarr_aa = dblarr_d_pm_b
      dblarr_bb = dblarr_d_pm_a
      print,'case 2'
    end
    dblarr_aa(*,0) = dblarr_aa(*,0) / 1000.
    dblarr_bb(*,0) = dblarr_bb(*,0) / 1000.

    indarr_aa_dist = where(dblarr_aa(*,0) le dbl_dist,count)
    print,'rave_find_solar_siblings: count1 = ',count
    if indarr_aa_dist(0) ge 0 then begin
      indarr_bb_dist = where(dblarr_bb(*,0) le dbl_dist,count)
      print,'rave_find_solar_siblings: count2 = ',count
      if indarr_bb_dist(0) ge 0 then begin
        dbl_pm_min = dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1),1) + (dbl_dist - dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1),0)) * (dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1)+1,1) - dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1),1)) / (dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1)+1,0) - dblarr_aa(indarr_aa_dist(n_elements(indarr_aa_dist)-1),0))

        dbl_pm_max = dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1),1) + (dbl_dist - dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1),0)) * (dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1)+1,1) - dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1),1)) / (dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1)+1,0) - dblarr_bb(indarr_bb_dist(n_elements(indarr_bb_dist)-1),0))
        print,'rave_find_solar_siblings: dbl_pm_min = ',dbl_pm_min,', dbl_pm_max = ',dbl_pm_max

        if dbl_pm ge dbl_pm_min and dbl_pm le dbl_pm_max then begin
          print,'rave_find_solar_siblings: star i=',i,': dbl_pm = ',dbl_pm,' within limits'
          indarr(i_n_good_stars) = i
          i_n_good_stars = i_n_good_stars + 1
        endif
;        indarr_aa_pm = where(dblarr_aa(*,1) le dbl_pm)
;        if indarr_aa_pm(0) ge 0 then begin
;          indarr_bb_
;        end
      endif
    endif
  endfor
  print,'rave_find_solar_siblings: i_n_good_stars = ',i_n_good_stars
  indarr = indarr(0:i_n_good_stars-1)
  print,'rave_find_solar_siblings: '
  strarr_ravedata = strarr_ravedata(indarr_pm(indarr_d(indarr)),*)
  dblarr_pm = dblarr_pm(indarr_pm(indarr_d(indarr)))
;  indarr_da = where(dblarr_dist(indarr_pm(indarr_d)) le 200.)
;  strarr_ravedata = strarr_ravedata(indarr_pm(indarr),*)
  print,'rave_find_solar_siblings: dist_pm: ',n_elements(indarr),' stars in range'
  set_plot,'ps'
  device,filename='/home/azuri/daten/rave/rave_data/distances/d_pm_rave_siblings.ps'
  plot,double(strarr_ravedata(*,i_col_dist)),dblarr_pm,psym = 2,xtitle='dist [kpc]',ytitle='pm [mas/yr]',/xlog,/ylog,xrange=[0.001,10.1],xstyle=1,symsize=0.2
  device,/close
  set_plot,'x'

  ; --- vrad
  indarr = where(abs(double(strarr_ravedata(*,i_col_vrad)) - d_suns_height_above_plane) le d_max_vrad)
  strarr_ravedata = strarr_ravedata(indarr,*)
  dblarr_pm = dblarr_pm(indarr)
  print,'rave_find_solar_siblings: vrad: ',n_elements(indarr),' stars in range'

  set_plot,'ps'
  device,filename='/home/azuri/daten/rave/rave_data/distances/d_pm_rave_siblings_vrad.ps'
  plot,double(strarr_ravedata(*,i_col_dist)),dblarr_pm,psym = 2,xtitle='dist [kpc]',ytitle='pm [mas/yr]',/xlog,/ylog,xrange=[0.001,10.1],xstyle=1,symsize=0.2
  device,/close
  set_plot,'x'

  ; --- height
  indarr = where(abs(double(strarr_ravedata(*,i_col_height)) - d_suns_height_above_plane) le d_max_height)
  strarr_ravedata = strarr_ravedata(indarr,*)
  dblarr_pm = dblarr_pm(indarr)
  print,'rave_find_solar_siblings: height: ',n_elements(indarr),' stars in range'

  set_plot,'ps'
  device,filename='/home/azuri/daten/rave/rave_data/distances/d_pm_rave_siblings_z.ps'
  plot,double(strarr_ravedata(*,i_col_dist)),dblarr_pm,psym = 2,xtitle='dist [kpc]',ytitle='pm [mas/yr]',/xlog,/ylog,xrange=[0.001,10.1],xstyle=1,symsize=0.2
  device,/close
  set_plot,'x'

  ; --- M/H
  indarr = where(abs(double(strarr_ravedata(*,i_col_mh))) le d_emh)
  strarr_ravedata = strarr_ravedata(indarr,*)
  dblarr_pm = dblarr_pm(indarr)
  print,'rave_find_solar_siblings: MH: ',n_elements(indarr),' stars in range'

  set_plot,'ps'
  device,filename='/home/azuri/daten/rave/rave_data/distances/d_pm_rave_siblings_mh.ps'
  plot,double(strarr_ravedata(*,i_col_dist)),dblarr_pm,psym = 2,xtitle='dist [kpc]',ytitle='pm [mas/yr]',/xlog,/ylog,xrange=[0.001,10.1],xstyle=1,symsize=0.2
  device,/close
  set_plot,'x'

;  ; --- lat
;  indarr = where(abs(double(strarr_ravedata(*,i_col_lat))) lt d_max_lat)
;  strarr_ravedata = strarr_ravedata(indarr,*)
;  print,'rave_find_solar_siblings: lat: ',n_elements(indarr),' stars in range'

;  indarr_dist = where(double(strarr_ravedata(*,i_col_dist)) gt 2.)
;  indarr =

  dblarr_lon = double(strarr_ravedata(*,i_col_lon))
  dblarr_lat = double(strarr_ravedata(*,i_col_lat))
  dblarr_ra = double(strarr_ravedata(*,i_col_ra))
  dblarr_dec = double(strarr_ravedata(*,i_col_dec))

  set_plot,'ps'
  device,filename=strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_siblings_lon_lat.ps'
  plot,dblarr_lon,dblarr_lat,xrange=[0.,360.],xstyle=1,yrange=[-90.,90.],ystyle=1,psym=2,xtitle='Galactic Longitude',ytitle='Galactic Latitude',charsize=1.5,charthick=2
  device,/close

  device,filename=strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_siblings_ra_dec.ps'
  plot,[dblarr_ra(0),dblarr_ra(1)],[dblarr_dec(0),dblarr_dec(1)],xrange=[360.,0.],xstyle=1,yrange=[-90.,0.],ystyle=1,psym=2,xtitle='RA',ytitle='DEC',charsize=1.5,charthick=2

  dblarr_rmag_t_sn = readfiletodblarr(str_rmag_time)

  i_nstars = 0
  strarr_raveid = strarr_ravedata(*,0)
  openw,lun,strmid(str_ravefile,0,strpos(str_ravefile,'.',/REVERSE_SEARCH))+'_siblings.dat',/GET_LUN
    printf,lun,'#ObjectID   RAVE_ID   RA   DEC   LON   LAT   Vmag   Rmag   t_obs   S/N'
    printf,lun,'#'
    dbl_total_exptime = 0.
    for i=0ul,n_elements(dblarr_dec)-1 do begin
      indarr = where(strarr_raveid_all eq strarr_raveid(i))
      if indarr(0) eq -1 then begin
        print,'rave_find_solar_siblings: could not find star(i=',i,') '+strarr_raveid(i)
        stop
      end

      str_line = strarr_ravedata(i,0) + ' ' + strarr_ravedata(i,1) + ' ' + strmid(strarr_ravedata(i,i_col_ra), 0, strpos(strarr_ravedata(i,i_col_ra),'.',/REVERSE_SEARCH)+4) + ' ' + strmid(strarr_ravedata(i,i_col_dec),0,strpos(strarr_ravedata(i,i_col_dec),'.',/REVERSE_SEARCH)+4) + ' ' + strmid(strarr_ravedata(i,i_col_lon),0,strpos(strarr_ravedata(i,i_col_lon),'.',/REVERSE_SEARCH)+4) + ' ' + strmid(strarr_ravedata(i,i_col_lat),0,strpos(strarr_ravedata(i,i_col_lat),'.',/REVERSE_SEARCH)+4)
;      for j=1,i_ncols-1 do begin
;        str_line = str_line + ' ' + strarr_ravedata(i,j)
        if dblarr_r_a(indarr(0)) lt dblarr_r_b(indarr(0)) then begin
          dbl_r = dblarr_r_a(indarr(0))
        end else begin
          dbl_r = dblarr_r_b(indarr(0))
        end
;      endfor

      indarr_rmag = where(dblarr_rmag_t_sn(*,0) le (dbl_r+0.25))
      dbl_t = dblarr_rmag_t_sn(indarr_rmag(n_elements(indarr_rmag)-1),1)
      dbl_sn = dblarr_rmag_t_sn(indarr_rmag(n_elements(indarr_rmag)-1),2)

      str_line = str_line + ' ' + strmid(string(dblarr_v(indarr(0))),0,strpos(string(dblarr_v(indarr(0))),'.',/REVERSE_SEARCH)+3)
      str_line = str_line + ' ' + strmid(string(dbl_r),0,strpos(string(dbl_r),'.')+3) + ' ' + strmid(string(dbl_t),0,strpos(string(dbl_t),'.')) + ' ' + strmid(string(dbl_sn),0,strpos(string(dbl_sn),'.'))
      b_print = 1
;      dbl_ra = double(strarr_ravedata(i,i_col_ra) * 24. / 700.)
;      if dbl_ra lt 14. then $
;        b_print = 1
      if dbl_t le 240. then begin
        i_priority = 1
      end else if dbl_t le 600 then begin
        i_priority = 2
      end else begin
        i_priority = 3
      end
      str_line = str_line + ' ' + string(i_priority)
;      if dbl_t le 600. and b_print then begin
        dbl_total_exptime = dbl_total_exptime + dbl_t + (15. * 60)
        printf,lun,str_line
        i_nstars = i_nstars + 1
        oplot,[dblarr_ra(i),dblarr_ra(i)],[dblarr_dec(i),dblarr_dec(i)],psym=2
;      end
    endfor
    print,'rave_find_solar_siblings: i_nstars = ',i_nstars
    print,'rave_find_solar_siblings: total exposure time = ',dbl_total_exptime,' s = ',dbl_total_exptime / 60.,' min = ',dbl_total_exptime / 3600.,' h'
  free_lun,lun
  device,/close
end
