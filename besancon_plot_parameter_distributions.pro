pro besancon_plot_parameter_distributions

  str_datafile = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_snr-i-dec-giant-dwarf-minus-ic1.dat'

  b_plot = 1
  int_start = 0

  dbl_l_min = 325.
  dbl_l_max = 340.
  dbl_b_min = -30.
  dbl_b_max = -25.

;  int_n_stars = 1000
  int_n_samples = 30
  int_col_feh = 8

  str_filelist_out = '/home/azuri/daten/besancon/lon-lat/samples/all_samples.list'
  openw,lun_list,str_filelist_out,/GET_LUN

  str_filelist_minus_out = '/home/azuri/daten/besancon/lon-lat/samples/all_samples_minus.list'
  openw,lun_list_minus,str_filelist_minus_out,/GET_LUN

  strarr_data = readfiletostrarr(str_datafile,' ')

  dblarr_lon = double(strarr_data(*,0))
  dblarr_lat = double(strarr_data(*,1))

  indarr_lon = where(dblarr_lon ge dbl_l_min and dblarr_lon le dbl_l_max)
  indarr_lat = where(dblarr_lat(indarr_lon) ge dbl_b_min and dblarr_lat(indarr_lon) le dbl_b_max)

  for jjj = 0,27 do begin
    int_n_stars = n_elements(indarr_lat)
    if jjj eq 1 then begin
      int_n_stars = 9000
    end else if jjj eq 2 then begin
      int_n_stars = 8000
    end else if jjj eq 3 then begin
      int_n_stars = 7000
    end else if jjj eq 4 then begin
      int_n_stars = 6000
    end else if jjj eq 5 then begin
      int_n_stars = 5000
    end else if jjj eq 6 then begin
      int_n_stars = 4000
    end else if jjj eq 7 then begin
      int_n_stars = 3000
    end else if jjj eq 8 then begin
      int_n_stars = 2000
    end else if jjj eq 9 then begin
      int_n_stars = 1000
    end else if jjj eq 10 then begin
      int_n_stars = 900
    end else if jjj eq 11 then begin
      int_n_stars = 800
    end else if jjj eq 12 then begin
      int_n_stars = 700
    end else if jjj eq 13 then begin
      int_n_stars = 600
    end else if jjj eq 14 then begin
      int_n_stars = 500
    end else if jjj eq 15 then begin
      int_n_stars = 400
    end else if jjj eq 16 then begin
      int_n_stars = 300
    end else if jjj eq 17 then begin
      int_n_stars = 200
    end else if jjj eq 18 then begin
      int_n_stars = 100
    end else if jjj eq 19 then begin
      int_n_stars = 90
    end else if jjj eq 20 then begin
      int_n_stars = 80
    end else if jjj eq 21 then begin
      int_n_stars = 70
    end else if jjj eq 22 then begin
      int_n_stars = 60
    end else if jjj eq 23 then begin
      int_n_stars = 50
    end else if jjj eq 24 then begin
      int_n_stars = 40
    end else if jjj eq 25 then begin
      int_n_stars = 30
    end else if jjj eq 26 then begin
      int_n_stars = 20
    end else if jjj eq 27 then begin
      int_n_stars = 10
    end

    str_out = strmid(str_datafile,0,strpos(str_datafile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(int_n_stars),2)+'stars_'
    str_temp = strtrim(string(dbl_l_min),2)
    str_out = str_out+strmid(str_temp,0,strpos(str_temp,'.'))+'-'
    str_temp = strtrim(string(dbl_l_max),2)
    str_out = str_out+strmid(str_temp,0,strpos(str_temp,'.'))+'_'
    str_temp = strtrim(string(dbl_b_min),2)
    str_out = str_out+strmid(str_temp,0,strpos(str_temp,'.'))+'-'
    str_temp = strtrim(string(dbl_b_max),2)
    str_out = str_out+strmid(str_temp,0,strpos(str_temp,'.'))+'.dat'
    indarr_use = ulonarr(int_n_stars)
    openw,lun_out,str_out,/GET_LUN
      for ii=0ul,int_n_stars-1 do begin
        if jjj eq 0 then begin
          printf,lun_out,strarr_data(indarr_lon(indarr_lat(ii)),int_col_feh)
        end else begin
          b_run = 1
          while b_run do begin
            int_random = ulong(randomu(dbl_seed) * int_n_stars)
            if ii gt 0 then begin
              indarr_test = where(indarr_use(0:ii-1) eq int_random)
              if indarr_test(0) lt 0 then begin
                indarr_use(ii) = int_random
                b_run = 0
              endif
            endif else begin
              indarr_use(0) = int_random
              b_run = 0
            endelse
          endwhile
          printf,lun_out,strarr_data(indarr_lon(indarr_lat(indarr_use(ii))),int_col_feh)
        endelse
      endfor
    free_lun,lun_out

    dblarr_feh = double(strarr_data(indarr_lon(indarr_lat),int_col_feh))
    if jjj gt 0 then $
      dblarr_feh = dblarr_feh(indarr_use)

    for jj=0,1 do begin
      if jj eq 1 then $
        dblarr_feh = 0. - dblarr_feh

    ; --- TODO: do same thing with random samples per swath taking into account the distritutions of RAVE I (and then plus giant-dwarf ratio)
    ; --- really? not necessary? DOCH!!!

      for ii = 0, 6 do begin
        if ii eq 0 then begin
            dbl_percentage = 1
        end else if ii eq 1 then begin
          dbl_percentage = 2
        end else if ii eq 2 then begin
          dbl_percentage = 5
        end else if ii eq 3 then begin
          dbl_percentage = 10
        end else if ii eq 4 then begin
          dbl_percentage = 20
        end else if ii eq 5 then begin
          dbl_percentage = 30
        end else if ii eq 6 then begin
          dbl_percentage = 50
        end

    ;    int_col_star_types = 11
      ;  int_which_sample = 1; --- 0... just a uniform random sample of the mother distribution
                            ; --- 1... a random sample per swath in l and b taking into account I
                            ; --- 2... a random sample per swath in l and b taking into account I and giant-to-dwarf ratio
      ;  dbl_seed = 5.

        str_htmlfile = strmid(str_datafile,0,strpos(str_datafile,'/',/REVERSE_SEARCH)+1)+'samples/index_'+strtrim(string(int_n_stars),2)+'stars'

        str_temptemp = strtrim(string(dbl_l_min),2)
        str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
        str_htmlfile = str_htmlfile + '_' + str_temptemp

        str_temptemp = strtrim(string(dbl_l_max),2)
        str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
        str_htmlfile = str_htmlfile + '-' + str_temptemp

        str_temptemp = strtrim(string(dbl_b_min),2)
        str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
        str_htmlfile = str_htmlfile + '_' + str_temptemp

        str_temptemp = strtrim(string(dbl_b_max),2)
        str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
        str_htmlfile = str_htmlfile + '-' + str_temptemp

        str_htmlfile = str_htmlfile + '_' + strtrim(string(int_n_samples),2)+'samples_'+strtrim(string(long(dbl_percentage)),2)+'percent'

        if jj eq 1 then $
          str_htmlfile = str_htmlfile + '_minus'
          str_htmlfile = str_htmlfile + '.html'


      ;  int_n_stars = n_elements(strarr_data(*,0))
        int_n_random_stars = ulong(double(int_n_stars) * dbl_percentage / 100.)

        if int_n_random_stars gt 1 then begin
          dblarr_moment = moment(dblarr_feh)

        ;  dblarr_star_types_samples = double(strarr_data(0:int_nstars-1,int_col_star_types))

          dblarr_moments = dblarr(int_n_samples,4)

          openw,lun,str_htmlfile,/GET_LUN
          printf,lun,'<html><body><center>'

          str_filename_dist = strmid(str_htmlfile,0,strpos(str_htmlfile,'/',/REVERSE_SEARCH)+1)+strtrim(string(int_n_stars),2)+'stars_'+strtrim(string(int_n_samples),2)+'samplesX'+strtrim(string(long(dbl_percentage)),2)+'percent_moments'

          str_temptemp = strtrim(string(dbl_l_min),2)
          str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
          str_filename_dist = str_filename_dist + '_' + str_temptemp

          str_temptemp = strtrim(string(dbl_l_max),2)
          str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
          str_filename_dist = str_filename_dist + '-' + str_temptemp

          str_temptemp = strtrim(string(dbl_b_min),2)
          str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
          str_filename_dist = str_filename_dist + '_' + str_temptemp

          str_temptemp = strtrim(string(dbl_b_max),2)
          str_temptemp = strmid(str_temptemp,0,strpos(str_temptemp,'.'))
          str_filename_dist = str_filename_dist + '-' + str_temptemp

          if jj eq 1 then $
            str_filename_dist = str_filename_dist + '_minus'

          str_filename_dist = str_filename_dist + '.dat'

          if jj eq 0 then $
            printf,lun_list,str_filename_dist+' '+str_out $
          else $
            printf,lun_list_minus,str_filename_dist+' '+str_out

          if int_start ne 0 then $
            int_start = countdatlines(str_filename_dist)
          print,'besancon_plot_parameter_distributions: int_start = ',int_start
          if int_start eq 0 then begin
            openw,lun_dist,str_filename_dist,/GET_LUN
          end else if int_start lt int_n_samples then begin
            openw,lun_dist,str_filename_dist,/GET_LUN,/APPEND
          end
          if int_start lt int_n_samples then begin
            if int_start eq 0 then $
              printf,lun_dist,'all: ' + strtrim(string(dblarr_moment(0)),2) + ' ' + strtrim(string(sqrt(dblarr_moment(1))),2) + ' ' + strtrim(string(dblarr_moment(2)),2) + ' ' + strtrim(string(dblarr_moment(3)),2)
            for i=ulong(int_start), int_n_samples-1 do begin
              ; --- define parameters
              dblarr_feh_sample = dblarr(int_n_random_stars)
              intarr_index_stars_found = lonarr(int_n_random_stars)
              intarr_index_stars_found(*) = -1
          ;    int_n_stars_found = 0

              ; --- create random sample
              for j=0ul, int_n_random_stars-1 do begin
                b_run = 1
                while b_run do begin
                  int_index = long(randomu(dbl_seed) * double(int_n_stars))
                  if j eq 0 then begin
                    intarr_index = [-1]
                  end else begin
                    intarr_index = where(intarr_index_stars_found(0:j-1) eq int_index)
                  endelse
                  if intarr_index(0) lt 0 then begin
                    dblarr_feh_sample(j) = dblarr_feh(int_index)
                    intarr_index_stars_found(j) = int_index
                    b_run = 0
                  endif
                endwhile
                print,'sample i=',i,': star no j=',j,' found'
              endfor; --- end create random sample

              ; --- calculate moments
              dblarr_moments(i,*) = moment(dblarr_feh_sample)

              printf,lun_dist,strtrim(string(i),2)+': ' + strtrim(string(dblarr_moments(i,0)),2) + ' ' + strtrim(string(sqrt(dblarr_moments(i,1))),2) + ' ' + strtrim(string(dblarr_moments(i,2)),2) + ' ' + strtrim(string(dblarr_moments(i,3)),2)

              print,'sample i=',i,' calculated: dblarr_moments(i,*) = ',dblarr_moments(i,*)

              if b_plot and ((i eq (int_n_samples-1)) or (i eq ((int_n_samples/10)-1)) or (i eq 19) or (i eq 19) or (i eq 29) or (i eq 49) or (i eq 99) or (i eq 199) or (i eq 299) or (i eq 499) or (i eq 999) or (i eq 1999) or (i eq 2999) or (i eq 4999) or (i eq 9999) or (i eq 19999) or (i eq 29999) or (i eq 49999) or (i eq 99999) or (((i eq ((int_n_samples/100)-1)) or (i eq ((int_n_samples/1000)-1))) and (i gt 0))) then begin

                ; --- calculate moments of moments
                dblarr_moments_of_moments = dblarr(4,4)

                str_plotname_root = strmid(str_datafile,0,strpos(str_datafile,'/',/REVERSE_SEARCH))+'/samples/'
                str_plotname_root = str_plotname_root + strmid(str_datafile,strpos(str_datafile,'/',/REVERSE_SEARCH)+1)
                str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
                for j=0, 3 do begin
                  dblarr_moments_of_moments(j,*) = moment(dblarr_moments(0:i,j))
                  dblarr_moments_of_moments(j,1) = sqrt(dblarr_moments_of_moments(j,1))
                  ; --- plot results
                  str_plotname_root = strmid(str_datafile,0,strpos(str_datafile,'/',/REVERSE_SEARCH))+'/samples/'
                  str_plotname_root = str_plotname_root + strmid(str_datafile,strpos(str_datafile,'/',/REVERSE_SEARCH)+1)
                  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
                  str_plotname_root = str_plotname_root+'_'+strtrim(string(i+1),2)+'samplesX'+strtrim(string(long(dbl_percentage)),2)+'percent_moment'+strtrim(string(j),2)
                  if j eq 0 then begin
                    str_xtitle = 'Mean [Fe/H]'
                    str_xtickformat = '(F8.3)'
                    dblarr_xrange=[-0.214, -0.21]
                    int_xticks = 4
                  end else if j eq 1 then begin
                    str_xtitle = 'Standard deviation [Fe/H]'
                    str_xtickformat = '(F8.3)'
                    dblarr_xrange=[0.13, 0.138]
                    int_xticks = 0
                  end else if j eq 2 then begin
                    str_xtitle = 'Skewness [Fe/H]'
                    str_xtickformat = '(F8.2)'
                    dblarr_xrange=[-1.51, -1.44]
                    int_xticks = 0
                  end else begin
                    str_xtitle = 'Kurtosis [Fe/H]'
                    str_xtickformat = '(F8.2)'
                    dblarr_xrange=[2.5, 3.5]
                    int_xticks = 4
                  endelse

                  str_ytitle = 'Percentage of stars'
                  int_n_bins = 30
                  int_n_bins_min = 25
                  int_n_bins_max = 35
          ;        str_title = 0
              ;    dblarr_xrange = [-2.,1.]
                  dbl_reject_value_x = 99.9
              ;    b_pop_id = 1
                  dblarr_position = [0.13, 0.16, 0.93, 0.99]
                  dbl_thick = 3.
                  dbl_charsize = 1.8
                  dbl_charthick = 3.
                  dblarr_vertical_lines_in_plot = [mean(dblarr_moments(0:i,j)),dblarr_moment(j)]
                  print,'dblarr_vertical_lines_in_plot = ',dblarr_vertical_lines_in_plot
                  plot_two_histograms,dblarr_moments(0:i,j),$; --- moments
                                      dblarr_moments(0:i,j),$; --- same as x
                                      STR_PLOTNAME_ROOT=str_plotname_root,$;     --- string
                                      XTITLE=str_xtitle,$;                           --- string
                                      YTITLE=str_ytitle,$;                           --- string
                                      I_NBINS=int_n_bins,$;                           --- int
                                      ;NBINSMAX=int_n_bins_max,$;                       --- int
                                      ;NBINSMIN=int_n_bins_min,$;                       --- int
          ;                            TITLE=str_title,$;                             --- string
                                      ;XRANGE=dblarr_xrange,$;                           --- dblarr
          ;                            YRANGE=0,$;                           --- dblarr
          ;                            MAXNORM=0,$;                         --- bool (0/1)
          ;                            TOTALNORM=0,$;                     --- bool (0/1)
                                      PERCENTAGE=1,$;                   --- bool (0/1)
                                      REJECTVALUEX=dbl_reject_value_x,$;               --- double
          ;                            B_POP_ID = 0,$;b_pop_id,$;                     --- bool
          ;                            DBLARR_STAR_TYPES=0,$;dblarr_star_types_samples,$;     --- dblarr
                                      PRINTPDF=1,$;                       --- bool (0/1)
          ;                            DEBUGA=0,$;                           --- bool (0/1)
          ;                            DEBUGB=0,$;                           --- bool (0/1)
          ;                            DEBUG_OUTFILES_ROOT=0,$; --- string
                                      COLOUR=1,$;                           --- bool (0/1)
                                      B_RESIDUAL=0,$;                 --- double
                                      I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                                      I_DBL_THICK = dbl_thick,$;
                                      I_INT_XTICKS = int_xticks,$
                                      I_STR_XTICKFORMAT = str_xtickformat,$
                                      I_DBL_CHARSIZE = dbl_charsize,$
                                      I_DBL_CHARTHICK = dbl_charthick,$
                                      DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                                      B_PRINT_MOMENTS               = 2
                  print,str_plotname_root+' ready'

                  printf,lun,'<br><hr><br><h3>'+str_xtitle+' '+strtrim(string(i+1),2)+' samples X '+strtrim(string(dbl_percentage),2)+' percent</h3><br>'
                  printf,lun,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a>'
                endfor
              endif
            endfor
            free_lun,lun_dist
          endif
          printf,lun,'</center>'
          printf,lun,'</body>'
          printf,lun,'</html>'
          free_lun,lun
        endif
      endfor
    endfor
  endfor
  indarr_lon = 0
  indarr_lat = 0
  strarr_data = 0
  free_lun,lun_list
  free_lun,lun_list_minus
end
