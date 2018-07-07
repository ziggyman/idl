pro besancon_plot_I_Teff

;  rave_plot_I_Teff_all

  imin = 9.
  imax = 12.

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

    str_path = '/home/azuri/daten/besancon/html/I_Teff/'
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
        ymin = -0.00001
        ymax = 12000.
        oldymin = ymin
        oldymax = ymax

        openw,lunw,'temp.txt',/GET_LUN
          printf,lunw,strarr_fields(i,0)+' '+strarr_fields(i,1)+' '+strarr_fields(i,2)+' '+strarr_fields(i,3)
        free_lun,lunw
        rave_plot_I_Teff_all,YMIN=ymin,YMAX=ymax,FIELDSFILE='temp.txt'

        oldymin = ymin
        oldymax = ymax
        datafile = datafiles(i)
        rave_plot_two_cols,datafile,$
                           12,$
                           4,$
                           'I [mag]',$
                           'Teff [K]',$
                           strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_I_Teff.ps',$
                           TITLE='Besancon '+strarr_fields(i,0)+' - '+strarr_fields(i,1)+', '+strarr_fields(i,2)+' - '+strarr_fields(i,3)+'',$
                           YLOG=1, $
                           XMIN=9.,$
                           XMAX=12.,$
                           YMIN=ymin,$
                           YMAX=ymax,$
                           IMIN=imin,$
                           IMAX=imax,$
                           ICOL=12
        if abs(ymin-oldymin) gt 0.0001 then begin
          print,'besancon_plot_I_Teff: WWWAAARRRNNNIIINNNGGG: ymin(=',ymin,') != oldymin(=',oldymin,')'
          rave_plot_I_Teff_all,YMIN=ymin,YMAX=ymax,FIELDSFILE='temp.txt'
        end
        if abs(ymax-oldymax) gt 0.0001 then begin
          print,'besancon_plot_I_Teff: WWWAAARRRNNNIIINNNGGG: ymax(=',ymax,') != oldymax(=',oldymax,')'
          rave_plot_I_Teff_all,YMIN=ymin,YMAX=ymax,FIELDSFILE='temp.txt'
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

        str_ravefile = '/home/azuri/daten/rave/rave_data/release3/rave_internal_090408_I_Teff_'
        if imin gt 0. then $
          str_ravefile = str_ravefile+$
                         'I'+$
                         strtrim(string(imin),2)+$
                         '-'+$
                         strtrim(string(imax),2)+$
                         '_'
        str_ravefile = str_ravefile+strmid(strarr_fields(i,0),0,strpos(strarr_fields(i,0),'.'))+'-'+strmid(strarr_fields(i,1),0,strpos(strarr_fields(i,1),'.'))+'_'+strmid(strarr_fields(i,2),0,strpos(strarr_fields(i,2),'.'))+'-'+strmid(strarr_fields(i,3),0,strpos(strarr_fields(i,3),'.'))+'.ps'
        print,'besancon_plot_I_Teff: str_ravefile = "'+str_ravefile+'"'

        str_besanconfile = strmid(datafile,0,strpos(datafile,'.',/REVERSE_SEARCH))+'_I_Teff.ps'

        if imin gt 0. then begin
          str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'_I'+strtrim(string(imin),2)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
        endif
        if imax gt 0. then begin
          str_besanconfile = strmid(str_besanconfile,0,strpos(str_besanconfile,'.',/REVERSE_SEARCH))+'-'+strtrim(string(imax),2)+strmid(str_besanconfile,strpos(str_besanconfile,'.',/REVERSE_SEARCH))
        endif
        print,'besancon_plot_I_Teff: str_besanconfile = "'+str_besanconfile+'"'

        do_htmldoc_rave_MH_vrad,str_besanconfile,str_ravefile,'html/I_Teff',IMIN=imin,IMAX=imax

      endfor

      printf,luni,'</body>'
      printf,luni,'</html>'
    free_lun,luni
;  end
end
