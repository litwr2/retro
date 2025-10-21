;for vasm6502/oldstyle
;the next zp-locations are used:
;e6-e7 - addr of the sprite def
;e4-e5 - sprite data addr
;e2-e3 - sprite saved data addr
;66-6a, d0-d3, d5-d7, d9-de, e0-e1 - temporary variables
;6b - for RLE

RLE = 1   ;1 slightly slower but supports the RLE compression

    macro sprite_t2,id,xs,ys,xp,yp,nls,nrs,nus,nds
\id
xsize_\id     byte \xs
ysize_\id     byte \ys
xpos_\id    byte \xp
ypos_\id    byte \yp    ;after xpos!
xidx_\id    byte 0
yidx_\id    byte 0      ;after xidx
nlrud_\id   byte \nls,\nrs,\nus,\nds
clrud_\id   byte 0,0,0,0
olrud_\id   byte \id\()_l_sl-\id,\id\()_r_sl-\id,\id\()_u_sl-\id,\id\()_d_sl-\id
asaved_\id   word saved_\id
     endm

s2xsize_off = 0
s2ysize_off = 1
s2xpos_off = 2
s2ypos_off = 3
s2xidx_off = 4
s2yidx_off = 5
s2nlrud_off = 6
s2clrud_off = 10
s2olrud_off = 14
saved_off = 18

    macro setspr_t2
    ldy #s2clrud_off+\1
    lda ($e6),y
    tax
    asl

    ldy #s2olrud_off+\1
    ;clc   ;required if n>=128
    adc ($e6),y
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    inx
    txa
    ldy #s2nlrud_off+\1
    cmp ($e6),y
    bne *+4
    lda #0
    ldy #s2clrud_off+\1
    sta ($e6),y
    
    setspr3_t2
    endm

    macro setspr3_t2
    ldy #saved_off
    lda ($e6),y
    sta $e2
    iny
    lda ($e6),y
    sta $e3
    endm

     macro rle_init
     lda $e4
     sta $dd
     lda $e5
     sta $de   ;addr
   if RLE
     lda #0
     sta $6b   ;count
   endif
     endm

     macro rle_get   ;sets Y=0
     ldy #0
  if RLE
     lda $6b
     beq .l1\@

     lda ($dd),y
     sta \1
     dec $6b
     bpl .l3\@  ;always
.l1\@
     lda ($dd),y
     bmi .l2\@

     sta \1
     bpl .l4\@  ;always
.l2\@
     sec
     sbc #129
     sta $6b
     inc $dd
     bne *+4
     inc $de
     lda ($dd),y
     sta \1
     lda $6b
.l3\@
     bne .x\@
.l4\@
     inc $dd
     bne *+4
     inc $de
.x\@
   else
     lda ($dd),y
     sta \1
     inc $dd
     bne *+4
     inc $de
   endif
     endm

    ;org $a000
mul16:   ;in: A * $66 -> Y:X;  byte*byte -> word; used: $66-$68; sets C=0
    sta $67
    ldy #0
    sty $68
    ldx #0
.l2 lsr $66
    bcc .l1

    clc
    txa
    adc $67
    tax
    tya
    adc $68
    tay
.l1 asl $67
    rol $68
    lda $66
    bne .l2
.le rts

put_t2: ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-de, $e0-e5
    ldy #s2clrud_off+ddir
    lda ($e6),y
    asl

    ldy #s2olrud_off+ddir
    adc ($e6),y  ;C=0
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    setspr3_t2
    rle_init

    ldy #s2xsize_off
    lda ($e6),y
    sta .xsz+1

    ldy #s2xidx_off
    lda #0
    sta ($e6),y
    iny
    sta ($e6),y  ;xindex = yindex = 0;

    sta $67
    sta $68
.l7 sta $d6   ;for (int y = 0; y < ysize; y++)
    ldy #s2ysize_off
    cmp ($e6),y
    bcs mul16.le  ;exit
    
    lda #0
    sta $d7
.l1 ldy #s2xpos_off
    lda ($e6),y
    pha
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr getaddr22  ;addr = getaddr22(xpos, y + ypos)
    rle_get $69
    lda $d6
    beq .l11

    clc
    lda .xsz+1
    adc $67
    sta $67
    bcc .l11

    inc $68
.l11
    lda $e2  ;e0 - saved[0][y], e2 - saved[0][0]
    clc
    adc $67
    sta $e0
    lda $e3
    adc $68
    sta $e1

    pla
    and #1
    bne .odd

    jsr .main
    lda #2
