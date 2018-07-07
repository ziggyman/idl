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
pro fxcor_out_RXJ_plot_red,list,print
;############################
;
; NAME:                  fxcor_out_RXJ_plot_red.pro
; PURPOSE:               plots 'vobs', 'vrel' or 'vhelio' for RXJ for
;                        the 2 red ccd-chips (red_l, red_r)
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fxcor_out_RXJ_plot_red,'<fxcor_RXJ_dats_red.list>','print'
; INPUTS:                input file: list ('</yoda/UVES/MNLupus/ready/fxcor_dats_red.list>'):
;                         /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_l_ref0_0.0_5980-6202_-1._100_100_90._80._0._-++.dat
;                         /yoda/UVES/MNLupus/ready/red_l/fxcor_RXJ_l_ref0_0.0_5980-6202_-2._100_100_90._80._0._-++.dat
;                             ...       
;                         /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_r_ref0_0.0_4869-5186_-1._100_100_90._80._0._-++.dat
;                         /yoda/UVES/MNLupus/ready/red_r/fxcor_RXJ_r_ref0_0.0_4869-5186_-2._100_100_90._80._0._-++.dat
;                                                      ...
;                          (OUTPUT-files of 'fxcor_out_trim.pro')
;                                            .
; OUTPUTS:               output files: '</yoda/UVES/MNLupus/ready/fxcor_RXJ_dats_red>_(vhelio,vrel,vobs).ps'
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.08.2004
;
    if n_elements(list) eq 0 then list = '/yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission.list'
;    path = strmid(list,0,strpos(list,'/',/REVERSE_SEARCH)+1)
;    print,'path = '+path
    qtemp = ''
    maxn = countlines(list)
    print,list,' contains ',maxn,'datalines'
    datfiles = strarr(maxn)
;    close,1
    openr,lun,list,/get_lun
;    arrpos = 0
;    indexa = 0
;    filenamelength = 0
;    nblue = 0
    nredl = 0
    nredr = 0
    nsubtract = 5

    loadct,0

; --- read filenames
    for i=0,maxn-1 do begin
        readf,lun,qtemp
        qtemp = strtrim(qtemp,2)
;        print,'qtemp = '+qtemp
        datfiles(i) = qtemp
        if strpos(datfiles(i),'red_l') gt 0 then nredl = nredl + 1
        if strpos(datfiles(i),'red_r') gt 0 then nredr = nredr + 1
    end
    free_lun,lun
    ndatfiles = maxn
    print,'ndatfiles = ',ndatfiles
    print,'nredl = ',nredl
    print,'nredr = ',nredr

; --- read data from filenames
    maxnred  = countlines(datfiles(0))
    nfitsfiles = maxnred - 2
;    print,'maxnred = ',maxnred,', nfitsfiles = ',nfitsfiles
    hjdarr    = dblarr(ndatfiles,nfitsfiles)
    hghtarr   = dblarr(ndatfiles,nfitsfiles)
    fwhmarr   = dblarr(ndatfiles,nfitsfiles)
    vobsarr   = dblarr(ndatfiles,nfitsfiles)
    vrelarr   = dblarr(ndatfiles,nfitsfiles)
    vhelioarr = dblarr(ndatfiles,nfitsfiles)
    verrarr   = dblarr(ndatfiles,nfitsfiles)
    vobssortarr   = intarr(ndatfiles,nfitsfiles)
    vrelsortarr   = intarr(ndatfiles,nfitsfiles)
    vheliosortarr = intarr(ndatfiles,nfitsfiles)
    
    for i=0,ndatfiles-1 do begin
        openr,lun,datfiles(i),/get_lun
        fieldpos = 0
        for j=0,maxnred-1 do begin
            readf,lun,qtemp
;            print,'qtem = ',qtemp
            if strmid(qtemp,0,1) ne '#' then begin
                hjdarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                hghtarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                fwhmarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                vobsarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                vrelarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                vhelioarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                verrarr(i,fieldpos) = qtemp
