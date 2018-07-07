;###########################
pro rave_fields_radec_to_lonlat,filename,outfile
;###########################

  if n_params() ne 2 then begin
    print,'READFILETOARR: Not enough parameters specified'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    print,'rave_fields_radec_to_lonlat: nlines = ',nlines
    print,'rave_fields_radec_to_lonlat: ndatalines = ',ndatalines
    print,'rave_fields_radec_to_lonlat: ncols = ',ncols
    strarr_data = readfiletostrarr(filename,' ')
    dblarr_ra_dec = dblarr(ndatalines,4)
    dblarr_lon_lat = dblarr(ndatalines,4)
    openw,lun,outfile,/GET_LUN
    for i=0UL, ndatalines-1 do begin
      for j=0, 3 do begin
        dblarr_ra_dec(i,j) = double(strarr_data(i,j))
      endfor
      euler,dblarr_ra_dec(i,0),dblarr_ra_dec(i,2),lona,lata,1
      euler,dblarr_ra_dec(i,1),dblarr_ra_dec(i,3),lonb,latb,1
      if lona lt lonb then begin
        dblarr_lon_lat(i,0)=lona
        dblarr_lon_lat(i,1)=lonb
      end else begin
        dblarr_lon_lat(i,0)=lonb
        dblarr_lon_lat(i,1)=lona
      end
      if lata lt latb then begin
        dblarr_lon_lat(i,2)=lata
        dblarr_lon_lat(i,3)=latb
      end else begin
        dblarr_lon_lat(i,2)=latb
        dblarr_lon_lat(i,3)=lata
      end
      printf,lun,strtrim(string(dblarr_lon_lat(i,0)),2)+' '+$
      strtrim(string(dblarr_lon_lat(i,1)),2)+' '+$
      strtrim(string(dblarr_lon_lat(i,2)),2)+' '+$
      strtrim(string(dblarr_lon_lat(i,3)),2)+' '+$
      strarr_data(i,4)
    endfor
    free_lun,lun
  end
end
