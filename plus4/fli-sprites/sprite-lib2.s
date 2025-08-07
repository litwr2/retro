;for vasm6502/oldstyle
;the next zp-locations are used: $e2-e7

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
saved_\id   ds \xs*\ys
     endm

s2xsize_off = 0
s2ysize_off = 1
s2xpos_off = 2
s2ypos_off = 3
x2idx_off = 4
y2idx_off = 5
n2lrud_off = 6
c2lrud_off = 10
o2lrud_off = 14
saved_off = 18

;ldir = 0
;rdir = 1
;udir = 2
;ddir = 3

    macro setspr_t2
    ldy #c2lrud_off+\1
    lda ($e6),y
    tax
    asl

    ldy #o2lrud_off+\1
    adc ($e6),y  ;C=0
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    inx
    txa
    ldy #n2lrud_off+\1
    cmp ($e6),y
    bne *+4
    lda #0
    ldy #c2lrud_off+\1
    sta ($e6),y

    lda #saved_off
    clc
    adc $e6
    sta $e2
    lda $e7
    adc #0
    sta $e3
    endm

    ;org $a000
mul16:
.le rts

put_t2:
    ldy #c2lrud_off+ddir   ;setspr_t2?
    lda ($e6),y
    tax
    asl

    ldy #o2lrud_off+ddir
    adc ($e6),y  ;C=0
    tay

    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5

    lda #saved_off
    ;clc
    adc $e6   ;C=0
    sta $e2
    lda $e7
    adc #0
    sta $e3

    ldy #x2idx_off
    lda #0
    sta ($e6),y
    iny
    sta ($e6),y  ;xindex = yindex = 0;

    sta $67
    sta $68

.l7 sta $d6   ;for (int y = 0; y < ysize; y++)
    ldy #s2ysize_off
    cmp ($e6),y
    bcs mul16.le
    
    lda #0
    sta $d7
.l1 ldy #s2xpos_off
    lda ($e6),y
    pha
    tax
    iny
    lda ($e6),y
    clc   ;remove?
    adc $d6
    tay
    jsr getaddr22  ;addr = getaddr22(xpos, y + ypos)
    lda $d6
    beq .l11

    clc
    ldy #s2xsize_off
    lda ($e6),y
    adc $67
    sta $67
    bcc .l11

    inc $68
.l11    
    pla
    and #1
    beq *+5
    jmp .odd

    jsr .main
    lda #2
.l6 sta $d7  ;for (x = 2; x < xsize; x += 2)
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7  ;C=0?
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
    txa
    ldy #s2xsize_off
    cmp ($e6),y
    bcc .l6
.l12
    ldx $d6
    inx
    txa
    bne .l7  ;always

.odd
    lda $d0    ;d0  - prg[addr]
    sta $d2    ;d2  - prg[addr + 0x400]
    lda $d1
    clc    ;?remove
    adc #4
    sta $d3

    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda $e2  ;e0 - saved[0][y], e2 - saved[0][0]
    adc $67  ;C=0
    sta $e0
    lda $e3
    adc $68
    sta $e1  ;saved[0][y] =
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
    ldy #0
    sta ($e0),y  ; = cc >> 4 | cl << 4

    clc
    lda $e4
    adc $67
    sta $dd
    lda $e5
    adc $68
    sta $de  ;dd - data[0][y], e4 - data[0][0]
    lda ($dd),y  ;Y=0
    beq .l8  ;if (data[0][y])

    sta $db   ;b1 = data[0][y]
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
    lda $db
    asl
    asl
    asl
    asl
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf | b1 << 4

