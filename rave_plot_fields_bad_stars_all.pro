pro rave_plot_fields_bad_stars_all

  fieldsfile = '/suphys/azuri/daten/rave/rave_data/release5/fields_lon_lat_small_new-5x5.dat'
  ravedatafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808.dat'

  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor

  i_ndatalines = countlines(ravedatafile)
  print,'rave_plot_two_cols: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end
  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
  dblarr_ravedata = dblarr(i_ndatalines,9)
  dblarr_ravedata(*,0) = double(strarr_ravedata_all(*,3))
  dblarr_ravedata(*,1) = double(strarr_ravedata_all(*,4))

  print,'rave_plot_two_cols: ravedatafile "'+ravedatafile+'" read'

  dblarr_ravedata(*,2) = double(strarr_ravedata_all(*,5)) ; --- vrad
  dblarr_ravedata(*,3) = double(strarr_ravedata_all(*,17)) ; --- Teff [K]
  dblarr_ravedata(*,4) = double(strarr_ravedata_all(*,19)); --- [Fe/H]
  dblarr_ravedata(*,5) = double(strarr_ravedata_all(*,20)); --- [alpha/Fe]
  dblarr_ravedata(*,6) = double(strarr_ravedata_all(*,18)); --- log g

  ; --- calibrate Metallicities
  dblarr_mH = dblarr_ravedata(*,4)
  dblarr_aFe = dblarr_ravedata(*,5)
  dblarr_logg = dblarr_ravedata(*,6)
  rave_calibrate_metallicities,dblarr_mH,$
                               dblarr_aFe,$
                               dblarr_logg,$
                               REJECTVALUE=99.9,$
                               REJECTERR=1.,$
                               OUTPUT=output
  print,'rave_besancon_plot_all: size(output) = ',size(output)
  print,'rave_besancon_plot_all: size(strarr_ravedata) = ',size(strarr_ravedata)
  dblarr_ravedata(*,4) = output

  dbl_maxpercentage = 20.
  dbl_reject = 0.00000001
  dbl_err_reject = 0.0001
  i_dat = 3
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_Teff_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 50.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_Teff_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 100.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_Teff_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 20.
  dbl_reject = 99.9
  dbl_err_reject = 1.
  i_dat = 6
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_logg_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 50.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_logg_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 100.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_logg_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 20.
  dbl_reject = 99.9
  dbl_err_reject = 1.
  i_dat = 4
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_MH_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 50.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_MH_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

  dbl_maxpercentage = 100.
  str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
  str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
  str_plotname = '/home/azuri/daten/rave/rave_data/release5/rave_fields_bad_stars_MH_'+str_maxpercentage+'.ps'
  rave_plot_fields_bad_stars,DBLARR_DATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

end
