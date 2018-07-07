;############################
pro plot_pipeline_comparisons_paper_piskunov,filelist,legendlist,title,ytitle,xmin,xmax,ymin,ymax,llxmin,lsymax,mode,print
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
;                         uves/hd175640_b1.text
;                         ses/nflat-fit1d_ext-sum/HD175640_botzfxsEcBlDRbtM.text
;                         ses/nflat-fit1d_ext-fit1d/HD175640_botzfxsEcBlDRbtM.text
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
    stop
  endif

    logfile = 'logfile_plot_pipeline_comparisons.log'
    openw,lun,logfile,/GET_LUN

;countlines
    maxn = countlines(filelist)
    legends = countlines(legendlist)
    if maxn ne legends then begin
      print,'plot_pipeline_comparisons: ERROR maxn(=',maxn,') != legends(=',legends,') => STOP'
      stop
    endif
    print,filelist,': ',maxn,' FILES'

;variables
    tempstring = ' '
    dumstring  = ' '
    path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH))
    print,'plot_pipeline_comparisons: path set to <'+path+'>'
    value = 0.
    xpmin = 0.
;    llxmin = 3932.55
;    lsymax = 82000.
    ldy = (ymax-ymin) / 40. * 3.; distance between two legend-lines
    ldymin = (ymax-ymin) / 100.
    ldymax = (ymax-ymin) / 25.; distance sample-line -- upper-legend-line
    ldx = (xmax - xmin) / 25.
    if strpos(filelist,'sky') ge 0 then begin
      lendiv = 2.4
    end else begin
      lendiv = 2.12
    end
    xminpos = 2UL
    xmaxpos = 5UL

;build arrays
    filenames = strarr(maxn)
    legendnames = strarr(maxn)
    psfilename = ' '

;read file in arrays
    openr,rflun,filelist,/GET_LUN
    openr,rllun,legendlist,/GET_LUN
;--- load color table
;    loadct,7,GET_NAMES=colornames,ncolors=maxn+2
    loadct,13,file='colors1.tbl';,GET_NAMES=colornames
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
    readf,rflun,tempstring
    filenames(0) = path+'/'+strtrim(strcompress(tempstring),2)
    print,'plot_pipeline_comparisons: filenames(i='+strtrim(string(0),2)+') = '+filenames(0)
    readf,rllun,tempstring
    legendnames(0) = strtrim(strcompress(tempstring),2)
    print,'plot_pipeline_comparisons: legendnames(i='+strtrim(string(0),2)+') = '+legendnames(0)
    i_npoints = countlines(filenames(0))
    xarray = dblarr(i_npoints)
    xarrayu = dblarr(i_npoints)
    yarray = dblarr(i_npoints)
    syarray = dblarr(maxn,i_npoints)
    ryarray = dblarr(maxn-1,i_npoints)
    data_array = readfiletodblarr(filenames(0))
    xarrayu = data_array(*,0)
    yarray = data_array(*,1)
    if (xarrayu(0) gt xarrayu(1)) then begin
      for j=0ul, i_npoints-1 do begin
        xarray(j) = xarrayu(i_npoints - 1 - j)
        syarray(0,j) = yarray(i_npoints - 1 - j)
      endfor
    end else begin
      xarray = xarrayu
      syarray(i,*) = yarray
    endelse
    xcen = xmin + ((xmax-xmin) / 2.)
    xcenstr = strtrim(string(xcen),2)
    if n_elements(print) ne 0 then begin
      set_plot,'ps'
      psfilename = strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'_'+strmid(xcenstr,0,strpos(xcenstr,'.'))+'.ps'
      print,'plot_pipeline_comparisons_paper_piskunov: psfilename = '+psfilename
      device,filename=psfilename,/color
    endif
    if ymax lt 10. then begin
      xpmin = 0.1
      ytickformat = '(F9.1)'
    endif else if ymax lt 100. then begin
      xpmin = 0.115
      ytickformat = '(F9.0)'
    end else if ymax lt 1000. then begin
      xpmin = 0.13
      ytickformat = '(F9.0)'
    end else if ymax lt 10000. then begin
      xpmin = 0.141
      ytickformat = '(F9.0)'
    end else if ymax lt 100000. then begin
      xpmin = 0.17
      ytickformat = '(F9.0)'
    end else if ymax lt 1000000. then begin
      xpmin = 0.185
      ytickformat = '(F9.0)'
