pro rave_find_errors
;
; NAME:                  rave_find_errors.pro
; PURPOSE:               find best fitting error function of the RAVE data
;                          from histograms
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_find_errors
; INPUTS:
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/07/2008

; --- pre: rave_write_dist_min_err
;          rave_find_doubles
;          rave_besancon_plot_all   --- convolve besancon data with rave error functions
;          rave_besancon_plot_histograms

  int_method = 2; 1... calculate chi square
                ; 2... calculate moments


  for iii = 0, 1 do begin
    if iii eq 0 then begin
      str_suffix = 'new_calib_DR3/'
      b_four_errors_only = 1
    end else begin
      str_suffix = 'abundances/'
      b_four_errors_only = 0
    end
    if b_four_errors_only then begin
      str_subpath = 'errdivby_?.??_?.??_?.??_?.??/'
    end else begin
      str_subpath = 'errdivby_?.??_?.??_?.??_?.??_?.??/'
    end
  ;  str_dirname = '/suphys/azuri/daten/besancon/lon-lat/histograms/dr8/abundances/'

    b_popid = 1
    b_types = 0
    for ooo = 0,5 do begin
      if ooo lt 3 then begin
        b_sample_logg = 0
      end else begin
        b_sample_logg = 1
      endelse
      if (ooo eq 0) or (ooo eq 3) then begin
        b_dwarfs_only = 0
        b_giants_only = 0
      end else if (ooo eq 1) or (ooo eq 4) then begin
        b_dwarfs_only = 1
        b_giants_only = 0
      end else if (ooo eq 2) or (ooo eq 5) then begin
        b_dwarfs_only = 0
        b_giants_only = 1
      end

      str_dirname = '/suphys/azuri/daten/besancon/lon-lat/histograms/dr8/'
      if b_sample_logg then begin
        str_dirname = str_dirname + 'sample_logg/'
      end else begin
        str_dirname = str_dirname + 'sample_no_logg/'
      endelse
      str_dirname = str_dirname + str_suffix

      if b_popid then begin
        str_dirname = str_dirname + 'popid/'
      end else begin
        str_dirname = str_dirname + 'types/'
      end

      if int_method eq 1 then begin
        int_loop_end = 1
      end else begin
        int_loop_end = 0
      end
      for l=0,int_loop_end do begin
        i_col_res = l
        if int_method eq 1 then begin
          if l eq 0 then begin
            str_ytitle = 'Residual'
            str_plottitle = 'res'
          end else if l eq 1 then begin
            str_ytitle = '!4 V !3 square'
            str_plottitle = 'chisq'
          end else begin
            str_ytitle = '!3weighted !4 V!3'
            str_plottitle = 'wchisq'
          end
        end else begin
            str_ytitle = 'sum(d(moment!Di!N)!E 2!N)'
            str_plottitle = 'moments'
        end
        for i=0ul, 5 do begin
          if abs(i) lt 0.1 then begin
            str_parameter = 'logg'
          end else if abs(i - 1) lt 0.1 then begin
            str_parameter = 'MH'
          end else if abs(i - 2) lt 0.1 then begin
            str_parameter = 'Teff'
          end else if abs(i - 3) lt 0.1 then begin
            str_parameter = 'vrad'
          end else if abs(i - 4) lt 0.1 then begin
            str_parameter = 'dist'
          end else if abs(i - 5) lt 0.1 then begin
            str_parameter = 'height'
          end
          str_filelist = str_dirname
          if b_dwarfs_only then begin
            str_filelist = str_filelist+'dwarfs_'
          end else if b_giants_only then begin
            str_filelist = str_filelist+'giants_'
          end
          if int_method eq 1 then begin
            str_filelist = str_filelist+str_parameter+'_resfiles.list'
          end else begin
            str_filelist = str_filelist+str_parameter+'_momfiles.list'
          end
          str_files = str_dirname + str_subpath
          if b_giants_only then begin
            str_files = str_files+'giants/'
          end else if b_dwarfs_only then begin
            str_files = str_files+'dwarfs/'
          end
          if int_method eq 1 then begin
            str_files = str_files+str_parameter+'*.res'
          end else begin
            str_files = str_files+str_parameter+'*moments.dat'
          end
          print,'searching for str_files = <'+str_files+'>'

          spawn,'ls '+str_files+' > '+str_filelist
          strarr_filenames=readfiletostrarr(str_filelist,' ')
          print,'rave_find_errors: strarr_filenames = ',strarr_filenames

          dblarr_res = dblarr(n_elements(strarr_filenames))
          dblarr_err_divby = dblarr(n_elements(strarr_filenames))
          print,'rave_find_errors: n_elements(strarr_filenames) = ',n_elements(strarr_filenames)
          for j=0UL, n_elements(strarr_filenames)-1 do begin
            dblarr_temp = readfiletodblarr(strarr_filenames(j))
            if int_method eq 1 then begin
              dblarr_res(j) = dblarr_temp(l)
            end else begin
              dblarr_res(j) = total(((dblarr_temp(0,*) - dblarr_temp(1,*)) / (dblarr_temp(0,*)))^2.)
              print,'dblarr_temp(0,*) = ',dblarr_temp(0,*)
              print,'dblarr_temp(1,*) = ',dblarr_temp(1,*)
              print,'dblarr_temp(0,*) - dblarr_temp(1,*) = ',dblarr_temp(0,*)-dblarr_temp(1,*)
              print,'(dblarr_temp(0,*) - dblarr_temp(1,*))^2. = ',(dblarr_temp(0,*)-dblarr_temp(1,*))^2.
              print,'dblarr_res(j=',j,') set to ',dblarr_res(j)
            endelse

            i_pos = strpos(strarr_filenames(j),'/',/REVERSE_SEARCH)
            if b_dwarfs_only or b_giants_only then $
              i_pos = strpos(strmid(strarr_filenames(j),0,i_pos),'/',/REVERSE_SEARCH)
            if abs(i) lt 0.1 then begin
              i_str_start = 24
              if b_four_errors_only then $
                i_str_start = i_str_start - 5
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end else if abs(i - 1) lt 0.1 then begin
              i_str_start = 19
              if b_four_errors_only then $
                i_str_start= i_str_start - 5
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end else if abs(i - 2) lt 0.1 then begin
              i_str_start = 14
              if b_four_errors_only then $
                i_str_start= i_str_start - 5
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end else if abs(i - 3) lt 0.1 then begin
              i_str_start = 9
              if b_four_errors_only then $
                i_str_start= i_str_start - 5
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end else if abs(i - 4) lt 0.1 then begin
              i_str_start = 4
