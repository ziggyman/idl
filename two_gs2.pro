function two_gs2,x,y,a,da
;
; function to fit two Gaussians
; usage: yfit=two_gs2(x,y,a,da)
; input: x,y,a (values of x,y for function and 7 parameters a)
; output: yfit,da (fit and corrections to a)
; a(0) and a(3) - central strengths
; a(1) and a(4) - central positions
; a(2) and a(5) - widths       [both kept constant]
; a(6) is zero point
;
; NOTE: this version keeps widths of both Gaussians fixed 
;    as full solutions normally unstable

  n = n_elements(x)
  c = x & e1=x & e2=x
  e1(*)=0. & e2(*)=0.
  c = ((x-a(1))/a(2))^2
  d = where(c le 30.)
  e1(d) = exp(-c(d))
  c = ((x-a(4))/a(5))^2
  d = where(c le 30.)
  e2(d) = exp(-c(d))
  res = y - a(0)*e1 - a(3)*e2-a(6)
  print,'Sum res^2 = ',total(res^2)
;
  t = fltarr(n,5)  ; widths not determined
  t(*,0) = e1
  t(*,2) = e2
  t(*,1) = 2*e1*a(0)*(x-a(1))/a(2)^2
  t(*,3) = 2*e2*a(3)*(x-a(4))/a(5)^2
  t(*,4) = 1.
;
  tt = transpose(t)#t   ; solution
  tr = transpose(t)#res
  svd,tt,w,u,v
  wp = fltarr(5,5) 
  mw = max(w)
  for i=0,4 do if w(i) ge mw*1.e-6 then wp(i,i)=1./w(i)
  dda = v#wp#(transpose(u)#tr)          ; corrections computed
  da = [dda(0:1),0.,dda(2:3),0.,dda(4)] ; no changes to widths
  a1 = a + da
;
  c = x & e1=x & e2=x  ; initialize
  e1(*)=0. & e2(*)=0.
  c = ((x-a1(1))/a1(2))^2
  d = where(c le 30.)
  e1(d) = exp(-c(d))   ; first Gaussian
  c = ((x-a1(4))/a1(5))^2
  d = where(c le 30.)
  e2(d) = exp(-c(d))   ; second Gaussian
  res = y - a1(0)*e1 - a1(3)*e2-a1(6)  ; residuals
  print,'Sum new res^2 = ',total(res^2)
return,a1(0)*e1+a1(3)*e2+a1(6)
end
; end of two_gs2.pro and whole package
;---------------------------------------------------------------------
