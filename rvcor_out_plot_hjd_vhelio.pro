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
pro rvcor_out_plot_hjd_vhelio,datafile
;############################
;
; NAME:                  rvcor_out_plot_hjd_vhelio.pro
; PURPOSE:               reads datafile and plots vhelio over hjd
;                        ;appends name of outfile to outfilelist
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      rvcor_out_plot_hjd_vhelio,'datafile','outfilelist'
; INPUTS:                input file (IRAF's rv.rvcorrect outfile): 'datafile':
;                          # RVCORRECT: Observatory parameters for European Southern Observatory, VLT, Paranal
;                          #       latitude = -24.6253
;                          #       longitude = 70.4022
;                          #       altitude = 2648
;                          ##   HJD          VOBS   VHELIO     VLSR   VDIURNAL   VLUNAR  VANNUAL   VSOLAR
;                          2451691.47890   -84.16   -87.23   -83.05      0.303    0.012   -3.382    4.184
;                          2451690.52804   -84.80   -87.48   -83.29      0.251    0.012   -2.937    4.184
;                             ...
; OUTPUTS:               output file: '<datafile_root>_hjd_vobs.eps'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           22.10.2004
;
    if n_elements(datafile) lt 1 then begin
        print,'rvcor_out_plot_hjd_vhelio: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'rvcor_out_plot_hjd_vhelio: USAGE:'
        print,"  rvcor_out_plot_hjd_vhelio,'datfile'"
    endif else begin
; --- count lines of input files
        nlines = countlines(datafile)
        ndatlines = countdatlines(datafile)
        ncols = countcols(datafile)

; --- read input file
        dataarr = dblarr(ndatlines,ncols)
        tempstr = ''
        idats = 0
        openr,lun,datafile,/GET_LUN
        for i=0,nlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                for j=0,ncols-1 do begin
                    dataarr(idats, j) = double(strmid(tempstr,0,strpos(tempstr,' ')))
                    tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1),2)
                endfor
                idats = idats + 1
            endif
        endfor
        free_lun,lun

; --- plot vhelio over hjd
        outfile = strmid(datafile,0,strpos(datafile,'vobs',/REVERSE_SEARCH))+'vhelio.eps'
;        openw,lun,outfilelist,/GET_LUN,/APPEND
;        printf,lun,outfile
;        free_lun,lun
        print,'rvcor_out_plot_hjd_vhelio: outfile = '+outfile
        set_plot,'ps'
        device,filename=outfile
        plot,dataarr(*,0),dataarr(*,2),xrange=[min(dataarr(*,0))-((max(dataarr(*,0))-min(dataarr(*,0)))/10.),max(dataarr(*,0))+((max(dataarr(*,0))-min(dataarr(*,0)))/10.)],yrange=[min(dataarr(*,2))-((max(dataarr(*,2))-min(dataarr(*,2)))/10.),max(dataarr(*,2))+((max(dataarr(*,2))-min(dataarr(*,2)))/10.)],xstyle=1,ystyle=1,xtitle='hjd [days]',ytitle='vhelio [km/s]',title=strmid(outfile,strpos(outfile,'/',/REVERSE_SEARCH)+1,strpos(outfile,'.',/REVERSE_SEARCH)-strpos(outfile,'/',/REVERSE_SEARCH)-1),psym=2,xticks=5,xtickformat='(F9.1)'
        device,/close
        set_plot,'x'
    endelse
end
