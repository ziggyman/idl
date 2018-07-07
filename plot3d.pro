;############################
pro plot3d,datafile
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

if n_elements(datafile) eq 0 then begin
    datafile = '/home/azuri/entwicklung/c/fitsutil/cfits/test/2D_PixArray.dat'
end

;countlines
  nrows = 0UL
  nrows = countlines(datafile)
  print,datafile,': ',nrows,' lines'

;countcols
  ncols = 0UL
  ncols = countcols(datafile)
  print,datafile,': ',ncols,' columns'

;build arrays
  data  = dblarr(ncols, nrows)
  i = 0UL
  j = 0UL
  iq = ''
  jq = ''
  kq = ''

;read file in arrays
  print,'plot3d: reading file ',datafile
  openr,lun,datafile,/GET_LUN
  for i=0UL,nrows-1 do begin
    readf,lun,iq 
    for j=0UL, ncols-1 do begin
      iq = strtrim(iq)
      jq = strmid(iq,0,strpos(strtrim(iq),' '))
      data(j, i) = jq
    endfor
;    print, 'plot3d: row ',i,': ',data(i, *)
  endfor
  close,lun

; write results
;  set_plot,'ps'
;  device,filename=strmid(filelist,0,strpos(filelist,'.',/reverse_search))+'.ps',/color

  surface,data
;  device,/close
;  set_plot,'x'
  
end
