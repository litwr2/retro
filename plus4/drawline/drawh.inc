;tmpx assembler
;rb - free

fhplot ;in x - dx, y - dy; bit 7 - left, bit 0 - right
.block
p = r5l
m8 = rcl
c8 = rch
yh = r6h
    txa
    beq l3
    bpl l1

    lda m8
    bmi l9

    sec
    lda p
    sbc #8
    sta p
    bcs *+4
    dec p+1
    asl c8
    rol c8
    lda ral
    bne *+6
    dec r3h
    dec r9h
    dec ral
    stx rah
    lda #$fe
    sta m8
    bne l3  ;always

l9  asl c8
    sec
    rol m8
    bne l3  ;always

l1  sec
    ror m8
    bcs la

    lda p
    adc #8  ;C=0
    sta p
    bcc *+4
    inc p+1
    stx rah
    lsr c8
    ror c8
    lda #$7f
    sta m8
    inc ral
    bne l3

    inc r3h
    inc r9h
    bne l3  ;always

la  lsr c8
l3  tya
    beq l7
    bpl l5

    lda yh
    dec yh
    and #7
    bne l6

    sec
    lda p
    sbc #<313
    sta p
    lda p+1
    sbc #>313  ;sets C=1
    sta p+1
    sty rah
    lda ral
    sbc #40
    sta ral
    bcs l7

    dec r3h
    dec r9h
l7  ldy #0
    lda (p),y
    and m8
    ora c8
    sta (p),y
    lda rah
    beq *+7
    sty rah
    jmp tplot
    rts

l6  lda p
    bne *+4
    dec p+1
    dec p
    jmp l7

l5  inc yh
    lda yh
    and #7
    bne l2

    lda p
    clc
    adc #<313
    sta p
    lda p+1
    adc #>313
    sta p+1
    sty rah
    lda ral
    adc #40  ;C=0
    sta ral
    bcc l7

    inc r3h
    inc r9h
    bne l7  ;always

l2  inc p
    bne l7

    inc p+1
    bne l7  ;always
.bend

ctplot  ;in: x - r8, y - r1h;  out: r3h, r9h, ral;  use: r5h
.block  ;remove r5h!!
x0l = r8l
x0h = r8h
y0 = r1h
    lda x0h
    lsr
    lda x0l
    ror
    lsr
    lsr
    sta ral
    lda #0
    sta r5h
    lda y0
    and #$f8
    sta m1
    asl
    rol r5h
    asl
    rol r5h  ;set C=0
m1 = * + 1
    adc #0  ;C=0
    bcc *+4
    inc r5h
    clc
    adc ral  ;sets C
    sta ral
    lda #gabase
    adc r5h   ;sets C=0
    sta r3h
    adc #4   ;C=0, sets C=0
    sta r9h
.bend

tplot  ;use: r0h
.block
c8 = rch
    ldy ral
    lda (r3l),y
    ldx c8
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
    sta (r3l),y
    lda (r9l),y
    and #$f
    sta r0h
    lda $86
    asl
    asl
    asl
    asl
    clc
    adc r0h  ;C=0
    sta (r9l),y
    rts

bg  and #$f
    sta r0h
    lda $ff15
    and #$70
    clc
    adc r0h  ;sets C=0
    sta (r3l),y
    lda (r9l),y
    and #$70
    sta r0h
    lda $ff15
    and #$f
    adc r0h  ;C=0
    sta (r9l),y
    rts
.bend

pow2 .byte 128,64,32,16,8,4,2,1
pow2i .byte 127,191,223,239,247,251,253,254

ghplot ;in x - r8, y - r1h, cs = rch (0 - bg, 1 - fg); use r0l, r5
.block  ;40*(y & $f8) + (y&7) + (x & f8)
x0l = r8l
x0h = r8h
y0 = r1h
p = r5l
m8 = rcl
c8 = rch
yh = r6h
    jsr ctplot
    lda y0
    and #7
    sta m2
    lda y0
    sta yh  ;fhplot!
    and #$f8
    tay
    jsr mul40
    adc x0l   ;C=0
    and #$f8
m2 = * + 1
    ora #0
    sta r5l
    lda r5h
    adc x0h  ;sets C=0
    adc #gbase  ;C=0, sets C=0
    sta r5h

    lda x0l
    and #7
    tax
    ldy c8
    beq l1

    lda pow2,x
    sta c8
l1  lda pow2i,x
    sta m8   ;fhplot!
    ldy #0
    and (r5l),y
    ora c8
    sta (r5l),y
.bend
erts rts

drawhline ;in x0 - r8, y0 - r1h, x1 - r2, y1 - r6h, cs = rch (0 - bg, 1 - fg)
          ;sx:sy - m:m; err - r4; e2 - m:r6l; dy:dx - r1l:r7
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
cntl = r2l
cnth = r2h
c8 = rch
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
    ldx #$80
    bmi l3  ;always

l1  lda x1l
    sec
    sbc x0l
    pha
    lda x1h
    sbc x0h  ;x1 - x0
    ldx #1
l3  stx sx
    sta dxh
    sta cnth
    pla
    sta dxl
    sta cntl

    lda y0
    cmp y1
    bcc l2  ;y0 < y1

    ;lda y0  ;y0 >= y1
    sbc y1  ;C=1
    ldx #$80
    bne l4  ;always

l2  sec
    lda y1
    sbc y0
    ldx #1
l4  stx sy
    sta dy

    lda dxl   ;err = dx - dy
    sec
    sbc dy
    sta errl
    lda dxh
    sbc #0
    sta errh

    lda dxh  ;if (dx < dy) cnt = dy; else cnt = dx
    bne l15

    lda dy
    cmp dxl
    bcc l15

    sta cntl
l15
    lda c8
    jsr ghplot
l5
    lda cntl  ;if (cnt-- == 0) break
    bne *+6
    dec cnth
    bmi erts
    dec cntl

    lda errl  ;e2 = 2*err
    asl
    sta e2l
    lda errh
    rol
    sta e2h

    ldx #0
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
sx = * + 1
    ldx #0
l7  ldy #0

    lda dxl
    cmp e2l
    lda dxh
e2h = * + 1
    sbc #0
    bmi l14

    clc   ;e2 <= dx
    lda dxl
    adc errl
    sta errl
    lda dxh
    adc errh
    sta errh
sy = * + 1
    ldy #0
l14 jsr fhplot
    jmp l5
.bend

