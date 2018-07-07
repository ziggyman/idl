pro rave_plot_MH_vrad_all

  fieldsfile = '/home/azuri/daten/rave/rave_data/release3/fields.dat'

  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = readfiletodblarr(fieldsfile)
  print,'strarr_fields = ',strarr_fields
  print,'dblarr_fields = ',dblarr_fields

  datafile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408.dat'

  for i=0,i_nfields-1 do begin
    print,'calculating line ',i
    print,dblarr_fields(i,0),$
          dblarr_fields(i,1),$
          dblarr_fields(i,2),$
          dblarr_fields(i,3)
    rave_plot_two_cols,datafile,$
                       5,$
                       19,$
                       'Radial Velocity [km/s]',$
                       '[M/H] [dex]',$
                       strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_MH_vrad.ps',$
                       XMIN=-300.,$
                       XMAX=300.,$
                       MINLONGITUDE=dblarr_fields(i,0),$
                       MAXLONGITUDE=dblarr_fields(i,1),$
                       COLLONGITUDE=1,$
                       MINLATITUDE=dblarr_fields(i,2),$
                       MAXLATITUDE=dblarr_fields(i,3),$
                       COLLATITUDE=2,$
                       TITLE='RAVE '+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', '+strarr_fields(i,2)+' - '+strarr_fields(i,3),$
                       YMIN=-3.,$
                       YMAX=1.,$
;                       DEBUG=1,$
;                       REJECTVALUEX=99.0,$
                       REJECTVALUEY=99.90;,$
;                       IMIN=10.5,$
;                       IMAX=12.,$
;                       ICOL=12;,
  endfor
end
