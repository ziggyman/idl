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
pro merge_parameterfiles,directory
;############################
;
; NAME:                  merge_parameterfiles
; PURPOSE:               * merges parameterfiles of the STELLA pipeline
;                          - takes last edited file and replaces found parameters in the older files
;                        
; CATEGORY:              
; CALLING SEQUENCE:      merge_parameterfiles,<String directory>
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

if n_elements(directory) eq 0 then begin
  print,'merge_parameterfiles: No parameter specified, return 0.'
  print,'merge_parameterfiles: USAGE: merge_parameterfiles,<in: directory:String>'
end else begin

  tempfile = 'ls-lt_out.text'
  tempstr = ''

; --- list directory sorted by time of last modification
  spawn,'ls -lt '+directory+'/parameterfile_*.prop > '+tempfile

; --- countlines
  maxn = 0UL
  maxn = countlines(tempfile)
  print,tempfile,': ',maxn,' LINES'  
  maxndat = 0UL
  maxndat = countdatlines(tempfile)
  print,tempfile,': ',maxndat,' DATA LINES'  

; --- build arrays
  lsout                = strarr(maxndat)
  nparameterlines      = 0.
  filename             = strarr(maxndat)
  parameter            = ''
  parametervalue       = ''
  parameterexplanation = ''
  i = 0UL
  j = 0UL
  k = 0UL

;read file in arrays
  print,'merge_parameterfiles: reading file ',tempfile
  openr,lun,tempfile,/GET_LUN
  for i=0UL,maxn-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    if strmid(tempstr,0,1) ne '#' then begin
      lsout(j) = tempstr
      print,'merge_parameterfiles: reading file: line ',i,': lsout(',i,') = ',lsout(i)
      j = j+1
    end
  end
  free_lun,lun

  print,'merge_parameterfiles: j = ',j

; --- extract filenames
  maxn = j
  filename = strarr(maxn)
  for l=0UL,maxndat-1 do begin
      filename(l) = strtrim(strmid(lsout(l),strpos(lsout(l),' ',/REVERSE_SEARCH),strlen(lsout(l))-strpos(lsout(l),' ',/REVERSE_SEARCH)),2)
  end

; --- read first (newest) parameterfile
  maxnparameterlines = maxcountlines(filename)
  print,'merge_parameterfiles: maxcountlines(filename) => nparameterlines = ',nparameterlines,' in filename'
  nparameterlines = countlines(filename(0))
  linearray                 = strarr(nparameterlines)
  parameterarray            = strarr(nparameterlines)
  parametervaluearray       = strarr(nparameterlines)
  parameterexplanationarray = strarr(nparameterlines)
  linearraya                 = strarr(maxnparameterlines)
  parameterarraya            = strarr(maxnparameterlines)
  parametervaluearraya       = strarr(maxnparameterlines)
  parameterexplanationarraya = strarr(maxnparameterlines)
;  tempfile = '/home/azuri/entwicklung/idl/'+tempfile
;  print,'merge_parameterfiles: reading file ',tempfile
  openr,lun,filename(0),/GET_LUN
  for i=0UL,nparameterlines-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    linearray(i) = tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      parameterarray(i) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' '),strlen(tempstr)-strpos(tempstr,' ')),2)
      parametervaluearray(i) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
      tempstr = strtrim(strmid(tempstr,strpos(tempstr,' '),strlen(tempstr)-strpos(tempstr,' ')),2)
      parameterexplanationarray(i) = tempstr
      print,'merge_parameterfiles: reading file: line ',i,': parameter = '+parameterarray(i)+', value = '+parametervaluearray(i)+', explanation = '+parameterexplanationarray(i)
    end
    
  endfor
  free_lun,lun

; --- update other parameterfiles
  infile  = ''
  newline = ''
  nparameterfiles = maxn
  spawn,'rm -rf bak/'
  spawn,'mkdir bak'
  for k=1UL, nparameterfiles-1 do begin
    infile = filename(k)
    spawn,'cp -p '+infile+' bak/'
    outfile = infile+'_merged'
; --- read infile
    openr,luna,infile,/GET_LUN
    nlines = countlines(infile)
    print,'merge_parameterfiles: infile <'+infile+'> contains ',nlines,' lines'
    for m=0UL, nlines-1 do begin
      readf,luna,tempstr
      tempstr = strtrim(tempstr,2)
      linearraya(m) = tempstr
      if strmid(tempstr,0,1) ne '#' then begin
        parameterarraya(m) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
        tempstr = strtrim(strmid(tempstr,strpos(tempstr,' '),strlen(tempstr)-strpos(tempstr,' ')),2)
        parametervaluearraya(m) = strtrim(strmid(tempstr,0,strpos(tempstr,' ')),2)
        tempstr = strtrim(strmid(tempstr,strpos(tempstr,' '),strlen(tempstr)-strpos(tempstr,' ')),2)
        parameterexplanationarraya(m) = tempstr
        print,'merge_parameterfiles: reading file <'+infile+'>: line ',m,': parameter = '+parameterarraya(m)+', value = '+parametervaluearraya(m)+', explanation = '+parameterexplanationarraya(m)
      end
    endfor

    openw,lunw,outfile,/GET_LUN
    for l=0UL, nparameterlines-1 do begin
      newline = linearray(l)
      if strmid(newline,0,1) ne '#' then begin
        newline = newline+'[to adopt]'
        for m=0UL, nlines-1 do begin
          if strmid(linearraya(m),0,1) ne '#' then begin
            if parameterarray(l) eq parameterarraya(m) then begin
              newline = parameterarray(l)
              while strlen(newline) lt 34 do $
                newline = newline + ' '
              newline = newline + ' '
              newline = newline+parametervaluearraya(m)
              while strlen(newline) lt 49 do $
                newline = newline + ' '
              newline = newline + ' '
              newline = newline+parameterexplanationarray(l)
              print,'merge_parameterfiles: infile <'+infile+'>: parameter '+parameterarray(l)+' updated'
            end
          endif
        endfor
      endif
      if strmid(newline,0,8) eq '#order1:' then begin
        print,'merge_parameterfiles: <#order1:> found'
        for m=0UL, nlines-1 do begin
          if strmid(linearraya(m),0,8) eq '#order1:' then begin
            for n=m, nlines-1 do begin
              newline = linearraya(n)
              printf,lunw,newline
              m = n
            endfor
          endif
        endfor
        l = nparameterlines-1
      endif else begin
        printf,lunw,newline
      end
    endfor
    free_lun,lunw
    free_lun,luna
    spawn,'mv '+outfile+' '+infile
  endfor

endelse
end
