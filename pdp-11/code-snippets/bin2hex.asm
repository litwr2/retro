;for macro-11 assembler, RT11
;bin to hex

BYTE = 0  ;0 means print a word

.macro out1
       .ttyout
       ;movb r0,(r5)+
       .endm out1

bin2hex:  mov r0,-(sp)   ;prints r1
.if eq BYTE
          mov r1,r0
          swab r0   ;sets C=0
          rorb r0
          asrb r0
          asrb r0
          asrb r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 1$

          add #7,r0
1$:       out1

          mov r1,r0
          swab r0
          bicb #240.,r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 2$

          add #7,r0
2$:       out1
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
3$:       out1

          mov r1,r0
          bicb #240.,r0
          add #'0,r0
          cmpb r0,#'9+1
          bcs 4$

          add #7,r0
4$:       out1
          mov (sp)+,r0
          return

