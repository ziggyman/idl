pro sanjib_to_textfile
  str_file_sanjib = '/home/azuri/daten/besancon/sanjib/Survey-0.3-beta/Examples/galaxy1.ebf'
  str_file_text = '/home/azuri/daten/besancon/sanjib.dat'

  read_halo,str_file_sanjib,halo
  dblarr_l = dblarr(n_elements(halo.px))
  dblarr_b = dblarr(n_elements(halo.px))
  dblarr_r = dblarr(n_elements(halo.px))
;  for i=0ul, n_elements(halo.px)-1 do begin
;    ; --- calculate galactic longitude
;;    dblarr_l(i) = acos(scal_prod([1.,0.],;[halo.px(i),halo.py(i)])/radius3(halo.px(i),halo.py(i),0.)) * 360. / (2. * !DPI)
;    dblarr_l(i) = acos(halo.px(i)/radius3(halo.px(i),halo.py(i),0.)) * 360. / (2. * !DPI)
;    if halo.py(i) lt 0. then $
;      dblarr_l(i) = 360. - dblarr_l(i)

    ; --- calculate galactic latitude
;    dblarr_b(i) = acos(scal_prod([halo.py(i),0.],[halo.py(i),halo.pz(i)])/(radius3(halo.py(i),0.,0.) * radius3(halo.py(i),halo.pz(i),0.))) * 360. / (2. * !DPI)
;    dblarr_b(i) = acos(scal_prod([halo.px(i),halo.py(i),halo.pz(i)],[halo.px(i),halo.py(i),0.])/(radius3(halo.px(i),halo.py(i),halo.pz(i)) * radius3(halo.px(i),halo.py(i),0.))) * 360. / (2. * !DPI)
;    if halo.pz(i) lt 0. then $
;      dblarr_b(i) = 0. - dblarr_b(i)
;    if strtrim(string(dblarr_b(i)),2) eq 'NaN' then begin
;      print,'sanjib_to_textfile: i=',i,': halo.px(i) = ',halo.px(i),', halo.py(i) = ',halo.py(i),', halo.pz(i) = ',halo.pz(i),', dblarr_l(i) = ',dblarr_l(i),', dblarr_b(i) = ',dblarr_b(i)
;    endif
;  endfor

  xyz2lbr,halo.px,halo.py,halo.pz,dblarr_l,dblarr_b,dblarr_r,DEG=1

  ; --- only for debugging
  for j=0ul,10 do begin
    print,'px(',j,') = ',halo.px(j),', py(',j,') = ',halo.py(j),', pz(',j,') = ',halo.pz(j)
    print,'l(',j,') = ',dblarr_l(j),', b(',j,') = ',dblarr_b(j)
  endfor

  ; --- print data file
  openw,lun,str_file_text,/GET_LUN
    printf,lun,'#log(Teff) logg Imag vrad M/H l b J-K PopID'
    for i=0ul,n_elements(halo.r)-1 do begin
      b_print = 1

      ; --- remove stars not in RAVE survey
      if dblarr_b(i) gt 60. then $
        b_print = 0
      if dblarr_b(i) gt -25. and dblarr_b(i) lt 25. then begin
        if dblarr_l(i) lt 230. or dblarr_l(i) gt 315. then begin
          if dblarr_b(i) gt -15. and dblarr_b(i) lt 15. then $
            b_print = 0
        end else begin
          ; --- colour cut in specified area
          if halo.cjk(i) lt 0.5 then $
            b_print = 0
        end
      end
      if dblarr_b(i) gt -5. and dblarr_b(i) lt 5. then $
        b_print = 0
      if dblarr_l(i) gt 30. and dblarr_l(i) lt 230. and dblarr_b(i) gt 15. then $
        b_print = 0

      ; --- remove stars with Imag < 9. and > 12.
      if halo.i(i) lt 9. or halo.i(i) gt 12. then begin
        b_print = 0
        print,'sanjib_to_textfile: star i=',i,' removed (Imag = ',halo.i(i),')'
      end

;      if halo.teff(i) gt 5. then begin
;        print,'sanjib_to_textfile: halo.teff(i=',i,') = ',halo.teff(i),', halo.id = ',halo.id(i)
;;        b_print = 0
;      endif

      ; --- print data file
      if b_print then $
        printf,lun,strtrim(string(halo.teff(i)),2)+' '+strtrim(string(halo.logg(i)),2)+' '+strtrim(string(halo.i(i)),2)+' '+strtrim(string(halo.vrad(i)),2)+' '+strtrim(string(halo.feh(i)),2)+' '+strtrim(string(dblarr_l(i)),2)+' '+strtrim(string(dblarr_b(i)),2)+' '+strtrim(string(halo.cjk(i)),2)+' '+strtrim(string(halo.id(i)),2)+' '+strtrim(string(dblarr_r(i)),2)
    endfor
  free_lun,lun
end
