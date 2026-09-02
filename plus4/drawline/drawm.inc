;vasm6502-oldstyle assembler
;thanks to Crown and MMS for hints
;r2h,r4h,r7,rb - free

fmplot ;in: x - dx, y - dy, r6l - .yh, rc - .m8/.c8, r5 - p, ral; bit 7 - left, bit 0 - right
       ;use: ra
.p = r5l
.m8 = rcl
.c8 = rch
.yh = r6l
    txa
    beq .l3

    sec
    ror .m8
    bcs .la

    lda .p
    adc #8  ;C=0
    sta .p
    bcc *+4
    inc .p+1
    stx rah
    lda .c8
    lsr
    ror
    ror
    sta .c8
    lda #$3f
    sta .m8
    inc ral
    bne .l3

    inc r3h
    inc r9h
    bne .l3  ;always

.la  ror .m8  ;C=1
    lsr .c8
    lsr .c8
.l3  tya
    beq .l7
    bpl .l5

    lda .yh
    dec .yh
    and #7
    bne .l6

    sec
    lda .p
    sbc #<313
    sta .p
    lda .p+1
    sbc #>313  ;sets C=1
    sta .p+1
    sty rah
    lda ral
    sbc #40
    sta ral
    bcs .l7

    dec r3h
    dec r9h
.l7  ldy #0
    lda (.p),y
    and .m8
    ora .c8
    sta (.p),y

    lda rah
    beq .lb

    sty rah
    lda .c8
    beq .lb

    eor #$ff
    cmp .m8
    bne *+3
.lb  rts
    jmp mtplot

.l6  lda .p
    bne *+4
    dec .p+1
    dec .p
    jmp .l7

.l5  inc .yh
    lda .yh
    and #7
    bne .l2

    lda .p
    clc
    adc #<313
    sta .p
    lda .p+1
    adc #>313
    sta .p+1
    sty rah
    lda ral
    adc #40  ;C=0
    sta ral
    bcc .l7

    inc r3h
    inc r9h
    bne .l7  ;always

.l2  inc .p
    bne .l7

    inc .p+1
    bne .l7  ;always
.bend

mctplot  ;in: x - r8l, y - r1h;  out: r3h, r9h, ral
.block
.x0 = r8l
.y0 = r1h
    lda .x0
    lsr
    lsr
    sta ral
    lda #0
    sta r3h
    lda .y0
    and #$f8
    sta .m1
    asl
    rol r3h
    asl
    rol r3h  ;set C=0
.m1 = * + 1
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

mtplot  ;use: r0h
.block
.c8 = rch
    ldy ral
    lda .c8
    and #$55
    beq bg

    lda (r3l),y
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

bg  lda (r3l),y
    and #$f
    sta r0h
    lda $85
    and #$70
    clc
    adc r0h  ;sets C=0
    sta (r3l),y
    lda (r9l),y
    and #$70
    sta r0h
    lda $85
    and #$f
    adc r0h  ;C=0
    sta (r9l),y
    rts
.bend

pow2m byte 0,64,128,192,0,16,32,48,0,4,8,12,0,1,2,3
pow2im byte $3f,$cf,$f3,$fc

gmplot ;in x - r8l, y - r1h, cs - rch (0 - mc1, 1 - fg, 2 - bg, 3 - mc2), r6l;
       ;out: r6l;  use: r0l, r5, r8h
.block  ;40*(y & $f8) + (y&7) + ((x << 1) & $f8)
x0l = r8l
x0h = r8h
.y0 = r1h
.p = r5l
.m8 = rcl
.c8 = rch
.yh = r6l
    lda .c8
    beq .l1

    cmp #3
    beq .l1

    jsr mctplot
.l1  lda #gbase/2
    sta x0h
    lda x0l
    asl
    sta .m1
    rol x0h
    lda .y0
    and #7
    sta .m2
    lda .y0
    sta .yh
    and #$f8
    tay
    jsr mul40
