pro xyz_to_lbr,x,y,z,l,b,r,DEG=deg
    ; --- calculate galactic longitude
;    dblarr_l(i) = acos(scal_prod([1.,0.],[halo.px(i),halo.py(i)])/radius3(halo.px(i),halo.py(i),0.)) * 360. / (2. * !DPI)
    dblarr_null = dblarr(1,n_elements(x))
    l = acos(x/radius3(x,y,dblarr_null))
    indarr = where(y lt 0.,count)
    if count gt 0 then $
      l(indarr) = (2. * !DPI) - l(indarr)
    if keyword_set(DEG) then $
      l = l * !RADEG

    ; --- calculate radius
    r = radius3(x,y,z)

    ; --- calculate galactic latitude
;    dblarr_b(i) = acos(scal_prod([halo.py(i),0.],[halo.py(i),halo.pz(i)])/(radius3(halo.py(i),0.,0.) * radius3(halo.py(i),halo.pz(i),0.))) * 360. / (2. * !DPI)
    b = acos(scal_prod([x,y,z],[x,y,dblarr_null])/(radius3(x,y,z) * radius3(x,y,dblarr_null)))
    indarr = where(z lt 0., count)
    if count gt 0 then $
      b(indarr) = 0. - b(indarr)
    if keyword_set(DEG) then $
      b = b * !RADEG
    indarr = where(strtrim(string(b),2) eq 'NaN',count)
    if count gt 0 then begin
      print,'sanjib_to_textfile: indarr = ',indarr,': x(indarr) = ',x(indarr),', y(indarr) = ',y(indarr),', z(indarr) = ',z(indarr),', l(indarr) = ',l(indarr),', b(indarr) = ',b(indarr)
    endif

end
