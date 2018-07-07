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
pro snrresults,filelist
;############################
;
; NAME:                  snrresults
; PURPOSE:               documents results of the STELLA-pipeline
;                        tests with different parameter values, computed with
;                        CALCSNR
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      snrresults,'filelist'
; INPUTS:                input file: 'filelist':
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00025..calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.0005.calcsnr
;                         testsigma/HD175640_b_T09-15-03.193_437_500s_botzxsf_ecds_ylevel0.00075.calcsnr
;                                            .
;                                            .
;                                            .
; OUTPUTS:               strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'.ps'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;

if n_elements(filelist) eq 0 then begin
    print,'snrresults: No file specified, return 0.'
    print,'snrresults: USAGE: snrresults,filelist'
end else begin

;countlines
  maxn = 0UL
  maxn = countlines(filelist)
  print,filelist,': ',maxn,' FILES'
  parameter = ''

;build arrays
  files = strarr(maxn)
  parval = dblarr(maxn)
  i = 0UL
  j = 0UL
  k = 0UL
  iq = ''
  jq = ''
  kq = ''

;read file in arrays
  print,'snrresults: reading file ',filelist
  close,1
  openr,1,filelist
  for i=0UL,maxn-1 do begin
    readf,1,iq
    files(i) = iq
    parameter = strmid(iq,0,strpos(iq,'.',/REVERSE_SEARCH))
    parameter = strmid(parameter,strpos(parameter,'_',/REVERSE_SEARCH))
    parval(i) = parameter
    print,'snrresults: parval(',i,') = ',parval(i)
  end
  parameter = strmid(files(0),0,strpos(files(0),'_',/REVERSE_SEARCH))
  parameter = strmid(parameter,strpos(parameter,'_',/REVERSE_SEARCH)+1)
  print,'snrresults: parameter = '+parameter
  close,1  

  close,2
  openr,2,files(0)
  maxm = countlines(files(0))
  print,'snrresults: ',files(0),' contains ',maxm,' lines'
  nareas = 0.
  nareas = (maxm-6.)/8.
  print,'snrresults: nareas = ',nareas
  close,2

  xmin   = dblarr(maxn,nareas)
  xmax   = dblarr(maxn,nareas)
  snr    = dblarr(maxn,nareas+1)
  mtar   = dblarr(maxn,nareas+1)
  ylevel = dblarr(maxn)

  for i=0UL,maxn-1 do begin
;      dumstring = strmid(files(i),strpos(files(i),'ylevel')+6,strpos(files(i),'.calc')-strpos(files(i),'ylevel')-6)
;      print,'snrresults: dumstring_ylevel = ',dumstring
;      ylevel(i) = dumstring
;      print,'snrresults: ylevel = ',ylevel
      openr,2,files(i)
      j = 0UL
      for k=0UL,maxm-1 do begin
          readf,2,iq
          jq = strmid(strtrim(iq),0,strpos(strtrim(iq),' '))
          kq = strmid(strtrim(iq),strpos(strtrim(iq),' ',/REVERSE_SEARCH),strlen(strtrim(iq))-strpos(strtrim(iq),' ',/REVERSE_SEARCH))
          print,'snrresults: k = ',k,', iq = ',iq,', jq = ',jq,', kq = ',kq
          if jq eq 'posxmin' then xmin(i,j-1) = kq
          if jq eq 'posxmax' then xmax(i,j-1) = kq
          if jq eq 'snr' then snr(i,j) = kq
          if jq eq 'meantomeanabsdevratio' then begin
              mtar(i,j) = kq
              j = j+1
          end
      endfor
      close,2
      print,'snrresults: nareas = ',nareas,', fileno = ',i,', j = ',j
  endfor

; write results
  set_plot,'ps'
  device,filename=strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'.ps',/color
  mytitle ='!ATest of parameter '+parameter
  print,'mytitle = '+mytitle
  plot,parval,snr(*,0),/xlog,/ylog,psym=1,xtitle=parameter,ytitle='SNR',title=mytitle,position=[0.1,0.1,0.96,0.9]
  for i=1,nareas do begin
      oplot,parval,snr(*,i),psym=2
  endfor
  device,/close
  set_plot,'x'
  
endelse
end
