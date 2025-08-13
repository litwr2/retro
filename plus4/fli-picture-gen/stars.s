;the CLEAR option just sets scrolling only mode, no stars
     lda #0
     sta $d4
     lda #1   ;v. scrolling step
     sta $e4
     lda #120  ;y of the sprite
     sta $e6

     lda #140
     sta $e7   ;y of big sprite 1

     jsr inisprite
     jsr inibsprite1
     jsr inibsprite2
stars0:
     lda #8   ;v-offset size in steps
     sta $e5
stars1:
     lda #64  ;delay
     sta $e0
stars:
  ifndef CLEAR
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
  endif
     dec $e0
     beq *+5
.l4: jmp stars

     jsr clrsprite
     jsr clrbsprite1
     jsr clrbsprite2

     lda $e4
     sta $d4
     bmi .l5

     jsr spritedown
     jsr spritebdown1
     jsr spritebdown2
     jmp .l6

.l5: jsr spriteup
     jsr spritebup1
     jsr spritebup2
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

   macro msetp
     ldx #\1
     ldy $e6
     lda #\2
     \3
     jsr setp
   endm

spritedown:
     dec $e6

inisprite:
     msetp 81,3,dey
     msetp 79,3,dey
     msetp 80,3
     msetp 81,3,iny
     msetp 79,3,iny
     rts

clrsprite:
     msetp 81,1,dey
     msetp 80,1,dey
     msetp 79,1,dey
     msetp 81,1
     msetp 80,1
     msetp 79,1
     msetp 81,1,iny
     msetp 80,1,iny
     msetp 79,1,iny
     rts

spriteup:
     inc $e6
     jmp inisprite

   macro msetpb
     ldx #\1
     lda $e7
     clc
     adc #\3
     tay
     lda #\2
     jsr setpbyte
   endm

spritebdown1:
     dec $e7

inibsprite1:
     msetpb 88,$4d,-3
     msetpb 88,$33,-2
     msetpb 88,$cc,-1
     msetpb 88,$33,0
     msetpb 88,$cc,1
     msetpb 88,$33,2
     msetpb 88,$4d,3
     rts

clrbsprite1:
     msetpb 88,$55,-3
     msetpb 88,$55,-2
     msetpb 88,$55,-1
     msetpb 88,$55,0
     msetpb 88,$55,1
     msetpb 88,$55,2
     msetpb 88,$55,3
     rts

spritebup1:
     inc $e7
     jmp inibsprite1

spritebdown2:
     ;dec $e7

inibsprite2:
     msetpb 48,$53,-4+14
     msetpb 52,$35,-4+14
     msetpb 48,$4c,-3+14
     msetpb 52,$cd,-3+14
     msetpb 48,$33,-2+14
     msetpb 52,$33,-2+14
     msetpb 48,$cc,-1+14
     msetpb 52,$cc,-1+14
     msetpb 48,$31,0+14
     msetpb 52,$73,0+14
     msetpb 48,$cc,1+14
     msetpb 52,$cc,1+14
     msetpb 48,$33,2+14
     msetpb 52,$33,2+14
     msetpb 48,$4c,3+14
     msetpb 52,$cd,3+14
     msetpb 48,$53,4+14
     msetpb 52,$35,4+14
     rts

clrbsprite2:
     msetpb 48,$55,-4+14
     msetpb 52,$55,-4+14
     msetpb 48,$55,-3+14
     msetpb 52,$55,-3+14
     msetpb 48,$55,-2+14
     msetpb 52,$55,-2+14
     msetpb 48,$55,-1+14
     msetpb 52,$55,-1+14
     msetpb 48,$55,0+14
     msetpb 52,$55,0+14
     msetpb 48,$55,1+14
     msetpb 52,$55,1+14
     msetpb 48,$55,2+14
     msetpb 52,$55,2+14
     msetpb 48,$55,3+14
     msetpb 52,$55,3+14
     msetpb 48,$55,4+14
     msetpb 52,$55,4+14
     rts

spritebup2:
     ;inc $e7
     jmp inibsprite2

