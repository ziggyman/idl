pro rave_plot_good_spectra,STR_PATH=str_path,STR_FILELIST=str_filelist,STR_TEXFILE=str_texfile
;
; NAME:                  rave_plot_good_spectra.pro
; PURPOSE:               plots the spectra of the stars which didn't deliver stellar
;                        parameters
; CATEGORY:              rave
; CALLING SEQUENCE:      rave_plot_bad_spectra
; INPUTS:                str_filelist:
;                          filename T_eff
; COPYRIGHT:             Andreas Ritter
; DATE:                  19/10/2008
;
;                        headline
;                        feetline (up to now not used)
;

  ; --- parameters
  if not keyword_set(STR_PATH) then $
    str_path = '/home/azuri/daten/rave/spectra/Andreas/'
  if not keyword_set(STR_FILELIST) then $
    str_filelist = str_path+'spectra.list'
  if not keyword_set(STR_TEXFILE) then $
    str_texfile = str_path+'spectra.tex'
  openw,lun,str_texfile,/GET_LUN
  printf,lun,'\documentclass[a4paper,10pt]{article}'
  printf,lun,'\usepackage{epsfig}'
  printf,lun,'\usepackage{epsf}'
  printf,lun,'\usepackage{amssymb}'
  printf,lun,'\usepackage{amsmath}'
  printf,lun,'\title{Spectra of RAVE stars which did not deliver stellar parameters}'
  printf,lun,'\author{Andreas Ritter}'
  printf,lun,'\begin{document}'
  printf,lun,'\maketitle'
  printf,lun,''
  printf,lun,''
  printf,lun,''
  printf,lun,''

  i_n_files = countdatlines(str_filelist)
  i_n_plots = 5

  strarr_filelist = readfiletostrarr(str_filelist,' ')

  for i=0UL, i_n_files-1, i_n_plots do begin
    set_plot,'ps'
    str_psfilename = str_path+'spectra_'+strtrim(string(i),2)+'-'+strtrim(string(i+i_n_plots-1),2)+'.ps'
    str_pdffilename = str_path+'spectra_'+strtrim(string(i),2)+'-'+strtrim(string(i+i_n_plots-1),2)+'.pdf'
    str_giffilename = str_path+'spectra_'+strtrim(string(i),2)+'-'+strtrim(string(i+i_n_plots-1),2)+'.gif'
    device,filename=str_psfilename,xsize=18,ysize=28,/color,encaps=1
      for j=0UL,min([i_n_plots,i_n_files-i])-1 do begin
        ;--- read individual spectra
        strarr_data = readfiletostrarr(str_path+strarr_filelist(i+j,0),' ')
        dblarr_data = double(strarr_data)
        indarr=where(dblarr_data(*,1) lt 0.)
        if n_elements(indarr) gt 1 then $
          dblarr_data(indarr,1) = 0.

        str_ytitle='Normalised Flux'
        if j eq i_n_plots-1 then begin
          str_xtitle = 'Wavelength ['+STRING("305B)+']'
          d_xtickinterval=100.
          d_xticklen=0.025
        end else begin
          str_xtitle = ''
          d_xtickinterval=1000.
          d_xticklen=0.05
        end
        d_xmin = 0.075
        d_xmax = 0.995
        d_ymin = 1.-double((j+1)*0.955/double(i_n_plots));+(2./(13.3*i_n_plots))
        d_ymax = d_ymin+(0.945/i_n_plots)
        dblarr_position=[d_xmin,d_ymin,d_xmax,d_ymax]
        print,'i=',i,': j=',j,': setting position to ',dblarr_position

        str_title = 'T_eff = '+strarr_filelist(i+j,1)+ 'K';strmid(strarr_filelist(i+j),strpos(strarr_filelist(i+j),'/')+1)
        plot,dblarr_data(*,0),dblarr_data(*,1),xrange=[8410.,8795.],xstyle=1,xtitle=str_xtitle,ytitle=str_ytitle,position=dblarr_position,xtickinterval=d_xtickinterval,xticklen=d_xticklen,xtickname=strarr_xticknames,/NOERASE
        xyouts,8600.,0.09,str_title
      endfor
    device,/close
    set_plot,'x'
    spawn,'ps2gif '+str_psfilename+' '+str_giffilename
    spawn,'epstopdf '+str_psfilename
    printf,lun,'\begin{figure}'
    printf,lun,'\includegraphics[width=\textwidth]{'+str_pdffilename+'}'
;    printf,lun,'\centerline{\includegraphics[width=\textwidth]{'+str_pdffilename+'}}'
;  \caption{Summary plot for Metallicity over radial velocitiy for $9.0 \leqq I \leqq 10.0$. The lower triangles show the differences in the mean values for $v_{rad}$, the upper ones the differences in the mean values for $[Fe/H]$. There is a clear systematic shift in the mean values of the metallicities to lower metallicities for the RAVE data.} \label{fig:meanfields_vrad_FeH_I9_00-10_0}
    printf,lun,'\end{figure}'

  endfor
  printf,lun,'\end{document}'
  free_lun,lun

end
