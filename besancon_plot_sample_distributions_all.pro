pro besancon_plot_sample_distributions_all
  int_n_samples = 10000;30

  for iii=0,1 do begin
    if iii eq 0 then $
      b_plot_stars = 0 $
    else $
      b_plot_stars = 1

    for ii = 0,1 do begin
      str_filename_list = '/home/azuri/daten/besancon/lon-lat/samples/all_samples'
      if int_n_samples ne 10000 then $
        str_filename_list = str_filename_list + '_30'
      if ii ne 0 then begin
        str_filename_list = str_filename_list + '_minus'
      endif
      str_filename_list = str_filename_list + '.list'
      strarr_filenames = readfiletostrarr(str_filename_list,' ')

      intarr_n_stars = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000]
      intarr_percentages = [1, 2, 5, 10, 20, 30, 50]
      dblarr_data = dblarr(28, 7, int_n_samples, 4); --- 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 9058 stars
                                    ; --- 1, 2, 5, 10, 20, 30, 50 %
                                    ; --- 4 moments
      dblarr_moments = dblarr(28, 7, int_n_samples, 4)
      intarr_n_samples_needed_1_sigma = ulonarr(28, 7, 4)
      intarr_n_samples_needed_3_sigma = ulonarr(28, 7, 4)
      dblarr_moments_end = dblarr(28, 7, 4, 4)
      dblarr_moments_parent = dblarr(28, 7, 4)
      for i=0ul, n_elements(strarr_filenames(*,0))-1 do begin
        strarr_data = readfiletostrarr(strarr_filenames(i,0),' ')
        if i eq 0 then begin
          dblarr_all_stars = strarr_data(0,1:4)
        end
        str_temp = strmid(strarr_filenames(i,0),strpos(strarr_filenames(i,0),'/',/REVERSE_SEARCH)+1)
        int_n_stars = long(strmid(str_temp,0,strpos(str_temp,'stars_')))
        print,'besancon_plot_sample_distributions_all: i=',i,': int_n_stars = ',int_n_stars

        str_temp = strmid(str_temp,strpos(str_temp,'X',/REVERSE_SEARCH)+1)
        int_percent = long(strmid(str_temp,0,strpos(str_temp,'percent')))
        print,'besancon_plot_sample_distributions_all: i=',i,': int_percent = ',int_percent

        if int_n_stars eq 10 then begin
          int_row = 0
        end else if int_n_stars eq 20 then begin
          int_row = 1
        end else if int_n_stars eq 30 then begin
          int_row = 2
        end else if int_n_stars eq 40 then begin
          int_row = 3
        end else if int_n_stars eq 50 then begin
          int_row = 4
        end else if int_n_stars eq 60 then begin
          int_row = 5
        end else if int_n_stars eq 70 then begin
          int_row = 6
        end else if int_n_stars eq 80 then begin
          int_row = 7
        end else if int_n_stars eq 90 then begin
          int_row = 8
        end else if int_n_stars eq 100 then begin
          int_row = 9
        end else if int_n_stars eq 200 then begin
          int_row = 10
        end else if int_n_stars eq 300 then begin
          int_row = 11
        end else if int_n_stars eq 400 then begin
          int_row = 12
        end else if int_n_stars eq 500 then begin
          int_row = 13
        end else if int_n_stars eq 600 then begin
          int_row = 14
        end else if int_n_stars eq 700 then begin
          int_row = 15
        end else if int_n_stars eq 800 then begin
          int_row = 16
        end else if int_n_stars eq 900 then begin
          int_row = 17
        end else if int_n_stars eq 1000 then begin
          int_row = 18
        end else if int_n_stars eq 2000 then begin
          int_row = 19
        end else if int_n_stars eq 3000 then begin
          int_row = 20
        end else if int_n_stars eq 4000 then begin
          int_row = 21
        end else if int_n_stars eq 5000 then begin
          int_row = 22
        end else if int_n_stars eq 6000 then begin
          int_row = 23
        end else if int_n_stars eq 7000 then begin
          int_row = 24
        end else if int_n_stars eq 8000 then begin
          int_row = 25
        end else if int_n_stars eq 9000 then begin
          int_row = 26
        end else begin
          int_row = 27
        end
        print,'besancon_plot_sample_distributions_all: i=',i,': int_row = ',int_row

        if int_percent eq 1 then begin
          int_col = 0
        end else if int_percent eq 2 then begin
          int_col = 1
        end else if int_percent eq 5 then begin
          int_col = 2
        end else if int_percent eq 10 then begin
          int_col = 3
        end else if int_percent eq 20 then begin
          int_col = 4
        end else if int_percent eq 30 then begin
          int_col = 5
        end else begin
          int_col = 6
        end
        print,'besancon_plot_sample_distributions_all: i=',i,': int_col = ',int_col

        ; --- populate data array
        dblarr_data(int_row, int_col, *, *) = double(strarr_data(1:n_elements(strarr_data(*,0))-1,1:4))
        dblarr_moments_parent(int_row, int_col, *) = double(strarr_data(0,1:4))
        print,'besancon_plot_sample_distributions_all: i=',i,': dblarr_data(int_row, int_col, 0, *) = ',dblarr_data(int_row, int_col, 0, *)
        for j=0,3 do begin
          dblarr_moment_all_samples = moment(dblarr_data(int_row, int_col, *, j))
          dblarr_moment_all_samples(1) = sqrt(dblarr_moment_all_samples(1))
          dblarr_moments_end(int_row, int_col, j, *) = dblarr_moment_all_samples

          print,'besancon_plot_sample_distributions_all: i=',i,': j=',j,': dblarr_moment_all_samples = ',dblarr_moment_all_samples
          int_n_samples_needed_1_sigma = 0
          int_n_samples_needed_3_sigma = 0
          for k=1,n_elements(dblarr_data(0,0,*,0))-1 do begin
            dblarr_moment = moment(dblarr_data(int_row, int_col, 0:k, j))
            dblarr_moment(1) = sqrt(dblarr_moment(1))
            if (abs(dblarr_moment(0)) ge 0.0000000001) and (abs(dblarr_moment(1)) ge 0.0000000001) then begin
              ;print,'besancon_plot_sample_distributions_all: i=',i,': j=',j,': k=',k,': dblarr_moment = ',dblarr_moment
              dblarr_moments(int_row, int_col, k, j) = (dblarr_moment(0) - dblarr_moment_all_samples(0)) / dblarr_moment_all_samples(1)
              ;print,'besancon_plot_sample_distributions_all: i=',i,': j=',j,': dblarr_moments(int_row=',int_row,', int_col=',int_col,',k=',k,', j=',j,') = ',dblarr_moments(int_row, int_col, k, j)
              if dblarr_moments(int_row, int_col, k, j) lt 3. then begin
                if int_n_samples_needed_3_sigma eq 0 then $
                  int_n_samples_needed_3_sigma = k
              end else begin
                int_n_samples_needed_3_sigma = 0
              end
              if dblarr_moments(int_row, int_col, k, j) lt 1. then begin
                if int_n_samples_needed_1_sigma eq 0 then $
                  int_n_samples_needed_1_sigma = k
              end else begin
                int_n_samples_needed_1_sigma = 0
              end
            endif
          endfor
          intarr_n_samples_needed_1_sigma(int_row, int_col, j) = int_n_samples_needed_1_sigma
          print,'besancon_plot_sample_distributions_all: i=',i,': j=',j,': int_n_samples_needed_1_sigma = ',int_n_samples_needed_1_sigma

          intarr_n_samples_needed_3_sigma(int_row, int_col, j) = int_n_samples_needed_3_sigma
          print,'besancon_plot_sample_distributions_all: i=',i,': j=',j,': int_n_samples_needed_3_sigma = ',int_n_samples_needed_3_sigma
        endfor
      endfor
      set_plot,'ps'
      for i=0,1 do begin
        for j=0,n_elements(intarr_percentages)-1 do begin
          for k=0,3 do begin
            str_plotname_root = strmid(str_filename_list,0,strpos(str_filename_list,'.',/REVERSE_SEARCH))
            str_plotname_root = str_plotname_root + '_' + strtrim(string(intarr_percentages(j)),2)
            str_plotname_root = str_plotname_root + '_' + strtrim(string(int_n_samples),2)+'samples'

            if k eq 0 then begin
              str_plotname_root = str_plotname_root + '_mean'
            end else if k eq 0 then begin
              str_plotname_root = str_plotname_root + '_sigma'
            end else if k eq 0 then begin
              str_plotname_root = str_plotname_root + '_skewness'
            end else begin
              str_plotname_root = str_plotname_root + '_kurtosis'
            endelse

            if i eq 0 then begin
              str_plotname_root = str_plotname_root + '_1sigma'
              intarr_plot = intarr_n_samples_needed_1_sigma(*,j,k)
            end else begin
              str_plotname_root = str_plotname_root + '_3sigma'
              intarr_plot = intarr_n_samples_needed_3_sigma(*,j,k)
            end

            device, filename=str_plotname_root+'.ps'
            plot,intarr_n_stars,$
                intarr_plot,$
                xtitle = 'Number of stars in swath',$
                ytitle = 'Number of samples',$
                charsize = 1.8,$
                charthick = 3.,$
                thick = 3.
            device,/close
          endfor
        endfor
      endfor

      for k=0,3 do begin
        for kk = 0,1 do begin
          str_plotname_root = strmid(str_filename_list,0,strpos(str_filename_list,'.',/REVERSE_SEARCH))+'_'
          if kk eq 1 then $
            str_plotname_root = str_plotname_root + 'mean-of-'
          if k eq 0 then begin
            str_plotname_root = str_plotname_root + 'mean'
          end else if k eq 1 then begin
            str_plotname_root = str_plotname_root + 'sigma'
          end else if k eq 2 then begin
            str_plotname_root = str_plotname_root + 'skewness'
          end else begin
            str_plotname_root = str_plotname_root + 'kurtosis'
          endelse
          if kk eq 1 then $
            str_plotname_root = str_plotname_root + '-minus-parent'
          if b_plot_stars then $
            str_plotname_root = str_plotname_root + '_with-stars'
          device, filename = str_plotname_root + '.ps',/color
          loadct,0
          intarr_xrange = [0.5,n_elements(dblarr_data(*,0,0,0))+0.5]
          intarr_yrange = [0.5,n_elements(dblarr_data(0,*,0,0))+0.5]
          dblarr_position = [0.12, 0.15, 0.875, 0.995]
          dblarr_xtickv = [1.,5.,10.,14.,19.,23.,27.]
          dblarr_ytickv = [1.,2.,3.,4.,5.,6.,7.]
          plot,[20.,20.],$
              [5.,5.],$
              xtitle = 'Number of stars in swath',$
              ytitle = 'Sample size in %',$
              xrange = intarr_xrange,$
              xstyle = 1,$
              yrange = intarr_yrange,$
              ystyle = 1,$
              psym=2,$
              symsize=0.05,$
              charsize = 1.8,$
              charthick = 3.,$
              thick = 3.,$
              position = dblarr_position,$
              xticks = n_elements(dblarr_xtickv)-1,$
              xtickv = dblarr_xtickv,$
              yticks = n_elements(dblarr_ytickv)-1,$;2 * (n_elements(intarr_percentages)-1),$
              ytickv = dblarr_ytickv,$;intarr_percentages;,$
              ytickname = [strtrim(string(intarr_percentages(0)),2), strtrim(string(intarr_percentages(1)),2), strtrim(string(intarr_percentages(2)),2), strtrim(string(intarr_percentages(3)),2), strtrim(string(intarr_percentages(4)),2), strtrim(string(intarr_percentages(5)),2), strtrim(string(intarr_percentages(6)),2)],$
              xtickname = ['10', '50', '100', '500', '1000', '5000', '9000']

          ; --- modify colour table
          red = intarr(256)
          green = intarr(256)
          blue = intarr(256)
          if kk eq 0 then begin
            for l=0ul, 255 do begin
              blue(l) = 0
              green(l) = 255 - l
              red(l) = l
              if red(l) lt 0 then red(l) = 0
              if red(l) gt 255 then red(l) = 255
              if green(l) lt 0 then green(l) = 0
              if green(l) gt 255 then green(l) = 255
              if blue(l) lt 0 then blue(l) = 0
              if blue(l) gt 255 then blue(l) = 255
            endfor
            green(0) = 0
            red(0) = 0
            blue(0) = 0
            ltab = 0
            modifyct,ltab,'green-red',red,green,blue,file='colors1_samples.tbl'
          end else begin
            rave_get_colour_table,B_POP_ID    = 2,$; --- 0: for histograms with star type for colour code
                                                          ; --- 1: for histograms with population ID for colour code
                                                          ; --- 2: for summary plots
                                  RED         = red,$
                                  GREEN       = green,$
                                  BLUE        = blue;,$
  ;                          DBL_N_TYPES = dbl_n_types
            ltab = 0
            modifyct,ltab,'blue-green-yellow',red,green,blue,file='colors1_samples.tbl'
          end
          loadct,ltab,FILE='colors1_samples.tbl'

      ;    box,1,1,10,2,2

          for i=0,n_elements(dblarr_data(*,0,0,0))-1 do begin
            for j=0,n_elements(dblarr_data(0,*,0,0))-1 do begin
              if kk eq 0 then begin
                int_colour = long(intarr_n_samples_needed_1_sigma(i,j,k) * 254 / 100.)
                if int_colour gt 254 then int_colour = 254
                if intarr_n_samples_needed_1_sigma(i,j,k) ne 0 then $
                  box,i+0.5,j+0.5,i+1.5,j+1.5,int_colour
              end else begin
                int_colour = long(127. + ((dblarr_moments_end(i,j,k,0) - dblarr_moments_parent(i,j,k)) * 127. / (3. * dblarr_moments_end(i,j,k,1))))
                if int_colour gt 254 then int_colour = 254
                if int_colour lt 1 then int_colour = 1
                if abs(dblarr_moments_end(i,j,k,0)) ge 0.00000001 then $
                  box,i+0.5,j+0.5,i+1.5,j+1.5,int_colour
              endelse
            endfor
          endfor

          i_dbl_charsize = 2.
          i_dbl_charthick = 3.
          dbl_xcoord = intarr_xrange(1)+(intarr_xrange(1) - intarr_xrange(0)) / 25.
          ; --- plot colour bar
          plot_colour_legend, I_DBLARR_XRANGE = intarr_xrange,$
                              I_DBLARR_YRANGE = intarr_yrange;,$
      ;                        B_BOTTOM_TO_TOP = 1
      ;    box,11,1,20,2,2
          loadct,0
          if kk eq 0 then begin
            str_temp_a = '1'
            str_temp_b = '>100'
            str_legend = 'Minimum number of samples'
          end else begin
            if b_plot_stars then begin
              str_filename_nstars = '/home/azuri/daten/besancon/lon-lat/html/5x5/best_error_fit/sample_logg/dr3_calib/popid/logg_0.0-3.5/vrad_MH/I9.00-12.0/n_stars_lon_lat.dat'
              strarr_nstars = readfiletostrarr(str_filename_nstars,' ')
              intarr_nstars_bes = ulong(strarr_nstars(*,5))
              intarr_nstars_rave = ulong(strarr_nstars(*,4))
              strarr_nstars = 0
              dblarr_x_plot = dblarr(n_elements(intarr_nstars_rave))
              dblarr_y_plot = dblarr(n_elements(intarr_nstars_rave))
              for ooo = 0ul, n_elements(intarr_nstars_rave)-1 do begin
                dbl_percentage = intarr_nstars_rave(ooo) * 100. / intarr_nstars_bes(ooo)
                for lll=0ul,1 do begin
                  if lll eq 0 then begin
                    intarr_check = intarr_percentages
                  end else begin
                    intarr_check = intarr_n_stars
                  endelse
                  dbl_last = 0.
                  for oooo=0ul,n_elements(intarr_check)-1 do begin
                    if dbl_percentage le intarr_check(oooo) then begin
                      if lll eq 0 then $
                        dblarr_y_plot(ooo) = double(oooo) + ((double(dbl_percentage) - double(dbl_last))/(double(intarr_check(oooo))-double(dbl_last)))$
                      else $
                        dblarr_x_plot(ooo) = double(oooo) + ((double(intarr_nstars_bes(ooo)) - double(dbl_last))/(double(intarr_check(oooo))-double(dbl_last)))
                      oooo = ulong(n_elements(intarr_check))
                      print,'ooo = ',ooo,', oooo = ',oooo,': dblarr_x_plot(ooo) = ',dblarr_x_plot(ooo)
                      print,'ooo = ',ooo,', oooo = ',oooo,': dblarr_y_plot(ooo) = ',dblarr_y_plot(ooo)
                    endif
                    if oooo lt ulong(n_elements(intarr_check)) then $
                      dbl_last = intarr_check(oooo)
                  endfor
                endfor
    ;    intarr_n_stars = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000]
    ;    intarr_percentages = [1, 2, 5, 10, 20, 30, 50]

              endfor
              oplot,dblarr_x_plot,$
                    dblarr_y_plot,$
                    psym=2,$
                    symsize=1.,$
                    thick = 3.
            endif
            str_temp_a = '-3!4r!3'
            str_temp_b = '+3!4r!3'
            if k eq 0 then begin
              str_legend = '!4l!3(!4l!3!Di!N) - !4l!3!Dparent!N'
            end else if k eq 1 then begin
              str_legend = '!4l!3(!4r!3!Di!N) - !4r!3!Dparent!N'
            end else if k eq 2 then begin
              str_legend = '!4l!3(s!Di!N) - s!Dparent!N'
            end else begin
              str_legend = '!4l!3(k!Di!N) - k!Dparent!N'
            end
          endelse
          xyouts,dbl_xcoord,$
                intarr_yrange(0),$
                str_temp_a,$
                charsize=i_dbl_charsize,$
                charthick = i_dbl_charthick
          xyouts,dbl_xcoord,$
                intarr_yrange(1) - ((intarr_yrange(1) - intarr_yrange(0)) * i_dbl_charsize / 40.),$
                str_temp_b,$
                charsize=i_dbl_charsize,$
                charthick = i_dbl_charthick
          xyouts,dbl_xcoord + ((intarr_xrange(1) - intarr_xrange(0)) / 24.5),$
                intarr_yrange(0) + ((intarr_yrange(1) - intarr_yrange(0)) / 2.),$
                str_legend,$
                charsize=i_dbl_charsize,$
                charthick = i_dbl_charthick,$
                alignment = 0.5,$
                orientation = 90.

          device,/close
          spawn,'epstopdf '+str_plotname_root+'.ps'
        endfor; kk
      endfor; k
      set_plot,'x'
    endfor
  endfor
;  stop
end
