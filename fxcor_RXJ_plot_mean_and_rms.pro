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
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  readf,lun,templine
  free_lun,lun
  templine = strtrim(templine,2)
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;############################
common maxn,maxc
;############################
pro fxcor_RXJ_plot_mean_and_rms,listred,listblue,color,print
;############################
common maxn,maxc
;############################
;
; NAME:                  fxcor_RXJ_plot_mean_and_rms.pro
; PURPOSE:               calculates and plots the mean and rms for the radial
;                        velocities in 'inlist' over hjd
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fxcor_RXJ_plot_mean_and_rms,'../../UVES/ready/fxcor_RXJ_final_red_vhelio.data','../../UVES/ready/fxcor_RXJ_final_blue_vhelio.data','color','print'
; INPUTS:                input file: listred: '../../UVES/ready/fxcor_RXJ_final_red_vhelio.data'
;                                    1692.234 1692.263 ... (hjds)
;                                    2.2534 5.2352 ... (vhelios)
;                                    2.5343 5.2525 ... (vhelios)
;                                    ...
;                        input file: listblue: '../../UVES/ready/fxcor_RXJ_final_blue_vhelio.data'
;                                    1692.234 1692.263 ... (hjds)
;                                    2.2534 5.2352 ... (vhelios)
;                                    2.5343 5.2525 ... (vhelios)
;                                    ...
;                        color: String
;                        print: String
; OUTPUTS:               'RXJ_vhelio_final.eps'
; COPYRIGHT:             Andreas Ritter
; DATE:                  27.08.2004
;
;                        headline
;                        feetline (up to now not used) 
;

if n_elements(listblue) lt 1 then begin
    print,'fxcor_RXJ_plot_mean_and_rms: ERROR: not enough parameters specified!'
    print,"fxcor_RXJ_plot_mean_and_rms: USAGE: fxcor_RXJ_plot_mean_and_rms,'listred','listblue','print'"
    listred  = '../../UVES/ready/fxcor_RXJ_final_red_vhelio.data' 
    listblue = '../../UVES/ready/fxcor_RXJ_final_blue_vhelio.data'
endif

maxnred = countlines(listred)
maxcred = countcols(listred)
print,'fxcor_RXJ_plot_mean_and_rms: listred "'+listred+'" contains '+strtrim(string(maxnred),2)+' rows and '+strtrim(string(maxcred),2)+' columns'

maxnblue = countlines(listblue)
maxcblue = countcols(listblue)
print,'fxcor_RXJ_plot_mean_and_rms: listblue "'+listblue+'" contains '+strtrim(string(maxnblue),2)+' rows and '+strtrim(string(maxcblue),2)+' columns'

nbluefirstnight  = 0
nbluesecondnight = 0
nredfirstnight   = 0
nredsecondnight  = 0
dhjd    = 1.
dhjdold = 0.

hjdarrred   = dblarr(maxcred)
vradarrred  = dblarr(maxnred,maxcred)
hjdarrblue  = dblarr(maxcblue)
vradarrblue = dblarr(maxnblue,maxcblue)

line = ''
; --- red
openr,lun,listred,/get_lun
for i=0,maxnred-1 do begin
    readf,lun,line
    line = strtrim(line,2)
    if i eq 0 then begin
        for j=0,maxcred-1 do begin
            if strpos(line,' ') lt 0 then begin
                hjdarrred(j) = line
            endif else begin
                hjdarrred(j) = strmid(line,0,strpos(line,' '))
                line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
                if j gt 0 then begin
                    dhjdold = dhjd
                    dhjd = hjdarrred(j) - hjdarrred(j-1)
                    if dhjd gt (2.*dhjdold) then begin
                        nredfirstnight  = j-1
                        nredsecondnight = maxcred-nredfirstnight
                        print,'fxcor_RXJ_plot_mean_and_rms: nredfirstnight = '+string(nredfirstnight)+', nredsecondnight = '+string(nredsecondnight)+', maxcred = '+string(maxcred)
                    endif
                endif
            endelse 
;            print,'fxcor_RXJ_plot_mean_and_rms: hjdarrred('+strtrim(string(j),2)+') = <'+strtrim(string(hjdarrred(j)),2)+'>'
        endfor 
    endif else begin
        for j=0,maxcred-1 do begin
            if strpos(line,' ') lt 0 then begin
                vradarrred(i,j) = line
            endif else begin
                vradarrred(i,j) = strmid(line,0,strpos(line,' '))
                line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
            endelse
;      print,'fxcor_RXJ_plot_mean_and_rms: vradarrred('+strtrim(string(i),2)+','+strtrim(string(j),2)+') = <'+strtrim(string(vradarrred(i,j)),2)+'>'
        endfor
    endelse
endfor
free_lun,lun

