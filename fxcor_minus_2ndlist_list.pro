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
;common maxn
;############################
pro fxcor_minus_2ndlist_list,inlist,sublist,outfile
;############################
;common maxn
;############################
;
; NAME:                  fxcor_minus_2ndlist_list.pro
; PURPOSE:               removes values 'inlist' from values of files
;                        in sublist
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fxcor_minus_2ndlist,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r_refHD209290_-3.5_120_90_90_90_-2_trimmed.dat','/yoda/UVES/MNLupus/ready/fxcor_dats_red.list','outlist'
; INPUTS:                input file: inlist: '/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r_refHD209290_-3.5_120_90_90_90_-2_trimmed.dat'
;                        #N HJD HGHT FWHM VOBS VREL VHELIO VERR
;                        #U days          km/s km/s km/s   km/s
;                        1691.4790 0.41 265.58 3.2223 13.4949 0.1771  10.186
;                        ...
;                        input file: sublist: '/yoda/UVES/MNLupus/ready/fxcor_dats_red.list'
;                                    red_r/fxcor...data
;                                    fxcor...data
;                                    ...
; OUTPUTS:               outfile+'_vobs.data',outfile+'_vrel.data',outfile+'_vhelio.data'
;                        and (   -    II    -   ).ps
; COPYRIGHT:             Andreas Ritter
; DATE:                  27.08.2004
;
;                        headline
;                        feetline (up to now not used) 
;

if n_elements(outfile) lt 1 then begin
  print,'fxcor_minus_2ndlist_list: ERROR: not enough parameters specified!'
  print,"fxcor_minus_2ndlist_list: USAGE: fxcor_minus_2ndlist_list,'inlist','outfile'"
endif else begin
  maxn = countlines(sublist)
  filearr = strarr(maxn)
  filenameq = ''
  linestr = ''
  hjdq = ''
  hjdqstr = ''
  vobsoutfile = outfile+'_vobs.data'
  vreloutfile = outfile+'_vrel.data'
  vheliooutfile = outfile+'_vhelio.data'
  path = strmid(sublist,0,strpos(sublist,'/',/REVERSE_SEARCH)+1)
  print,'fxcor_minus_2ndlist_list: path = '+path

; --- read sublist
;  close,1
  openr,lun,sublist,/get_lun
  for i=0,maxn-1 do begin
    readf,lun,filenameq
    filearr(i) = path+strtrim(filenameq,2)
  endfor
  free_lun,lun

; --- write hjds as table headers
  openr,lun,filearr(0),/get_lun
  maxm = countlines(filearr(0))
  for i=0,maxm-1 do begin
    readf,lun,linestr
    if i ge 2 then begin
      linestr = strtrim(linestr,2)
      hjdq = strmid(linestr,0,strpos(linestr,' '))
      hjdqstr = hjdqstr+hjdq+' '
    endif
  endfor
  free_lun,lun
;  close,2
;  close,3
;  close,4
  openw,lun,vobsoutfile,/get_lun
  printf,lun,hjdqstr
  free_lun,lun
  openw,lun,vreloutfile,/get_lun
  printf,lun,hjdqstr
  free_lun,lun
  openw,lun,vheliooutfile,/get_lun
  printf,lun,hjdqstr
  free_lun,lun
;  close,2
;  close,3
;  close,4
  
; --- execute fxcor_minus_2ndlist for infiles
  for i=0,maxn-1 do begin
    fxcor_minus_2ndlist,filearr(i),inlist,strmid(filearr(i),0,strpos(filearr(i),'.',/REVERSE_SEARCH))+'_minus_'+strmid(inlist,strpos(inlist,'/',/REVERSE_SEARCH)+1,strlen(inlist)-strpos(inlist,'/',/REVERSE_SEARCH)-1),outfile,'print'
  endfor

endelse
end
