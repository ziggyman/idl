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
pro remove3rdCol,list
;############################
;
; NAME:                  remove3rdCol.pro
; PURPOSE:               removes the third column from a 3-column list
;                        ('<list>.dat')
;                        and writes first 2 columns to '<list>.text'
; CATEGORY:              data reduction
; CALLING SEQUENCE:      remove3rdCol,'list'
; INPUTS:                input file: list:
;
;                                    lambda1 flux1 fluxerr1
;                                    lambda2 flux2 fluxerr2
;                                             ...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  14.07.2004
;

if n_elements(list) eq 0 then begin
    print,'remove3rdCol: Not enougth parameters specified, return 0.'
    print,'remove3rdCol: Usage: remove3rdCol,list:String'
endif else begin
    
    filename = ''
    tempstring = ''
    path = strmid(list,0,strpos(list,'/',/REVERSE_SEARCH)+1)
    lambdaq = double(0.)
    fluxq   = double(0.)
    errorq = double(0.)

;countlines
    maxn = countlines(list)
    print,list,': ',maxn,' DATA LINES'
    
;read old and write new file
    close,1
    close,2
    close,3
    openr,1,list
    for i=0UL,maxn-1 do begin  
        readf,1,tempstring
        filename = path+strtrim(strcompress(tempstring),2)
	maxm = countlines(filename)
	openr,2,filename
	openw,3,strmid(filename,0,strpos(filename,'.',/REVERSE_SEARCH)+1)+'text'
	for j=0UL,maxm-1 do begin
	    readf,2,lambdaq,fluxq,errorq
	    printf,3,lambdaq,fluxq,FORMAT = '(F15.10, F15.10)'
	endfor
	close,2
	close,3
    end  
    close,1  

endelse
end
