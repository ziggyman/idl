pro besancon_write_stars_all

;
; NAME:                  besancon_write_stars.pro
; PURPOSE:               copies the star data from infile to outfile
; CATEGORY:              rave
; CALLING SEQUENCE:      besancon_write_stars,'/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu','/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'
; INPUTS:                infile
;                            1                   ******************************************************************************************
;                              *                                                                                        *
;                              *      BESANCON MODEL OF STELLAR POPULATION SYNTHESIS 2003-12
;                              *
;                              *
;                                ******************************************************************************************
;
;                            Longitudes :  [   177.0 -   183.0 ] step:    1.50  Latitudes  :  [   -36.0 -   -30.0 ] step:    1.50
;
;
;                       outfile: name of file to write star data to
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  05/05/2008
;
;                        headline
;                        feetline (up to now not used)
;

  b_new = 1
  b_extinction = 1

  if b_extinction then begin
    str_listfile = '/home/azuri/daten/besancon/lon-lat/extinction/new/files.list'
    strarr_filenames = readfiletostrarr(str_listfile,' ')
  end else begin
    str_listfile = '/home/azuri/daten/rave/rave_data/release3/fields_lon_lat_small_new.dat'
    strarr_all = readfiletostrarr(str_listfile,' ')
    strarr_filenames = strarr_all(*,4)
  end

  for i=0UL, n_elements(strarr_filenames) - 1 do begin
;    i=0
    str_datfile = strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'.',/REVERSE_SEARCH)+1)+'dat'
    print,strarr_filenames(i)+' -> '+str_datfile
    besancon_write_stars,strarr_filenames(i),$
                         str_datfile,$
                         B_NEW = b_new
  endfor
end
