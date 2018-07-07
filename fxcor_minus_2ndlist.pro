common maxfn,maxfm

pro fxcor_minus_2ndlist,lista,listb,outlist,outfile,print
common maxfn,maxfm
  
;
; NAME:                  fxcor_minus_2ndlist.pro
; PURPOSE:               removes the radial velocities of the 2nd list
;                        from the 1st list
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fxcor_minus_2ndlist,'../../UVES/ready/red_r/fxcor_RXJ_red_r_-3_100_90_90.data','../../UVES/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt','outlist'
; INPUTS:                input file: lista, listb:
;                                    #N HJD HGHT FWHM VOBS VREL VHELIO VERR
;                                    #U days          km/s km/s km/s   km/s
;                                    file hjd1 hght fwhm vobs vrel vhelio verr
;                                    ...
;                        or: lista like above, listb:
;                        -<value to add>
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  27.08.2004
;
;                        headline
;                        feetline (up to now not used) 
;

headline=''            
feetline=''

;-- test arguments
if n_elements(outfile) eq 0 then begin
  lista = '../../UVES/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt'
  listb = '../../UVES/ready/red_r/fxcor_RXJ_red_r_-3_100_90_90.data'
  outlist = 'fxcor_minus_2ndlist_out.data'
  outfile = '../../UVES/ready/fxcor_refHD-fxcors_red'
  print,'ERROR: Not enough parameters specified!'
  print,"Usage: fxcor_minus_2ndlist,'lista','listb','outlist','outfile','print'"
endif
; else begin

;-- count lines fname
  maxfn=countlines(lista)
  print,maxfn,' data lines, outfile = <'+outfile+'>' 
  maxfm = countlines(listb)
  vobsoutfile = outfile+'_vobs.data'
  vreloutfile = outfile+'_vrel.data'
  vheliooutfile = outfile+'_vhelio.data'
 
 ;-- initialize variables
;  filenamearr    = strarr(maxfn-2)
  vradtosubtract = double(0.)
  hjdarr         = dblarr(maxfn-2)
  hghtarr        = dblarr(maxfn-2,2)
  fwhmarr        = dblarr(maxfn-2,2)
  vobsarr        = dblarr(maxfn-2,2)
  vrelarr        = dblarr(maxfn-2,2)
  vhelioarr      = dblarr(maxfn-2,2)
  verrarr        = dblarr(maxfn-2,2) 

 ;-- read filenames from fname (inputfile)
  hjdq      = ''
  hghtq     = ''
  fwhmq     = ''
  vobsq     = ''
  vrelq     = ''
  vhelioq   = ''
  verrq     = ''
  lineq     = ''
  vobsarrstring = ''
  vobsoutstring = ''
  vrelarrstring = ''
  vreloutstring = ''
  vhelioarrstring = ''
  vheliooutstring = ''

  close,1  
  openr,1,lista
  close,2
  openr,2,listb
  close,3
  openw,3,outlist
  if maxfn ne maxfm then begin
    readf,2,lineq
    vradtosubtract=strtrim(lineq,2)
  endif
  for i=0,maxfn-1 do begin
    if i lt 2 then begin
      readf,1,lineq
;      print,'line read 1st file: ',lineq
      if maxfn eq maxfm then readf,2,lineq
;      print,'line read 2nd file: ',lineq
      printf,3,lineq
    end else begin
      if maxfn ne maxfm then k=0 else k=1
      for j=0,k do begin
        readf,j+1,lineq
        lineq = strtrim(lineq,2)
        hjdq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(hjdq),strlen(lineq)-strlen(hjdq)),2)
;        print,'hjdq = <'+hjdq+'>'
;        print,'lineq = <'+lineq+'>'
        hghtq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(hghtq),strlen(lineq)-strlen(hghtq)),2)
;        print,'hghtq = <'+hghtq+'>'
;        print,'lineq = <'+lineq+'>'
        fwhmq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(fwhmq),strlen(lineq)-strlen(fwhmq)),2)
;        print,'fwhmq = <'+fwhmq+'>'
;        print,'lineq = <'+lineq+'>'
        vobsq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(vobsq),strlen(lineq)-strlen(vobsq)),2)
;        print,'vobsq = <'+vobsq+'>'
;        print,'lineq = <'+lineq+'>'
        vrelq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(vrelq),strlen(lineq)-strlen(vrelq)),2)
;        print,'vrelq = <'+vrelq+'>'
;        print,'lineq = <'+lineq+'>'
        vhelioq = strmid(lineq,0,strpos(lineq,' '))
        lineq = strtrim(strmid(lineq,strlen(vhelioq),strlen(lineq)-strlen(vhelioq)),2)
;        print,'vhelioq = <'+vhelioq+'>'
;        print,'lineq = <'+lineq+'>'
        verrq = lineq
