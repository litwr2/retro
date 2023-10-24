;for macro-11 assembler, RT11
;bin to hex

BYTE = 0  ;1 means print a word

bin2hex:  mov r0,-(sp)   ;prints r1
.if eq BYTE
          mov r1,r0
          swab r0   ;mov dl,ah
          clc
          rorb r0
          asrb r0
          asrb r0
          asrb r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 1$

          add #7,r0
1$:       .ttyout
          
          mov r1,r0
          swab r0
          bicb #240.,r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 2$

          add #7,r0
2$:       .ttyout
.endc
          mov r1,r0
          clc
          rorb r0
          asrb r0
          asrb r0
          asrb r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 3$

          add #7,r0
3$:       .ttyout
          
          mov r1,r0   ;mov dl,al
          bicb #240.,r0 ;and dl,0fh
          add #'0,r0   ;add dl,'0'
          cmpb r0,#'9+1 ;cmp dl,'9'+1
          bcs 4$

          add #7,r0  ;add dl,7
4$:       .ttyout
          mov (sp)+,r0
          return

