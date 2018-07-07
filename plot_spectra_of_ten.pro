;common maxn,dlambda,lambda,flux

pro plot_spectra_of_ten,spectralist,linelist,ranges
;common maxn,dlambda,lambda,flux

;
; NAME:                  plot_spectra_of_ten.pro
; PURPOSE:               plots a spectrum and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      plot_spectra_of_ten,spectralist,linelist,ranges
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
;                        ranges:
;                          3900. 4140.
;                          4100. 4300.
;                          ...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  23.02.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
if n_elements(ranges) eq 0 then begin
  print,'ERROR: not enough parameters spezified!'
  print,'Usage: plot_spectra_of_ten,spectralist,linelist,ranges'
  print,"Example: plot_spectra_of_ten,'/home/azuri/spectra/joss/000-010.list','/home/azuri/spectra/joss/lines1.list','/home/azuri/spectra/joss/ranges.list'"
  spectralist = '/home/azuri/spectra/joss/text.list'
  linelist = '/home/azuri/spectra/joss/lines1.list'
  ranges = '/home/azuri/spectra/joss/ranges.list'
endif; else begin

  strarr_spectra = readfiletoarr(spectralist)
  i_nranges = countlines(ranges)
  dblarr_ranges = readfiletodblarr(ranges)
  i_nspec = countlines(spectralist)
  str_path = strmid(spectralist,0,strpos(spectralist,'/',/REVERSE_SEARCH)+1)
  print,'str_path = ',str_path
  for i=0,i_nranges-1 do begin
    print,'ranges(',i,',0) = ',dblarr_ranges(i,0)
    print,'ranges(',i,',1) = ',dblarr_ranges(i,1)
    str_rangea = strtrim(string(dblarr_ranges(i,0)),2)
    str_rangea = strmid(str_rangea,0,strpos(str_rangea,'.',/REVERSE_SEARCH))
    str_rangeb = strtrim(string(dblarr_ranges(i,1)),2)
    str_rangeb = strmid(str_rangeb,0,strpos(str_rangeb,'.',/REVERSE_SEARCH))
    str_htmlfile = strmid(spectralist,0,strpos(spectralist,'.',/REVERSE_SEARCH))+str_rangea+'-'+str_rangeb+'.html'
    print,'str_htmlfile = ',str_htmlfile
    openw,lunh,str_htmlfile,/GET_LUN
      printf,lunh,'<html>'
      printf,lunh,'<body>'
      i_ispec = 0
      while i_ispec lt i_nspec do begin
        str_speclist = str_path
        if i_ispec lt 100 then $
          str_speclist = str_speclist+'0'
        if i_ispec lt 10 then $
          str_speclist = str_speclist+'0'
        str_speclist = str_speclist+strtrim(string(i_ispec),2)+'-'
        if i_ispec+10 lt 100 then $
          str_speclist = str_speclist+'0'
        str_speclist = str_speclist+strtrim(string(i_ispec+10),2)+'.list'
        openw,lun,str_speclist,/GET_LUN
          j = 9
          if i_ispec + j ge i_nspec then $
            j = i_nspec - i_ispec - 1
          for k=0,j do begin
            printf,lun,strarr_spectra(i_ispec + k)
          endfor
        free_lun,lun
        str_outfile_root = strmid(str_speclist,0,strpos(str_speclist,'.',/REVERSE_SEARCH))+'_'+str_rangea+'-'+str_rangeb
        str_outfile = str_outfile_root+'.ps'
        print,'str_outfile = ',str_outfile
        plot_ten_spectra,str_speclist,linelist,dblarr_ranges(i,0),dblarr_ranges(i,1),OUTFILE=str_outfile
        spawn,'ps2gif '+str_outfile+' '+str_outfile_root+'.gif'
        printf,lunh,'<img src='+strmid(str_outfile_root,strpos(str_outfile_root,'/',/REVERSE_SEARCH)+1)+'.gif><br'
        i_ispec = i_ispec+10
      endwhile
      printf,lunh,'</body>'
      printf,lunh,'</html>'
    free_lun,lunh
  endfor

;endelse
end
