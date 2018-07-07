function countlines,s
  c=0L
  if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
  else begin
    if not file_test(s) then begin
      print,'COUNTLINES: No file specified, return 0.'
      return,0l
    endif
    result=strarr(1)
    lines=0
    spawn,'wc -l '+s,result
    c=long(result(0))
  end
  return,c
end
