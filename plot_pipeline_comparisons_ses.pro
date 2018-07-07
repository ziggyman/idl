;############################
pro plot_pipeline_comparisons_ses
;############################
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4000.,10900.,0.,900000.,6500.,75000.,'ratio','print'
; SII(3933.264) and CaII(3933.668)
;plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',3932.5,3933.599,0.,80000.,3932.55,110000.,'ratio','print'
; CrII(4077.511) and SrII(4077.709)
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4075.9,4078.45,0.,500000.,4076.94,160000.,'ratio','print'
; --- CaI(4226.727), and TiII(7227.334), blended with FeI(4227.427) 
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4225.,4228.9,0.,500000.,4225.2,23500.,'ratio','print'
; FeI(4271.76), TiII(4271.937), MnII(4272.996), FeII(4273.326)
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4270.05,4274.15,0.,550000.,4271.6,223000.,'ratio','print'
; MnII(4272.996), FeII(4273.326)
;plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4272.35,4274.05,0.,60000.,4272.4,227000.,'ratio','print'
; TiII(4277.537), MnII(4278.614)
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4275.86,4279.32,0.,700000.,4277.05,200000.,'ratio','print'
; --- TiII (4450.482), Blend of FeII (4451.551) and MNI (4451.586)
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4448.6,4452.4,0.,800000.,4450.13,190000.,'ratio','print'
; --- FeII 4491.405 and MnI 4491.648
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4489.7,4492.4,0.,600000.,4491.05,240000.,'ratio','print'
; --- CrII 4558.65 
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4556.4,4558.49,5000.,750000.,4557.47,200000.,'ratio','print'
; --- SII 4656.757, FeII 4656.981, TiII 4657.206
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4655.,4658.35,5000.,800000.,4656.05,223000.,'ratio','print'
; --- SII 4716.271, MnII 4717.264
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4714.5,4718.,0.,600000.,4715.6,203500.,'ratio','print'
; --- MnII 4811.623, MnII 4812.033, CrII 4812.337
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4809.9,4812.99,5000.,600000.,4811.22,162000.,'ratio','print'
; --- YII 4823.304, MnI 4823.524 (CrII 4824.127 blended with 16.01 and 26.01)
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4821.65,4824.72,0.,500000.,4823.03,130000.,'ratio','print'
; --- TiII 4874.014
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',4872.25,4874.84,5000.,500000.,4873.55,132000.,'ratio','print'
; --- 5250 FeI
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',5248.95,5254.25,0.,350000.,5251.6,82000.,'ratio','print'
; --- HeI(5876), Na-D
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',5868.95,5900.25,2000.,350000.,5871.6,82000.,'ratio','print'
; --- 6173 FeI
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6173.,6175.6,2000.,300000.,6173.45,115500.,'ratio','print'
; --- 6430 FeI,6432 FeII
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6429.,6435.9,3000.,300000.,6432.5,100000.,'ratio','print'
; --- 6546.24 FeI, 6563 H_alpha
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6535.,6580.5,0.,400000.,6542.5,100000.,'ratio','print'
; --- 6708 LiI
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6704.6,6710.6,3000.,300000.,6706.,91000.,'ratio','print'
; --- 6708 LiI, 6717.685 CaI
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6703.,6721.6,3000.,300000.,6705.3,90000.,'ratio','print'
; --- 6717.685 CaI
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',6714.,6720.6,100000.,300000.,6715.3,90000.,'ratio','print'
; --- TiI 8468
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',8464.,8471.9,50000.,200000.,8465.2,105000.,'ratio','print'
; --- CaII 8498.018
plot_pipeline_comparisons,'/home/azuri/spectra/ses/to_compare_SES_0208.list','/home/azuri/spectra/ses/to_compare_SES_legend.list',' ','Flux [ADUs]',8495.,8500.2,80000.,150000.,8497.2,132500.,'ratio','print'
end
