pro rave_plot_I_vs_IDenis
  str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_no_doubles_maxsnr_230-315_-25-25_JmK_gt_0_5_samplex1.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NLines=i_nlines,I_NCols=i_ncols)

  dblarr_i = double(strarr_data(*,14))
  dblarr_idenis = double(strarr_data(*,50))
  dblarr_jdenis = double(strarr_data(*,52))
  dblarr_kdenis = double(strarr_data(*,54))
  dblarr_j2mass = double(strarr_data(*,59))
  dblarr_k2mass = double(strarr_data(*,63))
  ;print,'dblarr_k2mass = ',strarr_data(*,63)

  indarr_idenis = where(dblarr_idenis lt 99.,COMPLEMENT=indarr_idenis_bad)
  if (indarr_idenis(0) ge 0) then $
    print,'n_elements(indarr_idenis) = ',n_elements(indarr_idenis)
  if (indarr_idenis_bad(0) ge 0) then $
    print,'dblarr_idenis(indarr_idenis_bad) = ',dblarr_idenis(indarr_idenis_bad)

  indarr_jdenis = where(dblarr_jdenis lt 99.,COMPLEMENT=indarr_jdenis_bad)
  if (indarr_jdenis(0) ge 0) then $
    print,'n_elements(indarr_jdenis) = ',n_elements(indarr_jdenis)
  if (indarr_jdenis_bad(0) ge 0) then $
    print,'dblarr_jdenis(indarr_jdenis_bad) = ',dblarr_jdenis(indarr_jdenis_bad)

  indarr_j2mass_denis = where(dblarr_j2mass(indarr_jdenis) lt 99.,COMPLEMENT=indarr_2mass_bad)
  if (indarr_j2mass_denis(0) ge 0) then $
    print,'n_elements(indarr_j2mass_denis) = ',n_elements(indarr_j2mass_denis)
  if (indarr_2mass_bad(0) ge 0) then $
    print,'dblarr_jdenis(indarr_jdenis(indarr_2mass_bad)) = ',dblarr_j2mass(indarr_jdenis(indarr_2mass_bad))

  indarr_kdenis = where(dblarr_kdenis(indarr_jdenis) lt 99.,COMPLEMENT=indarr_kdenis_bad)
  if (indarr_kdenis(0) ge 0) then $
    print,'n_elements(indarr_kdenis) = ',n_elements(indarr_kdenis)
  if (indarr_kdenis_bad(0) ge 0) then $
    print,'dblarr_kdenis(indarr_jdenis(indarr_kdenis_bad)) = ',dblarr_kdenis(indarr_jdenis(indarr_kdenis_bad))

  indarr_k2mass_denis = where(dblarr_k2mass(indarr_jdenis(indarr_kdenis)) lt 99.,COMPLEMENT=indarr_2mass_bad)
  if (indarr_j2mass_denis(0) ge 0) then $
    print,'n_elements(indarr_k2mass_denis) = ',n_elements(indarr_k2mass_denis)
  if (indarr_2mass_bad(0) ge 0) then $
    print,'dblarr_jdenis(indarr_jdenis(indarr_kdenis(indarr_2mass_bad))) = ',dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_2mass_bad)))

  indarr_j2mass = where(dblarr_j2mass(indarr_jdenis(indarr_kdenis)) lt 99.,COMPLEMENT=indarr_j2mass_bad)
  if (indarr_j2mass(0) ge 0) then $
    print,'n_elements(indarr_j2mass) = ',n_elements(indarr_j2mass)
  if (indarr_j2mass_bad(0) ge 0) then $
    print,'dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass_bad))) = ',dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass_bad)))

  indarr_k2mass = where(dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass))) lt 99.,COMPLEMENT=indarr_k2mass_bad)
  if (indarr_k2mass(0) ge 0) then $
    print,'n_elements(indarr_k2mass) = ',n_elements(indarr_k2mass)
  if (indarr_k2mass_bad(0) ge 0) then $
    print,'dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass_bad)))) = ',dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass_bad))))

  set_plot,'ps'

  ; --- plot I vs I_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I_vs_IDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_i(indarr_idenis),dblarr_idenis(indarr_idenis),psym=2,symsize=0.2,xtitle='I_2MASS [mag]',ytitle='I_DENIS [mag]',yrange=[8.,14.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot I vs I-I_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I_vs_I-IDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_i(indarr_idenis),dblarr_i(indarr_idenis) - dblarr_idenis(indarr_idenis),psym=2,symsize=0.2,xtitle='I_2MASS [mag]',ytitle='I_2MASS - I_DENIS [mag]',yrange=[-3.5,3.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot J_2MASS vs J_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_J2MASS_vs_JDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_j2mass(indarr_jdenis(indarr_j2mass_denis)),dblarr_jdenis(indarr_jdenis(indarr_j2mass_denis)),psym=2,symsize=0.2,xtitle='J_2MASS [mag]',ytitle='J_DENIS [mag]';,yrange=[8.,14.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot J_2MASS vs J_2MASS - J_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_J2MASS_vs_J2MASS-JDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_j2mass(indarr_jdenis(indarr_j2mass_denis)),dblarr_j2mass(indarr_jdenis(indarr_j2mass_denis)) - dblarr_idenis(indarr_idenis),psym=2,symsize=0.2,xtitle='J_2MASS [mag]',ytitle='J_2MASS - J_DENIS [mag]';,yrange=[-3.5,3.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot K_2MASS vs K_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_K2MASS_vs_KDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_k2mass_denis))),dblarr_kdenis(indarr_jdenis(indarr_kdenis(indarr_k2mass_denis))),psym=2,symsize=0.2,xtitle='K_2MASS [mag]',ytitle='K_DENIS [mag]';,yrange=[8.,14.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot K_2MASS vs K_2MASS - K_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_K2MASS_vs_K2MASS-KDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_k2mass_denis))),dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass_denis))) - dblarr_idenis(indarr_jdenis(indarr_kdenis(indarr_k2mass_denis))),psym=2,symsize=0.2,xtitle='K_2MASS [mag]',ytitle='K_2MASS - K_DENIS [mag]';,yrange=[-3.5,3.],ystyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot J-K_2mass vs J-K_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_JmK2Mass_vs_JmKDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))) - dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))),dblarr_jdenis(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass))))-dblarr_kdenis(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))),psym=2,symsize=0.2,xtitle='J-K (2MASS) [mag]',ytitle='J-K (DENIS) [mag]',yrange=[-2.,4.],ystyle=1,xrange=[-0.5,2.5],xstyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  ; --- plot J-K_2mass vs J-K_2mass - J-K_Denis
  str_filename_plot = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_JmK2Mass_vs_JmK2Mass-JmKDenis.ps'
  device,filename = str_filename_plot
  plot,dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))) - dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))),(dblarr_j2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass)))) - dblarr_k2mass(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass))))) - (dblarr_jdenis(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass))))-dblarr_kdenis(indarr_jdenis(indarr_kdenis(indarr_j2mass(indarr_k2mass))))),psym=2,symsize=0.2,xtitle='J-K (2MASS) [mag]',ytitle='(J-K (RAVE)) - (J-K (DENIS)) [mag]',yrange=[-3.,3.],ystyle=1,xrange=[-0.5,2.],xstyle=1
  device,/close
  spawn,'epstopdf '+str_filename_plot
  spawn,'ps2gif '+str_filename_plot+' '+strmid(str_filename_plot,0,strpos(str_filename_plot,'.',/REVERSE_SEARCH))+'.gif'

  set_plot,'x'

end
