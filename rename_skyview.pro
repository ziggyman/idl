pro rename_skyview,list,path,runid

if n_elements(runid) eq 0 then begin
  print,'rename_skyview: Not enough parameters specified, return 0.'
  print,'usage: rename_skyview,list,path,runid'
endif else begin   

  file      = ''
  tempfile  = ''
  newnames  = 'newnames'
  temprunid = ''
  close,1
  close,2
  openw,1,path+newnames
  openr,2,path+list
  i = 1
  j = 0
  k = strlen(runid) - 1
  while not EOF(2) do begin
    readf, 2, tempfile
    file = 'hd'+strmid(tempfile,2,strlen(tempfile)-5)+'ps'
    tempstring = strcompress(string(i),/remove_all)
    print,'tempstring = '+tempstring
    print,'strlen(tempstring)='+string(strlen(tempstring))
    print,'strmid(000,0,3-'+string(strlen(tempstring))+') = '+strmid('000',0,3-strlen(tempstring))
    print,'strlen(runid) = '+string(strlen(runid))
    for j=0,k do begin
      print,'strmid(runid,'+string(j)+',1) = '+strmid(runid,j,1)
      if strmid(runid,j,1) eq '(' then begin
        temprunid = temprunid+'\('
      endif else if strmid(runid,j,1) eq ')' then begin
        temprunid = temprunid+'\)'
      endif else begin
        temprunid = temprunid+strmid(runid,j,1)
      end
      print,'temprunid = '+temprunid
    endfor
    
    spawn,'cp '+path+file+' '+path+temprunid+'.'+strmid('000',0,3-strlen(tempstring))+tempstring+'.ps'
    i = i+1
  endwhile
  close,2
  close,1
  spawn,'chmod +x '+path+newnames
  spawn,path+newnames
endelse
end

