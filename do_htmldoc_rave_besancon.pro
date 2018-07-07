pro do_htmldoc_rave_besancon,besanconfile,$
                             ravefile,$
                             htmlpath,$
;                             IMIN=imin,$
;                             IMAX=imax,$
                             IRANGE=irange,$
                             CALCSAMPLES=calcsamples,$
                             I_NSAMPLES=i_nsamples,$
;                             I_NBINS=i_nbins,$
;                             NBINSMIN=i_nbins_min,$
;                             NBINSMAX=i_nbins_max,$
                             B_ONE_BESANCONFILE=b_one_besanconfile,$
                             B_HIST=b_hist,$
                             TITLES=titles,$
                             PATH=path,$
                             GIFFILENAMES=giffilenames;            strarr(i_nsamples+1)

  print,'do_htmldoc_rave_besancon: besanconfile = '+besanconfile
  print,'do_htmldoc_rave_besancon: ravefile = '+ravefile
  str_temp = strmid(besanconfile,0,strpos(besanconfile,'/',/REVERSE_SEARCH))
  if keyword_set(PATH) then begin
    str_path = path
    print,'do_htmldoc_rave_besancon: keyword_set(PATH): str_path = '+str_path
  end else begin
    if keyword_set(B_ONE_BESANCONFILE) then begin
      str_path = str_temp + '/' + htmlpath
    end else begin
      str_path = strmid(str_temp,0,strpos(str_temp,'/',/REVERSE_SEARCH)+1) + htmlpath
    end
    if keyword_set(IRANGE) then begin
      if irange(0) gt 0. then $
        str_path = str_path + '/I'+strmid(strtrim(string(irange(0)),2),0,4)+'-'
      if irange(1) gt 0. then $
        str_path = str_path +strmid(strtrim(string(irange(1)),2),0,4)
    endif
    if keyword_set(B_ONE_BESANCONFILE) then begin
      i_pos_start = strpos(strmid(besanconfile,0,strpos(besanconfile,'_',/REVERSE_SEARCH)),'_',/REVERSE_SEARCH) + 1
      i_pos_end = strpos(besanconfile,'.',/REVERSE_SEARCH)
      str_path = str_path + '/' + strmid(besanconfile,i_pos_start,i_pos_end-i_pos_start) + '/'
    end else begin
      str_path = str_path + strmid(str_temp,strpos(str_temp,'/',/REVERSE_SEARCH)) + '/'
    end
    print,'do_htmldoc_rave_besancon: keyword PATH not set: str_path = '+str_path
  end
;  print,'do_htmldoc_rave_besancon: str_path = '+str_path
  openw,luni,str_path+'index.html',/GET_LUN
    printf,luni,'<html>'
    printf,luni,'<body>'
    str_besancon = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'.gif'
    str_besancon = strmid(str_besancon,strpos(str_besancon,'/',/REVERSE_SEARCH)+1)

    str_giffile_besancon =  str_path+str_besancon

    if keyword_set(B_HIST) and keyword_set(TITLES) then begin
      if keyword_set(GIFFILENAMES) then begin
        str_giffile_besancon_hist_x = giffilenames(0,0)+'.gif'
        str_giffile_besancon_hist_y = giffilenames(0,1)+'.gif'
      end else begin
        str_giffile_besancon_hist_x = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_'+titles(0)+'.gif'
        str_giffile_besancon_hist_y = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_'+titles(1)+'.gif'
      end
      spawn,'mv '+str_giffile_besancon_hist_x+' '+str_path
      spawn,'mv '+str_giffile_besancon_hist_y+' '+str_path
      spawn,'mv '+strmid(str_giffile_besancon_hist_x,0,strpos(str_giffile_besancon_hist_x,'.',/REVERSE_SEARCH))+'.ps '+str_path
      spawn,'mv '+strmid(str_giffile_besancon_hist_y,0,strpos(str_giffile_besancon_hist_y,'.',/REVERSE_SEARCH))+'.ps '+str_path
    end

    print,'do_htmldoc_rave_besancon: str_giffile_besancon = '+str_giffile_besancon
    str_rave = strmid(ravefile,strpos(ravefile,'/',/REVERSE_SEARCH)+1)

    str_giffile_rave = str_path+strmid(str_rave,0,strpos(str_rave,'.',/REVERSE_SEARCH))+'.gif'

