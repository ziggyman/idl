pro calc_merge_convolution_function,outfile

  if n_elements(outfile) eq 0 then begin
    print,'calc_merge_convolution_function: USAGE: calc_merge_convolution_function,outfile:String'
  endif else begin
    nx = 1000
    xarr = dblarr(nx)
    yarr = dblarr(nx)

    dumx = 0.

    openw,lun,outfile,/GET_LUN
    for i=0UL, nx-1 do begin
      xarr[i] = dumx
      if i lt nx/2 then begin
        yarr[i] = 2. * xarr[i] * xarr[i]
      endif else begin
        yarr[i] = 1. - (2. * (xarr[i] - 1.) * (xarr[i] - 1.))
      endelse
      printf,lun,xarr[i],yarr[i],FORMAT = '(F15.7," ",F15.7)'
      dumx = dumx + (1. / nx)
    endfor
    free_lun,lun
  endelse
end
