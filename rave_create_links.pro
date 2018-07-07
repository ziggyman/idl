pro rave_create_links

  b_meanfields = 1
  b_small_fields = 0
  b_test = 1
  b_stellar_streams = 0

  if b_meanfields then begin
  ; --- Teff from I_Teff 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_Teff_I9-12_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_1_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_1_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_3_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_3_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_5_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_5_Teff.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_1_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_5_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_1_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_3_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_5_sigma_Teff.pdf temp.tiff'

  ; --- Teff from I_Teff 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_Teff_I9-12_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_1_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_1_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_3_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_3_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_5_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_5_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_1_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_5_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_1_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_3_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_Teff_I9-12_samples_5_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_Teff_I9-12_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_Teff/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_Teff_I9-12_I.pdf temp.tiff'


  ; --- vrad from I_vrad 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_1_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_1_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_3_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_3_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_5_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_5_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_mean_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_mean_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_mean_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_sigma_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_sigma_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_sigma_vrad.pdf temp.tiff'

  ; --- vrad from I_vrad 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_1_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_1_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_3_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_3_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_5_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_5_vrad.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_mean_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_mean_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_mean_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_mean_vrad.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_sigma_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_sigma_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_sigma_vrad.pdf temp.tiff'

  ; --- I from I_vrad 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_1_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_1_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_3_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_3_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_5_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_5_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_sigma_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_sigma_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_sigma_I.pdf temp.tiff'


  ; --- I from I_vrad 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_I_vrad_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_1_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_1_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_3_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_3_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_5_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_5_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_mean_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_1_sigma_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_3_sigma_I.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/I_vrad/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Imag.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_I_vrad_I9-12_samples_5_sigma_I.pdf temp.tiff'


  ; --- MH from vrad_MH 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_vrad_MH_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/fields_kst_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_vrad_MH_I9-12_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_1_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_1_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_3_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_3_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_5_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_5_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_1_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_1_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_3_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_3_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_5_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_5_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_1_sigma_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_3_sigma_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_5_sigma_MH.pdf temp.tiff'

  ; --- MH from vrad_MH 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/fields_kst_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_vrad_MH_I9-12_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/fields_kst_vrad.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_vrad_MH_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_1_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_1_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_3_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_3_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_5_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_5_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_1_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_1_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_3_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_3_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_5_mean_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_5_mean_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_1_sigma_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_3_sigma_MH.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/vrad_MH/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_MH.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_vrad_MH_I9-12_samples_5_sigma_MH.pdf temp.tiff'


  ; --- Teff from Teff_logg 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_1_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_1_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_3_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_3_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_5_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_5_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_Teff.pdf temp.tiff'



    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_Teff_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_Teff_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_Teff_test.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_sigma_Teff.pdf temp.tiff'

  ; --- Teff from Teff_logg 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_1_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_1_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_3_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_3_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_5_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_5_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_Teff.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_sigma_Teff.pdf temp.tiff'


  ; --- logg from Teff_logg 9<I<10
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_1_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_1_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_3_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_3_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_5_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_5_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_logg.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_logg_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_logg_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_logg_test.pdf temp.tiff'




    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_logg_test_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_Teff_test_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_logg_test_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_Teff_test_low.pdf temp.tiff'




    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_logg_test.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_sigma_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_sigma_logg.pdf temp.tiff'

    ; --- logg from Teff_logg 9<I<12
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_Teff.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_vrad.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/fields_kst_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/fields_kst_Teff_logg_I9-12_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_1_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_1_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_3_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_3_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_5_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_5_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_mean_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_mean_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_mean_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_mean_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_1_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_1_sigma_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_3_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_3_sigma_logg.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/Teff_logg/I9.00-12.0/meanfields_lon_lat_samples_5_sigma_logg.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/meanfields_Teff_logg_I9-12_samples_5_sigma_logg.pdf temp.tiff'
  end
  if b_small_fields then begin
    ; --- I = 9-12
    ; --- I_vrad
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_vrad_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_I_vrad_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_vrad_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15_I_25bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_I_25bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15_Radial_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_vrad_30bins.pdf temp.tiff'

    ; --- I_Teff
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15_I_25bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_I_25bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_Teff_20bins.pdf temp.tiff'

    ; --- Teff_logg
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15_log_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_logg_29bins.pdf temp.tiff'


    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/260-265_25-30/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_260-265_25-30.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/260-265_25-30/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_260-265_25-30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_260-265_25-30.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30_log_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_logg_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_260-265_25-30/Teff_logg/I9.00-12.0/260-265_25-30/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_mean_sigma_convolved.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_260-265_25-30/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_260-265_25-30_convolved.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_260-265_25-30/Teff_logg/I9.00-12.0/260-265_25-30/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_Teff_logg_I9.00-12.0_260-265_25-30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_260-265_25-30_convolved.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_260-265_25-30/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_Teff_20bins_convolved.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_260-265_25-30/Teff_logg/I9.00-12.0/260-265_25-30/besancon_all_10x10_Teff_logg_I9.00-12.0_260-265_25-30_log_28bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_260-265_25-30_logg_28bins_convolved.pdf temp.tiff'


    ; --- vrad_MH
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_vrad_MH_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_vrad_MH_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_vrad_MH_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15_Radial_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_vrad_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15_Metallicity_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_MH_20bins.pdf temp.tiff'

  ; --- I = 9-12
    ; --- I_vrad
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_vrad_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_I_vrad_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_vrad_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15_I_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_I_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_vrad/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_vrad_I9.00-12.0_245-250_10-15_Radial_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_vrad_I9-12_245-250_10-15_vrad_30bins.pdf temp.tiff'

    ; --- I_Teff
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15_I_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_I_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/I_Teff/I9.00-12.0/245-250_10-15/besancon_all_10x10_I_Teff_I9.00-12.0_245-250_10-15_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_245-250_10-15_Teff_20bins.pdf temp.tiff'


