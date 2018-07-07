;**********************************************************************************
; This is the program for comparing the photometry data of the lineart spectra
; for each component with the synthetic spectra.
;***********************************************************************************
;***********************************************************************************
; Rading the synthetic spectra for the component A i.e of temp="2900-5.5.0.0"
;***********************************************************************************
final_flux_synth_A = dblarr(308197)     ; arrays
final_flux_synth_B = dblarr(308197)
final_flux_synth_C = dblarr(308197)
sum_flux1_a_b_c = dblarr(308197)
sum_flux_a_b_c = dblarr(308197)
;***********************************************************************************
; Rading the synthetic spectra for the component A i.e of temp="2900-5.5.0.0"
;***********************************************************************************
synthspectra_file_A='/disk2/Mdwarf/BT-settel-M-0.0/29-5.5-0.0.txt'
openr,3,synthspectra_file_A
rows_synthspectra_A = file_lines(synthspectra_file_A); no. of rows in the
                                                     ; data

synth_spec_A = fltarr(15,rows_synthspectra_A)   ; array for the data

readf,3,synth_spec_A                            ; reading the data
wavelength_synth_A1 = reform(synth_spec_A[0,*]) ; reforming the 1st
                                                ;column as wavelength
flux_synth_A1 = reform(synth_spec_A[1,*])       ; reforming the 1st
                                                ;column as flux
sortindex_A = sort(synth_spec_A[0,*])           ; sorting the data along the
                                                ;1st column
temp_wavelength_AA = wavelength_synth_A1(sortindex_A) ;storing the sorted
                             ;data of the wavelength into temperorry file
temp_wavelength_A=temp_wavelength_AA(where(temp_wavelength_AA ge 3000 and $
                  temp_wavelength_AA lt 90000))
temp_flux_AA = flux_synth_A1(sortindex_A)    ;storing the sorted
                                             ;data of the flux along the
                                             ;wavelength into temperorry file
temp_flux_A=temp_flux_AA(where(temp_wavelength_AA ge 3000 and $
            temp_wavelength_AA lt 90000))
final_wavelength_synth_A = temp_wavelength_A  ;final wavelength for the
                                              ;component A
temp_flux_synth_A = temp_flux_A               ;final flux for the
                                              ;component A
close,3
free_lun,3
;*****************************************************************************************
;          This below procedure is the crrection to get the absolute flux value
;          by the lineart
;          Here the c = speed of light = 29979245800 ; cm/sec
;          distance to the source = 7.72*3.08568025e16 ; cm
;          radius of source(as a function of solar radii) = 0.132
;*****************************************************************************************
final_flux_synth_A=2*(alog10((0.132*6.955e8)/(7.72*3.08568025e16))) $
    +(temp_flux_synth_A-8)
final_flux_synth_A1=10^(final_flux_synth_A)
;print,final_flux_synth_A1[0:10]
;stop
;PS_Start, Filename='/home/arvind/Desktop/component_B_C.ps'
lines = 4
items='Synth-A'
cgWindow,'Plot',final_wavelength_synth_A,final_flux_synth_A,background=cgColor('white'), $
color=cgColor('red'),Charsize=cgDefCharsize(),linestyle=lines,al_legend
stop
;****************************************************************************************
;                For the component B i.e temp 25-5.5-0.0
;***********************************************************************************
synthspectra_file_B='/disk2/Mdwarf/BT-settel-M-0.0/25-5.5-0.0.txt'
openr,3,synthspectra_file_B
rows_synthspectra_B = file_lines(synthspectra_file_B); no. of rows in the
                                                     ; data
synth_spec_B = fltarr(15,rows_synthspectra_B)        ; array for the data
readf,3,synth_spec_B                                 ; reading the data
;**********************************************************************************
wavelength_synth_B1 = reform(synth_spec_B[0,*]) ; reforming the 1st
                                                ;column as wavelength
flux_synth_B1 = reform(synth_spec_B[1,*])       ; reforming the 1st
                                                ;column as flux
sortindex_B = sort(synth_spec_B[0,*])           ; sorting the data along the
                                                ;1st column
temp_wavelength_BB = wavelength_synth_B1(sortindex_B) ;storing the sorted
                              ;data of the wavelength into temperorry file
temp_wavelength_B = temp_wavelength_BB(where(temp_wavelength_BB ge 3000 and $
                    temp_wavelength_BB lt 90000))
temp_flux_BB = flux_synth_A1(sortindex_B) ;storing the sorted
             ;data of the flux along the wavelength into temperorry file
temp_flux_B = temp_flux_BB(where(temp_wavelength_BB ge 3000 and $
              temp_wavelength_BB lt 90000))
