pro plot_two_histograms,dblarr_data_a,$; --- RAVE
                        dblarr_data_b,$; --- BESANCON
                        STR_PLOTNAME_ROOT=str_plotname_root,$;     --- string
                        XTITLE=xtitle,$;                           --- string
                        YTITLE=ytitle,$;                           --- string
                        I_NBINS=i_nbins,$;                           --- int
                        NBINSMAX=nbinsmax,$;                       --- int
                        NBINSMIN=nbinsmin,$;                       --- int
                        TITLE=title,$;                             --- string
                        XRANGE=xrange,$;                           --- dblarr
                        YRANGE=yrange,$;                           --- dblarr
                        MAXNORM=maxnorm,$;                         --- bool (0/1)
                        TOTALNORM=totalnorm,$;                     --- bool (0/1)
                        PERCENTAGE=percentage,$;                   --- bool (0/1)
                        REJECTVALUEX=rejectvaluex,$;               --- double
                        B_POP_ID = b_pop_id,$;                     --- bool
                        DBLARR_STAR_TYPES=dblarr_star_types,$;     --- dblarr
                        PRINTPDF=printpdf,$;                       --- bool (0/1)
                        DEBUGA=debuga,$;                           --- bool (0/1)
                        DEBUGB=debugb,$;                           --- bool (0/1)
                        DEBUG_OUTFILES_ROOT=debug_outfiles_root,$; --- string
                        COLOUR=colour,$;                           --- bool (0/1)
                        B_RESIDUAL=b_residual,$;                 --- double
                        I_DBLARR_POSITION = i_dblarr_position,$; --- dblarr[x1,y1,x2,y2]
                        I_DBL_THICK = i_dbl_thick,$;
                        I_INT_XTICKS = i_int_xticks,$
                        I_STR_XTICKFORMAT = i_str_xtickformat,$
                        I_DBL_CHARSIZE = i_dbl_charsize,$
                        I_DBL_CHARTHICK = i_dbl_charthick,$
                        DBLARR_VERTICAL_LINES_IN_PLOT = dblarr_vertical_lines_in_plot,$
                        B_PRINT_MOMENTS               = b_print_moments; --- 0: do not print moments
                                                                       ; --- 1: print moments for both samples in upper left corner
                                                                       ; --- 2: print moments for first sample in upper left corner
                                                                       ; --- 3: print moments for both samples in upper right corner
                                                                       ; --- 4: print moments for first sample in upper right corner
;
; NAME:                  plot_two_histograms.pro
; PURPOSE:               plots histograms
; CATEGORY:              rave
; CALLING SEQUENCE:      plot_two_histograms
; INPUTS:                dblarr_data_a... 1-D array (to be normalised)
;                        dblarr_data_b... 1-D array
;                        str_plotname_root... root file name for output plot
;                        XTITLE... xtitle
;                        YTITLE... ytitle
;                        NBINS...  number of bins
;                        TITLE... plot title
;                        XRANGE... xrange
;                        YRANGE... yrange
;                        MAXNORM... normalise to maximum of dblarr_data_b
;                        TOTALNORM... normalise to total number of dblarr_data_b
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008
;
;                        headline
;                        feetline (up to now not used)
;

;  print,'plot_two_histograms: dblarr_data = ',dblarr_data

;  print,'n_elements(dblarr_data_a) = ',n_elements(dblarr_data_a)
;  print,'n_elements(dblarr_data_b) = ',n_elements(dblarr_data_b)
;  print,'n_elements(dblarr_star_types) = ',n_elements(dblarr_star_types)
;  stop

  if n_elements(dblarr_data_a) lt 1 then begin
    problem = 1
    return
  end
; --- parameters
  if keyword_set(I_DBL_CHARSIZE) then begin
    dbl_charsize = i_dbl_charsize
  end else begin
    dbl_charsize = 2.
  end
  if keyword_set(I_DBL_CHARTHICK) then begin
    dbl_charthick = i_dbl_charthick
  end else begin
    dbl_charthick = 2.
  end
  if keyword_set(I_DBL_THICK) then begin
    dbl_thick = i_dbl_thick
  end else begin
    dbl_thick = 2.
  end
  if keyword_set(I_NBINS) then begin
    nbins = i_nbins
