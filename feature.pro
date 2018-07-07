<head><title>IDL Help</title></head>
<body bgcolor="#ffffff" link="#ee0000" vlink="#992200" text="#00000">
Viewing contents of file '/net/www/deutsch/idl/idllib/iuedac/iuelib/pro/feature.pro'<BR>
<PRE>
;*****************************************************************
;+
;*NAME:
;
;     FEATURE     (General IDL Library 01) 9 JANUARY 1981
; 
;*CLASS: 
;
;     spectral lines, measurement
;
;*CATEGORY:
;
;*PURPOSE:  
;
;    To measure the essential attributes of a spectral feature
; 
;*CALLING SEQUENCE:
;
;    FEATURE,WAVE,FLUX,W0,comment,noprint=nop
; 
;*PARAMETERS:
;
;    WAVE   (REQ) (I) (1) (I L F D)
;           Required input vector containing the wavelength array associated
;           with the spectrum.
;
;    FLUX   (REQ) (I) (1) (F D)
;           Required input vector containing the flux data for the spectrum.
;
;    W0     (REQ) (I/O) (0 1) (F D)
;           Upon input, this parameter is a required scalar containing the
;           laboratory wavelength of the feature.
;           The procedure converts this parameter to a vector containing 
;           the results of the measurement.
;           If W0 is a variable the results are returned in an array
;           of the same name.
;                  W0(0)= the original value for W0. 
;                  W0(1)= short wavelength limit to integration
;                  W0(2)= extremum of spectral line
;                  W0(3)= long wavelength limit to integration
;                  W0(4)= radial velocity for short wavelength limit
;                         to integration.
;                  W0(5)= radial velocity for extremum of spectral line
;                  W0(6)= radial velocity for the long wavelength limit
;                         to integration.
;                  W0(7)= flux at the short wavelength limit to the
;                         integration.
;                  W0(8)= flux at the spectral line extremum
;                  W0(9)= flux at the long wavelength limit to the 
;                         integration.
;                  W0(10)=continuum flux
;                  W0(11)=residual flux at extremum
;                  W0(12)=equivalent width
;                  W0(13)=total flux in the feature. 
;                  W0(14)=flux weighted wavelength for feature.
;                  W0(15)=flux weighted sigma, which for a 
;                         gaussian profile can be related to the full
;                         width at half maximum.
;                  W0(16)=net flux in feature
;                  W0(17)=flux weighted wavelength, with continuum
;                         not included
;                  W0(18)=flux weighted sigma for net flux only.
;
;    COMMENT (OPT) (I)
;           Title for output.
;
;    NOPRINT (KEY)
;           If set, FEATURE will not offer you the option of sending your
;           output to the laser printer.
;
;*EXAMPLES:
;
;     In this example, several carbon features of a high-dispersion 
;     spectrum, SWP 3353, are acquired and measured:
;         
;                openr,un1,'swp3353h',/get_lun
;                iueget,un1,89,h,wave,flux,eps  ; CIV 1550
;                feature,wave,flux,1548.20
;                feature,wave,flux,1550.77
;                close,un1
;
;     In this example, the user elects not to be offered the option to send
;     the final plot to the laser printer:
;
;                feature,w,f,1548.20,/noprint
;
;*SYSTEM VARIABLES USED:
;
;	!d.name
;	!x.range
;	!x.crange
;	!y.crange
;	!d.x_ch_size
;	!d.y_ch_size
;	!d.y_vsize
;	!err
;	!iueprint.type
;
;*INTERACTIVE INPUTS:
;
;        Upon prompting, the user sets the crosshairs
;        and hits the left mouse button (sunview) or
;        carriage-return key (tek) three times,
;        thereby measuring:
;         
;        Vertical crosshair at:      Horizontal crosshair at:
;        ______________________      ________________________
;        1) left edge of 
;            feature (W1)           continuum (F1)
;         
;        2) center of
;           feature (W2)            extremum(F2) of feature
;         
;        3) right edge of
;          feature (W2)             continuum (F3)
; 
;        These three positions may be entered in any order.
; 
;*SUBROUTINES CALLED:
;
;    TABINV
;    PCHECK
;    PARCHECK
;    FMEAS
;    FEATURE_OUT
;    XYREADS
;    YESNO
;    PLOTOPEN
;    PLOTPRINT
;
;*FILES USED:
;
;*SIDE EFFECTS:
;
;    IF W0 is a variable, the dimension and values will be changed
;    by the procedure.
;
;    The file idl.ps may be created.  It is a postcript print file
;    and will automatically be output using the command "lpr idl.ps".
;
;*RESTRICTIONS:
;
;    Device Dependent - The terminal must be equipped with a graphics 
;                       cursor.
;                       This procedure is not suitable for batch submission.
;
;                     - This procedure was modified to support
;                       remote terminals using tektronix 4014 emulation 
;                       or sunview graphics devices
;*NOTES:
;
;        The user may change the plot scaling using the system
;        variable !x.range(1).  If this variable is
;        is defaulted to zero then FEATURE will plot 50 points
;        on each side of the laboratory wavelength.  If more or
;        fewer points are desired the user should set !x.range
;        to the desired min. and max. wavelengths.
;
;        Program assumes IDL is to read 6 characters when accepting
;        GIN (graphics input) report in TEKTRONIX mode.
;
;        The Display: wavelengths (W), radial velocities (RV),
;           and fluxes (F) at the three points indicated by
;           user; continuum flux (FCONT); residual intensity 
;           at the extremum (RESI2); equivalent width of the
;           feature in milli-Angstroms (EW-MA) or in Angstroms
;           (EW-A);
;           The moments of the total flux distribution
;           (including underlying continuum).
;                FTOT = Total Flux
;                WTOT = Flux weighted wavelength
;                WIDTOT= Flux weighted sigma (width)
;           The same values are printed for the flux minus continuum.
;           (FNET, WNET and WIDNET.)
;             Note: for a Gaussian line profile, FWHM = 2.354 * WIDNET
;           If FLUX is in absolute units (erg/sec/A) then FCONT
;           has units (erg/sec).
;        2) Plot of feature with area of feature filled in by
;           vertical lines.
;
;	 tested with IDL Version 2.1.0 (sunos sparc)	10 Jul 91
;        tested with IDL Version 2.1.0 (ultrix mipsel)	N/A
;        tested with IDL Version 2.1.0 (vms vax)	10 Jul 91
;
;*PROCEDURE:
;
;        Let (W1,F1), (W2,F2), and (W3,F3) be the user measured
;        points:  The following computations are performed:
; 
;          RVn = (Wn-W0)*2.99792E5/W0
;          Continuum = (WAVE-W1)*(F3-F1)/(W3-W1)+F1
;          FCONT = integral(Continuum)/(W3-W1)
;          RESI2 = F2/FCONT
;          FTOT = integral(FLUX)
;          WTOT = integral(FLUX*WAVE)/integral(FLUX)
;          WIDTOT = SQRT(integral(FLUX*WAVE*WAVE)/integral(FLUX))
;          FNET, WNET and WIDNET are computed replacing FLUX with
;                FLUX-Continuum.
;          Equivalent width = integral(1.-FLUX/continuum)
; 
;        All integrals are done with respect to wavelength form W1 to
;        W2 using the trapezoidal rule.
; 
;*MODIFICATION HISTORY:
;
;     Feb 12 1981  SRH  GSFC  initial program
;     Apr 22 1981  SRH  GSFC  re. change request No. 4 to support
;                             Tektronix 4025 terminals
;     Apr 30 1981  SRH  GSFC  uses TEKPLOT for drawing characters on 
;                             the graph.
;     Jul 13 1981  DL   GSFC  per requests #65, 66, 21, 69
;                             allow user to specify !XMIN, !XMAX,
;                             !YMIN, !YMAX
;                             Do not cut fluxes off at 0.0
;                             Compute a flux weighted wavelength.
;                             Input points reordered if entered out of 
;                             order.
;     Oct  3  1981 FHS3 GSFC  Computer EW correctly, compute flux 
;                             weighted widths and return results array
;                             CR#015.
;     Jul  1  1985 CAG  GSFC  Force WIDNET to be greater than or equal 
;                             to zero (URP's 146, 179 & 217).
;     Oct 21  1985 RWT  GSFC  modify for DIDL (i.e., use NELEMENTS, new 
;                             INDGEN, replace @'s with #'s, and remove REORDER)
;     Aug 29  1986 CAG  GSFC  modified overplot to use !PSYM=0 (URP #158)
;     Oct  6  1986 RWT  GSFC  replace TEKDATA with CURSOR, and @ with #
;     Feb 11  1987 RWT  GSFC  VAX mods: use PLOTS for TKPLOT, XYOUTS & 
;                             SCTODC for XYOUT, replace INSERT and EXTRACT 
;                             with assignment statements,
;                             replace sub. FSORT with IDL SORT
;     Apr 13  1987 RWT  GSFC  add PARCHECK and PLTPARM
;     Feb 29  1988 RWT  GSFC  make FMEAS a separate procedure
;     Mar  9  1988 CAG  GSFC  add VAX RDAF-style prolog
;     aug. 28, 1989 jtb @gsfc extensive modifications for unix/sun idl
;     Feb 26, 1991 PJL  GSFC  added an optional parameter - comment - for
;			      plot title
;     Apr 09, 1991 GRA  CASA  added section to prompt for the name of a
;                             vms postscript print queue.
;     Jun 17, 1991 PJL  GSFC  changed hardcopy section to use new versions
;			      of PLOTOPEN and PLOTPRINT; tested on VAX and
;			      UNIX; updated prolog
;     Jun 21, 1991 PJL  GSFC  cleaned up; tested on SUN and VAX; 
;			      updated prolog
;     Jun 28, 1991 PJL  GSFC  added check for existence of printer; tested on 
;			      SUN and VAX; updated prolog
;     Jul 08, 1991 GRA  CASA  added 'feature' as name parameter to calls
;                             to PLOTOPEN and PLOTPRINT. Removed branch
;                             based on !d.name eq 'PS' in output
;                             section.
;     Jul 10, 1991 PJL  GSFC  corrected a comment and a prompt; tested on 
;			      SUN and VAX; updated prolog
;     Nov 11, 1991 PJL  GSFC  added /down to tek branch cursor call and wait
;			      to non-tek branch
;     Nov 22, 1991 GRA  CASA  removed reference to IUER_USERDATA from prolog.
;     Dec 11, 1991 PJL  GSFC  modified example in prolog
;     Feb 12, 1993 LLT  GSFC  Added keyword to suppress option to send plots to
;                             laser printer, added warning when fluxes in the
;                             selected range change sign, mark chosen points
;                             on printouts (and use the "x" symbol always),
;                             and add time-tag to printouts.
;     Sep 30, 1993 RWT  GSFC  modify for new plotopen and plotprint routines
;     Jun 27, 1994 RWT  GSFC  add "device,gin_chars=6", flush, 
;                             "device,/tek4010" commands in TEK mode
;-
;**************************************************************************
 pro feature,wave,flux,w0,comment,noprint=nop
;
 npar = n_params(0)
 if npar eq 0 then begin
    print,' FEATURE,WAVE,FLUX,W0,comment,noprint=nop'
    retall
 endif  ; npar
 parcheck,npar,[3,4],'FEATURE'
 pcheck,wave,1,010,0011      ;check input parameters
 pcheck,flux,2,010,0111
 pcheck,w0,3,110,0011
 w0 = float(w0)              ;make w0 a real number
;
 s=size(w0)
 if s(0) gt 0 then w0=w0 ;convert to scalar
;
; plot the points about the feature using xmin and xmax
; if !x.range(1) equals 0 then plot 50 points on each side
;
 if !x.range(1) eq 0 then begin
    tabinv,wave,w0,iw0
    i1=(iw0-50)>0
    i2=(iw0+50)&#60;(n_elements(wave)-1)
    i=indgen(i2-i1+1)+i1
 endif else  i=where((wave ge !x.range(0)) and (wave le !x.range(1)))
;
 wavef = wave(i)
 fluxf = flux(i)
 plot,wavef,fluxf, $
    ytitle='Flux',xmargin=[32,6],ymargin=[4,4]
;
 cr = string("15b)
 w = fltarr(4) & f = w
;
;  ***  sunview style plot device  ***
;
 if (strlowcase(!d.name) ne 'tek') then begin	;tek or not tek
;
;  output measuring instructions
;
    print,'*****************************************'
    print,' '
    print,' Move the cursor into the graphics window.'
    print,' The position of the cursor in data coordinates'
    print,' will be constantly displayed in the text window.'
    print,' '
    print,'  1. Place the X-HAIRS at the left continuum,'
    print,'     extremum, and right continuum points in any'
    print,'     sequence.  At each point press the LEFT'
    print,'     mouse button to MARK its position.  After'
    print,'     three points have been selected, the feature'
    print,'     will be measured and the results displayed.' 
    print,' '
    print,'  2. To measure ANOTHER feature or to begin the'
    print,'     current measuring sequence AGAIN, press the'
    print,'     MIDDLE mouse button and repeat step 1.' 
    print,' '
    print,'  3. To EXIT the procedure, press the RIGHT button'
    print,' '
    print,'*****************************************'
;
;  set up while loop
;
    form = "($,' wavelength= ',f7.2,' flux= ',e10.3,a)"
    count = 0
    !err = 0
;
;  while loop for measurements
;
    while !err ne 4 do begin
    ;
       cursor,x,y,2,/data
       wait,0.1
    ;
       if ( x ge !x.crange(0) and x le !x.crange(1) and $
          y ge !y.crange(0) and y le !y.crange(1) ) then begin
          print,form=form,x,y,cr
         ;
          if (!err eq 1) then begin  ; mark cursor position
             !err = 0
             print,' ' & wait,0.1
             count = count + 1
             oplot,[x],[y],psym=7
             w(count) = x
             f(count) = y
             ;
             if (count ge 3) then begin  ; measure feature
                count = 0
                ord = sort(w)
                w = w(ord)
                f = f(ord)
                w(0) = w0
               ;
               ;  oplot continuum
               ;
                cont = (wavef-w(1)) * (f(3)-f(1)) / (w(3)-w(1)) + f(1)
                oplot,wavef,cont
               ;
               ;  fill in feature to be measured
               ;
                tabinv,wavef,w,datapt
                i1 = fix(datapt(1)) + 1
                i3 = fix(datapt(3))
                for i=i1,i3 do $
                   plots,[wavef(i),wavef(i)],[cont(i),fluxf(i)]
               ;
               ;  measure feature and output results
               ;
                fmeas,wavef,fluxf,cont,datapt,meas
                rv = (w-w0) * 2.997925e5 / w0
                fcon = meas(0) / (w(3) - w(1))
                resi2 = f(2) / fcon
               ;
                result=fltarr(19)
                result(0) = w
                result(4) = rv(1:3)
                result(7) = f(1:3)
                result(10)=fcon
                result(11) = meas
                result(11) = resi2
               ;
                if npar eq 3 then feature_out, result else   $
                   feature_out, result,comment
                line=where((wavef ge w(1)) and (wavef le w(3)))
               if (min(fluxf(line)) lt 0) and (max(fluxf(line)) gt 0) then begin
                  print,$
                  'Warning: Your feature contains positive and negative fluxes.'
                  print,'This will adversely affect FTOT, WTOT, and WIDTOT.'
               endif
              ;
             endif   ; count ge 3
             ;
          endif   ;!err eq 1
          ;
          if (!err eq 2) then begin  ; re-initialize and begin again
             !err = 0
             count = 0
             w(0) = 0
             plot,wavef,fluxf,xtitle='Wavelength',ytitle='Flux', $
                xmargin=[32,6],ymargin=[4,4]
          endif  ; !err eq 2
           ;
       endif   ; !x.crange etc.
    endwhile     ; !err ne 4
;
    print,' '
;
 endif else begin 	; tek or not tek
;
;
;  ***  tek style plot device  ***
;
;  output measuring instructions
;
    hpos = 10 * !d.x_ch_size 
    vpos = !d.y_vsize - !d.y_ch_size
    vspace = 1.1 * !d.y_ch_size
;
    xyouts,hpos,vpos,font=0,/device, $
       'Place the X-hairs at left cont, extremum, and right cont points.'
    vpos = vpos - vspace
    xyouts,hpos,vpos,font=0,/device, $
       'Hit the SPACEBAR to MARK the X-hair position (type 0 to ABORT).'
;
; read three cursor positions 
;
    device,gin_chars=6
;    device,/tek4014
    for i=1,3 do begin
       flush,0
       cursor,ww,ff,1,/data,/down
       ;
       if (!err eq 48b) then return        ;abort
       print,string(7b)                    ;ring bell
       w(i)=ww & f(i)=ff
       oplot,[ww],[ff],psym=7
    endfor  ; i
   ;
;
;  sort w,f
;
    ord = sort(w)   ;sort w and f (leave w(0) = w0)
    w = w(ord)
    f = f(ord)
    w(0) = w0
;
;  determine and oplot continuum
;
    cont=(wavef-w(1))*(f(3)-f(1))/(w(3)-w(1))+f(1)
    oplot,wavef,cont
;
; find data-points associated with w - datapt (flt), i1,i2,i3 (int)
;
    tabinv,wavef,w,datapt
    i1=fix(datapt(1))+ 1
    i3=fix(datapt(3))
;
; draw in feature with vertical lines between continuum and profile
;
    for i=i1,i3 do plots,[wavef(i),wavef(i)],[cont(i),fluxf(i)]
;
; measurements (call fmeas, etc.)
;
    line=where((wavef ge w(1)) and (wavef le w(3)))
    if (min(fluxf(line)) lt 0) and (max(fluxf(line)) gt 0) then begin
       xyouts,.05,.05,/norm,font=0,$
              'Warning: Your feature contains positive and negative fluxes.'
       xyouts,.05,.02,/norm,font=0,$
              'This will adversely affect FTOT, WTOT, and WIDTOT.'
    endif
    fmeas,wavef,fluxf,cont,datapt,meas
    rv=(w-w0)*2.997925e5/w0
    fcon=meas(0)/(w(3)-w(1))
    resi2=f(2)/fcon
;
;   generate results array
;
    result    = fltarr(19)
    result(0) = w
    result(4) = rv(1:3)
    result(7) = f(1:3)
    result(10)= fcon
    result(11)= meas
    result(11)= resi2
;
; print out results at left of page
;
    if npar eq 3 then feature_out, result else feature_out, result,comment
;
 endelse     ; tek or not tek
;
 if (n_elements(result) gt 0) then w0 = result    ; return result in w0
;
; If requested (and there is an accessible printer), create a plot file 
; of output screen
;
 ans = ''
 if keyword_set(nop) then return
 if ((!iueprint.type eq '') or (!iueprint.type eq ' ')) then ans = 'n'  $
     else begin  $
    if (strlowcase(!d.name) ne 'tek') then $
       read,' Send this plot to the laser printer? (y/n) ',ans $
       else xyreads,/device,hpos,vpos-vspace,ans, $
          'Send plot to laser printer? (y or n) '
 endelse  ; is a printer accessible
 yesno,ans
 if ans then begin
    plotopen,dev,'feature'
   ;
   ;   format plot
   ;
    plot,wavef,fluxf, $
         xtitle='Wavelength',ytitle='Flux',xmargin=[32,6],ymargin=[4,4]
    oplot,wavef,cont
    oplot,w(1:3),f(1:3),psym=7         ;Left, right, extremum points chosen
    xyouts,/norm,.01,.03,systime(0)
    for i=i1,i3 do plots,[wavef(i),wavef(i)],[cont(i),fluxf(i)]
   ;
   ;   format text
   ;
    if npar eq 3 then feature_out, result else feature_out, result,comment
    plotprint,dev,'feature'
 endif  ; hardcopy
;
 return
 end  ; feature
</PRE>
</body>
