pro lbr2xyz,l,b,r,x,y,z,DEG=Deg
if keyword_set(Deg) then begin
x=r*cos(b*!DTOR*1.0d0)*cos(l*!DTOR*1.0d0)
y=r*cos(b*!DTOR*1.0d0)*sin(l*!DTOR*1.0d0)
z=r*sin(b*!DTOR*1.0d0)
endif else begin
x=r*cos(b*1.0d0)*cos(l*1.0d0)
y=r*cos(b*1.0d0)*sin(l*1.0d0)
z=r*sin(b*1.0d0)
endelse
end