.l6 sta $d7  ;for (x = 2; x < xsize; x += 2)
.xsz cmp #0
    bcs .l12

    ldy #s2xpos_off
    adc ($e6),y  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main1

    ldx $d7
    inx
    inx
    txa
    bne .l6  ;always
.l12
    ldx $d6
    inx
    txa
    jmp .l7

.odd
    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    asl
    asl
    asl
    asl
    ora $d5
    ldy #0
    sta ($e0),y  ; saved[0][y] = cc >> 4 | cl << 4

    lda $69  ;b1 = data[0][y]
    beq .l8  ;if (data[0][y])

    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = cl & 0xf0 | b1 >> 4

    lda $da
    and #$f
    sta $d5
    lda $69
    asl
    asl
    asl
    asl
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf | b1 << 4

.l8 ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l9 stx $d7
    inx
    txa
    cmp .xsz+1
    bcs .l14

    ldy #s2xpos_off
    lda ($e6),y
    adc $d7  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main1

    ldx $d7
    inx
    inx
    bne .l9  ;always
.l14
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos), sets C=0
    rle_get $69  ;sets Y=0

    lda ($d0),y  ;Y=0
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    and #$f
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy $d7
    sta ($e0),y  ;saved[x][y] = cc & 0xf | cl & 0xf0

    lda $69    ;b2 = data[x][y]
    beq .l10   ;if (data[x][y])

    and #$f0
    sta $d5
    lda $d9
    and #$f
    ora $d5
    ldy #0
    sta ($d0),y  ;prg[addr] = cl & 0xf | b2 & 0xf0

    lda $da
    and #$f0
    sta $d5
    lda $69
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf0 | b2 & 0xf
.l10
    jmp .l12

.main1
    rle_get $69
.main
    rle_get $6a  ;sets Y=0
    lda ($d0),y  ;Y=0
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    and #$f
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy $d7
    sta ($e0),y  ;saved[x][y] = cc & 0xf | cl & 0xf0
    sta .t+1

    lda $da
    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    asl
    asl
    asl
    asl
    ora $d5
    iny
    sta ($e0),y  ;saved[x + 1][y] = cc >> 4 | cl << 4
    sta $d5

    lda $6a  ;data[x + 1][y]
    ora $69  ;data[x][y]
    beq .l2  ;if ((data[x][y] | data[x + 1][y]) == 0)

    lda $69  ;if (data[x][y] == 0)
    bne .l3

.t  lda #0
    sta $d9    ;b1 = saved[x][y]
    lda $6a
    sta $da  ;b2 = data[x + 1][y]
    jmp .l4  ;always  ?bvc
.l3
    lda $6a  ;if (data[x + 1][y] == 0)
    bne .l5

    lda $69
    sta $d9   ;b1 = data[x][y]
    lda $d5
    sta $da   ;b2 = saved[x + 1][y]
    jmp .l4  ;always  ?bvc
.l5
    lda $69
    sta $d9   ;b1 = data[x][y]
    lda $6a
    sta $da  ;b2 = data[x + 1][y]
.l4
    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy #0
    sta ($d0),y  ;prg[addr] = b1 & 0xf0 | b2 >> 4
    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda $d9
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = b1 & 0xf | b2 << 4
.l2 rts

left_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d6, $d9-db, $e0-e5
    ldy #s2xpos_off
    lda ($e6),y
    bne *+3
    rts  ;if (xpos == 0) return

    setspr_t2 ldir
    jsr left0_t2
    ;jmp put00_t2

put00_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-da, $dc, $e0-e5
    rle_init

    lda #0
.l7 sta $d6   ;for (int y = 0; y < ysize; y++)
    ldy #s2ysize_off
    cmp ($e6),y
    bcs put_t2.l2
    
    lda #0
    sta $d7
    ldy #s2xpos_off
    lda ($e6),y
    pha
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr getaddr22  ;addr = getaddr22(xpos, y + ypos)
    rle_get $69

    ldy #s2xsize_off
    lda ($e6),y
    sta $66
    sta $dc
    ldy #s2yidx_off
    lda ($e6),y
    clc
    adc $d6
    ldy #s2ysize_off
    cmp ($e6),y
    bcc *+4
    sbc ($e6),y  ;C=1
    jsr mul16  ;[(y + yindex)%ysize]
    txa
    adc $e2  ;e0 - saved[0][(y + yindex)%ysize], e2 - saved[0][0], C=0
    sta $e0
    tya
    adc $e3
    sta $e1

    pla
    and #1
    bne .odd

    jsr .main
    ldx #2