;        print,'verrq = <'+verrq+'>'
;        print,'lineq = <'+lineq+'>'
;      lineq = strtrim(strmid(lineq,strpos(lineq,' '),strpos(lineq,' ',strpos(lineq,' ')+2))) 
;      print,'fxcor_minus_2ndlist: hjdq = <'+hjdq+'>, hghtq = <'+hghtq+'>, fwhmq = <'+fwhmq+'>, vobsq = <'+vobsq+'>, vrelq = <'+vrelq+'>, vhelioq = <'+vhelioq+'>, verrq = <'+verrq+'>'
        hjdarr(i-2)      = hjdq
        hghtarr(i-2,j)   = hghtq
        fwhmarr(i-2,j)   = fwhmq
        vobsarr(i-2,j)   = vobsq
        vrelarr(i-2,j)   = vrelq
        vhelioarr(i-2,j) = vhelioq
        verrarr(i-2,j)   = verrq
        if k eq 1 then begin
          if j eq 1 then begin
            vobsarrstring = strtrim(string(vobsarr(i-2,0)-vobsarr(i-2,1),FORMAT = '(F10.4)'),2)
            vobsoutstring = vobsoutstring+vobsarrstring+' '
 ;           print,'vobsoutstring = <'+vobsoutstring+'>'
            vrelarrstring = strtrim(string(vrelarr(i-2,0)-vrelarr(i-2,1),FORMAT = '(F10.4)'),2)
            vreloutstring = vreloutstring+vrelarrstring+' '
 ;           print,'vreloutstring = <'+vreloutstring+'>'
            vhelioarrstring = strtrim(string(vhelioarr(i-2,0)-vhelioarr(i-2,1),FORMAT = '(F10.4)'),2)
            vheliooutstring = vheliooutstring+vhelioarrstring+' '
 ;           print,'vheliooutstring = <'+vheliooutstring+'>'
          end
        end else begin
          vobsarrstring = strtrim(string(vobsarr(i-2,0)-vradtosubtract,FORMAT = '(F10.4)'),2)
          vobsoutstring = vobsoutstring+vobsarrstring+' '
;          print,'vobsoutstring = <'+vobsoutstring+'>'
          vrelarrstring = strtrim(string(vrelarr(i-2,0)-vradtosubtract,FORMAT = '(F10.4)'),2)
          vreloutstring = vreloutstring+vrelarrstring+' '
;           print,'vreloutstring = <'+vreloutstring+'>'
          vhelioarrstring = strtrim(string(vhelioarr(i-2,0)-vradtosubtract,FORMAT = '(F10.4)'),2)
          vheliooutstring = vheliooutstring+vhelioarrstring+' '
;          print,'vheliooutstring = <'+vheliooutstring+'>'
        endelse 
      end
      printf,3,hjdarr(i-2),hghtarr(i-2,0),fwhmarr(i-2,0),vobsarr(i-2,0) - vobsarr(i-2,1),vrelarr(i-2,0)-vrelarr(i-2,1),vhelioarr(i-2,0)-vhelioarr(i-2,1),verrarr(i-2,0),FORMAT = '(F10.4," ",F5.2," ",F6.2," ",F7.4," ",F7.4," ",F7.4," ",F7.3)'
    end
  endfor
  close,1
  close,2
  close,3
;  close,4
;  close,5
;  close,6
  openw,lun,vobsoutfile,/append,/get_lun
  openw,lunb,vreloutfile,/append,/get_lun
  openw,lunc,vheliooutfile,/append,/get_lun
  print,'printing <'+vobsoutstring+'> to '+vobsoutfile
  printf,lun,vobsoutstring
  print,'printing <'+vreloutstring+'> to '+vreloutfile
  printf,lunb,vreloutstring
  print,'printing <'+vheliooutstring+'> to '+vheliooutfile
  printf,lunc,vheliooutstring
  free_lun,lun
  free_lun,lunb
  free_lun,lunc

  if n_elements(print) gt 0 then begin
    set_plot,'ps'
    psoutfile = strmid(lista,0,strpos(lista,'.',/REVERSE_SEARCH))+'_minus_'+strmid(listb,strpos(listb,'/',/REVERSE_SEARCH)+1,strpos(listb,'.',/REVERSE_SEARCH)-strpos(listb,'/',/REVERSE_SEARCH)-1)+'.eps'
    print,'fxcor_minus_2ndlist: psoutfile = <'+psoutfile+'>'
    device, filename=psoutfile,bits_per_pixel=4,xsize=16.8,ysize=16.8,/color,encaps=1
  endif
  red   = intarr(256)
  green = intarr(256)
  blue  = intarr(256)
  TVLCT, red, green, blue, /GET
  modifyct,0,'blue-red',red,green,blue,file='colors1.tbl'
  loadct,0,file='colors1.tbl',ncolors=7
  plot,hjdarr,vobsarr(*,0),color=0,xtitle='hjd [days]',ytitle='radial velocity [km/s]',title='fxcor_minus_2ndlist: lista='+lista+' - listb='+listb+' = outlist='+outlist
  oplot,hjdarr,vobsarr(*,1),color=1
  oplot,hjdarr,vobsarr(*,0)-vobsarr(*,1),color=2
  if n_elements(print) gt 0 then begin
    device,/close
    set_plot,'x'
  endif

;endelse
end
