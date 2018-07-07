;common maxn,dlambda,lambda,flux

pro split_gf_all,linelist_in,linelist_out,start,range
;common maxn,dlambda,lambda,flux

;
; NAME:                  split_gf_all.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      split_gf_all,linelist_in,linelist_out,start,range
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
if strlen(range) eq 0 then begin
  print,'ERROR: no filename spezified!'
  print,'Usage: split_gf_all,linelist_in,linelist_out,start,range'
  print,"Example: split_gf_all,'/home/azuri/daten/linelists/kurucz/gfall.dat','/home/azuri/daten/linelists/kurucz/gf0100.100',0.,100."
endif else begin

  str_templine = ''
  d_lambda = 0.
  nlines = countlines(linelist_in)
;--- read input linelist_in
  openr,lun,linelist_in,/GET_LUN
    openw,lunw,linelist_out,/GET_LUN
      for i=0UL,nlines-1 do begin
        readf,lun,str_templine
        d_lambda = strtrim(strmid(strtrim(str_templine,2),0,strpos(strtrim(str_templine,2),' ')),2)
;        print,'d_lambda = ',d_lambda
        if (d_lambda ge start) and (d_lambda lt start + range) then $
          printf,lunw,str_templine
      endfor
    free_lun,lunw
  free_lun,lun

endelse
end