;		print,'fxcor_out_RXJ_plot_red: i = ',i,', fieldpos = ',fieldpos,', hjdarr(i,fieldpos) = ',hjdarr(i,fieldpos),', vhelioarr(i,fieldpos) = ',vhelioarr(i,fieldpos)
                fieldpos = fieldpos + 1
            endif
        endfor
        free_lun,lun


        vobssortarr(i,*)   = sort(vobsarr(i,*))
        vrelsortarr(i,*)   = sort(vrelarr(i,*))
        vheliosortarr(i,*) = sort(vhelioarr(i,*))

    endfor

; --- calculate mean and rms and write results to outfile
    openw,luno,strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vobs_mean+rms.data',/GET_LUN
    openw,lunr,strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vrel_mean+rms.data',/GET_LUN
    openw,lunh,strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vhelio_mean+rms.data',/GET_LUN
    printf,luno,'#N HJD VOBS ERR'
    printf,luno,'#U day km/s km/s'
    printf,lunr,'#N HJD VREL ERR'
    printf,lunr,'#U day km/s km/s'
    printf,lunh,'#N HJD VHELIO ERR'
    printf,lunh,'#U day km/s   km/s'
    hjdarrmean      = dblarr((2*nfitsfiles))
    vobsarrmean     = dblarr((2*nfitsfiles))
    vrelarrmean     = dblarr((2*nfitsfiles))
    vhelioarrmean   = dblarr((2*nfitsfiles))
    vobsarrstddev   = dblarr((2*nfitsfiles))
    vrelarrstddev   = dblarr((2*nfitsfiles))
    vhelioarrstddev = dblarr((2*nfitsfiles))
    for i=0,(2 * nfitsfiles)-1 do begin
        if i lt nfitsfiles then begin
            ; --- j : 
            k = 0
            j = nredl-1
            l = 0
        end 
        if (i ge nfitsfiles) then begin
            k = nredl
            j = nredl + nredr - 1
            l = nfitsfiles
        end
;        print,'i = ',i,' maxnred = ',maxnred,', j = ',j,', nredl = ',nredl,', nredr = ',nredr,', k = ',k,', l = ',l
;            print,'vobsarr(',i,',*) = ',vobsarr(i,0:j)
        hjdarrmean(i)    = hjdarr(k,i-l)
;        print,'hjdarrmean(',i,') = ',hjdarrmean(i)
        vobsarrmean(i)   = mean(vobsarr(k:j,i-l))
;        print,'vobsarrmean(',i,') = ',vobsarrmean(i)
        vrelarrmean(i)   = mean(vrelarr(k:j,i-l))
;        print,'vrelarrmean(',i,') = ',vrelarrmean(i)
        vhelioarrmean(i) = mean(vhelioarr(k:j,i-l))
;        print,'vhelioarrmean(',i,') = ',vhelioarrmean(i)
        vobsarrstddev(i)   = stddev(vobsarr(k:j,i-l))
;        print,'vobsarrstddev(',i,') = ',vobsarrstddev(i)
        vrelarrstddev(i)   = stddev(vrelarr(k:j,i-l))
;        print,'vrelarrstddev(',i,') = ',vrelarrstddev(i)
        vhelioarrstddev(i) = stddev(vhelioarr(k:j,i-l))
;        print,'vhelioarrstddev(',i,') = ',vhelioarrstddev(i)
        
        printf,luno,hjdarrmean(i),vobsarrmean(i),vobsarrstddev(i),FORMAT = '(F11.5," ",F15.8," ",F15.8)'
        printf,lunr,hjdarrmean(i),vrelarrmean(i),vrelarrstddev(i),FORMAT = '(F11.5," ",F15.8," ",F15.8)'
        printf,lunh,hjdarrmean(i),vhelioarrmean(i),vhelioarrstddev(i),FORMAT = '(F11.5," ",F15.8," ",F15.8)'
    endfor
    printf,luno,'# vobs mean: '+strtrim(string(mean(vobsarrmean)),2)
    printf,luno,'# vobs stddev: '+strtrim(string(stddev(vobsarrmean)),2)
    printf,lunr,'# vrel mean: '+strtrim(string(mean(vrelarrmean)),2)
    printf,lunr,'# vrel stddev: '+strtrim(string(stddev(vrelarrmean)),2)
    printf,lunh,'# vhelio mean: '+strtrim(string(mean(vhelioarrmean)),2)
    printf,lunh,'# vhelio stddev: '+strtrim(string(stddev(vhelioarrmean)),2)
    free_lun,luno
    free_lun,lunr
    free_lun,lunh

    vobsmax = max(vobsarr)
    vrelmax = max(vrelarr)
    vheliomax = max(vhelioarr)
