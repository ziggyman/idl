pro plot_merge_weights,i_str_psoutfile

  if n_elements(i_str_psoutfile) eq 0 then begin
    print,'calc_merge_convolution_function: USAGE: plot_merge_weights,outfile:String'
  endif else begin
    nx = 1000
    xarr = dindgen(nx);/(nx-1)
    yarr = (cos(xarr * !DPI / (double(nx)-1.)) + 1.) / 2.

    set_plot,'ps'
    device,filename=i_str_psoutfile
    plot,xarr,$
         yarr,$
         xtitle='Overlapping Interval',$
         ytitle='Weight',$
         xticks=2,$
         xtickname=['Start','Middle','End'],$
         thick=3.,$
         charthick = 3.,$
         charsize=1.8,$
         position = [0.13,0.155,0.97,0.995]
    oplot,xarr,1.-yarr,linestyle=2,thick=3.
    device,/close
    set_plot,'x'
    spawn,'epstopdf '+i_str_psoutfile

  endelse
end
