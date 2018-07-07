pro rave_plot_star_positions_lon_lat

;  b_input = 2
;  b_sanjib = 0
;  i_rave_dr = 8
;  b_sample = 0
  for lll = 0,2 do begin
    if lll eq 0 then begin
      b_giants_only = 0
      b_dwarfs_only = 0
    end else if lll eq 1 then begin
      b_giants_only = 1
      b_dwarfs_only = 0
    end else begin
      b_giants_only = 0
      b_dwarfs_only = 1
    endelse

    int_i_start = 0
    if b_giants_only or b_dwarfs_only then $
      int_i_start = 3
    for i=int_i_start, 9 do begin
      i = 9
      i_col_logg = -1
      dbl_max_value = 0
      if i eq 0 then begin
        filename = '/suphys/azuri/daten/rave/input_catalogue/ric1+2_lon_lat.dat'
        i_col_lon = 1
        i_col_lat = 2
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        int_nbins_min_x = 100
        int_nbins_max_x = 220
        int_nbins_min_y = 100
        int_nbins_max_y = 220
      end else if i eq 1 then begin
        filename = '/suphys/azuri/daten/rave/input_catalogue/rave_input.dat'
        i_col_lon = 1
        i_col_lat = 2
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        int_nbins_min_x = 100
        int_nbins_max_x = 220
        int_nbins_min_y = 100
        int_nbins_max_y = 220
      end else if i eq 2 then begin
        filename = '/suphys/azuri/daten/besancon/sanjib_with_errors_errdivby_2.36_3.64_2.84.dat'
        i_col_lon = 5
        i_col_lat = 6
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36
      end else if i eq 3 then begin
        filename = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_samplex1_logg_0_errdivby_1.00_1.00_1.00_1.00.dat'
        i_col_lon = 5
        i_col_lat = 6
        i_col_logg = 20
        outfile = strmid(filename,0,strpos(filename,'/',/REVERSE_SEARCH)+1)+'rave_sample.ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 100
        int_nbins_max_x = 220
        int_nbins_min_y = 100
        int_nbins_max_y = 220
      end else if i eq 4 then begin
        filename = '/suphys/azuri/daten/rave/rave_data/release7/rave_internal_290110_no_doubles.dat'
        i_col_lon = 4
        i_col_lat = 5
        i_col_logg = 20
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 100
        int_nbins_max_x = 220
        int_nbins_min_y = 100
        int_nbins_max_y = 220
      end else if i eq 5 then begin
        filename = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_no_doubles_maxsnr.dat'
        i_col_lon = 5
        i_col_lat = 6
        i_col_logg = 20
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36
      end else if i eq 6 then begin
        filename = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_samplex1_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
        i_col_lon = 5
        i_col_lat = 6
        i_col_logg = 20
        outfile = strmid(filename,0,strpos(filename,'/',/REVERSE_SEARCH)+1)+'rave_final.ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36
      end else if i eq 7 then begin
        filename = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_+snr-i-dec-minus-ic1-gt-20_mh-new+snr-i-dec-giant-dwarf-minus-ic1_with_errors_height_rcent_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
        i_col_lon = 0
        i_col_lat = 1
        i_col_logg = 6
        outfile = strmid(filename,0,strpos(filename,'/',/REVERSE_SEARCH)+1)+'besancon_final.ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36
      end else if i eq 8 then begin
        filename = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK.dat'
        i_col_lon = 0
        i_col_lat = 1
        i_col_logg = 6
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'ps'
        if b_giants_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
        if b_dwarfs_only then $
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36
      end else begin
        dbl_max_value = 1000
        filename = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK.dat'
        filename_rave = '/suphys/azuri/daten/rave/rave_data/release8/rave_internal_dr8_all_with-2MASS-JK_minus-ic1_230-315_-25-25_JmK2MASS_gt_0_5_no_doubles_maxsnr_I2MASS_9ltIlt12_good_STN-gt-20-with-atm-par_samplex1_logg_0_dwarfs_errdivby_2.70_0.75_3.00_1.00_4.00_giants_1.50_1.50_1.80_1.50_2.00.dat'
        i_col_lon = 0
        i_col_lat = 1
        i_col_logg = 6
        i_col_lon_rave = 5
        i_col_lat_rave = 6
        i_col_logg_rave = 20
        outfile = strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH))+'_rave_percent.ps'
        if b_giants_only then begin
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_giants.ps'
          dbl_max_value = 500
        endif
        if b_dwarfs_only then begin
          outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_dwarfs.ps'
          dbl_max_value = 1000
        endif
        int_nbins_min_x = 72
        int_nbins_max_x = 72
        int_nbins_min_y = 36
        int_nbins_max_y = 36

        strarr_data_bes = readfiletostrarr(filename,' ')
        dblarr_logg_bes = double(strarr_data_bes(*,i_col_logg))
        indarr_all = lindgen(n_elements(dblarr_logg_bes))
        if b_giants_only then $
          indarr_all = where(dblarr_logg_bes lt 3.5)
        if b_dwarfs_only then $
          indarr_all = where(dblarr_logg_bes ge 3.5)

        dblarr_longitude_bes = double(strarr_data_bes(indarr_all,i_col_lon))
        dblarr_latitude_bes = double(strarr_data_bes(indarr_all,i_col_lat))

        strarr_data_rave = readfiletostrarr(filename_rave,' ')
        dblarr_logg_rave = double(strarr_data_rave(*,i_col_logg_rave))
        indarr_all = lindgen(n_elements(dblarr_logg_rave))
        if b_giants_only then $
          indarr_all = where(dblarr_logg_rave lt 3.5)
        if b_dwarfs_only then $
          indarr_all = where(dblarr_logg_rave ge 3.5)
        dblarr_longitude_rave = double(strarr_data_rave(indarr_all,i_col_lon_rave))
        dblarr_latitude_rave = double(strarr_data_rave(indarr_all,i_col_lat_rave))
        str_fieldsfile = '/suphys/azuri/daten/rave/rave_data/fields_lon_lat_small_new-5x5_new.dat'
        strarr_fields = readfiletostrarr(str_fieldsfile,' ')

        dblarr_longitude = dblarr(100. * n_elements(strarr_fields(*,0)),2)
        dblarr_latitude = dblarr(100. * n_elements(strarr_fields(*,0)),2)
        dblarr_longitude_no = dblarr(10000. * n_elements(strarr_fields(*,0)),2)
        dblarr_latitude_no = dblarr(10000. * n_elements(strarr_fields(*,0)),2)
        int_nstars_done = 0
        int_nstars_done_no = 0
        for jjj=0,n_elements(strarr_fields(*,0))-1 do begin
          dbl_lon_min = double(strarr_fields(jjj,0))
          dbl_lon_max = double(strarr_fields(jjj,1))
          dbl_lat_min = double(strarr_fields(jjj,2))
          dbl_lat_max = double(strarr_fields(jjj,3))
          indarr_lon_rave = where((dblarr_longitude_rave ge dbl_lon_min) and (dblarr_longitude_rave lt dbl_lon_max))
          indarr_lat_rave = where((dblarr_latitude_rave(indarr_lon_rave) ge dbl_lat_min) and (dblarr_latitude_rave(indarr_lon_rave) lt dbl_lat_max))
          print,'n_elements(indarr_lat_rave) = ',n_elements(indarr_lat_rave)

          indarr_lon_bes = where((dblarr_longitude_bes ge dbl_lon_min) and (dblarr_longitude_bes lt dbl_lon_max))
          indarr_lat_bes = where((dblarr_latitude_bes(indarr_lon_bes) ge dbl_lat_min) and (dblarr_latitude_bes(indarr_lon_bes) lt dbl_lat_max))
          print,'n_elements(indarr_lat_bes) = ',n_elements(indarr_lat_bes)

          dbl_percentage = 100. * double(n_elements(indarr_lat_rave)) / double(n_elements(indarr_lat_bes))
          print,'rave_plot_star_positions_lon_lat: field ',jjj,': dbl_percentage = ',dbl_percentage

          if indarr_lat_rave(0) ge 0 then begin
            int_percentage = ulong(dbl_percentage)
            if dbl_percentage - int_percentage ge 0.5 then $
              int_percentage = int_percentage + 1
            print,'rave_plot_star_positions_lon_lat: field ',jjj,': int_percentage = ',int_percentage
