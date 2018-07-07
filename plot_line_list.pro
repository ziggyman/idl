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
pro plot_line_list,linelist,xmin,xmax,outfile
;############################
;
; NAME:                  plot_line_list
; PURPOSE:               plots line list <linelist> from <xmin> to <xmax> and writes plot to <outfile> (if given)
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_line_list,'linelist'(,xmin,xmax,'outfile')
; INPUTS:                input file: 'linelist':
;                         # units Angstroms
;                         3187.743    HeI
;                         3464.14     AII(70)
;                         3520.5      NeI 3520.472 blend with A 3520.0
;                                            .
;                                            .
;                                            .
;                        xmin: Double
;                              Minimum lambda to plot
;                        xmax: Double
;                              Maximum lambda to plot
; OUTPUTS:               outfile: Path and name of outfile
;                          ps-file
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.11.2006
;

if n_elements(linelist) eq 0 then begin
  print,'PLOT_LINE_LIST: Not enough parameters specified, return 0.'
  print,'PLOT_LINE_LIST: Usage: plot_line_list,<linelist: String>(,<xmin: Double>,<xmax: Double>,<outfile: String>)'
end else begin   

  logfile = 'logfile_plot_line_list.log'
  openw,loglun,logfile,/GET_LUN
  lambdaq = ''
  commentq = ''
  header = ''
  k = 0UL
  plotstartpos = 0UL
  plotendpos = 0UL

;countlines
  nlines = countlines(linelist)
  printf,loglun,'PLOT_LINE_LIST: ',linelist,' contains ',nlines,' LINES'  
  ndatlines = countdatlines(linelist)
  printf,loglun,'PLOT_LINE_LIST: ',linelist,' contains ',ndatlines,' DATA LINES'  

; --- build arrays
  lambdaarr = dblarr(ndatlines)
  commentarr = strarr(ndatlines)
  fluxarr = dblarr(3*ndatlines)
  lambdaplotarr = dblarr(3*ndatlines)

;read files
  openr,lun,linelist,/GET_LUN
  for i=0UL,nlines-1 do begin  
    readf,lun,commentq
    printf,loglun,i,commentq
    commentq = strtrim(commentq,2)
    if strmid(commentq,0,1) eq '#' then begin
      header = strtrim(commentq,2)
;      printf,loglun,'plot_line_list: header = <'+header+'>'
    end else begin
      commentq = strtrim(commentq,2)
      if strpos(commentq,' ') ge 0 then begin
        lambdaq = strmid(commentq,0,strpos(commentq,' '))
        commentq = strmid(commentq,strpos(commentq,' ') + 1)
        commentq = strtrim(commentq,2)
        lambdaarr[k] = lambdaq
        commentarr[k] = commentq
      end else begin
        lambdaarr[k] = commentq
        commentarr[k] = ''
      end
;      printf,loglun,'plot_line_list: lambdaarr[',k,'] = ',lambdaarr[k]
;      printf,loglun,'plot_line_list: commentarr[',k,'] = ',commentarr[k]
      k = k+1
    end
  end  
  free_lun,lun

; --- set plot arrays
  j = 0UL
  for i=0UL,ndatlines-2 do begin
    fluxarr[j] = 0.
    lambdaplotarr[j] = lambdaarr[i] - ((lambdaarr[i+1] - lambdaarr[i]) / 1000.)
    j = j + 1
    fluxarr[j] = 1.
    lambdaplotarr[j] = lambdaarr[i]
    j = j + 1
    fluxarr[j] = 0.
    lambdaplotarr[j] = lambdaarr[i] + ((lambdaarr[i+1] - lambdaarr[i]) / 1000.)
    j = j + 1
  endfor
  fluxarr[j] = 0.
  lambdaplotarr[j] = lambdaarr[i] - ((lambdaarr[i] - lambdaarr[i-1]) / 1000.)
  j = j + 1
  fluxarr[j] = 1.
  lambdaplotarr[j] = lambdaarr[ndatlines-1]
  j = j + 1
  fluxarr[j] = 0.
  lambdaplotarr[j] = lambdaarr[i] + ((lambdaarr[i] - lambdaarr[i-1]) / 1000.)

  if n_elements(xmin) eq 0 then begin
    xmin = lambdaplotarr[0]
    xmax = lambdaplotarr[(3*ndatlines)-1]
  endif
  if n_elements(outfile) ne 0 then begin
    set_plot,'ps'
    device,filename=outfile
  endif
  plot,lambdaplotarr,fluxarr,xrange=[xmin,xmax],yrange=[0.,3.],xstyle=1,ystyle=1,psym=10

; --- find plotstartpos end plotendpos
  while (lambdaarr[plotstartpos] lt xmin) and (plotstartpos lt (ndatlines-1)) do begin
    plotstartpos = plotstartpos+1
  end
  while (lambdaarr[plotendpos] lt xmax) and (plotendpos lt (ndatlines-1)) do begin
    plotendpos = plotendpos+1
  end
  print,'plot_line_list: plotstartpos = ',plotstartpos,', plotendpos = ',plotendpos

  praefix = ''
  for i=plotstartpos,plotendpos do begin
    xyouts,lambdaarr[i],1.1,praefix+strtrim(string(lambdaarr[i]),2)+' '+commentarr[i],charsize=0.8,alignment=0.0,orientation=90
    praefix = praefix+'         '
    if strlen(praefix) gt 30 then $
      praefix = ''
  endfor
  if n_elements(outfile) ne 0 then begin
    device,/close
    set_plot,'x'
  endif

  free_lun,loglun
endelse
end
