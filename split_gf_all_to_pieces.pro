;common maxn,dlambda,lambda,flux

pro split_gf_all_to_pieces,linelist_in,linelist_out,start,range
;common maxn,dlambda,lambda,flux

;
; NAME:                  split_gf_all_to_pieces.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      split_gf_all_to_pieces,linelist_in
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
if strlen(linelist_in) eq 0 then begin
  print,'ERROR: no filename spezified!'
  print,'Usage: split_gf_all_to_pieces,linelist_in'
  print,"Example: split_gf_all_to_pieces,'/home/azuri/daten/linelists/kurucz/gfall.dat'"
endif else begin

  d_lambda = 0.
  d_range = 100.
;--- read input linelist_in
  openr,lun,linelist_in,/GET_LUN
    for i=0UL, 7550 do begin
      str_outfile = strmid(linelist_in,0,strpos(linelist_in,'/',/REVERSE_SEARCH)+1)+'gf'
      if d_lambda lt 1000 then str_outfile = str_outfile + '0'
      str_outfile = str_outfile + strmid(strtrim(string(d_lambda+d_range),2),0,strpos(strtrim(string(d_lambda+d_range),2),'.'))+'.100'
      print,'str_outfile = '+str_outfile
      split_gf_all,linelist_in,str_outfile,d_lambda+100.,100.
      d_lambda = d_lambda + d_range
    endfor
  free_lun,lun

endelse
end
