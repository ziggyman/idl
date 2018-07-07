pro ucles_find_lines

  i_run = 3
  b_thar = 1

  if b_thar then begin
    if i_run eq 1 then begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/thar_aps_rr.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThAr_no_blends.dat'
      dbl_dv_tolerance = 1000.
    end else if i_run eq 2 then begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/run1_out.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThAr_no_strong_blends.dat'
      dbl_dv_tolerance = 250.
    end else begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/run1_out.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThAr_no_strong_strong_blends.dat'
      dbl_dv_tolerance = 150.
    end
    str_linelist_all = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThAr.dat'
  end else begin
    if i_run eq 1 then begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/find_lines_r.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThXe_no_blends.dat'
      dbl_dv_tolerance = 10000.
    end else if i_run eq 2 then begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/refThXe.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThXe_no_strong_blends.dat'
      dbl_dv_tolerance = 700.
    end else begin
      str_filelist = '/home/azuri/spectra/hermes/ThXe/refThXe.list'
      str_linelist = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThXe_no_strong_strong_blends.dat'
      dbl_dv_tolerance = 150.
    end
    str_linelist_all = '/home/azuri/daten/ThAr-Atlanten/UCLES/ThXe.dat'
  end

  str_outfile = strmid(str_linelist,0,strpos(str_linelist,'.',/REVERSE_SEARCH))+'_found.list'

  dbl_speed_of_light = 299792458.;m/s
  dbl_dv_tol = 40.;m/s
  dbl_minintens = 100.
  i_nsources = 50
  i_nions = 20
  i_nlines_per_ion_and_source = 10000

  strarr_filenames = readfilelinestoarr(str_filelist)
  strarr_lines = readfiletostrarr(str_linelist,' ')
  dblarr_lines_wlen = double(strarr_lines(*,0))

  strarr_ions_found = strarr(i_nions)
  strarr_sources_found = strarr(i_nions,i_nsources)
  strarr_wlen_found = strarr(i_nions,i_nsources,i_nlines_per_ion_and_source)
  strarr_lines_found = strarr(i_nions,i_nsources,i_nlines_per_ion_and_source,2)

  i_nions_found = 0
  i_nsources_found = 0
  i_nwlens_found = 0

  print,'n_elements(strarr_filenames)'
  dblarr_lines_found_in_order = dblarr(n_elements(strarr_filenames),200,17,2)
  print,'size(dblarr_lines_found_in_order) = ',size(dblarr_lines_found_in_order)
;  stop

  strarr_out = strarr(n_elements(strarr_filenames),1000,12)
  ;0... wlen
  ;1... ion
  ;2... intensity
  ;3... source
  ;4... gaussfit: intensity
  ;5... gaussfit: wlen
  ;6... gaussfit: fwhm
  ;7... gaussfit: continuum
  ;8... gaussfit: slope
  ;9... dv from fit with slope and fit without slope
  ;10... order
  ;11... gaussfit_pix: pos [pix]
  boolarr_print_out = lonarr(n_elements(strarr_filenames),1000)

  i_nlines_found = 0

  dblarr_slope_dv = dblarr(n_elements(dblarr_lines_wlen),3)
  i_nslopes_found = 0

  intarr_nlines_found_in_order = lonarr(n_elements(strarr_filenames))
