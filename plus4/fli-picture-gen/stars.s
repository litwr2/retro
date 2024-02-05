     lda #0
     sta $d4
     lda #1
     sta $e4
     lda #35
     sta $e6

     ldx #1
     ldy $e6
     dey
     lda #0
     jsr setp
     ldx #0
     ldy $e6
     dey
     lda #3
     jsr setp
     ldx #1
     ldy $e6
     lda #3
     jsr setp
     ldx #0
     ldy $e6
     txa
     jsr setp
     ldx #1
     ldy $e6
     iny
     lda #0
     jsr setp
     ldx #0
     ldy $e6
     iny
     lda #3
     jsr setp
stars0:
     lda #7
     sta $e5
stars:
     lda $ff1e
     adc $ff1d
     rol
     rol
     and #$7f
     sta $e3
     lda $ff1e
     lsr
     and #$1f
     adc $e3
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
     inc $e0
     beq *+5
.l4: jmp stars

     ;lda $d4
     ;bne *

     ldx #1
     ldy $e6
     dey
     lda #1
     jsr setp
     ldx #0
     ldy $e6
     dey
     lda #1
     jsr setp
     ldx #1
     ldy $e6
     lda #1
     jsr setp
     ldx #0
     ldy $e6
     lda #1
     jsr setp
     ldx #1
     ldy $e6
     iny
     lda #1
     jsr setp
     ldx #0
     ldy $e6
     iny
     lda #1
     jsr setp

     lda $e4
     sta $d4
     bmi .l5

     dec $e6
     jmp .l6

.l5: inc $e6
.l6: ldx #1
     ldy $e6
     dey
     lda #3
     jsr setp
     ldx #0
     ldy $e6
     dey
     lda #0
     jsr setp
     ldx #1
     ldy $e6
     lda #3
     jsr setp
     ldx #0
     ldy $e6
     txa
     jsr setp
     ldx #1
     ldy $e6
     iny
     lda #0
     jsr setp
     ldx #0
     ldy $e6
     iny
     lda #3
     jsr setp

     dec $e5
     bmi *+5
     jmp stars

     lda $e4
     tax
     dex
     txa
     eor #$ff
     sta $e4
     jmp stars0

