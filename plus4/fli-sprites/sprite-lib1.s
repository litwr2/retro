;for vasm6502/oldstyle
;the next zp-locations are used: $e2-e7
;e6-e7 - addr of the sprite def
;e4-e5 - sprite bitmap addr
;e2-e3 - sprite color addr
;d0-d3, d5-d7, d9-da - temporary variables

    macro sprite_t1,id,xs,ys,xp,yp,nls,nrs,nus,nds
\id
xsize_\id     byte \xs
ysize_\id     byte \ys
xpos_\id    byte \xp
ypos_\id    byte \yp    ;after xpos!
nlrud_\id   byte \nls,\nrs,\nus,\nds   ;dataset limit
clrud_\id   byte 0,0,0,0   ;the current dataset
olrud_\id   byte \id\()_l_sl-\id,\id\()_r_sl-\id,\id\()_u_sl-\id,\id\()_d_sl-\id  ;base dataset offset
     endm

sxsize_off = 0
sysize_off = 1
sxpos_off = 2
sypos_off = 3
nlrud_off = 4
clrud_off = 8
olrud_off = 12

    macro setspr_t1
    ldy #clrud_off+\1
    lda ($e6),y
    tax
    asl
    asl

    ldy #olrud_off+\1
    adc ($e6),y  ;C=0
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    sty put_t1c+1

    inx
    txa
    ldy #nlrud_off+\1
    cmp ($e6),y
    bne *+4
    lda #0
    ldy #clrud_off+\1
    sta ($e6),y
    endm

    org $a000
put_t1c:   ;it may only be used after the invocation of put_t1 or setspr_t1
    ldy #0   ;this instruction must be the first!   
.e  iny
    lda ($e6),y
    sta $e2
    iny
    lda ($e6),y
    sta $e3

    ldy #sysize_off
    lda ($e6),y
    sta .m4+1

    ldy #0
.l1x  ;for (int y = 0; y < ysize; y++)
    sty $d5

    lda ($e2),y
    sta $d9
    tya
    clc
.m4 adc #0
    tay
    lda ($e2),y
    sta $da

    lda $d5
    ldy #sypos_off
    adc ($e6),y  ;C=0, ypos
    tay    ;y+ypos
    jsr setmcl

    ldy $d5
    iny
    cpy .m4+1
    bne .l1x
    rts

put_t1:
    ldy #clrud_off+ddir
    lda ($e6),y
    asl
    asl

    ldy #olrud_off+ddir
    adc ($e6),y  ;C=0
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    jsr put_t1c.e       ;put00_t1 must be the next

put00_t1:   ;use: $d0-$d3, $d6, $d7, $d9, $da
         ;in: ac - mc output st, $e6,$e7 - sprite addr
    ;lda $a5
    ;cmp $a5
    ;beq *-2

    ldy #sysize_off
    lda ($e6),y
    sta .m4+1

    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    sta .m1+1

    lda #0
    sta $d5
.l1  ;for (int y = 0; y < ysize; y++)
    sta .m2+1

    ldy #sypos_off
    clc
    adc ($e6),y  ;ypos
    sta $d3    ;y+ypos

    ldy #sxpos_off
    lda ($e6),y  ;xpos
    tax
    ldy $d3
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + y)

.m2 lda #0
    beq .l11

    lda .m1+1
    clc
    adc $d5
    sta $d5
.l11
    sta $d2
    tay
    lda ($e4),y
    sta $d7   ;d = data[0][y];
    txa
    and #3
    bne *+5  ;if (z)
    jmp .l3

    sta $d9  ;z = xpos&3
    asl
    sta $da  ;2z
    tax
    lda $d7
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
    cmp .m1+1
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
    lda $d7
    asl
    dex
    bne *-2
    sta $d7  ;d << 8 - 2*z

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

    ora $d7
    sty $d7    ;d = nd
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
    lda $d7
    asl
    dex
    bne *-2

    tax
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[(unsigned char)(d << 8 - 2*z)]
    beq .l6  ;always
.l3
    ldx $d7
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

.l6 ldy .m2+1
    iny
    tya
.m4 cmp #0
    beq *+5
    jmp .l1
    rts

remove_t1:   ;use:$d0-d3, $d6
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
.l0 sta .l7+1
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

.l7 lda #0
    adc #0  ;C=1
    ldy #sysize_off
    cmp ($e6),y
    bne .l0   ;sets C=0 if the branch is taken
    rts

right0_t1:   ;use: $d0-d2,$d6
    ldy #sxpos_off
    lda ($e6),y
    sta $d2
    clc
    adc #1
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

right_t1:
    ldy #sxsize_off
    lda ($e6),y
    sec
    sbc #HSIZE
    ldy #sxpos_off
    adc ($e6),y  ;C=0, xpos == 160-xsize
    bne *+3
    rts

    setspr_t1 rdir
    jsr right0_t1
    jsr put_t1c
    jmp put00_t1

right2_t1:
    ldy #sxsize_off
    lda ($e6),y
    sec
    sbc #HSIZE-1
    ldy #sxpos_off
    adc ($e6),y  ;C=0, xpos + xpos < HSIZE - 1
    bcc *+3
    rts

    setspr_t1 rdir
    jsr right0_t1
    jsr right0_t1
    jsr put_t1c
    jmp put00_t1

  if 0
rightx_t1:
    ;ldy #sdptr_off
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

    jsr remove_t1
    ldy #sxpos_off
    lda ($e6),y
    clc
    adc #4
    sta ($e6),y
    jmp put00_t1
.l0  rts   ;an excess!!
  endif

up0_t1:  ;use:  $d0-d3, $d6, $d7
    ldy #sypos_off
    lda ($e6),y
    clc
    adc #-1
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

down0_t1:  ;use: $d0-d3, $d6, $d7
    ldy #sypos_off
    lda ($e6),y
    sta $d2
    clc
    adc #1
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
    beq up0_t1.l0

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

down_t1:
    ldy #sysize_off
    lda ($e6),y
    clc
    sbc #VSIZE-1
    ldy #sypos_off
    adc ($e6),y     ;C=0
    bne *+3
    rts

    setspr_t1 ddir
    jsr down0_t1
    jsr put_t1c
    jmp put00_t1

down2_t1:
    ldy #sysize_off
    lda ($e6),y
    sec
    sbc #VSIZE-1
    ldy #sypos_off
    adc ($e6),y  ;C=0, ypos + ypos < VSIZE - 1
    bcc *+3
    rts

    setspr_t1 ddir
    jsr down0_t1
    jsr down0_t1
    jsr put_t1c
    jmp put00_t1

left0_t1:   ;use: $d0-$d3, $d6
    ldy #sxpos_off
    lda ($e6),y
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

left_t1:
    ldy #sxpos_off
    lda ($e6),y
    bne *+3
    rts

    setspr_t1 ldir
    jsr left0_t1
    jsr put_t1c
    jmp put00_t1

left2_t1:
    ldy #sxpos_off
    lda ($e6),y
    cmp #2
    bcs *+3
    rts

    setspr_t1 ldir
    jsr left0_t1
    jsr left0_t1
    jsr put_t1c
    jmp put00_t1

up_t1:
    ldy #sypos_off
    lda ($e6),y
    bne *+3
    rts

    setspr_t1 udir
    jsr up0_t1
    jsr put_t1c
    jmp put00_t1

up2_t1:
    ldy #sypos_off
    lda ($e6),y
    cmp #2
    bcs *+3
    rts

    setspr_t1 udir
    jsr up0_t1
    jsr up0_t1
    jsr put_t1c
    jmp put00_t1

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

