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
pro removelist,list,listtoremove,newlist
;############################
;this program removes the equal lines of both lists from the first list
;############################

if n_elements(newlist) eq 0 then begin
  print,'removelist: No file specified, return 0.'
  print,'usage     : removelist,longer_list,list_to_remove_from_the_first,newlist'
endif else begin   

;logfile
  close,101
  openw,101,'logfile_removelist'

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' DATA LINES'  
  printf,101,list,': ',maxn,' DATA LINES' 

  maxm = countlines(listtoremove)
  print,listtoremove,': ',maxm,' DATA LINES' 
  printf,101,listtoremove,': ',maxm,' DATA LINES' 

;build arrays
  firstlistarr    = strarr(maxn)
  secondlistarr   = strarr(maxm)
  qtemp           = ''
  equal           = 0

;read files in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin
    readf,1,qtemp
    qtemp = strtrim(qtemp,2)
    printf,101,'skyview: qtemp='+qtemp
    firstlistarr(i) = qtemp
  end  

  close,1
  printf,101,'skyview: first list read.'
  close,1
  openr,1,listtoremove
  for i=0,maxm-1 do begin
    readf,1,qtemp
    qtemp = strtrim(qtemp,2)
    printf,101,'skyview: qtemp='+qtemp
    secondlistarr(i) = qtemp
  end  
  close,1
  printf,101,'skyview: second list read.'

  close,2
  openw,2,newlist
  for i=0,maxn-1 do begin
    equal = 0
    for j=0,maxm-1 do begin
      if firstlistarr(i) eq secondlistarr(j) then equal = 1
    endfor
    if equal eq 0 then begin
      printf,2,firstlistarr(i)
      print,'firstlistarr('+string(i)+') not found in second list => printing it to new list'
      printf,101,'removelist: firstlistarr('+string(i)+') not found in second list => printing it to new list'
      printf,101,'removelist: firstlistarr('+string(i)+') = '+firstlistarr(i)
    endif else begin
      print,'firstlistarr('+string(i)+') found in second list => dont printing it'
      printf,101,'removelist: firstlistarr('+string(i)+') found in second list => dont printing it'
      printf,101,'removelist: firstlistarr('+string(i)+') = '+firstlistarr(i)
    end
  endfor

;close files
  close,1
  close,2

;countlines newlist
  maxn2 = countlines(newlist)
  print,'removelist: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
  print,'removelist: '+string(maxn-maxn2)+' LINES removed'

;close logfile
  close,101
endelse
end
