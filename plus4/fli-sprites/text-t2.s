;for vasm assembler, oldstyle syntax

HILEV2 = 0

test:
   if 0
    lda #<ltext1
    sta $e6
    lda #>ltext1
    sta $e7
    lda #<data_ltext1_d1
    sta $e4
    sta $d2
    lda #>data_ltext1_d1
    sta $e5
    sta $d3
    lda #<($d000+1*8)
    sta $d0
    lda #>($d000+1*8)
    sta $d1
    ldx #0
    stx $d9
    ldy #$44
    sty $da
    lda #ltext1_xsz*8
    sta $d5
    jsr get_glyph_t2

    lda #<(data_ltext1_d1+8)
    sta $d2
    lda #>(data_ltext1_d1+8)
    sta $d3
    lda #<($d000+5*8)
    sta $d0
    lda #>($d000+5*8)
    sta $d1
    ldy #$35
    sty $da
    jsr get_glyph_t2
    jsr put_t2
  endif
    lda #<ltext1
    sta $e6
    lda #>ltext1
    sta $e7
    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext1_d1+4
  byte $00,$55   ;bg, fg
  byte 5   ;length
  byte "H"-64,"e"+32,"l"+32,"l"+32,"o"+32  ;text

    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext1_d1+ltext1_xsz*64
  byte $21,$44   ;bg, fg
  byte ltext1_xsz   ;length
  byte "80","x"+32,"128"  ;text
    jsr put_t2

    lda #<ltext4
    sta $e6
    lda #>ltext4
    sta $e7
    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext4_d1
  byte $42,$00   ;bg, fg
  byte ltext4_xsz   ;length
  byte "D"-64,"F"-64,"L"-64,"I"-64  ;text
     jsr put_t2

    lda #<ltext2
    sta $e6
    lda #>ltext2
    sta $e7
    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext2_d1
  byte $00,$5e   ;bg, fg
  byte ltext2_xsz   ;length
  byte "W"-64,"O"-64,"R"-64,"L"-64,"D"-64  ;text
     jsr put_t2

    lda #<ltext5
    sta $e6
    lda #>ltext5
    sta $e7
    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext5_d1
  byte $47,$00   ;bg, fg
  byte ltext5_xsz   ;length
  byte "o"+32,"f"+32  ;text
     jsr put_t2

    lda #<ltext3
    sta $e6
    lda #>ltext3
    sta $e7
    jsr put_gl_t2
  byte 1   ;rom
  word $d000   ;cg
  word data_ltext3_d1
  byte $00,$68   ;bg, fg
  byte ltext3_xsz   ;length
  byte "S"-64,"P"-64,"R"-64,"I"-64,"T"-64,"E"-64,"S"-64,"!"  ;text
     jsr put_t2
.restart
    lda #120
    jsr delay

     lda #10
     sta .count1
.loo1
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr up0_t2
    jsr put00_t2

    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr up0_t2
    jsr put00_t2

    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr up0_t2
    jsr put00_t2

    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr up0_t2
    jsr put00_t2

    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    dec .count1
    bne .loo1

    lda $e4
    sta $d0
    lda $e5
    sta $d1
    lda #$77
    ldx #8
    stx $d2
.loo8
    ldy #63
.loo7
    tax
    lda ($d0),y
    beq .l1

    txa
    sta ($d0),y
.l1 txa
    dey
    bpl .loo7

    tay
    clc
    lda $d0
    adc #64
    sta $d0
    bcc *+4
    inc $d1
    sec
    tya
    sbc #$10
    dec $d2
    bne .loo8

    lda #120
    jsr delay
.shift = 32  ;80
     lda #.shift
     sta .count1
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
.loo2
    jsr down0_t2
    jsr put00_t2
    dec .count1
    bne .loo2

     lda #.shift
     sta .count1
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
.loo3
    jsr down0_t2
    jsr put00_t2
    dec .count1
    bne .loo3

     lda #.shift/2
     sta .count1
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
.loo4
    jsr down0_t2
    jsr down0_t2
    jsr put00_t2
    dec .count1
    bne .loo4

     lda #.shift/2
     sta .count1
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
.loo5
    jsr down0_t2
    jsr down0_t2
    jsr put00_t2
    dec .count1
    bne .loo5

     lda #.shift
     sta .count1
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    lda $e4
    sta $d0
    lda $e5
    sta $d1
    lda #$72
    ldx #8
    stx $d2
.loo8a
    ldy #31
.loo7a
    tax
    lda ($d0),y
    beq .l1a

    txa
    sta ($d0),y
.l1a txa
    dey
    bpl .loo7a

    tay
    clc
    lda $d0
    adc #32
    sta $d0
    bcc *+4
    inc $d1
    sec
    tya
    sbc #$10
    dec $d2
    bne .loo8a

    lda #30
    jsr delay
    
