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
pro psfiles_idl,filelist
;############################

if n_elements(filelist) eq 0 then begin
    print,'psfiles_idl: No filelist specified, return 0.'
    print,"psfiles_idl: Usage: psfiles_idl,'filelist'"
endif else begin

    path = ''
    path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)

;countlines
; --- filelist
    maxn = countlines(filelist)
    print,filelist,' contains ',maxn,' files'
; --- lines
    nlines = 0UL
;    maxlines = 0UL

;variables
    tempstring = ' '
    dumstring  = ' '
    value = 0.

;build arrays
    filenamearr = strarr(maxn)
    nlinesarr   = ulonarr(maxn)
;    linearr = strarr(maxn)

;read filelist in filenamearray
    close,1
    openr,1,filelist
    for i=0UL,maxn-1 do begin  
        readf,1,tempstring
        print,'psfiles_idl: line(',i,') = '+tempstring
        dumstring = strtrim(strcompress(tempstring),2)
        filenamearr[i] = path+dumstring
        nlines = countlines(path+dumstring)
        nlinesarr[i] = nlines
;        if nlines gt maxlines then $
;            maxlines = nlines
    end  
    close,1  
    close,2

;    linearr = strarr(maxlines)

; --- read and write lines of ps files
    for i=0UL, maxn-1 do begin
        openr,1,filenamearr[i]
        outfile = strmid(filenamearr[i],0,strpos(filenamearr[i],'.',/REVERSE_SEARCH))+'_changed.ps'
        openw,2,outfile
        k = 0UL
        for j=0UL, (nlinesarr[i]-1) do begin
            readf,1,tempstring
            if strmid(tempstring,0,7) eq '%%Title' then begin
;                print,'psfiles_idl: filenamearr['+string(i)+'] = '+filenamearr[i]
;                print,"psfiles_idl: strpos(filenamearr[i],'/',/REVERSE_SEARCH) returns ",strpos(filenamearr[i],'/',/REVERSE_SEARCH)
;                print,"psfiles_idl: strpos(filenamearr[i],'.',/REVERSE_SEARCH) returns ",strpos(filenamearr[i],'.',/REVERSE_SEARCH)
                dumstring = '%%Title: '+strmid(filenamearr[i],strpos(filenamearr[i],'/',/REVERSE_SEARCH)+1,strpos(filenamearr[i],'.',/REVERSE_SEARCH)-strpos(filenamearr[i],'/',/REVERSE_SEARCH)-1)
                print,'psfiles_idl: printing '+dumstring+' to '+outfile
                printf,2,dumstring
;            end else if strmid(tempstring,0,17) eq '%%PageBoundingBox' then begin
;                dumstring = tempstring
            end else begin
                dumstring = tempstring
;                print,'psfiles_idl: printing '+dumstring+' to '+outfile
                printf,2,dumstring
            end
        endfor
        close,1
        close,2
    endfor
    
endelse
end
