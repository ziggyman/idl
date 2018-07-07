pro rave_print_colour_id,B_POP_ID      = b_pop_id,$
                         INT_M         = int_m,$;          --- add 1 to avoid m=0
                         DBLARR_XRANGE = dblarr_xrange,$
                         DBLARR_YRANGE = dblarr_yrange,$
                         DBL_N_TYPES   = dbl_n_types
        if keyword_set(B_POP_ID) then begin
          str_type_name = strtrim(string((int_m-1)),2)
          xyouts,dblarr_xrange(1)+((dblarr_xrange(1)-dblarr_xrange(0))/10.),$
                 dblarr_yrange(0)+((dblarr_yrange(1)-dblarr_yrange(0))*(int_m-1)/dbl_n_types)+9.*((dblarr_yrange(1)-dblarr_yrange(0))/(2. * dbl_n_types + 1.))/10.,$
                 str_type_name,$
                 alignment=0.5,$
                 charsize=1.,$
                 color=0
        end else begin
          if (int_m-1) eq 0 then begin
            str_type_name = 'SuperGs'
          end else if (int_m-1) eq 1 then begin
            str_type_name = 'BGs'
          end else if (int_m-1) eq 2 then begin
            str_type_name = 'Giants'
          end else if (int_m-1) eq 3 then begin
            str_type_name = 'SubGs'
          end else if (int_m-1) eq 4 then begin
            str_type_name = 'MS'
          end else if (int_m-1) eq 5 then begin
            str_type_name = 'WDs'
          end else if (int_m-1) eq 6 then begin
            str_type_name = 'TTs'
          end
          xyouts,dblarr_xrange(1)+((dblarr_xrange(1)-dblarr_xrange(0))/10.),$
                 dblarr_yrange(0)+((dblarr_yrange(1)-dblarr_yrange(0))*(int_m-1)/dbl_n_types)+((dblarr_yrange(1)-dblarr_yrange(0))/15.),$
                 str_type_name,$
                 alignment=0.5,$
                 orientation=90,$
                 charsize=1.,$
                 color=0
        end

end
