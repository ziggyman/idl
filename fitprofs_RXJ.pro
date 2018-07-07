pro fitprofs_RXJ

; --- delete old results
    spawn,'rm /yoda/UVES/MNLupus/ready/*/fitprofs_list_out_*_sort_out*'

; --- red_l all emission lines
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs_all_emission_lines_to_fit_ranges_l.log','/yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out.dat'
;    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_l/all_emission_lines_to_fit_ranges_l.dat','/yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs_all_emission_lines_to_fit_ranges_l.log','/yoda/UVES/MNLupus/ready/red_l/lambda_rest_all_emission_lines_l.dat','/yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out.dat','/yoda/UVES/MNLupus/ready/red_l/lambda_rest_all_emission_lines_l.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_all_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l_hjd_vobs.list'

; --- remove H_alpha line from list
;    spawn,'head -n -1 single_wavelength_files_red_l_hjd_vobs.list > single_wavelength_files_RXJ_red_l_hjd_vobs.list'

    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_all_emission_lines_l_hjd_vobs.list','/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_red.dat','/yoda/UVES/MNLupus/ready/ras_hms_red.dat','/yoda/UVES/MNLupus/ready/decs_hms_red.dat'

; --- red_l know lines
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs_known_emission_lines_to_fit_ranges_l.log','/yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out.dat','/yoda/UVES/MNLupus/ready/red_l/lambda_rest_known_emission_lines_l.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_known_emission_lines_to_fit_ranges_l_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l_hjd_vobs.list'
    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/red_l/single_wavelength_files_known_emission_lines_l_hjd_vobs.list','/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_red.dat','/yoda/UVES/MNLupus/ready/ras_hms_red.dat','/yoda/UVES/MNLupus/ready/decs_hms_red.dat'

; --- red_r all emission lines
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_r/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_r/logfile_fitprofs_all_emission_lines_to_fit_ranges_r.log','/yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out.dat','/yoda/UVES/MNLupus/ready/red_r/lambda_rest_all_emission_lines_r.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_all_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r_hjd_vobs.list'

; --- remove H_alpha line from list
;    spawn,'head -n -1 single_wavelength_files_red_r_hjd_vobs.list > single_wavelength_files_RXJ_red_r_hjd_vobs.list'

    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_all_emission_lines_r_hjd_vobs.list','/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_red.dat','/yoda/UVES/MNLupus/ready/ras_hms_red.dat','/yoda/UVES/MNLupus/ready/decs_hms_red.dat'

; --- red_r know lines
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_r/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_r/logfile_fitprofs_known_emission_lines_to_fit_ranges_r.log','/yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out.dat','/yoda/UVES/MNLupus/ready/red_r/lambda_rest_known_emission_lines_r.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_known_emission_lines_to_fit_ranges_r_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r_hjd_vobs.list'
    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/red_r/single_wavelength_files_known_emission_lines_r_hjd_vobs.list','/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_red.dat','/yoda/UVES/MNLupus/ready/ras_hms_red.dat','/yoda/UVES/MNLupus/ready/decs_hms_red.dat'

; --- blue all emission lines
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/blue/logfile_fitprofs_all_emission_lines_to_fit_ranges_blue.log','/yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out.dat','/yoda/UVES/MNLupus/ready/blue/lambda_rest_all_emission_lines_blue.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue.list','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_all_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_hjd_vobs.list'

; --- remove H_alpha line from list
;    spawn,'head -n -1 single_wavelength_files_blue_hjd_vobs.list > single_wavelength_files_RXJ_blue_hjd_vobs.list'

    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_all_emission_lines_blue_hjd_vobs.list','/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_blue.dat','/yoda/UVES/MNLupus/ready/ras_hms_blue.dat','/yoda/UVES/MNLupus/ready/decs_hms_blue.dat'

; --- blue know lines
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue_*_hjd_vobsmean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vobs.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue_*_hjd_vheliomean.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vhelio.eps'
    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out_????.*.dat'
    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/blue/logfile_fitprofs_known_emission_lines_to_fit_ranges_blue.log','/yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out.dat'
    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out.dat','/yoda/UVES/MNLupus/ready/blue/lambda_rest_known_emission_lines_blue.dat'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out_????.*.dat > /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue.list'
    fitprofs_out_plot_list,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue.list','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_known_emission_lines_to_fit_ranges_blue_sort_out_????.*_hjd_vobs.dat > /yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue_hjd_vobs.list'
    fitprofs_plot_hjd_vobsmean,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue_hjd_vobs.list'
    write_rvcorrect_input_lists,'/yoda/UVES/MNLupus/ready/blue/single_wavelength_files_known_emission_lines_blue_hjd_vobs.list','/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/utc_middle_hms_blue.dat','/yoda/UVES/MNLupus/ready/ras_hms_blue.dat','/yoda/UVES/MNLupus/ready/decs_hms_blue.dat'




    do_htmldoc_plot_equiwidths_and_airmass
    do_htmldoc_fitprofs_out_plot






