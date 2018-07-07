;###########################
function countlines,s
;###########################

c=0L
if n_params() ne 1 then print,'COUNTLINES: No file specified, return 0.' $
else begin
  result=strarr(1)
  lines=0
  spawn,'wc -l '+s,result
  c=long(result(0))
end
return,c
end

;############################
pro beispiel,filelist
;############################

common maxfiles

if n_elements(filelist) eq 0 then print,'Beispiel: No file specified, return 0.' $
else begin   

  maxfiles = countlines(filelist)
  print,maxfiles,' FILES'  

  files = strarr(maxfiles)
  nbias = 0
  nflat = 0

  close,1
  openr,1,fname  
  for i=0,maxn-1 do begin  
    readf,1,fileq  
    files(i)=fileq
    if strmid(fileq,0,1) eq 'b' then nbias += 1
    if strmid(fileq,0,1) eq 'f' then nflat += 1
  end  
  close,1  

  biases = strarr(nbias)
  flats  = strarr(nflat)

  ibias=0
  iflat=0

  for i=0,maxfiles-1 do begin
    if strmid(files(i),0,1) eq b then begin
      bias(ibias)=files(i)
      ibias += 1
    endif
    else begin
      if strmid(files(i),0,1) eq f then begin
        flat(iflat)=files(i)
        iflat += 1
      endif
    endelse
  end

  ;---combine biases
  combinedbias=readfits(bias(0), h)
  for i=1,nbias-1 do combinedbias+=readfits(bias(i), h)
  combinedbias=combinedbias/nbias
  ccd_tv_win1,combinedbias,xmax=1012
  biaswert = mean(combinedbias)

  ;---combine flats
  combinedflat=readfits(flat(0), h)
  for i=1,nflat-1 do combinedflat+=readfits(flat(i), h)
  combinedflat = combinedflat/nflat
  combinedflat = combinedflat/max(flat))
  ccd_tv_win1,combinedflat,xmax=1012

  .
  .
  .

endelse
end