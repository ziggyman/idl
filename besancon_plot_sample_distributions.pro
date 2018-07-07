pro besancon_plot_sample_distributions
  for iii=0,1 do begin
;    str_filename_root = '/home/azuri/daten/besancon/lon-lat/samples/9058stars_10000samplesX10percent_moments_325-340_-30--25'
    if iii eq 0 then begin
      str_filelist = '/home/azuri/daten/besancon/lon-lat/samples/all_samples.list'
    end else begin
      str_filelist = '/home/azuri/daten/besancon/lon-lat/samples/all_samples_minus.list'
;      str_filename_root = str_filename_root+'_minus'
    endelse
    str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1_325-340_-30--25.dat'

    strarr_filenames = readfiletostrarr(str_filelist,' ')
    strarr_filenames_root = strarr_filenames(*,0)
    for jjj=0, n_elements(strarr_filenames(*,0))-1 do begin
      strarr_filenames_root(jjj) = strmid(strarr_filenames(jjj,0),0,strpos(strarr_filenames(jjj,0),'.',/REVERSE_SEARCH))
    endfor
    for jjj=0,n_elements(strarr_filenames(*,0))-1 do begin
      strarr_data = readfiletostrarr(strarr_filenames_root(jjj,0) + '.dat',' ',I_NDATALINES=int_nsamples)
      int_nsamples = int_nsamples - 1
      print,'besancon_plot_sample_distributions: int_nsamples = ',int_nsamples

      dblarr_moments_all_stars = double(strarr_data(0,1:4))

      dblarr_moments = double(strarr_data(1:int_nsamples,1:4))

      indarr_x = (lindgen((int_nsamples / 5) - 1) * 5) + 5

      dblarr_moments_of_moments = dblarr(n_elements(indarr_x),4,4)
      for i=0ul, n_elements(indarr_x)-1 do begin
        for j = 0, 3 do begin
          strarr_temp = strtrim(string(dblarr_moments(0:indarr_x(i)-1,j)),2)
          indarr_good = where((strarr_temp ne '0.00000') and (strarr_temp ne 'NaN'))
          dblarr_moments_of_moments(i,j,*) = moment(dblarr_moments(indarr_good,j))
        endfor
      endfor
      strarr_temp = 0
      indarr_good = 0
      dblarr_moments_of_moments(*,*,1) = sqrt(dblarr_moments_of_moments(*,*,1))

      dblarr_xrange = [0.,10000.]
      dblarr_position = [0.21,0.153,0.94,0.99]

      if jjj eq 0 then begin
        dblarr_feh_all = readfiletodblarr(str_datafile)
        if iii eq 1 then $
          dblarr_feh_all = 0. - dblarr_feh_all
        dblarr_moments_feh = moment(dblarr_feh_all)
        dblarr_moments_feh(1) = sqrt(dblarr_moments_feh(1))
      endif
      if iii eq 0 then begin
        openw,lun,strarr_filenames_root(jjj)+'_index.html',/GET_LUN
        printf,lun,'<html><body><center>'
      endif
      dblarr_vertical_lines = [dblarr_moments_feh(0),dblarr_moments_feh(0)-dblarr_moments_feh(1),dblarr_moments_feh(0)+dblarr_moments_feh(1)]
      str_plotname_hist_root = strarr_filenames_root(jjj)+'_feh_all'
      ;if iii eq 1 then $
      ;  str_plotname_hist_root = str_plotname_hist_root+'_minus'
      dblarr_xrange_hist = [-2.,0.5]
      if iii eq 1 then $
        dblarr_xrange_hist = [-0.5,2.]
      i_print_moments = 2
      if iii eq 1 then begin
        i_print_moments = 4
      endif
      if jjj eq 0 then begin
        plot_two_histograms,dblarr_feh_all,$; --- RAVE
                            dblarr_feh_all,$; --- BESANCON
                            STR_PLOTNAME_ROOT=str_plotname_hist_root,$;     --- string
                            XTITLE='[Fe/H] [dex]',$;                           --- string
                            YTITLE='Percentage of stars',$;                           --- string
                            I_NBINS=0,$;                           --- int
                            NBINSMAX=30,$;                       --- int
                            NBINSMIN=40,$;                       --- int
                            ;TITLE=0,$;                             --- string
                            XRANGE=dblarr_xrange_hist,$;                           --- dblarr
                            ;YRANGE=yrange,$;                           --- dblarr
                            ;MAXNORM=maxnorm,$;                         --- bool (0/1)
                            ;TOTALNORM=totalnorm,$;                     --- bool (0/1)
                            PERCENTAGE=1,$;                   --- bool (0/1)
                            ;REJECTVALUEX=rejectvaluex,$;               --- double
                            ;B_POP_ID = b_pop_id,$;                     --- bool
                            ;DBLARR_STAR_TYPES=dblarr_star_types,$;     --- dblarr
                            PRINTPDF=1,$;                       --- bool (0/1)
                            ;DEBUGA=debuga,$;                           --- bool (0/1)
                            ;DEBUGB=debugb,$;                           --- bool (0/1)
                            ;DEBUG_OUTFILES_ROOT=debug_outfiles_root,$; --- string
                            COLOUR=0,$;                           --- bool (0/1)
                            ;B_RESIDUAL=b_residual,$;                 --- double
                            I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                            I_DBL_THICK = 3.,$;
                            ;I_INT_XTICKS = i_int_xticks,$
                            ;I_STR_XTICKFORMAT = i_str_xtickformat,$
                            I_DBL_CHARSIZE = 1.8,$
                            I_DBL_CHARTHICK = 3.,$
                            DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                            B_PRINT_MOMENTS               = i_print_moments; --- 0: do not print moments
                                                                          ; --- 1: print moments for both samples in upper left corner
                                                                          ; --- 2: print moments for first sample in upper left corner
                                                                          ; --- 3: print moments for both samples in upper right corner
      endif
      if iii eq 0 then begin
        str_temp = strmid(str_plotname_hist_root,strpos(str_plotname_hist_root,'/',/REVERSE_SEARCH)+1)
        str_temp_minus = strmid(str_temp,0,strpos(str_temp,'_feh',/REVERSE_SEARCH))
        str_temp_hist = strmid(str_temp,strpos(str_temp,'_feh',/REVERSE_SEARCH))
        printf,lun,str_temp+' '+str_temp_minus+'_minus'+str_temp_hist+'<br><a href="'+str_temp+'.gif"><img src="'+str_temp+'.gif"></a><a href="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"><img src="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"></a><br>'
      endif
      dblarr_feh = double(readfiletostrarr(strarr_filenames(jjj,1),' '))
      i_print_moments = 2
      if iii eq 1 then begin
        dblarr_feh = 0. - dblarr_feh
        i_print_moments = 4
      endif
      dblarr_moment_feh = moment(dblarr_feh)
      dblarr_vertical_lines_in_plot = [dblarr_moment_feh(0), dblarr_moment_feh(0)-sqrt(dblarr_moment_feh(1)), dblarr_moment_feh(0)+sqrt(dblarr_moment_feh(1))]
      str_plot_root = str_plotname_hist_root+'_parent'
      plot_two_histograms,dblarr_feh,$; --- RAVE
                            dblarr_feh,$; --- BESANCON
                            STR_PLOTNAME_ROOT=str_plot_root,$;     --- string
                            XTITLE='[Fe/H] [dex]',$;                           --- string
                            YTITLE='Percentage of stars',$;                           --- string
                            I_NBINS=0,$;                           --- int
                            NBINSMAX=30,$;                       --- int
                            NBINSMIN=40,$;                       --- int
                            ;TITLE=0,$;                             --- string
                            XRANGE=dblarr_xrange_hist,$;                           --- dblarr
                            ;YRANGE=yrange,$;                           --- dblarr
                            ;MAXNORM=maxnorm,$;                         --- bool (0/1)
                            ;TOTALNORM=totalnorm,$;                     --- bool (0/1)
                            PERCENTAGE=1,$;                   --- bool (0/1)
                            ;REJECTVALUEX=rejectvaluex,$;               --- double
                            ;B_POP_ID = b_pop_id,$;                     --- bool
                            ;DBLARR_STAR_TYPES=dblarr_star_types,$;     --- dblarr
                            PRINTPDF=1,$;                       --- bool (0/1)
                            ;DEBUGA=debuga,$;                           --- bool (0/1)
                            ;DEBUGB=debugb,$;                           --- bool (0/1)
                            ;DEBUG_OUTFILES_ROOT=debug_outfiles_root,$; --- string
                            COLOUR=0,$;                           --- bool (0/1)
                            ;B_RESIDUAL=b_residual,$;                 --- double
                            I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                            I_DBL_THICK = 3.,$;
                            ;I_INT_XTICKS = i_int_xticks,$
                            ;I_STR_XTICKFORMAT = i_str_xtickformat,$
                            I_DBL_CHARSIZE = 1.8,$
                            I_DBL_CHARTHICK = 3.,$
                            DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                            B_PRINT_MOMENTS               = i_print_moments; --- 0: do not print moments
                                                            ; --- 1: print moments for both samples in upper left corner
                                                            ; --- 2: print moments for first sample in upper left corner
                                                            ; --- 3: print moments for both samples in upper right corner
                                                            ; --- 4: print moments for first sample in upper right corner

      if iii eq 0 then begin
        str_temp = strmid(str_plot_root,strpos(str_plot_root,'/',/REVERSE_SEARCH)+1)
        str_temp_minus = strmid(str_temp,0,strpos(str_temp,'_feh',/REVERSE_SEARCH))
        str_temp_hist = strmid(str_temp,strpos(str_temp,'_feh',/REVERSE_SEARCH))
        printf,lun,str_temp+' '+str_temp_minus+'_minus'+str_temp_hist+'<br><a href="'+str_temp+'.gif"><img src="'+str_temp+'.gif"></a><a href="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"><img src="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"></a><br>'
      endif
      for i=0,3 do begin
        str_plotname_root_root = strarr_filenames_root(jjj)
        if i eq 0 then begin
          str_plotname_root_root = str_plotname_root_root + '_mean-of-'
          str_ytitle_root = '!4l!3'
        end else if i eq 1 then begin
          str_plotname_root_root = str_plotname_root_root + '_sigma-of-'
          str_ytitle_root = '!4r!3'
        end else if i eq 2 then begin
          str_plotname_root_root = str_plotname_root_root + '_skewness-of-'
          str_ytitle_root = 's'
        end else begin
          str_ytitle_root = 'k'
          str_plotname_root_root = str_plotname_root_root + '_kurtosis-of-'
        end
        for j=0,4 do begin
          str_plotname_root = str_plotname_root_root
          str_ytitle = str_ytitle_root
          dblarr_vertical_lines_in_plot = 0
          dblarr_horizontal_lines_in_plot = 0
          dblarr_xrange = [0.,10000.]
          if j eq 0 then begin
            str_plotname_root = str_plotname_root + 'means'
            str_ytitle = str_ytitle + '(!4l!3!Di!N)'
            dblarr_y_plot = dblarr_moments_of_moments(*,j,i)
            dblarr_yrange = [min(dblarr_y_plot),max(dblarr_y_plot)]
          end else if j eq 1 then begin
            str_plotname_root = str_plotname_root + 'sigmas'
            str_ytitle = str_ytitle + '(!4r!3!Di!N)';' / |!4l!3(!4l!3!di!N)|'
            dblarr_y_plot = dblarr_moments_of_moments(*,j,i); / abs(dblarr_moments_of_moments(*,0,0))
            dblarr_yrange = [min(dblarr_y_plot),max(dblarr_y_plot)]
          end else if j eq 2 then begin
            str_plotname_root = str_plotname_root + 'skewnesses'
            str_ytitle = str_ytitle + '(s!Di!N)'
            dblarr_y_plot = dblarr_moments_of_moments(*,j,i)
            dblarr_yrange = [min(dblarr_y_plot),max(dblarr_y_plot)]
          end else if j eq 3 then begin
            str_plotname_root = str_plotname_root + 'kurtosises'
            str_ytitle = str_ytitle + '(k!Di!N)'
            dblarr_y_plot = dblarr_moments_of_moments(*,j,i)
            dblarr_yrange = [min(dblarr_y_plot),max(dblarr_y_plot)]
          end else begin
            str_plotname_root = str_plotname_root_root+'_mean-of-'+str_ytitle_root
            if i lt 2 then begin
              str_plotname_root = str_plotname_root+'s'
            end else begin
              str_plotname_root = str_plotname_root+'es'
            end
            str_plotname_root = str_plotname_root+'-minus-mean-all_vs_n'
            if i eq 0 then begin
              str_ytitle = '!4l!3(!4l!3!Di!N) - !4l!3(all)'
            end else if i eq 1 then begin
              str_ytitle = '!4l!3(!4r!3!Di!N) - !4r!3(all)'
            end else if i eq 2 then begin
              str_ytitle = '!4l!3(s!Di!N) - s(all)'
            end else begin
              str_ytitle = '!4l!3(k!Di!N) - k(all)'
            end
            dblarr_y_plot = dblarr_moments_of_moments(*,i,0) - dblarr_moments_all_stars(i)

            dblarr_horizontal_lines_in_plot = [(-1. * dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,i,1)), (1. * dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,i,1))]
            print,'i = ',i,': dblarr_horizontal_lines_in_plot = ',dblarr_horizontal_lines_in_plot

            dblarr_xrange = [0.,1000.]
            dblarr_yrange = [(-3.1 * dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,i,1)), (3.1 * dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,i,1))]
            print,'i = ',i,': dblarr_yrange = ',dblarr_yrange
          end
          str_plotname_root = str_plotname_root + '_vs_nsamples'
          print,'besancon_plot_sample_distributions: str_plotname_root = ',str_plotname_root
          set_plot,'ps'
  ;        if iii eq 1 then $
  ;          str_plotname_root = str_plotname_root+'_minus'
          device,filename=str_plotname_root+'.ps'
            plot,double(indarr_x),$
                dblarr_y_plot,$
                xrange = dblarr_xrange,$
                xstyle = 1,$
                yrange = dblarr_yrange,$
                ystyle = 1,$
                xtitle = 'Number of samples',$
                ytitle = str_ytitle,$
                position = dblarr_position,$
                thick = 3.,$
                charthick = 3.,$
                charsize = 1.8,$
                xtickformat='(I5)'
    ;          if j eq 1 then begin
    ;            oplot,dblarr_xrange,$
    ;                  [dblarr_moments_all_stars(1),$; / abs(dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,1,0)),
    ;                   dblarr_moments_all_stars(1)],$; / abs(dblarr_moments_of_moments(n_elements(dblarr_moments_of_moments(*,0,0))-1,1,0))],$
    ;                  linestyle = 2
    ;          end else
              if j lt 4 then begin
                if i eq 0 then begin
                  oplot,dblarr_xrange,$
                        [dblarr_moments_all_stars(j),dblarr_moments_all_stars(j)],$
                        linestyle = 2
                endif
              end else begin
                for ii=0,n_elements(dblarr_horizontal_lines_in_plot)-1 do begin
                  oplot,dblarr_xrange,$
                        [dblarr_horizontal_lines_in_plot(ii),dblarr_horizontal_lines_in_plot(ii)],$
                        linestyle = 2
                endfor
                oplot,dblarr_xrange,$
                      [0.,0.],$
                      linestyle = 3
              endelse
    ;        endif

          device,/close
          set_plot,'x'
          spawn,'ps2gif '+str_plotname_root+'.ps '+str_plotname_root+'.gif'
          spawn,'epstopdf '+str_plotname_root+'.ps'
          if iii eq 0 then begin
            str_temp = strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)
            str_temp_minus = strmid(str_temp,0,strpos(str_temp,'--',/REVERSE_SEARCH)+4)
            str_temp_hist = strmid(str_temp,strpos(str_temp,'--',/REVERSE_SEARCH)+4)
            printf,lun,str_temp+' '+str_temp_minus+'_minus'+str_temp_hist+'<br><a href="'+str_temp+'.gif"><img src="'+str_temp+'.gif"></a><a href="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"><img src="'+str_temp_minus+'_minus'+str_temp_hist+'.gif"></a><br>'
          endif
        endfor
      endfor
      if iii eq 0 then $
        printf,lun,'</center></body></html>'
      free_lun,lun
    endfor
  endfor
end
