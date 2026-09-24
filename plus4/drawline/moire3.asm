;vasm6502-oldstyle assembler

  include "registers.mac"

ROM8table = 0   ;0 - RAM, ROM address ($C289, $DF7A)  saves 8 bytes
usehrattr = 1
hrcoorcheck = 1
gabase = $18   ;attributes
gbase = $20    ;bitmap

    * = $1001
 byte <(eob-2),>(eob-2),$a,0
 byte $9e  ;sys
 byte init/1000+48, init/100%10+48, init/10%10+48, init%10+48
 byte ":"
 byte $e7  ;color
 byte "0,5,3:"
 byte $e7  ;color
 byte "1,2,7:"
 byte "TI$",$b2,$22,"000000",$22  ;ti="000000"
 byte ":"
 byte $de  ;graphic
 text "1,1:"
 byte $9e  ;sys
 byte start/1000+48, start/100%10+48, start/10%10+48, start%10+48
 byte ":"
 byte $99,$54,$49  ;print ti
 byte ":"
 byte $a1,$f9,$41,$24  ;getkeya$
 byte ":"
 byte $de  ;graphic
 byte "0"
 byte 0,0,0
eob

init
    lda #<eob
    sta $2d
    sta $2f
    sta $31
    lda #>eob
    sta $2e
    sta $30
    sta $32
    lda #$60  ;rts
    sta init
    rts

rnd99 lda $ff1c
    eor $ff1e
    and #$7f
    cmp #100
    bcs rnd99
    rts

start
    jsr hrinit

    jsr rnd99
    adc #110
    sta xc
    jsr rnd99
    adc #50
    sta yc

    lda #0
    sta i
    sta i+1
.l3 lda i
    cmp #<319
    lda i+1
    sbc #>319
    bcs p2

    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda i
    sta r2l
    lda i+1
    sta r2h
    lda #0
    sta r6h
    lda #1
    sta rch
    jsr drawhrline
    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    ldy i+1
    ldx i
    inx
    bne *+3
    iny
    sty r2h
    stx r2l
    lda #0
    sta r6h
    ;lda #0
    sta rch
    jsr drawhrline
    lda i
    clc
    adc #2
    sta i
    bcc .l3

    inc i+1
    bne .l3
p2
    lda #0
    sta i
    sta i+1
.l3 lda i
    cmp #<200
    lda i+1
    sbc #>200
    bcs p3

    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda #<319
    sta r2l
    lda #>319
    sta r2h
    lda i
    sta r6h
    lda #1
    sta rch
    jsr drawhrline
    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda #<319
    sta r2l
    lda #>319
    sta r2h
    ldx i
    inx
    stx r6h
    lda #0
    sta rch
    jsr drawhrline
.l1 lda i
    clc
    adc #2
    sta i
    bcc .l3

    inc i+1
    bne .l3
p3
    lda #<319
    sta i
    lda #>319
    sta i+1
.l3 lda i
    cmp #$ff
    bne .l1

    lda i+1
    cmp #$ff
    beq p4

.l1 lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda i
    sta r2l
    lda i+1
    sta r2h
    lda #199
    sta r6h
    lda #1
    sta rch
    jsr drawhrline
    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    ldy i+1
    ldx i
    bne *+3
    dey
    dex
    stx r2l
    sty r2h
    lda #199
    sta r6h
    lda #0
    sta rch
    jsr drawhrline
    lda i
    sec
    sbc #2
    sta i
    bcs .l3
    
    dec i+1
    jmp .l3
p4
    lda #199
    sta i
    lda #0
    sta i+1
.l3 lda i
    cmp #$ff
    bne .l1

    lda i+1
    cmp #$ff
    beq p5

.l1 lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda #0
    sta r2l
    lda #0
    sta r2h
    lda i
    sta r6h
    lda #1
    sta rch
    jsr drawhrline
    lda xc
    sta r8l
    lda xc+1
    sta r8h
    lda yc
    sta r1h
    lda #0
    sta r2l
    lda #0
    sta r2h
    ldx i
    dex 
    stx r6h
    lda #0
    sta rch
    jsr drawhrline
    lda i
    sec
    sbc #2
    sta i
    bcs .l3

    dec i+1
    jmp .l3
p5
    rts

xc byte 0,0
yc byte 0
x0 byte 0,0
y0 byte 0
x1 byte 0,0
y1 byte 0
i byte 0,0


   * = $1300
  include "drawh.inc"

