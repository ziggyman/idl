pro stella_plot_xcorprof
  str_plotname = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/D_A1_XCorProf_Out.ps'
  set_plot,'ps'
  device,filename=str_plotname

  str_filename_bound = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/I_A2_IBound.dat'
  intarr_bound = long(readfiletostrarr(str_filename_bound,' '))
  print,intarr_bound
  
  for i=0ul, 18 do begin
    str_filename_xcor_out = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/D_A1_XCorProf_Out__Ap0_IBin'+strtrim(string(i),2)+'_IRunTel1.fits'
    str_filename_xcor_fit = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/D_A1_XCorProf_Fit__Ap0_IBin'+strtrim(string(i),2)+'_IRunTel1.fits'
    str_filename_xcor_diff = '/home/azuri/entwicklung/idl/REDUCE/16_03_2013/D_A1_XCorProf_Diff__Ap0_IBin'+strtrim(string(i),2)+'_IRunTel1.fits'
  
    dblarr_out = double(readfiletostrarr(str_filename_xcor_out,' '))
    dblarr_fit = double(readfiletostrarr(str_filename_xcor_fit,' '))
    dblarr_diff = double(readfiletostrarr(str_filename_xcor_diff,' '))
  
    print,'dblarr_out = ',dblarr_out
    
    intarr_size = size(dblarr_out)
    indgen_x = lindgen(intarr_size(1)) + intarr_bound(i,0)

    if i eq 0 then begin
      plot,dblarr_out,xrange=[0,4096],xstyle=1,yrange=[-0.2, 0.1],ystyle=1
    end else begin
      oplot,indgen_x,dblarr_out
    endelse
    oplot,indgen_x,dblarr_fit,linestyle=2
    oplot,indgen_x,dblarr_diff,linestyle=3
  endfor
  device,/close
  set_plot,'x'
end
