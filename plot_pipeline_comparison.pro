;############################
pro plot_pipeline_comparison,filelist,legendlist,layoutlist
;############################
;
; NAME:                  plot_pipeline_comparison
; PURPOSE:               * plots a list of spectra of the same object
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_pipeline_comparison,<String filelist>,<String legendlist>,<String layoutlist>
; INPUTS:                input file: 'filelist':
;                         uves/hd175640_b1.fits
;                                ....
;                        input file: 'legendlist':
;                         UVES pipeline
;                           ...
;                        input file: 'layoutlist':
;                          #xmin,xmax,ymin,ymax,llxmin,lsymax
;                          3720. 4998. -125000. 285000. 4108. 45000.
;                                            .
;                                            .
;                                            .
;                        llxmin: xmin for first line in legend
;                        lsymax: ymax for first string in legend
; OUTPUTS:               outfile: image <filelist_ROOT>xmin-xmax.pdf
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           07.05.2007
;

if n_elements(layoutlist) eq 0 then begin
  print,'plot_pipeline_comparison: Not enougth parameters specified, return 0.'
  print,'plot_pipeline_comparison: Usage: plot_pipeline_comparison,<String filelist>,<String legendlist>,<String layoutlist>'
endif else begin

  logfile = 'logfile_plot_pipeline_comparison.log'
  openw,lun,logfile,/GET_LUN

;countlines
  maxn = countlines(filelist)
  maxl = countlines(legendlist)
  maxll = countlines(layoutlist)
  maxld = countdatlines(layoutlist)
  print,filelist,': ',maxn,' Files and ',maxld,' Layouts'

;variables
  tempstring = ' '
  dumstring  = ' '
  path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH))
  print,'plot_pipeline_comparison: path set to <'+path+'>'
  value = 0.
  xpmin = 0.
;    llxmin = 3932.55
;    lsymax = 82000.

;build arrays
  filenames = strarr(maxn)
  legendnames = strarr(maxn)
  xmins = dblarr(maxld)
  xmaxs = dblarr(maxld)
  ymins = dblarr(maxld)
  ymaxs = dblarr(maxld)
  llxmins = dblarr(maxld)
  lsymaxs = dblarr(maxld)
;  xminposu = dblarr(maxld)
;  xmaxposu = dblarr(maxld)
;  xminpos = dblarr(maxld)
;  xmaxpos = dblarr(maxld)

  psfilename = ' '

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

;read file in arrays
  openr,rflun,filelist,/GET_LUN
  openr,rllun,legendlist,/GET_LUN
  for i=0UL,maxn-1 do begin
    readf,rflun,tempstring
    filenames(i) = path+'/'+strtrim(strcompress(tempstring),2)
    print,'plot_pipeline_comparison: filenames(i='+strtrim(string(i),2)+') = '+filenames(i)
    readf,rllun,tempstring
    legendnames(i) = strtrim(strcompress(tempstring),2)
    print,'plot_pipeline_comparison: legendnames(i='+strtrim(string(i),2)+') = '+legendnames(i)
  endfor
  free_lun,rflun
  free_lun,rllun

  openr,rdlun,layoutlist,/GET_LUN
  dline = 0UL
  for i=0UL,maxll-1 do begin
    readf,rdlun,tempstring
    tempstring = strtrim(strcompress(tempstring),2)
    if strmid(tempstring,0,1) ne '#' then begin
      print,'line read from layouts: '+tempstring
      xmins(dline) = double(strtrim(strmid(tempstring,0,strpos(tempstring,' ')),2))
      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      xmaxs(dline) = double(strtrim(strmid(tempstring,0,strpos(tempstring,' ')),2))
      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      ymins(dline) = double(strtrim(strmid(tempstring,0,strpos(tempstring,' ')),2))
      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      ymaxs(dline) = double(strtrim(strmid(tempstring,0,strpos(tempstring,' ')),2))
      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      llxmins(dline) = double(strtrim(strmid(tempstring,0,strpos(tempstring,' ')),2))
      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      lsymaxs(dline) = double(strtrim(strmid(tempstring,0),2))
;      tempstring = strtrim(strmid(tempstring,strpos(tempstring,' ')),2)
      dline = dline+1
    endif
  endfor
  free_lun,rdlun

; --- read fitsfile to compare with others
  tempfitsfile = readfits(filenames(0),header)
  xarrayu = dblarr((size(tempfitsfile))(1))
  yarrayu = tempfitsfile
  head=headfits(filenames(0),/COMPRESS)
