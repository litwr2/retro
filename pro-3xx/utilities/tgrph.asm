;for macro-11 assembler, RT11
;this program must fill your screen with color boxes, 4096 colors must be shown on the Pro with the EBO
;240x175

      .radix 10

       .MCall .exit, .rsum, .scca, .trpset, .print, .ttyout, .ttyin
      $JSW =: ^O44
      TTSPC$ =: ^O10000

VA = 0  ;may be 0 or 16 that corresponds video amplifiers off or on

START:   bis #TTSPC$,@#$JSW
         ;.rsum
         ;.scca #area,#addr
         mov #64256,R1    ;$fb00
         mov #7,R3
vidsk:   .trpset #area,#trprou
         mov (r1),r2
         cmpb #2,r2  ;2 (IDR for the Pro 325/350)
         beq vidok

         cmpb #40,r2  ;$28 (IDR for the Pro 380)
         beq vidok

         cmpb #16,r2  ;$10 (IDR for the Pro 380+EBO, at $fb00)
         beq vidok

         cmp -(SP),-(SP)
trprou:  cmp (SP)+,(SP)+
         sub #128,R1    ;$80, downto $f800
         sob R3,vidsk

         .print #msg1
         .exit
vidok:   bit #^B0010000000000000,4(r1)  ;EBO present?
         beq 1$

         .print #msg2
         .exit
    
1$:      mov r1,@#vidbs
         .print #term1
         .trpset #area,#0      ;restore vector
         mov 4(r1),@#save4     ;save video system registers
         mov 6(r1),@#save6
         mov 8(r1),@#save8
         mov 14(r1),@#save14
         mov 16(r1),@#save16
         mov #^B0000000000000000!VA,4(r1)   ;Control Status - CSR, 256 lines do not work in xhomer

         call pal12
         ;.scca #area,#0
         .ttyin
         mov @#vidbs,r1
         mov @#save4,4(r1)
         mov @#save6,6(r1)
         mov @#save8,8(r1)
         mov @#save14,14(r1)
         mov @#save16,16(r1)
         .print #term2
         bic #TTSPC$,@#$JSW
         .exit

pal12:  ;draw boxes
    mov #35,-(sp)
    clr r3
    clr r2
    mov #2,r5
    mov #5,r4
2$: clr r1
    mov #120,r0
1$: call pb4096
    inc r3
    add r5,r1
    sob r0,1$

    add r4,r2
    dec (sp)
    bne 2$
    tst (sp)+
    return

pb4096: ;R1-X,R2-Y,R3-color,R4-length Y,R5-length X; draw a box
    mov r0,-(sp)
    mov r2,-(sp)
    mov r4,-(sp)
2$: mov r5,r0
    mov r1,-(sp)
    asl r1
    asl r1
1$: mov r3,-(sp)
    call pp4096
    mov (sp)+,r3
    add #4,r1
    sob r0,1$
    mov (sp)+,r1
    inc r2
    sob r4,2$
    mov (sp)+,r4
    mov (sp)+,r2
    mov (sp)+,r0
    return

pb64: ;R1-X,R2-Y,R3-color,R4-length X,R5-length Y; draw a box
    mov r0,-(sp)
    mov r2,-(sp)
    mov r4,-(sp)
2$: mov r5,r0
    mov r1,-(sp)
    asl r1
1$: mov r3,-(sp)
    call pp64
    mov (sp)+,r3
    add #2,r1
    sob r0,1$
    mov (sp)+,r1
    inc r2
    sob r4,2$
    mov (sp)+,r4
    mov (sp)+,r2
    mov (sp)+,r0
    return

pb8: ;R1-X,R2-Y,R3-color,R4-length X,R5-length Y; draw a box
    mov r0,-(sp)
    mov r2,-(sp)
    mov r4,-(sp)
2$: mov r5,r0
    mov r1,-(sp)
1$: mov r3,-(sp)
    call pp8
    mov (sp)+,r3
    inc r1
    sob r0,1$
    mov (sp)+,r1
    inc r2
    sob r4,2$
    mov (sp)+,r4
    mov (sp)+,r2
    mov (sp)+,r0
    return

