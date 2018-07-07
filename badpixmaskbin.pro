;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;############################
pro badpixmaskbin,badpixelfile,xbin,ybin
;############################
;
; NAME:                  badpixmaskbin
; PURPOSE:               * bins the given input-badpixelmask file for
;                          xbin, ybin binned images
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      badpixmaskbin,<String badpixelfile>,<int xbin>,<int ybin>
; INPUTS:                input file: 'badpixelfile':
;                         1       60      2034    2034
;                         2016    2148    2033    2033
;                         1       2148    1975    1981
;                                            .
;                                            .
;                                            .
;                        outfile: <badpixelrootfilename>_<xbin>x<ybin>.<badpixelfileending>
; OUTPUTS:               outfile: <badpixelrootfilename>_2x1.<badpixelfileending>
;                         1       30      2034    2034
;                         1013    1074    2033    2033
;                         1       1074    1975    1981
;                                            .
;                                            .
;                                            .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.12.2005
;

if n_elements(ybin) eq 0 then begin
  print,'badpixmaskbin: No outfile specified, return 0.'
  print,'badpixmaskbin: USAGE: badpixmaskbin,<in: badpixelfile:String>,<int xbin>,<int ybin>'
end else begin

  tempstr = ''

;countlines
  maxn = 0UL
  maxn = countlines(badpixelfile)
  print,badpixelfile,': ',maxn,' LINES'  
  maxndat = 0UL
  maxndat = countdatlines(badpixelfile)
  print,badpixelfile,': ',maxndat,' DATA LINES'  

;build arrays
  dumla   = dblarr(maxndat,4)
  newline = intarr(maxndat,4)
  i = 0UL
  j = 0UL
  k = 0UL
  dumreal = 0.

;read file in arrays
  print,'badpixmaskbin: reading file ',badpixelfile
  openr,lun,badpixelfile,/GET_LUN
  for i=0UL,maxn-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    if strmid(tempstr,0,1) ne '#' then begin
      dumla(j,0) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,1) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,2) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,3) = tempstr
      print,'badpixmaskbin: reading file: line ',i,': dumla(',i,',0) = ',dumla(i,0),', dumla(',i,',1) = ',dumla(i,1),', dumla(',i,',2) = ',dumla(i,2),', dumla(',i,',3) = ',dumla(i,3)
      j = j+1
    endif
  endfor
  free_lun,lun

; --- rebin
  for l=0UL,maxndat-1 do begin
    for i=0,3 do begin
      if ((i lt 2) AND (xbin eq '2')) OR ((i ge 2) AND (ybin eq '2')) then begin
        newline(l,i) = dumla(l,i)/2.
        dumla(l,i) = dumla(l,i)/2.
        print,'badpixmaskbin: newline(',l,',',i,') = ',newline(l,i),', dumla(l,i) = ',dumla(l,i)
        dumreal = newline(l,i)
        if dumreal ne dumla(l,i) then begin
          newline(l,i) = newline(l,i)+1
          print,'badpixmaskbin: newline(',l,',',i,') = ',newline(l,i),', dumla(l,i) = ',dumla(l,i)
        endif
      end else begin
        newline(l,i) = dumla(l,i)
      endelse
    endfor
  endfor

; --- write new file
  outfile = strtrim(strmid(badpixelfile,0,strpos(badpixelfile,'.',/REVERSE_SEARCH)),2)
  outfile = outfile+'_'+strtrim(string(xbin),2)+'x'+strtrim(string(ybin),2)+strtrim(strmid(badpixelfile,strpos(badpixelfile,'.',/REVERSE_SEARCH)),2)
  print,'badpixmaskbin: outfilename = '+outfile
  openw,luna,outfile,/GET_LUN
  for i=0UL,maxndat-1 do begin
    printf,luna,newline(i,0),newline(i,1),newline(i,2),newline(i,3)
  endfor
  free_lun,luna

endelse
end
