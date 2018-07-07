pro rave_besancon_plot_imag_histograms, I_INT_MODE=i_int_mode
  if not keyword_set(I_INT_MODE) then $
    i_int_mode = 9; --- 1... no -> use observed stars
                  ; --- 2... IC1
                  ; --- 3... IC2
                  ; --- 4... observed minus IC1
                  ; --- 5... observed minus Ken Russel's stars
                  ; --- 6... observed with 2MASS I
                  ; --- 7... observed with 2MASS I minus IC1
                  ; --- 8... IC1 in 2MASS I
                  ; --- 9... IC2 in 2MASS I
                  ; --- 10... IC2 minus IC1
                  ; --- 11... IC2 minus IC1 in 2MASS I

  print,'rave_besancon_plot_imag_histograms, I_INT_MODE=',i_int_mode

  int_col_bes_imag = 2
  int_col_bes_age = 11

  if i_int_mode eq 1 then begin; --- observed data
  str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat'
    str_file_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr.dat'
    int_col_rave_imag = 14
    str_suffix = '_Imag-RAVE'
    xrange = [8.9,12.1]
    str_xtickformat = '(F4.1)'
  end else if i_int_mode eq 2 then begin; --- IC1
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat'
    str_file_rave = '/home/azuri/daten/rave/input_catalogue/ric1+2.dat'
    int_col_rave_imag = 9
    str_suffix = '_Imag-RAVE'
    xrange = [8.9,12.1]
    str_xtickformat = '(F4.1)'
  end else if i_int_mode eq 3 then begin; --- IC2
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat';_230-315_-25-25_JmK.dat'
    str_file_rave = '/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25.dat';rave_input_IbI-ge-25.dat'
    int_col_rave_imag = 6
    str_suffix = '_Imag-RAVE'
    xrange = [8.9,12.1]
    str_xtickformat = '(F4.1)'
;    int_col_rave_jmag =
  end else if i_int_mode eq 4 then begin; --- observed minus IC1
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat'
    str_file_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr_minus-ic1.dat'
    int_col_rave_imag = 14
    str_suffix = '_Imag-RAVE'
    xrange = [8.9,12.1]
    str_xtickformat = '(F4.1)'
  end else if i_int_mode eq 7 then begin; --- observed with 2MASS I minus IC1
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat'
    str_file_rave = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr_minus-ic1_I2MASS.dat'
                                                              ;rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr_minus-ic1_I2MASS.dat'
    int_col_rave_imag = 14
    str_suffix = '_Imag-2MASS'
    xrange = [6.7,12.8]
    str_xtickformat = '(I3)'
  end else if i_int_mode eq 9 then begin; --- IC2 with 2MASS I
    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat';230-315_-25-25_JmK.dat'
;    str_file_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_IbI-ge-25.dat'
    str_file_rave = '/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25.dat'
;    str_file_rave = '/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS.dat'
                                                              ;rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr_minus-ic1_I2MASS.dat'
    int_col_rave_imag = 5
    str_suffix = '_Imag-2MASS'
    xrange = [6.7,12.8]
    str_xtickformat = '(I3)'
  end else begin
    print,'i_int_mode ',i_int_mode,' not implemented'
    return
  end

  strarr_data_rave = readfiletostrarr(str_file_rave,' ')
  dblarr_imag_rave = double(strarr_data_rave(*,int_col_rave_imag))
  strarr_data_rave = 0

  strarr_data_besancon = readfiletostrarr(str_file_besancon,' ')
  dblarr_imag_besancon = double(strarr_data_besancon(*,int_col_bes_imag))
  dblarr_age_besancon = double(strarr_data_besancon(*,int_col_bes_age))
  strarr_data_besancon = 0

  str_plotname_root = strmid(str_file_besancon,0,strpos(str_file_besancon,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = str_plotname_root + 'imag/'
  str_plotname_root = str_plotname_root + strmid(str_file_besancon,strpos(str_file_besancon,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
  str_plotname_root = str_plotname_root + '_vs_' + strmid(str_file_rave,strpos(str_file_rave,'/',/REVERSE_SEARCH)+1)
  str_plotname_root = strmid(str_plotname_root,0,strpos(str_plotname_root,'.',/REVERSE_SEARCH))
  str_plotname_root = str_plotname_root + str_suffix
  str_plotname_root = str_plotname_root + '_I'+strtrim(string(long(xrange(0))),2)+'-'+strtrim(string(long(xrange(1))),2)

  print,'rave_besancon_plot_imag_histograms: str_plotname_root set to <'+str_plotname_root+'>'

  xtitle = 'I [mag]'
  ytitle = 'Percentage of stars'
;  i_nbins = 50
  nbinsmin = 40
  nbinsmax = 60
  dblarr_position = [0.12, 0.16,0.91,0.99]
  int_xticks = 0;3
  dblarr_vertical_lines_in_plot = [9.,9.8,10.5,11.3,12.]
  b_print_moments = 0
  plot_two_histograms,dblarr_imag_rave,$; --- RAVE
                        dblarr_imag_besancon,$; --- BESANCON
                        STR_PLOTNAME_ROOT=str_plotname_root,$;     --- string
                        XTITLE=xtitle,$;                           --- string
                        YTITLE=ytitle,$;                           --- string
;                        I_NBINS=i_nbins,$;                           --- int
                        NBINSMAX=nbinsmax,$;                       --- int
                        NBINSMIN=nbinsmin,$;                       --- int
;                        TITLE=title,$;                             --- string
                        XRANGE=xrange,$;                           --- dblarr
;                        YRANGE=yrange,$;                           --- dblarr
;                        MAXNORM=maxnorm,$;                         --- bool (0/1)
;                        TOTALNORM=totalnorm,$;                     --- bool (0/1)
                        PERCENTAGE=1,$;                   --- bool (0/1)
;                        REJECTVALUEX=rejectvaluex,$;               --- double
                        B_POP_ID = 1,$;                     --- bool
                        DBLARR_STAR_TYPES=dblarr_age_besancon,$;     --- dblarr
                        PRINTPDF=1,$;                       --- bool (0/1)
;                        DEBUGA=debuga,$;                           --- bool (0/1)
;                        DEBUGB=debugb,$;                           --- bool (0/1)
;                        DEBUG_OUTFILES_ROOT=debug_outfiles_root,$; --- string
                        COLOUR=1,$;                           --- bool (0/1)
;                        B_RESIDUAL=b_residual,$;                 --- double
                        I_DBLARR_POSITION = dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                        I_DBL_THICK = 3,$;
                        I_INT_XTICKS = int_xticks,$
                        I_STR_XTICKFORMAT = str_xtickformat,$
                        I_DBL_CHARSIZE = 1.8,$
                        I_DBL_CHARTHICK = 3.,$
                        DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                        B_PRINT_MOMENTS               = b_print_moments

end
