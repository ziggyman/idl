pro rave_replace_imag_with_2mass_dist

  b_breddels = 1

  i_col_i2mass = 14
  i_col_j2mass = 59
  i_col_k2mass = 63
  i_col_ei2mass = 15
  i_col_raveid = 1
  i_col_objectid = 2
  i_col_lon = 5
  i_col_lat = 6

  if b_breddels then begin
    i_col_i_dist = 52
    i_col_j_dist = 21
    i_col_k_dist = 23
    i_col_objectid_dist = 0
    i_col_raveid_dist = 0
    i_col_lon_dist = 3
    i_col_lat_dist = 4
    i_col_ra_dist = 1
    i_col_dec_dist = 2

    str_filename_dist_in = '/suphys/azuri/daten/rave/rave_data/distances/breddels/breddels_minus-ic1-ic2_230-315_-25-25_JmK2MASS_gt_0_5_+stn.dat'
  end else begin
    i_col_i_dist = 12
    i_col_j_dist = 13
    i_col_k_dist = 14
    i_col_objectid_dist = 1
    i_col_raveid_dist = 0
    i_col_lon_dist = 4
    i_col_lat_dist = 5
    str_filename_dist_in = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100430_lon-lat_all-dists_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_minus-ic1-ic2.dat'
;str_filename_dist_in = '/suphys/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter_lon_lat_no_doubles_minerr_230-315_-25-25_JmK2MASS_gt_0_5.dat'
  endelse

  str_filename_in = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20_good_minus_ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr.dat';rave_internal_dr8_all_no_doubles_maxsnr_230-315_-25-25_JmK2MASS_gt_0_5_I2MASS.dat'

  ; --- give outfile a name
  ;     use identification via cross-matching longitude and latitude instead of identifier,
  ;     as there are not many matches if identifiers are used
  str_filename_out = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_I2MASS-lb.dat'
  str_filename_out_ilt12 = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_I2MASS-9ltIlt12-lb.dat'

  strarr_header = strarr(1)
  strarr_header(0) = '-1'
  strarr_header_dist = strarr(1)
  strarr_header_dist(0) = '-1'

  strarr_data = readfiletostrarr(str_filename_in,' ',I_NLines=i_nlines,I_NCols=i_ncols,HEADER=strarr_header)
  strarr_data_dist = readfiletostrarr(str_filename_dist_in,' ',I_NLines=i_nlines_dist,I_NCols=i_ncols_dist,HEADER=strarr_header_dist)

  strarr_raveid = strarr_data(*,i_col_raveid)
  strarr_raveid_dist = strarr_data_dist(*,i_col_raveid_dist)
  strarr_objectid = strarr_data(*,i_col_objectid)
  strarr_objectid_dist = strarr_data_dist(*,i_col_objectid_dist)

  dblarr_lon = double(strarr_data(*,i_col_lon))
  dblarr_lat = double(strarr_data(*,i_col_lat))
  dblarr_lon_dist = double(strarr_data_dist(*,i_col_lon_dist))
  dblarr_lat_dist = double(strarr_data_dist(*,i_col_lat_dist))
  if b_breddels then begin
;    dblarr_ra_dist = double(strarr_data(*,i_col_ra_dist))
;    dblarr_dec_dist = double(strarr_data(*,i_col_dec_dist))
;    euler,dblarr_lon_dist,dblar
    indarr_lon = where(dblarr_lon_dist lt 0.)
    dblarr_lon_dist(indarr_lon) = dblarr_lon_dist(indarr_lon) + 360.
  endif
