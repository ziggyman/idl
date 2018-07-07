;###########################
function countcols,filename,DELIMITER=delimiter
;###########################

;
; NAME:                  countcols.pro
; PURPOSE:               counts the columns in a table, delimiter = ' ' if not stated else
; CATEGORY:
; CALLING SEQUENCE:      countcols,'datafile'
; INPUTS:                datafile
;                            r1508268-243910 227.11204167 -24.65302778 338.55967000  28.57959000  -116.8    1.5   -3.3   13.2   -5.8   13.2 4 11.42 20030411    1507m23 2   1  36.1 0.93   61.4    1.2   -2.6    6.3   2.1  24.4 99.999 99.999 99.999 99.999   0653-0321526  0.280 14.26 12.92 13.63 12.64 11.38 A J150826.8-243910  0.122 11.793 0.04 10.951 0.07 10.266 0.06 B 15082687-2439107  0.258 10.932 0.02 10.436 0.02 10.364 0.02 AAA A AA
;                            r1508321-242942 227.13387500 -24.49525000 338.68088000  28.69780000   -54.6    2.1  -10.4   13.2    0.8   13.2 4 11.75 20030411    1507m23 2   3  28.0 0.94   62.6    1.0   -4.9    5.2   3.8  23.8 99.999 99.999 99.999 99.999   0655-0321354  0.154 15.22 13.21 14.66 13.10 12.11 A J150832.1-242942  0.151 12.071 0.03 11.067 0.08 10.153 0.07 A 15083211-2429428  0.204 10.998 0.02 10.297 0.02 10.155 0.02 AAA A AA

;
; COPYRIGHT:             Andreas Ritter
; DATE:                  25/04/2008
;
;                        headline
;                        feetline (up to now not used)
;

  cols=0L
  oldcols=0L
  if n_elements(filename) eq 0 then print,'COUNTCOLS: No file specified, return 0.' $
  else begin
    templine = ''
;  run = 1
;  cols = 0UL
    i_nlines = countlines(filename)
    openr,lun,filename,/get_lun
    for i=0UL,i_nlines-1 do begin
      readf,lun,templine
      str_line = templine
      templine = strtrim(templine,2)
      if strmid(templine,0,1) ne '#' then begin
        cols = 0
        if not keyword_set(DELIMITER) then begin
;          DELIMITER = ' '
          cols = n_elements(strsplit(templine,' ',/EXTRACT))
        end else begin
          while strpos(templine,Delimiter) ge 0 do begin
            cols = cols+1
            templine = strtrim(strmid(templine,strpos(templine,Delimiter)+1),2)
          end
          cols = cols+1
        end
        if cols gt oldcols then begin
          oldcols = cols
          print,'countcols: cols = ',cols
          print,'countcols: str_line = <'+str_line+'>'
;        print,'countcols: oldcols = ',oldcols
        endif
      endif
    end
    free_lun,lun
  end
  return,oldcols
end

;;###########################
;function countcols,filename
;;###########################
;
;cols=0L
;if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
;else begin
;  templine = ''
;  openr,num,filename,/get_lun
;  readf,num,templine
;  close,num
;  templine = strtrim(templine,2)
;  while strpos(templine,' ') ge 0 do begin
;    cols = cols+1
;    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
;  end
;  cols = cols+1
;end
;return,cols
;end
