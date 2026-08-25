;tmpx assembler
;rb - free

fmplot ;in x - dx, y - dy; bit 7 - left, bit 0 - right
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
    lda c8
    asl
    rol
    rol
    sta c8
    lda ral
    bne *+6
    dec r3h
    dec r9h
    dec ral
    stx rah
    lda #$fc
    sta m8
    bne l3  ;always

l9  asl c8
    asl c8
    sec
    rol m8
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
    lda c8
    lsr
    ror
    ror
    sta c8
    lda #$3f
    sta m8
    inc ral
    bne l3

    inc r3h
    inc r9h
    bne l3  ;always

la  ror m8  ;C=1
    lsr c8
    lsr c8
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
    beq lb

    sty rah
    lda c8
    beq lb

    eor #$ff
    cmp m8
    beq lb

    jmp mtplot
lb  rts 

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

mctplot  ;in: x - r8l, y - r1h;  out: r3h, r9h, ral
.block
x0l = r8l
x0h = r8h
y0 = r1h
    lda x0l
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

mtplot  ;use: r0h
.block
c8 = rch
    ldy ral
    lda c8
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

pow2m .byte 0,64,128,192,0,16,32,48,0,4,8,12,0,1,2,3
pow2im .byte $3f,$cf,$f3,$fc

gmplot ;in x - r8l, y - r1h, cs - rch (0 - mc1, 1 - fg, 2 - bg, 3 - mc2) - must be the first!;  use r0l, r5, r8h
.block  ;40*(y & $f8) + (y&7) + ((x << 1) & $f8)
x0l = r8l
x0h = r8h
y0 = r1h
p = r5l
m8 = rcl
c8 = rch
yh = r6h
    beq l1

    cmp #3
    beq l1

    jsr mctplot
l1  lda #gbase/2
    sta x0h
    lda x0l
    asl
    sta m1
    rol x0h
    lda y0
    and #7
    sta m2
    lda y0
    sta yh
    and #$f8
    tay
    jsr mul40
m1 = * + 1
    adc #0   ;C=0
    and #$f8
m2 = * + 1
    ora #0
    sta r5l
    lda r5h
    adc x0h
    sta r5h

    lda m1
    and #6
    asl
    ora c8
    tax
    lda pow2m,x
    sta c8
    lda x0l
    and #3
    tax
    lda pow2im,x
    sta m8
    ldy #0
    and (r5l),y
    ora c8
    sta (r5l),y
.bend
ertsm rts

drawmline ;in x0 - r8l, y0 - r1h, x1 - r2l, y1 - r6h, cs = rch (0 - mc1, 1 - fg, 2 - bg, 3 - mc2)
          ;sx:sy - m:m; err - r4; e2 - r2h:r6l; dy:dx - r1l:r7l
.block   ;sy - zp!!
x0 = r8l
y0 = r1h
x1 = r2l
y1 = r6h
errl = r4l
errh = r4h
e2l = r6l
e2h = r2h
dy = r1l
dx = r7l
cnt = r2l
c8 = rch
    lda x0
    cmp x1
    bcc l1  ;x0 < x1

    ;lda x0l  ;x0 >= x1
    sbc x1  ;C=1
    ldx #$80
    bmi l3  ;always

l1  lda x1
    sec
    sbc x0
    ldx #1
l3  stx sx
    sta dx
    sta cnt

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

    lda dx   ;err = dx - dy
    sec
    sbc dy
    sta errl
    lda #0
    sbc #0
    sta errh

    lda dy  ;if (dx < dy) cnt = dy; else cnt = dx
    cmp dx
    bcc *+4
    sta cnt
    lda c8
    jsr gmplot
    inc cnt
l5
    dec cnt  ;if (cnt-- == 0) break
    beq ertsm

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
    lda dx
    cmp e2l
    lda #0
    sbc e2h
    bmi l14

    clc   ;e2 <= dx
    lda dx
    adc errl
    sta errl
    bcc *+4
    inc errh
sy = * + 1
    ldy #0
l14 jsr fmplot
    jmp l5
.bend

