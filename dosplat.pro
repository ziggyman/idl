;******************************************************************************
;+
;*NAME:
;
;       DOSPLAT
;
;*CLASS:
;
;       system dependancies - DOS
;
;*CATEGORY:
;
;*PURPOSE:
;
;       Set system dependant items such as system commands that will be
;       spawned, internal data formats, etc.
;       DOS/WINDOWS types - { windows 3.1 3.6.1b }
;
;*CALLING SEQUENCE:
;
;       DOSPLAT,NCOPY,ICOPY,COPYMES,NDELETE,IDELETE,PDELETE,NPURGE,RENAME,  $
;          PAGE,CAT,SUBMIT,AWK,KEYST,PRINTCMD,DIRLIS,FIND,SECURITY,   $
;          QUOTA,SYNTAX,FONT,SYSLOGIN,TRMLDEV,NULLDEV,TAPECTRL,TAPECOPY,TMPLOC
;
;*PARAMETERS:
;
;       NCOPY   (REQ) (O) (0) (S)
;               The copy command without conformation (non-interactive).
;
;       ICOPY   (REQ) (O) (0) (S)
;               The copy command with conformation (interactive).
;
;       COPYMES (REQ) (O) (0) (S)
;               Message related to copy command.
;                  copymes.present - present tense of the word.
;                  copymes.past - past tense of the word.
;
;       NDELETE (REQ) (O) (0) (S)
;               The delete command without conformation (non-interactive).
;
;       IDELETE (REQ) (O) (0) (S)
;               The delete command with conformation (interactive).
;
;       PDELETE (REQ) (O) (0) (S)
;               Print file and then delete file.
;
;       NPURGE  (REQ) (O) (0) (S)
;               The purge command without conformation (non-interactive).
;
;       RENAME  (REQ) (O) (0) (S)
;               To give a file a different name (rename or move).
;
;       PAGE    (REQ) (O) (0) (S)
;               The page command for displaying a file.
;
;       CAT     (REQ) (O) (0) (S)
;               The cat or type command.
;
;       SUBMIT  (REQ) (O) (0) (S)
;               The command to submit a batch job.
;                  submit.cmd - the submit command
;                  submit.notify - the notify option
;                  submit.noprint - the noprint option
;
;       AWK     (REQ) (O) (0) (S)
;               The awk command information.
;                  awk.cmd - the command
;                  awk.file - the file of awk commands
;
;       KEYST   (REQ) (O) (0) (B)
;               The keystroke value for carriage return.
;
;       PRINTCMD (REQ) (O) (0) (S)
;               The default print command.
;
;       DIRLIS  (REQ) (O) (0) (S)
;               Directory listing.
;                  dirlis.cmd - the basic directoty listing command.
;                  dirlis.sec - the option to see security settings
;                  dirlis.col - listing in one column
;                  dirlis.output - output file
;                  dirlis.nohead - only filenames (no extra "stuff" printed)
;                  dirlis.since - limit output to ust files changed in past
;                                 24 hours
;
;       FIND    (REQ) (O) (0) (S)
;               The find command.
;                   find.cmd - the command
;                   find.ctime - how many days since file changed
;                   find.prune - prune search tree
;                   find.type - type of file
;                   find.name - filename to be searched for
;                   find.print - output filenames found
;
;       SECURITY (REQ) (O) (0) (S)
;               Reset secuity permissions on a file.
;                  security.set - decline other users from readi write, or
;                                 execute privilege.
;                  ecurity.unset - allow everyone read permission and group
;                                     execute privilege.
;
;       QUOTA   (REQ) (O) (0) (S)
;               Show disk quota command.
;
;       SYNTAX  (REQ) (O) (0) (S)
;               Structure of different syntax notations.
;                  syntax.redirect - redirect output to a file
;                  syntax.addon - attached information to end
;                  syntax.pipe - pipe output to another command
;                  syntax.background - put process in background
;                  syntax.execute - execute character
;                  syntax.allver - all versions (when versions available)
;                  syntax.disksep - separates disk name from path
;                  syntax.startpath - separates the disk from the start of the
;                                     path
;                  syntax.midpath - separates the directory and subdirectory
;                  syntax.endpath - separates end of path from filename
;                  syntax.versep - separates filename from version number
;                  syntax.extsep - separates filename extension from the rest
;                                  of the file name
;                  syntax.listsep - separate names in a list of filenames
;                  syntax.pdelim - separate list of files to print command
;                  syntax.pathlist - separate directory names in !path
;
;       FONT    (REQ) (O) (0) (S)
;               The fixed width font available.
;
;       SYSLOGIN  (REQ) (O) (0) (S)
;               The system login logical.
;
;       TRMLDEV (REQ) (O) (0) (S)
;               Terminal device name.
;
;       NULLDEV (REQ) (O) (0) (S)
;               The null device (garbage maybe piped to it).
;
;       TAPECTRL (REQ) (O) (0) (S)
;               Magnetic tape control for skipping files - Unix and Ultrix
;               systems.  tape.device = '' is assumed to be a VMS or VMS-like
;               system.  No suppost for DOS PCs.
;                  tapectrl.device - the device directory.
;                  tapectrl.mt - the tape control command.
;                  tapectrl.back - back up on the tape.
;                  tapectrl.forward - go forward on the tape.
;                  tapectrl.bandf - back and then forward one.
;                  tapectrl.fspace - forward space on a tape.
;                  tapectrl.bspace - back space on a tape.
;                  tapectrl.status - print status information about the tape
;                                    unit.
;                  tapectrl.rewind - rewind the tape.
;                  tapectrl.weof - write EOF marker
;                  tapectrl.eom - goto end of recorded media
;                  tapectrl.eom - goto end of recorded media
;
;       TAPECOPY (REQ) (O) (0) (S)
;               Tape copy commands.
;                  tapecopy.cmd - command.
;                  tapecopy.infile - input file marker.
;                  tapecopy.outfile - output file marker.
;                  tapecopy.ibs - input block size marker.
;                  tapecopy.obs - output size marker.
;                  tapecopy.num - number of files to copy before ending marker.
;                  tapecopy.qic - block size for QIC tapes (must be 512).
;                  tapecopy.nonqic - block size for non-QIC tapes.
;                  tapecopy.conv - conversion to take place
;                  tapecopy.sync - with tapecopy.conv, pad every input record
;                                  to ibs
;
;       TMPLOC (REQ) (O) (0) (S)
;                  string describing the path for storing temporary scratch
;                  files (set to '\tmp' for windows)
;
;*EXAMPLES:
;
;*SYSTEM VARIABLES USED:
;
;       !version.os
;
;*INTERACTIVE INPUT:
;
;       none
;
;*SUBROUTINES CALLED:
;
;       PARCHECK
;
;*FILES USED:
;
;       none
;
;*SIDE EFFECTS:
;
;*RESTRICTIONS:
;
;       If !version.os is not 'windows', the procedure retalls.
;
;*NOTES:
;
;       Please see the file platform.txt in the iuerdaf/manual subdirectory
;       for information on how to customizing this procedure.
;
;       Additional systems may be added by contacting IUEDAC staff.  However,
;       please note that they will be UNsupported.  Please include the
;       information requested in the platform.txt file.
;
;*PROCEDURE:
;
;       Keywords are set based on !version.os.  If !version.os is not
;       'windows', the procedure retalls.
;
;*I_HELP  nn:
;
;*MODIFICATION HISTORY:
;
;       22 Sep 94  PJL  wrote based on VMSPLAT - not all commands set up yet
;       20 Oct 94  PJL  finished what commands I could determine;  added
;                       syntax.midpath
;       28 Nov 94  PJL  added font
;       20 Mar 95  RWT  add tmploc parameter
;-
;******************************************************************************
 pro dosplat,ncopy,icopy,copymes,ndelete,idelete,pdelete,npurge,rename,page, $
        cat,submit,awk,keyst,printcmd,dirlis,find,security,quota,syntax,  $
        font,syslogin,trmldev,nulldev,tapectrl,tapecopy,tmploc
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'DOSPLAT,NCOPY,ICOPY,COPYMES,NDELETE,IDELETE,PDELETE,NPURGE,' +    $
       'RENAME,  $'
    print,'   PAGE,CAT,SUBMIT,AWK,KEYST,PRINTCMD,DIRLIS,FIND,SECURITY,   $'
    print,'   QUOTA,SYNTAX,FONT,SYSLOGIN,TRMLDEV,NULLDEV,TAPECTRL,TAPECOPY, $'
    print,'   TMPLOC'
    retall
 endif  ; npar eq 0
 parcheck,npar,24,'DOSPLAT'
