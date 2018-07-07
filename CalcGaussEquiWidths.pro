;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;###########################
function countdatlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTDATLINES: No file specified, return 0.' $
else begin
  c = long(0)
  nlines = countlines(s)
  openr,lun,s,/GET_LUN
  tempstr = ''
  for i=0,nlines-1 do begin
    readf,lun,tempstr
    if strmid(tempstr,0,1) ne '#' then begin
      c = c + 1
    endif
  endfor
  free_lun,lun
end
return,c
end

;###########################
function countcols,filename
;###########################

cols=0L
if n_params() ne 1 then print,'COUNTCOLS: No file specified, return 0.' $
else begin
  templine = ''
  openr,lun,filename,/get_lun
  run = 1
  while run eq 1 do begin
    readf,lun,templine
    templine = strtrim(templine,2)
    if strmid(templine,0,1) ne '#' then run = 0
  end
  free_lun,lun
  while strpos(templine,' ') ge 0 do begin
    cols = cols+1
    templine = strtrim(strmid(templine,strpos(templine,' '),strlen(templine)-strpos(templine,' ')),2)
  end
  cols = cols+1
end
return,cols
end

;############################
pro CalcGaussEquiWidths,xyarray,positions,D_VRad
;############################
;
; NAME:                  CalcGaussEquiWidths
; PURPOSE:               * calculates the equivalent widths of gaussian fits to y=f(x) at
;                          the given positions using CalcGaussEquiWidth
;                        *
;
; CATEGORY:              elemental abundance analysis
; CALLING SEQUENCE:      CalcGaussEquiWidths,'xy-array','positions',D_VRad
; INPUTS:                input file: xy-array:
;                         1110.0 140.1
;                         1110.1 140.1
;                         1110.2 142.2
;                         ...
;
;                        input file: positions:
;                         # Laboratory Wavelength in Air
;                         1115.1
;                         1140.1
;                         1432.2
;                         ...
;
;                        input parameter: D_VRad
;                         radial velocity of observed object in [km/s]
;
; OUTPUTS:
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           20/11/2007
;

  if n_elements(D_VRad) eq 0 then begin
    print,'CalcGaussEquiWidths: Not enough arguments specified, return 0.'
    print," USAGE: CalcGaussEquiWidths,'xyarray','positions',D_VRad"
  end else begin
    D_SpeedOfLight = 300000.
; --- read files to arrays
    D_A2_XYData = readfiletodblarr(xyarray)
    D_A1_X = D_A2_XYData(*,0)
    D_A1_Y = D_A2_XYData(*,1)
    D_A2_XYData = 0
    D_A1_Positions = readfiletodblarr(positions)
    print,'xarr = ',D_A1_X
    print,'yarr = ',D_A1_Y

; --- correct x for radial velocity
    D_A1_X = D_A1_X + (D_A1_X * D_VRad / D_SpeedOfLight)
    print,'xarr(corrected for VRad) = ',D_A1_X

; --- take 1st derivate of y to find inflexion points arround centers
    D_A1_YDeriv = DERIV(D_A1_X, D_A1_Y)
    print,'D_A1_YDeriv = ',D_A1_YDeriv
    I_NPositions = N_ELEMENTS(D_A1_Positions)
    I_A1_A = lonarr(I_NPositions)
    I_A1_B = lonarr(I_NPositions)
    I_A1_C = lonarr(I_NPositions)
    for i=0,I_NPositions-1 do begin
      print,'CalcGaussEquiWidths: D_A1_Positions(i=',i,') = ',D_A1_Positions(i)
      I_Pos = WHERE(D_A1_X lt D_A1_Positions(i), count)
      print,'CalcGaussEquiWidths: I_Pos = ',I_Pos
      I_Pos = I_Pos(count-1)
      print,'CalcGaussEquiWidths: I_Pos = ',I_Pos
