;##################################################### 
pro do_htmldoc_sestest_problems
;#####################################################

  htmlfile = '/home/azuri/daten/html/stella-testresults/problems.html'

  openw,lun,htmlfile,/GET_LUN

  printf,lun,'<center>'
  printf,lun,'  <h1>SES test results</h1>'
  printf,lun,'  <h2>Problems</h2><hr><br>'
  printf,lun,'  <h3>We still have some problems to reduce the spectra taken with SES, but</h3><br>'
  printf,lun,'  <h2>All problems are going to be solved soon!</h2><br><hr><br>'
  printf,lun,'  <h3>Problem 1: Problems with the readout software:</h3>'
  printf,lun,'  <a href="images/badpix_SES_2148x2052.gif"><img src="images/badpix_SES_2148x2052.gif" width=70% alt="picture showing the CCD regions to take out"><br>This picture shows the bad CCD regions produced by the readout software which is currently being used.</a><br><br>'
  printf,lun,'  Unfortunately the readout software for SES, which was assumed to run without problems, produces a large amount of saturated lines on the CCD. To get rid of these bad regions every single exposure needs to be checked for these regions. All bad regions found in images taken during one observing block are put into the bad-pixel file used by the STELLA pipeline. The pipeline then takes the median of the surrounding pixels to replace the bad pixel values.<br><br>'
  printf,lun,'  A new interface to another readout software is in process. This should prevent the problem of producing bad rows during the readout process.<br><br><hr><br>'
  printf,lun,'  <h3>Problem 2: Missing orders in the Flats:</h3>'
  printf,lun,'  <a href="images/problem_flat_whole-width2.png"><img src="images/problem_flat_whole-width2.png" width=70% alt="picture showing a flatfield image"><br>This picture shows a flatfield image before taking out the bad readout regions. The fifth order from left (red side) is missing completely.</a><br><br>'
  printf,lun,'The flatfield intensity around the fifth order from the left (red side) goes down to zero. The reason for this is unknown, but in the future the wavelength region shown at the CCD will be shifted about 10 orders to the blue.<br><br><hr><br>'
  printf,lun,'</center>'
  free_lun,lun

end