;
;  commands determined by the operating system - see the prolog for information
;
 case strlowcase(!version.os) of
    'windows':
    else:  begin
              print,"!version.os should equal 'windows'.  It does not."
              print,'ACTION:  retall'
              retall
           end  ; else
 endcase  ; strlowcase(!version.os)
;
;  the following should be correct for all DOS systems
;
 ncopy = 'copy '
 icopy = 'NA'
 copymes = {copymes,present:' overwrite ',past:' overwritten '}
 ndelete = 'del '
 idelete = 'NA'
 pdelete = 'NA'
 npurge = 'NA'
 rename = 'ren '
 page = 'more < '
 cat = 'type '
 submit = {submit,cmd:'NA',notify:'',noprint:'',delete:''}
 awk = {awk,cmd:'NA',file:''}
 keyst = 13B
 printcmd = 'print '
 dirlis = {dirlis,cmd:'dir',sec:'',col:'',output:'',nohead:'',since:''}
 find = {find,cmd:'NA',ctime:'',prune:'',type:'',name:'',print:''}
 security = {security,set:'NA',unset:'NA'}
 quota = 'NA'
 syntax = {syntax,redirect:'',addon:'',pipe:'',background:'',execute:'',   $
           allver:'',disksep:':',startpath:'\',midpath:'\',endpath:'\',   $
           versep:'',extsep:'.',listsep:' ',pdelim:' ',pathlist:';'}
 font = 'COURIER*BOLD*PROOF*FIXED*10'
 syslogin = ''
;;; trmldev = 'tt:/fort'
 trmldev = 'sys$output'
 nulldev = ''
;
;  mkskip not needed for DOS system
;
 tapectrl = {tapectrl,device:'NA',mt:'NA',back:'',forward:'',bandf:'',   $
             fspace:'',bspace:'',status:'',eom:'',rewind:'',weof:''}
 tapecopy = {tapecopy,cmd:'NA',infile:'',outfile:'',ibs:'',obs:'',num:'',   $
             qic:'',nonqic:'',conv:'',sync:''}
 tmploc = '\tmp'
;
 return
 end  ; dosplat
