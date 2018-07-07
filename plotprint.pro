;******************************************************************************
;+
;*NAME:
;
;       PLOTPRINT
;
;*PURPOSE:
;
;       Sends a plot file created using PLOTOPEN, to the default
;       laser printer and closes plot file.
;
;*CALLING SEQUENCE:
;
;       PLOTPRINT,DNAME,name
;
;*PARAMETERS:
;
;       DNAME (I) (REQ)
;       device name.  If device name is TEK this equals null string.
;
;       name (I) (OPT) (0) (S)
;       name of plot file (extension is assumed to be equal to !iueprint.type
;       if not given). If not supplied, then iueidl.ext (where ext equals
;       !iueprint.type) is sent to the laser printer.
;
;*SYSTEM VARIABLES USED:
;
;       !D.NAME (effected in PLOTCLOSE)
;       !iueprint.type
;       !iueprint.com
;       !iuer.dat
;
;*SIDE EFFECTS:
;
;       !d.name get reset to DNAME.
;
;*PROCEDURE:
;
;               PLOTPRINT changes !d.name if dname not
;       equal to '' and closes input file.
;       The input file extension (if given) is checked against the default
;       printer type (the program will refuse to proceed if the extension
;       appears to be inappropriate for the printer to be used - the old
;       .PLT extension used in version 1 is assumed to be for TEK printers).
;       Then, the file is sent to the printer defined in !iueprint.com.
;       If !iueprint.type is 'TEK', then 3 files are send to the laser
;       printer (in one print command) in the following order:
;            - QUIC command file [IUERDAF.GENLIB01.DAT]TEKON.LIS
;              to put printer in plot mode,
;            - input file (i.e. name.ext where -usually- ext = !iueprint.type)
;              containing plot commands,
;            - QUIC command TEKOFF.LIS to get printer out of plot mode.
;
;*EXAMPLES:
;
;       To produce laser printer plot of H,W,F,E vectors (and store
;       plot file in IUEIDL.TEK):
;               PLOTOPEN,D
;               IUEPLOT,H,W,F,E
;               PLOTPRINT,D
;
;       To make hardcopy of existing plot file in (vms) main directory:
;               PLOTPRINT,'','[USER1]IUEIDL.TEK'
;
;*SUBROUTINES CALLED:
;
;       PARCHECK
;       DECOMPOSE
;       PLATFORM
;
;*FILES USED:
;
;       in !iuer.dat
;       TEKON.LIS  - sends commands to QMS 800 laser printer to place it
;                    in the graphics mode emulating a Tek 4010
;       TEKOFF.LIS - sends commands to QMS 800 laser printer to exit from
;                    graphics mode and return to normal printer mode
;       TEKON.LIS and TEKOFF.LIS are hardware dependent
;
;*NOTES:
;
;       TEKON.LIS and TEKOFF.LIS are hardware dependent
;
;       tested with IDL Version 2.1.0  (sunos sparc)     23 Jul 91
;       tested with IDL Version 2.1.0  (ultrix mipsel)   N/A
;       tested with IDL Version 2.1.0  (vms vax)         23 Jul 91
;
;*MODIFICATION HISTORY:
;
;       written by D. Lindler   Dec. 1986
;       C. Grady     Oct. 1987 generalized for IUE RDAF use
;       M. Horn      Nov. 1987 update QMS commands to be
;                    compatible with the laser printers on IUE::
;       6-28-88 RWT update prolog and compress code
;       6-30-88 RWT calls printplot.com and submits all 3 files in one
;                   print command
;       11-4-88 RAE adds sysvars parameter to pass system variable values
;       3-13-91 PJL modified for unix/sun - many changes
;       4-12-91 PJL paths for tekon.lis and tekoff.lis
;       5-10-91 PJL corrected two typos in the prolog
;       6-10-91 PJL modified for various printers; updated prolog;
;                   tested on SUN and VAX with QMS/TEK and PS printers
;       7-11-91 GRA changed path to use getenv('IUER_DAT'), added
;                   version number ;0 to VMS branch to get most
;                   recent file for plotting. Tested on SUN, ULTRIX
;                   (PS branch), and VMS (PS and Tek branches).
;       7-23-91 RWT change "ctdir + name" to "name" in defining cmd,
;                   and define variable delim
;       1-15-92 PJL updated documentation
;       1-16-92 GRA updated documentation
;     11 Feb 92 LLT add call to IUE_PARSE, allow extension to be entered
;                   (to allow .PLT files created in version 1 to be printed),
;                   allow plot files in other directories to be printed, allow
;                   version number to be specified (wild card will work too).
;     12 Feb 92 PJL added path defaults to other branches of the 'if'
;                   statements;  added ' ' check for dname
;     12 Feb 92 RWT replace IUE_PARSE with DECOMPOSE, allow plotting of
;                   files in other directories without including disk name,
;                   and expand prolog.
;      9 Sep 93 RWT remove plotclose and parameter UNIT (not needed).
;     15 Jun 94  PJL  replaced !version with PLATFORM
;      2 Sep 94 LLT IUER_DAT ---> !iuer.dat
;-
;******************************************************************************
 pro plotprint,dname,name
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'PLOTPRINT,DNAME,name'
    retall
 endif  ; npar
 parcheck,npar,[1,2],'PLOTPRINT'
;
; get printer system variables
;
 type = !iueprint.type
 cmd = !iueprint.com
;
 device,/close_file
 if (dname ne '' and dname ne ' ') then set_plot,dname
 if (npar lt 2)  then begin
    name = 'iueidl.' + type
    d = ''
    p = ''
 endif else $
    if strpos(name,'.') lt 0 then begin
       name = name + '.' + type
       d = ''
       p = ''
    endif else begin
       decompose,name,d,p,fn,e,v
       e=strlowcase(strmid(e,1,strlen(e)-1))
       if e eq 'plt' then ext='tek' else ext=e
       if (ext ne strlowcase(type)) then begin
          print,'The file extension of the given plot file (',e,') does not'
          print,'match your laser printer type (',type,").   It's probably"
          print,"a bad idea to proceed, so we're going to quit."
          retall
       endif  ; ext
    endelse  ; name
;
; submit name.ext (where ext = !iueprint.type) to laser printer
;
 if strpos(name,'.') lt 0 then name = name + type
;;; delim = ' '
 platform,dummy,syntax=syntax
 delim = syntax.pdelim
 if (strlowcase(type) eq 'tek') then begin
    tekon = !iuer.dat + 'tekon.lis'
    tekoff = !iuer.dat + 'tekoff.lis'
;;;    if (!version.os eq 'vms') then begin
    if (delim ne ' ') then begin
       if (d eq '') then begin
          cd,CURRENT=ctdir
          decompose,ctdir,d,acc,fn,e,v
          if (p ne '') then name = d + name else name = ctdir + name
;;;       endif ; sys eq 'vms'
       endif ; delim ne ' '
;;;       delim = ' + '
    endif ; if vms
    cmd = cmd + ' ' + tekon + delim + name + delim + tekoff
 endif else cmd = cmd + ' ' + name
 spawn,cmd
;
 return
 end  ; plotprint
