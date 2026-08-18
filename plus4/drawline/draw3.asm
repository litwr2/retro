.include "cbm35basic.mac"
gabase = $18
gbase = $20
r6l = $14
r6h = $15
r7l = $39
r7h = $3a
r8l = 3
r8h = 4
   * = $1100
tplot  ;in x, y, a = cs (0 - bg, 1 - fg); use r0, r5
.block
    sta r0l
    jsr mul40
    sta r5l
    txa
    adc r5l
    sta r5l
    bcc *+4
    inc r5h

    lda #gabase
    clc
    adc r5h   ;sets C=0
    sta r5h

    ldy #0
    lda (r5l),y
    ldx r0l
    beq bg

    and #$f0
    sta r0h
    lda $86
    lsr
    lsr
    lsr
    lsr
    clc
    adc r0h  ;sets C=0
    sta (r5l),y
    lda r5h
    adc #4  ;C=0
    sta r5h
    lda (r5l),y
    and #$f
    sta r0h
    lda $86
    asl
    asl
    asl
    asl
    clc
    adc r0h
    sta (r5l),y
    rts

bg  and #$f
    sta r0h
    lda $ff15
    and #$70
    adc r0h  ;C=0, sets C=0
    sta (r5l),y
    lda r5h
    adc #4  ;C=0, sets C=0
    sta r5h
    lda (r5l),y
    and #$70
    sta r0h
    lda $ff15
    and #$f
    adc r0h  ;C=0
    sta (r5l),y
    rts
.bend

ghplot ;in x - r8, y - r1h, a = cs (0 - bg, 1 - fg); use r0l, r5
.block  ;40*(y & $f8) + (y&7) + (x & $f8)
x0l = r8l
x0h = r8h
y0 = r1h
x8o = r3l
y8o = r3h
    sta gm3

    lda x0h
    jsr ctplot
    jsr cgplot
    tax
    lda pow2,x
    sta r0l
    ldy #0
    lda (r5l),y

    ldx gm3
    beq bg

    ora r0l
    sta (r5l),y
    rts

bg  eor #$ff
    ora r0l
    eor #$ff
    sta (r5l),y
    rts
.bend

pow2 .byte 128,64,32,16,8,4,2,1

gmplot ;in x - r8l, y - r1h, a = cs (0 - mc1, 1 - bg, 2 - fg, 3 - mc2); use r0l, r5, r8h
.block  ;40*(y & $f8) + (y&7) + ((x & $fc) << 1)
x0l = r8l
x0h = r8h
y0 = r1h
x8o = r3l
y8o = r3h
    sta gm3

    asl x0l
    lda #0
    rol
    sta x0h

    ldx gm3
    beq l5

    cpx #3
    beq l5

    ;lda x0h
    jsr ctplot
l5  jsr cgplot
.if 0
    sbc #5  ;C=0
    eor #$ff
    tay
    lda #$fc
    iny
    beq l1

l2  sec
    rol
    asl gm3
    dey
    bne l2
.endif
    lsr
    tay
    asl
    asl
    ora gm3
    tax
    lda mcbits,x
    sta r0l
    lda mcmask,y
    ldy #0
    and (r5l),y
    ora r0l
    sta (r5l),y
.if 0
l1  ;ldy #0
    and (r5l),y
    ora gm3
    sta (r5l),y
.endif
    lsr x0h
    ror x0l
    rts
mcbits .byte $3f,$cf,$f3,$fc
mcmask .byte 0,0,0,0,$40,$10,4,1,$80,$20,8,2,$c0,$30,$c,3
.bend

cgplot
.block
x0l = r8l
x0h = r8h
y0 = r1h

    lda y0
    and #7
    sta m2  ;y&7
    lda x0l
    and #$f8
    sta m1  ;8*[x/8] = x&$f8
    lda y0
    and #$f8
    tay
    jsr mul40
m2 = * + 1
    ora #0
m1 = * + 1
    adc #0  ;C=0
    sta r5l
    lda r5h
    adc x0h  ;sets C=0
    adc #gbase  ;C=0, sets C=0
    sta r5h

    lda x0l
    and #7
    rts
.bend

ctplot
.block
x0l = r8l
x0h = r8h
y0 = r1h
x8o = r3l
y8o = r3h

    lsr
    lda x0l
    ror
    lsr
    lsr
    tax
    lda y0
    lsr
    lsr
    lsr
    cmp y8o
    bne l6

    cpx x8o
    bne l6
    rts

l6  tay
    stx x8o
    sty y8o
.bend
gm3 = * + 1
    lda #0
    ;lda #0  ;for tests only
    jmp tplot


drawhline ;in x0 - r8, y0 - r1h, x1 - r2, y1 - r6h, a = cs (0 - bg, 1 - fg)
          ;sx:sy - m:c; err - r4; e2 - m:r6l; dy:dx - r1l:r7
