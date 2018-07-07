;common maxn,dlambda,lambda,flux

pro plot_five_spectra,spectralist,linelist,xmin,xmax,OUTFILE=outfile
;common maxn,dlambda,lambda,flux

;
; NAME:                  plot_five_spectra.pro
; PURPOSE:               plots a spectrum and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_five_spectra,spectralist,linelist,xmin,xmax,OUTFILE=outfile
; INPUTS:                spectralist:
;                           spectruma
;                           spectrumb
;                           ...
;
;                        spectruma:
;                           5880.0063      0.15201110E-05
;                           5880.0161      0.17347011E-05
;                           ...
;
;                        linelist:
;                          3934. CaII
;                          3963. CaII
;                          ...
;
;                        xmin,xmax:    range to plot
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  13.02.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
if strlen(xmax) eq 0 then begin
  print,'ERROR: not enough parameters spezified!'
  print,'Usage: plot_five_spectra,spectralist,linelist,xmin,xmax,OUTFILE=outfile'
  print,"Example: plot_five_spectra,'/home/azuri/spectra/joss/000-010.list','/home/azuri/spectra/joss/lines1.list',3930.,3970.,OUTFILE='/home/azuri/spectra/joss/000-010_lines1.ps'"
endif else begin

;-- read lambda and flux from spectra (inputfiles)
  strarr_spectra = readfilelinestoarr(spectralist)
  str_path = strmid(spectralist,0,strpos(spectralist,'/',/REVERSE_SEARCH)+1)
  i_nspectra = countlines(spectralist)
  i_nspectrapoints = countlines(str_path+strarr_spectra(0))
  dblarr_spectra = dblarr(i_nspectra,i_nspectrapoints,2)

  for i=0, i_nspectra - 1 do begin
    dblarr_temp = readfiletodblarr(str_path+strarr_spectra(i))
;    print,'dblarr_temp = ',dblarr_temp
;    print,'i = ',i,': n_elements(dblarr_temp) = ',n_elements(dblarr_temp)
    dblarr_spectra(i,*,*) = dblarr_temp
  endfor
;  print,'dblarr_spectra(0,0:10,0) = ',dblarr_spectra(0,0:10,0)
;  print,'dblarr_spectra(0,0:10,1) = ',dblarr_spectra(0,0:10,1)

;-- read linelist
  i_nlines_lines = countlines(linelist)
  i_nlines = countdatlines(linelist)
  strarr_lines = readfiletoarr(linelist)
;  print,'strarr_lines = ',strarr_lines
  dblarr_xticksv = dblarr(i_nlines+2)
  dblarr_xticksv(0) = xmin
  dblarr_xticksv(1:i_nlines+1) = xmax
  strarr_xticknames = strarr(i_nlines+2)
  strarr_xticknames(0) = strmid(xmin,0,strpos(xmin,'.')+2)
  strarr_xticknames(1:i_nlines+1) = strmid(xmax,0,strpos(xmax,'.')+2)
  i_nlines_in_limits = 0
  dbl_dum = 0.
  for j=1,i_nlines do begin
;    print,'size(strarr_lines) = ',size(strarr_lines)
;    print,'j-1 = ',j-1
    if strmid(strarr_lines(j-1,0),0,1) ne '#' then begin
      dbl_dum = strarr_lines(j-1,0)
      if dbl_dum le xmax and dbl_dum ge xmin then begin
        i_nlines_in_limits = i_nlines_in_limits + 1
        dblarr_xticksv(i_nlines_in_limits) = strarr_lines(j-1,0)
        strarr_xticknames(i_nlines_in_limits) = strarr_lines(j-1,1)
      endif
    endif
  endfor
;  print,'i_nlines_in_limits = ',i_nlines_in_limits

  if KEYWORD_SET(outfile) then begin
    set_plot,'ps'
    device,filename=outfile,/color
  endif
  dblarr_pos = dblarr(4)
  dblarr_pos(0) = 0.03
  dblarr_pos(2) = 0.97
; --- plot lines
  strarr_yticknames = strarr(2)
  strarr_yticknames(0) = ' '
  strarr_yticknames(1) = ' '
