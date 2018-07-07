meansigbes ...  = dblarr(i_nfields*2,2):
      meansigbes(i_plot*2,0)=meanx
      meansigbes(i_plot*2,1)=sigmax
      meansigbes(i_plot*2+1,0)=meany
      meansigbes(i_plot*2+1,1)=sigmay

meansigbes_samples ...

meansigfiles ... = strarr(i_nfields)
      meansigfiles(i_plot) = str_path + html_path + "/mean_sigma_x_y.dat"

meansigfiles_samples ...
      openw,lunm,meansigfiles_samples(i_plot),/GET_LUN
        printf,lunm,'#Besancon samples'
        printf,lunm,'#mean_x sigma_x mean_y sigma_y'
        printf,lunm,strtrim(string(meansigbes_samples(i_plot*2,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2,1)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2+1,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2+1,1)),2)
      free_lun,lunm

calcsamples ... boolean, "Calculate random samples of Besancon data?"

i_nsamples ... if 'calcsamples' == 1: "number of random samples"

meansigmasamples (rave_plot_two_cols)...
    if i_nravestars gt 0 and i_nravestars lt n_elements(dblarr_vrad) then begin
      meansigmasamples = dblarr(I_NSAMPLES,4)
      for i=0, i_nsamples-1 do begin
        meansigmasamples(i,0) = meanx_plot
        meansigmasamples(i,1) = meany_plot
        meansigmasamples(i,2) = sigmax_plot
        meansigmasamples(i,3) = sigmay_plot
      endfor
    endif


  openw,luni,str_path+'index.html',/GET_LUN
    for i=0,i_nfields-1 do begin
      if problem_rave eq 1 then begin
        meanx = 0.
        sigmax = 0.
        meany = 0.
        sigmay = 0.

        meanx_samples = 0.
        sigmax_samples = 0.
        meany_samples = 0.
        sigmay_samples = 0.
      endif
      i_plot = i_plot + 1
      i_nplots = i_nplots + 1

; --- write means and sigmas to dblarr meansigbes
      meansigbes(i_plot*2,0)=meanx
      meansigbes(i_plot*2,1)=sigmax
      meansigbes(i_plot*2+1,0)=meany
      meansigbes(i_plot*2+1,1)=sigmay

; --- write means and sigmas to dblarr meansigbes_samples
      meansigbes_samples(i_plot*2,)=meansigmasamples()


      if (abs(yminbak-oldymin) gt 0.0001) or (abs(ymaxbak-oldymax) gt 0.0001) then   begin
        if abs(yminbak-oldymin) gt 0.0001 then begin
          print,'besancon_rave_plot_two_cols: WWWAAARRRNNNIIINNNGGG: yminbak(=',yminbak,') != oldymin(=',oldymin,')'
        end
        if abs(ymaxbak-oldymax) gt 0.0001 then begin
          print,'besancon_rave_plot_two_cols: WWWAAARRRNNNIIINNNGGG: ymaxbak(=',ymaxbak,') != oldymax(=',oldymax,')'
        end
        if (not keyword_set(FORCEYRANGE)) then begin
; --- plot RAVE data again mit new x and y ranges

          if problem_rave eq 1 then begin
            if problem_bes eq 0 then begin
              meanx = meansigbes(2*i_plot,0)
              meanx_samples = meansigbes_samples(2*i_plot,0)
              sigmax = 0.
              meany = meansigbes(2*i_plot+1,0)
              meany_samples = meansigbes_samples(2*i_plot+1,0)
              sigmay = 0.
            end else begin
              meanx = 0.
              sigmax = 0.
              meany = 0.
              sigmay = 0.
            end
          endif

; --- write means and sigmas to meansigrave
          meansigrave(i_plot*2+0,0)=meanx
          meansigrave(i_plot*2+0,1)=sigmax
          meansigrave(i_plot*2+1,0)=meany
          meansigrave(i_plot*2+1,1)=sigmay
        end
      end
; --- write meansigfiles
      meansigfiles(i_plot) = str_path + html_path + "/mean_sigma_x_y.dat"
;      meansigfiles_samples(i_plot) = str_path + html_path + "/mean_sigma_x_y_samples.dat"

;      print,'besancon_rave_plot_two_cols: meansigfiles(',i_plot,') = '+meansigfiles(i_plot)
      openw,lunm,meansigfiles(i_plot),/GET_LUN
        printf,lunm,'#data mean_x sigma_x mean_y sigma_y'
        printf,lunm,'RAVE '+$
                     strtrim(string(meansigrave(i_plot*2,0)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_plot*2,1)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_plot*2+1,0)),2)+$
                     ' '+$
                     strtrim(string(meansigrave(i_plot*2+1,1)),2)
        printf,lunm,'BESANCON '+$
                    strtrim(string(meansigbes(i_plot*2,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_plot*2,1)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_plot*2+1,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes(i_plot*2+1,1)),2)
      free_lun,lunm

; meansigfiles_samples
      openw,lunm,meansigfiles_samples(i_plot),/GET_LUN
        printf,lunm,'#Besancon samples'
        printf,lunm,'#mean_x sigma_x mean_y sigma_y'
        printf,lunm,strtrim(string(meansigbes_samples(i_plot*2,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2,1)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2+1,0)),2)+$
                    ' '+$
                    strtrim(string(meansigbes_samples(i_plot*2+1,1)),2)
      free_lun,lunm