pp8: ;1024 pixels ;R1-X,R2-Y,R3-color (1 bit per plane), R3 is changed
    mov r0,-(sp)
    mov @#vidbs,r0
    mov #^B0000000000000010,6(r0) ;plane 1, the MOV-op
    mov #^B0000000000000000,8(r0) ;plane 2 & 3, the NOP-op
    mov R1,14(r0)  ;X
    mov R2,16(r0)  ;Y
    mov R3,20(r0)  ;pattern
    mov #1,18(r0)  ;counter
    asr r3
    tst 4(r0)   ;transfer done?
    bpl .-4
    mov #^B0000000000000000,6(r0) ;plane 1, the NOP-op
    mov #^B0000000000000010,8(r0) ;plane 2 & 3, the MOV/NOP-op
    mov R3,20(r0)  ;pattern
    mov #1,18(r0)  ;counter
    asr r3
    tst 4(r0)   ;transfer done?    
    bpl .-4
    ;mov #^B0000000000000000,6(r0) ;plane 1, the NOP-op
    mov #^B0000001000000000,8(r0) ;plane 2 & 3, the NOP/MOV-op
    mov R3,20(r0)  ;pattern
    mov #1,18(r0)  ;counter
    mov (sp)+,r0
    return

pp64: ;512 pixels; R1-X,R2-Y,R3-color (6 bits, 2 bits per plane), R3 is changed
    mov r0,-(sp)
    mov @#vidbs,r0
    mov #^B0000000000001010,6(r0) ;plane 1, the MOV-op
    mov #^B0000100000001000,8(r0) ;plane 2 & 3, the NOP-op
    mov R1,14(r0)  ;X
    mov R2,16(r0)  ;Y
    mov R3,20(r0)  ;pattern
    mov #2,18(r0)  ;counter
    asr r3
    asr r3
    tst 4(r0)   ;transfer done?
    bpl .-4
    mov #^B0000000000001000,6(r0) ;plane 1, the NOP-op
    mov #^B0000100000001010,8(r0) ;plane 2 & 3, the MOV/NOP-op
    mov R3,20(r0)  ;pattern
    mov #2,18(r0)  ;counter
    asr r3
    asr r3
    tst 4(r0)   ;transfer done?    
    bpl .-4
    ;mov #^B0000000000001000,6(r0) ;plane 1, the NOP-op
    mov #^B0000101000001000,8(r0) ;plane 2 & 3, the NOP/MOV-op
    mov R3,20(r0)  ;pattern
    mov #2,18(r0)  ;counter
    mov (sp)+,r0
    return

pp4096: ;256 pixels; R1-X,R2-Y,R3-color (12 bits, 4 bits per plane), R3 is changed
    mov r0,-(sp)
    mov @#vidbs,r0
    mov #^B0000000000010010,6(r0) ;plane 1, the MOV-op
    mov #^B0001000000010000,8(r0) ;plane 2 & 3, the NOP-op
    mov R1,14(r0)  ;X
    mov R2,16(r0)  ;Y
    mov R3,20(r0)  ;pattern
    mov #4,18(r0)  ;counter
    asr r3
    asr r3
    asr r3
    asr r3
    tst 4(r0)   ;transfer done?
    bpl .-4
    mov #^B0000000000010000,6(r0) ;plane 1, the NOP-op
    mov #^B0001000000010010,8(r0) ;plane 2 & 3, the MOV/NOP-op
    mov R3,20(r0)  ;pattern
    mov #4,18(r0)  ;counter
    asr r3
    asr r3
    asr r3
    asr r3
    tst 4(r0)   ;transfer done?    
    bpl .-4
    ;mov #^B0000000000010000,6(r0) ;plane 1, the NOP-op
    mov #^B0001001000010000,8(r0) ;plane 2 & 3, the NOP/MOV-op
    mov R3,20(r0)  ;pattern
    mov #4,18(r0)  ;counter
    mov (sp)+,r0
    return

P00000:
        mov #10000,r3
	CALL @#PRZ
        mov #1000,r3
	CALL @#PRZ
        mov #100,r3
	CALL @#PRZ
        mov #10,r3
	CALL @#PRZ
	mov r2,r0
PR:	add #48,r0
   	.ttyout
        return

PRZ:	mov #65535,r0
4$:	inc r0
	cmp r2,r3
	bcs PR

	sub r3,r2
	br 4$

DPR2: ;print R2
      mov r0,-(sp)
      call P00000
      .print #eol
      mov (sp)+,r0
      return

area:    .word 0,0
addr:    .word 0
vidbs:   .word 0
save4:   .word 0
save6:   .word 0
save8:   .word 0
save14:  .word 0
save16:  .word 0
msg1:    .asciz "cannot find the video card"
msg2:    .asciz "cannot find the EBO"
term1:   .ascii <27> "[?25l" <128>
term2:   .ascii <27> "[?25h" <27> "[H" <128>
eol:     .byte 0
.End	START