;            stop
            for kkk=int_nstars_done, int_nstars_done + int_percentage-1 do begin
              dblarr_longitude(kkk) = dbl_lon_min + ((dbl_lon_max - dbl_lon_min) / 2.)
              dblarr_latitude(kkk) = dbl_lat_min + ((dbl_lat_max - dbl_lat_min) / 2.)
;              print,'rave_plot_star_positions_lon_lat: dblarr_longitude(kkk=',kkk,') set to ',dblarr_longitude(kkk)
            endfor
            int_nstars_done = int_nstars_done + long(dbl_percentage)
;            print,'rave_plot_star_positions_lon_lat: int_nstars_done set to ',int_nstars_done
          end
          if indarr_lat_bes(0) ge 0 then begin
            for kkk=int_nstars_done_no, int_nstars_done_no + n_elements(indarr_lat_bes)-1 do begin
              dblarr_longitude_no(kkk) = dbl_lon_min + ((dbl_lon_max - dbl_lon_min) / 2.)
              dblarr_latitude_no(kkk) = dbl_lat_min + ((dbl_lat_max - dbl_lat_min) / 2.)
;              print,'rave_plot_star_positions_lon_lat: dblarr_longitude_no(kkk=',kkk,') set to ',dblarr_longitude_no(kkk)
            endfor
            int_nstars_done_no = int_nstars_done_no + n_elements(indarr_lat_bes)
            print,'rave_plot_star_positions_lon_lat: int_nstars_done_no set to ',int_nstars_done_no
          endif
        endfor
        dblarr_longitude = dblarr_longitude(0:int_nstars_done-1)
        dblarr_latitude = dblarr_latitude(0:int_nstars_done-1)
        ;stop
      endelse
      dblarr_xrange = [0,360]
      dblarr_yrange = [-90,90]
      dblarr_position = [0.155,0.155,0.965,0.995]
      str_xtitle = 'Galactic Longitude [deg]'
      str_ytitle = 'Galactic Latitude [deg]'
      dbl_charsize = 1.8
      dbl_charthick = 3.
      dbl_thick = 3.
      i_nxticks = 4
      i_nyticks = 4
      str_xtickformat = '(I3)'
      str_ytickformat = '(I3)'
      if i ne 9 then begin

        strarr_data = readfiletostrarr(filename,' ')
        indarr_all = lindgen(n_elements(strarr_data(*,0)))
        if i_col_logg ge 0 then begin
          dblarr_logg = double(strarr_data(*,i_col_logg))
          if b_giants_only then $
            indarr_all = where(dblarr_logg lt 3.5)
          if b_dwarfs_only then $
            indarr_all = where(dblarr_logg ge 3.5)
        endif
        dblarr_longitude = double(strarr_data(indarr_all,i_col_lon))
        dblarr_latitude = double(strarr_data(indarr_all,i_col_lat))
        if i eq 1 then begin
          euler,dblarr_longitude,dblarr_latitude,dblarr_longitude_temp,dblarr_latitude_temp,1
          dblarr_longitude = dblarr_longitude_temp
          dblarr_longitude_temp = 0
          dblarr_latitude = dblarr_latitude_temp
          dblarr_latitude_temp = 0
        end
        set_plot,'ps'
        device,filename=outfile
        plot,dblarr_longitude,$
            dblarr_latitude,$
            psym=2,$
            symsize=0.1,$
            xrange=dblarr_xrange,$
            yrange=dblarr_yrange,$
            xstyle=1,$
            ystyle=1,$
            xtitle=str_xtitle,$
            ytitle=str_ytitle,$
            position=dblarr_position,$
      ;       position=[0.17,0.17,0.995,0.91],$
      ;       title='observed RAVE stars',$
            charsize=dbl_charsize,$
            charthick=dbl_charthick,$
            thick=dbl_thick,$
            xticks=i_nxticks,$
            yticks=i_nyticks,$
            xtickformat = str_xtickformat,$
            ytickformat = str_ytickformat
        device,/close
        spawn,'epstopdf --outfile='+strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH)+1)+'pdf '+outfile
        spawn,'ps2gif '+outfile+' '+strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH)+1)+'gif'
        reduce_pdf_size,strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH)+1)+'pdf',strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_small.pdf'
      endif
      dblarr_position_density = [0.155,0.155,0.88,0.995]
      str_outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH)) + '_density'
      if i eq 9 then $
        int_end = 1 $
      else $
        int_end = 0
      for j=0,int_end do begin
        if j eq 1 then begin
          dblarr_longitude = dblarr_longitude_no
          dblarr_latitude = dblarr_latitude_no
          str_outfile = str_outfile + '_bes-numbers'
        end else begin
