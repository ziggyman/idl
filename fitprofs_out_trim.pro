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
pro fitprofs_out_trim,fitprofs_outfile,rest_wavelengths
;############################
;
; NAME:                  fitprofs_out_trim.pro
; PURPOSE:               removes unnecessary lines from fitprofs-out
;                        files and sorts them by wavelength
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fitprofs_out_trim,'<fitprofs_RXJ_out>.txt','<rest_wavelengths>.dat'
; INPUTS:                input file: 'fitprofs_RXJ_out.txt':
;                         # Oct 11 13:28 RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.fits - Ap 1: OBJECT
;                         # Nfit=5, background=YES, positions=all, gfwhm=all, lfwhm=all
;                         #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                           5889.949 0.9329112   0.58931   -0.6317   5.15786    0.1073        0.
;                           5895.922 0.9331263  0.299532    -0.321   2.81372       0.1        0.
;                           6300.304   0.94769   3.40355    -3.591   24.3593    0.1313        0.
;                           6363.778 0.9499759  0.982022    -1.034   7.19365    0.1282        0.
;                           6562.861 0.9571458    5.1559    -5.387   1.65263     2.931        0.
;                         # Oct 11 13:28 RXJ1523_l_UVES.2000-05-26T23:39:57.321_botzfsx_ecd_ctc.fits - Ap 1: OBJECT
;                         # Nfit=5, background=YES, positions=all, gfwhm=all, lfwhm=all
;                         #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                           5889.949 0.9296033  0.448244   -0.4822    4.0415    0.1042        0.
;                           5895.922 0.9298649  0.241355   -0.2596   2.32431   0.09755        0.
;                                  ...
; INPUTS:                input file: 'rest_wavelengths.dat':
;                           5889.951 
;                           5895.924
;                           6300.304
;                           6363.776
;                           6564.70
; OUTPUTS:               '<fitprofs_RXJ_<restwavelength>>.data'
;                        output file: '<fitprofs_RXJ_5889.>.data':
;                         #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                           5889.949 0.9329112   0.58931   -0.6317   5.15786    0.1073        0.
;                           5889.949 0.9296033  0.448244   -0.4822    4.0415    0.1042        0.
;                                 .
;                                 .
;                                 .
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.10.2004
;
if n_elements(rest_wavelengths) lt 1 then begin
    print,'fitprofs_out_trim: ERROR: NOT ENOUGH PARAMETERS -> returning'
    print,'fitprofs_out_trim: USAGE:'
    print,"  fitprofs_out_trim,'<fitprofs_outfile>.txt','<rest_wavelengths>.dat'"
endif else begin
    nlines = countlines(fitprofs_outfile)
    ncols  = countcols(fitprofs_outfile)
    nrestlines = countlines(rest_wavelengths)
    ndats  = countdatlines(rest_wavelengths)
    print,'fitprofs_out_trim: '+fitprofs_outfile+' containes ',nlines,' lines and ',ncols,' columns'
    print,'fitprofs_out_trim: '+rest_wavelengths+' containes ',nrestlines,' lines and ',ndats,' datalines'
    
    restwavelengtharr = strarr(ndats)
    datlinearr = strarr(ndats,nlines/(ndats + 3))

; --- read rest_wavelengts
    openr,lun,rest_wavelengths,/get_lun
    dat = 0
    for i=0,nrestlines-1 do begin
        readf,lun,templine
	templine = strtrim(templine,2)
	if strmid(templine,0,1) ne '#' then begin
    	    restwavelengtharr(dat) = templine
	    dat = dat + 1
	endif
    endfor
    free_lun,lun

; --- read fitprofs_outfile
    headerline = ''
    spectra = 0
    dat = 0
    openr,lun,fitprofs_outfile,/get_lun
    for i=0,nlines-1 do begin
        readf,lun,templine
	templine = strtrim(templine,2)
;        print,'fitprofs_out_trim: strmid(templine,0,10) = <'+strmid(templine,0,10)+'>'
        if strmid(templine,0,10) eq '#   center' then begin
	    headerline = templine
	    spectra = spectra + 1
	    dat = 0
	end else if strmid(templine,0,1) ne '#' then begin
	    print,'dat = ',dat,': templine = '+templine
	    datlinearr(dat,spectra-1) = templine
	    print,'fitprofs_out_trim: datlinearr(',dat,',',spectra-1,') = '+datlinearr(dat,spectra-1)
	    dat = dat + 1
	end
    endfor
    free_lun,lun

; --- write outfiles
    for i=0,ndats-1 do begin
        outfile = strmid(fitprofs_outfile,0,strpos(fitprofs_outfile,'.',/REVERSE_SEARCH))+'_'+restwavelengtharr(i)+'.dat'
	print,'fitprofs_out_trim: outfile(',i,') = '+outfile
	openw,lun,outfile,/get_lun
        printf,lun,headerline
        for j=0,nlines/(ndats+3)-1 do begin
            printf,lun,datlinearr(i,j)
        endfor
        free_lun,lun
    endfor
end
end