;  boolarr_print_lines_in_order = lonarr(n_elements(strarr_filenames),1000)
  strarr_pos_ion_lines_found_in_order = strarr(n_elements(strarr_filenames),200,2)

  i_npix = countlines(strarr_filenames(0))
  dblarr_spec_all_orders = dblarr(n_elements(strarr_filenames),i_npix,2)

  openw,lun,str_outfile,/GET_LUN
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    spawn,'rm '+strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'.',/REVERSE_SEARCH))+'_*.dat'
    dblarr_spec = readfiletodblarr(strarr_filenames(i))
    dblarr_spec_all_orders(i,*,0) = dblarr_spec(*,0)
    dblarr_spec_all_orders(i,*,1) = dblarr_spec(*,1)
    dbl_wlen_start = dblarr_spec(0,0)
    dbl_wlen_end = dblarr_spec(n_elements(dblarr_spec(*,0))-1,0)
    indarr_lines_order = where(dblarr_lines_wlen gt dbl_wlen_start and dblarr_lines_wlen lt dbl_wlen_end)
    dblarr_lines_order = dblarr_lines_wlen(indarr_lines_order)
    intarr_nlines_found_in_order(i) = 0
    for j=0ul, n_elements(indarr_lines_order)-1 do begin
      print,'dblarr_lines_order(j=',j,') = ',dblarr_lines_order(j)
      indarr_line = where(dblarr_spec(*,0) gt dblarr_lines_order(j))
      indarr_line = [indarr_line(0)-5, indarr_line(0)-4,indarr_line(0)-3, indarr_line(0)-2, indarr_line(0)-1, indarr_line(0), indarr_line(0)+1,indarr_line(0)+2, indarr_line(0)+3, indarr_line(0)+4, indarr_line(0)+5]
      print,'indarr_line = ',indarr_line
      if indarr_line(0) ge 0 and indarr_line(10) le n_elements(dblarr_spec(*,0)) then begin
        print,'dblarr_spec(indarr_line,0) = ',dblarr_spec(indarr_line,0)
        print,'dblarr_spec(indarr_line,1) = ',dblarr_spec(indarr_line,1)
        dbl_max = max(dblarr_spec(indarr_line,1),maxind)
        print,'dbl_max = ',dbl_max
        if dbl_max ge dbl_minintens then begin
          print,'maxind = ',maxind
          indarr_gauss = indgen(17)
          indarr_gauss_pix = indgen(17)
          for k=0,n_elements(indarr_gauss)-1 do begin
            indarr_gauss(k) = indarr_line(maxind)-long(n_elements(indarr_gauss)/2)+k
            indarr_gauss_pix(k) = indarr_gauss(k)+1
          endfor
          print,'indarr_gauss = ',indarr_gauss
          print,'indarr_gauss_pix = ',indarr_gauss_pix
          print,'dblarr_spec(indarr_gauss,0) = ',dblarr_spec(indarr_gauss,0)
          print,'dblarr_spec(indarr_gauss,1) = ',dblarr_spec(indarr_gauss,1)
          if indarr_gauss(0) ge 0 and indarr_gauss(n_elements(indarr_gauss)-1) lt n_elements(dblarr_spec(*,0)) then begin
            dbl_xa = (dblarr_spec(indarr_gauss(0),0) + dblarr_spec(indarr_gauss(1),0)) / 2.
            dbl_xb = (dblarr_spec(indarr_gauss(n_elements(indarr_gauss)-2),0) + dblarr_spec(indarr_gauss(n_elements(indarr_gauss)-2),0)) / 2.
            dbl_xa_pix = (indarr_gauss_pix(0) + indarr_gauss_pix(1)) / 2.
            dbl_xb_pix = (indarr_gauss_pix(n_elements(indarr_gauss)-2) + indarr_gauss_pix(n_elements(indarr_gauss)-2)) / 2.
            dbl_ya = (dblarr_spec(indarr_gauss(0),1) + dblarr_spec(indarr_gauss(1),1)) / 2.
            dbl_yb = (dblarr_spec(indarr_gauss(n_elements(indarr_gauss)-2),1) + dblarr_spec(indarr_gauss(n_elements(indarr_gauss)-2),1)) / 2.

            ; --- calculate slope and continuum level
            dbl_slope = (dbl_yb-dbl_ya) / (dbl_xb-dbl_xa)
            dbl_slope_pix = (dbl_yb-dbl_ya) / (dbl_xb_pix-dbl_xa_pix)
            print,'dbl_slope = ',dbl_slope
            print,'dbl_slope_pix = ',dbl_slope_pix
            dbl_cont = dbl_ya - (dbl_xa * dbl_slope)
            dbl_cont_pix = dbl_ya - (dbl_xa_pix * dbl_slope_pix)
            print,'dbl_cont = ',dbl_cont
            print,'dbl_cont_pix = ',dbl_cont_pix

            dblarr_x = dblarr_spec(indarr_gauss,0)
            dblarr_y = dblarr_spec(indarr_gauss,1) - dbl_cont - (dbl_slope * dblarr_x)
            dblarr_y_pix = dblarr_spec(indarr_gauss,1) - dbl_cont_pix - (dbl_slope_pix * indarr_gauss_pix)
            print,'dblarr_x = ',dblarr_x
            print,'dblarr_y = ',dblarr_y
            print,'dblarr_y_pix = ',dblarr_y_pix

            ; --- calculate intensity
            dbl_intens = dblarr_y(long(n_elements(indarr_gauss)/2))
            dbl_intens_pix = dbl_intens
            print,'dbl_intens = ',dbl_intens

            ; --- calculate width
            indarr_width = where(dblarr_y(0:long(n_elements(indarr_gauss)/2)) lt dbl_intens/2.)
            print,'indarr_width = ',indarr_width
            if indarr_width(0) ge 0 then begin
              dbl_x_width_a = dblarr_x(indarr_width(n_elements(indarr_width)-1))
              dbl_x_width_a_pix = indarr_gauss_pix(indarr_width(n_elements(indarr_width)-1))
              print,'dbl_x_width_a = ',dbl_x_width_a
              print,'dbl_x_width_a_pix = ',dbl_x_width_a_pix
              indarr_width = where(dblarr_y(long(n_elements(indarr_gauss)/2):n_elements(indarr_gauss)-1) lt dbl_intens/2.)
              print,'indarr_width = ',indarr_width
              if indarr_width(0) ge 0 then begin
                dbl_x_width_b = dblarr_x(long(n_elements(indarr_gauss)/2)+indarr_width(0))
                dbl_x_width_b_pix = indarr_gauss_pix(long(n_elements(indarr_gauss)/2)+indarr_width(0))
                print,'dbl_x_width_b = ',dbl_x_width_b
                print,'dbl_x_width_b_pix = ',dbl_x_width_b_pix
                dbl_width = dbl_x_width_b - dbl_x_width_a
                dbl_width_pix = dbl_x_width_b_pix - dbl_x_width_a_pix
                print,'dbl_width = ',dbl_width
                print,'dbl_width_pix = ',dbl_width_pix

                print,'dblarr_x(long(n_elements(dblarr_x)/2.)-1=',long(n_elements(dblarr_x)/2.)-1,') = ',dblarr_x(long(n_elements(dblarr_x)/2.)-1)
                print,'dblarr_y(long(n_elements(dblarr_y)/2.)-1=',long(n_elements(dblarr_y)/2.)-1,') = ',dblarr_y(long(n_elements(dblarr_y)/2.)-1)
                print,'dblarr_x(long(n_elements(dblarr_x)/2.)=',long(n_elements(dblarr_x)/2.),') = ',dblarr_x(long(n_elements(dblarr_x)/2.))
                print,'dblarr_y(long(n_elements(dblarr_y)/2.)=',long(n_elements(dblarr_y)/2.),') = ',dblarr_y(long(n_elements(dblarr_y)/2.))
                print,'dblarr_x(long(n_elements(dblarr_x)/2.)+1=',long(n_elements(dblarr_x)/2.)+1,') = ',dblarr_x(long(n_elements(dblarr_x)/2.)+1)
                print,'dblarr_y(long(n_elements(dblarr_y)/2.)+1=',long(n_elements(dblarr_y)/2.)+1,') = ',dblarr_y(long(n_elements(dblarr_y)/2.)+1)

                ; --- calculate position
                dbl_pos = dblarr_x(long(n_elements(dblarr_x)/2.)-1)*dblarr_y(long(n_elements(dblarr_x)/2.)-1)+dblarr_x(long(n_elements(dblarr_x)/2.))*dblarr_y(long(n_elements(dblarr_x)/2.))+dblarr_x(long(n_elements(dblarr_x)/2.)+1)*dblarr_y(long(n_elements(dblarr_x)/2.)+1)
                dbl_pos_pix = indarr_gauss_pix(long(n_elements(dblarr_x)/2.)-1)*dblarr_y_pix(long(n_elements(dblarr_x)/2.)-1)+indarr_gauss_pix(long(n_elements(dblarr_x)/2.))*dblarr_y_pix(long(n_elements(dblarr_x)/2.))+indarr_gauss_pix(long(n_elements(dblarr_x)/2.)+1)*dblarr_y_pix(long(n_elements(dblarr_x)/2.)+1)

                dbl_pos = dbl_pos / (dblarr_y(long(n_elements(dblarr_x)/2.)-1)+dblarr_y(long(n_elements(dblarr_x)/2.))+dblarr_y(long(n_elements(dblarr_x)/2.)+1))
                dbl_pos_pix = dbl_pos_pix / (dblarr_y_pix(long(n_elements(dblarr_x)/2.)-1)+dblarr_y_pix(long(n_elements(dblarr_x)/2.))+dblarr_y_pix(long(n_elements(dblarr_x)/2.)+1))
                print,'dbl_pos = ',dbl_pos
                print,'dbl_pos_pix = ',dbl_pos_pix

                ; --- run GaussFit
                dblarr_result = gaussfit(dblarr_spec(indarr_gauss, 0),$
                                         dblarr_spec(indarr_gauss,1),$
                                         a,$
                                         estimates=[dbl_intens,dbl_pos,dbl_width,dbl_cont,dbl_slope],$
                                         MEASURE_ERRORS=sqrt(dblarr_spec(indarr_gauss,1)),$
                                         NTERMS=5)
                print,'dblarr_result = ',dblarr_result
                print,'a = ',a
                dblarr_result_pix = gaussfit(indarr_gauss_pix,$
                                             dblarr_spec(indarr_gauss,1),$
                                             a_pix,$
                                             estimates=[dbl_intens_pix,dbl_pos_pix,dbl_width_pix,dbl_cont_pix,dbl_slope_pix],$
                                             MEASURE_ERRORS=sqrt(dblarr_spec(indarr_gauss,1)),$
                                             NTERMS=5)
                print,'dblarr_result_pix = ',dblarr_result_pix
                print,'a_pix = ',a_pix

                ; --- check if gaussfit worked
                if a(0) eq dbl_intens and a(1) eq dbl_pos then begin
                  print,'ucles_find_lines: error: gauss fit did not converge'
                end else if a(0) gt 0. then begin

                  dbl_lambda_min = double(strarr_lines(indarr_lines_order(j),0)) / (1. + 13000./dbl_speed_of_light)
                  dbl_lambda_max = double(strarr_lines(indarr_lines_order(j),0)) / (1. - 13000./dbl_speed_of_light)
                  if a(1) ge dbl_lambda_min and a(1) le dbl_lambda_max then begin

                    ; --- run gaussfit without slope
                    dbl_cont_without_slope = (dblarr_spec(indarr_gauss(0), 1) + dblarr_spec(indarr_gauss(n_elements(indarr_gauss)-1), 1)) / 2.
                    dblarr_result_b = gaussfit(dblarr_spec(indarr_gauss, 0),$
                                               dblarr_spec(indarr_gauss, 1),$
                                               b,$
                                               estimates=[dbl_intens,dbl_pos,dbl_width,dbl_cont_without_slope],$
                                               MEASURE_ERRORS=sqrt(dblarr_spec(indarr_gauss,1)),$
                                               NTERMS=4)
                    if b(0) eq dbl_intens and b(1) eq dbl_pos then begin
                      print,'ucles_find_lines: error: gauss fit without slope did not converge'
                    end else if b(0) gt 0. then begin
                      dbl_dv = abs(dbl_speed_of_light*(b(1) / a(1) - 1.))
                      dblarr_slope_dv(i_nslopes_found,0) = dbl_slope
                      dblarr_slope_dv(i_nslopes_found,1) = dbl_dv
                      dblarr_slope_dv(i_nslopes_found,2) = a(0)
                      i_nslopes_found = i_nslopes_found + 1

                      ; --- remove weak lines
                      if a(0) gt 4.* dbl_cont_without_slope then begin

                        str_ion = strarr_lines(indarr_lines_order(j),1)
                        print,'str_ion = '+str_ion
                        str_source = strarr_lines(indarr_lines_order(j),3)
                        print,'str_source = '+str_source
    ;                    strarr_lines(indarr_lines_order(j),2) = strtrim(strarr_lines(indarr_lines_order(j),2),
                        remove_substring_in_string,strarr_lines(indarr_lines_order(j),2),'('
                        remove_substring_in_string,strarr_lines(indarr_lines_order(j),2),')'
                        dbl_intens_source = double(strarr_lines(indarr_lines_order(j),2))
                        print,'dbl_intens_source = ',dbl_intens_source

                        ; --- look for ion in strarr_ions_found
                        indarr_ion = where(strarr_ions_found eq str_ion)
                        if indarr_ion(0) lt 0 then begin
                          strarr_ions_found(i_nions_found) = str_ion
                          i_ion_found = i_nions_found
                          i_nions_found = i_nions_found + 1
                        end else begin
                          i_ion_found = indarr_ion(0)
                        end
                        print,'strarr_ions_found(0:i_nions_found=',i_nions_found,'-1) = ',strarr_ions_found(0:i_nions_found-1)

                        ; --- look for source of ion in strarr_lines_found
                        indarr_sources = where(strarr_sources_found(i_ion_found,*) ne '')
                        if indarr_sources(0) ge 0 then begin
                          i_nsources_found_for_ion = n_elements(indarr_sources)
                        end else begin
                          i_nsources_found_for_ion = 0
                        end
                        indarr_source = where(strarr_sources_found(i_ion_found,*) eq str_source)
                        if indarr_source(0) lt 0 then begin
                          strarr_sources_found(i_ion_found,i_nsources_found_for_ion) = str_source
                          i_source_found = i_nsources_found_for_ion
    ;                      i_nsources_found = i_nsources_found + 1
                        end else begin
                          i_source_found = indarr_source(0)
                        end
                        print,'strarr_sources_found(i_ion_found=',i_ion_found,',0:i_source_found=',i_source_found,') = ',strarr_sources_found(i_ion_found,0:i_source_found)

                        ;if i_nsources_found_for_ion gt 3 then $
                        ;stop

                        indarr_wlen_found = where(strarr_wlen_found(i_ion_found,i_source_found,*) ne '')
                        if indarr_wlen_found(0) lt 0 then begin
                          i_nwlen_found = 0
                        end else begin
                          i_nwlen_found = n_elements(indarr_wlen_found)
                        end
                        strarr_wlen_found(i_ion_found,i_source_found,i_nwlen_found) = strarr_lines(indarr_lines_order(j),0)
                        print,'strarr_wlen_found(0:i_nions_found-1,0:i_nsources_found-1,0:i_nwlen_found=',i_nwlen_found,') = ',strarr_wlen_found(0:i_nions_found,0:i_nsources_found,0:i_nwlen_found)
                        ;indarr_wlen_found = where(strarr_wlen_found(i_ion_found,i_source_found,*) eq strarr_lines(indarr_lines_order(j),0))
                        ;if indarr_wlen_found(0) lt 0 then begin
                        ;  strarr_wlen_found(i_ion_found,i_source_found,i_nwlen_found) = strarr_lines(indarr_lines_order(j),0)
                        ;  i_wlen_found = i_nwlen_found
                        ;end else begin
                        ;  i_wlen_found = indarr_wlen_found(0)
                        ;end

                        ; --- add intensities to strarr_lines_found
                        strarr_lines_found(i_ion_found,i_source_found,i_nwlen_found,0) = strtrim(string(dbl_intens_source,FORMAT='(F30.8)'),2)
                        strarr_lines_found(i_ion_found,i_source_found,i_nwlen_found,1) = strtrim(string(a(0),FORMAT='(F30.8)'),2)
                        print,'strarr_lines_found(i_ion_found,i_source_found,i_nwlen_found,*) = ',strarr_lines_found(i_ion_found,i_source_found,i_nwlen_found,*)

                        ;if i_nions_found gt 9 then $
                        ;stop


                        strarr_out(i,intarr_nlines_found_in_order(i),0:3) = strarr_lines(indarr_lines_order(j),*)
                        strarr_out(i,intarr_nlines_found_in_order(i),4) = strtrim(string(a(0),FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),5) = strtrim(string(a(1),FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),6) = strtrim(string(a(2),FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),7) = strtrim(string(a(3),FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),8) = strtrim(string(a(4),FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),9) = strtrim(string(dbl_dv,FORMAT='(F30.8)'),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),10) = strtrim(string(i),2)
                        strarr_out(i,intarr_nlines_found_in_order(i),11) = strtrim(string(a_pix(1),FORMAT='(F30.8)'),2)
                        boolarr_print_out(i,intarr_nlines_found_in_order(i)) = 1
                        print,'strarr_out(i=',i,',intarr_nlines_found_in_order(i)=',intarr_nlines_found_in_order,',*) = ',strarr_out(i,intarr_nlines_found_in_order(i),*)
                        i_nlines_found = i_nlines_found+1
    ;                    printf,lun,strarr_lines(indarr_lines_order(j),0)+' '+strarr_lines(indarr_lines_order(j),1)+' '+strarr_lines(indarr_lines_order(j),2)+' '+strarr_lines(indarr_lines_order(j),3)+' '+strtrim(string(a(0)),2)+' '+strtrim(string(a(1)),2)+' '+strtrim(string(a(2)),2)+' '+strtrim(string(a(3)),2)+' '+strtrim(string(a(4)),2)

                        str_filename_line = strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'.',/REVERSE_SEARCH))+'_'+strtrim(string(dblarr_lines_order(j)),2)+'.dat'
                        openw,luna,str_filename_line,/GET_LUN
                          for m=0,n_elements(indarr_gauss)-1 do begin
                            printf,luna,dblarr_spec(indarr_gauss(m),0),dblarr_result(m)
                          endfor
                        free_lun,luna
                        dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i),*,0) = dblarr_spec(indarr_gauss,0)
                        dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i),*,1) = dblarr_result
                        print,'dblarr_lines_found_in_order(i=',i,',intarr_nlines_found_in_order(i)=',intarr_nlines_found_in_order(i),',*,0) = ',dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i),*,0)
                        print,'dblarr_lines_found_in_order(i=',i,',intarr_nlines_found_in_order(i)=',intarr_nlines_found_in_order(i),',*,1) = ',dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i),*,1)
                        print,'size(dblarr_lines_found_in_order)=',size(dblarr_lines_found_in_order)
