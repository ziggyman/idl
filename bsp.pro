From sboehmer@aip.de Thu Jul 13 16:53:01 MET 2000
Received: [ from galaxy.aip.de by dynamo.aip.de (8.9.1/8.9.1) with ESMTP id QAA09517 for <aritter@dynamo>; Thu, 13 Jul 2000 16:53:00 +0200 (METDST)]
Received: [by galaxy.aip.de (8.9.1/8.9.1) id QAA05720 for aritter; Thu, 13 Jul 2000 16:52:59 +0200 (METDST)]
Date: Thu, 13 Jul 2000 16:52:59 +0200 (METDST)
From: Sabine Boehmer <sboehmer@aip.de>
Message-Id: <200007131452.QAA05720@galaxy.aip.de>
To: aritter@aip.de
Subject: file
Mime-Version: 1.0
Content-Type: text/plain; charset=X-roman8
Content-Transfer-Encoding: 7bit
Status: RO

;***********
pro animat
;***********
common alle1,lwert, mwert, base
common hier1, variatg, variatr, variatb, green, red, blue,base4 
common anima1, w1

stopm=0
red=intarr(256)
green=intarr(256)
blue=intarr(256)
variatr=intarr(256)
variatg=intarr(256)
variatb=intarr(256)


for i=0,255 do begin
variatg(i)=i
variatr(i)=255
variatb(i)=0

green(i)=variatg(i)
red(i)=variatr(i)
blue(i)=variatb(i)
endfor

variatg(0)=0
variatr(0)=0
variatb(0)=0

green(0)=variatg(0)
red(0)=variatr(0)
blue(0)=variatb(0)

;lfor i=1,1 do begin
;id=10
;green(122-id+i)=0
;red(122-id+i)=255
;blue(122-id+i)=0
;endfor

base4=widget_base(w1,title="X",/column,tlb_frame_attr=4)
b=widget_button(base4,value="Stop: Oszillation",uvalue=0)
widget_control,/realize,base4
test=1
lauf=110

for m=0,0 do begin
;111111111111111111111111111111111111111111111111111111111111111;
e=widget_event([base4],/nowait)
if(e.id ne 0) then widget_control,e.id, get_uvalue=test

if (test eq 0) then begin
goto, endmarke
endif

for j=0,110,10 do begin
for i=1,127 do begin

   if ((i+j) le 127) then begin
	ib=i+j
   endif else begin
	ib=127
   endelse

  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor
for i=129,255 do begin

   if ((i-j) ge 129) then begin
        ib=i-j
   endif else begin
	ib=127
   endelse
	
  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)


endfor

modifyct,0,'blue-red',red,green,blue,file='~/idl/anima/colors1.tbl'
loadct,0,file='~/idl/anima/colors1.tbl'
s=strcompress(string(lauf),/remove_all)
write_gif,'~/idl/anima/bilder/bild'+s+'.gif',tvrd()
lauf=lauf+1
endfor


;222222222222222222222222222222222222222222222222222222222222222222222;
e=widget_event([base4],/nowait)
if(e.id ne 0) then widget_control,e.id, get_uvalue=test
if (test eq 0) then begin
goto, endmarke
endif


for j=110,0,-10 do begin
for i=1,127 do begin

   if ((i+j) le 127) then begin
	ib=255-(i+j)
   endif else begin
	ib=127
   endelse

  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor

for i=129,255 do begin  

   if ((i-j) ge 129) then begin
        ib=255-(i-j)
   endif else begin
	ib=127
   endelse

  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)
	
endfor

modifyct,0,'blue-red',red,green,blue,file='~/idl/anima/colors1.tbl'
loadct,0,file='~/idl/anima/colors1.tbl'
s=strcompress(string(lauf),/remove_all)
write_gif,'~/idl/anima/bilder/bild'+s+'.gif',tvrd()
lauf=lauf+1
endfor


;3333333333333333333333333333333333333333333333333333333333333333333;

e=widget_event([base4],/nowait)
if(e.id ne 0) then widget_control, e.id, get_uvalue=test
if (test eq 0) then begin
goto, endmarke
endif


for j=0,110,10 do begin
for i=1,127 do begin
  
   if ((i+j) le 127) then begin
	ib=255-(i+j)
   endif else begin
	ib=127
   endelse

  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor

for i=129,255 do begin

   if ((i-j) ge 129) then begin
        ib=255-(i-j)
   endif else begin
	ib=127
   endelse


  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor

modifyct,0,'blue-red',red,green,blue,file='~/idl/anima/colors1.tbl'
loadct,0,file='~/idl/anima/colors1.tbl'
s=strcompress(string(lauf),/remove_all)
write_gif,'~/idl/anima/bilder/bild'+s+'.gif',tvrd()
lauf=lauf+1
endfor


;44444444444444444444444444444444444444444444444444444444444444444444;
e=widget_event([base4],/nowait)
if(e.id ne 0) then widget_control, e.id, get_uvalue=test
if (test eq 0) then begin
goto, endmarke
endif


for j=110,0,-10 do begin
for i=1,127 do begin

   if ((i+j) le 127) then begin
	ib=i+j
   endif else begin
	ib=127
   endelse


  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor

for i=129,255 do begin
    
   if ((i-j) ge 129) then begin
        ib=i-j
   endif else begin
	ib=127
   endelse


  green(i)=variatg(ib)
;  red(i)=variatr(ib)
;  blue(i)=variatb(ib)

endfor

modifyct,0,'blue-red',red,green,blue,file='~/idl/anima/colors1.tbl'
loadct,0,file='~/idl/anima/colors1.tbl'
s=strcompress(string(lauf),/remove_all)
write_gif,'~/idl/anima/bilder/bild'+s+'.gif',tvrd()
lauf=lauf+1
endfor


endfor

endmarke: widget_control, base4,/destroy

if (m eq 20) then begin
widget_control, base,/destroy
exit
endif

end


