.loo6
    jsr down0_t2
    jsr put00_t2
    dec .count1
    bne .loo6

    lda #120
    jsr delay

    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr remove_t2
    ldy #s2ypos_off
    lda #10
    sta ($e6),y
    jsr put_t2

    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr remove_t2
    ldy #s2ypos_off
    lda #26
    sta ($e6),y
    jsr put_t2

    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr remove_t2
    ldy #s2ypos_off
    lda #34
    sta ($e6),y
    jsr put_t2

    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr remove_t2
    ldy #s2ypos_off
    lda #42
    sta ($e6),y
    jsr put_t2

    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr remove_t2
    ldy #s2ypos_off
    lda #50
    sta ($e6),y
    jsr put_t2

    lda #120
    jsr delay

    lda #8
    sta .count1
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
.loo00
    jsr left0_t2
    jsr left0_t2
    jsr put00_t2
    dec .count1
    bne .loo00 

    lda #24
    sta .count1
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
.loo01
    jsr right0_t2
    jsr put00_t2
    dec .count1
    bne .loo01

    lda #20
    sta .count1
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
.loo02
    jsr left0_t2
    jsr put00_t2
    dec .count1
    bne .loo02

    lda #32
    sta .count1
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
.loo03
    jsr right0_t2
    jsr put00_t2
    dec .count1
    bne .loo03

    lda #8
    sta .count1
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
.loo04
    jsr left0_t2
    jsr put00_t2
    dec .count1
    bne .loo04

    lda #120
    jsr delay

    lda #8
    sta .count1
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
.loo04b
    jsr right0_t2
    jsr put00_t2
    dec .count1
    bne .loo04b

    lda #32
    sta .count1
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
.loo03b
    jsr left0_t2
    jsr put00_t2
    dec .count1
    bne .loo03b

    lda #20
    sta .count1
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
.loo02b
    jsr right0_t2
    jsr put00_t2
    dec .count1
    bne .loo02b

    lda #24
    sta .count1
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
.loo01b
    jsr left0_t2
    jsr put00_t2
    dec .count1
    bne .loo01b

    lda #16
    sta .count1
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
.loo00b
    jsr right0_t2
    jsr put00_t2
    dec .count1
    bne .loo00b

    lda #8
    sta .count1
.loox
    lda #5
    jsr delay
    lda #2
    sta $d4
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #50
    jsr delay

    lda #2
    sta $d4
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #50
    jsr delay

    lda #2
    sta $d4
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr up0_t2
    jsr put00_t2
    lda #50
    jsr delay

    lda #-6
    sta $d4

    inc irq276.me+1
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    jsr remove_t2
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    jsr remove_t2
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    jsr remove_t2
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    jsr remove_t2
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    jsr remove_t2

    jsr sscroll_down4
    lda #<ltext1
    ldy #>ltext1
    jsr .seta
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    lda #<ltext2
    ldy #>ltext2
    jsr .seta
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    lda #<ltext3
    ldy #>ltext3
    jsr .seta
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    lda #<ltext4
    ldy #>ltext4
    jsr .seta
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    lda #<ltext5
    ldy #>ltext5
    jsr .seta
    ldy #s2ypos_off
    lda ($e6),y
    clc
    adc #3
    sta ($e6),y
    jsr put_t2
    inc irqX.me+1
    dec .count1
    beq *+5
    jmp .loox
    jmp .restart

.count1 byte 0

.seta
    sta $e6
    sty $e7
    clc
    adc #22
    sta $e2
    tya
    adc #0
    sta $e3
    ldy #20
    lda ($e6),y
    sta $e4
    iny
    lda ($e6),y
    sta $e5
    rts

   org $a000
   include "common.s"
   include "aux.s"
   ;include "sprite-lib1.s"
   ;include "text-lib1.s"
   include "sprite-lib2.s"
   include "text-lib2.s"
   include "sscroll.s"

ltext1_xsz = 6  ;hello
ltext1_ysz = 2
    sprite_t2 ltext1,ltext1_xsz*8,ltext1_ysz*8,16,10,1,1,1,1
ltext1_l_sl
ltext1_r_sl
ltext1_u_sl
ltext1_d_sl word data_ltext1_d1
saved_ltext1 ds ltext1_xsz*ltext1_ysz*64,$77
data_ltext1_d1
  ds ltext1_xsz*ltext1_ysz*64,0

ltext2_xsz = 5   ;world
ltext2_ysz = 1
      sprite_t2 ltext2,ltext2_xsz*8,ltext2_ysz*8,20,34,1,1,1,1
ltext2_l_sl
ltext2_r_sl
ltext2_u_sl
ltext2_d_sl word data_ltext2_d1
saved_ltext2 ds ltext2_xsz*ltext2_ysz*64,$77
data_ltext2_d1
  ds ltext2_xsz*ltext2_ysz*64,$55

ltext4_xsz = 4   ;DFLI
ltext4_ysz = 1
    sprite_t2 ltext4,ltext4_xsz*8,ltext4_ysz*8,24,26,1,1,1,1
ltext4_l_sl
ltext4_r_sl
ltext4_u_sl
ltext4_d_sl word data_ltext4_d1
saved_ltext4 ds ltext4_xsz*ltext4_ysz*64,$77
data_ltext4_d1
  ds ltext4_xsz*ltext4_ysz*64,$55

ltext5_xsz = 2  ;of
ltext5_ysz = 1
      sprite_t2 ltext5,ltext5_xsz*8,ltext5_ysz*8,32,42,1,1,1,1
ltext5_l_sl
ltext5_r_sl
ltext5_u_sl
ltext5_d_sl word data_ltext5_d1
saved_ltext5 ds ltext5_xsz*ltext5_ysz*64,$77
data_ltext5_d1
  ds ltext5_xsz*ltext5_ysz*64,$55

ltext3_xsz = 8  ;sprites!
ltext3_ysz = 1
      sprite_t2 ltext3,ltext3_xsz*8,ltext3_ysz*8,8,50,1,1,1,1
ltext3_l_sl
ltext3_r_sl
ltext3_u_sl
ltext3_d_sl word data_ltext3_d1
saved_ltext3 ds ltext3_xsz*ltext3_ysz*64,$77
data_ltext3_d1
  ds ltext3_xsz*ltext3_ysz*64,$55

freemem:

