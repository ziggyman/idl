;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;############################
pro calcsnrlist,filelist,arealist
;############################
;
; NAME:                  calcsnrlist
; PURPOSE:               starts CALCSNR for every file given in
;                        FILELIST
;                        * first without XMIN and XMAX
;                        * then with different XMINs and XMAXs
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcsnrlist,'HD_textfiles.list','testareas.list'
; INPUTS:                input file: 'HD_textfiles.list':
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                         HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                                            .
;                                            .
;                                            .
;                        imput file: 'testareas.list':
;                         3906.545 3907.264
;                         4005.609 4010.746
;                         4184.529 4186.176
;                                 .
;                                 .
;                                 .
; OUTPUTS:               
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;
if n_elements(filelist) eq 0 then begin
    filelist = 'HD_textfiles.list'
    arealist = 'testareas.list'
end

if n_elements(arealist) eq 0 then begin
    print,'calcsnrlist: Not enough parameters, return 0.'
    print,"calcsnrlist: USAGE: calcsnrlist,'HD_textfiles.list','testareas.list'"
end else begin

;--- countlines
  maxn = 0UL
  maxn = countlines(filelist)
  print,'calcsnrlist: ',filelist,': ',maxn,' FILES'

  nareas = 0UL
  nareas = countlines(arealist)
  print,'calcsnrlist: ',arealist,': ',nareas,' FILES'

;--- find path
  path = strmid(filelist,0,strpos(filelist,'/',/REVERSE_SEARCH)+1)
  print,'path = '+path

;--- build arrays
  file = strarr(maxn)
  datx = dblarr(100)
  daty = dblarr(100)
  lmin = dblarr(nareas)
  lmax = dblarr(nareas)

  xdum = 0.
  ydum = 0.
  
;read file in arrays
  iq = ' '
  print,'calcsnrlist: reading file ',filelist
  close,1
  openr,1,filelist
  for i=0,maxn-1 do begin
    readf,1,iq
    file(i) = path+iq
  end
  close,1  

  print,'calcsnrlist: reading file ',arealist
  close,1
  openr,1,arealist
  for i=0,nareas-1 do begin
    readf,1,iq
    lmin(i) = strmid(strtrim(iq,2),0,strpos(strtrim(iq,2),' '))
    lmax(i) = strmid(strtrim(iq,2),strpos(strtrim(iq,2),' ')+1,strlen(strtrim(iq,2))-strpos(strtrim(iq,2),' ')-1)
    print,'lmin(',i,') = ',lmin(i),', lmax(',i,') = ',lmax(i)
  end
  close,1  

  for i=0,maxn-1 do begin
      outfilename = strmid(file(i),0,strpos(file(i),'.',/REVERSE_SEARCH))+'.calcsnr'
      spawn,'rm -f '+outfilename
      datfilename = strmid(file(i),0,strpos(file(i),'.',/REVERSE_SEARCH))+'.dat'
      spawn,'rm -f '+datfilename
      calcsnr,file(i),outfilename,datfilename
      for j=0,nareas-1 do begin
          calcsnr,file(i),outfilename,datfilename,lmin(j),lmax(j)
      endfor
      close,5
;      nareas = countlines(datfilename)
      datx = congrid(datx,nareas)
      daty = congrid(daty,nareas)
      openr,5,datfilename
      for j=0,nareas-1 do begin
          readf,5,xdum,ydum
          datx(j) = xdum
          daty(j) = ydum
      endfor
      close,5
      set_plot,'ps'
      device,filename=strmid(file(i),0,strpos(file(i),'.',/reverse_search))+'.ps',/color
      if strpos(file(i),'ylevel') ge 1 then begin
          mytitle = '!Aobsaplimit = +/- '+strmid(file(i),strpos(file(i),'obsaplimit')+12,strpos(file(i),'/')-strpos(file(i),'obsaplimit')-12)+', ylevel = '+strmid(file(i),strpos(file(i),'ylevel')+6,strpos(file(i),'.',/REVERSE_SEARCH)-strpos(file(i),'ylevel')-6)
      end else if (strpos(file(i),'_ls') ge 1) and (strpos(file(i),'_us') ge 1) then begin
          mytitle = '!Alsigma = '+strmid(file(i),strpos(file(i),'_ls')+3,strpos(file(i),'_us')-strpos(file(i),'_ls')-3)
          tempstring = strmid(file(i),strpos(file(i),'_us')+3,strlen(file(i))-strpos(file(i),'_us')-3)
          if strpos(tempstring,'_') lt 1 then begin
              mytitle = mytitle+', usigma = '+strmid(file(i),strpos(file(i),'_us')+3,strpos(file(i),'.',/REVERSE_SEARCH)-strpos(file(i),'_us')-3)
          end else begin
              mytitle = mytitle+', usigma = '+strmid(file(i),strpos(file(i),'_us')+3,strpos(file(i),'_',/REVERSE_SEARCH)-strpos(file(i),'_us')-3)
          end
      end else if strpos(file(i),'_nobg') gt 0 then begin
          mytitle = '!Afit1d without background subtraction'
      end else if strpos(file(i),'f1d') gt 0 then begin
          mytitle = '!Afit1d with background subtraction'
      end else begin
          mytitle = strmid(file(i),strpos(file(i),'/',/REVERSE_SEARCH)+1,strlen(file(i))-strpos(file(i),'/',/REVERSE_SEARCH)-1)
      end
      plot,datx,daty,xtitle='wavelength ['+STRING("305B)+']',ytitle='SNR',title=mytitle,psym=2,position=[0.15,0.1,0.98,0.9]
      device,/close
      set_plot,'x'
  end

endelse
end