;                        stop
                        strarr_pos_ion_lines_found_in_order(i,intarr_nlines_found_in_order(i),0) = strarr_out(i,intarr_nlines_found_in_order(i),0)
                        strarr_pos_ion_lines_found_in_order(i,intarr_nlines_found_in_order(i),1) = strarr_out(i,intarr_nlines_found_in_order(i),1)
                        ;boolarr_print_lines_in_order(i,intarr_nlines_found_in_order(i)) = 1
                        intarr_nlines_found_in_order(i) = intarr_nlines_found_in_order(i) + 1
                      end
                    end
                  end
                endif
              endif
            endif
          endif
        endif
      endif
    endfor
;    dblarr_lines_found_in_order = dblarr_lines_found_in_order(0:intarr_nlines_found_in_order(i)-1,*,*)
    print,'intarr_nlines_found_in_order(i) = ',intarr_nlines_found_in_order(i)
  endfor
  strarr_pos_ion_lines_found_in_order = strarr_pos_ion_lines_found_in_order(*,0:max(intarr_nlines_found_in_order)-1,*)
  dblarr_slope_dv = dblarr_slope_dv(0:i_nslopes_found-1,*)
  strarr_out = strarr_out(*,0:max(intarr_nlines_found_in_order)-1,*)
  dblarr_lines_found_in_order = dblarr_lines_found_in_order(*,0:max(intarr_nlines_found_in_order)-1,*,*)
  print,'size(dblarr_lines_found_in_order)=',size(dblarr_lines_found_in_order)
