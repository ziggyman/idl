;common maxn,dlambda,lambda,flux

pro rave_plot_MH_vrad,datafile,XMIN=xmin,XMAX=xmax,IMIN=imin,IMAX=imax
;common maxn,dlambda,lambda,flux

;
; NAME:                  rave_plot_MH_vrad.pro
; PURPOSE:               plots err_vrad over vrad
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_plot_MH_vrad,'/home/azuri/daten/rave/rave data/rave_dr1.dat'
; INPUTS:                datafile
;                            r1508268-243910 227.11204167 -24.65302778 338.55967000  28.57959000  -116.8    1.5   -3.3   13.2   -5.8   13.2 4 11.42 20030411    1507m23 2   1  36.1 0.93   61.4    1.2   -2.6    6.3   2.1  24.4 99.999 99.999 99.999 99.999   0653-0321526  0.280 14.26 12.92 13.63 12.64 11.38 A J150826.8-243910  0.122 11.793 0.04 10.951 0.07 10.266 0.06 B 15082687-2439107  0.258 10.932 0.02 10.436 0.02 10.364 0.02 AAA A AA
;                            r1508321-242942 227.13387500 -24.49525000 338.68088000  28.69780000   -54.6    2.1  -10.4   13.2    0.8   13.2 4 11.75 20030411    1507m23 2   3  28.0 0.94   62.6    1.0   -4.9    5.2   3.8  23.8 99.999 99.999 99.999 99.999   0655-0321354  0.154 15.22 13.21 14.66 13.10 12.11 A J150832.1-242942  0.151 12.071 0.03 11.067 0.08 10.153 0.07 A 15083211-2429428  0.204 10.998 0.02 10.297 0.02 10.155 0.02 AAA A AA

;
; COPYRIGHT:             Andreas Ritter
; DATE:                  25/04/2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
  if n_elements(datafile) eq 0 then begin
    print,'ERROR: not enough parameters specified!'
    print,'Usage: rave_plot_MH_vrad,(string)datafile'
    print,"Example: rave_plot_MH_vrad,'/home/azuri/daten/rave/rave_data/rave_dr1.dat'"
    datafile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408_177-183_-36--30.dat'
  end
  if keyword_set(XMIN) and keyword_set(XMAX) then begin
    if keyword_set(IMIN) and keyword_set(IMAX) then begin
      rave_plot_two_cols,datafile,5,19,'Radial Velocity [km/s]','[M/H] [dex]',strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps',XMIN=xmin,XMAX=xmax,IMIN=imin,IMAX=imax,ICOL=12
    end else begin
      rave_plot_two_cols,datafile,5,19,'Radial Velocity [km/s]','[M/H] [dex]',strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps',XMIN=xmin,XMAX=xmax
    end
  end else begin
    if keyword_set(IMIN) and keyword_set(IMAX) then begin
      rave_plot_two_cols,datafile,5,19,'Radial Velocity [km/s]','[M/H] [dex]',strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps',IMIN=imin,IMAX=imax,ICOL=12
    end else begin
      rave_plot_two_cols,datafile,5,19,'Radial Velocity [km/s]','[M/H] [dex]',strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps'
    end
  end
  rave_plot_two_cols,datafile,5,19,'Radial Velocity [km/s]','[M/H] [dex]',strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps',XMIN=-300.,XMAX=300.,IMIN=9.,IMAX=10.5,ICOL=12
end
