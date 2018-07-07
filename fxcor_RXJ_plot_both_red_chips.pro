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
pro fxcor_RXJ_plot_both_red_chips,datafiler,datafilel,outputroot
;############################
;
; NAME:                  fxcor_RXJ_plot_both_red_chips.pro
; PURPOSE:               reads datafiles of both red chips and plots vhelio over hjd
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      fxcor_RXJ_plot_both_red_chips,'datafiler','datafilel','outputroot'
; INPUTS:                input file (fxcor_out_trim_mean_rms outfile):
;                        'datafiler' (</yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_red_r_refHD209290_-3.5_120_90_90_90_-2_trimmed.dat>):
;                          
;                          #N HJD HGHT FWHM VOBS VREL VHELIO VERR
;                          #U days          km/s km/s km/s   km/s
;                          1691.4790 0.50 176.43 6.2891 16.5629 3.2244  5.993
;                          1691.5037 0.51 172.20 8.7228 18.9967 5.6219  6.345
;                             ...
; OUTPUTS:               output file: '<outputroot>.eps'
;                        output file: '<outputroot>.data'
;                        output file: '<outputroot>_mean_rms.data'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           23.12.2004
;
    if n_elements(outputroot) lt 1 then begin
        print,'fxcor_RXJ_plot_both_red_chips: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'fxcor_RXJ_plot_both_red_chips: USAGE:'
        print,"  fxcor_RXJ_plot_both_red_chips,'datfiler','datafilel','outputroot'"
    endif else begin

; --- count lines of input files
        nlinesr = countlines(datafiler)
        nlinesl = countlines(datafilel)
        ndatlinesr = countdatlines(datafiler)
        ndatlinesl = countdatlines(datafilel)
        ncolsr = countcols(datafiler)
        ncolsl = countcols(datafilel)

        print,'fxcor_RXJ_plot_both_red_chips: '+datafiler+' contains '+strtrim(string(nlinesr),2)+' lines, '+strtrim(string(ndatlinesr),2)+' lines, and '+strtrim(string(ncolsr),2)+' columns'
        print,'fxcor_RXJ_plot_both_red_chips: '+datafilel+' contains '+strtrim(string(nlinesl),2)+' lines, '+strtrim(string(ndatlinesl),2)+' lines, and '+strtrim(string(ncolsl),2)+' columns'

        if (nlinesr eq nlinesl) and (ndatlinesr eq ndatlinesl) and (ncolsr eq ncolsr) then begin
; --- read data files
            headarr = strarr(nlinesr-ndatlinesr)
            dataarrr = dblarr(ndatlinesr,ncolsr)
            dataarrl = dblarr(ndatlinesr,ncolsr)
            newarr = dblarr(ndatlinesr,ncolsr)
            tempstrr = ''
            tempstrl = ''
            dataline = 0
            headline = 0
            openr,lunr,datafiler,/get_lun
            openr,lunl,datafilel,/get_lun
            for i=0, nlinesr-1 do begin
;                print,'fxcor_RXJ_plot_both_red_chips: reading input files: i = '+strtrim(string(i),2)
                readf,lunr,tempstrr
                readf,lunl,tempstrl
                if strmid(tempstrr,0,1) ne '#' then begin
                    for j=0, ncolsr-1 do begin
                        if strpos(tempstrr,' ') ge 0 then begin
                            dataarrr(dataline,j) = strmid(tempstrr,0,strpos(tempstrr,' '))
                            dataarrl(dataline,j) = strmid(tempstrl,0,strpos(tempstrl,' '))
                        end else begin
                            dataarrr(dataline,j) = tempstrr
                            dataarrl(dataline,j) = tempstrl
                        end
;                        print,'fxcor_RXJ_plot_both_red_chips: dataarrr('+strtrim(string(dataline),2)+','+strtrim(string(j),2)+') = '+strtrim(string(dataarrr[dataline,j]),2),', dataarrl('+strtrim(string(dataline),2)+','+strtrim(string(j),2)+') = '+strtrim(string(dataarrl(dataline,j)),2)
                        tempstrr = strmid(tempstrr,strpos(tempstrr,' '))
                        tempstrl = strmid(tempstrl,strpos(tempstrl,' '))
                        tempstrr = strtrim(tempstrr,2)
                        tempstrl = strtrim(tempstrl,2)
                    endfor
                    dataline = dataline + 1
                endif else begin
                    headarr(headline) = tempstrr
                    headline = headline + 1
                endelse
            endfor
            free_lun,lunr
            free_lun,lunl

; --- calculate new data array
            for i=0, ndatlinesr-1 do begin
                for j=0, ncolsr-1 do begin
;                    if j ne ncolsr-1 then begin
                        newarr(i,j) = (dataarrr(i,j) + dataarrl(i,j)) / 2.
