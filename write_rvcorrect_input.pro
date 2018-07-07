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

;############################
pro write_rvcorrect_input,imagelist,utcmiddle_hms_list,ra_hms_list,dec_hms_list,hjd_vobs_list,outlist
;############################
;
; NAME:                  write_rvcorrect_input.pro
; PURPOSE:               writes input-data file for IRAF's rv.rvcorrect task
;                        if itcmiddle_hms.hour == 24 day is raised by one
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      write_rvcorrect_input,'imagelist','utcmiddle_hms_list','ra_hms_list','dec_hms_list','hjd_vobs_list','outlist'
; INPUTS:                input file: 'imagelist':
;                           RXJ1523..<DATE>T<TIME_START>....fits
;                           RXJ1523..<DATE>T<TIME_START>....fits
;                             ...
;                        input file: 'utcmiddle_hms_list':
;                           23:21:44
;                           00:32:29
;                             ...
;                        input file: 'ra_hms_list':
;                           15:23:30.1
;                           15:23:30.1
;                             ...
;                        input file: 'dec_hms_list':
;                           -38:21:28.7
;                           -38:21:28.8
;                             ...
;                        input file: 'hjd_vobs_list':
;                           #hjd[days] vobs[km/s]
;                           2451691.47899437      -0.101694821
;                           2451691.50370868      -0.101694821
;                             ...
; OUTPUTS:               output file: 'outlist':
;                           2000 05 26 23:21:44 15:23:30.1 -38:21:28.7 0 -0.101694821
;                           2000 05 27 00:32:29 15:23:30.1 -38:21:28.8 0 -0.101694821
;                             ...
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           20.10.2004
;
    if n_elements(outlist) lt 1 then begin
        print,'write_rvcorrect_input: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'write_rvcorrect_input: USAGE:'
        print,"  write_rvcorrect_input,'imagelist','utcmiddle_hms_list','ra_hms_list','dec_hms_list','hjd_vobs_list','outlist'"
    endif else begin
; --- count lines of input files
        nlines_imagelist = countlines(imagelist)
        ndatlines_imagelist = countdatlines(imagelist)
        print,'imagelist ',imagelist,' contains ',nlines_imagelist,' lines and ',ndatlines_imagelist,' datalines'
        nlines_utcmiddle_hms_list = countlines(utcmiddle_hms_list)
        ndatlines_utcmiddle_hms_list = countdatlines(utcmiddle_hms_list)
        print,'utcmiddle_hms_list ',utcmiddle_hms_list,' contains ',nlines_utcmiddle_hms_list,' lines and ',ndatlines_utcmiddle_hms_list,' datalines'
        nlines_ra_hms_list = countlines(ra_hms_list)
        ndatlines_ra_hms_list = countdatlines(ra_hms_list)
        print,'ra_hms_list ',ra_hms_list,' contains ',nlines_ra_hms_list,' lines and ',ndatlines_ra_hms_list,' datalines'
        nlines_dec_hms_list = countlines(dec_hms_list)
        ndatlines_dec_hms_list = countdatlines(dec_hms_list)
        print,'dec_hms_list ',dec_hms_list,'contains ',nlines_dec_hms_list,' lines and ',ndatlines_dec_hms_list,' datalines'
        nlines_hjd_vobs_list = countlines(hjd_vobs_list)
        ndatlines_hjd_vobs_list = countdatlines(hjd_vobs_list)
        print,'hjd_vobs_list ',hjd_vobs_list,' contains ',nlines_hjd_vobs_list,' lines and ',ndatlines_hjd_vobs_list,' datalines'
        
; --- create data arrays
        datearr = strarr(ndatlines_imagelist)
        utcarr = strarr(ndatlines_utcmiddle_hms_list)
        raarr = strarr(ndatlines_ra_hms_list)
        decarr = strarr(ndatlines_dec_hms_list)
        vobsarr = strarr(ndatlines_hjd_vobs_list)

        tempstr = ''

