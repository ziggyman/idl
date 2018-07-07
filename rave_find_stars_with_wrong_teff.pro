pro rave_find_stars_with_wrong_teff
  str_ravedatafile = '/home/azuri/daten/rave/rave_data/release7/rave_internal_290110.dat'

  icol_raveid = 0
  icol_teff = 18
  icol_logg = 19
  icol_obsdate = 14
  icol_snr = 33

  strarr_ravedata = readfiletostrarr(str_ravedatafile,' ')

  strarr_raveid = strarr_ravedata(*,icol_raveid)
  strarr_obsdate = strarr_ravedata(*,icol_obsdate)
  dblarr_teff = double(strarr_ravedata(*,icol_teff))
  dblarr_logg = double(strarr_ravedata(*,icol_logg))
  dblarr_snr = double(strarr_ravedata(*,icol_snr))

  indarr_teff = where(dblarr_teff lt 3700.)
  indarr_logg = where(dblarr_logg(indarr_teff) gt 1. and dblarr_logg(indarr_teff) lt 4.2)

  str_outfile_root = strmid(str_ravedatafile,0,strpos(str_ravedatafile,'.',/REVERSE_SEARCH))+'_wrong_teff'
  openw,lun,str_outfile_root+'.dat',/GET_LUN
    printf,lun,'# rave_id teff logg obsdate S2N'
;    for i=0ul,n_elements(indarr_logg)-1 do begin
;      printf,lun,strtrim(strarr_raveid(indarr_teff(indarr_logg(i))),2)+' '+strtrim(string(dblarr_teff(indarr_teff(indarr_logg(i)))),2)+' '+strtrim(string(dblarr_logg(indarr_teff(indarr_logg(i)))),2)+' '+strtrim(strarr_obsdate(indarr_teff(indarr_logg(i))),2)+' '+strtrim(string(dblarr_snr(indarr_teff(indarr_logg(i)))),2)
;    endfor
    for i=0ul,n_elements(indarr_teff)-1 do begin
      printf,lun,strtrim(strarr_raveid(indarr_teff(i)),2)+' '+strtrim(string(dblarr_teff(indarr_teff(i))),2)+' '+strtrim(string(dblarr_logg(indarr_teff(i))),2)+' '+strtrim(strarr_obsdate(indarr_teff(i)),2)+' '+strtrim(string(dblarr_snr(indarr_teff(i))),2)
    endfor
  free_lun,lun

  set_plot,'ps'
  device,filename=str_outfile_root+'.ps'
;  plot,dblarr_teff(indarr_teff(indarr_logg)),dblarr_logg(indarr_teff(indarr_logg)),psym=2,symsize=0.1,yrange=[0.,5.],xtitle='T_eff [K]',ytitle='log g [dex]'
  plot,dblarr_teff(indarr_teff),dblarr_logg(indarr_teff),psym=2,symsize=0.1,xrange=[3550.,3700.],xstyle=1,yrange=[0.,5.],xtitle='T_eff [K]',ytitle='log g [dex]'

  device,filename=str_outfile_root+'_all_stars.ps'
  plot,dblarr_teff,dblarr_logg,psym=2,symsize=0.1,xrange=[0.,3700.],yrange=[0.,5.],xtitle='T_eff [K]',ytitle='log g [dex]'

  set_plot,'x'
  spawn,'ps2gif '+str_outfile_root+'.ps '+str_outfile_root+'.gif'
  spawn,'ps2gif '+str_outfile_root+'_all_stars.ps '+str_outfile_root+'_all_stars.gif'
end
