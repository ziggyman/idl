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
pro standarddev,list,column
;############################

if n_elements(list) eq 0 then print,'average: No file specified, return 0.' $
else begin   

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' DATA LINES'  

;build arrays
  myarray = dblarr(maxn)
;  column = 3
  iq = 0.
  jq = 0.
  kq = 0.
  lq = 0.
;  mq = ''
  av = 0.
  sd = 0.

;read file in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin  
    readf,1,iq,jq,kq,lq
;,mq
;    print,i,lambdaq,intensq,whoknowsq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7, " whoknowsq = ", F15.7 )'
    print,iq,jq,kq,lq
;    if i gt 0 then begin
      if column eq 1 then begin
        myarray(i) = double(iq)
      endif else if column eq 2 then begin
        myarray(i) = double(jq)
      end else if column eq 3 then begin
        myarray(i) = double(kq)
      end else if column eq 4 then begin
        myarray(i) = double(lq)
;    end else if column eq 5 then begin
;      myarray(i) = mq
      end
;    end
  end  
  close,1  

;average
;  for i=0,maxn-1 do begin
;    av = av + myarray(i)
;  endfor
  av = mean(myarray)
  print,'mean of column ',column,' = ',av
  av = 0.
  for i=0,maxn-1 do begin
    av = av + myarray(i)
  endfor
  av = av / (maxn)
  print,'average of column ',column,' = ',av

;stddev
  sd = stddev(myarray)
  print,'stddev of column ',column,' = ',sd

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
