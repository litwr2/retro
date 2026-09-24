;vasm6502-oldstyle assembler
;thanks to Crown and MMS for hints
;r1l,r2h,r4h,r7,rah,rb - free

;ROM4table = 0  ;0 - RAM, ROM address ($D202, $D21A, $D221, $D228, $D233, $D294, $D37D, $D602, $D77D, $FD58, $FE98) saves 4 bytes if usemcattr==1
;usemcattr = 1
;mccoorcheck = 1

pow2m byte 0,64,128,192,0,16,32,48,0,4,8,12,0,1,2,3
pow2im byte $3f,$cf,$f3,$fc
  if usemcattr
  if ROM4table == 0
c8st byte 0,255,255,0
  endif
  if ROM4table != 0
c8st = ROM4table
  endif
  endif

drawmline ;in: x0 - r8l, y0 - r1h, x1 - r2l, y1 - r6h, cs = rch (0 - bg, 1 - fg)
          ;use: r2l, r3*, r4l, r5*, r6, r8 (r8h*), r9*, ra*, rc
.x0 = r8l
.y0 = r1h
.x1 = r2l
.y1 = r6h
.xy = r4l
.vl = r0l
.vh = r0h
.dy = r6l
.dx = r8h
;.cnt = r1l
.p = r5l
.m8 = rcl
.c8 = rch
    lda #<.l5
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

.l1 lda .x1
    sec
    sbc .x0
    sta .dx  ;x1 - x0
    sta .cnt

    jsr gmplot  ;plot(x, y, c), sets YR
    lda .y1
    sec
    sbc .y0
    bcs .l7  ;y1 < y0

    eor #$ff  ;y1 < y0
    adc #1  ;C=0
    ldx #<.l0
    stx .m3
.l7 sta .dy  ;y1 >= y0
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

    lda #<.l5a
    sta .lb+1
    ;lda #>.l5a
    ;sta .lb+2
.cnt = * + 1
    ldx #0
    inx
  if mccoorcheck
    lda #199
    cmp .x1
    bcs .l5a

    lda #201
    sbc .x0  ;C=0
    tax
  endif

  assert >.l5a == >.l5b, WRONG_ALIGNMENT
.l5a dex
    beq .e1  ;erts

    ;x++
    lda #0
    cmp .vh
    lda .vl
    bcs .l6x

    ;lda .vl  ;d < 0
    ;clc  ;v += dy
    adc .dy
    sta .vl
    bcc *+4
    inc .vh
    sec
    ror .m8
    bcs .lxa

    jsr .px
  if usemcattr
    bne *+6
    inc r3h
    inc r9h
  endif
    jmp .ly7

.lxa ror .m8  ;C=1
    lsr .c8
    lsr .c8
    jmp .ly7

.l6x ;lda .vl  ;v >= 0
    ;sec   ;v -= xy
    sbc .xy
    sta .vl
    bcs .lyx

    dec .vh
    jmp .lyx

.l4  ;lda .dy  ;dy >= dx
    tax
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

    lda #<.l5b
    sta .lb+1
    ;lda #>.l5b
    ;sta .lb+2

    inx
  if mccoorcheck
    lda #199
    cmp .y1
    bcs .l5b

    lda #201
    sbc .y0  ;C=0
    tax
  endif
.l5b dex
    bne *+3
.e1  rts

    lda #0
    cmp .vh
    lda .vl
    bcs .l6y

    ;lda .vl  ;v < 0
    ;clc  ;v += dy
    adc .dx  ;C=0
    sta .vl
    bcc .ly3

    inc .vh
    jmp .ly3

.l6y ;lda .vl  ;v >= 0
    ;sec  ;C=1
    sbc .xy  ;v -= xy
    sta .vl
    bcs *+5
    dec .vh

.lyx    sec
    ror .m8
    bcs .la

    jsr .px
  if usemcattr
    bne .ly3

    inc r3h
    inc r9h
    bne .ly3  ;always
  else
    jmp .ly3
  endif
.la  ror .m8  ;C=1
    lsr .c8
    lsr .c8
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
    sbc #>320  ;sets C=1
    sta .p+1
  if usemcattr
    sta .tr2
    lda ral
    sbc #40   ;C=1
    sta ral
    bcs .ly7

    dec r3h
    dec r9h
  endif
.ly7 lda (.p),y
    and .m8
    ora .c8
    sta (.p),y
  if usemcattr
.tr2 = * + 1
    lda #0
.tr1 = * + 1
    and #0
    beq .lb

    sty .ys
    jsr mtplot
.ys = * + 1
    ldy #0
    lda #0
    sta .tr2
  endif
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
    adc #>320
    sta .p+1
  if usemcattr
    sta .tr2
    lda ral
    adc #40  ;C=0
    sta ral
    bcc .ly7

    inc r3h
    inc r9h
  endif
    bne .ly7  ;always

.px lda .p
    adc #8  ;C=0
    sta .p
    bcc *+4
    inc .p+1
    lda .c8
    lsr
    ror
    ror
    sta .c8
    lda #$3f
    sta .m8
  if usemcattr
    sta .tr2
    inc ral
  endif
    rts

gmplot ;in x - r8l, y - r1h, cs - rch (0 - mc1, 1 - fg, 2 - bg, 3 - mc2);
       ;out: YR, r5l;  use: r5
       ;40*(y & $f8) + (y&7) + ((x << 1) & $f8)
.x0 = r8l
.y0 = r1h
.p = r5l
.m8 = rcl
.c8 = rch
    lda .y0
    and #$f8
    sta .p
  if usemcattr
    ldx .c8
    lda c8st,x
    sta drawmline.tr1
    beq *+5
    jsr mctplot
  endif
    lda .y0
    and #7
    tay
    lda .p
    lsr
    lsr
    lsr
    sta .p+1
    lda #gbase/8
     asl .p
     rol
     asl .p
     rol
     asl .p
     rol
     asl .x0  ;sets C
     adc .p+1
     sta .p+1
     lda .x0
     and #$f8
     adc .p  ;C=0
     sta .p
     bcc *+4
     inc .p+1

    lda .x0
    lsr .x0
    and #6
    asl
    ora .c8
    tax
    lda pow2m,x
    sta .c8
    lda .x0
    and #3
    tax
    lda pow2im,x
    sta .m8
    and (.p),y
    ora .c8
    sta (.p),y
    rts

  if usemcattr
mctplot  ;in: x - r8l, y - r1h, r5l;  out: r3h, r9h, ral
;5*(y & $f8) + (x >> 2)
.x0 = r8l
.y0 = r1h
.p = r5l
.c8 = rch
    lda .x0
    lsr
    lsr
    sta ral
    lda #gabase/4
    sta r3h
    lda .p
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

    ldx #$f0
    ldy #$f
    lda .c8
    and #$55
    beq .bg

    stx mtplot.ma1
    sty mtplot.ma2
    lda $86
    lsr
    lsr
    lsr
    lsr
    sta mtplot.a1
    lda $86
    asl
    asl
    asl
    asl
    jmp .l1
.bg
    stx mtplot.ma2
    sty mtplot.ma1
    lda $85
    and #$70
    sta mtplot.a1
    lda $85
    and #$f
.l1
    sta mtplot.a2

mtplot
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
  endif

