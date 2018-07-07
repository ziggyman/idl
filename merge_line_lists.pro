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

;############################
pro merge_line_lists,linelistfilelist,outfile
;############################
;
; NAME:                  merge_line_lists
; PURPOSE:               merges different line lists from <linelistfilelist> to <outfile>
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      merge_line_lists,'linelistfilelist','outfile'
; INPUTS:                input file: 'linelistfilelist':
;                          /home/azuri/stella/linelists/thar.dat
;                          /home/azuri/stella/linelists/hene.dat
;                                            .
;                                            .
;                                            .
;                        /home/azuri/stella/linelists/thar.dat:
;                         # units Angstroms
;                         3187.743    HeI
;                         3464.14     AII(70)
;                         3520.5      NeI 3520.472 blend with A 3520.0
;                                            .
;                                            .
;                                            .
; OUTPUTS:               outfile: Path and name of outfile
;                         # units Angstroms
;                         3187.743    HeI
;                         3464.14     AII(70)
;                         3520.5      NeI 3520.472 blend with A 3520.0
;                         3545.58     AII(70)
;                         3559.51     AII(70)
;                                        .
;                                        .
;                                        .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.11.2006
;

if n_elements(outfile) eq 0 then begin
  print,'MERGE_LINE_LISTS: Not enough parameters specified, return 0.'
  print,'MERGE_LINE_LISTS: Usage: merge_line_lists,<linelistfilelist: String>,<outfile: String>'
end else begin   

  logfile = 'logfile_merge_line_lists.log'
  openw,loglun,logfile,/GET_LUN
  lambdaq = ''
  commentq = ''
  header = ''
  maxn = 0UL
  nextsmallest = 0
  lastnextsmallest = 0
  templambda = 0.
  lastlambda = 0.
  run = 1

;countlines
  nfiles = countlines(linelistfilelist)
  printf,loglun,'MERGE_LINE_LISTS: ',linelistfilelist,' contains ',nfiles,' LINES'  
;  maxn = countdatlines(linelistfilelist)
;  printf,loglun,'MERGE_LINE_LISTS: ',linelistfilelist,' contains ',maxn,' DATA LINES'  

; --- build arrays
  filearr = strarr(nfiles)
  nlinesarr = intarr(nfiles)
  ndatlinesarr = intarr(nfiles)
  posarr = intarr(nfiles)

;read files
  openr,lun,linelistfilelist,/GET_LUN
  for i=0UL,nfiles-1 do begin  
    readf,lun,lambdaq
    printf,loglun,i,lambdaq
    lambdaq = strtrim(lambdaq,2)
    nlinesarr[i] = countlines(lambdaq)
    ndatlinesarr[i] = countdatlines(lambdaq)
    printf,loglun,'merge_line_lists: nlinesarr[',i,'] = ',nlinesarr[i],', ndatlinesarr[',i,'] = ',ndatlinesarr[i]
    if maxn lt ndatlinesarr[i] then $
      maxn = ndatlinesarr[i]
    filearr[i] = lambdaq
  end  
  free_lun,lun

  lambdaarr = dblarr(nfiles,maxn)
  commentarr = strarr(nfiles,maxn)

  for i=0UL, nfiles-1 do begin
    k = 0L
    openr,lun,filearr[i],/GET_LUN
      for j=0UL, nlinesarr[i]-1 do begin
        readf,lun,commentq
        if strmid(commentq,0,1) eq '#' then begin
          header = strtrim(commentq,2)
;          printf,loglun,'merge_line_lists: header = <'+header+'>'
        end else begin
          commentq = strtrim(commentq,2)
          if strpos(commentq,' ') ge 0 then begin
            lambdaq = strmid(commentq,0,strpos(commentq,' '))
            commentq = strmid(commentq,strpos(commentq,' ') + 1)
            commentq = strtrim(commentq,2)
            lambdaarr[i,k] = lambdaq
            commentarr[i,k] = commentq
          end else begin
            lambdaarr[i,k] = commentq
            commentarr[i,k] = ''
          end