;    print,'vobsmax = ',vobsmax,', vrelmax = ',vrelmax,', vheliomax = ',vheliomax
    vobsmin = min(vobsarr)
    vrelmin = min(vrelarr)
    vheliomin = min(vhelioarr)
;    print,'vobsmin = ',vobsmin,', vrelmin = ',vrelmin,', vheliomin = ',vheliomin

; --- plot vrelarrmean
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vrel.eps',/color
    endif
    plot,hjdarrmean,vrelarrmean,psym=2,xtitle='heliocentric julian date (days)',$
        ytitle='relative radial velocity (ref: 1st image) (km/s)',$
        xrange=[min(hjdarrmean)-.2,max(hjdarrmean)+.2],xstyle=1,yrange=[vrelmin-1,vrelmax+1],$
        ystyle=1,color=1,title=strmid(list,strpos(list,'/',/REVERSE_SEARCH)+1),position=[0.11,0.11,0.98,0.93],$
        charsize=1.2

    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='/home/azuri/daten/idl/colors1.tbl'
;    loadct,0,file='/opt/rsi/idl_5.5/resource/colors/colors1.tbl',ncolors=3

    oplot,hjdarrmean(0:nfitsfiles-1),vrelarrmean(0:nfitsfiles-1),psym=4,color=0
    oploterr,hjdarrmean(0:nfitsfiles-1),vrelarrmean(0:nfitsfiles-1),vrelarrstddev(0:nfitsfiles-1)
    oplot,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vrelarrmean(nfitsfiles:((2*nfitsfiles)-1)),psym=4,color=2
    oploterr,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vrelarrmean(nfitsfiles:((2*nfitsfiles)-1)),vrelarrstddev(nfitsfiles:((2*nfitsfiles)-1))
    for i=0,nredl-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vrelarr(i,0:nfitsfiles-1),psym=1,color=2
    endfor
    for i=nredl,nredl+nredr-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vrelarr(i,0:nfitsfiles-1),psym=1,color=1
    endfor
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif

; --- vhelioarrmean
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vhelio.eps',/color
    endif
    plot,hjdarrmean,vhelioarrmean,psym=2,xtitle='heliocentric julian date (days)',$
        ytitle='heliocentric radial velocity (ref: 1st image) (km/s)',$
        xrange=[min(hjdarrmean)-.2,max(hjdarrmean)+.2],xstyle=1,$
        yrange=[vheliomin-1,vheliomax+1],ystyle=1,color=1,$
        title=strmid(list,strpos(list,'/',/REVERSE_SEARCH)+1),$
        position=[0.11,0.11,0.98,0.93],$
        charsize=1.2

    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='/home/azuri/daten/idl/colors1.tbl'
;    loadct,0,file='/opt/rsi/idl_5.5/resource/colors/colors1.tbl',ncolors=3

    oplot,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),psym=4,color=0
    oploterr,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),vhelioarrstddev(0:nfitsfiles-1)
    oplot,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrmean(nfitsfiles:((2*nfitsfiles)-1)),psym=4,color=2
    oploterr,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrstddev(nfitsfiles:((2*nfitsfiles)-1))
    for i=0,nredl-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vhelioarr(i,0:nfitsfiles-1),psym=1,color=2
    endfor
    for i=nredl,nredl+nredr-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vhelioarr(i,0:nfitsfiles-1),psym=1,color=1
    endfor
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif

; --- one image for red_r and one for red_l
; --- red_r
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vhelio_l.eps',/color
    endif
    title = strmid(list,strpos(list,'/',/REVERSE_SEARCH)+1)
    title = strmid(title,0,strpos(title,'.',/REVERSE_SEARCH))+'_l'
    plot,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),psym=2,$
        xtitle='heliocentric julian date (days)',$
        ytitle='heliocentric radial velocity (ref: 1st image) (km/s)',$
        xrange=[min(hjdarrmean)-.2,max(hjdarrmean)+.2],xstyle=1,$
        yrange=[vheliomin-1,vheliomax+1],ystyle=1,color=1,$
        title=title,position=[0.11,0.11,0.98,0.93],charsize=1.2

    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='/home/azuri/daten/idl/colors1.tbl'
