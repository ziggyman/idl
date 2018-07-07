;############################
pro plot_pipeline_comparisons,filelist,legendlist,title,ytitle,xmin,xmax,ymin,ymax,llxmin,lsymax,mode,print
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
;                        mode: Enum('ratio','diff')
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
    print,'maxn = ',maxn
    print,'legends = ',legends
    if maxn ne legends then begin
      printf,lun,'plot_pipeline_comparisons: ERROR maxn(=',maxn,') != legends(=',legends,') => STOP'
      free_lun,lun
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
    xarrayu = dblarr(15000000)
    yarray = dblarr(15000000)
    syarray = dblarr(maxn,15000000)
    psfilename = ' '

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
;      head=headfits(filenames(i),/COMPRESS)
      head=headfits(filenames(i));,/COMPRESS)
      printf,lun,'head = ', head
      crvala = 0.
      cdelta = 1.
      if strpos(path,'REDUCE') lt 0 then begin
        crvala=hierarch(head, 'CRVAL1')
        cdelta=hierarch(head, 'CDELT1')
      endif
      print,'crvala = ',crvala
      print,'cdelta = ',cdelta
      xmaxpos = (size(fitsfile))(1)-2
      if i lt 2 then begin
        xarray = dblarr((size(fitsfile))(1))
        xarray(0) = crvala
        lambda = crvala
        for j=1UL,(size(fitsfile))(1)-1 do begin
          lambda = lambda + cdelta
          xarray(j) = lambda
;          print,'xarray(j=',j,') set to ',xarray(j)
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
          psfilename = strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'_'+strmid(xcenstr,0,strpos(xcenstr,'.'))+'.ps'
          device,filename=psfilename,/color
        endif
        if ymax lt 10. then begin
          xpmin = 0.1
          ytickformat = '(F9.1)'
        endif else if ymax lt 100. then begin
          xpmin = 0.115
          ytickformat = '(F9.0)'
        end else if ymax lt 1000. then begin
          xpmin = 0.125
          ytickformat = '(F9.0)'
        end else if ymax lt 10000. then begin
          xpmin = 0.14
          ytickformat = '(F9.0)'
        end else if ymax lt 100000. then begin
          xpmin = 0.17
          ytickformat = '(F9.0)'
        end else if ymax lt 1000000. then begin
          xpmin = 0.185
          ytickformat = '(F9.0)'
;        end else if ymax lt 1000000. then begin
;          xpmin = 0.185
        end
        if ymin lt -100000. then begin
          xpmin = 0.205
        endif
        printf,lun,'plot_pipeline_comparisons: ymin = ',ymin,', ymax = ',ymax,', xpmin = ',xpmin
        yarrayu = dblarr((size(fitsfile))(1))
        if cdelta eq 1. then begin
          for iind=0,(size(fitsfile))(1)-1 do begin
            yarrayu(iind) = fitsfile((size(fitsfile))(1)-1-iind)
          endfor
          lendiv = 3.1
        endif else begin
          yarrayu(0:(size(fitsfile))(1)-1) = fitsfile
        endelse
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
        syarray(i-1,0:(size(fitsfile))(1)-1)=fitsfile(*)
        print,'size(syarray(',i-1,',*)) = ',size(syarray(i-1,*))
        oplot,xarray(0:(size(syarray(i-1,*)))(2)-1),syarray(i-1,*),color=i+3;*(255/(maxn));,yticks=4
        oplot,[llxmin,llxmin+((xmax-xmin)/11.)],[lsymax-(double(i)*ldy),lsymax-(double(i)*ldy)],color=i+3;*(255/(maxn))
        xyouts,llxmin+((xmax-xmin)/9.),lsymax-(double(i)*ldy)-ldymin,legendnames(i),color=i+3;,charsize=1.4,charthick=2
      endelse
    end
    free_lun,rflun
    free_lun,rllun
    xarrayout = dblarr((size(xarray))(1))
    if cdelta ne 1. then begin
      rebinstart = 0UL
      rebinend   = 0UL
      rebinstart = max([xarrayu(0),xarray(0),xmin-1])
      print,'rebinstart set to ',rebinstart
      xuzeros = where(xarrayu le 0.)
      print,'xuzeros = ',size(xuzeros),': ',xuzeros
      if (size(xuzeros))(0) ne 0 then xarrayu(xuzeros) = 1.
      xzeros = where(xarray le 0.)
      print,'xzeros = ',size(xzeros);,': ',xzeros
      print,'xmax = ',xmax
      rebinend   = min([xarrayu((size(xarrayu))(1)-1),xarray((size(xarray))(1)-1),xmax+1])
      print,'rebinend set to ',rebinend
      dlambda    = xarray(1)-xarray(0)
      printf,lun,'dlambda set to ',dlambda
      ustartpos = 0UL
      uendpos   = (size(xarrayu))(1)-1
      ustart = rebinstart
      uend   = rebinend
      nxstartpos = 0UL
      nxendpos   = (size(xarray))(1)-1
      nu = 0UL
      nx = 0UL
      nstart = rebinstart
      nend   = rebinend
      for i=1UL,(size(xarrayu))(1)-1 do begin
        if xarrayu(i-1) lt rebinstart and xarrayu(i) ge rebinstart then begin
          ustartpos = i
          ustart = xarrayu(i)
        endif
        if xarrayu(i-1) lt rebinend and xarrayu(i) ge rebinend then begin
          uendpos = i
          uend = xarrayu(i)
        endif
        if ustartpos ne 0 and uendpos eq 0 then begin
          nu = nu+1
        endif
      endfor
      print,'ustartpos set to ',ustartpos
      print,'uendpos set to ',uendpos
      for i=1UL,(size(xarray))(1)-1 do begin
        if xarray(i-1) lt max([rebinstart,ustart]) and xarray(i) ge max([rebinstart,ustart]) then begin
          nxstartpos = i
          nstart = xarray(i)
        endif
        if xarray(i-1) lt min([rebinend,uend]) and xarray(i) ge min([rebinend,uend]) then begin
          nxendpos = i
          nend = xarray(i)
        endif
        if nxstartpos ne 0 and nxendpos eq 0 then begin
          nx = nx+1
        endif
      endfor
      print,'nxstartpos set to ',nxstartpos
      print,'nxendpos set to ',nxendpos
      spos = dblarr(nxendpos-nxstartpos+1)
      j = ustartpos
      for i=0UL,nxendpos-nxstartpos do begin
        while xarray(i+nxstartpos) lt xarrayu(j) do begin
          j = j + 1
          if j ge (size(xarrayu))(1) then break
        end
