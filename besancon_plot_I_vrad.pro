pro besancon_plot_I_vrad,SUBPATH=subpath,$
                         FIELDSFILE=fieldsfile,$
                         XCOL=xcol,$
                         XTITLE=xtitle,$
                         XMIN=xmin,$
                         XMAX=xmax,$
                         YCOL=ycol,$
                         YTITLE=ytitle,$
                         YMIN=ymin,$
                         YMAX=ymax,$
                         IMIN=imin,$
                         IMAX=imax,$
                         ICOL=icol,$
                         FORCEYRANGE=forceyrange

;  rave_plot_I_Teff_all

  if (not keyword_set(IMIN)) then imin = 9.
  if (not keyword_set(IMAX)) then imax = 12.
  if (not keyword_set(XMIN)) then xmin = 9.
  if (not keyword_set(XMAX)) then xmax = 12.
  if (not keyword_set(YMIN)) then ymin = -300.
  if (not keyword_set(YMAX)) then ymax = 300.
  if (not keyword_set(ICOL)) then icol = 12.
  if (not keyword_set(XCOL)) then xcol = 12.
  if (not keyword_set(YCOL)) then ycol = 15.
  if (not keyword_set(XTITLE)) then xtitle = 'I [mag]'
  if (not keyword_set(YTITLE)) then ytitle = 'vrad [km/s]'
  if (not keyword_set(SUBPATH)) then subpath = 'I_vrad'
  if (not keyword_set(FORCEYRANGE)) then forceyrange = 1

  meanx=0.
  sigmax=0.
  meany=0.
  sigmay=0.

  meansigrave = dblarr(2,2)
  meansigbes = dblarr(2,2)

  if (not keyword_set(FIELDSFILE)) then $
    fieldsfile = '/home/azuri/daten/rave/rave_data/release3/fields.dat'
  i_nfields = countdatlines(fieldsfile)
  strarr_fields = readfiletostrarr(fieldsfile,' ')
  dblarr_fields = dblarr(i_nfields,4)
  for i=0,3 do begin
    dblarr_fields(*,i) = double(strarr_fields(*,i))
  endfor
  print,'strarr_fields = ',strarr_fields
  print,'dblarr_fields = ',dblarr_fields

;  fielddatasfile = '/home/azuri/daten/besancon/fielddatas.txt'
;  i_ndatafiles = countdatlines(fielddatasfile)
  datafiles = strarr_fields(*,4)
;  if i_nfields ne i_ndatafiles then begin
;    print,'besancon_plot_FeH_vrad: ERROR: i_nfields ne i_ndatafiles'
;  end else begin

    str_path = '/home/azuri/daten/besancon/html/'+subpath+'/'
    if imin gt 0. then $
      str_path = str_path + 'I' + strtrim(string(imin),2) + '-'
    if imax gt 0. then $
      str_path = str_path + strtrim(string(imax),2) + '/'
    openw,luni,str_path+'index.html',/GET_LUN
      printf,luni,'<html>'
      printf,luni,'<body>'
      fieldfile = '/home/azuri/daten/rave/rave_data/release3/fields.ps'
      giffieldfile = strmid(fieldfile,0,strpos(fieldfile,'.',/REVERSE_SEARCH))+'.gif'
      print,'fieldfile = '+fieldfile
      giffieldfile = str_path+strmid(giffieldfile,strpos(giffieldfile,'/',/REVERSE_SEARCH)+1)
      spawn,'ps2gif '+fieldfile+' '+giffieldfile
      printf,luni,'<img src="rave_chart.gif" width=60%><br><br>'
      printf,luni,'<img src="'+strmid(giffieldfile,strpos(giffieldfile,'/',/REVERSE_SEARCH)+1)+'" width=60%><br><br>'

      for i=0,i_nfields-1 do begin
        yminbak = ymin
        ymaxbak = ymax
        oldymin = ymin
        oldymax = ymax

        openw,lunw,'temp.txt',/GET_LUN
          printf,lunw,strarr_fields(i,0)+' '+strarr_fields(i,1)+' '+strarr_fields(i,2)+' '+strarr_fields(i,3)
        free_lun,lunw
        rave_plot_I_vrad_all,YMIN=yminbak,$
                             YMAX=ymaxbak,$
                             FIELDSFILE='temp.txt',$
                             MEANX=meanx,$
                             SIGMAX=sigmax,$
                             MEANY=meany,$
                             SIGMAY=sigmay

        meansigrave(0,0)=meanx
        meansigrave(0,1)=sigmax
        meansigrave(1,0)=meany
        meansigrave(1,1)=sigmay

        oldymin = yminbak
        oldymax = ymaxbak
        datafile = datafiles(i)
        rave_plot_two_cols,datafile,$
                           xcol,$
                           ycol,$
                           xtitle,$
                           ytitle,$
                           strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_'+subpath+'.ps',$
                           TITLE='Besancon '+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', '+strarr_fields(i,2)+' - '+strarr_fields(i,3)+'',$
