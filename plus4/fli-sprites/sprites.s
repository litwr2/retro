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
    ldy #<s2
    sty $e6
    ldy #>s2
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
    bne l0

    lda #-2
    sta $d4
    jsr down
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
    lda #0
.l1  ;for (int y = 0; y < ysize; y++)
    pha
    tax
    asl
    ldy #sypos_off
    adc ($e6),y  ;C=0, ypos
    sta $d3    ;y+ypos
    ldy put00_hs
    beq .l2

    pha   ;ypos+2y
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

    pla
    tay
    jsr setmcl
    ldy $d3
    iny
    jsr setmcl
.l2 ldy #sxpos_off
    lda ($e6),y  ;xpos
    tax
    ldy $d3
    jsr getpaddr  ;addr = getcsaddr2(xpos, ypos + y)
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
    and #2
    bne *+5  ;if (xpos&2)
    jmp .l3

    lda d
    rol
    rol
    rol
    and #3
    tax   ;nd  = d >> 6
    lda tab5t,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab5t[nd]
    lda tab5b,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab5b[nd]
    ldy #sxpos_off
    lda ($e6),y
    tax
    inx
    inx
    ldy $d3
    jsr getnextx
    lda d
    and #$3f
    lsr
    lsr
    tax           ;nd = (d & 0x3f) >> 2
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]
    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l8 ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    cmp $d6
    beq .l7
    
    lda d
    and #3
    lsr
    ror
    ror
    sta d
    lda $d6
    adc $d2  ;C=0
    tay
    lda ($e4),y
    pha
    lsr
    lsr
    ora d
    sta d  ;d = (d & 3) << 6 | data[x][y] >> 2

    lda $d6
    asl
    asl
    asl
    ldy #sxpos_off
    adc ($e6),y ;C=0
    adc #-2   ;C=0
    pha
    tax
    ldy $d3
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x - 2, ypos + 2*y)
    lda d
    lsr
    lsr
    lsr
    lsr
    tax  ;nd  = d >> 4
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

    pla
    clc
    adc #4
    tax
    ldy $d3
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x + 2, ypos + y)
    lda d
    and #$f
    tax   ;nd = d & 0xf
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

    pla
    sta $d7  ;d = data[x][y]

    inc $d6
    bne .l8  ;always
.l7
    clc
    lda #30
    ldy #sxpos_off
    adc ($e6),y
    tax
    ldy $d3
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 30, ypos + 2*y)

    lda d
    and #3
    tax    ;nd = d & 3
    lda tab3t,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab3t[nd]
    lda tab3b,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab3b[nd]
    jmp .l6
.l3
    lda d
    lsr
    lsr
    lsr
    lsr
    tax   ;nd  = d >> 4
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

    ldy #sxpos_off
    lda ($e6),y
    clc
    adc #4
    tax 
    ldy $d3
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 4, ypos + 2*y)

    lda d
    and #$f
    tax
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l5 ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    cmp $d6
    beq .l6

    lda $d6
    asl
    asl
    asl
    ldy #sxpos_off
    adc ($e6),y  ;C=0
    pha
    tax
    ldy $d3
    jsr getnextx   ;addr = getnextxaddr2(addr, xpos + 4*x, ypos + y)

    lda $d6  ;x
    clc
    adc $d2  ;4*y
    tay
    lda ($e4),y
    sta d  ;d = data[x][y]
    
    lsr
    lsr
    lsr
    lsr
    tax  ;nd  = d >> 4
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

    pla
    clc
    adc #4
    tax
    ldy $d3
    jsr getnextx   ;addr = getnextxaddr2(addr, xpos + 4*x + 2, ypos + y)

    lda d
    and #$f
    tax     ;nd = d & 0xf
    lda tab1,x
    ldy #0
    sta ($d0),y  ;prg[addr] = tab1[nd]
    lda tab2,x
    iny
    sta ($d0),y  ;prg[addr+1] = tab2[nd]

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
    lda #0  ;for (int y = 0; y < ysize; y++)
.l0 pha
    ldy #sxpos_off
    lda ($e6),y
    sta $d3
    tax
    iny  ;sypos_off
    pla
    pha
    asl
    adc ($e6),y  ;C=0
    sta $d2
    tay
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + 2*y)
    txa
    and #2
    bne *+5
    jmp .l1   ;long?

    ldy #0
    lda ($d0),y
    and #$f0
    ora #5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = prg[addr] & 0xf0 | 5

    ;ldx $d3
    inx
    inx
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 2, ypos + 2*y)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l2 ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    cmp $d6
    beq .l7

    lda $d6
    asl
    asl
    asl  ;*8
    adc $d3  ;C=0
    pha
    adc #-2  ;C=0
    tax
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x - 2, ypos + 2*y)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    pla
    tax
    inx
    inx
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x + 2, ypos + 2*y)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    inc $d6
    bne .l2   ;always
.l7
    lda $d3
    ;clc
    adc #29  ;C=1
    tax
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 30, ypos + 2*y);

    ldy #0
    lda ($d0),y
    and #$f
    ora #$a0
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = prg[addr] & 0xf | 0xa0;

