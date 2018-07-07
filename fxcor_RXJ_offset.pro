;###########################
function strrep,s,sso,ssn
;###########################

c=0L
if n_params() ne 3 then print,'STRREP: Not enough string parameters specified, return 0.' $
else begin
  result = ''
  i = 0
  j = 1
  while (j eq 1) do begin
    if i le strlen(s)-1 then begin
      if strmid(s,i,strlen(sso)) eq sso then begin
        result = result + ssn
        i = i + strlen(sso)
      endif else begin
        result = result + strmid(s,i,1)
        i = i + 1
      endelse
    endif else begin
      j = 0
    end
  end
end
return,result
end

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

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;###########################
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;###########################
function readfilelinestoarr,filename
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILELINESTOARR: No file specified, return dumarr'
  endif else begin
    nlines   = countlines(filename)
    dataarr  = strarr(nlines)
    templine = ''
    openr,lun,filename,/get_lun
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      dataarr(i) = templine
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;###########################
function readfiletoarr,filename
;###########################

  dumarr = strarr(1)
  dumarr(0) = ''
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILETOARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    dataarr = strarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
        dataarr(irun,idat) = templine
        irun = irun + 1
      end
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;###########################
function readfiletodblarr,filename
;###########################

  dumarr = dblarr(1)
  dumarr(0) = 0.
  if n_params() ne 1 then begin
    print,'fxcor_RXJ_offset.READFILETODBLARR: No file specified, return dumarr'
  endif else begin
    nlines     = countlines(filename)
    ndatalines = countdatlines(filename)
    ncols      = countcols(filename)
    dataarr = dblarr(ndatalines,ncols)
    templine = ''
    openr,lun,filename,/get_lun
    irun = 0UL
    for i=0, nlines-1 do begin
      readf,lun,templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        idat = 0
        while (strpos(templine,' ') gt 0) do begin
          dataarr(irun,idat) = strmid(templine,0,strpos(templine,' '))
          templine = strtrim(strmid(templine,strpos(templine,' ')),2)
          idat = idat + 1
        end
        dataarr(irun,idat) = templine
        irun = irun + 1
      endif
    endfor
    free_lun,lun
    return,dataarr
  end
  return,dumarr
end

;############################
pro fxcor_RXJ_offset,zerofile,reffile,print
;############################
;
; NAME:                  fxcor_RXJ_offset.pro
; PURPOSE:               calculates offset from both input files (zerofile, reffile)
;                        and plots 'vhelio' and 'vhelioerr' over hjd
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fxcor_RXJ_offset,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission_vhelio_mean+rms.data','/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2.data','print'
; INPUTS:                input file: zerofile ('</yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission_vhelio_mean+rms.data>'):
;                          red_l/fxcor_RXJ_red_l_ref1_no_emission_5835-5865_-3._80_80_75._3._-2.-_trimmed.dat
;                          red_l/fxcor_RXJ_red_l_ref1_no_emission_5978-6003_-3._80_80_75._3._-2.-_trimmed.dat
;                             ...       
;                          red_r/fxcor_RXJ_red_r_ref1_no_emission_4790-4854_-3._80_80_75._3._-2.-_trimmed.dat
;                          red_r/fxcor_RXJ_red_r_ref1_no_emission_4864-5197_-3._80_80_75._3._-2.-_trimmed.dat
;                                                      ...
;                          (OUTPUT-files of 'fxcor_out_trim(_mean_rms).pro')
;                        
;                        input file: reffile ('/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2.data'):
;                          #N HJD HGHT FWHM VOBS VREL VHELIO VERR
;                          #U days          km/s km/s km/s   km/s
;                          1691.4790 0.48000000 193.83000 6.2303500 16.504150 3.1657000 6.5535000
;                          1691.5037 0.49500000 188.98000 8.3027000 18.576600 5.2018000 6.8515000
;                           ...                  .
; OUTPUTS:               output files: '<zerofile>_offset_set.ps'
;                                      '<zerofile>_offset_set.data'
;                                      '<zerofile>_offset.log'
;                    
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           28.12.2004
;
    if n_elements(print) eq 0 then begin
        print,'fxcor_RXJ_offset: ERROR: Not enough parameters specified!'
        print,"fxcor_RXJ_offset: USAGE: fxcor_RXJ_offset,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_no_emission_vhelio_mean+rms.data','/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r+l_refHD209290_-3.5_120_90_90_90_-2.data','print'"
    endif else begin
        path = strmid(zerofile,0,strpos(zerofile,'/',/REVERSE_SEARCH)+1)

        nzerolines    = countlines(zerofile)
        nzerodatlines = countdatlines(zerofile)
        nzerocols     = countcols(zerofile)
        
        nreffilelines     = countlines(reffile)
        nreffiledatalines = countdatlines(reffile)
        nreffilecols      = countcols(reffile)
 
        zerofilearrrl  = readfiletodblarr(zerofile)
        zerofilestrarr = readfilelinestoarr(zerofile)
        reffilearr     = readfiletodblarr(reffile)
        reffilestrarr  = readfilelinestoarr(reffile)

        zerofilearr = dblarr(nzerodatlines/2, nzerocols)

        for i=0UL, (nzerodatlines/2)-1 do begin
            zerofilearr(i,0) = zerofilearrrl(i,0)
            zerofilearr(i,1) = (zerofilearrrl(i,1) + zerofilearrrl(i+(nzerodatlines/2),1)) / 2.
            zerofilearr(i,2) = (zerofilearrrl(i,2) + zerofilearrrl(i+(nzerodatlines/2),2)) / 2.
        endfor

        zerovheliomean   = mean(zerofilearr[*,1])
        zerovheliostddev = stddev(zerofilearr[*,1])
        refvheliomean    = mean(reffilearr[*,5])
        refvheliostddev  = stddev(reffilearr[*,5])

        openw,lun,strmid(zerofile,0,strpos(zerofile,'.',/REVERSE_SEARCH))+'_offset.log',/GET_LUN
        printf,lun,"mean of vhelio's in file "+zerofile+': '+strtrim(string(zerovheliomean),2)
        printf,lun,"stddev of vhelio's in file "+zerofile+': '+strtrim(string(zerovheliostddev),2)
        printf,lun,' '
        printf,lun,"mean of vhelio's in file "+reffile+': '+strtrim(string(refvheliostddev),2)
        printf,lun,"stddev of vhelio's in file "+reffile+': '+strtrim(string(refvheliostddev),2)
        printf,lun,' '
        print,'fxcor_RXJ_offset: zerovheliomean = ',zerovheliomean,', zerovheliostddev = ',zerovheliostddev
        print,'fxcor_RXJ_offset: refvheliomean = ',refvheliomean,', refvheliostddev = ',refvheliostddev

        vheliodiff = refvheliomean - zerovheliomean
        print,'fxcor_RXJ_offset: vheliodiff = ',vheliodiff
        printf,lun,'difference of mean values: '+strtrim(string(vheliodiff),2)
        free_lun,lun

