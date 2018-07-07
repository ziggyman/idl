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
pro fitprofs_list_out_sort,fitprofs_list_infile,fitprofs_list_outfile,outfile
;############################
;
; NAME:                  fitprofs_list_out_sort.pro
; PURPOSE:               sorts fitprofs_list.cl output to be able to use the other fitprofs*.pro programs
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fitprofs_list_out_sort,'</yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list>','</yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs.log>','</yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_sort_out.dat>'
; INPUTS:                input file: 'RXJ_ctc.list':
;                          RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.fits
;                          RXJ1523_l_UVES.2000-05-26T23:39:57.321_botzfsx_ecd_ctc.fits
;                          RXJ1523_l_UVES.2000-05-27T00:15:32.288_botzfsx_ecd_ctc.fits
;                                    ...
;                        input file: 'logfile_fitprofs.log' (output file of fitprofs_list.cl):
;                          # Oct 14  0:55 RXJ1523_l_UVES.2000-05-28T07:10:28.581_botzfx_ecd_ctc.fits - Ap 1: OBJECT
;                          # Nfit=1, background=YES, positions=all, gfwhm=all, lfwhm=all
;                          #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                            6604.292 0.9965227 0.0025934 -0.002602 0.0276018   0.08827        0.
;                          # Oct 14  0:55 RXJ1523_l_UVES.2000-05-28T07:46:06.874_botzfx_ecd_ctc.fits - Ap 1: OBJECT
;                          # Nfit=1, background=YES, positions=all, gfwhm=all, lfwhm=all
;                          #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                            6604.281  0.990182 0.0035808 -0.003616 0.0317449     0.106        0.
;                          # Oct 14  0:55 RXJ1523_l_UVES.2000-05-28T07:10:28.581_botzfx_ecd_ctc.fits - Ap 1: OBJECT
;                                  ...
; OUTPUTS:               output file: '<fitprofs_list_out_sort_out.dat'>:
;                          # Oct 14  0:55 RXJ1523_l_UVES.2000-05-28T07:10:28.581_botzfx_ecd_ctc.fits - Ap 1: OBJECT
;                          # Nfit=1, background=YES, positions=all, gfwhm=all, lfwhm=all
;                          #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                            6603.989  1.002499 0.0024061   -0.0024 0.0153168    0.1476        0.
;                            6604.292 0.9965227 0.0025934 -0.002602 0.0276018   0.08827        0.
;                                  ...
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           14.10.2004
;
if n_elements(outfile) lt 1 then begin
    print,'fitprofs_list_out_sort: ERROR: NOT ENOUGH PARAMETERS -> returning'
    print,'fitprofs_list_out_sort: USAGE:'
    print,"  fitprofs_list_out_sort,'</yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list>','</yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs.log>','<fitprofs_list_out_sort_out.dat>'"
endif else begin
;    nfeaturelines = countlines(fitprofs_list_in_datfile)
;    nfeatures = countdatlines(fitprofs_list_in_datfile)
    nfiles = countdatlines(fitprofs_list_infile)
    nlines = countlines(fitprofs_list_outfile)
    ndatlines = countdatlines(fitprofs_list_outfile)
    print,'fitprofs_list_out_sort: '+fitprofs_list_infile+' contains ',nfiles,' datalines (files), '+fitprofs_list_outfile+' contains ',nlines,' lines and ',ndatlines,' datalines'
    headarr = strarr(nfiles,3)
    linearr = strarr(ndatlines)
    tempstr = ''

;; --- read fitprofs_list_in_datfile and write lambdarest_outfile
;    
;    openr,lun,fitprofs_list_in_datfile,/GET_LUN
;    openw,luna,lambdarest_outfile,/GET_LUN
;    tempstr = ''
;    for i=0,nfeaturelines-1 do begin
;        readf,lun,tempstr
;        if strmid(tempstr,0,1) ne '#' then begin
;            printf,luna,strmid(tempstr,0,strpos(tempstr,' '))
;        endif
;    endfor
;    free_lun,lun
;    free_lun,luna

; --- read fitprofs_list_outfile
    openr,lun,fitprofs_list_outfile,/GET_LUN
    headrun = 0
    headsrun = 0
    datrun = 0
    temprun = 0
    for i=0,nlines - 1 do begin
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        if (strmid(tempstr,0,1) eq '#') and (headsrun lt nfiles) then begin
;            print,'fitprofs_list_out_sort: headarr(',headsrun,',',headrun,') = ',tempstr
            headarr(headsrun, headrun) = tempstr
            headrun = headrun + 1
            if headrun eq 3 then $
              headrun = 0
            if headrun eq 0 then $
              headsrun = headsrun + 1
        endif else if strmid(tempstr,0,1) ne '#' then begin
            linearr(datrun) = tempstr
;            print,'fitprofs_list_out_sort: linearr(',datrun,') = ',linearr(datrun)
            if temprun eq 0 then begin
                print,'i = ',i,', datrun = ',datrun,', nfiles = ',nfiles,': lambdarest = ',strmid(tempstr,0,strpos(tempstr,' '))
;                printf,luna,strmid(tempstr,0,strpos(tempstr,' '))
            end
            datrun = datrun + 1
            temprun = temprun + 1
            if temprun eq nfiles then $
                temprun = 0
        end
    endfor
;    free_lun,luna
    free_lun,lun

; --- write outfile
    nwavelengths = ndatlines / nfiles
    openw,lun,outfile,/GET_LUN
    for i=0,nfiles-1 do begin
        for j=0,2 do begin
;            print,'fitprofs_list_out_sort: headarr(',i,',',j,') = ',headarr(i,j)
            printf,lun,headarr(i,j)
        endfor
        for k=0,nwavelengths-1 do begin
            printf,lun,linearr(i+(k*nfiles))
        endfor
    endfor
    free_lun,lun
endelse
end