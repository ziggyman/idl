pro rave_write_input_final
  str_datafile_in = '/home/azuri/daten/rave/rave_data/input_catalogue/rave_input_final.txt'
  str_datafile_out = strmid(str_datafile_in,0,strpos(str_datafile_in,'.',/REVERSE_SEARCH))+'.dat'

  i_col_id = 0;-16
  i_col_ra = 17;-26
  i_col_dec = 28;-37
  i_col_i = 43;-48
  i_col_j = 54;-59
  i_col_k = 63;-68

  strarr_lines = readfilelinestoarr(str_datafile_in,NLINES=nlines)

  dblarr_ra = double(strmid(strarr_lines,i_col_ra,10))
  dblarr_dec = double(strmid(strarr_lines,i_col_dec,10))
  euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,SELECT=1
  plot,dblarr_lon,dblarr_lat,xtitle='lon',ytitle=lat,psym=7,symsize=0.2

  openw,lun,str_datafile_out,/GET_LUN
    printf,lun,'# RAVE_ID RA DEC LON LAT Imag Jmag Kmag'
    for i=0ul,nlines-1 do begin
      printf,lun,strmid(strarr_lines(i),0,39)+$
                 strtrim(string(dblarr_lon(i)),2)+' '+$
                 strtrim(string(dblarr_lat(i)),2)+' '+$
                 strmid(strarr_lines(i),i_col_i,6)+' '+$
                 strmid(strarr_lines(i),i_col_j,6)+' '+$
                 strmid(strarr_lines(i),i_col_k,6)
    endfor
  free_lun,lun
end