;  stop

  ; --- plot dv vs slope for all lines found
  print,'dblarr_slope_dv = ',dblarr_slope_dv
  print,'i_nslopes_found = ',i_nslopes_found

  set_plot,'ps'
  device,filename='dv_vs_slope.ps',/color
    loadct,0
    plot,alog10(dblarr_slope_dv(*,0) / dblarr_slope_dv(*,2)),$
         alog10(dblarr_slope_dv(*,1)/1000.),$
         xtitle='log (slope/I)',$
         ytitle='log dv [km/s]',$
         psym=2,$
         xrange=[-4.2,1.2],$
         xstyle=1,$
         yrange=[-5.,3.],$
         ystyle=1
    indarr = where(alog10(dblarr_slope_dv(*,1)/1000.) gt -0.8)
    loadct,13
    oplot,alog10(dblarr_slope_dv(indarr,0) / dblarr_slope_dv(indarr,2)),$
          alog10(dblarr_slope_dv(indarr,1)/1000.),$
          psym=2,$
          color=250
  device,/close
  set_plot,'x'
;stop
;  print,'strarr_ions_found = ',strarr_ions_found
;  print,'strarr_sources_found = ',strarr_sources_found
;  print,'strarr_wlen_found = ',strarr_wlen_found

  ; --- calculate scale factor alpha
  str_index = strmid(str_filelist,0,strpos(str_filelist,'/',/REVERSE_SEARCH)+1)+'index.html'
  openw,luna,str_index,/GET_LUN
    printf,luna,'<html><body><center>'
    i_nions_found = n_elements(where(strarr_ions_found ne ''))
    print,'i_nions_found = ',i_nions_found
    dblarr_alpha = dblarr(i_nions_found,i_nsources)
    for i=0,i_nions_found-1 do begin
      i_nsources_found = n_elements(where(strarr_sources_found(i,*) ne ''))
      print,'i_nsources_found = ',i_nsources_found
      for j=0,i_nsources_found-1 do begin
        i_nwlens_found = n_elements(where(strarr_wlen_found(i,j,*) ne ''))
        indarr_ne_zero = where(double(strarr_lines_found(i,j,0:i_nwlens_found-1,0)) gt 0.)
        if indarr_ne_zero(0) ge 0 then begin
          print,'i_nwlens_found = ',i_nwlens_found
          str_plot = strmid(str_filelist,0,strpos(str_filelist,'/',/REVERSE_SEARCH)+1)+strarr_ions_found(i)+'_'+strarr_sources_found(i,j)+'.ps'
          str_plot_gif = strmid(str_plot,0,strpos(str_plot,'.',/REVERSE_SEARCH))+'.gif'
          set_plot,'ps'
          device,filename=str_plot,/color
            dblarr_x = double(strarr_lines_found(i,j,indarr_ne_zero,0))
            dblarr_y = double(strarr_lines_found(i,j,indarr_ne_zero,1))
            loadct,0
            plot,alog10(dblarr_x),$
                 alog10(dblarr_y),$
                 xtitle='log I!Dsource!N',$
                 ytitle='log I!Dmeasure!N',$
                 psym=2,$
                 thick=2,$
                 charsize=2.,$
                 charthick=2.
            dbl_scale_factor = median(dblarr_y / dblarr_x)
            loadct,13
