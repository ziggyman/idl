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
pro plot_equiwidths_and_airmass_over_hjd,fitprofs_out,airmasslist,hjdlist
;############################
;
; NAME:                  plot_equiwidths_and_airmass_over_hjd.pro
; PURPOSE:               plots equivalent widths of the (telluric?)
;                        emission lines and the airmass over hjd
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      plot_equiwidths_and_airmass_over_hjd,'fitprofs_out.txt','airmasslist','hjdlist'
; INPUTS:                input file: 'fitprofs_out':
;                          # Oct 14  3:04 RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.fits - Ap 1: OBJECT
;                          # Nfit=1, background=YES, positions=all, gfwhm=all, lfwhm=all
;                          #   center      cont      flux       eqw      core     gfwhm     lfwhm
;                          5888.183  0.648878 0.0646819  -0.09968   0.57325     0.106        0.
;                          5889.949 0.5592897   0.68574    -1.226   5.41836    0.1189        0.
;                          5895.922 0.5588993  0.390904   -0.6994   3.10078    0.1184        0.
;                             ...
;                        input file: 'airmasslist':AIRMASS_START AIRMASS_END
;                          2.32 2.02
;                          1.98 1.84
;                           ...
;                        input file: 'hjdlist':
;                          2451691.47899437
;                          2451691.50370868
;                          2451691.5284187
;                          
;                             ...
; OUTPUTS:               '<fitprofs_out>_hjd_equiwidth_airmass.dat'
;                        '<fitprofs_out>_hjd_equiwidth_airmass.eps'
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           14.10.2004
;
if n_elements(hjdlist) lt 1 then begin
    print,'plot_equiwidths_and_airmass_over_hjd: ERROR: NOT ENOUGH PARAMETERS -> returning'
    print,'plot_equiwidths_and_airmass_over_hjd: USAGE:'
    print,"  plot_equiwidths_and_airmass_over_hjd,'<fitprofs_out.txt>','<airmasses.list>','<hjds_l.text>'"
endif else begin
    nlines = countlines(fitprofs_out)
    ndatlines = countdatlines(fitprofs_out)
    ncols = countcols(fitprofs_out)
    nhjdlines = countlines(hjdlist)
    nairmasslines = countlines(airmasslist)
    if nairmasslines ne nhjdlines then begin
        print,'plot_equiwidths_and_airmass_over_hjd: nairmasslines (=',nairmasslines,') not equal to nhjdlines (=',nhjdlines,')'
    endif else begin
        print,'plot_equiwidths_and_airmass_over_hjd: '+fitprofs_out+' contains ',nlines,' lines and ',ndatlines,' datalines'
	print,'plot_equiwidths_and_airmass_over_hjd: '+hjdlist+' contains ',nhjdlines,' lines, '+airmasslist+' contains ',nairmasslines,' lines'

; --- read hjdlist
        hjdarr = dblarr(nhjdlines)
        tempstr = ''
        openr,lun,hjdlist,/GET_LUN
        for i=0,nhjdlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            hjdarr(i) = tempstr
        endfor
        free_lun,lun

; --- read fitprofs_out
        datarr = dblarr(nhjdlines,ndatlines/nhjdlines,ncols)
        openr,lun,fitprofs_out,/GET_LUN
        tempdbl = 0.
        for i=0, nhjdlines-1 do begin
            datrun = 0
            for j=0,(nlines/nhjdlines) - 1 do begin
                readf,lun,tempstr
                if strmid(tempstr,0,1) ne '#' then begin
                    for k=0,ncols-1 do begin
                        if strpos(tempstr,' ') ge 0 then begin
                            tempdbl = double(strmid(tempstr,0,strpos(tempstr,' ')))
;                            print,"strmid(tempstr,0,strpos(tempstr,' ')) = "+strmid(tempstr,0,strpos(tempstr,' '))
                            datarr(i,datrun,k) = tempdbl
    		        end else begin
                            datarr(i,datrun,k) = double(tempstr)
		        end
                        tempstr = strtrim(strmid(tempstr,strpos(tempstr,' ')+1,strlen(tempstr)-strpos(tempstr,' ')-1),2)
;		        print,'plot_equiwidths_and_airmass_over_hjd: tempstr = <'+tempstr+'>'
;                        print,'plot_equiwidths_and_airmass_over_hjd: datarr('+strtrim(string(i),2)+','+strtrim(string(datrun),2)+','+strtrim(string(k),2)+') = ',datarr(i,datrun,k)
                    endfor
                    datrun = datrun + 1
                endif
            endfor
        endfor
        free_lun,lun

; --- read airmasslist
        airmassarr = dblarr(nairmasslines)
        airmassstddevarr = dblarr(nairmasslines)
        airmassa = 0.
        airmassb = 0.
        openr,lun,airmasslist,/GET_LUN
        for i=0,nairmasslines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            airmassa = strmid(tempstr,0,strpos(tempstr,' '))
            tempstr = strmid(tempstr,strpos(tempstr,' ',/REVERSE_SEARCH)+1,strlen(tempstr)-strpos(tempstr,' ',/REVERSE_SEARCH)-1)
            airmassb = tempstr
            airmassarr(i) = (airmassa + airmassb) / 2.
            airmassstddevarr(i) = stddev([double(airmassa),double(airmassb)])
            print,'plot_equiwidths_and_airmass_over_hjd: airmassa = '+strtrim(string(airmassa),2)+', airmassb = '+strtrim(string(airmassb),2)+' -> airmassarr('+strtrim(string(i),2)+') = '+strtrim(string(airmassarr(i)),2)
        endfor
        free_lun,lun

