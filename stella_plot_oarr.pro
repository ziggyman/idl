pro stella_plot_oarr
  i_filestart = 10
  nfiles = 500;countlines(str_filename)
  overSample = 30.
  str_rootdir = '/home/azuri/spectra/pfs/'
  str_subdir = '2014-10-14/debug/'
  
  for i_trace = 0ul, 9 do begin
  str_trace = ''
  if i_trace lt 100 then str_trace+='0'
  if i_trace lt 10 then str_trace+='0'
  str_trace += strtrim(string(i_trace),2)
  
  i_bin = 0
  str_bin = ''
  if i_bin lt 10 then str_bin+='0'
  str_bin += strtrim(string(i_bin),2)

  plot_rec = 1

  ; --- read SlitFunc_ImIn
  str_filename = str_rootdir+str_subdir+'SlitFunc_ImIn_trace'+str_trace+'_IBin'+str_bin+'_IRunTel0_Tel0.dat'
  dblarr_pixval = double(readfiletostrarr(str_filename,' '))
  ;print,"dblarr_pixval(*,0) = ",dblarr_pixval(*,0)
  ;print,"dblarr_pixval(0,*) = ",dblarr_pixval(0,*)
  dblarr_pixval = dblarr_pixval(i_filestart:i_filestart+nfiles-1, *)
  for i=0ul, nfiles-1 do begin
    dblarr_pixval(i,*) = dblarr_pixval(i,*) / total(dblarr_pixval(i,*))
  endfor
  print,"dblarr_pixval(0,*) = ",dblarr_pixval(0,*)
 
  ; --- read IFirst
  str_filename = str_rootdir+str_subdir+'IFirstPix_trace'+str_trace+'_IBin'+str_bin+'_IRunTel0_Tel0.dat'
  dblarr_ifirst = double(readfilelinestoarr(str_filename))
  dblarr_ifirst = dblarr_ifirst(i_filestart:i_filestart+nfiles-1)
  
; --- read xcentersPixelOffset
;  str_filename = str_rootdir+str_subdir+'SlitFunc_XCentersIn_trace'+str_trace+'_IBin'+str_bin+'_IRunTel0_Tel0.dat'
;  dblarr_offset_x = double(readfilelinestoarr(str_filename))
;  dblarr_offset_x = dblarr_offset_x(i_filestart:i_filestart+nfiles-1)
  
; --- read OArr's
  str_filename = str_rootdir+str_subdir+'oarrs.list'
  spawn,'ls /home/azuri/spectra/pfs/'+str_subdir+'OArr_trace'+str_trace+'_IBin'+str_bin+'*.dat > '+str_filename
  strlist_filenames = readfilelinestoarr(str_filename)
  strlist_filenames = strlist_filenames(i_filestart:i_filestart+nfiles-1)
  nrows = countlines(strlist_filenames(0))
  dblarr_oarrs = dblarr(nfiles, nrows)
  print,'size(dblarr_oarrs) = ',size(dblarr_oarrs)

  str_nfilename = str_rootdir+str_subdir+'oarrs_new.list'
  spawn,'ls /home/azuri/spectra/pfs/'+str_subdir+'OArr_new_trace'+str_trace+'_IBin'+str_bin+'*.dat > '+str_nfilename
  strlist_nfilenames = readfilelinestoarr(str_nfilename)
  strlist_nfilenames = strlist_nfilenames(i_filestart:i_filestart+nfiles-1)
  dblarr_noarrs = dblarr(nfiles, nrows)
; --- read and normalize OArr's
  for i=0ul, nfiles-1 do begin
    dblarr_oarrs(i,*) = double(readfilelinestoarr(strlist_filenames(i)))
    dblarr_oarrs(i,*) = dblarr_oarrs(i,*) * overSample / total(dblarr_oarrs(i,*))
    dblarr_noarrs(i,*) = double(readfilelinestoarr(strlist_nfilenames(i)))
    dblarr_noarrs(i,*) = dblarr_noarrs(i,*) * overSample / total(dblarr_noarrs(i,*))
  endfor

; --- read profiles
  str_filename_profs = str_rootdir+str_subdir+'profs.list'
  spawn,'ls /home/azuri/spectra/pfs/'+str_subdir+'ProfileOut_trace'+str_trace+'_IBin'+str_bin+'*.dat > '+str_filename_profs
  strlist_filenames_prof = readfilelinestoarr(str_filename_profs)
  strlist_filenames_prof = strlist_filenames_prof(i_filestart:i_filestart+nfiles-1)
  npix = countlines(strlist_filenames_prof(0))
  dblarr_profs = dblarr(nfiles, npix)
  dblarr_pix_x = dblarr(nfiles, npix, 3)
  for i=0ul, nfiles-1 do begin
    dblarr_profs(i,*) = double(readfilelinestoarr(strlist_filenames_prof(i)))
    for j=0ul, npix-1 do begin
      dblarr_pix_x(i,j,0) = double(j) * double(overSample) + dblarr_ifirst(i) + double(overSample)/2.
      dblarr_pix_x(i,j,1) = dblarr_oarrs(i,j*overSample+long(dblarr_ifirst(i))+long(overSample/2))
      dblarr_pix_x(i,j,2) = dblarr_noarrs(i,j*overSample+long(dblarr_ifirst(i))+long(overSample/2))
    endfor
    print,dblarr_pix_x(i,*,*)
  endfor