; --- read imagelist
        openr,lun,imagelist,/GET_LUN
        ndats = 0
        for i=0,nlines_imagelist-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                tempstr = strmid(tempstr,0,strpos(tempstr,'T')+3)
                datearr(ndats) = strmid(tempstr,strlen(tempstr)-13)
                print,'datearr(',ndats,') = ',datearr(ndats)
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- read utcmiddle_hms_list
        openr,lun,utcmiddle_hms_list,/GET_LUN
        ndats = 0
        for i=0,nlines_utcmiddle_hms_list-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                utcarr(ndats) = tempstr
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- read ra_hms_list
        openr,lun,ra_hms_list,/GET_LUN
        ndats = 0
        for i=0,nlines_ra_hms_list-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                raarr(ndats) = tempstr
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- read dec_hms_list
        openr,lun,dec_hms_list,/GET_LUN
        ndats = 0
        for i=0,nlines_dec_hms_list-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                decarr(ndats) = tempstr
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- read hjd_vobs_list
        openr,lun,hjd_vobs_list,/GET_LUN
        ndats = 0
        for i=0,nlines_hjd_vobs_list-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                vobsarr(ndats) = strmid(tempstr,strpos(tempstr,' ',/REVERSE_SEARCH)+1,strlen(tempstr)-strpos(tempstr,' ',/REVERSE_SEARCH)-1)
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- write outlist
        year = 0ul
        month = 0ul
        day = 0ul
        hour = 0ul
        min = 0ul
        sec = 0.
        openw,lun,outlist,/GET_LUN
        for i=0,ndatlines_imagelist-1 do begin
            year = ulong(strmid(datearr(i),0,4))
            print,'strmid(datearr(i),0,4) = <'+strmid(datearr(i),0,4)+'>'
            month = ulong(strmid(datearr(i),5,2))
            print,'strmid(datearr(i),5,2) = <'+strmid(datearr(i),5,2)+'>'
            day = ulong(strmid(datearr(i),8,2))
            print,'strmid(datearr(i),8,2) = <'+strmid(datearr(i),8,2)+'>'
            temphour = ulong(strmid(datearr(i),strlen(datearr(i))-2))
            print,'temphour = <'+strtrim(string(temphour),2)+'>'
            hour = ulong(strmid(utcarr(i),0,2))
            print,'strmid(utcarr(i),0,2) = <'+strmid(utcarr(i),0,2)+'>'
            min = ulong(strmid(utcarr(i),3,2))
            print,'strmid(utcarr(i),3,2) = <'+strmid(utcarr(i),3,2)+'>'
            sec = double(strmid(utcarr(i),strpos(utcarr(i),':',/REVERSE_SEARCH)+1))
            print,'strmid(utcarr(i),6,4) = <'+strmid(utcarr(i),6,4)+'>'
;            print,'write_rvcorrect_input: date = ',year,'-',month,'-',day,' ',hour,':',min,':',sec
            if (temphour ne hour) AND ((hour eq 0) OR (hour gt 23)) then begin
                if (hour gt 23) then $
                    hour = hour - 24
                day = day+1
; --- 31 day months
                if (month eq 1) or (month eq 3) or (month eq 5) or (month eq 7) or $
                   (month eq 8) or (month eq 10) or (month eq 12) then begin
                    if day gt 31 then begin
                        month = month + 1
                        day = 1
                        if month eq 13 then begin
                            year = year + 1
                            month = 1
                        endif
                    endif
                endif else if (month eq 4) or (month eq 6) or (month eq 9) or (month eq 11) then begin
; --- 30 day months
                    if day gt 30 then begin
                        month = month + 1
                        day = 1
                        if month eq 13 then begin
                            year = year + 1
                            month = 1
                        endif
                    endif
                end else begin
; february
                    if (double(ulong(year / 100)) eq double(year / 100)) or (double(ulong(year / 4)) ne double(year / 4)) then begin
                        if day eq 30 then begin
                            day = 1
                            month = month + 1
                        endif
                    end else begin
                        if day gt 28 then begin
                            day = 1
                            month = month + 1
                        endif
                    end
                end
            endif ;hour gt 23
;            print,'write_rvcorrect_input: date = ',year,'-',month,'-',day,' ',hour,':',min,':',sec
            tempstr = strtrim(string(year),2)+' '
            if month lt 10 then $
                tempstr = tempstr + '0'
            tempstr = tempstr + strtrim(string(month),2) + ' '
            if day lt 10 then $
                tempstr = tempstr + '0'
            tempstr = tempstr + strtrim(string(day),2) + ' '
            if hour lt 10 then $
                tempstr = tempstr + '0'
            tempstr = tempstr + strtrim(string(hour),2)+':'
            if min lt 10 then $
                tempstr = tempstr + '0'
            tempstr = tempstr + strtrim(string(min),2)+':'
            if sec lt 10 then begin
                tempstr = tempstr + '0'
                printf,lun,FORMAT='(A,F3.1,1X,A,1X,A," 0 ",A)',tempstr,sec,raarr(i),decarr(i),vobsarr(i)
            endif else begin
                printf,lun,FORMAT='(A,F4.1,1X,A,1X,A," 0 ",A)',tempstr,sec,raarr(i),decarr(i),vobsarr(i)
            endelse
        endfor
        free_lun,lun

    endelse
end
