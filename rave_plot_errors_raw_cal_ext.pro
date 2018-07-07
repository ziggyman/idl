pro rave_plot_errors_raw_cal_ext
  str_filename_dat = '/home/azuri/entwicklung/tex/talks/rave_meeting_coona_2011/images/errors.dat'

  strarr_data = readfiletostrarr(str_filename_dat,' ')

  dblarr_rave_raw = double(strarr_data(*,1:2))
  dblarr_rave_cal = double(strarr_data(*,3:4))
  dblarr_rave_ext = double(strarr_data(*,5:6))
  print,'0. dblarr_rave_raw = ',dblarr_rave_raw
  print,'0. dblarr_rave_cal = ',dblarr_rave_cal
  print,'0. dblarr_rave_ext = ',dblarr_rave_ext

  ; --- subtract external error from rave errors
  for i=0,4 do begin
    indarr = where(abs(dblarr_rave_ext(i,*) - 10.) ge 0.0000001)
    if indarr(0) ge 0 then begin
      dblarr_rave_raw(i,*) -= dblarr_rave_ext(i,*)
      dblarr_rave_cal(i,*) -= dblarr_rave_ext(i,*)
    endif
  endfor
  print,'1. dblarr_rave_raw = ',dblarr_rave_raw
  print,'1. dblarr_rave_cal = ',dblarr_rave_cal
  print,'1. dblarr_rave_ext = ',dblarr_rave_ext
  ; --- normalise data
  for i=0,4 do begin; all parameters
    for j=0,1 do begin; giants and dwarfs
      dblarr_test = [dblarr_rave_raw(i,j),dblarr_rave_cal(i,j),dblarr_rave_ext(i,j)]
      indarr = where(abs(dblarr_test - 10.) ge 0.00000001)
      print,'dblarr_test = ',dblarr_test
      dbl_max = max(dblarr_test(indarr))
      print,'dbl_max = ',dbl_max
      print,'dblarr_rave_raw(i=',i,',j=',j,') = ',dblarr_rave_raw(i,j)
      if abs(dblarr_rave_raw(i,j) - 10.) ge 0.00000001 then begin
        dblarr_rave_raw(i,j) /= dbl_max
        print,'dblarr_rave_raw(i=',i,',j=',j,') = ',dblarr_rave_raw(i,j)
      endif
      if abs(dblarr_rave_cal(i,j) - 10.) ge 0.00000001 then begin
        dblarr_rave_cal(i,j) /= dbl_max
        print,'dblarr_rave_cal(i=',i,',j=',j,') = ',dblarr_rave_cal(i,j)
      endif
      if abs(dblarr_rave_ext(i,j) - 10.) ge 0.00000001 then begin
        dblarr_rave_ext(i,j) /= dbl_max
        print,'dblarr_rave_ext(i=',i,',j=',j,') = ',dblarr_rave_ext(i,j)
      endif
    endfor
  endfor
  print,'2. dblarr_rave_raw = ',dblarr_rave_raw
  print,'2. dblarr_rave_cal = ',dblarr_rave_cal
  print,'2. dblarr_rave_ext = ',dblarr_rave_ext

  set_plot,'ps'
    str_plotname = strmid(str_filename_dat,0,strpos(str_filename_dat,'.',/REVERSE_SEARCH))+'.ps'
    device,filename=str_plotname,/color
    ;print,'!xtickv=',!xtickv
;    !XTICKS=14
;    !XTICKV=[0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5,13.5,14.5]
;    !XTICKNAME=['T!Deff!N','(log g)','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','(log g)','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','(log g)','[m/H]','[M/H]','[!4a!3/Fe]']

      for l=0,1 do begin; --- dwarfs and giants
        if l eq 0 then begin
          plot,[0.,15.],$
               [0.,0.],$
               xrange = [0.,15.],$
               yrange = [0.,1.],$
               xstyle = 1,$
               ystyle = 1,$
               position = [0.135,0.6,0.99,0.92],$
               title='Dwarfs',$
               ytitle='normalised error',$
               xticks=1,$
               xtickname=[' ',' '],$
;           xtickv=[0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5,13.5,14.5],$
;           xtickname=['T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]'],$
               charsize=1.8,$
               charthick=3.,$
               thick=3.
        end else begin
          plot,[0.,15.],$
               [0.,0.],$
               xrange = [0.,15.],$
               yrange = [0.,1.],$
               xstyle = 1,$
               ystyle = 1,$
               position = [0.135,0.08,0.99,0.42],$
               title='Giants',$
               ytitle='normalised error',$
               xticks=1,$
               xtickname=[' ',' '],$
;           xtickv=[0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5,13.5,14.5],$
;           xtickname=['T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]','T!Deff!N','log g','[m/H]','[M/H]','[!4a!3/Fe]'],$
               charsize=1.8,$
               charthick=3.,$
               thick=3.,$
               /noerase
        endelse
        xyouts,0.5,-0.07,'T!Deff!N',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,1.5,-0.07,'log g',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,2.5,-0.07,'[m/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,3.5,-0.07,'[M/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,4.5,-0.07,'[!4a!3/Fe]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,5.5,-0.07,'T!Deff!N',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,6.5,-0.07,'log g',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,7.5,-0.07,'[m/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,8.5,-0.07,'[M/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,9.5,-0.07,'[!4a!3/Fe]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,10.5,-0.07,'T!Deff!N',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,11.5,-0.07,'log g',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,12.5,-0.07,'[m/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,13.5,-0.07,'[M/H]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,14.5,-0.07,'[!4a!3/Fe]',alignment=0.5,charsize=0.8,charthick=3.;
        xyouts,2.5,-0.22,'raw',charsize=1.8,charthick=3.,alignment=0.5
        xyouts,7.5,-0.22,'calibrated',charsize=1.8,charthick=3.,alignment=0.5
        xyouts,12.5,-0.22,'external',charsize=1.8,charthick=3.,alignment=0.5
        loadct,13
        for i=0,2 do begin
          if i eq 0 then begin
            dblarr_data_plot = dblarr_rave_raw
          end else if i eq 1 then begin
            dblarr_data_plot = dblarr_rave_cal
          end else begin
            dblarr_data_plot = dblarr_rave_ext
          endelse
          for j=0,4 do begin
            print,'dblarr_data_plot(j=',j,',0) = ',dblarr_data_plot(j,0)
            print,'dblarr_data_plot(j=',j,',1) = ',dblarr_data_plot(j,1)
            if abs(dblarr_data_plot(j,l) - 10.) ge 0.000001 then $
              box,i*5.+j,0.,i*5+j+1,dblarr_data_plot(j,l),100*i
          endfor
        endfor
      endfor
; --- giants
;      plot,[0.,16.],$
;           [0.,0.],$
;           xrange = [0.,16.],$
;           yrange = [0.,1.],$
;           xstyle = 1,$
;           ystyle = 1,$
;           position = [0.15,0.13,0.99,0.42],$
;           title='Giants',$
;           /NOERASE

    device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname
end
