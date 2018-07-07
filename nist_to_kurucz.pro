pro nist_to_kurucz,nistlines,outfile
;
; NAME:                  nist_to_kurucz.pro
; PURPOSE:               converts NIST-line lists to Kurucz format
; CATEGORY:              data reduction
; CALLING SEQUENCE:      nist_to_kurucz,nistlines,outfile
; INPUTS:                *nistlines (LONG line list from NIST):
;                           ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                          Spectrum  |     Observed  |     Rel. |    Aki    |  log_gf | Acc. |        Ei           Ek        |                Configurations                 |        Terms                |  Ji   Jk  | gi   gk |Type|
;                                    |    Wavelength |     Int. |    s^-1   |         |      |      (cm-1)       (cm-1)      |                                               |                             |           |         |    |
;                                    |     Air  (Å)  |     (?)  |           |         |      |                               |                                               |                             |           |         |    |
;                           ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                    |               |          |           |         |      |                               |                                               |                             |           |         |    |
;                          W I       |     5880.21   |       10 |           |         |      |  34121.68     -   51123.14    |                       - 5d4.6s.(6D).7s        |        * - 5D               |   4 - 4   |  9 - 9  |    |
;                           ...
;
;                        *outfile (input for ATLAS synthe):
;                              500.0098 -2.896 25.00   37630.620  4.5 (3G)4s b4G   57624.650  3.5 7S)s9p 8P   7.12 -6.17 -7.78K88  0 0  0 0.000  0 0.000    0    0           1163  677
;                              500.0113 -6.266 22.00    8602.342  2.0 s2 a3P       28596.312  1.0 (4F)4p y5F  8.08 -5.46 -7.77K    0 0  0 0.000  0 0.000    0    0           1490    0
;                              ...
;
; COPYRIGHT:             Andreas Ritter
; DATE:                  15.01.2008
;
;                        headline
;                        feetline (up to now not used)
;

;-- test arguments
if strlen(outfile) eq 0 then begin
  print,'ERROR: no filename specified!'
  print,'Usage: nist_to_kurucz,nistlines,outfile'
  print,"Example: nist_to_kurucz,'/home/azuri/daten/atomic_line_list/nist/5880-5900_long.dat','/home/azuri/daten/atomic_line_list/nist/5880-5900_long_kurucz.dat'"
endif else begin

; -- number of references
  i_nref = 0
; -- number of header lines
  i_nhead = 6

  i_nlines = countlines(nistlines)
  print,'i_nlines = ',i_nlines
  i_nondatalines = i_nref + i_nhead + 2
  i_empty_lines = 0UL
  i_empty_lines = (i_nlines - i_nondatalines) / 6
  print,'i_empty_lines = ',i_empty_lines
  i_nondatalines = i_nondatalines + i_empty_lines
  print,'i_nondatalines = ',i_nondatalines
  i_arrlength = i_nlines - i_nondatalines
  print,'i_arrlength = ',i_arrlength
; -- define arrays
  ; -- element ion
  sarr_element = strarr(i_arrlength)
  str_element_name = ''
  str_element_ion = ''

  ; -- wavelength (Angstroems)
  darr_wavelength = dblarr(i_arrlength)

  ; -- relative intensity
  darr_rel_intens = intarr(i_arrlength)

  ; -- Aki
  darr_Aki = dblarr(i_arrlength)

  ; -- log(gf)
  darr_loggf = dblarr(i_arrlength)

  ; -- Excitation low
  darr_exc_low = dblarr(i_arrlength)

  ; -- Excitation up
  darr_exc_up = dblarr(i_arrlength)

  ; -- Configurations low
  sarr_config_low = strarr(i_arrlength)

  ; -- Configurations up
  sarr_config_up = strarr(i_arrlength)

  ; -- Terms
  sarr_terms = strarr(i_arrlength)

  ; -- J low
  darr_j_low = dblarr(i_arrlength)

  ; -- J up
  darr_j_up = dblarr(i_arrlength)

  ; -- Lande factor lower
;  darr_lande_lower = dblarr(i_arrlength)

  ; -- Lande factor upper
