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

;############################
pro move,inlist,outlist
;############################

if n_elements(outlist) eq 0 then print,'merge: No file specified, return 0.' $
else begin   

;countlines
  maxin = countlines(inlist)
  print,inlist,': ',maxin,' FILES'  
  maxout = countlines(outlist)
  print,outlist,': ',maxout,' FILES'

  if maxin eq maxout then begin

;build arrays
    files = strarr(maxin,2)

;read file in arrays
    close,1
    openr,1,inlist
    for i=0,maxin-1 do begin  
      readf,1,fileq
      files(i,0) = fileq
    end  
    close,1  

    openr,1,oulist
    for i=0,maxin-1 do begin  
      readf,1,fileq
      files(i,1) = fileq
      spawn,'mv '+files(i,0)+' '+files(i,1)
    end  
    close,1  
    
  endif else print,'merge: Number of items in both lists do not agree, return 0.'

endelse
end
