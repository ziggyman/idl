function two_gs1,x,y,a,da
;
; function to fit two Gaussians
; usage: yfit=two_gs1(x,y,a,da)
; input: x,y,a
; output: yfit,da
; da are diff.corr.'s to parameters a
; a(0) and a(3) - central strengths
; a(1) and a(4) - central positions
; a(2) and a(5) - widths                 [a(5) kept constant]
; a(6) is zero point
;
; NOTE: this version keeps the width of the 2nd Gaussian fixed 
; but inputs and outputs are the same as for "two_gs"
;
  n = n_elements(x)
  c = x & e1=x & e2=x
  c = ((x-a(1))/a(2))^2
  e1(*)=0. & e2(*)=0.
  d = where(c le 30.)
  e1(d) = exp(-c(d))
  c = ((x-a(4))/a(5))^2
  d = where(c le 30.)
  e2(d) = exp(-c(d))
  res = y - a(0)*e1 - a(3)*e2-a(6)
  print,'Sum res^2 = ',total(res^2)
;
  t = fltarr(n,6)
  t(*,0) = e1
  t(*,3) = e2
  t(*,1) = 2*e1*a(0)*(x-a(1))/a(2)^2
  t(*,4) = 2*e2*a(3)*(x-a(4))/a(5)^2
  t(*,2) = t(*,1)*(x-a(1))/a(2)   ; to solve for width of 1st Gaussian
  t(*,5) = 1.
;
  tt = transpose(t)#t
  tr = transpose(t)#res
  svd,tt,w,u,v
  wp = fltarr(6,6)
  mw = max(w)
  for i=0,5 do if w(i) ge mw*1.e-6 then wp(i,i)=1./w(i)
  dda = v#wp#(transpose(u)#tr)
  da = [dda(0:4),0.,dda(5)]   ; width of 2nd Gaussian unchanged
  a1 = a + da
;
  c = x & e1=x & e2=x
  e1(*)=0. & e2(*)=0.
  c = ((x-a1(1))/a1(2))^2
  d = where(c le 30.)
  e1(d) = exp(-c(d))
  c = ((x-a1(4))/a1(5))^2
  d = where(c le 30.)
  e2(d) = exp(-c(d))
  res = y - a1(0)*e1 - a1(3)*e2-a1(6)
  print,'Sum new res^2 = ',total(res^2)
return,a1(0)*e1+a1(3)*e2+a1(6)
end

; end of two_gs1.pro
