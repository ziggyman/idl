function feh_and_afe_to_metallicity, I_STR_FILENAME = i_str_filename,$
                                     I_STR_DELIMITER = i_str_delimiter,$
                                     I_INT_COL_FEH  = i_int_col_feh,$
                                     I_INT_COL_AFE  = i_int_col_afe,$
                                     I_DBLARR_FEH   = i_dblarr_feh,$
                                     I_DBLARR_AFE   = i_dblarr_afe

  if (not keyword_set(I_DBLARR_FEH)) and (not keyword_set(I_DBLARR_AFE)) then begin
    if not keyword_set(I_STR_FILENAME) then $
      i_str_filename = '/home/azuri/daten/rave/soubiran2005/soubiran2005.tsv'
    strarr_data = readfiletostrarr(i_str_filename,i_str_delimiter)
    dblarr_feh = double(strarr_data(*,i_int_col_feh))
    dblarr_afe = double(strarr_data(*,i_int_col_afe))
  end else begin
    dblarr_feh = i_dblarr_feh
    dblarr_afe = i_dblarr_afe
  endelse

  dblarr_mh = dblarr_feh + alog10(0.638 * 10. ^ dblarr_afe + 0.362); --- Salaris 1993

  strarr_data = 0
  dblarr_feh = 0
  dblarr_afe = 0

  return,dblarr_mh
end
