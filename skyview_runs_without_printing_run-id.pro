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
pro skyview,list,texfile,path
;############################
;this program writes 2 other programs: a shell scripts to convert the
;given images to ps-files and a tex-file to make the skyviews out of
;the ps-files
;############################

if n_elements(path) eq 0 then begin
  print,'skyview: Not enough parameters given, return 0.'
  print,'usage: skyview,starlist,texfile,path_where_the_images_are'
endif else begin   

;logfile
  close,1
  openw,1,'logfile_skyview'

;countlines
  maxn = countlines(path+list)
  print,list,': ',maxn,' FILENAMES'  
  printf,1,list,': ',maxn,' FILENAMES' 
  maxlines = countlines(path+texfile)
  print,texfile,': ',maxlines,' TEXT LINES' 
  printf,1,texfile,': ',maxlines,' TEXT LINES' 

;build arrays
  mystrarr    = strarr(maxn)
  filearr     = strarr(maxn)
  mytexarr    = strarr(maxlines)
;  path        = '/home/azuri/skycat/'
  tempstring  = ''
  tempstring1 = '\put(2.0,0.0){\includegraphics*[width=16.8cm,clip=]{'
  tempstring2 = '}}'
  tempstring3 = '\hspace*{2cm}\bf{OB:\hspace{17.8mm}'
  tempstring4 = '}\\'
  tempstring5 = '\hspace*{2cm}\bf{RUN ID:\hspace{8mm}'
  tempstring6 = '}\\'
  headlines   = 0
  filenr      = 0
  printf,1,'skyview: arrays built'

  qtemp = ''

;read file containing the gifs in array
  close,3
  openr,3,path+list
  for i=0,maxn-1 do begin
    readf,3,qtemp
    qtemp = strtrim(qtemp,1)
    printf,1,'skyview: qtemp='+qtemp
    tempstring  = strmid(qtemp,0,strlen(qtemp)-3) + 'eps'
    mystrarr(i) = tempstring
    printf,1,'skyview: mystrarr('+string(i)+') = '+mystrarr(i)
  end  
  close,3
  printf,1,'skyview: gif-files read.'

;read and write texfile
  close,3
  openr,3,path+texfile
  for i=0,maxlines-1 do begin
    readf,3,qtemp
    mytexarr(i) = qtemp
    printf,1,'skyview: mytexarr('+string(i)+') = '+mytexarr(i)
  endfor
  close,3

;find header
  for i=0,maxlines-1 do begin
    if (strlen(mytexarr(i)) gt 17) then begin
      printf,1,'skyview: strmid(mytexarr('+string(i)+'),0,16) = '+strmid(mytexarr(i),0,16)
      if strmid(mytexarr(i),0,16) eq '\begin{minipage}' then begin
        headlines = i
        printf,1,'skyview: beginning of real tex at line = headlines = '+headlines+' (beginning with 1) => breaking forloop'
        goto, jump1
      endif
    endif 
  endfor

;write new texfile
  jump1: printf,1,'skyview: maxn = ',maxn,', maxlines = ',maxlines
  print,'skyview: maxn = ',maxn,', maxlines = ',maxlines
  for i=0,maxn-1 do begin
    filenr = 4
    close,filenr
    filearr(i) = path+'hd'+strmid(mystrarr(i),2,strlen(mystrarr(i))-5)+'tex'
    print,'filenr('+string(i)+') = '+string(filenr)+', filename = '+filearr(i)
    printf,1,'skyview: filenr('+string(i)+') = '+string(filenr)+', filename = '+filearr(i)
    openw,filenr,filearr(i)
    for k=0,headlines-1 do begin 
      printf,filenr,mytexarr(k)
      printf,1,'skyview: '+mytexarr(k)
    endfor
    for j=headlines,maxlines-1 do begin
      printf,1,'skyview: strlen(mytexarr('+string(j)+') = '+mytexarr(j)+') = '+string(strlen(mytexarr(j)))
      if (strlen(mytexarr(j)) gt strlen(tempstring1)) and (strmid(mytexarr(j),0,strlen(tempstring3)) ne tempstring3) then begin
        printf,1,'skyview: strmid(mytexarr('+string(j)+'),0,'+string(strlen(tempstring1))+') = '+strmid(mytexarr(j),0,strlen(tempstring1))
        if strmid(mytexarr(j),0,strlen(tempstring1)) eq tempstring1 then begin 
          printf,1,'skyview: Treffer! replacing one'
          print,'skyview: Treffer! replacing one ps-file'
          printf,filenr,tempstring1+path+mystrarr(i)+tempstring2
          printf,1,'skyview: '+tempstring1+mystrarr(i)+tempstring2
        endif else printf,filenr,mytexarr(j)
      endif else if strlen(mytexarr(j)) gt strlen(tempstring3) then begin
        printf,1,'skyview: ---------- strmid(mytexarr('+string(j)+'),0,'+string(strlen(tempstring3))+') = '+strmid(mytexarr(j),0,strlen(tempstring3))
        if strmid(mytexarr(j),0,strlen(tempstring3)) eq tempstring3 then begin
          printf,1,'skyview: Treffer! replacing one HD-name'
          print,'skyview: Treffer! replacing one HD-name'
          printf,filenr,tempstring3+'HD '+strmid(mystrarr(i),2,strlen(mystrarr(i))-6)+tempstring4
          printf,1,'skyview: '+tempstring3+'HD '+strmid(mystrarr(i),2,strlen(mystrarr(i))-6)+tempstring4
        endif else printf,filenr,mytexarr(j)
      end else printf,filenr,mytexarr(j)
    endfor
    close,filenr
  endfor

;latex
  for i=0,maxn-1 do begin
    spawn,'latex '+filearr(i)
    printf,1,'skyview: spawning '+'dvips -o '+strmid(filearr(i),0,strlen(filearr(i))-3)+'ps '+strmid(filearr(i),0,strlen(filearr(i))-4)+'.tex'
    spawn,'dvips -o '+strmid(filearr(i),0,strlen(filearr(i))-3)+'ps '+strmid(filearr(i),strlen(path),strlen(filearr(i))-strlen(path)-4)
    spawn,'rm '+strmid(filearr(i),strlen(path),strlen(filearr(i))-strlen(path)-4)+'.aux'
    spawn,'rm '+strmid(filearr(i),strlen(path),strlen(filearr(i))-strlen(path)-4)+'.log'
    spawn,'rm '+strmid(filearr(i),strlen(path),strlen(filearr(i))-strlen(path)-4)+'.dvi'
    spawn,'rm '+filearr(i)
  endfor

;close logfile
  close,1
endelse
end
