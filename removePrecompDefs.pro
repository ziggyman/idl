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
  close,102
  openw,102,'logfile_removePrecompDefs'

;countlines
  maxn = countlines(list)
  maxm = countlines(newlist)
  if maxn eq maxm then begin
      print,list,': ',maxn,' Programs to clean'  
      printf,102,list,': ',maxn,' Programs to clean' 

;build arrays
      proarr    = strarr(maxn)
      newproarr = strarr(maxn)
      qtemp      = ''
      newqtemp   = ''   

;read files in arrays
      close,3
      openr,3,list
      close,4
      openr,4,newlist
      for i=0,maxn-1 do begin
          readf,3,qtemp
          readf,4,newqtemp
          qtemp = strtrim(qtemp,2)
          newqtemp = strtrim(newqtemp,2)
          printf,102,'removePrecompDefs: qtemp='+qtemp+' newqtemp='+newqtemp
          proarr(i) = qtemp
          newproarr(i) = newqtemp
      end  
      
      close,3
      close,4
      printf,102,'removePrecompDefs: list read.'
      
      for i=0,maxn-1 do begin
          removePrecompDefsOneFile,proarr(i),newproarr(i)
      endfor
  endif else begin
      print,'removePrecompDefs: ERROR: numbers of files in list1 and list2 are not equal!'
  endelse

;close logfile
  close,102
endelse
end
