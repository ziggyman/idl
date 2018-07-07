;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################
pro fxcor_out_trim,list,newlist,vplot,print
;############################
;
; NAME:                  fxcor_out_trim.pro
; PURPOSE:               removes unnecessary lines from fxcor-out
;                        files and plots vobs, vrel or vhelio (see below)
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fxcor_out_trim,'<fxcor_RXJ_out>.txt','<fxcor_RXJ.data>','<vplot>','print'
; INPUTS:                input file: 'fxcor_RXJ_out.txt':
;                         #K IRAF       = NOAO/IRAF V2.12.1-EXPORT       version
;                         #K USER       = azuri                          name
;                         #K HOST       = murphy                         computer
;                         #K DATE       = 2004-04-20                     yyyy-mm-dd
;                         #K TIME       = 02:54:12                       hh:mm:ss
;                         #K PACKAGE    = rv                             name
;                         #K TASK       = fxcor                          name
;                         #
;                         #T Template ' A' -- Object = 'OBJECT'                                        \*
;                         #                   Image  = '30:30.858_botzfsx_ecd_ctc.fits'  Vhelio = 18.36
;                         #
;                         #  Velocity Dispersion = 2.25 Km/sec/pixel     Rebinned WPC = 3.25261E-6
;                         #
;                         #N OBJECT        IMAGE     REF   HJD       AP    CODES     SHIFT   HGHT FWHM    TDR    VOBS      VREL       VHELIO     VERR
;                         #U name          image           days            cfr/fun   pixel                       km/s      km/s       km/s       km/s
;                         #
;                         OBJECT           1101-264_l_UVES.2000-05-26T22:34:02.512_botzfsx_ecd_ctc.fits  A  1691.4457   1    BNS/gau   5.343   0.62 21.17   31.61  1.7247    11.9972
;                           -21.6124   0.510
;                         #K IRAF       = NOAO/IRAF V2.12.1-EXPORT       version
;                                            .
;                                            .
;                                            .
;                        vplot: String (enum('vobs','vrel','vhelio'))
; OUTPUTS:               '<fxcor_RXJ>.data','<fxcor_RXJ>.ps'
;                        output file: '<fxcor_RXJ>.data':
;                         #N HJD      HGHT    FWHM    VOBS      VREL       VHELIO     VERR
;                         #U        cfr/fun   pixel   km/s      km/s       km/s       km/s
;                         1691.4457   0.62    21.17   1.7247    11.9972     -21.6124   0.510
;                         1691.4573   0.66    24.17   1.0473    11.3972     -21.0124   0.523
;                                 .
;                                 .
;                                 .
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.04.2004
;

if n_elements(vplot) eq 0 then begin
  print,'fxcor_out_trim: Not enough parameters specified, return 0.'
  print,"USAGE         : fxcor_out_trim,'fxcor_out.txt','fxcor_out.data','vobs'[,'print']"
endif else begin   

;logfile
;  close,101
  openw,lun,'logfile_fxcor_out_trim',/get_lun

;countlines
  maxn = countlines(list)
  print,list,': ',maxn,' data lines'  
  printf,lun,list,': ',maxn,' data lines' 
  
;build arrays
  listarr    = strarr(maxn)
  linearr    = strarr(14)
  newlinearr = strarr(maxn,7)
  newlinedblarr = dblarr(maxn,7)
  qtemp      = ''
  newqtemp   = ''

;read files in arrays
;  close,1
  openr,luna,list,/get_lun
  for i=0,maxn-1 do begin
      readf,luna,qtemp
      qtemp = strtrim(qtemp,2)
      printf,lun,'fxcor_out_trim: qtemp='+qtemp
      print,'fxcor_out_trim: qtemp='+qtemp
      listarr(i) = strcompress(qtemp)
  end  
      
  free_lun,luna
  printf,lun,'fxcor_out_trim: input list read.'
  print,'fxcor_out_trim: input list read.'
  
;  close,2
  openw,lunb,newlist,/get_lun
  printf,lunb,'#N HJD HGHT FWHM VOBS VREL VHELIO VERR'
  printf,lunb,'#U days          km/s km/s km/s   km/s'
;  close,3
  openw,lunc,strmid(newlist,0,strlen(newlist)-4)+'_noheader.dat',/get_lun
  m = 0
  for i=0,maxn-1 do begin
; search for interesting lines
      printf,lun,'fxcor_out_trim: input line = '+listarr(i)
      print,'fxcor_out_trim: input line = '+listarr(i)
      if (strmid(listarr(i),0,1) ne '#') then begin
          printf,lun,'fxcor_out_trim: data line found'
          print,'fxcor_out_trim: data line found'
          k = 0
          l = 0
          oldj = 0
          for j=0,strlen(listarr(i)) do begin
              if strmid(listarr(i),j,1) eq ' ' then begin
                  linearr(k) = strmid(listarr(i),oldj,j-oldj+1)
                  printf,lun,'linearr(',k,') = ',linearr(k)
                  print,'linearr(',k,') = ',linearr(k)
                  k = k + 1
                  if k eq 13 then linearr(k)=''
                  oldj = j + 1
                  if (k eq 4) or (k eq 8) or (k eq 9) or (k eq 11) or $
                     (k eq 12) or (k eq 13) or (k eq 14) then begin
                      newlinearr(m,l)    = linearr(k-1)
                      printf,lun,'newlinearr(',m,',',l,') = ',newlinearr(m,l)
                      print,'newlinearr(',m,',',l,') = ',newlinearr(m,l)
                      l = l + 1
                  endif
              endif
              if k eq 13 then begin
                  linearr(k) = linearr(k)+strmid(listarr(i),j,1)
                  newlinearr(m,l) = linearr(k)
              end
          endfor
          printf,lunb,newlinearr(m,0),newlinearr(m,1),newlinearr(m,2),newlinearr(m,3),newlinearr(m,4),newlinearr(m,5),newlinearr(m,6)
          printf,lunc,newlinearr(m,0),newlinearr(m,1),newlinearr(m,2),newlinearr(m,3),newlinearr(m,4),newlinearr(m,5),newlinearr(m,6)
          m = m + 1
      endif
  endfor
