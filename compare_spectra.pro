;common maxn,dlambda,lambda,flux

pro compare_spectra,spectruma,spectrumb,linelist,OUTFILE=outfile,D_XMIN=d_xmin,D_XMAX=d_xmax,D_MAXRESINTENS=d_maxresintens,legenda
;common maxn,dlambda,lambda,flux

;
; NAME:                  compare_spectra.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      compare_spectra,spectruma,spectrumb,linelist,OUTFILE=outfile,D_XMIN=xmin,D_XMAX=xmax,D_MAXRESINTENS=maxresintens,legenda
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
if strlen(linelist) eq 0 then begin
  print,'ERROR: no filename spezified!'
  print,'Usage: compare_spectra,spectruma,spectrumb,linelist,OUTFILE=outfile,D_XMIN=xmin,D_XMAX=xmax,D_MAXRESINTENS=maxresintens,legenda'
  print,"Example: compare_spectra,'/home/azuri/atlas12/tutorial/t5770g444p00_br70_vald.dat','/home/azuri/atlas12/tutorial/sunspectre_5880_20.dat','/home/azuri/atlas12/tutorial/t5770g444p00_br70_vald_lin.dat',OUTFILE='/home/azuri/atlas12/tutorial/t5770g444p00_br70_vald_sun.ps',D_MAXRESINTENS=0.97,'VALD'"
endif else begin

;-- read lambda and flux from spectruma (inputfile)
  dblarr_spectruma = readfiletodblarr(spectruma)
  dblarr_spectrumb = readfiletodblarr(spectrumb)
;  print,"spectrumb = ",dblarr_spectrumb

;-- read linelist
  i_nlines = countlines(linelist)
  strarr_linelist = strarr(i_nlines,9)
;  strarr_linelist = readfiletoarr(linelist)
  openr,lun,linelist,/GET_LUN
  for i=0,i_nlines-1 do begin
    readf,lun,str_line
    strarr_linelist(i,0)=strtrim(strmid(str_line,0,10),2)
    str_line = strmid(str_line,10)
    strarr_linelist(i,1)=strtrim(strmid(str_line,0,7),2)
    str_line = strmid(str_line,7)
    strarr_linelist(i,2)=strtrim(strmid(str_line,0,5),2)
    str_line = strmid(str_line,5)
    strarr_linelist(i,3)=strtrim(strmid(str_line,0,12),2)
    str_line = strmid(str_line,12)
    strarr_linelist(i,4)=strtrim(strmid(str_line,0,5),2)
    str_line = strmid(str_line,5)
    strarr_linelist(i,5)=strtrim(strmid(str_line,0,12),2)
    str_line = strmid(str_line,12)
    strarr_linelist(i,6)=strtrim(strmid(str_line,0,9),2)
    str_line = strmid(str_line,9)
    strarr_linelist(i,7)=strtrim(strmid(str_line,0,9),2)
    str_line = strmid(str_line,9)
    strarr_linelist(i,8)=strtrim(str_line,2)
  endfor
;  print,strarr_linelist
  free_lun,lun

;-- read out line positions
  dblarr_linepos = strarr_linelist(*,0) * 10.
; print,'dblarr_linepos = ',dblarr_linepos

;-- read out the unbroadened residual intensity at line center
  dblarr_resintens = strarr_linelist(*,8)

;-- read out ion name
  strarr_names = strarr_linelist(*,6)

;--load color table
  loadct,2

;-- plot spectruma
  dbl_fac = max(dblarr_spectruma(*,1)) / max(dblarr_spectrumb(*,1))
  print,'min(dblarr_spectruma(*,1)) = ',min(dblarr_spectruma(*,1))
  print,'min(dblarr_spectrumb(*,1))*dbl_fac = ',min(dblarr_spectrumb(*,1))*dbl_fac
  dbl_ymin = min([min(dblarr_spectruma(*,1)),min(dblarr_spectrumb(*,1) * dbl_fac)])
  print,'dbl_ymin = ',dbl_ymin
  dbl_ymax = max(dblarr_spectruma(*,1))
  if KEYWORD_SET(outfile) then begin
    set_plot,'ps'
    device,filename=outfile,/color
  endif
  x_range = dblarr(2)
  y_range = dblarr(2)
