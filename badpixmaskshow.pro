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
pro badpixmaskshow,badpixelfile,xbin,ybin
;############################
;
; NAME:                  badpixmaskshow
; PURPOSE:               * bins the given input-badpixelmask file for
;                          xbin, ybin binned images
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      badpixmaskshow,<String badpixelfile>
; INPUTS:                input file: 'badpixelfile':
;                         1       60      2034    2034
;                         2016    2148    2033    2033
;                         1       2148    1975    1981
;                                            .
;                                            .
;                                            .
;                        outfile: <badpixelrootfilename>.png
; OUTPUTS:               outfile: image <badpixelrootfilename>.png
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.12.2005
;

if n_elements(badpixelfile) eq 0 then begin
  print,'badpixmaskshow: No outfile specified, return 0.'
  print,'badpixmaskshow: USAGE: badpixmaskshow,<in: badpixelfile:String>'
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
  xmax    = 0UL
  ymax    = 0UL
  dumreal = 0.

;read file in arrays
  print,'badpixmaskshow: reading file ',badpixelfile
  openr,lun,badpixelfile,/GET_LUN
  for i=0UL,maxn-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    if strmid(tempstr,0,1) ne '#' then begin
      dumla(j,0) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,1) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      if dumla(j,1) gt xmax then xmax = dumla(j,1)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,2) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')),2)
      dumla(j,3) = tempstr
      if dumla(j,1) gt ymax then ymax = dumla(j,1)
      print,'badpixmaskshow: reading file: line ',i,': dumla(',i,',0) = ',dumla(i,0),', dumla(',i,',1) = ',dumla(i,1),', dumla(',i,',2) = ',dumla(i,2),', dumla(',i,',3) = ',dumla(i,3)
      j = j+1
    endif
  endfor
  free_lun,lun

; --- show bad-pixel areas
  outfile = strtrim(strmid(badpixelfile,0,strpos(badpixelfile,'.',/REVERSE_SEARCH)),2)
  outfile = outfile+'.ps'
  print,'badpixmaskshow: outfilename = '+outfile

  set_plot,'ps'
  device,filename=outfile
  mytitle = strmid(badpixelfile,strpos(badpixelfile,'/',/REVERSE_SEARCH)+1)
  myxtitle = 'column'
  myytitle = 'line'
  plot,[0,xmax],[0,ymax],xstyle=1,ystyle=1,psym=2,symsize=0.001,title=mytitle,xtitle=myxtitle,ytitle=myytitle
;  box,1,1,xmax,ymax,25
  for i=0, maxndat-1 do begin
    box,dumla(i,0),dumla(i,2),dumla(i,1),dumla(i,3),150
  endfor
  device,/close
  set_plot,'x'
endelse
end
