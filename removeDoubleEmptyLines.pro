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
pro removeDoubleEmptyLines,list
;############################
;
; NAME:                  removeDoubleEmptyLines.pro
; PURPOSE:               removes unnecessary lines from wspectext-out
;                        files with header
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      removeDoubleEmptyLines,'RXJ_ctc_head.text.list'
; INPUTS:                input file: 'RXJ_ctc_head.text.list':
;                         RXJ...ctc+h.text
;                                .
;                                .
;                                .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.04.2004
;

if n_elements(list) eq 0 then begin
    print,'removeDoubleEmptyLines: Not enough parameters specified, return 0.'
    print,"USAGE                 : removeDoubleEmptyLines,'../../UVES/ready/red_l/RXJ_ctc_head.text.list'"
endif else begin   
    maxn = countlines(list)

    filearr      = strarr(maxn)
    nlinearr     = intarr(maxn)
    nnewlinesarr = intarr(maxn)
    dumstr       = ''

    maxf = 0

    close,1
    openr,1,list
    for i=0UL,maxn-1 do begin
        readf,1,dumstr
        filearr(i) = strmid(list,0,strpos(list,'/',/reverse_search))+'/'+strtrim(dumstr,2)
        nlinearr(i) = countlines(filearr(i))
        if maxf lt nlinearr(i) then maxf = nlinearr(i)
    endfor
    close,1

    linearr = strarr(i,maxf)
    endfound = 0

    for i=0UL,maxn-1 do begin
        openr,1,filearr(i)
        nemptylines = 0
        for j=0UL,nlinearr(i)-1 do begin
            readf,1,dumstr
            if endfound eq 0 then begin
                linearr(i,j) = dumstr
                print,linearr(i,j)
                nnewlinesarr(i) = nnewlinesarr(i) + 1
                if strmid(dumstr,0,3) eq 'END' then begin
                    endfound = 1
                endif
            endif else begin
                if strmid(dumstr,0,2) eq '  ' then begin
                    nemptylines = nemptylines + 1 
                end else begin
                    linearr(i,j-nemptylines) = dumstr
;                    print,linearr(i,j)
                    nnewlinesarr(i) = nnewlinesarr(i) + 1
                end
            endelse
        endfor
        close,1
    endfor

; --- write new files
    for i=0UL,maxn-1 do begin
        openw,1,filearr(i)
        for j=0UL,nnewlinesarr(i)-1 do begin
            printf,1,linearr(i,j)
        endfor
        close,1
    endfor

endelse
end
