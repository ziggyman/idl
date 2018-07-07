pro besancon_calculate_vrad_from_uvwlb, IO_STR_FILENAME = io_str_filename
; NAME:
;       besancon_calculate_vrad_from_uvwlb
; PURPOSE:
;       re-calculates vrad from U, V, W, L, B with different LSR
;
; EXPLANATION:
;       - adopt new LSR to re-calculate vrad
;       - LSR specified in vrad_from_uvwlb.pro
;
; CALLING SEQUENCE:
;       besancon_calculate_vrad_from_uvwlb,(IO_STR_FILENAME=filename)
;
; INPUTS: IO_STR_FILEAME - file name Besancon data file
;
; OUTPUTS: writes <IO_STR_FILENAME_root>+'_vrad-from-uvwlb'.dat
;
; RESTRICTIONS: -
;
; PRE: -
;
; POST: (besancon_do_error_convolution.pro)
;       rave_besancon_calc_heights
;       besancon_get_ravesample
;
; USES: - readfiletostrarr.pro
;       - vrad_from_uvwlb.pro
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2010-07-25
;-------------------------------------------------------------------------
;
;email from Annie Robin:
;Here is the transformation applied wrongly on the model on line:
;
;this is a transformation (U1,V1,W1) in the referential of the star towards the (U,V,W) in the LSR.
;(in fortran)
;
;        sinalpha1=rm*sin(xl)*cos(xb)/r
;        sinalpha1=dmax1(sinalpha1,-1.d0)
;        sinalpha1=dmin1(sinalpha1,+1.d0)
;        alpha1=asin(sinalpha1)
;        U = U1 * COS(alpha1) + V1 * SIN(alpha1)
;        V = - U1 * SIN(alpha1)+ V1 * COS(alpha1)
;
;xl=longitude in radians
;xb=latitude in radians
;r=galactocentric distance of the star
;r0=sun-center distance
;rm= distance from the observer to the star
;
;in moup0906:
;
;The transformation which should have been applied:
;       SINGL = RM*COS(XB)*SIN(XL)/R
;       COSGL = (R0-RM*COS(XB)*COS(XL))/R
;       U = U1 * COSGL + V1 * SINGL
;       V = - U1 * SINGL + V1 * COSGL
;
;the difference is only for stars at Rm>R0 (the other side of the GC).
;Not sure this is the reason of the discrepancy...
;
;Annie
  str_filename_in = '/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20_with-errors_errdivby-dwarfs-2_70_0_75_2_00_1_00-giants-1_50-1_50-1_80-1_50.dat'
  ;'/home/azuri/daten/besancon/lon-lat/besancon_all_10x10_230-315_-25-25_JmK_eI_mh_+snr-i-dec-giant-dwarf-minus-ic1-ge-20.dat'
  if keyword_set(IO_STR_FILENAME) then $
    str_filename_in = io_str_filename

  str_filename_out = strmid(str_filename_in,0,strpos(str_filename_in,'.',/REVERSE_SEARCH))+'_vrad-from-uvwlb.dat'

  strarr_data = readfiletostrarr(str_filename_in,' ',HEADER=strarr_header)

  int_col_u = 12
  int_col_v = 13
  int_col_w = 14
  int_col_l = 0
  int_col_b = 1
  int_col_vrad = 7

  dblarr_u = double(strarr_data(*,int_col_u))
  dblarr_v = double(strarr_data(*,int_col_v))
  dblarr_w = double(strarr_data(*,int_col_w))
  dblarr_l = double(strarr_data(*,int_col_l))
  dblarr_b = double(strarr_data(*,int_col_b))
  dblarr_vrad = double(strarr_data(*,int_col_vrad))

  openw,lun,str_filename_out,/GET_LUN
  if n_elements(strarr_header) gt 0 then begin
    for i=0ul, n_elements(strarr_header)-1 do begin
      printf,lun,strarr_header(i)
    endfor
  endif

  ; --- calculate vrad and write to output file
  for i=0ul, n_elements(dblarr_u)-1 do begin
    vrad_from_uvwlb, I_DBL_L = dblarr_l(i),$; [deg]
                     I_DBL_B = dblarr_b(i),$; [deg]
                     I_DBL_UU = dblarr_u(i),$; [km/s]
                     I_DBL_VV = dblarr_v(i),$; [km/s]
                     I_DBL_WW = dblarr_w(i),$; [km/s]
                     O_DBL_VRAD = dbl_vrad; [km/s]
    ;if abs(dblarr_vrad(i) - dbl_vrad) gt 0.01 then print,'Problem: i=',i,': l=',dblarr_l(i),', b=',dblarr_b(i),', u=',dblarr_u(i),', v=',dblarr_v(i),', w=',dblarr_w(i),', vrad_old=',dblarr_vrad(i),', vrad_new=',dbl_vrad
    ;if i eq 100 then stop
    dblarr_vrad(i) = dbl_vrad
    str_out = strarr_data(i,0)
    for j=1, 6 do begin
      str_out = str_out + ' ' + strarr_data(i,j)
    endfor
    str_out = str_out + ' ' + strtrim(string(dblarr_vrad(i)),2)
    for j=8, n_elements(strarr_data(0,*))-1 do begin
      str_out = str_out + ' ' + strarr_data(i,j)
    endfor
    printf,lun,str_out
  endfor
  free_lun,lun
  io_str_filename = str_filename_out

  ; --- clean up
  dblarr_vrad = 0
  dblarr_u = 0
  dblarr_v = 0
  dblarr_w = 0
  dblarr_l = 0
  dblarr_b = 0
end
