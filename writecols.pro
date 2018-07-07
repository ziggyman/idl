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
pro writecols,linelistfile,cola,colb,outfile
;############################
;
; NAME:                  writecols
; PURPOSE:               writes specified columns of linelistfile to outfile
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      writecols,'linelistfile',1,3,'outfile'
; INPUTS:                input file: 'linelistfile':
;                         # units Angstroms
;                         3187.743    HeI
;                         3464.14     AII(70)
;                         3520.5      NeI 3520.472 blend with A 3520.0
;                                            .
;                                            .
;                                            .
;                        cola: int: number of first column to write
;                        colb: int: number of second column to write
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
; LAST EDITED:           11.04.2007
;

if n_elements(outfile) eq 0 then begin
  print,'WRITECOLS: Not enough parameters specified, return 0.'
  print,'WRITECOLS: Usage: writecols,<linelistfile: String>,<cola: Ordinal>,<colb: Ordinal>,<outfile: String>'
end else begin   

  lambdaq = ''
  commentq = ''

;countlines
  nlines = countlines(linelistfile)
  print,'WRITECOLS: ',linelistfile,' contains ',nlines,' LINES'  
;  maxn = countdatlines(linelistfile)
;  print,'WRITECOLS: ',linelistfile,' contains ',maxn,' DATA LINES'  

;read files
  firstcol = ''
  secondcol = ''
  openr,lun,linelistfile,/GET_LUN
  openw,lunw,outfile,/GET_LUN
  printf,lunw,'# units Angstroms'
  for i=0UL,nlines-1 do begin  
    readf,lun,lambdaq
    print,i,': ',lambdaq
    if strmid(lambdaq,0,1) eq '#' then begin
      printf,lunw,strtrim(lambdaq,2)
    end else begin
      lambda = ''
      firstcol = ''
      secondcol = ''
      for j=0UL,colb do begin
        lambdaq = strtrim(lambdaq,2)
        lambda = strmid(lambdaq,0,strpos(lambdaq,' '))
        print,'WRITECOLS: lambda set to <'+strtrim(lambda,2)+'>'
        lambdaq = strtrim(strmid(lambdaq,strpos(lambdaq,' ')),2)
        print,'WRITECOLS: lambdaq set to <'+strtrim(lambdaq,2)+'>'
        if j eq cola then begin
          firstcol = lambda
          print,'WRITECOLS: firstcol set to <'+firstcol+'>'
        endif
        if j eq colb then begin
          secondcol = lambda+strtrim(strmid(lambdaq,0,strpos(lambdaq,' ')),2)
          print,'WRITECOLS: secondcol set to <'+secondcol+'>'
        endif
      endfor
      printf,lunw,firstcol+' '+secondcol
    end
  end  
  free_lun,lunw
  free_lun,lun
endelse
end
