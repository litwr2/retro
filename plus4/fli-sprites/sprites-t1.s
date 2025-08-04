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
    ;jsr getkey
    ;cmp #$50  ;curd
    jsr waitkey
    lda #$80
    and kmatrix+1
    beq fastm

    lda #1
    and kmatrix+5   ;curd
    bne l1

    jsr down_t1
    jmp l0
l1  ;cmp #$53  ;curu
    lda #8
    and kmatrix+5  ;curu
    bne l2

    jsr up_t1
    jmp l0
l2  ;cmp #$60  ;curl
    lda #1
    and kmatrix+6  ;curl
    bne l3

    jsr left_t1
    jmp l0
l3  ;cmp #$63  ;curr
    lda #8
    and kmatrix+6  ;curr
    bne l4

    jsr right_t1
    jmp l0
l4  ;cmp #$70   ;1
    lda #1
    and kmatrix+7   ;1
    bne l5

    lda #2
    sta $d4
    jsr up_t1
    jmp l0
l5  ;cmp #$73   ;2
    lda #8
    and kmatrix+7  ;2
    bne l6

    lda #-2
    sta $d4
    jsr down_t1
    jmp l0
l6  ;cmp #$21   ;R
    lda #2
    and kmatrix+2   ;R
    bne l7

    jsr remove_t1
    jmp l0

l7  ;cmp #$51   ;P
    lda #2
    and kmatrix+5  ;P
    bne *-5

    jsr put00_t1
    jmp l0

fastm
    lda #1
    and kmatrix+5   ;curd
    bne l11

    jsr down2_t1
    jmp l0
l11  ;cmp #$53  ;curu
    lda #8
    and kmatrix+5  ;curu
    bne l21

    jsr up2_t1
    jmp l0
l21  ;cmp #$60  ;curl
    lda #1
    and kmatrix+6  ;curl
    bne l31

    jsr left2_t1
    jmp l0
l31  ;cmp #$63  ;curr
    lda #8
    and kmatrix+6  ;curr
    bne *+5

    jsr right2_t1
    jmp l0
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


