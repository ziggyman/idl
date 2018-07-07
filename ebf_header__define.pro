PRO ebf_header__define
sruct = { ebf_header, $      
          name: bytarr(32),    $   
          datatype:0L,  datasize:0L, $
          version:0L, extra1:0L, extra2:0L, rank:0L, $
          dim:lonarr(32), $
          spattern:lonarr(12), $
	  magic2:0L, magic4:0.0,magic3:0LL, magic5:0.0d0 $
        }
END

;PRO ebf_header__define
;sruct = { ebf_header     ,    $      
;          name: bytarr(16)  ,    $   
;          attribute: bytarr(16),    $
;          datatype:0l         ,    $
;          datasize:0l     ,    $
;          extra1:0L       ,    $
;          extra2:0L       ,    $
;          extra3:0L       ,    $
;          rank:0L       ,    $
;          dim:lonarr(50)   $
;        }
;
;END
