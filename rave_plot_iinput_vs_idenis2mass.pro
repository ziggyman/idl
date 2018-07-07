pro rave_plot_iinput_vs_idenis2mass
  str_filename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_IDenis2MASS.dat'
  str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_IInput_vs_IDenis2MASS'

  i_col_idenis2mass = 14
  i_col_iinput = 50


  strarr_data = readfiletostrarr(str_filename,' ')

  dblarr_idenis2mass = double(strarr_data(*,i_col_idenis2mass))
  dblarr_iinput = double(strarr_data(*,i_col_iinput))

  compare_two_parameters,dblarr_iinput,$
                         dblarr_idenis2mass,$
                         str_plotname_root,$
                         STR_XTITLE               = 'I!DC,input!N [mag]',$
                         STR_YTITLE               = 'I!DC,DENIS/2MASS!N [mag]',$
                         I_PSYM                   = 2,$
                         DBL_SYMSIZE              = 0.15,$
                         DBL_CHARSIZE             = 1.8,$
                         DBL_CHARTHICK            = 3.,$
                         DBL_THICK                = 3.,$
                         DBLARR_XRANGE            = [8.5,13.5],$
                         DBLARR_YRANGE            = [7.,13.5],$
                         DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                         DIFF_DBLARR_YRANGE       = [-2.,2.],$
                         DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                         DIFF_STR_YTITLE          = 'I!DC,input!N - I!DC,DENIS/2MASS!N [mag]',$
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
                         HIST_STR_XTITLE          = 'I!DC!N [mag]',$;            --- string
                         HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                         HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                         HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                         HIST_B_POP_ID            = 0,$;             --- bool
                         HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                         HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                         HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                         O_STR_PLOTNAME_HIST      = o_str_plotname_hist
end