;          print,'dblarr_longitude = ',dblarr_longitude
;          print,'dblarr_latitude = ',dblarr_latitude
;          stop
        endelse
        plot_density,I_DBLARR_X          = dblarr_longitude,$
                    I_DBLARR_Y          = dblarr_latitude,$
                    I_DBLARR_RANGE_X    = dblarr_xrange,$
                    I_DBLARR_RANGE_Y    = dblarr_yrange,$
                    I_STR_PLOTNAME_ROOT = str_outfile,$
                    I_DBL_THICK         = dbl_thick,$
                    I_DBL_CHARTHICK     = dbl_charthick,$
                    I_DBL_CHARSIZE      = dbl_charsize,$
                    I_STR_XTITLE        = str_xtitle,$
                    I_STR_YTITLE        = str_ytitle,$
                    I_DBLARR_POSITION   = dblarr_position_density,$
                    I_INT_XTICKS        = i_nxticks,$
                    I_INT_yTICKS        = i_nyticks,$
                    I_STR_XTICKFORMAT   = str_xtickformat,$
                    I_STR_YTICKFORMAT   = str_ytickformat,$
                    I_INT_NBINS_MIN_X   = int_nbins_min_x,$
                    I_INT_NBINS_MAX_X   = int_nbins_max_x,$
                    I_INT_NBINS_MIN_Y   = int_nbins_min_y,$
                    I_INT_NBINS_MAX_Y   = int_nbins_max_y,$
                    I_DBL_MAX_VALUE     = dbl_max_value
        spawn,'epstopdf --outfile='+str_outfile+'.pdf '+str_outfile+'.ps'
        spawn,'ps2gif '+str_outfile+'.ps '+str_outfile+'.gif'
        reduce_pdf_size,str_outfile+'.pdf',str_outfile+'_small.pdf'
      endfor
  ;    stop
    endfor
  endfor
end
