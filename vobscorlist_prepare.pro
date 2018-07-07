pro vobscorlist_prepare
; --- red
    add_1col_lists,'/yoda/UVES/MNLupus/ready/utcs_red.dat','/yoda/UVES/MNLupus/ready/exptimes_red.dat','/yoda/UVES/MNLupus/ready/utc_middle_red.dat'
    conv_time_to_hms,'/yoda/UVES/MNLupus/ready/utc_middle_red.dat','/yoda/UVES/MNLupus/ready/utc_middle_hms_red.dat'

; --- blue
    add_1col_lists,'/yoda/UVES/MNLupus/ready/utcs_blue.dat','/yoda/UVES/MNLupus/ready/exptimes_blue.dat','/yoda/UVES/MNLupus/ready/utc_middle_blue.dat'
    conv_time_to_hms,'/yoda/UVES/MNLupus/ready/utc_middle_blue.dat','/yoda/UVES/MNLupus/ready/utc_middle_hms_blue.dat'

end
