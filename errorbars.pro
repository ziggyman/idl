pro errorbars,print=print

if n_elements(print) ne 0 then begin
  set_plot,'ps'
  device,filename='~/ps/jbo00zhr.ps'
end

close,1
nmax=9
!p.charsize=2
!p.charthick=1.3
!p.thick=3.0
!x.thick=3.0
!y.thick=3.0

sol=[94.947,95.582,95.681,95.921,96.510,96.585,96.855,97.514,98.436,102.289]
v=[1.04,0.54,1.78,2.26,1.78,0.29,1.62,0.47,1.04,0.91]
e=[0.74,0.38,0.73,1.30,0.56,0.20,0.57,0.23,0.74,0.64]
plot,sol(0:nmax),v(0:nmax),psym=3,xrange=[94,103],/xstyle, $
   yrange=[0,5],/ystyle, $
   xtitle='!17Solar longitude (2000)!3',ytitle='!17ZHR!3'
oploterr,sol(0:nmax),v(0:nmax),e(0:nmax)
oplot,[95.951],[3.85],psym=2
oplot,[95.951,95.951],[3.85-1.22,3.85+1.22],linestyle=1,psym=0

if n_elements(print) ne 0 then begin
  device,/close
  set_plot,'x'
end
!p.charsize=1.0
!p.charthick=1.0
!p.thick=1.0
!x.thick=1.0
!y.thick=1.0

end

