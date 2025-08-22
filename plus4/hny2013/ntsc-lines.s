line2o .macro   ;open, needs 7 cycs
       sty $FF19
       #wait24
       #wait24
       #wait24
       #wait4
       sta $ff1e
       #wait24
       #wait12
       #wait4
       #wait4
       #wait4
       #wait4
       stx $FF19
       jmp start
       .endm

line2  .macro
       #cyc 10
       sta $ff1e
       #cyc 5
       #wait4
       #wait4
       #wait3
       #wait4
       #wait4
       .endm

line2cb  .macro  ;base for the codes
       #wait24
       #wait24
       #wait24
       #wait8
       sta $ff1e
       #wait24
       #wait24
       #wait3
       #wait8
       .endm

line2cb1  .macro
       stx $d2
       ldx #0
       stx $fd30
       sta $ff08
       ldx $ff08
       cpx #$ff
       BEQ l1

       ldx $d0
       ldy $d1
       stx $d1
       sty $d0
       jmp l2

l1
       ldx $d2
       #wait4
       pha
       pla
l2
       #wait24
       #wait8
       #wait12
       sta $ff1e
       #wait24
       #wait24
       #wait3
       #wait8
       .endm

line2cb2  .macro
       inc $d4
       lda #delay1
       cmp $d4
       bne l4

       lda #0
       sta $d4
       lda #51
       cmp $d3
       beq l2

       sta $d3
       jmp l1
l4
       #wait12
       #wait2
       jmp l1
l2
       lda #49
       sta $d3
l1
       LDA #(255-cval)
       #wait24
       #wait24
       sta $ff1e
       #wait24
       #wait24
       #wait3
       #wait8
       .endm

line2cb3  .macro
       lda #delay2
       cmp $d4
       bne l4

       lda #50
       cmp $d3
       bne l2

       dec $d3
       jmp l1
l4
       #wait4
       #wait3
l2
       #wait4
       #wait3
l1
       LDA #(255-cval)
       #wait24
       #wait24
       #wait8
       sta $ff1e
       #wait24
       #wait24
       #wait3
       #wait8
       .endm

line2b  .macro  ;blank grey line
       #hcycb 10*2
       sta $ff1e
       #hcycb 5*2
       #wait4
       #wait4
       #wait3
       #wait8
       .endm

line2x .macro
       #cycx 10
       sta $ff1e
       #cycx 5
       #wait8
       #wait4
       #wait3
       #wait4
       .endm

line3  .macro  ;not fixed!!!
       ldy #15
pcl   .var <*
      .if pcl/$fd
v1    .var 1
       cmp $1500
      .endif
c1     dey
       bne c1
      .ifndef v1
       cmp $1500
      .endif
       sta $ff1e
       ldy #10
pcl   .var <*
      .if pcl/$fd
v2     .var 1
       cmp $1500
      .endif
c2     dey
       bne c2
      .ifndef v2
       cmp $1500
      .endif
      .endm

line3sx .macro
       #wait24
       #wait24
       #wait24
       #wait8
       sta $ff1e
       lda $ff1d
       sec
       sbc $d3
       sta $ff1d
       LDA #(255-cval).3
       #wait24
       #wait12
       #wait4
       #wait4
       .endm

line2_2 .macro
       #line2
       #line2
       .endm

line2_4 .macro
       #line2_2
       #line2_2
       .endm

line2_8 .macro
       #line2_4
       #line2_4
       .endm

line2_16 .macro
       #line2_8
       #line2_8
       .endm

line2_32 .macro
       #line2_16
       #line2_16
       .endm

line2_64 .macro
       #line2_32
       #line2_32
       .endm

line2_128 .macro
       #line2_64
       #line2_64
       .endm

line2_2x .macro
       #line2x
       #line2x
       .endm

line2_4x .macro
       #line2_2x
       #line2_2x
       .endm

line2_8x .macro
       #line2_4x
       #line2_4x
       .endm

line2_16x .macro
       #line2_8x
       #line2_8x
       .endm

line2_32x .macro
       #line2_16x
       #line2_16x
       .endm

line2_64x .macro
       #line2_32x
       #line2_32x
       .endm

line2_128x .macro
       #line2_64x
       #line2_64x
       .endm

line2b_2 .macro
       #line2b
       #line2b
       .endm

line2b_4 .macro
       #line2b_2
       #line2b_2
       .endm

line2b_8 .macro
       #line2b_4
       #line2b_4
       .endm

line2b_16 .macro
       #line2b_8
       #line2b_8
       .endm

line2b_32 .macro
       #line2b_16
       #line2b_16
       .endm

line2b_64 .macro
       #line2b_32
       #line2b_32
       .endm

