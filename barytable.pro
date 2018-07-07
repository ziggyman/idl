;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################
pro barytable,list
;############################
;this program converts a list of names, RAs, DECs, DATEs and UTs (4
;rows per image) to one new list (one row per image)
;
;list: 1st line: DATE
;list: 2nd line: UTC_HMS
;list: 3rd line: DEC_HMS
;list: 4th line: RA_HMS
;############################

if n_elements(list) eq 0 then print,'sortline: No file specified, return 0.' $
else begin   

;logfile
  close,101
  openw,101,'logfile'

  path  = '/home/azuri/UVES/'

;countlines
  maxn = countlines(path+list)
  print,list,': '+string(maxn)+' DATA LINES'  
  printf,101,list,': '+string(maxn)+' DATA LINES, maxn/4.='+string(maxn/4.)+'   maxn/4='+string(maxn/4)  

;build arrays
  columns    = 5
  namelist   = strarr(maxn/4)
  ralist     = strarr(maxn/4)
  declist    = strarr(maxn/4)
  datelist   = strarr(maxn/4)
  utlist     = strarr(maxn/4)
  printf,101,'barytable: arrays built'

  qtemp     = ''
  tempstr   = ''
  iname     = 0
  ira       = 0
  idec      = 0
  idate     = 0
  iut       = 0
  year      = ''
  month     = ''
  day       = ''
  hour      = ''
  minute    = ''
  second    = ''
  dech      = ''
  decm      = ''
  decs      = ''
  rah       = ''
  ram       = ''
  ras       = ''
  latitude  = '-24,37,31.465'
  longitude = '-70,24,10.855'

;read file in arrays
  close,1
  openr,1,path+list
  for i=0,maxn-1 do begin
    readf,1,tempstr
    qtemp = strtrim(tempstr,1)
    printf,101,'barytable: qtemp='+qtemp
    if qtemp ne '' then begin
      if (i mod 4) eq 0 then begin
        namelist(iname) = strmid(qtemp,0,strpos(qtemp,','))
        printf,101,'barytable: namelist('+string(iname)+') = '+namelist(iname)
        iname = iname + 1
        datelist(idate)   = strmid(qtemp,strpos(qtemp,' ')+1,strpos(qtemp,' ',strpos(qtemp,' ')+1)-strpos(qtemp,' ')-1)
        printf,101,'barytable: datelist('+string(idate)+')  = '+datelist(idate)
        idate  = idate + 1 
      end else if (i mod 4) eq 1 then begin
        utlist(iut)       = strmid(qtemp,strpos(qtemp,' ')+1,strpos(qtemp,' ',strpos(qtemp,' ')+1)-strpos(qtemp,' ')-1)
        printf,101,'barytable: utlist('+string(iut)+')    = '+utlist(iut)
        iut   = iut + 1 
      end else if (i mod 4) eq 2 then begin
        declist(idec)   = strmid(qtemp,strpos(qtemp,' ')+1,strpos(qtemp,' ',strpos(qtemp,' ')+1)-strpos(qtemp,' ')-1)
        printf,101,'barytable: declist('+string(idec)+')  = '+declist(idec)
        idec   = idec + 1 
      end else if (i mod 4) eq 3 then begin
        ralist(ira)     = strmid(qtemp,strpos(qtemp,' ')+1,strpos(qtemp,' ',strpos(qtemp,' ')+1)-strpos(qtemp,' ')-1)
        printf,101,'barytable: ralist('+string(ira)+')   = '+ralist(ira)
        ira   = ira + 1 
      end
    endif
  endfor
  close,1
  printf,101,'barytable: infile read.'

;write file
  newlist1  = 'barycor_imname_DATE_UTC_DEC_RA.tbl'
  newlist2  = 'barycor_DATE_UTC_DEC_RA.tbl'
  blankline = '                                                                                                             '
  print,'output filenames:'+newlist1+' + '+newlist2
  printf,101,'barytable: starting writing the new list. output filenames:'+newlist1+' + '+newlist2
  close,2
  close,3
  openw,2,path+newlist1
  openw,3,path+newlist2
  for i=0,(maxn/4)-1 do begin
    year   = strmid(datelist(i),0,4)
    month  = strmid(datelist(i),5,2)
    day    = strmid(datelist(i),8,2)
    hour   = strmid(utlist(i),0,2)
    minute = strmid(utlist(i),3,2)
    second = strmid(utlist(i),6,6)
    rah    = strmid(ralist(i),0,2)
    ram    = strmid(ralist(i),3,2)
    ras    = strmid(ralist(i),6,4)
    if strmid(declist(i),0,1) ne '-' then begin
      dech   = strmid(declist(i),0,2) 
      decm   = strmid(declist(i),3,2) 
      decs   = strmid(declist(i),6,4) 
    endif else begin
      dech   = strmid(declist(i),0,3) 
      decm   = strmid(declist(i),4,2) 
      decs   = strmid(declist(i),7,4) 
    endelse
    printf,2,namelist(i)+': '+year+','+month+','+day+' '+hour+','+minute+','+second+' '+rah+','+ram+','+ras+' '+dech+','+decm+','+decs+' '+longitude+' '+latitude
    printf,101,'barytable: '+namelist(i)+': '+year+','+month+','+day+' '+hour+','+minute+','+second+' '+rah+','+ram+','+ras+' '+dech+','+decm+','+decs+' '+longitude+' '+latitude
    printf,3,year+','+month+','+day+' '+hour+','+minute+','+second+' '+rah+','+ram+','+ras+' '+dech+','+decm+','+decs+' '+longitude+' '+latitude
  endfor
  close,2
  close,3
;  close,4
  printf,101,'barytable: new list written. closing program.'

;close logfile
  close,101
endelse
end
