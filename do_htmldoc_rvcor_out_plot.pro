;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################################
pro do_htmldoc_rvcor_out_plot
;############################################

    do_htmldoc_rvcor_out_plot_all_emission_lines
    do_htmldoc_rvcor_out_plot_known_emission_lines

    openw,lunw,'/yoda/UVES/MNLupus/ready/website/vhelio/index.html',/GET_LUN
    printf,lunw,'<html>'
    printf,lunw,'<head>'
    printf,lunw,'<TITLE>MNLupus - heliocentric radial velocities</TITLE>'
    printf,lunw,'</head>'
    printf,lunw,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lunw,'<center>'
    printf,lunw,'<h1>MNLupus: heliocentric radial velocities of the emission features</h1><br>'
    printf,lunw,'<h3>Because not all emission features could be identified, the radial velocity measurements have been done in two different ways:</h3><br><br>'
    printf,lunw,'For the emission features with <b>known rest wavelengths</b> (air) the observed and heliocentric radial velocities could be determined. This has been done using the IRAF task "onedspec.fitprofs" (to fit a Gauss function into the feature), additional self written IDL procedures (to compare the "fitprofs" output to the rest wavelengths and calculate and plot the observed radial velocities using the formula v/c=d_lambda/lambda) and the IRAF task "rv.rvcorrect" (to calculate the heliocentric radial velocities).<br><br>'
    printf,lunw,'<a href=index_known_blue.html>Blue channel (3290-4512 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_known_red_r.html>Red channel, right chip (4780-5745 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_known_red_l.html>Red channel, left chip (5830-6810 Angstroem)</a><br><br><hr><br>'
    printf,lunw,'For <b>all emission features</b> (also those without known rest positions) the position in the first spectrum has been measured and taken as rest wavelength to calculate at least the movement with respect to the first image. This has been done the same way like described above.</h3><br><br>'
    printf,lunw,'<a href=index_all_blue.html>Blue channel (3290-4512 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_all_red_r.html>Red channel, right chip (4780-5745 Angstroem)</a><br><br>'
    printf,lunw,'<a href=index_all_red_l.html>Red channel, left chip (5830-6810 Angstroem)</a><br><br>'
    printf,lunw,'</body></html>'
    free_lun,lunw

end
