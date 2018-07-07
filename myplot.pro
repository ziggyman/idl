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
pro myplot,list,xcolumn,ycolumn,title,xtitle,ytitle,print
;############################

if n_elements(ycolumn) eq 0 then begin
    print,'myplot: No ycolumn specified, return 0.'
    print,'myplot: Usage: myplot,list,xcolumn,ycolumn'
    print,'myplot: x- and ycolumn: 0 - (nlines-1)'
endif else begin

;countlines
    maxn = countlines(list)
    print,list,': ',maxn,' DATA LINES'

;variables
    tempstring = ' '
    dumstring  = ' '
    value = 0.

;build arrays
    xarray = dblarr(maxn)
    yarray = dblarr(maxn)

;read file in arrays
    close,1
    openr,1,list
    for i=0UL,maxn-1 do begin  
        readf,1,tempstring
;        print,'myplot: line(',i,') = '+tempstring
        dumstring = strtrim(strcompress(tempstring),2)
        j = 0UL
        repeat begin
            if (strpos(dumstring,' ') eq (-1)) then begin
                value = dumstring
                dumstring = ''
            end else begin
                value = strmid(dumstring,0,strpos(dumstring,' '))
                dumstring = strtrim(strmid(dumstring,strpos(dumstring,' ')),2)
            end
;            print,'myplot: dumstring = '+dumstring
;            print,'myplot: value('+string(j)+') = '+string(value)

            if (xcolumn eq j) then begin
                xarray(i) = value
;                print,'myplot: xarray('+string(i)+') = '+string(xarray(i))
            end else if (ycolumn eq j) then begin
                yarray(i) = value
;                print,'myplot: yarray('+string(i)+') = '+string(yarray(i))
            end
            j = j+1
        endrep until (dumstring eq '')
    end  
    close,1  

; --- plot
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH)+1)+'ps',/color
    endif
    plot,xarray,yarray,xtitle=xtitle,ytitle=ytitle,title=title
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif
    
endelse
end
