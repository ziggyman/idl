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
pro merge,list
;############################

if n_elements(list) eq 0 then print,'merge: No file specified, return 0.' $
else begin   

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' FILES'  

;build arrays
  files = strarr(maxn)

;read file in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin  
    readf,1,fileq
    files(i) = fileq
  end  
  close,1  

;countlines
  maxi = countlines(files(1))
  print,files(1),': ',maxi,' DATA LINES'

;read datas from files in array
  datas = dblarr(maxn,maxi,2)
  for i=0,maxn-1 do begin
    openr,1,'/home/azuri/NTT/'+files(i)
    for j=0,maxi-1 do begin
      readf,1,lambdaq,intensq
      datas(i,j,0) = lambdaq
      datas(i,j,1) = intensq
    endfor
    close,1
  endfor

;merge the orders
  merged = dblarr(maxn*maxi,2)
  dummerge = 0
  dumi = 0
  dumj = 0
  test = 0
  hiti = 0
  hitj = 0
  hitjold = hitj
  while (test eq 0) do begin
    for i=maxi/2,maxi-2 do begin
      for j=0,maxi/2 do begin
        if (datas(dumi,i,0) lt datas(dumi+1,j,0)) and (datas(dumi,i+1,0) gt datas(dumi+1,j+1,0)) then begin
          if (datas(dumi,i,1) lt datas(dumi+1,j,1)) and (datas(dumi,i+1,1) gt datas(dumi+1,j+1,1)) then begin
            hiti = i
            hitj = j
            print,'Treffer! => hiti = ',hiti,'    hitj = ',hitj,'   hitjold = ',hitjold
          endif          
        endif
      endfor
    endfor
    for i=hitjold,hiti do begin
      merged(dummerge+i,0) = datas(dumi,i,0)
      merged(dummerge+i,1) = datas(dumi,i,1)
      print,dummerge+i,merged(dummerge+i,0),merged(dummerge+i,1)
    endfor
    dummerge = dummerge + hiti
    dumi = dumi + 1
    hitjold = hitj
  end
  

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
