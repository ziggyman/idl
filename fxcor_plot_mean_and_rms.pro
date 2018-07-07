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
pro fxcor_plot_mean_and_rms,inlist,meanoutfile,print
;############################
common maxn,maxc
;############################
;
; NAME:                  fxcor_plot_mean_and_rms.pro
; PURPOSE:               calculates and plots the mean and rms for the radial
;                        velocities in 'inlist' over hjd
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fxcor_plot_mean_and_rms,'../../UVES/ready/fxcor_refHD209290_minus_fxcor_dats_red_vhelio.data','print'
; INPUTS:                input file: inlist: '../../UVES/ready/fxcor_refHD209290_minus_fxcor_dats_red_vhelio.data'
;                                    1692.234 1692.263 ... (hjds)
;                                    2.2534 5.2352 ... (vhelios)
;                                    2.5343 5.2525 ... (vhelios)
;                                    ...
; OUTPUTS:               inlist+'.eps',meanoutfile
; COPYRIGHT:             Andreas Ritter
; DATE:                  27.08.2004
;
;                        headline
;                        feetline (up to now not used) 
;

if n_elements(meanoutfile) lt 1 then begin
  print,'fxcor_plot_mean_and_rms: ERROR: not enough parameters specified!'
  print,"fxcor_plot_mean_and_rms: USAGE: fxcor_plot_mean_and_rms,'inlist','meanoutfile','print'"
  inlist = '../../UVES/ready/fxcor_dats_red_minus_refHD209290_vhelio.data' 
  meanoutfile = '../../UVES/ready/fxcor_dats_red_minus_refHD209290_vhelio_mean.data'
endif

maxn = countlines(inlist)
maxc = countcols(inlist)
print,'fxcor_plot_mean_and_rms: inlist "'+inlist+'" contains '+strtrim(string(maxn),2)+' rows and '+strtrim(string(maxc),2)+' columns'

hjdarr = dblarr(maxc)
vradarr = dblarr(maxn,maxc)

line = ''

openr,lun,inlist,/get_lun
for i=0,maxn-1 do begin
  readf,lun,line
  line = strtrim(line,2)
  if i eq 0 then begin
    for j=0,maxc-1 do begin
      if strpos(line,' ') lt 0 then begin
        hjdarr(j) = line
      endif else begin
        hjdarr(j) = strmid(line,0,strpos(line,' '))
        line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
      endelse 
      print,'fxcor_plot_mean_and_rms: hjdarr('+strtrim(string(j),2)+') = <'+strtrim(string(hjdarr(j)),2)+'>'
    endfor 
  endif else begin
    for j=0,maxc-1 do begin
      if strpos(line,' ') lt 0 then begin
        vradarr(i,j) = line
      endif else begin
        vradarr(i,j) = strmid(line,0,strpos(line,' '))
        line = strtrim(strmid(line,strpos(line,' ')+1,strlen(line)-strpos(line,' ')-1),2)
      endelse
;      print,'fxcor_plot_mean_and_rms: vradarr('+strtrim(string(i),2)+','+strtrim(string(j),2)+') = <'+strtrim(string(vradarr(i,j)),2)+'>'
    endfor
  endelse
endfor
free_lun,lun

; --- calculate mean and rms
meanarr = dblarr(maxc)
rmsarr  = dblarr(maxc)
for i=0,maxc-1 do begin
  meanarr(i) = mean(vradarr(*,i))
  rmsarr(i) = stddev(vradarr(*,i))
;  print,'fxcor_plot_mean_and_rms: mean('+strtrim(string(i),2)+') = '+strtrim(string(meanarr(i)),2)+', rms('+strtrim(string(i),2)+') = '+strtrim(string(rmsarr(i)),2)
endfor

; --- plot mean and rms
if n_elements(print) gt 0 then begin
  set_plot,'ps'
  psoutfile = strmid(inlist,0,strpos(inlist,'.',/REVERSE_SEARCH))+'.eps'
  print,'psoutfile = <'+psoutfile+'>'
  device, filename=psoutfile,bits_per_pixel=4,xsize=16.8,ysize=16.8,/color,encaps=1
endif
plot,hjdarr,meanarr,xtitle='hjd [days]',ytitle='radial velocity [km/s]',title='fxcor_plot_mean_and_rms: inlist='+inlist+', meanoutfile='+meanoutfile
oploterr,hjdarr,meanarr,rmsarr
if n_elements(print) gt 0 then begin
  device,/close
  set_plot,'x'
endif

openw,lun,meanoutfile,/get_lun
printf,lun,strtrim(string(mean(meanarr)),2)+' '+strtrim(string(stddev(meanarr)),2)
free_lun,lun
print,'fxcor_plot_mean_and_rms: mean(meanarr) = '+strtrim(string(mean(meanarr)),2)
print,'fxcor_plot_mean_and_rms: rms(meanarr) = '+strtrim(string(stddev(meanarr)),2)

end
