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
pro removePrecompDefs,list,newlist
;############################
;this program removes the precompiler-_DEBUG_..._ definitions in 'list'
;############################

if n_elements(newlist) eq 0 then begin
  print,'removePrecompDefs: No file specified, return 0.'
  print,'usage     : removePrecompDefs,program,newProgram'
endif else begin   

;logfile
  close,101
  openw,101,'logfile_removePrecompDefs'

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' DATA LINES'  
  printf,101,list,': ',maxn,' DATA LINES' 

;build arrays
  listarr    = strarr(maxn)
  qtemp           = ''

;read files in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin
    readf,1,qtemp
    qtemp = strtrim(qtemp,2)
    printf,101,'removePrecompDefs: qtemp='+qtemp
    listarr(i) = qtemp
  end  

  close,1
  printf,101,'removePrecompDefs: list read.'
  close,1

  close,2
  openw,2,newlist
  for i=0,maxn-1 do begin
; search for '#ifdef _DEBUG_'
      if strmid(listarr(i,0,14) eq '#ifdef _DEBUG_' then begin
          repeat begin
              i = i+1
          endrep until strmid(listarr(i,0,6) == '#endif'
      endif
      else begin
          printf,2,listarr(i)
          print,'printing listarr('+listarr(i)+') it to new list'
      printf,101,'removePrecompDefs: printing listarr('+listarr(i)+') it to new list'
  endfor

;close files
  close,1
  close,2

;countlines newlist
  maxn2 = countlines(newlist)
  print,'removePrecompDefs: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
  print,'removePrecompDefs: '+string(maxn-maxn2)+' LINES removed'

;close logfile
  close,101
endelse
end
