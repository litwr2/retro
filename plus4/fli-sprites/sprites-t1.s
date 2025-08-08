;for vasm assembler, oldstyle syntax

   ;jsr waitkey
   ;jmp *-3
    ldy #<s7
    sty $e6
    ldy #>s7
    sty $e7

   jsr put_t1
l0
    lda #2
    jsr delay
    lda #>(l0-1)
    pha
    lda #<(l0-1)
    pha
    ;jsr getkey
    ;cmp #$50  ;curd
    jsr waitkey
    lda #$80
    and kmatrix+1
    bne *+5
    jmp fastm

    lda #1
    and kmatrix+5   ;curd
    bne *+5
    jmp down_t1

    lda #8
    and kmatrix+5  ;curu
    bne *+5
    jmp up_t1

    lda #1
    and kmatrix+6  ;curl
    bne *+5
    jmp left_t1

    lda #8
    and kmatrix+6  ;curr
    bne *+5
    jmp right_t1

    lda #1
    and kmatrix+7   ;1
    bne l5

    lda #2
    sta $d4
    jmp up_t1
l5
    lda #8
    and kmatrix+7  ;2
    bne l6

    lda #-2
    sta $d4
    jmp down_t1
l6
    lda #2
    and kmatrix+2   ;R
    bne l7

    jsr remove_t1
l8  jsr waitkey
    lda #2
    and kmatrix+5  ;P
    bne l8
    jmp put00_t1

l7  lda #16
    and kmatrix+2  ;C
    bne l0

    jsr remove_t1
    ldy #sxpos_off
    lda #HSIZE/2
    sta ($e6),y
    iny
    lda #VSIZE/2
    sta ($e6),y
    jmp put_t1

fastm
    lda #1
    and kmatrix+5   ;curd
    bne *+5
    jmp down2_t1

    lda #8
    and kmatrix+5  ;curu
    bne *+5
    jmp up2_t1

    lda #1
    and kmatrix+6  ;curl
    bne *+5
    jmp left2_t1

    lda #8
    and kmatrix+6  ;curr
    bne *+5
    jmp right2_t1
   ;jsr remove_t1
   ;jsr right
   ;ldy #sxpos_off
   ;lda ($e6),y
   ;clc
   ;adc #$fe
   ;sta ($e6),y
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
   include "aux.s"
   include "sprite-lib1.s"
   ;include "lib/s1.s"
   ;include "lib/s2.s"
   ;include "lib/s3.s"
   ;include "lib/s4.s"
   ;include "lib/s5.s"
   ;include "lib/s6.s"
   include "lib/s7.s"


