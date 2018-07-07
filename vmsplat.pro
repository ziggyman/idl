;******************************************************************************
;+
;*NAME:
;
;       VMSPLAT
;
;*CLASS:
;
;       system dependancies - VMS
;
;*CATEGORY:
;
;*PURPOSE:
;
;       Set system dependant items such as system commands that will be
;       spawned, internal data formats, etc.
;       VMS types - { vax vms 3.5.1}, { alpha vms 3.5.1}
;
;*CALLING SEQUENCE:
;
;       VMSPLAT,NCOPY,ICOPY,COPYMES,NDELETE,IDELETE,PDELETE,NPURGE,RENAME,  $
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
;               Not applicable for VMS systems.
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
;               Not applicable for VMS systems.
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
;               systems.  tape.device = '' is assumed to be a VMS or VMS like
;               system.
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
;                  string describing path for storing temporary scratch files
;                  (set to sys$login on vms systems).
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
;       If !version.os is not 'vms', the procedure retalls.
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
;       Keywords are set based on !version.os.  If !version.os is not 'vms',
;       the procedure retalls.
;
;*I_HELP  nn:
;
;*MODIFICATION HISTORY:
;
;       22 Sep 94  PJL  broke out from PLATFORM
;       11 Oct 94  PJL  changed awk and find from '' to 'NA'
;       20 Oct 94  PJL  added syntax.midpath
;       28 Nov 94  PJL  added font
;       20 Mar 95  RWT  add tmploc parameter
;-
;******************************************************************************
 pro vmsplat,ncopy,icopy,copymes,ndelete,idelete,pdelete,npurge,rename,page, $
        cat,submit,awk,keyst,printcmd,dirlis,find,security,quota,syntax,font, $
        syslogin,trmldev,nulldev,tapectrl,tapecopy,tmploc
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'VMSPLAT,NCOPY,ICOPY,COPYMES,NDELETE,IDELETE,PDELETE,NPURGE,' +   $
       'RENAME,  $'
    print,'   PAGE,CAT,SUBMIT,AWK,KEYST,PRINTCMD,DIRLIS,FIND,SECURITY,   $'
    print,'   QUOTA,SYNTAX,FONT,SYSLOGIN,TRMLDEV,NULLDEV,TAPECTRL,TAPECOPY, $'
    print,'   TMPLOC
    retall
 endif  ; npar eq 0
 parcheck,npar,24,'VMSPLAT'
;
;  commands determined by the operating system - see the prolog for information
;
 if ((strlowcase(!version.os)) ne 'vms') then begin
    print,"!version.os should equal 'vms'.  It does not."
    print,'ACTION:  retall'
    retall
 endif  ; (strlowcase(!version.os)) ne 'vms'
;
;  the following should be correct for all VMS systems
;
 ncopy = 'copy/noconfirm '
 icopy = 'copy/confirm '
 copymes = {copymes,present:' supersede ',past:' superseded '}
 ndelete = 'delete/noconfirm '
 idelete = 'delete/confirm '
 pdelete = 'print/delete '
 npurge = 'purge '
 rename = 'rename '
 page = 'type/page '
 cat = 'type '
 submit = {submit,cmd:'submit',notify:'/notify',noprint:'/noprint',   $
           delete:'/delete'}
 awk = {awk,cmd:'NA',file:''}
 keyst = 13B
 printcmd = 'print '
 dirlis = {dirlis,cmd:'directory',sec:'/security ',col:'/column:1',   $
           output:'/output=',nohead:'/nohead',since:'/since'}
 find = {find,cmd:'NA',ctime:'',prune:'',type:'',name:'',print:''}
 security = {security,set:'set protection=(G,W) ',   $
             unset:'set protection=(S:RWED,O:RWED,G:RE,W:R) '}
 quota = 'show quota'
 syntax = {syntax,redirect:'',addon:'',pipe:'',background:'',execute:'@',   $
           allver:';*',disksep:':',startpath:'[',midpath:'.',endpath:']',   $
           versep:';',extsep:'.',listsep:',',pdelim:' + ',pathlist:','}
 font = '-ADOBE-Courier-Medium-R-Normal-*-140-75-75-M-90-ISO8859-1'
 syslogin = 'sys$login'
;;; trmldev = 'tt:/fort'
 trmldev = 'sys$output'
 nulldev = ''
;
;  mkskip not needed for VMS/VAX system
;
 tapectrl = {tapectrl,device:'',mt:'',back:'',forward:'',bandf:'',fspace:'',  $
             bspace:'',status:'',eom:'',rewind:'',weof:''}
 tapecopy = {tapecopy,cmd:'',infile:'',outfile:'',ibs:'',obs:'',num:'',   $
             qic:'',nonqic:'',conv:'',sync:''}
 tmploc = 'SYS$LOGIN:'
;
 return
 end  ; vmsplat
