pro rave_plot_two_colours,dblarrx,$
                          dblarry,$
                          XYTITLES=xytitles,$
                          TITLE=title

;  str_rave_data_file = '/home/azuri/daten/rave/rave_data/release5/rave_internal_300808.dat'

;  strarr_rave_data = readfiletostrarr(str_rave_data_file,' ')

  if not keyword_set(XYTITLES) then begin
    xytitles = strarr(2)
    xytitles(0) = ''
    xytitles(1) = ''
  endif
  if not keyword_set(TITLE) then begin
    title=''
  end
  plot,dblarrx,dblarry,xtitle=xytitles(0),ytitle=xytitles(1),title=title

end
