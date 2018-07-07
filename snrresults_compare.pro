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
pro snrresults_compare,filelist_UVES,filelist_STELLA
;############################
;
; NAME:                  snrresults_compare
; PURPOSE:               compares the results of the STELLA-pipeline
;                        and the UVES-pipeline
;                        pre: CALCSNR
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      snrresults_compare,'filelist_UVES','filelist_STELLA'
; INPUTS:                input file: 'filelist...':
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00025..calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.0005.calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00075.calcsnr
;                                            .
;                                            .
;                                            .
; OUTPUTS:               strmid(filelist,0,strpos(filelist_STELLA,'.',/reverse_search))+'.ps'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;

if n_elements(filelist_STELLA) eq 0 then begin
    print,'snrresults_compare: Not enough parameters specified, return 0.'
    print,"snrresults_compare: USAGE: snrresults_compare,'filelist_UVES','filelist_STELLA'"
end else begin

;countlines
  maxmu = 0UL
  maxms = 0UL
  maxnu = 0UL
  maxnu = countlines(filelist_UVES)
  print,filelist_UVES,': ',maxnu,' FILES'
  maxns = 0UL
  maxns = countlines(filelist_STELLA)
  print,filelist_STELLA,': ',maxns,' FILES'

;build arrays
  filesu = strarr(maxnu)
  filess = strarr(maxns)
  i = 0UL
  j = 0UL
  k = 0UL
  iq = ''
  jq = ''
  kq = ''

;read file in arrays
  print,'snrresults_compare: reading file ',filelist_UVES
  close,1
  openr,1,filelist_UVES
  for i=0UL,maxnu-1 do begin
    readf,1,iq
    filesu(i) = iq
  end
  close,1  
  openr,1,filelist_STELLA
  for i=0UL,maxns-1 do begin
    readf,1,iq
    filess(i) = iq
  end
  close,1  

  close,2
  openr,2,filesu(0)
  maxmu = countlines(filesu(0))
  print,'snrresults_compare: ',filesu(0),' contains ',maxm,' lines'
  nareas = 0.
  nareas = (maxm-6.)/8.
  print,'snrresults_compare: nareas = ',nareas
  close,2

  xminu   = dblarr(maxnu,nareas)
  xmaxu   = dblarr(maxnu,nareas)
  xarru   = dblarr(maxnu,nareas)
  snru    = dblarr(maxnu,nareas+1)
  mtaru   = dblarr(maxnu,nareas+1)

  xmins   = dblarr(maxns,nareas)
  xmaxs   = dblarr(maxns,nareas)
  xarrs   = dblarr(maxns,nareas)
  snrs    = dblarr(maxns,nareas+1)
  mtars   = dblarr(maxns,nareas+1)

  for i=0UL,maxnu-1 do begin
;      dumstring = strmid(filesu(i),strpos(filesu(i),'ylevel')+6,strpos(filesu(i),'.calc')-strpos(filesu(i),'ylevel')-6)
;      print,'snrresults_compare: dumstring_ylevel = ',dumstring
;      ylevel(i) = dumstring
;      print,'snrresults_compare: ylevel = ',ylevel
      openr,2,filesu(i)
      j = 0UL
      for k=0UL,maxmu-1 do begin
          readf,2,iq
          jq = strmid(strtrim(iq),0,strpos(strtrim(iq),' '))
          kq = strmid(strtrim(iq),strpos(strtrim(iq),' ',/REVERSE_SEARCH),strlen(strtrim(iq))-strpos(strtrim(iq),' ',/REVERSE_SEARCH))
          print,'snrresults_compare: k = ',k,', iq = ',iq,', jq = ',jq,', kq = ',kq
          if jq eq 'posxmin' then xminu(i,j-1) = kq
          if jq eq 'posxmax' then begin
              xmaxu(i,j-1) = kq
              xarru(i,j-1) = xminu(i,j-1)+((xmaxu(i,j-1)-xminu(i,j-1))/2.)
          endif
          if jq eq 'snr' then snru(i,j) = kq
          if jq eq 'meantomeanabsdevratio' then begin
              mtaru(i,j) = kq
              j = j+1
          end
      endfor
      close,2
      print,'snrresults_compare: nareas = ',nareas,', fileno = ',i,', j = ',j
  endfor
  for i=0UL,maxns-1 do begin
;      dumstring = strmid(filesu(i),strpos(filesu(i),'ylevel')+6,strpos(filesu(i),'.calc')-strpos(filesu(i),'ylevel')-6)
;      print,'snrresults_compare: dumstring_ylevel = ',dumstring
;      ylevel(i) = dumstring
;      print,'snrresults_compare: ylevel = ',ylevel
      openr,2,filess(i)
      j = 0UL
      for k=0UL,maxms-1 do begin
          readf,2,iq
          jq = strmid(strtrim(iq),0,strpos(strtrim(iq),' '))
          kq = strmid(strtrim(iq),strpos(strtrim(iq),' ',/REVERSE_SEARCH),strlen(strtrim(iq))-strpos(strtrim(iq),' ',/REVERSE_SEARCH))
          print,'snrresults_compare: k = ',k,', iq = ',iq,', jq = ',jq,', kq = ',kq
          if jq eq 'posxmin' then xmins(i,j-1) = kq
          if jq eq 'posxmax' then begin
              xmaxs(i,j-1) = kq
              xarrs(i,j-1) = xmins(i,j-1)+((xmaxs(i,j-1)-xmins(i,j-1))/2.)
          endif
          if jq eq 'snr' then snrs(i,j) = kq
          if jq eq 'meantomeanabsdevratio' then begin
              mtars(i,j) = kq
              j = j+1
          end
      endfor
      close,2
      print,'snrresults_compare: nareas = ',nareas,', fileno = ',i,', j = ',j
  endfor

; write results
  set_plot,'ps'
  device,filename=strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'.ps',/color
  ;mytitle ='!Aobsaplimit='+strmid(filelist,strpos(filelist,'obsaplimit')+10,strpos(filelist,'_files')-strpos(filelist,'obsaplimit')-10)
;  print,'mytitle = '+mytitle
  plot,xarru(*,0),snru(*,0),/xlog,/ylog,psym=1,xtitle='wavelength ['+STRING("305B)+']',ytitle='SNR',position=[0.1,0.1,0.96,0.9]
  for i=1,nareas do begin
      oplot,xarru(*,i),snru(*,i),psym=2
  endfor
  oplot,xarrs(*,0),snrs(*,0),/xlog,/ylog,psym=1,color=1
  for i=1,nareas do begin
      oplot,xarrs(*,i),snrs(*,i),psym=2,color=1
  endfor
  
  device,/close
  set_plot,'x'
  
endelse
end
