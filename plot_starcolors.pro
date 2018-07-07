;common maxn,dlambda,lambda,flux

pro plot_starcolors,colorfile,datafiles,wlen
;common maxn,dlambda,lambda,flux

;
; NAME:                  plot_starcolors.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_starcolors,spectruma,spectrumb,linelist,OUTFILE=outfile,D_XMIN=xmin,D_XMAX=xmax,D_MAXRESINTENS=maxresintens,legenda
; INPUTS:                spectruma (output of ATLAS synthe):
;                           5880.0063      0.15201110E-05      0.38394624E-05     0.395918
;                           5880.0161      0.17347011E-05      0.38394703E-05     0.451807
;                           ...
;
;                        spectrumb (output of ATLAS synthe):
;                           5880.0063      0.15201110E-05
;                           5880.0161      0.17347011E-05
;                           ...
;
;                        linelist (output of ATLAS synthe):
;                           588.2705 -3.690  2.0   62669.727  1.0   79664.000    14.00  KP     1.0000
;                           588.3052 -2.621  2.0   48451.730  1.0   65445.000    20.00  K88    1.0000
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  03.01.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
  if n_elements(wlen) eq 0 then begin
    print,'ERROR: not enough parameters specified!'
    print,'Usage: plot_starcolors,colorfile,datafiles,wlen'
    print,"Example: plot_starcolors,'/home/azuri/spectra/joss/Plots/Colours_no_header.txt','/home/azuri/spectra/joss/datfiles.list','3934'"
    colorfile = '/home/azuri/spectra/joss/Plots/Colours_no_header.txt'
    datafiles = '/home/azuri/spectra/joss/datfiles.list'
    wlen = '4340'
  end
  str_path = strmid(datafiles,0,strpos(datafiles,'/',/REVERSE_SEARCH)+1)
  i_ncolors = countlines(colorfile)
  i_ndatfiles = countlines(datafiles)
  dblarr_colors = readfiletodblarr(colorfile)
  strarr_datafiles = readfiletoarr(datafiles)
;  print,'dblarr_colors(*,1) = ',dblarr_colors(*,1)
  str_plotname = str_path + 'colors.ps'
  loadct,2
  set_plot,'ps'
  device,filename=str_plotname,/color
  plot,dblarr_colors(*,4),dblarr_colors(*,0),psym=1,ytitle='U-B',xrange=[-0.5,2.],yrange=[1.,-1.5],xtitle='V-I'
  for i=0UL, i_ndatfiles-1 do begin
    i_ndatalines = countlines(str_path+strarr_datafiles(i))
    strarr_data = readfiletoarr(str_path+strarr_datafiles(i))
    for j=0UL,i_ndatalines-1 do begin
      if strmid(strarr_data(j,0),0,4) eq wlen then begin
        if strarr_data(j,1) ne 'not' then begin
          i_starnum = long(strmid(strarr_datafiles(i),1,3))
          print,'i_starnum = ',i_starnum
          d_width = double(strarr_data(j,2))
          if d_width lt 3. then begin
            oplot,[dblarr_colors(i_starnum-1,4),dblarr_colors(i_starnum-1,4)],[dblarr_colors(i_starnum-1,0),dblarr_colors(i_starnum-1,0)],psym=2,color=20
          end else if d_width lt 5. then begin
            oplot,[dblarr_colors(i_starnum-1,4),dblarr_colors(i_starnum-1,4)],[dblarr_colors(i_starnum-1,0),dblarr_colors(i_starnum-1,0)],psym=2,color=180
          end else begin
            oplot,[dblarr_colors(i_starnum-1,4),dblarr_colors(i_starnum-1,4)],[dblarr_colors(i_starnum-1,0),dblarr_colors(i_starnum-1,0)],psym=2,color=90
          end
        endif
      endif
    endfor
  endfor
  device,/close
  set_plot,'x'
end