;    print,'plot_two_histograms: nbins = ',nbins
    ;stop
  end else begin
;    print,'plot_two_histograms: Calculating data bin width'
    nbins = 1
    dbl_bin_width = 1.
    if n_elements(dblarr_data_a) eq 1 then begin
      if dblarr_data_a eq 0 then begin
        dblarr_data_a = [0.,1.]
      endif
    endif
    if n_elements(dblarr_data_b) eq 1 then begin
      if dblarr_data_b eq 0 then begin
        dblarr_data_b = [0.,1.]
      endif
    endif
;    print,'n_elements(dblarr_data_b) = ',n_elements(dblarr_data_b)
;    print,'n_elements(dblarr_star_types) = ',n_elements(dblarr_star_types)
;    stop
    get_bin_width,DBLARR_DATA_A=dblarr_data_a,$; --- in
                  DBLARR_DATA_B=dblarr_data_b,$; --- in
                  DBLARR_BIN_RANGE=xrange,$; --- in
                  I_NBINS_MIN=nbinsmin,$; --- in
                  I_NBINS_MAX=nbinsmax,$; --- in
                  DBL_BIN_WIDTH=dbl_bin_width,$; --- out
                  NBINS=nbins; --- out
;    openw,luna,'debug_plot_two_histograms.test',/GET_LUN
;      print,'plot_two_histograms: dbl_bin_width = ',dbl_bin_width
;      printf,luna,'plot_two_histograms: xrange = ',xrange
;      printf,luna,'plot_two_histograms: dbl_bin_width = ',dbl_bin_width
;      print,'plot_two_histograms: nbins = ',nbins
;      printf,luna,'plot_two_histograms: nbins = ',nbins
;      printf,luna,'plot_two_histograms: nbinsmin = ',nbinsmin
;      printf,luna,'plot_two_histograms: nbinsmax = ',nbinsmax
;    free_lun,luna

;    stop

    str_plotname_root = str_plotname_root+'_'+strtrim(string(nbins),2)+'bins'
;    print,'plot_two_histograms: str_plotname_root = '+str_plotname_root
  end


  indarr_reverse_a = ulonarr(n_elements(dblarr_data_a) + nbins + 1)
  indarr_reverse_b = ulonarr(n_elements(dblarr_data_b) + nbins + 1)


;  print,'after get_bin_width: n_elements(dblarr_data_b) = ',n_elements(dblarr_data_b)
;  print,'after get_bin_width: n_elements(dblarr_star_types) = ',n_elements(dblarr_star_types)
;  stop
;  stop
  print,' '
  print,' '
  print,' '
  print,' '
  if keyword_set(REJECTVALUEX) then begin
    i_nstars_all = n_elements(dblarr_data_a)
    indarr = where(abs(dblarr_data_a - rejectvaluex) gt 0.0001)
    if n_elements(indarr) eq 1 then begin
      print,'plot_two_histograms: n_elements(indarr=',indarr,') eq 1 => RETURNING'
      problem = 1
      return
    endif
;    strarr_data_temp = strarr_data
    dblarr_data_a = dblarr_data_a(indarr,*)
;    print,'plot_two_histograms: REJECTVALUEX = ',rejectvaluex,': ',i_nstars_all-n_elements(dblarr_data_a),' stars rejected from dblarr_data_a'
    indarr = 0
  endif
;  print,'plot_two_histograms: nbins = ',nbins
  if not keyword_set(XRANGE) then begin
    xrange_plot=dblarr(2)
    xrange_plot(0) = min([min(dblarr_data_a),min(dblarr_data_b)])
    xrange_plot(1) = max([max(dblarr_data_a),max(dblarr_data_b)])
    dbl_dist = xrange_plot(1) - xrange_plot(0)
    xrange_plot(0) = xrange_plot(0) - (dbl_dist / 20.)
    xrange_plot(1) = xrange_plot(1) + (dbl_dist / 20.)
  end else begin
