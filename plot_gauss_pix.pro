pro plot_gauss_pix
  xarr = lindgen(10)
  yarr = exp(-((xarr-5.)^2.) / 4.)
  plot,xarr,$
       yarr,$
       xrange=[-0.5, 9.5],$
       xstyle=0
  for i=-0.5d, 10.5 do begin
    oplot,[i,i],[min(yarr),max(yarr)]
  endfor
end
