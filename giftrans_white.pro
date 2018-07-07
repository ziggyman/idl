;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################
pro giftrans_white,giflist
;############################
;
; NAME:                  giftrans_white
; PURPOSE:               sets the white color of the input files to transparent
;
; CATEGORY:              image processing
; CALLING SEQUENCE:      giftrans_white,'giflist'
; INPUTS:                input file: 'giflist':
;                          ../fig/export/aperture-data_file.gif
;                                            .
;                                            .
;                                            .
; OUTPUTS:               output files: strmid(<giffile>,0,strpos(<giffile>,'.',/REVERSE_SEARCH))+'_'+'_trans.gif'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           05.09.2005
;

if n_elements(giflist) eq 0 then begin
    print,'giftrans_white: Not enough parameters specified, return 0.'
    print,"giftrans_white: Usage: giftrans_white,'../fig/export/gifs.list'"
end else begin

;countlines
    maxn = countlines(giflist)

;build arrays
    files = strarr(maxn) 

;define variables
    fileq = ''
    outfile = ''

;read giflist
    openr,lun,giflist,/GET_LUN
    for i=0UL,maxn-1 do begin
      readf,lun,fileq
      files(i) = strtrim(fileq,2)
    endfor
    free_lun,lun

;invoke giftrans
    for i=0UL,maxn-1 do begin
      outfile = strmid(files(i),0,strpos(files(i),'.',/REVERSE_SEARCH))
      outfile = outfile+'_trans.gif'
      spawn,"giftrans -t '#ffffff' -o "+outfile+" "+files(i)
    endfor

endelse
end
