 common val,m,r,s,x,y,it
 pro func,fn
 common val,m,r,s,x,y,it
 ;+
 ; NAME:                  func
 ; PURPOSE:               Plot a function 
 ; CATEGORY:
 ; CALLING SEQUENCE:      func,filename
 ; INPUTS:                input file:
 ;        
 ;                        headline
 ;                        feetline (up to now not used) 
 ;                        x-axis name
 ;                        y-axis name
 ;                        x and y(i) as two column array
 ;
 headline=''            ; einige Variablen initialisieren
 feetline=''
 xaxis=''
 yaxis=''
 i=0
 ra=0.0
 re=0.0
 sa=0.0
 se=0.0
 ma=0.0
 me=0.0
 xa=0.0
 xe=0.0
 ya=0.0
 ye=0.0
 dum1=' '
 dum2=' '
 dum3=' '
 dum4=' '
 dum5=' '
 dum6=' '
 ncol=1
 mdum=1
 ndum=1
 close,1
   openr,1,fn
   readf,1,ncol
   readf,1,dum1  
   readf,1,dum2
   readf,1,dum3
   readf,1,dum4
   readf,1,dum5
   readf,1,dum6
   print,'number of columns=',ncol+1
   it=0
   ydum=fltarr(ncol)
   repeat begin
     readf,1,mdum,xdum,ydum
     it=it+1
   endrep until eof(1) eq 1
   close,1
   m=fltarr(it)
   r=fltarr(it)
   s=fltarr(it)
   x=fltarr(it)
   y=fltarr(it,ncol)
   openr,1,fn                      ; Datei zum lesen oeffnen
   readf,1,ndum
   readf,1,headline                ; Ueberschrift einlesen
   readf,1,feetline                ; Unterschrift einlesen
   readf,1,xaxis                   ; X-Achsenbezeichnung einlesen
   readf,1,yaxis                   ; Y-Achsenbezeichnung einlesen
   readf,1,dum5
   readf,1,dum6
   for i=0,it-1 do begin
     readf,1,mdum,xdum,ydum
     m(i)=mdum
     x(i)=xdum
     y(i,*)=ydum
   endfor
   r=x/x(it-1)
   s=y(*,3)*y(*,4)
   plot,r,y(*,0),title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
              ytitle='!17'+yaxis,charsize=1.0
  ; for i=1,ncol-1 do begin
  ;   plot_io,x,y,title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
   ;oplot,r,s
   ;endfor
   close,1                         ; Datei schliessen
 ; set_plot,'ps'
 ; device,filename='~/ps/func.ps'
 ; device,/portrait
 ; plot_io,x,y,title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
 ; plot,x,y,title='!17'+headline, xtitle='!17'+xaxis,xstyle=1,$
 ; ytitle='!17'+yaxis,charsize=1.5
 ; device,/close
 ; set_plot,'x'
   end                              
 


