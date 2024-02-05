stars:
     lda $ff1e
     adc $ff1d
     rol
     rol
     and #$7f
     sta $e0
     lda $ff1e
     lsr
     and #$1f
     adc $e0
     sta $e1
     tax

     lda #0
     sta $d8
     lda $ff00
     adc $ff01
     adc $ff02
     eor $ff03
     rol
     adc $ff1e
     rol
     adc $ff1d
     rol
     adc $ff1f
     rol
     rol $d8
     ldy $d8
     cpy #>VSIZE
     bcc .ok1

     cmp #<VSIZE
     bcc .ok1

     lsr $d8
     ror
.ok1:tay
     sta $e2

     lda $ff1e
     adc $ff1f
     and #$7b
     beq .l2
     
     lda #1
     bne .l3

.l2: lda $ff1e
     lsr
     and #3
.l3: sta $e3
     jsr setp

     lda #0
     sta $d9
     lda $e3
     cmp #1
     beq .l1     

     lda $ff1d
     rol
     adc $ff1f
     rol
     adc $ff04
     eor $ff05
     rol
     adc $ff1e
     sta $d9
.l1: ldx $e1
     ldy $e2
     lda $e3
     jsr seta
     jmp stars

