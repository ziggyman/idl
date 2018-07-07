common maxfn,maxn,flux

pro I_res_lambda,fname,hjdname,resname,lambda0,dlambda,print,lambdacutstart,lambdacutend  
common maxfn,maxn,flux
  
;
; NAME:                  I_res_lambda.pro
; PURPOSE:               prints absorptionlines and resisuals between
;                        lambda0-dlambda and lambda0+dlambda,
;                        sets intensities between 'lambdacutstart' and
;                        'lambdacutend' to the last intensity value
;                        before this area
; CATEGORY:              data reduction
; CALLING SEQUENCE:      I_res_lambda,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctcv.text.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text','/yoda/UVES/MNLupus/ready/red_l/residuals_v.text.list',6439.2,4.5,'print',6439.0,6439.4
; INPUTS:                input file: '/yoda/UVES/MNLupus/ready/red_l/RXJ_ctcv.text.list':
;
;                                    file1
;                                    file2
;                                      :
;                                    filen
;                                    nextnight
;
;                        '/yoda/UVES/MNLupus/ready/red_l/hjds.text':
;                                    hjd
;
;                        '/yoda/UVES/MNLupus/ready/red_l/residuals.list':
;                                    lambda flux
;
;                        datafiles:
;                                    lambda flux
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  14.02.2001
;
;                        headline
;                        feetline (up to now not used) 
;
if n_elements(print) ne 0 then begin  
    set_plot,'ps'
    dumfilename = strmid(fname,0,strpos(fname,'/',/REVERSE_SEARCH)+1)+strcompress('I_res_lambda_'+strtrim(string(lambda0-dlambda),2)+'-'+strtrim(string(lambda0+dlambda),2)+'.ps')
;    strput,dumfilename,'_',strpos(dumfilename,' ')
    print,'dumfilename = ',dumfilename
    device,filename=dumfilename,xsize=18,ysize=26
;,yoffset=1,xoffset=1
;,/color  
    !p.charthick=2.0
    !p.charsize=1.5
    !p.thick=6.0
    !x.thick=3.0
    !y.thick=3.0
end else begin
    window,0,retain=2
    !p.charsize=2
    !p.charthick=2.0
    !p.thick=2.0
    !x.thick=2.0
    !y.thick=2.0
end
;loadct,40

