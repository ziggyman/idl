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
pro get_element_lines_from_line_list,linelistfile,element,outfile
;############################
;
; NAME:                  get_element_lines_from_line_list
; PURPOSE:               writes lines belonging to the specified element from line-list file to outfile
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      get_element_lines_from_line_list,'linelistfile','El','outfile'
; INPUTS:                input file: 'linelistfile':
;                         # units Angstroms
;                         3187.743    HeI
;                         3464.14     AII(70)
;                         3520.5      NeI 3520.472 blend with A 3520.0
;                                            .
;                                            .
;                                            .
;                        El: String, Element to take lines
; OUTPUTS:               outfile: Path and name of outfile
;                         # units Angstroms
;                         3464.14     AII(70)
;                         3545.58     AII(70)
;                         3559.51     AII(70)
;                                        .
;                                        .
;                                        .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.11.2006
;

if n_elements(outfile) eq 0 then begin
  print,'GET_ELEMENT_LINES_FROM_LINE_LIST: Not enough parameters specified, return 0.'
  print,'GET_ELEMENT_LINES_FROM_LINE_LIST: Usage: get_element_lines_from_line_list,<linelistfile: String>,<element: String>,<outfile: String>'
end else begin   

  lambdaq = ''
  commentq = ''

;countlines
  nlines = countlines(linelistfile)
  print,'GET_ELEMENT_LINES_FROM_LINE_LIST: ',linelistfile,' contains ',nlines,' LINES'  
;  maxn = countdatlines(linelistfile)
;  print,'GET_ELEMENT_LINES_FROM_LINE_LIST: ',linelistfile,' contains ',maxn,' DATA LINES'  

;read files
  openr,lun,linelistfile,/GET_LUN
  openw,lunw,outfile,/GET_LUN
  for i=0UL,nlines-1 do begin  
    readf,lun,lambdaq
    print,i,lambdaq
    if strmid(lambdaq,0,1) eq '#' then begin
      printf,lunw,strtrim(lambdaq,2)
    end else begin
      if strpos(lambdaq,element) ge 0 then begin
        printf,lunw,strtrim(lambdaq,2)
      endif
    end
  end  
  free_lun,lunw
  free_lun,lun
endelse
end
