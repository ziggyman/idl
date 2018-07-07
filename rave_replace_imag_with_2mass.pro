pro rave_replace_imag_with_2mass
  b_input = 0
  b_all = 0
  b_chem = 0

  if b_input then begin
    i_col_i_input = 5
    str_filename_in = '/suphys/azuri/daten/rave/input_catalogue/rave_input.dat'
    strarr_data = readfiletostrarr(str_filename_in,' ',HEADER=strarr_header)
    dblarr_i_input = double(strarr_data(*,i_col_i_input))
    strarr_lines = readfilelinestoarr(str_filename_in,STR_DONT_READ='#')
    dblarr_j2mass = dblarr(n_elements(strarr_lines))
    dblarr_k2mass = dblarr(n_elements(strarr_lines))
    print,'rave_replace_imag_with_2mass: creating dblarr_j2mass and dblarr_k2mass'
    for i=0ul, n_elements(strarr_lines)-1 do begin
      str_temp = strtrim(strmid(strarr_lines(i),strpos(strarr_lines(i),'J=')+2),2)
      dblarr_j2mass(i) = double(strmid(str_temp,0,strpos(str_temp,',')))
      dblarr_k2mass(i) = double(strtrim(strmid(str_temp,strpos(str_temp,'K=')+2),2))
      if i lt 10 then begin
        print,'rave_replace_imag_with_2mass: dblarr_j2mass(i=',i,') = ',dblarr_j2mass(i),', dblarr_k2mass(i=',i,') = ',dblarr_k2mass(i)
      endif
    endfor


  end else begin
    i_col_i_input = 14
    i_col_idenis = 50
    i_col_jdenis = 52
    i_col_kdenis = 54
    i_col_j2mass = 59
    i_col_k2mass = 63
    i_col_mh = 21
    if b_chem then begin
      str_filename_in = '/suphys/azuri/daten/rave/rave_data/abundances/RAVE_abd_imag_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5.dat'
    end else begin
      if b_all then begin
        str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all.dat'
      end else begin
        str_filename_in = '/home/azuri/daten/rave/rave_data/release10/raveinternal_150512_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr.dat'
