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
pro snrresults_lus,filelist,arealist
;############################
;
; NAME:                  snrresults_lus
; PURPOSE:               documents results of the STELLA-pipeline
;                        tests with different LOWER- and
;                        UPPERREJECTIONSIGMAS, computed with CALCSNR
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      snrresults_lus,'snrresults_testsigmas.list','testareas.list'
; INPUTS:                input file: 'snrresults_testsigmas.list':
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.01.calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.05.calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ls0.01_us0.1.calcsnr
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
    filelist = 'snrresults_testsigma_files.list'
    arealist = 'testareas.list'
end
if n_elements(arealist) eq 0 then begin
    print,'snrresults_lus: No file specified, return 0.'
    print,'snrresults_lus: USAGE: snrresults_lus,filelist,arealist'
end else begin

;countlines
  maxn = 0UL
  maxn = countlines(filelist)
  print,filelist,': ',maxn,' FILES'

  nareas = 0UL
  nareas = countlines(arealist)
  print,arealist,': ',nareas,' FILES'
  
;build arrays
  files = strarr(maxn)
  lmin  = dblarr(nareas)
  lmax  = dblarr(nareas)
  i = 0UL
  j = 0UL
  k = 0UL
  iq = ''
  jq = ''
  kq = ''

;read file in arrays
  print,'snrresults_lus: reading file ',filelist
  close,1
  openr,1,filelist
  for i=0UL,maxn-1 do begin
    readf,1,iq
    files(i) = iq
  end
  close,1  

  print,'snrresults_lus: reading file ',arealist
  close,1
  openr,1,arealist
  for i=0UL,nareas-1 do begin
    readf,1,iq
    lmin(i) = strmid(strtrim(iq,2),0,strpos(strtrim(iq,2),' '))
    lmax(i) = strmid(strtrim(iq,2),strpos(strtrim(iq,2),' ')+1,strlen(strtrim(iq,2))-strpos(strtrim(iq,2),' ')-1)
    print,'lmin(',i,') = ',lmin(i),', lmax(',i,') = ',lmax(i)    
  end
  close,1  

;  close,2
;  openr,2,files(0)
  maxm = countlines(files(0))
  print,'snrresults_lus: ',files(0),' contains ',maxm,' lines'
;  nareas = 0.
;  nareas = (maxm-6.)/8.
;  print,'snrresults_lus: nareas = ',nareas
;  close,2

  xmin   = dblarr(maxn,nareas)
  xmax   = dblarr(maxn,nareas)
  snr    = dblarr(maxn,nareas+1)
  mtar   = dblarr(maxn,nareas+1)
  lsigma = dblarr(maxn)
  usigma = dblarr(maxn)

  for i=0UL,maxn-1 do begin
      dumstring = strmid(files(i),strpos(files(i),'_ls')+3,strpos(files(i),'_us')-strpos(files(i),'_ls')-3)
      print,'snrresults_lus: dumstring_ls = ',dumstring
      lsigma(i) = dumstring
      dumstring = strmid(files(i),strpos(files(i),'_us')+3,strpos(files(i),'.calc')-strpos(files(i),'_us')-3)
      print,'snrresults_lus: dumstring_us = ',dumstring
      usigma(i) = dumstring
      print,'snrresults_lus: lsigma = ',lsigma(i),', usigma = ',usigma(i)
      maxm = countlines(files(i))
      close,2
      openr,2,files(i)
      j = 0UL
      for k=0UL,maxm-1 do begin
          readf,2,iq
          jq = strmid(strtrim(iq),0,strpos(strtrim(iq),' '))
          kq = strmid(strtrim(iq),strpos(strtrim(iq),' ',/REVERSE_SEARCH),strlen(strtrim(iq))-strpos(strtrim(iq),' ',/REVERSE_SEARCH))
          print,'snrresults_lus: k = ',k,', iq = ',iq,', jq = ',jq,', kq = ',kq
          if jq eq 'posxmin' then xmin(i,j-1) = kq
          if jq eq 'posxmax' then xmax(i,j-1) = kq
          if jq eq 'snr' then snr(i,j) = kq
          if jq eq 'meantomeanabsdevratio' then begin
              mtar(i,j) = kq
              j = j+1
          end
      endfor
      close,2
      print,'snrresults_lus: nareas = ',nareas,', fileno = ',i,', j = ',j
  endfor

; write results
;  set_plot,'ps'
;  device,filename=strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'.ps',/color

;Define custom plotting symbols:
  oOrb = OBJ_NEW('orb', COLOR=[0, 0, 255])
  oOrb->Scale, .25, .15, .25
  oSymbol = OBJ_NEW('IDLgrSymbol', oOrb)
;  mytitle = 'w = '+strtrim(string(xmin(0,0)),2)+' - '+strtrim(string(xmax(0,0)),2)+' A'
;  xplot3d,lsigma,usigma,snr(*,0),symbol=oSymbol,title=mytitle,xtitle='lower sigma',ytitle='upper sigma',ztitle='SNR',name=mytitle,linestyle=0
  for i=0,nareas do begin
      if i eq 0 then mytitle = 'whole wavelengthrange' $
      else mytitle = 'w = '+strtrim(string(lmin(i-1)),2)+' - '+strtrim(string(lmax(i-1)),2)+' '+STRING("305B)
      xplot3d,lsigma,usigma,snr(*,i),symbol=oSymbol,title=mytitle,xtitle='lower sigma',ytitle='upper sigma',ztitle='SNR',name=mytitle,linestyle=6
;,/overplot
  endfor
;  device,/close
;  set_plot,'x'
  
endelse
end
