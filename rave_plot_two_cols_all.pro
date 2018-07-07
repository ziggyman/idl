pro rave_plot_two_cols_all,FIELDSFILE=fieldsfile,$
                           RAVEDATAFILE=ravedatafile,$
                           DATAARR=dataarr,$
                           XCOL=xcol,$
                           XRANGESET=xrangeset,$
                           XTITLE=xtitle,$
                           XLOG=xlog,$
                           YLOG=ylog,$
                           YCOL=ycol,$
                           YRANGESET=yrangeset,$
                           YTITLE=ytitle,$
                           TITLE=title,$
                           ICOL=icol,$
                           IRANGE=irange,$
                           MOMENTX=momentx,$
                           MOMENTY=momenty,$
                           REJECTVALUEX=rejectvaluex,$
                           NREJECTEDX=nrejectedx,$
                           REJECTVALUEY=rejectvaluey,$
                           NREJECTEDY=nrejectedy,$
                           FORCEXRANGE=forcexrange,$
                           FORCEYRANGE=forceyrange,$
                           SUBPATH=subpath,$
                           I_NSTARS=i_nstars,$
                           PROBLEM=problem,$
                           INDARR_OUT=indarr_out,$
                           IO_PLOT_GIANT_TO_DWARF_RATIO = io_plot_giant_to_dwarf_ratio; --- 0: don't, 1: x=logg, 2: y=logg

  if keyword_set(XRANGESET) then $
    xrange = xrangeset
  if keyword_set(YRANGESET) then $
    yrange = yrangeset
  if (not keyword_set(FIELDSFILE)) then begin
    fieldsfile = '/suphys/azuri/daten/rave/rave_data/release3/fields.dat'
  end

  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor
;  print,'rave_plot_two_cols_all: strarr_fields = ',strarr_fields
;  print,'rave_plot_two_cols_all: dblarr_fields = ',dblarr_fields

;  if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then $
;    dblarr_giant_to_dwarf_ratio = dblarr(i_nfields)

  if (not keyword_set(MOMENTX)) then momentx = 0.
  if (not keyword_set(MOMENTY)) then momenty = 0.
;  if (not keyword_set(MEANX)) then meanx = 0.
;  if (not keyword_set(SIGMAX)) then sigmax = 0.
;  if (not keyword_set(MEANY)) then meany = 0.
;  if (not keyword_set(SIGMAY)) then sigmay = 0.

  if (keyword_set(RAVEDATAFILE)) then begin
    datafile = ravedatafile
  end else begin
    datafile = '/suphys/azuri/daten/rave/rave_data/release5/rave_internal_300808_no_doubles.dat'
  end

  for i=0,i_nfields-1 do begin
    oldymin = yrange(0)
    oldymax = yrange(1)
    print,'rave_plot_two_cols_all: calculating line ',i
    print,'rave_plot_two_cols_all: ',dblarr_fields(i,0),$
          dblarr_fields(i,1),$
          dblarr_fields(i,2),$
          dblarr_fields(i,3)
    colra = 0.000001
    coldec = 1
    mindec = dblarr_fields(i,2)
    if mindec eq 0. then mindec = 0.0000001
    minra = dblarr_fields(i,0)
    if minra eq 0. then minra = 0.0000001
    str_plotname = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_'+subpath+'.ps'
    print,'rave_plot_two_cols_all: str_plotname = '+str_plotname
    if xcol eq 0.0001 then $
      xcol = 0
    if ycol eq 0.0001 then $
      ycol = 0
;    if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then $
;      giant_to_dwarf_ratio = io_plot_giant_to_dwarf_ratio
;    print,'rave_plot_two_cols_all: io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
;    stop
    rave_plot_two_cols,datafile,$
                       xcol,$
                       ycol,$
                       xtitle,$
                       ytitle,$
                       str_plotname,$
                       XRANGESET=xrangeset,$;---
                       XLOG=xlog,$;---
                       YLOG=ylog,$;---
                       DATAARR=dataarr,$;---
                       REJECTVALUEX=rejectvaluex,$;---
                       REJECTVALUEY=rejectvaluey,$;---
                       NREJECTEDX=nrejectedx,$;---
                       NREJECTEDY=nrejectedy,$;---
                       MINDEC=mindec,$;---
                       MAXDEC=dblarr_fields(i,3),$;---
                       COLDEC=coldec,$;---
                       MINRA=minra,$;---
                       MAXRA=dblarr_fields(i,1),$;---
                       COLRA=colra,$;---
                       TITLE=title,$;---
                       YRANGESET=yrangeset,$;---
                       IRANGE=irange,$;---
                       ICOL=icol,$;---
                       FORCEXRANGE=forcexrange,$;---
                       FORCEYRANGE=forceyrange,$;---
                       MOMENTX=momentx,$;---
                       MOMENTY=momenty,$;---
                       I_NSTARS=i_nstars,$;---
                       PROBLEM=problem,$;---
                       INDARR_OUT=indarr_out,$;---
                       IO_PLOT_GIANT_TO_DWARF_RATIO = io_plot_giant_to_dwarf_ratio; --- 0: don't, 1: x=logg, 2: y=logg

;    if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then begin
;      dblarr_giant_to_dwarf_ratio(i) = giant_to_dwarf_ratio
;      io_plot_giant_to_dwarf_ratio = giant_to_dwarf_ratio
;      print,'giant_to_dwarf_ratio = ',giant_to_dwarf_ratio
;      print,'io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
;    endif


    if problem eq 1 then begin
      return
    end
    if abs(yrange(0)-oldymin) gt 0.00001 then begin
      print,'rave_plot_two_cols_all: WWWAAARRRNNNIIINNNGGG: ymin(=',yrange(0),') != oldymin(=',oldymin,')'
    end
    if abs(yrange(1)-oldymax) gt 0.00001 then begin
      print,'rave_plot_two_cols_all: WWWAAARRRNNNIIINNNGGG: ymax(=',yrange(1),') != oldymax(=',oldymax,')'
    end
  endfor
  strarr_fields=0
  datafile=0
;  if keyword_set(IO_PLOT_GIANT_TO_DWARF_RATIO) then begin
;    io_plot_giant_to_dwarf_ratio = dblarr_giant_to_dwarf_ratio
;    print,'io_plot_giant_to_dwarf_ratio = ',io_plot_giant_to_dwarf_ratio
;;    stop
;  endif
end