;  print,'dblarr_xticksv = ',dblarr_xticksv
;  print,'strarr_xticknames = ',strarr_xticknames
  for i=0, i_nspectra-1 do begin
    dblarr_pos(1) = 0.99 - (0.94 / i_nspectra) * (i+1)
    dblarr_pos(3) = 0.99 - (0.94 / i_nspectra) * i
    dblarr_spectra_in_range = dblarr(2)
    dblarr_spectra_in_range = [0,1]
    dbl_ymin = 0.
    dbl_ymax = 1.
    intarr_index_range = where(dblarr_spectra(0,*,0) ge xmin and dblarr_spectra(0,*,0) le xmax,count)
    if count ne 0 then begin
      dbl_ymin = min(dblarr_spectra(i,intarr_index_range,1))
      dbl_ymax = max(dblarr_spectra(i,intarr_index_range,1))
    endif
    print,'dbl_ymin = ',dbl_ymin
    print,'dbl_ymax = ',dbl_ymax
    if abs(dbl_ymax - dbl_ymin) lt 0.0000001 then dbl_ymax = 1.
;    print,'dblarr_pos = ',dblarr_pos
    if i eq 0 then begin
;      print,'dblarr_spectra(',i,',*,0) = ',dblarr_spectra(i,*,0)
      plot,dblarr_spectra(i,*,0),dblarr_spectra(i,*,1),position=dblarr_pos,xrange=[xmin,xmax],xstyle=1,xticks=1,yrange=[dbl_ymin,dbl_ymax],ystyle=1,yticks=1,ytickname=strarr_yticknames;i_nlines+1,xtickv=dblarr_xticksv,xticklen=1.
      for j=1,i_nlines_in_limits do begin
        oplot,[dblarr_xticksv(j),dblarr_xticksv(j)],[0,100000]
      endfor
    end else if i eq i_nspectra-1 then begin
      if i_nlines_in_limits eq 0 then begin
        dblarr_xticksv(1) = xmin
        dblarr_xticksv(2) = xmax
        dumstr = strtrim(string(xmin),2)
        strarr_xticknames(1) = strmid(dumstr,0,strpos(dumstr,'.'))
        dumstr = strtrim(string(xmax),2)
        strarr_xticknames(2) = strmid(dumstr,0,strpos(dumstr,'.'))
        i_nlines_in_limits = 2
        i_xticks = 1
      end else if i_nlines_in_limits eq 1 then begin
        strarr_xticknames(2) = strarr_xticknames(1)
        dumstr = strtrim(string(xmin),2)
        strarr_xticknames(1) = strmid(dumstr,0,strpos(dumstr,'.'))
        dumstr = strtrim(string(xmax),2)
        strarr_xticknames(3) = strmid(dumstr,0,strpos(dumstr,'.'))
        dblarr_xticksv(2) = dblarr_xticksv(1)
        dblarr_xticksv(1) = xmin
        dblarr_xticksv(3) = xmax
        i_nlines_in_limits = 3
        i_xticks = 2
        print,'i_nlines_in_limits = 1'
      end else begin
        i_xticks = i_nlines_in_limits - 1
      end
      plot,dblarr_spectra(i,*,0),dblarr_spectra(i,*,1),xrange=[xmin,xmax],xstyle=1,position=dblarr_pos,yrange=[dbl_ymin,dbl_ymax],ystyle=1,yticks=1,ytickname=strarr_yticknames,/NOERASE,xticks=i_xticks,xtickv=dblarr_xticksv(1:i_nlines_in_limits),xtickname=strarr_xticknames(1:i_nlines_in_limits);,xticklen=10
      for j=1,i_nlines_in_limits do begin
        oplot,[dblarr_xticksv(j),dblarr_xticksv(j)],[0,100000]
      endfor
    end else begin
      plot,dblarr_spectra(i,*,0),dblarr_spectra(i,*,1),xrange=[xmin,xmax],xstyle=1,position=dblarr_pos,xticks=1,yrange=[dbl_ymin,dbl_ymax],ystyle=1,yticks=1,ytickname=strarr_yticknames,/NOERASE;,xticks=i_nlines+1,xtickv=dblarr_xticksv.
      for j=1,i_nlines_in_limits do begin
        oplot,[dblarr_xticksv(j),dblarr_xticksv(j)],[0,100000]
      endfor
    end
  endfor

  if KEYWORD_SET(OUTFILE) then begin
    device,/close
    set_plot,'x'
  endif

endelse
end
