;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;###########################
function maxcountlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file array specified, return 0.' $
else begin
  result=strarr(1)
  lines=N_ELEMENTS(s)
  maxnlines = 0UL
  for i=0UL, lines-1 do begin
    spawn,'wc -l '+s(i),result
    c=ulong(result(0))
    if c gt maxnlines then $
      maxnlines = c
  endfor
end
return,maxnlines
end

;############################
pro remove_parameter_from_parameterfiles,directory,parameter
;############################
;
; NAME:                  remove_parameter_from_parameterfiles
; PURPOSE:               * removes parameter <parameter> from parameterfiles of the STELLA pipeline
;                        
; CATEGORY:              
; CALLING SEQUENCE:      remove_parameter_from_parameterfiles,<String directory>,<String parameter>
; INPUTS:                 Directory named 'directory':
;                         -rwxr-xr-x  1 azuri azuri 30234 2006-03-16 02:08 parameterfile_SES_2148x2052.prop
;                         -rwxr-xr-x  1 azuri azuri 29887 2006-03-11 21:27 parameterfile_SES_2198x2052.prop
;                         -rw-r--r--  1 azuri azuri 29918 2006-03-03 00:39 parameterfile_SES_2198x2052_errortest.prop
;                         -rwxr-xr-x  1 azuri azuri 30122 2006-02-17 18:45 parameterfile_ALFOSC_6grism9_2102x2052.prop
;                         -rw-r--r--  1 azuri azuri 29840 2006-01-30 03:38 parameterfile_test.prop
;                         -rwxr-xr-x  1 azuri azuri 29423 2006-01-08 15:08 parameterfile_SES_1074x2052.prop
;                                            .
;                                            .
;                                            .
;                        
; OUTPUTS:               outfile: same as infiles, but updated
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.04.2006
;

if n_elements(parameter) eq 0 then begin
  print,'remove_parameter_from_parameterfiles: Not enough parameters specified, return 0.'
  print,'remove_parameter_from_parameterfiles: USAGE: remove_parameter_from_parameterfiles,<in: directory:String>,<in: parameter:String>'
end else begin

  tempfile = 'ls-lt_out.text'
  tempstr = ''

; --- list directory sorted by time of last modification
  spawn,'ls '+directory+'/parameterfile*.prop > '+tempfile

; --- countlines
  nfiles = 0UL
  nfiles = countlines(tempfile)
  print,tempfile,': ',nfiles,' LINES'  

; --- build arrays
  nparameterlines      = 0.
  filename             = strarr(nfiles)
  i = 0UL
  j = 0UL
  k = 0UL

;read file names in arrays
  print,'remove_parameter_from_parameterfiles: reading file list <'+tempfile+'>'
  openr,lun,tempfile,/GET_LUN
  for i=0UL,nfiles-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    if strmid(tempstr,0,1) ne '#' then begin
      filename(j) = tempstr
      print,'remove_parameter_from_parameterfiles: reading file: line ',i,': filename(',i,') = ',filename(i)
      j = j+1
    end
  end
  free_lun,lun

  print,'remove_parameter_from_parameterfiles: j = ',j

; --- read first (newest) parameterfile
  nfilesparameterlines = maxcountlines(filename)
  print,'remove_parameter_from_parameterfiles: maxcountlines(filename) => nparameterlines = ',nparameterlines,' in filename'
  nparameterlines            = countlines(filename(0))
  linearray                  = strarr(nparameterlines)

; --- update parameterfiles
  infile  = ''
  spawn,'rm -rf bak/'
  spawn,'mkdir bak'
  for k=0UL, nfiles-1 do begin
    infile = filename(k)
    spawn,'cp -p '+infile+' bak/'
    outfile = infile+'_merged'
; --- read infile
    openr,luna,infile,/GET_LUN
    openw,lunw,outfile,/GET_LUN
    nlines = countlines(infile)
    print,'remove_parameter_from_parameterfiles: infile <'+infile+'> contains ',nlines,' lines'
    for m=0UL, nlines-1 do begin
      readf,luna,tempstr
      tempstr = strtrim(tempstr,2)
      if strmid(tempstr,0,strlen(parameter)) ne parameter and strmid(tempstr,0,strlen(parameter)+1) ne ('#'+parameter) then begin
        printf,lunw,tempstr
      end
    endfor

    free_lun,lunw
    free_lun,luna
    spawn,'mv '+outfile+' '+infile
  endfor

endelse
end
