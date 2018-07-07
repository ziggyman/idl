pro xyz2lbr,x,y,z,l,b,r,DEG=Deg
  rc=radius3(x,y,0.0)*1.0d0
  l=atan(y*1.0d0,x)
  ind=where(l lt 0,count)
  if count gt 0 then l[ind]=2*!PI+l[ind]
  b=atan(z/rc)
  r=radius3(x,y,z)
  if keyword_set(Deg) then begin
    l=l*!RADEG
    b=b*!RADEG
  endif
    indarr = where(strtrim(string(b),2) eq 'NaN',count)
    if count gt 0 then begin
      if count lt 10 then begin
        print,'sanjib_to_textfile: indarr = ',indarr,': x(indarr) = ',x(indarr),', y(indarr) = ',y(indarr),', z(indarr) = ',z(indarr),', l(indarr) = ',l(indarr),', b(indarr) = ',b(indarr)
      end else begin
        print,'size(indarr) = ',size(indarr)
        print,'sanjib_to_textfile: indarr = ',indarr(0:9),': x(indarr) = ',x(indarr(0:9)),', y(indarr) = ',y(indarr(0:9)),', z(indarr) = ',z(indarr(0:9)),', l(indarr) = ',l(indarr(0:9)),', b(indarr) = ',b(indarr(0:9))
      end
    endif
end
