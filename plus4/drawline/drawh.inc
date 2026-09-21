;vasm6502-oldstyle assembler
;thanks to Crown and MMS for hints
;r0,r4h,r6l,r7,rah,rb - free

ROM8table = 0   ;0 - RAM, ROM address ($C289, $DF7A)  saves 8 bytes
noattr = 0

drawhline ;in: x0 - r8, y0 - r1h, x1 - r2, y1 - r6h, cs = rch (0 - bg, 1 - fg)
          ;use: r1, r2, r3*, r4l, r5*, r6, r8, r9*, ra*, rc (rcl*)
.x0l = r8l
.x0h = r8h
.y0 = r1h
.x1l = r2l
.x1h = r2h
.y1 = r6h
.xyl = r4l
;.xyh = m
.vl = r8l
.vh = r8h
.dy = r6h
.dxl = r2l
.dxh = r2h
.cntl = r1l
.cnth = r1h
.p = r5l
.m8 = rcl
.c8 = rch
    lda #<.l5
    sta .m3
    lda .x0h
    cmp .x1h
    bcc .l1  ;x0 < x1
    bne .l12 ;x0 >= x1

    lda .x0l
    cmp .x1l
    bcc .l1

.l12 lda .x0l  ;x0 >= x1
    ldx .x1l  ;swap(x0, x1), swap(y0, y1)
    stx .x0l
    sta .x1l
    lda .x0h
    ldx .x1h
    stx .x0h
    sta .x1h
    lda .y0
    ldx .y1
    stx .y0
    sta .y1

.l1 lda .x1l
    sec
    sbc .x0l
    sta .dxl
    sta .cntl
    lda .x1h
    sbc .x0h  ;x1 - x0
    sta .dxh

    jsr ghplot  ;plot(x, y, c), sets Y
    lda .y1
    sec
    sbc .y0
    bcc .l2  ;y1 < y0

.l7 sta .dy  ;y1 >= y0
    ldx .dxh
    bne .l3  ;dx > dy

    cmp .dxl
    bcs .l4  ;dx <= dy

.l3 lda .dxl  ;dy < dx
    sec  ;xy = dx - dy
    sbc .dy
    sta .xyl
    lda .dxh
    sta .cnth
    sbc #0
    sta .xyh
    lda .dxh  ;d = dy - dx/2
    lsr
    lda .dxl
    ror
    sta .m1
    lda .dy
    sec
.m1 = * + 1
    sbc #0
    sta .vl
    lda #0
    sbc #0
    sta .vh
    lda #<.l5a
    sta .lb+1
    lda #0
    sbc .cntl  ;C=1
    sta .cntl

  assert >.l5a == >.l5b, WRONG_ALIGNMENT
    ;lda #>.l5a
    ;sta .lb+2
.l5a inc .cntl
    bne *+6
    dec .cnth
    bmi .e1  ;erts

    ;x++
    lda .vh
    bpl .l6x

    lda .vl  ;d < 0
    clc  ;v += dy
    adc .dy
    sta .vl
    bcc * + 4
    inc .vh
    ;jsr fhplot  ;x
    sec
    ror .m8
    bcs .lxa

    jsr .px
    bne * + 6  ;.ly7
    inc r3h
    inc r9h
    jmp .ly7

.lxa lsr .c8
    jmp .ly7

.l2 eor #$ff  ;y1 < y0
    adc #1  ;C=0
    ldx #<.l0
    stx .m3
    jmp .l7

.l6x lda .vl  ;v >= 0
    sec   ;v -= xy
    sbc .xyl
    sta .vl
    lda .vh
.xyh = * + 1
    sbc #0
    sta .vh
    jmp .lyx

.l4  ;lda .dy  ;dy >= dx
    sta .cntl
    ;sec  ;xy = dy - dx
    sbc .dxl  ;C=1
    sta .xyl

    lda .dy  ;v = dx - dy/2
    lsr
    sta .m4
    lda .dxl
    sec
.m4 = * + 1
    sbc #0
    sta .vl
    lda #0
    sbc #0
    sta .vh
    inc .cntl
    lda #<.l5b
    sta .lb+1
    ;lda #>.l5b
    ;sta .lb+2
.l5b dec .cntl
    bne *+3
.e1  rts

    lda .vl
    ldx #0
    cpx .vh
    bcs .l6y

    ;lda .vl  ;v < 0
    ;clc  ;v += dy
    adc .dxl  ;C=0
    sta .vl
    bcc .ly3

    inc .vh
    jmp .ly3