.m1 = * + 1
    adc #0   ;C=0
    and #$f8
.m2 = * + 1
    ora #0
    sta r5l
    lda r5h
    adc x0h
    sta r5h

    lda .m1
    and #6
    asl
    ora .c8
    tax
    lda pow2m,x
    sta .c8
    lda x0l
    and #3
    tax
    lda pow2im,x
    sta .m8
    ldy #0
    and (r5l),y
    ora .c8
    sta (r5l),y
.bend
    rts

drawmline ;in: x0 - r8l, y0 - r1h, x1 - r2l, y1 - r6h, cs = rch (0 - bg, 1 - fg)
          ;use: r0*, r1l, r2l, r3*, r4l, r5*, r6 (r6l*), r8 (r8h*), r9*, ra*, rc (rcl*)
.block
.x0 = r8l
.y0 = r1h
.x1 = r2l
.y1 = r6h
.xy = r4l
.vl = r8l
.vh = r8h
.dy = r6h
.dx = r2l
.cnt = r1l
    lda #1
    sta .m2
    sta .m3

    lda .x0
    cmp .x1
    bcc .l1  ;x0 < x1

    lda .x0  ;x0 >= x1
    ldx .x1  ;swap(x0, x1), swap(y0, y1)
    stx .x0
    sta .x1
    lda .y0
    ldx .y1
    stx .y0
    sta .y1

.l1  lda .x1
    sec
    sbc .x0
    sta .dx  ;x1 - x0
    sta .cnt

    jsr gmplot  ;plot(x, y, c)
    lda .y1
    sec
    sbc .y0
    bcc .l2  ;y1 < y0

.l7  sta .dy  ;y1 >= y0
    cmp .dx
    bcs .l4  ;dx <= dy

    lda .dx  ;dy < dx
    sec  ;xy = dx - dy
    sbc .dy
    sta .xy
    lda .dx  ;d = dy - dx/2
    lsr
    sta .m1
    lda .dy
    sec
.m1 = * + 1
    sbc #0
    sta .vl
    lda #0
    sbc #0
    sta .vh
    inc .cnt
.l5a dec .cnt
    beq .e1  ;erts

    ldx #1  ;x++
    ldy #0
    lda .vh
    bpl .l6x

    lda .vl  ;d < 0
    clc  ;v += dy
    adc .dy
    sta .vl
    bcc *+4
    inc .vh
    jsr fmplot
    jmp .l5a

.l2  eor #$ff  ;y1 < y0
    adc #1  ;C=0
    ldx #$80
    stx .m2
    stx .m3
    bne .l7  ;always

.l6x lda .vl  ;v >= 0
    sec   ;v -= xy
    sbc .xy
    sta .vl
    lda .vh
xyh = * + 1
    sbc #0
    sta .vh
.m2 = * + 1
    ldy #1  ;y++
    jsr fmplot
    jmp .l5a

.l4  ;lda .dy  ;dy >= dx
    sta .cnt
    ;sec  ;xy = dy - dx
    sbc .dx  ;C=1
    sta .xy

    lda .dy  ;v = dx - dy/2
    lsr
    sta .m4
    lda .dx
    sec
.m4 = * + 1
    sbc #0
    sta .vl
    lda #0
    sbc #0
    sta .vh
    inc .cnt
.l5b dec .cnt
    bne *+3
.e1  rts

.m3 = * + 1
    ldy #1  ;y++
    lda .vl
    ldx #0
    cpx .vh
    bcs .l6y

    ;lda .vl  ;v < 0
    ;clc  ;v += dy
    adc .dx
    sta .vl
    bcc *+4
    inc .vh
    jsr fmplot
    jmp .l5b

.l6y ;lda .vl  ;v >= 0
    ;sec
    sbc .xy  ;v -= xy
    sta .vl
    bcs *+4
    dec .vh
    ldx #1  ;x++
    jsr fmplot
    jmp .l5b
.bend

