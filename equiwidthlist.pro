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
pro equiwidthlist,filelist,xmiddle,xmin,xmax,npixlowl,npixlowu,npixhighl,npixhighu,hjdlist
;############################
;
; NAME:                  equiwidth
; PURPOSE:               * calculates the equivalent widths within a
;                          given wavelengthrange (xmin - xmax) for a
;                          list of files
;                        * plots equivalent widths over hjd
;                        * calculates mean and rms of equivalent widths
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      equiwidthlist,'filelist',xmin,xmax
; INPUTS:                input file: 'filelist':
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.text
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:39:57.321_botzfsx_ecd_ctc.text
;                                 .
;                                 .
;                                 .
;                        input file: 'hjdlist':
;                          2451691.5531219
;                          2451691.58047251
;                              ...
;                        xmin, xmax: Real
; OUTPUTS:               outfile: '<datfile>_<xmin>-<xmax>.text'
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.04.2004
;

if n_elements(hjdlist) eq 0 then begin
    print,'equiwidthlist: Not enough arguments specified, return 0.'
    print," USAGE: equiwidthlist,'filelist',xmin:Real,xmax:Real"
end else begin   

;define variables
    fileq    = ''
    equiq    = 0.d
    hjdq     = 0.d
    equimean = 0.d
    equirms  = 0.d

;countlines
    maxn = countlines(filelist)
    print,filelist+': '+string(maxn)+' FILES'  

;build arrays
    file = strarr(maxn)
    equi = dblarr(maxn)
    hjd  = dblarr(maxn)
    path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)

;read file in arrays
    openr,lun,filelist,/GET_LUN
    for i=0,maxn-1 do begin  
        readf,lun,fileq
;        print,i,lambdaq,intensq, FORMAT = '(F15.0 , "lambdaq = " , F15.7 , " intensq = " , F15.7 )'
        file(i) = path+fileq
    end  
    free_lun,lun

;equiwidth
    outfile = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)+'equiwidths_'+strmid(filelist,strpos(filelist,'/',/REVERSE_SEARCH)+1)
;    print,'equiwidthlist: outfile = '+outfile
    outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))
    outfile = strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(xmiddle),2)+'.data'
    print,'equiwidthlist: outfile = '+outfile
    openw,lun,outfile,/GET_LUN
    for i=0,maxn-1 do begin
        equiwidth,file(i),xmiddle,xmin,xmax,npixlowl,npixlowu,npixhighl,npixhighu,outfile
    end
    free_lun,lun

; print results
    openr,lun,outfile,/GET_LUN
    openr,luna,hjdlist,/GET_LUN
    maxm = countlines(outfile)
    maxl = countlines(hjdlist)
    print,'equiwidthlist: outfile '+outfile+' contains '+strtrim(string(maxm),2)+', hjdlist '+hjdlist+' '+strtrim(string(maxl),2)+' lines'
    if maxm eq maxl then begin
        for j=0,maxm-1 do begin
            readf,lun,fileq;,equiq
;            print,'equiwidthlist: string read from outfile = <'+fileq+'>'
            equiq = strtrim(strmid(fileq,strpos(fileq,' ')),2)
            equi(j) = equiq
            readf,luna,hjdq
;            print,j,hjdq,equiq, FORMAT = '(F15.0, "hjdq = ", F15.7 , " equiq = ", F15.7)'
            hjd(j) = hjdq
        endfor
        set_plot,'ps'
        fname=strmid(outfile,0,strpos(outfile,'.',/REVERSE_SEARCH))+'.ps'
        print,'equiwidthlist: fname = '+fname
        device,filename=fname
;        plot,hjd[0:maxm-1]-hjd(0),equi[0:maxm-1],xstyle=1,xrange=[0-((hjd(maxm-1)-hjd(0))/10.),$
;             hjd(maxm-1)-hjd(0)+((hjd(maxm-1)-hjd(0))/10.)],yrange=[min(equi)-((max(equi)-min(equi))/10.),$
;             max(equi)+((max(equi)-min(equi))/10.)],ystyle=1,psym=2,xtitle='HJD - '+strtrim(string(FORMAT='(F11.3)',$
;             hjd(0)),2),ytitle='euqivalent width',title='MN Lup: '+strtrim(string(xmin),2)+' - '+$
;             strtrim(string(xmax),2)+' '+STRING("305B),charsize=1.,charthick=2,xthick=2,ythick=2,$
;             position=[0.12,0.1,0.98,0.93]
        plot,hjd[0:maxm-1],equi[0:maxm-1],xstyle=1,xrange=[hjd(0)-((hjd(maxm-1)-hjd(0))/10.),hjd(maxm-1)+((hjd(maxm-1)-hjd(0))/10.)],$
             yrange=[min(equi)-((max(equi)-min(equi))/10.),$
             max(equi)+((max(equi)-min(equi))/10.)],ystyle=1,psym=2,xtitle='HJD [days]',$
             ytitle='euqivalent width ['+STRING("305B)+']',title='MN Lup: '+strtrim(string(xmin),2)+' - '+$
             strtrim(string(xmax),2)+' '+STRING("305B),charsize=1.,charthick=2,xthick=2,ythick=2,$
             position=[0.13,0.1,0.94,0.93],xticks=5,xtickformat='(F9.1)'
        device,/close
        set_plot,'x'
        equimean = mean(equi[0:maxm-1])
        equirms  = stddev(equi[0:maxm-1])
        print,'equiwidthlist: mean = '+strtrim(string(equimean),2),', rms = '+strtrim(string(equirms),2)
    end else begin
        print,'equiwidthlist: ERROR: number of lines in outfile(='+outfile+') not equal to hjdlist (='+hjdlist+')'
    end
    free_lun,lun
    free_lun,luna
    
    if equimean ne 0. and equirms ne 0. then begin
        openw,lun,outfile,/GET_LUN,/APPEND
        printf,lun,'mean = '+strtrim(string(equimean),2)
        printf,lun,'rms  = '+strtrim(string(equirms),2)
        free_lun,lun
    end
    
endelse
end
