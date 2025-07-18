;for vasm assembler, oldstyle syntax

     macro sprite
\1
xsize_\1     byte \2
ysize_\1     byte \3
xpos_\1    byte \4
ypos_\1    byte \5    ;after xpos!
dptr_\1    word data_\1
cptr_\1    word color_\1
     endm

sxsize_off = 0
sysize_off = 1
sxpos_off = 2
sypos_off = 3
sdptr_off = 4
scptr_off = 6

   jsr getkey
    ldy #<s1
    sty $e6
    ldy #>s1
    sty $e7
   ;jsr put0
    ldy #<s6
    sty $e6
    ldy #>s6
    sty $e7

   jsr put0
l0
    jsr getkey
    cmp #$50  ;curd
    bne l1

    jsr down
    jmp l0
l1  cmp #$53  ;curd
    bne l2
    
    jsr up
    jmp l0
l2  cmp #$60  ;curl
    bne l3
    
    jsr left
    jmp l0
l3  cmp #$63  ;curr
    bne l4
    
    jsr  right
    jmp l0
l4  cmp #$70   ;1
    bne l5

    lda #2
    sta $d4
    jsr up
    jmp l0
l5  cmp #$73   ;2
    bne l6

    lda #-2
    sta $d4
    jsr down
    jmp l0
l6  cmp #$21   ;R
    bne l7

    jsr remove
    jmp l0

l7  cmp #$51   ;P
    bne *-5
    
    jsr put00
    jmp l0

   ;jsr remove
   ;jsr right
   ;ldy #sxpos_off
   ;lda ($e6),y
   ;clc
   ;adc #$fe
   ;sta ($e6),y
   lda #5
   jsr delay
    jsr getkey
  jmp l0
  if 0
l0 lda #200
l1 pha
    ;jsr getkey
   ;lda #5
   ;jsr delay
    ldy #<s1
    sty $e6
    ldy #>s1
    sty $e7
   jsr left
   ;jsr down
       ldy #<s3
    sty $e6
    ldy #>s3
    sty $e7
   jsr left
   ;jsr up
   pla
   clc
   adc #-1
   bne l1

   lda #200
l2 pha
    ldy #<s1
    sty $e6
    ldy #>s1
    sty $e7
   jsr left
   ;jsr up
       ldy #<s3
    sty $e6
    ldy #>s3
    sty $e7
   jsr right
   ;jsr down
   pla
   clc
   adc #-1
   bne l2
   jmp l0
  endif

gm byte 0
getkey:
    lda #$7f
.l0 tax
    stx $fd30
    stx $ff08
    ldx $ff08
    cpx #$ff
    bne .l1

    ror  ;C=1
    bcs .l0
    bcc getkey
.l1
    ldy #$ff
    lsr
    iny
    bcs *-2

    txa
    ldx #$ff
    lsr
    inx
    bcs *-2

    stx gm
    tya
    asl
    asl
    asl
    asl
    ora gm
    sta gm
    rts

ymul:   ;y*xsize/4  ;in: y, a;  used: $d6;  xsize = 8, 12, 16, 20, 24
        ;it sets $d6==AC sometimes
    cpy #16
    bne .l1

    asl
    asl   ;y*4
    rts
.l1
    cpy #12
    bne .l2

    sta $d6
    asl
    adc $d6  ;C=0, y*3
    rts
.l2
    cpy #8
    bne .l3

    asl   ;y*2
    rts
.l3
    cpy #20
    bne .l4

    sta $d6
    asl
    asl
    adc $d6   ;C=0, y*5
.l4 rts  ;y == 4

    org $a000
put00_hs byte 1
put0:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5       ;put00 must be the next

put00:   ;use: $d0-$d3, $d6, $d7, $d9, $da
         ;in: ac - mc output st, $e6,$e7 - sprite addr
d = $d7
    sta put00_hs

    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    sta .m2+1
    sta .m1+1

    lda #0
