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
pro fxcor_out_plot,list,print
    if n_elements(list) eq 0 then list = '../../UVES/ready/fxcor_dats_blue+red.list'
    path = strmid(list,0,strpos(list,'/',/REVERSE_SEARCH)+1)
    print,'path = '+path
    qtemp = ''
    maxn = countlines(list)
    print,list,' contains ',maxn,'datalines'
    datfiles = strarr(maxn)
;    close,1
    openr,lun,list,/get_lun
;    arrpos = 0
;    indexa = 0
;    filenamelength = 0
    nblue = 0
    nredl = 0
    nredr = 0
    nsubtract = 5

    loadct,0

; --- read filenames
    for i=0,maxn-1 do begin
        readf,lun,qtemp
        qtemp = strtrim(qtemp,2)
        print,'qtemp = '+qtemp
;        print,'strmid(qtemp,0,15) = ',strmid(qtemp,0,15)
;        if strmid(qtemp,0,15) eq 'fxcor_out_trim,' then begin
;            indexa = strpos(qtemp,"'",strpos(qtemp,'.dat',/REVERSE_SEARCH),/REVERSE_SEARCH) + 1
;            print,'indexa = ',indexa
;            filenamelength = strpos(qtemp,"'",strpos(qtemp,',',/REVERSE_SEARCH),/REVERSE_SEARCH) - indexa
;            print,'filenamelength = ',filenamelength
        datfiles(i) = path+qtemp
;            print,'datfiles(',arrpos,') = ',datfiles(arrpos)
        if strpos(datfiles(i),'blue') gt 0 then nblue = nblue + 1
        if strpos(datfiles(i),'red_l') gt 0 then nredl = nredl + 1
        if strpos(datfiles(i),'red_r') gt 0 then nredr = nredr + 1
;            arrpos = arrpos + 1
;        end
    end
    free_lun,lun
    ndatfiles = maxn
    print,'ndatfiles = ',ndatfiles
    print,'nblue = ',nblue
    print,'nredl = ',nredl
    print,'nredr = ',nredr

; --- read data from filenames
    maxnblue  = countlines(datfiles(0))
    print,'datfiles(ndatfiles-1=',ndatfiles-1,') = ',datfiles(ndatfiles-1)
    maxnred   = countlines(datfiles(ndatfiles-1))
    maxarr = intarr(2)
    maxarr(0) = maxnblue
    maxarr(1) = maxnred
    nfitsfiles = max(maxarr) - 2
    print,'maxnblue = ',maxnblue,', maxnred = ',maxnred,', nfitsfiles = ',nfitsfiles
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
        if strpos(datfiles(i),'blue') gt 0 then begin
            maxl = maxnblue 
        endif else begin
            maxl = maxnred
        endelse
        print,'maxnblue = ',maxnblue,', maxnred = ',maxnred,', maxl = ',maxl
        for j=0,maxl-1 do begin
            readf,lun,qtemp
;            print,'qtem = ',qtemp
            if strmid(qtemp,0,1) ne '#' then begin
                hjdarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                if i gt 30 then print,'hjdarr(',i,',',fieldpos,') = ',hjdarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
                if i gt 30 then print,'qtemp = ',qtemp
                hghtarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
                if i eq 30 then print,'hghtarr(',i,',',fieldpos,') = ',hghtarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
;                print,'qtemp = ',qtemp
                fwhmarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
;                if i eq 5 then print,'fwhmarr(',i,',',fieldpos,') = ',fwhmarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
;                print,'qtemp = ',qtemp
                vobsarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
;                if i eq 5 then print,'vobsarr(',i,',',fieldpos,') = ',vobsarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
;                print,'qtemp = ',qtemp
                vrelarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
;                if i eq 5 then print,'vrelarr(',i,',',fieldpos,') = ',vrelarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
;                print,'qtemp = ',qtemp
                vhelioarr(i,fieldpos) = strmid(qtemp,0,strpos(qtemp,' '))
;                if i eq 5 then print,'vhelioarr(',i,',',fieldpos,') = ',vhelioarr(i,fieldpos)
                qtemp = strmid(qtemp,strpos(qtemp,' ')+1,strlen(qtemp)-strlen(strmid(qtemp,0,strpos(qtemp,' ')+1)))