;  print,'head = ', head
  crvala = 0.
  cdelta = 0.
  crvala=hierarch(head, 'CRVAL1')
  cdelta=hierarch(head, 'CDELT1')
  print,'crvala = ',crvala
  print,'cdelta = ',cdelta
  xarrayu(0) = crvala
  lambda = crvala
;  for j=0UL, maxld-1 do begin
;    xmaxpos(j) = (size(tempfitsfile))(1)-2
;  endfor
  for k=1UL,(size(tempfitsfile))(1)-1 do begin
    lambda = lambda + cdelta
    xarrayu(k) = lambda
;    print,'xarrayu(k=',k,') set to ',xarrayu(k)
;    for j=0UL, maxld-1 do begin
;      if (xarrayu(k-1) le xmins(j)) and (xarrayu(k) gt xmins(j)) then xminposu(j) = k
;      if (xarrayu(k-1) le xmaxs(j)) and (xarrayu(k) gt xmaxs(j)) then xmaxposu(j) = k
;    endfor
  endfor
  print,'plot_pipeline_comparison: xarrayu set to size ',size(xarrayu)

; --- read other fitsfiles
  tempfitsfile = readfits(filenames(1),header)
  xarray = dblarr((size(tempfitsfile))(1))
  syarray = dblarr(maxn-1,(size(tempfitsfile))(1))
  syarrayr = dblarr(maxn-1,(size(tempfitsfile))(1))
  syarray(0,*) = tempfitsfile
  head=headfits(filenames(1),/COMPRESS)
;  print,'head = ', head
  crvala = 0.
  cdelta = 0.
  crvala=hierarch(head, 'CRVAL1')
  cdelta=hierarch(head, 'CDELT1')
  print,'crvala = ',crvala
  print,'cdelta = ',cdelta
  xarray(0) = crvala
  lambda = crvala
  for k=1UL,(size(tempfitsfile))(1)-1 do begin
    lambda = lambda + cdelta
    xarray(k) = lambda
  endfor
  for i=1UL, maxn-2 do begin
    fitsfile = readfits(filenames(i+1),header)
    syarray(i,0:(size(fitsfile))(1)-1) = fitsfile
  endfor
  print,'plot_pipeline_comparison: syarray set to size ',size(syarray)

; --- loop through layouts
  for i=0UL,maxld-1 do begin
    ldy = (ymaxs(i)-ymins(i)) / 40. * 3.; distance between two legend-lines
    ldymin = (ymaxs(i)-ymins(i)) / 100.
    ldymax = (ymaxs(i)-ymins(i)) / 25.; distance sample-line -- upper-legend-line
    ldx = (xmaxs(i) - xmins(i)) / 25.
    lendiv = 2.3

;    for j=0UL,maxn-1 do begin
;      fitsfile = readfits(filenames(j),header)
;      printf,lun,'plot_pipeline_comparison: filenames(j='+strtrim(string(j),2)+') = '+filenames(j)+' read to fitsfile of size ',size(fitsfile)
; --- read dispersion from fits-header
;      if j eq 0 then begin
    xcen = xmins(i) + ((xmaxs(i)-xmins(i)) / 2.)
    xcenstr = strtrim(string(xcen),2)
    print,'xcen = ',xcen,', xcenstr = <',xcenstr,'>'
    set_plot,'ps'
    psfilename = strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'_'+strmid(xcenstr,0,strpos(xcenstr,'.'))+'.ps'
    device,filename=psfilename,/color
    if ymaxs(i) lt 10. then begin
      xpmin = 0.1
    endif else if ymaxs(i) lt 100. then begin
      xpmin = 0.115
    end else if ymaxs(i) lt 1000. then begin
      xpmin = 0.125
    end else if ymaxs(i) lt 10000. then begin
      xpmin = 0.14
    end else if ymaxs(i) lt 100000. then begin
      xpmin = 0.17
    end else if ymaxs(i) lt 1000000. then begin
      xpmin = 0.185
