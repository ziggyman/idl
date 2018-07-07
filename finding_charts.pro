;############################
pro finding_charts,list,texfile,path,runid
;############################
;this program makes finding-charts out of a given list of HD-gifs
;needs the LIST containing the HDs and a TEXFILE in the PATH and a RUNID
;rename_skyview runs only under IDL-Versions below 5.4!!!
;############################

if n_elements(runid) eq 0 then begin
  print,'finding_charts: Not enough parameters given, return 0.'
  print,'USAGE: finding_charts,starlist,texfile,path_where_the_images_can_be_found,runid'
endif else begin

  gifinvert,list,path
  skyview,list,texfile,path,runid
  rename_skyview,list,path,runid

endelse
end