;'/home/azuri/daten/rave/rave_data/release9/raveinternal_101111_with-2MASS-JK_no-flag_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr.dat'
;'/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_no-doubles-within-2-arcsec-maxsnr.dat';rave_internal_dr8_all_IbI-ge-25_no-doubles-maxsnr_minus-ic1.dat';with-2MASS-JK_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr.dat';rave_internal_dr8_all_good_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      ;str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5.dat'
      endelse
    endelse
    strarr_header = strarr(1)
    strarr_header(0) = '-1'
    strarr_data = readfiletostrarr(str_filename_in,' ',I_NLines=i_nlines,I_NCols=i_ncols,HEADER=strarr_header)

    ; --- check magnitudes
    indarr = where(strarr_data(*,i_col_idenis) eq 'XXX')
    if indarr(0) ge 0 then $
      strarr_data(indarr,i_col_idenis) = strtrim(string(99.9),2)
    indarr = where(strarr_data(*,i_col_jdenis) eq 'XXX')
    if indarr(0) ge 0 then $
      strarr_data(indarr,i_col_jdenis) = strtrim(string(99.9),2)
    indarr = where(strarr_data(*,i_col_kdenis) eq 'XXX')
    if indarr(0) ge 0 then $
      strarr_data(indarr,i_col_kdenis) = strtrim(string(99.9),2)
    indarr = where(strarr_data(*,i_col_j2mass) eq 'XXX')
    if indarr(0) ge 0 then $
      strarr_data(indarr,i_col_j2mass) = strtrim(string(99.9),2)
    indarr = where(strarr_data(*,i_col_k2mass) eq 'XXX')
    if indarr(0) ge 0 then $
      strarr_data(indarr,i_col_k2mass) = strtrim(string(99.9),2)
    dblarr_i_input = double(strarr_data(*,i_col_i_input))
    indarr_gt_12 = where(dblarr_i_input gt 12.)
    if indarr_gt_12(0) lt 0 then begin
      print,'dblarr_i_input(indarr_gt_12) = 0'
    end else begin
      print,'dblarr_i_input(indarr_gt_12) = ',dblarr_i_input(indarr_gt_12)
    end
  ;  stop
    dblarr_idenis = double(strarr_data(*,i_col_idenis))
    dblarr_jdenis = double(strarr_data(*,i_col_jdenis))
    dblarr_kdenis = double(strarr_data(*,i_col_kdenis))
    dblarr_j2mass = double(strarr_data(*,i_col_j2mass))
  ;  print,'strarr_data(*,i_col_k2mass) = ',strarr_data(*,i_col_k2mass)
    dblarr_k2mass = double(strarr_data(*,i_col_k2mass))
  end

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I2MASS.dat'
  ;str_filename_out_rave = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_IDenis2MASS.dat'
  str_filename_out_ilt12 = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I2MASS-9ltIlt12.dat'


  ; --- calculate I_2MASS from J_2MASS and K_2MASS
  print,'rave_replace_imag_with_2mass: calculating 2MASS I'
  dblarr_i2mass = dblarr_j2mass + 1.103 * (dblarr_j2mass - dblarr_k2mass)+0.07

  indarr_j2mass_and_k2mass_ne_99 = where((abs(dblarr_j2mass - 99.) gt 10.) and (abs(dblarr_k2mass - 99.) gt 10.),COMPLEMENT=indarr_j2mass_or_k2mass_eq_99)

  ;print,'indarr_j2mass_or_k2mass_eq_99 = ',indarr_j2mass_or_k2mass_eq_99

  if b_input then begin
    b = 0ul
    print,'rave_replace_imag_with_2mass: saving 2MASS I to strarr_data(*,i_col_i_input)'
    strarr_data(*,i_col_i_input) = strtrim(string(dblarr_i2mass),2)
    ; --- write output files with I_Input and I_2MASS swaped
    print,'rave_replace_imag_with_2mass: writing output files'
    openw,lun,str_filename_out,/GET_LUN
    openw,luna,str_filename_out_ilt12,/GET_LUN
    if n_elements(strarr_header) gt 0 then begin
      for i=0ul,n_elements(strarr_header)-1 do begin
        printf,lun,strarr_header(i)
      endfor
    endif
    for i=0ul, n_elements(strarr_lines)-1 do begin
      str_line = ''
      for j=0,5 do begin
        str_line = str_line+strarr_data(i,j)+' '
      endfor
      str_line = str_line + strtrim(string(dblarr_i_input(i)),2)+' '
      str_line = str_line + strtrim(string(dblarr_j2mass(i)),2)+' '
      str_line = str_line + strtrim(string(dblarr_k2mass(i)),2)
      printf,lun,str_line
      if (dblarr_i2mass(i) ge 9.) and (dblarr_i2mass(i) le 12.) then begin
        print,'rave_replace_imag_with_2mass: printing star b=',b,' with i2mass = ',dblarr_i2mass(i)
        printf,luna,str_line
        b = b+1
      endif
    endfor
    print,'file <'+str_filename_out_ilt12+'> with ',b,' lines written'
  end else begin
    indarr_idenis_ne_99 = where(dblarr_idenis lt 80.)

    indarr_j2mass_and_k2mass_and_idenis_ne_99 = where((abs(dblarr_j2mass - 99.) gt 10.) and (abs(dblarr_k2mass - 99.) gt 10.) and (abs(dblarr_idenis - 99.) gt 10.),COMPLEMENT=indarr_j2mass_or_k2mass_or_idenis_eq_99)

    if indarr_j2mass_or_k2mass_eq_99(0) ge 0 then begin
      indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99 = where((abs(dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99)-99.) lt 10.) or (abs(dblarr_kdenis(indarr_j2mass_or_k2mass_eq_99)-99.) lt 10.),COMPLEMENT=indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99)
    end else begin
      indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99 = [-1]
    endelse

