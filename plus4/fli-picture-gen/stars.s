     lda #0
     sta $d4
     lda #1   ;v. scrolling step
     sta $e4
     lda #120  ;y of the sprite
     sta $e6

     jsr inisprite
stars0:
     lda #7   ;v-offset size in steps
     sta $e5
stars1:
     lda #64  ;delay
     sta $e0
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
     dec $e0
     beq *+5
.l4: jmp stars

     ;lda $d4
     ;bne *

     jsr clrsprite
     lda $e4
     sta $d4
     bmi .l5

     jsr spritedown
     jmp .l6

.l5: jsr spriteup
.l6: dec $e5
     bmi *+5
     jmp stars1

     lda $e4
     tax
     dex
     txa
     eor #$ff
     sta $e4
     jmp stars0

inisprite:
     ldx #80
     ldy $e6
     dey
     lda #0
     jsr setp

     ldx #79
     ldy $e6
     dey
     lda #3
     jsr setp

     ldx #80
     ldy $e6
     lda #3
     jsr setp

     ldx #79
     ldy $e6
     ldx #0
     jsr setp

     ldx #80
     ldy $e6
     iny
     lda #0
     jsr setp

     ldx #79
     ldy $e6
     iny
     lda #3
     jmp setp

clrsprite:
     ldx #80
     ldy $e6
     dey
     lda #1
     jsr setp

     ldx #79
     ldy $e6
     dey
     lda #1
     jsr setp

     ldx #80
     ldy $e6
     lda #1
     jsr setp

     ldx #79
     ldy $e6
     lda #1
     jsr setp

     ldx #80
     ldy $e6
     iny
     lda #1
     jsr setp

     ldx #79
     ldy $e6
     iny
     lda #1
     jmp setp

spriteup:
     inc $e6
     ldx #80
     ldy $e6
     dey
     lda #3
     jsr setp

     ldx #79
     ldy $e6
     dey
     lda #0
     jsr setp

     ldx #80
     ldy $e6
     lda #3
     jsr setp

     ldx #79
     ldy $e6
     lda #0
     jsr setp

     ldx #80
     ldy $e6
     iny
     lda #0
     jsr setp

     ldx #79
     ldy $e6
     iny
     lda #3
     jmp setp

spritedown:
     dec $e6
     ldx #80
     ldy $e6
     dey
     lda #3
     jsr setp

     ldx #79
     ldy $e6
     dey
     lda #0
     jsr setp

     ldx #80
     ldy $e6
     lda #3
     jsr setp

     ldx #79
     ldy $e6
     lda #0
     jsr setp

     ldx #80
     ldy $e6
     iny
     lda #0
     jsr setp

     ldx #79
     ldy $e6
     iny
     lda #3
     jmp setp
