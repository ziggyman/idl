;############################
pro writeClHeaders,list,newlist
;############################
;this program writes the CL-headers of files in 'list' to files in 'newlist'
;############################

if n_elements(newlist) eq 0 then begin
  print,'writeClHeaders: No file specified, return 0.'
  print,'usage     : writeClHeaders,list_of_programs,list_of_new_rograms'
endif else begin   

;logfile
  openw,loglun,'logfile_writeClHeaders',/GET_LUN

;countlines
  maxn = countlines(list)
  maxm = countlines(newlist)
  if maxn eq maxm then begin
      print,list,': ',maxn,' Programs to clean'  
      printf,loglun,list,': ',maxn,' Programs to clean' 

;build arrays
      proarr    = strarr(maxn)
      newproarr = strarr(maxn)
      qtemp      = ''
      newqtemp   = ''   

;read files in arrays
      openr,luna,list,/GET_LUN
      openr,lunb,newlist,/GET_LUN
      for i=0,maxn-1 do begin
          readf,luna,qtemp
          readf,lunb,newqtemp
          qtemp = strtrim(qtemp,2)
          newqtemp = strtrim(newqtemp,2)
          printf,loglun,'writeClHeaders: qtemp='+qtemp+' newqtemp='+newqtemp
          proarr(i) = qtemp
          newproarr(i) = newqtemp
      end  
      
      free_lun,luna
      free_lun,lunb
      printf,loglun,'writeClHeaders: list read.'
      
      for i=0,maxn-1 do begin
          writeClHeaderOneFile,proarr(i),newproarr(i)
      endfor
  endif else begin
      print,'writeClHeaders: ERROR: numbers of files in list1 and list2 are not equal!'
  endelse

;close logfile
  free_lun,loglun
endelse
end
