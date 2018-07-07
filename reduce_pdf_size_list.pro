pro reduce_pdf_size_list,str_list
  b_define_path_out = 0

  strarr_filenames = readfiletostrarr(str_list,' ')

  for i=0,n_elements(strarr_filenames)-1 do begin
    if b_define_path_out then begin
      str_path_out = '/home/azuri/entwicklung/tex/thesis/mq/mqthesis_v23/ch5/figs/metallicities'
    end else begin
      str_path_out = strmid(strarr_filenames(i),0,strpos(strarr_filenames(i),'/',/REVERSE_SEARCH))
    endelse
    print,'str_path_out = ',str_path_out
    str_out = str_path_out+strmid(strarr_filenames(i),strpos(strarr_filenames(i),'/',/REVERSE_SEARCH))
    str_out = strmid(str_out,0,strpos(str_out,'.',/REVERSE_SEARCH))+'_small.pdf'
    print,'str_out = ',str_out
;    stop
    if (strarr_filenames(i) ne '') and (strpos(strarr_filenames(i),'_small.pdf') lt 0) then begin
      reduce_pdf_size,strarr_filenames(i),str_out
      if b_define_path_out then $
        spawn,'cp -p '+strarr_filenames(i)+' '+str_path_out
    endif
  endfor
end
