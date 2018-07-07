;common maxn,dlambda,lambda,flux

pro gaussfit_lines,list_of_spectra_in,idlist_in,linelist_in
;common maxn,dlambda,lambda,flux

;
; NAME:                  gaussfit_lines.pro
; PURPOSE:               plots two spectra and names the lines
; CATEGORY:              data reduction
; CALLING SEQUENCE:      gaussfit_lines,linelist_in,linelist_out,start,range
; INPUTS:                linelist_in: gfall.dat
;                         2.4898 -0.842  7.05       0.000  0.0 1s2 1S     4016390.000  1.0 s3p *1P    11.73  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                         2.8787 -0.171  7.05       0.000  0.0 1s2 1S     3473790.000  1.0 s2p *1P    12.26  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                           ...
;
; OUTPUTS:               linelist_out: gf0100.100
;                         2.4898 -0.842  7.05       0.000  0.0 1s2 1S     4016390.000  1.0 s3p *1P    11.73  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                         2.8787 -0.171  7.05       0.000  0.0 1s2 1S     3473790.000  1.0 s2p *1P    12.26  0.00  0.00NBS  0 0  0 0.000  0 0.000    0    0              0    0
;                           ...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  03.01.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
if n_elements(linelist_in) eq 0 then begin
  print,'ERROR: not enough parameters spezified!'
  print,'Usage: gaussfit_lines,list_of_spectra_in,idlist_in,linelist_in'
  print,"Example: gaussfit_lines,'/home/azuri/spectra/joss/text.list','/home/azuri/spectra/joss/fibre_id.txt','/home/azuri/spectra/joss/lines_to_fit.text"
endif; else begin
  list_of_spectra_in = '/home/azuri/spectra/joss/text.list'
  idlist_in = '/home/azuri/spectra/joss/fibre_id.txt'
  linelist_in = '/home/azuri/spectra/joss/lines_to_fit.list'

  str_templine = ''
  str_idline = ''
  str_fibre = ''
  str_headline = ''
  j = 0UL
  nlines = countlines(linelist_in)
  dblarr_lines = strarr(nlines)
  strarr_lines = strarr(nlines)

;--- read input linelist_in
  openr,lunl,linelist_in,/GET_LUN
  for i=0UL,nlines-1 do begin
    readf,lunl,str_templine
    dblarr_lines(i) = double(strmid(str_templine,0,strpos(str_templine,' ')))
    strarr_lines(i) = strtrim(str_templine,2)
    print,'dblarr_lines(',i,') = ',dblarr_lines(i),': ',strarr_lines(i)
  endfor
  free_lun,lunl

;--- read list_of_spectra_in
  nspectra = countlines(list_of_spectra_in)
  openr,lun,list_of_spectra_in,/GET_LUN
    for i=0UL,nspectra-1 do begin
      readf,lun,str_templine
      str_path = strmid(list_of_spectra_in,0,strpos(list_of_spectra_in,'/',/REVERSE_SEARCH)+1)
      str_spectraname = str_path+strtrim(str_templine,2)
      str_fibre = strmid(str_templine,strpos(str_templine,'_',/REVERSE_SEARCH)+1,3)
      i_sfibre = long(str_fibre)
;      print,'str_fibre = '+str_fibre+', i_sfibre = ',i_sfibre
;--- read idlist_in
      nfibrelines = countlines(idlist_in)
      openr,luni,idlist_in,/GET_LUN
        for j=0UL, nfibrelines-1 do begin
          readf,luni,str_templine
;--- if id found and star proceed
          str_fibre = strtrim(strmid(str_templine,1,4),2)
          i_fibre = long(str_fibre)
;          print,'str_fibre = '+str_fibre+', i_fibre = ',i_fibre
          if i_sfibre eq i_fibre then begin
            str_starname = strtrim(strmid(str_templine,5,13),2)
            print,'fibre '+str_fibre+' found: str_starname = '+str_starname

;--- if star proceed
            if strmid(str_starname,0,1) eq 'S' then begin
              print,'Star found'
              openw,lunw,str_path+str_starname+'_fibre'+str_fibre+'.dat',/GET_LUN
                printf,lunw,'line         Center     Width      EquivalentWidth'
                dblarr_star = readfiletodblarr(str_spectraname)
                for k=0UL,nlines-1 do begin
                  intarr_indices = where(dblarr_star(*,0) gt dblarr_lines(k)-20. and dblarr_star(*,0) lt dblarr_lines(k)+20.)
                  print,'intarr_indices = ',intarr_indices
                  str_plotname = str_path+str_starname+'_fibre'+str_fibre+'_'+strtrim(string(dblarr_lines(k)),2)+'.ps'
                  i_ncoeffs = 4
;                  dbl_mean = mean([dblarr_star(intarr_indices(0),1),dblarr_star(intarr_indices(1),1)])
;                  dblarr_estimates = [dbl_mean/2.,0.,2.,dbl_mean]
                  fit = GAUSSFIT(dblarr_star(intarr_indices,0),dblarr_star(intarr_indices,1),D_A1_Coeffs,NTERMS=i_ncoeffs)
                  d_width = D_A1_Coeffs(2)
                  d_center = D_A1_Coeffs(1)
                  d_ewidth = FCalcGaussEquiWidth(dblarr_star(intarr_indices,0),dblarr_star(intarr_indices,1),i_ncoeffs)
                  print,'d_width = ',d_width,', d_ewidth = ',d_ewidth
                  loadct,2
                  set_plot,'ps'
                  device,filename=str_plotname,/color
                    plot,dblarr_star(intarr_indices,0),dblarr_star(intarr_indices,1),title=str_starname+': '+strarr_lines(k)+'  width='+strtrim(string(d_width),2)+'  equiwidth='+strtrim(string(d_ewidth),2)
                    if abs(d_center - dblarr_lines(k)) lt 7. and d_ewidth gt 1.2 then begin
                      oplot,dblarr_star(intarr_indices,0),fit
                      printf,lunw,strtrim(string(dblarr_lines(k)),2)+':  '+strtrim(string(d_center),2)+'   '+strtrim(string(d_width),2)+'   '+strtrim(string(d_ewidth),2)
                    end else begin
                      oplot,dblarr_star(intarr_indices,0),fit,color=90
                      printf,lunw,strtrim(string(dblarr_lines(k)),2)+':  not   fit   properly'
                    end
                  device,/close
                  set_plot,'x'
                endfor
              free_lun,lunw
            endif
            j = ulong(nfibrelines-1)
          endif
        endfor
      free_lun,luni
    endfor
  free_lun,lun

;endelse
end