; --- Teff_logg
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/Teff_logg/I9.00-12.0/245-250_10-15/besancon_all_10x10_Teff_logg_I9.00-12.0_245-250_10-15_log_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_245-250_10-15_logg_29bins.pdf temp.tiff'

    ; --- vrad_MH
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_vrad_MH_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/rave_internal_190509_no_doubles_SNR_gt_20_vrad_MH_I9.00-12.0_245-250_10-15.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_vrad_MH_I9-12_245-250_10-15.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15_Radial_30bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_vrad_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/3_small_fields/vrad_MH/I9.00-12.0/245-250_10-15/besancon_all_10x10_vrad_MH_I9.00-12.0_245-250_10-15_Metallicity_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/vrad_MH_I9-12_245-250_10-15_MH_20bins.pdf temp.tiff'

  end
  if b_test then begin
    ; --- test
    ; --- 230-315_5-25
    ; --- I_Teff
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25_I_28bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_I_28bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25_I_26bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_I_26bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_5-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_5-25_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_5-25_Teff_20bins.pdf temp.tiff'

; --- Teff_logg
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_230-315_5-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_230-315_5-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_Teff_1_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_logg_1_29bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_logg_1_29bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_5-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_5-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-25_Teff_1_20bins.pdf temp.tiff'



    ; --- 230-315_15-25
    ; --- I_Teff
;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_230-315_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_230-315_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_230-315_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_230-315_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_230-315_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_mean_sigma.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25_I_28bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_I_28bins.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25_Effective_20bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25_I_26bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_I_26bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/230-315_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_230-315_15-25_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_230-315_15-25_Teff_20bins.pdf temp.tiff'

; --- Teff_logg
;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_230-315_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_230-315_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_230-315_15-25_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/230-315_15-25/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_230-315_15-25_test.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_mean_sigma.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25_Effective_20bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_Teff_20bins.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25_log_30bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_logg_30bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_mean_sigma_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_logg_1_29bins_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_Teff_1_20bins_test.pdf temp.tiff'











    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_230-315_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_Teff_logg_I9.00-12.0_230-315_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_230-315_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_Teff_1_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_230-315_15-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_logg_1_29bins.pdf temp.tiff'









    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/230-315_5-15/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_5-15_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-15_Teff_1_20bins_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/230-315_5-15/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_5-15_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_5-15_logg_1_29bins_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_Teff_1_20bins_low.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test_2_fields_low/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_logg_1_29bins_low.pdf temp.tiff'









    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_log_1_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_logg_1_29bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/230-315_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_230-315_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_230-315_15-25_Teff_1_20bins.pdf temp.tiff'

; --- 315-360_15-25
; --- I_Teff
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_I_28bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_I_28bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_Teff_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_I_26bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_I_26bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_Effective_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_Teff_20bins.pdf temp.tiff'

; --- Teff_logg
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_315-360_15-25_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_315-360_15-25_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_315-360_15-25_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_315-360_15-25_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_mean_sigma_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_Teff_1_20bins_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25_log_12_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_logg_12_29bins_test.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0.bak/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_mean_sigma_test.pdf temp.tiff'






    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_Teff_logg_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_SNR_gt_20_Teff_logg_I9.00-12.0_315-360_15-25.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_Teff_logg_I9-12_315-360_15-25.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_315-360_15-25_Effective_1_20bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_Teff_1_20bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_Teff_logg_I9.00-12.0_315-360_15-25_log_12_29bins.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_logg_12_29bins.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25_log_27bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_logg_27bins_test.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/Teff_logg/I9.00-12.0/315-360_15-25/besancon_all_10x10_230-315_-25-25_JmK_Teff_logg_I9.00-12.0_315-360_15-25_Effective_20bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/Teff_logg_I9-12_315-360_15-25_Teff_20bins_test.pdf temp.tiff'

; --- 250-315_25-50
;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/rave_internal_190509_no_doubles_SNR_gt_20_I_Teff_I9.00-12.0_315-360_15-25.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_I_Teff_I9-12_315-360_15-25.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_Effective_20bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_Teff_20bins.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/mean_sigma_x_y.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_mean_sigma.pdf temp.tiff'

;    spawn,'rm temp.tiff'
;    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/test/I_Teff/I9.00-12.0/315-360_15-25/besancon_all_10x10_I_Teff_I9.00-12.0_315-360_15-25_Effective_20bins.gif temp.tiff'
;    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/I_Teff_I9-12_315-360_15-25_Teff_20bins.pdf temp.tiff'

  end

  if b_stellar_streams then begin
    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/stellar_streams/vrad_MH/I9.00-12.0/270-290_-40--30/rave_internal_190509_no_doubles_SNR_gt_20_vrad_MH_I9.00-12.0_270-290_-40--30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/rave_internal_190509_no_doubles_SNR_gt_20_vrad_MH_I9-12_270-290_-40--30.pdf temp.tiff'

    spawn,'rm temp.tiff'
    spawn,'gif2tiff /home/azuri/daten/besancon/lon-lat/html/5x5/stellar_streams/vrad_MH/I9.00-12.0/270-290_-40--30/besancon_all_10x10_vrad_MH_I9.00-12.0_270-290_-40--30.gif temp.tiff'
    spawn,'tiff2pdf -o /home/azuri/entwicklung/tex/talks/Padua2009/images/besancon_all_10x10_vrad_MH_I9-12_270-290_-40--30.pdf temp.tiff'
  end
end
