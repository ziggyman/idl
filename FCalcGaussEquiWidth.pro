;############################
Function FCalcGaussEquiWidth,x,y,ncoeffs
;############################
;
; NAME:                  FCalcGaussEquiWidth
; PURPOSE:               * calculates the equivalent width of a gaussian fit to y(x),
;                        * gaussfit = A0 * exp(-(z^2)/2.) + A3 + A4*x
;                            with z = (x-A1)/A2
;
; CATEGORY:              elemental abundance analysis
; CALLING SEQUENCE:      ewidth = FCalcGaussEquiWidth(x-array,y-array)
; INPUTS:                input array: x-array:
;                         1110.0
;                         1110.1
;                         1110.2
;                         ...
;
;                        input array: y-array:
;                         140.1
;                         140.1
;                         142.2
;                         ...
; OUTPUTS:               ewidth = equivalent width auf gaussfit
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           20/11/2007
;
  ON_ERROR,2
  if n_elements(ncoeffs) eq 0 then begin
    print,'FCalcGaussEquiWidth: Not enough arguments specified, return 0.'
    print," USAGE: ewidth = FCalcGaussEquiWidth(xarray, yarray, ncoeffs)"
  end else begin
    nx = n_elements(x)
    print,'FCalcGaussEquiWidth: nx = ',nx
;    xcenter = (x(nx-1) - x(0)) / nx
    fit = GAUSSFIT(x,y,D_A1_Coeffs,NTERMS=ncoeffs)

; --- calculate equivalent width
    print,'FCalcGaussEquiWidth: fit = ',fit
    D_EquiWidth = 0.
    if ncoeffs eq 5 then begin
      ycont = D_A1_Coeffs(3) + (D_A1_Coeffs(4) * x)
    end else if ncoeffs eq 4 then begin
      ycont = y
      ycont(*) = D_A1_Coeffs(3)
;      fit = fit / ycont
;      print,'x = ',x
;      for i=1, nx - 1 do begin
;        print,'x = ',x
;        dx = (x(i) - x(i-1))
;        dy = fit(i-1) - fit(i)
;        D_EquiWidth = D_EquiWidth + (dx * (1. - fit(i-1) - (dy / 2.)))
;        if i eq nx-1 then begin
;          print,'FCalcGaussEquiWidth: D_EquiWidth = ',D_EquiWidth
;        endif
;      endfor
    end else if ncoeffs eq 3 then begin
      ycont = 1.
;      fit = fit / ycont
;      for i=1, nx - 1 do begin
;        dx = (x(i) - x(i-1))
;        dy = fit(i-1) - fit(i)
;        D_EquiWidth = D_EquiWidth + (dx * (1. - fit(i-1) - (dy / 2.)))
;        if i eq nx-1 then begin
;          print,'FCalcGaussEquiWidth: D_EquiWidth = ',D_EquiWidth
;        endif
;      endfor
    end
    fit = fit / ycont
    D_EquiWidth = 0.
    for i=1, nx - 1 do begin
      dx = (x(i) - x(i-1))
      dy = fit(i-1) - fit(i)
      D_EquiWidth = D_EquiWidth + (dx * (1. - fit(i-1) - (dy / 2.)))
      if i eq nx-1 then begin
        print,'FCalcGaussEquiWidth: D_EquiWidth = ',D_EquiWidth
      endif
    endfor
    ymax = max([y,ycont,fit],MIN=ymin)
    plot,x,y/ycont,yrange=[0.,1.2]
;    oplot,x,ycont
    oplot,x,fit
    print,'FCalcGaussEquiWidth: plot ready'
    print,'FCalcGaussEquiWidth: returning D_EquiWidth = ',D_EquiWidth
    return, D_EquiWidth
  endelse
end
