pro rave_plot_spectra
  i_col_date = 15
  i_col_fieldname = 16
  i_col_fibre = 18
  i_col_teff = 19
  i_col_snr = 35

  b_create_list = 0

  str_spectrafilename = '/home/azuri/daten/papers/rave/spc/spectra.list'
  str_ravefilename = '/home/azuri/daten/rave/rave_data/release8/rave_internal_dr8_stn_gt_20.dat'

  str_spectrafilename_out = strmid(str_spectrafilename,0,strpos(str_spectrafilename,'.',/REVERSE_SEARCH))+'_found.list'
  print,'str_spectrafilename_out = ',str_spectrafilename_out

  if b_create_list then begin

    strarr_spectra = readfiletostrarr(str_spectrafilename,' ',I_NLINES=i_nspectra)
    strarr_data = readfiletostrarr(str_ravefilename,' ',I_NLINES=i_nlines)

    openw,lun,str_spectrafilename_out,/GET_LUN
    for i=0ul, i_nspectra-1 do begin
      i_pos_slash = strpos(strarr_spectra(i),'/')
      str_date = strmid(strarr_spectra(i),0,i_pos_slash)
      str_field = strmid(strarr_spectra(i),i_pos_slash+1,7)
      l_fibre = long(strmid(strarr_spectra(i),i_pos_slash+15,3))
      print,'i=',i,': date = '+str_date+', field = '+str_field+', l_fibre = ',l_fibre

      indarr_date = where(strarr_data(*,i_col_date) eq str_date)
      if indarr_date(0) ne -1 then begin
        indarr_field = where(strarr_data(indarr_date,i_col_fieldname) eq str_field)
        if indarr_field(0) ne -1 then begin
          print,'strarr_data(indarr_date(indarr_field),i_col_fibre)',strarr_data(indarr_date(indarr_field),i_col_fibre)
          indarr_fibre = where(long(strarr_data(indarr_date(indarr_field),i_col_fibre)) eq l_fibre)
          if indarr_fibre(0) ne -1 then begin
            str_teff = strarr_data(indarr_date(indarr_field(indarr_fibre)),i_col_teff)
            dbl_snr = double(strarr_data(indarr_date(indarr_field(indarr_fibre)),i_col_snr))
            if dbl_snr gt 100 then begin
              print,'found star with teff = '+str_teff+' K'
              printf,lun,strarr_spectra(i)+' '+str_teff
            end else begin
              print,'star ',i,': snr(=',dbl_snr,') too low'
            endelse
          end else begin
            print,'star ',i,' not found in fibres'
          endelse
        end else begin
          print,'star ',i,' not found in field'
        endelse
      end else begin
        print,'star ',i,' not found in date'
      endelse
    endfor
    free_lun,lun
  endif

  str_path = strmid(str_spectrafilename,0,strpos(str_spectrafilename,'/',/REVERSE_SEARCH)+1)
  print,'str_path = <'+str_path+'>'

  str_filelist = str_spectrafilename_out; strmid(str_spectrafilename_out,strpos(str_spectrafilename_out,'/',/REVERSE_SEARCH)+1)
  print,'str_filelist = <'+str_filelist+'>'

  str_texfile = '/home/azuri/entwicklung/tex/rave/good_spectra.tex'
  print,'str_texfile = <'+str_texfile+'>'

  rave_plot_good_spectra,STR_PATH=str_path,STR_FILELIST=str_filelist,STR_TEXFILE=str_texfile
end
