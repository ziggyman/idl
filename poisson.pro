pro poisson,x1,x2,nx,mu,fac,outfile

  if n_elements(outfile) eq 0 then begin
    print,'poisson: USAGE: poisson,x1:Double,x2:Double,nx:Integer,mu:Double,fac:Double,outfile:String'
  endif else begin
    xarr = dblarr(nx)
    yarr = dblarr(nx)

    dumx = 0.

    openw,lun,outfile,/GET_LUN
    for i=0UL, nx-1 do begin
      xarr[i] = dumx
      yarr[i] = ((mu ^ xarr[i]) / factorial(xarr[i])) * exp(0.-mu) * fac
      printf,lun,xarr[i],yarr[i],FORMAT = '(F15.7," ",F15.7)'
      dumx = dumx + ((x2-x1) / nx)
    endfor
    free_lun,lun
  endelse
end
