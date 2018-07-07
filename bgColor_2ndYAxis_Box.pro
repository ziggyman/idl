common maxn,bahnradius,masse,drehimpuls,dum  

pro bgColor_2ndYAxis_Box,fname,print  
common maxn,bahnradius,masse,drehimpuls,dum
  
;+
; NAME:                  bgColor_2ndYAxis_Box.pro
; PURPOSE:               farbigerHintergrund UND zweite yaxis rechts UND box
; CATEGORY:              styles
; CALLING SEQUENCE:      progr,filename,print
; INPUTS:                input file: planeten.dat (planetes_r_m_v_L_r_neu.dat)
;        
;                        headline
;                        feetline (up to now not used) 
;Bahnradius              x-axis name
;Masse / Drehimpuls      y-axis name
;                        x and y(i) as two column array
;

maxn=countlines(fname)  
print,maxn,' DATA-LINES'  
  
loadct,13
!p.thick=5.0
!x.thick=3.0
!y.thick=3.0
!p.charthick=3.0
bahnradiusq=0.0d0
masseq=0.0d0
drehimpulsq=0.0d0
;radius=fltarr(maxn)  
bahnradius=dblarr(maxn)
masse=dblarr(maxn)  
drehimpuls=dblarr(maxn)
  
if n_elements(print) ne 0 then begin  
  set_plot,'ps'  
  device,filename='planeten.ps',/color  
end    
close,1  
openr,1,fname  
for i=0,maxn-1 do begin  
  readf,1,bahnradiusq,masseq,dum1,drehimpulsq,dum2  
  bahnradius(i)=bahnradiusq 
  print,'bahnradius = ',bahnradius(i) 
  masse(i)=masseq
  print,'masse = ',masse(i) 
  drehimpuls(i)=drehimpulsq*(1e-18)
  print,'drehimpuls = ',drehimpuls(i) 
  
end  
close,1  
xmin=6.0e+10
xmax=6e+14
ymin=1e+25
ymax=1e+34
title='MASSE- U. DREHIMPULSVERTEILUNG IM SONNENSYSTEM'
plot_oo,[0],[0],xrange=[xmin,xmax],yrange=[ymin,ymax],position=[0.215,0.16,0.8,0.9]
;oplot,bahnradius,masse
box,10e+7,10e+16,10e+23,10e+36,150
plot_oo,bahnradius,masse,xrange=[xmin,xmax],yrange=[ymin,ymax],$
	xtitle='BAHNRADIUS [cm]',ytitle='MASSE [g]',psym=1,symsize=0.01,$
	position=[0.215,0.16,0.8,0.9],charsize=1.8,/noerase
oplot,bahnradius,masse,color=25
xyouts, 0.12e+9, 4e+34, title, alignment=0.0, charsize=1.8
box, 2e+11, 1.05e+32, 3e+11, 1.89e+32, 168
box, 2e+11, 0.4e+32, 3e+11, 0.74e+32, 60
xyouts,4e+11,1.05e+32,'MASSE',alignment=0.0,charsize=1.8
xyouts,4e+11,0.3e+32,'DREHIMPULS',alignment=0.0,charsize=1.8
xyouts,2e+16,1e+29,'DREHIMPULS [g cm!A2!N s!A-1!N]',alignment=0.5,$
	orientation=90,charsize=1.8
for i=0, 9 do box, bahnradius(i) - (1.5*bahnradius(i)/10), 1e+24,$
	bahnradius(i) + (2*bahnradius(i)/10), drehimpuls(i), 60
for i=0, 9 do box, bahnradius(i) - (0.7*bahnradius(i)/10), 1e+24, $
	bahnradius(i) + (bahnradius(i)/10), masse(i), 168
j=1e+24
xyouts,1.1e+15,j-1.1e+23,'!510!A42!N',alignment=0.0,charsize=1.8
j=j*100
xyouts,1.1e+15,j-3e+25,'!510!A44!N',alignment=0.0,charsize=1.8
j=j*100
xyouts,1.1e+15,j-3e+27,'!510!A46!N',alignment=0.0,charsize=1.8
j=j*100
xyouts,1.1e+15,j-3e+29,'!510!A48!N',alignment=0.0,charsize=1.8
j=j*100
xyouts,1.1e+15,j-3e+31,'!510!A50!N',alignment=0.0,charsize=1.8
j=j*100
xyouts,1.1e+15,j-7e+33,'!510!A52!N',alignment=0.0,charsize=1.8

oplot,[1.4e11,4e13,4e13,1.4e11,1.4e11],[1.8e31,1.8e31,5e32,5e32,1.8e31]
;yq=smooth(y,7)  
;-------------------------------------------------- 
;--------Ax=double(min(yq,minimum))  
;--------theta0x=double(theta(minimum))  
;--------cx=double((total(y(0:9))+total(y(maxn-10:maxn-1)))/20)  
;--------cx=0.5760071-0.1109905*nu0x    ;mit sidelobes  
;oplot,nu,yq  
;cx=0.0  
;Ax=0.01  
;nu0x=0.003333  
;deltanux=double(0.5e-3)  
;axis,1e+22,1e+13,zax=0,/DATA
;oplot,bahnradius,drehimpuls,psym=4  
;oplot,bahnradius,drehimpuls,linestyle=2
if n_elements(print) ne 0 then begin  
  device,/close  
  set_plot,'x'  
  spawn,'lp -ddvor planeten.ps'  
end  
!p.thick=1.0
!x.thick=1.0
!y.thick=1.0
!p.charthick=1.0
end

pro box, x0, y0, x1, y1, color

polyfill, [x0, x0, x1, x1], [y0, y1, y1, y0], col=color
end