;  dblarr_lon_dist = dblarr_lon_dist + 180.
;  print,'dblarr_lon_dist = ',dblarr_lon_dist
;  print,'dblarr_lat_dist = ',dblarr_lat_dist

  b = 0ul
  openw,lun,str_filename_out,/GET_LUN
  openw,luna,str_filename_out_ilt12,/GET_LUN
  if strarr_header(0) ne '-1' then begin
    for i=0ul,n_elements(strarr_header_dist)-1 do begin
      str_print = strarr_header_dist(i)
      if b_breddels then begin
        str_print = str_print+' Imag2MASS'
      end
      printf,lun,str_print
    endfor
  endif
  indarr_good = lonarr(n_elements(strarr_raveid_dist))
  indarr_good_dist = lonarr(n_elements(strarr_raveid_dist))
  i_ngood = 0ul
  i_ndoubles = 0ul
  for i=0ul, n_elements(strarr_raveid_dist)-1 do begin
    dblarr_sub = dblarr_lon - dblarr_lon_dist(i)
    ;print,'min(abs(dblarr_sub_lon)) = ',min(abs(dblarr_sub))
    indarr_lon = where(abs(abs(dblarr_sub) - min(abs(dblarr_sub))) lt (1.01 * min(abs(dblarr_sub))))
    indarr_lon = where(abs(dblarr_lon - dblarr_lon_dist(i)) lt 0.0013)
    ;print,'abs(dblarr_lon(indarr_lon(0))=',dblarr_lon(indarr_lon(0)),' - dblarr_lon_dist(i)=',dblarr_lon_dist(i),') = ',abs(dblarr_lon(indarr_lon(0)) - dblarr_lon_dist(i))
    if indarr_lon(0) eq -1 then begin
      print,'PROBLEM: i=',i,': indarr_lon(0) == -1: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
;      stop
    end else begin
      dblarr_sub = dblarr_lat(indarr_lon) - dblarr_lat_dist(i)
      ;print,'min(abs(dblarr_sub_lat)) = ',min(abs(dblarr_sub))
      indarr_lat = where(abs(abs(dblarr_sub) - min(abs(dblarr_sub))) lt (1.01 * min(abs(dblarr_sub))))
      indarr_lat = where(abs(dblarr_lat(indarr_lon) - dblarr_lat_dist(i)) lt 0.0013)
    ;indarr = where((strarr_raveid eq strarr_raveid_dist(i)) or (strarr_objectid eq strarr_objectid_dist(i)) or (strarr_raveid eq strarr_objectid_dist(i)) or (strarr_objectid eq strarr_raveid_dist(i)))
      if indarr_lat(0) eq -1 then begin
        print,'PROBLEM: i=',i,': indarr_lat(0) == -1: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
;      stop
      end else begin
;        print,'abs(dblarr_lat(indarr_lon(indarr_lat(0)))=',dblarr_lat(indarr_lon(indarr_lat(0))),' - dblarr_lat_dist(i)=',dblarr_lat_dist(i),') = ',abs(dblarr_lat(indarr_lon(indarr_lat(0))) - dblarr_lat_dist(i))
        if n_elements(indarr_lat) gt 1 then begin
          print,'PROBLEM: more than 1 star found in rave data'
          print,'strarr_data(indarr_lon(indarr_lat),*) = ',strarr_data(indarr_lon(indarr_lat),0)+' ',strarr_data(indarr_lon(indarr_lat),1)+' ',strarr_data(indarr_lon(indarr_lat),2)+' ',strarr_data(indarr_lon(indarr_lat),3)+' ',strarr_data(indarr_lon(indarr_lat),4)+' ',strarr_data(indarr_lon(indarr_lat),5)
          print,'strarr_data_dist(i,*) = '+strarr_data_dist(i,0)+' '+strarr_data_dist(i,1)+' '+strarr_data_dist(i,2)+' '+strarr_data_dist(i,3)+' '+strarr_data_dist(i,4)
          i_ndoubles = i_ndoubles + 1
          ;stop
        end
        indarr_good(i_ngood) = indarr_lon(indarr_lat(0))
        indarr_good_dist(i_ngood) = i
;        print,'i=',i,': strarr_data(indarr_lon(indarr_lat(0)),*) = ',strarr_data(indarr_lon(indarr_lat(0)),*)
;        print,'i=',i,': strarr_data_dist(i,*) = ',strarr_data_dist(i,*)
        i_ngood = i_ngood + 1
;        print,'i=',i,': found: strarr_raveid_dist(i) = ',strarr_raveid_dist(i),', strarr_objectid_dist(i) = ',strarr_objectid_dist(i)
;        if double(strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)) lt 99. then begin
        print,'old imag = '+strarr_data_dist(i,i_col_i_dist)+', new imag(2mass) = '+strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)
