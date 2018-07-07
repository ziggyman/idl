;############################
pro writeClHeaderOneFile,list,newlist
;############################
;this program removes the precompiler-_DEBUG_..._ definitions in 'list'
;############################

if n_elements(newlist) eq 0 then begin
  print,'writeClHeaderOneFile: No file specified, return 0.'
  print,'usage     : writeClHeaderOneFile,program,new_rogram'
endif else begin   

;logfile
  openw,loglun,'logfile_writeClHeaderOneFile',/GET_LUN

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' lines in program to clean'  
  printf,loglun,list,': ',maxn,' lines in program to clean' 
  
;build arrays
  listarr    = strarr(maxn)
  qtemp      = ''
  newqtemp   = ''   
  
;read files in arrays
  openr,luna,list,/GET_LUN
  for i=0,maxn-1 do begin
      readf,luna,qtemp
;      qtemp = strtrim(qtemp,2)
      printf,loglun,'writeClHeaderOneFile: qtemp='+qtemp
      listarr(i) = qtemp
  end  

  maxl = maxn-3;
  print,'maxl = '+string(maxl)
  
  free_lun,luna
  printf,loglun,'writeClHeaderOneFile: program read.'
  
  openw,luna,newlist,/GET_LUN
  for i=0,maxn-1 do begin
; search for 'begin'
    print,'Line no '+string(i)
    if strmid(strtrim(listarr(i),2),0,5) eq 'begin' then begin
      break
    endif else begin
;      if strmid(strtrim(listarr(i),2),0,1) ne '#' then begin
;        print,'no # at beginning'
        printf,luna,listarr(i)
;      endif
    endelse
  endfor
;close files
  free_lun,luna
;countlines newlist
  maxn2 = countlines(newlist)
  print,'writeClHeaderOneFile: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
  print,'writeClHeaderOneFile: '+string(maxn-maxn2)+' LINES removed'
  
;close logfile
  free_lun,loglun
endelse
end
