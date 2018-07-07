pro rave_stream_plot_spectra_and_templates

  openw,lun,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/index.html',/GET_LUN
  printf,lun,'<html><body><center>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.017.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.017.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.017',STR_TITLE='0821m22.rvsun.017'
  printf,lun,'<a href="0821m22.rvsun.017.gif"><img src="0821m22.rvsun.017.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/spectra/20080209/20080209_0821m22_017.renormobs_gk.txt','/home/azuri/daten/rave/stream/spectra/20080209/20080209_0821m22_017.synth_gk.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.renormobs_gk.017',STR_TITLE='0821m22_017_renorm'
  printf,lun,'<a href="0821m22_017_renorm.gif"><img src="0821m22_017_renorm.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.111.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.111.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.111',STR_TITLE='0821m22.rvsun.111'
  printf,lun,'<a href="0821m22.rvsun.111.gif"><img src="0821m22.rvsun.111.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/spectra/0821m22.rvsun.111.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.111.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.111',STR_TITLE='0821m22.rvsun.111'
  printf,lun,'<a href="0821m22.rvsun.111.gif"><img src="0821m22.rvsun.111.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.127.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.127.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.127',STR_TITLE='0821m22.rvsun.127'
  printf,lun,'<a href="0821m22.rvsun.127.gif"><img src="0821m22.rvsun.127.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.135.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.135.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.135',STR_TITLE='0821m22.rvsun.135'
  printf,lun,'<a href="0821m22.rvsun.135.gif"><img src="0821m22.rvsun.135.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.035.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.035.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.035',STR_TITLE='0833m26.rvsun.035'
  printf,lun,'<a href="0833m26.rvsun.035.gif"><img src="0833m26.rvsun.035.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.038.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.038.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.038',STR_TITLE='0833m26.rvsun.038'
  printf,lun,'<a href="0833m26.rvsun.038.gif"><img src="0833m26.rvsun.038.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.041.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.041.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.041',STR_TITLE='0833m26.rvsun.041'
  printf,lun,'<a href="0833m26.rvsun.041.gif"><img src="0833m26.rvsun.041.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.053.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.053.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.053',STR_TITLE='0833m26.rvsun.053'
  printf,lun,'<a href="0833m26.rvsun.053.gif"><img src="0833m26.rvsun.053.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.062.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.062.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.062',STR_TITLE='0833m26.rvsun.062'
  printf,lun,'<a href="0833m26.rvsun.062.gif"><img src="0833m26.rvsun.062.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.107.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.107.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0833m26.rvsun.107',STR_TITLE='0833m26.rvsun.107'
  printf,lun,'<a href="0833m26.rvsun.107.gif"><img src="0833m26.rvsun.107.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0847m22.rvsun.026.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0847m22.rvsun.026.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0847m22.rvsun.026',STR_TITLE='0847m22.rvsun.026'
  printf,lun,'<a href="0847m22.rvsun.026.gif"><img src="0847m22.rvsun.026.gif"></a><br>'

  rave_plot_spectrum_and_template,'/home/azuri/daten/rave/stream/red\ overdensity/spectra/0901m26.rvsun.076.cont.vrcor.txt','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0901m26.rvsun.076.cont.vrcor.txt.temp','/home/azuri/daten/rave/stream/red\ overdensity/spectra/0901m26.rvsun.076',STR_TITLE='0901m26.rvsun.076'
  printf,lun,'<a href="0901m26.rvsun.076.gif"><img src="0901m26.rvsun.076.gif"></a><br>'

  spawn,'ps2gif /home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.017.ps /home/azuri/daten/rave/stream/red\ overdensity/spectra/0821m22.rvsun.017.gif'
  printf,lun,'</center></body></html>'
  free_lun,lun
end