.block
x0l = r8l
x0h = r8h
y0 = r1h
x1l = r2l
x1h = r2h
y1 = r6h
errl = r4l
errh = r4h
e2l = r6l
dy = r1l
dxl = r7l
dxh = r7h
x8o = r3l
y8o = r3h

    sta m3
    lda x0h
    cmp x1h
    bcc l1  ;x0 < x1
    bne l12 ;x0 >= x1

    lda x0l
    cmp x1l
    bcc l1

l12 lda x0l  ;x0 >= x1
    sbc x1l  ;C=1
    pha
    lda x0h
    sbc x1h  ;x0 - x1
    ldx #$ff
    ldy #$ff
    bmi l3  ;always

l1  lda x1l
    sec
    sbc x0l
    pha
    lda x1h
    sbc x0h  ;x1 - x0
    ldx #1
    ldy #0
l3  stx sxl
    sty sxh
    sta dxh
    pla
    sta dxl

    lda y0
    cmp y1
    bcc l2  ;y0 < y1

    ;lda y0  ;y0 >= y1
    sbc y1  ;C=1
    ldx #$c6  ;dec zp
    bne l4  ;always

l2  sec
    lda y1
    sbc y0
    ldx #$e6  ;inc zp
l4  stx csy
    stx y8o
    sta dy

    lda dxl
    sec
    sbc dy
    sta errl
    lda dxh
    sbc #0
    sta errh
l5
m3 = * + 1
    lda #0
    jsr ghplot
    lda x0h
    cmp x1h
    bne l6

    lda x0l
    cmp x1l
    bne l6

    lda y0
    cmp y1
    bne l6
    rts

l6  lda errl
    asl
    sta  e2l
    lda errh
    rol
    sta e2h

    lda e2l
    clc
    adc dy
    lda e2h
    adc #0
    bmi l7  ;e2 < -dy

l14 lda errl  ;e2 >= dy
    sec
    sbc dy
    sta errl  ;err += dy
    bcs *+4
    dec errh
    lda x0l
    clc
sxl = * + 1
    adc #0
    sta x0l
    lda x0h
sxh = * + 1
    adc #0 ;x0 += sx
    sta x0h
l7  lda dxh
e2h = * + 1
    cmp #0
    bmi l5
    bne l11

    lda dxl
    cmp e2l
    bmi l5

l11 clc   ; e2 <= dx
    lda dxl
    adc errl
    sta errl
    lda dxh
    adc errh
    sta errh
csy inc y0
    bvc l5  ;always
.bend

mul40   ;in y; out r5h:a, C=0
.block
    lda #0
    sta r5h
    sty m1
    tya
    asl
    rol r5h
    asl
    rol r5h
m1 = * + 1
    adc #0
    bcc *+4
    inc r5h
    asl
    rol r5h
    asl
    rol r5h
    asl
    rol r5h
    rts
.bend

drawmline ;in x0 - r8l, y0 - r1h, x1 - r2l, y1 - r6h, a = cs (0 - mc1, 1 - bg, 2 - fg, 3 - mc2)
          ;sx:sy - c:c; err - r4; e2 - m:r6l; dy:dx - r1l:r7l
.block
x0 = r8l
y0 = r1h
x1 = r2l
y1 = r6h
errl = r4l
errh = r4h
e2l = r6l
dy = r1l
dx = r7l
x8o = r3l
y8o = r3h

    sta m3
    lda x0
    cmp x1
    bcc l1  ;x0 < x1

    lda x0  ;x0 >= x1
    sbc x1  ;C=1
    ldx #$c6  ;dec zp
    bne l3  ;always

l1  lda x1
    sec
    sbc x0
    ldx #$e6  ;inc zp
l3  stx csx
    sta dx

    lda y0
    cmp y1
    bcc l2  ;y0 < y1

    ;lda y0  ;y0 >= y1
    sbc y1  ;C=1
    ldx #$c6  ;dec zp
    bne l4  ;always

l2  sec
    lda y1
    sbc y0
    ldx #$e6  ;inc zp
l4  stx csy
    stx y8o
    sta dy

    lda dx
    sec
    sbc dy
    sta errl
    lda #0
    sbc #0
    sta errh
l5
m3 = * + 1
    lda #0
    jsr gmplot
    lda x0
    cmp x1
    bne l6

    lda y0
    cmp y1
    bne l6
    rts

l6  lda errl
    asl
    sta e2l
    lda errh
    rol
    sta e2h

    lda e2l
    clc
    adc dy
    lda e2h
    adc #0
    bmi l7  ;e2 < -dy

    lda errl  ;e2 >= dy
    sec
    sbc dy
    sta errl  ;err += dy
    bcs *+4
    dec errh
csx dec x0
l7  lda #0
e2h = * + 1
    cmp #0
    bmi l5
    bne l11

    lda dx
    cmp e2l
    bcc l5

l11 clc   ; e2 <= dx
    lda dx
    adc errl
    sta errl
    bcc *+4
    inc errh
csy inc y0
    jmp l5  ;always
.bend