;    if keyword_set(B_HIST) and keyword_set(TITLES) then begin
;      str_giffile_rave_hist_x = strmid(ravefile,0,strpos(ravefile,'.',/REVERSE_SEARCH))+'_'+titles(0)+'.gif'
;      spawn,'mv '+str_giffile_rave_hist_x+' '+str_path

;      str_giffile_rave_hist_y = strmid(ravefile,0,strpos(ravefile,'.',/REVERSE_SEARCH))+'_'+titles(1)+'.gif'
;      spawn,'mv '+str_giffile_rave_hist_y+' '+str_path
;    endif

    print,'do_htmldoc_rave_besancon: str_giffile_rave = '+str_giffile_rave
    print,'do_htmldoc_rave_besancon: Converting '+ besanconfile
    spawn,'ps2gif '+besanconfile+' '+str_giffile_besancon
    spawn,'mv '+besanconfile+' '+str_path
    spawn,'ps2gif '+strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_cont.ps '+strmid(str_giffile_besancon,0,strpos(str_giffile_besancon,'.',/REVERSE_SEARCH))+'_cont.gif'
    spawn,'mv '+strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_cont.ps '+str_path
    print,'do_htmldoc_rave_besancon: Converting '+ ravefile
    spawn,'ps2gif '+ravefile+' '+str_giffile_rave
    spawn,'mv '+ravefile+' '+str_path
    spawn,'ps2gif '+strmid(ravefile,0,strpos(ravefile,'.',/REVERSE_SEARCH))+'_cont.ps '+strmid(str_giffile_rave,0,strpos(str_giffile_rave,'.',/REVERSE_SEARCH))+'_cont.gif'
    spawn,'mv '+strmid(ravefile,0,strpos(ravefile,'.',/REVERSE_SEARCH))+'_cont.ps '+str_path
    str_giffile_besancon_temp = strmid(str_giffile_besancon,strpos(str_giffile_besancon,'/',/REVERSE_SEARCH)+1)
    printf,luni,'<img src=' + str_giffile_besancon_temp + ' width=60% alt="no stars in Besancon field">'
    str_giffile_besancon_temp = strmid(str_giffile_besancon,strpos(str_giffile_besancon,'/',/REVERSE_SEARCH)+1)
    printf,luni,'<img src=' + strmid(str_giffile_besancon_temp,0,strpos(str_giffile_besancon_temp,'.',/REVERSE_SEARCH)) + '_cont.gif width=60% alt="no stars in Besancon field"><br>'
    str_giffile_rave_temp = strmid(str_giffile_rave,strpos(str_giffile_rave,'/',/REVERSE_SEARCH)+1)
    printf,luni,'<img src=' + str_giffile_rave_temp + ' width=60% alt="no RAVE stars in field">'
    str_giffile_rave_temp = strmid(str_giffile_rave,strpos(str_giffile_rave,'/',/REVERSE_SEARCH)+1)
    printf,luni,'<img src=' + strmid(str_giffile_rave_temp,0,strpos(str_giffile_rave_temp,'.',/REVERSE_SEARCH)) + '_cont.gif width=60% alt="no RAVE stars in field"><br>'
    if keyword_set(B_HIST) and keyword_set(TITLES) then begin
      printf,luni,'<img src=' + strmid(str_giffile_besancon_hist_x,strpos(str_giffile_besancon_hist_x,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="no stars in Besancon field">'
      printf,luni,'<img src=' + strmid(str_giffile_besancon_hist_y,strpos(str_giffile_besancon_hist_y,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="no stars in Besancon field"><br>'
      printf,luni,'solid line: RAVE, dashed line: Besancon<br>'
    endif
;    if keyword_set(B_HIST) and keyword_set(TITLES) then begin
;      printf,luni,'<img src=' + strmid(str_giffile_rave_hist_x,strpos(str_giffile_rave_hist_x,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="no RAVE stars in field">'
;      printf,luni,'<img src=' + strmid(str_giffile_rave_hist_y,strpos(str_giffile_rave_hist_y,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="no RAVE stars in field"><br>'
;    endif
;    printf,luni,'<a href="'+strmid(str_htmlfile,strpos(str_htmlfile,'/',/REVERSE_SEARCH)+1)+'">'+strmid(strarr_lines(i,0),0,strpos(strarr_lines(i,0),'.'))+' '+strarr_lines(i,1)+'</a><br>'
    if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) then begin
      printf,luni,'<br><hr><br><h3>Random samples of Besancon data with the same number of stars as in the Rave field</h3><br>'
      for i=0,i_nsamples-1 do begin
;      for i=0,n_elements(giffilenames)/2 - 1 do begin
        samplefile = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_'+strtrim(string(i),2)+'.ps'
        samplegiffile = strmid(str_giffile_besancon,0,strpos(str_giffile_besancon,'.',/REVERSE_SEARCH))+'_'+strtrim(string(i),2)+'.gif'
        print,'do_htmldoc_rave_besancon: Converting '+ samplefile
        spawn,'ps2gif '+samplefile+' '+samplegiffile
        spawn,'mv '+samplefile+' '+str_path
        spawn,'ps2gif '+strmid(samplefile,0,strpos(samplefile,'.',/REVERSE_SEARCH))+'_cont.ps '+strmid(samplegiffile,0,strpos(samplegiffile,'.',/REVERSE_SEARCH))+'_cont.gif'
        spawn,'mv '+strmid(samplefile,0,strpos(samplefile,'.',/REVERSE_SEARCH))+'_cont.ps '+str_path
;        spawn,'rm '+samplefile

        if keyword_set(B_HIST) and keyword_set(TITLES) then begin
          if keyword_set(GIFFILENAMES) and n_elements(giffilenames) gt 2 then begin
;            print,'do_htmldoc_rave_besancon: giffilenames = ',giffilenames
            str_giffile_besancon_hist_x = giffilenames(i+1,0)+'.gif'
            str_giffile_besancon_hist_y = giffilenames(i+1,1)+'.gif'
          end else begin
            str_giffile_besancon_hist_x = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_'+titles(0)+'_'+strtrim(string(i),2)+'.gif'
            str_giffile_besancon_hist_y = strmid(besanconfile,0,strpos(besanconfile,'.',/REVERSE_SEARCH))+'_'+titles(1)+'_'+strtrim(string(i),2)+'.gif'
          end
          spawn,'mv '+str_giffile_besancon_hist_x+' '+str_path
          spawn,'mv '+str_giffile_besancon_hist_y+' '+str_path
          spawn,'mv '+strmid(str_giffile_besancon_hist_x,0,strpos(str_giffile_besancon_hist_x,'.',/REVERSE_SEARCH))+'.ps '+str_path
          spawn,'mv '+strmid(str_giffile_besancon_hist_y,0,strpos(str_giffile_besancon_hist_y,'.',/REVERSE_SEARCH))+'.ps '+str_path
        end

        samplegiffile_temp = strmid(samplegiffile,strpos(samplegiffile,'/',/REVERSE_SEARCH)+1)
        printf,luni,'<img src=' + samplegiffile_temp + ' width=60% alt="not enough stars to compare">'
        printf,luni,'<img src=' + strmid(samplegiffile_temp,0,strpos(samplegiffile_temp,'.',/REVERSE_SEARCH)) + '_cont.gif width=60% alt="not enough stars to compare"><br>'
        if keyword_set(B_HIST) and keyword_set(TITLES) then begin
          printf,luni,'<img src=' + strmid(str_giffile_besancon_hist_x,strpos(str_giffile_besancon_hist_x,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="not enough stars to compare">'
          printf,luni,'<img src=' + strmid(str_giffile_besancon_hist_y,strpos(str_giffile_besancon_hist_y,'/',/REVERSE_SEARCH)+1) + ' width=48% alt="not enough stars to compare">'
        endif
        printf,luni,'<br><hr><br>'
      endfor
    end
    printf,luni,'</body>'
    printf,luni,'</html>'
  free_lun,luni
end
