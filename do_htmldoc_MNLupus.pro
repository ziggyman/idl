pro do_htmldoc_MNLupus

; pre: * 'fitprofs_RXJ.pro'
;      * 'vobscorlist_prepare.pro'
;      * IRAF task 'vobscorlist.cl'

; --- write index.html
    openw,lun,'/yoda/UVES/MNLupus/ready/website/index.html',/GET_LUN
    printf,lun,'<html>'
    printf,lun,'<head>'
    printf,lun,'<TITLE>MNLupus - Results</TITLE>'
    printf,lun,'</head>'
    printf,lun,'<body text="#00FFC8" link="#00FFFF" alink="#000096" vlink="#FFFF96" bgcolor="#000000">'
    printf,lun,'<center>'
    printf,lun,'<h1>MNLupus: Results</h1><br>'
    printf,lun,'<a href=equiwidths_calc/index.html><h3>Measured equivalent widths over hjd</h3></a><br><br>'
    printf,lun,'<a href=equiwidths/index.html><h3>Measured equivalent widths (with Gauss fit) over hjd and airmass</h3></a><br><br>'
    printf,lun,'<a href=i_res_lambda/index.html><h3>Grey-scale plots of some interesting features</h3></a><br><br>'
    printf,lun,'<a href=vobs/index.html><h3>Observed radial velocities over hjd (emission lines)</h3></a><br><br>'
    printf,lun,'<a href=vhelio/index.html><h3>Heliocentric radial velocities over hjd (emission lines)</h3></a><br><br>'
    printf,lun,'<a href=vhelio/ranges/index.html><h3>Heliocentric radial velocities over hjd (regions without emission lines)</h3></a><br><br>'
    printf,lun,'<a href=exptimes/index.html><h3>Exposure times</h3></a><br><br>'
    printf,lun,'</body></html>'
    free_lun,lun

    spawn,'rm -rf /yoda/UVES/MNLupus/ready/website/vobs'
    spawn,'rm -rf /yoda/UVES/MNLupus/ready/website/vhelio'
    spawn,'rm -rf /yoda/UVES/MNLupus/ready/website/equiwidths'
    spawn,'rm -rf /yoda/UVES/MNLupus/ready/website/equiwidths_calc'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/vobs'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/vhelio'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/vhelio/ranges'
;    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/exptimes'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/equiwidths_calc'
    spawn,'mkdir /yoda/UVES/MNLupus/ready/website/equiwidths'

    do_htmldoc_I_res_lambda
    do_htmldoc_plot_equiwidths_and_airmass
    do_htmldoc_fitprofs_out_plot

    vobscorlist_out
    do_htmldoc_rvcor_out_plot
    do_htmldoc_calcequiwidths

; --- to remove regions from calculation comment out the corresponding
;     lines in file fxcor_out_trim_list_no_emission
    do_htmldoc_fxcor_no_emission_lines

    spawn,'cp -pr /yoda/UVES/MNLupus/ready/website_vhelio_ranges/ /yoda/UVES/MNLupus/ready/website/vhelio/all_ranges/'

end
