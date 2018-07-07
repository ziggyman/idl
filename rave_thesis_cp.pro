pro rave_thesis_cp
  str_filelist = '/home/azuri/daten/rave/calibration/latest.list'
  str_dir = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch5/figs/'

  strarr_filenames = readfiletostrarr(str_filelist,' ')
  for i=0ul, n_elements(strarr_filenames)-1 do begin
    spawn,'cp -p '+strmid(str_filelist,0,strpos(str_filelist,'/',/REVERSE_SEARCH)+1) + strarr_filenames(i) + ' ' + str_dir
  endfor
end
