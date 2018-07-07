pro rave_replace_imag_with_denis

  b_chem = 0

  i_col_i_input = 14
  i_col_idenis = 50
  i_col_jdenis = 52
  i_col_kdenis = 54
  i_col_j2mass = 59
  i_col_k2mass = 63

  if b_chem then begin
    str_filename_in = '/suphys/azuri/daten/rave/rave_data/abundances/RAVE_abd_imag_frac_gt_70_230-315_-25-25_JmK2MASS_gt_0_5.dat'
  end else begin
    str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5.dat'
  endelse
  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_IDenis2MASS.dat'
  ;str_filename_out_rave = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_IDenis2MASS.dat'
  str_filename_out_ilt12 = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_I2MASS_9ltIlt12.dat'

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
  dblarr_idenis = double(strarr_data(*,i_col_idenis))
  dblarr_jdenis = double(strarr_data(*,i_col_jdenis))
  dblarr_kdenis = double(strarr_data(*,i_col_kdenis))
  dblarr_j2mass = double(strarr_data(*,i_col_j2mass))
;  print,'strarr_data(*,i_col_k2mass) = ',strarr_data(*,i_col_k2mass)
  dblarr_k2mass = double(strarr_data(*,i_col_k2mass))

  ; --- calculate I_2MASS from J_2MASS and K_2MASS
  dblarr_i2mass = dblarr_j2mass + 1.103 * (dblarr_j2mass - dblarr_k2mass)+0.07

  indarr_j2mass_and_k2mass_ne_99 = where((abs(dblarr_j2mass - 99.) gt 10.) and (abs(dblarr_k2mass - 99.) gt 10.),COMPLEMENT=indarr_j2mass_or_k2mass_eq_99)

  indarr_j2mass_and_k2mass_and_idenis_ne_99 = where((abs(dblarr_j2mass - 99.) gt 10.) and (abs(dblarr_k2mass - 99.) gt 10.) and (abs(dblarr_idenis - 99.) gt 10.),COMPLEMENT=indarr_j2mass_or_k2mass_or_idenis_eq_99)

  indarr_jdenis_or_kdenis_and_j2mass_or_k2mass_eq99 = where((abs(dblarr_jdenis(indarr_j2mass_or_k2mass_eq_99)-99.) lt 10.) or (abs(dblarr_kdenis(indarr_j2mass_or_k2mass_eq_99)-99.) lt 10.),COMPLEMENT=indarr_jdenis_and_kdenis_ne99_and_j2mass_or_k2mass_eq99)

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
                         DIFF_STR_YTITLE          = 'I!DDENIS!N - I!D2MASS!N [mag]',$
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
                         O_STR_PLOTNAME_HIST      = o_str_plotname_hist


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
                         DIFF_STR_YTITLE          = 'I!DDENIS!N - I!D2MASS!N [mag]',$
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
                         O_STR_PLOTNAME_HIST      = o_str_plotname_hist


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
                         DIFF_STR_YTITLE          = 'I!DDENIS!N - I!D2MASS!N [mag]',$
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
                         O_STR_PLOTNAME_HIST      = o_str_plotname_hist


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
;  dblarr_temp = (dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99)) - (dblarr_j2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99) - dblarr_k2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99))

;  indarr_bad_idenis = where(dblarr_temp le -0.2 or dblarr_temp ge 0.6)


  ;dblarr_idenis(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_bad_idenis)) = dblarr_i2mass(indarr_j2mass_and_k2mass_and_idenis_ne_99(indarr_bad_idenis))
  dblarr_idenis = dblarr_i2mass




  ; --- replace I_DENIS == 99. with I_2MASS and store indices where I_2MASS is not available for these stars in indarr_bad
;  indarr = where(abs(dblarr_idenis - 99.) lt 10.)
  indarr_bad = indarr_j2mass_and_k2mass_ne_99;lonarr(n_elements(dblarr_idenis))






;  print,'indarr = where(dblarr_idenis ge 99.) = ',indarr
;  print,'n_elements(indarr) = ',n_elements(indarr)
;  ind = 0
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
  ; --- write output files with I_Input and I_Denis swaped
  openw,lun,str_filename_out,/GET_LUN
  openw,luna,str_filename_out_ilt12,/GET_LUN
  if strarr_header(0) ne '-1' then begin
    for i=0ul,n_elements(strarr_header)-1 do begin
      printf,lun,strarr_header(i)
    endfor
  endif
  for i_row=0ul, n_elements(dblarr_idenis)-1 do begin
    str_line = strarr_data(i_row,0)
    for i_col=1ul, i_ncols-1 do begin
      if i_col eq i_col_i_input then begin
        str_line = str_line + ' ' + string(dblarr_idenis(i_row))
      end else if i_col eq i_col_idenis then begin
        str_line = str_line + ' ' + string(dblarr_i_input(i_row))
      end else begin
        str_line = str_line + ' ' + strarr_data(i_row,i_col)
      end
    endfor
    if ind gt 0 then begin
      indarr_temp = where(indarr_bad eq i_row)
    end else begin
      indarr_temp = lonarr(1)
      indarr_temp(0) = -1
    endelse
    if indarr_temp(0) lt 0 then begin
      printf,lun,str_line
      if dblarr_idenis(i_row) ge 9. and dblarr_idenis(i_row) le 12. then begin
        printf,luna,str_line
        b = b+1
      endif
    endif
  endfor
  print,'b = ',b
  free_lun,lun
  free_lun,luna
end
