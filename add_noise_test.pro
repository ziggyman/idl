pro add_noise_test
  str_rave_filename = '/home/azuri/daten/rave/rave_data/release5/rave_internal_190509_no_doubles_SNR_gt_20.dat'
  str_sigma_filename = '/home/azuri/daten/rave/rave_data/sigma_teff.rez'
;  str_sigma_filename = '/home/azuri/daten/rave/rave_data/Teff_sigma40_Teff.dat'

  i_nlines = countdatlines(str_rave_filename)
  strarr_ravedata = readfiletostrarr(str_rave_filename,' ')
  dblarr_i_sn_rave = dblarr(i_nlines,2)
  dblarr_i_sn_rave(*,0) = double(strarr_ravedata(*,13)); --- Imag
  dblarr_i_sn_rave(*,1) = double(strarr_ravedata(*,32)); --- SNR
;  print,'add_noise_test: dblarr_i_sn_rave = ',dblarr_i_sn_rave
;  stop

  dblarr_teff_sigma = readfiletodblarr(str_sigma_filename)
  print,'add_noise_test: dblarr_teff_sigma = ',dblarr_teff_sigma
  print,'add_noise_test: size(dblarr_teff_sigma) = ',size(dblarr_teff_sigma)
  print,'add_noise_test: n_elements(dblarr_teff_sigma(*,0)) = ',n_elements(dblarr_teff_sigma(*,0))
  print,'add_noise_test: n_elements(dblarr_teff_sigma(0,*)) = ',n_elements(dblarr_teff_sigma(0,*))
;  print,'add_noise_test: size(dblarr_teff_sigma(*,1:9)) = ',size(dblarr_teff_sigma(*,1:9))
;  for i = 1, 9 do begin
;    dblarr_teff_sigma(*,i) = dblarr_teff_sigma(*,i) * dblarr_teff_sigma(*,0)
;  endfor
;  dblarr_teff_sigma(*,2) = 10.^dblarr_teff_sigma(*,2)
  dblarr_teff_sigma(*,3) = dblarr_teff_sigma(*,3) * (10.^dblarr_teff_sigma(*,2))
  print,'add_noise_test: dblarr_teff_sigma = ',dblarr_teff_sigma

  dblarr_data = [4830.588,4500.,7000.];,$;    --- vector(n)
  dblarr_teff = dblarr_data;,$;  --- vector(n)
  dblarr_mh = [-0.52141304,0.5, -1.1];,$;      --- vector(n)
  dblarr_logg = [2.63,3.,0.8];,$;  --- vector(n)
  dblarr_imag = [11.725,9.3,10.7]
;  dblarr_sn = [20.,80.];,$;      --- vector(n)
  dbl_k = -0.848;,$;              --- double
  dbl_seed = 5.
  add_noise,DBLARR_DATA=dblarr_data,$;    --- vector(n)
              DBLARR_TEFF = dblarr_teff,$;  --- vector(n)
              DBLARR_MH = dblarr_mh,$;      --- vector(n)
              DBLARR_LOGG = dblarr_logg,$;  --- vector(n)
              DBLARR_IMAG = dblarr_imag,$;      --- vector(n)
              DBLARR_SIGMA = dblarr_teff_sigma,$;--- dblarr(m,10) (*,0): Teff, (*,1:9): sigma40
                                           ;--- (*,1): M/H = 0, log g = 4.5
                                           ;--- (*,2): M/H = 0, log g = 3.0
                                           ;--- (*,3): M/H = 0, log g = 1.0
                                           ;--- (*,4): M/H = -0.5, log g = 4.5
                                           ;--- (*,5): M/H = -0.5, log g = 3.0
                                           ;--- (*,6): M/H = -0.5, log g = 1.0
                                           ;--- (*,7): M/H = -1.0, log g = 4.5
                                           ;--- (*,8): M/H = -1.0, log g = 3.0
                                           ;--- (*,9): M/H = -1.0, log g = 1.0
              DBL_K = dbl_k,$;              --- double
              DBL_SEED=dbl_seed,$;            --- double
              DBLARR_I_SN_RAVE = dblarr_i_sn_rave
  print,'add_noise_test: dblarr_data = ',dblarr_data
end