;        end else if ymax lt 1000000. then begin
;          xpmin = 0.185
    end
    if ymins(i) lt -100000. then begin
      xpmin = 0.205
    endif
    print,'plot_pipeline_comparison: ymins(i) = ',ymins(i),', ymaxs(i) = ',ymaxs(i),', xpmin = ',xpmin
    plot,xarrayu,yarrayu,position=[xpmin,0.4,0.99,0.99],ytitle='FLUX [ADUs]',charsize=1.4,xstyle=1,ystyle=1,xrange=[xmins(i),xmaxs(i)],yrange=[ymins(i),ymaxs(i)],xticks=1,xtickname=[' ',' '],ytickformat='(F9.0)',color=0,charthick=2;,yticks=4,xtickformat='(F9.2)'
    ; upper line of legend box
    oplot,[llxmins(i)-((xmaxs(i)-xmins(i))/110.),llxmins(i)+(xmaxs(i)-xmins(i))/lendiv],[lsymaxs(i)+ldymax,lsymaxs(i)+ldymax],color=0
    ; lower line of legend box
    oplot,[llxmins(i)-((xmaxs(i)-xmins(i))/110.),llxmins(i)+(xmaxs(i)-xmins(i))/lendiv],[lsymaxs(i)-(ldy*(maxn-1.))-ldymax,lsymaxs(i)-(ldy*(maxn-1.))-ldymax],color=0
    ; left line of legend box
    oplot,[llxmins(i)-((xmaxs(i)-xmins(i))/110.),llxmins(i)-(xmaxs(i)-xmins(i))/110.],[lsymaxs(i)-(ldy*(maxn-1.))-ldymax,lsymaxs(i)+ldymax],color=0
    ; right line of legend box
    oplot,[llxmins(i)+((xmaxs(i)-xmins(i))/lendiv),llxmins(i)+(xmaxs(i)-xmins(i))/lendiv],[lsymaxs(i)-(ldy*(maxn-1.))-ldymax,lsymaxs(i)+ldymax],color=0
    ; sample line inside legend
    oplot,[llxmins(i),llxmins(i)+((xmaxs(i)-xmins(i))/11.)],[lsymaxs(i),lsymaxs(i)],color=0
    ; legend name
    xyouts,llxmins(i)+((xmaxs(i)-xmins(i))/9.),lsymaxs(i)-ldymin,legendnames(0);,charsize=1.4,charthick=2
    ytitle = ' '
    ; --- loop through spectra
    for j=0UL, maxn-2 do begin
      print,'plotting spectrum '+legendnames(j+1)
      oplot,xarray,syarray(j,*),color=j+4;*(255/(maxn));,yticks=4
      oplot,[llxmins(i),llxmins(i)+((xmaxs(i)-xmins(i))/11.)],[lsymaxs(i)-(double(j+1)*ldy),lsymaxs(i)-(double(j+1)*ldy)],color=j+4;*(255/(maxn))
      xyouts,llxmins(i)+((xmaxs(i)-xmins(i))/9.),lsymaxs(i)-(double(j+1)*ldy)-ldymin,legendnames(j+1),color=j+4;,charsize=1.4,charthick=2
    endfor
    for j=0UL, maxn-2 do begin
      print,'size(xarrayu) = ',size(xarrayu),', size(xarray) = ',size(xarray)
      print,'size(xarrayout) = ',size(xarrayout)
      print,'size(syarray) = ',size(syarray),', size(sarray) = ',size(sarray)

; --- rebin 1st spectrum to compare with others
      if j eq 0 then begin
        xarrayout = dblarr((size(xarray))(1))
        rebinstart = 0UL
        rebinend   = 0UL
        rebinstart = max([xarrayu(0),xarray(0),xmins(i)-1])
        print,'rebinstart set to ',rebinstart
        xuzeros = where(xarrayu le 0.)
        print,'xuzeros = ',size(xuzeros),': ',xuzeros
        xzeros = where(xarray le 0.)
        print,'xzeros = ',size(xzeros);,': ',xzeros
        print,'xmaxs(i) = ',xmaxs(i)
        rebinend   = min([xarrayu((size(xarrayu))(1)-1),xarray((size(xarray))(1)-1),xmaxs(i)+1])
        print,'rebinend set to ',rebinend
        dlambda    = xarray(1)-xarray(0)
        print,'dlambda set to ',dlambda
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
        for k=1UL,(size(xarrayu))(1)-1 do begin
          if xarrayu(k-1) lt rebinstart and xarrayu(k) ge rebinstart then begin
            ustartpos = k
            ustart = xarrayu(k)
          endif
          if xarrayu(k-1) lt rebinend and xarrayu(k) ge rebinend then begin
            uendpos = k
            uend = xarrayu(k)
          endif
          if ustartpos ne 0 and uendpos eq 0 then begin
            nu = nu+1
          endif
        endfor
        print,'ustartpos set to ',ustartpos
        print,'uendpos set to ',uendpos
        for k=1UL,(size(xarray))(1)-1 do begin
          if xarray(k-1) lt max([rebinstart,ustart]) and xarray(k) ge max([rebinstart,ustart]) then begin
            nxstartpos = k
            nstart = xarray(k)
          endif
          if xarray(k-1) lt min([rebinend,uend]) and xarray(k) ge min([rebinend,uend]) then begin
            nxendpos = k
            nend = xarray(k)
          endif
          if nxstartpos ne 0 and nxendpos eq 0 then begin
            nx = nx+1
          endif
        endfor
        print,'nxstartpos set to ',nxstartpos
        print,'nxendpos set to ',nxendpos
        spos = dblarr(nxendpos-nxstartpos+1)
        k = ustartpos
        for l=0UL,nxendpos-nxstartpos do begin
          while xarray(l+nxstartpos) lt xarrayu(k) do begin
            k = k + 1
            print,'while: k set to ',k
            if k ge (size(xarrayu))(1) then break
          end