;    end else if ymax lt 1000000. then begin
;      xpmin = 0.185
    end
    if ymin lt -100000. then begin
      xpmin = 0.205
    endif
    print,'plot_pipeline_comparisons_paper_piskunov: ymin = ',ymin,', ymax = ',ymax,', xpmin = ',xpmin
    xmaxpos = (size(yarray))(1) - 3UL
    if strpos(filelist,'sky') ge 0 then begin
      plot,xarray,$
           syarray(0,*),$
           position=[xpmin,0.4,0.99,0.99],$
           title=title,$
           ytitle=ytitle,$
           charsize=1.4,$
           xstyle=1,$
           ystyle=1,$
           xrange=[xmin,xmax],$
           yrange=[ymin,ymax],$
           xticks=1,$
           xtickname=[' ',' '],$
           ytickformat='(F9.0)',$
           color=0,$
           charthick=2;,yticks=4,xtickformat='(F9.2)'
    end else begin
      plot,xarray,$
           syarray(0,*)+2000.,$
           position=[xpmin,0.4,0.99,0.99],$
           title=title,$
           ytitle=ytitle,$
           charsize=1.4,$
           xstyle=1,$
           ystyle=1,$
           xrange=[xmin,xmax],$
           yrange=[ymin,ymax],$
           xticks=1,$
           xtickname=[' ',' '],$
           ytickformat='(F9.0)',$
           color=0,$
           charthick=2;,yticks=4,xtickformat='(F9.2)'
    endelse
    
    ; upper line of legend box
    oplot,[llxmin-((xmax-xmin)/110.),llxmin+(xmax-xmin)/lendiv],[lsymax+ldymax,lsymax+ldymax],color=0
    ; lower line of legend box
    oplot,[llxmin-((xmax-xmin)/110.),llxmin+(xmax-xmin)/lendiv],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax-(ldy*(maxn-1.))-ldymax],color=0
    ; left line of legend box
    oplot,[llxmin-((xmax-xmin)/110.),llxmin-(xmax-xmin)/110.],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax+ldymax],color=0
    ; right line of legend box
    oplot,[llxmin+((xmax-xmin)/lendiv),llxmin+(xmax-xmin)/lendiv],[lsymax-(ldy*(maxn-1.))-ldymax,lsymax+ldymax],color=0
    ; sample line inside legend
    oplot,[llxmin,llxmin+((xmax-xmin)/11.)],[lsymax,lsymax],color=0
    ; legend name
    xyouts,llxmin+((xmax-xmin)/9.),lsymax-ldymin,legendnames(0);,charsize=1.4,charthick=2
;      for l=1UL,maxn-1 do begin
;      endfor
    xarray_interp_new = xarray
    for i=1UL,maxn-1 do begin
      readf,rflun,tempstring
      filenames(i) = path+'/'+strtrim(strcompress(tempstring),2)
      print,'plot_pipeline_comparisons: filenames(i='+strtrim(string(i),2)+') = '+filenames(i)
      readf,rllun,tempstring
      legendnames(i) = strtrim(strcompress(tempstring),2)
      print,'plot_pipeline_comparisons: legendnames(i='+strtrim(string(i),2)+') = '+legendnames(i)
      i_npoints = countlines(filenames(i))
      data_array = readfiletodblarr(filenames(i))
      xarrayu = data_array(*,0)
      yarray = data_array(*,1)
      print,'size(data_array) = ',size(data_array)
      print,'size(xarrayu) = ',size(xarrayu)
      print,'size(yarray) = ',size(yarray)
      print,'size(xarray_interp_new) = ',size(xarray_interp_new)
      
      interp_array = interpol(yarray,xarrayu,xarray_interp_new)
      if (i lt 4) then begin
        if (xarrayu(0) gt xarrayu(1)) then begin
          for j=0ul, i_npoints-1 do begin
            xarray(j) = xarrayu(i_npoints - 1 - j)
            syarray(i,j) = yarray(i_npoints - 1 - j)
          endfor
          yarray_plot = syarray(i,*)
        end else begin
          xarray = xarrayu