.l6 stx $d7  ;for (x = 2; x < xsize; x += 2)
    cpx $dc
    bcs .l1

    ldy #s2xpos_off
    txa
    adc ($e6),y  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main1

    ldx $d7
    inx
    inx
    bne .l6  ;always
.l1
    ldx $d6
    inx
    txa
    jmp .l7  ;always

.odd
    lda $69  ;data[0][y]
    bne .l8  ;if (data[0][y])

    ldy #s2xidx_off
    lda ($e6),y
    tay
    lda ($e0),y  ;saved[xindex][(y + yindex)%ysize]
.l8 sta $d9   ;b1 = 

    lsr
    lsr
    lsr
    lsr
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf0 | b1 >> 4

    lda ($d2),y
    and #$f
    sta $d5
    lda $d9
    asl
    asl
    asl
    asl
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b2 & 0xf

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l9 stx $d7
    txa
    inx
    cpx $dc
    bcs .l15

    ldy #s2xpos_off
    adc ($e6),y  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main1

    ldx $d7
    inx
    inx
    bne .l9  ;always
.l15
    rle_get $69
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos), sets C=0
    lda $69  ;data[x][y]
    bne .l10   ;if (data[x][y])

    ldy #s2xidx_off
    lda ($e6),y
    ;clc
    adc $d7  ;C=0
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y  ;saved[(x + xindex)%xsize][(y + yindex)%ysize]
.l10
    sta $da   ;b2 = 

    and #$f0
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf | b2 & 0xf0

    lda $da
    and #$f
    sta $d5
    lda ($d2),y
    and #$f0
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b2 & 0xf
    jmp .l1

.main1
    rle_get $69
.main
    rle_get $6a
    lda $69
    bne .l5  ;if (data[x][y] == 0)

    ldy #s2xidx_off
    lda ($e6),y
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y  ;saved[(x + xindex)%xsize][(y + yindex)%ysize]
.l5 sta $d9     ;b1 =

    lda $6a
    bne .l3  ;if (data[x + 1][y] == 0)

    ldy #s2xidx_off
    lda ($e6),y
    sec
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y  ;saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]
.l3 sta $da  ;b2 =

    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy #0
    sta ($d0),y  ;prg[addr] = b1 & 0xf0 | b2 >> 4

    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda $d9
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = b1 & 0xf | b2 << 4
.le rts

remove_t2:  ;in: e6-e7;  used: $d0-d3, $d5-$d7, $d9-da, $dc, $e0-e3
    lda #0
.l7 sta $d6   ;for (int y = 0; y < ysize; y++)
    ldy #s2ysize_off
    cmp ($e6),y
    bcs put00_t2.le
    
    lda #0
    sta $d7

    ldy #s2xpos_off
    lda ($e6),y
    pha
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr getaddr22  ;addr = getaddr22(xpos, y + ypos)

    ldy #s2xsize_off
    lda ($e6),y
    sta $66
    sta $dc
    ldy #s2yidx_off
    lda ($e6),y
    clc
    adc $d6
    ldy #s2ysize_off
    cmp ($e6),y
    bcc *+4
    sbc ($e6),y  ;C=1
    jsr mul16   ;[(y + yindex)%ysize]
    txa
    adc $e2  ;e0 - saved[0][(y + yindex)%ysize], e2 - saved[0][0], C=0
    sta $e0
    tya
    adc $e3  ;sets C=0
    sta $e1

    pla
    and #1
    bne .odd  ;if ((xpos&1) == 0)

    jsr .main
    ldx #2
.l6 stx $d7  ;for (x = 2; x < xsize; x += 2)
    cpx $dc
    bcs .l1

    ldy #s2xpos_off
    txa
    adc ($e6),y  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main

    ldx $d7
    inx
    inx
    bne .l6  ;always
.l1
    ldx $d6
    inx
    txa
    bne .l7  ;always

.odd
    ldy #s2xidx_off
    lda ($e6),y
    tay
    lda ($e0),y
    sta $da     ;b2 = saved[xindex][(y + yindex)%ysize]

    lsr
    lsr
    lsr
    lsr
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf0 | b2 >> 4

    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda ($d2),y
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l9 stx $d7
    txa
    inx
    cpx $dc
    bcs .l8

    ldy #s2xpos_off
    adc ($e6),y  ;C=0
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)
    jsr .main

    ldx $d7
    inx
    inx
    bne .l9  ;always