;                    endif else begin
;                        newarr(i,j) = data
;                    endelse
                endfor
            endfor

; --- write newarr to <outputroot>.data
            openw,lun,outputroot+'.data',/get_lun
            for i=0, nlinesr-ndatlinesr-1 do begin
                printf,lun,headarr(i)
            endfor
            xmin = 1000000.
            xmax = -1000.
            ymin = 1000.
            ymax = -1000.
            for i=0, ndatlinesr-1 do begin
                tempstrr = ''
                for j=0, ncolsr-1 do begin
                    tempstrr = tempstrr + strtrim(string(newarr(i,j)),2)
                    if j lt (ncolsr-1) then begin
                        tempstrr = tempstrr + ' '
                    endif
                endfor
                printf,lun,tempstrr
                xmin = min([xmin,newarr(i,0)])
                xmax = max([xmax,newarr(i,0)])
                ymin = min([ymin,newarr(i,5)-newarr(i,6)])
                ymax = max([ymax,newarr(i,5)+newarr(i,6)])
;                print,'fxcor_RXJ_plot_both_red_chips: xmin = ',xmin,', xmax = ',xmax,', ymin = ',ymin,', ymax = ',ymax
            endfor
            free_lun,lun

; --- write meanoutfile
            openw,lunb,outputroot+'_mean_rms.data',/get_lun
            tempday = 0.
            dumday = 0.
            day = 1
            firstimageofday = 0
            for i=0, ndatlinesr-1 do begin
                if i eq 0 then begin
                    tempday = newarr(0,0)
                endif
                dumday = newarr(i,0)
;                print,'fxcor_RXJ_plot_both_red_chips: dumday = '+strtrim(string(dumday),2)+', tempday = '+strtrim(string(tempday),2)+', dumday - tempday = '+strtrim(string(dumday-tempday),2)
                if ((dumday - tempday) gt 0.9) or (i eq (ndatlinesr-1)) then begin
                    if (dumday - tempday) gt 0.9 then begin
                        printf,lunb,'night '+strtrim(string(day),2)+': '+strtrim(string(i-1-firstimageofday))+' images'
                    endif else begin
                        printf,lunb,'night '+strtrim(string(day),2)+': '+strtrim(string(i-firstimageofday))+' images'
                    endelse
                    printf,lunb,'  vobs:'
                    printf,lunb,'    mean = '+strtrim(string(mean(newarr(firstimageofday:i-1,3))),2)+' km/s'      
                    printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(firstimageofday:i-1,3))),2)+' km/s'      
                    printf,lunb,'  vrel:'
                    printf,lunb,'    mean = '+strtrim(string(mean(newarr(firstimageofday:i-1,4))),2)+' km/s'      
                    printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(firstimageofday:i-1,4))),2)+' km/s'      
                    printf,lunb,'  vhelio:'
                    printf,lunb,'    mean = '+strtrim(string(mean(newarr(firstimageofday:i-1,5))),2)+' km/s'      
                    printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(firstimageofday:i-1,5))),2)+' km/s'      
                    firstimageofday = i
                    tempday = newarr(i,0)
                    day = day + 1
                endif 
                
            endfor
            printf,lunb,'all nights: '+strtrim(string(ndatlinesr))+' images'
            printf,lunb,'  vobs:'
            printf,lunb,'    mean = '+strtrim(string(mean(newarr(*,3))),2)+' km/s'      
            printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(*,3))),2)+' km/s'      
            printf,lunb,'  vrel:'
            printf,lunb,'    mean = '+strtrim(string(mean(newarr(*,4))),2)+' km/s'      
            printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(*,4))),2)+' km/s'      
            printf,lunb,'  vhelio:'
            printf,lunb,'    mean = '+strtrim(string(mean(newarr(*,5))),2)+' km/s'      
            printf,lunb,'    rms  = '+strtrim(string(stddev(newarr(*,5))),2)+' km/s'      
            free_lun,lunb

; --- plot vhelio over hjd
            set_plot,'ps'
            device,filename=outputroot+'.eps'
            plot,newarr[*,0],newarr[*,5],xtitle='heliocentric julian date (days)',ytitle='heliocentric radial velocity (km/s)',xrange=[xmin-((xmax-xmin)/10.),xmax+((xmax-xmin)/10.)],yrange=[ymin-((ymax-ymin)/10.),ymax+((ymax-ymin)/10.)],xstyle=1,ystyle=1,charthick=0.8,charsize=1.3,position=[0.12,0.12,0.96,0.99],psym=1
            oploterr,newarr[*,0],newarr[*,5],newarr[*,6]
            device,/close
            set_plot,'x'
        endif
    endelse
end
