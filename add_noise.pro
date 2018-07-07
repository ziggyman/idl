pro add_noise,IO_DBLARR_DATA        = io_dblarr_data,$;  --- IO: vector(n)
              O_DBLARR_ERR          = o_dblarr_err,$; --- O: vector(n)
              I_DBLARR_SNR_BESANCON = i_dblarr_snr_besancon,$; --- I: vector(n)
              I_DBLARR_TEFF         = i_dblarr_teff,$;  --- I: vector(n)
              I_DBLARR_MH           = i_dblarr_mh,$;    --- I: vector(n)
              I_DBLARR_LOGG         = i_dblarr_logg,$;  --- I: vector(n)
              I_DBLARR_RAVE_LOGG    = i_dblarr_rave_logg,$; --- I: vector(m)
              I_DBLARR_RAVE_DIST    = i_dblarr_rave_dist,$; --- I: vector(m)
              I_DBLARR_RAVE_EDIST   = i_dblarr_rave_edist,$; --- I: vector(m)
              I_DBLARR_SIGMA        = i_dblarr_sigma,$; --- I: dblarr(m,4) (*,0): logg
                                               ; --- (*,1): M/H
                                               ; --- (*,2): Teff
                                               ; --- (*,3): sigma40
              I_DBL_SIGMA           = i_dbl_sigma,$;      --- IO: double
              I_B_PERCENT           = i_b_percent,$;      --- I: bool
              I_B_REAL_ERR          = i_b_real_err,$;     --- I: bool
              I_DBL_PERCENTAGE      = i_dbl_percentage,$; --- I: double
              I_DBL_K               = i_dbl_k,$;          --- I: double
              IO_DBL_SEED           = io_dbl_seed,$;       --- IO: int
              I_DBL_DIVIDE_ERROR_BY = i_dbl_divide_error_by,$; --- I: double
              I_DBL_REJECT          = i_dbl_reject;,$

; NAME:
;       add_noise.pro
; PURPOSE:
;       add noise to IO_DBLARR_DATA
;
; EXPLANATION:
;       - if I_B_PERCENT and I_DBL_PERCENTAGE are set: for Breddels distances
;                                                      calculate random error in per cent from normal distribution with
;                                                      1sigma=i_dbl_percentage
;       - if only I_B_PERCENT is set: for Zwitter distances
;                                     randomly select Zwitter star with similar log g and distance and adopt its error
;       - if I_DBL_K and I_DBLARR_SIGMA are set: use errors from DR1 paper
;
; CALLING SEQUENCE:
;       besancon_convolve_atmospheric_parameters_with_errors_from_smoothed_running_mean(,IO_STR_FILENAME = string)(,I_DBLARR_ERRDIVBY = dblarr)
;
; INPUTS: IO_STR_FILENAME = string: besancon file name
;         I_DBLARR_ERRDIVBY = dblarr(3): 0: vrad, 1: Teff, 2: log g, 3: [M/H]
;
; OUTPUTS: IO_STR_FILENAME = io_str_filename_root + '_with-errors' (+'-errdivby-'+)
;
; PRE: rave_compare_to_external_and_calibrate.pro
;      besancon_add_snr.pro
;      (besancon_calculate_mh_from_feh.pro)
;
; POST: -
;
; USES: readfiletostrarr.pro
;
; RESTRICTIONS: -
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


  B_DEBUG = 0
  B_STOP = 0

  i_run_percent = 0

  o_dblarr_err = dblarr(n_elements(io_dblarr_data))

  if keyword_set(I_DBL_SIGMA) then begin
    b_sigma_set = 1
  end else begin
    b_sigma_set = 0
  end

  if not keyword_set(IO_DBL_SEED) then $
    io_dbl_seed = 5.
;  if not keyword_set(DBL_I_SEED) then $
;    dbl_i_seed = 1.

  if keyword_set(I_DBLARR_TEFF) then begin
    i_dblarr_teff = alog10(i_dblarr_teff)
    print,'add_noise: I_DBLARR_TEFF set'
