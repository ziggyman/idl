pro plot_pipeline_comparisons_cosmics_all
  str_path = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/Tel1_no_xcor/'
  str_filelist_all = str_path+'cosmics_text.list'
  strarr_filelists = readfilelinestoarr(str_filelist_all)
  
  str_plotname = strmid(str_filelist_all,0,strpos(str_filelist_all,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
    device,filename=str_plotname
      loadct,0
;      for i=0, n_elements(strarr_filelists)-1 do begin
        strarr_one_filelist_before = readfilelinestoarr(str_path+strarr_filelists(0))
        print,'strarr_one_filelist_before = ',strarr_one_filelist_before
        strarr_one_filelist_lacos = readfilelinestoarr(str_path+strarr_filelists(1))
        print,'strarr_one_filelist_lacos = ',strarr_one_filelist_lacos
        strarr_one_filelist_orig = readfilelinestoarr(str_path+strarr_filelists(2))
        print,'strarr_one_filelist_orig = ',strarr_one_filelist_orig
        strarr_one_filelist_mine = readfilelinestoarr(str_path+strarr_filelists(3))
        print,'strarr_one_filelist_mine = ',strarr_one_filelist_mine
;        stop

        dblarr_before_a = double(readfiletostrarr(str_path+strarr_one_filelist_before(0),' '))
        indarr = where(dblarr_before_a lt 0.)
        if indarr(0) ge 0 then $
        dblarr_before_a(indarr) = 0.
        print,'mean(dblarr_before_a) = ',size(dblarr_before_a),': ',mean(dblarr_before_a)
        dbl_median_before_a = median(dblarr_before_a)
        dbl_mean_before_a = mean(dblarr_before_a)
        print,'median(dblarr_before_a) = ',size(dblarr_before_a),': ',dbl_median_before_a
        print,'max(dblarr_before_a) = ',max(dblarr_before_a)
        dblarr_before_b = double(readfiletostrarr(str_path+strarr_one_filelist_before(1),' '))
        indarr = where(dblarr_before_b lt 0.)
        if indarr(0) ge 0 then $
        dblarr_before_b(indarr) = 0.
        print,'mean(dblarr_before_b) = ',size(dblarr_before_b),': ',mean(dblarr_before_b)
        dbl_median_before_b = median(dblarr_before_b)
        dbl_mean_before_b = mean(dblarr_before_b)
        print,'median(dblarr_before_b) = ',size(dblarr_before_b),': ',dbl_median_before_b
        print,'max(dblarr_before_b) = ',max(dblarr_before_b)

        dblarr_lacos_a = double(readfiletostrarr(str_path+strarr_one_filelist_lacos(0),' '))
        indarr = where(dblarr_lacos_a lt 0.)
        if indarr(0) ge 0 then $
        dblarr_lacos_a(indarr) = 0.
        print,'mean(dblarr_lacos_a) = ',size(dblarr_lacos_a),': ',mean(dblarr_lacos_a)
        dbl_median_lacos_a = median(dblarr_lacos_a)
        dbl_mean_lacos_a = mean(dblarr_lacos_a)
        print,'median(dblarr_lacos_a) = ',size(dblarr_lacos_a),': ',median(dblarr_lacos_a)
        print,'max(dblarr_lacos_a) = ',max(dblarr_lacos_a)
        dblarr_lacos_b = double(readfiletostrarr(str_path+strarr_one_filelist_lacos(1),' '))
        indarr = where(dblarr_lacos_b lt 0.)
        if indarr(0) ge 0 then $
        dblarr_lacos_b(indarr) = 0.
        print,'mean(dblarr_lacos_b) = ',size(dblarr_lacos_b),': ',mean(dblarr_lacos_b)
        dbl_median_lacos_b = median(dblarr_lacos_b)
        dbl_mean_lacos_b = mean(dblarr_lacos_b)
        print,'median(dblarr_lacos_b) = ',size(dblarr_lacos_b),': ',median(dblarr_lacos_b)
        print,'max(dblarr_lacos_b) = ',max(dblarr_lacos_b)
        
        dblarr_orig_a = double(readfiletostrarr(str_path+strarr_one_filelist_orig(0),' '))
        indarr = where(dblarr_orig_a lt 0.)
        if indarr(0) ge 0 then $
        dblarr_orig_a(indarr) = 0.
        print,'mean(dblarr_orig_a) = ',size(dblarr_orig_a),': ',mean(dblarr_orig_a)
        dbl_median_orig_a = median(dblarr_orig_a)
        dbl_mean_orig_a = mean(dblarr_orig_a)
        print,'median(dblarr_orig_a) = ',size(dblarr_orig_a),': ',median(dblarr_orig_a)
        print,'max(dblarr_orig_a) = ',max(dblarr_orig_a)
        dblarr_orig_b = double(readfiletostrarr(str_path+strarr_one_filelist_orig(1),' '))
        indarr = where(dblarr_orig_b lt 0.)
        if indarr(0) ge 0 then $
        dblarr_orig_b(indarr) = 0.
        print,'mean(dblarr_orig_b) = ',size(dblarr_orig_b),': ',mean(dblarr_orig_b)
        dbl_median_orig_b = median(dblarr_orig_b)
        dbl_mean_orig_b = mean(dblarr_orig_b)
        print,'median(dblarr_orig_b) = ',size(dblarr_orig_b),': ',median(dblarr_orig_b)
        print,'max(dblarr_orig_b) = ',max(dblarr_orig_b)

        dblarr_mine_a = double(readfiletostrarr(str_path+strarr_one_filelist_mine(0),' '))
        indarr = where(dblarr_mine_a lt 0.)
        if indarr(0) ge 0 then $
        dblarr_mine_a(indarr) = 0.
        print,'mean(dblarr_mine_a) = ',size(dblarr_mine_a),': ',mean(dblarr_mine_a)
        dbl_median_mine_a = median(dblarr_mine_a)
        dbl_mean_mine_a = mean(dblarr_mine_a)
        print,'median(dblarr_mine_a) = ',size(dblarr_mine_a),': ',median(dblarr_mine_a)
        print,'max(dblarr_mine_a) = ',max(dblarr_mine_a)
        dblarr_mine_b = double(readfiletostrarr(str_path+strarr_one_filelist_mine(1),' '))
        indarr = where(dblarr_mine_b lt 0.)
        if indarr(0) ge 0 then $
        dblarr_mine_b(indarr) = 0.
        print,'mean(dblarr_mine_b) = ',size(dblarr_mine_b),': ',mean(dblarr_mine_b)
        dbl_median_mine_b = median(dblarr_mine_b)
        dbl_mean_mine_b = mean(dblarr_mine_b)
        print,'median(dblarr_mine_b) = ',size(dblarr_mine_b),': ',median(dblarr_mine_b)
        print,'max(dblarr_mine_b) = ',max(dblarr_mine_b)
;        stop

        dblarr_before_a = dblarr_before_a(*,0:33)
        dblarr_before_b = dblarr_before_b(*,0:33)
        dblarr_lacos_a = dblarr_lacos_a(*,0:33)
        dblarr_lacos_b = dblarr_lacos_b(*,0:33)
        dblarr_orig_a = dblarr_orig_a(*,0:33)
        dblarr_orig_b = dblarr_orig_b(*,0:33)
        dblarr_mine_a = dblarr_mine_a(*,0:33)
        dblarr_mine_b = dblarr_mine_b(*,0:33)

        dblarr_before_a = dblarr_before_a / 0.68;dbl_mean_orig_a / dbl_mean_before_a
        dblarr_before_b = dblarr_before_b / 0.68;dbl_mean_orig_b / dbl_mean_before_b
        dblarr_lacos_a = dblarr_lacos_a / 0.68;dbl_mean_mine_a / dbl_mean_lacos_a
        dblarr_lacos_b = dblarr_lacos_b / 0.68;dbl_mean_mine_b / dbl_mean_before_b
        dblarr_orig_a = dblarr_orig_a * 0.68;dbl_mean_orig_a / dbl_mean_before_a
        dblarr_orig_b = dblarr_orig_b * 0.68;dbl_mean_orig_b / dbl_mean_before_b
        dblarr_mine_a = dblarr_mine_a * 0.68;dbl_mean_mine_a / dbl_mean_lacos_a
        dblarr_mine_b = dblarr_mine_b * 0.68;dbl_mean_mine_b / dbl_mean_before_b

        size_a = size(dblarr_orig_a)
        size_b = size(dblarr_orig_b)
        print,'size_a = ',size_a
        print,'size_b = ',size_b
        d_maxval = max([dblarr_orig_a,dblarr_orig_b,dblarr_mine_a,dblarr_mine_b, dblarr_lacos_a, dblarr_lacos_b])
        print,'d_maxval = ',d_maxval
;        stop
          xrange = [0,4*size_a(2)+6]
          yrange = [0,size_a(1) + size_b(1) + 2]
          plot,xrange,$
               [0,0],$
               xrange=xrange,$
               xstyle = 1,$
               yrange = yrange,$
               ystyle = 1,$
;               xtitle = 'Relative CCD column',$
;               ytitle = 'Relative CCD row',$
               thick = 2.,$
               charsize = 1.4,$
               charthick = 3.,$
               position=[0.033,0.06,0.93,0.995],$
               xticks=1,$
               yticks=1,$
               xtickname=[' ',' '],$
               ytickname=[' ',' ']
          for i_row = 0, size_a(1)-1 do begin
            for i_col = 0, size_a(2)-1 do begin
              x0=i_col
              x1=i_col+1
              y0=i_row
              y1=i_row+1
              
              i_color = (254 * dblarr_before_a(i_row, i_col) / d_maxval) + 1
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0,y0,x1,y1,i_color
              
              i_color = (254 * dblarr_lacos_a(i_row, i_col) / d_maxval) + 1
;              i_color = (254 * (dblarr_orig_a(i_row, i_col)-dblarr_lacos_a(i_row, i_col)) / d_maxval) + 1
              if i_color gt 254 then i_color = 254
              if i_color lt 0 then i_color = 0
              i_color = 254 - i_color
              box,x0+size_a(2)+2,y0,x1+size_a(2)+2,y1,i_color
              
              i_color = (254 * dblarr_orig_a(i_row, i_col) / d_maxval) + 1
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0+2*size_a(2)+4,y0,x1+2*size_a(2)+4,y1,i_color
              
              i_color = (254 * dblarr_mine_a(i_row, i_col) / d_maxval) + 1
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0+3*size_a(2)+6,y0,x1+3*size_a(2)+6,y1,i_color
            endfor
          endfor
          for i_row = 0, size_b(1)-1 do begin
            for i_col = 0, size_b(2)-1 do begin
              x0=i_col
              x1=i_col+1
              y0=i_row+size_a(1)+2
              y1=i_row+size_a(1)+2+1
              
              i_color = (254 * dblarr_before_b(i_row, i_col) / d_maxval + 1)
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0,y0,x1,y1,i_color
              
              i_color = (254 * dblarr_lacos_b(i_row, i_col) / d_maxval + 1)
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0+size_a(2)+2,y0,x1+size_a(2)+2,y1,i_color
              
              i_color = (254 * dblarr_orig_b(i_row, i_col) / d_maxval + 1)
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0+2*size_a(2)+4,y0,x1+2*size_a(2)+4,y1,i_color
              
              i_color = (254 * dblarr_mine_b(i_row, i_col) / d_maxval + 1)
              if i_color gt 254 then i_color = 254
              i_color = 254 - i_color
              box,x0+3*size_a(2)+6,y0,x1+3*size_a(2)+6,y1,i_color
            endfor
          endfor
          for i=0, 254 do begin
            x0=xrange(1)
            x1=xrange(1) + 3
            y0=0+yrange(1)*i/254
            y1=0+yrange(1)*(i+1)/254
            box,x0,y0,x1,y1,254-i
          endfor
          xyouts,xrange(1)+3.5,0,'0',charsize=1.4,charthick = 3.
          xyouts,xrange(1)+3.,yrange(1)-2.5,strtrim(string(long(d_maxval)), 2),charsize=1.4,charthick = 3.
          xyouts,xrange(1)+7,yrange(1)/2.,'Pixel value [ADUs]',orientation=90,charsize=1.4,charthick=3.,alignment=0.5
        
          xyouts,xrange(0)-1,yrange(1)/2.,'Relative CCD row',orientation=90,charsize=1.4,charthick=3.,alignment=0.5
          xyouts,xrange(1)/2+3,yrange(0)-4.,'Relative CCD column',charsize=1.4,charthick=3.,alignment=0.5
;      endfor
       oplot,[xrange(0), xrange(1)],[size_a(1)+1,size_a(1)+1]
       oplot,[size_a(2)+1, size_a(2)+1],[yrange(0),yrange(1)]
       oplot,[2*size_a(2)+3, 2*size_a(2)+3],[yrange(0),yrange(1)]
       oplot,[3*size_a(2)+5, 3*size_a(2)+5],[yrange(0),yrange(1)]
    device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname
  
end
