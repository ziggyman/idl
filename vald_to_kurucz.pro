pro vald_to_kurucz,valdlines,outfile
;
; NAME:                  vald_to_kurucz.pro
; PURPOSE:               converts VALD-line lists to Kurucz format
; CATEGORY:              data reduction
; CALLING SEQUENCE:      vald_to_kurucz,valdlines,outfile
; INPUTS:                *valdlines (LONG line list from VALD):
;                                                                                       Lande factors     Damping parameters
;                          Elm Ion  WL(A)     log(gf) Exc. lo   J lo Exc. up   J up  lower upper  mean   Rad.   Stark  Waals
;                          'Fe 1', 5880.0272, -1.940,  4.5580,  3.0,  6.6660,  4.0, 1.660, 1.230, 0.570, 8.430,-5.410,-7.194,
;                                   '   y5P       f5G C     MFW       1   1   1   1   2   2   2   3   1'
;                          'Pr 3', 5880.0370, -3.730, 12.4380,  4.5, 14.5460,  5.5, 0.940, 1.050, 1.300, 0.000, 0.000, 0.000,
;                                   '                           DRM   4   4   4   4   4   4   4   4   4'
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
  print,'Usage: vald_to_kurucz,valdlines,outfile'
  print,"Example: vald_to_kurucz,'/home/azuri/daten/atomic_line_list/vald/5880-5900_long.dat','/home/azuri/daten/atomic_line_list/vald/5880-5900_long_kurucz.dat'"
endif else begin

; -- number of references
  i_nref = 53
; -- number of header lines
  i_nhead = 2

  i_nlines = countlines(valdlines)
  print,'i_nlines = ',i_nlines
  i_nondatalines = i_nref + i_nhead + 1
  print,'i_nondatalines = ',i_nondatalines
  i_arrlength = (i_nlines - i_nondatalines) / 2
  print,'i_arrlength = ',i_arrlength
; -- define arrays
  ; -- element ion
  darr_element = dblarr(i_arrlength)
  str_element_name = ''
  i_element_ion = 0

  ; -- wavelength (Angstroems)
  darr_wavelength = dblarr(i_arrlength)

  ; -- log(gf)
  darr_loggf = dblarr(i_arrlength)

  ; -- Excitation low
  darr_exc_low = dblarr(i_arrlength)

  ; -- J low
  darr_j_low = dblarr(i_arrlength)

  ; -- Excitation up
  darr_exc_up = dblarr(i_arrlength)

  ; -- J up
  darr_j_up = dblarr(i_arrlength)

  ; -- Lande factor lower
  darr_lande_lower = dblarr(i_arrlength)

  ; -- Lande factor upper
  darr_lande_upper = dblarr(i_arrlength)

  ; -- Lande factor mean
  darr_lande_mean = dblarr(i_arrlength)

  ; -- Damping Rad.
  darr_damping_rad = dblarr(i_arrlength)

  ; -- Damping Stark
  darr_damping_stark = dblarr(i_arrlength)

  ; -- Damping van der Waals
  darr_damping_waals = dblarr(i_arrlength)

  ; -- References
  sarr_references = strarr(i_arrlength)

;-- read VALD-line list (inputfile 'valdlines')
  openr,lun,valdlines,/GET_LUN
;  -- read header
  templine = ''
  readf,lun,templine
  readf,lun,templine
;  -- read data
  i_ielement = 0
  for i=2,i_nlines-i_nref-2 do begin
    ; -- line data
;    print,'reading element ',i_ielement
    readf,lun,templine
    templine = strmid(templine,strpos(templine,"'")+1)
;    if i eq 2 then print,'templine = ',templine
    str_element = strmid(templine,0,strpos(templine,"'"))