;    print,'keyword_set(xrange)'
    xrange_plot = xrange
  end
;  print,'plot_two_histograms: xrange_plot = ',xrange_plot
  if not keyword_set(YRANGE) then begin
    yrange_plot=dblarr(2)
    yrange_plot(0) = 0
  end else begin
;    print,'keyword_set(yrange)'
    yrange_plot = yrange
  end
;  print,'xrange_plot = ',xrange_plot
;  print,'yrange_plot = ',yrange_plot

  if keyword_set(DBLARR_STAR_TYPES) then begin
    if n_elements(dblarr_star_types) ne n_elements(dblarr_data_b) then begin
      print,'plot_two_histogams: n_elements(dblarr_star_types)=',n_elements(dblarr_star_types),' not equal to n_elements(dblarr_data_b)=',n_elements(dblarr_data_b)
      stop
    end
  end

  ; --- snr bin ranges
  dblarr_bins = dblarr(nbins+1)
  dblarr_bins(0) = xrange_plot(0)

  ; --- snr bin counts
  intarr_bin_counts_a = dblarr(nbins)
  intarr_bin_counts_b = dblarr(nbins)
  intarr_bin_counts_a_orig = dblarr(nbins)
  intarr_bin_counts_b_orig = dblarr(nbins)

  if keyword_set(I_NBINS) then begin
    dbl_bin_width = (xrange_plot(1) - xrange_plot(0)) / double(nbins)
;    print,'dbl_bin_width = ',dbl_bin_width
  endif

;  openw,lun,'/home/azuri/daten/rave/rave_data/release5/html/index.html',/GET_LUN
;  printf,lun,'<html><body><center>'
;  printf,lun,'S/N for different Imag bins<br><hr>'
;  printf,lun,'<br>NOTE: If no S/N is given in the data release, S/N was set to -10<br>'
;  printf,lun,'This does not mean that the star did not deliver stellar parameters<br><br><hr>'

  if keyword_set(B_POP_ID) then i_n_types = 10 else i_n_types = 7
  if keyword_set(DBLARR_STAR_TYPES) then begin
    intarr_bin_counts_star_types = lonarr(nbins,i_n_types)
;    print,'dblarr_star_types = ',dblarr_star_types
  endif
;  print,'dblarr_data_b = ',dblarr_data_b
;  stop
  indarr_reverse_a(0) = nbins+1
  indarr_reverse_b(0) = nbins+1
  for i=0,nbins-1 do begin
    dblarr_bins(i+1) = dblarr_bins(i) + dbl_bin_width
;    print,'i = ',i,': binrange = ',dblarr_bins(i),'...',dblarr_bins(i+1)
;    if i eq 0 then begin
;      indarr_a = where((dblarr_data_a ge dblarr_bins(i)) and (dblarr_data_a lt dblarr_bins(i+1)))
;      indarr_b = where((dblarr_data_b ge dblarr_bins(i)) and (dblarr_data_b lt dblarr_bins(i+1)))
;      if keyword_set(DEBUGA) then begin
;        openw,lun,debug_outfiles_root+'_I_'+strtrim(string(dblarr_bins(i)),2)+'-'+strtrim(string(dblarr_bins(i+1)),2)+'.dat',/GET_LUN
;        openw,lun,'/suphys/azuri/daten/rave/rave_data/release5/I_'+strtrim(string(dblarr_bins(i)),2)+'-'+strtrim(string(dblarr_bins(i+1)),2),/GET_LUN
;        printf,lun,dblarr_data_a(indarr_a)
;        free_lun,lun
;      endif
;    end else begin
      indarr_a = where((dblarr_data_a ge dblarr_bins(i)) and (dblarr_data_a lt dblarr_bins(i+1)))
      indarr_b = where((dblarr_data_b ge dblarr_bins(i)) and (dblarr_data_b lt dblarr_bins(i+1)))

      indarr_reverse_a(i+1) = indarr_reverse_a(i) + n_elements(indarr_a)
      if indarr_a(0) lt 0 then begin
        indarr_reverse_a(i+1) = indarr_reverse_a(i)
      end else begin
        indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1) = indarr_a
      endelse

      indarr_reverse_b(i+1) = indarr_reverse_b(i) + n_elements(indarr_b)
      if indarr_b(0) lt 0 then begin
        indarr_reverse_b(i+1) = indarr_reverse_b(i)
      end else begin
        indarr_reverse_b(indarr_reverse_b(i):indarr_reverse_b(i+1)-1) = indarr_b
      endelse