;          strarr_data_dist(i,i_col_i_dist) = strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)
;          strarr_data_dist(i,i_col_j_dist) = strarr_data(indarr_lon(indarr_lat(0)),i_col_j2mass)
;          strarr_data_dist(i,i_col_k_dist) = strarr_data(indarr_lon(indarr_lat(0)),i_col_k2mass)
;        end
        str_line = strarr_data_dist(i,0)
        for i_col=1ul, i_ncols_dist-1 do begin
          if b_breddels and (i_col eq i_col_lon_dist) then begin
            str_line = str_line + ' ' + strtrim(string(dblarr_lon_dist(i)),2)
          end else if i_col eq i_col_i_dist then begin
            str_line = str_line + ' ' + strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)
          end else if i_col eq i_col_j_dist then begin
            str_line = str_line + ' ' + strarr_data(indarr_lon(indarr_lat(0)),i_col_j2mass)
          end else if i_col eq i_col_k_dist then begin
            str_line = str_line + ' ' + strarr_data(indarr_lon(indarr_lat(0)),i_col_k2mass)
          end else begin
            str_line = str_line + ' ' + strarr_data_dist(i,i_col)
          end
        endfor
        print,'I_2MASS = ',strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass),', I_RAVE = ',strarr_data_dist(i,i_col_i_dist)
        printf,lun,str_line
        if (double(strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)) ge 9.) and (double(strarr_data(indarr_lon(indarr_lat(0)),i_col_i2mass)) le 12.) then begin
          printf,luna,str_line
          b = b+1
        endif
      endelse
    endelse
  endfor
  print,'b = ',b
  print,'i_ndoubles = ',i_ndoubles
  free_lun,lun
  free_lun,luna

;  stop

  indarr_good = indarr_good(0:i_ngood-1)
  indarr_good_dist = indarr_good_dist(0:i_ngood-1)
  indarr_i = where((double(strarr_data(indarr_good,i_col_j2mass)) lt 80.) and (double(strarr_data(indarr_good,i_col_k2mass)) lt 80.))
  str_plotname_root = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_I2MASS_vs_Idist'
  compare_two_parameters,double(strarr_data(indarr_good(indarr_i),i_col_i2mass)),$
                         double(strarr_data_dist(indarr_good_dist(indarr_i),i_col_i_dist)),$
                         str_plotname_root,$
                         STR_XTITLE               = 'I!D2MASS!N [mag]',$
                         STR_YTITLE               = 'I!Ddist!N [mag]',$
                         I_PSYM                   = 2,$
                         DBL_SYMSIZE              = 0.05,$
                         DBL_CHARSIZE             = 1.8,$
                         DBL_CHARTHICK            = 3.,$
                         DBL_THICK                = 3.,$
                         DBLARR_XRANGE            = [6.,13.5],$
                         DBLARR_YRANGE            = [6.,13.5],$
                         DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                         DIFF_DBLARR_YRANGE       = [-4.,4.],$
                         DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                         DIFF_STR_YTITLE          = '(I!D2MASS!N - I!Ddist!N) [mag]',$
;                         I_XTICKS                 = i_xticks,$
                         STR_XTICKFORMAT          = '(I2)',$
;                         I_YTICKS                 = i_yticks,$
                         DBL_REJECTVALUEX         = 90.,$;             --- double
                         DBL_REJECTVALUE_X_RANGE  = 30.,$;             --- double
                         DBL_REJECTVALUEY         = 90.,$;             --- double
                         DBL_REJECTVALUE_Y_RANGE  = 30.,$;             --- double