;          print,'size(syarray) = ',size(syarray)
;          print,'size(yarray) = ',size(yarray)
          syarray(i,*) = interp_array
          yarray_plot = yarray
        endelse
      
        if i eq 1 then begin
          indarr_plot = where((xarrayu ge xmin) and (xarrayu le xmax))
          mean_yarray_zero = mean(yarray_plot(indarr_plot))
        endif
      end else begin
        xarray = xarrayu
        
        indarr_plot = where((xarrayu ge xmin) and (xarrayu le xmax))
        mean_yarray_i = mean(yarray(indarr_plot))
        print,'mean_yarray_zero = ',mean_yarray_zero
        print,'mean_yarray_i = ',mean_yarray_i

;        stop
        
        yarray_plot = yarray * mean_yarray_zero / mean_yarray_i;* 10. * 1800. / 3100.
        syarray(i,*) = interp_array * mean_yarray_zero / mean_yarray_i
      endelse
      print,'plot_pipeline_comparisons: xarray set to size ',size(xarray)
      if strpos(filelist,'sky') ge 0 then begin
        oplot,xarray,$
              yarray_plot,$
              color=i+3;*(255/(maxn));,yticks=4
      end else begin
        oplot,xarray,$
              yarray_plot+2000.-(2000.*(i/4.)),$
              color=i+3;*(255/(maxn));,yticks=4
      endelse
      
      ; --- create legend
      oplot,[llxmin,llxmin+((xmax-xmin)/11.)],$
            [lsymax-(double(i)*ldy),lsymax-(double(i)*ldy)],$
            color=i+3;*(255/(maxn))
      xyouts,llxmin+((xmax-xmin)/9.),$
             lsymax-(double(i)*ldy)-ldymin,$
             legendnames(i),$
             color=i+3;,charsize=1.4,charthick=2

      if i gt 0 then begin
        if mode eq 'diff' then begin
          ryarray(i-1,*) = syarray(i,*) - syarray(0,*);(xminpos-1:xmaxpos+1)
        end else begin
          ryarray(i-1,*) = syarray(i,*) / syarray(0,*)
          indarr = where(syarray(0,*) eq 0.)
          print,'plot_pipeline_comparsisons_paper_piskunov: i = ',i,', indarr = ',indarr
          print,'plot_pipeline_comparsisons_paper_piskunov: size(ryarray) = ',size(ryarray)
          if indarr(0) gt -1 then $
            ryarray(i-1,indarr) = 0.
        endelse
      endif
    endfor
    print,'plot_pipeline_comparisons_paper_piskunov: min(syarray) = ',min(syarray)
    print,'plot_pipeline_comparisons_paper_piskunov: max(syarray) = ',max(syarray)
    free_lun,rflun
    free_lun,rllun
    ytitle = ' '
    for i = 0UL,maxn-2 do begin
      if i eq 0 then begin
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
        yminb = 0.1;min(ryarray(0:maxn-2,*))
        ymaxb = max(ryarray(0:maxn-2,*))
        print,'yminb set to ',yminb
        print,'ymaxb set to ',ymaxb
        xtickformat = '(F9.0)'
        if mode eq 'diff' then begin
          if strpos(filelist,'sky') ge 0 then begin
            ymaxb = 35.
            yminb = -20.
          endif
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
          if strpos(filelist,'sky') ge 0 then begin
            ymaxb = 2.95
            yminb = -0.01
          end else begin
            if ymaxb gt 1.9 then ymaxb = 1.9
            if yminb lt 0.1 then yminb = 1. - (ymaxb - 1.)
          endelse
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
        print,'yminb set to ',yminb
        print,'ymaxb set to ',ymaxb
        xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]'
        plot,xarray_interp_new,$
             ryarray(i,*),$
             position=[xpmin,0.12,0.99,0.395],$
             title=title,$
             xtitle=xtitle,$
             charsize=1.4,$
             xstyle=1,$
             ystyle=1,$
             xrange=[xmin,xmax],$
             yrange=[yminb,ymaxb],$
             ytickformat=ytickformat,$
             charthick=2,$
             /NOERASE,$
             color=0,$
             xtickformat=xtickformat,$
             ytitle=ytitle;,ytitle='Difference [ADUs]';,yticks=4
      endif
      oplot,xarray_interp_new,$
            ryarray(i,*),$
            color=i+4
    endfor
    if n_elements(print) ne 0 then begin
      device,/close
      set_plot,'x'
      spawn,'ps2gif '+psfilename+' '+strmid(psfilename,0,strpos(psfilename,'.',/REVERSE_SEARCH))+'.gif'
      spawn,'epstopdf '+psfilename
;      spawn,'rm '+psfilename
    endif

    free_lun,lun
end
