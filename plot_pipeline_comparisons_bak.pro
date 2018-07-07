;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then begin
  print,'COUNTLINES: No file specified, return 0.'
end else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################
pro plot_pipeline_comparisons,filelist,legendlist,title,ytitle,xmin,xmax,ymin,ymax,llxmin,lsymax,print
;############################
;
; NAME:                  plot_pipeline_comparisons
; PURPOSE:               * plots a list of spectra of the same object
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_pipeline_comparisons,<String filelist>,<String legendlist>,
;                         <String title>,<String ytitle>,<Double xmin>,<Double xmax>,
;                         <Double ymin>,<Double ymax>,<Double llxmin>,<Double lsymax>,<String print>
; INPUTS:                input file: 'filelist':
;                         uves/hd175640_b1.fits
;                         ses/nflat-fit1d_ext-sum/HD175640_botzfxsEcBlDRbtM.fits
;                         ses/nflat-fit1d_ext-fit1d/HD175640_botzfxsEcBlDRbtM.fits
;                                            .
;                                            .
;                                            .
;                        input file: 'legendlist':
;                         UVES pipeline * 1.7
;                         STELLA pipeline: sum
;                                    .
;                                    .
;                                    .
;                        llxmin: xmin for first line in legend
;                        lsymax: ymax for first string in legend
;                        outfile: <filelist_ROOT>.ps
; OUTPUTS:               outfile: image <filelist_ROOT>.ps
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           13.04.2007
;

if n_elements(lsymax) eq 0 then begin
    print,'plot_pipeline_comparisons: Not enougth parameters specified, return 0.'
    print,'plot_pipeline_comparisons: Usage: plot_pipeline_comparisons,<String filelist>,<String legendlist>,<String title>,<String ytitle>,<Double xmin>,<Double xmax>,<Double ymin>,<Double ymax>,<Double llxmin>,<Double lsymax>,<String print>'
endif else begin

    logfile = 'logfile_plot_pipeline_comparisons.log'
    openw,lun,logfile,/GET_LUN

;countlines
    maxn = countlines(filelist)
    legends = countlines(legendlist)
    if maxn ne legends then begin
      printf,lun,'plot_pipeline_comparisons: ERROR maxn(=',maxn,') != legends(=',legends,') => STOP'
      stop
    endif
    printf,lun,filelist,': ',maxn,' FILES'
    
;variables
    tempstring = ' '
    dumstring  = ' '
    path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH))
    printf,lun,'plot_pipeline_comparisons: path set to <'+path+'>'
    value = 0.
    xpmin = 0.
;    llxmin = 3932.55
;    lsymax = 82000.
    ldy = (ymax-ymin) / 40. * 3.; distance between two legend-lines
    ldymin = (ymax-ymin) / 100.
    ldymax = (ymax-ymin) / 25.; distance sample-line -- upper-legend-line
    ldx = (xmax - xmin) / 25.
    lendiv = 2.3
    xminpos = 2UL
    xmaxpos = 5UL
    
;build arrays
    filenames = strarr(maxn)
    legendnames = strarr(maxn)
    xarray = dblarr(1000000)
    xarrayu = dblarr(1000000)
    yarray = dblarr(1000000)
    syarray = dblarr(maxn,1000000)

;read file in arrays
    openr,rflun,filelist,/GET_LUN
    openr,rllun,legendlist,/GET_LUN
;--- load color table
;    loadct,7,GET_NAMES=colornames,ncolors=maxn+2
    loadct,13;,GET_NAMES=colornames
;    print,'colornames: ',colornames
    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for k=0,255 do begin
      green(k) = blue(255-k)
    endfor
    for k=0,255 do begin
      blue(k) = green(k)
      green(k) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='colors1.tbl'
    loadct,0,file='colors1.tbl',ncolors=maxn+3
    for i=0UL,maxn-1 do begin  
      readf,rflun,tempstring
      filenames(i) = path+'/'+strtrim(strcompress(tempstring),2)
      printf,lun,'plot_pipeline_comparisons: filenames(i='+strtrim(string(i),2)+') = '+filenames(i)
      readf,rllun,tempstring
      legendnames(i) = strtrim(strcompress(tempstring),2)
      printf,lun,'plot_pipeline_comparisons: legendnames(i='+strtrim(string(i),2)+') = '+legendnames(i)
      fitsfile = readfits(filenames(i),header)
      printf,lun,'plot_pipeline_comparisons: filenames(i='+strtrim(string(i),2)+') = '+filenames(i)+' read to fitsfile of size ',size(fitsfile)
