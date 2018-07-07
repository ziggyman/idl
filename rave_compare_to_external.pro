pro rave_compare_to_external

  ; --- pre: rave_make_datafile_external

  str_filename = '/home/azuri/daten/rave/calibration/all_found.dat'

  str_htmlfile = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/index.html'
  openw,lun_html,str_htmlfile,/GET_LUN
  printf,lun_html,'<html><body><center>'
  ; --- 0: lon,
  ; --- 1: lat,
  ; --- 2: vrad,
  ; --- 3: evrad,
  ; --- 4: Teff,
  ; --- 5: eTeff,
  ; --- 6: logg,
  ; --- 7: elogg,
  ; --- 8: mh,
  ; --- 9: emh,
  ; --- 10: bool_feh,
  ; --- 11: rave_vrad,
  ; --- 12: rave_teff,
  ; --- 13: rave_eteff,
  ; --- 14: rave_logg,
  ; --- 15: rave_elogg,
  ; --- 16: rave_mh,
  ; --- 17: rave_emh,
  ; --- 18: rave_afe,
  ; --- 19: rave_stn,
  ; --- 20: source
  int_col_teff_ext = 4
  int_col_eteff_ext = 5
  int_col_logg_ext = 6
  int_col_elogg_ext = 7
  int_col_mh_ext = 8
  int_col_emh_ext = 9
  int_col_bool_feh_ext = 10
  int_col_afe_ext = 11
  int_col_teff_rave = 13
  int_col_eteff_rave = 14
  int_col_logg_rave = 15
  int_col_elogg_rave = 16
  int_col_mh_rave = 17
  int_col_emh_rave = 18
  int_col_afe_rave = 19
  int_col_stn_rave = 20
  int_col_source_ext = 21
  for iii=0,2 do begin; --- 0: all external sources, 1: minus PASTEL, 2: PASTEL only
    for ii=0,2 do begin; --- 0: all stars, 1: dwarfs, 2: giants
      if ii eq 0 then begin
        b_dwarfs_only = 0
        b_giants_only = 0
      end else if ii eq 1 then begin
        b_dwarfs_only = 1
        b_giants_only = 0
      end else begin
        b_dwarfs_only = 0
        b_giants_only = 1
      endelse
      strarr_data = readfiletostrarr(str_filename,' ')
;      print,'iii = ',iii,': ii = ',ii,': 1. strarr_data = ',strarr_data

      indarr = where((long(strarr_data(*,int_col_source_ext)) ne 3))
      strarr_data = strarr_data(indarr,*)
;      print,'iii = ',iii,': ii = ',ii,': 2. strarr_data = ',strarr_data

      if iii eq 1 then begin; --- external minus pastel
        indarr = where((long(strarr_data(*,int_col_source_ext)) ne 1))
        strarr_data = strarr_data(indarr,*)
      endif
      if iii eq 2 then begin; --- pastel
        indarr = where((long(strarr_data(*,int_col_source_ext)) eq 1))
        strarr_data = strarr_data(indarr,*)
      endif
;      print,'iii = ',iii,': ii = ',ii,': 3. strarr_data = ',strarr_data

      indarr_teff = where(double(strarr_data(*,int_col_teff_ext)) gt 15000.)
      if indarr_teff(0) ge 0 then $
        strarr_data(indarr_teff,int_col_teff_ext) = strtrim(string(0.),2)

      indarr_mh = where(double(strarr_data(*,int_col_mh_rave)) gt 3.)
      if indarr_mh(0) ge 0 then $
        strarr_data(indarr_mh,int_col_mh_rave) = strtrim(string(0.),2)

      strarr_data(*,int_col_elogg_rave) = strtrim(string(0.),2)

      indarr = where(double(strarr_data(*,int_col_teff_ext)) lt 15000.)
      strarr_data = strarr_data(indarr,*)
;      print,'iii = ',iii,': ii = ',ii,': 4. strarr_data = ',strarr_data
      rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = double(strarr_data(*,int_col_logg_rave)),$
                                        O_INDARR_DWARFS  = indarr_dwarfs,$
                                        O_INDARR_GIANTS  = indarr_giants,$
                                        I_DBL_LIMIT_LOGG = 3.5
      if b_dwarfs_only then $
        strarr_data = strarr_data(indarr_dwarfs,*)
      if b_giants_only then $
        strarr_data = strarr_data(indarr_giants,*)
