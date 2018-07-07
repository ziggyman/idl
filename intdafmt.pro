;******************************************************************************
;+
;*NAME:
;
;       INTDAFMT
;
;*CLASS:
;
;       system dependancies - internal data format
;
;*CATEGORY:
;
;*PURPOSE:
;
;       Determine the system's internal data format.
;
;*CALLING SEQUENCE:
;
;       INTDAFMT,TYPE,RMS
;
;*PARAMETERS:
;
;       TYPE    (REQ) (O) (0) (S)
;               The internal data format.  Types are:
;                  'ieeebig' - IEEE big-endian format (SunOS/sparc, FITS)
;                  'ieeelittle' - IEEE little-endian format (Ultrix/mipsel,
;                                 DOS/386, VMS/mipsel)
;                  'vaxformat' - byte, signed word and longword integers,
;                                f-floating, d-floating (Ultrix/VAX, VMS/VAX)
;               The variable must be sent to ' ' before set to PLATFORM for
;               this parameter to be returned.
;
;       RMS     (REQ) (O) (0) (I)
;               Record Management Services.  For use with some (CON_RDAF and
;               CONVERT) of the internal data format conversion procedures.
;               Set to 1 when the system is VMS or Ultrix and the architecture
;               is VAX or Mipsel.  For all other cases, set to 0.  Used to
;               consider Ultrix/VAX to VMS/VAX and Ultrix/Mipsel and VMS/Mipsel
;               "translations".
;
;*EXAMPLES:
;
;*SYSTEM VARIABLES USED:
;
;       !version.os
;       !version.arch
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
;       If !version.arch is not one of the given values, the procedure tries
;       to determine the internal data format.
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
;       If the !version.arch is not one of the know values, then a test is used
;       to determine which format it is.  If it is not IEEE big-endian, IEEE
;       little-endian, or VAX formats, then the procedure retalls.  If the
;       system is VMS or Ultrix with an architectue of VAX or Mipsel, then
;       the RMS (Record Management Services) keyword is set to 1.  For all
;       other cases, it equals 0.
;
;*I_HELP  nn:
;
;*MODIFICATION HISTORY:
;
;       22 Sep 94  PJL  broke off from PLATFORM; added MacOS (powermac) and
;                       windows (3.1)
;        6 Feb 95  PJL  correct mispel to mipsel
;
;-
;******************************************************************************
 pro intdafmt,type,rms
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'INTDAFMT,TYPE,RMS'
    retall
 endif  ; npar eq 0
 parcheck,npar,1,'INTDAFMT'
;
 sysos = strlowcase(!version.os)
;
 rms = 0
 case (strlowcase(!version.arch)) of
    'vax':  begin
               type = 'vaxformat'
               if ( (sysos eq 'vms') or (sysos eq 'ultrix') ) then rms = 1
            end  ; strlowcase(!version.arch)) eq 'vms'
    'alpha':  begin
                 rms = 1     ;  not 100% sure about this - needs
                             ;  tested under both systems
                 if (sysos eq 'vms') then type = 'vaxformat' else  $
                    type = 'ieeelittle'     ;  OpenVMS or OSF
              end  ; strlowcase(!version.arch)) eq 'alpha'
    'sparc': type = 'ieeebig'
    'c2': type = 'ieeebig'            ; convex same as unix
    'mipsel':  begin
                  type = 'ieeelittle'
                  if ( (sysos eq 'vms') or (sysos eq 'ultrix') ) then rms = 1
               end  ; strlowcase(!version.arch)) eq 'mispel'
    'dos': type = 'ieeelittle'
    '386': type = 'ieeelittle'
    '3.1': type = 'ieeelittle'  ; same as ultrix, dos, and 386
    'powermac': type = 'ieeebig'  ; same as sunos
;
;  if none of the above - try to determine which one
;
    else:  begin
              type = ''
              temp = byte(34.34,0,4)
              temp2 = where(temp eq [66,9,92,41],ct)  ; ieeebig
              if (ct eq 4) then type = 'ieeebig'
              temp2 = where(temp eq [41,92,9,66],ct)  ; ieeelittle
              if (ct eq 4) then type = 'ieeelittle'
              temp2 = where(temp eq [9,67,41,92],ct)  ; vaxformat
              if (ct eq 4) then type = 'vaxformat'
              if (type eq '') then begin
                 print,'System ' + !version.arch + ' has an unknown ' +   $
                    'internal data format.'
                 print,'ACTION:  retall'
                 retall
              endif else begin
;
;  check that the integer format matches the expected value
;
                 ok = 0              ; will be set to 1 if matches
                 temp = byte(34,0,2)
                 case (type) of
                    'ieeebig':  begin
                                   temp2 = where(temp eq [0,34],ct)
                                   if (ct eq 2) then ok = 1
                                end  ; type eq 'ieeebig'
                    'ieeelittle':  begin
                                      temp2 = where(temp eq [34,0],ct)
                                      if (ct eq 2) then ok = 1
                                   end  ; type eq 'ieeelittle'
                    'vaxformat':  begin
                                     temp2 = where(temp eq [34,0],ct)
                                     if (ct eq 2) then ok = 1
                                  end  ; type eq 'vaxformat'
                 endcase  ; type
                 if (not(ok)) then begin
                    print,'Integer byte value not equal to expected value.'
                    print,'System ' + !version.arch + ' has an unknown ' + $
                       'internal data format.'
                    print,'ACTION:  retall'
                    retall
                 endif  ; not(ok)
              endelse  ; type eq ''
           end  ; else
 endcase  ; strlowcase(!version.os)
;
 return
 end  ; intdafmt
