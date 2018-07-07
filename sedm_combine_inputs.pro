pro sedm_combine_inputs
  str_filename_source = '/home/azuri/spectra/SEDIFU/input/Source-Spectrum_ang_r.dat'
  str_filename_source_qe = '/home/azuri/spectra/SEDIFU/input/Source+QE-Spectrum_ang_r.dat'
  str_filename_sky = '/home/azuri/spectra/SEDIFU/input/Sky-Spectrum_ang_r.dat'
  str_filename_sky_qe = '/home/azuri/spectra/SEDIFU/input/Sky+QE-Spectrum_ang_r.dat'
  str_filename_moon = '/home/azuri/spectra/SEDIFU/input/Moon-Spectrum_ang_r.dat'
  str_filename_input_source_resolution = '/home/azuri/spectra/SEDIFU/input/Input-Source-Resolution_ang_r.dat'
  str_filename_instrument_resolution = '/home/azuri/spectra/SEDIFU/input/Instrument-Resolution_ang_r.dat'
  
  str_filename_measured_sky = '/home/azuri/spectra/SEDIFU/obs_sky_sEcDR.text'
  str_filename_measured_sky_from_sum = '/home/azuri/spectra/SEDIFU/obs_skyFromSum.text'
  str_filename_measured_source_and_sky = '/home/azuri/spectra/SEDIFU/SEDM-deep-TEST-2012-05-14_obs_s_Ec_ap974_x1034_y1130_dr.text'
  str_filename_measured_source_and_sky_from_sum = '/home/azuri/spectra/SEDIFU/SEDM-deep-TEST-2012-05-14_obs_s_EcSum_ap974_x1034_y1130_dr.text'
  
  str_filename_combined_out = '/home/azuri/spectra/SEDIFU/input/Combined_Source+Sky+Moon_times_InputSourceResolution_divby_QE_ang_r.dat'
  
  dblarr_source = double(readfiletostrarr(str_filename_source,' '))
  dblarr_source_qe = double(readfiletostrarr(str_filename_source_qe,' '))
  dblarr_sky = double(readfiletostrarr(str_filename_sky,' '))
  dblarr_sky_qe = double(readfiletostrarr(str_filename_sky_qe,' '))
  dblarr_moon = double(readfiletostrarr(str_filename_moon,' '))
  dblarr_input_source_resolution = double(readfiletostrarr(str_filename_input_source_resolution,' '))
  dblarr_instrument_resolution = double(readfiletostrarr(str_filename_instrument_resolution,' '))
  
;  dblarr_qe_sky = dblarr_sky
;  dblarr_qe_sky(*,1) = dblarr_qe_sky(*,1) / dblarr_sky_qe(*,1)
;  dblarr_poly_coeffs = poly_fit(dblarr_qe_sky(*,0),dblarr_qe_sky(*,1),6,YFIT=dblarr_qe_sky_fit)
;  
;  dblarr_qe_sky_fit = 1. / dblarr_qe_sky_fit
;  plot,dblarr_qe_sky(*,0),1./dblarr_qe_sky(*,1)
;  oplot,dblarr_qe_sky(*,0),dblarr_qe_sky_fit
;  

  dblarr_qe_source = dblarr_source
  dblarr_qe_source(*,1) = dblarr_qe_source(*,1) / dblarr_source_qe(*,1)
  dblarr_poly_coeffs = poly_fit(dblarr_qe_source(*,0),dblarr_qe_source(*,1),6,YFIT=dblarr_qe_source_fit)

  dblarr_measured_source = double(readfiletostrarr(str_filename_measured_source_and_sky,' '))
  dblarr_measured_source_from_sum = double(readfiletostrarr(str_filename_measured_source_and_sky_from_sum,' '))
  dblarr_measured_sky = double(readfiletostrarr(str_filename_measured_sky,' '))
  dblarr_measured_sky_from_sum = double(readfiletostrarr(str_filename_measured_sky_from_sum,' '))
  
  dblarr_qe_source = 1. / dblarr_qe_source
  
  ; --- plot instrument response curve calculated from input source and source+qe data
  plot,dblarr_qe_source(*,0),1./dblarr_qe_source(*,1)
  ;oplot,dblarr_qe_source(*,0),dblarr_qe_source_fit

  dblarr_sky_qe(*,1) = dblarr_sky(*,1) * dblarr_qe_source(*,1)
  
  ; --- plot instrument resolution
  plot,dblarr_input_source_resolution(*,0),dblarr_input_source_resolution(*,1)
  
  ; --- plot instrument resolution
