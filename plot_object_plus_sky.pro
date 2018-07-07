pro plot_object_plus_sky

  str_dirname = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch6/figs/slit_fibre/'
  spawn,'mkdir '+str_dirname
  str_plotname_slit = str_dirname+'slit.ps'
  str_plotname_fibre = str_dirname+'fibre.ps'
  str_htmlfilename = str_dirname+'index.html'
  x = [-5., -4., -3., -2.,-1.,0.,1.,2.,3.,4.,5.]
  a_slit = 1.
  a_fibre = 1.
  sky = 0.2
  sigma = 1.
  mu = 0.

  gauss_slit = a_slit * exp(0. - ((x-mu)^2.)/(2. * (sigma^2.)))
  gauss_fibre = a_fibre * exp(0. - ((x-mu)^2.)/(2. * (sigma^2.)))
  sky_slit = replicate(sky,n_elements(x))
  sky_fibre = sky * exp(0. - ((x-mu)^2.)/(2. * (sigma^2.)))

  print,'gauss_slit = ',gauss_slit
  print,'gauss_fibre = ',gauss_fibre

  openw,lun,str_htmlfilename,/GET_LUN
  printf,lun,'<html><body>'

  set_plot,'ps'
  for j=0,7 do begin
    if j eq 0 then begin
      str_plotname = strmid(str_plotname_slit,0,strpos(str_plotname_slit,'.',/REVERSE_SEARCH))+'_nosky.ps'
      str_title = 'Spatial Profile Slit without Sky'
      str_ytitle = 'Flux [arbitrary units]'
      y_sky = replicate(0.,n_elements(x))
      y_object = gauss_slit
    end else if j eq 1 then begin
      str_plotname = strmid(str_plotname_fibre,0,strpos(str_plotname_fibre,'.',/REVERSE_SEARCH))+'_nosky.ps'
      str_title = 'Spatial Profile Fibre without Sky'
      str_ytitle = 'Integral-Normalised Flux [arbitrary units]'
      y_sky = replicate(0.,n_elements(x))
      y_object = gauss_fibre
    end else if j eq 2 then begin
      str_plotname = strmid(str_plotname_slit,0,strpos(str_plotname_slit,'.',/REVERSE_SEARCH))+'_nosky_norm.ps'
      str_title = 'Integral-Normalised Spatial Profile Slit without Sky'
      str_ytitle = 'Integral-Normalised Flux [arbitrary units]'
      y_sky = replicate(0.,n_elements(x))
      y_object = gauss_slit
    end else if j eq 3 then begin
      str_plotname = strmid(str_plotname_fibre,0,strpos(str_plotname_fibre,'.',/REVERSE_SEARCH))+'_nosky_norm.ps'
      str_title = 'Integral-Normalised Spatial Profile Fibre without Sky'
      str_ytitle = 'Integral-Normalised Flux [arbitrary units]'
      y_sky = replicate(0.,n_elements(x))
      y_object = gauss_fibre
    end else if j eq 4 then begin
      str_plotname = str_plotname_slit
      str_title = 'Spatial Profile Slit with Sky'
      str_ytitle = 'Flux [arbitrary units]'
      y_sky = sky_slit
      y_object = gauss_slit
    end else if j eq 5 then begin
      str_plotname = str_plotname_fibre
      str_title = 'Spatial Profile Fibre with Sky'
      str_ytitle = 'Flux [arbitrary units]'
      y_sky = sky_fibre
      y_object = gauss_fibre
    end else if j eq 6 then begin
      str_plotname = strmid(str_plotname_slit,0,strpos(str_plotname_slit,'.',/REVERSE_SEARCH))+'_norm.ps'
      str_title = 'Integral-Normalised Spatial Profile Slit with Sky'
      str_ytitle = 'Integral-Normalised Flux [arbitrary units]'
      y_sky = sky_slit
      y_object = gauss_slit
    end else if j eq 7 then begin
      str_plotname = strmid(str_plotname_fibre,0,strpos(str_plotname_fibre,'.',/REVERSE_SEARCH))+'_norm.ps'
      str_title = 'Integral-Normalised Spatial Profile Fibre with Sky'
      str_ytitle = 'Integral-Normalised Flux [arbitrary units]'
      y_sky = sky_fibre
      y_object = gauss_fibre
    end
    str_gifplotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH))+'.gif'
    printf,lun,'<img src="'+str_gifplotname+'" width=45%>'
    if (j eq 1) or (j eq 3) or (j eq 5) or (j eq 7) then $
      printf,lun,'<br><hr>'

    device,filename=str_plotname,/color
    loadct,0
    if (j eq 2) or (j eq 3) or (j eq 6) or (j eq 7) then begin
      sum = total(y_sky + y_object)
      y_sky = y_sky / sum
      y_object = y_object / sum
    endif
    plot,x,$
         replicate(0.,n_elements(x)),$
         xrange=[min(x)-0.5, max(x)+0.5],$
         xstyle=1,$
         yrange=[0., max(y_sky + y_object) + max(y_sky + y_object)/15.],$
         ystyle=1,$
         xtitle='Relative Pixel Number',$
         ytitle=str_ytitle,$
         title=str_title,$
         charsize=1.28,$
         charthick=3.,$
         thick=3.

; --- legend
    oplot,[x(0),$
           x(0)],$
          [max(y_sky + y_object) - (max(y_sky + y_object))/15.,$
           max(y_sky + y_object) - (max(y_sky + y_object))/5.]
    oplot,[x(3),$
           x(3)],$
          [max(y_sky + y_object) - (max(y_sky + y_object))/15.,$
           max(y_sky + y_object) - (max(y_sky + y_object))/5.]
    oplot,[x(0),$
           x(3)],$
          [max(y_sky + y_object) - (max(y_sky + y_object))/15.,$
           max(y_sky + y_object) - (max(y_sky + y_object))/15.]
    oplot,[x(0),$
           x(3)],$
          [max(y_sky + y_object) - (max(y_sky + y_object))/5.,$
           max(y_sky + y_object) - (max(y_sky + y_object))/5.]

; --- histograms
    loadct,13
    for i=0,n_elements(x)-1 do begin
; --- object
      box,x(i)-0.5,y_sky(i),x(i)+0.5,y_sky(i)+y_object(i),50
; --- sky
      box,x(i)-0.5,0.,x(i)+0.5,y_sky(i),125
    endfor

; --- legend
; --- sky
    box,x(0)+0.1,$
        max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50.,$
        x(0)+0.5,$
        max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50. + (max(y_sky + y_object))/25.,$
        125

; --- object
    box,x(0)+0.1,$
        max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50. + (max(y_sky + y_object))/25. + (max(y_sky + y_object))/50.,$
        x(0)+0.5,$
        max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50. + (max(y_sky + y_object))/25. + (max(y_sky + y_object))/50. + max(y_sky + y_object)/25.,$
        50
    xyouts,x(0)+0.7,$
           max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50.,$
           'Sky',$
           charsize=1.2,$
           charthick=3.
    xyouts,x(0)+0.7,$
           max(y_sky + y_object) - (max(y_sky + y_object))/5. + max(y_sky + y_object)/50. + (max(y_sky + y_object))/25. + (max(y_sky + y_object))/50.,$
           'Point Source',$
           charsize=1.2,$
           charthick=3.
    device,/close
    spawn,'epstopdf '+str_plotname
    spawn,'ps2gif '+str_plotname+' '+str_gifplotname
  endfor
  printf,lun,'</body></html>'
  free_lun,lun
  set_plot,'x'
end
