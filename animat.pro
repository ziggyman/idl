;***********
pro animat
;***********

common test,lauf,ampli,t
test=1
lauf=100
ampli=10.
t=0.
Pi=3.1416
xmax=2*Pi
ymax=150
x=fltarr(629)
y=fltarr(629)
for i=0, 628 do begin
 x(i)=i/100.
endfor
window, 0, xsize=200, ysize=200, title='Flip-Flop'
for m=0,20*Pi do begin
 t=m/10.
 y=(ampli^2)/2+((Cos(x-Pi/2))^2)+2*ampli*Cos(t)*Cos(x-Pi/2)+(ampli^2)/2*Cos(2*t)
 plot,x,y,xstyle=1,xrange=[0,xmax],yrange=[0,ymax],xmargin=4,ymargin=3,background=255,color=0
 s=strcompress(string(lauf),/remove_all)
 write_gif, 'test'+s+'.gif',tvrd()
 lauf=lauf+1
endfor
;endmarke: widget_control, base4,/destroy

;if (m eq 20) then begin
; widget_control, base,/destroy
; exit
;endif

end