; --- plot equivalent width over hjd for each feature
        psfilelist = strmid(fitprofs_out,0,strpos(fitprofs_out,'.',/REVERSE_SEARCH))+'_equiwidth_over_hjd_eps-files.list'
        openw,lun,psfilelist,/GET_LUN
        for i=0,(ndatlines/nhjdlines) - 1 do begin
            psoutfile = strmid(fitprofs_out,0,strpos(fitprofs_out,'.',/REVERSE_SEARCH))+'_'+strtrim(string(datarr(0,i,0)),2)+'_equiwidth_over_hjd.eps'
            print,'plot_equiwidths_and_airmass_over_hjd: psoutfile(',i,') = '+psoutfile
            printf,lun,psoutfile
            set_plot,'ps'
            device,filename=psoutfile
            plot,hjdarr,datarr(*,i,3),xstyle=1,ystyle=1,xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],yrange=[min(datarr(*,i,3))-((max(datarr(*,i,3))-min(datarr(*,i,3)))/10.),max(datarr(*,i,3))+((max(datarr(*,i,3))-min(datarr(*,i,3)))/10.)],xtitle='hjd [days]',ytitle='equivalent width',title='lambda = '+strtrim(string(datarr(0,i,0)),2),psym=2,xtickformat='(F9.1)'
            device,/close
            set_plot,'x'
        endfor

; --- plot mean of equivalent widths over hjd
        equimeanarr = dblarr(nhjdlines)
	equistddevarr = dblarr(nhjdlines)
        for i=0,nhjdlines-1 do begin
            equimeanarr(i) = mean(datarr(i,*,3))
            equistddevarr(i) = stddev(datarr(i,*,3))
        endfor
	psoutfile = strmid(fitprofs_out,0,strpos(fitprofs_out,'.',/REVERSE_SEARCH))+'_equiwidths_over_hjd.eps'
        print,'plot_equiwidths_and_airmass_over_hjd: psoutfile = '+psoutfile
        printf,lun,psoutfile
        set_plot,'ps'
        device,filename=psoutfile
        plot,hjdarr,equimeanarr,xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],xstyle=1,ystyle=1,yrange=[min(equimeanarr)-((max(equimeanarr)-min(equimeanarr))/10.),max(equimeanarr)+((max(equimeanarr)-min(equimeanarr))/10.)],xtitle='hjd [days]',ytitle='mean of equivalent widths',title=fitprofs_out,psym=2,xtickformat='(F9.1)
;        plot,hjdarr,equimeanarr,xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],xstyle=1,ystyle=1,yrange=[min(equimeanarr)-max(equistddevarr),max(equimeanarr)+max(equistddevarr)],xtitle='hjd [days]',ytitle='mean of equivalent widths',title=fitprofs_out,psym=2
;	oploterr,hjdarr,equimeanarr,equistddevarr
        device,/close
        set_plot,'x'

; --- plot airmasses over hjd
        psoutfile = strmid(fitprofs_out,0,strpos(fitprofs_out,'.',/REVERSE_SEARCH))+'_airmass_over_hjd.eps'
        set_plot,'ps'
        device,filename=psoutfile
        print,'plot_equiwidths_and_airmass_over_hjd: psoutfile = '+psoutfile
        printf,lun,psoutfile
        plot,hjdarr,airmassarr,xtitle='hjd [days]',xrange=[min(hjdarr)-0.2,max(hjdarr)+0.2],yrange=[min(airmassarr)-((max(airmassarr)-min(airmassarr))/10.),max(airmassarr)+((max(airmassarr)-min(airmassarr))/10.)],xstyle=1,ystyle=1,ytitle='airmass',title='MNLupus',psym=2,xtickformat='(F9.1)'
;        oploterr,hjdarr,airmassarr,airmassstddevarr
        device,/close
        set_plot,'x'

; --- plot mean of equivalent widths over airmass
        psoutfile = strmid(fitprofs_out,0,strpos(fitprofs_out,'.',/REVERSE_SEARCH))+'_equiwidths_over_airmass.eps'
        print,'plot_equiwidths_and_airmass_over_hjd: psoutfile = '+psoutfile
        printf,lun,psoutfile
        set_plot,'ps'
        device,filename=psoutfile
        plot,airmassarr,equimeanarr,xrange=[min(airmassarr)-((max(airmassarr)-min(airmassarr))/10.),max(airmassarr)+((max(airmassarr)-min(airmassarr))/10.)],yrange=[min(equimeanarr)-((max(equimeanarr)-min(equimeanarr))/10.),max(equimeanarr)+((max(equimeanarr)-min(equimeanarr))/10.)],xstyle=1,ystyle=1,xtitle='airmass',ytitle='mean of equivalent widths',title='MNLupus',psym=2,xtickformat='(F9.1)'
;        plot,airmassarr,equimeanarr,xrange=[min(airmassarr)-((max(airmassarr)-min(airmassarr))/10.),max(airmassarr)+((max(airmassarr)-min(airmassarr))/10.)],yrange=[min(equimeanarr)-max(equistddevarr),max(equimeanarr)+max(equistddevarr)],xstyle=1,ystyle=1,xtitle='airmass',ytitle='mean of equivalent widths',title='MNLupus',psym=2
;        oploterr,airmassarr,equimeanarr,equistddevarr
        device,/close
        set_plot,'x'
        free_lun,lun
        print,'plot_equiwidths_and_airmass_over_hjd: psfilelist = '+psfilelist
    endelse
endelse
end