; --- write output file
        openw,lun,strmid(zerofile,0,strpos(zerofile,'.',/REVERSE_SEARCH))+'_offset_set.data',/GET_LUN
        
        printf,lun,zerofilestrarr(0)
        printf,lun,zerofilestrarr(1)
        nnewlines = nzerodatlines / 2
        for i = 0UL, nnewlines - 1 do begin
            zerofilearr(i,1) = zerofilearr(i,1) + vheliodiff
            printf,lun,zerofilearr(i,0),zerofilearr(i,1),zerofilearr(i,2),FORMAT = '(F11.5 , F16.8 , F16.8)'
        endfor
;        printf,lun,"# mean of vhelio's: "+strtrim(string(mean(zerofilearr[*,1])),2)
;        printf,lun,"# stddev of vhelio's: "+strtrim(string(stddev(zerofilearr[*,1])),2)
        free_lun,lun

; --- write mean_rms file
        openw,lun,strmid(zerofile,0,strpos(zerofile,'.',/REVERSE_SEARCH))+'_offset_set_mean_rms'+strmid(zerofile,strpos(zerofile,'.',/REVERSE_SEARCH)),/get_lun
        tempday = 0.
        dumday = 0.
        day = 1
        firstimageofday = 0
        for i=0, nnewlines-1 do begin
          if i eq 0 then begin
            tempday = zerofilearr(0,0)
          endif
          dumday = zerofilearr(i,0)
;          print,'fxcor_RXJ_offset: dumday = '+strtrim(string(dumday),2)+', tempday = '+strtrim(string(tempday),2)+', dumday - tempday = '+strtrim(string(dumday-tempday),2)
          if ((dumday - tempday) gt 0.9) or (i eq (nnewlines-1)) then begin
            if (dumday - tempday) gt 0.9 then begin
              printf,lun,'night '+strtrim(string(day),2)+': '+strtrim(string(i-1-firstimageofday))+' images'
            endif else begin
              printf,lun,'night '+strtrim(string(day),2)+': '+strtrim(string(i-firstimageofday))+' images'
            endelse
            printf,lun,'  vhelio:'
            printf,lun,'    mean = '+strtrim(string(mean(zerofilearr(firstimageofday:i-1,1))),2)+' km/s'      
            printf,lun,'    rms  = '+strtrim(string(stddev(zerofilearr(firstimageofday:i-1,1))),2)+' km/s'      
            firstimageofday = i
            tempday = zerofilearr(i,0)
            day = day + 1
          endif 
  
        endfor
        printf,lun,'all nights: '+strtrim(string(nnewlines))+' images'
        printf,lun,'  vhelio:'
        printf,lun,'    mean = '+strtrim(string(mean(zerofilearr(*,1))),2)+' km/s'
        printf,lun,'    rms  = '+strtrim(string(stddev(zerofilearr(*,1))),2)+' km/s'      

  free_lun,lun

; --- plot new zerofilearr
        set_plot,'ps'
        device,filename=strmid(zerofile,0,strpos(zerofile,'.',/REVERSE_SEARCH))+'_offset_set.eps'
        plot,zerofilearr[*,0],zerofilearr[*,1],$
          xrange=[min(zerofilearr[*,0])-0.2,max(zerofilearr[*,0])+0.2],xstyle=1,$
          yrange=[min(zerofilearr[*,1])-max(zerofilearr[*,2]),max(zerofilearr[*,1])+max(zerofilearr[*,2])],$
          ystyle=1,charsize=1.2,xtitle='heliocentric julian date (days)',psym=4,$
          ytitle='heliocentric radial velocity (km/s)',position=[0.09,0.11,0.98,0.98]
        oploterr,zerofilearr[*,0],zerofilearr[*,1],zerofilearr[*,2]
        device,/close
        set_plot,'x'

    endelse
end