.l1  ;for (int y = 0; y < ysize; y++)
    pha
    tax

    ldy #sypos_off
    clc
    adc ($e6),y  ;ypos
    sta $d3    ;y+ypos

    ldy put00_hs
    beq .l2

    ldy #scptr_off
    lda ($e6),y
    sta $d0
    iny
    lda ($e6),y
    sta $d1
    txa
    tay
    lda ($d0),y
    sta $d9
    txa
    ldy #sysize_off
    adc ($e6),y  ;C=0
    tay
    lda ($d0),y
    sta $da

    ldy $d3
    jsr setmcl
.l2 ldy #sxpos_off
    lda ($e6),y  ;xpos
    tax
    ldy $d3
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + y)
    ldy #sxsize_off
    lda ($e6),y
    tay
    pla   ;y
    pha
    jsr ymul
    sta $d2
    tay
    lda ($e4),y
    sta d   ;d = data[0][y];
    txa
    and #3
    bne *+5  ;if (z)
    jmp .l3

    sta $d9  ;z = xpos&3
    asl
    sta $da  ;2z
    tax
    lda d
    lsr
    dex
    bne *-2

    tax   ;d >> 2*z
    lda tab1,x  ;tab1[d >> 2*z]
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[d >> 2*z]

    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l8 lda $d6 
.m2 cmp #0
    beq .l7

    asl
    asl
    ldy #sxpos_off
    adc ($e6),y  ;C=0
    and #$fc
    tax
    ldy $d3
    jsr getnextx   ;addr = getnextxaddr(addr, (xpos&0xfc) + 4*x, ypos + y)

    lda #8
    sec
    sbc $da
    tax
    lda d
    asl
    dex
    bne *-2
    sta d  ;d << 8 - 2*z

    clc
    lda $d2
    adc $d6   ;C=0
    tay
    lda ($e4),y
    tay      ;nd = data[x][y]
    ldx $da  ;2z
    lsr
    dex
    bne *-2    ;nd >> 2*z

    ora d
    sty d     ;d = nd
    tax
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[(unsigned char)(d << 8 - 2*z | nd >> 2*z)]

    inc $d6  ;x
    bne .l8   ;always
.l7
    ;lda $d6
    asl
    asl
    ldy #sxpos_off
    adc ($e6),y  ;C=0
    and #$fc
    tax
    ldy $d3
    jsr getnextx  ;addr = getnextxaddr(addr, (xpos&0xfc) + 4*x, ypos + y)

    lda #8
    sec
    sbc $da
    tax
    lda d
    asl
    dex
    bne *-2

    tax
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[(unsigned char)(d << 8 - 2*z)]
    beq .l6  ;always
.l3
    ldx d
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[d]


    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l5 lda $d6 
.m1 cmp #0
    beq .l6

    asl
    asl
    ldy #sxpos_off
    adc ($e6),y  ;C=0
    tax
    ldy $d3
    jsr getnextx   ;addr = getnextxaddr(addr, xpos + 4*x, ypos + y)

    lda $d6  ;x
    clc
    adc $d2  ;xsize/4*y
    tay
    lda ($e4),y
    tax      ;nd = data[x][y]
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]

    inc $d6  ;x
    bne .l5   ;always

.l6 pla
    clc
    adc #1
    ldy #sysize_off
    cmp ($e6),y
    beq *+5
    jmp .l1
    rts

remove:   ;use:$d0-d3, $d6
    ldy #sxpos_off
    lda ($e6),y
    tax
    and #$fc  ;p = xpos&0xfc
    sta $d3

    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    tay
    txa
    and #3
    beq *+3
    iny
    sty .m1+1  ;l = xsize/4 + ((xpos&3) != 0)

    lda #0  ;for (int y = 0; y < ysize; y++)
.l0 pha
    ldy #sypos_off
    adc ($e6),y  ;C=0
    sta $d2  ;ypos + y
    tay
    ldx $d3
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + y)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    lda #1  ;for (int x = 1; x < l; x++)
    sta $d6
.l2 lda $d6
.m1 cmp #0
    beq .l7

    lda $d6
    asl
    asl  ;*4
    adc $d3  ;C=0
    tax
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, p + 4*x, ypos + y)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    inc $d6
    bne .l2   ;always

