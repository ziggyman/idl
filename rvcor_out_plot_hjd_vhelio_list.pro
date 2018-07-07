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
pro rvcor_out_plot_hjd_vhelio_list,filelist
;############################
;
; NAME:                  rvcor_out_plot_hjd_vhelio_list.pro
; PURPOSE:               reads filelist and plots vhelio over hjd
;
; CATEGORY:              data analysis
; CALLING SEQUENCE:      rvcor_out_plot_hjd_vhelio_list,'filelist'
; INPUTS:                input file (list of IRAF's rv.rvcorrect outfiles): 'filelist':
;                          /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_5865.45_hjd_vobs_to_rvcorrect_rvcor.dat
;                          /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_5865.98_hjd_vobs_to_rvcorrect_rvcor.dat
;                             ...
; OUTPUTS:               outputlist = strmid(filelist,0,strpos(filelist,'.',/REVERSE_SEARCH))+'_out.list'
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           24.10.2004
;
    if n_elements(filelist) lt 1 then begin
        print,'rvcor_out_plot_hjd_vhelio_list: ERROR: NOT ENOUGH PARAMETERS -> returning'
        print,'rvcor_out_plot_hjd_vhelio_list: USAGE:'
        print,"  rvcor_out_plot_hjd_vhelio_list,'filelist'"
    endif else begin
; --- count lines of input files
        nlines = countlines(filelist)
        ndatlines = countdatlines(filelist)

; --- read filelist
        filearr = strarr(ndatlines)
        tempstr = ''
        ndats = 0
        openr,lun,filelist,/GET_LUN
        for i=0,nlines-1 do begin
            readf,lun,tempstr
            tempstr = strtrim(tempstr,2)
            if strmid(tempstr,0,1) ne '#' then begin
                filearr(ndats) = tempstr
                ndats = ndats + 1
            endif
        endfor
        free_lun,lun

; --- start rvcor_out_plot_hjd_vhelio
        outputlist = strmid(filelist,0,strpos(filelist,'.',/REVERSE_SEARCH))+'_out.list'
        print,'rvcor_out_plot_hjd_vhelio_list: outputlist = '+outputlist
        openw,lun,outputlist,/GET_LUN
        for i=0,ndatlines-1 do begin
            outfile = strmid(filearr(i),0,strpos(filearr(i),'vobs',/REVERSE_SEARCH))+'vhelio.eps'
            printf,lun,outfile
            rvcor_out_plot_hjd_vhelio,filearr(i)
        endfor
        free_lun,lun

    endelse
end