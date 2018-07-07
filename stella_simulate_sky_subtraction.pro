pro stella_simulate_sky_subtraction
  dblarr_lambda = [0.,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,11.,12.,13.,14.,15.,16.,17.,18.,19.]
  dblarr_star_cont = [18000.,18100.,18180.,18230.,18200.,18140.,18180.,18220.,18250.,18270.,18300.,18340.,18360.,18400.,18420.,18460.,18490.,18520.,18530.,18530.]
  dblarr_sky_cont = [250.,252.,253.,254.,254.,255.,257.,256.,257.,258.,259.,261.,262.,260.,259.,257.,256.,255.,253.,251.]

  dblarr_coeffs_sky = svdfit(dblarr_lambda,dblarr_sky_cont,4,YFIT=dblarr_sky_fit,STATUS=status_sky)
  print,'dblarr_sky_fit = ',dblarr_sky_fit
  print,'status_sky = ',status_sky
  dblarr_coeffs_star = svdfit(dblarr_lambda,dblarr_star_cont,4,YFIT=dblarr_star_fit,STATUS=status_star)
  print,'dblarr_star_fit = ',dblarr_star_fit
  print,'status_star = ',status_star

  dblarr_sky_fit = poly(dblarr_lambda,dblarr_coeffs_sky)
  print,'dblarr_sky_fit = ',dblarr_sky_fit
  dblarr_star_fit = poly(dblarr_lambda,dblarr_coeffs_star)
  print,'dblarr_star_fit = ',dblarr_star_fit
  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/coeffs_star_cont.dat',/GET_LUN
    for i=0ul, n_elements(dblarr_coeffs_star)-1 do begin
      printf,lun,strtrim(string(dblarr_coeffs_star(i)),2)
    endfor
  free_lun,lun
  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/coeffs_sky_cont.dat',/GET_LUN
    for i=0ul, n_elements(dblarr_coeffs_sky)-1 do begin
      printf,lun,strtrim(string(dblarr_coeffs_sky(i)),2)
    endfor
  free_lun,lun

  set_plot,'ps'
  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/sky_cont.ps'
   plot,dblarr_lambda,$
        dblarr_sky_cont,$
        psym=2
   oplot,dblarr_lambda,$
         dblarr_sky_fit
  device,/close

  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/star_cont.ps'
   plot,dblarr_lambda,$
        dblarr_star_cont,$
        psym=2
   oplot,dblarr_lambda,$
         dblarr_star_fit
  device,/close
  set_plot,'x'

  dbl_fwhm_sky = 0.01
  dbl_fwhm_star = 0.2

  dblarr_lines_sky = [0.75,1.2,3.5,3.6,3.8,5.9,7.8,8.,12.4,15.6,16.,17.6,17.75]
  dblarr_lines_amp_sky = [10000.,12000.,10000.,2000.,5000.,15000.,16000.,12000.,25000.,20000.,12000.,8000.,13000.]
  dblarr_lines_star = [1.,5.,6.,8.,12.,14.,14.5,19.]
  dblarr_lines_amp_star = [-2000.,-4000.,-6000.,-4000.,-2000.,-10000.,-5000.,-1000.]

  dblarr_slambda = dindgen(2000)/100.
  dblarr_ssky_cont = poly(dblarr_slambda,dblarr_coeffs_sky)
  dblarr_sstar_cont = poly(dblarr_slambda,dblarr_coeffs_star)
  dblarr_ssky = dblarr_ssky_cont
  dblarr_sstar = dblarr_sstar_cont

  for i=0ul, n_elements(dblarr_lines_sky)-1 do begin
    dblarr_temp = dblarr_lines_amp_sky(i)*exp(-(dblarr_slambda-dblarr_lines_sky(i))^2./(2.*dbl_fwhm_sky^2.))
    dblarr_ssky = dblarr_ssky + dblarr_temp
  endfor
  set_plot,'ps'
  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/sky.ps'
   plot,dblarr_slambda,$
        dblarr_ssky
  device,/close
  set_plot,'x'

  for i=0ul, n_elements(dblarr_lines_star)-1 do begin
    dblarr_temp = dblarr_lines_amp_star(i)*exp(-(dblarr_slambda-dblarr_lines_star(i))^2./(2.*dbl_fwhm_star^2.))
    dblarr_sstar = dblarr_sstar + dblarr_temp
  endfor
  set_plot,'ps'
  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/star.ps'
   plot,dblarr_slambda,$
        dblarr_sstar
  device,/close

  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/lambda_sky_star.dat',/GET_LUN
    for i=0ul, n_elements(dblarr_ssky)-1 do begin
      printf,lun,strtrim(string(dblarr_slambda(i)),2)+' '+strtrim(string(dblarr_ssky(i)),2)+' '+strtrim(string(dblarr_sstar(i)),2)
    endfor
  free_lun,lun