.l8 ldx #1  ;for (x = 1; x < xsize - 1; x += 2)
.l9 stx $d7
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7  ;C=0?
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
    inx
    txa
    ldy #s2xsize_off
    cmp ($e6),y
    dex
    bcc .l9

    stx $d7
    ldy #s2xpos_off
    lda ($e6),y
    clc
    adc $d7  ;C=0?
    tax
    iny
    lda ($e6),y
    adc $d6  ;C=0
    tay
    jsr nextaddr22  ;addr = nextaddr22(addr, x + xpos, y + ypos)

    lda $d0    ;d0  - prg[addr]
    sta $d2    ;d2  - prg[addr + 0x400]
    lda $d1
    clc    ;?remove
    adc #4
    sta $d3

    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda $e2  ;e0 - saved[0][y], e2 - saved[0][0]
    adc $67  ;C=0
    sta $e0
    lda $e3
    adc $68
    sta $e1
    lda $e0
    adc $d7  ;C=0
    sta $e0
    bcc *+4
    inc $e1   ;saved[x][y] =
    lda $da
    and #$f
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy #0
    sta ($e0),y  ; = cc & 0xf | cl & 0xf0

    clc
    lda $e4
    adc $67
    sta $dd
    lda $e5
    adc $68
    sta $de
    lda $dd
    adc $d7  ;C=0
    sta $dd
    bcc *+4
    inc $de  ;dd - data[x][y], e4 - data[0][0]
    lda ($dd),y  ;Y=0
    beq .l10   ;if (data[x][y])

    sta $db   ;b2 = data[x][y]
    and #$f0
    sta $d5
    lda $d9
    and #$f
    ora $d5
    sta ($d0),y  ;prg[addr] = cl & 0xf | b2 & 0xf0

    lda $da
    and #$f0
    sta $d5
    lda $db
    and #$f
    ora $d5
    sta ($d2),y  ;prg[addr + 0x400] = cc & 0xf0 | b2 & 0xf
.l10
    jmp .l12

.main
    lda $d0    ;d0  - prg[addr]
    sta $d2    ;d2  - prg[addr + 0x400]
    lda $d1
    clc    ;?remove
    adc #4
    sta $d3

    ldy #0
    lda ($d0),y
    sta $d9  ;cl = prg[addr]
    lda ($d2),y
    sta $da  ;cc = prg[addr + 0x400]

    lda $e2  ;e0 - saved[x][y], e2 - saved[0][0]
    adc $67  ;C=0
    sta $e0
    lda $e3
    adc $68
    sta $e1
    lda $e0
    adc $d7  ;C=0
    sta $e0
    bcc *+4
    inc $e1  ;saved[x][y] =
    lda $da
    and #$f
    sta $d5
    lda $d9
    and #$f0
    ora $d5
    ldy #0
    sta ($e0),y  ; = cc & 0xf | cl & 0xf0

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

    clc
    lda $e4
    adc $67
    sta $dd
    lda $e5
    adc $68
    sta $de  ;dd - data[x][y], e4 - data[0][0]
    lda $dd
    adc $d7  ;C=0, sets V=0
    sta $dd
    bcc *+4
    inc $de
    lda ($dd),y  ;Y=1
    sta $db   ;data[x + 1][y]
    dey
    lda ($dd),y
    sta $dc  ;data[x][y]
    ora $db
    beq .l2  ;if ((data[x][y] | data[x + 1][y]) == 0)

    lda $dc  ;if (data[x][y] == 0)
    bne .l3

    lda ($e0),y  ;Y=0
    sta $d9    ;b1 = saved[0][y]
    lda $db
    sta $da  ;b2 = data[x][y]
    jmp .l4  ;always  ?bvc
.l3
    lda $db  ;if (data[x + 1][y] == 0)
    bne .l5

    lda $dc
    sta $d9   ;b1 = data[x][y]
    iny
    lda ($d2),y
    sta $da   ;b2 = saved[x + 1][y]
    jmp .l4  ;always  ?bvc
.l5
    lda $dc
    sta $d9   ;b1 = data[x][y]
    lda $db
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
    ldy #0   ;remove?
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

  if 0
right_t1:
    setspr_t1 rdir
    jsr right0_t1
    jmp put00_t1

right2_t1:
    setspr_t1 rdir
    jsr right0_t1
    jsr right0_t1
    jmp put00_t1

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

  if 0
down_t1:
    setspr_t1 ddir
    jsr down0_t1
    jmp put00_t1

down2_t1:
    setspr_t1 ddir
    jsr down0_t1
    jsr down0_t1
    jmp put00_t1

left_t1:
    setspr_t1 ldir
    jsr left0_t1
    jmp put00_t1

left2_t1:
    setspr_t1 ldir
    jsr left0_t1
    jsr left0_t1
    jmp put00_t1

up_t1:
    setspr_t1 udir
    jsr up0_t1
    jmp put00_t1

up2_t1:
    setspr_t1 udir
    jsr up0_t1
    jsr up0_t1
    jmp put00_t1
  endif

getaddr22:  ;in :x, y;  used: AC, YR, XR;  doubled x, y are used;  returns addr in $d0-d1
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
    sta $d1
    rts

nextaddr22: ;in :x, y, $d0-d1;  used: ac, yr;  doubled x, y are used;  returns addr in $d0-d1
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
    bne *+4
    inc $d1   ;a = addr + 1
.l2 rts


