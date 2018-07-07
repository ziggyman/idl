pro rave_plot_errors_dr2_cal_ext
  str_filename_dat = '/home/azuri/entwicklung/tex/talks/rave_meeting_coona_2011/images/errors.dat'

  strarr_data = readfiletostrarr(str_filename_dat,' ')

  dblarr_rave_dr2 = double(strarr_data(*,1:2))
  dblarr_rave_cal = double(strarr_data(*,3:4))
  dblarr_rave_ext = double(strarr_data(*,5:6))
  print,'0. dblarr_rave_dr2 = ',dblarr_rave_dr2
  print,'0. dblarr_rave_cal = ',dblarr_rave_cal
  print,'0. dblarr_rave_ext = ',dblarr_rave_ext

  ; --- subtract external error from rave errors
  for i=0,4 do begin
    indarr = where(abs(dblarr_rave_ext(i,*) - 10.) ge 0.0000001)
    if indarr(0) ge 0 then begin
      dblarr_rave_dr2(i,*) -= dblarr_rave_ext(i,*)
      dblarr_rave_cal(i,*) -= dblarr_rave_ext(i,*)
    endif
  endfor
  print,'1. dblarr_rave_dr2 = ',dblarr_rave_dr2
  print,'1. dblarr_rave_cal = ',dblarr_rave_cal
  print,'1. dblarr_rave_ext = ',dblarr_rave_ext
  ; --- normalise data
  for i=0,4 do begin; all parameters
    for j=0,1 do begin; giants and dwarfs
      dblarr_test = [dblarr_rave_dr2(i,j),dblarr_rave_cal(i,j),dblarr_rave_ext(i,j)]
      indarr = where(abs(dblarr_test - 10.) ge 0.00000001)
      print,'dblarr_test = ',dblarr_test
      dbl_max = max(dblarr_test(indarr))
      print,'dbl_max = ',dbl_max
      print,'dblarr_rave_dr2(i=',i,',j=',j,') = ',dblarr_rave_dr2(i,j)
      if abs(dblarr_rave_dr2(i,j) - 10.) ge 0.00000001 then begin
        dblarr_rave_dr2(i,j) /= dbl_max
        print,'dblarr_rave_dr2(i=',i,',j=',j,') = ',dblarr_rave_dr2(i,j)
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
  print,'2. dblarr_rave_dr2 = ',dblarr_rave_dr2
  print,'2. dblarr_rave_cal = ',dblarr_rave_cal
  print,'2. dblarr_rave_ext = ',dblarr_rave_ext

  set_plot,'ps'
    device,filename=strmid(str_filename_dat,0,strpos(str_filename_dat,'.',/REVERSE_SEARCH))+'.ps',/color
;    !XTICKNAME=['T!D!eff, DR3!N']
; --- dwarfs
      plot,[0.,15.],$
           [0.,0.],$
           xrange = [0.,16.],$
           yrange = [0.,1.],$
           xstyle = 1,$
           ystyle = 1,$
           position = [0.15,0.63,0.99,0.92],$
           title='Dwarfs';,$

      loadct,13
      for i=0,2 do begin
        if i eq 0 then begin
          dblarr_data_plot = dblarr_rave_dr2
        end else if i eq 1 then begin
          dblarr_data_plot = dblarr_rave_cal
        end else begin
          dblarr_data_plot = dblarr_rave_ext
        endelse
        for j=0,4 do begin
          print,'dblarr_data_plot(j=',j,',0) = ',dblarr_data_plot(j,0)
          print,'dblarr_data_plot(j=',j,',1) = ',dblarr_data_plot(j,1)
          if abs(dblarr_data_plot(j,0) - 10.) ge 0.000001 then $
            box,i*5.+j,0.,i*5+j+1,dblarr_data_plot(j,0),100*i
        endfor
      endfor

; --- giants
      plot,[0.,16.],$
           [0.,0.],$
           xrange = [0.,16.],$
           yrange = [0.,1.],$
           xstyle = 1,$
           ystyle = 1,$
           position = [0.15,0.13,0.99,0.42],$
           title='Giants',$
           /NOERASE

    device,/close
  set_plot,'x'
end