;      print,'bin ',i,': indarr_a = ',indarr_a
;      print,'bin ',i,': indarr_b = ',indarr_b
      if keyword_set(DEBUGA) then begin
        if indarr_a(0) ne -1 then begin
          openw,lun,debug_outfiles_root+'_I_'+strtrim(string(dblarr_bins(i)),2)+'-'+strtrim(string(dblarr_bins(i+1)),2)+'.dat',/GET_LUN
          printf,lun,dblarr_data_a(indarr_a)
          free_lun,lun
        endif
      endif
      if keyword_set(DEBUGB) then begin
        if indarr_b(0) ne -1 then begin
          openw,lun,debug_outfiles_root+'_Teff_'+strtrim(string(dblarr_bins(i)),2)+'-'+strtrim(string(dblarr_bins(i+1)),2)+'.dat',/GET_LUN
;        openw,lun,'/suphys/azuri/daten/besancon/lon-lat/Teff_'+strtrim(string(dblarr_bins(i)),2)+'-'+strtrim(string(dblarr_bins(i+1)),2)+'.dat',/GET_LUN
          printf,lun,dblarr_data_b(indarr_b)
          free_lun,lun
        endif
      endif
;    end

; --- calculate number of stars in bin i
    intarr_bin_counts_a(i) = n_elements(indarr_a)
;    if intarr_bin_counts_a(i) eq 1 then begin
    if indarr_a(0) eq -1 then $
      intarr_bin_counts_a(i) = 0
;    end
    intarr_bin_counts_b(i) = n_elements(indarr_b)
;    if intarr_bin_counts_b(i) eq 1 then begin
    if indarr_b(0) eq -1 then begin
      intarr_bin_counts_b(i) = 0
      if keyword_set(DBLARR_STAR_TYPES) then begin
        intarr_bin_counts_star_types(i,*) = 0
      endif
    end else begin
;    end else begin
; --- star types
      if keyword_set(DBLARR_STAR_TYPES) then begin
        for j=0,i_n_types-1 do begin
          indarr_star_types = where(dblarr_star_types(indarr_b) eq j+1)
;          if n_elements(indarr_star_types) eq 1 then begin
          if indarr_star_types(0) eq -1 then begin
            intarr_bin_counts_star_types(i,j) = 0
;            end
          end else begin
            intarr_bin_counts_star_types(i,j) = n_elements(indarr_star_types)
          endelse
        endfor
;        print,'plot_two_histograms: i_n_types = ',i_n_types
;        print,'plot_two_histograms: indarr_a = ',indarr_a
;        print,'plot_two_histograms: indarr_b = ',indarr_b
;        print,'plot_two_histograms: intarr_bin_counts_star_types = ',intarr_bin_counts_star_types
      endif
    endelse
  endfor
  intarr_bin_counts_a_orig = intarr_bin_counts_a
  intarr_bin_counts_b_orig = intarr_bin_counts_b
;  print,'intarr_bin_counts_a = ',intarr_bin_counts_a
;  print,'intarr_bin_counts_b = ',intarr_bin_counts_b
;stop
  if keyword_set(MAXNORM) then begin
    normalise = max(intarr_bin_counts_b) / max(intarr_bin_counts_a)
    intarr_bin_counts_a = double(intarr_bin_counts_a) * normalise
  end
  if keyword_set(TOTALNORM) then begin
    normalise = total(intarr_bin_counts_b) / total(intarr_bin_counts_a)
;      print,'plot_two_histograms: normalise = ',normalise
    intarr_bin_counts_a = double(intarr_bin_counts_a) * normalise
