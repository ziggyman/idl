;common maxn,dlambda,lambda,flux

pro besancon_write_stars_ext,infile,outfile
;common maxn,dlambda,lambda,flux

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

;-- test arguments
  if n_elements(outfile) eq 0 then begin
    print,'ERROR: not enough parameters specified!'
    print,'Usage: besancon_write_stars,(string)file,(string)outfile'
    print,"Example: besancon_write_stars,'/suphys/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu','/suphys/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'"
    infile = '/suphys/azuri/daten/besancon/lon-lat/with_extinction/l310b5.resu'
    outfile = '/suphys/azuri/daten/besancon/lon-lat/with_extinction/l310b5.dat'
  end
  print,'besancon_write_stars: infile = "'+infile+'"'
  str_path = strmid(infile,0,strpos(infile,'/',/REVERSE_SEARCH)+1)
  i_ndatalines = countlines(infile)
  print,'besancon_write_stars: i_ndatalines = ',i_ndatalines
  line = ''
  i_found_dist = 0
  openr,lun,infile,/GET_LUN
    openw,lunw,outfile,/GET_LUN
      for i=0ul,i_ndatalines-1 do begin
        readf,lun,line
        if strmid(strtrim(line,2),0,9) eq 'I     J-K' then begin
          i_found_dist = i_found_dist + 1
        end else begin
          if i_found_dist eq 1 then begin
            printf,lunw,line
          endif
        end
      endfor
    free_lun,lunw
  free_lun,lun
end