;                         STR_YTICKFORMAT          = str_ytickformat,$
                         B_PRINTPDF               = 1,$;               --- bool (0/1)
                         SIGMA_I_NBINS            = 50,$
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


  str_plotname_root = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_J2MASS_vs_Jdist'
  compare_two_parameters,double(strarr_data(indarr_good(indarr_i),i_col_j2mass)),$
                         double(strarr_data_dist(indarr_good_dist(indarr_i),i_col_j_dist)),$
                         str_plotname_root,$
                         STR_XTITLE               = 'J!D2MASS!N [mag]',$
                         STR_YTITLE               = 'J!Ddist!N [mag]',$
                         I_PSYM                   = 2,$
                         DBL_SYMSIZE              = 0.05,$
                         DBL_CHARSIZE             = 1.8,$
                         DBL_CHARTHICK            = 3.,$
                         DBL_THICK                = 3.,$
                         DBLARR_XRANGE            = [6.,13.5],$
                         DBLARR_YRANGE            = [6.,13.5],$
                         DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                         DIFF_DBLARR_YRANGE       = [-4.,4.],$
                         DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                         DIFF_STR_YTITLE          = '(J!D2MASS!N - J!Ddist!N) [mag]',$
;                         I_XTICKS                 = i_xticks,$
                         STR_XTICKFORMAT          = '(I2)',$
;                         I_YTICKS                 = i_yticks,$
                         DBL_REJECTVALUEX         = 90.,$;             --- double
                         DBL_REJECTVALUE_X_RANGE  = 30.,$;             --- double
                         DBL_REJECTVALUEY         = 90.,$;             --- double
                         DBL_REJECTVALUE_Y_RANGE  = 30.,$;             --- double
;                         STR_YTICKFORMAT          = str_ytickformat,$
                         B_PRINTPDF               = 1,$;               --- bool (0/1)
                         SIGMA_I_NBINS            = 50,$
                         SIGMA_I_MINELEMENTS      = 5,$
                         HIST_I_NBINSMIN          = 20,$;            --- int
                         HIST_I_NBINSMAX          = 30,$;            --- int
                         HIST_STR_XTITLE          = 'J [mag]',$;            --- string
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


  str_plotname_root = strmid(str_filename_dist_in,0,strpos(str_filename_dist_in,'.',/REVERSE_SEARCH))+'_K2MASS_vs_Kdist'
  compare_two_parameters,double(strarr_data(indarr_good(indarr_i),i_col_k2mass)),$
                         double(strarr_data_dist(indarr_good_dist(indarr_i),i_col_k_dist)),$
                         str_plotname_root,$
                         STR_XTITLE               = 'K!D2MASS!N [mag]',$
                         STR_YTITLE               = 'K!Ddist!N [mag]',$
                         I_PSYM                   = 2,$
                         DBL_SYMSIZE              = 0.05,$
                         DBL_CHARSIZE             = 1.8,$
                         DBL_CHARTHICK            = 3.,$
                         DBL_THICK                = 3.,$
                         DBLARR_XRANGE            = [6.,13.5],$
                         DBLARR_YRANGE            = [6.,13.5],$
                         DBLARR_POSITION          = [0.18,0.16,0.99,0.99],$
                         DIFF_DBLARR_YRANGE       = [-4.,4.],$
                         DIFF_DBLARR_POSITION     = [0.18,0.16,0.99,0.99],$
                         DIFF_STR_YTITLE          = '(K!D2MASS!N - K!Ddist!N) [mag]',$
;                         I_XTICKS                 = i_xticks,$
                         STR_XTICKFORMAT          = '(I2)',$
;                         I_YTICKS                 = i_yticks,$
                         DBL_REJECTVALUEX         = 90.,$;             --- double
                         DBL_REJECTVALUE_X_RANGE  = 30.,$;             --- double
                         DBL_REJECTVALUEY         = 90.,$;             --- double
                         DBL_REJECTVALUE_Y_RANGE  = 30.,$;             --- double
;                         STR_YTICKFORMAT          = str_ytickformat,$
                         B_PRINTPDF               = 1,$;               --- bool (0/1)
                         SIGMA_I_NBINS            = 50,$
                         SIGMA_I_MINELEMENTS      = 5,$
                         HIST_I_NBINSMIN          = 20,$;            --- int
                         HIST_I_NBINSMAX          = 30,$;            --- int
                         HIST_STR_XTITLE          = 'K [mag]',$;            --- string
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


end
