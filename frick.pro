pro frick,print=print

!p.charsize=1.3

if n_elements(print) ne 0 then begin
  set_plot,'ps'
  device,filename='~/daten/ps/frick.ps'
end

T=[0.3,0.4, 0.5, 0.7, 1.0,2.0,3.0,4.0,5.0,7.0,8.0,9.0,10, 10.5, $
   11, 12,13,17,18,19,20,30,40,50,60,80,100,110,133]
f=[0.2,0.23,0.28,0.33,0.4,0.7,1.1,1.7,3.5,9.0,30, 80, 123,130, $
   101,50,15,8.3,9.0, 10,11,25,23,30,33,50,165,200,115]

x=findgen(10000)/10000*(133.-0.3)+0.3
y=spline(T,f,x,10.0)

;print,y

plot_oo,x,y,xtitle='!17T (YEARS)!3',yrange=[0.1,1000],thick=2.0, $
  xrange=[0.3,200],/xstyle

;plot_oo,T,f,xtitle='!17T (YEARS)!3'


if n_elements(print) ne 0 then begin
  device,/close
  set_plot,'x'
end

!p.charsize=1.0

end
