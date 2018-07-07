pro do_something

  fieldsfile = '/home/azuri/daten/rave/rave_data/release3/fields.dat'


  ; --- plot [M/H] over vrad
  besancon_rave_plot_two_cols,SUBPATH='MH_vrad',$
                              FIELDSFILE=fieldsfile,$
                              XCOLRAVE=5,$
                              XCOLBESANCON=15,$
                              XTITLE='v_rad [km/s]',$
                              XMIN=-300.,$
                              XMAX=300.,$
                              YCOLRAVE=19,$
                              YCOLBESANCON=19,$
                              YTITLE='[M/H] [dex]',$
                              YMIN=-3.,$
                              YMAX=1.,$
                              IMIN=0,$
                              IMAX=0,$
                              ICOL=12,$
                              FORCEXRANGE=1,$
                              FORCEYRANGE=0,$
                              REJECTVALUEX=0,$
                              REJECTVALUEY=99.90

;  ; --- plot Teff over I
;  besancon_rave_plot_two_cols,SUBPATH='I_Teff',$
;                              FIELDSFILE=fieldsfile,$
;                              XCOLRAVE=12,$
;                              XCOLBESANCON=12,$
;                              XTITLE='I [mag]',$
;                              XMIN=9.,$
;                              XMAX=12.,$
;                              YLOGBES = 1,$
;                              YCOLRAVE=17,$
;                              YCOLBESANCON=4,$
;                              YTITLE='T_eff [K]',$
;                              YMIN=-0.0001,$
;                              YMAX=12000.,$
;                              IMIN=0,$
;                              IMAX=0,$
;                              ICOL=12,$
;                              FORCEYRANGE=0,$
;                              REJECTVALUEX=0,$
;                              REJECTVALUEY=0.0000001

end
