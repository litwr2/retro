;for vasm assembler, oldstyle syntax

HILEV2 = 1

    ldy #<s10
    sty $e6
    ldy #>s10
    sty $e7
    jsr put_t2
l0
    lda #>(l0-1)
    pha
    lda #<(l0-1)
    pha
    jsr waitkey
    lda #$80
    and kmatrix+1
    bne *+5
    jmp fastm

    lda #1
    and kmatrix+5   ;curd
    bne *+5
    jmp down_t2

    lda #8
    and kmatrix+5  ;curu
    bne *+5
    jmp up_t2

    lda #1
    and kmatrix+6  ;curl
    bne *+5
    jmp left_t2

    lda #8
    and kmatrix+6  ;curr
    bne *+5
    jmp right_t2

    lda #1
    and kmatrix+7   ;1
    bne l5

scoff2 = * + 1
    lda #0
    bmi .l1

    cmp #3
    beq .l0
.l1
    inc scoff2
    lda $d4
    bne *-2
    lda #-2
    sta $d4
    jmp down_t2
.l0 lda #6
    sta $d4
    lda #0
    sta scoff2
    inc irq276.me+1
    jsr remove_t2
    jsr sscroll_up4
    ldy #s2ypos_off
    lda ($e6),y
    sec
    sbc #3
    sta ($e6),y
    jsr put_t2
    inc irqX.me+1
    rts
l5  lda #8
    and kmatrix+7  ;2
    bne l6

    lda scoff2
    bpl .l1

    cmp #-3
    beq .l0
.l1
    dec scoff2
    lda $d4
    bne *-2
    lda #2
    sta $d4
    jmp up_t2
.l0 lda #-6
    sta $d4
    lda #0
    sta scoff2
    inc irq276.me+1
    jsr remove_t2
    jsr sscroll_down4
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    inc irqX.me+1
    rts

l6  lda #2
    and kmatrix+2   ;R
    bne l7

    jsr remove_t2
l8  jsr waitkey
    lda #2
    and kmatrix+5  ;P
    bne l8
    jmp put_t2

l7  lda #16
    and kmatrix+2  ;C
    beq *+5
    jmp l0

    jsr remove_t2
    ldy #s2xpos_off
    lda #HSIZE/4
    sta ($e6),y
    iny
    lda #VSIZE/4
    sta ($e6),y
    jmp put_t2

fastm
    lda #1
    and kmatrix+5   ;curd
    bne *+5
    jmp down2_t2

    lda #8
    and kmatrix+5  ;curu
    bne *+5
    jmp up2_t2

    lda #1
    and kmatrix+6  ;curl
    bne *+5
    jmp left2_t2

    lda #8
    and kmatrix+6  ;curr
    bne *+5

    jmp right2_t2
    jmp l0
  if 0
l0 lda #200
l1 pha
    ;jsr getkey
   ;lda #5
   ;jsr delay
    ldy #<s1
    sty $e6
    ldy #>s1
    sty $e7
   jsr left
   ;jsr down
       ldy #<s3
    sty $e6
    ldy #>s3
    sty $e7
   jsr left
   ;jsr up
   pla
   clc
   adc #-1
   bne l1

   lda #200
l2 pha
    ldy #<s1
    sty $e6
    ldy #>s1
    sty $e7
   jsr left
   ;jsr up
       ldy #<s3
    sty $e6
    ldy #>s3
    sty $e7
   jsr right
   ;jsr down
   pla
   clc
   adc #-1
   bne l2
   jmp l0
  endif

   org $a000
   include "common.s"
   include "aux.s"
   ;include "sprite-lib1.s"
   include "sprite-lib2.s"
   include "sscroll.s"
   include "sprlib/s10_t2.s"