;  print,'dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99)) = ',dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99))
;  print,'dblarr_kdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99)) = ',dblarr_kdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99))
;  print,'dblarr_j2mass(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99)) = ',dblarr_j2mass(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99))
;  print,'dblarr_k2mass(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99)) = ',dblarr_k2mass(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99))
;stop

  ; --- compare I_DENIS and I_2MASS for stars with J-K < 0.65
    indarr_jmk = where(dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) lt 0.65, COMPLEMENT=indarr_jmk_b)
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_Idenis_vs_I2mass_JmK_lt_0_65'
    compare_two_parameters,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)),$
                          dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!DDENIS!N [mag]',$
                          STR_YTITLE               = 'I!D2MASS!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [6.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!DDENIS!N - I!D2MASS!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]


    set_plot,'ps'
      device,filename=str_plotname_root+'_cond_JmK_lt_0_65.ps'
        plot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)),$
              dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk))-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)),$
            xtitle='I!DDENIS!N [mag]',$
            ytitle='I!DDENIS!N - I!D2MASS!N [mag]',$
            psym=2,$
            symsize=0.05,$
            charsize=2.,$
            thick=3.,$
            charthick=3.
            dblarr_temp = (dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99)) - (dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99))

        indarr_bad_idenis = where(dblarr_temp le -0.2 or dblarr_temp ge 0.6,COMPLEMENT=indarr_good)
        loadct,13
        oplot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
              dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good))-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
            psym=2,$
            symsize=0.05,$
            color=140
      device,/close
    set_plot,'x'


    ; --- compare I_DENIS and I_2MASS for stars with J-K < 0.65
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_Idenis_vs_I2mass_JmK_ge_0_65'
    compare_two_parameters,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk_b)),$
                          dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk_b)),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!DDENIS!N [mag]',$
                          STR_YTITLE               = 'I!D2MASS!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [6.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!DDENIS!N - I!D2MASS!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]


    set_plot,'ps'
      device,filename=str_plotname_root+'_cond_JmK_ge_0_65.ps'
        plot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk_b)),$
              dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk_b))-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk_b)),$
          xtitle='I!DDENIS!N [mag]',$
          ytitle='I!DDENIS!N - I!D2MASS!N [mag]',$
          psym=2,$
          symsize=0.05,$
          charsize=2.,$
          thick=3.,$
          charthick=3.
          dblarr_temp = (dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99)) - (dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99))

          indarr_bad_idenis = where(dblarr_temp le -0.2 or dblarr_temp ge 0.6,COMPLEMENT=indarr_good)
          loadct,13
          oplot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
                dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good))-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
              psym=2,$
              symsize=0.05,$
            color=140
      device,/close
    set_plot,'x'






    ; --- compare I_DENIS and I_2MASS for stars with J-K < 0.65
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_Idenis_vs_I2mass_all'
    compare_two_parameters,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99),$
                          dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!DDENIS!N [mag]',$
                          STR_YTITLE               = 'I!D2MASS!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [6.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!DDENIS!N - I!D2MASS!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]


    set_plot,'ps'
      device,filename=str_plotname_root+'_cond_all.ps'
        plot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99),$
            dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99)-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99),$
            xtitle='I!DDENIS!N [mag]',$
            ytitle='I!DDENIS!N - I!D2MASS!N [mag]',$
            psym=2,$
            symsize=0.05,$
            charsize=2.,$
            thick=3.,$
            charthick=3.
        dblarr_temp = (dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99)) - (dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99))

        indarr_bad_idenis = where(dblarr_temp le -0.2 or dblarr_temp ge 0.6,COMPLEMENT=indarr_good)
        loadct,13
        oplot,dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
              dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good))-dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good)),$
              psym=2,$
              symsize=0.05,$
              color=140
      device,/close
    set_plot,'x'









    indarr_num = where(dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)) lt 10.,COMPLEMENT=indarr_faint)
    print,'percentage of stars with I < 10 = ',100. * n_elements(indarr_num) / n_elements(dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)))

    indarr_num = where(abs(dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk(indarr_faint))) - dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk(indarr_faint)))) gt 0.2,COMPLEMENT=indarr_faint)
    print,'percentage of stars with abs(I_DENIS-I2MASS) > 0.2 = ',100. * n_elements(indarr_num) / n_elements(dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_jmk)))

    print,'percentage of stars with 2MASS J and K = ',100. * n_elements(indarr_j2mass_and_k2mass_ne_99) / n_elements(dblarr_idenis)

  ;  stop

    ; --- replace I_input with I_2MASS
    dblarr_temp = (dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99)) - (dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99))

    indarr_bad_i2mass = where((dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) gt 10.) and ((dblarr_temp le -0.2) or (dblarr_temp ge 0.6)), COMPLEMENT=indarr_good_i2mass)


    ;dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_bad_idenis)) = dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_bad_idenis))
    ;dblarr_idenis = dblarr_i2mass




    ; --- replace I_DENIS == 99. with I_2MASS and store indices where I_2MASS is not available for these stars in indarr_bad
  ;  indarr = where(abs(dblarr_idenis - 99.) lt 10.)
    indarr_bad = lonarr(n_elements(dblarr_idenis))
    ind = 0





  ;  print,'indarr = where(dblarr_idenis ge 99.) = ',indarr
  ;  print,'n_elements(indarr) = ',n_elements(indarr)
  ;  if indarr_j2mass_or_k2mass_eq_99(0) ge 0 then begin
  ;    for i_ind = 0, n_elements(indarr)-1 do begin
  ;      indarr_temp = where(indarr_j2mass_or_k2mass_eq_99 eq indarr(i_ind))
  ;      if indarr_temp(0) eq -1 then begin
  ;        print,'replacing dblarr_idenis(indarr(i_ind)=',indarr(i_ind),') =',dblarr_idenis(indarr(i_ind)),' with dblarr_i2mass(indarr(i_ind)) = ',dblarr_i2mass(indarr(i_ind))
  ;        dblarr_idenis(indarr(i_ind)) = dblarr_i2mass(indarr(i_ind))
  ;      end else begin
  ;        indarr_bad(ind) = indarr(i_ind)
  ;        ind = ind+1
  ;      end
  ;    endfor
  ;  endif

    b = 0ul

      ; --- add stars to indarr_bad where dblarr_temp le -0.2 or dblarr_temp ge 0.6 for stars without 2MASS J and K but with DENIS J and K and add stars with Denis I or K eq 99 to indarr_bad
  ; if indarr_j2mass_or_k2mass_eq_99(0) ge 0 then begin
  ;   dblarr_temp = (dblarr_idenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99)) - dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99))) - (dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99)) - dblarr_kdenis(indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99)))
 ;   indarr_bad_idenis = where(dblarr_temp le -0.2 or dblarr_temp ge 0.6)
 ;   if ind gt 0 and indarr_bad_idenis(0) ge 0 then begin
 ;     for i_ind = 0, n_elements(indarr_bad_idenis)-1 do begin
 ;       indarr_temp = where(indarr_bad eq indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99(indarr_bad_idenis(i_ind))))
 ;       if indarr_temp(0) eq -1 then begin
 ;         indarr_bad(ind) = indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99(indarr_bad_idenis(i_ind)))
 ;         ind = ind+1
 ;       endif
 ;     endfor
 ;     for i_ind = 0, n_elements(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99(indarr_bad_idenis))-1 do begin
 ;       indarr_temp = where(indarr_bad eq indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99(indarr_bad_idenis(i_ind))))
 ;       if indarr_temp(0) eq -1 then begin
 ;         indarr_bad(ind) = indarr_j2mass_or_k2mass_eq_99(indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99(indarr_bad_idenis(i_ind)))
 ;         ind = ind+1
 ;       endif
 ;     endfor
 ;     for i_ind = 0, n_elements(indarr_j2mass_or_k2mass_eq_99)-1 do begin
 ;       indarr_temp = where(indarr_bad eq indarr_j2mass_or_k2mass_eq_99(i_ind))
 ;       if indarr_temp(0) eq -1 then begin
 ;         indarr_bad(ind) = indarr_j2mass_or_k2mass_eq_99(i_ind)
 ;         ind = ind+1
 ;       endif
 ;     endfor
 ;     print,'indarr_bad = ',indarr_bad
 ;   endif
 ; endif
 ; if ind gt 0 then begin
 ;   indarr_bad = indarr_bad(0:ind-1)
 ;   print,'indarr_bad = ',indarr_bad
 ; endif