.l8
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos), sets C=0

    ldy #s2xidx_off
    lda ($e6),y
    adc $d7  ;C=0
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y
    sta $d9     ;b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize]

    and #$f0
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f
    ora $d5
    sta ($d0),y   ;prg[addr] = prg[addr] & 0xf | b1 & 0xf0

    lda $d9
    and #$f
    sta $d5
    lda ($d2),y
    and #$f0
    ora $d5
	sta ($d2),y   ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf
    jmp .l1

.main
    ldy #s2xidx_off
    lda ($e6),y
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc
    tay
    lda ($e0),y
    sta $d9  ;b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize]

    iny
    tya
    cmp $dc
    bcc *+4
    sbc $dc
    tay
    lda ($e0),y
    sta $da  ;b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]

    lsr
    lsr
    lsr
    lsr
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy #0
    sta ($d0),y  ;prg[addr] = b2 >> 4 | b1 & 0xf0

    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda $d9
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = b2 << 4 | b1 & 0xf
    rts

left0_t2:  ;used: $66-68, $d0-d3, $d5-d6, $d9-db
    ldy #s2xpos_off
    lda ($e6),y
    sec
    sbc #1  ;sets C=1
    sta ($e6),y  ;xpos--

    ldy #s2xsize_off
    lda ($e6),y
    sta .xsz+1

    ldy #s2xidx_off
    lda ($e6),y
    bne .l1

    lda .xsz+1
    ldy #s2xidx_off
.l1
    sbc #1  ;C=1
    sta ($e6),y  ;if (xindex == 0) xindex = xsize - 1; else xindex--

    lda #0  ;for (int y = 0; y < ysize; y++)
.l2 sta $d6
.xsz lda #0
    sta $66
    ldy #s2yidx_off
    lda ($e6),y
    clc
    adc $d6
    ldy #s2ysize_off
    cmp ($e6),y
    bcc *+4
    sbc ($e6),y  ;C=1
    jsr mul16   ;(y + yindex)%ysize
    txa
    adc $e2  ;e0 - saved[0][(y + yindex)%ysize], e2 - saved[0][0], C=0
    sta $e0
    tya
    adc $e3  ;sets C=0
    sta $e1

    lda .xsz+1
    ldy #s2xpos_off
    adc ($e6),y  ;C=0
    tax   ;xpos + xsize

    iny
    lda ($e6),y
    adc $d6  ;C=0
    sta $d5  ;ypos + y

    ldy #s2xidx_off
    lda ($e6),y
    pha
    tay
    lda ($e0),y  ;saved[xindex][(y + yindex)%ysize]
    ldy $d5
    jsr setcolor22  ;setcolor22(xpos + xsize, ypos + y, saved[xindex][(y + yindex)%ysize])

    ldy #s2xpos_off
    lda ($e6),y
    tax
    iny
    lda ($e6),y
    clc
    adc $d6
    tay
    jsr getcolor22  ;getcolor22(xpos, ypos + y)
    tax
    pla
    tay
    txa
    sta ($e0),y  ;saved[xindex][(y + yindex)%ysize] = getcolor22(xpos, ypos + y)

    ldy $d6
    iny
    tya
    ldy #s2ysize_off
    cmp ($e6),y
    bcc .l2
    rts

right0_t2:  ;used: $66-68, $d0-d3, $d5-d6, $d9-db
    ldy #s2xsize_off
    lda ($e6),y
    sta .xsz+1

    lda #0  ;for (int y = 0; y < ysize; y++)