;      printf,lun,'xarray(i=',i,'+nxstartpos=',nxstartpos,')=',xarray(i+nxstartpos),', xarrayu(j=',j,')=',xarrayu(j),', xarrayu(j+1)=',xarrayu(j+1)
        spos(i) = (xarray(nxstartpos+i) - xarrayu(j)) / (xarrayu(j+1) - xarrayu(j))
      endfor
;    openw,luna,'spos.dat',/GET_LUN
;    printf,luna,'size(spos) = ',size(spos),': '
;    printf,luna,spos
;    free_lun,luna
;    openw,luna,'yarrayu.dat',/GET_LUN
;    printf,luna,'size(yarrayu(ustartpos=',ustartpos,':uendpos=',uendpos,') = ',size(yarrayu(ustartpos:uendpos)),': '
;    printf,luna,yarrayu(ustartpos:uendpos)
;    free_lun,luna
;    for i=0UL,999 do begin
;      if i eq 0 then begin
          print,'ustartpos = ',ustartpos
          print,'uendpos = ',uendpos
          print,'size(yarrayu) = ',size(yarrayu)
          sarray = interpolate(yarrayu(ustartpos:uendpos),spos)
;      end else begin
;        sarray = [sarray,interpolate(yarrayu(ustartpos]
;      end
;    endfor
;    sarray = dblarr((size(xarray))(1))

;    if rebinspectra(xarrayu,xarrayout,yarrayu,sarray,rebinstart,rebinend,dlambda) ne 1 then begin
;      stop
;    endif
      zeros = where(sarray eq 0.,COMPLEMENT=nozeros)
      openw,luna,'zeros.dat',/GET_LUN
      printf,luna,'size(zeros) = ',size(zeros),': '
      printf,luna,zeros
      free_lun,luna
;     openw,luna,'nozeros.dat',/GET_LUN
;     printf,luna,'size(nozeros) = ',size(nozeros),': '
;     printf,luna,nozeros
;     free_lun,luna
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
;       j = 0UL
        printf,lun,'size(xarrayu) = ',size(xarrayu),', size(xarray) = ',size(xarray)
        printf,lun,'size(xarrayout) = ',size(xarrayout)
        printf,lun,'size(syarray) = ',size(syarray),', size(sarray) = ',size(sarray)
;      if i eq 0 then begin
;        openw,luna,'syarray'+strtrim(string(i),2)+'_before.dat',/GET_LUN
;        printf,luna,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
;        free_lun,luna
;        openw,luna,'sarray.dat',/GET_LUN
;        printf,luna,'sarray(xminpos:xmaxpos)) = ',size(sarray),': ',sarray
;        free_lun,luna
;      endif

        if mode eq 'diff' then begin
          syarray(i,nxstartpos:nxendpos) = syarray(i,nxstartpos:nxendpos) - sarray;(xminpos-1:xmaxpos+1)
        end else begin

;      if i eq 0 then begin
;        openw,luna,'syarray'+strtrim(string(i),2)+'_after.dat',/GET_LUN
;        printf,luna,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
;        free_lun,luna
;      endif

          if (size(zeros))(0) ne 0 then sarray(zeros) = 1000000.
          syarray(i,nxstartpos:nxendpos) = syarray(i,nxstartpos:nxendpos) / sarray
;      (syarray(i,nxstartpos:nxendpos))(nozeros) = (syarray(i,nxstartpos:nxendpos))(nozeros) / sarray(nozeros)
;        syarray(i,nozeros) = syarray(i,nozeros) / sarray(nozeros)
;        if (size(zeros))(0) ne 0 then (syarray(i,nxstartpos:nxendpos))(zeros) = 1.
        end
;      printf,lun,'syarray(i,xminpos:xmaxpos)) = ',size(syarray(i,xminpos:xmaxpos)),': ',syarray(i,xminpos:xmaxpos)
      endfor
    endif
    ytitle = ' '
    for i = 0UL,maxn-2 do begin
      if cdelta eq 1. then begin
        print,'size(yarray) = ',size(yarray)
        print,'size(syarray) = ',size(syarray)
;        zeros = where(syarray(i,*) le 0.)
;        print,'size(zeros) = ',size(zeros)
;        syarray(i,zeros) = 1.
        zeros = where(yarrayu le 0.)
        print,'size(zeros) = ',size(zeros)
        if (size(zeros))(0) ne 0 then $
          yarrayu(zeros) = syarray(i,zeros)
        syarray(i,0:(size(syarray))(2)-1) = syarray(i,0:(size(syarray))(2)-1) / yarrayu(0:(size(syarray))(2)-1)
        nxstartpos = xmin
        nxendpos   = xmax
      endif
      if i eq 0 then begin
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
        yminb = min(syarray(*,nxstartpos:nxendpos))
        ymaxb = max(syarray(*,nxstartpos:nxendpos))
        printf,lun,'yminb set to ',yminb
        printf,lun,'ymaxb set to ',ymaxb
        xtickformat = '(F9.0)'
        if mode eq 'diff' then begin
          if ymaxb gt 40000. then ymaxb = 39000.
          if yminb lt (0.-40000.) then yminb = 0.-39000.
          ytitle = 'Difference [ADUs]'
          if (xmax - xmin) lt 10. then xtickformat='(F9.1)'
;        if (xmax - xmin) lt 1. then xtickformat='(F9.1)'
          if (xmax - xmin) lt .1 then xtickformat='(F9.2)'
          if (xmax - xmin) lt .01 then xtickformat='(F9.3)'
          ytickformat = '(F9.0)'
;        if (ymaxb - yminb) lt 10. then ytickformat='(F9.1)'
          if (ymaxb - yminb) lt 1. then ytickformat='(F9.1)'
          if (ymaxb - yminb) lt .1 then ytickformat='(F9.2)'
          if (ymaxb - yminb) lt .01 then ytickformat='(F9.3)'
          if (ymaxb - yminb) lt .001 then ytickformat='(F9.4)'
          if (ymaxb - yminb) lt .0001 then ytickformat='(F9.5)'
        end else begin
          if ymaxb gt 1.9 then ymaxb = 1.9
          if yminb lt 0.1 then yminb = 1. - (ymaxb - 1.)
          if cdelta eq 1. then begin
            if ymaxb gt 1.003 then ymaxb = 1.003
            if yminb lt 0.98 then yminb = 0.98
          endif
          ytitle = 'Ratio'
          if (xmax - xmin) lt 10. then xtickformat='(F9.1)'
          if (xmax - xmin) lt 1. then xtickformat='(F9.1)'
          if (xmax - xmin) lt .1 then xtickformat='(F9.2)'
          if (xmax - xmin) lt .01 then xtickformat='(F9.3)'
          ytickformat = '(F9.0)'
          print,'yminb = ',yminb,', ymaxb = ',ymaxb,', ymaxb-yminb = ',ymaxb-yminb
          if (ymaxb - yminb) lt 10. then ytickformat='(F9.1)'
          if (ymaxb - yminb) lt 1. then ytickformat='(F9.2)'
          if (ymaxb - yminb) lt .1 then ytickformat='(F9.2)'
          if (ymaxb - yminb) lt .035 then ytickformat='(F9.3)'
          if (ymaxb - yminb) lt .004 then ytickformat='(F9.4)'
          if (ymaxb - yminb) lt .0004 then ytickformat='(F9.5)'
        end
        printf,lun,'yminb set to ',yminb
        printf,lun,'ymaxb set to ',ymaxb
        xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]'
        if cdelta eq 1. then xtitle = 'Pixel'
        plot,xarray,syarray(i,*),position=[xpmin,0.12,0.99,0.395],title=title,xtitle=xtitle,charsize=1.4,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[yminb,ymaxb],ytickformat=ytickformat,charthick=2,/NOERASE,color=0,xtickformat=xtickformat,ytitle=ytitle;,ytitle='Difference [ADUs]';,yticks=4
      endif
      oplot,xarray,syarray(i,*),color=i+4
    endfor
    if n_elements(print) ne 0 then begin
      device,/close
      set_plot,'x'
      spawn,'epstopdf '+psfilename
      spawn,'rm '+psfilename
    endif

    free_lun,lun
  endelse
end
