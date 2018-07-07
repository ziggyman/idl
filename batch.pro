pro batch

file=''
openr, lun, 'list',/get_lun
while not EOF(lun) then begin
readf, lun, file

set_plot, 'ps'
device, filename=file+'.eps',bits_per_pixel=4,xsize=15.,ysize=15,/color,encaps=1
read_gif, file,im, R,G,B
tvlct, reverse(R),reverse(G),reverse(B)
tv, im
device, /close
set_plot, 'x'
endwhile

end