;      print,'plot_two_histograms: normalised intarr_bin_counts_a = ',intarr_bin_counts_a
;      print,'plot_two_histograms: yrange_plot = ',yrange_plot
    if keyword_set(DBLARR_STAR_TYPES) then begin
      intarr_bin_counts_star_types = double(intarr_bin_counts_star_types) * normalise
;        print,'plot_two_histograms: normalised intarr_bin_counts_star_types = ',intarr_bin_counts_star_types
    end
  end
  if keyword_set(PERCENTAGE) then begin
    if keyword_set(DBLARR_STAR_TYPES) then begin
;        print,'total(intarr_bin_counts_b) = ',total(intarr_bin_counts_b)
;        print,'plot_two_histograms: intarr_bin_counts_star_types = ',intarr_bin_counts_star_types
;        stop
      intarr_bin_counts_star_types = 100. * double(intarr_bin_counts_star_types) / total(intarr_bin_counts_b)
;        print,'plot_two_histograms: normalised intarr_bin_counts_star_types = ',intarr_bin_counts_star_types
    end
;    print,'plot_two_histograms: before: intarr_bin_counts_a = ',intarr_bin_counts_a
;    print,'plot_two_histograms: before: intarr_bin_counts_b = ',intarr_bin_counts_b
    intarr_bin_counts_a = 100. * intarr_bin_counts_a / total(intarr_bin_counts_a)
    intarr_bin_counts_b = 100. * intarr_bin_counts_b / total(intarr_bin_counts_b)
;    print,'plot_two_histograms: after: intarr_bin_counts_a = ',intarr_bin_counts_a
;    print,'plot_two_histograms: after: intarr_bin_counts_b = ',intarr_bin_counts_b
;    print,'plot_two_histograms: yrange_plot = ',yrange_plot
;      stop
  endif
  if not keyword_set(YRANGE) then begin
    max_a = max(intarr_bin_counts_a)
    max_b = max(intarr_bin_counts_b)
    yrange_plot(1) = max([max_a,max_b])+(max([max_a,max_b])/20.)
  endif

; --- compare number of stars in bin i
  if keyword_set(B_RESIDUAL) then begin
    dblarr_residuals = dblarr(nbins)
    dblarr_chisq = dblarr(nbins)
    dblarr_chisq_weighted = dblarr(nbins)
    for m=0UL, nbins-1 do begin
      dblarr_residuals(m) = abs(intarr_bin_counts_a(m) - intarr_bin_counts_b(m))
      dblarr_chisq(m) = (intarr_bin_counts_a(m) - intarr_bin_counts_b(m))^2.
      dblarr_chisq_weighted(m) = ((intarr_bin_counts_a(m) - intarr_bin_counts_b(m))^2.) / intarr_bin_counts_a(m)
    endfor
    dbl_residual = total(dblarr_residuals)
    dbl_chisq = total(dblarr_chisq)
    dbl_chisq_weighted = total(dblarr_chisq_weighted)
;    print,'plot_two_histograms: dbl_residual = ',dbl_residual
    openw,lunb,str_plotname_root+'.res',/GET_LUN
      printf,lunb,'#dbl_residual dbl_chisq dbl_chisq_weighted'
      printf,lunb,dbl_residual,dbl_chisq,dbl_chisq_weighted
    free_lun,lunb
  endif

  set_plot,'ps'
  str_psfilename=str_plotname_root+'.ps'
  str_giffilename=str_plotname_root+'.gif'
  str_pdffilename=str_plotname_root+'.pdf'
;  print,'plot_two_histograms: str_pdffilename = '+str_pdffilename
  if keyword_set(DBLARR_STAR_TYPES) or keyword_set(COLOUR) then begin
    device,LANGUAGE_LEVEL=2,filename=str_psfilename,/color,/encapsulated,xsize=17.75,ysize=12.72
  end else begin
    device,LANGUAGE_LEVEL=2,filename=str_psfilename,/encapsulated,xsize=17.75,ysize=12.72
  end

  i_xticks = 0
  if keyword_set(I_INT_XTICKS) then begin
    if i_int_xticks gt 1 then $
      i_xticks = i_int_xticks
  end else begin
    xtickformat = 0
    if (xtitle eq 'Effective Temperature [K]') then begin
      i_xticks = 4
      xtickformat='(F6.0)'
    end
  end

  xtickformat = 0
  if keyword_set(I_STR_XTICKFORMAT) then begin
    if i_str_xtickformat ne '1' then begin
      xtickformat = i_str_xtickformat
