pro remove_ith_element_from_array,arr_array,int_element
  if (int_element lt 0) or (int_element ge n_elements(arr_array)) then begin
    ;print,'remove_ith_element_from_array: (int_element=',int_element,' lt 0) or (int_element ge n_elements(arr_array)=',n_elements(arr_array),') => returning'
    return
  endif
  if (n_elements(arr_array) eq 1) and (int_element eq 0) then begin
    ;print,'remove_ith_element_from_array: (int_element=',int_element,' == 0) and (n_elements(arr_array)=',n_elements(arr_array),') == 1 => setting arr_array to [-1]'
    arr_array = [-1]
  end else begin
    ;print,'remove_ith_element_from_array: (int_element=',int_element,' != 0) or (n_elements(arr_array)=',n_elements(arr_array),') != 1'
    if int_element eq 0 then begin
      ;print,'remove_ith_element_from_array: int_element=',int_element,' == 0 => setting arr_array to arr_array(1:n_elements(arr_array-1)=',n_elements(arr_array-1),')'
      arr_array = arr_array(1:n_elements(arr_array)-1)
    end else if int_element eq n_elements(arr_array)-1 then begin
      ;print,'remove_ith_element_from_array: int_element=',int_element,' == n_elements(arr_array) -1 => setting arr_array to arr_array(0:n_elements(arr_array-2)=',n_elements(arr_array-2),')'
      arr_array = arr_array(0:n_elements(arr_array)-2)
    end else begin
      ;print,'remove_ith_element_from_array: (int_element=',int_element,' != 0) and (n_elements(arr_array)=',n_elements(arr_array),') != 1'
      arr_array = [arr_array(0:int_element-1),arr_array(int_element+1:n_elements(arr_array)-1)]
    end
  end
end