;  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/star.dat',/GET_LUN
;    for i=0ul, n_elements(dblarr_sstar)-1 do begin
;      printf,lun,dblarr_sstar(i)
;    endfor
;  free_lun,lun
;  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/lambda.dat',/GET_LUN
;    for i=0ul, n_elements(dblarr_slambda)-1 do begin
;      printf,lun,dblarr_slambda(i)
;    endfor
;  free_lun,lun

  dblarr_sspec = dblarr_ssky + dblarr_sstar
  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/sspec.ps'
   plot,dblarr_slambda,$
        dblarr_sspec
  device,/close

  ; --- calculate trace function
  dblarr_row = [0.,100.,200.,300.,400.,500.,600.,700.,800.,900.,1000.,1100.,1200.,1300.,1400.,1500.,1600.,1700.,1800.,1900.]
  dblarr_col = [181.,182.,183.,185.,187.,189.,191.,193.,195.,197.,200.,203.,206.,209.,212.,216.,218.,222.,226.,230.]
  dblarr_coeffs_trace = svdfit(dblarr_row, dblarr_col,2,YFIT=dblarr_trace_fit)
  print,dblarr_trace_fit
  openw,lun,'/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/coeffs_trace.dat',/GET_LUN
    for i=0ul, n_elements(dblarr_coeffs_trace)-1 do begin
      printf,lun,strtrim(string(dblarr_coeffs_trace(i)),2)
    endfor
  free_lun,lun
stop
  int_col_star = 100
  int_ncols = 2000
  dblarr_spec = dblarr(n_elements(dblarr_slambda),int_ncols)
  for i=0ul, int_ncols-1 do begin
    if i eq int_col_star then begin
      dblarr_spec(*,i) = dblarr_ssky + dblarr_sstar
    end else begin
      dblarr_spec(*,i) = dblarr_ssky
    end
  endfor

  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/spec.ps'
  shade_surf,dblarr_spec
  device,/close

  ; --- convolve with psf
  dbl_sigma_psf = 150.
  dblarr_lambda = dblarr_slambda + 7000.
  dblarr_ccd = dblarr(n_elements(dblarr_lambda),2*int_ncols)

  for i_end=0ul, n_elements(dblarr_lambda)-1 do begin
    for j_end=0ul, (2*int_ncols)-1 do begin
      for i_orig=0, n_elements(dblarr_lambda)-1 do begin
        for j_orig=0, int_ncols-1 do begin
          dblarr_ccd(i_end,j_end) = dblarr_ccd(i_end,j_end)+dblarr_spec(i_orig,j_orig)*exp(-((i_end-i_orig)^2/(2.*dbl_sigma_psf)^2. + (j_end-j_orig)^2./(2.*dbl_sigma_psf)^2.))
        endfor
;        print,'i_orig = ',i_orig
      endfor
      print,'j_end = ',j_end
    endfor
    print,'i_end = ',i_end
  endfor
  device,filename='/home/azuri/entwicklung/stella/ses-pipeline/c/msimulateskysubtraction/data/ccd.ps'
  shade_surf,dblarr_ccd
  device,/close

  set_plot,'x'
  stop
end