; --- plot mean_sigma_x_y
      str_plotname = str_path + html_path + "/mean_sigma_x_y.ps"
      str_gifplotname = str_path + html_path + "/mean_sigma_x_y.gif"
      set_plot,'ps'
      device,filename=str_plotname,/color
      red = intarr(256)
      green = intarr(256)
      blue = intarr(256)
      for l=0ul, 255 do begin
        if l le 127 then begin
          red(l) = 60 - (2*l)
          green(l) = 2 * l
          blue(l) = 255 - (2 * l)
        end else begin
          blue(l) = 0
          green(l) = 255 - (2 * (l-127))
          red(l) = 2 * (l-127)
        end
        if red(l) lt 0 then red(l) = 0
        if red(l) gt 255 then red(l) = 255
        if green(l) lt 0 then green(l) = 0
        if green(l) gt 255 then green(l) = 255
        if blue(l) lt 0 then blue(l) = 0
        if blue(l) gt 255 then blue(l) = 255
      endfor
      ltab = 0
      modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'
      plot,[meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1)],$
           [meansigrave(i_plot*2+1,0),meansigrave(i_plot*2+1,0)],$
           xtitle=xtitle,$
           ytitle=ytitle,$
           xrange=[min([meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigbes(i_plot*2+0,0)-meansigbes(i_plot*2+0,1)])-meansigbes(i_plot*2+0,1),max([meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1),meansigbes(i_plot*2,0)+meansigbes(i_plot*2,1)])+meansigbes(i_plot*2+0,1)],$
           yrange=[min([meansigrave(i_plot*2+1,0)-meansigrave(i_plot*2+1,1),meansigbes(i_plot*2+1,0)-meansigbes(i_plot*2+1,1)])-meansigbes(i_plot*2+1,1),max([meansigrave(i_plot*2+1,0)+meansigrave(i_plot*2+1,1),meansigbes(i_plot*2+1,0)+meansigbes(i_plot*2+1,1)])+meansigbes(i_plot*2+1,1)],$
           linestyle=0,$
           thick=3
      loadct,ltab,FILE='colors1.tbl'
      if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) and n_elements(MEANSIGMASAMPLES) gt 1 then begin
        for m=0,i_nsamples-1 do begin
          oplot,[meansigmasamples(m,0)-meansigmasamples(m,2),meansigmasamples(m,0)+meansigmasamples(m,2)],[meansigmasamples(m,1),meansigmasamples(m,1)],linestyle=2,thick=3,color=254
          oplot,[meansigmasamples(m,0),meansigmasamples(m,0)],[meansigmasamples(m,1)-meansigmasamples(m,3),meansigmasamples(m,1)+meansigmasamples(m,3)],linestyle=2,thick=3,color=254
        endfor
      endif
      oplot,[meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1)],[meansigrave(i_plot*2+1,0),meansigrave(i_plot*2+1,0)],linestyle=0,thick=6,color=1
      oplot,[meansigrave(i_plot*2,0),meansigrave(i_plot*2,0)],[meansigrave(i_plot*2+1,0)-meansigrave(i_plot*2+1,1),meansigrave(i_plot*2+1,0)+meansigrave(i_plot*2+1,1)],linestyle=0,thick=6,color=1
      oplot,[meansigbes(i_plot*2,0)-meansigbes(i_plot*2,1),meansigbes(i_plot*2,0)+meansigbes(i_plot*2,1)],[meansigbes(i_plot*2+1,0),meansigbes(i_plot*2+1,0)],linestyle=0,thick=6,color=150
      oplot,[meansigbes(i_plot*2,0),meansigbes(i_plot*2,0)],[meansigbes(i_plot*2+1,0)-meansigbes(i_plot*2+1,1),meansigbes(i_plot*2+1,0)+meansigbes(i_plot*2+1,1)],linestyle=0,thick=6,color=150

      device,/close
      set_plot,'x'
      print,'Converting '+str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
      spawn,'rm '+str_plotname

    endfor
    meansigfiles = meansigfiles(0:i_nplots-1,*)
    meansigfiles_samples = meansigfiles_samples(0:i_nplots-1,*)
    if not keyword_set(LONLAT) then begin
    end else begin
; --- plot mean fields in Lon and Lat
      str_plotname = str_path + "meanfields_lon_lat.ps"
      str_gifplotname = str_path + "meanfields_lon_lat.gif"
      rave_plot_fields_mean,dblarr_ra_dec,$
                            meansigfiles,$
                            str_plotname,$
                            DATAARR=strarr_rave_data,$
                            RADEC=0
      print,'Converting '+ str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
      spawn,'rm '+str_plotname

; --- plot mean fields comparing to the random samples in Lon and Lat
      str_plotname = str_path + "meanfields_lon_lat_samples.ps"
      str_gifplotname = str_path + "meanfields_lon_lat_samples.gif"
      rave_plot_fields_mean,dblarr_ra_dec,$
                            meansigfiles_samples,$
                            str_plotname,$
                            DATAARR=strarr_rave_data,$
                            RADEC=0
      print,'Converting '+ str_plotname
      spawn,'ps2gif '+str_plotname+' '+str_gifplotname
      spawn,'rm '+str_plotname
    end
  free_lun,luni
