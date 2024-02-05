     lda #0
     sta $d8
     lda #$a0
     sta $e0
.l1: ldx $e0
     dex
     ldy $e0
     dey
     lda #2
     jsr setp

     ldx $e0
     dex
     ldy $e0
     lda #3
     jsr setp

     ldx $e0
     dex
     ldy $e0
     iny
     lda #2
     jsr setp

     ldx $e0
     dex
     ldy $e0
     iny
     iny
     lda #0
     jsr setp
     dec $e0
     bne .l1

     lda #$a0
     sta $e0
.l2: ldx $e0
     dex
     txa
     clc
     adc #VSIZE-160
     tay
     lda #0
     rol
     sta $d8
     lda #2
     jsr setp
     dec $e0
     bne .l2

     lda $a5
     adc #25
     cmp $a5
     bne *-2

     lda #$a0
     sta $e0
.l3: lda #$77
     sta $d9
     lda #0
     sta $d8
     ldx $e0
     dex
     ldy $e0
     ;dey
     lda #2
     jsr seta

     ldx $e0
     dex
     ldy $e0
     dey
     lda #2
     jsr seta

     ldx $e0
     dex
     txa
     clc
     adc #VSIZE-160
     tay
     lda #0
     rol
     sta $d8
     lda #2
     jsr seta
     dec $e0
     dec $e0
     bne .l3

     lda #0
     sta $d8
     ldx #80
     ldy #200
     lda #1
     ;jsr seta
     jmp *
     ;jmp tobasic

