pro remove_element_from_array,arr_array,element
  ;print,'arr_array = ',arr_array
  ;print,'element = ',element
  indarr_good = where(arr_array ne element)
  ;print,'remove_element_from_array: indarr_remove = ',indarr_remove
  if indarr_good(0) lt 0 then begin
    arr_array = [-1]
  end else begin
    arr_array = arr_array(indarr_good)
  endelse
;  while indarr_remove(0) ge 0 do begin
;    if (n_elements(arr_new) eq 1) and (indarr_remove(0) eq 0) then begin
;      arr_new = [-1]
;    end else begin
;      if indarr_remove(0) eq 0 then begin
;        arr_new = arr_new(1:n_elements(arr_new)-1)
;      end else if indarr_remove(0) eq n_elements(arr_new)-1 then begin
;        arr_new = arr_new(0:indarr_remove(0)-1)
;      end else begin
;        arr_new = [arr_new(0:indarr_remove(0)-1),arr_new(indarr_remove(0)+1:n_elements(arr_new)-1)]
;      endelse
;    end
;    if n_elements(indarr_remove) eq 1 then begin
;      indarr_remove(0) = -1
;    end else begin
;      indarr_remove = indarr_remove(1:n_elements(indarr_remove)-1) - 1
;    endelse
;    ;print,'remove_element_from_array: indarr_remove = ',indarr_remove
;    ;print,'remove_element_from_array: arr_new = ',arr_new
;  end
;  arr_array = arr_new
;  arr_new = 0
end