;  stop
  
; --- read xvalues
;  str_filename_x = str_rootdir+str_subdir+'xarrs.list'
;  spawn,'ls /home/azuri/spectra/pfs/'+str_subdir+'x_trace'+str_trace+'_IBin'+str_bin+'*.dat > '+str_filename_x
;  strlist_filenames_x = readfilelinestoarr(str_filename_x)
;  strlist_filenames_x = strlist_filenames_x(i_filestart:i_filestart+nfiles-1)
;  dblarr_x = dblarr(nfiles, nrows, 2)
;  for i=0ul, nfiles-1 do begin
;    dblarr_x(i,*, 0) = double(readfilelinestoarr(strlist_filenames_x(i))) - dblarr_offset_x(i)
;    for ipix=0, npix-1 do begin
;      for ix=0, nrows-1 do begin
;        if (dblarr_x(i,ix,0) ge ipix) and (dblarr_x(i,ix,0) lt ipix+1) then begin
;          dblarr_x(i,ix,1) = dblarr_profs(i,ipix)
;        endif
;      endfor
;    endfor
;  endfor
;  print,'dblarr_x(0,*,*) = ',dblarr_x(0,*,*)
;  for i=0ul, nfiles-1 do begin
;    dblarr_x(i,*, 0) = dindgen(nrows)
;  endfor
;  stop
  
; --- read SlitFuncOut
  str_filename_sf = str_rootdir+str_subdir+'SlitFuncOut_trace'+str_trace+'_IBin'+str_bin+'_IRunTel0_Tel0.dat'
  dblarr_sfout = double(readfilelinestoarr(str_filename_sf))
  dblarr_sfout = dblarr_sfout * overSample / total(dblarr_sfout)

   for p=0,1 do begin
    str_plotfilename = 'normpixvals_prof_trace'
    if i_trace lt 100 then str_plotfilename = str_plotfilename + '0'
    if i_trace lt 10 then str_plotfilename = str_plotfilename + '0'
    str_plotfilename = str_plotfilename + strtrim(string(i_trace),2)+'_overSample30_lambdaSF1667'
    if p eq 0 then begin
      plot_rec=0 
    end else begin
      plot_rec=1
      str_plotfilename=str_plotfilename+'+rec'
    endelse
    set_plot,'ps'
      device,filename=str_rootdir+str_subdir+str_plotfilename+'.ps',/color
;        plot,dblarr_oarrs(0,*),$
        plot,dblarr_pix_x(0,*,0),$
             dblarr_pix_x(0,*,1),$
             xrange=[0,(npix+1) * overSample + 1],$
             yrange=[0,max(dblarr_oarrs)],$
             ystyle = 2,$
             xtitle = 'subpixel number',$
             ytitle = 'signal fraction',$
             psym   = 2,$
             linestyle = 0,$
             symsize = 0.1,$
             title=str_plotfilename
        loadct,17
        for i=0ul, nfiles-1 do begin
;          oplot,dblarr_oarrs(i,*),$
;          oplot,dblarr_pix_x(i,*,0),$
;                dblarr_pix_x(i,*,1),$
;                color = 255 * i / nfiles,$
;                psym = 2,$
;                symsize=1.2,$
;                linestyle=0
;          oplot,dblarr_pix_x(i,*,0),$
;                dblarr_pix_x(i,*,2),$
;                color = 255 * i / nfiles,$
;                psym = 2,$
;                symsize=3.,$
;                linestyle=0
          print,"size(dblarr_pixval) = ",size(dblarr_pixval)
          print,"size(dblarr_pix_x) = ",size(dblarr_pix_x)
          oplot,dblarr_pix_x(i,*,0),$
                dblarr_pixval(i,*),$
                color = 255 * i / nfiles,$
                psym = 6,$
                symsize=0.1,$
                linestyle=0
          if plot_rec eq 1 then begin
            oplot,dblarr_pix_x(i,*,0),$
                  dblarr_profs(i,*),$
;                  linestyle = 2,$
                  color = 255 * i / nfiles,$
                  psym=4,$
                  symsize=0.5,$
                  linestyle=0
          endif
        endfor
        loadct,0
;        oplot,dblarr_sfout,thick=3.
        oplot,dblarr_sfout,thick=3.
      device,/close
    set_plot,'x'
   endfor
  endfor
  
end
