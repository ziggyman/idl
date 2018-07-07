pro plot_pipeline_comparisons_cosmics
  str_path = '/home/azuri/spectra/elaina/eso_archive/red_564/red_l/Tel1_no_xcor/'
  str_filelist_all = str_path+'cosmics_text.list'
  strarr_filelists = readfilelinestoarr(str_filelist_all)
  
  str_plotname = strmid(str_filelist_all,0,strpos(str_filelist_all,'.',/REVERSE_SEARCH))+'.ps'
  set_plot,'ps'
    device,filename=str_plotname
      loadct,0
;      for i=0, n_elements(strarr_filelists)-1 do begin
        strarr_one_filelist_orig = readfilelinestoarr(str_path+strarr_filelists(0))
        strarr_one_filelist_mine = readfilelinestoarr(str_path+strarr_filelists(1))
        dblarr_orig_a = double(readfiletostrarr(str_path+strarr_one_filelist_orig(0),' '))
        indarr = where(dblarr_orig_a lt 0.)
        dblarr_orig_a(indarr) = 0.
        dblarr_orig_b = double(readfiletostrarr(str_path+strarr_one_filelist_orig(1),' '))
        indarr = where(dblarr_orig_b lt 0.)
        dblarr_orig_b(indarr) = 0.

        dblarr_mine_a = double(readfiletostrarr(str_path+strarr_one_filelist_mine(0),' '))
        indarr = where(dblarr_mine_a lt 0.)
        dblarr_mine_a(indarr) = 0.
        dblarr_mine_b = double(readfiletostrarr(str_path+strarr_one_filelist_mine(1),' '))
        indarr = where(dblarr_mine_b lt 0.)
        dblarr_mine_b(indarr) = 0.
        
        size_a = size(dblarr_orig_a)
        size_b = size(dblarr_orig_b)
        print,'size_a = ',size_a
        print,'size_b = ',size_b
        d_maxval = max([dblarr_orig_a,dblarr_orig_b,dblarr_mine_a,dblarr_mine_b])
        print,'d_maxval = ',d_maxval
          xrange = [0,2*size_a(2)+2]
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
               position=[0.04,0.06,0.905,0.995],$
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
              i_color = 254 - (254 * dblarr_orig_a(i_row, i_col) / d_maxval + 1)
              box,x0,y0,x1,y1,i_color
              
              i_color = 254 - (254 * dblarr_mine_a(i_row, i_col) / d_maxval + 1)
              box,x0+size_a(2)+2,y0,x1+size_a(2)+2,y1,i_color
            endfor
          endfor
          for i_row = 0, size_b(1)-1 do begin
            for i_col = 0, size_b(2)-1 do begin
              x0=i_col
              x1=i_col+1
              y0=i_row+size_a(1)+2
              y1=i_row+size_a(1)+2+1
              i_color = 254 - (254 * dblarr_orig_b(i_row, i_col) / d_maxval + 1)
              box,x0,y0,x1,y1,i_color
              
              i_color = 254 - (254 * dblarr_mine_b(i_row, i_col) / d_maxval + 1)
              box,x0+size_a(2)+2,y0,x1+size_a(2)+2,y1,i_color
            endfor
          endfor
          for i=0, 254 do begin
            x0=xrange(1)+1
            x1=xrange(1) + 3
            y0=0+yrange(1)*i/254
            y0=0+yrange(1)*(i+1)/254
            box,x0,y0,x1,y1,254-i
          endfor
          xyouts,xrange(1)+3.5,0,'0',charsize=1.4,charthick = 3.
          xyouts,xrange(1)+3.5,yrange(1)-2.5,strtrim(string(long(d_maxval)), 2),charsize=1.4,charthick = 3.
          xyouts,xrange(1)+7,yrange(1)/2.,'Pixel value [ADUs]',orientation=90,charsize=1.4,charthick=3.,alignment=0.5
        
          xyouts,xrange(0)-1,yrange(1)/2.,'Relative CCD row',orientation=90,charsize=1.4,charthick=3.,alignment=0.5
          xyouts,xrange(1)/2+3,yrange(0)-4.,'Relative CCD column',charsize=1.4,charthick=3.,alignment=0.5
;      endfor
    device,/close
  set_plot,'x'
  spawn,'epstopdf '+str_plotname
  
end
