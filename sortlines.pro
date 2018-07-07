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
pro sortlines,list
;############################
;this program sorts an array with 14 columns
;############################

if n_elements(list) eq 0 then print,'sortline: No file specified, return 0.' $
else begin   

;logfile
  close,101
  openw,101,'logfile'

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' DATA LINES'  
  printf,101,list,': ',maxn,' DATA LINES'  

;build arrays
  columns    = 14
  myarray    = strarr(maxn,columns)
  mynewarray = strarr(maxn,columns)
  mydblarray = dblarr(maxn)
  headarray  = strarr(14)
  qarray     = strarr(columns)
  printf,101,'sortlines: arrays built'

  qtemp = ''

;read file in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin
    readf,1,qtemp
    qtemp = strtrim(qtemp,1)
    printf,101,'sortlines: qtemp=',qtemp
    for k=0,columns-1 do begin
      qarray(k) = strmid(qtemp,0,strpos(qtemp,' '))
      qtemp     = strtrim(strmid(qtemp,strpos(qtemp,' ')),1)
    endfor
;    readf,1,qarray(0),qarray(1),qarray(2),qarray(3),qarray(4),qarray(5),qarray(6),qarray(7),qarray(8),qarray(9),qarray(10),qarray(11),qarray(12),qarray(13)
;    print,i,lambdaq,intensq,whoknowsq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7, " whoknowsq = ", F15.7 )'
    if i eq 0 then begin
      for j=0,columns-1 do begin
        headarray(j)    = qarray(j)
        printf,101,'sortlines: reading infile(',list,'): run',i,' qarray(',j,')=',qarray(j),' headarray(',j,')=',headarray(j)
      endfor
    endif else begin
      for j=0,columns-1 do begin
        myarray(i-1,j)    = qarray(j)
        printf,101,'sortlines: reading infile(',list,'): run',i,' qarray(',j,')=',qarray(j),' myarray(',i-1,',',j,')=',myarray(i-1,j)
      endfor
      mydblarray(i-1) = double(qarray(0))
      printf,101,'sortlines: reading infile(',list,'): run',i,' mydblarray(',i-1,')=',mydblarray(i-1)
    end
  end  
  close,1
  printf,101,'sortlines: infile read.'

;sort 1st column
  printf,101,'sortlines: starting sort'
  for i=0,columns-1 do begin
    mynewarray(*,i) = myarray(sort(mydblarray),i)
  endfor
  printf,101,'sortlines: array sorted'

;write file
  newlist = 'sorted_list.text'
  blankline = '                                   '
  print,'output filename:',newlist
  printf,101,'sortlines: starting writing the new list. output filename:',newlist
  close,2
  openw,2,newlist
    printf,2,headarray(0)+strmid(blankline,0,12-strlen(headarray(0)))+headarray(1)+strmid(blankline,0,12-strlen(headarray(1)))+headarray(2)+strmid(blankline,0,12-strlen(headarray(2)))+headarray(3)+strmid(blankline,0,12-strlen(headarray(3)))+headarray(4)+strmid(blankline,0,12-strlen(headarray(4)))+headarray(5)+strmid(blankline,0,5-strlen(headarray(5)))+headarray(6)+strmid(blankline,0,3-strlen(headarray(6)))+headarray(7)+strmid(blankline,0,12-strlen(headarray(7)))+headarray(8)+strmid(blankline,0,12-strlen(headarray(8)))+headarray(9)+strmid(blankline,0,5-strlen(headarray(9)))+headarray(10)+strmid(blankline,0,3-strlen(headarray(10)))+headarray(11)+strmid(blankline,0,12-strlen(headarray(11)))+headarray(12)+strmid(blankline,0,12-strlen(headarray(12)))+headarray(13)
     printf,101,'sortlines: '+headarray(0)+strmid(blankline,0,12-strlen(headarray(0)))+headarray(1)+strmid(blankline,0,12-strlen(headarray(1)))+headarray(2)+strmid(blankline,0,12-strlen(headarray(2)))+headarray(3)+strmid(blankline,0,12-strlen(headarray(3)))+headarray(4)+strmid(blankline,0,12-strlen(headarray(4)))+headarray(5)+strmid(blankline,0,5-strlen(headarray(5)))+headarray(6)+strmid(blankline,0,3-strlen(headarray(6)))+headarray(7)+strmid(blankline,0,12-strlen(headarray(7)))+headarray(8)+strmid(blankline,0,12-strlen(headarray(8)))+headarray(9)+strmid(blankline,0,5-strlen(headarray(9)))+headarray(10)+strmid(blankline,0,3-strlen(headarray(10)))+headarray(11)+strmid(blankline,0,12-strlen(headarray(11)))+headarray(12)+strmid(blankline,0,12-strlen(headarray(12)))+headarray(13)
   for i=0,maxn-1 do begin
     printf,2,mynewarray(i,0)+strmid(blankline,0,12-strlen(mynewarray(i,0)))+mynewarray(i,1)+strmid(blankline,0,12-strlen(mynewarray(i,1)))+mynewarray(i,2)+strmid(blankline,0,12-strlen(mynewarray(i,2)))+mynewarray(i,3)+strmid(blankline,0,12-strlen(mynewarray(i,3)))+mynewarray(i,4)+strmid(blankline,0,12-strlen(mynewarray(i,4)))+mynewarray(i,5)+strmid(blankline,0,5-strlen(mynewarray(i,5)))+mynewarray(i,6)+strmid(blankline,0,3-strlen(mynewarray(i,6)))+mynewarray(i,7)+strmid(blankline,0,12-strlen(mynewarray(i,7)))+mynewarray(i,8)+strmid(blankline,0,12-strlen(mynewarray(i,8)))+mynewarray(i,9)+strmid(blankline,0,5-strlen(mynewarray(i,9)))+mynewarray(i,10)+strmid(blankline,0,3-strlen(mynewarray(i,10)))+mynewarray(i,11)+strmid(blankline,0,12-strlen(mynewarray(i,11)))+mynewarray(i,12)+strmid(blankline,0,12-strlen(mynewarray(i,12)))+mynewarray(i,13)
     printf,101,'sortlines: '+mynewarray(i,0)+strmid(blankline,0,12-strlen(mynewarray(i,0)))+mynewarray(i,1)+strmid(blankline,0,12-strlen(mynewarray(i,1)))+mynewarray(i,2)+strmid(blankline,0,12-strlen(mynewarray(i,2)))+mynewarray(i,3)+strmid(blankline,0,12-strlen(mynewarray(i,3)))+mynewarray(i,4)+strmid(blankline,0,12-strlen(mynewarray(i,4)))+mynewarray(i,5)+strmid(blankline,0,5-strlen(mynewarray(i,5)))+mynewarray(i,6)+strmid(blankline,0,3-strlen(mynewarray(i,6)))+mynewarray(i,7)+strmid(blankline,0,12-strlen(mynewarray(i,7)))+mynewarray(i,8)+strmid(blankline,0,12-strlen(mynewarray(i,8)))+mynewarray(i,9)+strmid(blankline,0,5-strlen(mynewarray(i,9)))+mynewarray(i,10)+strmid(blankline,0,3-strlen(mynewarray(i,10)))+mynewarray(i,11)+strmid(blankline,0,12-strlen(mynewarray(i,11)))+mynewarray(i,12)+strmid(blankline,0,12-strlen(mynewarray(i,12)))+mynewarray(i,13)
   endfor
  close,2
  printf,101,'sortlines: new list written. closing program.'

;close logfile
  close,101
endelse
end