;              if b_four_errors_only then $
;                if not b_four_errors_only then $
;                i_str_start = i_str_start - 5
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end else if abs(i - 5) lt 0.1 then begin
              i_str_start = 4
              str_err_divby = strmid(strarr_filenames(j),i_pos-i_str_start,4)
              dblarr_err_divby(j) = double(str_err_divby)
              print,'rave_find_errors: i=',i,', j=',j,': str_err_divby = ',str_err_divby
            end
          endfor
          print,'rave_find_errors: dblarr_res = ',dblarr_res
          print,'rave_find_errors: dblarr_err_divby = ',dblarr_err_divby
;      stop
          str_plotname = strmid(strarr_filenames(0),0,strpos(strarr_filenames(0),'/',/REVERSE_SEARCH))
          str_plotname = strmid(str_plotname,0,strpos(str_plotname,'/',/REVERSE_SEARCH))
          if b_giants_only then begin
            str_plotname = strmid(str_plotname,0,strpos(str_plotname,'/',/REVERSE_SEARCH))
            str_plotname = str_plotname + '/giants_'
          end else if b_dwarfs_only then begin
            str_plotname = strmid(str_plotname,0,strpos(str_plotname,'/',/REVERSE_SEARCH))
            str_plotname = str_plotname + '/dwarfs_'
          end else begin
            str_plotname = str_plotname+'/'
          end
          str_plotname = str_plotname+str_parameter+'_'+str_plottitle
          print,'rave_find_errors: str_plotname = '+str_plotname

      ; --- fit a polynomial
          int_order = 7
          dblarr_coeffs = poly_fit(dblarr_err_divby(0:n_elements(dblarr_err_divby)-1),dblarr_res(0:n_elements(dblarr_err_divby)-1),int_order)
          dblarr_x = dblarr(200)
          dblarr_fit = dblarr(200)
          for k=0UL,199 do begin
            if abs(k) lt 0.1 then begin
              dblarr_x(k) = .5
            end else begin
              dblarr_x(k) = dblarr_x(k-1)+(4.5/200.)
            end
            for ll=0UL,int_order do begin
              dblarr_fit(k) = dblarr_fit(k) + (dblarr_coeffs(ll) * dblarr_x(k)^(ll))
            endfor
          endfor

          ; --- find minimum of fit
          dbl_min = min(dblarr_fit)
          intarr_index = where(abs(dblarr_fit - dbl_min) lt 0.000001)
          if intarr_index(0) ge 0 then begin
            print,'rave_find_errors: x_min = ',dblarr_x(intarr_index(0))
            print,'rave_find_errors: y_min = ',dblarr_fit(intarr_index(0))
            print,'rave_find_errors: max(dblarr_fit) = ',max(dblarr_fit)
            ; --- plot residuals over err_divby
            str_psfilename=str_plotname+'.ps'
            str_giffilename=str_plotname+'.gif'
            str_pdffilename=str_plotname+'.pdf'
            print,'rave_find_errors: str_pdffilename = '+str_pdffilename
        ;    stop
            set_plot,'ps'
            device,filename=str_psfilename,/color
              loadct,4
              ; --- plot data
              print,'dblarr_err_divby = ',dblarr_err_divby
              print,'dblarr_res = ',dblarr_res
              plot,dblarr_err_divby,$
                  dblarr_res,$
                  xrange=[0.,5.5],$
                  xtitle='Error function divided by',$
                  ytitle=str_ytitle,$
                  psym=2,$
                  yrange=[0.,max(dblarr_fit)],$
        ;           yrange=[min(dblarr_fit),max(dblarr_fit)],$
                  ystyle=1,$
                  title=str_parameter+': Minimum=('+strmid(strtrim(string(dblarr_x(intarr_index(0))),2),0,4)+','+strmid(strtrim(string(dblarr_fit(intarr_index(0))),2),0,4)+')',$
                  charsize=2.,$
                  charthick=2.,$
                  thick=3.

              ; --- plot fit
              oplot,dblarr_x,$
                    dblarr_fit,$
                    THICK=3.,$
                    color=100
              oplot,[dblarr_x(intarr_index(0)), dblarr_x(intarr_index(0))],$
                    [dblarr_fit(intarr_index(0)), dblarr_fit(intarr_index(0))],$
                    psym=2,$
                    color=100
            device,/close
            set_plot,'x'
            spawn,'ps2gif '+str_psfilename+' '+str_giffilename
            spawn,'epstopdf '+str_psfilename
            spawn,'rm '+str_psfilename
          endif
        endfor
      endfor
    endfor
  endfor
end
