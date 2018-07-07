pro rave_plot_iinput_vs_i2mass
  str_filename = '/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25.dat';/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS.dat'
  str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_I2MASS_vs_IInput'

  i_col_i2mass = 5;14
  i_col_iinput = 6;67


  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_i2mass = double(strarr_data(*,i_col_i2mass))
  dblarr_iinput = double(strarr_data(*,i_col_iinput))

  compare_two_parameters,dblarr_i2mass,$
                         dblarr_iinput,$
                         str_plotname_root,$
                         STR_XTITLE               = 'I!D2MASS!N [mag]',$
                         STR_YTITLE               = 'I!DIC2!N [mag]',$
                         I_PSYM                   = 2,$
                         DBL_SYMSIZE              = 0.15,$
                         DBL_CHARSIZE             = 1.8,$
                         DBL_CHARTHICK            = 3.,$
                         DBL_THICK                = 3.,$
                         DBLARR_XRANGE            = [3.,13.],$
                         DBLARR_YRANGE            = [9.,12.],$
                         DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                         DIFF_DBLARR_YRANGE       = [-6.,2.],$
                         DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                         DIFF_STR_YTITLE          = 'I!D2MASS!N - I!DIC2!N [mag]',$
;                         I_XTICKS                 = i_xticks,$
                         STR_XTICKFORMAT          = '(I2)',$
;                         I_YTICKS                 = i_yticks,$
                         DBL_REJECTVALUEX         = 90.,$;             --- double
                         DBL_REJECTVALUE_X_RANGE  = 30.,$;             --- double
                         DBL_REJECTVALUEY         = 90.,$;             --- double
                         DBL_REJECTVALUE_Y_RANGE  = 30.,$;             --- double
;                         STR_YTICKFORMAT          = str_ytickformat,$
                         B_PRINTPDF               = 1,$;               --- bool (0/1)
                         SIGMA_I_NBINS            = 30,$
                         SIGMA_I_MINELEMENTS      = 5,$
                         HIST_I_NBINSMIN          = 20,$;            --- int
                         HIST_I_NBINSMAX          = 30,$;            --- int
                         HIST_STR_XTITLE          = 'I [mag]',$;            --- string
                         ;HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                         ;HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                         HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                         ;HIST_B_POP_ID            = 0,$;             --- bool
                         ;HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                         HIST_DBLARR_XRANGE       = [3.,13.],$
                         HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                         ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                         O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                         B_PRINT_MOMENTS                    = 1,$
                           DBLARR_VERTICAL_LINES_IN_PLOT    = [9.,12.],$
                           DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                           DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]

  reduce_pdf_size,'/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput_diff.pdf','/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput_diff_small.pdf'
  reduce_pdf_size,'/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput.pdf','/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput_small.pdf'
  reduce_pdf_size,'/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput_hist_30bins.pdf','/home/azuri/daten/rave/input_catalogue/rave_input_I2MASS_lon_lat_IbI-ge-25_I2MASS_vs_IInput_hist_30bins_small.pdf'
end
