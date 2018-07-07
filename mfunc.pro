common val,x,y,it
pro mfunc,fn
common val,x,y,it
;+
; NAME:                  func
; PURPOSE:               Plot a set of functions 
; CATEGORY:
; CALLING SEQUENCE:      func,filename
; INPUTS:                input file:
;        
;                        headline
;                        feetline (up to now not used) 
;                        x-axis name
;                        y-axis name
;                        number of columns
;                        x and y(i) as column array
;
; define variables
;
headline=''            ; einige Variablen initialisieren
feetline=''
xaxis=''
yaxis=''
xa=0.0
xe=0.0
ya=0.0
ye=0.0
dum1=' '
dum2=' '
dum3=' '
dum4=' '
ncol=1
ndum=1
;
; read file to determine array sizes
;
openr,1,fn
readf,1,dum1  
readf,1,dum2
readf,1,dum3
readf,1,dum4
readf,1,ncol
print,'number of columns=',ncol
it=0
ydum=fltarr(ncol)
repeat begin
  readf,1,xdum,ydum
  it=it+1
endrep until eof(1) eq 1
close,1
;
; read data
;
x=fltarr(it)
y=fltarr(it,ncol)
openr,1,fn                      ; Datei zum lesen oeffnen
readf,1,headline                ; Ueberschrift einlesen
readf,1,feetline                ; Unterschrift einlesen
readf,1,xaxis                   ; X-Achsenbezeichnung einlesen
readf,1,yaxis                   ; Y-Achsenbezeichnung einlesen
readf,1,ndum
for i=0,it-1 do begin
  readf,1,xdum,ydum
  x(i)=xdum
  y(i,*)=ydum
endfor
;
; plot on screen
;
plot,x,y(*,0),title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
           ytitle='!17'+yaxis,charsize=1.0,linestyle=0
close,1                         ; Datei schliessen
for j=1,ncol-1 do begin
    oplot,x,y(*,j),linestyle=j
endfor
;
; plot to psfile
;
set_plot,'ps'
device,filename='~/ps/mfunc.ps'
; device,/encapsulated,xsize=16,ysize=12
 device,/portrait
plot,x,y(*,0),title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
ytitle='!17'+yaxis,charsize=1.5,linestyle=0
for j=1,ncol-1 do begin
    oplot,x,y(*,j),linestyle=j
endfor
device,/close
set_plot,'x'
end                              
