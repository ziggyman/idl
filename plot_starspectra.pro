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
pro plot_starspectra,list,xcolumn,ycolumn,title,ytitle,xmin0,xmax0,xmin1,xmax1,xmin2,xmax2,style,print
;############################
;
; NAME:                  plot_starspectra
; PURPOSE:               * plots a spectrum of a star at 4 given ranges
;                          xbin, ybin binned images
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      badpixmaskshow,<String badpixelfile>
; INPUTS:                input file: 'badpixelfile':
;                         1       60      2034    2034
;                         2016    2148    2033    2033
;                         1       2148    1975    1981
;                                            .
;                                            .
;                                            .
;                        outfile: <badpixelrootfilename>.png
; OUTPUTS:               outfile: image <badpixelrootfilename>_4ranges.ps
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           01.03.2006
;

if n_elements(style) eq 0 then begin
    print,'plot_starspectra: Not enougth parameters specified, return 0.'
    print,'plot_starspectra: Usage: plot_starspectra,list:String,xcolumn:int(0,1,...),ycolumn:int(0,1,...),title:String,ytitle:String,xmin0:double,xmax0:double,xmin1:double,xmax1:double,xmin2:double,xmax2:double,style:Enum(log,lin,''),print:String'
    print,"plot_starspectra,'../../comparison_STELLA_and_UVES_pipelines/HD175640_437/combined/HD_combined_orders.text',0,1,'HD175640 (reduced with the STELLA pipeline)','normalized flux',4200.,4500.,4250.,4300.,4271.,4274.5,'log','p'"
    print,"plot_starspectra,'../../comparison_STELLA_and_UVES_pipelines/UVES/hd175640b1.text',0,1,'HD175640 (reduced with the UVES pipeline)','normalized flux',4200.,4500.,4250.,4300.,4271.,4274.5,'log','print'"
endif else begin

    logfile = 'logfile_plot_starspectra.log'
    openw,lun,logfile,/GET_LUN

;countlines
    maxn = countlines(list)
    printf,lun,list,': ',maxn,' DATA LINES'
    
;variables
    tempstring = ' '
    dumstring  = ' '
    value = 0.
    xpmin = 0.
    
;build arrays
    xarray = dblarr(maxn)
    yarray = dblarr(maxn)

;load color table
    loadct,1
;    red   = intarr(256)
;    green = intarr(256)
;    blue  = intarr(256)
;    TVLCT, red, green, blue, /GET
;    for i=0,255 do begin
;        green(i) = blue(255-i)
;    endfor
;    for i=0,255 do begin
;        blue(i) = green(i)
;        green(i) = 0
;    endfor
;    modifyct,0,'blue-red',red,green,blue,file='colors1.tbl'
;    loadct,0,file='colors1.tbl',ncolors=3
    
;read file in arrays
    close,1
    openr,1,list
    for i=0UL,maxn-1 do begin  
        readf,1,tempstring
;        printf,lun,'plot_starspectra: line(',i,') = '+tempstring
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
;            printf,lun,'plot_starspectra: dumstring = '+dumstring
;            printf,lun,'plot_starspectra: value('+string(j)+') = '+string(value)
            
            if (xcolumn eq j) then begin
                xarray(i) = value
;                printf,lun,'plot_starspectra: xarray('+string(i)+') = '+string(xarray(i))
            end else if (ycolumn eq j) then begin
                yarray(i) = value