;close output file
  free_lun,lunb
  free_lun,lunc

;countlines newlist
  maxn2 = countlines(newlist)
  print,'fxcor_out_trim: '+newlist+' contains now '+string(maxn2)+' DATA LINES'
  print,'fxcor_out_trim: '+string(maxn-maxn2)+' LINES removed'

;read newlinedblarr
  openr,lunb,newlist,/get_lun
  qdbl1 = double(0)
  qdbl2 = double(0)
  qdbl3 = double(0)
  qdbl4 = double(0)
  qdbl5 = double(0)
  qdbl6 = double(0)
  qdbl7 = double(0)

  for i=0,maxn2-1 do begin
      if i lt 2 then readf,lunb,qtemp else begin
          readf,lunb,qdbl1,qdbl2,qdbl3,qdbl4,qdbl5,qdbl6,qdbl7
          printf,lun,'fxcor_out_trim: qdbl1=',qdbl1,', qdbl2=',qdbl2,', qdbl3=',qdbl3,', qdbl4=',qdbl4,', qdbl5=',qdbl5,', qdbl6=',qdbl6,', qdbl7=',qdbl7
          print,'fxcor_out_trim: qdbl1=',qdbl1,', qdbl2=',qdbl2,', qdbl3=',qdbl3,', qdbl4=',qdbl4,', qdbl5=',qdbl5,', qdbl6=',qdbl6,', qdbl7=',qdbl7
          newlinedblarr(i-2,0) = qdbl1
          newlinedblarr(i-2,1) = qdbl2
          newlinedblarr(i-2,2) = qdbl3
          newlinedblarr(i-2,3) = qdbl4
          newlinedblarr(i-2,4) = qdbl5
          newlinedblarr(i-2,5) = qdbl6
          newlinedblarr(i-2,6) = qdbl7
          if i eq 2 then begin
              xmin = qdbl1
              xmax = qdbl1
; --- vobs
              ymin = qdbl4-qdbl7
              ymax = qdbl4+qdbl7
; --- vrel
              if vplot eq 'vrel' then begin
                  ymin = qdbl5-qdbl7
                  ymax = qdbl5+qdbl7
              end else if vplot eq 'vhelio' then begin
; --- vhelio
                  ymin = qdbl6-qdbl7
                  ymax = qdbl6+qdbl7
              end
          end else begin
              xmin = min([xmin,qdbl1])
              xmax = max([xmax,qdbl1])
; --- vobs
              ymin = min([ymin,qdbl4-qdbl7])
              ymax = max([ymax,qdbl4+qdbl7])
; --- vrel
              if vplot eq 'vrel' then begin
                  ymin = min([ymin,qdbl5-qdbl7])
                  ymax = max([ymax,qdbl5+qdbl7])
              end else if vplot eq 'vhelio' then begin
; --- vhelio
                  ymin = min([ymin,qdbl6-qdbl7])
                  ymax = max([ymax,qdbl6+qdbl7])
              end
          end
      end
  end  
  free_lun,lunb

;plot vrad over hjd
  if n_elements(print) ne 0 then begin
      set_plot,'ps'
      device,filename=strmid(newlist,0,strpos(newlist,'.',/reverse_search))+'_'+vplot+'.ps'
  endif
  vplotno = 3
  vplottitle = 'observed'
  if vplot eq 'vrel' then begin
      vplotno = 4
      vplottitle = 'relative'
  end else if vplot eq 'vhelio' then begin
      vplotno = 5
      vplottitle = 'heliocentric'
  end
  plot,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,vplotno],psym=1,xrange=[xmin-.2,xmax+.2],xstyle=1,xtitle='!5heliocentric julian date (days)',yrange=[ymin-((ymax-ymin)/10.),ymax+((ymax-ymin)/10.)],ystyle=1,ytitle='!5'+vplottitle+' radial velocity (km/s)',position=[0.11,0.12,0.985,0.99],charthick=0.8,charsize=1.3
;,title='fxcor_out_trim: list='+list+', newlist='+newlist;,title='MN Lup: red arm'
  oploterr,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,vplotno],newlinedblarr[0:maxn2-3,6]
; --- vrel
;  plot,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,4],psym=1,xrange=[xmin-.2,xmax+.2],xstyle=1,xtitle='!5HJD [days]',yrange=[ymin-((ymax-ymin)/10.),ymax+((ymax-ymin)/10.)],ytitle='!5radial velocity [km/s]',title='MN Lup: red arm',charsize=1.2,position=[0.12,0.12,0.985,0.92],charthick=1.2
;  oploterr,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,4],newlinedblarr[0:maxn2-3,6]
; --- vhelio
;  plot,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,5],psym=1,xrange=[xmin-.2,xmax+.2],xstyle=1,xtitle='!5HJD [days]',yrange=[ymin-((ymax-ymin)/10.),ymax+((ymax-ymin)/10.)],ytitle='!5radial velocity [km/s]',title='MN Lup: red arm',charsize=1.2,position=[0.12,0.12,0.985,0.92],charthick=1.2
;  oploterr,newlinedblarr[0:maxn2-3,0],newlinedblarr[0:maxn2-3,5],newlinedblarr[0:maxn2-3,6]
  if n_elements(print) ne 0 then begin
      device,/close
      set_plot,'x'
  end
;close logfile
  free_lun,lun
endelse
end