;    stop
  end; else begin
  if not keyword_set(I_DBL_REJECT) then $
    i_dbl_reject = 1000000000.

  if keyword_set(I_DBLARR_TEFF) then $
    dblarr_teff_calc = i_dblarr_teff
  if keyword_set(I_DBLARR_MH) then $
    dblarr_mh_calc = i_dblarr_mh
  if keyword_set(I_DBLARR_LOGG) then $
    dblarr_logg_calc = i_dblarr_logg

  if b_sigma_set then $
    openw,lun_vrad,'temp_vrad.dat',/GET_LUN


  for i=0UL, n_elements(io_dblarr_data)-1 do begin
    if keyword_set(I_DBL_PERCENTAGE) then begin
      o_dblarr_err(i) = i_dbl_percentage * io_dblarr_data(i) / 100.
      if not keyword_set(I_B_REAL_ERR) then $
        o_dblarr_err(i) = RANDOMN(io_dbl_seed) * o_dblarr_err(i)
      io_dblarr_data(i) = io_dblarr_data(i) + o_dblarr_err(i)
    end else begin
      if b_sigma_set then begin
        if keyword_set(I_B_REAL_ERR) then begin
          o_dblarr_err(i) = i_dbl_sigma
        end else begin
          o_dblarr_err(i) = RANDOMN(io_dbl_seed) * i_dbl_sigma
        endelse
  ;      print,'add_noise: old io_dblarr_data(i=',i,') = ',io_dblarr_data(i)
        print,'add_noise: o_dblarr_err(i=',i,') = ',o_dblarr_err(i)
        printf,lun_vrad,string(o_dblarr_err(i))
        if keyword_set(I_DBL_DIVIDE_ERROR_BY) then $
          o_dblarr_err(i) = o_dblarr_err(i) / i_dbl_divide_error_by
          print,'add_noise: o_dblarr_err(i=',i,') = ',o_dblarr_err(i)
          print,'add_noise: old io_dblarr_data(i=',i,') = ',io_dblarr_data(i)
          io_dblarr_data(i) = io_dblarr_data(i) + o_dblarr_err(i)
        print,'add_noise: new io_dblarr_data(i=',i,') = ',io_dblarr_data(i)

        str_dum = strtrim(string(io_dblarr_data(i)),2)
        if strmid(str_dum,strlen(str_dum)-3,3) eq 'NaN' then stop
        if strmid(str_dum,strlen(str_dum)-3,3) eq 'Inf' then stop
        if strmid(str_dum,strlen(str_dum)-8,8) eq 'Infinity' then stop
        print,' '
  ;      if i eq 100 then stop
      end else begin
        if (not keyword_set(I_DBL_REJECT)) or abs(io_dblarr_data(i) - i_dbl_reject) gt 0.2 then begin
          if B_DEBUG then begin
            print,' '
            print,' '
            print,' '
            print,' '
            print,' '
            print,' '
            print,' '
            print,' '
            print,' '
          endif
          if keyword_set(I_DBL_K) then begin; no average sigma given
    ;        print,'add_noise: io_dblarr_data(i=',i,') = ',io_dblarr_data(i)
    ;        print,'add_noise: i_dblarr_logg(i=',i,') = ',i_dblarr_logg(i)
    ;        print,'add_noise: i_dblarr_mh(i=',i,') = ',i_dblarr_mh(i)
    ;        print,'add_noise: i_dblarr_teff(i=',i,') = ',i_dblarr_teff(i)

            ; --- teff
            dblarr_sigma_calc = i_dblarr_sigma
            dbl_minmax = min(dblarr_sigma_calc(*,2))
            if B_DEBUG then begin
              print,'add_noise: min(dblarr_sigma_calc(*,2)) = ',dbl_minmax,', i_dblarr_teff(i=',i,') = ',i_dblarr_teff(i)
            endif
            if i_dblarr_teff(i) le dbl_minmax then begin
    ;          print,'i_dblarr_teff(i=',i,') lt dbl_minmax = ',dbl_minmax,': setting i_dblarr_teff(i) to ',dbl_minmax+0.00001
              dblarr_teff_calc(i) = dbl_minmax+0.00001
            endif

            dbl_minmax = max(dblarr_sigma_calc(*,2))
            if B_DEBUG then begin
              print,'add_noise: max(dblarr_sigma_calc(*,2)) = ',dbl_minmax,', i_dblarr_teff(i=',i,') = ',i_dblarr_teff(i)
            endif
            if i_dblarr_teff(i) ge dbl_minmax then begin
              if B_DEBUG then begin
                print,'add_noise: i_dblarr_teff(i=',i,') = ',i_dblarr_teff(i),' ge max(dblarr_sigma_calc(*,2)) = ',dbl_minmax
              endif
              dblarr_teff_calc(i) = dbl_minmax-0.00001
            endif

            ; --- mh
            dbl_minmax = min(dblarr_sigma_calc(*,1))
            if B_DEBUG then begin
              print,'add_noise: min(dblarr_sigma_calc(*,1)) = ',dbl_minmax,', i_dblarr_mh(i=',i,') = ',i_dblarr_mh(i)
            endif
            if i_dblarr_mh(i) le dbl_minmax then $
              dblarr_mh_calc(i) = dbl_minmax+0.00001

            dbl_minmax = max(dblarr_sigma_calc(*,1))
            if B_DEBUG then begin
              print,'add_noise: max(dblarr_sigma_calc(*,1)) = ',dbl_minmax,', i_dblarr_mh(i=',i,') = ',i_dblarr_mh(i)
            endif
            if i_dblarr_mh(i) ge dbl_minmax then $
              dblarr_mh_calc(i) = dbl_minmax-0.00001

            ; --- logg
            dbl_minmax = min(dblarr_sigma_calc(*,0))
            if B_DEBUG then begin
              print,'add_noise: min(dblarr_sigma_calc(*,0)) = ',dbl_minmax,', i_dblarr_logg(i=',i,') = ',i_dblarr_logg(i)
            endif
            if i_dblarr_logg(i) le dbl_minmax then $
              dblarr_logg_calc(i) = dbl_minmax+0.00001

            dbl_minmax = max(dblarr_sigma_calc(*,0))
            if B_DEBUG then begin
              print,'add_noise: max(dblarr_sigma_calc(*,0)) = ',dbl_minmax,', i_dblarr_logg(i=',i,') = ',i_dblarr_logg(i)
            endif
            if i_dblarr_logg(i) ge dbl_minmax then $
              dblarr_logg_calc(i) = dbl_minmax-0.00001

            if B_DEBUG then begin
              print,'add_noise: i_dblarr_teff(i=',i,') = ',i_dblarr_teff(i)
              print,'add_noise: dblarr_sigma_calc(*,2) = ',dblarr_sigma_calc(*,2)
              print,'add_noise: i_dblarr_mh(i=',i,') = ',i_dblarr_mh(i)
              print,'add_noise: dblarr_sigma_calc(*,1) = ',dblarr_sigma_calc(*,1)
              print,'add_noise: i_dblarr_logg(i=',i,') = ',i_dblarr_logg(i)
              print,'add_noise: dblarr_sigma_calc(*,0) = ',dblarr_sigma_calc(*,0)
    ;          print,'add_noise: dblarr_imag(i) = ',dblarr_imag(i)
            endif

            ; --- log g
            indarr = where(dblarr_sigma_calc(*,0) eq dblarr_logg_calc(i))
            if indarr(0) ne -1 then begin
              print,'add_noise: PROBLEM: logg: indarr(=',indarr,') ne -1'
              print,'add_noise: PROBLEM: logg: dblarr_logg(i=',i,') = ',dblarr_logg_calc(i)
              print,'add_noise: PROBLEM: logg: dblarr_sigma_calc(indarr(=',indarr,'),0) = ',dblarr_sigma_calc(indarr,0)
              indarr_dum = ulonarr(n_elements(indarr) * 2)
              for m=0UL, n_elements(indarr)-1 do begin
                indarr_dum(m) = indarr(m)
                indarr_dum(m+288) = indarr(m)+288
              endfor
              indarr = indarr_dum
              B_STOP = 1
            end else begin
              if dblarr_logg_calc(i) ge 3. then begin
                indarr = where(abs(dblarr_sigma_calc(*,0) - dblarr_logg_calc(i)) le 1.5)
              end else begin
                indarr_temp = where(dblarr_sigma_calc(*,0) le 3.)
                indarr = where(abs(dblarr_sigma_calc(indarr_temp,0) - dblarr_logg_calc(i)) le 2.)
                indarr = indarr_temp(indarr)
              endelse
            endelse
            if B_DEBUG then begin
              print,'add_noise: n_elements(indarr(logg)) = ',n_elements(indarr)
            endif
            if n_elements(indarr) ne 576 then begin
              print,'add_noise: n_elements(indarr) = ',n_elements(indarr)
              print,'add_noise: i = ',i
              stop
            endif
            if abs(dblarr_sigma_calc(indarr(0),0) - dblarr_sigma_calc(indarr(1),0)) gt (1.1 * 2.) then begin
              print,'add_noise: PROBLEM: abs(dblarr_sigma_calc(indarr(0)=',indarr(0),',0)=',dblarr_sigma_calc(indarr(0),0),' - dblarr_sigma_calc(indarr(1)=',indarr(1),',0)=',dblarr_sigma_calc(indarr(1),0),')=',abs(dblarr_sigma_calc(indarr(0),0) - dblarr_sigma_calc(indarr(1),0)),' gt (1.1 * 2.)'
              stop
            endif

            ; --- mh
            indarr_temp = indarr
            indarr = where(dblarr_sigma_calc(*,1) eq dblarr_mh_calc(i))
            if indarr(0) ne -1 then begin
              print,'add_noise: PROBLEM: mh: indarr(=',indarr,') ne -1'
              dblarr_mh_calc(i) = dblarr_mh_calc(i) + 0.00000001
            endif
            indarr = where(abs(dblarr_sigma_calc(indarr_temp,1) - dblarr_mh_calc(i)) le 0.5)
            indarr = indarr_temp(indarr)
            if B_DEBUG then $
              print,'add_noise: n_elements(indarr(mh)) = ',n_elements(indarr)
            if n_elements(indarr) ne 384 then begin
              print,'add_noise: dblarr_sigma_calc(indarr,*) = ',dblarr_sigma_calc(indarr,*)
              print,'add_noise: i = ',i
              stop
            endif
            if abs(dblarr_sigma_calc(indarr(0),1) - dblarr_sigma_calc(indarr(1),1)) gt (1.1 * 0.5) then begin
              print,'add_noise: PROBLEM: abs(dblarr_sigma_calc(indarr(0)=',indarr(0),',1)=',dblarr_sigma_calc(indarr(0),1),' - dblarr_sigma_calc(indarr(1)=',indarr(1),',1)=',dblarr_sigma_calc(indarr(1),1),')=',abs(dblarr_sigma_calc(indarr(0),1) - dblarr_sigma_calc(indarr(1),1)),' gt (1.1 * 0.5)'
              stop
            endif

            ; --- teff
            indarr_temp = indarr
            indarr = where(dblarr_sigma_calc(indarr_temp,2) eq dblarr_teff_calc(i))
            if n_elements(indarr) ne 1 then begin
              print,'add_noise: teff: PROBLEM: indarr(=',indarr,') ne -1'
              indarr_dum = ulonarr(2*n_elements(indarr))
              for l=0ul, n_elements(indarr)-1 do begin
                indarr_dum(2*l) = indarr(l)
                indarr_dum((2*l)+1) = indarr(l)+1
              endfor
              indarr = indarr_dum
            end else begin
              indarr = where(abs(dblarr_sigma_calc(indarr_temp,2) - dblarr_teff_calc(i)) le 0.01)
            endelse
            indarr = indarr_temp(indarr)
            indarr_sigma = indarr
            if B_DEBUG then $
              print,'add_noise: n_elements(indarr(teff)) = ',n_elements(indarr)
            if n_elements(indarr) ne 8 then begin
              print,'add_noise: dblarr_sigma_calc(indarr,*) = ',dblarr_sigma_calc(indarr,*)
              print,'add_noise: i = ',i
              stop
            endif
            if abs(dblarr_sigma_calc(indarr(0),2) - dblarr_sigma_calc(indarr(1),2)) gt (1.1 * 0.01) then begin
              print,'add_noise: PROBLEM: abs(dblarr_sigma_calc(indarr(0)=',indarr(0),',2)=',dblarr_sigma_calc(indarr(0),2),' - dblarr_sigma_calc(indarr(1)=',indarr(1),',2)=',dblarr_sigma_calc(indarr(1),2),')=',abs(dblarr_sigma_calc(indarr(0),2) - dblarr_sigma_calc(indarr(1),2)),' gt (1.1 * 0.01)'
              stop
            endif


            dblarr_sigma_interp_temp = dblarr(n_elements(indarr)/2,3)
            if B_DEBUG then begin
              print,'add_noise: indarr = ',indarr
              print,'add_noise: size(indarr) = ',size(indarr)
              print,'add_noise: dblarr_sigma_calc(indarr,*) = ',dblarr_sigma_calc(indarr,*)
              for j=0ul, n_elements(indarr) - 1 do begin
                print,dblarr_sigma_calc(indarr(j),0),dblarr_sigma_calc(indarr(j),1),dblarr_sigma_calc(indarr(j),2),dblarr_sigma_calc(indarr(j),3)
              endfor
            endif

            dbl_teff = 10.^dblarr_teff_calc(i)

            if B_DEBUG then begin
              print,'add_noise: before "for j=0,n_elements(indarr) / 2 - 1 do begin": indarr = ',indarr
              print,'add_noise: before "for j=0,n_elements(indarr) / 2 - 1 do begin": size(indarr) = ',size(indarr)
              print,'add_noise: before "for j=0,n_elements(indarr) / 2 - 1 do begin": n_elements(indarr) = ',n_elements(indarr)
            endif
            for j=0,n_elements(indarr) / 2 - 1 do begin
              dbl_teff_a = 10.^dblarr_sigma_calc(indarr(2*j),2)
              dbl_teff_b = 10.^dblarr_sigma_calc(indarr((2*j)+1),2)
              if B_DEBUG then begin
                print,'add_noise: j = ',j,': dbl_teff_a = ',dbl_teff_a
                print,'add_noise: j = ',j,': dbl_teff_b = ',dbl_teff_b
                print,'add_noise: j = ',j,': dblarr_sigma_calc(2*j,*) = ',dblarr_sigma_calc(2*j,*)
              endif
              dblarr_sigma_interp_temp(j,0) = dblarr_sigma_calc(indarr(2*j),0)
              dblarr_sigma_interp_temp(j,1) = dblarr_sigma_calc(indarr(2*j),1)
              if B_DEBUG then $
                print,'add_noise: dbl_teff_a = ',dbl_teff_a,', dbl_teff_b = ',dbl_teff_b,', dblarr_sigma_calc(indarr(2*(j=',j,'))=',indarr(2*j),',3) = ',dblarr_sigma_calc(indarr(2*j),3),', dblarr_sigma_calc(indarr((2*j)+1)=',indarr((2*j)+1),',3) = ',dblarr_sigma_calc(indarr((2*j)+1),3),', dbl_teff = ',dbl_teff
              dblarr_sigma_interp_temp(j,2) = get_lin_fit_val(dbl_teff_a,dbl_teff_b,dblarr_sigma_calc(indarr(2*j),3),dblarr_sigma_calc(indarr((2*j)+1),3),dbl_teff)
              if B_DEBUG then begin
                print,'add_noise: j = ',j
                print,'add_noise: dblarr_sigma_interp_temp(j=',j,',*) = ',dblarr_sigma_interp_temp(j,*)
                print,'add_noise: indarr = ',indarr
                print,'add_noise: size(indarr) = ',size(indarr)
              endif
            endfor
            if B_DEBUG then begin
              print,'add_noise: dblarr_sigma_interp_temp = ',dblarr_sigma_interp_temp
            endif
            dblarr_sigma_interp_mh = dblarr(n_elements(indarr)/4,2)
            if B_DEBUG then begin
              print,'add_noise: size(dblarr_sigma_interp_mh) = ',size(dblarr_sigma_interp_mh)
              print,'add_noise: n_elements(dblarr_sigma_interp_mh) = ',n_elements(dblarr_sigma_interp_mh)
              print,'add_noise: before "for j=0,n_elements(indarr) / 4 - 1 do begin": indarr = ',indarr
              print,'add_noise: before "for j=0,n_elements(indarr) / 4 - 1 do begin": size(indarr) = ',size(indarr)
              print,'add_noise: before "for j=0,n_elements(indarr) / 4 - 1 do begin": n_elements(indarr) = ',n_elements(indarr)
            endif
            for j=0,n_elements(indarr) / 4 - 1 do begin
              if B_DEBUG then begin
                print,'add_noise: j=',j,': dblarr_sigma_interp_temp(2*j,*) = ',dblarr_sigma_interp_temp(2*j,*)
                print,'add_noise: j=',j,': dblarr_sigma_interp_temp(2*j+1,*) = ',dblarr_sigma_interp_temp(2*j+1,*)
                print,'add_noise: i_dblarr_mh(i) = ',i_dblarr_mh(i)
              endif
              dblarr_sigma_interp_mh(j,0) = dblarr_sigma_interp_temp(2*j,0)
              if B_DEBUG then $
                print,'add_noise: dblarr_sigma_interp_mh(j=',j,',0) = ',dblarr_sigma_interp_mh(j,0)

              dbl_sigma_a = dblarr_sigma_interp_temp(2*j,2)
              dbl_sigma_b = dblarr_sigma_interp_temp((2*j)+1,2)
              dbl_mh_a = dblarr_sigma_interp_temp(2*j,1)
              dbl_mh_b = dblarr_sigma_interp_temp((2*j)+1,1)
              if dbl_mh_a gt dbl_mh_b then begin
                if B_DEBUG then $
                  print,'add_noise: dbl_mh_a(=',dbl_mh_a,') gt dbl_mh_b(=',dbl_mh_b,')'
                dbl_temp = dbl_mh_a
                dbl_mh_a = dbl_mh_b
                dbl_mh_b = dbl_temp
                dbl_temp = dbl_sigma_a
                dbl_sigma_a = dbl_sigma_b
                dbl_sigma_b = dbl_temp
                if B_DEBUG then begin
                  print,'add_noise: dbl_mh_a = ',dbl_mh_a
                  print,'add_noise: dbl_mh_b = ',dbl_mh_b
                  print,'add_noise: dbl_sigma_a = ',dbl_sigma_a
                  print,'add_noise: dbl_sigma_b = ',dbl_sigma_b
                endif
              endif
              dblarr_sigma_interp_mh(j,1) = get_lin_fit_val(dbl_mh_a,dbl_mh_b,dbl_sigma_a,dbl_sigma_b,dblarr_mh_calc(i))
              if B_DEBUG then $
                print,'add_noise: dblarr_sigma_interp_mh(j=',j,',1) = ',dblarr_sigma_interp_mh(j,1)
            endfor
            if B_DEBUG then $
              print,'add_noise: dblarr_sigma_interp_mh = ',dblarr_sigma_interp_mh

            dbl_sigma_fourty = get_lin_fit_val(dblarr_sigma_interp_mh(0,0),dblarr_sigma_interp_mh(1,0),dblarr_sigma_interp_mh(0,1),dblarr_sigma_interp_mh(1,1),dblarr_logg_calc(i))
            if B_DEBUG then $
              print,'add_noise: dbl_sigma_fourty = ',dbl_sigma_fourty

            if abs(i_dblarr_snr_besancon(i)) lt 0.0001 then $
              i_dblarr_snr_besancon(i) = 0.2
            if i_dblarr_snr_besancon(i) lt 80 then begin
              dbl_r = i_dblarr_snr_besancon(i) / 40.
            end else begin
              dbl_r = 2.
            endelse
            if B_DEBUG then begin
              print,'add_noise: i_dbl_k = ',i_dbl_k
              print,'add_noise: dbl_r = ',dbl_r
            end
            i_dbl_sigma = (dbl_r ^ i_dbl_k) * dbl_sigma_fourty
            if B_DEBUG then begin
              print,'add_noise: i_dbl_sigma = ',i_dbl_sigma
              print,'add_noise: dblarr_sigma_calc(indarr_sigma=',indarr_sigma,',*) = ',dblarr_sigma_calc(indarr_sigma,*)
              print,'add_noise: dbl_sigma_fourty = ',dbl_sigma_fourty
              print,'add_noise: io_dblarr_data(i=',i,') = ',io_dblarr_data(i)
            end
          endif; keyword_set(i_dbl_k)
          if keyword_set(I_B_PERCENT) then begin
            b_found = 0
            dbl_range = 0.
            while not b_found do begin
              dbl_range = dbl_range + 0.05
              indarr_logg = where(i_dblarr_rave_logg lt (dblarr_logg_calc(i) + dbl_range) and (i_dblarr_rave_logg gt dblarr_logg_calc(i) - dbl_range))
              if indarr_logg(0) gt -1 then begin
                dbl_distrange = 0.
                i_dum = 0
                while (not b_found) and (i_dum lt 10) do begin
                  i_dum = i_dum + 1
                  if io_dblarr_data(i) gt 20. then begin
                    dbl_distrange = dbl_distrange + 2.5
                  end else if io_dblarr_data(i) gt 10. then begin
                    dbl_distrange = dbl_distrange + 1.5
                  end else begin
                    dbl_distrange = dbl_distrange + 0.005
                  end
                  indarr_dist = where(i_dblarr_rave_dist(indarr_logg) lt (io_dblarr_data(i) + dbl_distrange) and (i_dblarr_rave_dist(indarr_logg) gt io_dblarr_data(i) - dbl_distrange))
                  if indarr_dist(0) ge 0 then begin
                    b_found = 1
                    print,'add_noise: star with logg = ',i_dblarr_logg(i),' found: dbl_range = ',dbl_range,', dbl_distrange = ',dbl_distrange
                  endif
                endwhile
              endif
            end
            random_nr = long(RANDOMU(seed,/UNIFORM) * (n_elements(indarr_dist)))
            i_dbl_sigma = alog10(i_dblarr_rave_edist(indarr_logg(indarr_dist(random_nr))) / 0.01) / 0.2
            print,'add_noise: old dist = ',io_dblarr_data(i)
            dbl_dist = alog10(io_dblarr_data(i) / 0.01) / 0.2
            print,'add_noise: old mu = ',dbl_dist
          end; if keyword_set(B_PERCENT)





          print,'add_noise: i_dbl_sigma = ',i_dbl_sigma
          if keyword_set(I_B_REAL_ERR) then begin
            o_dblarr_err(i) = i_dbl_sigma
          end else begin
            o_dblarr_err(i) = RANDOMN(io_dbl_seed) * i_dbl_sigma
          endelse
          print,'add_noise: o_dblarr_err(i=',i,') = ',o_dblarr_err(i)
          if keyword_set(I_DBL_DIVIDE_ERROR_BY) then $
            o_dblarr_err(i) = o_dblarr_err(i) / i_dbl_divide_error_by
    ;      print,'add_noise: o_dblarr_err(i=',i,') = ',o_dblarr_err(i)
          if not keyword_set(I_B_PERCENT) then begin
            print,'add_noise: old io_dblarr_data(i=',i,') = ',io_dblarr_data(i)
            io_dblarr_data(i) = io_dblarr_data(i) + o_dblarr_err(i)
          end else begin
            dbl_dist = dbl_dist + o_dblarr_err(i)
            io_dblarr_data(i) = 0.01 * 10.^(0.2*dbl_dist)
          endelse
          print,'add_noise: new io_dblarr_data(i=',i,') = ',io_dblarr_data(i)

          str_dum = strtrim(string(io_dblarr_data(i)),2)
          if strmid(str_dum,strlen(str_dum)-3,3) eq 'NaN' then stop
          if strmid(str_dum,strlen(str_dum)-3,3) eq 'Inf' then stop
          if strmid(str_dum,strlen(str_dum)-8,8) eq 'Infinity' then stop
          print,' '
        endif
      endelse
    endelse
  endfor
  if b_sigma_set then $
    free_lun,lun_vrad

  if keyword_set(I_DBLARR_TEFF) then begin
    i_dblarr_teff = 10.^i_dblarr_teff
    print,'add_noise: I_DBLARR_TEFF set'
;    o_dblarr_err = 10.^o_dblarr_err
  end; else begin
end
