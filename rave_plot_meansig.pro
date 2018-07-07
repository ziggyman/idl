pro rave_plot_meansig,STR_PLOTNAME=str_plotname,$
                      MEANSIGRAVE=meansigrave,$
                      MEANSIGBES=meansigbes,$
                      B_SAMPLES=b_samples,$
                      CALCSAMPLES = calcsamples,$
                      I_NSAMPLES = i_nsamples,$
                      MEANSIGMASAMPLES=meansigmasamples

  if not keyword_set(STR_PAHT) then return
  if not keyword_set(HTML_PATH) then return
  if not keyword_set(STR_PLOTNAME) then return
  if not keyword_set(MEANSIGRAVE) then return
  if not keyword_set(MEANSIGBES) then return
  if not keyword_set(CALCSAMPLES) then return
  if not keyword_set(I_NSAMPLES) then return
  if not keyword_set(MEANSIGMASAMPLES) then return

; --- plot mean_sigma_x_y
  str_gifplotname = strmid(str_plotname,0,strpos(str_plotname,'.',/REVERSE_SEARCH)+1)+"gif"
  set_plot,'ps'
  device,filename=str_plotname,/color
  red = intarr(256)
  green = intarr(256)
  blue = intarr(256)
  for l=0ul, 255 do begin
    if l le 127 then begin
      red(l) = 60 - (2*l)
      green(l) = 2 * l
      blue(l) = 255 - (2 * l)
    end else begin
      blue(l) = 0
      green(l) = 255 - (2 * (l-127))
      red(l) = 2 * (l-127)
    end
    if red(l) lt 0 then red(l) = 0
    if red(l) gt 255 then red(l) = 255
    if green(l) lt 0 then green(l) = 0
    if green(l) gt 255 then green(l) = 255
    if blue(l) lt 0 then blue(l) = 0
    if blue(l) gt 255 then blue(l) = 255
  endfor
  ltab = 0
  modifyct,ltab,'blue-green-red',red,green,blue,file='colors1.tbl'
  plot,[meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1)],$
       [meansigrave(i_plot*2+1,0),meansigrave(i_plot*2+1,0)],$
       xtitle=xtitle,$
       ytitle=ytitle,$
       xrange=[min([meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigbes(i_plot*2+0,0)-meansigbes(i_plot*2+0,1)])-meansigbes(i_plot*2+0,1),max([meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1),meansigbes(i_plot*2,0)+meansigbes(i_plot*2,1)])+meansigbes(i_plot*2+0,1)],$
       yrange=[min([meansigrave(i_plot*2+1,0)-meansigrave(i_plot*2+1,1),meansigbes(i_plot*2+1,0)-meansigbes(i_plot*2+1,1)])-meansigbes(i_plot*2+1,1),max([meansigrave(i_plot*2+1,0)+meansigrave(i_plot*2+1,1),meansigbes(i_plot*2+1,0)+meansigbes(i_plot*2+1,1)])+meansigbes(i_plot*2+1,1)],$
       linestyle=0,$
       thick=3
  loadct,ltab,FILE='colors1.tbl'
  if keyword_set(CALCSAMPLES) and keyword_set(I_NSAMPLES) and n_elements(MEANSIGMASAMPLES) gt 1 then begin
    for m=0,i_nsamples-1 do begin
      oplot,[meansigmasamples(m,0)-meansigmasamples(m,2),meansigmasamples(m,0)+meansigmasamples(m,2)],[meansigmasamples(m,1),meansigmasamples(m,1)],linestyle=2,thick=3,color=254
      oplot,[meansigmasamples(m,0),meansigmasamples(m,0)],[meansigmasamples(m,1)-meansigmasamples(m,3),meansigmasamples(m,1)+meansigmasamples(m,3)],linestyle=2,thick=3,color=254
    endfor
  endif
  oplot,[meansigrave(i_plot*2,0)-meansigrave(i_plot*2,1),meansigrave(i_plot*2,0)+meansigrave(i_plot*2,1)],[meansigrave(i_plot*2+1,0),meansigrave(i_plot*2+1,0)],linestyle=0,thick=6,color=1
  oplot,[meansigrave(i_plot*2,0),meansigrave(i_plot*2,0)],[meansigrave(i_plot*2+1,0)-meansigrave(i_plot*2+1,1),meansigrave(i_plot*2+1,0)+meansigrave(i_plot*2+1,1)],linestyle=0,thick=6,color=1
  oplot,[meansigbes(i_plot*2,0)-meansigbes(i_plot*2,1),meansigbes(i_plot*2,0)+meansigbes(i_plot*2,1)],[meansigbes(i_plot*2+1,0),meansigbes(i_plot*2+1,0)],linestyle=0,thick=6,color=150
  oplot,[meansigbes(i_plot*2,0),meansigbes(i_plot*2,0)],[meansigbes(i_plot*2+1,0)-meansigbes(i_plot*2+1,1),meansigbes(i_plot*2+1,0)+meansigbes(i_plot*2+1,1)],linestyle=0,thick=6,color=150

  device,/close
  set_plot,'x'
  print,'Converting '+str_plotname
  spawn,'ps2gif '+str_plotname+' '+str_gifplotname
  spawn,'rm '+str_plotname
end