; --- red_l_disk
;    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_l/disc_lines_to_fit_ranges.dat','/yoda/UVES/MNLupus/ready/red_l/logfile_fitprofs_disc_lines_to_fit_ranges.log','/yoda/UVES/MNLupus/ready/red_l/lambda_rest_disc_emission_lines.dat','/yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_l_sort_out.dat'
;    spawn,'rm /yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_l_sort_out_????.*.dat'
;    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_l_sort_out.dat','/yoda/UVES/MNLupus/ready/red_l/lambda_rest_disc_emission_lines.dat'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_l_sort_out_????.*.dat > single_wavelength_files_disc_red_l.list'
;    fitprofs_out_plot_list,'single_wavelength_files_disc_red_l.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_list_out_l_sort_out_????.*_hjd_vobs.dat > single_wavelength_files_disc_red_l_hjd_vobs.list'
;
;    fitprofs_plot_hjd_vobsmean,'single_wavelength_files_disc_red_l_hjd_vobs.list'
;
;; --- red_r
;    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_out_????.*.dat'
;    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_r/fitprofs_out.txt','/home/azuri/daten/atomic_line_list/emission_lines_red_r.dat'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_out_????.*.dat > single_wavelength_files_red_r.list'
;    fitprofs_out_plot_list,'single_wavelength_files_red_r.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_l/fitprofs_out_????.*_hjd_vobs.dat > single_wavelength_files_red_r_hjd_vobs.list'
;
;; --- remove H_beta line from list
;;    spawn,'head -n 1 single_wavelength_files_red_r_hjd_vobs.list > single_wavelength_files_RXJ_red_r_hjd_vobs.list'
;
;    fitprofs_plot_hjd_vobsmean,'single_wavelength_files_red_r_hjd_vobs.list'
;
;; --- red_r_disk
;    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/red_r/RXJ_ctc.list','/yoda/UVES/MNLupus/ready/red_r/logfile_fitprofs.log','/yoda/UVES/MNLupus/ready/red_r/lambda_rest_disc_emission_lines.dat','/yoda/UVES/MNLupus/ready/red_r/fitprofs_list_out_r_sort_out.dat'
;    spawn,'rm /yoda/UVES/MNLupus/ready/red_r/fitprofs_list_out_r_sort_out_????.*.dat'
;    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/red_r/fitprofs_list_out_r_sort_out.dat','/yoda/UVES/MNLupus/ready/red_r/lambda_rest_disc_emission_lines.dat'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_list_out_r_sort_out_????.*.dat > single_wavelength_files_disc_red_r.list'
;    fitprofs_out_plot_list,'single_wavelength_files_disc_red_r.list','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/red_r/fitprofs_list_out_r_sort_out_????.*_hjd_vobs.dat > single_wavelength_files_disc_red_r_hjd_vobs.list'
;
;    fitprofs_plot_hjd_vobsmean,'single_wavelength_files_disc_red_r_hjd_vobs.list'
;
;; --- blue
;    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_out_????.*.dat'
;    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/blue/fitprofs_out.txt','/home/azuri/daten/atomic_line_list/emission_lines_blue.dat'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_out_????.*.dat > single_wavelength_files_blue.list'
;    fitprofs_out_plot_list,'single_wavelength_files_blue.list','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_out_????.*_hjd_vobs.dat > single_wavelength_files_blue_hjd_vobs.list'
;    fitprofs_plot_hjd_vobsmean,'single_wavelength_files_blue_hjd_vobs.list'
;
;; --- blue_disk
;    fitprofs_list_out_sort,'/yoda/UVES/MNLupus/ready/blue/RXJ_blue_ctc.list','/yoda/UVES/MNLupus/ready/blue/logfile_fitprofs.log','/yoda/UVES/MNLupus/ready/blue/lambda_rest_disc_emission_lines.dat','/yoda/UVES/MNLupus/ready/blue/fitprofs_list_out_blue_sort_out.dat'
;    spawn,'rm /yoda/UVES/MNLupus/ready/blue/fitprofs_list_out_blue_sort_out_????.*.dat'
;    fitprofs_out_trim,'/yoda/UVES/MNLupus/ready/blue/fitprofs_list_out_blue_sort_out.dat','/yoda/UVES/MNLupus/ready/blue/lambda_rest_disc_emission_lines.dat'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_list_out_blue_sort_out_????.*.dat > single_wavelength_files_disc_blue.list'
;    fitprofs_out_plot_list,'single_wavelength_files_disc_blue.list','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'
;    spawn,'ls -1 /yoda/UVES/MNLupus/ready/blue/fitprofs_list_out_blue_sort_out_????.*_hjd_vobs.dat > single_wavelength_files_disc_blue_hjd_vobs.list'
;
;    fitprofs_plot_hjd_vobsmean,'single_wavelength_files_disc_blue_hjd_vobs.list'

end
