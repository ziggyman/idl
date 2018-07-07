;common maxn,dlambda,lambda,flux

pro rave_write_stars,infile,outfile
;common maxn,dlambda,lambda,flux

;
; NAME:                  rave_write_stars.pro
; PURPOSE:               copies the star data from infile to outfile
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_write_stars,'/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu','/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'
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
    print,'Usage: rave_write_stars,(string)file,(string)outfile'
    print,"Example: rave_write_stars,'/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu','/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'"
    infile = '/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu'
    outfile = '/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'
  end
  print,'rave_write_stars: infile = "'+infile+'"'
  str_path = strmid(infile,0,strpos(infile,'/',/REVERSE_SEARCH)+1)
  i_ndatalines = countlines(infile)
  print,'rave_write_stars: i_ndatalines = ',i_ndatalines
  line = ''
  i_found_dist = 0
  openr,lun,infile,/GET_LUN
    openw,lunw,outfile,/GET_LUN
      for i=0ul,i_ndatalines-1 do begin
        readf,lun,line
        if strmid(strtrim(line,2),0,1) ne '"' then begin
          line = strrep(line,',',' ')
          printf,lunw,line
        end
      endfor
    free_lun,lunw
  free_lun,lun
end
