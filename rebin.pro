function calcintens,x1,x2,xn,y1,y2
intensn = 0.
if n_params() ne 5 then begin
  print,'COUNTLINES: Not enough parameters specified, return 0.'
end else begin
  intensn = y1
  intensn = intensn + ((y2 - y1) * (xn - x1)/(x2 - x1));
end
return,intensn
end

function rebinspectra,inwave,outwave,inintens,outintens,lambdastart,lambdaend,dlambda;InArrLength)
if n_elements(dlambda) eq 0 then begin
    print,'rebinspectra: Not enougth parameters specified, return 0.'
    print,'rebinspectra: Usage: rebinspectra,<dblarr inwave: in>,<dblarr outwave: out>,<dblarr inintens: in>,<dblarr outintens: out>,<double lambdastart>,<double lambdaend>,<double dlambda>'
endif else begin
  i = 0UL;
  j = 0UL;
  print,'rebinspectra: started rebinspectra,',inwave,',',outwave,',',inintens,',',outintens,',',lambdastart,',',lambdaend,',',dlambda
  InArrLength = (size(inwave))(1)
  print,'rebinspectra: InArrLength set to ',InArrLength
  if (size(inintens))(1) ne InArrLength then begin
    print,'rebinspectra: ERROR: (size(inintens))(1)[=',(size(inintens))(1),'] ne InArrLength(=',InArrLength
    stop
  endif
  if inwave(0) lt inwave(2) then begin
    if inwave(0) lt lambdastart then begin
      print,'rebinspectra: inwave[0](=',inwave(0),') > lambdastart(=',lambdastart,') => returning 0'
      stop
    endif
    while inwave(i) lt lambdastart do begin
      i = i+1
    end
    i = i+1
  end else begin; Lambda falling
    if inwave(InArrLength - 1) gt lambdastart then begin
      print,'rebinspectra: inwave(InArrLength-1=',InArrLength-1,')(=',inwave(InArrLength-1),') > lambdaend(=',lambdaend,') => returning 0'
      stop
    end
    while inwave(InArrLength - i - 1) lt lambdastart do begin
      i = i+1
    end
    i = i+1
  end
;   printf("RebinTextFiles.Rebin: lambdastart = %.7f\n", lambdastart);
;   printf("RebinTextFiles.Rebin: lambdaend = %.7f\n", lambdaend);
; //  printf("RebinTextFiles.Rebin: LambdaBegin = %.7f\n", LambdaBegin);
;   printf("RebinTextFiles.Rebin: dlambda = %.7f\n", dlambda);
;   outwave[j] = lambdastart;

   if inwave(0) lt inwave(1) then begin
;    printf("RebinTextFiles.Rebin: i = %d, j = %d\n", i, j);
;     printf("RebinTextFiles.Rebin: inwave[%d] = %.7f\n", i-1, inwave[i-1]);
;     printf("RebinTextFiles.Rebin: inwave[%d]=%.7f\n", i, inwave[i]);
;     printf("RebinTextFiles.Rebin: outwave[%d]=%.7f\n", j, outwave[j]);
;     printf("RebinTextFiles.Rebin: inintens[%d]=%.7f\n", i-1, inintens[i-1]);
;     printf("RebinTextFiles.Rebin: inintens[%d]=%.7f\n", i, inintens[i]);
    outintens(j) = calcintens(inwave(i-1), inwave(i), outwave(j), inintens(i-1), inintens(i))
  end else begin
;     printf("RebinTextFiles.Rebin: i = %d, j = %d\n", i, j);
;     printf("RebinTextFiles.Rebin: inwave[%d] = %.7f\n", InArrLength - i, inwave[InArrLength - i]);
;     printf("RebinTextFiles.Rebin: inwave[%d]=%.7f\n", InArrLength - i - 1, inwave[InArrLength - i - 1]);
;     printf("RebinTextFiles.Rebin: outwave[%d]=%.7f\n", j, outwave[j]);
;     printf("RebinTextFiles.Rebin: inintens[%d]=%.7f\n", InArrLength - i, inintens[InArrLength - (i-1)]);
;     printf("RebinTextFiles.Rebin: inintens[%d]=%.7f\n", InArrLength - 1 - i, inintens[InArrLength - 1 - i]);
    outintens(j) = calcintens(inwave(InArrLength - i), inwave(InArrLength-1-i), outwave(j), inintens(InArrLength-i), inintens(InArrLength-1-i))
  end
;  printf("RebinTextFiles.Rebin: outwave[%d] = %.7f, outintens[%d] = %.7f\n", j, outwave[j], j, outintens[j]);
  while outwave(j) + dlambda le lambdaend do begin
    j = j+1
    outwave(j) = outwave(j-1) + dlambda
    if inwave(0) lt inwave(1) then begin
      while inwave(i) lt lambdaend and inwave(i) lt outwave(j) do begin
        i = i+1
      end
      outintens(j) = calcintens(inwave(i-1), inwave(i), outwave(j), inintens(i-1), inintens(i))
    end else begin
      while inwave(InArrLength-1-i) lt lambdaend and inwave(InArrLength-1-i) lt outwave(j) do begin
        i = i+1
      end
      outintens(j) = calcintens(inwave(InArrLength-i), inwave(InArrLength-1-i), outwave(j), inintens(InArrLength-i), inintens(InArrLength-1-i))
    end
  end
;  printf("RebinTextFiles.Rebin: outwave[%d] = %.7f\n", j, outwave[j]);
  return,1
end
end
