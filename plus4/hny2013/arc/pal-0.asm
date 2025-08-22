;for the TMPX assembler

cyc    .macro
       STY $FF19
       STX $FF19
       .endm

cyc2   .macro
       #cyc
       #cyc
       .endm

cyc4   .macro
       #cyc2
       #cyc2
       .endm

cyc8   .macro
       #cyc4
       #cyc4
       .endm

wait2  .macro
       nop
       .endm

wait3  .macro
       .byte 4, $d0
       .endm

wait4  .macro
       .byte $14, $d0
       .endm

wait8  .macro
       #wait4
       #wait4
       .endm

wait12 .macro
       #wait8
       #wait4
       .endm

line1  .macro
       #cyc8
       #cyc2
       #cyc
       #cyc
       #wait8
       #wait3
       #wait2
       .endm

line2  .macro
l1     #cyc8
       #cyc2
       #cyc
       sty $ff19
       #wait4
       #wait8
       #wait2
       jmp l1
       .endm

       * = $1001
       .BYTE $16,$10,0,0,$9E
       .byte <start/1000+48,<(start-((start/1000)*1000))/100+48
       .byte <(start-((start/100)*100))/10+48,<start-((start/10)*10)+48
       .NULL ":litwr-2012/25"
       .BYTE 0,0

start  LDA #$0B
       STA $FF06
       sei
l0     lda $ff1c
       lsr
       bcs l0
sync   lda $ff1c
       lsr
       bcc sync
       LDX #$EE
       LDY #$12
       LDA #$2F
wait   CPY $FF1D
       BNE wait
       ADC $FF1E
       LSR
       STA xpos+1
xpos   BPL xpos
       CMP #$C9
       CMP #$C9
       CMP #$C5
       NOP
       LDY #$11
delay  DEY
       BNE delay
       LDY #$E5
       #line2
;cnt    .var 288
;loop   .lbl
;       .if cnt
;       #line1
;cnt    .var cnt - 1
;       .goto loop
;       .endif
       jmp l0



