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
pro calcequiwidths_RXJ,filelist,rangelist,hjdlist
;############################
;
; NAME:                  calcequiwidths_RXJ
; PURPOSE:               * calculates the equivalent widths within a
;                          given wavelengthrange for a list of files
;                        * plots equivalent widths over hjd
;                        * calculates mean and rms of equivalent widths
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcequiwidths_RXJ,'filelist','rangelist','hjdlist'
; INPUTS:                input file: 'filelist':
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.text
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:39:57.321_botzfsx_ecd_ctc.text
;                                 .
;                                 .
;                                 .
;                        input file: 'rangelist':
;                          #lambda_middle lambda_min lambda_max npix_left_from_lambda_min npix_right_from_lambda_min npix_left_from_lambda_max npix_right_from_lambda_max
;                          6563.43 6557.25 6568.60 2 1 1 2
;                          5992.23 5882.52 5903.16 20 5 2 30
;                          6438.54 6435.32 6443.08 10 5 5 10
;                              ...
;                        input file: 'hjdlist':
;                          2451691.5531219
;                          2451691.58047251
;                              ...
; OUTPUTS:               outfile: '<datfile>_<xmin>-<xmax>.dat'
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.04.2004
;

if n_elements(hjdlist) eq 0 then begin
    print,'calcequiwidths_RXJ: Not enough arguments specified, return 0.'
    print," USAGE: calcequiwidths_RXJ,'../../UVES/ready/red_l/RXJ_ctcv.list','../../UVES/ready/red_l/known_emission_lines_l_ranges.dat','../../UVES/ready/red_l/hjdlist.text'"
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

; --- start equiwidthlist,...
    for i=0,ndatlines-1 do begin
        equiwidthlist,filelist,double(dataarr(i,0)),double(dataarr(i,1)),double(dataarr(i,2)),long(dataarr(i,3)),long(dataarr(i,4)),long(dataarr(i,5)),long(dataarr(i,6)),hjdlist
    endfor

endelse
end
