function GetL  
common fit_funk,maxn,theta,y,h2,h4,h6  
  L=0.0D  
  for i=0,maxn-1 do begin  
     H=h2*(sin(theta(i))^2.)+h4*(sin(theta(i))^4.)+h6*(sin(theta(i))^6) 
     L=L+((y(i)-H)^2) 
    end  
  return,L  
end  
  
pro fit_funk,fname,PRINT=print  
common fit_funk,maxn,theta,y,h2,h4,h6  
maxiter=20000L  
maxn=countlines(fname)  
print,maxn,' DATA-LINES'  
thetaq=0.0  
yq=0.0  
theta=fltarr(maxn)  
y=fltarr(maxn)  
  
if n_elements(print) ne 0 then begin  
  set_plot,'ps'  
  device,filename='fit_funk.ps'  
end    
close,1  
openr,1,fname  
for i=0,maxn-1 do begin  
  readf,1,thetaq,yq  
  theta(i)=thetaq*3.1416/180.  
  y(i)=yq  
end  
close,1  
plot,theta,y,/xstyle,xtitle='X-Title [mHz]',ytitle='Y-Title [xxx]'  
  
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
h2x=-3.467 
h4x=3.701
h6x=-3.578
Gstart=dblarr(maxn)  
;------------for i=0,maxn-1 do Gstart(i)=Ax/(1.0+((nu(i)-nu0x)/deltanux)^2)  
for i=0,maxn-1 do Gstart(i)=h2x*(sin(theta(i))^2)+h4x*(sin(theta(i))^4)*h6x*(sin(theta(i))^6)  
;oplot,theta,Gstart,linestyle=2  
  
;Astep=total(y)/maxn/1000  
;cstep=double(1e-5)  
;nustep=double(1e-4)  
;deltastep=double(1e-4)  
hstep=double(1e-3) 
   
oldLmin=0.0  
j=0L  
repeat begin  
   h2=h2x 
   h4=h4x 
   h6=h6x
    L=GetL()  
   h2=h2x-hstep 
    L1=GetL()  
   h2=h2x+hstep  
    L2=GetL()  
   h2=h2x
   h4=h4x-hstep 
    L3=GetL()  
   h4=h4x+hstep 
    L4=GetL()  
   h4=h4x 
   h6=h6x-hstep
    L5=GetL()  
   h6=h6x+hstep 
    L6=GetL()  
;   h4=h4x 
;    L7=GetL()  
;   h4=h4x-hstep 
;    L8=GetL()  
;---------  deltanu=deltanux  
  Lmin=min([L,L1,L2,L3,L4,L5,L6])  
  if (j mod 50 eq 0) then print,j,Lmin  
  if Lmin eq L1 then h2x=h2x-hstep  
  if Lmin eq L2 then h2x=h2x+hstep  
  if Lmin eq L3 then h4x=h4x-hstep  
  if Lmin eq L4 then h4x=h4x+hstep  
  if Lmin eq L5 then h6x=h6x-hstep 
  if Lmin eq L6 then h6x=h6x+hstep 
  j=j+1L  
  if L eq Lmin then begin  
    hstep=hstep/2.0  
  end  
endrep until (j gt maxiter)  
print,'h2   =',h2x  
print,'h4   =',h4x  
print,'h6   =',h6x  
for i=0,maxn-1 do Gstart(i)=h2x*(sin(theta(i))^2)+h4x*(sin(theta(i))^4)+h6x*(sin(theta(i))^6) 
oplot,theta,Gstart,linestyle=1  
  
if n_elements(print) ne 0 then begin  
  device,/close  
  set_plot,'x'  
  spawn,'lp -dddir fit_funk.ps'  
end  
end
