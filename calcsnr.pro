;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;############################
pro calcsnr,datfile,outfile,datoutfile,xmin,xmax
;############################
;
; NAME:                  calcsnr
; PURPOSE:               * calculates the signal-to-noise ratio of a
;                          given spectra file
;                          * if XMIN and XMAX are given between XMIN and
;                            XMAX after normalizing the desired area
;                          * else for the whole spetra using the mean of
;                            NBIN pixels
;                        * appends the results to OUTFILE
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcsnr,'datfile','outfile','datoutfile'<,xmin,xmax>
; INPUTS:                input file: 'datfile':
;                         3740.80444335938      105783.50
;                         3740.82373046875      104585.70
;                         3740.84277343750      106158.90
;                                            .
;                                            .
;                                            .
;                        outfile: String
; OUTPUTS:               outfile:
;                        * if XMIN and XMAX are not given:
;                         dintens       5
;                         intensmean       122014.38
;                         intensmeanabsdev       765.26669
;                         intensstddev       979.09460
;                         snr       528.78716
;                         meantomeanabsdevratio       692.59212
;                        *else:
;                         posxmin        9879
;                         posxmax        9926
;                         intensmean      0.99982837
;                         intensmeanabsdev    0.0024659103
;                         intensstddev    0.0030637015
;                         snr       326.34654
;                         meantomeanabsdevratio       405.46015
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           04.01.2004
;

if n_elements(datoutfile) eq 0 then begin
  print,'calcsnr: No outfile specified, return 0.'
  print,'calcsnr: USAGE: calcsnr:<in: datfile:String>,<out: outfile:String>,<out: datoutfile:String>,<in: xmin:Real>,<in: xmax:Real>'
end else begin

  iq = ''
  id = double(0)
  jq = ''
  jd = double(0)
  tempstr = ''

;countlines
  maxn = 0UL
  maxn = countlines(datfile)
  print,datfile,': ',maxn,' DATA LINES'  

;build arrays
  dumla            = dblarr(maxn)
  dumin            = dblarr(maxn)
  intensmean       = 0.
  intensmeanabsdev = 0.
  intensstddev     = 0.
  dintens          = 5
  i = 0UL
  j = 0UL
  k = 0UL
  nbin = 20

;read file in arrays
  print,'calcsnr: reading file ',datfile
  close,1
  openr,1,datfile
  for i=0UL,maxn-1 do begin
    readf,1,tempstr
    tempstr = strtrim(tempstr,2)
    iq = strmid(tempstr,0,strpos(tempstr,' '))
    jq = strmid(tempstr,strpos(tempstr,' ')+1,strlen(tempstr)-strpos(tempstr,' ')-1)
;    print,'iq = "'+iq+'", jq = "'+jq+'"'
    if strmid(iq,0,2) ne '**' then begin
        id = iq
        jd = jq
        if jd gt 0. then begin
            dumla(j) = id
            dumin(j) = jd
            j = j+1
        end
    end
;    print,'calcsnr: reading file: line ',i,': lambda = ',lambda(i),', intensity = ',intensity(i)
  end
  close,1  

  print,'calcsnr: j = ',j

  maxn = j
  lambda    = dblarr(maxn)
  intensity = dblarr(maxn)
  for l=0UL,maxn-1 do begin
      lambda(l) = dumla(l)
      intensity(l) = dumin(l)
  end

  close,2
  openw,2,outfile,/APPEND
  close,3
  openw,3,datoutfile,/APPEND

;calcsnr
  if n_elements(xmax) ne 0 then begin
      j = 0
      nbin = 0
      posmin = 0
      posmax = 0
      print,'calcsnr: maxn = ',maxn
      for i=0UL,maxn-1 do begin
          if lambda(i) gt xmin then begin
;              print,'calcsnr: lambda(i) = ',lambda(i),' is greater than xmin = ',xmin
              if lambda(i) lt xmax then begin
 ;                 print,'calcsnr: lambda(i) = ',lambda(i),' is lower than xmax = ',xmax
                  if posmin eq 0 then posmin = i
                  posmax = i
                  j = j+1
              end
          end
      end
      nbin = j/3
      print,'calcsnr: posmin = ',posmin
      print,'calcsnr: posmax = ',posmax
      print,'calcsnr: j = ',j
      if j eq 0 then print,'calcsnr: ERROR: j must be greater than 0!' $
      else begin
          dumlambda = dblarr(j)
          dumintens = dblarr(j)
          j = 0
          for i=posmin, posmax do begin
              dumlambda(j) = lambda(i)
              dumintens(j) = intensity(i)
              j = j+1
          endfor
