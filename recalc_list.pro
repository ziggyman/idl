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
pro recalc_list,inlist,outlist
;############################
;
; NAME:                  recalc_list
; PURPOSE:               multiplys 1st column of <inlist> by 10. and writes result and 2nd column to <outlist>
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      recalc_list,<string 'inlist'>,<string 'outlist'>
; INPUTS:                input file: <inlist>:
;                          1290.0     13.232313
;                          1289.5     14.231451
;                          1289.0     13.142314
;                                            .
;                                            .
;                                            .
; OUTPUTS:               file <outlist>:
;                          3980.0     20.352342
;                          3980.5     20.523422
;                          3981.0     20.532411
;                                            .
;                                            .
;                                            .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           27.10.2006
;

if n_elements(outlist) eq 0 then begin
    print,'recalc_list: No outlist specified, return 0.'
    print,'recalc_list: Usage: recalc_list,inlist,outlist'
endif else begin

;countlines
    maxn = countlines(inlist)
    print,inlist,': ',maxn,' DATA LINES'

;variables
    tempstring = ' '
    dumstring  = ' '
    value = 0.
    tempint = 0
    tempvalue = 0.

;build arrays
    xarray = dblarr(maxn)
    yarray = dblarr(maxn)

;read file in arrays
    openr,lun,inlist,/GET_LUN
    for i=0UL,maxn-1 do begin  
        readf,lun,tempstring
        print,'recalc_list: line(',i,') = '+tempstring
        dumstring = strtrim(strcompress(tempstring),2)
        print,'recalc_list: dumstring = '+dumstring
        repeat begin
            if (strpos(dumstring,' ') eq (-1)) then begin
                value = dumstring
                dumstring = ''
            end else begin
                value = strmid(dumstring,0,strpos(dumstring,' '))
        	print,'recalc_list: value = '+string(value)
                xarray(i) = 10. * value
                print,'recalc_list: xarray('+string(i)+') = '+string(xarray(i))

                dumstring = strtrim(strmid(dumstring,strpos(dumstring,' ')),2)
	        print,'recalc_list: dumstring = '+dumstring
                if (strpos(dumstring,'E') eq (-1)) then begin
                    value = dumstring
                endif else begin
                    value = strmid(dumstring,0,strpos(dumstring,'E'))
                    print,'recalc_list: value = '+string(value)
                    tempint = strmid(dumstring,strpos(dumstring,'E')+1,strlen(dumstring)-strpos(dumstring,'E'))
                    print,'recalc_list: tempint = '+string(tempint)
                    print,'recalc_list: tempint * 10 = '+string(tempint * 10)
                    tempvalue = 1.
                    if (tempint lt 0) then begin
                        while (tempint lt 0) do begin
                            tempvalue = tempvalue / 10.
                            tempint = tempint + 1
                        endwhile
                    end else if (tempint gt 0) then begin
                        while (tempint gt 0) do begin
                            tempvalue = tempvalue * 10.
                            tempint = tempint - 1
                        endwhile
                    end
                    value = value * tempvalue
;                    value = pow(value,tempint)
                end
        	print,'recalc_list: value = '+string(value)
                yarray(i) = value
                print,'recalc_list: yarray('+string(i)+') = '+string(yarray(i))
                dumstring = strtrim(strmid(dumstring,strpos(dumstring,' ')),2)
; --- write outlist
            end
        endrep until (dumstring eq '')
    end  
    free_lun,lun

    openw,lunw,outlist,/GET_LUN
    for i=0UL,maxn-1 do begin
        printf,lunw,FORMAT='(F7.1," ",F13.9)',xarray(maxn-1-i),yarray(maxn-1-i)
    endfor
    free_lun,lunw
    
    
endelse
end
