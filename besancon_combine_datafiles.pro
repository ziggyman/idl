pro besancon_combine_datafiles,STR_FIELDS = str_fields,$
                               STR_FILENAMES = str_filenames,$
                               STR_OUTFILE = str_outfile,$
                               B_CALC_VRAD = b_calc_vrad,$
                               B_EXTINCTION = b_extinction,$
                               B_JMK = b_jmk,$
                               B_EXT_NEW = b_ext_new

  if keyword_set(B_EXTINCTION) then begin
    i_col_I     = 0
    i_col_b_v    = 1 ; J-K
    i_col_v_i   = 3 ; I-J
    i_col_v_k   = 4 ; I-K
    i_col_vrad  = 7
    i_col_uu    = 8
    i_col_vv    = 9
    i_col_ww    = 10
    i_col_type  = 12
    i_col_lteff = 14
    i_col_logg  = 15
    i_col_age   = 16
    i_col_MH    = 20
    i_col_l     = 21
    i_col_b     = 22
    i_col_dist  = 25
  end else begin
    i_col_dist  = 0
    i_col_type  = 2
    i_col_lteff = 4
    i_col_logg  = 5
    i_col_age   = 6
    i_col_b_v    = 8 ; B-V, JmK: J-K
    i_col_v_i   = 10 ; V-I, JmK: I-J
    i_col_v_k   = 11 ; V-K, JmK: I-K
    i_col_I     = 12
    i_col_vrad  = 15
    i_col_uu    = 16
    i_col_vv    = 17
    i_col_ww    = 18
    i_col_MH    = 19
    i_col_l     = 20
    i_col_b     = 21
  end

  if not keyword_set(B_CALC_VRAD) then begin
    b_calc_vrad = 0
  endif

  ; --- write list of data-file names
  if not keyword_set(STR_FIELDS) then begin
    str_fields = '/suphys/azuri/daten/rave/rave_data/release3/fields_lon_lat_small_new.dat'
  end
  strarr_fields = readfiletostrarr(str_fields,' ')
  if keyword_set(B_EXTINCTION) and keyword_set(B_EXT_NEW) then begin
    strarr_filenames = strarr_fields(*,0)
  end else begin
    strarr_filenames = strarr_fields(*,4)
  end
  print,'strarr_filenames = ',strarr_filenames

  if not keyword_set(STR_FILENAMES) then begin
    str_filenames = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/files_stars.text'
  end
  if not keyword_set(STR_OUTFILE) then begin
    str_outfile = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/besancon_230-315_-25-25_JmK_ext_new.dat'
  end

  openw,lun,str_filenames,/GET_LUN
    for i=0UL, n_elements(strarr_filenames)-1 do begin
      str_temp = strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'.',/REVERSE_SEARCH))+'.dat'
      besancon_write_stars,strarr_filenames(i),$
                           str_temp,$
                           B_EXTINCTION = b_extinction
      printf,lun,str_temp
    endfor
  free_lun,lun

  ; --- read data-file names
  strarr_filenames = readfiletostrarr(str_filenames,' ')
  print,'strarr_filenames = ',strarr_filenames

  i_nlines_all = 0
  openw,lun,str_outfile,/GET_LUN
    printf,lun,'#0:l 1:b 2:Imag 3:Vmag(JmK:Jmag) 4:Kmag 5:logTeff 6:logg 7:vrad 8:M/H 9:dist 10:Type 11:age 12:uu 13:vv 14:ww 15:height 16:r_cent'

    for i=0UL,n_elements(strarr_filenames)-1 do begin
      i_nlines = countlines(strarr_filenames(i))
      i_nlines_all = i_nlines_all + i_nlines
      strarr_lines = readfiletostrarr(strarr_filenames(i),' ')

      ; --- calculate colours
; ---   i_col_b_v    = 8 ; B-V, JmK: J-K
; ---   i_col_v_i   = 10 ; V-I, JmK: I-J
; ---    i_col_v_k   = 11 ; V-K, JmK: I-K
      dblarr_i = double(strarr_lines(*,i_col_i))
      if not keyword_set(B_JMK) then begin
        dblarr_vmi = double(strarr_lines(*,i_col_v_i))
        dblarr_vmk = double(strarr_lines(*,i_col_v_k))
        dblarr_v = dblarr_vmi + dblarr_i
        dblarr_k = dblarr_v - dblarr_vmk
        strarr_print_vj = strtrim(string(dblarr_v),2)
      end else begin
        dblarr_imj = double(strarr_lines(*,i_col_v_i))
        dblarr_imk = double(strarr_lines(*,i_col_v_k))
        dblarr_j = dblarr_i - dblarr_imj
        dblarr_k = dblarr_i - dblarr_imk
        strarr_print_vj = strtrim(string(dblarr_j),2)
      end
      strarr_k = strtrim(string(dblarr_k),2)

      for j=0UL, i_nlines - 1 do begin
        if keyword_set(B_EXTINCTION) then begin
          str_string_print = strtrim(string(alog10(double(strarr_lines(j,i_col_lteff)))),2)
        end else begin
          str_string_print = strarr_lines(j,i_col_lteff)
        end
