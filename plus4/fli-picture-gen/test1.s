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

     lda #25
     jsr delay

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

     lda #25
     jsr delay
     jsr scroll

     lda #$33
     sta $e3
     jsr fill

     lda #1
     sta $d4
     lda $d4
     bne *-2
     lda #-1
     sta $d4
     
     lda #$e1
     sta $e3
     jsr fill

     jsr scroll

     jsr tobasic
     jsr $ff4f
     byte "HELLO!",0
     rts
     ;jmp *

delay: adc $a5
     cmp $a5
     bne *-2
     rts

scroll:
     lda #16
     sta $e0
.l4: lda #1
     sta $d4
     lda #5
     jsr delay
     lda #-1
     sta $d4
     lda #5
     jsr delay
     dec $e0
     bne .l4
     rts

fill:lda #0
     sta $e1
     sta $e2
.l5: sta $e0
.l4: ldx $e0
     ldy $e1
     lda $e2
     sta $d8
     lda $e3
     jsr setpbyte
     clc
     lda $e0
     adc #4
     sta $e0
     cmp #160
     bne .l4

     inc $e1
     bne *+4
     inc $e2
     lda #0
     ldy $e2
     cpy #>VSIZE
     bcc .l5

     ldy $e1
     cpy #<VSIZE
     bcc .l5
     rts
