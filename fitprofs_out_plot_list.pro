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
pro fitprofs_out_plot_list,fitprofs_trim_outfiles,hjdfile
;############################
;
; NAME:                  fitprofs_out_plot_list.pro
; PURPOSE:               starts fitprofs_out_plot for every input file in fitprofs_trim_outfiles
;
; CATEGORY:              spectral analysis
; CALLING SEQUENCE:      fitprofs_out_plot_list,'<fitprofs_RXJ_out_trimmed>.list','<hjds.dat>'
; INPUTS:                input file: 'fitprofs_RXJ_out_trimmed.list':
;                          /yoda/UVES/MNLupus/ready/red_l/fitprofs_out_5889.95.dat
;                          /yoda/UVES/MNLupus/ready/red_l/fitprofs_out_5895.924.dat
;                              ...
if n_elements(hjdfile) lt 1 then begin
    print,'fitprofs_out_plot_list: NOT ENOUGH PARAMETERS SPECIFIED!'
    print,'fitprofs_out_plot_list: calling sequence:'
    print," fitprofs_out_plot_list,'single_wavelength_files.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'"
end else begin
    ndatfiles = countlines(fitprofs_trim_outfiles)
    tempstr = ''
    openr,lun,fitprofs_trim_outfiles,/GET_LUN
    for i=0,ndatfiles-1 do begin
        readf,lun,tempstr
        tempstr = strtrim(tempstr,2)
        fitprofs_out_plot,tempstr,hjdfile
    endfor
    free_lun,lun
endelse
end