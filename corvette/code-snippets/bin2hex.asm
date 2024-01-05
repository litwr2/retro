;for the pasmo assembler
bin2hex   proc   ;prints A
          local l1,l2
          push bc
          ld b,a
          and $f0
          rrca
          rrca
          rrca
          rrca
          add a,'0'
          cp '9'+1
          jp c,l1 

          add a,7
l1        ld c,a
          call printc

          ld a,b
          and 0fh
          add a,'0'
          cp '9'+1
          jp c,l2

          add a,7
l2        ld c,a
          call printc
          pop bc
          ret
          endp