.l6y ;lda .vl  ;v >= 0
    ;sec  ;C=1
    sbc .xyl  ;v -= xy
    sta .vl
    bcs *+5
    dec .vh
    ;x++
.lyx sec
    ror .m8
    bcs .la

    jsr .px
    bne .ly3

    inc r3h
    inc r9h
    bne .ly3  ;always

.la lsr .c8
.ly3
.m3 = * + 1
    jmp .l0

   assert >.l0 == >.l5,BAD_ALIGNMENT
.l0 dey
    bpl .ly7

    ldy #7
    sec
    lda .p
    sbc #<320
    sta .p
    lda .p+1
    sta .tr
    sbc #>320  ;sets C=1
    sta .p+1
    lda ral
    sbc #40
    sta ral
    bcs .ly7

    dec r3h
    dec r9h
.ly7 lda (.p),y
    and .m8
    ora .c8
    sta (.p),y
.tr = * + 1
    lda #0
    beq .lb

    sty .ys
    jsr tplot
.ys = * + 1
    ldy #0
    lda #0
    sta .tr
.lb jmp .l5a

.l5 iny
    cpy #8
    bne .ly7

    ldy #0
    lda .p
    ;clc
    adc #<319  ;C=1
    sta .p
    lda .p+1
    sta .tr
    adc #>320
    sta .p+1
    lda ral
    adc #40  ;C=0
    sta ral
    bcc .ly7

    inc r3h
    inc r9h
    bne .ly7  ;always

.px lda .p
    adc #8  ;C=0
    sta .p
    bcc *+4
    inc .p+1
    lsr .c8
    ror .c8
    lda #$7f
    sta .tr
    sta .m8
    inc ral
    rts

   if ROM8table = 0
pow2 byte 128,64,32,16,8,4,2,1
   endif
   if ROM8table != 0
pow2 = ROM8table
   endif
pow2i byte 127,191,223,239,247,251,253,254

ghplot ;in x - r8, y - r1h, cs = rch (0 - bg, 1 - fg), rcl, r5l;  out: YR;  use r5
   ;40*(y & $f8) + (y&7) + (x & f8)
.x0l = r8l
.x0h = r8h
.y0 = r1h
.p = r5l
.m8 = rcl
.c8 = rch
    jsr ctplot
    lda .y0
    and #7
    tay
    lda .p
    lsr
    lsr
    lsr
    adc .x0h  ;C=0
    sta .p+1
    lda #gbase/8
     asl .p
     rol
     asl .p
     rol
     asl .p
     rol
     adc .p+1  ;C=0
     sta .p+1
     lda .x0l
     and #$f8
     adc .p
     sta .p
     bcc *+4
     inc .p+1

    lda .x0l
    and #7
    tax
    lda .c8
    beq .l1

    lda pow2,x
    sta .c8
.l1 lda pow2i,x
    sta .m8
    and (.p),y
    ora .c8
    sta (.p),y
.erts rts

ctplot  ;in: x - r8, y - r1h;  out: r3h, r5l, r9h, ral
;5*(y & $f8) + (x >> 3)
.x0l = r8l
.x0h = r8h
.y0 = r1h
.p = r5l
.c8 = rch
    lda .x0h
    lsr
    lda .x0l
    ror
    lsr
    lsr
    sta ral
    lda #gabase/4
    sta r3h
    lda .y0
    and #$f8
    sta .p
    asl
    rol r3h
    asl
    rol r3h  ;sets C=0
    adc .p  ;C=0
    bcc *+5
    inc r3h
    clc
    adc ral  ;sets C=0
    sta ral
    lda r3h
    adc #4   ;C=0, sets C=0
    sta r9h

    lda #$f0
    ldy #$f
    ldx .c8
    beq .bg

    sta tplot.ma1
    sty tplot.ma2
    lda $86
    lsr
    lsr
    lsr
    lsr
    sta tplot.a1
    lda $86
    asl
    asl
    asl
    asl
    jmp .l1
.bg
    sta tplot.ma2
    sty tplot.ma1
    lda $ff15
    and #$70
    sta tplot.a1
    lda $ff15
    and #$f
.l1
    sta tplot.a2

tplot
    ldy ral
    lda (r3l),y
.ma1 = * + 1
    and #0
.a1 = * + 1
    ora #0
    sta (r3l),y
    lda (r9l),y
.ma2 = * + 1
    and #0
.a2 = * + 1
    ora #0
    sta (r9l),y
    rts