;    loadct,0,file='/opt/rsi/idl_5.5/resource/colors/colors1.tbl',ncolors=3

    oplot,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),psym=4,color=0
    oploterr,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),vhelioarrstddev(0:nfitsfiles-1)
    for i=0,nredl-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vhelioarr(i,0:nfitsfiles-1),psym=1,color=2
    endfor
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif

; vhelio: red_l
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vhelio_r.eps',/color
    endif
    title = strmid(list,strpos(list,'/',/REVERSE_SEARCH)+1)
    title = strmid(title,0,strpos(title,'.',/REVERSE_SEARCH))+'_r'
    plot,hjdarrmean(0:nfitsfiles-1),vhelioarrmean(0:nfitsfiles-1),psym=2,$
        xtitle='heliocentric julian date (days)',$
        ytitle='heliocentric radial velocity (ref: 1st image) (km/s)',$
        xrange=[min(hjdarrmean)-.2,max(hjdarrmean)+.2],xstyle=1,$
        yrange=[vheliomin-1,vheliomax+1],ystyle=1,color=1,$
        title=title,position=[0.11,0.11,0.98,0.93],charsize=1.2

    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='/home/azuri/daten/idl/colors1.tbl'
;    loadct,0,file='/opt/rsi/idl_5.5/resource/colors/colors1.tbl',ncolors=3

    oplot,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrmean(nfitsfiles:((2*nfitsfiles)-1)),psym=4,color=2
    oploterr,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrmean(nfitsfiles:((2*nfitsfiles)-1)),vhelioarrstddev(nfitsfiles:((2*nfitsfiles)-1))
    for i=nredl,nredl+nredr-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vhelioarr(i,0:nfitsfiles-1),psym=1,color=1
    endfor
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif

; --- vobs
    if n_elements(print) gt 0 then begin
        set_plot,'ps'
        device,filename=strmid(list,0,strpos(list,'.',/REVERSE_SEARCH))+'_vobs.eps',/color
    endif
    plot,hjdarrmean,vobsarrmean,psym=2,xtitle='heliocentric julian date (days)',$
        ytitle='observed radial velocity (ref: 1st image) (km/s)',$
        xrange=[min(hjdarrmean)-.2,max(hjdarrmean)+.2],xstyle=1,yrange=[vobsmin-1,vobsmax+1],$
        ystyle=1,color=1,title=strmid(list,strpos(list,'/',/REVERSE_SEARCH)+1),$
        position=[0.11,0.11,0.98,0.93],$
        charsize=1.2

    red   = intarr(256)
    green = intarr(256)
    blue  = intarr(256)
    TVLCT, red, green, blue, /GET
    for i=0,255 do begin
        green(i) = blue(255-i)
    endfor
    for i=0,255 do begin
        blue(i) = green(i)
        green(i) = 0
    endfor
    modifyct,0,'blue-red',red,green,blue,file='/home/azuri/daten/idl/colors1.tbl'
;    loadct,0,file='/opt/rsi/idl_5.5/resource/colors/colors1.tbl',ncolors=3

    oplot,hjdarrmean(0:nfitsfiles-1),vobsarrmean(0:nfitsfiles-1),psym=4,color=0
    oploterr,hjdarrmean(0:nfitsfiles-1),vobsarrmean(0:nfitsfiles-1),vobsarrstddev(0:nfitsfiles-1)
    oplot,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vobsarrmean(nfitsfiles:((2*nfitsfiles)-1)),psym=4,color=2
    oploterr,hjdarrmean(nfitsfiles:((2*nfitsfiles)-1)),vobsarrmean(nfitsfiles:((2*nfitsfiles)-1)),vobsarrstddev(nfitsfiles:((2*nfitsfiles)-1))
    for i=0,nredl-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vobsarr(i,0:nfitsfiles-1),psym=1,color=2
    endfor
    for i=nredl,nredl+nredr-1 do begin
        oplot,hjdarr(i,0:nfitsfiles-1),vobsarr(i,0:nfitsfiles-1),psym=1,color=1
    endfor
    if n_elements(print) gt 0 then begin
        device,/close
        set_plot,'x'
    endif
end
