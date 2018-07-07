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
pro average,list,column
;############################

if n_elements(list) eq 0 then print,'average: No file specified, return 0.' $
else begin   

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' DATA LINES'  

;build arrays
  myarray = dblarr(maxn)

;read file in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin  
    readf,1,iq,jq,kq
;    print,i,lambdaq,intensq,whoknowsq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7, " whoknowsq = ", F15.7 )'
    if column eq 1 then begin
      myarray(i) = iq
    endif else if column eq 2 then begin
      myarray(i) = jq
    end else if column eq 3 then begin
      myarray(i) = kq
;    end else if column eq 4 then begin
;      myarray(i) = lq
    end

  end  
  close,1  

;average
  k = 0.
  for i=0,maxn-1 do begin
    k = k + myarray(i)
  endfor
  k = k / maxn
  print,'average of column ',column,' = ',k

;write file
;  newlist = strmid(list,0,strpos(list,'.',0)-1)+'_'+dlambdanewstr+'.dat'
;  print,'output filename:',newlist
;  close,2
;  openw,2,newlist
;   for i=0,maxi-1 do begin
;     printf,2,lambdanew(i),intensnew(i)
;   endfor
;  close,2

endelse
end
