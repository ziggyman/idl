;******************************************************************************
;+
;*NAME:
;
;       PLOTOPEN
;
;*PURPOSE:
;
;       Procedure to open plot journal file
;
;*CALLING SEQUENCE:
;
;       PLOTOPEN,DNAME,name
;
;*PARAMETERS:
;
;       DNAME (O) (REQ)
;             device name.  Saves the current plot type to reset it
;             in PLOTPRINT.
;
;       name  (I) (OPT) (0) (S)
;             file name to place plots.  If not supplied then plots
;             are placed in IUEIDL.**, where ** is dependent upon the
;             plot type.  For postscript, ** = 'ps'; for tektronix,
;             ** = 'tek', etc.  This value isw stored in !iueprint.type.
;
;*SIDE EFFECTS:
;
;       The specified plot file is opened and all plots are
;       written to it until PLOTCLOSE or PLOTPRINT is called.
;
;       The device name (!D.NAME) is reset to !iueprint.dev.
;
;*OPERATIONAL NOTES:
;
;       SET_PLOT must be set to the value in !iueprint.dev to use
;       the plot journal.
;
;       For users who want the y-axis label to parallel the y-axis,
;       !p.font must be set to -1 (i.e., !p.font = -1).
;
;       tested with IDL Version 2.1.0  (sunos sparc)     23 Jul 91
;       tested with IDL Version 2.1.0  (ultrix mipsel)   N/A
;       tested with IDL Version 2.1.0  (vms vax)         23 Jul 91
;
;*METHOD:
;
;       IDL procedure DEVICE with the keyword PLOT_TO is used to
;       direct the plots to the specified file.  If the terminal
;       type is 'TEK' then the output is also directed to the screen.
;
;*SYSTEM VARIABLES USED:
;
;       !d.name
;       !iueprint.type
;       !iueprint.dev
;
;*FILES USED, CREATED, OR DESTROYED:
;
;       A file, with default name IUEIDL.**, or user specified name
;       and extension .** is created, where ** is the value in
;       !iueprint.type as described above.
;
;*PROCEDURES USED:
;
;       PARCHECK
;
;*MODIFICATION HISTORY:
;
;       writen by D. Lindler  Dec. 1986
;       C.A.G - change calling sequence to avoid use of additional
;               system variable; add printing of calling sequence
;               if no parameters are given.
;       RAE  - setting up viewport size and fancy
;       6-28-8 RWT compress code and update prolog
;       6-30-88 RWT change internal parameter NAME to FILE to not
;         output plot file name with extension added
;       11-4-88 RAE uses pltparm to save viewport size in vecor named
;         sysvars. URP #307
;        3-12-91 PJL modified for unix/sun - many changes
;        6-10-91 PJL modified to handle various printers; updated prolog;
;                tested on VAX and SUN with QMS/TEK and PS printers
;        7-03-91 GRA changed WARNING: statement to PLOTOPEN: .
;        7-15-91 RWT add /none keyword to openw statement
;       12-04-91 PJL added to prolog documentation
;       24 Feb 93  PJL  added version.os branch to handle Version 3 UNIX/Ultrix
;                       problem with the /none keyword
;        9 Sep 93 RWT remove parameter UNIT and openw commands
;-
;******************************************************************************
 pro plotopen,dname,name
;
 nparm = n_params(0)
 if (nparm eq 0) then begin
    print,'PLOTOPEN,DNAME,name'
    retall
 endif  ; nparm
 parcheck,nparm,[1,2],'PLOTOPEN'
;
; get system variables that define printer
;
 type = !iueprint.type
 dev = !iueprint.dev
;
; define file name (use iueidl. as default) and get plot dimensions
;
 if (nparm eq 1) then file = 'iueidl.' + type else file = name + '.' + type
;
; reset printer type
;
 dname = !d.name     ; save the present type
 set_plot,type       ; reset type
 if (strlowcase(dname) ne strlowcase(!d.name)) then   $
     print,'PLOTOPEN: device name is now set to ',strupcase(!d.name)
;
; printer device variations
;
 if ((dev ne '') and (dev ne ' ')) then begin
    dev = 'device,' + dev + "'" + file + "'"
    check = execute(dev)
    if (check eq 0) then print,'Problem opening file' else   $
       print,'Plots will be placed in ',strupcase(file)
 endif  ; dev ne ''
 return
 end  ; plotopen