headline=''            
feetline=''
xaxis='!7k!1 ['+STRING("305B)+']'
;yaxis='!5        residuals          normalized flux - hjd '
xmaximum = -1000.
xminimum = 1000.
ymin = 1000.
ymax = -1000.
jump = 0.15
;(ymax-ymin)/80.
print,'jump=',jump

; --- test arguments
if n_elements(fname) eq 0 then begin
    print,'ERROR: no filename spezified!'
    print,"Usage: I_res_lambda,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctcv.text.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text','/yoda/UVES/MNLupus/ready/red_l/residuals_v.text.list',lambda0:double,deltalambda:double,print:String,lambdacutstart:double,lambdacutend:double"
endif else begin
    
; --- variable declarations
    maxn = 0UL
    maxfn = 0UL
    
; --- count lines fname
    maxfn=countlines(fname)
    print,maxfn,' DATA-FILES'
    
; --- initialize variables
    filename    = strarr(maxfn)
    resfilename = strarr(maxfn)
    hjd         = dblarr(maxfn)
    
    for i=0UL,maxfn-1 do begin
        filename(i)    = strmid(fname,0,strpos(fname,'/',/reverse_search)+1)
        resfilename(i) = strmid(resname,0,strpos(fname,'/',/reverse_search)+1)
;        if i eq 0 then print,'I_res_lambda: filename(0) = '+filename(0)+', resfilename(0) = '+resfilename(0)
    endfor
    
; --- count lines hjdname
    maxhn=countlines(fname)
    print,maxhn,' HJDs'
    
; --- read filenames from fname (inputfile)
    filenameq = ''
    openr,lun,fname,/GET_LUN
    for i=0,maxfn-1 do begin  
        readf,lun,filenameq
        filename(i) = filename(i)+strtrim(filenameq,2) 
;        print,'filename = ',filename(i)
    endfor
    free_lun,lun
    
; --- read hjds from hjdname (inputfile)
    hjdq=double(0.)
    dum = 0
    openr,lun,hjdname,/GET_LUN
    for i=0,maxfn-1 do begin  
        dum = dum+1
        readf,lun,hjdq
        hjd(i)=hjdq 
;        print,hjdq,hjd(i) , FORMAT = '("hjdq = " , F15.7 , " hjd = " , F15.7 )'
    endfor
    free_lun,lun
    print,dum,' hjds read'
    
; --- read resfilenames from resname (inputfile)
    dum = 0
    openr,lun,resname,/GET_LUN
    for i=0,maxfn-1 do begin  
        dum = dum+1
        readf,lun,filenameq
        resfilename(i) = resfilename(i)+strtrim(filenameq,2) 
;        print,'resfilename(',i,') = ',resfilename(i)
    endfor
    free_lun,lun
    print,dum,' resfiles'
    
; --- count lines of filename
    maxn=countlines(filename(1))
    print,maxn,' DATA-lines'
    
; --- initialize variables
    ynight11    = 0.
    ynight12    = 0.
    ynight21    = 0.
    ynight22    = 0.
    nfluxpoints = 0
    meanflux    = double(0.)
    lambda      = dblarr(maxfn,maxn)
    flux        = dblarr(maxfn,maxn)
    reslambda   = dblarr(maxfn,maxn)
    resflux     = dblarr(maxfn,maxn)
    resmax      = double(0.)
    resmin      = double(0.)
    lastflux    = double(0.)
    lastresflux = double(0.)
; middle   = dblarr(2,maxn)
    
;-- read datas from filename (filename(i))
    for k=0UL,maxfn-1 do begin
        openr,lun,filename(k),/GET_LUN  
        openr,luna,resfilename(k),/GET_LUN
        for i=0UL,maxn-1 do begin  
            readf,lun,lambdaq,fluxq
            lambda(k,i)=lambdaq 
            if n_elements(lambdacutend) ne 0 then begin
                if (lambda(k,i) ge lambdacutstart) and $
                   (lambda(k,i) le lambdacutend) then begin
                    flux(k,i) = lastflux
                end else begin
                    flux(k,i) = fluxq
                    lastflux  = fluxq
                end
            end else begin
                flux(k,i) = fluxq
                lastflux  = fluxq
            end
            readf,luna,lambdaq,fluxq
            reslambda(k,i)=lambdaq 
            if n_elements(lambdacutend) ne 0 then begin
                if (reslambda(k,i) ge lambdacutstart) and $
                   (reslambda(k,i) le lambdacutend) then begin
                    resflux(k,i) = lastresflux
                end else begin
                    resflux(k,i) = fluxq
                    lastresflux  = fluxq
                end
            end else begin
                resflux(k,i) = fluxq
                lastresflux  = fluxq
            end
;            resflux(k,i)=fluxq
;            if k eq 0 then begin
            if (lambda(k,i) ge (lambda0 - dlambda)) and (lambda(k,i) le (lambda0 + dlambda)) then begin
; --- search for maximum flux and maximum and minimum of resflux
                if flux(k,i) gt ymax then ymax = flux(k,i)
                if resflux(k,i) gt resmax then resmax = resflux(k,i)
                if resflux(k,i) lt resmin then resmin = resflux(k,i)
; --- count datapoints
                nfluxpoints = nfluxpoints + 1
; --- calculate mean of flux
                meanflux = meanflux + flux(k,i)
                if flux(k,i) lt ymin then ymin = flux(k,i)
            endif
;            endif
        endfor
        free_lun,lun
        free_lun,luna
    endfor
    print,'ymax = ',ymax,', resmax = ',resmax,', resmin = ',resmin
    
; --- mean of flux
    meanflux = meanflux / double(nfluxpoints)
    print,'meanflux = ',meanflux
    
; --- calculate graph size and positions
    dy1 = ymax - ymin
    print,'I_res_lambda: ymin = ',ymin,', ymax = ',ymax,', dy1 = ',dy1,', jump = ',jump
    dhjd = double(0.)
    dhjd = hjd(maxfn-1) - hjd(0)
    print,'I_res_lambda: dhjd = ',dhjd
;   --- emission lines
    if meanflux gt 1. then begin
        print,'mean of flux is greater than 1. -> emission line'
        ymax = ymax + ((ymax - ymin) / 15.)
        tempdi = double(0.)
        tempdi = (ymax - ymin) / 2.
        ymin = ymin - (dhjd * tempdi)
    endif else begin
;   --- absorption lines
        print,'mean of flux is lower than 1. -> absorption line'
        ymax = ymax + ((ymax - ymin) / 5.)
        tempdi = double(0.)
        tempdi = (ymax - ymin) / 2.
        ymin = ymax - ((ymax - ymin) / 5.) - (dhjd * tempdi) - dy1
    endelse
    dy2 = ymax - ymin
    jump = ymax - dy2 - resmax  ; - (abs(ymax - resmax)*1.25)
    ymin = ymax - dy2 - resmax + resmin - (1.6 * dhjd * tempdi)
    dy3 = ymax - ymin
    print,'I_res_lambda: ymin = ',ymin,', ymax = ',ymax,', dy2 = ',dy2,', dy3 = ',dy3,', jump = ',jump,', tempdi = ',tempdi
    print,'I_res_lambda: ymin = ',ymin,', ymax = ',ymax,', dy3 = ',dy3,', jump = ',jump,', tempdi = ',tempdi
;---plot
    file = 0
    plot,lambda(file,0:maxn-1),flux(file,0:maxn-1),$
               xstyle=1,xrange=[lambda0-dlambda,lambda0+dlambda],ystyle=1,yrange=[ymin,ymax],title='!5'+headline,$
               xtitle=xaxis,charsize=2,color=0,xticks=3,$
               xticklen=0.03,position=[0.15,0.1,0.93,0.95];,$
;               yticks=1,ytickname=[' ',' ']
;,ytitle=yaxis
    
;,/noerase
    oplot,reslambda(file,0:maxn-1),resflux(file,0:maxn-1)+jump
    dummmi=uint(0)
    dumlambda=reslambda(1,1001)-reslambda(1,1000)
    for i=1UL,maxn-2 do begin
        if (reslambda(file,i) gt lambda0-dlambda) AND (reslambda(file,i) lt lambda0+dlambda) then begin
            if dummmi eq 0. then begin
                dummmi=i
;                minflux=min(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda)))
;                maxflux=max(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda)))
            endif