;            oplot,dblarr_x,dblarr_x * dbl_scale_factor,color=50
            if n_elements(dblarr_x) gt 1 then begin
              dblarr_alpha(i,j) = dbl_scale_factor
;              dblarr_linfit = linfit(dblarr_x,dblarr_y)
;              if not(dblarr_linfit(0) le 0.) and not(dblarr_linfit(0) ge 0.) then begin
;                dblarr_alpha(i,j,0) = 0.
;                dblarr_alpha(i,j,1) = mean(dblarr_y) / mean(dblarr_x)
;              end else begin
;                dblarr_alpha(i,j,0) = dblarr_linfit(0)
;                dblarr_alpha(i,j,1) = dblarr_linfit(1)
;              end
            end else begin
              dblarr_alpha(i,j,0) = 0.
;              dblarr_alpha(i,j,1) = dblarr_y(0) / dblarr_x(0)
            end
            print,'dblarr_alpha(i,j) = ',dblarr_alpha(i,j)
            oplot,alog10(dblarr_x),alog10(dblarr_alpha(i,j)*dblarr_x),color=130
;            oplot,alog10(dblarr_x),dblarr_alpha(i,j,0)+dblarr_alpha(i,j,1)*dblarr_x,color=130
          device,/close
          set_plot,'x'
          spawn,'ps2gif '+str_plot+' '+str_plot_gif
          printf,luna,'<h2>'+strarr_ions_found(i)+'_'+strarr_sources_found(i,j)+'</h2>'
          printf,luna,'<a href="'+strmid(str_plot_gif,strpos(str_plot_gif,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_plot_gif,strpos(str_plot_gif,'/',/REVERSE_SEARCH)+1)+'"></a><br>alpha = ',dblarr_alpha(i,j),'<br><hr><br>'
        ;end else begin
        ;  print,'error: i_nwlens_found = ',i_nwlens_found
        ;end
        endif
      endfor
    endfor
    printf,luna,'</center></body></html>'
  free_lun,luna

  ; --- write new input linelist for next step
  str_linelist_all_out = strmid(str_linelist,0,strpos(str_linelist,'_',/REVERSE_SEARCH))+'_strong_blends.dat'
  openw,lunb,str_linelist_all_out,/GET_LUN

  strarr_lines_all = readfiletostrarr(str_linelist_all,' ')
  strarr_lines_all_out = strarr_lines_all
  i_nlines_removed = 0
  for i=0ul, n_elements(strarr_lines_all(*,0))-1 do begin
    ; --- re-scale intensities
    str_ion = strarr_lines_all(i,1)
    str_source = strarr_lines_all(i,3)
    indarr_ion = where(strarr_ions_found eq str_ion)
    if indarr_ion(0) ge 0 then begin
      indarr_source = where(strarr_sources_found(indarr_ion(0),*) eq str_source)
      if indarr_source(0) ge 0 then begin
        strarr_lines_all(i,2) = strtrim(string(double(strarr_lines_all(i,2)) * dblarr_alpha(indarr_ion(0),indarr_source(0)),FORMAT='(F30.8)'),2)
      endif
    endif

    ; --- remove lines with velocity shifts due to blending from next input line list
    dbl_sigma_v = (dbl_speed_of_light / 43000.) / 2.355

    dbl_lambda_min = double(strarr_lines_all(i,0)) / (1. + 13000./dbl_speed_of_light)
    dbl_lambda_max = double(strarr_lines_all(i,0)) / (1. - 13000./dbl_speed_of_light)
    print,'dbl_lambda_min = ',dbl_lambda_min
    print,'dbl_lambda_max = ',dbl_lambda_max
    indarr = where(double(strarr_lines_all(*,0)) ge dbl_lambda_min and double(strarr_lines_all(*,0)) le dbl_lambda_max and double(strarr_lines_all(*,0)) ne double(strarr_lines_all(i,0)))
    if indarr(0) ge 0 then begin
      j=0ul
      while j le n_elements(indarr)-1 do begin
        dbl_dv_sep = abs(dbl_speed_of_light * ((double(strarr_lines_all(indarr(j),0)) / double(strarr_lines_all(i,0))) - 1.))
        dbl_ratio_intensities = double(strarr_lines_all(indarr(j),2)) / double(strarr_lines_all(i,2))
        dbl_ratio_intensities_max = (1. / ((dbl_dv_sep / dbl_dv_tol) - 1.)) + 0.1 * (dbl_dv_sep / dbl_sigma_v)^2. + 0.0012 * (dbl_dv_sep / dbl_sigma_v)^4.
        ;i_old = i
        if dbl_ratio_intensities gt dbl_ratio_intensities_max then begin
          print,'removing line '+strarr_lines_all(i,0)+' '+strarr_lines_all(i,1)+' '+strarr_lines_all(i,2)+' '+strarr_lines_all(i,3)+' because of line '+strarr_lines_all(indarr(j),0)+' '+strarr_lines_all(indarr(j),1)+' '+strarr_lines_all(indarr(j),2)+' '+strarr_lines_all(indarr(j),3)
          print,'should be equal to '+strarr_lines_all_out(i-i_nlines_removed,0)+' '+strarr_lines_all(i-i_nlines_removed,1)+' '+strarr_lines_all(i-i_nlines_removed,2)+' '+strarr_lines_all(i-i_nlines_removed,3)+' because of line '+strarr_lines_all(indarr(j),0)+' '+strarr_lines_all(indarr(j),1)+' '+strarr_lines_all(indarr(j),2)+' '+strarr_lines_all(indarr(j),3)
          strarr_lines_all_out(i-i_nlines_removed:n_elements(strarr_lines_all_out(*,0))-2,*) = strarr_lines_all_out(i-i_nlines_removed+1:n_elements(strarr_lines_all_out(*,0))-1,*)
          strarr_lines_all_out = strarr_lines_all_out(0:n_elements(strarr_lines_all_out(*,0))-2,*)
          i_nlines_removed = i_nlines_removed + 1
          ;i = i-1
          j=n_elements(indarr)-1
        endif
        j = j+1
      end
    endif
  endfor
  for i=0ul, n_elements(strarr_lines_all_out(*,0))-1 do begin
    printf,lunb,strarr_lines_all_out(i,0)+' '+strarr_lines_all_out(i,1)+' '+strarr_lines_all_out(i,2)+' '+strarr_lines_all_out(i,3)
  endfor

  ; --- rescale intensities
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    for j=0ul, intarr_nlines_found_in_order(i)-1 do begin
      str_ion = strarr_out(i,j,1)
      str_source = strarr_out(i,j,3)
      indarr_ion = where(strarr_ions_found eq str_ion)
      if indarr_ion(0) ge 0 then begin
        indarr_source = where(strarr_sources_found(indarr_ion(0),*) eq str_source)
        if indarr_source(0) ge 0 then begin
          remove_substring_in_string,strarr_out(i,j,2),'('
          remove_substring_in_string,strarr_out(i,j,2),')'

          strarr_out(i,j,2) = strtrim(string(double(strarr_out(i,j,2)) * dblarr_alpha(indarr_ion(0),indarr_source(0)),FORMAT='(F30.8)'),2)

          set_plot,'ps'
          device,filename='I2_by_I1_vs_vc.ps'
            dblarr_x = double(indgen(100.))
            dblarr_y = 1. / (dblarr_x / 40. - 1.) + 0.1*(dblarr_x/dbl_sigma_v)^2. + 0.0012 * (dblarr_x / dbl_sigma_v)^4.
            plot,alog10(dblarr_x),alog10(dblarr_y),xtitle='log dv!Dsep!N',ytitle='log (I!D2!N / I!D1!N)'
          device,/close
          set_plot,'x'

        endif
      endif
    endfor
  endfor

  ; --- check FWHM
  set_plot,'ps'
  device,filename='FWHMv_vs_lambda.ps'
    dblarr_x = dblarr(i_nlines_found)
    dblarr_y = dblarr(i_nlines_found)
    i_nx = 0
    for i=0ul, n_elements(strarr_filenames)-1 do begin
      dblarr_x(i_nx:i_nx+intarr_nlines_found_in_order(i)-1) = double(strarr_out(i,0:intarr_nlines_found_in_order(i)-1,0))
      dblarr_y(i_nx:i_nx+intarr_nlines_found_in_order(i)-1) = dbl_speed_of_light*(abs(double(strarr_out(i,0:intarr_nlines_found_in_order(i)-1,6))) / dblarr_x(i_nx:i_nx+intarr_nlines_found_in_order(i)-1))/1000.
      i_nx = i_nx+intarr_nlines_found_in_order(i)
    endfor
    plot,dblarr_x,$
         dblarr_y,$
         xtitle='Air wavelength ['+STRING("305B)+']',$
         ytitle='FWHM [km/s]',$
         psym=2,$
         yrange=[1.5,4.],$
         ystyle=1
    dblarr_fit = poly_fit(dblarr_x,dblarr_y,2,YFIT=dblarr_yfit,YERROR=dblarr_yerror)
    loadct,13
    oplot,dblarr_x,dblarr_yfit,color=50
    indarr = where(abs(dblarr_y - dblarr_yfit) gt dblarr_yerror / 2.5,COMPLEMENT=indarr_complement)
    oplot,dblarr_x(indarr),dblarr_y(indarr),psym=2,color=240
  device,/close
  set_plot,'x'
  i_nx = 0
  i_nx_good = 0
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    indarr_do_not_remove_from_order = where((indarr_complement ge i_nx) and (indarr_complement lt i_nx+intarr_nlines_found_in_order(i)))

    strarr_out(i,0:n_elements(indarr_do_not_remove_from_order)-1,*) = strarr_out(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*)
    strarr_out(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*) = ''

    dblarr_lines_found_in_order(i,0:n_elements(indarr_do_not_remove_from_order)-1,*,*) = dblarr_lines_found_in_order(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*,*)
    dblarr_lines_found_in_order(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*,*) = 0.

    boolarr_print_out(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1) = 0

    strarr_pos_ion_lines_found_in_order(i,0:n_elements(indarr_do_not_remove_from_order)-1,*) = strarr_pos_ion_lines_found_in_order(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*)
    strarr_pos_ion_lines_found_in_order(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*) = ''

    i_nx = i_nx+intarr_nlines_found_in_order(i)
    i_nx_good = i_nx_good + n_elements(indarr_do_not_remove_from_order)
    intarr_nlines_found_in_order(i) = n_elements(indarr_do_not_remove_from_order)
  endfor
  strarr_out = strarr_out(*,0:max(intarr_nlines_found_in_order)-1,*)
  dblarr_lines_found_in_order = dblarr_lines_found_in_order(*,0:max(intarr_nlines_found_in_order)-1,*,*)
  strarr_pos_ion_lines_found_in_order = strarr_pos_ion_lines_found_in_order(*,0:max(intarr_nlines_found_in_order)-1,*)

  ; --- remove lines with high slope
  dblarr_slope = dblarr(total(intarr_nlines_found_in_order))
  dblarr_dv = dblarr(total(intarr_nlines_found_in_order))
  dblarr_intens = dblarr(total(intarr_nlines_found_in_order))
  i_nx = 0
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    dblarr_slope(i_nx:i_nx+intarr_nlines_found_in_order(i)-1) = double(strarr_out(i,0:intarr_nlines_found_in_order(i)-1,8))
    dblarr_dv(i_nx:i_nx+intarr_nlines_found_in_order(i)-1) = double(strarr_out(i,0:intarr_nlines_found_in_order(i)-1,9))
    dblarr_intens(i_nx:i_nx+intarr_nlines_found_in_order(i)-1) = double(strarr_out(i,0:intarr_nlines_found_in_order(i)-1,4))
    i_nx = i_nx+intarr_nlines_found_in_order(i)
  endfor
  set_plot,'ps'
  device,filename='dv_vs_slope_end.ps',/color
    loadct,0
    plot,alog10(dblarr_slope / dblarr_intens),$
         alog10(dblarr_dv/1000.),$
         xtitle='log!D10!N (slope/I!DMeas!N)',$
         ytitle='log!D10!N dv [km/s]',$
         psym=2,$
         xrange=[-4.2,1.2],$
         xstyle=1,$
         yrange=[-5.,3.],$
         ystyle=1
    indarr = where(alog10(dblarr_dv/1000.) gt -0.8,COMPLEMENT=indarr_complement)
    loadct,13
    oplot,alog10(dblarr_slope(indarr) / dblarr_intens(indarr)),alog10(dblarr_dv(indarr)/1000.),psym=2,color=240
  device,/close
  set_plot,'x'
;  strarr_out = strarr_out(indarr_complement,*)
  i_nx = 0
  i_nx_good = 0
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    indarr_do_not_remove_from_order = where((indarr_complement ge i_nx) and (indarr_complement lt i_nx+intarr_nlines_found_in_order(i)))

    strarr_out(i,0:n_elements(indarr_do_not_remove_from_order)-1,*) = strarr_out(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*)
    strarr_out(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*) = ''

    dblarr_lines_found_in_order(i,0:n_elements(indarr_do_not_remove_from_order)-1,*,*) = dblarr_lines_found_in_order(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*,*)
    dblarr_lines_found_in_order(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*,*) = 0.

    strarr_pos_ion_lines_found_in_order(i,0:n_elements(indarr_do_not_remove_from_order)-1,*) = strarr_pos_ion_lines_found_in_order(i,indarr_complement(indarr_do_not_remove_from_order)-i_nx,*)
    strarr_pos_ion_lines_found_in_order(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1,*) = ''

    boolarr_print_out(i,n_elements(indarr_do_not_remove_from_order):n_elements(strarr_out(0,*,0))-1) = 0

    i_nx = i_nx+intarr_nlines_found_in_order(i)
    i_nx_good = i_nx_good + n_elements(indarr_do_not_remove_from_order)
    intarr_nlines_found_in_order(i) = n_elements(indarr_do_not_remove_from_order)
  endfor
  strarr_out = strarr_out(*,0:max(intarr_nlines_found_in_order)-1,*)
  strarr_pos_ion_lines_found_in_order = strarr_out(*,0:max(intarr_nlines_found_in_order)-1,*)
  dblarr_lines_found_in_order = dblarr_lines_found_in_order(*,0:max(intarr_nlines_found_in_order)-1,*,*)

  for i=0ul, n_elements(strarr_filenames)-1 do begin
    ;indarr = where(strarr_out(*,0) eq strarr_out(i,0))
    ;if n_elements(indarr) gt 1 then begin
    ;  print,'line i=',i,' found ',n_elements(indarr),' times: strarr_out(i,*) = ',strarr_out(i,*)
    ;  for j=0,n_elements(indarr)-1 do begin
    ;    print,'strarr_out(indarr(j),*) = ',strarr_out(indarr(j),*)
    ;  endfor
    ;end

    ; --- reject lines with dv > tolerance
    j=0ul
    j_end = intarr_nlines_found_in_order(i)
    while j lt j_end do begin
      dbl_dv = abs(dbl_speed_of_light*(double(strarr_out(i,j,0)) / double(strarr_out(i,j,5)) - 1.))
      b_print = 1
      if dbl_dv gt dbl_dv_tolerance then begin
        if j eq intarr_nlines_found_in_order(i)-1 then begin
          strarr_out(i,intarr_nlines_found_in_order(i)-1,*) = ''

          dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*,*) = 0.

          strarr_pos_ion_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*) = ''

          boolarr_print_out(i,intarr_nlines_found_in_order(i)-1) = 0
        end else begin
          strarr_out(i,j:intarr_nlines_found_in_order(i)-2,*) = strarr_out(i,j+1:intarr_nlines_found_in_order(i)-1,*)
          strarr_out(i,intarr_nlines_found_in_order(i)-1,*) = ''

          dblarr_lines_found_in_order(i,j:intarr_nlines_found_in_order(i)-2,*,*) = dblarr_lines_found_in_order(i,j+1:intarr_nlines_found_in_order(i)-1,*,*)
          dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*,*) = 0.

          strarr_pos_ion_lines_found_in_order(i,j:intarr_nlines_found_in_order(i)-2,*) = strarr_pos_ion_lines_found_in_order(i,j+1:intarr_nlines_found_in_order(i)-1,*)
          strarr_pos_ion_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*) = ''

          boolarr_print_out(i,intarr_nlines_found_in_order(i)-1) = 0
        endelse
        intarr_nlines_found_in_order(i) = intarr_nlines_found_in_order(i)-1
        j_end = j_end-1
      end else begin
        ; --- remove double findings
        indarr_double = where(abs(dbl_speed_of_light*(double(strarr_out(i,*,5)) / double(strarr_out(i,j,5)) - 1.)) lt 250.)
        if n_elements(indarr_double) gt 1 then begin
          print,'double identification found: indarr_double = ',indarr_double
          dblarr_intens_double = dblarr(n_elements(indarr_double))
          for j=0,n_elements(indarr_double)-1 do begin
            print,'strarr_out(indarr_double(i,j=',j,'),*) = ',strarr_out(i,indarr_double(j),*)
            dblarr_intens_double(j) = double(strarr_out(i,indarr_double(j),2))
          endfor
          j_end = j_end-1
          max_intens = max(dblarr_intens_double)
          indarr_max_intens = where(dblarr_intens_double eq max_intens,COMPLEMENT=indarr_nmax_intens)

          if indarr_nmax_intens(0) lt 0 then begin
            indarr_nmax_intens = indarr_max_intens
            remove_ith_element_from_array,indarr_nmax_intens,0
          endif
          for j=0, n_elements(indarr_nmax_intens)-1 do begin
            print,'removing line ',indarr_double(indarr_nmax_intens(j))
            strarr_out(i,indarr_double(indarr_nmax_intens(j)):intarr_nlines_found_in_order(i)-2,*) = strarr_out(i,indarr_double(indarr_nmax_intens(j))+1:intarr_nlines_found_in_order(i)-1,*)
            strarr_out(i,intarr_nlines_found_in_order(i)-1,*) = ''

            dblarr_lines_found_in_order(i,indarr_double(indarr_nmax_intens(j)):intarr_nlines_found_in_order(i)-2,*,*) = dblarr_lines_found_in_order(i,indarr_double(indarr_nmax_intens(j))+1:intarr_nlines_found_in_order(i)-1,*,*)
            dblarr_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*,*) = 0.

            strarr_pos_ion_lines_found_in_order(i,indarr_double(indarr_nmax_intens(j)):intarr_nlines_found_in_order(i)-2,*) = strarr_pos_ion_lines_found_in_order(i,indarr_double(indarr_nmax_intens(j))+1:intarr_nlines_found_in_order(i)-1,*)
            strarr_pos_ion_lines_found_in_order(i,intarr_nlines_found_in_order(i)-1,*) = ''

            boolarr_print_out(i,intarr_nlines_found_in_order(i)-1) = 0

            intarr_nlines_found_in_order(i) = intarr_nlines_found_in_order(i)-1
          endfor
