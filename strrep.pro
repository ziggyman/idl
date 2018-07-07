;###########################
function strrep,s,sso,ssn
;###########################

c=0L
if n_params() ne 3 then print,'STRREP: Not enough string parameters specified, return 0.' $
else begin
  result = ''
  i = 0
  j = 1
  while (j eq 1) do begin
    if i le strlen(s)-1 then begin
      if strmid(s,i,strlen(sso)) eq sso then begin
        result = result + ssn
        i = i + strlen(sso)
      endif else begin
        result = result + strmid(s,i,1)
        i = i + 1
      endelse
    endif else begin
      j = 0
    end
  end
end
return,result
end
