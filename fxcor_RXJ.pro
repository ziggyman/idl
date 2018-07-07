;############################
pro fxcor_RXJ
;############################
;
; NAME:                  fxcor_RXJ.pro
; PURPOSE:               calculates and plots the mean and rms for the radial
;                        velocities of RXJ1523 over hjd
; CATEGORY:              data reduction
; CALLING SEQUENCE:      fxcor_RXJ
; OUTPUTS:               inlist+'.eps',meanoutfile
; COPYRIGHT:             Andreas Ritter
; DATE:                  27.08.2004
;
;                        headline
;                        feetline (up to now not used) 
; --- trim fxcor outputs
fxcor_out_trim_list
; --- red channel
; --- left array
fxcor_minus_2ndlist_list,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt','/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission.list','/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission_minus_refHD209290'
fxcor_plot_mean_and_rms,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission_minus_refHD209290_vhelio.data','/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission_minus_refHD209290_vhelio_mean.data','print'
fxcor_minus_2ndlist_list,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission_minus_refHD209290_vhelio_mean.data','/yoda/UVES/MNLupus/ready/fxcor_dats_red_l_emission.list','/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_l'
fxcor_plot_mean_and_rms,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_l_vhelio.data','/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_l_vhelio_mean.data','print'
; --- right array
fxcor_minus_2ndlist_list,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt','/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission.list','/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission_minus_refHD209290'
fxcor_plot_mean_and_rms,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission_minus_refHD209290_vhelio.data','/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission_minus_refHD209290_vhelio_mean.data','print'
fxcor_minus_2ndlist_list,'/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission_minus_refHD209290_vhelio_mean.data','/yoda/UVES/MNLupus/ready/fxcor_dats_red_r_emission.list','/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_r'
fxcor_plot_mean_and_rms,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_r_vhelio.data','/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_r_vhelio_mean.data','print'

;fxcor_minus_2ndlist_list,'../../UVES/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt','../../UVES/ready/fxcor_dats_red.list','../../UVES/ready/fxcor_dats_red_minus_refHD209290'
;fxcor_plot_mean_and_rms,'../../UVES/ready/fxcor_dats_red_minus_refHD209290_vhelio.data','../../UVES/ready/fxcor_dats_red_minus_refHD209290_vhelio_mean.data','print'
;fxcor_minus_2ndlist_list,'../../UVES/ready/fxcor_dats_red_minus_refHD209290_vhelio_mean.data','../../UVES/ready/fxcor_dats_red.list','../../UVES/ready/fxcor_RXJ_final_red'
;fxcor_plot_mean_and_rms,'../../UVES/ready/fxcor_RXJ_final_red_vhelio.data','../../UVES/ready/fxcor_RXJ_final_red_vhelio_mean.data','print'

; -- blue channel
;fxcor_minus_2ndlist_list,'../../UVES/ready/fxcor_RXJ_red_r_-3.5_100_90_90_refHD209290_trimmed.txt','../../UVES/ready/fxcor_dats_blue.list','../../UVES/ready/fxcor_dats_blue_minus_refHD209290'
;fxcor_plot_mean_and_rms,'../../UVES/ready/fxcor_dats_blue_minus_refHD209290_vhelio.data','../../UVES/ready/fxcor_dats_blue_minus_refHD209290_vhelio_mean.data','print'
;fxcor_minus_2ndlist_list,'../../UVES/ready/fxcor_dats_blue_minus_refHD209290_vhelio_mean.data','../../UVES/ready/fxcor_dats_blue.list','../../UVES/ready/fxcor_RXJ_final_blue'
;fxcor_plot_mean_and_rms,'../../UVES/ready/fxcor_RXJ_final_blue_vhelio.data','../../UVES/ready/fxcor_RXJ_final_blue_vhelio_mean.data','print'

; --- all together
fxcor_RXJ_plot_mean_and_rms,'/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_l_vhelio.data','/yoda/UVES/MNLupus/ready/fxcor_RXJ_emission_final_red_r_vhelio.data','','print'

;fxcor_RXJ_plot_mean_and_rms,'../../UVES/ready/fxcor_RXJ_final_red_vhelio.data','../../UVES/ready/fxcor_RXJ_final_blue_vhelio.data','','print'
end
