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
pro removePrecompDefsOneFile,list,newlist
;############################
;this program removes the precompiler-_DEBUG_..._ definitions in 'list'
;############################

if n_elements(newlist) eq 0 then begin
  print,'removePrecompDefs: No file specified, return 0.'
  print,'usage     : removePrecompDefsOneFile,program,new_rogram'
endif else begin   

;logfile
  close,101
  openw,101,'logfile_removePrecompDefsOneFile'

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' lines in program to clean'  
  printf,101,list,': ',maxn,' lines in program to clean' 
  
;build arrays
  listarr    = strarr(maxn)
  qtemp      = ''
  newqtemp   = ''   
  
;read files in arrays
  close,1
  openr,1,list
  for i=0,maxn-1 do begin
      readf,1,qtemp
;      qtemp = strtrim(qtemp,2)
      printf,101,'removePrecompDefs: qtemp='+qtemp
      listarr(i) = qtemp
  end  

  maxl = maxn-3;
  print,'maxl = '+string(maxl)
  
  close,1
  printf,101,'removePrecompDefs: program read.'
  
  close,2
  openw,2,newlist
  for i=0,maxn-1 do begin
; search for '#ifdef _DEBUG_'
;      print,'Line no '+string(i)
      if strmid(strtrim(listarr(i),2),0,14) eq '#ifdef _DEBUG_' then begin
;          print,'#ifdef _DEBUG_ at line '+listarr(i)+'detected'
;          print,'not printing: '+listarr(i)
;          printf,101,'not printing: '+listarr(i)
          repeat begin
              i = i+1
;              print,'not printing: '+listarr(i)
;              printf,101,'not printing: '+listarr(i)
          endrep until strmid(strtrim(listarr(i),2),0,6) eq '#endif'
      endif else begin
;          print,'no # at beginning'
          if i lt maxl then begin
;              print,string(i)+' < ('+string(maxl)
              if (( strmid(strtrim(listarr(i),2),0,5) eq 'else{' ) and ( strtrim(listarr(i+1),2) eq '}' )) then begin
                  print,'empty else loop detected'
;                  print,'not printing: '+listarr(i)
                  i = i+1
;                  print,'not printing: '+listarr(i)
              endif else begin
                  printf,2,listarr(i)
;                  print,'printing listarr('+string(i)+') to new list'
;                  printf,101,'removePrecompDefs: printing listarr('+string(i)+') to new list'
              endelse
          endif else begin
              printf,2,listarr(i)
;              print,'printing listarr('+string(i)+') to new list'
;              printf,101,'removePrecompDefs: printing listarr('+string(i)+') to new list'
          endelse
      endelse
  endfor
;close files
  close,1
  close,2
;countlines newlist
  maxn2 = countlines(newlist)
  print,'removePrecompDefs: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
  print,'removePrecompDefs: '+string(maxn-maxn2)+' LINES removed'
;  endif else begin
;      print,'removePrecompDefs: ERROR: numbers of files in list1 and list2 are not equal!'
;  endelse
  
;close logfile
  close,101
endelse
end
