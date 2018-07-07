function one_gs,x,y,a,da
;
; function to fit one Gaussian with zero point (baseline)
; usage: yfit=two_gs(x,y,a,da)
; input: x,y,a
; output: yfit,da
; da(4) are diff.corr.'s to parameters a(4) as follows:
;   a(0) - central strength
;   a(1) - central position
;   a(2) - width
;   a(3) - zero point

; a(0) and a(3) - central strengths
; a(1) and a(4) - central positions
; a(2) and a(5) - widths
; a(6) is zero point
;

  n = n_elements(x)
  c = x & e1=x
  c = ((x-a(1))/a(2))^2
  e1(*)=0.
  d = where(c le 30.)
  e1(d) = exp(-c(d))
  res = y - a(0)*e1 - a(3)
  print,'Sum res^2 = ',total(res^2)
;

  t = fltarr(n,4)         ; derivatives
  t(*,0) = e1
  t(*,1) = 2*e1*a(0)*(x-a(1))/a(2)^2
  t(*,2) = t(*,1)*(x-a(1))/a(2)
  t(*,3) = 1.
;
  tt = transpose(t)#t     ; solution
  tr = transpose(t)#res
  svd,tt,w,u,v
  wp = fltarr(4,4)
  mw = max(w)
  for i=0,3 do if w(i) ge mw*1.e-6 then wp(i,i)=1./w(i)
  da = v#wp#(transpose(u)#tr)
  a1 = a + da
;
  c = x & e1=x            ; new Gaussian
  e1(*)=0.
  c = ((x-a1(1))/a1(2))^2
  d = where(c le 30.)
  e1(d) = exp(-c(d))
  res = y - a1(0)*e1 - a1(3)
  print,'Sum new res^2 = ',total(res^2)
return,a1(0)*e1+a1(3)
end
; end of one_gs.pro