; --- read dispersion from fits-header
      head=headfits(filenames(i),/COMPRESS)
      printf,lun,'head = ', head
      crvala = 0.
      cdelta = 0.
      crvala=hierarch(head, 'CRVAL1')
      cdelta=hierarch(head, 'CDELT1')
      xmaxpos = (size(fitsfile))(1)-2
      if i lt 2 then begin
        xarray = dblarr((size(fitsfile))(1))
        xarray(0) = crvala
        for j=1UL,(size(fitsfile))(1)-1 do begin
          xarray(j) = xarray(j-1) + cdelta
          if (xarray(j-1) le xmin) and (xarray(j) gt xmin) then xminpos = j
          if (xarray(j-1) le xmax) and (xarray(j) gt xmax) then xmaxpos = j
        endfor
      endif
      printf,lun,'plot_pipeline_comparisons: xarray set to size ',size(xarray)
      if i eq 0 then begin
        xarrayu = xarray
        xcen = xmin + ((xmax-xmin) / 2.)
        xcenstr = strtrim(string(xcen),2)
        if n_elements(print) ne 0 then begin
          set_plot,'ps'
          device,filename=strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'_'+strmid(xcenstr,0,strpos(xcenstr,'.'))+'.ps',/color
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
          xpmin = 0.165
        end else if ymax lt 1000000. then begin
          xpmin = 0.19
;        end else if ymax lt 1000000. then begin
;          xpmin = 0.185
        end
        printf,lun,'plot_pipeline_comparisons: ymin = ',ymin,', ymax = ',ymax,', xpmin = ',xpmin
        yarrayu = fitsfile
        openw,luna,'yarrayu.dat',/GET_LUN
        printf,luna,'size(yarrayu) = ',size(yarrayu),': '
        printf,luna,yarrayu
        free_lun,luna
        xmaxpos = (size(yarrayu))(1) - 3UL
        plot,xarrayu,yarrayu,position=[xpmin,0.4,0.99,0.99],title=title,ytitle=ytitle,charsize=1.4,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[ymin,ymax],xticks=1,xtickname=[' ',' '],ytickformat='(F9.0)',color=i,charthick=2;,yticks=4,xtickformat='(F9.2)'
        ; upper line of legend box
        oplot,[llxmin-((xmax-xmin)/110.),llxmin+(xmax-xmin)/lendiv],[lsymax+ldymax,lsymax+ldymax],color=i
        ; lower line of legend box
        oplot,[llxmin-((xmax-xmin)/110.),llxmin+(xmax-xmin)/lendiv],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax-(ldy*(maxn-1.))-ldymax],color=i
        ; left line of legend box
        oplot,[llxmin-((xmax-xmin)/110.),llxmin-(xmax-xmin)/110.],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax+ldymax],color=i
        ; right line of legend box
        oplot,[llxmin+((xmax-xmin)/lendiv),llxmin+(xmax-xmin)/lendiv],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax+ldymax],color=i
        ; sample line inside legend
        oplot,[llxmin,llxmin+((xmax-xmin)/11.)],[lsymax,lsymax],color=i
        ; legend name
        xyouts,llxmin+((xmax-xmin)/9.),lsymax-ldymin,legendnames(i);,charsize=1.4,charthick=2
;        for l=1UL,maxn-1 do begin
;        endfor
      end else begin
        if i eq 1 then begin
          syarray = dblarr(maxn-1,(size(fitsfile))(1))
        end
        syarray(i-1,*)=fitsfile
        oplot,xarray,syarray(i-1,*),color=i+3;*(255/(maxn));,yticks=4
        oplot,[llxmin,llxmin+((xmax-xmin)/11.)],[lsymax-(double(i)*ldy),lsymax-(double(i)*ldy)],color=i+3;*(255/(maxn))
        xyouts,llxmin+((xmax-xmin)/9.),lsymax-(double(i)*ldy)-ldymin,legendnames(i),color=i+3;,charsize=1.4,charthick=2
      endelse
    end  
    free_lun,rflun  
    free_lun,rllun  
    xarrayout = dblarr((size(xarray))(1))
    rebinstart = 0UL
    rebinend   = 0UL
    rebinstart = max([xarrayu(0),xarray(0)])
    printf,lun,'rebinstart set to ',rebinstart
    rebinend   = min([xarrayu((size(xarrayu))(1)-1),xarray((size(xarray))(1)-1)])
    printf,lun,'rebinend set to ',rebinend
    dlambda    = xarray(1)-xarray(0)
    printf,lun,'dlambda set to ',dlambda
    sarray = dblarr((size(xarray))(1))
    if rebinspectra(xarrayu,xarrayout,yarrayu,sarray,rebinstart,rebinend,dlambda) ne 1 then begin
      stop
    endif
    zeros = where(sarray eq 0.,COMPLEMENT=nozeros)
    openw,luna,'zeros.dat',/GET_LUN
    printf,luna,'size(zeros) = ',size(zeros),': '
    printf,luna,zeros
    free_lun,luna
    if max(sarray) eq 0. then begin
      print,'sarray == 0. => STOP'
      stop
    endif
