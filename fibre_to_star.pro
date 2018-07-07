;common maxn,dlambda,lambda,flux

pro fibre_to_star,list_in,idlist_in,list_out
;common maxn,dlambda,lambda,flux

;
; NAME:                  fibre_to_star.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fibre_to_star,linelist_in,linelist_out,start,range
; INPUTS:                linelist_in: gfall.dat
;                         2.4898 -0.842  7.05       0.000  0.0 1s2 1S     4016390.000  1.0 s3p *1P    11.73  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                         2.8787 -0.171  7.05       0.000  0.0 1s2 1S     3473790.000  1.0 s2p *1P    12.26  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                           ...
;
; OUTPUTS:               linelist_out: gf0100.100
;                         2.4898 -0.842  7.05       0.000  0.0 1s2 1S     4016390.000  1.0 s3p *1P    11.73  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                         2.8787 -0.171  7.05       0.000  0.0 1s2 1S     3473790.000  1.0 s2p *1P    12.26  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                           ...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  03.01.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
if n_elements(list_out) eq 0 then begin
  print,'ERROR: not enough parameters spezified!'
  print,'Usage: fibre_to_star,list_in,idlist_in,list_out'
  print,"Example: fibre_to_star,'/home/azuri/spectra/joss/types.txt','/home/azuri/spectra/joss/fibre_id.txt','/home/azuri/spectra/joss/spectral_types.txt"
endif; else begin
  list_in = '/home/azuri/spectra/joss/types.txt'
  idlist_in = '/home/azuri/spectra/joss/fibre_id.txt'
  list_out = '/home/azuri/spectra/joss/spectral_types.txt'
  nlines = countlines(list_in)

  str_templine = ''
  str_idline = ''
  str_fibre = ''
  str_headline = ''
  j = 0UL
  strarr_lines = strarr(nlines-2)

;--- read input linelist_in
  openr,lun,list_in,/GET_LUN
    readf,lun,str_headline
    openw,lunw,list_out,/GET_LUN
      for i=1UL,nlines-1 do begin
        readf,lun,str_templine
        if strmid(str_templine,0,1) eq '0' or strmid(str_templine,0,1) eq '1' then begin
          i_fitspos = strpos(str_templine,'.fits')
          str_fibre = strmid(str_templine,i_fitspos-3,3)
          i_fibre = long(str_fibre)
          print,'i_fibre = ',i_fibre
          i_fibrelines = countlines(idlist_in)
          openr,luna,idlist_in,/GET_LUN
          for k=0UL,i_fibrelines-1 do begin
            readf,luna,str_idline
            str_fibre = strtrim(strmid(str_idline,1,4),2)
            i_fibrea = long(str_fibre)
            if i_fibre eq i_fibrea then begin
              print,'i_fibrea = ',i_fibrea
              str_id = strtrim(strmid(str_idline,5,14),2)
              print,'str_id = ',str_id
              strarr_lines(j) = str_id+' '+strmid(str_templine,4)
              j = j+1
            endif
          endfor
          free_lun,luna
;          printf,lunw,strmid(str_templine,0,strpos(str_templine,'B')) +
        end; else begin
        ;  printf,lunw,str_templine
        ;endelse
      endfor
      strarr_lines = strarr_lines(0:j-1)
      i_sorted = sort(strarr_lines)
      print,'strarr_lines(i_sorted) = ',strarr_lines(i_sorted)
      k = 0UL
      printf,lunw,str_headline
      printf,lunw,' '
      for i=0UL, j-1 do begin
        if k eq 10 then begin
          printf,lunw,' '
          k=0
        end else begin
          printf,lunw,strarr_lines(i_sorted(i))
          k=k+1
        endelse
      endfor
    free_lun,lunw
  free_lun,lun

;endelse
end
