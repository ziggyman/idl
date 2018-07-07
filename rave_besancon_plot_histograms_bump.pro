pro rave_besancon_plot_histograms_bump
  str_path = '/home/azuri/daten/besancon/lon-lat/histograms/find_bump/'
  str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snrdec_snr_gt_20_samplex1_IDenis2MASS_9ltIlt12_0.dat'
  ;str_datafile_besancon = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_mh+snrdec_snr_gt_20_samplex1_IDenis2MASS_9ltIlt12_0_with_errors_height_rcent_errdivby_2.00_2.00_2.00_2.00_2.00.dat'

  i_col_logg = 6
  i_col_snr = 15

  dbl_bin_width=1.
  nbins=1

  strarr_data_besancon = readfiletostrarr(str_datafile_besancon,' ',I_NCOLS = i_ncols)
  dblarr_logg_besancon = double(strarr_data_besancon(*,i_col_logg))
  if i_ncols gt i_col_snr then begin
    dblarr_snr_besancon = double(strarr_data_besancon(*,i_col_snr))
    get_bin_width,DBLARR_DATA_A=dblarr_snr_besancon,$; --- in
                  DBLARR_DATA_B=dblarr_snr_besancon,$; --- in
                  DBLARR_BIN_RANGE=[0.,150.],$; --- in
                  I_NBINS_MIN=25,$; --- in
                  I_NBINS_MAX=30,$; --- in
                  DBL_BIN_WIDTH=dbl_bin_width,$; --- out
                  NBINS=nbins; --- out

    dblarr_x = dblarr(nbins)
    dblarr_x(0) = dbl_bin_width/2.
    for i=1,nbins-1 do begin
      dblarr_x(i) = dblarr_x(i-1) + dbl_bin_width
    endfor

    dblarr_hist = histogram(dblarr_snr_besancon,MIN=0.,MAX=150.,BINSIZE=dbl_bin_width)
    print,'dblarr_hist = ',dblarr_hist

    set_plot,'ps'
    str_filename = str_path+strmid(str_datafile_besancon,strpos(str_datafile_besancon,'/',/REVERSE_SEARCH))
    str_filename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_snr.ps'
    device,filename=str_filename
    plot,dblarr_x,dblarr_hist
;  if not keyword_set(DBLARR_DATA_A) or not keyword_set(DBLARR_DATA_B) or not keyword_set(DBLARR_BIN_RANGE) or not keyword_set(I_NBINS_MIN) or not keyword_set(I_NBINS_MAX) or not keyword_set(DBL_BIN_WIDTH) or not keyword_set(NBINS) then begin
    device,/close
    set_plot,'x'
  endif
  get_bin_width,DBLARR_DATA_A=dblarr_logg_besancon,$; --- in
                DBLARR_DATA_B=dblarr_logg_besancon,$; --- in
                DBLARR_BIN_RANGE=[0.,5.5],$; --- in
                I_NBINS_MIN=25,$; --- in
                I_NBINS_MAX=30,$; --- in
                DBL_BIN_WIDTH=dbl_bin_width,$; --- out
                NBINS=nbins; --- out

  dblarr_x = dblarr(nbins)
  dblarr_x(0) = dbl_bin_width/2.
  for i=1,nbins-1 do begin
    dblarr_x(i) = dblarr_x(i-1) + dbl_bin_width
  endfor

  dblarr_hist = histogram(dblarr_logg_besancon,MIN=0.,MAX=5.5,BINSIZE=dbl_bin_width)
  print,'dblarr_hist = ',dblarr_hist

  set_plot,'ps'
  str_filename = str_path+strmid(str_datafile_besancon,strpos(str_datafile_besancon,'/',/REVERSE_SEARCH))
  str_filename = strmid(str_filename,0,strpos(str_filename,'.',/REVERSE_SEARCH))+'_logg.ps'
  device,filename=str_filename
  plot,dblarr_x,dblarr_hist
;  if not keyword_set(DBLARR_DATA_A) or not keyword_set(DBLARR_DATA_B) or not keyword_set(DBLARR_BIN_RANGE) or not keyword_set(I_NBINS_MIN) or not keyword_set(I_NBINS_MAX) or not keyword_set(DBL_BIN_WIDTH) or not keyword_set(NBINS) then begin
  device,/close
  set_plot,'x'
end
