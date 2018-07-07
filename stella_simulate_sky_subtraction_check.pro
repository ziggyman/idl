pro stella_simulate_sky_subtraction_check
  str_filename_sf_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/cfits_sf_'
  str_filename_sp_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/cfits_sp_'
  str_filename_sp_fit_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_SPFit_MaxOnly_'
  str_filename_sky_fit_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_SkyFit_MaxOnly_'
  str_filename_sp_all_fit_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_SPFit_'
  str_filename_sky_all_fit_root = '/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_SkyFit_'

  set_plot,'ps'
  for j=0,3 do begin
    str_filename_act = str_filename_sp_all_fit_root+'Tel'+strtrim(string(j),2)
    if file_test(str_filename_act+'.dat') then begin
      dblarr_spfit = double(readfiletostrarr(str_filename_act+'.dat', ' '))
      device,filename=str_filename_act+'.ps'
        plot,dblarr_spfit,title=strmid(str_filename_act,strpos(str_filename_act,'/',/REVERSE_SEARCH)+1)
      device,/close
    endif
    for k=0,6 do begin
      str_suffix = 'IBin0_IRunTel'+strtrim(string(k),2)
      str_psfilename = str_filename_sf_root+str_suffix
      for l=0, 1 do begin
        if l eq 1 then begin
          str_suffix = str_suffix + '_MaxOnly'
        endif
        device,filename=str_filename_sf_root+str_suffix+'_Tel'+strtrim(string(j),2)+'_all.ps',/color
        loadct,13
        for i=1, 7 do begin
          str_filename_act = str_filename_sf_root+strtrim(string(i),2)+'_'+str_suffix+'_Tel'+strtrim(string(j),2)+'.dat'
          if file_test(str_filename_act) then begin
            dblarr_data = double(readfiletostrarr(str_filename_act,' '))
            indarr = lindgen(n_elements(dblarr_data))
            i_color = 1
            if i eq 1 then begin
              plot,indarr,$
                   dblarr_data,$
                   color=i_color,$
;                   yrange=[-0.1,0.4],$
;                   ystyle=1,$
                   title = 'sf_Tel'+strtrim(string(j),2)+str_suffix
              oplot,[20,40],$
                    [0.35,0.35],$
                    color=i_color
            end else begin
              i_color = i*long(250/8)
              print,'i=',i,': i_color = ',i_color
              oplot,indarr,$
                    dblarr_data,$
                    color=i_color
              oplot,[20,40],$
                    [0.35-(i-1)*0.15/8,0.35-(i-1)*0.15/8],$
                    color=i_color
            endelse
          endif else begin
            print,'File '+str_filename_act+' not found'
          endelse
        endfor
        device,/close

        device,filename=str_filename_sp_root+str_suffix+'_Tel'+strtrim(string(j),2)+'_all.ps',/color
        for i=1, 7 do begin
          str_filename_act = str_filename_sp_root+strtrim(string(i),2)+'_'+str_suffix+'_Tel'+strtrim(string(j),2)+'.dat'
          if file_test(str_filename_act) then begin
            dblarr_data = double(readfiletostrarr(str_filename_act,' '))
            indarr = lindgen(n_elements(dblarr_data))
            i_color = 1
            if i eq 1 then begin
              plot,indarr,$
                   dblarr_data,$
                   color=i_color,$
                   title = 'sp_Tel'+strtrim(string(j),2)+str_suffix
              oplot,[20,40],$
                    [0.35,0.35],$
                    color=i_color
            end else begin
              i_color = i*long(250/8)
              oplot,indarr,$
                    dblarr_data,$
                    color=i_color
              oplot,[20,40],$
                    [0.35-(i-1)*0.15/8,0.35-(i-1)*0.15/8],$
                    color=i_color
            endelse
          endif else begin
            print,'File '+str_filename_act+' not found'
          endelse
        endfor
        device,/close
      endfor
    endfor
  endfor
  for j=0,3 do begin
    if j eq 0 then begin
      str_filename_root = str_filename_sp_fit_root
      str_title='D_A1_SPFit_MaxOnly_'+strtrim(string(j),2)
      y_min = 0.
      y_max = 0.4
    end else if j eq 1 then begin
      str_filename_root = str_filename_sky_fit_root
      str_title='D_A1_SkyFit_MaxOnly_'+strtrim(string(j),2)
      y_min = 0.
      y_max = 0.05
    end else if j eq 2 then begin
      str_filename_root = str_filename_sp_all_fit_root
      str_title='D_A1_SPFit_'+strtrim(string(j),2)
      y_min = 0.
      y_max = 0.4
    end else begin
      str_filename_root = str_filename_sky_all_fit_root
      str_title='D_A1_SkyFit_'+strtrim(string(j),2)
      y_min = 0.
      y_max = 0.1
    endelse
    device,filename=str_filename_root+'all.ps',/color
    for i=0, 6 do begin
      str_filename_act = str_filename_root+strtrim(string(i),2)+'.dat'
      if file_test(str_filename_act) then begin
        dblarr_data = double(readfiletostrarr(str_filename_act,' '))
        indarr = lindgen(n_elements(dblarr_data))
        i_color = 1
        if i eq 0 then begin
          plot,indarr,$
               dblarr_data,$
               color=i_color,$
               title = str_title
          oplot,[20,40],$
                [y_max - (y_max-y_min)/10.,y_max - (y_max-y_min)/10.],$
                color=i_color
        end else begin
          i_color = (i+1)*long(250/8)
          oplot,indarr,$
                dblarr_data,$
                color=i_color
          oplot,[20,40],$
                [y_max-(y_max-y_min)/10. - (i)*0.15/8,y_max-(y_max-y_min)/10. -(i)*0.15/8],$
                color=i_color
        endelse
      endif else begin
        print,'File '+str_filename_act+' not found'
      endelse
    endfor
    device,/close
  endfor

  for i_tel=0,3 do begin
    for i_row=0, 199 do begin
