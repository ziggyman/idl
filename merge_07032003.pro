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

;logfile
  close,101
  openw,101,'logfile'

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' FILES'  
  printf,101,list,': ',maxn,' FILES'  

;build arrays
  files = strarr(maxn)
  newlist = 'templist'

;read file in arrays
  fileq = ' '
  close,1
  openr,1,list
  for i=0,maxn-1 do begin  
    readf,1,fileq
    files(i) = fileq
;    print,'files(',i,') = ',files(i)
  end  
  close,1  

;countlines
  maxi = countlines(files(1))
  print,files(1),': ',maxi,' DATA LINES'
  printf,101,files(1),': ',maxi,' DATA LINES'

;read datas from files in array
  lambdaq = double(0.)
  intensq = double(0.)
  datas = dblarr(maxn,maxi,2)
  for i=0,maxn-1 do begin
    close,i+2
    tempstr = files(i)
    openr,i+2,tempstr
;    print,'tempstring = ',tempstr
    for j=0,maxi-1 do begin
      readf,i+2,lambdaq,intensq
      datas(i,j,0) = lambdaq
      datas(i,j,1) = intensq
;      readf,i+2,datas(i,j,0),datas(i,j,1)
;      print,datas(i,j,0),datas(i,j,1)
    endfor
    close,i+2
  endfor

;merge the orders
  merged = dblarr(maxn*maxi,2)
  dummerge = 0
  dumfilenr = 0
  dumj = 0
  test = 0
  hiti = 0
  hitj = 0
  hitjold = hitj

;  while (test eq 0) do begin
  for dumfilenr = 0,maxn-2 do begin
    hitjold = hitj
    for zeile_file1=1,maxi/2 do begin
;      dumbreak = 0
      for zeile_file2=maxi/2,maxi-2 do begin
;        printf,101,'datas(',dumfilenr,',',zeile_file1,',0)=',datas(dumfilenr,zeile_file1,0),', datas(',dumfilenr+1,',',zeile_file2,',0)=',datas(dumfilenr+1,zeile_file2,0)
;        if (datas(dumfilenr,zeile_file1,0) gt datas(dumfilenr+1,zeile_file2,0)) and (datas(dumfilenr,zeile_file1+1,0) le datas(dumfilenr+1,zeile_file2+1,0)) then begin
        if (datas(dumfilenr,zeile_file1,0) gt datas(dumfilenr+1,zeile_file2,0)) then begin

;         printf,101,'datas(dumfilenr,zeile_file1,0)=',datas(dumfilenr,zeile_file1,0)
;         printf,101,' gt datas(dumfilenr+1,zeile_file2,0)=',datas(dumfilenr+1,zeile_file2,0)
;         printf,101,' '
;         printf,101,'datas(dumfilenr,zeile_file1+1,0)=',datas(dumfilenr,zeile_file1+1,0)
;         printf,101,'      datas(dumfilenr+1,zeile_file2+1,0)=',datas(dumfilenr+1,zeile_file2+1,0)
;         printf,101,' '
         
          if (zeile_file1 eq maxi/2) and (zeile_file2 eq maxi-2) then begin
            print,'Error! NO MATCH FOUND!!!  dumfilenr = ',dumfilenr
            printf,101,'Error! NO MATCH FOUND!!!  dumfilenr = ',dumfilenr
          endif 

          if (datas(dumfilenr,zeile_file1,0) le datas(dumfilenr+1,zeile_file2+1,0)) then begin