;      print,'xtickformat set to ',xtickformat
    endif
;    stop
  end else begin
;  if xrange_plot(1)-xrange_plot(0) gt 500. then i_xticks=3
;  if (xtitle eq 'Radial Velocity [km/s]') or
    if (xtitle eq 'Effective Temperature [K]') then begin
      xtickformat='(F6.0)'
    end else if xtitle eq 'Radial Velocity [km/s]' or xtitle eq 'log g [dex]' then begin
      xtickformat = '(F6.0)'
    end else begin
      xtickformat = '(F6.1)'
    end
  end
;  print,'plot_two_histograms: xtitle = '+xtitle+', i_xticks = ',i_xticks,', xtickformat = ',xtickformat
;  print,'plot_two_histograms: xrange_plot = ',xrange_plot
;  print,'plot_two_histograms: yrange_plot = ',yrange_plot
;  print,'plot_two_histograms: intarr_bin_counts_a = ',intarr_bin_counts_a
;  print,'plot_two_histograms: intarr_bin_counts_b = ',intarr_bin_counts_b
;  print,'plot_two_histograms: dblarr_bins = ',dblarr_bins
;stop
  if string(xtickformat) ne '0' then $
    !x.tickformat = xtickformat

  if abs(xrange_plot(0) - xrange_plot(1)) lt 0.0000001 then $
    xrange_plot(1) = xrange_plot(0) + 1.
  if strpos(string(yrange_plot(0)),'N') ge 0 then $
    yrange_plot(0) = -1.
  if strpos(string(yrange_plot(1)),'N') ge 0 then $
    yrange_plot(1) = 1.

  if yrange_plot(1) lt max(intarr_bin_counts_a) then $
    yrange_plot(1) = max(intarr_bin_counts_a) + max(intarr_bin_counts_a) / 30.
  if yrange_plot(1) lt max(intarr_bin_counts_b) then $
    yrange_plot(1) = max(intarr_bin_counts_b) + max(intarr_bin_counts_b) / 30.

  plot,[xrange_plot(0),xrange_plot(1)],$
       [0.,0.],$
       xrange=xrange_plot,$
       yrange=yrange_plot,$
       xstyle=1,$
       ystyle=1,$
       xtitle=xtitle,$
       ytitle=ytitle,$
       title=title,$
       charsize=dbl_charsize,$
       charthick=dbl_charthick,$
       thick=dbl_thick,$
       xticks=i_xticks,$
       xtickformat=xtickformat,$
       position=i_dblarr_position

;  print,'plot_two_histograms: intarr_bin_counts_a = ',intarr_bin_counts_a
;  print,'plot_two_histograms: intarr_bin_counts_b = ',intarr_bin_counts_b
  if keyword_set(COLOUR) then begin
    red = intarr(256)
    green = intarr(256)
    blue = intarr(256)
    red(0) = 0
    green(0) = 0
    blue(0) = 0
    red(1) = 255
    green(1) = 0
    blue(1) = 0
    ltab = 0
    modifyct,ltab,'black-red',red,green,blue,file='colors1.tbl'
    loadct,ltab,FILE='colors1.tbl'
  endif
  if keyword_set(DBLARR_STAR_TYPES) then begin

    rave_get_colour_table,B_POP_ID    = b_pop_id,$
                          RED         = red,$
                          GREEN       = green,$
                          BLUE        = blue,$
                          DBL_N_TYPES = dbl_n_types