;            dumcolor = (255)*(resflux(file,i)-minflux)/(maxflux-minflux)
            dumcolor = (255)*(resflux(file,i)-resmin)/(resmax-resmin)
            print,'resflux(',file,',',i,')=',resflux(file,i),' dumcolor=',dumcolor
            color = uint(uint(dumcolor) + 256L * (uint(dumcolor) + 256L * uint(dumcolor)))
;   color = 10+256L*(10+256L*10)
            print,'dummmi=',dummmi,', reslambda(',file,',',dummmi,')=',reslambda(file,dummmi),', resmin=',resmin,', resmax=',resmax,', dumcolor=',dumcolor,' color=',color,' i=',i
            if reslambda(1,i)-dumlambda/2. lt lambda0-dlambda then xminimum=float(lambda0-dlambda) else xminimum=float(reslambda(1,i)-dumlambda/2.)
            if reslambda(1,i)+dumlambda/2. gt lambda0+dlambda then xmaximum=float(lambda0+dlambda) else xmaximum=float(reslambda(1,i)+dumlambda/2.)
            yminimum=float(ymin+((ymax-ymin)/10.-(ymax-ymin)*(file+1.)/(10.*(maxfn+2.))))
            ymaximum=float(ymin+((ymax-ymin)/10.-(ymax-ymin)*(file)/(10.*(maxfn+2.))))
                                ;print,'xminimum=',xminimum,', xmaximum=',xmaximum,', yminimum=',yminimum,', ymaximum=',ymaximum
            box,xminimum,yminimum,xmaximum,ymaximum,color
        end
    end
    dumI     = 0.
    dumfile  = 0.
    ddumI    = 1.
    ddumIold = 1.
    foundynight11 = 0
    foundynight12 = 0
    dhjd = 1.
    for file=1,maxfn-1 do begin
        dummyI = dumI
        dhjd_old = dhjd
        dhjd = hjd(file) - hjd(file-1)
        if dhjd gt (dhjd_old * 2.) then dumfile = 1
        dumI   = dumI + (dhjd*tempdi)