;    printf,lun,'after rebinspectra: xarrayout set to ',xarrayout
;    printf,lun,'after rebinspectra: sarray set to ',sarray
      printf,lun,'xminpos set to ',size(xminpos),': ',xminpos;,', xminpos((size(xminpos))(1)-1 = ',(size(xminpos))(1)-1,') = ',xminpos((size(xminpos))(1)-1)
      printf,lun,'xmaxpos set to ',size(xmaxpos),': ',xmaxpos;,', xmaxpos((size(xmaxpos))(1)-1 = ',(size(xmaxpos))(1)-1,') = ',xmaxpos((size(xmaxpos))(1)-1)
; use xminpos and xmaxpos to determine yrange in next plot!!!

    for i=0UL,maxn-2 do begin
;      j = 0UL
      printf,lun,'size(xarrayu) = ',size(xarrayu),', size(xarray) = ',size(xarray)
      printf,lun,'size(xarrayout) = ',size(xarrayout)
      printf,lun,'size(syarray) = ',size(syarray),', size(sarray) = ',size(sarray)
      if i eq 0 then begin
        openw,luna,'syarray'+strtrim(string(i),2)+'_before.dat',/GET_LUN
        printf,luna,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
        free_lun,luna
        openw,luna,'sarray.dat',/GET_LUN
        printf,luna,'sarray(xminpos:xmaxpos)) = ',size(sarray(xminpos:xmaxpos)),': ',sarray(xminpos:xmaxpos)
        free_lun,luna
      endif
      if xmaxpos+1 ge (size(sarray))(1) then xmaxpos = xmaxpos - 1
      print,'xminpos = ',xminpos
      print,'xmaxpos = ',xmaxpos
      print,'size(sarray) = ',size(sarray)
      syarray(i,xminpos-1:xmaxpos+1) = syarray(i,xminpos-1:xmaxpos+1) - sarray(xminpos-1:xmaxpos+1)
      if i eq 0 then begin
        openw,luna,'syarray'+strtrim(string(i),2)+'_after.dat',/GET_LUN
        printf,luna,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
        free_lun,luna
      endif
;      syarray(i,xminpos:xmaxpos) = syarray(i,xminpos:xmaxpos) / sarray(xminpos:xmaxpos)
;      syarray(i,nozeros) = syarray(i,nozeros) / sarray(nozeros)
;      syarray(i,zeros) = 1.
;      printf,lun,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
    endfor
    for i = 0UL,maxn-2 do begin
      if i eq 0 then begin
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
        yminb = min(syarray(*,xminpos-1:xmaxpos+1))
        ymaxb = max(syarray(*,xminpos-1:xmaxpos+1))
        print,'yminb set to ',yminb
        print,'ymaxb set to ',ymaxb
        if ymaxb gt 98000. then ymaxb = 98000.
        if yminb lt (0.-98000.) then yminb = 0.-98000.
        print,'yminb set to ',yminb
        print,'ymaxb set to ',ymaxb
        xtickformat = '(F9.0)'
        if (xmax - xmin) lt 10. then xtickformat='(F9.1)'
;        if (xmax - xmin) lt 1. then xtickformat='(F9.1)'
        if (xmax - xmin) lt .1 then xtickformat='(F9.2)'
        if (xmax - xmin) lt .01 then xtickformat='(F9.3)'
        ytickformat = '(F9.0)'
;        if (ymaxb - yminb) lt 10. then ytickformat='(F9.1)'
        if (ymaxb - yminb) lt 1. then ytickformat='(F9.1)'
        if (ymaxb - yminb) lt .1 then ytickformat='(F9.2)'
        if (ymaxb - yminb) lt .01 then ytickformat='(F9.3)'
        plot,xarray,syarray(i,*),position=[xpmin,0.12,0.99,0.395],title=title,xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',ytitle='Difference [ADUs]',charsize=1.4,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[yminb,ymaxb],ytickformat=ytickformat,charthick=2,/NOERASE,color=0,xtickformat=xtickformat;,yticks=4
      endif
      oplot,xarray,syarray(i,*),color=i+3
    endfor
    if n_elements(print) ne 0 then begin
      device,/close
      set_plot,'x'
    endif

    free_lun,lun
  endelse
end
