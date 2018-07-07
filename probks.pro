function probks, alam

  ; --- help routine for Kolmogorov-Smirnov Test from Numerical Receipes

  j = 0UL

  EPS1 = 0.001
  EPS2 = 1.0e-8

  a2=0.
  fac=2.
  sum=0.
  term=0.
  termbf=0.

  a2 = (0.-2.) * alam * alam
  for j=1UL,100 do begin
    term = fac * exp(a2*j*j)
    sum = sum + term
    if (abs(term) le EPS1 * termbf) or (abs(term) le (EPS2 * sum)) then $
      return,sum
    fac = 0. - fac
    termbf = abs(term)
  endfor
  return,1.
end
