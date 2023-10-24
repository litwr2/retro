;for macro-11 assembler
;picture viewer, v1, (c) 2023 litwr
;it can now show 3 bpp, 6 bpp, and 12 bpp pictures
;horizontal sizes must be 1024, 512, and 256, respectively.

;the PPI-extension may be skipped when a filename is entered

;it uses the PPI format (Pro PIctures)
;offset  value
;0       format ID (must be 3 now)
;2       horizontal size (plane 1, Red)
;4       vertical size (plane 1)
;6       bits per pixel on a plane (plane 1)
;8       x offset (plane 1)
;10      y offset (plane 1)
;12-21   reserved
;22      horizontal size (plane 2, Green)
;24      vertical size (plane 2)
;26      bits per pixel on a plane (plane 2)
;28      x offset (plane 2)
;30      y offset (plane 2)
;32-41   reserved
;42      horizontal size (plane 3, Blue)
;44      vertical size (plane 3)
;46      bits per pixel on a plane (plane 3)
;48      x offset (plane 3)
;50      y offset (plane 3)
;52-61   reserved
;62-511   reserved
;512     plane 1 (red) data, must be multiple of 512
;        plane 2 (green) data, must be multiple of 512
;        plane 3 (blue) data, must be multiple of 512
;data consists of packed words, for instance a word must contain 4 pixels if bpp=4

    .radix 10

      .MCall .exit, .trpset, .print, .ttyout, .ttyin, .settop, .csigen, .readw
      TTSPC$ =: ^O10000
      $JSW =: ^O44

START:   bis #TTSPC$,@#$JSW
         .settop #-2
         mov #63488,R1    ;$f800
         mov #7,R3
2$:      .trpset #area,#3$
         mov (r1),r2
         cmpb #2,r2   ;ID for the Pro 325/350
         beq vidok

         cmpb #40,r2  ;$28 (IDR for the Pro 380)
         beq vidok

         cmpb #16,r2  ;$10 (IDR for the Pro 380+EBO, at $fb00)
         beq vidok

         cmp -(SP),-(SP)
3$:      cmp (SP)+,(SP)+
         add #128,R1    ;$80, upto $fb00
         sob R3,2$

         .print #emsg
         .exit
vidok:   .trpset #area,#0
         bit #^B0010000000000000,4(r1)  ;EBO present
         beq 1$

         .print #e2msg
         .exit
1$:      mov r1,@#vbase
         mov sp,r5
         .csigen #dspace,#defext
         mov r5,sp
         mov r0,@#buff
         clr @#blk
         .readw #area,#3
         bcc 3$

4$:      .print #e4msg
         .exit

3$:      mov @#buff,r4
         cmp (r4)+,#3
         beq 5$

         .print #e5msg
         .exit

5$:      mov (r4)+,r1
         mov r1,@#hs
         mov (r4)+,r2
         mov r2,@#vs
         mov (r4)+,r3
         mov r3,@#bpp
         mul r3,r1
         ash #-4,r1
         mul r1,r2
         mov r3,@#wpp

         call sreg
         mov @#vbase,r5
         mov @#wpp,@#cwpp
         clr @#yc
         mov @#bpp,r0
         asr r0
         mov r0,r1
         ash #3,r0
         bis #^B0000000000000000,r0
         mov r0,6(r5) ;plane 1 (blue), the NOP-op
         mov r1,r0
         swab r0
         bis r1,r0
         ash #3,r0
         bis #^B0000001000000000,r0
         mov r0,8(r5) ;plane 2 (green) & 3 (red), the NOP/MOV-op
         call drawb

         mov @#wpp,@#cwpp
         clr @#yc
         mov @#bpp,r0
         asr r0
         mov r0,r1
         swab r0
         bis r1,r0
         ash #3,r0
         bis #^B0000000000000010,r0
         mov r0,8(r5) ;plane 2 & 3, the MOV/NOP-op
         call drawb

         mov @#wpp,@#cwpp
         clr @#yc
         mov @#bpp,r0
         asr r0
         mov r0,r1
         ash #3,r0
         bis #^B0000000000000010,r0
         mov r0,6(r5) ;plane 1, the MOV-op
         mov r1,r0
         swab r0
         bis r1,r0
         ash #3,r0
         bis #^B0000000000000000,r0
         mov r0,8(r5) ;plane 2 & 3, the NOP/NOP-op
         call drawb

         .ttyin
         call @#rreg
         .exit

drawb:    inc @#blk
          .readw #area,#3
          bcc 3$

         .print #e4msg
         .exit

3$:       mov @#buff,r0
          mov #4,r2
2$:       mov #64,r1
          mov @#yc,16(r5)
          mov #0,14(r5)
1$:       mov (r0)+,20(r5)
          mov #16,18(r5)
          tst 4(r5)   ;transfer done?
          bpl .-4

          add #16,14(r5)
          sob r1,1$

          inc @#yc
          sob r2,2$

          sub #256,@#cwpp
          bhi drawb
          return

rreg:  mov @#vbase,r1
       mov #save4,r2
       mov (r2)+,4(r1)
       mov (r2)+,6(r1)
       mov (r2)+,8(r1)
       mov (r2)+,14(r1)
       mov (r2),16(r1)
       return

sreg:  mov @#vbase,r1
       mov #save4,r2
       mov 4(r1),(r2)+
       mov 6(r1),(r2)+
       mov 8(r1),(r2)+
       mov 14(r1),(r2)+
       mov 16(r1),(r2)
       clr r2
       cmp #256,@#vs
       adc r2
       asl r2
       asl r2
       bis #^B0000000000000001,r2  ;256/512 lines
       mov r2,4(r1)
       return

bin2hex:  mov r0,-(sp)   ;prints r1
          mov r1,r0
          swab r0   ;mov dl,ah
          clc
          rorb r0
          asrb r0
          asrb r0
          asrb r0    ;shr dl,4
          add #'0,r0 ;add dl,'0'
          cmpb r0,#'9+1 ;cmp dl,'9'+1
          bcs 1$

          add #7,r0  ;add dl,7
1$:       .ttyout

          mov r1,r0
          swab r0   ;mov dl,ah
          bicb #240,r0 ;and dl,0fh
          add #'0,r0   ;add dl,'0'
          cmpb r0,#'9+1 ;cmp dl,'9'+1
          bcs 2$

          add #7,r0    ;add dl,7
2$:       .ttyout

          mov r1,r0   ;mov dl,al
          clc
          rorb r0
          asrb r0
          asrb r0
          asrb r0    ;shr dl,4
          add #'0,r0 ;add dl,'0'
          cmpb r0,#'9+1 ;cmp dl,'9'+1
          bcs 3$

          add #7,r0  ;add dl,7
3$:       .ttyout

          mov r1,r0   ;mov dl,al
          bicb #240,r0 ;and dl,0fh
          add #'0,r0   ;add dl,'0'
          cmpb r0,#'9+1 ;cmp dl,'9'+1
          bcs 4$

          add #7,r0  ;add dl,7
4$:       .ttyout
          mov (sp)+,r0
          return

vbase:   .word 0
hs:      .word 0
vs:      .word 0
yc:      .word 0
bpp:     .word 0
wpp:     .word 0
cwpp:    .word 0
save4:   .blkw 5
defext:  .rad50 "PPI"
         .word 0,0,0
area:    .word 0
blk:     .word 0
buff:    .word 0
         .word 256,0
emsg:    .asciz "cannot find the graphic system"
e2msg:    .asciz "cannot find the EBO"
e4msg:    .asciz "read error"
e5msg:    .asciz "wrong format"
dspace:
.End	START
