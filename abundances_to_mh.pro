function abundances_to_mh,I_STR_FILENAME  = i_str_filename,$
                          I_INT_COL_FEH   = i_int_col_feh,$
                          I_INT_COL_OFE   = i_int_col_ofe,$
                          I_INT_COL_NAFE  = i_int_col_nafe,$
                          I_INT_COL_MGFE  = i_int_col_mgfe,$
                          I_INT_COL_ALFE  = i_int_col_alfe,$
                          I_INT_COL_SIFE  = i_int_col_sife,$
                          I_INT_COL_CAFE  = i_int_col_cafe,$
                          I_INT_COl_TIFE  = i_int_col_tife,$
                          I_INT_COL_NIFE  = i_int_col_nife,$
                          I_STR_DELIMITER = i_str_delimiter
  if not keyword_set(I_STR_FILENAME) then $
    i_str_filename= "/home/azuri/daten/rave/calibration/rave_soubiran_orig.dat"

  if not keyword_set(I_INT_COL_FEH) then $
    i_int_col_feh = 3
  if not keyword_set(I_INT_COL_OFE) then $
    i_int_col_ofe = 4
  if not keyword_set(I_INT_COL_NAFE) then $
    i_int_col_nafe = 5
  if not keyword_set(I_INT_COL_MGFE) then $
    i_int_col_mgfe = 6
  if not keyword_set(I_INT_COL_ALFE) then $
    i_int_col_alfe = 7
  if not keyword_set(I_INT_COL_SIFE) then $
    i_int_col_sife = 8
  if not keyword_set(I_INT_COL_CAFE) then $
    i_int_col_cafe = 9
  if not keyword_set(I_INT_COL_TIFE) then $
    i_int_col_tife = 10
  if not keyword_set(I_INT_COL_NIFE) then $
    i_int_col_nife = 11

  if not keyword_set(I_STR_DELIMITER) then $
    i_str_delimiter = ' '

  strarr_data = readfiletostrarr(i_str_filename,i_str_delimiter);
  dblarr_FeH = double(strarr_data(*,i_int_col_feh));
  indarr = where(strarr_data(*,i_int_col_feh) eq '')
  if indarr(0) ge 0 then $
    dblarr_FeH(indarr) = 99.9

  dblarr_OFe = double(strarr_data(*,i_int_col_ofe));
  indarr = where(strarr_data(*,i_int_col_ofe) eq '')
  if indarr(0) ge 0 then $
    dblarr_OFe(indarr) = 99.9

  dblarr_NaFe = double(strarr_data(*,i_int_col_nafe));
  indarr = where(strarr_data(*,i_int_col_nafe) eq '')
  if indarr(0) ge 0 then $
    dblarr_NaFe(indarr) = 99.9

  dblarr_MgFe = double(strarr_data(*,i_int_col_mgfe));
  indarr = where(strarr_data(*,i_int_col_mgfe) eq '')
  if indarr(0) ge 0 then $
    dblarr_MgFe(indarr) = 99.9

  dblarr_AlFe = double(strarr_data(*,i_int_col_alfe));
  indarr = where(strarr_data(*,i_int_col_alfe) eq '')
  if indarr(0) ge 0 then $
    dblarr_AlFe(indarr) = 99.9

  dblarr_SiFe = double(strarr_data(*,i_int_col_sife));
  indarr = where(strarr_data(*,i_int_col_sife) eq '')
  if indarr(0) ge 0 then $
    dblarr_SiFe(indarr) = 99.9

  dblarr_CaFe = double(strarr_data(*,i_int_col_cafe));
  indarr = where(strarr_data(*,i_int_col_cafe) eq '')
  if indarr(0) ge 0 then $
    dblarr_CaFe(indarr) = 99.9

  dblarr_TiFe = double(strarr_data(*,i_int_col_tife));
  indarr = where(strarr_data(*,i_int_col_tife) eq '')
  if indarr(0) ge 0 then $
    dblarr_TiFe(indarr) = 99.9

  dblarr_NiFe = double(strarr_data(*,i_int_col_nife));
  indarr = where(strarr_data(*,i_int_col_nife) eq '')
  if indarr(0) ge 0 then $
    dblarr_NiFe(indarr) = 99.9

  ;//compute [M/H] for soubiran
  gor = dblarr_FeH*0.;
  dol = dblarr_FeH*0.;
  dblarr_MH = dblarr_FeH*0.;
  AFe=7.51;
  MFe=55.85;
  AO=8.93;
  MO=16.00;
  ANa=6.31;
  MNa=22.99;
  AMg=7.58;
  MMg=24.31;
  AAl=6.48;
  MAl=26.98;
  ASi=7.55;
  MSi=28.09;
  ACa=6.34;
  MCa=40.08;
  ATi=4.93;
  MTi=47.88;
  ANi=6.25;
  MNi=58.69;

  print,'abundances_to_mh: i_int_col_ofe = ',i_int_col_ofe
  print,'abundances_to_mh: dblarr_ofe = ',dblarr_ofe
  ;stop

  w=where(dblarr_FeH lt 90.);
  gor(w)=gor(w)+MFe*10.^(AFe+0.0+dblarr_FeH(w));
  dol(w)=dol(w)+MFe*10.^AFe;
  w=where(dblarr_OFe lt 90.)
  gor(w)=gor(w)+MO*10.^(AO +dblarr_OFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MO*10.^AO;
  w=where(dblarr_NaFe lt 90.);
  gor(w)=gor(w)+MNa*10.^(ANa +dblarr_NaFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MNa*10.^ANa;
  w=where(dblarr_MgFe lt 90.);
  gor(w)=gor(w)+MMg*10.^(AMg +dblarr_MgFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MMg*10.^AMg;
  w=where(dblarr_AlFe lt 90.);
  gor(w)=gor(w)+MAl*10.^(AAl +dblarr_AlFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MAl*10.^AAl;
  w=where(dblarr_SiFe lt 90.);
  gor(w)=gor(w)+MSi*10.^(ASi +dblarr_SiFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MSi*10.^ASi;
  w=where(dblarr_CaFe lt 90.);
  gor(w)=gor(w)+MCa*10.^(ACa +dblarr_CaFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MCa*10.^ACa;
  w=where(dblarr_TiFe lt 90.);
  gor(w)=gor(w)+MTi*10.^(ATi +dblarr_TiFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MTi*10.^ATi;
  w=where(dblarr_NiFe lt 90.);
  gor(w)=gor(w)+MNi*10.^(ANi +dblarr_NiFe(w)+dblarr_FeH(w));
  dol(w)=dol(w)+MNi*10.^ANi;
  dblarr_MH = alog10(gor/dol);

  print,'dblarr_MH = ',dblarr_MH

  return,dblarr_MH
end