; --- blue
dhjd = 1.
openr,lun,listblue,/get_lun
for i=0,maxnblue-1 do begin
    readf,lun,line
    line = strtrim(line,2)
    if i eq 0 then begin
        for j=0,maxcblue-1 do begin
            if strpos(line,' ') lt 0 then begin
                hjdarrblue(j) = line
            endif else begin
                hjdarrblue(j) = strmid(line,0,strpos(line,' '))
                line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
                if j gt 0 then begin
                    dhjdold = dhjd
                    dhjd = hjdarrblue(j) - hjdarrblue(j-1)
                    if dhjd gt (2.*dhjdold) then begin
                        nbluefirstnight  = j-1
                        nbluesecondnight = maxcblue-nbluefirstnight
                        print,'fxcor_RXJ_plot_mean_and_rms: nbluefirstnight = '+string(nbluefirstnight)+', nbluesecondnight = '+string(nbluesecondnight)+', maxcblue = '+string(maxcblue)
                    endif
                endif
            endelse 
;            print,'fxcor_RXJ_plot_mean_and_rms: hjdarrblue('+strtrim(string(j),2)+') = <'+strtrim(string(hjdarrblue(j)),2)+'>'
        endfor 
    endif else begin
        for j=0,maxcblue-1 do begin
            if strpos(line,' ') lt 0 then begin
                vradarrblue(i,j) = line
            endif else begin
                vradarrblue(i,j) = strmid(line,0,strpos(line,' '))
                line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
            endelse
;      print,'fxcor_RXJ_plot_mean_and_rms: vradarrblue('+strtrim(string(i),2)+','+strtrim(string(j),2)+') = <'+strtrim(string(vradarrblue(i,j)),2)+'>'
        endfor
    endelse
endfor
free_lun,lun

; --- calculate mean and rms
meanarrred = dblarr(maxcred)
rmsarrred  = dblarr(maxcred)
for i=0,maxcred-1 do begin
    meanarrred(i) = mean(vradarrred(*,i))
    rmsarrred(i) = stddev(vradarrred(*,i))
;  print,'fxcor_RXJ_plot_mean_and_rms: mean('+strtrim(string(i),2)+') = '+strtrim(string(meanarr(i)),2)+', rms('+strtrim(string(i),2)+') = '+strtrim(string(rmsarr(i)),2)
endfor

meanarrblue = dblarr(maxcblue)
rmsarrblue  = dblarr(maxcblue)
for i=0,maxcblue-1 do begin
    meanarrblue(i) = mean(vradarrblue(*,i))
    rmsarrblue(i) = stddev(vradarrblue(*,i))
;  print,'fxcor_RXJ_plot_mean_and_rms: mean('+strtrim(string(i),2)+') = '+strtrim(string(meanarr(i)),2)+', rms('+strtrim(string(i),2)+') = '+strtrim(string(rmsarr(i)),2)
endfor

; --- serach for min and max values
ymin = 0.
ymax = 0.
for i=0,maxcred-1 do begin
    if meanarrred(i)+rmsarrred(i) gt ymax then ymax = meanarrred(i)+rmsarrred(i)
    if meanarrred(i)-rmsarrred(i) lt ymin then ymin = meanarrred(i)-rmsarrred(i)
endfor
for i=0,maxcblue-1 do begin
    if meanarrblue(i)+rmsarrblue(i) gt ymax then ymax = meanarrblue(i)+rmsarrblue(i)
    if meanarrblue(i)-rmsarrblue(i) lt ymin then ymin = meanarrblue(i)-rmsarrblue(i)
endfor
xmin = 0.
xmax = 0.
xmin = min([min(hjdarrblue),min(hjdarrred)])
xmax = max([max(hjdarrblue),max(hjdarrred)])
xmin = xmin - ((xmax-xmin)/20.)
xmax = xmax + ((xmax-xmin)/20.)

; --- plot mean and rms
print,'fxcor_RXJ_plot_mean_and_rms: n_elements(color)=<',n_elements(color),'>'
if n_elements(print) gt 0 then begin
    set_plot,'ps'
    psoutfile = strmid(listred,0,strpos(listred,'.',/REVERSE_SEARCH))+'+'+strmid(listblue,strpos(listblue,'/',/REVERSE_SEARCH)+1,strpos(listblue,'.',/REVERSE_SEARCH)-strpos(listblue,'/',/REVERSE_SEARCH)-1)+'_mean_and_rms.eps'
    print,'psoutfile = <'+psoutfile+'>'
    print,'fxcor_RXJ_plot_mean_and_rms: color = <'+color+'>, print = <'+print+'>'
    if n_elements(color) gt 1 then $
        device, filename=psoutfile,bits_per_pixel=4,xsize=19.8,ysize=14.8,/color,encaps=1 $
    else $
        device, filename=psoutfile,bits_per_pixel=4,xsize=19.8,ysize=14.8,encaps=1
endif

xtitle='heliocentric julian date (hjd) [days]'
if strpos(listred,'vrel') ge 0 then begin
    ytitle='relative radial velocity [km/s]'
end else if strpos(listred,'vobs') ge 0 then begin
    ytitle='observed radial velocity [km/s]'
end else begin
    ytitle='heliocentric radial velocity [km/s]'
end
title='MN Lup (reference: HD 209290)'

loadct,0                        ;,file='~/daten/idl/anima/colors1.tbl'

