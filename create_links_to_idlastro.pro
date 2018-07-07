;###########################
pro create_links_to_idlastro,filename
;###########################

  if n_elements(filename) eq 0 then $
    print,'CREATE_LINKS_TO_IDL_ASTRO: No file specified, return 0.' $
  else begin
    nfiles = countlines(filename)
    file = ''
    openr,lun,filename,/GET_LUN
      for i=0,nfiles-1 do begin
        readf,lun,file
        file = strtrim(file,2)
        link = strmid(file,strpos(file,'/',/REVERSE_SEARCH)+1)
        print,'starting ln -s '+file+' '+link
        spawn,'ln -s '+file+' '+link
      endfor
    free_lun,lun
  end
end
