pro photo,infile,outfile,SQRT=sqrt

  str_photo_name=infile
  str_photo_name_out=outfile
  
;  str_photo_name='/home/azuri/daten/bilder/20081224/051220081428_copy.bmp'
;  str_photo_name_out='/home/azuri/daten/bilder/20081224/051220081428_out_sqrt.bmp'

  dbl_log = 4.
  
;  read_jpeg,str_photo_name,jpeg_photo,intarr_colours;,colors=256,dither=1;,/two_pass_quantize
;  print,intarr_colours
;  tvlct,intarr_colours
;;  tv,jpeg_photo
;  write_jpeg,str_photo_name_out,jpeg_photo,quality=100

  bmp_photo=read_bmp(str_photo_name,intarr_r,intarr_g,intarr_b)
;  print,'intarr_r = ',intarr_r
;  print,'intarr_g = ',intarr_g
;  print,'intarr_b = ',intarr_b
;  print,'bmp_photo = ',bmp_photo
  print,'size(bmp_photo)=',size(bmp_photo)
  intarr_size_bmp_photo = size(bmp_photo)

;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,0:100) = 10
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,0:100) = 5
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,0:100) = 50
;
;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,100:200) = 20
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,100:200) = 10
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,100:200) = 100
;
;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,200:300) = 40
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,200:300) = 20
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,200:300) = 200
;
;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,300:400) = 80
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,300:400) = 40
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,300:400) = 255
;
;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,400:500) = 160
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,400:500) = 80
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,400:500) = 255

;  bmp_photo(0,0:intarr_size_bmp_photo(2)-1,500:600) = 255
;  bmp_photo(1,0:intarr_size_bmp_photo(2)-1,500:600) = 160
;  bmp_photo(2,0:intarr_size_bmp_photo(2)-1,500:600) = 255

; --- recalculate
  int_intarr_rgb_length = 1
  for i=1,intarr_size_bmp_photo(0) do begin
    int_intarr_rgb_length = int_intarr_rgb_length * intarr_size_bmp_photo(i)
  endfor
  print,'int_intarr_rgb_length = ',int_intarr_rgb_length
  intarr_rgb = reform(bmp_photo,int_intarr_rgb_length)
  
  dbl_mean_photo = mean(intarr_rgb)
  print,'mean(intarr_rgb) = ',dbl_mean_photo
 
  dblarr_r_orig = double(bmp_photo(0,*,*))
  dblarr_g_orig = double(bmp_photo(1,*,*))
  dblarr_b_orig = double(bmp_photo(2,*,*))
  print,'min(dblarr_r_orig) = ',min(dblarr_r_orig)
  print,'min(dblarr_g_orig) = ',min(dblarr_g_orig)
  print,'min(dblarr_b_orig) = ',min(dblarr_b_orig)

;  for i=2,10 do begin
;    dbl_log = double(i)
  print,'dbl_log = ',dbl_log
  if keyword_set(SQRT) then begin
    dblarr_r = sqrt(dblarr_r_orig);alog10(dblarr_r_orig+1)/alog10(dbl_log)*dblarr_r_orig;*alog(dblarr_r_orig+1)
    dblarr_g = sqrt(dblarr_g_orig);alog10(dblarr_g_orig+1)/alog10(dbl_log)*dblarr_r_orig;*alog(dblarr_r_orig+1)
    dblarr_b = sqrt(dblarr_b_orig);alog10(dblarr_b_orig+1)/alog10(dbl_log)*dblarr_r_orig;*alog(dblarr_r_orig+1)
  end else begin
    dblarr_r = alog10(dblarr_r_orig+1)/alog10(dbl_log);*dblarr_r_orig;*alog(dblarr_r_orig+1)
    dblarr_g = alog10(dblarr_g_orig+1)/alog10(dbl_log);*dblarr_r_orig;*alog(dblarr_r_orig+1)
    dblarr_b = alog10(dblarr_b_orig+1)/alog10(dbl_log);*dblarr_r_orig;*alog(dblarr_r_orig+1)
  end
  print,'mean(dblarr_r) = ',mean(dblarr_r)
  print,'mean(dblarr_g) = ',mean(dblarr_g)
  print,'mean(dblarr_b) = ',mean(dblarr_b)
  
  intarr_dblarr_r_size = size(dblarr_r)
  print,'intarr_dblarr_r_size = ',intarr_dblarr_r_size
  dblvec_r = reform(dblarr_r,intarr_dblarr_r_size(n_elements(intarr_dblarr_r_size)-1))
  dblvec_g = reform(dblarr_g,intarr_dblarr_r_size(n_elements(intarr_dblarr_r_size)-1))
  dblvec_b = reform(dblarr_b,intarr_dblarr_r_size(n_elements(intarr_dblarr_r_size)-1))
  print,'n_elements(dblvec_r) = ',n_elements(dblvec_r)
  print,'n_elements(dblvec_r)*3 = ',n_elements(dblvec_r)*3
  dblvec_rgb = dblarr(ulong(n_elements(dblvec_r))*ulong(3))
  print,'size(dblvec_rgb) = ',size(dblvec_rgb)
  dblvec_rgb(0:n_elements(dblvec_r)-1) = dblvec_r(*)
  dblvec_rgb(ulong(n_elements(dblvec_r)):(ulong(2)*ulong(n_elements(dblvec_r)))-ulong(1)) = dblvec_g(*)
  dblvec_rgb(2*n_elements(dblvec_r):(3*n_elements(dblvec_r))-1) = dblvec_b(*)
  dbl_mean_dblvec_rgb = mean(dblvec_rgb)
  print,'dbl_mean_dblvec_rgb = ',dbl_mean_dblvec_rgb

;    dblarr_r = dblarr_r * dbl_mean_photo / dbl_mean_dblvec_rgb
;    dblarr_g = dblarr_g * dbl_mean_photo / dbl_mean_dblvec_rgb
;    dblarr_b = dblarr_b * dbl_mean_photo / dbl_mean_dblvec_rgb
  dblarr_r = dblarr_r * 255. / max(dblarr_r)
  dblarr_g = dblarr_g * 255. / max(dblarr_g)
  dblarr_b = dblarr_b * 255. / max(dblarr_b)
  print,'new min(dblarr_r) = ',min(dblarr_r)
  print,'new max(dblarr_r) = ',max(dblarr_r)
  print,'new min(dblarr_g) = ',min(dblarr_g)
  print,'new max(dblarr_g) = ',max(dblarr_g)
  print,'new min(dblarr_b) = ',min(dblarr_b)
  print,'new max(dblarr_b) = ',max(dblarr_b)

; --- write new colours to image
  bmp_photo(0,*,*) = fix(dblarr_r)
  bmp_photo(1,*,*) = fix(dblarr_g)
  bmp_photo(2,*,*) = fix(dblarr_b)

  write_bmp,strmid(str_photo_name_out,0,strpos(str_photo_name_out,'.',/REVERSE_SEARCH))+'_'+strtrim(string(i),2)+'.bmp',bmp_photo

end
