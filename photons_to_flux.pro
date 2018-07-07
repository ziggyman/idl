pro photons_to_flux, str_filename_in, dbl_exptime, dbl_a_tel
  dblarr_wlen_photons = double(readfiletostrarr(str_filename_in, ' '))
  
  size_data = size(dblarr_wlen_photons)
  print,'size_data = ',size_data
  dblarr_dwlen = dblarr(size_data(2))
end
