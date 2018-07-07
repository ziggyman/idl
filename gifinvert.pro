pro gifinvert,list,path
;this program inverts the colortable of the images given in the list

if n_elements(path) eq 0 then begin
  print,'gifinvert: No file specified, return 0.'
  print,'usage: gifinvert,list_containing_hd-gifs,path_where_the_gifs_can_be_found'
endif else begin 

  file     = ''
  tempfile = ''
  openr, lun, path+list,/get_lun
  while not EOF(lun) do begin
    readf, lun, tempfile
    file = path+tempfile
    set_plot, 'ps'
    device, filename=strmid(file,0,strlen(file)-4)+'.eps',bits_per_pixel=4,xsize=16.8,ysize=16.8,/color,encaps=1
    read_gif, file,im, R,G,B
    tvlct, reverse(R),reverse(G),reverse(B)
    tv, im
    device, /close
    set_plot, 'x'
  endwhile
  close,lun
endelse
end

