pro write_file, I_STRARR_DATA   = i_strarr_data,$
                I_STRARR_HEADER = i_strarr_header,$
                I_STR_FILENAME  = i_str_filename
; NAME:
;       write_file.pro
; PURPOSE:
;       write header I_STRARR_HEADER and 2d data array I_STRARR_DATA to I_STR_FILENAME
;
; EXPLANATION:
;       - creates I_STR_FILENAME and writes header and data array into it
;
; CALLING SEQUENCE:
;       write_file,I_STRARR_DATA = strarr_2d, (I_STRARR_HEADER = strarr_1d,) I_STR_FILENAME = string
;
; INPUTS: I_STRARR_DATA: 2D string array to write to file
;         I_STRARR_HEADER: string vector containing header for output file
;         I_STR_FILENAME = string: output file name
;
; OUTPUTS: creates I_STR_FILENAME
;
; PRE: i_strarr_data = readfiletostrarr(str_filename,$
;                                       ' ',$
;                                       (I_NLINES = int_ndatalines,$)
;                                       (I_NCOLS  = int_ncols,$)
;                                        HEADER   = i_strarr_header)
;
; POST: -
;
; USES: -
;
; RESTRICTIONS: - i_strarr_data: 2D strarr
;               - i_strarr_header: 1D strarr
;
; DEBUG: -
;
; EXAMPLE: -
;
; MODIFICATION HISTORY
;        - created 2010-04-26
;
; COPYRIGHT: Andreas Ritter
;-------------------------------------------------------------------------
  openw,lun,i_str_filename,/GET_LUN
    if keyword_set(I_STRARR_HEADER) then begin
      for i=0ul, n_elements(i_strarr_header)-1 do begin
        printf,lun,i_strarr_header(i)
      endfor
    endif
    for i=0ul, n_elements(i_strarr_data(*,0)) - 1 do begin
      str_line = i_strarr_data(i,0)
      for j=1ul, n_elements(i_strarr_data(0,*))-1 do begin
        str_line = str_line + ' ' + i_strarr_data(i,j)
      endfor
      printf,lun,str_line
    endfor
  free_lun,lun
end
