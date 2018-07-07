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

;###########################
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;############################
pro calcequiwidths_RXJ_trim_rangelist,rangelist
;############################
;
; NAME:                  calcequiwidths_RXJ_trim_rangelist
; PURPOSE:               * writes lambda_min and lambda_max from
;                          'rangelist' to <outfile>
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcequiwidths_RXJ_trim_rangelist,'rangelist'
; INPUTS:                input file: 'rangelist':
;                          # lambda lambda_min lambda_max height function equiwidth
;                          5889.951 5889.77 5890.11 5. gaussian 0.12
;                          5895.924 5895.78 5896.11 3. gaussian 0.12
;                          6300.304 6300.1 6300.49 22. gaussian 0.13
;                              ...
; OUTPUTS:               outfile: '<rangelist_root>_lmin_lmax.dat'
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           28.10.2004
;

if n_elements(rangelist) eq 0 then begin
    print,'calcequiwidths_RXJ_trim_rangelist: Not enough arguments specified, return 0.'
    print," USAGE: calcequiwidths_RXJ_trim_rangelist,'../../UVES/ready/red_l/known_emission_lines_l_ranges.dat'"
end else begin   
    
    nlines = countlines(rangelist)
    ndatlines = countdatlines(rangelist)
    ncols = countcols(rangelist)

    dataarr = strarr(ndatlines,ncols)
    tempstr = ''
    idat = 0
    
; --- read rangelist
    openr,lun,rangelist,/GET_LUN
    for i=0,nlines-1 do begin
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        if strmid(tempstr,0,1) ne '#' then begin
            for j=0,ncols-1 do begin
                if strpos(tempstr,' ') ge 0 then begin
                    dataarr(idat,j) = strmid(tempstr,0,strpos(tempstr,' '))
                end else begin
                    dataarr(idat,j) = tempstr
                end
;                if j eq 0 then $
;                    print,'fitprofs_out_plot: datarr(',i-1,',',j,') = ',datarr(i-1,j)
                tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1,strlen(tempstr)-strpos(tempstr,' ')-1),2)
            endfor
            idat = idat+1
        endif        
    endfor
    free_lun,lun

; --- write outfile
    outfile = strmid(rangelist,0,strpos(rangelist,'.',/REVERSE_SEARCH))+'_lmin_lmax'+strmid(rangelist,strpos(rangelist,'.',/REVERSE_SEARCH))
    openw,lun,outfile,/GET_LUN
    for i=0,ndatlines-1 do begin
        printf,lun,dataarr(i,1)+' '+dataarr(i,2)
    endfor
    free_lun,lun
end
end
