pro do_htmldoc_joss

  str_path = '/home/azuri/spectra/joss/'
  str_linelist = str_path+'lines_to_fit.list'
  strarr_lines = readfiletoarr(str_linelist)
  i_nlines = countdatlines(str_linelist)
  openw,luni,str_path+'html/index.html',/GET_LUN
    printf,luni,'<html>'
    printf,luni,'<body>'
    for i=0UL,i_nlines-1 do begin
      spawn,'ls -1 '+str_path+'S*'+strarr_lines(i,0)+'*.ps > '+str_path+'temp.list'
      i_nfiles = countdatlines(str_path+'temp.list')
      strarr_files = readfiletoarr(str_path+'temp.list')
      str_htmlfile = str_path+'html/'+strmid(strarr_lines(i,0),0,strpos(strarr_lines(i,0),'.'))+'_'+strarr_lines(i,1)+'.html'
      print,'str_htmlfile = '+str_htmlfile
      openw,lun,str_htmlfile,/GET_LUN
        printf,lun,'<html>'
        printf,lun,'<body>'
        for j=0UL,i_nfiles-1 do begin
          i_slashpos = strpos(strarr_files(j),'/',/REVERSE_SEARCH)+1
          str_giffile = strmid(strarr_files(j),0,i_slashpos)+'html/'+strmid(strarr_files(j),i_slashpos,strpos(strarr_files(j),'.')-i_slashpos)+'.gif'
;        print,'str_giffile = '+str_giffile
          spawn,'ps2gif '+strarr_files(j)+' '+str_giffile
          printf,lun,'<img src='+strmid(str_giffile,strpos(str_giffile,'/',/REVERSE_SEARCH)+1)+'><br>'
        endfor
        printf,lun,'</body>'
        printf,lun,'</html>'
      free_lun,lun
      printf,luni,'<a href="'+strmid(str_htmlfile,strpos(str_htmlfile,'/',/REVERSE_SEARCH)+1)+'">'+strmid(strarr_lines(i,0),0,strpos(strarr_lines(i,0),'.'))+' '+strarr_lines(i,1)+'</a><br>'
    endfor
    printf,luni,'</body>'
    printf,luni,'</html>'
  free_lun,luni
end