;        if dumI-dummyI gt (ymax-ymin)/20. then dumI=dummyI+(ymax-ymin)/20.
        oplot,lambda(file,0:maxn-1),flux(file,0:maxn-1)-dumI
        oplot,reslambda(file,0:maxn-1),resflux(file,0:maxn-1)+jump-dumI
        ddumIold = ddumI
        ddumI = dumI - dummyI
        print,'dumI=',dumI,', ddumI = ',ddumI,', ddumIold = ',ddumIold
        dummmi=0
        for i=1UL,maxn-2 do begin
;   dumlambda=reslambda(file,i+1)-reslambda(file,i)
            if (reslambda(file,i) gt lambda0-dlambda) AND (reslambda(file,i) lt lambda0+dlambda) then begin
                if dummmi eq 0. then dummmi=i
;    print,'dummmi=',dummmi,', reslambda(',file,',',dummmi,')=',reslambda(file,dummmi)
                                ;print,'min(',dummmi,':',dummmi+2.*dlambda/dumlambda,')=',min(resflux(file,dummmi:dummmi+2.*dlambda/dumlambda)),' max=',max(resflux(file,dummmi:dummmi+2.*dlambda/dumlambda))
                                ;print,'dummmi = ',dummmi,', dummmi+2.*dlambda/dumlambda = ',dummmi+(2.*dlambda/dumlambda)
                                ;print,'dumcolor=',dumcolor
                minflux=min(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda)))
                maxflux=max(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda)))
                dumcolor = (255)*(resflux(file,i)-minflux)/(maxflux-minflux)