;          stop
        end else begin
          j = j+1
        end
      endelse
    end
  endfor
  free_lun,lunb

  ; --- write database file
  str_ecfilename_out = strmid(str_filelist,0,strpos(str_filelist,'/',/REVERSE_SEARCH))+'/database/ecref'
  if b_thar then begin
    str_ecfilename_out = str_ecfilename_out+'ThAr_UCLES'
  end else begin
    str_ecfilename_out = str_ecfilename_out+'ThXe_UCLES'
  end
  str_ecfilename = strmid(str_ecfilename_out,strpos(str_ecfilename_out,'/',/REVERSE_SEARCH)+3)
  openw,lunec,str_ecfilename_out,/GET_LUN
    printf,lunec,'# Date'
    printf,lunec,'begin   ecidentify '+str_ecfilename
    printf,lunec,'        id      '+str_ecfilename
    printf,lunec,'        task    ecidentify'
    printf,lunec,'        image   '+str_ecfilename
    str_line = '        features'
    if n_elements(strarr_out(*,0)) lt 1000 then begin
      str_line = str_line+'        '
    end else begin
      str_line = str_line+'       '
    end
    str_line = str_line+strtrim(string(total(intarr_nlines_found_in_order)),2)
    printf,lunec,str_line

    for i=0ul, n_elements(strarr_filenames)-1 do begin
      if intarr_nlines_found_in_order(i) gt 0 then begin
        for j=0ul, intarr_nlines_found_in_order(i)-1 do begin
          str_line = string(i+1,FORMAT='(I19)')+string(i+1,FORMAT='(I5)')+string(double(strarr_out(i,j,11)),FORMAT='(F9.2)')
          if double(strarr_out(i,j,11)) ge 1000. then begin
            str_out = string(double(strarr_out(i,j,11)),FORMAT='(F12.5)')
          end else begin
            str_out = string(double(strarr_out(i,j,11)),FORMAT='(F12.6)')
          end
          str_line = str_line+str_out+string(double(strarr_out(i,j,0)),FORMAT='(F12.4)')+'   5.0  1  1'

          ; --- reject lines with dv > tolerance
          print,'checking line strarr_out(i=,',i,',j=',j,',*) = ',strarr_out(i,j,*)
          dbl_dv = abs(dbl_speed_of_light*(double(strarr_out(i,j,0)) / double(strarr_out(i,j,5)) - 1.))
          print,'dbl_dv = ',dbl_dv,', dbl_dv_tolerance = ',dbl_dv_tolerance
          b_print = 1
          if dbl_dv gt dbl_dv_tolerance then b_print = 0
          if b_print then begin
            printf,lunec,str_line
          endif
        endfor
      endif
    endfor
    printf,lunec,'        slope   0'
  free_lun,lunec




  str_indexfile = strmid(str_filelist,0,strpos(str_filelist,'/',/REVERSE_SEARCH))+'/plots_for_line_identification/Th'
  if b_thar then begin
    str_indexfile = str_indexfile+'Ar/index.html'
  end else begin
    str_indexfile = str_indexfile+'Xe/index.html'
  end
  openw,lunind,str_indexfile,/GET_LUN
  printf,lunind,'<html><body><center>'
  for i=0ul, n_elements(strarr_filenames)-1 do begin

    set_plot,'ps'
    str_plotname_ident = strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'/',/REVERSE_SEARCH))+'/plots_for_line_identification/Th'
    if b_thar then begin
      str_plotname_ident = str_plotname_ident+'Ar/'
    end else begin
      str_plotname_ident = str_plotname_ident+'Xe/'
    end
    str_plotname_ident = str_plotname_ident+strmid(strarr_filenames(i),strpos(strarr_filenames(i),'/',/REVERSE_SEARCH)+1)
    str_plotname_ident = strmid(str_plotname_ident,0,strpos(str_plotname_ident,'.',/REVERSE_SEARCH))+'_identified.ps'
    device,filename=str_plotname_ident,/color
      loadct,0
      xmin = min(dblarr_spec_all_orders(i,*,0))
      xmax = max(dblarr_spec_all_orders(i,*,0))
      ymin = 0.
      ymax = 10000.;max(dblarr_spec(*,1))
      plot,dblarr_spec_all_orders(i,*,0),$
           dblarr_spec_all_orders(i,*,1),$
           xtitle='Air Wavelength ['+STRING("305B)+']',$
           ytitle='Flux [arbitrary units]',$
           xrange=[xmin,xmax],$
           xstyle=1,$
           yrange=[ymin,ymax+ymax/2.5],$
           ystyle=1,$
           position=[0.13,0.09,0.97,0.995]
      loadct,13
      ;print,'strarr_pos_ion_lines_found_in_order = ',strarr_pos_ion_lines_found_in_order
;      stop
      for j=0,intarr_nlines_found_in_order(i)-1 do begin
        oplot,dblarr_lines_found_in_order(i,j,*,0),$
              dblarr_lines_found_in_order(i,j,*,1),$
              color=(j+1) * 255 / (intarr_nlines_found_in_order(i)+1)
        oplot,[double(strarr_pos_ion_lines_found_in_order(i,j,0)),double(strarr_pos_ion_lines_found_in_order(i,j,0))],$
              [ymax+ymax/20.,ymax+ymax/200.]
        xyouts,double(strarr_pos_ion_lines_found_in_order(i,j,0))+(xmax-xmin)/200.,$
               ymax+ymax/15.,$
               strmid(strarr_pos_ion_lines_found_in_order(i,j,0),0,strpos(strarr_pos_ion_lines_found_in_order(i,j,0),'.')+5)+' '+strarr_pos_ion_lines_found_in_order(i,j,1),$
               orientation=90,$
               charsize=0.5
      endfor
    device,/close
    set_plot,'x'
    str_giffilename = strmid(str_plotname_ident,0,strpos(str_plotname_ident,'.',/REVERSE_SEARCH))+'.gif'
    spawn,'ps2gif '+str_plotname_ident+' '+str_giffilename
    printf,lunind,'<h3>Order '+strtrim(string(i+1),2)+'</h3><br>'
    printf,lunind,'<a href="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"><img src="'+strmid(str_giffilename,strpos(str_giffilename,'/',/REVERSE_SEARCH)+1)+'"></a><br><hr><br>'
  endfor
  printf,lunind,'</center></body></html>'
  free_lun,lunind

  ; --- print lines found to file
  strarr_lines_to_print = strarr(total(intarr_nlines_found_in_order),4)
  i_nlines = 0
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    if intarr_nlines_found_in_order(i) gt 0 then begin
      for j=0ul, intarr_nlines_found_in_order(i)-1 do begin
        indarr_found = where(strarr_lines_to_print(*,0) eq strarr_out(i,j,0))
        if indarr_found(0) lt 0 then begin
          strarr_lines_to_print(i_nlines,*) = strarr_out(i,j,0:3);+' '+strarr_out(i,j,1)+' '+strarr_out(i,j,2)+' '+strarr_out(i,j,3);+' '+strtrim(string(dblarr_alpha(indarr_ion(0),indarr_source(0))),2)
          i_nlines = i_nlines + 1
        endif
      endfor
    endif
  endfor
  for i=0ul, i_nlines-1 do begin
    printf,lun,strarr_lines_to_print(i,0)+' '+strarr_lines_to_print(i,1)+' '+strarr_lines_to_print(i,2)+' '+strarr_lines_to_print(i,3)
  endfor
  free_lun,lun

end
