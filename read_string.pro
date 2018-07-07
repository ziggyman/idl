function read_string, file
a=read_ascii(file)
tab=a.field1
ncol=(size(tab))[1]
nlines=(size(tab))[2]
line=''
openr, lun, file,/get_lun
arr=strarr(ncol,nlines)
for i=0,nlines-1 do begin
    readf, lun, line
    len=strlen(line)
    line=strcompress(line)
    len=strlen(line)
    line2=strsplit(line,' ',/extract)
    arr[*,i]=line2
endfor
close, /all
return, arr
end
