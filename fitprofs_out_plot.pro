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
pro fitprofs_out_plot,fitprofs_trim_outfile,hjdfile
;############################
;
; NAME:                  fitprofs_out_plot.pro
; PURPOSE:               calculates and plots observed radial velocity (vobs) over heliocentric julian date (hjd)
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fitprofs_out_plot,'<fitprofs_RXJ_out_trimmed>.dat','<hjds.dat>'
; INPUTS:                input file: 'fitprofs_RXJ_out_trimmed.dat':
;                         #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                           5889.949 0.9329112   0.58931   -0.6317   5.15786    0.1073        0.
;                           5889.949 0.9296033  0.448244   -0.4822    4.0415    0.1042        0.
;                                  ...
; INPUTS:                input file: 'hjds.dat':
;                           2451691.47899437
;                           2451691.50370868
;                             ...
; OUTPUTS:               '<fitprofs_out_trimmed_hjd_vobs.dat'
;                        output file: '<fitprofs_RXJ_5889._hjd_vobs>.data':
;                         # hjd/[days] vobs/[km/s]
;                           2451691.47899437   -0.123
;                           2451691.50370868   -0.231
;                                 .
;                                 .
;                                 .
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.10.2004
;
if n_elements(hjdfile) lt 1 then begin
    print,'fitprofs_out_plot: ERROR: NOT ENOUGH PARAMETERS -> returning'
    print,'fitprofs_out_plot: USAGE:'
    print,"  fitprofs_out_plot,'<fitprofs_trim_outfile>.txt','<hjds>.dat'"
endif else begin
    nlines = countlines(fitprofs_trim_outfile)
    ndatlines = countdatlines(fitprofs_trim_outfile)
    ncols  = countcols(fitprofs_trim_outfile)
    ndats  = countlines(hjdfile)
    print,'fitprofs_out_plot: '+fitprofs_trim_outfile+' containes ',nlines,' lines, ',ndatlines,' datlines and ',ncols,' columns'
    print,'fitprofs_out_plot: '+hjdfile+' containes ',ndats,' lines'
    if ndatlines ne ndats then begin
        print,'fitprofs_out_plot: ERROR: number of data lines in '+fitprofs_trim_outfile+' not equal to number of lines in '+hjdfile+'!!! -> returning'
    end else begin
        c0 = 299792.458
        hjdarr = dblarr(ndatlines)
        datarr = dblarr(ndatlines,ncols)
        tempstr = ''

; --- read hjdfile
        openr,lun,hjdfile,/get_lun
        for i=0,ndatlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            hjdarr(i) = tempstr
;	    print,'fitprofs_out_plot: hjdarr(',i,') = <',hjdarr(i)
        endfor
        free_lun,lun

; --- read fitprofs_trim_outfile
        openr,lun,fitprofs_trim_outfile,/get_lun
        for i=0,nlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                for j=0,ncols-1 do begin
		    if strpos(tempstr,' ') ge 0 then begin
                        datarr(i-1,j) = strmid(tempstr,0,strpos(tempstr,' '))
		    end else begin
			datarr(i-1,j) = tempstr
		    end
		    if j eq 0 then $
;                    print,'fitprofs_out_plot: datarr(',i-1,',',j,') = ',datarr(i-1,j)
                    tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1,strlen(tempstr)-strpos(tempstr,' ')-1),2)
                endfor
            endif
        endfor
        free_lun,lun

; --- calculate vobsarr
        vobsarr = dblarr(ndats)
        lambda0 = 0.
        lambda0 = strmid(fitprofs_trim_outfile,strpos(fitprofs_trim_outfile,'_',/REVERSE_SEARCH)+1,strpos(fitprofs_trim_outfile,'.',/REVERSE_SEARCH)-strpos(fitprofs_trim_outfile,'_',/REVERSE_SEARCH)-1)
        print,'fitprofs_out_plot: lambda0 = ',lambda0
        outfile = strmid(fitprofs_trim_outfile,0,strpos(fitprofs_trim_outfile,'.',/REVERSE_SEARCH))+'_hjd_vobs.dat'
        openw,luna,outfile,/get_lun
        printf,luna,'# hjd/[days] vobs/[km/s]'
        for i=0,ndats-1 do begin
; --- v/c = dlambda/lambda0
  	    vobsarr(i) = c0 * (datarr(i,0)-lambda0)/lambda0
            print,'fitprofs_out_plot: vobsarr(',i,') = ',vobsarr(i)
            printf,luna,hjdarr(i),vobsarr(i),FORMAT = '(F16.8," ",F17.9)'
	endfor
        free_lun,luna
        
; --- plot lambda over hjd
        psoutfile = strmid(outfile,0,strpos(outfile,'_',/REVERSE_SEARCH))+'_lambda.eps'
	print,'fitprofs_out_plot: psoutfile = <'+psoutfile+'>'
        set_plot,'ps'
        device,filename=psoutfile
        plot,hjdarr,datarr(*,0),psym=2,xstyle=1,ystyle=1,xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],yrange=[min(datarr(*,0))-(max(datarr(*,0))-min(datarr(*,0)))/10.,max(datarr(*,0))+(max(datarr(*,0))-min(datarr(*,0)))/10.],xtitle='hjd [days]',ytitle='wavelength [Angstroem]',title=strmid(psoutfile,strpos(psoutfile,'/',/REVERSE_SEARCH)+1,strpos(psoutfile,'.',/REVERSE_SEARCH)-strpos(psoutfile,'/',/REVERSE_SEARCH)-1),xticks=5,xtickformat='(F9.1)'
        device,/close
        set_plot,'x'
; --- plot vobs over hjd
        psoutfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'.eps'
	print,'fitprofs_out_plot: psoutfile = <'+psoutfile+'>'
        set_plot,'ps'
        device,filename=psoutfile
        plot,hjdarr,vobsarr,psym=2,xstyle=1,ystyle=1,xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],yrange=[min(vobsarr)-(max(vobsarr)-min(vobsarr))/10.,max(vobsarr)+(max(vobsarr)-min(vobsarr))/10.],xtitle='hjd [days]',ytitle='vobs [km/s]',title=strmid(psoutfile,strpos(psoutfile,'/',/REVERSE_SEARCH)+1,strpos(psoutfile,'.',/REVERSE_SEARCH)-strpos(psoutfile,'/',/REVERSE_SEARCH)-1),xticks=5,xtickformat='(F9.1)'
        device,/close
        set_plot,'x'
    endelse
endelse
end