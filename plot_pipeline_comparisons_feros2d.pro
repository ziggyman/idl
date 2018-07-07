;############################
pro plot_pipeline_comparisons_feros2d
;############################
; --- everything
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',3500.,9300.,-10000.,225000.,3800.,212000.,'ratio','print'
; --- 3933.6641 Ca-K
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',3933.,3937.2,2000.,27000.,3934.65,25000.,'ratio','print'
; --- 4077 SrII
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',4075.8,4079.5,8000.,32000.,4077.,30500.,'ratio','print'
; --- CaI 4226.727
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',4224.,4230.5,5000.,45000.,4225.6,42500.,'ratio','print'
; --- CaI 4454.781
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',4453.,4457.6,15500.,55000.,4454.9,53000.,'ratio','print'
; --- 5250 FeI
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',5249.95,5253.25,61000.,107000.,5251.6,82000.,'ratio','print'
; --- 6173 FeI
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',6172.9,6175.1,86000.,118000.,6173.45,115500.,'ratio','print'
; --- 6430 FeI,6432 FeII
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',6430.,6434.9,81000.,113000.,6432.5,100000.,'ratio','print'
; --- 6708 LiI
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',6705.6,6709.6,65000.,114000.,6706.,85000.,'ratio','print'
; --- 6717.685 CaI
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',6715.,6719.6,75000.,107000.,6715.3,90000.,'ratio','print'
; --- TiI 8468
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',8465.,8470.9,85000.,131000.,8465.2,105000.,'ratio','print'
; --- CaII 8498.018
plot_pipeline_comparisons,'/home/azuri/spectra/feros/to_compare_fit2d.list','/home/azuri/spectra/feros/legend_names.list',' ','Flux [ADUs]',8496.,8499.2,91500.,135000.,8497.2,132500.,'ratio','print'
end
