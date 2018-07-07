;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################################
pro do_htmldoc_stella_testresults
;############################################

; --- create html documentation for the ses test results
    do_htmldoc_sestest_problems
;    do_htmldoc_sestest_results

; --- blue


end