;                printf,lun,'plot_starspectra: yarray('+string(i)+') = '+string(yarray(i))
            end
            j = j+1
        endrep until (dumstring eq '')
    end  
    close,1  

    x00 = 0UL
    x01 = 0UL
    x02 = 0UL
    x10 = 0UL
    x11 = 0UL
    x12 = 0UL

    printf,lun,'plot_starspectra: starting "for i=1UL,maxn-1 do begin"'
    for i=1UL,maxn-1 do begin
        printf,lun,'plot_starspectra: xarray[',i,'-1] = ',xarray[i-1],', xarray[',i,'] = ',xarray[i]
        printf,lun,'plot_starspectra: xmin0 = ',xmin0,', xmax0 = ',xmax0
        printf,lun,'plot_starspectra: xmin1 = ',xmin1,', xmax1 = ',xmax1
        printf,lun,'plot_starspectra: xmin2 = ',xmin2,', xmax2 = ',xmax2
        if xarray[i-1] lt xmin0 and xarray[i] ge xmin0 then x00 = i
        if xarray[i-1] le xmax0 and xarray[i] gt xmax0 then x10 = i
        if xarray[i-1] lt xmin1 and xarray[i] ge xmin1 then x01 = i
        if xarray[i-1] le xmax1 and xarray[i] gt xmax1 then x11 = i
        if xarray[i-1] lt xmin2 and xarray[i] ge xmin2 then x02 = i
        if xarray[i-1] le xmax2 and xarray[i] gt xmax2 then x12 = i
    endfor
    printf,lun,'plot_starspectra: x00 = ',x00,', x10 = ',x10
    printf,lun,'plot_starspectra: x01 = ',x01,', x11 = ',x11
    printf,lun,'plot_starspectra: x02 = ',x02,', x12 = ',x12

    if n_elements(print) ne 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/reverse_search))+'_4ranges_'+style+'.ps',/color
    endif

    ymin = 0.
    ymax = max(yarray)
    if ymax gt 3. then begin
      ymax = 1.5
    endif
    if ymax lt 10. then begin
      xpmin = 0.1
    endif else if ymax lt 100. then begin
      xpmin = 0.115
    end else if ymax lt 1000. then begin
      xpmin = 0.125
    end else if ymax lt 10000. then begin
      xpmin = 0.14
    end else if ymax lt 100000. then begin
      xpmin = 0.155
    end else if ymax lt 1000000. then begin
      xpmin = 0.17
    end
    printf,lun,'plot_starspectra: ymin = ',ymin,', ymax = ',ymax,', xpmin = ',xpmin
    if style eq 'log' then begin
        plot,xarray,yarray,/ylog,position=[xpmin,0.785,0.97,0.94],title=title,charsize=1.2,xstyle=1,ystyle=1,yticks=1,yrange=[ymin,ymax],ytickformat='(F9.1)'
    end else begin
        plot,xarray,yarray,position=[xpmin,0.785,0.97,0.94],title=title,charsize=1.2,xstyle=1,ystyle=1,yticks=1,yrange=[ymin,ymax],ytickformat='(F9.1)'
    end
    printf,lun,'min(yarray) = ',min(yarray),', max(yarray) = ',max(yarray)
    oplot,[xmin0,xmin0,xmax0,xmax0,xmin0],[min(yarray[x00:x10]),max(yarray[x00:x10]),max(yarray[x00:x10]),min(yarray[x00:x10]),min(yarray[x00:x10])],color=2
    if style eq 'log' then begin
        plot,xarray[x00:x10],yarray[x00:x10],/ylog,position=[xpmin,0.565,0.97,0.71],/noerase,xstyle=1,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end else begin
        plot,xarray[x00:x10],yarray[x00:x10],position=[xpmin,0.565,0.97,0.71],/noerase,xstyle=1,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end
    oplot,[xmin1,xmin1,xmax1,xmax1,xmin1],[min(yarray[x01:x11]),max(yarray[x01:x11]),max(yarray[x01:x11]),min(yarray[x01:x11]),min(yarray[x01:x11])],color=2
    for i=0,19-strlen(ytitle) do begin
        ytitle = ' '+ytitle
    endfor
    if style eq 'log' then begin
        ytitle = ytitle+' (logarithmic scale)'
    end else if style eq 'lin' then begin
        ytitle = ytitle + ' (linear scale)'
    end else begin
        ytitle = '    '+ytitle
    end
    printf,lun,'ytitle = '+ytitle
    if style eq 'log' then begin
        plot,xarray[x01:x11],yarray[x01:x11],/ylog,position=[xpmin,0.34,0.97,0.485],/noerase,xstyle=1,ytitle='!5'+ytitle,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end else begin
        plot,xarray[x01:x11],yarray[x01:x11],position=[xpmin,0.34,0.97,0.485],/noerase,xstyle=1,ytitle=ytitle,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end
    oplot,[xmin2,xmin2,xmax2,xmax2,xmin2],[min(yarray[x02:x12]),max(yarray[x02:x12]),max(yarray[x02:x12]),min(yarray[x02:x12]),min(yarray[x02:x12])],color=2
    if style eq 'log' then begin
        plot,xarray[x02:x12],yarray[x02:x12],/ylog,position=[xpmin,0.115,0.97,0.26],xtitle='wavelength ['+STRING("305B)+']',/noerase,xstyle=1,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end else begin
        plot,xarray[x02:x12],yarray[x02:x12],position=[xpmin,0.115,0.97,0.26],xtitle='wavelength ['+STRING("305B)+']',/noerase,xstyle=1,charsize=1.2,ystyle=1,yticks=1,ytickformat='(F9.1)'
    end
    if n_elements(print) ne 0 then begin
        device,/close
        set_plot,'x'
    endif
    free_lun,lun
endelse
end
