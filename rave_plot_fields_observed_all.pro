pro rave_plot_fields_observed_all

  dblarr_irange=[9.,10.]

  fieldsfile = '/suphys/azuri/daten/rave/rave_data/release5/fields_lon_lat_small_new-5x5.dat'
  ravedatafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles.dat'
  besancondatafile = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat'
  str_temp = strtrim(string(dblarr_irange(0)),2)
  str_plotname_root = '/home/azuri/daten/rave/rave_data/release5/rave_fields_observed_I'+strmid(str_temp,0,strpos(str_temp,'.')+2)+'-'

  str_temp = strtrim(string(dblarr_irange(1)),2)
  str_plotname_root = str_plotname_root+strmid(str_temp,0,strpos(str_temp,'.')+2)

  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor

; --- rave
  i_ndatalines = countlines(ravedatafile)
  print,'rave_plot_fields_observed_all: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end
  strarr_ravedata_all = readfiletostrarr(ravedatafile,' ')
  dblarr_ravedata = dblarr(i_ndatalines,9)
  dblarr_ravedata(*,0) = double(strarr_ravedata_all(*,3))
  dblarr_ravedata(*,1) = double(strarr_ravedata_all(*,4))
  dblarr_ravedata(*,2) = double(strarr_ravedata_all(*,12)); --- I [mag]
  dblarr_ravedata(*,3) = double(strarr_ravedata_all(*,5)) ; --- vrad
  dblarr_ravedata(*,4) = double(strarr_ravedata_all(*,12)); --- I [mag]
  dblarr_ravedata(*,5) = double(strarr_ravedata_all(*,17)) ; --- Teff [K]
  dblarr_ravedata(*,6) = double(strarr_ravedata_all(*,19)); --- [Fe/H]
  dblarr_ravedata(*,7) = double(strarr_ravedata_all(*,20)); --- [alpha/Fe]
  dblarr_ravedata(*,8) = double(strarr_ravedata_all(*,18)); --- log g

; --- besancon
  i_ndatalines = countdatlines(besancondatafile)
  print,'rave_plot_fields_observed_all: i_ndatalines = ',i_ndatalines
  if i_ndatalines eq 0 then begin
    problem=1
    return
  end

  strarr_besancondata_all = readfiletostrarr(besancondatafile,' ')
  dblarr_besancondata = dblarr(i_ndatalines,3)
  print,'rave_plot_fields_observed_all: size(strarr_besancondata_all) = ',size(strarr_besancondata_all),', size(dblarr_besancondata) = ',size(dblarr_besancondata)
  dblarr_besancondata(*,0) = double(strarr_besancondata_all(*,5))
  dblarr_besancondata(*,1) = double(strarr_besancondata_all(*,6))
  print,'rave_plot_fields_observed_all: besancondatafile "'+besancondatafile+'" read'

  dblarr_besancondata(*,2) = double(strarr_besancondata_all(*,2)) ; --- Imag

  ; --- calibrate Metallicities
;  dblarr_mH = dblarr_ravedata(*,6)
;  dblarr_aFe = dblarr_ravedata(*,7)
;  dblarr_logg = dblarr_ravedata(*,8)
;  rave_calibrate_metallicities,dblarr_mH,$
;                               dblarr_aFe,$
;                               dblarr_logg,$
;                               REJECTVALUE=99.9,$
;                               REJECTERR=1.,$
;                               OUTPUT=output
;  print,'rave_besancon_plot_all: size(output) = ',size(output)
;  print,'rave_besancon_plot_all: size(strarr_ravedata) = ',size(strarr_ravedata)
;  dblarr_ravedata(*,6) = output

  for k=0UL,2 do begin
    if k eq 0 then begin
      dbl_maxpercentage = 20.
    end else if k eq 1 then begin
      dbl_maxpercentage = 50.
    end else begin
      dbl_maxpercentage = 100.
    end

    ; --- Teff
    dbl_reject = 0.00000001
    dbl_err_reject = 0.0001
    i_dat = 5
    str_maxpercentage = strtrim(string(dbl_maxpercentage),2)
    str_maxpercentage = strmid(str_maxpercentage,0,strpos(str_maxpercentage,'.'))
    str_plotname = str_plotname_root+'_Teff_'+str_maxpercentage+'.ps'
    rave_plot_fields_observed,DBLARR_RAVEDATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                             DBLARR_BESANCONDATA=dblarr_besancondata,$    ; --- dblarr(*,3)
                             DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                             DBL_REJECT=dbl_reject,$      ; --- double
                             DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                             I_LON=0,$                ; --- int
                             I_LAT=1,$
                             I_DAT=i_dat,$
                             I_IMAG=2,$
                             DBLARR_IRANGE=dblarr_irange,$
                             STR_PLOTNAME=str_plotname,$
                             DBL_MAXPERCENTAGE=dbl_maxpercentage

    ; --- log g
    dbl_reject = 99.9
    dbl_err_reject = 1.
    i_dat = 8
    str_plotname = str_plotname_root+'_logg_'+str_maxpercentage+'.ps'
    rave_plot_fields_observed,DBLARR_RAVEDATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                              DBLARR_BESANCONDATA=dblarr_besancondata,$    ; --- dblarr(*,3)
                              DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                              DBL_REJECT=dbl_reject,$      ; --- double
                              DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                              I_LON=0,$                ; --- int
                              I_LAT=1,$
                              I_DAT=i_dat,$
                              I_IMAG=2,$
                              DBLARR_IRANGE=dblarr_irange,$
                              STR_PLOTNAME=str_plotname,$
                              DBL_MAXPERCENTAGE=dbl_maxpercentage

    ; --- M/H
    dbl_reject = 99.9
    dbl_err_reject = 1.
    i_dat = 6
    str_plotname = str_plotname_root+'_MH_'+str_maxpercentage+'.ps'
    rave_plot_fields_observed,DBLARR_RAVEDATA=dblarr_ravedata,$    ; --- dblarr(*,3)
                              DBLARR_BESANCONDATA=dblarr_besancondata,$    ; --- dblarr(*,3)
                              DBLARR_FIELDS=dblarr_fields,$; --- dblarr(*,4)
                              DBL_REJECT=dbl_reject,$      ; --- double
                              DBL_ERR_REJECT=dbl_err_reject,$      ; --- double
                              I_LON=0,$                ; --- int
                              I_LAT=1,$
                              I_IMAG=2,$
                              DBLARR_IRANGE=dblarr_irange,$
                              I_DAT=i_dat,$
                              STR_PLOTNAME=str_plotname,$
                              DBL_MAXPERCENTAGE=dbl_maxpercentage

  endfor

end