;  for i=0ul, ind-1 do begin
;    print,'removed line indarr_bad(i=',i,') = ',indarr_bad(i)
;    print,'     dblarr_j2mass(indarr_bad(i)) = ',dblarr_j2mass(indarr_bad(i))
;    print,'     dblarr_k2mass(indarr_bad(i)) = ',dblarr_k2mass(indarr_bad(i))
;    print,'     dblarr_jdenis(indarr_bad(i)) = ',dblarr_jdenis(indarr_bad(i))
;    print,'     dblarr_kdenis(indarr_bad(i)) = ',dblarr_kdenis(indarr_bad(i))
;  endfor
;stop

    i_col_bt = 36
    i_col_vt = 38

    dblarr_bt = double(strarr_data(*,i_col_bt))
    dblarr_vt = double(strarr_data(*,i_col_vt))

    ;print,'dblarr_bt = ',dblarr_bt

    indarr = where(dblarr_bt gt 80.)
    print,'percentage of stars with BT = ',100. * n_elements(indarr) / n_elements(dblarr_idenis)

    indarr = where(dblarr_vt gt 80.)
    print,'percentage of stars with VT = ',100. * n_elements(indarr) / n_elements(dblarr_idenis)

  ;  i_col_teff = 19
  ;  dblarr_teff = double(strarr_data(*,i_col_teff))
    ;print,'dblarr_teff = ',dblarr_teff
  ;  indarr_teff = where(dblarr_teff(indarr_j2mass_and_k2mass_ne_99) gt 10.)

    ; --- from Simons 1996
    ;  dblarr_teff_calc = 10. ^ ((7.06 + dblarr_k2mass(indarr_j2mass_and_k2mass_ne_99(indarr_teff)) - dblarr_j2mass(indarr_j2mass_and_k2mass_ne_99(indarr_teff))) / 1.78)
  ;  set_plot,'ps'
  ;  device,filename=strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_teff.ps',/color
  ;  plot,dblarr_teff(indarr_j2mass_and_k2mass_ne_99(indarr_teff)),$
  ;       dblarr_teff_calc,$
  ;       xtitle='T!Deff!N RAVE',$
  ;       ytitle='T!Deff!N calc',$
  ;       psym=2,$
  ;       symsize=0.1,$
  ;       xrange=[3000.,12000.],$
  ;       xstyle=1,$
  ;       yrange=[3000.,12000.],$
  ;       ystyle=1,$
  ;       xtickformat='(I6)'
  ;
  ;  loadct,13
  ;  device,/close

  ;  device,filename=strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_teff_diff.ps',/color
  ;  plot,dblarr_teff(indarr_j2mass_and_k2mass_ne_99(indarr_teff)),$
  ;       dblarr_teff(indarr_j2mass_and_k2mass_ne_99(indarr_teff))-dblarr_teff_calc,$
  ;       xtitle='T!Deff!N RAVE',$
  ;       ytitle='T!Deff,RAVE!N - T!Deff,calc!N',$
  ;       psym=2,$
  ;       symsize=0.1,$
  ;       xrange=[3000.,12000.],$
  ;       xstyle=1,$
  ;       yrange=[-3000.,3000.],$
  ;       ystyle=1,$
  ;       xtickformat='(I6)'
  ;  loadct,13
  ;  device,/close
  ;  set_plot,'x'

    dblarr_iusno = double(strarr_data(*,46))
  ;  print,'dblarr_iusno = ',dblarr_iusno
  ;  stop
    indarr_iusno = where(dblarr_iusno(indarr_idenis_ne_99) lt 80.)
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_IDENIS_vs_IUSNO'
    compare_two_parameters,dblarr_idenis(indarr_idenis_ne_99(indarr_iusno)),$
                          dblarr_iusno(indarr_idenis_ne_99(indarr_iusno)),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!DDENIS!N [mag]',$
                          STR_YTITLE               = 'I!DUSNO!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [8.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!DDENIS!N - I!DUSNO!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]


    indarr_iusno = where(dblarr_iusno(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass)) lt 80.)
    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I2MASS_vs_IUSNO'
    compare_two_parameters,dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_iusno))),$
                          dblarr_iusno(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_iusno))),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!D2MASS!N [mag]',$
                          STR_YTITLE               = 'I!DUSNO!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [8.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!D2MASS!N - I!DUSNO!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]

    dblarr_bt_tycho = double(strarr_data(*,36))
    dblarr_vt_tycho = double(strarr_data(*,38))

    indarr_tycho = where(dblarr_bt_tycho(indarr_idenis_ne_99) lt 80. and dblarr_vt_tycho(indarr_idenis_ne_99) lt 80.)
    dblarr_v_tycho = dblarr_vt_tycho - 0.09*(dblarr_bt_tycho - dblarr_vt_tycho)
    dblarr_b_tycho = dblarr_v_tycho + 0.85*(dblarr_bt_tycho - dblarr_vt_tycho)
    indarr_b_minus_v_lt_1_3 = where(dblarr_b_tycho(indarr_idenis_ne_99(indarr_tycho)) - dblarr_v_tycho(indarr_idenis_ne_99(indarr_tycho)) lt 1.3, COMPLEMENT=indarr_b_minus_v_ge_1_3)
    dblarr_i_tycho = dblarr_v_tycho
    dblarr_i_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_lt_1_3))) = dblarr_v_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_lt_1_3))) - 1.007*(dblarr_b_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_lt_1_3))) - dblarr_v_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_lt_1_3)))) - 0.03
    dblarr_i_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_ge_1_3))) = dblarr_v_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_ge_1_3))) - 2.444*(dblarr_b_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_ge_1_3))) - dblarr_v_tycho(indarr_idenis_ne_99(indarr_tycho(indarr_b_minus_v_ge_1_3)))) + 1.84

    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_IDENIS_vs_ITycho2'
    compare_two_parameters,dblarr_idenis(indarr_idenis_ne_99(indarr_tycho)),$
                          dblarr_i_tycho(indarr_idenis_ne_99(indarr_tycho)),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!DDENIS!N [mag]',$
                          STR_YTITLE               = 'I!DTycho2!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [8.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!DDENIS!N - I!DTycho2!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]



    indarr_tycho = where(dblarr_bt_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass)) lt 80. and dblarr_vt_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass)) lt 80.)
    dblarr_v_tycho = dblarr_vt_tycho - 0.09*(dblarr_bt_tycho - dblarr_vt_tycho)
    dblarr_b_tycho = dblarr_v_tycho + 0.85*(dblarr_bt_tycho - dblarr_vt_tycho)
    indarr_b_minus_v_lt_1_3 = where(dblarr_b_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho))) - dblarr_v_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho))) lt 1.3, COMPLEMENT=indarr_b_minus_v_ge_1_3)
    dblarr_i_tycho = dblarr_v_tycho
    dblarr_i_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_lt_1_3)))) = dblarr_v_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_lt_1_3)))) - 1.007*(dblarr_b_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_lt_1_3)))) - dblarr_v_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_lt_1_3))))) - 0.03
    dblarr_i_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_ge_1_3)))) = dblarr_v_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_ge_1_3)))) - 2.444*(dblarr_b_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_ge_1_3)))) - dblarr_v_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho(indarr_b_minus_v_ge_1_3))))) + 1.84

    str_plotname_root = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I2MASS_vs_ITycho2'
    compare_two_parameters,dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho))),$
                          dblarr_i_tycho(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_good_i2mass(indarr_tycho))),$
                          str_plotname_root,$
                          STR_XTITLE               = 'I!D2MASS!N [mag]',$
                          STR_YTITLE               = 'I!DTycho2!N [mag]',$
                          I_PSYM                   = 2,$
                          DBL_SYMSIZE              = 0.05,$
                          DBL_CHARSIZE             = 1.8,$
                          DBL_CHARTHICK            = 3.,$
                          DBL_THICK                = 3.,$
                          DBLARR_XRANGE            = [8.,13.5],$
                          DBLARR_YRANGE            = [8.,13.5],$
                          DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                          DIFF_DBLARR_YRANGE       = [-4.,4.],$
                          DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                          DIFF_STR_YTITLE          = '(I!D2MASS!N - I!DTycho2!N) [mag]',$
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
                          HIST_B_MAXNORM           = 0,$;             --- bool (0/1)
                          HIST_B_TOTALNORM         = 0,$;           --- bool (0/1)
                          HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                          HIST_B_POP_ID            = 0,$;             --- bool
                          HIST_DBLARR_STAR_TYPES   = 0,$;   --- dblarr
                          HIST_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$;   --- dblarr
                          HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                          O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                          DBLARR_VERTICAL_LINES_IN_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = [9.,12.],$
                          DBLARR_VERTICAL_LINES_IN_HIST_PLOT = [9.,12.]






    dblarr_err_idenis = double(strarr_data(*,51))
    ;print,dblarr_err_idenis

  ;  print,'strarr_data(indarr_idenis_ne_99,51) = ',strarr_data(indarr_idenis_ne_99,51)
    indarr = where(dblarr_err_idenis(indarr_idenis_ne_99) lt 9.)
    dbl_err_idenis_mean = mean(dblarr_err_idenis(indarr_idenis_ne_99(indarr)))
    dbl_err_idenis_stddev = stddev(dblarr_err_idenis(indarr_idenis_ne_99(indarr)))
    print,'dbl_err_idenis_mean = ',dbl_err_idenis_mean
    print,'dbl_err_idenis_stddev = ',dbl_err_idenis_stddev
    dbl_err_idenis_max = max(dblarr_err_idenis(indarr_idenis_ne_99(indarr)))
    print,'dbl_err_idenis_max = ',dbl_err_idenis_max

    indarr = where((strarr_data(*,60) eq 'X') or (strarr_data(*,60) eq '8.89'))
    if indarr(0) ge 0 then $
      strarr_data(indarr,60) = strtrim(string(9.99),2)
    indarr = where((strarr_data(*,64) eq 'X') or (strarr_data(*,64) eq '8.89'))
    if indarr(0) ge 0 then $
      strarr_data(indarr,64) = strtrim(string(9.99),2)
    dblarr_err_j2mass = double(strarr_data(*,60))
    dblarr_err_k2mass = double(strarr_data(*,64))
    ;print,'strarr_data(*,64) = ',strarr_data(*,64)
    indarr_j = where(dblarr_err_j2mass(indarr_j2mass_and_k2mass_ne_99) lt 8.,COMPLEMENT=indarr_j_bad)
    print,'n_elements(indarr_j) = ',n_elements(indarr_j)
    dbl_err_j2mass_mean = mean(dblarr_err_j2mass(indarr_j2mass_and_k2mass_ne_99(indarr_j)))
    dbl_err_j2mass_stddev = stddev(dblarr_err_j2mass(indarr_j2mass_and_k2mass_ne_99(indarr_j)))
    print,'dbl_err_j2mass_mean = ',dbl_err_j2mass_mean
    print,'dbl_err_j2mass_stddev = ',dbl_err_j2mass_stddev
    dbl_err_j2mass_max = max(dblarr_err_j2mass(indarr_j2mass_and_k2mass_ne_99(indarr_j)))
    print,'dbl_err_j2mass_max = ',dbl_err_j2mass_max

    indarr_k = where(dblarr_err_k2mass(indarr_j2mass_and_k2mass_ne_99) lt 8.,COMPLEMENT=indarr_k_bad)
    print,'n_elements(indarr_k) = ',n_elements(indarr_k)
    dbl_err_k2mass_mean = mean(dblarr_err_k2mass(indarr_j2mass_and_k2mass_ne_99(indarr_k)))
    dbl_err_k2mass_stddev = stddev(dblarr_err_k2mass(indarr_j2mass_and_k2mass_ne_99(indarr_k)))
    print,'dbl_err_k2mass_mean = ',dbl_err_k2mass_mean
    print,'dbl_err_k2mass_stddev = ',dbl_err_k2mass_stddev
    dbl_err_k2mass_max = max(dblarr_err_k2mass(indarr_j2mass_and_k2mass_ne_99(indarr_k)))
    print,'dbl_err_k2mass_max = ',dbl_err_k2mass_max

    dblarr_err_i2mass = 2.103 * dblarr_err_j2mass(indarr_j2mass_and_k2mass_ne_99) + 1.103 * dblarr_err_k2mass(indarr_j2mass_and_k2mass_ne_99)



    ; --- write output files with I_Input and I_2MASS swaped
    openw,lun,str_filename_out,/GET_LUN
    openw,luna,str_filename_out_ilt12,/GET_LUN
    if strarr_header(0) ne '-1' then begin
      for i=0ul,n_elements(strarr_header)-1 do begin
        printf,lun,strarr_header(i)
      endfor
    endif
  ;  print,'indarr_j2mass_and_k2mass_ne_99 = ',indarr_j2mass_and_k2mass_ne_99
    indarr_bad = indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_bad_i2mass)
    for i_row=0ul, n_elements(indarr_j2mass_and_k2mass_ne_99)-1 do begin
      str_line = strarr_data(i_row,0)
      for i_col=1ul, i_ncols-1 do begin
        if i_col eq i_col_i_input then begin
          str_line = str_line + ' ' + string(dblarr_i2mass(indarr_j2mass_and_k2mass_ne_99(i_row)))
        end else if i_col eq 67 then begin
          str_line = str_line + ' ' + string(dblarr_i_input(indarr_j2mass_and_k2mass_ne_99(i_row)))
        end else if i_col eq 15 then begin
          str_line = str_line + ' ' + string(dblarr_err_i2mass(i_row))
        end else begin
          str_line = str_line + ' ' + strarr_data(indarr_j2mass_and_k2mass_ne_99(i_row),i_col)
        end
      endfor
      indarr_cond = where(indarr_bad eq indarr_j2mass_and_k2mass_ne_99(i_row))
      if indarr_cond(0) lt 0 then begin
        printf,lun,str_line
        if dblarr_i2mass(indarr_j2mass_and_k2mass_ne_99(i_row)) ge 9. and dblarr_i2mass(indarr_j2mass_and_k2mass_ne_99(i_row)) le 12. then begin
          printf,luna,str_line
          b = b+1
        endif
      endif
    endfor
    print,'b = ',b
    print,'percentage of stars with 9 <= I <= 12: ',100. * b / n_elements(indarr_j2mass_and_k2mass_ne_99)

    print,'percentage of stars without DENIS I = ',100. * n_elements(where(abs(dblarr_idenis - 99.) lt 10.)) / n_elements(dblarr_idenis)
    while indarr_k_bad(0) ge 0 do begin
  ;    print,'indarr_k_bad = ',indarr_k_bad
  ;    print,'indarr_j_bad = ',indarr_j_bad
      remove_ith_element_from_array,dblarr_err_i2mass,indarr_k_bad(0)
      remove_element_from_array,indarr_j_bad,indarr_k_bad(0)
      remove_ith_element_from_array,indarr_k_bad,0
  ;    print,'indarr_k_bad = ',indarr_k_bad
  ;    print,'indarr_j_bad = ',indarr_j_bad
    end
    while indarr_j_bad(0) ge 0 do begin
      remove_ith_element_from_array,dblarr_err_i2mass,indarr_j_bad(0)
      remove_ith_element_from_array,indarr_j_bad,0
    end
    dbl_err_i2mass_mean = mean(dblarr_err_i2mass)
    dbl_err_i2mass_stddev = stddev(dblarr_err_i2mass)
    print,'dbl_err_i2mass_mean = ',dbl_err_i2mass_mean
    print,'dbl_err_i2mass_stddev = ',dbl_err_i2mass_stddev
    dbl_err_i2mass_max = max(dblarr_err_i2mass)
    print,'dbl_err_i2mass_max = ',dbl_err_i2mass_max

    free_lun,lun
    free_lun,luna

    indarr_mh = where(strarr_data(*,i_col_mh) lt 80.,COMPLEMENT=indarr_no_mh)
  ;  print,'strarr_data(indarr_no_mh,i_col_mh) = ',strarr_data(indarr_no_mh,i_col_mh)
    print,'n_elements(strarr_data(*,0)) = ',n_elements(strarr_data(*,0))
    print,'n_elements(indarr_mh) = ',n_elements(indarr_mh)

  end
end