; --- find centers and save to I_A1_B
      j = 0
      if D_A1_YDeriv(I_Pos) eq 0. then begin
        I_A1_B(i) = I_Pos
      endif else begin
        while I_A1_B(i) eq 0 do begin
          j = j + 1
          if D_A1_YDeriv(I_Pos - j) eq 0. then begin
            I_A1_B(i) = I_Pos - j
          end else if D_A1_YDeriv(I_Pos + j) eq 0. then begin
            I_A1_B(i) = I_Pos + j
          end else if D_A1_YDeriv(I_Pos - j) lt 0. and D_A1_YDeriv(I_Pos) gt 0. then begin
            I_A1_B(i) = I_Pos - j
          end else if D_A1_YDeriv(I_Pos - j) gt 0. and D_A1_YDeriv(I_Pos) lt 0. then begin
            I_A1_B(i) = I_Pos - j
          end else if D_A1_YDeriv(I_Pos + j) gt 0. and D_A1_YDeriv(I_Pos) lt 0. then begin
            I_A1_B(i) = I_Pos + j
          end else if D_A1_YDeriv(I_Pos + j) gt 0. and D_A1_YDeriv(I_Pos) lt 0. then begin
            I_A1_B(i) = I_Pos + j
          end
        end
      end
; --- find start and end of gaussian and save to I_A1_A and I_A1_C
      k = 1
      I_A1_A(i) = -1
      I_A1_C(i) = -1
      while (I_A1_A(i) eq -1) or (I_A1_C(i) eq -1) do begin
        k = k + 1
        if (k le I_A1_B(i)) and (I_A1_A(i) eq -1) then begin
          if D_A1_YDeriv(I_A1_B(i) - k) eq 0. then begin
            I_A1_A(i) = I_A1_B(i) - k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 1. I_A1_A(',i,') set to ',I_A1_A(i)
          end else if D_A1_YDeriv(I_A1_B(i) - k) lt 0. and D_A1_YDeriv(I_A1_B(i) - k + 1) gt 0. then begin
            I_A1_A(i) = I_A1_B(i) - k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 2. I_A1_A(',i,') set to ',I_A1_A(i)
          end else if D_A1_YDeriv(I_A1_B(i) - k) gt 0. and D_A1_YDeriv(I_A1_B(i) - k + 1) lt 0. then begin
            I_A1_A(i) = I_A1_B(i) - k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 3. I_A1_A(',i,') set to ',I_A1_A(i)
          end
        end
        if (I_A1_B(i) + k lt N_ELEMENTS(D_A1_YDeriv)) and (I_A1_C(i) eq -1) then begin
          if D_A1_YDeriv(I_A1_B(i) + k) eq 0. then begin
            I_A1_C(i) = I_A1_B(i) + k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 1. I_A1_C(',i,') set to ',I_A1_C(i)
          end else if D_A1_YDeriv(I_A1_B(i) + k) gt 0. and D_A1_YDeriv(I_A1_B(i) + k - 1) lt 0. then begin
            I_A1_C(i) = I_A1_B(i) + k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 2. I_A1_C(',i,') set to ',I_A1_C(i)
          end else if D_A1_YDeriv(I_A1_B(i) + k) gt 0. and D_A1_YDeriv(I_A1_B(i) + k - 1) lt 0. then begin
            I_A1_C(i) = I_A1_B(i) + k
            print,'CalcGaussEquiWidths: k = ',k
            print,'CalcGaussEquiWidths: 3. I_A1_C(',i,') set to ',I_A1_C(i)
          end
        end
      end
      print,'CalcGaussEquiWidths: I_A1_A(i) = ',I_A1_A(i)
      print,'CalcGaussEquiWidths: I_A1_B(i) = ',I_A1_B(i)
      print,'CalcGaussEquiWidths: I_A1_C(i) = ',I_A1_C(i)

; --- calculate equivalent width
      D_EquivalentWidth = FCalcGaussEquiWidth(D_A1_X(I_A1_A(i):I_A1_C(i)),D_A1_Y(I_A1_A(i):I_A1_C(i)))
      print,'CalcGaussEquiWidths: D_EquivalentWidth = ',D_EquivalentWidth
    endfor

  endelse
end
