pro rave_plot_I_Teff_all,datafile,FIELDSFILE=fieldsfile,YMIN=ymin,YMAX=ymax

  if keyword_set(FIELDSFILE) then begin

  end else begin
    fieldsfile = '/home/azuri/daten/rave/rave_data/release3/fields.dat'
  end

  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor
  print,'strarr_fields = ',strarr_fields
  print,'dblarr_fields = ',dblarr_fields

  datafile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408.dat'

  for i=0,i_nfields-1 do begin
    if keyword_set(YMIN) then begin

    end else begin
      ymin = -0.00001
    end
    if keyword_set(YMAX) then begin

    end else begin
      ymax = 12000.
    end
    oldymin = ymin
    oldymax = ymax
    print,'calculating line ',i
    print,dblarr_fields(i,0),$
          dblarr_fields(i,1),$
          dblarr_fields(i,2),$
          dblarr_fields(i,3)
    rave_plot_two_cols,datafile,$
                       12,$
                       17,$
                       'I [mag]',$
                       'Teff [K]',$
                       strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_I_Teff.ps',$
                       XMIN=9.,$
                       XMAX=12.,$
                       REJECTVALUEY=0.0000001,$
                       MINLATITUDE=dblarr_fields(i,2),$
                       MAXLATITUDE=dblarr_fields(i,3),$
                       COLLATITUDE=2,$
                       MINLONGITUDE=dblarr_fields(i,0),$
                       MAXLONGITUDE=dblarr_fields(i,1),$
                       COLLONGITUDE=1,$
                       TITLE='RAVE '+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', '+strarr_fields(i,2)+' - '+strarr_fields(i,3),$
                       YMIN=ymin,$
                       YMAX=ymax,$
                       IMIN=9.,$
                       IMAX=12.0,$
                       ICOL=12;,DEBUG=1
    if abs(ymin-oldymin) gt 0.00001 then begin
      print,'rave_plot_I_Teff_all: WWWAAARRRNNNIIINNNGGG: ymin(=',ymin,') != oldymin(=',oldymin,')'
    end
    if abs(ymax-oldymax) gt 0.00001 then begin
      print,'rave_plot_I_Teff_all: WWWAAARRRNNNIIINNNGGG: ymax(=',ymax,') != oldymax(=',oldymax,')'
    end
  endfor
end