;                           YLOG=1, $
                           XMIN=xmin,$
                           XMAX=xmax,$
                           YMIN=yminbak,$
                           YMAX=ymaxbak,$
                           IMIN=imin,$
                           IMAX=imax,$
                           ICOL=icol,$
                           FORCEYRANGE=forceyrange,$
                           MEANX=meanx,$
                           SIGMAX=sigmax,$
                           MEANY=meany,$
                           SIGMAY=sigmay

        meansigbes(0,0)=meanx
        meansigbes(0,1)=sigmax
        meansigbes(1,0)=meany
        meansigbes(1,1)=sigmay
        if (abs(yminbak-oldymin) gt 0.0001) or (abs(ymaxbak-oldymax) gt 0.0001) then begin
          if abs(yminbak-oldymin) gt 0.0001 then begin
            print,'besancon_plot_I_vrad: WWWAAARRRNNNIIINNNGGG: yminbak(=',yminbak,') != oldymin(=',oldymin,')'
          end
          if abs(ymaxbak-oldymax) gt 0.0001 then begin
            print,'besancon_plot_I_vrad: WWWAAARRRNNNIIINNNGGG: ymaxbak(=',ymaxbak,') != oldymax(=',oldymax,')'
          end
          if (not keyword_set(FORCEYRANGE)) then begin
            rave_plot_I_vrad_all,YMIN=ymin,$
                                 YMAX=ymax,$
                                 FIELDSFILE='temp.txt',$
                                 MEANX=meanx,$
                                 SIGMAX=sigmax,$
                                 MEANY=meany,$
                                 SIGMAY=sigmay

            meansigrave(0,0)=meanx
            meansigrave(0,1)=sigmax
            meansigrave(1,0)=meany
            meansigrave(1,1)=sigmay
          end
        end
        html_path = strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+$
                    '-'+$
                    strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+$
                    '_'+$
                    strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+$
                    '-'+$
                    strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))
        spawn,'rm -r '+str_path+html_path
        spawn,'mkdir '+str_path+html_path
        str_print = '<a href="'+$
                    html_path+$
                    '/index.html">longitude = '+$
                    strarr_fields(i,0)+$
                    ' - '+$
                    strarr_fields(i,1)+$
                    ', latitude = '+$
                    strarr_fields(i,2)+$
                    ' - '+$
                    strarr_fields(i,3)+$
                    '</a><br>'
        printf,luni,str_print

        str_ravefile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408_'+subpath+'_'
        if imin gt 0. then $
          str_ravefile = str_ravefile+$
                         'I'+$
                         strtrim(string(imin),2)+$
                         '-'+$
                         strtrim(string(imax),2)+$
                         '_'
        str_ravefile = str_ravefile+strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+'-'+strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+'_'+strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+'-'+strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))+'.ps'
        print,'besancon_plot_I_vrad: str_ravefile = "'+str_ravefile+'"'

        str_besanconfile = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_'+subpath+'.ps'

        if imin gt 0. then begin
          str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_I'+strtrim(string(imin),2)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
        endif
        if imax gt 0. then begin
          str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'-'+strtrim(string(imax),2)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
        endif
        print,'besancon_plot_I_vrad: str_besanconfile = "'+str_besanconfile+'"'

        do_htmldoc_rave_MH_vrad,str_besanconfile,str_ravefile,'html/'+subpath,IMIN=imin,IMAX=imax

      endfor

      printf,luni,'</body>'
      printf,luni,'</html>'
    free_lun,luni
;  end
end
