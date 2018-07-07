function whichnight,s

c=0
if n_params() ne 1 then print,'WHICHNIGHT: No file specified, return 0.' $
else begin
  if strpos(s,'10-11') ge 0 then begin
    c=1
  end else begin
    c=2
  endelse
endelse
return,c
end