;      print,'setting color ',l,': red = ',red,', green = ',green,'blue = ',blue
    ltab = 0
    modifyct,ltab,'blue-green-red',red,green,blue,file='colors1_hist.tbl'
    loadct,ltab,FILE='colors1_hist.tbl'
    for k=0, nbins-1 do begin
      if dblarr_bins(k+1) gt xrange_plot(1) then dblarr_bins(k+1) = xrange_plot(1)
      for l=0,long(dbl_n_types)-1 do begin
        if l gt 0 then begin
          box,dblarr_bins(k),$
              total(intarr_bin_counts_star_types(k,0:l-1)),$
              dblarr_bins(k+1),$
              total(intarr_bin_counts_star_types(k,0:l-1))+intarr_bin_counts_star_types(k,l),$
              l+1
        end else begin
          box,dblarr_bins(k),0,dblarr_bins(k+1),intarr_bin_counts_star_types(k,l),l+1
        end
        if k eq 0 then begin
          box,xrange_plot(1),yrange_plot(0)+((yrange_plot(1)-yrange_plot(0))*double(l)/dbl_n_types),xrange_plot(1)+((xrange_plot(1)-xrange_plot(0))/15.),yrange_plot(0)+((yrange_plot(1)-yrange_plot(0))*(double(l)+1.)/dbl_n_types),l+1

          rave_print_colour_id,B_POP_ID      = b_pop_id,$
                               INT_M         = l+1,$
                               DBLARR_XRANGE = xrange_plot,$
                               DBLARR_YRANGE = yrange_plot,$
                               DBL_N_TYPES   = dbl_n_types
        end
      endfor
    endfor
  end; else begin
  for k=0, nbins-1 do begin
;  print,'plot_two_histograms: ',dblarr_bins(k),'-',dblarr_bins(k+1),': a=',intarr_bin_counts_a(k),', b=',intarr_bin_counts_b(k)
    if dblarr_bins(k+1) gt xrange_plot(1) then $
      dblarr_bins(k+1) = xrange_plot(1)
    oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_bin_counts_a(k)],thick=10
    oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_bin_counts_a(k)],thick=10
    oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_bin_counts_a(k),intarr_bin_counts_a(k)],thick=10
    if not keyword_set(DBLARR_STAR_TYPES) then begin
      if not keyword_set(COLOUR) then begin
        oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_bin_counts_b(k)],linestyle=2,thick=10
        oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_bin_counts_b(k)],linestyle=2,thick=10
        oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_bin_counts_b(k),intarr_bin_counts_b(k)],linestyle=2,thick=10
      end else begin
;        if keyword_set(B_PRINT_MOMENTS) then begin
;          if b_print_moments lt 2 then begin
            oplot,[dblarr_bins(k),dblarr_bins(k)],[0,intarr_bin_counts_b(k)],color=1,thick=5
            oplot,[dblarr_bins(k+1),dblarr_bins(k+1)],[0,intarr_bin_counts_b(k)],color=1,thick=5
            oplot,[dblarr_bins(k),dblarr_bins(k+1)],[intarr_bin_counts_b(k),intarr_bin_counts_b(k)],color=1,thick=5
;          endif
;        endif
      endelse
    endif
  endfor
;  end

  ; --- print moments
  if keyword_set(B_PRINT_MOMENTS) then begin