; normalize flux
          dummean = dblarr(nbin)
          for i=0,nbin-1 do begin
              dummean(i) = dumintens(i)
          endfor
          ya = mean(dummean)
          xa = dumlambda(nbin/2)
          l = 0
          for i=posmax-posmin+1-nbin,posmax-posmin do begin
              dummean(l) = dumintens(i)
              l = l+1
          endfor
          yb = mean(dummean)
          xb = dumlambda(posmax-posmin-(nbin/2))
          linea = (yb-ya)/(xb-xa)
          lineb = ya-(((yb-ya)/(xb-xa))*xa)
          for i=0,j-1 do begin
              dumintens(i) = dumintens(i) / (linea*dumlambda(i)+lineb)
          endfor
          intensmean = mean(dumintens)
          print,'calcsnr: intensmean = ',intensmean
          intensmeanabsdev = meanabsdev(dumintens)
          print,'calcsnr: intensmeanabsdev = ',intensmeanabsdev
          intensstddev = stddev(dumintens)
          print,'calcsnr: intensstddev = ',intensstddev
          print,'calcsnr: snr = ',intensmean/intensstddev
          print,'calcsnr: mtar = ',intensmean/intensmeanabsdev
          set_plot,'ps'
          device,filename=strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(xmin),2)+'-'+strtrim(string(xmax),2)+'.ps'
          mytitle = ''
          if strmid(datfile,strpos(datfile,'/')+1,2) eq 'hd' then begin
              mytitle = '!A'+strmid(datfile,strpos(datfile,'/')+1,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'/')-1)
          end else if strpos(datfile,'ylevel') ge 1 then begin
              mytitle = '!Aobsaplimit=+/-'+strmid(datfile,strpos(datfile,'obsaplimit')+12,strpos(datfile,'/')-strpos(datfile,'obsaplimit')-12)+', ylevel='+strmid(datfile,strpos(datfile,'ylevel')+6,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'ylevel')-6)+', w='+strtrim(string(min(dumlambda)),2)+'-'+strtrim(string(max(dumlambda)),2)+' '+STRING("305B)
          end else if (strpos(datfile,'_ls') ge 1) and (strpos(datfile,'_us') ge 1) then begin
              mytitle = '!Alsigma = '+strmid(datfile,strpos(datfile,'_ls')+3,strpos(datfile,'_us')-strpos(datfile,'_ls')-3)
              if strpos(strmid(datfile,strpos(datfile,'_us')+3,strlen(datfile)-strpos(datfile,'_us')-3),'_') ge 1 then begin
                  mytitle = mytitle+', usigma = '+strmid(datfile,strpos(datfile,'_us')+3,strpos(datfile,'_',/REVERSE_SEARCH)-strpos(datfile,'_us')-3)
              end else begin
                  mytitle = mytitle+', usigma = '+strmid(datfile,strpos(datfile,'_us')+3,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'_us')-3)
              end
          end else if strpos(datfile,'_nobg') gt 0 then begin
              mytitle = '!Afit1d without background subtraction'
          end else if strpos(datfile,'f1d') gt 0 then begin
              mytitle = '!Afit1d with background subtraction'
          end else begin
              mytitle = strmid(datfile,strpos(datfile,'/',/REVERSE_SEARCH)+1,strlen(datfile)-strpos(datfile,'/',/REVERSE_SEARCH)-1)
          end
          snrint = 0UL
          snrint = intensmean/intensstddev
          mytitle = mytitle+': SNR = '+strtrim(string(long(snrint)),2)
          print,'mytitle = '+mytitle
          plot,dumlambda,dumintens,title=mytitle,xtitle='wavelength / '+STRING("305B),ytitle='normalized flux',yrange=[min(dumintens)-stddev(dumintens),max(dumintens)+stddev(dumintens)],ystyle=1,position=[0.15,0.1,0.98,0.9],xrange=[min(dumlambda),max(dumlambda)],xstyle=1
          device,/close
          set_plot,'x'
          printf,2,' '
          printf,2,'posxmin',posmin
          printf,2,'posxmax',posmax
          printf,2,'intensmean',intensmean
          printf,2,'intensmeanabsdev',intensmeanabsdev
          printf,2,'intensstddev',intensstddev
          printf,2,'snr',intensmean/intensstddev
          printf,2,'meantomeanabsdevratio',intensmean/intensmeanabsdev
          printf,3,xmin+((xmax-xmin)/2.),intensmean/intensstddev
      end
  end else begin
      dumintensmean = dblarr(maxn-(dintens-1))
      dumintensmeanabsdev = dblarr(maxn-(dintens-1))
      dumintensstddev = dblarr(maxn-(dintens-1))
      dumintens = dblarr(dintens)
      dumsnr = dblarr(maxn-(dintens-1))
      dummtabsdev = dblarr(maxn-(dintens-1))
      for i=ulong((dintens-1)/2),maxn-(((dintens-1)/2)+1) do begin
          k = 0
          for j=i-((dintens-1.)/2.),i+((dintens-1.)/2.) do begin
              dumintens(k) = intensity(j)
              k = k+1
          endfor
          dumintensmean(i-((dintens-1.)/2.)) = mean(dumintens)
;          print,'calcsnr: i = ',i,': dumintensmean = ',dumintensmean(i-((dintens-1.)/2.))
          dumintensmeanabsdev(i-((dintens-1.)/2.)) = meanabsdev(dumintens)
;          print,'calcsnr: i = ',i,': dumintensmeanabsdev = ',dumintensmeanabsdev(i-((dintens-1.)/2.))
          dumintensstddev(i-((dintens-1.)/2.)) = stddev(dumintens)
;          print,'calcsnr: i = ',i,': dumintensstddev = ',dumintensstddev(i-((dintens-1.)/2.))
          dumsnr(i-((dintens-1.)/2.)) = dumintensmean(i-((dintens-1.)/2.)) / dumintensstddev(i-((dintens-1.)/2.))
;          print,'calcsnr: i = ',i,': dumsnr = ',dumsnr(i-((dintens-1.)/2.))
          dummtabsdev(i-((dintens-1.)/2.)) = dumintensmean(i-((dintens-1.)/2.)) / dumintensmeanabsdev(i-((dintens-1.)/2.))
;          print,'calcsnr: i = ',i,': dumintensabsdev = ',dummtabsdev(i-((dintens-1.)/2.))
      endfor
      intensmean = mean(dumintensmean)
      print,'calcsnr: intensmean = ',intensmean
      intensmeanabsdev = mean(dumintensmeanabsdev)
      print,'calcsnr: intensmeanabsdev = ',intensmeanabsdev
      intensstddev = mean(dumintensstddev)
      print,'calcsnr: intensstddev = ',intensstddev
      snr = mean(dumsnr)
      print,'calcsnr: snr = ',snr
      mtar = mean(dummtabsdev)
      print,'calcsnr: mtar = ',mtar
      printf,2,'dintens',dintens
      printf,2,'intensmean',intensmean
      printf,2,'intensmeanabsdev',intensmeanabsdev
      printf,2,'intensstddev',intensstddev
      printf,2,'snr',snr
      printf,2,'meantomeanabsdevratio',mtar
      
; --- plot snrarray
      set_plot,'ps'
      device,filename=strmid(datfile,0,strpos(datfile,'.',/REVERSE_SEARCH))+'_snr.ps'
      mytitle = ''
      if strmid(datfile,strpos(datfile,'/')+1,2) eq 'hd' then begin
          mytitle = '!A'+strmid(datfile,strpos(datfile,'/')+1,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'/')-1)
      end else if strpos(datfile,'ylevel') ge 1 then begin 
          mytitle = '!Aobsaplimit='+strmid(datfile,10,strpos(datfile,'/')-10)+', ylevel='+strmid(datfile,strpos(datfile,'ylevel')+6,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'ylevel')-6)
      end else if strpos(datfile,'_ls') ge 1 then begin
          mytitle = 'lsigma = '+strmid(datfile,strpos(datfile,'_ls')+3,strpos(datfile,'_us')-strpos(datfile,'_ls')-3)+', usigma = '
          tempstring = strmid(datfile,strpos(datfile,'_us')+3,strlen(datfile)-strpos(datfile,'_us')-3)
          if strpos(tempstring,'_') lt 1 then begin
              mytitle = mytitle+strmid(datfile,strpos(datfile,'_us')+3,strpos(datfile,'.',/REVERSE_SEARCH)-strpos(datfile,'_us')-3)
          end else begin
              mytitle = mytitle+strmid(datfile,strpos(datfile,'_us')+3,strpos(datfile,'_',/REVERSE_SEARCH)-strpos(datfile,'_us')-3)
          end
      end else if strpos(datfile,'nobg') gt 0 then begin
          mytitle = '!Afit1d without background subtraction'
      end else if strpos(datfile,'f1d') gt 0 then begin
          mytitle = '!Afit1d with background subtraction'
      end else begin
          mytitle = datfile
      end
      mytitle = mytitle + ': mean(SNR) = '+strtrim(string(long(mean(dumsnr))),2)
      print,'mytitle = '+mytitle
      plot,lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1))),dumsnr,title=mytitle,xtitle='wavelength / '+STRING("305B),ytitle='SNR',yrange=[min(dumsnr)-stddev(dumsnr),max(dumsnr)+stddev(dumsnr)],ystyle=1,xrange=[min(lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1)))),max(lambda(ulong((dintens-1)/2):ulong(maxn-(((dintens-1)/2)+1))))],xstyle=1,position=[0.15,0.1,0.98,0.9]
      device,/close
      set_plot,'x'
      
  end
  close,2
  close,3
endelse
end