.l6 pla
    clc
    adc #1
    ldy #sysize_off
    cmp ($e6),y
    beq *+5
    jmp .l0
    rts

.l1 ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    ;ldx $d3
    inx
    inx
    inx
    inx
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 4, ypos + 2*y)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    lda #1  ;for (int x = 1; x < xsize/4; x++)
    sta $d6
.l5 ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    cmp $d6
    beq .l6

    lda $d6
    asl
    asl
    asl
    adc $d3  ;C=0
    pha
    tax
    ldy $d2
    jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x, ypos + 2*y);

	ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    pla
    clc
    adc #4
    tax
    ldy $d2
	jsr getnextx  ;addr = getnextxaddr(addr, xpos + 8*x + 4, ypos + 2*y)

	ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    inc $d6
    bne .l5  ;always

right0:   ;use: $d0-d2,$d6
    sta $d2
    adc #2   ;C=0
    ;ldy #sxpos_off
    sta ($e6),y
    
    ldx $d2
    ldy #sypos_off
    lda ($e6),y
    tay
    jsr getpaddr  ;addr = getcsaddr(xpos - 2, ypos)
    ldy #sxpos_off
    lda ($e6),y
    and #2
    beq .l1

    ldy #0
    lda ($d0),y
    lsr
    lsr
    lsr
    lsr
    cmp #$a
    bne *+3
    lsr
    ora #$a0
    sta ($d0),y  ;prg[addr] = (d == 0xa ? 0x5 : d) | 0xa0; d = prg[addr] >> 4
    iny
    lda ($d0),y
    lsr
    lsr
    lsr
    lsr
    cmp #$a
    bne *+3
    lsr
    ora #$a0
    sta ($d0),y  ;prg[addr+1] = (d == 0xa ? 0x5 : d) | 0xa0; d = prg[addr+1] >> 4

    lda #1  ;for (int y = 1; y < ysize; y++)
    sta $d6
.l50 
    ldy #sysize_off
    lda ($e6),y
    cmp $d6
    beq .l70

    lda $d6
    asl
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l20

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos - 2, ypos + 2*y)
    jmp .l30

.l20 lda #2
    adc $d0  ;C=0
    sta $d0
    bcc *+4
    inc $d1  ;addr += 2
.l30
    ldy #0
    lda ($d0),y
    lsr
    lsr
    lsr
    lsr
    cmp #$a
    bne *+3
    lsr
    ora #$a0
    sta ($d0),y  ;prg[addr] = (d == 0xa ? 0x5 : d) | 0xa0; d = prg[addr] >> 4
    iny
    lda ($d0),y
    lsr
    lsr
    lsr
    lsr
    cmp #$a
    bne *+3
    lsr
    ora #$a0
    sta ($d0),y  ;prg[addr+1] = (d == 0xa ? 0x5 : d) | 0xa0; d = prg[addr+1] >> 4

    inc $d6
    bne .l50  ;always
.l70
    rts

.l1 ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5
    lda #1  ;for (int y = 1; y < ysize; y++)
    sta $d6
.l5 ldy #sysize_off
    lda ($e6),y
    cmp $d6
    beq .l70

    lda $d6
    asl
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l2

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos - 2, ypos + 2*y)
    jmp .l3

.l2 lda #2
    adc $d0  ;C=0
    sta $d0
    bcc *+4
    inc $d1  ;addr += 2
.l3
    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5 

    inc $d6
    bne .l5   ;always

right:
    ldy #sdptr_off
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    ldy #sxsize_off
    lda ($e6),y
    asl
    sbc #HSIZE-1  ;C=0
    ldy #sxpos_off
    adc ($e6),y  ;C=0, xpos == 160-2*xsize
    beq right0.l70

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
    adc #-2
    ;ldy #sypos_off
    sta ($e6),y
    ldy #sysize_off
    clc
    adc ($e6),y
    adc ($e6),y
    sta $d2

    ldy #sxpos_off
    lda ($e6),y
    tax
    and #$fc
    sta $d3    ;p = xpos & 0xfc
    txa
    and #2
    lsr
    sta $d7    ;((xpos&2)>>1)
    ldy $d2
    jsr getpaddr  ;addr = getcsaddr(xpos, ypos + 2*ysize)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    ldy #sxsize_off
    lda ($e6),y
    lsr
    adc $d7  ;C=0
    sta $d7  ;xsize/2 + ((xpos&2)>>1)

    lda #1    ;for (int x = 1; x < xsize; x++)
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
    jsr getpaddr  ;addr = getnextxaddr(addr, p + 4*x, ypos + 2*ysize)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5 
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
    adc #2  ;C=0
    ;ldy #sypos_off
    sta ($e6),y
    ldy #sxpos_off
    lda ($e6),y
    tax
    and #$fc
    sta $d3    ;p = xpos & 0xfc
    txa
    and #2
    lsr
    sta $d7    ;((xpos&2)>>1)
    ldy $d2
    jsr getpaddr  ;getcsaddr(xpos, ypos)

    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5

    ldy #sxsize_off
    lda ($e6),y
    lsr
    adc $d7  ;C=0
    sta $d7  ;xsize/2 + ((xpos&2)>>1)

    lda #1    ;for (int x = 1; x < xsize/2 + ((xpos&2)>>1); x++)
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
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5 

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
    asl
    sbc #VSIZE-1    ;C=0
    ldy #sypos_off
    adc ($e6),y     ;C=0
    beq up0.l0

    lda ($e6),y
    jsr down0
    lda #1
    jmp put00