;      print,'iii = ',iii,': ii = ',ii,': 5. strarr_data = ',strarr_data

      dblarr_position = [0.205,0.175,0.932,0.995]
      dblarr_position_diff=[0.205,0.175,0.932,0.995]
      dblarr_position_hist=[0.205,0.175,0.932,0.995]

      indarr = where((abs(double(strarr_data(*,int_col_mh_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_mh_rave))) ge 0.0000001))
      indarr_feh = where(long(strarr_data(indarr, int_col_bool_feh_ext)) eq 1)
            ;if ii eq 0 then begin
      if indarr_feh(0) ge 0 then begin
        dblarr_teff_temp = double(strarr_data(indarr(indarr_feh), int_col_teff_ext))
        indarr_teff = where(abs(dblarr_teff_temp) lt 0.0000001)
        if indarr_teff(0) ge 0 then $
          dblarr_teff_temp(indarr_teff) = double(strarr_data(indarr(indarr_feh(indarr_teff)), int_col_teff_rave))

        dblarr_logg_temp = double(strarr_data(indarr(indarr_feh), int_col_logg_ext))
        indarr_logg = where(abs(dblarr_logg_temp) lt 0.0000001)
        if indarr_logg(0) ge 0 then $
          dblarr_logg_temp(indarr_logg) = double(strarr_data(indarr(indarr_feh(indarr_logg)), int_col_logg_rave))
        besancon_calculate_mh,I_DBLARR_FEH  = double(strarr_data(indarr(indarr_feh), int_col_mh_ext)),$
                              O_DBLARR_MH   = o_dblarr_mh,$ ; --- dblarr
                              I_INT_VERSION = 3,$; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
                              I_DBLARR_TEFF = dblarr_teff_temp,$
                              I_DBLARR_LOGG = dblarr_logg_temp
    ;    besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_feh), int_col_mh_ext)),$
    ;                          O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
    ;                          I_B_MINE                          = 1,$
    ;    ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
    ;    ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
    ;    ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
    ;    ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
    ;                          I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_feh), int_col_logg_rave))
    ;          ;endif
        strarr_data(indarr(indarr_feh), int_col_mh_ext) = strtrim(string(o_dblarr_mh),2)
      endif

      strarr_data(*,int_col_elogg_ext) = 0.
      strarr_data(*,int_col_elogg_rave) = 0.

      for i=0,20 do begin
        int_smooth_mean_sig = 0
        int_sigma_nbins = 20
        int_sigma_minelements = 2
        dbl_sigma_clip = 3.
        b_diff_plot_y_minus_x = 0
        if i eq 0 then begin
          int_col_ext = int_col_teff_ext
          int_col_err_ext = int_col_elogg_ext
          int_col_rave = int_col_teff_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          dblarr_xrange = [3500.,7500.]
          dblarr_yrange = [3500.,7500.]
          dblarr_yrange_diff = [-2000.,2000.]
          dblarr_yrange_hist = 0
          i_xticks = 0
          i_yticks = 4
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
          dblarr_x = double(strarr_data(indarr, int_col_ext))
          dblarr_y = double(strarr_data(indarr, int_col_rave))
          print,'dblarr_x(0:10) = ',dblarr_x(0:10)
          print,'dblarr_y(0:10) = ',dblarr_y(0:10)
          dblarr_yfit = 0
          if b_dwarfs_only then begin
            dblarr_xrange = [4500.,7500.]
            i_xticks = 0
            b_print_moments = 3
            ;i_fit_order_teff_vs_teff = 3
            ;dblarr_coeffs_teff_vs_teff = svdfit(dblarr_x,dblarr_y,i_fit_order_teff_vs_teff,yfit=dblarr_teff_fit);,measure_errors = double(strarr_data(indarr, int_col_err_rave)))
            ;dblarr_yfit = dblarr_teff_fit
          endif
          if b_giants_only then begin
  ;          dblarr_yrange_hist = [0.,10.]
            b_print_moments = 3
            dbl_sigma_clip = 2.5
  ;          dblarr_xrange = [4000.,5000.]
            dblarr_yrange = [3500.,7500.]
            i_yticks = 5
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-ext_vs_Teff-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-ext-minus-pastel_vs_Teff-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-pastel_vs_Teff-RAVE'
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_diff_only = 0
          dblarr_vertical_lines = 0
    ;      stop
        end else if i eq 1 then begin
          int_col_ext = int_col_teff_ext
          int_col_err_ext = int_col_elogg_ext
          int_col_rave = int_col_teff_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'STN'
          str_xtitle_hist = 'T!Deff!N [K]'
          str_ytitle = 'T!Deff, RAVE!N [K]'
          str_ytitle_diff = 'T!Deff, RAVE!N [K]'
          dblarr_xrange = [0.,200.]
          dblarr_yrange = [3500.,7500.]
          dblarr_yrange_diff = [3500.,7500.]
          dblarr_yrange_hist = 0
          i_xticks = 0
          i_yticks = 4
          b_print_moments = 1
          indarr = where(abs(double(strarr_data(*,int_col_rave))) ge 0.0000001)
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_teff_rave))
          print,'dblarr_x(0:10) = ',dblarr_x(0:10)
          print,'dblarr_y(0:10) = ',dblarr_y(0:10)
          dblarr_yfit = 0
          if b_dwarfs_only then begin
            dblarr_yrange_diff = [4500.,7500.]
            i_xticks = 0
            b_print_moments = 3
            ;i_fit_order_teff_vs_teff = 3
            ;dblarr_coeffs_teff_vs_teff = svdfit(dblarr_x,dblarr_y,i_fit_order_teff_vs_teff,yfit=dblarr_teff_fit);,measure_errors = double(strarr_data(indarr, int_col_err_rave)))
            ;dblarr_yfit = dblarr_teff_fit
          endif
          if b_giants_only then begin
  ;          dblarr_yrange_hist = [0.,10.]
            b_print_moments = 3
            dbl_sigma_clip = 2.5
  ;          dblarr_xrange = [4000.,5000.]
            dblarr_yrange_diff = [3500.,7500.]
            i_yticks = 5
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-ext_vs_STN-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-ext-minus-pastel_vs_STN-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/Teff-pastel_vs_STN-RAVE'
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_diff_only = 1
          dblarr_vertical_lines = 0
    ;      stop
        end else if i eq 2 then begin
          int_col_ext = int_col_logg_ext
          int_col_err_ext = int_col_elogg_ext
          int_col_rave = int_col_logg_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = '(log g)!Dext!N [dex]'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!Dext!N - (log g)!DRAVE!N [dex]'
          dblarr_xrange = [-1., 5.7]
          dblarr_yrange = [-1.,6.5]
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          dblarr_yrange_hist = 0
          dblarr_yrange_diff = [-1.5,1.5]
          b_print_moments = 1
          if b_dwarfs_only then begin
            dblarr_xrange = [3.3, 5.1]
            dblarr_yrange = [3., 5.5]
  ;          dblarr_yrange_diff = [-2.,2.]
            str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
          end else if b_giants_only then begin
            dblarr_xrange = [-0.5, 3.8]
            dblarr_yrange_hist = [0.,17.]
            dblarr_yrange = [-1.,4.5]
  ;          dblarr_yrange_diff = [-4.,4.]
            b_print_moments = 3
          endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-ext_vs_logg-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-ext-minus-pastel_vs_logg-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-pastel_vs_logg-RAVE'

          i_xticks = 0
          i_yticks = 0
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
          dblarr_x = double(strarr_data(indarr, int_col_ext))
          dblarr_y = double(strarr_data(indarr, int_col_rave))
          b_diff_only = 0
          dblarr_vertical_lines = 0
          dblarr_yfit = 0
        end else if i eq 3 then begin
          int_col_ext = int_col_logg_ext
          int_col_err_ext = int_col_elogg_ext
          int_col_rave = int_col_logg_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'STN'
          str_xtitle_hist = 'log g [dex]'
          str_ytitle = '(log g)!DRAVE!N [dex]'
          str_ytitle_diff = '(log g)!DRAVE!N [dex]'
          dblarr_xrange = [0., 200.]
          dblarr_yrange = [-1.,6.5]
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          dblarr_yrange_hist = 0
          dblarr_yrange_diff = [-1.,5.5]
          b_print_moments = 1
          if b_dwarfs_only then begin
  ;          dblarr_xrange = [3.3, 5.1]
            dblarr_yrange_diff = [3., 5.5]
  ;          dblarr_yrange_diff = [-2.,2.]
  ;          str_xtickformat = '(F4.1)'
            str_ytickformat = '(F4.1)'
          end else if b_giants_only then begin
  ;          dblarr_xrange = [-0.5, 3.8]
  ;          dblarr_yrange_hist = [0.,17.]
            dblarr_yrange_diff = [-1.,4.5]
  ;          dblarr_yrange_diff = [-4.,4.]
            b_print_moments = 3
          end
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-ext_vs_STN-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-ext-minus-pastel_vs_STN-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/logg-pastel_vs_STN-RAVE'

          i_xticks = 0
          i_yticks = 0
          indarr = where(abs(double(strarr_data(*,int_col_rave))) ge 0.0000001)
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_logg_rave))
          b_diff_only = 1
          dblarr_vertical_lines = 0
          dblarr_yfit = 0
        end else if i eq 4 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_elogg_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = '[M/H]!Dext!N [dex]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [-2., 0.5]
          dblarr_yrange = [-2.5, 0.5]
          dblarr_yrange_diff = [-2.,2.]
          dblarr_yrange_hist = 0
          if b_dwarfs_only then begin
            dblarr_xrange = [-2.,0.5]
          endif
  ;        if b_giants_only then $
  ;          dblarr_yrange_hist = [0.,21.]
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-ext_vs_MH-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-ext-minus-pastel_vs_MH-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-pastel_vs_MH-RAVE'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(F6.1)'
          str_ytickformat = '(F6.1)'
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
  ;        if ii eq 0 then begin
          rave_calibrate_metallicities,I_DBLARR_MH = double(strarr_data(*,int_col_rave)),$
                                        I_DBLARR_AFE = double(strarr_data(*,int_col_rave+2)),$
                                        I_DBLARR_TEFF=double(strarr_data(*,int_col_rave-4)),$; --- new calibration
                                        I_DBLARR_LOGG=double(strarr_data(*,int_col_rave-2)),$; --- old calibration
                                        I_DBLARR_STN = double(strarr_data(*,int_col_rave+3)),$; --- calibration from DR3 paper
                                        O_STRARR_MH_CALIBRATED=strarr_mh_rave_calibrated,$;           --- string array
                                        I_DBL_REJECTVALUE=9.99,$; --- double
                                        I_DBL_REJECTERR=1,$;       --- double
                                        I_B_SEPARATE=1
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
          dblarr_y = double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 0
          dblarr_vertical_lines = 0
        end else if i eq 5 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'STN!DRAVE!N'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!DRAVE!N [dex]'
          dblarr_xrange = [0., 200.]
          dblarr_yrange = [-2.5, 0.5]
          dblarr_yrange_diff = [-2.,2.]
          dblarr_yrange_hist = 0
  ;        if b_dwarfs_only then begin
  ;          dblarr_yrange_diff = [-1.,1.]
  ;        endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-ext_vs_STN-RAVE'
          if iii eq 1 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-ext-minus-pastel_vs_STN-RAVE'
          if iii eq 2 then $
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/MH-pastel_vs_STN-RAVE'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(F4.1)'
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = 0
        end else if i eq 12 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'T!Deff, ext!N [K]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [3500., 7500.]
          dblarr_yrange = [-2.5, 0.5]
          dblarr_yrange_diff = [-2.,2.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'/',/REVERSE_SEARCH))+'/rave-external/dMH_vs_Teff-ext'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          if b_dwarfs_only then begin
            dblarr_xrange = [4300., 7200.]
  ;          dblarr_yrange_diff = [-1.,1.]
          end else if b_giants_only then begin
            dblarr_xrange = [3500., 7200.]
  ;          dblarr_yrange_diff = [-1.,1.]
          endif
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_teff_ext))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = 0
        end else if i eq 13 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'T!Deff, ext!N - T!Deff, RAVE!N [K]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [-2000., 2000.]
          dblarr_yrange = [-2.5, 0.5]
          dblarr_yrange_diff = [-2.,2.]
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_dTeff'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
  ;        if b_dwarfs_only then begin
  ;          dblarr_xrange = [4300., 7200.]
  ;;          dblarr_yrange_diff = [-1.,1.]
  ;        end else if b_giants_only then begin
  ;          dblarr_xrange = [3500., 7200.]
  ;;          dblarr_yrange_diff = [-1.,1.]
  ;        end
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_teff_ext))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_teff_ext)) - double(strarr_data(indarr, int_col_teff_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = [0.0000001]
        end else if i eq 14 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = '(log g)!Dext!N [K]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [-1., 5.7]
          dblarr_yrange = [-2.5, 0.5]
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          dblarr_yrange_diff = [-2.,2.]
          if b_dwarfs_only then begin
            dblarr_xrange = [3.5, 5.]
            dblarr_yrange = [3., 6.5]
  ;          dblarr_yrange_diff = [-1.,1.]
            str_xtickformat = '(F4.1)'
          end else if b_giants_only then begin
            dblarr_xrange = [-1., 4.5]
            dblarr_yrange = [-1., 4.5]
          endif
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_logg-ext'
          i_xticks = 0
          i_yticks = 0
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_logg_ext))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_logg_ext))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = 0
        end else if i eq 15 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = '(log g)!Dext!N - (log g)!DRAVE!N [K]'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [-2., 2.]
          dblarr_yrange = [-2.5, 0.5]
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          dblarr_yrange_diff = [-2.,2.]
  ;        if b_dwarfs_only then begin
  ;          dblarr_xrange = [3.5, 5.]
  ;          dblarr_yrange = [3., 6.5]
  ;;          dblarr_yrange_diff = [-1.,1.]
  ;          str_xtickformat = '(F4.1)'
  ;        end else if b_giants_only then begin
  ;          dblarr_xrange = [-1., 4.5]
  ;          dblarr_yrange = [-1., 4.5]
  ;        end
          dblarr_yrange_hist = 0
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_dlogg'
          i_xticks = 0
          i_yticks = 0
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_logg_ext))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_logg_ext)) - double(strarr_data(indarr, int_col_logg_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = 0
        end else if i eq 16 then begin
          dblarr_yfit = 0
          int_col_ext = int_col_mh_ext
          int_col_err_ext = int_col_emh_ext
          int_col_rave = int_col_mh_rave
          int_col_err_rave = int_col_elogg_rave
          str_xtitle = 'STN!DRAVE!N'
          str_xtitle_hist = '[M/H] [dex]'
          str_ytitle = '[M/H]!DRAVE!N [dex]'
          str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
          dblarr_xrange = [0., 200.]
          dblarr_yrange = [-2.5, 0.5]
          dblarr_yrange_diff = [-2.,2.]
          dblarr_yrange_hist = 0
  ;        if b_dwarfs_only then begin
  ;          dblarr_yrange_diff = [-1.,1.]
  ;        endif
          str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_dMH_vs_STN-RAVE'
          i_xticks = 0
          i_yticks = 0
          str_xtickformat = '(I6)'
          str_ytickformat = '(I6)'
          b_print_moments = 1
          indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
  ;        if ii eq 0 then begin
  ;        strarr_data(indarr, int_col_rave) = output
          dblarr_x = double(strarr_data(indarr, int_col_stn_rave))
          dblarr_y = double(strarr_data(indarr, int_col_mh_ext)) - double(strarr_mh_rave_calibrated(indarr))
          b_diff_only = 1
          dblarr_vertical_lines = 0
        end else if i eq 17 then begin
          dblarr_yfit = 0
          if not(b_dwarfs_only) and not(iii eq 2) then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_emh_ext
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRAVE!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRAVE!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-2.,2.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
  ;          if b_giants_only then begin
  ;            dblarr_yrange_hist = [0.,21.]
  ;          endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext-no-FeH_vs_MH-RAVE-giants'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            b_diff_only = 0
            dblarr_vertical_lines = 0
          endif
        end else if i eq 18 then begin
          dblarr_yfit = 0
          if not(b_dwarfs_only) and not(iii eq 2) then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_emh_ext
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DZwitter!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DZwitter!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-2.,2.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
    ;        if b_giants_only then begin
    ;          dblarr_yrange_hist = [0.,21.]
    ;        endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext_vs_MH-RAVE-giants-from-FeH-Zwitter'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
            besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_giants), int_col_mh_rave)),$
                                  O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                                  I_INT_VERSION                     = 1; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(o_dblarr_mh),2)
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            print,'dblarr_x = ',dblarr_x
            print,'dblarr_y = ',dblarr_y
    ;        if b_giants_only then $
    ;          stop
            b_diff_only = 0
            dblarr_vertical_lines = 0
          endif
        end else if i eq 19 then begin
          dblarr_yfit = 0
          if not(b_dwarfs_only) and not(iii eq 2) then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_emh_ext
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRitter, chem!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRitter, chem!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-2.,2.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
  ;          if b_giants_only then begin
  ;            dblarr_yrange_hist = [0.,21.]
  ;          endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext_vs_MH-RAVE-giants-from-FeH-mine-chem'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
              besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_giants), int_col_mh_rave)),$
                                    O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                                    I_INT_VERSION                     = 2,$; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
                                    ;I_B_MINE                          = 1,$
      ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
      ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
                                    I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_giants), int_col_logg_rave))
    ;        strarr_data(indarr, int_col_rave) = output
    ;        dblarr_x = o_dblarr_mh
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(o_dblarr_mh),2)
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            b_diff_only = 0
            dblarr_vertical_lines = 0
          endif
        end else if i eq 20 then begin
          dblarr_yfit = 0
          if not(b_dwarfs_only) and not(iii eq 2) then begin
            int_col_ext = int_col_mh_ext
            int_col_err_ext = int_col_emh_ext
            int_col_rave = int_col_mh_rave
            int_col_err_rave = int_col_elogg_rave
            str_xtitle = '[M/H]!Dext!N [dex]'
            str_xtitle_hist = '[M/H] [dex]'
            str_ytitle = '[M/H]!DRitter, S&G!N [dex]'
            str_ytitle_diff = '[M/H]!Dext!N - [M/H]!DRitter, S&G!N [dex]'
            dblarr_xrange = [-2., 0.5]
            dblarr_yrange = [-2., 0.5]
            dblarr_yrange_diff = [-2.,2.]
            dblarr_yrange_hist = 0
    ;        if b_dwarfs_only then begin
    ;          dblarr_yrange_diff = [-1.,1.]
    ;        endif
  ;          if b_giants_only then begin
  ;            dblarr_yrange_hist = [0.,21.]
  ;          endif
            str_plotname_root = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_MH-ext_vs_MH-RAVE-giants-from-FeH-mine-S+G'
            i_xticks = 0
            i_yticks = 0
            str_xtickformat = '(F6.1)'
            str_ytickformat = '(F6.1)'
            b_print_moments = 1
            indarr = where((abs(double(strarr_data(*,int_col_ext))) ge 0.0000001) and (abs(double(strarr_data(*,int_col_rave))) ge 0.0000001))
    ;        if ii eq 0 then begin
            indarr_giants = where(double(strarr_data(indarr, int_col_logg_rave)) lt 3.5)
              besancon_calculate_mh,I_DBLARR_FEH                      = double(strarr_data(indarr(indarr_giants), int_col_mh_rave)),$
                                    O_DBLARR_MH                       = o_dblarr_mh,$ ; --- dblarr
                                    I_INT_VERSION                     = 3,$; --- 1: Zwitter, 2: Mine from chemical, 3: Mine from Soubiran
                                    ;I_B_MINE                          = 1,$
      ;                            I_DBLARR_COEFFS_DWARFS            = i_dblarr_coeffs_dwarfs,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_POOR = i_dblarr_coeffs_giants_metal_poor,$
      ;                            I_DBLARR_COEFFS_GIANTS_METAL_RICH = i_dblarr_coeffs_giants_metal_rich,$
      ;                            I_DBLARR_COEFFS_GIANTS_VERY_METAL_RICH = i_dblarr_coeffs_giants_very_metal_rich,$
                                    I_DBLARR_LOGG                     = double(strarr_data(indarr(indarr_giants), int_col_logg_rave)),$
                                    I_DBLARR_TEFF                     = double(strarr_data(indarr(indarr_giants), int_col_teff_rave))
    ;        strarr_data(indarr, int_col_rave) = output
    ;        dblarr_x = o_dblarr_mh
            indarr = indarr(indarr_giants)
            dblarr_x = double(strarr_data(indarr, int_col_mh_ext))
            strarr_mh_rave_calibrated(indarr) = strtrim(string(o_dblarr_mh),2)
            dblarr_y = double(strarr_mh_rave_calibrated(indarr))
            indarr_mh = where(long(strarr_data(indarr,int_col_bool_feh_ext)) eq 0)
            indarr = indarr(indarr_mh)
            dblarr_x = dblarr_x(indarr_mh)
            dblarr_y = dblarr_y(indarr_mh)
            b_diff_only = 0
            dblarr_vertical_lines = 0
          endif
        endif
        if b_dwarfs_only then begin
          str_plotname_root = str_plotname_root + '_dwarfs'
        end else if b_giants_only then begin
          str_plotname_root = str_plotname_root + '_giants'
        end
        if int_smooth_mean_sig gt 0 then $
          str_plotname_root = str_plotname_root + '_' + strtrim(string(long(int_smooth_mean_sig)),2) + 'smoothings'
        if not(b_dwarfs_only and (i ge 22)) and not((iii eq 2) and (i ge 22)) then begin
          print,'iii = ',iii,': ii = ',ii,': calculating '+str_plotname_root
