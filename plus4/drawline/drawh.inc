;tmpx assembler
;thanks to Crown and MMS for hints
;r4h,r7,rb - free

fhplot ;in: x - dx, y - dy, r6l - yh, rc - m8/c8, r5 - p, ral; bit 7 - left, bit 0 - right
       ;use: ra
.block
p = r5l
m8 = rcl
c8 = rch
yh = r6l
    txa
    beq l3

    sec
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

ctplot  ;in: x - r8, y - r1h;  out: r3h, r9h, ral
.block
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
    sta r3h
    lda y0
    and #$f8
    sta m1
    asl
    rol r3h
    asl
    rol r3h  ;set C=0
m1 = * + 1
    adc #0  ;C=0
    bcc *+4
    inc r3h
    clc
    adc ral  ;sets C
    sta ral
    lda #gabase
    adc r3h   ;sets C=0
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

ghplot ;in x - r8, y - r1h, cs = rch (0 - bg, 1 - fg), rcl;  out: r6l;  use r0l, r5
.block  ;40*(y & $f8) + (y&7) + (x & f8)
x0l = r8l
x0h = r8h
y0 = r1h
p = r5l
m8 = rcl
c8 = rch
yh = r6l
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

drawhline ;in: x0 - r8, y0 - r1h, x1 - r2, y1 - r6h, cs = rch (0 - bg, 1 - fg)
          ;use: r0*, r1, r2, r3*, r4l, r5*, r6 (r6l*), r8, r9*, ra*, rc (rcl*)
.block
x0l = r8l
x0h = r8h
y0 = r1h
x1l = r2l
x1h = r2h
y1 = r6h
xyl = r4l
;xyh = m
vl = r8l
vh = r8h
dy = r6h
dxl = r2l
dxh = r2h
cntl = r1l
cnth = r1h
    lda #1
    sta m2
    sta m3
    lda x0h
    cmp x1h
    bcc l1  ;x0 < x1
    bne l12 ;x0 >= x1

    lda x0l
    cmp x1l
    bcc l1

l12 lda x0l  ;x0 >= x1
    ldx x1l  ;swap(x0, x1), swap(y0, y1)
    stx x0l
    sta x1l
    lda x0h
    ldx x1h
    stx x0h
    sta x1h
    lda y0
    ldx y1
    stx y0
    sta y1

l1  lda x1l
    sec
    sbc x0l
    sta dxl
    sta cntl
    lda x1h
    sbc x0h  ;x1 - x0
    sta dxh

    jsr ghplot  ;plot(x, y, c)
    lda y1
    sec
    sbc y0
    bcc l2  ;y1 < y0

l7  sta dy  ;y1 >= y0
    ldx dxh
    bne l3  ;dx > dy

    cmp dxl
    bcs l4  ;dx <= dy

l3  lda dxl  ;dy < dx
    sec  ;xy = dx - dy
    sbc dy
    sta xyl
    lda dxh
    sta cnth
    sbc #0
    sta xyh
    lda dxh  ;d = dy - dx/2
    lsr
    lda dxl
    ror
    sta m1
    lda dy
    sec
m1 = * + 1
    sbc #0
    sta vl
    lda #0
    sbc #0
    sta vh
l5a lda cntl
    bne *+6
    dec cnth
    bmi e1  ;erts

    dec cntl
    ldx #1  ;x++
    ldy #0
    lda vh
    bpl l6x

    lda vl  ;d < 0
    clc  ;v += dy
    adc dy
    sta vl
    bcc *+4
    inc vh
    jsr fhplot
    jmp l5a

l2  eor #$ff  ;y1 < y0
    adc #1  ;C=0
    ldx #$80
    stx m2
    stx m3
    bne l7  ;always

l6x lda vl  ;v >= 0
    sec   ;v -= xy
    sbc xyl
    sta vl
    lda vh
xyh = * + 1
    sbc #0
    sta vh
m2 = * + 1
    ldy #1  ;y++
    jsr fhplot
    jmp l5a

l4  ;lda dy  ;dy >= dx
    sta cntl
    ;sec  ;xy = dy - dx
    sbc dxl  ;C=1
    sta xyl

    lda dy  ;v = dx - dy/2
    lsr
    sta m4
    lda dxl
    sec
m4 = * + 1
    sbc #0
    sta vl
    lda #0
    sbc #0
    sta vh
    inc cntl
l5b dec cntl
    bne *+3
e1  rts

    ;dec cntl
m3 = * + 1
    ldy #1  ;y++
    lda vl
    ldx #0
    cpx vh
    bcs l6y

    ;lda vl  ;v < 0
    ;clc  ;v += dy
    adc dxl
    sta vl
    bcc *+4
    inc vh
    jsr fhplot
    jmp l5b

l6y ;lda vl  ;v >= 0
    ;sec
    sbc xyl  ;v -= xy
    sta vl
    bcs *+4
    dec vh
    ldx #1  ;x++
    jsr fhplot
    jmp l5b
.bend