.l7 pla
    adc #0  ;C=1
    ldy #sysize_off
    cmp ($e6),y
    bne .l0   ;sets C=0 if the branch is taken
    rts

right0:   ;use: $d0-d2,$d6
    sta $d2
    adc #1   ;C=0
    ;ldy #sxpos_off
    sta ($e6),y
    and #3
    bne .l0
    
    ldx $d2
    ldy #sypos_off
    lda ($e6),y
    tay
    jsr getpaddr  ;addr = getcsaddr(xpos - 1, ypos)
    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    ldy #sysize_off
    lda ($e6),y
    sta .m1+1
    lda #1    ;for (int y = 1; y < ysize; y++)
    sta $d6
.l5 lda $d6
.m1 cmp #0
    beq .l0
 
    ;lda $d6
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l2

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos - 2, ypos + 2*y)
    jmp .l3

.l2 inc $d0
    bne *+4
    inc $d1  ;addr += 2
.l3
    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    inc $d6
    bne .l5  ;always
.l0 rts

right:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sxsize_off
    lda ($e6),y
    sec
    sbc #HSIZE
    ldy #sxpos_off
    adc ($e6),y  ;C=0, xpos == 160-2*xsize
    beq right0.l0

    lda ($e6),y
    jsr right0
    lda #0
    jmp put00

  if 0
rightx:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sxpos_off
    lda ($e6),y
    sta $d6
    ldy #sxsize_off
    lda ($e6),y
    asl
    sbc #HSIZE-1  ;C=0
    adc $d6    ;C=0, 160-2*xsize
    beq .l0

    jsr remove
    ldy #sxpos_off
    lda ($e6),y
    clc
    adc #4
    sta ($e6),y
    lda #0
    jmp put00
.l0  rts   ;an excess!!
  endif

up0:  ;use:  $d0-d3, $d6, $d7
    clc
    adc #-1
    ;ldy #sypos_off
    sta ($e6),y   ;ypos--
    ldy #sysize_off
    clc
    adc ($e6),y
    sta $d2     ;ypos + ysize

    ldy #sxpos_off
    lda ($e6),y
    tax
    and #$fc
    sta $d3    ;p = xpos & 0xfc
    txa
    and #3
    sta $d7    ;xpos&3
    ldy $d2
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + ysize)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    ldx $d7
    beq *+4
    adc #1  ;C=0
    sta $d7  ;l = xsize/4 + ((xpos&3) != 0)

    lda #1    ;for (int x = 1; x < l; x++)
    sta $d6
.l5 lda $d6
    cmp $d7
    beq .l0

    ;lda $d6
    asl
    asl
    adc $d3  ;C=0
    tax
    ldy $d2
    jsr getpaddr  ;addr = getnextxaddr(addr, p + 4*x, ypos + ysize)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5 
    inc $d6
    bne .l5  ;always
.l0 rts

up:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sypos_off
    lda ($e6),y
    beq up0.l0

    jsr up0
    lda #1
    jmp put00

down0:  ;use: $d0-d3, $d6, $d7
    sta $d2
    ;clc
    adc #1  ;C=0
    ;ldy #sypos_off
    sta ($e6),y   ;ypos++
    ldy #sxpos_off
    lda ($e6),y
    tax
    and #$fc
    sta $d3    ;p = xpos & 0xfc
    txa
    and #3
    sta $d7    ;xpos&3
    ldy $d2
    jsr getpaddr  ;getcsaddr(xpos, ypos)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    ldx $d7
    beq *+4
    adc #1  ;C=0
    sta $d7  ;l = xsize/4 + ((xpos&3) != 0)

    lda #1    ;for (int x = 1; x < l; x++)
    sta $d6
.l5 lda $d6
    cmp $d7
    beq up0.l0

    ;lda $d6
    asl
    asl
    adc $d3  ;C=0
    tax
    ldy $d2
    jsr getpaddr  ;addr = getnextxaddr(addr, p + 4*x, ypos)

    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5 

    inc $d6
    bne .l5  ;always

down:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sysize_off
    lda ($e6),y
    clc
    sbc #VSIZE-1
    ldy #sypos_off
    adc ($e6),y     ;C=0
    beq up0.l0

    lda ($e6),y
    jsr down0
    lda #1
    jmp put00

left0:   ;use: $d0-$d3, $d6
    sec
    sbc #1
    ;ldy #sxpos_off
    sta ($e6),y   ;xpos--
    and #3
    bne .l0

    lda ($e6),y
    ldy #sxsize_off
    clc
    adc ($e6),y
    sta $d2     ;xpos + xsize
    tax
    ldy #sypos_off
    lda ($e6),y
    tay
    jsr getpaddr  ;addr = getcsaddr(xpos + xsize, ypos)
    ldy #0
    lda #$a5
    sta ($d0),y  ;prg[addr] = 0xa5

    ldy #sysize_off
    lda ($e6),y
    sta .m1+1
    lda #1    ;for (int y = 1; y < ysize; y++)
    sta $d6
.l5 lda $d6
.m1 cmp #0
    beq .l0

    ;lda $d6
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l2

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos + xsize, ypos + y)
    jmp .l3

.l2 inc $d0
    bne *+4
    inc $d1  ;addr++
.l3
    lda #$a5
    ldy #0
    sta ($d0),y  ;prg[addr] = 0xa5

    inc $d6
    bne .l5   ;always
.l0 rts

left:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sxpos_off
    lda ($e6),y
    beq left0.l0

    jsr left0
    lda #0
    jmp put00


    sprite s1,16,16,64,202
data_s1 
  byte $0f, $ff, $ff, $f0
  byte $ff, $ff, $ff, $ff
  byte $ff, $00, $00, $ff
  byte $50, $00, $00, $05
  byte $50, $aa, $aa, $05
  byte $50, $aa, $aa, $05
  byte $50, $af, $fa, $05
  byte $50, $af, $fa, $05
  byte $50, $af, $fa, $05
  byte $50, $af, $fa, $05
  byte $50, $aa, $aa, $05
  byte $50, $aa, $aa, $05
  byte $50, $00, $00, $05
  byte $ff, $00, $00, $ff
  byte $ff, $ff, $ff, $ff
  byte $0f, $ff, $ff, $f0
color_s1
  byte $00, $00, $00, $00, $00, $00, $53, $63, $63, $53, $00, $00, $00, $00, $00, $00
  byte $7e, $6e, $5e, $4e, $3e, $2e, $5d, $4d, $4d, $5d, $2e, $3e, $4e, $5e, $6e, $7e

    sprite s2,12,16,100,190
data_s2
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $00, $aa
  byte $aa, $00, $aa
  byte $aa, $ff, $aa
  byte $aa, $ff, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
  byte $aa, $aa, $aa
color_s2
  byte $00, $00, $00, $00, $00, $00, $52, $63, $63, $52, $00, $00, $00, $00, $00, $00
  byte $7e, $6e, $5e, $4e, $3e, $2e, $5d, $4d, $4d, $5d, $2e, $3e, $4e, $5e, $6e, $7e

    sprite s3,8,2,81,198
data_s3
  byte $66,$66
  byte $99,$99
color_s3
  byte $7e, $6e
  byte $53, $42

    sprite s4,4,2,42,8
data_s4
  byte $66
  byte $99
color_s4
  byte $7e, $6e
  byte $53, $42

    sprite s5,4,1,42,8
data_s5
  byte $66
color_s5
  byte $7e
  byte $53

    sprite s6,16,18,64,202
data_s6_1
  byte $00,$05,$50,$00
  byte $00,$55,$55,$00
  byte $01,$55,$55,$40
  byte $01,$55,$55,$40
  byte $05,$95,$55,$50
  byte $0a,$a9,$55,$a0
  byte $0a,$aa,$aa,$a0
  byte $02,$a6,$9a,$80
  byte $00,$a6,$9a,$00
  byte $02,$6a,$a9,$80
  byte $0a,$5a,$a5,$a0
  byte $2a,$55,$55,$a8
  byte $2a,$55,$55,$a8
  byte $0a,$95,$56,$a0
  byte $02,$aa,$aa,$80
  byte $02,$a8,$2a,$80
  byte $02,$a8,$2a,$80
  byte $00,$54,$15,$00
