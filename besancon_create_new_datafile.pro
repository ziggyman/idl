pro besancon_create_new_datafile
  besancon_combine_datafiles,STR_FIELDS = '/suphys/azuri/daten/rave/rave_data/release3/fields_lon_lat_small_new.dat',$
                             STR_FILENAMES = '/suphys/azuri/daten/rave/rave_data/release5/fields_lon_lat_small_new.text',$
                             STR_OUTFILE = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat',$
                             B_CALC_VRAD = 0

  besancon_combine_datafiles,STR_FIELDS = '/suphys/azuri/daten/rave/rave_data/release5/fields_lon_lat_10x10_JmK.dat',$
                             STR_FILENAMES = '/suphys/azuri/daten/rave/rave_data/release5/fields_lon_lat_10x10_JmK.text',$
                             STR_OUTFILE = '/suphys/azuri/daten/besancon/lon-lat/besancon_230-320_-25-25_JmK.dat',$
                             B_CALC_VRAD = 0,$
                             B_JMK = 1

  besancon_combine_all_and_jmk,STR_BES_ALL = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10.dat',$
                               STR_BES_JMK = '/suphys/azuri/daten/besancon/lon-lat/besancon_230-320_-25-25_JmK.dat',$
                               STR_OUTFILE = '/suphys/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK.dat'

end
