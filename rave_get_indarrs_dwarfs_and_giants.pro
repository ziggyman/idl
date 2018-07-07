pro rave_get_indarrs_dwarfs_and_giants,I_DBLARR_LOGG    = i_dblarr_logg,$
                                       O_INDARR_DWARFS  = o_indarr_dwarfs,$
                                       O_INDARR_GIANTS  = o_indarr_giants,$
                                       I_DBL_LIMIT_LOGG = i_dbl_limit_logg
  o_indarr_dwarfs = where(i_dblarr_logg ge i_dbl_limit_logg, COMPLEMENT=o_indarr_giants)
end
