pro rave_stream_plot_vrad_vs_dist
  str_filename_stars = '/home/azuri/daten/rave/stream/red\ overdensity/mystars_all_l240-255_b5-15_+E\(B-V\)+E\(J\)+E\(K\).dat'
  str_filename_dist = '/home/azuri/daten/rave/rave_data/distances/all_20100819_SN20.rez'

  strarr_stars = readfiletostrarr(str_filename_stars,' ')
  strarr_dist = readfiletostrarr(str_filename_dist,' ')

  print,'strarr_stars(0,*) = ',strarr_stars(0,*)
  print,'strarr_dist(0,*) = ',strarr_dist(0,*)
  print,'size(strarr_stars) = ',size(strarr_stars)
  print,'size(strarr_dist) = ',size(strarr_dist)

  int_col_stars_id = 1
  int_col_dist_id = 0

  strarr_stars_id = strarr_stars(*,int_col_stars_id)
  strarr_dist_id = strarr_dist(*,int_col_dist_id)

  indarr_stars = ulonarr(1)
  indarr_dist = ulonarr(1)
  int_nfound = 0
  for i=0ul, n_elements(strarr_stars_id)-1 do begin
    indarr_dist_id = where(strarr_dist_id eq strarr_stars_id(i))
    print,'i = ',i,': indarr_dist_id = ',indarr_dist_id
    if indarr_dist_id(0) ne -1 then begin
      indarr_stars(int_nfound) = i
      indarr_dist(int_nfound) = indarr_dist_id(0)
      indarr_stars_temp = ulonarr(int_nfound+2)
      indarr_stars_temp(0:int_nfound) = indarr_stars
      indarr_dist_temp = ulonarr(int_nfound+2)
      indarr_dist_temp(0:int_nfound) = indarr_dist
      indarr_stars = indarr_stars_temp
      indarr_dist = indarr_dist_temp
      int_nfound = int_nfound+1
    endif
  endfor
  indarr_stars = indarr_stars(0:int_nfound-1)
  indarr_dist = indarr_dist(0:int_nfound-1)
  print,'indarr_stars = ',indarr_stars
  print,'indarr_dist = ',indarr_dist

  int_col_dist_vrad = 3
  int_col_dist_mh = 14
  int_col_dist_dist_pn = 16
  int_col_dist_dist_pnr = 18

  dblarr_dist_vrad = double(strarr_dist(indarr_dist,int_col_dist_vrad))
  dblarr_dist_mh = double(strarr_dist(indarr_dist,int_col_dist_mh))
  dblarr_dist_dist_pn = double(strarr_dist(indarr_dist,int_col_dist_dist_pn))
  dblarr_dist_dist_pnr = double(strarr_dist(indarr_dist,int_col_dist_dist_pnr))

  set_plot,'ps'
   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_dist_vs_vrad.ps',/color
    plot,dblarr_dist_vrad,$
         dblarr_dist_dist_pn,$
         xrange = [0.,max(dblarr_dist_vrad)+20.],$
         xstyle = 1,$
         psym=2,$
         xtitle='radial velocity [km/s]',$
         ytitle='distance [kpc]'
    loadct,13
    for i=0ul, n_elements(dblarr_dist_vrad)-1 do begin
      oplot,[dblarr_dist_vrad(i), dblarr_dist_vrad(i)],$
            [dblarr_dist_dist_pn(i), dblarr_dist_dist_pn(i)],$
            psym=2,$
            color = i*255/n_elements(dblarr_dist_vrad)

      oplot,[dblarr_dist_vrad(i), dblarr_dist_vrad(i)],$
            [dblarr_dist_dist_pnr(i), dblarr_dist_dist_pnr(i)],$
            psym=4,$
            color = i*255/n_elements(dblarr_dist_vrad)
   endfor
   device,/close
;   device,filename='/home/azuri/daten/rave/stream/red\ overdensity/mystars_mh_vs_vrad.ps'
;    plot,dblarr_dist_vrad,$
;         dblarr_dist_mh,$
;         xrange = [0.,max(dblarr_dist_vrad)+20.],$
;         xstyle = 1,$
;         psym=2,$
;         xtitle = 'radial velocity [km/s]',$
;         ytitle = 'metallicity [dex]'
;    for i=0ul, n_elements(dblarr_dist_vrad)-1 do begin
;      oplot,[dblarr_dist_vrad(i), dblarr_dist_vrad(i)],$
;            [dblarr_dist_mh(i), dblarr_dist_mh(i)],$
;            psym=2,$
;            color = i*255/n_elements(dblarr_dist_vrad)
;    endfor
;   device,/close
  set_plot,'x'
end
