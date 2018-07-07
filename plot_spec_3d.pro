pro plot_spec_3d,str_fitsfilename
  str_filename = str_fitsfilename;'/home/azuri/spectra/elaina/eso_archive/red_564/red_l/LMC-X1_rl_2000-01-12T01-48-55.757_564_1200s_botzfxs_1574-1638_915-1249.text'
  str_filename_out = strmid(str_filename, 0, strpos(str_filename,'.')) + '_' + strmid(str_filename, strpos(str_filename,'.')+1, strpos(str_filename,'.',/REVERSE_SEARCH)-strpos(str_filename,'.')-1)+'.ps'
  str_filename_out_gif = strmid(str_filename, 0, strpos(str_filename,'.')) + '_' + strmid(str_filename, strpos(str_filename,'.')+1, strpos(str_filename,'.',/REVERSE_SEARCH)-strpos(str_filename,'.')-1)+'.gif'
  print,'str_filename_out_gif set to '+str_filename_out_gif

  data_str = readfiletostrarr(str_filename,' ')
  data = double(data_str)

  size_data = size(data)
  print,'size(data) = ',size_data

;  zrange=[0.,160.]
  zrange = [0.,max(data)]
  if (strpos(str_fitsfilename,'ky') ge 0) then $
    zrange=[0.,60.]

  if (zrange[1] gt 220) then zrange[1] = 220.
;  zrange=[0.,360.]
  print,'zrange = ',zrange

  position = [0.175,0.08,0.999,2.]
  if (zrange[1] > 100) then $
    position[0] = 0.2
  if (zrange[1] > 1000) then $
    position[0] = 0.225

  set_plot,'ps'
  device,filename=str_filename_out
  shade_surf,data,$
             AX=045,$
             AZ=025,$
             xstyle=1,$
             ystyle=1,$
             zstyle=1,$
             xmargin=[4.1,1.2],$
             ymargin=[1.6,0.8],$
;             min_value=0.,$
;             max_value=120.,$
             xrange=[0,size_data(1)-1],$
             yrange=[0,size_data(2)-1],$
             zrange=zrange,$
             xtitle='Row',$
             ytitle='Column',$
             ztitle='Counts',$
             charsize=3.,$
             charthick=2.,$
             position=position
  device,/close
  set_plot,'x'
  spawn,'ps2gif '+str_filename_out+' '+str_filename_out_gif
  spawn,'epstopdf '+str_filename_out;+' '+str_filename_out_pdf
;  xsurface,data
end