.l2 sta $d6
.xsz lda #0
    sta $66
    ldy #s2yidx_off
    lda ($e6),y
    clc
    adc $d6
    ldy #s2ysize_off
    cmp ($e6),y
    bcc *+4
    sbc ($e6),y  ;C=1
    jsr mul16   ;(y + yindex)%ysize
    txa
    adc $e2  ;e0 - saved[0][(y + yindex)%ysize], e2 - saved[0][0], C=0
    sta $e0
    tya
    adc $e3   ;sets C=0
    sta $e1

    ldy #s2xpos_off
    lda ($e6),y
    tax   ;xpos

    iny
    lda ($e6),y
    adc $d6  ;C=0
    sta $d5  ;ypos + y

    ldy #s2xidx_off
    lda ($e6),y
    pha
    tay
    lda ($e0),y  ;saved[xindex][(y + yindex)%ysize]
    ldy $d5
    jsr setcolor22  ;setcolor22(xpos, ypos + y, saved[xindex][(y + yindex)%ysize])

    lda .xsz+1
    clc
    ldy #s2xpos_off
    adc ($e6),y
    tax  ;xpos + xsize

    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr getcolor22  ;getcolor22(xpos, ypos + y)
    tax
    pla
    tay
    txa
    sta ($e0),y  ;saved[xindex][(y + yindex)%ysize] = getcolor22(xpos + xsize, ypos + y)

    ldy $d6
    iny
    tya
    ldy #s2ysize_off
    cmp ($e6),y
    bcc .l2

    ldy #s2xpos_off
    lda ($e6),y
    adc #0  ;C=1
    sta ($e6),y  ;xpos++

    ldy #s2xidx_off
    lda ($e6),y
    adc #1  ;C=0
    cmp .xsz+1
    bne *+6
    lda #0
    ldy #s2xidx_off
    sta ($e6),y  ;xindex++;  if (xindex == xsize) xindex = 0
    rts

up0_t2:  ;used: $66-68, $d0-d3, $d5-d7, $d9-dc
    ldy #s2ypos_off
    lda ($e6),y
    sec
    sbc #1  ;sets C=1
    sta ($e6),y  ;ypos--
    sta $d6

    ldy #s2yidx_off
    lda ($e6),y
    bne .l1

    ldy #s2ysize_off
    lda ($e6),y
    ldy #s2yidx_off
.l1
    sbc #1  ;C=1
    sta ($e6),y  ;if (yindex == 0) yindex = ysize - 1; else yindex--

    ldy #s2xidx_off
    lda ($e6),y
    sta $db   ;xindex

    lda #0
    sta $d7  ;x

    ldy #s2xsize_off
    lda ($e6),y
    sta $66
    sta $dc
    ldy #s2yidx_off
    lda ($e6),y
    jsr mul16   ;yindex
    txa
    adc $e2  ;e0 - saved[0][yindex], e2 - saved[0][0], C=0
    sta $e0
    tya
    adc $e3  ;sets C=0
    sta $e1

    ldy #s2xpos_off
    lda ($e6),y
    sta $66  ;xpos
    tax
    iny
    lda ($e6),y
    ldy #s2ysize_off
    adc ($e6),y  ;C=0
    tay
    sta $68  ;y + ypos
    jsr getaddr22  ;addr = getaddr22(xpos, ypos + ysize)

    lda $66
    and #1
    bne .odd2

    jsr cmain2
    ldx #2
.l6 stx $d7  ;for (x = 2; x < xsize; x += 2)
    cpx $dc
    bcc *+5
    jmp .p2

    txa
    adc $66   ;C=0
    tax
    ldy $68
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos + ysize)
    jsr cmain2

    ldx $d7
    inx
    inx
    bne .l6  ;always
.odd2
    ldy $db
    lda ($e0),y
    sta $da  ;b2 = saved[xindex][yindex]

    lsr
    lsr
    lsr
    lsr
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf0 | b2 >> 4

    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda ($d2),y
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l2 stx $d7
    txa
    inx
    cpx $dc
    bcs .l3

    adc $66  ;C=0
    tax
    ldy $68
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos + ysize)
    jsr cmain2

    ldx $d7
    inx
    inx
    bne .l2   ;always
.l3
    clc
    adc $66
    tax
    ldy $68
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos + ysize) sets C=0

    lda $db
    adc $d7  ;C=0
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y
    sta $d9   ;b1 = saved[(x + xindex)%xsize][yindex]

    and #$f0
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf | b1 & 0xf0

    lda $d9
    and #$f
    sta $d5
    lda ($d2),y
    and #$f0
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf
.p2
    ldx $66  ;xpos
    ldy $d6  ;ypos
    jsr getaddr22  ;addr = getaddr22(xpos, ypos)

    lda $66
    and #1
    bne .odd1  ; if ((xpos&1) == 0)

    lda #0
    sta $d7
    jsr cmain1
    lda #2  ;for (x = 2; x < xsize; x += 2)
.l5 sta $d7
    cmp $dc
    bcc *+3
    rts

    adc $66   ;C=0
    tax
    ldy $d6
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos)
    jsr cmain1

    ldx $d7
    inx
    inx
    txa
    bne .l5  ;always
