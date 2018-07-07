pro rave_dist_get_lon_lat
;  str_distfile_in = '/home/azuri/daten/rave/rave_data/distances/Distances_20100213_Zwitter.dat'
  str_distfile_in = '/home/azuri/daten/rave/rave_data/distances/Distances_20100430.dat';all_20100201_SN20.rez'
  str_ravefile = '/home/azuri/daten/rave/rave_data/release7/rave_internal_290110.dat'
  str_distfile_out = strmid(str_distfile_in,0,strpos(str_distfile_in,'.',/REVERSE_SEARCH))+'_lon-lat_all-dists.dat'

  strarr_distdata_in = readfiletostrarr(str_distfile_in,' ')
  dblarr_ra = double(strarr_distdata_in(*,1))
  dblarr_dec = double(strarr_distdata_in(*,2))
;  euler,dblarr_ra,dblarr_dec,dblarr_lon,dblarr_lat,SELECT=1
  strarr_distdata_id = strarr_distdata_in(*,0)
  i_col_rave_raveid = 0
  i_col_rave_id = 1
  i_col_rave_imag = 13
  i_col_rave_lon = 4
  i_col_rave_lat = 5

  i_col_dist_err = [19,21,23]

  strarr_ravedata = readfiletostrarr(str_ravefile,' ')
  strarr_ravedata_raveid = strarr_ravedata(*,i_col_rave_raveid)
  strarr_ravedata_id = strarr_ravedata(*,i_col_rave_id)
  strarr_ravedata_imag = strarr_ravedata(*,i_col_rave_imag)
  strarr_ravedata_lon = strarr_ravedata(*,i_col_rave_lon)
  strarr_ravedata_lat = strarr_ravedata(*,i_col_rave_lat)

  openw,lun,str_distfile_out,/GET_LUN
    printf,lun,'#    ObjectID    RAVE_ID           RA           DEC      LON      LAT     RV    eRV   pmRA  epmRA   pmDE  epmDE   Imag   Jmag   Kmag  Obsdate Fieldname FibNum Teff  logg    MH     SN    dist   edist  whichmu'
    printf,lun,'#'
    for i=0ul,n_elements(dblarr_ra)-1 do begin
      indarr = where(strarr_ravedata_id eq strarr_distdata_id(i))
      if indarr(0) eq -1 then begin
        print,'rave_dist_write_min_err: could not find star '+strarr_distdata_id(i)
        stop
      endif
      print,'rave_dist_write_min_err: star i=',i,': '+strarr_distdata_id(i)+' found'
      strarr_out_line = strarr_ravedata_raveid(indarr(0))+' '+$
                        strarr_distdata_in(i,0)+' '+$
                        strarr_distdata_in(i,1)+' '+$
                        strarr_distdata_in(i,2)+' '+$
                        strarr_ravedata_lon(indarr(0))+' '+$
                        strarr_ravedata_lat(indarr(0))+' '+$
                        strarr_distdata_in(i,3)+' '+$
                        strarr_distdata_in(i,4)+' '+$
                        strarr_distdata_in(i,5)+' '+$
                        strarr_distdata_in(i,6)+' '+$
                        strarr_distdata_in(i,7)+' '+$
                        strarr_distdata_in(i,8)+' '+$
                        strarr_ravedata_imag(indarr(0))+' '+$
                        strarr_distdata_in(i,9)+' '+$
                        strarr_distdata_in(i,10)+' '+$
                        strarr_distdata_in(i,11)+' '+$
                        strarr_distdata_in(i,12)+' '+$
                        strarr_distdata_in(i,13)+' '+$
                        strarr_distdata_in(i,14)+' '+$
                        strarr_distdata_in(i,15)+' '+$
                        strarr_distdata_in(i,16)+' '+$
                        strarr_distdata_in(i,17)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,18)))),2)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,19)))),2)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,20)))),2)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,21)))),2)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,22)))),2)+' '+$
                        strtrim(string(0.01*10.^(0.2*double(strarr_distdata_in(i,23)))),2)
      printf,lun,strarr_out_line
    endfor
  free_lun,lun
end