;    print,'dblarr_data_a(0:10) = ',dblarr_data_a(0:10)
;    print,'dblarr_data_b(0:10) = ',dblarr_data_b(0:10)
;    stop
    dblarr_moment_x = moment(dblarr_data_a)
    dblarr_moment_y = moment(dblarr_data_b)
    dblarr_moment_x(1) = sqrt(dblarr_moment_x(1))
    dblarr_moment_y(1) = sqrt(dblarr_moment_y(1))
    if (b_print_moments eq 1) or (b_print_moments eq 3) then begin
      dblarr_moments = dblarr(2,n_elements(dblarr_moment_x))
      dblarr_moments(0,*) = dblarr_moment_x
      dblarr_moments(1,*) = dblarr_moment_y
    end else begin
      dblarr_moments = dblarr_moment_x
    end
    if (b_print_moments eq 3) or (b_print_moments eq 4) then begin
      b_right = 1
    end else begin
      b_right = 0
    end
    print_moments,I_DBLARR_MOMENTS = dblarr_moments,$
                  I_DBLARR_XRANGE  = xrange_plot,$
                  I_DBLARR_YRANGE  = yrange_plot,$
                  B_RIGHT          = b_right
  endif

  ; --- vertical lines
  if keyword_set(DBLARR_VERTICAL_LINES_IN_PLOT) then begin
    plot_vertical_lines,dblarr_vertical_lines_in_plot,yrange_plot
  endif

  if keyword_set(DEBUG_A) then begin
    dblarr_x = dblarr(n_elements(dblarr_bins)-1)
    for i=0,n_elements(dblarr_x)-1 do begin
      dblarr_x(i) = dblarr_bins(i) + (dblarr_bins(i+1)-dblarr_bins(i))/2.
    endfor

    dblarr_hist =  histogram(dblarr_data_a,NBINS=nbins+1,REVERSE_INDICES=indarr_reverse,LOCATIONS=dblarr_locations,MIN=dblarr_bins(0),MAX=dblarr_bins(nbins))
    print,'dblarr_bins = ',dblarr_bins
    print,'dblarr_locations = ',dblarr_locations
    dblarr_nstars = dblarr(nbins)
    for i=0,nbins-1 do begin
      dblarr_nstars(i) = indarr_reverse(i+1) - indarr_reverse(i)
    endfor
    dblarr_nstars = dblarr_nstars * 100. / total(dblarr_nstars)
    dblarr_hist = dblarr_hist * 100. / total(dblarr_hist)
    print,'size(dblarr_hist) = ',size(dblarr_hist)
    print,'size(dblarr_nstars) = ',size(dblarr_nstars)
    print,'size(intarr_bin_counts_a) = ',size(intarr_bin_counts_a)
    for i=0,nbins-1 do begin
      print,'i=',i,': dblarr_hist = ',dblarr_hist(i),', dblarr_nstars = ',dblarr_nstars(i),', intarr_bin_counts_a = ',intarr_bin_counts_a(i)
    endfor
    for i=0,1 do begin
      print,'dblarr_bins(i=',i,') = ',dblarr_bins(i)
      print,'dblarr_bins(i+1) = ',dblarr_bins(i+1)
      print,'intarr_bin_counts_a_orig(i=',i,') = ',intarr_bin_counts_a_orig(i)
      print,'n_elements(indarr_reverse_a(indarr_reverse_a(i)=',indarr_reverse_a(i),':indarr_reverse_a(i+1)=',indarr_reverse_a(i+1),'-1)) = ',n_elements(indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1))
      print,'n_elements(indarr_reverse(indarr_reverse(i)=',indarr_reverse(i),':indarr_reverse(i+1)=',indarr_reverse(i+1),'-1)) = ',n_elements(indarr_reverse(indarr_reverse(i):indarr_reverse(i+1)-1))
  ;    for j=0,intarr_bin_counts_a_orig(i)-1 do begin
      print,'indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1) = ',indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1)
      print,'indarr_reverse(indarr_reverse(i):indarr_reverse(i+1)-1) = ',indarr_reverse(indarr_reverse(i):indarr_reverse(i+1)-1)
      print,'dblarr_data_a(indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1)) = ',dblarr_data_a(indarr_reverse_a(indarr_reverse_a(i):indarr_reverse_a(i+1)-1))
      print,'dblarr_data_a(indarr_reverse(indarr_reverse(i):indarr_reverse(i+1)-1)) = ',dblarr_data_a(indarr_reverse(indarr_reverse(i):indarr_reverse(i+1)-1))
  ;    endfor
    endfor
    oplot,dblarr_x,dblarr_nstars
  endif
  device,/close
  loadct,0
  ;stop
  spawn,'ps2gif '+str_psfilename+' '+str_giffilename
  if keyword_set(PRINTPDF) then begin
    spawn,'epstopdf '+str_psfilename
    ;make_pdf,str_psfilename
  endif
;  spawn,'rm '+str_psfilename

end