.odd1
    ldy #0
    lda ($d0),y
    asl
    asl
    asl
    asl
    sta $d5
    lda ($d2),y
    lsr
    lsr
    lsr
    lsr
    ora $d5
    ldy $db
    sta ($e0),y  ;saved[xindex][yindex] = prg[addr + 0x400] >> 4 | prg[addr] << 4

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l7 stx $d7
    txa
    inx
    cpx $dc
    bcs .l4

    adc $66  ;C=0
    tax
    ldy $d6
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos)
    jsr cmain1

    ldx $d7
    inx
    inx
    bne .l7  ;always
.l4
    clc
    adc $66
    tax
    ldy $d6
    jsr nextaddr22   ;addr = nextaddr22(addr, x + xpos, ypos)

    ldy #0
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda ($d0),y
    sta $d9  ;cl = prg[addr]

    and #$f0
    sta $d5
    lda $db
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc
    tay
    lda $da
    and #$f
    ora $d5
    sta ($e0),y  ;saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0
    rts

down0_t2:  ;used: $66-68, $d0-d3, $d5-d7, $d9-dc
    ldy #s2xidx_off
    lda ($e6),y
    sta $db   ;xindex

    lda #0
    sta $d7  ;x

    ldy #s2xsize_off
    lda ($e6),y
    sta $66
    sta $dc
    ldy #s2yidx_off
    lda ($e6),y
    jsr mul16   ;yindex
    txa
    adc $e2  ;e0 - saved[0][yindex], e2 - saved[0][0], C-0
    sta $e0
    tya
    adc $e3  ;sets C=0
    sta $e1

    ldy #s2xpos_off
    lda ($e6),y
    sta $66  ;xpos
    tax
    ldy #s2ypos_off
    lda ($e6),y
    sta $d6
    tay
    jsr getaddr22  ;addr = getaddr22(xpos, ypos)

    lda $66
    and #1
    bne .odd2

    jsr cmain2
    lda #2
.l6 sta $d7  ;for (x = 2; x < xsize; x += 2)
    cmp $dc
    bcc *+5
    jmp .p2

    adc $66  ;C=0
    tax
    ldy $d6
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos)
    jsr cmain2

    ldx $d7
    inx
    inx
    txa
    bne .l6  ;always
.odd2
    ldy $db
    lda ($e0),y
    sta $da  ;b2 = saved[xindex][yindex]

    lsr
    lsr
    lsr
    lsr
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf0 | b2 >> 4

    lda $da
    asl
    asl
    asl
    asl
    sta $d5
    lda ($d2),y
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l2 stx $d7
    txa
    inx
    cpx $dc
    bcs .l4

    adc $66   ;C=0
    tax
    ldy $d6
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos)
    jsr cmain2

    ldx $d7
    inx
    inx
    bne .l2  ;always
.l4
    clc
    adc $66
    tax
    ldy $d6
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos) sets C=0

    lda $db
    adc $d7  ;C=0
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y
    sta $d9   ;b1 = saved[(x + xindex)%xsize][yindex]

    and #$f0
    sta $d5
    ldy #0
    lda ($d0),y
    and #$f
    ora $d5
    sta ($d0),y  ;prg[addr] = prg[addr] & 0xf | b1 & 0xf0

    lda $d9
    and #$f
    sta $d5
    lda ($d2),y
    and #$f0
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf
.p2
    ldx $66  ;xpos
    ldy #s2ysize_off
    lda ($e6),y
    clc
    adc $d6
    sta $68
    tay  ;ypos + ysize
    jsr getaddr22  ;addr = getaddr22(xpos, ypos + ysize)

    lda $66
    and #1
    bne .odd1  ; if ((xpos&1) == 0)

    lda #0
    sta $d7
    jsr cmain1
    lda #2  ;for (x = 2; x < xsize; x += 2)
.l5 sta $d7
    cmp $dc
    bcs .l12

    adc $66  ;C=0
    tax
    ldy $68
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos + ysize)
    jsr cmain1

    ldx $d7
    inx
    inx
    txa
    bne .l5  ;always
.l12
    lda $d6
    clc
    adc #1
    ldy #s2ypos_off
    sta ($e6),y  ;ypos++

    ldy #s2yidx_off
    lda ($e6),y
    adc #1  ;C=0
    ldy #s2ysize_off
    cmp ($e6),y
    bne .l1

    lda #0