;    if i eq 2 then print,'element(',i_ielement,') = ',darr_element(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    if i eq 2 then print,'templine = ',templine
    darr_wavelength(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if i eq 2 then print,'wavelength(',i_ielement,') = ',darr_wavelength(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    if i eq 2 then print,'templine = ',templine
    darr_loggf(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if i eq 2 then print,'log_gf(',i_ielement,') = ',darr_loggf(i_ielement)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
;    if i eq 2 then print,'templine = ',templine
    darr_exc_low(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_j_low(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_exc_up(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_j_up(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_lande_lower(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_lande_upper(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_lande_mean(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_damping_rad(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_rad(i_ielement)) lt 0.00000001 then darr_damping_rad(i_ielement) = 1.

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_damping_stark(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_stark(i_ielement)) lt 0.00000001 then darr_damping_stark(i_ielement) = 1.

    templine = strtrim(strmid(templine,strpos(templine,',')+1),2)
    darr_damping_waals(i_ielement) = strtrim(strmid(templine,0,strpos(templine,',')),2)
;    if abs(darr_damping_waals(i_ielement)) lt 0.00000001 then darr_damping_waals(i_ielement) = 1.

; -- references
    readf,lun,templine
    templine = strtrim(strmid(templine,strpos(templine,"'")+1),2)
    sarr_references(i_ielement) = strtrim(strmid(templine,0,strpos(templine,"'",/REVERSE_SEARCH)),2)

    ; --- convert element name
    str_element_name = strmid(str_element,0,strpos(str_element,' '))
    i_element_ion = strmid(str_element,strpos(str_element,' ')+1)
    if str_element_name eq 'H' then darr_element(i_ielement) = 1. $
    else if str_element_name eq 'He' then darr_element(i_ielement) = 2. $
    else if str_element_name eq 'Li' then darr_element(i_ielement) = 3. $
    else if str_element_name eq 'Be' then darr_element(i_ielement) = 4. $
    else if str_element_name eq 'B' then darr_element(i_ielement) = 5. $
    else if str_element_name eq 'C' then darr_element(i_ielement) = 6. $
    else if str_element_name eq 'N' then darr_element(i_ielement) = 7. $
    else if str_element_name eq 'O' then darr_element(i_ielement) = 8. $
    else if str_element_name eq 'F' then darr_element(i_ielement) = 9. $
    else if str_element_name eq 'Ne' then darr_element(i_ielement) = 10. $
    else if str_element_name eq 'Na' then darr_element(i_ielement) = 11. $
    else if str_element_name eq 'Mg' then darr_element(i_ielement) = 12. $
    else if str_element_name eq 'Al' then darr_element(i_ielement) = 13. $
    else if str_element_name eq 'Si' then darr_element(i_ielement) = 14. $
    else if str_element_name eq 'P' then darr_element(i_ielement) = 15. $
    else if str_element_name eq 'S' then darr_element(i_ielement) = 16. $
    else if str_element_name eq 'Cl' then darr_element(i_ielement) = 17. $
    else if str_element_name eq 'Ar' then darr_element(i_ielement) = 18. $
    else if str_element_name eq 'K' then darr_element(i_ielement) = 19. $
    else if str_element_name eq 'Ca' then darr_element(i_ielement) = 20. $
    else if str_element_name eq 'Sc' then darr_element(i_ielement) = 21. $
    else if str_element_name eq 'Ti' then darr_element(i_ielement) = 22. $
    else if str_element_name eq 'V' then darr_element(i_ielement) = 23. $
    else if str_element_name eq 'Cr' then darr_element(i_ielement) = 24. $
    else if str_element_name eq 'Mn' then darr_element(i_ielement) = 25. $
    else if str_element_name eq 'Fe' then darr_element(i_ielement) = 26. $
    else if str_element_name eq 'Co' then darr_element(i_ielement) = 27. $
    else if str_element_name eq 'Ni' then darr_element(i_ielement) = 28. $
    else if str_element_name eq 'Cu' then darr_element(i_ielement) = 29. $
    else if str_element_name eq 'Zn' then darr_element(i_ielement) = 30. $
    else if str_element_name eq 'Ga' then darr_element(i_ielement) = 31. $
    else if str_element_name eq 'Ge' then darr_element(i_ielement) = 32. $
    else if str_element_name eq 'As' then darr_element(i_ielement) = 33. $
    else if str_element_name eq 'Se' then darr_element(i_ielement) = 34. $
    else if str_element_name eq 'Br' then darr_element(i_ielement) = 35. $
    else if str_element_name eq 'Kr' then darr_element(i_ielement) = 36. $
    else if str_element_name eq 'Rb' then darr_element(i_ielement) = 37. $
    else if str_element_name eq 'Sr' then darr_element(i_ielement) = 38. $
    else if str_element_name eq 'Y' then darr_element(i_ielement) = 39. $
    else if str_element_name eq 'Zr' then darr_element(i_ielement) = 40. $
    else if str_element_name eq 'Nb' then darr_element(i_ielement) = 41. $
    else if str_element_name eq 'Mo' then darr_element(i_ielement) = 42. $
    else if str_element_name eq 'Tc' then darr_element(i_ielement) = 43. $
    else if str_element_name eq 'Ru' then darr_element(i_ielement) = 44. $
    else if str_element_name eq 'Rh' then darr_element(i_ielement) = 45. $
    else if str_element_name eq 'Pd' then darr_element(i_ielement) = 46. $
    else if str_element_name eq 'Ag' then darr_element(i_ielement) = 47. $
    else if str_element_name eq 'Cd' then darr_element(i_ielement) = 48. $
    else if str_element_name eq 'In' then darr_element(i_ielement) = 49. $
    else if str_element_name eq 'Sn' then darr_element(i_ielement) = 50. $
    else if str_element_name eq 'Sb' then darr_element(i_ielement) = 51. $
    else if str_element_name eq 'Te' then darr_element(i_ielement) = 52. $
    else if str_element_name eq 'I' then darr_element(i_ielement) = 53. $
    else if str_element_name eq 'Xe' then darr_element(i_ielement) = 54. $
    else if str_element_name eq 'Cs' then darr_element(i_ielement) = 55. $
    else if str_element_name eq 'Ba' then darr_element(i_ielement) = 56. $
    else if str_element_name eq 'La' then darr_element(i_ielement) = 57. $
    else if str_element_name eq 'Ce' then darr_element(i_ielement) = 58. $
    else if str_element_name eq 'Pr' then darr_element(i_ielement) = 59. $
    else if str_element_name eq 'Nd' then darr_element(i_ielement) = 60. $
    else if str_element_name eq 'Pm' then darr_element(i_ielement) = 61. $
    else if str_element_name eq 'Sm' then darr_element(i_ielement) = 62. $
    else if str_element_name eq 'Eu' then darr_element(i_ielement) = 63. $
    else if str_element_name eq 'Gd' then darr_element(i_ielement) = 64. $
    else if str_element_name eq 'Tb' then darr_element(i_ielement) = 65. $
    else if str_element_name eq 'Dy' then darr_element(i_ielement) = 66. $
    else if str_element_name eq 'Ho' then darr_element(i_ielement) = 67. $
    else if str_element_name eq 'Er' then darr_element(i_ielement) = 68. $
    else if str_element_name eq 'Tm' then darr_element(i_ielement) = 69. $
    else if str_element_name eq 'Yb' then darr_element(i_ielement) = 70. $
    else if str_element_name eq 'Ac' then darr_element(i_ielement) = 71. $
    else if str_element_name eq 'Th' then darr_element(i_ielement) = 72. $
    else if str_element_name eq 'Pa' then darr_element(i_ielement) = 73. $
    else if str_element_name eq 'U' then darr_element(i_ielement) = 74. $
    else if str_element_name eq 'Np' then darr_element(i_ielement) = 75. $
    else if str_element_name eq 'Pu' then darr_element(i_ielement) = 76. $
    else if str_element_name eq 'Am' then darr_element(i_ielement) = 77. $
    else if str_element_name eq 'Cm' then darr_element(i_ielement) = 78. $
    else if str_element_name eq 'Bk' then darr_element(i_ielement) = 79. $
    else if str_element_name eq 'Cf' then darr_element(i_ielement) = 80. $
    else if str_element_name eq 'Es' then darr_element(i_ielement) = 81. $
    else if str_element_name eq 'Fm' then darr_element(i_ielement) = 82. $
    else if str_element_name eq 'Md' then darr_element(i_ielement) = 83. $
    else if str_element_name eq 'No' then darr_element(i_ielement) = 84. $
    else if str_element_name eq 'Lu' then darr_element(i_ielement) = 85. $
    else if str_element_name eq 'Hf' then darr_element(i_ielement) = 86. $
    else if str_element_name eq 'Ta' then darr_element(i_ielement) = 87. $
    else if str_element_name eq 'W' then darr_element(i_ielement) = 88. $
    else if str_element_name eq 'Re' then darr_element(i_ielement) = 89. $
    else if str_element_name eq 'Os' then darr_element(i_ielement) = 90. $
    else if str_element_name eq 'Ir' then darr_element(i_ielement) = 91. $
    else if str_element_name eq 'Pt' then darr_element(i_ielement) = 92. $
    else if str_element_name eq 'Au' then darr_element(i_ielement) = 93. $
    else if str_element_name eq 'Hg' then darr_element(i_ielement) = 94. $
    else if str_element_name eq 'Tl' then darr_element(i_ielement) = 95. $
    else if str_element_name eq 'Pb' then darr_element(i_ielement) = 96. $
    else if str_element_name eq 'Bi' then darr_element(i_ielement) = 97. $
    else if str_element_name eq 'Po' then darr_element(i_ielement) = 98. $
    else if str_element_name eq 'At' then darr_element(i_ielement) = 99. $
    else if str_element_name eq 'Rn' then darr_element(i_ielement) = 100. $
    else if str_element_name eq 'Fr' then darr_element(i_ielement) = 101. $
    else if str_element_name eq 'Ra' then darr_element(i_ielement) = 102. $
    else if str_element_name eq 'Lr' then darr_element(i_ielement) = 103. $
    else if str_element_name eq 'Rf' then darr_element(i_ielement) = 104. $
    else if str_element_name eq 'Db' then darr_element(i_ielement) = 105. $
    else if str_element_name eq 'Sg' then darr_element(i_ielement) = 106. $
    else if str_element_name eq 'Bh' then darr_element(i_ielement) = 107. $
    else if str_element_name eq 'Hs' then darr_element(i_ielement) = 108. $
    else if str_element_name eq 'Mt' then darr_element(i_ielement) = 109. $
    else if str_element_name eq 'Uun' then darr_element(i_ielement) = 110. $
    else if str_element_name eq 'Uuu' then darr_element(i_ielement) = 111. $
    else if str_element_name eq 'Uub' then darr_element(i_ielement) = 112. $
    else if str_element_name eq 'Uut' then darr_element(i_ielement) = 113. $
    else if str_element_name eq 'Uuq' then darr_element(i_ielement) = 114. $
    else if str_element_name eq 'Uup' then darr_element(i_ielement) = 115. $
    else if str_element_name eq 'Uuh' then darr_element(i_ielement) = 116. $
    else if str_element_name eq 'Uus' then darr_element(i_ielement) = 117. $
    else if str_element_name eq 'Uuo' then darr_element(i_ielement) = 118. $
    else begin
      darr_element(i_ielement) = 0.
      print,'WARNING: Element No ',i_ielement,': Element "'+str_element+'" not found!!!'
    endelse

    if i_element_ion eq 1 then darr_element(i_ielement) = darr_element(i_ielement)+'00' $
    else if i_element_ion eq 2 then darr_element(i_ielement) = darr_element(i_ielement)+.01 $
    else if i_element_ion eq 3 then darr_element(i_ielement) = darr_element(i_ielement)+.02 $
    else if i_element_ion eq 4 then darr_element(i_ielement) = darr_element(i_ielement)+.03 $
    else if i_element_ion eq 5 then darr_element(i_ielement) = darr_element(i_ielement)+.04 $
    else if i_element_ion eq 6 then darr_element(i_ielement) = darr_element(i_ielement)+.05 $
    else if i_element_ion eq 7 then darr_element(i_ielement) = darr_element(i_ielement)+.06 $
    else if i_element_ion eq 8 then darr_element(i_ielement) = darr_element(i_ielement)+.07 $
    else if i_element_ion eq 9 then darr_element(i_ielement) = darr_element(i_ielement)+.08 $
    else if i_element_ion eq 10 then darr_element(i_ielement) = darr_element(i_ielement)+.09 $
    else if i_element_ion eq 11 then darr_element(i_ielement) = darr_element(i_ielement)+.10 $
    else if i_element_ion eq 12 then darr_element(i_ielement) = darr_element(i_ielement)+.11 $
    else if i_element_ion eq 13 then darr_element(i_ielement) = darr_element(i_ielement)+.12 $
    else if i_element_ion eq 14 then darr_element(i_ielement) = darr_element(i_ielement)+.13 $
    else if i_element_ion eq 15 then darr_element(i_ielement) = darr_element(i_ielement)+.14 $
    else if i_element_ion eq 16 then darr_element(i_ielement) = darr_element(i_ielement)+.15 $
    else begin
      darr_element(i_ielement) = darr_element(i_ielement)+'99'
      print,'WARNING: Element No ',i_ielement,': Ion ',i_element_ion,' not found!'
    endelse
;    print,'darr_element(',i_ielement,') = ',darr_element(i_ielement)
    i_ielement = i_ielement + 1
    i = i+1
  endfor
  free_lun,lun
; -- convert units
  darr_wavelength = darr_wavelength / 10.
  darr_exc_low = darr_exc_low * 8062.4
  darr_exc_up  = darr_exc_up * 8062.4
;  darr_damping_rad = alog10(darr_damping_rad)
;  darr_damping_stark = alog10(darr_damping_stark)
;  darr_damping_waals = alog10(darr_damping_waals)

  print,'element(',i_ielement-1,') = ',darr_element(i_ielement-1)
  print,'wavelength(',i_ielement-1,') = ',darr_wavelength(i_ielement-1)
  print,'log_gf(',i_ielement-1,') = ',darr_loggf(i_ielement-1)
  print,'exc. low(',i_ielement-1,') = ',darr_exc_low(i_ielement-1)
  print,'j low(',i_ielement-1,') = ',darr_j_low(i_ielement-1)
  print,'exc. up(',i_ielement-1,') = ',darr_exc_up(i_ielement-1)
  print,'j up(',i_ielement-1,') = ',darr_j_up(i_ielement-1)
  print,'lande lower(',i_ielement-1,') = ',darr_lande_lower(i_ielement-1)
  print,'lande upper(',i_ielement-1,') = ',darr_lande_upper(i_ielement-1)
  print,'lande mean(',i_ielement-1,') = ',darr_lande_mean(i_ielement-1)
  print,'damping rad(',i_ielement-1,') = ',darr_damping_rad(i_ielement-1)
  print,'damping stark(',i_ielement-1,') = ',darr_damping_stark(i_ielement-1)
  print,'damping waals(',i_ielement-1,') = ',darr_damping_waals(i_ielement-1)
  print,'references(',i_ielement-1,') = ',sarr_references(i_ielement-1)

; -- write outfile
  str_outline = ''
  openw,lun,outfile,/GET_LUN
  for i=0,i_ielement-1 do begin
    printf,lun,darr_wavelength(i),$
               darr_loggf(i),$
               darr_element(i),$
               darr_exc_up(i),$
               darr_j_up(i),$
               darr_exc_low(i),$
               darr_j_low(i),$
               darr_damping_rad(i),$
               darr_damping_stark(i),$
               darr_damping_waals(i),$
               FORMAT='(" ",F10.4,F7.3,F6.2,F12.3,F5.1," *         ",F12.3,F5.1," *         ",F6.2,F6.2,F6.2,"     0 0  0 0.000  0 0.000    0    0              0    0")'
  endfor
  free_lun,lun
endelse
end
