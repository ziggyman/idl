;+
; PURPOSE:
;  Calculates the weighted mean of a set of measurements.
;
; CATEGORY:
;  Statistics
;
; CALLING SEQUENCE:
;  result = wmean(val, dval, [/nan, error = error])
;
; INPUTS:
;  val : A vector of data values
;  dval: The error on each data value
;
; KEYWORD PARAMETERS:
;  nan: If set, treat NANs as missing data
;  error: Set to a named variable to hold the error on the weighted
;         mean
;
; OUTPUTS:
;  The weighted mean
;
; MODIFICATION HISTORY
;  April 2009 Written by Chris Beaumont
;  April 23 2009 fixed integer truncation bug
;-
function wmean, val, dval, nan = nan, error = error, sqr_err=sqr_err
compile_opt idl2
on_error, 2

;- check inputs
if n_params() ne 2 then begin
   print, 'wmean calling sequence:'
   print,' result = wmean(val, dval, [/nan, error = error])'
   return, !values.f_nan
endif
sz = n_elements(val)
if n_elements(dval) ne sz then $
   message, 'val and dval must contain the same number of elements'


;- the calculation
;- require at least one finite value
if keyword_set(nan) then begin
   hit = where(finite(val) and finite(dval), ct)
   if ct eq 0 then begin
      error = !values.f_nan
      return, !values.f_nan
   endif
endif

if keyword_set(sqr_err) then begin
  dw = total(1. / dval^2., nan = keyword_set(nan))
  sum = total(1. * val / dval^2., nan = keyword_set(nan)) / dw
end else begin
  dw = total(1. / dval, nan = keyword_set(nan))
  sum = total(1. * val / dval, nan = keyword_set(nan)) / dw
endelse
error = sqrt(1. / dw)

return, sum

end