;          print,'iii = ',iii,': ii = ',ii,': dblarr_x = ',dblarr_x
;          print,'iii = ',iii,': ii = ',ii,': dblarr_y = ',dblarr_y
          compare_two_parameters,dblarr_x,$
                                dblarr_y,$
                                str_plotname_root,$
                                DBLARR_ERR_X             = double(strarr_data(indarr, int_col_err_ext)),$
                                DBLARR_ERR_Y             = double(strarr_data(indarr, int_col_err_rave)),$
                                DBLARR_RAVE_SNR          = double(strarr_data(indarr, int_col_stn_rave)),$
                                STR_XTITLE               = str_xtitle,$
                                STR_YTITLE               = str_ytitle,$
                                STR_TITLE                = 1,$
                                I_PSYM                   = 2,$
                                DBL_SYMSIZE              = 1.,$
                                DBL_CHARSIZE             = 1.8,$
                                DBL_CHARTHICK            = 3.,$
                                DBL_THICK                = 3.,$
                                DBLARR_XRANGE            = dblarr_xrange,$
                                DBLARR_YRANGE            = dblarr_yrange,$
                                DBLARR_POSITION          = dblarr_position,$
                                DIFF_DBLARR_YRANGE       = dblarr_yrange_diff,$
                                DIFF_DBLARR_POSITION     = dblarr_position_diff,$
                                DIFF_STR_YTITLE          = str_ytitle_diff,$
                                I_B_DIFF_PLOT_Y_MINUS_X  = 0,$
                                I_XTICKS                 = i_xticks,$
                                STR_XTICKFORMAT          = str_xtickformat,$
                                I_YTICKS                 = i_yticks,$
                                DBL_REJECTVALUEX         = 0.,$;             --- double
                                DBL_REJECTVALUE_X_RANGE  = 0.0000001,$;             --- double
                                ;DBL_REJECTVALUEY         = dbl_rejectvaluex,$;             --- double
                                ;DBL_REJECTVALUE_Y_RANGE  = dbl_rejectvalue_y_range,$;             --- double
                                STR_YTICKFORMAT          = str_ytickformat,$
                                B_PRINTPDF               = 1,$;               --- bool (0/1)
                                SIGMA_I_NBINS            = int_sigma_nbins,$
                                I_INT_SMOOTH_MEAN_SIG    = int_smooth_mean_sig,$
                                SIGMA_I_MINELEMENTS      = int_sigma_minelements,$
                                I_DBL_SIGMA_CLIP         = dbl_sigma_clip,$
                                O_DBLARR_DIFF_MEAN_SIGMA = o_dblarr_diff_mean_sigma,$
                                I_B_USE_WEIGHTED_MEAN    = 0,$
                                HIST_I_NBINSMIN          = 20,$;            --- int
                                HIST_I_NBINSMAX          = 25,$;            --- int
                                HIST_STR_XTITLE          = str_xtitle_hist,$;            --- string
                                ;HIST_B_MAXNORM           = hist_b_maxnorm,$;             --- bool (0/1)
                                ;HIST_B_TOTALNORM         = hist_b_totalnorm,$;           --- bool (0/1)
                                HIST_B_PERCENTAGE        = 1,$;          --- bool (0/1)
                                ;HIST_B_POP_ID            = 0,$;             --- bool
                                ;HIST_DBLARR_STAR_TYPES   = hist_dblarr_star_types,$;   --- dblarr
                                HIST_DBLARR_XRANGE       = dblarr_xrange,$
                                HIST_DBLARR_YRANGE       = dblarr_yrange_hist,$
                                HIST_DBLARR_POSITION     = dblarr_position_hist,$;   --- dblarr
                                ;HIST_B_RESIDUAL          = hist_b_residual,$;            --- double
                                O_STR_PLOTNAME_HIST      = o_str_plotname_hist,$
                                ;DBLARR_VERTICAL_LINES_IN_PLOT    = dblarr_vertical_lines_in_plot,$
                                DBLARR_VERTICAL_LINES_IN_DIFF_PLOT = dblarr_vertical_lines,$
                                ;DBLARR_VERTICAL_LINES_IN_HIST_PLOT = dblarr_vertical_lines_in_hist_plot,$
                                I_DBLARR_YFIT                      = dblarr_yfit,$
                                B_PRINT_MOMENTS                    = b_print_moments,$
                                I_DO_SIGMA_CLIPPING                = 1,$
                                O_INDARR_Y_GOOD                    = o_indarr_y_good,$
                                I_INTARR_SYMBOLS                   = long(strarr_data(indarr,int_col_source_ext)),$
                                ;I_DBL_REJECT_DIFF_STARS_BELOW      = i_dbl_reject_diff_stars_below,$
                                ;I_DBL_REJECT_DIFF_STARS_ABOVE      = i_dbl_reject_diff_stars_above,$
                                B_DIFF_ONLY                        = b_diff_only;,$; --- dblarr_y given as dblarr_x-<some_parameter>
                                ;I_DBLARR_LINES_IN_DIFF_PLOT        = i_dblarr_lines_in_diff_plot
          wait,1
          reduce_pdf_size,str_plotname_root+'_diff.pdf',str_plotname_root+'_diff_small.pdf'
          if not b_diff_only then begin
            wait,1
            reduce_pdf_size,str_plotname_root+'.pdf',str_plotname_root+'_small.pdf'
            reduce_pdf_size,o_str_plotname_hist+'.pdf',o_str_plotname_hist+'_small.pdf'
          endif
          printf,lun_html,'<br><hr><br>'+strtrim(string(iii),2)+': '+strtrim(string(ii),2)+': '+strtrim(string(i),2)+': '+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'<br>'
          printf,lun_html,'Correlation coefficient = '+strtrim(string(correlate(dblarr_x,dblarr_y)),2)+'<br>'
          if not b_diff_only then $
            printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'
          printf,lun_html,'<a href="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"><img src="'+strmid(str_plotname_root,strpos(str_plotname_root,'/',/REVERSE_SEARCH)+1)+'_diff.gif"></a><br>'
          if not b_diff_only then $
            printf,lun_html,'<a href="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"><img src="'+strmid(o_str_plotname_hist,strpos(o_str_plotname_hist,'/',/REVERSE_SEARCH)+1)+'.gif"></a><br>'

          indarr_good = where(abs(o_dblarr_diff_mean_sigma(*,3) ge int_sigma_minelements) gt 0.01)
          dbl_mean = 0.
          dbl_sigma = 0.;mean(o_dblarr_diff_mean_sigma(indarr_good(indarr_meansig),1))
          int_nstars_all = total(o_dblarr_diff_mean_sigma(*,3))
          for kkkk = 0, n_elements(o_dblarr_diff_mean_sigma(*,0))-1 do begin
            dbl_weight = o_dblarr_diff_mean_sigma(kkkk,3) / double(int_nstars_all)
            dbl_mean = dbl_mean + o_dblarr_diff_mean_sigma(kkkk,1) * dbl_weight
            dbl_sigma = dbl_sigma + o_dblarr_diff_mean_sigma(kkkk,2) * dbl_weight
          endfor
  ;        dblarr_moments_mean = moment(o_dblarr_diff_mean_sigma(indarr_good,0))
  ;        indarr_meansig = where(abs(o_dblarr_diff_mean_sigma(indarr_good,0) - dbl_mean) lt (3. * sqrt(dblarr_moments_mean(1))))
  ;        dbl_mean = mean(o_dblarr_diff_mean_sigma(indarr_good(indarr_meansig),0))
  ;        dblarr_moments_sigma = moment(o_dblarr_diff_mean_sigma(indarr_good,1))
  ;        indarr_meansig = where(abs(o_dblarr_diff_mean_sigma(indarr_good,0) - dblarr_moments_sigma(0)) lt (3. * sqrt(dblarr_moments_sigma(1))))
  ;        dbl_sigma = 0.;mean(o_dblarr_diff_mean_sigma(indarr_good(indarr_meansig),1))
  ;        printf,lunmeansig,'mean: ',dbl_mean,dbl_sigma
          print,'mean: ',dbl_mean,dbl_sigma

        endif
      endfor
  ;    free_lun,lunmeansig
    endfor
  endfor
  ;  str_filenames = [str_soubiran, str_pastel, str_echelle, str_gcs]
  for i=0,8 do begin
    if i eq 0 then begin
      print,'Soubiran: '
    end else if i eq 1 then begin
      print,'PASTEL: '
    end else if i eq 2 then begin
      print,'Echelle: '
    end else if i eq 3 then begin
      print,'GCS: '
    end else begin
      print,'i=',i
    end
    indarr = where(long(strarr_data(*,int_col_source_ext)) eq i)
    if indarr(0) ge 0 then begin
      print,n_elements(indarr),' stars'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_teff_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with Teff'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_logg_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with logg'
      indarr_teff = where(abs(double(strarr_data(indarr,int_col_logg_ext))) gt 0.00001)
      print,n_elements(indarr_teff),' stars with [M/H] / [Fe/H]'
    endif
  endfor
  printf,lun_html,'</center></body></html>'
  free_lun,lun_html
end