;*********************************************************************************
final_wavelength_synth_B = temp_wavelength_B  ;final wavelength for the
                                              ;component B
temp_flux_synth_B = temp_flux_B               ;final flux for the
                                              ;component B
;*****************************************************************************************
final_flux_synth_B=2*(alog10((0.102*6.955e8)/(7.72*3.08568025e16))) $
    +(temp_flux_synth_B-8)
final_flux_synth_B1=10^(final_flux_synth_B)
;*****************************************************************************************
;          This above procedure is the crrection to get the absolute flux value
;          by the lineart
;          Here the c = speed of light = 29979245800 ; cm/sec
;          distance to the source = 7.72*3.08568025e16 ; cm
;          radius of source(function of solar radii) = 0.132
;***************************************************************************************
;cgplot ,final_wavelength_synth_B,final_flux_synth_B,background='white', color='red', $
;xtit='Wavelength', ytit='Flux', title='Component B
;print,final_wavelength_synth_B[0:300]
close,3
free_lun,3
;****************************************************************************************
;                For the component C
;****************************************************************************************
synthspectra_file_C='/disk2/Mdwarf/BT-settel-M-0.0/24-5.5-0.0.txt'
openr,3,synthspectra_file_C
rows_synthspectra_C = file_lines(synthspectra_file_C); no. of rows in the
                                                     ; data
synth_spec_C = fltarr(15,rows_synthspectra_C)        ; array for the data
readf,3,synth_spec_C                                 ; reading the data
wavelength_synth_C1 = reform(synth_spec_C[0,*]) ; reforming the 1st
                                                ; column as wavelength
flux_synth_C1 = reform(synth_spec_C[1,*])       ; reforming the 1st
                                                ;column as flux
sortindex_C = sort(synth_spec_C[0,*])           ; sorting the data along the
                                                ;1st column
temp_wavelength_CC = wavelength_synth_C1(sortindex_C) ;storing the sortted
                               ;data of the wavelength into temperorry file
temp_wavelength_C = temp_wavelength_CC(where(temp_wavelength_CC ge 3000 and $
                    temp_wavelength_CC lt 90000))
temp_flux_CC = flux_synth_C1(sortindex_C)    ;storing the sorted
       ;data of the flux along the wavelength into temperorry file
temp_flux_C=temp_flux_CC(where(temp_wavelength_CC ge 3000 and $
            temp_wavelength_CC lt 90000))
final_wavelength_synth_C = temp_wavelength_C     ;final wavelength for the
                                                 ;component C
temp_flux_synth_C = temp_flux_C  ;final flux for the component C
;*****************************************************************************************
final_flux_synth_C=2*(alog10((0.098*6.955e8)/(7.72*3.08568025e16))) $
    +(temp_flux_synth_C-8)  ;correction by the lineart
final_flux_synth_C1=10^(final_flux_synth_C)
;*****************************************************************************************
;          This above procedure is the crrection to get the absolute flux value
;          by the lineart
;          Here the c = speed of light = 29979245800 ; cm/sec
;          distance to the source = 7.72*3.08568025e16 ; cm
;          radius of source(function of solar radii) = 0.132
;***************************************************************************************
;cgplot , final_wavelength_synth_C,final_flux_synth_C,background='white', color='red', $
;xtit='Wavelength', ytit='Flux', title='Component C
close,3
free_lun,3
;*****************************************************************************************
; Adding the flux of all the component Fa+Fb+Fc and then taking the mean
;*****************************************************************************************
for l = 0L, 308196 do begin
   sum_flux_a_b_c(l) =(final_flux_synth_C1(l) + final_flux_synth_B1(l))
     endfor