;                print,'qtemp = ',qtemp
                verrarr(i,fieldpos) = qtemp
;                if i eq 5 then print,'verrarr(',i,',',fieldpos,') = ',verrarr(i,fieldpos)
                fieldpos = fieldpos + 1
            endif
        endfor
        free_lun,lun


;        if i lt 5 then print,'vobsarr(',i,',*) = ',vobsarr(i,*)
        vobssortarr(i,*)   = sort(vobsarr(i,*))
;        if i lt 5 then print,'vobssortarr(',i,',*) = ',vobssortarr(i,*)
        
;        if i lt 5 then print,'vrelarr(',i,',*) = ',vrelarr(i,*)
        vrelsortarr(i,*)   = sort(vrelarr(i,*))
;        if i lt 5 then print,'vrelsortarr(',i,',*) = ',vrelsortarr(i,*)

;        if i lt 5 then print,'vhelioarr(',i,',*) = ',vhelioarr(i,*)
        vheliosortarr(i,*) = sort(vhelioarr(i,*))
;        if i lt 5 then print,'vheliosortarr(',i,',*) = ',vheliosortarr(i,*)

    endfor

    hjdarrmean    = dblarr(maxnblue+(2*maxnred)-6)
    vobsarrmean   = dblarr(maxnblue+(2*maxnred)-6)
    vrelarrmean   = dblarr(maxnblue+(2*maxnred)-6)
    vhelioarrmean = dblarr(maxnblue+(2*maxnred)-6)
    for i=0,maxnblue + (2 * maxnred) - 7 do begin
        if i lt maxnblue - 2 then begin
            ; --- j : 
            k = 0
            j = nblue-1
            l = 0
        end 
        if (i ge maxnblue - 2) and (i lt maxnblue + maxnred - 4) then begin
            k = nblue
            j = nblue + nredr - 1
            l = maxnblue - 2
        end
        if (i ge maxnblue + maxnred - 4) and (i lt maxnblue + (2 * maxnred) - 6) then begin
            k = nblue+nredr
            j = nblue+nredr+nredl-1
            l = maxnblue + maxnred - 4
        end
        print,'i = ',i,', maxnblue = ',maxnblue,', maxnred = ',maxnred,', j = ',j,', nblue = ',nblue,', nredl = ',nredl,', k = ',k,', l = ',l
;            print,'vobsarr(',i,',*) = ',vobsarr(i,0:j)
        hjdarrmean(i)    = hjdarr(k,i-l)
        print,'hjdarrmean(',i,') = ',hjdarrmean(i)
        vobsarrmean(i)   = mean(vobsarr(k:j,i-l))
        print,'vobsarrmean(',i,') = ',vobsarrmean(i)
        vrelarrmean(i)   = mean(vrelarr(k:j,i-l))
        print,'vrelarrmean(',i,') = ',vrelarrmean(i)
        vhelioarrmean(i) = mean(vhelioarr(k:j,i-l))
        print,'vhelioarrmean(',i,') = ',vhelioarrmean(i)
    endfor

    vobsmax = max(vobsarr)
    vrelmax = max(vrelarr)
    vheliomax = max(vhelioarr)
    print,'vobsmax = ',vobsmax,', vrelmax = ',vrelmax,', vheliomax = ',vheliomax
    vobsmin = min(vobsarr)
    vrelmin = min(vrelarr)
    vheliomin = min(vhelioarr)
    print,'vobsmin = ',vobsmin,', vrelmin = ',vrelmin,', vheliomin = ',vheliomin

; --- plot

    mywindow = OBJ_NEW('IDLgrWindow')
    myview = OBJ_NEW('IDLgrView', VIEWPLANE_RECT=[min(hjdarrmean)-.1,vrelmin-1,max(hjdarrmean)-min(hjdarrmean)+.2,vrelmax-vrelmin+2.])
    mymodel = OBJ_NEW('IDLgrModel')

    myplot1 = OBJ_NEW('IDLgrPlot', hjdarrmean, vrelarrmean, LINESTYLE=2)

    mySymbol = OBJ_NEW('IDLgrSymbol', 2, SIZE=[.3,.01])
    myplot1 -> SetProperty, SYMBOL=mySymbol

    myview -> Add, mymodel
    mymodel -> Add, myplot1
    mywindow -> Draw, myview 

end