;    printf,lun,'xarray(i=',i,'+nxstartpos=',nxstartpos,')=',xarray(i+nxstartpos),', xarrayu(j=',j,')=',xarrayu(j),', xarrayu(j+1)=',xarrayu(j+1)
          spos(l) = (xarray(nxstartpos+l) - xarrayu(k)) / (xarrayu(k+1) - xarrayu(k))
        endfor
        print,'interpolating sarray'
        sarray = interpolate(yarrayu(ustartpos:uendpos),spos)
        print,'interpolate ready'
        zeros = where(sarray eq 0.,COMPLEMENT=nozeros)
        openw,luna,'zeros.dat',/GET_LUN
        printf,luna,'size(zeros) = ',size(zeros),': '
        printf,luna,zeros
        free_lun,luna
        if max(sarray) eq 0. then begin
          print,'sarray == 0. => STOP'
          stop
        endif
        if (size(zeros))(0) ne 0 then sarray(zeros) = 1000000.
      endif; j eq 0
      print,'j=',j,', size(syarrayr)=',size(syarrayr),', size(syarray)=',size(syarray),', size(sarray)=',size(sarray),', nxendpos-nxstartpos+1=',nxendpos-nxstartpos+1
      print,'calculating syarrayr(j=',j,')'
      syarrayr(j,nxstartpos:nxendpos) = syarray(j,nxstartpos:nxendpos) / sarray
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
;        printf,lun,'syarray(1:maxn-1,xminpos:xmaxpos)) = ',syarray(1:maxn-1,xminpos:xmaxpos)
      print,'syarrayr(',j,') calculated'
      yminb = min(syarrayr(*,nxstartpos:nxendpos))
      ymaxb = max(syarrayr(*,nxstartpos:nxendpos))
      xtickformat = '(F9.0)'
      if ymaxb gt 1.9 then ymaxb = 1.9
      if yminb lt 0.1 then yminb = 1. - (ymaxb - 1.)
      print,'yminb set to ',yminb
      print,'ymaxb set to ',ymaxb
      ytitle = 'Ratio'
      if (xmaxs(i) - xmins(i)) lt 10. then xtickformat='(F9.1)'
      if (xmaxs(i) - xmins(i)) lt 1. then xtickformat='(F9.1)'
      if (xmaxs(i) - xmins(i)) lt .1 then xtickformat='(F9.2)'
      if (xmaxs(i) - xmins(i)) lt .01 then xtickformat='(F9.3)'
      ytickformat = '(F9.0)'
      if (ymaxb - yminb) lt 10. then ytickformat='(F9.1)'
      if (ymaxb - yminb) lt 1. then ytickformat='(F9.2)'
      if (ymaxb - yminb) lt .1 then ytickformat='(F9.2)'
      if (ymaxb - yminb) lt .01 then ytickformat='(F9.3)'
      print,'ytickformat set to ',ytickformat
      print,'starting ratio plotting'
      if j eq 0 then begin
        plot,xarray,syarrayr(j,*),position=[xpmin,0.12,0.99,0.395],xtitle='Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',charsize=1.4,xstyle=1,ystyle=1,xrange=[xmins(i),xmaxs(i)],yrange=[yminb,ymaxb],ytickformat=ytickformat,charthick=2,/NOERASE,color=0,xtickformat=xtickformat,ytitle=ytitle;,ytitle='Difference [ADUs]';,yticks=4
      endif
      oplot,xarray,syarrayr(j,*),color=j+4
      print,'ratio plotting ready'
    endfor; --- loop through spectra
    device,/close
    set_plot,'x'
    print,'psfilename <'+psfilename+'> ready'
    spawn,'epstopdf '+psfilename
;    spawn,'rm '+psfilename

  endfor; --- loop through layouts
  free_lun,lun
endelse
end