;           printf,101,'zeile_file1=',zeile_file1,', zeile_file2=',zeile_file2
;           print,'zeile_file1=',zeile_file1,', zeile_file2=',zeile_file2
            if ((datas(dumfilenr,zeile_file1,1) ge datas(dumfilenr+1,zeile_file2,1)) and (datas(dumfilenr,zeile_file1+1,1) le datas(dumfilenr+1,zeile_file2+1,1))) or ((datas(dumfilenr,zeile_file1,1) le datas(dumfilenr+1,zeile_file2,1)) and (datas(dumfilenr,zeile_file1+1,1) ge datas(dumfilenr+1,zeile_file2+1,1))) then begin
              hiti = zeile_file1
              hitj = zeile_file2
              print,'Treffer! => hiti = ',hiti,'    hitj = ',hitj,'   hitjold = ',hitjold
              printf,101,'Treffer! => hiti = ',hiti,'    hitj = ',hitj,'   hitjold = ',hitjold
;              dumbreak = 1
              print,'BREAK!'
              printf,101,'BREAK!'
              goto, jump1
            endif          
          endif
        endif
      endfor
    endfor
    jump1: print,'jump1 reached: dumfilenr = ',dumfilenr
    printf,101,'jump1 reached: dumfilenr = '+string(dumfilenr)+', hitjold = '+string(hitjold)+', hiti = '+string(hiti)
    if dumfilenr eq 0 then begin
      for line_i=maxi-1,hiti,-1 do begin
        merged(maxi-1-line_i,0) = datas(dumfilenr,line_i,0)
        merged(maxi-1-line_i,1) = datas(dumfilenr,line_i,1)
        print,maxi-1-line_i,merged(maxi-1-line_i,0),merged(maxi-1-line_i,1)
        printf,101,maxi-1-line_i,merged(maxi-1-line_i,0),merged(maxi-1-line_i,1)
      endfor
      dummerge = maxi-hiti-1
    endif else begin
      zeile_file1 = dummerge
      print,'zeile_file1 = '+string(zeile_file1)
      for line_i=hitjold,hiti,-1 do begin
        zeile_file1 = zeile_file1 + 1
        merged(zeile_file1,0) = datas(dumfilenr,line_i,0)
        merged(zeile_file1,1) = datas(dumfilenr,line_i,1)
;        print,zeile_file1,merged(zeile_file1,0),merged(zeile_file1,1)
        printf,101,zeile_file1,merged(zeile_file1,0),merged(zeile_file1,1)
      endfor
      dummerge = dummerge + hitjold - hiti + 1
    end
;    if dumfilenr eq 60 then begin
;      print,'dumfilenr eq maxi-3 => ',dumfilenr,maxi-3
;      test = 1
;      break
;    endif
;    dumfilenr = dumfilenr + 1
;    if dumfilenr gt maxi-3 then break
    hitjold = hitj
    print,'dummerge=',dummerge,', dumfilenr=',dumfilenr,', dumj=',dumj,', test=',test,', hiti=',hiti,', hitj=',hitj,', hitjold=',hitjold
    printf,101,'dummerge=',dummerge,', dumfilenr=',dumfilenr,', dumj=',dumj,', test=',test,', hiti=',hiti,', hitj=',hitj,', hitjold=',hitjold

  end
  dummfilenr = dumfilenr + 1
  print,'for-loop ended dumfilenr set to ',dumfilenr
  printf,101,'for-loop ended dumfilenr set to ',dumfilenr
  for line_i=maxi-1,hitjold,-1 do begin
    merged(dummerge+line_i,0) = datas(dumfilenr,line_i,0)
    merged(dummerge+line_i,1) = datas(dumfilenr,line_i,1)
    print,dummerge+line_i,merged(dummerge+line_i,0),merged(dummerge+line_i,1)
    printf,101,dummerge+line_i,merged(dummerge+line_i,0),merged(dummerge+line_i,1)
  endfor

;write file
;  newlist = 'templist'
  print,'output filename:',newlist
  printf,101,'output filename:',newlist
  close,100
  openw,100,newlist 
  i = ulong(0)
  for i=ulong(0),dummerge+hitjold-maxi+1 do begin
     printf,100,merged(i,0),merged(i,1)
  endfor
  close,100
  print,newlist,' READY!!!'
  printf,101,newlist,' READY!!!'
  close,101

endelse
end