;      str_filename_x='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_XInt_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

;      str_filename_y='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_TempArrA_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

;      str_filename_interp='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/p_D_A1_SF0_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

;      str_filename_interq='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/p_D_A1_SF1_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

;      str_filename_orig_x='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A2_SlitFuncOrig_x_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

;      str_filename_orig_im='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A2_SlitFuncOrig_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'

      str_filename_sf_end='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/SFVecArr_IBin0_IRunTel0_Tel'+strtrim(string(i_tel),2)+'.dat'

      str_filename_oarr='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/OArrBySF_row'+strtrim(string(i_row), 2)+'_IBin0_IRunTel0_Tel'+strtrim(string(i_tel),2)+'.dat'

      str_filename_prof='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_Prof_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row), 2)+'.dat'

      str_filename_im='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_Im_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row), 2)+'.dat'

      str_filename_skya='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_Sky_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row), 2)+'.dat'

      ; --- line: p_D_A1_SF0_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat' vs. index
      ; --- symbol 1: +: D_A2_SlitFuncOrig_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat' vs. D_A2_SlitFuncOrig_x_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'-3.5
      ; --- symbol 2: *: p_D_A1_SF0_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat' vs.  D_A1_XInt_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'
      ; --- symbol 3: .
      ; --- symbol 4: diamond: OArrBySF_row'+strtrim(string(i_row), 2)+'_IBin0_IRunTel0_Tel'+strtrim(string(i_tel),2)+'.dat' vs. index
      ; --- symbol 5: triangle: p_D_A1_SF1_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat' vs. D_A1_XInt_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.dat'
      ; --- symbol 6: square: SFVecArr_IBin0_IRunTel0_Tel'+strtrim(string(i_tel),2)+'.dat' vs. index

;      dblarr_x = double(readfiletostrarr(str_filename_x,' '))
;      print,'dblarr_x=',dblarr_x
;      dblarr_y = double(readfiletostrarr(str_filename_y,' '))
;      print,'dblarr_y=',dblarr_y
;      dblarr_interp = double(readfiletostrarr(str_filename_interp,' '))
;      print,'dblarr_interp=',dblarr_interp
;      dblarr_interq = double(readfiletostrarr(str_filename_interq,' '))
;      print,'dblarr_interq=',dblarr_interq
;      dblarr_orig_x = double(readfiletostrarr(str_filename_orig_x,' '))
;      print,'dblarr_orig_x=',dblarr_orig_x
;      dblarr_orig_im = double(readfiletostrarr(str_filename_orig_im,' '))
;      dblarr_orig_im -= min(dblarr_orig_im)
;      dblarr_orig_im = dblarr_orig_im / total(dblarr_orig_im)
;      print,'dblarr_orig_im=',dblarr_orig_im
      dblarr_sf_end = double(readfiletostrarr(str_filename_sf_end,' '))
      print,'dblarr_sf_end=',dblarr_sf_end
      dblarr_oarr = double(readfiletostrarr(str_filename_oarr,' '))
      print,'dblarr_oarr=',dblarr_oarr
      dblarr_prof = double(readfiletostrarr(str_filename_prof,' '))
      print,'dblarr_prof=',dblarr_prof
      dblarr_im = double(readfiletostrarr(str_filename_im,' '))
      print,'dblarr_im=',dblarr_im
      dblarr_sky = double(readfiletostrarr(str_filename_skya,' '))
      print,'dblarr_sky=',dblarr_sky
      dblarr_inm = dblarr_im - dblarr_sky(0)
      dblarr_inm = dblarr_inm / total(dblarr_inm)
      intarr_size = size(dblarr_im)
      print,'size(dblarr_im) = ',intarr_size
      dblarr_im = dblarr_im / total(dblarr_im)
      print,'dblarr_im = ',dblarr_im
      print,'dblarr_inm = ',dblarr_inm
      
;      if i_tel eq 1 then stop
      
      device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/SFVecArr_and_OArr_vs_index_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.ps',/color
;        plot,dblarr_y,$
;             xrange=[-2.,102.],$
;             xstyle=2,$
;             title='Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)
;        oplot,dblarr_x,dblarr_interp,psym=2
;        oplot,dblarr_x,dblarr_interq,psym=5
;        oplot,dblarr_orig_x,$;-3.5,
;              dblarr_orig_im,psym=1
;        loadct,13
        plot,dblarr_oarr,psym=4,$
             title='SFVecArr and OArr Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2);,color=100
        oplot,dblarr_sf_end,psym=6;,color=100
      device,/close

      ; --- line: D_A1_Prof_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row), 2)+'.dat' vs. index
      ; --- PSym=2: *: D_A1_Im_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row), 2)+'.dat' vs. index
      ; --- PSym=4: diamond: dblarr_im - dblarr_sky vs. index
      device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/D_A1_Prof_and_Im_vs_index_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2)+'.ps',/color
        plot,dblarr_prof,$
             title='Prof_and_Im_Tel'+strtrim(string(i_tel),2)+'_irow'+strtrim(string(i_row),2);,$
            ; xrange=[-2.,102.],$
            ; xstyle=2
        oplot,dblarr_im,psym=2
        oplot,dblarr_inm,psym=5
      device,/close
    endfor
  endfor
  set_plot,'x'
end