;  darr_lande_upper = dblarr(i_arrlength)

  ; -- Lande factor mean
;  darr_lande_mean = dblarr(i_arrlength)

  ; -- Damping Rad.
;  darr_damping_rad = dblarr(i_arrlength)

  ; -- Damping Stark
;  darr_damping_stark = dblarr(i_arrlength)

  ; -- Damping van der Waals
;  darr_damping_waals = dblarr(i_arrlength)

  ; -- References
;  sarr_references = strarr(i_arrlength)

;-- read NIST-line list (inputfile 'nistlines')
  openr,lun,nistlines,/GET_LUN
;  -- read header
  templine = ''
  for i=0,i_nhead-1 do begin
    readf,lun,templine
  endfor

;  -- read data
  i_ielement = 0
  j = 0
  tempstr = ''
  for i=0,i_arrlength+i_empty_lines-1 do begin
    ; -- line data
;    print,'reading element ',i_ielement
    readf,lun,templine
;    templine = strmid(templine,strpos(templine,"'")+1)
;    if i eq 0 then print,'templine = ',templine
    str_element = strtrim(strmid(templine,0,strpos(templine,"|")),2)
    if i eq 0 then print,'str_element = ',str_element

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    darr_wavelength(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
    if i eq 0 then print,'wavelength(',i_ielement,') = ',darr_wavelength(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    darr_rel_intens(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
    if i eq 0 then print,'darr_rel_intens(',i_ielement,') = ',darr_rel_intens(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    darr_Aki(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
    if i eq 0 then print,'darr_Aki(',i_ielement,') = ',darr_Aki(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    tempstr = strtrim(strmid(templine,0,strpos(templine,'|')),2)
    if n_elements(tempstr) ne 0 then $
      darr_loggf(i_ielement) = tempstr $
    else $
      darr_loggf(i_ielement) = 0.
    if i eq 0 then print,'log_gf(',i_ielement,') = ',darr_loggf(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    if strpos(templine,'-') ne (-1) and strpos(templine,'-') lt strpos(templine,'|') then begin
      darr_exc_low(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'-')),2)
      if i eq 0 then print,'darr_exc_low(',i_ielement,') = ',darr_exc_low(i_ielement)

      templine = strtrim(strmid(templine,strpos(templine,'-')+1),2)
;      if i eq 0 then print,'templine = ',templine
      darr_exc_up(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
      if i eq 0 then print,'darr_exc_up(',i_ielement,') = ',darr_exc_up(i_ielement)
    endif

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    if strpos(templine,'-') ne (-1) and strpos(templine,'-') lt strpos(templine,'|') then begin
      sarr_config_low(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'-')),2)
      if i eq 0 then print,'sarr_config_low(',i_ielement,') = ',sarr_config_low(i_ielement)

      templine = strtrim(strmid(templine,strpos(templine,'-')+1),2)
;      if i eq 0 then print,'templine = ',templine
      sarr_config_up(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
      if i eq 0 then print,'sarr_config_up(',i_ielement,') = ',sarr_config_up(i_ielement)
    endif

    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if i eq 0 then print,'templine = ',templine
    if strpos(templine,'-') ne (-1) and strpos(templine,'-') lt strpos(templine,'|') then begin
      darr_j_low(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'-')),2)
      if i eq 0 then print,'darr_j_low(',i_ielement,') = ',darr_j_low(i_ielement)

      templine = strtrim(strmid(templine,strpos(templine,'-')+1),2)
;      if i eq 0 then print,'templine = ',templine
      darr_j_up(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
      if i eq 0 then print,'darr_j_up(',i_ielement,') = ',darr_j_up(i_ielement)
    endif

;    templine = strtrim(strmid(templine,strpos(templine,'|')+1),2)
;    if strpos(templine,'-') ne (-1) and strpos(templine,'-') lt strpos(templine,'|') then begin
;      darr_lande_lower(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'-')),2)

;      templine = strtrim(strmid(templine,strpos(templine,'-')+1),2)
;      darr_lande_upper(i_ielement) = strtrim(strmid(templine,0,strpos(templine,'|')),2)
;    endif

;    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    darr_lande_mean(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

;    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    darr_damping_rad(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_rad(i_ielement)) lt 0.00000001 then darr_damping_rad(i_ielement) = 1.

;    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    darr_damping_stark(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_stark(i_ielement)) lt 0.00000001 then darr_damping_stark(i_ielement) = 1.

;    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    darr_damping_waals(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_waals(i_ielement)) lt 0.00000001 then darr_damping_waals(i_ielement) = 1.

; -- references
;    readf,lun,templine
;    templine = strtrim(strmid(templine,strpos(templine,"'")+1),2)
;    sarr_references(i_ielement) = strtrim(strmid(templine,0,strpos(templine,"'",/REVERSE_SEARCH)),2)

    ; --- convert element name
    str_element_name = strmid(str_element,0,strpos(str_element,' '))
    str_element_ion = strmid(str_element,strpos(str_element,' ')+1)
    print,'str_element_name = ',str_element_name
    print,'str_element_ion = ',str_element_ion
    if str_element_name eq 'H' then sarr_element(i_ielement) = 1. $
    else if str_element_name eq 'He' then sarr_element(i_ielement) = 2. $
    else if str_element_name eq 'Li' then sarr_element(i_ielement) = 3. $
    else if str_element_name eq 'Be' then sarr_element(i_ielement) = 4. $
    else if str_element_name eq 'B' then sarr_element(i_ielement) = 5. $
    else if str_element_name eq 'C' then sarr_element(i_ielement) = 6. $
    else if str_element_name eq 'N' then sarr_element(i_ielement) = 7. $
    else if str_element_name eq 'O' then sarr_element(i_ielement) = 8. $
    else if str_element_name eq 'F' then sarr_element(i_ielement) = 9. $
    else if str_element_name eq 'Ne' then sarr_element(i_ielement) = 10. $
    else if str_element_name eq 'Na' then sarr_element(i_ielement) = 11. $
    else if str_element_name eq 'Mg' then sarr_element(i_ielement) = 12. $
    else if str_element_name eq 'Al' then sarr_element(i_ielement) = 13. $
    else if str_element_name eq 'Si' then sarr_element(i_ielement) = 14. $
    else if str_element_name eq 'P' then sarr_element(i_ielement) = 15. $
    else if str_element_name eq 'S' then sarr_element(i_ielement) = 16. $
    else if str_element_name eq 'Cl' then sarr_element(i_ielement) = 17. $
    else if str_element_name eq 'Ar' then sarr_element(i_ielement) = 18. $
    else if str_element_name eq 'K' then sarr_element(i_ielement) = 19. $
    else if str_element_name eq 'Ca' then sarr_element(i_ielement) = 20. $
    else if str_element_name eq 'Sc' then sarr_element(i_ielement) = 21. $
    else if str_element_name eq 'Ti' then sarr_element(i_ielement) = 22. $
    else if str_element_name eq 'V' then sarr_element(i_ielement) = 23. $
    else if str_element_name eq 'Cr' then sarr_element(i_ielement) = 24. $
    else if str_element_name eq 'Mn' then sarr_element(i_ielement) = 25. $
    else if str_element_name eq 'Fe' then sarr_element(i_ielement) = 26. $
    else if str_element_name eq 'Co' then sarr_element(i_ielement) = 27. $
    else if str_element_name eq 'Ni' then sarr_element(i_ielement) = 28. $
    else if str_element_name eq 'Cu' then sarr_element(i_ielement) = 29. $
    else if str_element_name eq 'Zn' then sarr_element(i_ielement) = 30. $
    else if str_element_name eq 'Ga' then sarr_element(i_ielement) = 31. $
    else if str_element_name eq 'Ge' then sarr_element(i_ielement) = 32. $
    else if str_element_name eq 'As' then sarr_element(i_ielement) = 33. $
    else if str_element_name eq 'Se' then sarr_element(i_ielement) = 34. $
    else if str_element_name eq 'Br' then sarr_element(i_ielement) = 35. $
    else if str_element_name eq 'Kr' then sarr_element(i_ielement) = 36. $
    else if str_element_name eq 'Rb' then sarr_element(i_ielement) = 37. $
    else if str_element_name eq 'Sr' then sarr_element(i_ielement) = 38. $
    else if str_element_name eq 'Y' then sarr_element(i_ielement) = 39. $
    else if str_element_name eq 'Zr' then sarr_element(i_ielement) = 40. $
    else if str_element_name eq 'Nb' then sarr_element(i_ielement) = 41. $
    else if str_element_name eq 'Mo' then sarr_element(i_ielement) = 42. $
    else if str_element_name eq 'Tc' then sarr_element(i_ielement) = 43. $
    else if str_element_name eq 'Ru' then sarr_element(i_ielement) = 44. $
    else if str_element_name eq 'Rh' then sarr_element(i_ielement) = 45. $
    else if str_element_name eq 'Pd' then sarr_element(i_ielement) = 46. $
    else if str_element_name eq 'Ag' then sarr_element(i_ielement) = 47. $
    else if str_element_name eq 'Cd' then sarr_element(i_ielement) = 48. $
    else if str_element_name eq 'In' then sarr_element(i_ielement) = 49. $
    else if str_element_name eq 'Sn' then sarr_element(i_ielement) = 50. $
    else if str_element_name eq 'Sb' then sarr_element(i_ielement) = 51. $
    else if str_element_name eq 'Te' then sarr_element(i_ielement) = 52. $
    else if str_element_name eq 'I' then sarr_element(i_ielement) = 53. $
    else if str_element_name eq 'Xe' then sarr_element(i_ielement) = 54. $
    else if str_element_name eq 'Cs' then sarr_element(i_ielement) = 55. $
    else if str_element_name eq 'Ba' then sarr_element(i_ielement) = 56. $
    else if str_element_name eq 'La' then sarr_element(i_ielement) = 57. $
    else if str_element_name eq 'Ce' then sarr_element(i_ielement) = 58. $
    else if str_element_name eq 'Pr' then sarr_element(i_ielement) = 59. $
    else if str_element_name eq 'Nd' then sarr_element(i_ielement) = 60. $
    else if str_element_name eq 'Pm' then sarr_element(i_ielement) = 61. $
    else if str_element_name eq 'Sm' then sarr_element(i_ielement) = 62. $
    else if str_element_name eq 'Eu' then sarr_element(i_ielement) = 63. $
    else if str_element_name eq 'Gd' then sarr_element(i_ielement) = 64. $
    else if str_element_name eq 'Tb' then sarr_element(i_ielement) = 65. $
    else if str_element_name eq 'Dy' then sarr_element(i_ielement) = 66. $
    else if str_element_name eq 'Ho' then sarr_element(i_ielement) = 67. $
    else if str_element_name eq 'Er' then sarr_element(i_ielement) = 68. $
    else if str_element_name eq 'Tm' then sarr_element(i_ielement) = 69. $
    else if str_element_name eq 'Yb' then sarr_element(i_ielement) = 70. $
    else if str_element_name eq 'Ac' then sarr_element(i_ielement) = 71. $
    else if str_element_name eq 'Th' then sarr_element(i_ielement) = 72. $
    else if str_element_name eq 'Pa' then sarr_element(i_ielement) = 73. $
    else if str_element_name eq 'U' then sarr_element(i_ielement) = 74. $
    else if str_element_name eq 'Np' then sarr_element(i_ielement) = 75. $
    else if str_element_name eq 'Pu' then sarr_element(i_ielement) = 76. $
    else if str_element_name eq 'Am' then sarr_element(i_ielement) = 77. $
    else if str_element_name eq 'Cm' then sarr_element(i_ielement) = 78. $
    else if str_element_name eq 'Bk' then sarr_element(i_ielement) = 79. $
    else if str_element_name eq 'Cf' then sarr_element(i_ielement) = 80. $
    else if str_element_name eq 'Es' then sarr_element(i_ielement) = 81. $
    else if str_element_name eq 'Fm' then sarr_element(i_ielement) = 82. $
    else if str_element_name eq 'Md' then sarr_element(i_ielement) = 83. $
    else if str_element_name eq 'No' then sarr_element(i_ielement) = 84. $
    else if str_element_name eq 'Lu' then sarr_element(i_ielement) = 85. $
    else if str_element_name eq 'Hf' then sarr_element(i_ielement) = 86. $
    else if str_element_name eq 'Ta' then sarr_element(i_ielement) = 87. $
    else if str_element_name eq 'W' then sarr_element(i_ielement) = 88. $
    else if str_element_name eq 'Re' then sarr_element(i_ielement) = 89. $
    else if str_element_name eq 'Os' then sarr_element(i_ielement) = 90. $
    else if str_element_name eq 'Ir' then sarr_element(i_ielement) = 91. $
    else if str_element_name eq 'Pt' then sarr_element(i_ielement) = 92. $
    else if str_element_name eq 'Au' then sarr_element(i_ielement) = 93. $
    else if str_element_name eq 'Hg' then sarr_element(i_ielement) = 94. $
    else if str_element_name eq 'Tl' then sarr_element(i_ielement) = 95. $
    else if str_element_name eq 'Pb' then sarr_element(i_ielement) = 96. $
    else if str_element_name eq 'Bi' then sarr_element(i_ielement) = 97. $
    else if str_element_name eq 'Po' then sarr_element(i_ielement) = 98. $
    else if str_element_name eq 'At' then sarr_element(i_ielement) = 99. $
    else if str_element_name eq 'Rn' then sarr_element(i_ielement) = 100. $
    else if str_element_name eq 'Fr' then sarr_element(i_ielement) = 101. $
    else if str_element_name eq 'Ra' then sarr_element(i_ielement) = 102. $
    else if str_element_name eq 'Lr' then sarr_element(i_ielement) = 103. $
    else if str_element_name eq 'Rf' then sarr_element(i_ielement) = 104. $
    else if str_element_name eq 'Db' then sarr_element(i_ielement) = 105. $
    else if str_element_name eq 'Sg' then sarr_element(i_ielement) = 106. $
    else if str_element_name eq 'Bh' then sarr_element(i_ielement) = 107. $
    else if str_element_name eq 'Hs' then sarr_element(i_ielement) = 108. $
    else if str_element_name eq 'Mt' then sarr_element(i_ielement) = 109. $
    else if str_element_name eq 'Uun' then sarr_element(i_ielement) = 110. $
    else if str_element_name eq 'Uuu' then sarr_element(i_ielement) = 111. $
    else if str_element_name eq 'Uub' then sarr_element(i_ielement) = 112. $
    else if str_element_name eq 'Uut' then sarr_element(i_ielement) = 113. $
    else if str_element_name eq 'Uuq' then sarr_element(i_ielement) = 114. $
    else if str_element_name eq 'Uup' then sarr_element(i_ielement) = 115. $
    else if str_element_name eq 'Uuh' then sarr_element(i_ielement) = 116. $
    else if str_element_name eq 'Uus' then sarr_element(i_ielement) = 117. $
    else if str_element_name eq 'Uuo' then sarr_element(i_ielement) = 118. $
    else begin
      sarr_element(i_ielement) = 0.
      print,'WARNING: Element No ',i_ielement,': Element "'+str_element+'" not found!!!'
    endelse

    if str_element_ion eq 'I' then sarr_element(i_ielement) = sarr_element(i_ielement)+'00' $
    else if str_element_ion eq 'II' then sarr_element(i_ielement) = sarr_element(i_ielement)+.01 $
    else if str_element_ion eq 'III' then sarr_element(i_ielement) = sarr_element(i_ielement)+.02 $
    else if str_element_ion eq 'IV' then sarr_element(i_ielement) = sarr_element(i_ielement)+.03 $
    else if str_element_ion eq 'V' then sarr_element(i_ielement) = sarr_element(i_ielement)+.04 $
    else if str_element_ion eq 'VI' then sarr_element(i_ielement) = sarr_element(i_ielement)+.05 $
    else if str_element_ion eq 'VII' then sarr_element(i_ielement) = sarr_element(i_ielement)+.06 $
    else if str_element_ion eq 'VIII' then sarr_element(i_ielement) = sarr_element(i_ielement)+.07 $
    else if str_element_ion eq 'IX' then sarr_element(i_ielement) = sarr_element(i_ielement)+.08 $
    else if str_element_ion eq 'X' then sarr_element(i_ielement) = sarr_element(i_ielement)+.09 $
    else if str_element_ion eq 'XI' then sarr_element(i_ielement) = sarr_element(i_ielement)+.10 $
    else if str_element_ion eq 'XII' then sarr_element(i_ielement) = sarr_element(i_ielement)+.11 $
    else if str_element_ion eq 'XIII' then sarr_element(i_ielement) = sarr_element(i_ielement)+.12 $
    else if str_element_ion eq 'XIV' then sarr_element(i_ielement) = sarr_element(i_ielement)+.13 $
    else if str_element_ion eq 'XV' then sarr_element(i_ielement) = sarr_element(i_ielement)+.14 $
    else if str_element_ion eq 'XVI' then sarr_element(i_ielement) = sarr_element(i_ielement)+.15 $
    else begin
      sarr_element(i_ielement) = sarr_element(i_ielement)+'99'
      print,'WARNING: Element No ',i_ielement,': Ion ',str_element_ion,' not found!'
    endelse
    print,'sarr_element(',i_ielement,') = ',sarr_element(i_ielement)
    i_ielement = i_ielement + 1
    j = j + 1
    if j eq 5 then begin
      readf,lun,templine
      i = i + 1
      j = 0
    endif
  endfor
  free_lun,lun
; -- convert units
  darr_wavelength = darr_wavelength / 10.
;  darr_exc_low = darr_exc_low * 8062.4
;  darr_exc_up  = darr_exc_up * 8062.4
;  darr_damping_rad = alog10(darr_damping_rad)
;  darr_damping_stark = alog10(darr_damping_stark)
;  darr_damping_waals = alog10(darr_damping_waals)

  print,'element(',i_ielement-1,') = ',sarr_element(i_ielement-1)
  print,'wavelength(',i_ielement-1,') = ',darr_wavelength(i_ielement-1)
  print,'log_gf(',i_ielement-1,') = ',darr_loggf(i_ielement-1)
  print,'exc. low(',i_ielement-1,') = ',darr_exc_low(i_ielement-1)
  print,'j low(',i_ielement-1,') = ',darr_j_low(i_ielement-1)
  print,'exc. up(',i_ielement-1,') = ',darr_exc_up(i_ielement-1)
  print,'j up(',i_ielement-1,') = ',darr_j_up(i_ielement-1)
;  print,'lande lower(',i_ielement-1,') = ',darr_lande_lower(i_ielement-1)
;  print,'lande upper(',i_ielement-1,') = ',darr_lande_upper(i_ielement-1)
;  print,'lande mean(',i_ielement-1,') = ',darr_lande_mean(i_ielement-1)
;  print,'damping rad(',i_ielement-1,') = ',darr_damping_rad(i_ielement-1)
;  print,'damping stark(',i_ielement-1,') = ',darr_damping_stark(i_ielement-1)
;  print,'damping waals(',i_ielement-1,') = ',darr_damping_waals(i_ielement-1)
;  print,'references(',i_ielement-1,') = ',sarr_references(i_ielement-1)

; -- write outfile
  str_outline = ''
  openw,lun,outfile,/GET_LUN
  for i=0,i_ielement-1 do begin
    printf,lun,darr_wavelength(i),$
               darr_loggf(i),$
               sarr_element(i),$
               darr_exc_low(i),$
               darr_j_low(i),$
               darr_exc_up(i),$
               darr_j_up(i),$
 ;              darr_damping_rad(i),$
 ;              darr_damping_stark(i),$
 ;              darr_damping_waals(i),$
               FORMAT='(" ",F10.4,F7.3,F6.2,F12.3,F5.1," *         ",F12.3,F5.1," *           0.00  0.00  0.00     0 0  0 0.000  0 0.000    0    0              0    0")'
  endfor
  free_lun,lun
endelse
end