;  plot,dblarr_instrument_resolution(*,0),dblarr_instrument_resolution(*,1)
;  oplot,dblarr_source(*,0),dblarr_source(*,1)
  dblarr_combined = dblarr_source
  dblarr_combined(*,1) = dblarr_combined(*,1) + dblarr_sky(*,1)
  dblarr_combined(*,1) = dblarr_combined(*,1) + dblarr_moon(*,1)
  dblarr_combined(*,1) = dblarr_combined(*,1) * dblarr_qe_source(*,1)
;  dblarr_combined(*,1) = dblarr_combined(*,1) * dblarr_input_source_resolution(*,1)
  dblarr_combined(*,1) = dblarr_combined(*,1) * dblarr_combined(*,0)
  
  write_file, I_STRARR_DATA   = strtrim(string(dblarr_combined),2),$
;                I_STRARR_HEADER = i_strarr_header,$
                I_STR_FILENAME  = str_filename_combined_out
  
  dblarr_combined_sky = dblarr_sky
  dblarr_combined_sky(*,1) = dblarr_combined_sky(*,1) + dblarr_moon(*,1)
  dblarr_combined_sky(*,1) = dblarr_combined_sky(*,1) / dblarr_qe_source(*,1)
;  dblarr_combined_sky(*,1) = dblarr_combined_sky(*,1) * dblarr_input_source_resolution(*,1)
  dblarr_combined_sky(*,1) = dblarr_combined_sky(*,1) * dblarr_combined_sky(*,0)

  ; --- plot measured source from Sum and median-scaled combined input data (source + sky + moon) / instrument_response * input_source_resolution
  plot,dblarr_measured_source_from_sum(*,0),dblarr_measured_source_from_sum(*,1)
  oplot,dblarr_combined(*,0),dblarr_combined(*,1) * mean(dblarr_measured_source_from_sum(*,1)) / mean(dblarr_combined(*,1)),linestyle=2
stop
  ; --- plot ratio between both previous plots
;  plot,dblarr_combined(*,0),dblarr_combined(*,1) * mean(dblarr_measured_source_from_sum(*,1)) / (mean(dblarr_combined(*,1)) * dblarr_measured_source_from_sum(*,1))

  ; --- plot measured source from Piskunov and median-scaled combined input data (source + sky + moon) / instrument_response  
  plot,dblarr_measured_source(*,0),dblarr_measured_source(*,1)
  oplot,dblarr_combined(*,0),dblarr_combined(*,1) * mean(dblarr_measured_source(*,1)) / mean(dblarr_combined(*,1)),linestyle=2
  
  ; --- plot ratio between both previous plots
;  plot,dblarr_combined(*,0),dblarr_combined(*,1) * mean(dblarr_measured_source(*,1)) / (mean(dblarr_combined(*,1)) * dblarr_measured_source(*,1)),yrange=[0,2.],ystyle=1
  
;  print,'dblarr_combined = ',dblarr_combined(*,1)
;  print,'dblarr_measured_source = ',dblarr_measured_source
;  print,'dblarr_plot = ',dblarr_combined(*,1) * mean(dblarr_measured_source(*,1)) / (mean(dblarr_combined(*,1)) * dblarr_measured_source(*,1))

  ; --- plot ratio between measured source from Piskunov and measured source from sum
;  plot,dblarr_measured_source(*,0),dblarr_measured_source(*,1) / dblarr_measured_source_from_sum(*,1),yrange=[0.,2.],ystyle=1
  
  ; --- plot measured source from Piskunov and measured source from sum
;  plot,dblarr_measured_source(*,0),dblarr_measured_source(*,1)
;  oplot,dblarr_measured_source_from_sum(*,0),dblarr_measured_source_from_sum(*,1),linestyle=2

  ; --- plot measured sky and combined input sky
;  plot,dblarr_combined_sky(*,0),dblarr_combined_sky(*,1) * mean(dblarr_measured_sky(*,1)) / mean(dblarr_combined_sky(*,1)),linestyle=2
;  oplot,dblarr_measured_sky(*,0),dblarr_measured_sky(*,1)

  ; --- plot measured sky from sum and combined input sky
;  plot,dblarr_measured_sky_from_sum(*,0),dblarr_measured_sky_from_sum(*,1)
;  oplot,dblarr_combined_sky(*,0),dblarr_combined_sky(*,1) * mean(dblarr_measured_sky_from_sum(*,1)) / mean(dblarr_combined_sky(*,1)),linestyle=2

;  print,'mean(dblarr_sky) = ',mean(dblarr_sky)
;  print,'mean(dblarr_moon) = ',mean(dblarr_moon)
;  print,'mean(dblarr_source) = ',mean(dblarr_source)
;  print,'mean(dblarr_combined) = ',mean(dblarr_combined)

end