.l1 ldy #s2yidx_off
    sta ($e6),y  ;yindex++; if (yindex == ysize) yindex = 0
    rts
.odd1
    ldy #0
    lda ($d0),y
    asl
    asl
    asl
    asl
    sta $d5
    lda ($d2),y
    lsr
    lsr
    lsr
    lsr
    ora $d5
    ldy $db
    sta ($e0),y  ;saved[xindex][yindex] = prg[addr + 0x400] >> 4 | prg[addr] << 4

    ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l7 stx $d7
    txa
    inx
    cpx $dc
    bcs .l8

    adc $66  ;C=0
    tax
    ldy $68
    jsr nextaddr22  ;nextaddr22(addr, x + xpos, ypos + ysize)
    jsr cmain1

    ldx $d7
    inx
    inx
    bne .l7  ;always
.l8
    clc
    adc $66
    tax
    ldy $68
    jsr nextaddr22   ;addr = nextaddr22(addr, x + xpos, ypos + ysize)

    ldy #0
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda ($d0),y
    sta $d9  ;cl = prg[addr]

    and #$f0
    sta $d5
    lda $db
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc
    tay
    lda $da
    and #$f
    ora $d5
    sta ($e0),y  ;saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0
    jmp .l12

cmain2:
    lda $db
    sec
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y
    sta $da  ;b2 = saved[(xindex + x + 1)%xsize][yindex]

    lda $db
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda ($e0),y
    sta $d9   ;b1 = saved[(x + xindex)%xsize][yindex]

    and #$f0
    sta $d5
    lda $da
    lsr
    lsr
    lsr
    lsr
    ora $d5
    ldy #0
    sta ($d0),y  ;prg[addr] = b1 & 0xf0 | b2 >> 4

    lda $d9
    and #$f
    sta $d5
    lda $da
    asl
    asl
    asl
    asl
    ora $d5
    sta ($d2),y   ;prg[addr + 0x400] = b1 & 0xf | b2 << 4
    rts

cmain1:
    ldy #0
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda ($d0),y
    sta $d9  ;cl = prg[addr]

    asl
    asl
    asl
    asl
    sta $d5
    lda $db
    sec
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda $da
    lsr
    lsr
    lsr
    lsr
    ora $d5
    sta ($e0),y  ;saved[(xindex + x + 1)%xsize][yindex] = cc >> 4 | cl << 4,

    lda $d9
    and #$f0
    sta $d5
    lda $db
    clc
    adc $d7
    cmp $dc
    bcc *+4
    sbc $dc  ;C=1
    tay
    lda $da
    and #$f
    ora $d5
    sta ($e0),y  ;saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
    rts

left2_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d6, $d9-da, $dc-$de, $e0-e5
    ldy #s2xpos_off
    lda ($e6),y
    cmp #2
    bcs *+3
    rts  ;if (xpos < 2) return

    setspr_t2 ldir
    jsr left0_t2
    jsr left0_t2
    jmp put00_t2

right_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d6, $d9-da, $dc-$de, $e0-e5
    ldy #s2xsize_off
    lda ($e6),y
    sec
    sbc #HSIZE/2
    ldy #s2xpos_off
    adc ($e6),y  ;C=0, xpos == HSIZE/2-xsize
    bne *+3
    rts  ;if (xpos + xsize == xmax/2) return

    setspr_t2 rdir
    jsr right0_t2
    jmp put00_t2

right2_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d6, $d9-da, $dc-$de, $e0-e5
    ldy #s2xsize_off
    lda ($e6),y
    sec
    sbc #HSIZE/2-1
    ldy #s2xpos_off
    adc ($e6),y  ;C=0
    bcc *+3  ;if (xpos + xsize < xmax/2 - 1) return
    rts

    setspr_t2 rdir
    jsr right0_t2
    jsr right0_t2
    jmp put00_t2

down_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-de, $e0-e5
    ldy #s2ypos_off
    lda ($e6),y
    sta $d6
    sec
    sbc #VSIZE/2
    ldy #s2ysize_off
    adc ($e6),y     ;C=0
    bne *+3
    rts

    setspr_t2 ddir
    jsr down0_t2
    jmp put00_t2

down2_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-de, $e0-e5
    ldy #s2ypos_off
    lda ($e6),y
    sec
    sbc #VSIZE/2-1
    ldy #s2ysize_off
    adc ($e6),y     ;C=0
    bcc *+3
    rts

    setspr_t2 ddir
    jsr down0_t2
    jsr down0_t2
    jmp put00_t2

