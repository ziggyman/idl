;common maxn,dlambda,lambda,flux

pro rave_write_stars_lon_lat,infile,outfile,minra,maxra,mindec,maxdec
;common maxn,dlambda,lambda,flux

;
; NAME:                  rave_write_stars_lat_lon.pro
; PURPOSE:               copies the star data from infile to outfile
; CATEGORY:              rave data release 3
; CALLING SEQUENCE:      rave_write_stars_lat_lon,'/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.resu','/home/azuri/daten/besancon/177-183_-36--30/1209132335.045735.dat'
; INPUTS:                infile
;                            r1508268-243910 227.11204166 -24.65302778 338.55967  28.57959  -116.8    1.5   -7.7    4.7    3.1    4.7 5 11.42 20030411    1507m23 2   1      0 99.90 99.90 99.90   0 9.9       0  36.1 0.93   61.4    1.2   -2.6    6.3   2.1  24.4 99.999 99.999 99.999 99.999   0653-0321526  0.280 14.26 12.92 13.63 12.92 11.38 A J150826.8-243910  0.122 11.793 0.04 10.951 0.07 10.266 0.06 B 15082687-2439107  0.258 10.932 0.02 10.436 0.02 10.364 0.02 AAA A AA
;                            r1508321-242942 227.13387500 -24.49525000 338.68088  28.69780   -54.6    2.1   -2.6    4.7    1.9    4.7 5 11.75 20030411    1507m23 2   3      0 99.90 99.90 99.90   0 9.9       0  28.0 0.94   62.6    1.0   -4.9    5.2   3.8  23.8 99.999 99.999 99.999 99.999   0655-0321354  0.154 15.22 13.21 14.66 13.21 12.11 A J150832.1-242942  0.151 12.071 0.03 11.067 0.08 10.153 0.07 A 15083211-2429428  0.204 10.998 0.02 10.297 0.02 10.155 0.02 AAA A AA
;                            ...
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
  if n_elements(maxdec) eq 0 then begin
    print,'ERROR: not enough parameters specified!'
    print,'Usage: rave_write_stars_lat_lon,(string)file,(string)outfile,(double)minra,(double)maxra,(double)mindec,(double)maxdec'
    print,"Example: rave_write_stars_lat_lon,'/home/azuri/daten/rave/rave_data/release3/rave_internal_090408.dat','/home/azuri/daten/rave/rave_data/release3/rave_internal_090408_<minra>-<maxra>_<mindec>-<maxdec>.dat',167.,173.,-36.,-30."
    infile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408.dat'
    outfile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408_177-183_-36--30.dat'
    minra = 177.
    maxra = 183.
    mindec = -36.
    maxdec = -30.
  end
  print,'rave_write_stars_lat_lon: infile = "'+infile+'"'
  str_path = strmid(infile,0,strpos(infile,'/',/REVERSE_SEARCH)+1)
  i_ndatalines = countlines(infile)
  i_ncols = countcols(infile,DELIMITER=' ')
  print,'rave_write_stars_lat_lon: i_ndatalines = ',i_ndatalines,', i_ncols = ',i_ncols
  strarr_data = readfiletostrarr(infile,' ')
  line = ''
  openr,lun,infile,/GET_LUN
    openw,lunw,outfile,/GET_LUN
      for i=0ul,i_ndatalines-1 do begin
        readf,lun,line
        if (double(strarr_data(i,1)) ge minra) and (double(strarr_data(i,1)) le maxra) and (double(strarr_data(i,2)) ge mindec) and (double(strarr_data(i,2)) le maxdec) then begin
          printf,lunw,line
        end
      endfor
    free_lun,lunw
  free_lun,lun
end