;    dumcolor = (255)*(resflux(file,i)-min(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda))))/(max(resflux(0:maxfn-1,dummmi:dummmi+(2.*dlambda/dumlambda)))-min(resflux(file,dummmi:dummmi+(2.*dlambda/dumlambda))))
                                ;if file lt 18 then print,'dummmi=',dummmi,', reslambda(',file,',',dummmi,')=',reslambda(file,dummmi),', resflux(',file,',',i,')=',resflux(file,i),' minflux=',minflux,', maxflux=',maxflux,', dumcolor=',dumcolor
                color = uint(uint(dumcolor) + 256L * (uint(dumcolor) + 256L * uint(dumcolor)))
                                ;print,'dumcolor=',dumcolor,' color=',color,' i=',i
                if reslambda(file,i)-dumlambda/2. lt lambda0-dlambda then xminimum=float(lambda0-dlambda) else xminimum=float(reslambda(file,i)-dumlambda/2.)
                if reslambda(file,i)+dumlambda/2. gt lambda0+dlambda then xmaximum=float(lambda0+dlambda) else xmaximum=float(reslambda(file,i)+dumlambda/2.)
                yminimum=float(ymin+((ymax-ymin)/10.-(ymax-ymin)*(float(file)+dumfile+1.)/(10.*(maxfn+2.))))
                ymaximum=float(ymin+((ymax-ymin)/10.-(ymax-ymin)*(float(file)+dumfile)/(10.*(maxfn+2.))))
                                ;print,'file=',file,', xminimum=',xminimum,', xmaximum=',xmaximum,', yminimum=',yminimum,', ymaximum=',ymaximum
                box,xminimum,yminimum,xmaximum,ymaximum,color
                if file eq (maxfn - 1) then begin
                    ynight22 = resflux(file,i) + jump - dumI - (3. * ((hjd(file)-hjd(file-1))*tempdi))
                    print,'I_res_lambda: ynight21 = ',ynight21,', ynight22 = ',ynight22
                endif
                if (ddumI gt (2. * ddumIold)) and (foundynight12 eq 0) then begin
                    foundynight12 = 1
                    ynight12 = ynight12dum - (3. * ((hjd(file-1)-hjd(file-2))*tempdi))
                    print,'I_res_lambda: ynight11 = ',ynight11,', ynight12 = ',ynight12
                endif
                ynight12dum = resflux(file,i) + jump - dumI
            endif
            if (lambda(1,i) gt lambda0-dlambda) AND (lambda(1,i) lt lambda0+dlambda) then begin
                if file eq (maxfn - 1) then begin
                    ynight21 = flux(file,i) - dumI - (3. * ((hjd(file)-hjd(file-1))*tempdi))
;                    print,'I_res_lambda: ynight21 = ',ynight21,', ynight22 = ',ynight22
                endif
                if (ddumI gt (2. * ddumIold)) and (foundynight11 eq 0) then begin
                    foundynight11 = 1
                    ynight11 = ynight11dum - (3. * ((hjd(file-1)-hjd(file-2))*tempdi))
;                    print,'I_res_lambda: ynight11 = ',ynight11,', ynight12 = ',ynight12
                endif
                ynight11dum = flux(file-1,i) - dumI
            endif
;            if file eq (maxhn/2) then dumfile = 1.
        endfor
    endfor
    print,'I_res_lambda: ynight11 = ',ynight11,', ynight12 = ',ynight12
    print,'I_res_lambda: ynight21 = ',ynight21,', ynight22 = ',ynight22
    XYOUTS, lambda0+dlambda+(dlambda/10.), ynight22, 'night2' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0+dlambda+(dlambda/10.), ynight12, 'night1' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0+dlambda+(dlambda/10.), ynight21, 'night2' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0+dlambda+(dlambda/10.), ynight11, 'night1' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0+dlambda+(dlambda/10.), ymin + ((ymax - ymin) / 150.), 'n2' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0+dlambda+(dlambda/10.), ymin + ((ymax - ymin) / 17.5), 'n1' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    XYOUTS, lambda0-dlambda-(dlambda/3.5), ymin + ((ymax-ymin)/1.9), 'normalized_flux-(C!B1!N*hjd)' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    if jump lt 0. then $
        XYOUTS, lambda0-dlambda-(dlambda/3.5), ymin + ((ymax-ymin)/30.), 'residuals-C!B2!N-(C!B1!N*hjd)' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 $;TEXT_AXES=0 
    else $
        XYOUTS, lambda0-dlambda-(dlambda/3.5), ymin + ((ymax-ymin)/30.), 'residuals+C!B2!N-(C!B1!N*hjd)' , ALIGNMENT=0.0, CHARSIZE=2, CHARTHICK=2, ORIENTATION=90 ;TEXT_AXES=0 
    if n_elements(print) ne 0 then begin  
        device,/close  
        set_plot,'x'  
;  spawn,'lp -ddhgps '+dumfilename
    end
    
    !p.charsize=1.0
    !p.charthick=1.0
    !p.thick=1.0
    !x.thick=1.0
    !y.thick=1.0
    
endelse
end