;  print,'D_XMIN = ',D_XMIN
;  print,'D_XMAX = ',D_XMAX
;  print,'D_MAXRESINTENS = ',D_MAXRESINTENS
  if KEYWORD_SET(D_XMIN) then x_range(0)=D_XMIN else x_range(0)=min(dblarr_spectruma(*,0))
  if KEYWORD_SET(D_XMAX) then x_range(1)=D_XMAX else x_range(1)=max(dblarr_spectruma(*,0))

  y_range(0) = dbl_ymin-(dbl_ymax - dbl_ymin)/50.
  y_range(1) = dbl_ymax + (dbl_ymax-dbl_ymin)/7.

  print,x_range
  plot,dblarr_spectruma(*,0),dblarr_spectruma(*,1),xrange=x_range,yrange=y_range,xstyle=1,ystyle=1,xtitle='wavelength ['+STRING("305B)+']',ytitle='flux',position=[0.135,0.1,0.99,0.99]
  oplot,dblarr_spectrumb(*,0),dblarr_spectrumb(*,1) * dbl_fac,color=90

;-- print legend
  strarr_legendnames = strarr(2)
  strarr_legendnames(0) = 'ATLAS9 + '+legenda
  strarr_legendnames(1) = 'Sun'
  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 40., x_range(0) + (x_range(1) - x_range(0)) / 40.],[y_range(0) + (y_range(1) - y_range(0)) / 40., y_range(0) + (y_range(1) - y_range(0)) / 5.]
  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 2.8, x_range(0) + (x_range(1) - x_range(0)) / 2.8],[y_range(0) + (y_range(1) - y_range(0)) / 40., y_range(0) + (y_range(1) - y_range(0)) / 5.]
  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 40., x_range(0) + (x_range(1) - x_range(0)) / 2.8],[y_range(0) + (y_range(1) - y_range(0)) / 40., y_range(0) + (y_range(1) - y_range(0)) / 40.]
  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 40., x_range(0) + (x_range(1) - x_range(0)) / 2.8],[y_range(0) + (y_range(1) - y_range(0)) / 5., y_range(0) + (y_range(1) - y_range(0)) / 5.]

  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 30., x_range(0) + (x_range(1) - x_range(0)) / 10.],[y_range(0) + (y_range(1) - y_range(0)) / 7., y_range(0) + (y_range(1) - y_range(0)) / 7.]
  oplot,[x_range(0) + (x_range(1) - x_range(0)) / 30., x_range(0) + (x_range(1) - x_range(0)) / 10.],[y_range(0) + (y_range(1) - y_range(0)) / 15., y_range(0) + (y_range(1) - y_range(0)) / 15.],color=90
  xyouts,x_range(0) + (x_range(1) - x_range(0)) / 9.,y_range(0) + (y_range(1) - y_range(0)) / 7.5,strarr_legendnames(0)
  xyouts,x_range(0) + (x_range(1) - x_range(0)) / 9.,y_range(0) + (y_range(1) - y_range(0)) / 18.,strarr_legendnames(1)

;-- print lines to spectruma
  if (not KEYWORD_SET(D_MAXRESINTENS)) then D_MAXRESINTENS = 0.98
;  print,strarr_names
  for i=0,countlines(linelist)-1 do begin
;-- show only lines with residual intensities below D_MAXRESINTENS
    if strarr_names(i) eq 'K' then print,i
    if dblarr_resintens(i) le D_MAXRESINTENS then begin
      if dblarr_linepos(i) ge x_range(0) and dblarr_linepos(i) lt x_range(1) then begin
        oplot,[dblarr_linepos(i),dblarr_linepos(i)],[dbl_ymax,dbl_ymax + (dbl_ymax-dbl_ymin)/20.]
        xyouts,dblarr_linepos(i),dbl_ymax + (dbl_ymax-dbl_ymin)/19.,strmid(strarr_names(i),0,strpos(strarr_names(i),'.')+3),orientation=90,charsize=0.5
      endif
    endif
  endfor
  if KEYWORD_SET(OUTFILE) then begin
    device,/close
    set_plot,'x'
  endif

endelse
end