color_s6_1
  byte $68,$68,$68,$68,$68,$68,$68,$6d,$6d,$5b,$5b,$5b,$5b,$5b,$00,$00,$00,$00
  byte $00,$00,$00,$00,$72,$72,$72,$72,$72,$72,$72,$72,$72,$46,$46,$46,$48,$21
data_s6
  byte $00,$05,$50,$00
  byte $00,$55,$55,$00
  byte $01,$55,$55,$40
  byte $01,$55,$55,$40
  byte $05,$95,$55,$50
  byte $0a,$a9,$55,$a0 ;
  byte $0a,$aa,$aa,$a0
  byte $02,$a6,$9a,$80 ;
  byte $00,$a6,$98,$28
  byte $0a,$2a,$a9,$a8 ;
  byte $0a,$95,$55,$80 ;
  byte $02,$a5,$55,$00
  byte $00,$15,$5a,$00
  byte $00,$15,$5a,$00
  byte $00,$55,$15,$00
  byte $00,$aa,$15,$00
  byte $00,$00,$2a,$00
  byte $00,$00,$2a,$00
color_s6
  byte $68,$68,$68,$68,$68,$68,$68,$6d,$6d,$5b,$5b,$5b,$5b,$5b,$00,$00,$00,$00
  byte $00,$00,$00,$00,$72,$72,$72,$72,$72,$72,$72,$72,$72,$46,$46,$46,$48,$21

tab1
  byte $a5, $a4, $a7, $a6, $a1, $a0, $a3, $a2, $ad, $ac, $af, $ae, $a9, $a8, $ab, $aa
  byte $85, $84, $87, $86, $81, $80, $83, $82, $8d, $8c, $8f, $8e, $89, $88, $8b, $8a
  byte $b5, $b4, $b7, $b6, $b1, $b0, $b3, $b2, $bd, $bc, $bf, $be, $b9, $b8, $bb, $ba
  byte $95, $94, $97, $96, $91, $90, $93, $92, $9d, $9c, $9f, $9e, $99, $98, $9b, $9a
  byte $25, $24, $27, $26, $21, $20, $23, $22, $2d, $2c, $2f, $2e, $29, $28, $2b, $2a
  byte $05, $04, $07, $06, $01, $00, $03, $02, $0d, $0c, $0f, $0e, $09, $08, $0b, $0a
  byte $35, $34, $37, $36, $31, $30, $33, $32, $3d, $3c, $3f, $3e, $39, $38, $3b, $3a
  byte $15, $14, $17, $16, $11, $10, $13, $12, $1d, $1c, $1f, $1e, $19, $18, $1b, $1a
  byte $e5, $e4, $e7, $e6, $e1, $e0, $e3, $e2, $ed, $ec, $ef, $ee, $e9, $e8, $eb, $ea
  byte $c5, $c4, $c7, $c6, $c1, $c0, $c3, $c2, $cd, $cc, $cf, $ce, $c9, $c8, $cb, $ca
  byte $f5, $f4, $f7, $f6, $f1, $f0, $f3, $f2, $fd, $fc, $ff, $fe, $f9, $f8, $fb, $fa
  byte $d5, $d4, $d7, $d6, $d1, $d0, $d3, $d2, $dd, $dc, $df, $de, $d9, $d8, $db, $da
  byte $65, $64, $67, $66, $61, $60, $63, $62, $6d, $6c, $6f, $6e, $69, $68, $6b, $6a
  byte $45, $44, $47, $46, $41, $40, $43, $42, $4d, $4c, $4f, $4e, $49, $48, $4b, $4a
  byte $75, $74, $77, $76, $71, $70, $73, $72, $7d, $7c, $7f, $7e, $79, $78, $7b, $7a
  byte $55, $54, $57, $56, $51, $50, $53, $52, $5d, $5c, $5f, $5e, $59, $58, $5b, $5a

