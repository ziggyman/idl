pro rave_check_mh_calib
  str_path = '/home/azuri/daten/rave/rave_data/release8/'

  openw,lun,str_path+'check_mh_calib/index.html',/GET_LUN
  printf,lun,'<html><body><center>'
  for i=13,15 do begin
    if i eq 0 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe.dat'
    end else if i eq 1 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe.dat'
    end else if i eq 2 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe.dat'
    end else if i eq 3 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib.dat'
    end else if i eq 4 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_MH-fromFeH-calib.dat'
    end else if i eq 5 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_MH-fromFeH-calib.dat'
    end else if i eq 6 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_MH-fromFeH-calib.dat'
    end else if i eq 7 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_MH-from-FeH.dat'
    end else if i eq 8 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_MH-from-FeH.dat'
    end else if i eq 9 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_MH-from-FeH.dat'
    end else if i eq 10 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_no-FeH.dat'
    end else if i eq 11 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_no-FeH.dat'
    end else if i eq 12 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_no-FeH.dat'
    end else if i eq 13 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-MH-logg-aFe_MH-from-FeH-and-aFe.dat'
    end else if i eq 14 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-mH-logg-aFe_MH-from-FeH-and-aFe.dat'
    end else if i eq 15 then begin
      str_filename_rave = 'rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_calib-STN-Teff-MH-logg-aFe_MH-from-FeH-and-aFe.dat'
    endif
  ;str_filename_bes = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_vrad-from-uvwlb.dat'

    strarr_data_rave = readfiletostrarr(str_path+str_filename_rave,' ')
    dblarr_cmh_rave = double(strarr_data_rave(*,23))
    dblarr_mh_calib_rave = double(strarr_data_rave(*,24))
    dblarr_logg = double(strarr_data_rave(*,20))

    print,'dblarr_cmh_rave(0:10) = ',dblarr_cmh_rave(0:10)

    ;strarr_data_bes = readfiletostrarr(str_filename_bes,' ')
    ;dblarr_mh_bes = double(strarr_data_bes)

    ; --- split data into dwarfs and giants
    rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = dblarr_logg,$
                                        O_INDARR_DWARFS  = indarr_dwarfs,$
                                        O_INDARR_GIANTS  = indarr_giants,$
                                        I_DBL_LIMIT_LOGG = 3.5
    int_loop_end = 0
    if (i eq 1) or (i eq 5) then begin
      dblarr_temp = dblarr_cmh_rave
    end else if (i eq 2) or (i eq 6) then begin
      int_loop_end = 1
    endif
    for k=0,int_loop_end do begin
      if k eq 1 then begin
        dblarr_cmh_rave = dblarr_temp
      endif
      for jj=0,1 do begin
        if jj eq 0 then begin; --- dwarfs
          dblarr_cmh_rave_check = dblarr_cmh_rave(indarr_dwarfs)
          dblarr_mh_calib_rave_check = dblarr_mh_calib_rave(indarr_dwarfs)
        end else begin; --- giants
          dblarr_cmh_rave_check = dblarr_cmh_rave(indarr_giants)
          dblarr_mh_calib_rave_check = dblarr_mh_calib_rave(indarr_giants)
        endelse
        dbl_seed = 5.
        for j=0,13 do begin
          if j eq 0 then begin
            dbl_sigma = 0.
          end else if j eq 1 then begin
            dbl_sigma = -0.05
          end else if j eq 2 then begin
            dbl_sigma = -0.07
          end else if j eq 3 then begin
            dbl_sigma = -0.1
          end else if j eq 4 then begin
            dbl_sigma = -0.12
          end else if j eq 5 then begin
            dbl_sigma = 0.05
          end else if j eq 6 then begin
            dbl_sigma = 0.06
          end else if j eq 7 then begin
            dbl_sigma = 0.1
          end else if j eq 8 then begin
            dbl_sigma = 0.105
          end else if j eq 9 then begin
            dbl_sigma = 0.11
          end else if j eq 10 then begin
            dbl_sigma = 0.13
          end else if j eq 11 then begin
            dbl_sigma = 0.15
          end else if j eq 12 then begin
            dbl_sigma = 0.2
          end else if j eq 13 then begin
            dbl_sigma = 0.25
          endif
          if j gt 0 then begin
            if dbl_sigma gt 0. then begin
              dblarr_cmh_plus_errors_rave = dblarr_cmh_rave_check
              add_noise,IO_DBLARR_DATA        = dblarr_cmh_plus_errors_rave,$
                        I_DBL_SIGMA           = dbl_sigma,$
                        IO_DBL_SEED           = dbl_seed,$
                        I_DBL_DIVIDE_ERROR_BY = 0
              dblarr_x = dblarr_mh_calib_rave_check
              dblarr_y = dblarr_cmh_plus_errors_rave
            end else begin
              dblarr_mh_plus_errors_rave = dblarr_mh_calib_rave_check
              add_noise,IO_DBLARR_DATA        = dblarr_mh_plus_errors_rave,$
                        I_DBL_SIGMA           = 0. - dbl_sigma,$
                        IO_DBL_SEED           = dbl_seed,$
                        I_DBL_DIVIDE_ERROR_BY = 0
              dblarr_x = dblarr_mh_plus_errors_rave
              dblarr_y = dblarr_cmh_rave_check
            endelse
          end else begin
            dblarr_x = dblarr_mh_calib_rave_check
            dblarr_y = dblarr_cmh_rave_check
          endelse
          str_plotname_root = str_path+'check_mh_calib/'+strmid(str_filename_rave,0,strpos(str_filename_rave,'.',/REVERSE_SEARCH))
          if dbl_sigma lt 0 then begin
            dbl_sigma = 0. - dbl_sigma
            if k eq 0 then begin
              str_plotname_root = str_plotname_root + '_cmH-err+'
            end else begin
              str_plotname_root = str_plotname_root + '_cMH-from-mH-calib_and_cmH-from-MH-calib_cmH-err+'
            endelse
          endif else begin
            if k eq 0 then begin
              str_plotname_root = str_plotname_root + '_cMH-err+'
            end else begin
              str_plotname_root = str_plotname_root + '_cMH-from-mH-calib_and_cmH-from-MH-calib_cMH-err+'
            endelse
          endelse
          str_sigma = strmid(strtrim(string(dbl_sigma),2),0,5)
          str_sigma = strmid(str_sigma,0,strpos(str_sigma,'.'))+'_'+strmid(str_sigma,strpos(str_sigma,'.')+1)
          str_plotname_root = str_plotname_root + str_sigma
          if jj eq 0 then begin
            str_plotname_root = str_plotname_root + '_dwarfs'
          end else begin
            str_plotname_root = str_plotname_root + '_giants'
          endelse
          plot_two_histograms,dblarr_x,$; --- RAVE
                              dblarr_y,$; --- BESANCON
                              STR_PLOTNAME_ROOT = str_plotname_root,$;     --- string
                              XTITLE            = '[M/H] [dex]',$;                           --- string
                              YTITLE            = 'Percentage of stars',$;                           --- string
                              I_NBINS           = 50,$;                           --- int
                              ;NBINSMAX=40,$;                       --- int
                              ;NBINSMIN=50,$;                       --- int
                              TITLE             = 0,$;                             --- string
                              XRANGE            = [-2.,1.],$;                           --- dblarr
                              YRANGE            = 0,$;                           --- dblarr
                              MAXNORM           = 0,$;                         --- bool (0/1)
                              TOTALNORM         = 0,$;                     --- bool (0/1)
                              PERCENTAGE        = 1,$;                   --- bool (0/1)
                              REJECTVALUEX      = 0,$;               --- double
                              B_POP_ID          = 0,$;                     --- bool
                              DBLARR_STAR_TYPES = 0,$;     --- dblarr
                              PRINTPDF          = 1,$;                       --- bool (0/1)
                              DEBUGA            = 0,$;                           --- bool (0/1)
                              DEBUGB            = 0,$;                           --- bool (0/1)
                              DEBUG_OUTFILES_ROOT = 0,$; --- string
                              COLOUR              = 1,$;                           --- bool (0/1)
                              B_RESIDUAL          = 0,$;                 --- double
                              I_DBLARR_POSITION   = [0.125,0.16,0.91,0.99],$; --- dblarr[x1,y1,x2,y2]
                              I_DBL_THICK         = 3.,$;
                              I_INT_XTICKS        = 0,$
                              I_STR_XTICKFORMAT   = '(F4.1)',$
                              I_DBL_CHARSIZE      = 1.8,$
                              I_DBL_CHARTHICK     = 3.,$
                              DBLARR_VERTICAL_LINES_IN_PLOT = 0,$
                              B_PRINT_MOMENTS               = 1; --- 0: do not print moments
                                                                          ; --- 1: print moments for both samples in upper left corner
                                                                          ; --- 2: print moments for first sample in upper left corner
                                                                          ; --- 3: print moments for both samples in upper right corner
                                                                          ; --- 4: print moments for first sample in upper right corner

          printf,lun,'<hr><br>'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+': <br>error added: '+strmid(strtrim(string(dbl_sigma),2),0,4)+' dex<br>'
          printf,lun,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
        endfor
      endfor
    endfor
  endfor
  printf,lun,'</center></body></html>'
  free_lun,lun
end
