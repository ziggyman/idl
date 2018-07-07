pro besancon_split_fields,STEP=step
;
; NAME:                  besancon_split_fields.pro
; PURPOSE:               split fields from 10x10 deg to 5x5 deg
; CATEGORY:              rave
; CALLING SEQUENCE:      besancon_split_fields
; INPUTS:
;                        STEP=step : double
; COPYRIGHT:             Andreas Ritter
; DATE:                  09/10/2008
;
;                        headline
;                        feetline (up to now not used)
;

  if not keyword_set(STEP) then step = 5.

; --- parameters
  str_datafile = '/home/azuri/daten/rave/rave_data/release3/fields_lon_lat_small_new.dat'
  str_dataoutfile = '/home/azuri/daten/rave/rave_data/release5/'+$
                    strmid(str_datafile,strpos(str_datafile,'/',/REVERSE_SEARCH)+1,strpos(str_datafile,'.',/REVERSE_SEARCH)-strpos(str_datafile,'/',/REVERSE_SEARCH)-1)+$
                    '-'+$
                    strmid($
                           strtrim(string(step),2),$
                           0,$
                           strpos($
                                  strtrim(string(step),2),$
                                  '.',$
                                  /REVERSE_SEARCH)$
                          )+$
                    'x'+$
                    strmid($
                           strtrim(string(step),2),0,strpos($
                                                            strtrim(string(step),2),$
                                                            '.',$
                                                            /REVERSE_SEARCH)$
                          )+$
                    '.dat'
  str_filelist = '/home/azuri/daten/rave/rave_data/release5/'+$
                 strmid(str_datafile,strpos(str_datafile,'/',/REVERSE_SEARCH)+1,strpos(str_datafile,'.',/REVERSE_SEARCH)-strpos(str_datafile,'/',/REVERSE_SEARCH)-1)+$
                 '_datafiles.text'

  strarr_data = readfiletostrarr(str_datafile,' ')

  dblarr_fields = double(strarr_data(*,0:3))
  strarr_fieldfiles = strarr_data(*,4)

  openw,lun,str_dataoutfile,/GET_LUN
  openw,luna,str_filelist,/GET_LUN
  for i=0UL, n_elements(strarr_fieldfiles) - 1 do begin
    dbl_lon_start = dblarr_fields(i,0)
    dbl_lon_end = dblarr_fields(i,1)
    dbl_lat_start = dblarr_fields(i,2)
    dbl_lat_end = dblarr_fields(i,3)
    while (dbl_lon_end - dbl_lon_start) gt 0. do begin
      while (dbl_lat_end - dbl_lat_start) gt 0. do begin
        printf,lun,strmid(strtrim(string(dbl_lon_start),2),0,strpos(strtrim(string(dbl_lon_start),2),'.',/REVERSE_SEARCH)+3)+' '+strmid(strtrim(string(dbl_lon_start+5.),2),0,strpos(strtrim(string(dbl_lon_start+5.),2),'.',/REVERSE_SEARCH)+3)+' '+strmid(strtrim(string(dbl_lat_start),2),0,strpos(strtrim(string(dbl_lat_start),2),'.',/REVERSE_SEARCH)+3)+' '+strmid(strtrim(string(dbl_lat_start+5.),2),0,strpos(strtrim(string(dbl_lat_start+5.),2),'.',/REVERSE_SEARCH)+3)+' '+strarr_fieldfiles(i)
        print,strtrim(string(dbl_lon_start),2)+' '+strtrim(string(dbl_lon_start+5.),2)+' '+strtrim(string(dbl_lat_start),2)+' '+strtrim(string(dbl_lat_start+5.),2)+' '+strarr_fieldfiles(i)
        dbl_lat_start = dbl_lat_start + 5.
        print,'dbl_lat_end(='+strtrim(string(dbl_lat_end),2)+') - dbl_lat_start(='+strtrim(string(dbl_lat_start),2)+') = '+strtrim(string(dbl_lat_end - dbl_lat_start),2)
      end
      dbl_lat_start = dblarr_fields(i,2)
      dbl_lon_start = dbl_lon_start + 5.
      print,'dbl_lon_end(='+strtrim(string(dbl_lon_end),2)+') - dbl_lon_start(='+strtrim(string(dbl_lon_start),2)+') = '+strtrim(string(dbl_lon_end - dbl_lon_start),2)
    end
    printf,luna,strarr_fieldfiles(i)
  endfor
  free_lun,lun
  free_lun,luna

end
