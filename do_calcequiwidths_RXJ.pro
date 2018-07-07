pro do_calcequiwidths_RXJ

; --- blue
;    calcequiwidths_RXJ_trim_rangelist,'/yoda/UVES/MNLupus/ready/blue/all_emission_lines_to_fit_ranges_blue.dat'
    calcequiwidths_RXJ,'/yoda/UVES/MNLupus/ready/blue/RXJ_ctc.text.list','/yoda/UVES/MNLupus/ready/blue/all_emission_lines_to_calc_equiwidth_blue.dat','/yoda/UVES/MNLupus/ready/blue/hjds_blue.text'

; --- red_r
;    calcequiwidths_RXJ_trim_rangelist,'/yoda/UVES/MNLupus/ready/red_r/all_emission_lines_to_fit_ranges_r.dat'
    calcequiwidths_RXJ,'/yoda/UVES/MNLupus/ready/red_r/RXJ_ctc.text.list','/yoda/UVES/MNLupus/ready/red_r/all_emission_lines_to_calc_equiwidth_r.dat','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'

; --- red_l
;    calcequiwidths_RXJ_trim_rangelist,'/yoda/UVES/MNLupus/ready/red_l/all_emission_lines_to_fit_ranges_l.dat'
    calcequiwidths_RXJ,'/yoda/UVES/MNLupus/ready/red_l/RXJ_ctc.text.list','/yoda/UVES/MNLupus/ready/red_l/all_emission_lines_to_calc_equiwidth_l.dat','/yoda/UVES/MNLupus/ready/red_l/hjds_l.text'

end
