pro plot_arc_lamps
  for i_lamp=0ul, 4 do begin
    if i_lamp eq 0 then begin
      str_filename_high_r = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/ThAr_cal.dat'
      str_filename_low_r = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/ThAr_cal_R100.dat'
      str_filename_lowrb = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/ThAr_cal_R100_rb.dat'
    end else if i_lamp eq 1 then begin
      str_filename_high_r = '/home/azuri/daten/STELLA-pipeline/Arcs/HeNeAr/HeNeAr_cal.dat'
      str_filename_low_r = '/home/azuri/daten/STELLA-pipeline/Arcs/HeNeAr/HeNeAr_cal_R100.dat'
      str_filename_lowrb = '/home/azuri/daten/STELLA-pipeline/Arcs/HeNeAr/HeNeAr_cal_R100_rb.dat'
    end else if i_lamp eq 2 then begin
      str_filename_high_r = '/home/azuri/daten/STELLA-pipeline/Arcs/FeAr/FeAr_cal.dat'
      str_filename_low_r = '/home/azuri/daten/STELLA-pipeline/Arcs/FeAr/FeAr_cal_R100.dat'
      str_filename_lowrb = '/home/azuri/daten/STELLA-pipeline/Arcs/FeAr/FeAr_cal_R100_rb.dat'
    end else if i_lamp eq 3 then begin
      str_filename_high_r = '/home/azuri/daten/STELLA-pipeline/Arcs/CuAr/CuAr_cal.dat'
      str_filename_low_r = '/home/azuri/daten/STELLA-pipeline/Arcs/CuAr/CuAr_cal_R100.dat'
      str_filename_lowrb = '/home/azuri/daten/STELLA-pipeline/Arcs/CuAr/CuAr_cal_R100_rb.dat'
    end else if i_lamp eq 4 then begin
      str_filename_high_r = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/Westinghouse_lamp/westinghouse_ThAr_cal.dat'
      str_filename_low_r = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/Westinghouse_lamp/westinghouse_ThAr_cal_R100.dat'
      str_filename_lowrb = '/home/azuri/daten/STELLA-pipeline/Arcs/ThAr/Westinghouse_lamp/westinghouse_ThAr_cal_R100_rb.dat'
    endif
    
    dblarr_high_r = double(readfiletostrarr(str_filename_high_r, ' '))
    dblarr_low_r = double(readfiletostrarr(str_filename_low_r, ' '))
    dblarr_lowrb = double(readfiletostrarr(str_filename_lowrb, ' '))
    
    dbl_lambda_min = 3200.
    dbl_lambda_max = 4200.
    for i_plot=0, 5 do begin
      str_filename_out_high_r = str_filename_high_r;strmid(str_filename_high_r,strpos(str_filename_high_r,'/',/REVERSE_SEARCH)+1)
      str_lambda_min = strtrim(string(dbl_lambda_min),2)
      str_lambda_min = strmid(str_lambda_min,0,strpos(str_lambda_min,'.'))
      str_lambda_max = strtrim(string(dbl_lambda_max),2)
      str_lambda_max = strmid(str_lambda_max,0,strpos(str_lambda_max,'.'))
      str_filename_out_high_r = strmid(str_filename_out_high_r,0,strpos(str_filename_out_high_r,'.'))+'_'+str_lambda_min+'-'+str_lambda_max+'.ps'
      print,'str_filename_out_high_r = "'+str_filename_out_high_r+'"'
      
      str_filename_out_low_r = str_filename_low_r;strmid(str_filename_low_r,strpos(str_filename_low_r,'/',/REVERSE_SEARCH)+1)
      str_filename_out_low_r = strmid(str_filename_out_low_r,0,strpos(str_filename_out_low_r,'.'))+'_'+str_lambda_min+'-'+str_lambda_max+'.ps'
      print,'str_filename_out_low_r = "'+str_filename_out_low_r+'"'
      
      str_filename_out_lowrb = str_filename_lowrb;strmid(str_filename_low_r,strpos(str_filename_low_r,'/',/REVERSE_SEARCH)+1)
      str_filename_out_lowrb = strmid(str_filename_out_lowrb,0,strpos(str_filename_out_lowrb,'.'))+'_'+str_lambda_min+'-'+str_lambda_max+'.ps'
      print,'str_filename_out_lowrb = "'+str_filename_out_lowrb+'"'

;        plot,dblarr_low_r(*,0),$
;             dblarr_low_r(*,1),$
;             xrange=[3350., 3400.]
;      stop
      set_plot,'ps'
      device,filename=str_filename_out_high_r
        plot,dblarr_high_r(*,0),$
             dblarr_high_r(*,1),$
             xrange=[dbl_lambda_min, dbl_lambda_max],$
             xstyle = 1,$
             xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
             ytitle = 'Flux'
      device,/close
      spawn,'epstopdf '+str_filename_out_high_r
      
      device,filename=str_filename_out_low_r
        plot,dblarr_low_r(*,0),$
             dblarr_low_r(*,1),$
             xrange=[dbl_lambda_min, dbl_lambda_max],$
             xstyle = 1,$
             xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
             ytitle = 'Flux'
      device,/close
      spawn,'epstopdf '+str_filename_out_low_r
      
      device,filename=str_filename_out_lowrb
        plot,dblarr_lowrb(*,0),$
             dblarr_lowrb(*,1),$
             xrange=[dbl_lambda_min, dbl_lambda_max],$
             xstyle = 1,$
             xtitle = 'Wavelength ['+STRING("305B)+'ngstr'+STRING("366B)+'ms]',$
             ytitle = 'Flux'
      device,/close
      spawn,'epstopdf '+str_filename_out_lowrb
      
      dbl_lambda_min = dbl_lambda_min + 1000.
      dbl_lambda_max = dbl_lambda_max + 1000.
    endfor
  endfor
  set_plot,'x'
end
