pro make_pdf,str_psfile
  str_filename_root = strmid(str_psfile,0,strpos(str_psfile,'.',/REVERSE_SEARCH))
  str_giffile = str_filename_root+'.gif'
  str_tifffile = str_filename_root+'.tiff'
  str_pdffile = str_filename_root+'.pdf'

  spawn,'ps2gif '+str_psfile+' '+str_giffile
  spawn,'gif2tiff '+str_giffile+' '+str_tifffile
  spawn,'tiff2pdf '+str_tifffile+' > '+str_pdffile
  spawn,'rm '+str_tifffile
end
