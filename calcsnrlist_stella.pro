;###########################
function countlines,s
;###########################

c=0UL
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=ulong(result(0))
end
return,c
end

;############################
pro calcsnrlist_stella
;############################
;
; NAME:                  calcsnrlist_stella
; PURPOSE:               starts CALCSNRLIST for every file given in
;                        'calcsnrlist_stella.list' with the area list 'calcsnrlist_stella.ranges'
;                        
; CATEGORY:              data reduction
; CALLING SEQUENCE:      calcsnrlist_stella
; INPUTS:                input file: 'calcsnrlist_stella.list':
;                         /media/sda2/UVES/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                         /media/sda2/UVES/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                         /media/sda2/UVES/HD175640_b_2001-06-14T09-15-03.193_437_500s_botzxsf_ecds.text
;                                            .
;                                            .
;                                            .
;                        imput file: 'calcsnrlist_stella.ranges':
;                         3906.545 3907.264
;                         4005.609 4010.746
;                         4184.529 4186.176
;                                 .
;                                 .
;                                 .
; OUTPUTS:               
;
; COPYRIGHT:             Andreas Ritter
; CONTACT:               aritter@aip.de
;
; LAST EDITED:           02.10.2005
;

; --- start calcsnrlist

  calcsnrlist,'calcsnrlist_stella.list','calcsnrlist_stella.ranges'

end
