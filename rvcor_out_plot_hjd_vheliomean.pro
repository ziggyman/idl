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
pro rvcor_out_plot_hjd_vheliomean,datafilelist
;############################
;
; NAME:                  rvcor_out_plot_hjd_vheliomean.pro
; PURPOSE:               reads datafilelist and plots mean of vhelios over hjd
;                        ;appends name of outfile to outfilelist
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      rvcor_out_plot_hjd_vheliomean,'datafilelist'
; INPUTS:                input file (list of IRAF's rv.rvcorrect outfiles): '/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_hjd_vobs_rvcor_out.list':
;                          /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_3482.71_hjd_vobs_to_rvcorrect_rvcor.dat
;                          /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_3482.93_hjd_vobs_to_rvcorrect_rvcor.dat
;                            ...
;
;                          /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_3482.93_hjd_vobs_to_rvcorrect_rvcor.dat:
;                          # RVCORRECT: Observatory parameters for European Southern Observatory, VLT, Paranal
;                          #       latitude = -24.6253
;                          #       longitude = 70.4022
;                          #       altitude = 2648
;                          ##   HJD          VOBS   VHELIO     VLSR   VDIURNAL   VLUNAR  VANNUAL   VSOLAR
;                          2451691.47890   -84.16   -87.23   -83.05      0.303    0.012   -3.382    4.184
;                          2451690.52804   -84.80   -87.48   -83.29      0.251    0.012   -2.937    4.184
;                             ...
; OUTPUTS:               output file: '<datafile_root>_hjd_vheliomean.eps'
;                        output file:
;                        '<datafile_root>_hjd_vheliomean.dat':
;                          # hjd         vhelio_mean vhelio_rms
;                          23425.2342  -2.5342     0.435
;                          23532.2352  -3.3255     0.235
;                            ...
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           22.10.2004
;
    if n_elements(datafilelist) lt 1 then begin
        print,'rvcor_out_plot_hjd_vheliomean: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'rvcor_out_plot_hjd_vheliomean: USAGE:'
        print,"  rvcor_out_plot_hjd_vheliomean,'datafilelist'"
    endif else begin
; --- count lines of input files
        nlines = countlines(datafilelist)
        nfiles = countdatlines(datafilelist)
        ncols = countcols(datafilelist)

; --- read input file
        filearr = strarr(nfiles)
        tempstr = ''
        idats = 0
        openr,lun,datafilelist,/GET_LUN
        for i=0,nlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                filearr(idats) = tempstr
                idats = idats + 1
            endif
        endfor
        free_lun,lun

; --- read data files
        nlines = countlines(filearr(0))
        ndatlines = countdatlines(filearr(0))
        ncols = countcols(filearr(0))
        dataarr = dblarr(nfiles,ndatlines,ncols)
        vheliomeanarr = dblarr(ndatlines)
        vheliostddevarr = dblarr(ndatlines)
        for j=0,nfiles-1 do begin
            idats = 0
            openr,lun,filearr(j),/GET_LUN
            for i=0,nlines-1 do begin
                readf,lun,tempstr
                tempstr = strtrim(tempstr,2)
                if strmid(tempstr,0,1) ne '#' then begin
                    for k=0,ncols-1 do begin
                        dataarr(j,idats, k) = double(strmid(tempstr,0,strpos(tempstr,' ')))
                        tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1),2)
                    endfor
                    idats = idats + 1
                endif
            endfor
            free_lun,lun
        endfor

; --- calculate vheliomeans and write output data file
        outfile = strmid(datafilelist,0,strpos(datafilelist,'.',/REVERSE_SEARCH))+'_hjd_vheliomean.dat'
        openw,lun,outfile,/GET_LUN
        printf,lun,'# hjd[days]      vhelio_mean[km/s]    vhelio_rms[km/s]'
        for i=0,ndatlines-1 do begin
            print,'hjd(',i,') = ',dataarr(0,i,0)
            vheliomeanarr(i) = mean(dataarr(*,i,2))
            vheliostddevarr(i) = stddev(dataarr(*,i,2))
            printf,lun,dataarr(0,i,0),vheliomeanarr(i),vheliostddevarr(i)
        endfor
        free_lun,lun

; --- plot vhelio over hjd
        outfile = strmid(datafilelist,0,strpos(datafilelist,'.',/REVERSE_SEARCH))+'_hjd_vheliomean.eps'
        print,'rvcor_out_plot_hjd_vheliomean: outfile = '+outfile
        set_plot,'ps'
        device,filename=outfile
        plot,dataarr(0,*,0),vheliomeanarr,xrange=[min(dataarr(0,*,0))-((max(dataarr(0,*,0))-min(dataarr(0,*,0)))/10.),max(dataarr(0,*,0))+((max(dataarr(0,*,0))-min(dataarr(0,*,0)))/10.)],yrange=[min(vheliomeanarr)-max(vheliostddevarr),max(vheliomeanarr)+max(vheliostddevarr)],xstyle=1,ystyle=1,xtitle='hjd [days]',ytitle='vhelio [km/s]',title=strmid(outfile,strpos(outfile,'/',/REVERSE_SEARCH)+1,strpos(outfile,'.',/REVERSE_SEARCH)-strpos(outfile,'/',/REVERSE_SEARCH)-1),psym=2,xticks=5,xtickformat='(F9.1)'
        oploterr,dataarr(0,*,0),vheliomeanarr,vheliostddevarr
        device,/close
        set_plot,'x'
    endelse
end
