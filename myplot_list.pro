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
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;###########################
function findmaxlines,filelist
;###########################

if n_params() ne 1 then print,'FINDMAXLINES: No file specified, return 0.' $
else begin
  path = ''
  maxlines = long(0)
  nlines = long(0)
  if strmid(filelist,0,1) eq '/' then begin
    path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)
  endif
  nlines = countlines(filelist)
  openr,lun,filelist,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    tempstr = strtrim(tempstr,2)
    nlines = countlines(path+tempstr)
    if nlines gt maxlines then $
      maxlines = nlines
  endfor
  free_lun,lun
end
return,maxlines
end

;############################
pro myplot_list,list,title,outfile
;############################
;
; NAME:                  myplot_list
; PURPOSE:               * plots a star spectrum with differnt colours for every 
;                          order from <list>
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      myplot_list,<String list>,<String title>,<String outfile>
; INPUTS:                input file: <list>:
;                         science_botzsfx_ec_bld_001.text
;                         science_botzsfx_ec_bld_002.text
;                         science_botzsfx_ec_bld_003.text
;                                            .
;                                            .
;                                            .
;                        title: Image title
;                        outfile: <outfile>.ps
; OUTPUTS:               outfile: PostScriptFile <outfile>.ps
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           12.06.2006
;

if n_elements(outfile) eq 0 then begin
    print,'myplot_list: No ycolumn specified, return 0.'
    print,'myplot_list: Usage: myplot_list,list,title,outfile'
endif else begin

;countlines
    nfiles = countlines(list)
    print,list,': ',nfiles,' Files'

;findmaxlines
    maxlines = findmaxlines(list)
    print,list,': longest file contains ',maxlines,' lines'

;variables
    tempstring = ' '
    dumstring  = ' '
    path       = ''
    value      = 0.
    xtitle     = 'wavelength ['+STRING("305B)+']'
    ytitle     = 'flux [ADUs]'

;build arrays
    xarray = dblarr(nfiles,maxlines)
    yarray = dblarr(nfiles,maxlines)
    nlinesarray = intarr(nfiles)
    orderfilearray = strarr(nfiles)

;look for path
  if strmid(list,0,1) eq '/' then begin
    path = strmid(list,0,strpos(list,'/',/REVERSE_SEARCH)+1)
  endif

;read files from list
    openr,1,list
    for i=0UL,nfiles-1 do begin  
        readf,1,tempstring
        orderfilearray(i) = path+strtrim(tempstring,2)
        nlinesarray(i) = countlines(orderfilearray(i))
        print,'myplot_list: nlinesarray(',i,') = ',nlinesarray(i)
        openr,2,orderfilearray(i)
        for k = 0UL, nlinesarray(i)-1 do begin
            readf,2,tempstring
            dumstring = strtrim(tempstring,2)
            if (strpos(dumstring,' ') ne (-1)) then begin
                value = strmid(dumstring,0,strpos(dumstring,' '))
                dumstring = strtrim(strmid(dumstring,strpos(dumstring,' ')),2)
                xarray(i,k) = value
                value = dumstring
                yarray(i,k) = value
;                print,'myplot_list: xarray(',i,',',k,') = ',xarray(i,k),', yarray(',i,',',k,') = ',yarray(i,k)
            endif else begin
                print,'myplot_list: ERROR: Not enough columns found in file <',+orderfilearray(i)+'>! RETURNING'
            endelse
        endfor
        close,2
    endfor
    close,1
    
;load color table
    loadct,1
    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='colors1.tbl'
    loadct,0,file='colors1.tbl',ncolors=nfiles

    set_plot,'ps'
    device,filename=outfile+'.ps',/color

    xmin = min(xarray)
    xmax = max(xarray)
    ymin = min(yarray)
    ymax = max(yarray)
    xymax = nlinesarray(0) - 1
    plot,xarray(0,0:xymax),yarray(0,0:xymax),xrange=[xmin,xmax],yrange=[ymin,ymax],xtitle=xtitle,ytitle=ytitle,title=title
    for i=1UL,nfiles-1 do begin
        xymax = nlinesarray(i) - 1
        oplot,xarray(i,0:xymax),yarray(i,0:xymax),color=i
    endfor
    device,/close
    set_plot,'x'
    
endelse
end