;          printf,loglun,'merge_line_lists: lambdaarr[',i,',',k,'] = ',lambdaarr[i,k]
;          printf,loglun,'merge_line_lists: commentarr[',i,',',k,'] = ',commentarr[i,k]
          k = k+1
        end
      endfor
    free_lun,lun
  endfor

; --- merge lists and write outfile
  for i=0UL, nfiles-1 do begin
    posarr[i] = 0
  endfor
  openw,lun,outfile,/GET_LUN
    printf,lun,header
    templambda = lambdaarr[0,posarr[0]]
    nextsmallest = 0
    lastnextsmallest = 0
    run = 1
    while run eq 1 do begin
      printf,loglun,'merge_line_lists: templambda = ',templambda
      printf,loglun,'merge_line_lists: nextsmallest = ',nextsmallest
      for i=0UL, nfiles-1 do begin
;        printf,loglun,'merge_line_lists: posarr[',i,'] = ',posarr[i]
;        printf,loglun,'merge_line_lists: ndatlinesarr[',i,'] = ',ndatlinesarr[i]
        if posarr[i] lt ndatlinesarr[i] then begin
          if lambdaarr[i,posarr[i]] eq lastlambda then begin
            if posarr[i] lt ndatlinesarr[i]-1 then begin
              posarr[i] = posarr[i] + 1
            end; else begin
;              
;            end
          endif
          printf,loglun,'merge_line_lists: posarr[',i,'] = ',posarr[i],' lower than ndatlinesarr[',i,'] = ',ndatlinesarr[i]
          if templambda gt lambdaarr[i,posarr[i]] then begin
            lastnextsmallest = nextsmallest
            nextsmallest = i
            if nextsmallest ne lastnextsmallest then begin
              printf,loglun,'merge_line_lists: templambda (=',templambda,') gt lambdaarr[',i,',posarr[',i,']=',posarr[i],']=',lambdaarr[i,posarr[i]]
              printf,loglun,'merge_line_lists: nextsmallest = ',nextsmallest
            endif
            templambda = lambdaarr[i,posarr[i]]
          endif
        endif
      endfor
      
      if posarr[nextsmallest] lt ndatlinesarr[nextsmallest] then begin
        printf,loglun,'merge_line_lists: writing outfile: ',lambdaarr[nextsmallest,posarr[nextsmallest]],commentarr[nextsmallest,posarr[nextsmallest]]
        printf,lun,strtrim(string(lambdaarr[nextsmallest,posarr[nextsmallest]]),2)+' '+commentarr[nextsmallest,posarr[nextsmallest]]
        lastlambda = lambdaarr[nextsmallest,posarr[nextsmallest]]
;        if posarr[nextsmallest] lt ndatlinesarr[nextsmallest] - 1 then begin
          posarr[nextsmallest] = posarr[nextsmallest] + 1
        if posarr[nextsmallest] lt ndatlinesarr[nextsmallest] then begin
          templambda = lambdaarr[nextsmallest,posarr[nextsmallest]]
        end else begin
          j = 0UL
          run = 1
          while run eq 1 do begin
            if posarr[j] lt ndatlinesarr[j] then begin
              templambda = lambdaarr[j,posarr[j]]
              run = 0
              printf,loglun,'merge_line_lists: lambdaarr[j=',j,', posarr[',j,']=',posarr[j],' = ',lambdaarr[j,posarr[j]],': setting temprun to ',run
            endif
            j = j+1
            if j eq nfiles then $
              run = 0
          end
        endelse
        printf,loglun,'merge_line_lists: new templambda = ',templambda
        run = 0
        for j=0UL, nfiles-1 do begin
          if posarr[j] lt ndatlinesarr[j] then $
            run = 1
        endfor
      end else begin
        run = 0
      endelse
    end; while run eq 1
  free_lun,lun
  free_lun,loglun
endelse
end
