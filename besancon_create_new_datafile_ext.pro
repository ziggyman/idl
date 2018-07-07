pro besancon_create_new_datafile_ext

  b_new = 1

  if b_new then begin
    besancon_combine_datafiles,STR_FIELDS = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/files.list',$
                               STR_FILENAMES = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/files.text',$
                               STR_OUTFILE = '/suphys/azuri/daten/besancon/lon-lat/extinction/new/besancon_with_extinction_new.dat',$
                               B_CALC_VRAD = 0,$
                               B_EXTINCTION = 1,$
                               B_JMK = 1,$
                               B_EXT_NEW = 1
  end else begin
    besancon_combine_datafiles,STR_FIELDS = '/suphys/azuri/daten/besancon/lon-lat/extinction/files.dat',$
                               STR_FILENAMES = '/suphys/azuri/daten/besancon/lon-lat/extinction/files.text',$
                               STR_OUTFILE = '/suphys/azuri/daten/besancon/lon-lat/extinction/besancon_with_extinction.dat',$
                               B_CALC_VRAD = 0,$
                               B_EXTINCTION = 1,$
                               B_JMK = 1
  end
end