up_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-de, $e0-e5
    ldy #s2ypos_off
    lda ($e6),y
    bne *+3
    rts

    setspr_t2 udir
    jsr up0_t2
    jmp put00_t2

up2_t2:  ;in: $e6-e7;  used: $66-68, $d0-d3, $d5-d7, $d9-de, $e0-e5
    ldy #s2ypos_off
    lda ($e6),y
    cmp #2
    bcs *+3
    rts

    setspr_t2 udir
    jsr up0_t2
    jsr up0_t2
    jmp put00_t2

getaddr22:  ;in :x, y;  used: AC, YR, XR;  doubled x, y are used;  returns addr in $d0-d1 and $d2-d3, C=0
    lda #0
    sta $d1
    tya
    and #$fc
    asl
    ;rol $d1   ;y < 128
    sta $d0
    asl
    rol $d1
    asl
    rol $d1
    adc $d0  ;C=0
    sta $d0
    bcc *+4
    inc $d1
    txa
    lsr
    clc
    adc $d0
    sta $d0
    sta $d2
    bcc *+4
    inc $d1      ;p = (y >> 2)*40 + (x >> 1) = (y&0xfc)*10 + (x >> 1)
    
    tya
    and #3
    stx .m1+1
    tax
    lda abase2,x   ;ba = abase2[y&3] - 0x400
    sec
    sbc #4
    cpy #96
    bcs .l1

    lda abase1,x  ;if (y < 96) ba = abase1[y&3]
    bcc .l3     ;always

.l1 cpy #100       ;optimize for VSIZE = 200
    bcs .l2

.l4 lda abase2,x
    bcc .l3    ;always

.l2 cpy #104        ;optimize for VSIZE = 200
    bcs .l3

.m1 ldy #0
    cpy #48
    bcc .l4   ;if (y < 100 || y < 104 && x < 48) ba = abase2[y&3]

.l3 clc
    adc $d1
    sta $d1   ;ba + p
    adc #4
    sta $d3
    rts

nextaddr22: ;in :x, y, $d0-d1;  used: ac, yr;  doubled x, y are used;  returns addr in $d0-d1 and $d2-d3, C=0
    cpx #48
    bne .l1

    cpy #100  ;optimize for VSIZE = 200
    bcc .l1

    cpy #104   ;optimize for VSIZE = 200
    bcs .l1

    tya
    and #3
    tay
    lda abase2,y
    sta $d1
    lda #0
    sta $d0  ;if (x == 48 && y >=100 && y < 104) a = abase2[y&3]
    beq .l2   ;always
.l1
    inc $d0
    bne .l2

    inc $d1   ;a = addr + 1
.l2 lda $d1
    clc
    adc #4
    sta $d3
    lda $d0
    sta $d2
    rts

setcolor22: ;in: x, y, a - color;  doubled x, y are used;  used: $d0-d3, $d5, $d9-db
    sta $db
    stx $d5
    jsr getaddr22  ;addr = getaddr22(x, y)
    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]
    lda $d5
    and #1
    beq .l1

    lda $d9  ;cs = 1
    and #$f0
    sta $d5
    lda $db
    lsr
    lsr
    lsr
    lsr
    ora $d5
    sta ($d0),y  ;prg[addr] = cl & 0xf0 | c >> 4

    lda $da
    and #$f
    sta $d5
    lda $db
    asl
    asl
    asl
    asl
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf | c << 4
    rts
.l1
    lda $d9  ;cs = 2
    and #$f
    sta $d5
    lda $db
    and #$f0
    ora $d5
    sta ($d0),y  ;prg[addr] = cl & 0xf | c & 0xf0

    lda $da
    and #$f0
    sta $d5
    lda $db
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf0 | c & 0xf
    rts

getcolor22:  ;in: x, y;  doubled x, y are used;  used: $d5, $d9, $da;  returns AC
    stx $d5
    jsr getaddr22  ;addr = getaddr22(x, y)
    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]
    lda $d5
    and #1
    beq .l1
    
    lda $d9  ;cs = 1
    asl
    asl
    asl
    asl
    sta $d5
    lda $da
    lsr
    lsr
    lsr
    lsr
    ora $d5
    rts   ;return cc >> 4 | cl << 4

.l1 lda $d9
    and #$f0
    sta $d5
    lda $da
    and #$f
    ora $d5
    rts   ;return cc & 0xf | cl & 0xf0;