left0:   ;use: $d0-$d3, $d6
    clc
    adc #-2
    ;ldy #sxpos_off
    sta ($e6),y
    ldy #sxsize_off
    clc
    adc ($e6),y
    adc ($e6),y
    sta $d2
    tax
    ldy #sypos_off
    lda ($e6),y
    tay
    jsr getpaddr  ;addr = getcsaddr(xpos + 2*xsize, ypos)
    ldy #sxpos_off
    lda ($e6),y
    and #2
    beq .l1

    ldy #0
    lda ($d0),y
    asl
    asl
    asl
    asl
    cmp #$50
    bne *+3
    asl
    ora #5
    sta ($d0),y   ;prg[addr] = (d == 0x50 ? 0xa0 : d) | 5; d = prg[addr] << 4
    iny
    lda ($d0),y
    asl
    asl
    asl
    asl
    cmp #$50
    bne *+3
    asl
    ora #5
    sta ($d0),y  ;prg[addr+1] = (d == 0x50 ? 0xa0 : d) | 5; d = prg[addr+1] << 4

    lda #1    ;for (int y = 1; y < ysize; y++)
    sta $d6
.l50
    ldy #sysize_off
    lda ($e6),y
    cmp $d6
    beq .l0

    lda $d6
    asl
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l20

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos + 2*xsize, ypos + 2*y)
    jmp .l30

.l20 lda #2
    adc $d0  ;C=0
    sta $d0
    bcc *+4
    inc $d1  ;addr += 2
.l30
    ldy #0
    lda ($d0),y
    asl
    asl
    asl
    asl
    cmp #$50
    bne *+3
    asl
    ora #5
    sta ($d0),y  ;prg[addr] = (d == 0x50 ? 0xa0 : d) | 5; d = prg[addr] << 4
    iny
    lda ($d0),y
    asl
    asl
    asl
    asl
    cmp #$50
    bne *+3
    asl
    ora #5
    sta ($d0),y  ;prg[addr+1] = (d == 0x50 ? 0xa0 : d) | 5; d = prg[addr+1] << 4

    inc $d6
    bne .l50   ;always
.l0
    rts

.l1 ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5
    lda #1    ;for (int y = 1; y < ysize; y++)
    sta $d6
.l5 ldy #sysize_off
    lda ($e6),y
    cmp $d6
    beq .l0

    lda $d6
    asl
    ldy #sypos_off
    adc ($e6),y  ;C=0
    tay
    and #7
    bne .l2

    ldx $d2
    jsr getpaddr  ;addr = getcsaddr(xpos + 2*xsize, ypos + 2*y)
    jmp .l3

.l2 lda #2
    adc $d0  ;C=0
    sta $d0
    bcc *+4
    inc $d1  ;addr += 2
.l3
    ldy #0
    lda #$a5
    sta ($d0),y
    iny
    sta ($d0),y  ;prg[addr + 1] = prg[addr] = 0xa5 

    inc $d6
    bne .l5  ;always

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

    sprite s2,12,16,40,8
data_s2
  byte $00, $00, $00
  byte $00, $00, $00
  byte $00, $00, $00
  byte $00, $00, $00
  byte $00, $aa, $00
  byte $00, $00, $00
  byte $00, $00, $00
  byte $00, $00, $00
  byte $00, $ff, $00
  byte $00, $ff, $00
  byte $00, $00, $00
  byte $00, $aa, $00
  byte $f0, $00, $00
  byte $f0, $00, $00
  byte $f5, $55, $00
  byte $00, $ff, $00
color_s2
  byte $00, $00, $00, $00, $00, $00, $53, $63, $63, $53, $00, $00, $00, $00, $00, $00
  byte $7e, $6e, $5e, $4e, $3e, $2e, $5d, $4d, $4d, $5d, $2e, $3e, $4e, $5e, $6e, $7e

    sprite s3,8,2,42,8
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

tab1 byte $a5, $a0, $af, $a3, $5, 0, $f, $3, $f5, $f0, $ff, $f3, $35, $30, $3f, $33
tab2 byte $a5, $a0, $af, $ac, $5, 0, $f, $c, $f5, $f0, $ff, $fc, $c5, $c0, $cf, $cc
tab3t byte $a5, 5, $f5, $35
tab3b byte $a5, 5, $f5, $c5
tab5t byte $a5, $a0, $af, $a3
tab5b byte $a5, $a0, $af, $ac

