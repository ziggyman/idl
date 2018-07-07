pro remove_subarr_from_array,arr_array,arr_subarray
  for isub=0ul, n_elements(arr_subarray)-1 do begin
    remove_element_from_array,arr_array,arr_subarray(isub)
  endfor
end