;        printf,lun,'#0:l 1:b 2:Imag 3:Vmag(JmK:Jmag) 4:Kmag 5:logTeff 6:logg 7:vrad 8:M/H 9:dist 10:Type 11:age 12:uu 13:vv 14:ww 15:height 16:r_cent'
        str_string_print = strarr_lines(j,i_col_l)+' '+$;     --- 0
                           strarr_lines(j,i_col_b)+' '+$;     --- 1
                           strarr_lines(j,i_col_I)+' '+$;     --- 2
                           strarr_print_vj(j)+' '+$;          --- 3
                           strarr_k(j)+' '+$;                 --- 4
                           str_string_print+' '+$;            --- 5
                           strarr_lines(j,i_col_logg)+' '+$;  --- 6
                           strarr_lines(j,i_col_vrad)+' '+$;  --- 7
                           strarr_lines(j,i_col_MH)+' '+$;    --- 8
                           strarr_lines(j,i_col_dist)+' '+$;  --- 9
                           strarr_lines(j,i_col_type)+' '+$;  --- 10
                           strarr_lines(j,i_col_age)+' '+$;   --- 11
                           strarr_lines(j,i_col_uu)+' '+$;    --- 12
                           strarr_lines(j,i_col_vv)+' '+$;    --- 13
                           strarr_lines(j,i_col_ww);          --- 14
        printf,lun,str_string_print
      endfor
      print,'i_nlines_all = ',i_nlines_all
    endfor
  free_lun,lun
  if b_calc_vrad then begin
    dblarr_besancon = readfiletodblarr(str_outfile)
    strarr_lines = readfiletostrarr(str_outfile,' ')
    i_nlines_new = countdatlines(str_outfile)
    openw,lun,str_outfile,/GET_LUN
      printf,lun,'#0:l 1:b 2:Imag 3:Vmag(JmK:Jmag) 4:Kmag 5:logTeff 6:logg 7:vrad 8:M/H 9:dist 10:Type 11:age 12:uu 13:vv 14:ww 15:snr 16:height 17:r_cent'
      for i=0ul, i_nlines_new-1 do begin
        vrad_from_uvwlb, DBL_L = dblarr_besancon(i,0),$; [deg]
                         DBL_B = dblarr_besancon(i,1),$; [deg]
                         DBL_UU = dblarr_besancon(i,12),$; [km/s]
                         DBL_VV = dblarr_besancon(i,13),$; [km/s]
                         DBL_WW = dblarr_besancon(i,14),$; [km/s]
;                         DBL_DIST = dbl_dist,$; [kiloparsec]
                         DBL_U_SUN = 10.3,$; [km/s]
                         DBL_V_SUN = 6.3,$; [km/s]
                         DBL_W_SUN = 5.9,$; [km/s]
;                         DBL_R_SUN = dbl_r_sun,$; [kiloparsec]
;                         DBL_V_LSR = dbl_v_lsr,$; [km/s]
                         OUT_DBL_VRAD = out_dbl_vrad; [km/s]
        printf,lun,strarr_lines(i,0)+' '+$; --- 0
                   strarr_lines(i,1)+' '+$;  --- 1
                   strarr_lines(i,2)+' '+$;     --- 2
                   strarr_lines(i,3)+' '+$;    --- 3
                   strarr_lines(i,4)+' '+$;     --- 4
                   strarr_lines(i,5)+' '+$;     --- 5
                   strarr_lines(i,6)+' '+$;    --- 6
                   strtrim(string(out_dbl_vrad),2)+' '+$;  --- 7
                   strarr_lines(i,8)+' '+$;  --- 8
                   strarr_lines(i,9)+' '+$;  --- 9
                   strarr_lines(i,10)+' '+$;   --- 10
                   strarr_lines(i,11)+' '+$;   --- 11
                   strarr_lines(i,12)+' '+$;  --- 12
                   strarr_lines(i,13)+' '+$;   --- 13
                   strarr_lines(i,14);+' '+$;   --- 14
      endfor

    free_lun,lun
  end

  spawn,'wc '+str_outfile

end
