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
pro recalc_thars,ecfile_old,ecfile_new,naps,mode,ordershift,pixelshift
;############################
;
; NAME:                  recalc_thars
; PURPOSE:               recalculates the IRAF-ecThAr file for different binnings
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      recalc_thars,<string 'ecfile_old'>,<string 'ecfile_new'>,<int naps>,<enum mode(0,1,2)>,<int ordershift>,<double pixelshift>
; INPUTS:                input file: 'ecrefThAr_SES_1074x1026':
;                          # Sat 00:05:54 24-Sep-2005
;                          begin   ecidentify refThAr_SES_1074x1026
;                                  id      refThAr_SES_1074x1026
;                                  task    ecidentify
;                                  image   refThAr_SES_1074x1026
;                                  units   angstroms
;                                  features        4
;                                           14   14    54.49  54.4929237   8573.1205   7.0  1  1
;                                           14   14    74.39  74.3874741   8575.3305   7.0  1  1
;                                           14   14    91.02  91.0204544   8577.2768   7.0  1  1
;                                            .
;                                            .
;                                            .
;                        int naps: number of apertures to recalculate
;                        enum mode(0,1,2): 0 - recalculates emission feature positions from binned to not-binned
;                                          1 - recalculates emission feature positions from not-binned to binned
;                                          2 - no binning
;                        int ordershift: shift to add for order number
;                        double pixelshift: shift in pixels to add to emission feature positions
; OUTPUTS:               file 'ecfile_new':
;                          # Sat 00:05:54 24-Sep-2005
;                          begin   ecidentify refThAr_SES_1074x1026
;                                  id      refThAr_SES_1074x1026
;                                  task    ecidentify
;                                  image   refThAr_SES_1074x1026
;                                  units   angstroms
;                                  features        4
;                                           14   14   108.98 108.9858474   8573.1205   7.0  1  1
;                                           14   14   148.78 148.4749482   8575.3305   7.0  1  1
;                                           14   14   182.04 182.0409088   8577.2768   7.0  1  1
;                                            .
;                                            .
;                                            .
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           15.11.2005
;

if n_elements(pixelshift) eq 0 then begin
  print,'recalcthars : Not enough arguments, return 0.'
  print,"usage       : recalc_thars,<string 'ecfile_old'>,<string 'ecfile_new'>,<int naps>,<enum mode(0,1,2)>,<int ordershift>,<double pixelshift>"
endif else begin

; --- logfile
  close,1
  openw,1,'logfile_recalc_thars'

; --- countlines
  maxn = countlines(ecfile_old)
  print,ecfile_old,': ',maxn,' DATA LINES'
  printf,1,ecfile_old,': ',maxn,' DATA LINES'

; --- build arrays
  tempstr      = ''
  apnrstr      = ''
  newline      = ''
  ordernr      = ''
  endofline    = ''
  j            = 1
  k            = 0
  l            = 1
  dumstart     = 0
  position     = 0.
  dumposstr    = ''
  posstrfound  = 0
  dumchar      = ''
  lastcharwaschar = 0
  lastcharwasempty = 1
  parnum       = 0

; --- read files in arrays
  close,2
  close,3
  openr,2,ecfile_old
  openw,3,ecfile_new
  while not EOF(2) do begin
    readf,2,tempstr
    tempstr = strtrim(tempstr,2)
    printf,1,'recalc_thars: tempstr='+tempstr
;    printf,1,'strtim(strmid(tempstr,0,2),2) = '+strtrim(strmid(tempstr,0,2),2)
    apnrstr = strtrim(strmid(tempstr,0,2),2)
    printf,1,'apnrstr = '+apnrstr
    if apnrstr eq 'of' then begin
      dumstart = 0
      printf,1,'dumstart set to ',dumstart
    endif
    if dumstart eq 1 then begin
      while strtrim(string(j),2) ne strtrim(apnrstr,2) do begin
	j = j + 1
      end
; --- read dumposstr
      ordernr = strtrim(string(j+ordershift),2)
      if ordernr le naps then begin
        k = 0
        while posstrfound eq 0 do begin
	  dumchar = strmid(tempstr,k,1)
          k = k+1
          print,'j = ',j,', dumchar = '+dumchar
          if dumchar eq ' ' then begin
            if lastcharwaschar eq 1 then begin
              if parnum eq 3 then begin
                posstrfound = 1
                print,'j = ',j,', posstrfound = 1, position = '+position
              endif
            endif
            lastcharwasempty = 1
            lastcharwaschar = 0
          endif else begin
            if lastcharwasempty eq 1 then begin
              parnum = parnum + 1
              if parnum eq 3 then begin
                position = dumchar
              endif
            endif else begin
              if parnum eq 3 then begin
                position = position + dumchar
              endif
            endelse
            lastcharwaschar = 1
            lastcharwasempty = 0
          endelse
        end
        dumposstr = strtrim(strmid(tempstr,7,10))
        printf,1,'dumposstr = '+dumposstr
        printf,1,'        j = ',j
        position = double(dumposstr)
; --- rebin
        if mode eq 0 then begin
          position = position * 2.
        endif else if mode eq 1 then begin
          position = position / 2.
        end
        position = position + pixelshift
        printf,1,'new position = ',position

        endofline = tempstr
        for l=1,4 do begin
          endofline = strtrim(strmid(endofline,strpos(endofline,' ')),2)
        endfor

        printf,1,ordernr,ordernr,position,position,endofline,FORMAT = '("recalc_thars: newline = ",A," ",A," ",F7.2," ",F7.2," ",A)'
        if ordernr gt 0 then $
          printf,3,ordernr,ordernr,position,position,endofline,FORMAT = '(A," ",A," ",F7.2," ",F7.2," ",A)'
      endif
    endif else begin
      if strmid(tempstr,0,5) eq 'begin' then begin
        tempstr = strtrim(strmid(tempstr,6),2)
        newline = 'begin '
        task    = strmid(tempstr,0,strpos(tempstr,' '))
        filename = strmid(ecfile_new,strpos(ecfile_new,'/',/REVERSE_SEARCH)+3)
        printf,1,'recalc_thars: task = '+task+', filename = '+filename
        newline = newline+task+' '+filename
        printf,1,'recalc_thars: begin: newline = '+newline
        printf,3,newline
      end else if strmid(tempstr,0,1) eq 'i' then begin
        newline = strmid(tempstr,0,strpos(tempstr,' ')+1)+' '+filename
        printf,1,'recalc_thars: i: newline = '+newline
        printf,3,newline
      end else if (strmid(tempstr,0,4) eq 'task') OR $
                    (strmid(tempstr,0,5) eq 'units') OR $
                    (strmid(tempstr,0,8) eq 'features') then begin
        newline = tempstr
        printf,1,'recalc_thars: task,units,features: newline = '+newline
        printf,3,newline
      end
    endelse
    if apnrstr eq 'fe' then begin
      dumstart = 1
      print,'dumstart set to ',dumstart
      printf,1,'dumstart set to ',dumstart
    endif
  endwhile
  printf,3,'slope 0'
  close,2
  close,3

  close,/all
endelse
end
