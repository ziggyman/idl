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
pro fitprofs_plot_hjd_vobsmean,vobsfilelist
;############################
;
; NAME:                  fitprofs_plot_hjd_vobsmean.pro
; PURPOSE:               calculates and plots mean of vobs values over hjd
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fitprofs_plot_hjd_vobsmean,'<vobsfiles>.list'
; INPUTS:                input file: 'vobsfiles.list':
;                           fitprofs_out_5889.95_hjd_vobs.dat
;                           fitprofs_out_6564.70_hjd_vobs.dat
;                             ...
; OUTPUTS:               '<vobsfiles>_mean.dat':
;                             ...
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           12.10.2004
;
if n_elements(vobsfilelist) lt 1 then begin
    print,'fitprofs_plot_hjd_vobsmean: ERROR: NOT ENOUGH PARAMETERS -> returning'
    print,'fitprofs_plot_hjd_vobsmean: USAGE:'
    print,"  fitprofs_plot_hjd_vobsmean,'<vobsfiles>.list'"
endif else begin

; --- count lines of input files
    nvobsfiles  = countlines(vobsfilelist)
    print,'fitprofs_plot_hjd_vobsmean: vobsfilelist containes ',nvobsfiles,' lines'

; --- read list of vobsfiles
    tempstr = ''
    vobsfilearr = strarr(nvobsfiles)
;    path = strmid(vobsfilelist,0,strpos(vobsfilelist,'/',/REVERSE_SEARCH))+'/'
    openr,lun,vobsfilelist,/get_lun
    for i=0, nvobsfiles-1 do begin
	readf,lun,tempstr
        vobsfilearr(i) = strtrim(tempstr,2)
;        vobsfilearr(i) = path+strtrim(tempstr,2)
;	print,'fitprofs_plot_hjd_vobsmean: vobsfilearr(',i,') = '+vobsfilearr(i)
    endfor
    free_lun,lun

; --- read vobsfiles
    nvlines = countlines(vobsfilearr(0))
    nvdatlines = countdatlines(vobsfilearr(0))
    ncols = countcols(vobsfilearr(0))
    print,'vobsfilearr(0) = ',vobsfilearr(0),': ',nvlines,' lines, ',nvdatlines,' datlines and ',ncols,' columns'
    datarr = dblarr(nvobsfiles,nvdatlines,ncols)
    for i=0,nvobsfiles-1 do begin
	openr,lun,vobsfilearr(i),/get_lun
	l = 0
        for j=0,nvlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
	    print,'fitprofs_plot_hjd_vobsmean: tempstr = <'+tempstr+'>'
            if strmid(tempstr,0,1) ne '#' then begin
                for k=0,ncols-1 do begin
		    if strpos(tempstr,' ') ge 0 then begin
                        datarr(i,l,k) = strmid(tempstr,0,strpos(tempstr,' '))
		    end else begin
                        datarr(i,l,k) = tempstr
		    end
		    if (i eq 0) and (k eq 0) then $
                        print,'fitprofs_plot_hjd_vobsmean: datarr(',i,',',l,',',k,') = ',datarr(i,l,k)
                    tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1,strlen(tempstr)-strpos(tempstr,' ')-1),2)
;		    print,'fitprofs_plot_hjd_vobsmean: tempstr = <'+tempstr+'>'
                endfor           
                l = l+1
            endif
        endfor
        free_lun,lun
    endfor

; calculate and plot mean values for vobs
    vobsmeanarr = dblarr(nvlines)
    vobsstddevarr = dblarr(nvlines)
    errmax = 0.
    for i=0,nvdatlines-1 do begin
	vobsmeanarr(i) = mean(datarr(*,i,1))
        vobsstddevarr(i) = stddev(datarr(*,i,1))
        errmax = max([errmax,vobsstddevarr(i)])
        print,'fitprofs_plot_hjd_vobsmean: vobsmeanarr(',i,') = ',vobsmeanarr(i)
        print,'fitprofs_plot_hjd_vobsmean: vobsstddevarr(',i,') = ',vobsstddevarr(i)
    endfor
    set_plot,'ps'
    psoutfile = strmid(vobsfilelist,0,strpos(vobsfilelist,'.',/REVERSE_SEARCH))+'_hjd_vobsmean.eps'
    print,'fitprofs_plot_hjd_vobsmean: psoutfile = '+psoutfile
    device,filename=psoutfile
    plot,datarr(0,*,0),vobsmeanarr,psym=2,xrange=[min(datarr(0,*,0))-0.2,max(datarr(0,*,0))+0.2],yrange=[min(vobsmeanarr)-errmax,max(vobsmeanarr)+errmax],xstyle=1,ystyle=1,xtitle='hjd [days]',ytitle='observed radial velocity [km/s]',title=strmid(psoutfile,strpos(psoutfile,'/',/REVERSE_SEARCH)+1,strpos(psoutfile,'.',/REVERSE_SEARCH)-strpos(psoutfile,'/',/REVERSE_SEARCH)-1),xticks=5,xtickformat='(F9.1)'
    oploterr,datarr(0,*,0),vobsmeanarr,vobsstddevarr
    device,/close
    set_plot,'x'

; --- write results to outfile
    outfile = strmid(vobsfilelist,0,strpos(vobsfilelist,'.',/REVERSE_SEARCH))+'_mean.dat'
    print,'fitprofs_plot_hjd_vobsmean: outfile = '+outfile
    openw,lun,outfile,/GET_LUN
    for i=0,nvdatlines-1 do begin
        printf,lun,datarr(0,i,0),vobsmeanarr(i),FORMAT='(F16.8," ",F17.9)'
    endfor
    free_lun,lun
endelse
end