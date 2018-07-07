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
pro myplot_xmin_xmax,list,xcolumn,ycolumn,xmin,xmax
;############################

if n_elements(xmin) eq 0 then xmin = 0.
if n_elements(xmax) eq 0 then xmax = 0.

if n_elements(ycolumn) eq 0 then begin
    print,'myplot_xmin_xmax: No ycolumn specified, return 0.'
    print,'myplot_xmin_xmax: Usage: myplot_xmin_xmax,list,xcolumn,ycolumn,xmin,xmax'
    print,'myplot_xmin_xmax: x- and ycolumn: 0 - (nlines-1)
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
    for i=0,maxn-1 do begin  
        readf,1,tempstring
        print,'myplot_xmin_xmax: line(',i,') = '+tempstring
        dumstring = strtrim(strcompress(tempstring),2)
        j = 0
        repeat begin
            if (strpos(dumstring,' ') eq (-1)) then begin
                value = dumstring
                dumstring = ''
            end else begin
                value = strmid(dumstring,0,strpos(dumstring,' '))
                dumstring = strtrim(strmid(dumstring,strpos(dumstring,' ')),2)
            end
;            print,'myplot_xmin_xmax: dumstring = '+dumstring
;            print,'myplot_xmin_xmax: value('+string(j)+') = '+string(value)

            if (xcolumn eq j) then begin
                xarray(i) = value
                print,'myplot_xmin_xmax: xarray('+string(i)+') = '+string(xarray(i))
            end else if (ycolumn eq j) then begin
                yarray(i) = value
                print,'myplot_xmin_xmax: yarray('+string(i)+') = '+string(yarray(i))
            end
            j = j+1
        endrep until (dumstring eq '')
    end  
    close,1  
    
    if (xmax eq 0.) then begin
        plot,xarray,yarray
    end else begin
        plot,xarray,yarray,xrange=[xmin,xmax]
    end
    
endelse
end
