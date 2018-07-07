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
  print,'usage     : removePrecompDefs,list_of_programs,list_of_new_rograms'
endif else begin   

;logfile
  close,101
  openw,101,'logfile_removePrecompDefs'

;countlines
  maxn = countlines(list)
  maxm = countlines(newlist)
  if maxn eq maxm then begin
      print,list,': ',maxn,' Programs to clean'  
      printf,101,list,': ',maxn,' Programs to clean' 

;build arrays
      listarr    = strarr(maxn)
      newlistarr = strarr(maxn)
      qtemp      = ''
      newqtemp   = ''   

;read files in arrays
      close,1
      openr,1,list
      close,2
      openr,2,newlist
      for i=0,maxn-1 do begin
          readf,1,qtemp
          readf,2,newqtemp
          qtemp = strtrim(qtemp,2)
          newqtemp = strtrim(newqtemp,2)
          printf,101,'removePrecompDefs: qtemp='+qtemp+' newqtemp='+newqtemp
          listarr(i) = qtemp
          newlistarr(i) = newqtemp
      end  
      
      close,1
      close,2
      printf,101,'removePrecompDefs: list read.'
      
      for i=0,maxn-1 do begin
; search for '#ifdef _DEBUG_'
          maxm = countlines(listarr(i))
          print,list,': ',maxm,' lines in program ',listarr(i)  
          close,1
          openr,1,listarr(i)
          close,2
          openw,2,newlistarr(i)
          for j=0,maxm-1 do begin
              readf,1,qtemp
              print,qtemp
              if strmid(qtemp,0,14) eq '#ifdef _DEBUG_' then begin
                  repeat begin
                      j = j+1
                      readf,1,qtemp
                      print,qtemp
                  endrep until strmid(qtemp,0,6) eq '#endif'
              endif else begin
                  printf,2,qtemp
                  print,'printing listarr('+qtemp+') to new list'
                  printf,101,'removePrecompDefs: printing listarr('+qtemp+') to new list'
              endelse
          endfor
;close files
          close,1
          close,2
      endfor
;countlines newlist
      maxn2 = countlines(newlist)
      print,'removePrecompDefs: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
      print,'removePrecompDefs: '+string(maxn-maxn2)+' LINES removed'
  endif else begin
      print,'removePrecompDefs: ERROR: numbers of files in list1 and list2 are not equal!'
  endelse

;close logfile
  close,101
endelse
end
