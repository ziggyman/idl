;##################################################### 
procedure do_htmldoc_varonepar,filelist,parameter,parameterlist,snrarealist
;#####################################################

if n_elements(snrarealist) eq 0 then begin
  print,'do_htmldoc_varonepar: NOT ENOGH PARAMETERS SPECIFIED -> return 0'
  print," USAGE: do_htmldoc_varonepar,'filelist','parameter','paramterlist','snrarealist'"
endif else begin
  nfiles           = countlines(filelist)
  nparametervalues = countlines(parameterlist)
  nsnrareas        = countlines(snrarealist)
  
  filearr    = strarr(nfiles)
  parvalarr  = strarr(nparametervalues)
;  snrareaarr = strarr(nsnrareas)

  i = 0UL
  tempstr = ''

  openr,lun,filelist,/GET_LUN
  for i=0,nfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    filearr(i) = tempstr
  endfor
  free_lun,lun

  openr,lun,parameterlist,/GET_LUN
  for i=0,nparametervalues-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    parvalarr(i) = tempstr
  endfor
  free_lun,lun

;  openr,lun,snrarealist,/GET_LUN
;  for i=0,nsnrareas-1 do begin
;    readf,lun,tempstr
;    tempstr = strtrim(tempstr,2)
;    snrareaarr(i) = tempstr
;  endfor
;  free_lun,lun

  calcsnrlist,filelist,snrarealist
  

end
