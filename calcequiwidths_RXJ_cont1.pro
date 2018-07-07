
;############################
pro calcequiwidths_RXJ,filelist,hjdlist
;############################
;
; NAME:                  calcequiwidths_RXJ
; PURPOSE:               * calculates the equivalent widths within a
;                          given wavelengthrange for a list of files
;                        * plots equivalent widths over hjd
;                        * calculates mean and rms of equivalent widths
;
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcequiwidths_RXJ,'filelist',xmin,xmax
; INPUTS:                input file: 'filelist':
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:04:21.984_botzfsx_ecd_ctc.text
;                          ../../UVES/ready/red_l/RXJ1523_l_UVES.2000-05-26T23:39:57.321_botzfsx_ecd_ctc.text
;                                 .
;                                 .
;                                 .
;                        inputfile: 'hjdlist':
;                          
; OUTPUTS:               outfile: '<datfile>_<xmin>-<xmax>.text'
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           10.04.2004
;

if n_elements(hjdlist) eq 0 then begin
    print,'calcequiwidths_RXJ: Not enough arguments specified, return 0.'
    print," USAGE: calcequiwidths_RXJ,'../../UVES/ready/red_l/RXJ_ctcv.list','../../UVES/ready/red_l/hjdlist.text'"
end else begin   
    
    equiwidthlist,filelist,6557.25,6568.60,hjdlist
    equiwidthlist,filelist,5882.52,5903.16,hjdlist
    equiwidthlist,filelist,6435.32,6443.08,hjdlist
;    equiwidthlist,filelist,
;    equiwidthlist,filelist,
;    equiwidthlist,filelist,
;    equiwidthlist,filelist,
;    equiwidthlist,filelist,

endelse
end