; Make a vector of 16 points, A[i] = 2pi/16:
A = FINDGEN(17) * (!PI*2/16.)
; Define the symbol to be a unit circle with 16 points, 
; and set the filled flag:
USERSYM, COS(A), SIN(A),/FILL

plot,hjdarrred,meanarrred,xtitle=xtitle,ytitle=ytitle,xstyle=1,xrange=[xmin,xmax],ystyle=1,$
  yrange=[min(meanarrred)-max(rmsarrred),max(meanarrred)+max(rmsarrred)],psym=8,color=0,$
  position=[0.075,0.085,0.99,0.95],title=title ;,charsize=1.2,charthick=2,xthick=2,ythick=2,$
  thick=2

if n_elements(color) gt 1 then begin
    print,'fxcor_RXJ_plot_mean_and_rms: n_elements(color)=<',n_elements(color),'> gt 1'
    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = red(255-i)
    endfor
    for i=0,255 do begin
        red(i) = green(i)
        green(i) = 0
    endfor
    
    modifyct,0,'red-blue',red,green,blue,file='colors1.tbl'
    loadct,0,file='colors1.tbl',ncolors=10

    oplot,hjdarrred,meanarrred,psym=8,color=1 ;,thick=2
endif else begin
    oplot,hjdarrred,meanarrred,psym=8;,color=1 ;,thick=2
endelse
oploterr,hjdarrred,meanarrred,rmsarrred

USERSYM, COS(A), SIN(A)

if n_elements(color) gt 1 then begin
    oplot,hjdarrblue,meanarrblue,psym=8,color=9 ;,thick=2
    for i=0,255 do begin
        green(i) = red(i)
    endfor
    for i=0,255 do begin
        red(i) = blue(i)
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='colors1.tbl'
    loadct,0,file='colors1.tbl',ncolors=3
endif else begin
    oplot,hjdarrblue,meanarrblue,psym=8;,color=9 ;,thick=2
endelse
;oploterr,hjdarrblue,meanarrblue,rmsarrblue
if n_elements(print) gt 0 then begin
    device,/close
    set_plot,'x'
endif

meanoutfile = strmid(listred,0,strpos(listred,'.',/REVERSE_SEARCH))+'+blue_mean_rms.data'
print,'fxcor_RXJ_plot_mean_and_rms: meanoutfile = '+meanoutfile
openw,lun,meanoutfile,/get_lun
printf,lun,'red : 1st night: mean(meanarr[0:'+strtrim(string(nredfirstnight-1),2)+']) = '+strtrim(string(mean(meanarrred[0:nredfirstnight-1])),2)+', stddev(meanarr[0:'+strtrim(string(nredfirstnight-1),2)+']) = '+strtrim(string(stddev(meanarrred[0:nredfirstnight-1])),2)
printf,lun,'red : 2nd night: mean(meanarr['+strtrim(string(nredfirstnight),2)+':'+strtrim(string(maxcred-1),2)+']) = '+strtrim(string(mean(meanarrred[nredfirstnight:maxcred-1])),2)+', stddev(meanarr['+strtrim(string(nredfirstnight),2)+':'+strtrim(string(maxcred-1),2)+']) = '+strtrim(string(stddev(meanarrred[nredfirstnight:maxcred-1])),2)
printf,lun,'red : both nights: mean(meanarr) = '+strtrim(string(mean(meanarrred)),2)+', stddev(meanarr) = '+strtrim(string(stddev(meanarrred)),2)
printf,lun,'blue: 1st night: mean(meanarr[0,'+strtrim(string(nbluefirstnight-1),2)+']) = '+strtrim(string(mean(meanarrblue[0:nbluefirstnight-1])),2)+', stddev(meanarr[0,'+strtrim(string(nbluefirstnight-1),2)+']) = '+strtrim(string(stddev(meanarrblue[0:nbluefirstnight-1])),2)
printf,lun,'blue: 2nd night: mean(meanarr['+strtrim(string(nbluefirstnight),2)+':'+strtrim(string(maxcblue-1),2)+']) = '+strtrim(string(mean(meanarrblue[nbluefirstnight:maxcblue-1])),2)+', stddev(meanarr['+strtrim(string(nbluefirstnight),2)+':'+strtrim(string(maxcblue-1),2)+']) = '+strtrim(string(stddev(meanarrblue[nbluefirstnight:maxcblue-1])),2)
printf,lun,'blue: both nights: mean(meanarr) = '+strtrim(string(mean(meanarrblue)),2)+', stddev(meanarr) = '+strtrim(string(stddev(meanarrblue)),2)
free_lun,lun
print,'fxcor_RXJ_plot_mean_and_rms: mean(meanarrred) = '+strtrim(string(mean(meanarrred)),2)
print,'fxcor_RXJ_plot_mean_and_rms: rms(meanarrred) = '+strtrim(string(stddev(meanarrred)),2)
print,'fxcor_RXJ_plot_mean_and_rms: mean(meanarrblue) = '+strtrim(string(mean(meanarrblue)),2)
print,'fxcor_RXJ_plot_mean_and_rms: rms(meanarrblue) = '+strtrim(string(stddev(meanarrblue)),2)

end