sum_flux_a1_b1_c1=alog10(sum_flux_a_b_c)
;print,sum_flux_a_b_c[0:10]
;stop
cgplot, final_wavelength_synth_C,sum_flux_a1_b1_c1,background='white', color='red', $
xtit='Wavelength (A)', ytit='Flux', title='Component B+C'
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                                  Photometry
;*******************************************************************************************
; This is the program for the photometry of 15-Aug-05 and 12-April-05 of the
; leinart data.
; This program will do the comparision of the photometric data with the model
; spectra in order to have well calibration of flux.
;******************************************************************************************
;                               Step - I
;  Reading the photometric data of 15-Aug-05
;*******************************************************************************************
readcol, '/disk2/allard/Observation/other_ir_photometry_for_fit_15aug05.txt', $
a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,f='f,f,f,f,f,f,f,f,f,f,f'
clight = 29979245800 ;cm/sec
distance = 7.72*3.08568025e16
wavelength_obs1=a1  ; wavelength
flux_obs1_A=b1      ; A component
flux_obs1_B=d1      ; B component
flux_obs1_C=f1      ; C component
flux_obs1_BC=h1     ; AB component
flux_obs1_ABC=j1    ; ABC component
;******************************************************************************************
;                    this calculation is for 15th August photometry
;==========================================================================================
;                   for component A
;==========================================================================================
flux_obs_A = (1e-26*flux_obs1_A*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_A3 = alog10(1e-26*flux_obs1_A*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
; flux_obs_A3 is the logarithimic scale
flux_obs_A_error1=alog10(1e-26*(flux_obs1_A-c1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_A_error2=alog10(1e-26*(flux_obs1_A+c1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
;==========================================================================================
;                   for component B
;==========================================================================================
flux_obs_B = (1e-26*flux_obs1_B*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_B3 = alog10(1e-26*flux_obs1_B*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_B_error1=alog10(1e-26*(flux_obs1_B-e1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_B_error2=alog10(1e-26*(flux_obs1_B+e1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
;print, flux_obs_B
;=========================================================================================
;                   for component C
;==========================================================================================
flux_obs_C = (1e-26*flux_obs1_C*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_C3 = alog10(1e-26*flux_obs1_C*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_C_error1=alog10(1e-26*(flux_obs1_C-g1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_C_error2=alog10(1e-26*(flux_obs1_C+g1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
;print, flux_obs_C
;******************************************************************************************
;                               for component A+B
;******************************************************************************************
flux_obs_BC = (1e-26*flux_obs1_BC*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_BC3 = alog10(1e-26*flux_obs1_BC*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_BC_error1=alog10(1e-26*(flux_obs1_BC-i1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_BC_error2=alog10(1e-26*(flux_obs1_BC+i1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
;******************************************************************************************
;                               for component A+B+C
;******************************************************************************************
flux_obs_ABC = (1e-26*flux_obs1_ABC*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_ABC3 = alog10(1e-26*flux_obs1_ABC*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_ABC_error1=alog10(1e-26*(flux_obs1_ABC-k1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
flux_obs_ABC_error2=alog10(1e-26*(flux_obs1_ABC+k1)*clight/wavelength_obs1/wavelength_obs1/10000/1e-4)
;==========================================================================================
photomtetryABC = alog10(flux_obs_B+ flux_obs_C+flux_obs_A)
photomtetryBC = alog10(flux_obs_B+ flux_obs_C)
;print,'photomtetryBC',photomtetryBC,'flux_obs_BC3',flux_obs_BC3
;stop
;cgplot, wavelength_obs1*1e4,flux_obs_A,psym=7,color='red',SYMSIZE=3,/overplot
;cgplot, wavelength_obs1*1e4,flux_obs_B,psym=2,color='green',SYMSIZE=2,/overplot
;cgplot, wavelength_obs1*1e4,flux_obs_C,psym=5,color='green',SYMSIZE=2,/overplot
cgplot, wavelength_obs1*1e4,flux_obs_BC3, PSYM=6, color='black',SYMSIZE=2,/overplot
;cgplot, wavelength_obs1*1e4,flux_obs_ABC3,psym=2,color='green',SYMSIZE=2 ,/overplot
;cgplot, wavelength_obs1*1e4,photomtetryABC,psym=2,color='black',SYMSIZE=2,/overplot
cgplot, wavelength_obs1*1e4,photomtetryBC,psym=2,color='green',SYMSIZE=2,/overplot
;errplot,wavelength_obs1*1e4,flux_obs_A_error1,flux_obs_A_error2
;errplot,wavelength_obs1*1e4,flux_obs_B_error1,flux_obs_B_error2
;errplot,wavelength_obs1*1e4,flux_obs_C_error1,flux_obs_C_error2
;errplot,wavelength_obs1*1e4,flux_obs_BC_error1,flux_obs_BC_error2
;errplot,wavelength_obs1*1e4,flux_obs_ABC_error1,flux_obs_ABC_error2
;stop
;*********************************************************************************************
;                    writing the output for the 15 August photometry
;***********************************************************************************************
;file_out ='/home/arvind/Desktop/'+'15_Aug.txt'
;  openw,10,file_out
;for k=0L,7 do begin
;  printf,10,format='(f15.6,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4)', $
;  (1e4)*wavelength_obs1(k),flux_obs_A3(k),flux_obs_B3(k),flux_obs_C3(k),flux_obs_ABC3(k), $
;  photomtetryABC(k),flux_obs_BC3(k),photomtetryBC(k)
;endfor
;close,10
;free_lun,10
;stop
;******************************************************************************************
;                      this calculation is for 12th April photometry
;==========================================================================================
;***********************************************************************************************
readcol, '/disk2/allard/Observation/hst_ir_short_phot_for_fit_12apr05.csv', $
a2,b2,c2,d2,e2,f2,g2,h2,i2,j2,k2,f='f,f,f,f,f,f,f,f,f,f,f'
wavelength_obs2=a2  ; wavelength
flux_obs1_A1=b2     ; A component
flux_obs1_B1=d2     ; B component
flux_obs1_C1=f2     ; C component
flux_obs1_BC1=h2     ; AB component
flux_obs1_ABC1=j2    ; ABC component
;*************************************************************************************************
;                               component A
;*************************************************************************************************
flux_obs1_A11 = (1e-26*flux_obs1_A1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_A1 = alog10(1e-26*flux_obs1_A1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_A1_error1=alog10(1e-26*(flux_obs1_A1-c2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_A1_error2=alog10(1e-26*(flux_obs1_A1+c2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
;print,'flux_obs1_A1',flux_obs1_A1
;stop
;*************************************************************************************************
;                               component B
;*************************************************************************************************
flux_obs1_B11 = (1e-26*flux_obs1_B1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_B1 = alog10(1e-26*flux_obs1_B1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_B1_error1=alog10(1e-26*(flux_obs1_B1-e2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_B1_error2=alog10(1e-26*(flux_obs1_B1+e2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
;print,flux_obs1_B1
;stop
;*************************************************************************************************
;                               component C
;*************************************************************************************************
flux_obs1_C11 = (1e-26*flux_obs1_C1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_C1 = alog10(1e-26*flux_obs1_C1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_C1_error1=alog10(1e-26*(flux_obs1_C1-g2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_C1_error2=alog10(1e-26*(flux_obs1_C1+g2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
;print, flux_obs1_C1
;stop
;*************************************************************************************************
;                               component A+B
;*************************************************************************************************
flux_obs1_BC11 = (1e-26*flux_obs1_BC1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_BC1 = alog10(1e-26*flux_obs1_BC1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_BC1_error1=alog10(1e-26*(flux_obs1_BC1-i2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_BC1_error2=alog10(1e-26*(flux_obs1_BC1+i2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
;print, flux_obs1_BC1
;stop
;*************************************************************************************************
;                               component A+B+C
;*************************************************************************************************
flux_obs1_ABC11 = (1e-26*flux_obs1_ABC1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_ABC1 = alog10(1e-26*flux_obs1_ABC1*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_ABC1_error1=alog10(1e-26*(flux_obs1_ABC1-k2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
flux_obs1_ABC1_error2=alog10(1e-26*(flux_obs1_ABC1+k2)*clight/wavelength_obs2/wavelength_obs2/10000/1e-4)
;*************************************************************************************************
photomtetryABC1 = alog10(flux_obs1_B11+ flux_obs1_C11+flux_obs1_A11)
photomtetryBC1 = alog10(flux_obs1_B11+ flux_obs1_C11)
;print, photomtetryBC1[0:5],flux_obs1_BC1[0:5]
;cgplot, wavelength_obs2*1e4,flux_obs1_A1,psym=1,color='red',symsize=3,/overplot
;cgplot, wavelength_obs2*1e4,flux_obs1_B1,psym=2,color='green',SYMSIZE=2,/overplot
;cgplot, wavelength_obs2*1e4,flux_obs1_C1,psym=2,color='green',SYMSIZE=2,/overplot
cgplot, wavelength_obs2*1e4,flux_obs1_BC1,psym=7,color='yellow',SYMSIZE=2,/overplot
;cgplot, wavelength_obs2*1e4,flux_obs1_ABC1,psym=2,color='yellow',SYMSIZE=2,/overplot
;cgplot, wavelength_obs2*1e4,photomtetryABC1,psym=2,color='brown',SYMSIZE=2,/overplot
cgplot, wavelength_obs2*1e4,photomtetryBC1,psym=2,color='brown',SYMSIZE=2,/overplot
;***********************************************************************************************
; writing the output for the 12april photometry
;***********************************************************************************************
;file_out ='/home/arvind/Desktop/'+'12_April.txt'
; print,'output file - ',file_out
; openw,10,file_out
;for k=0L,30 do begin
;  printf,10,format='(f15.6,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4,1x,e13.4)', $
;  (1e4)*wavelength_obs2(k),flux_obs1_A1(k),flux_obs1_B1(k),flux_obs1_C1(k),flux_obs1_ABC1(k), $
;  photomtetryABC1(k),flux_obs1_BC1(k),photomtetryBC1(k)
;endfor
;close,10
;free_lun,10
PS_End
;=====================================================================================
print,'end of program'
end
