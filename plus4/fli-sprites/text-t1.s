;for vasm assembler, oldstyle syntax

HILEV1 = 0

test:
  if 0
    lda #<text1
    sta $e6
    lda #>text1
    sta $e7
    lda #<data_text1_d1
    sta $e4
    sta $d2
    lda #>data_text1_d1
    sta $e5
    sta $d3
    lda #<($d000+4*8)
    sta $d0
    lda #>($d000+4*8)
    sta $d1
    lda #20
    sta $d5
    ldy #$55
    sty $da
    ldx #$aa
    stx $d9
    jsr get_glyph_t1
  endif
    lda #<text1
    sta $e6
    lda #>text1
    sta $e7
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text1_d1
  byte $aa,$55   ;bg, fg
  byte text1_xsz   ;length
  byte " ","H"-64,"e"+32,"l"+32,"l"+32,"o"+32," "  ;text
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text1_d1+text1_xsz*16
  byte $55,$00   ;bg, fg
  byte text1_xsz   ;length
  byte "160","x"+32,"256"  ;text 
    lda #<text4
    sta $e6
    lda #>text4
    sta $e7
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text4_d1
  byte $aa,$55   ;bg, fg
  byte text4_xsz   ;length
  byte "D"-64,"F"-64,"L"-64,"I"-64  ;text

    lda #<text5
    sta $e6
    lda #>text5
    sta $e7
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text5_d1
  byte $00,$aa   ;bg, fg
  byte text5_xsz   ;length
  byte "o"+32,"f"+32  ;text

    lda #<text2
    sta $e6
    lda #>text2
    sta $e7
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text2_d1
  byte $00,$aa   ;bg, fg
  byte text2_xsz   ;length
  byte "W"-64,"O"-64,"R"-64,"L"-64,"D"-64  ;text

    lda #<text3
    sta $e6
    lda #>text3
    sta $e7
    jsr put_gl_t1
  byte 1   ;rom
  word $d000   ;cg
  word data_text3_d1
  byte $00,$55   ;bg, fg
  byte text3_xsz   ;length
  byte "S"-64,"P"-64,"R"-64,"I"-64,"T"-64,"E"-64,"S"-64,"!"  ;text

    ;jsr waitkey
    lda #<text3
    sta $e6
    lda #>text3
    sta $e7
    jsr put_t1
    lda #<text1
    sta $e6
    lda #>text1
    sta $e7
    jsr put_t1
    lda #<text4
    sta $e6
    lda #>text4
    sta $e7
    jsr put_t1
    lda #<text2
    sta $e6
    lda #>text2
    sta $e7
    jsr put_t1
    lda #<text5
    sta $e6
    lda #>text5
    sta $e7
    jsr put_t1
    ;jsr waitkey
    lda #200
    jsr delay
.loo0
    lda #70
    sta .count2
.loo
    lda #<text1
    ldx #>text1
    jsr .seta
    jsr up0_t1
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text4
    ldx #>text4
    jsr .seta
    jsr up0_t1
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text2
    ldx #>text2
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text5
    ldx #>text5
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text3
    ldx #>text3
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr put00_t1

    dec .count2
    beq *+5
    jmp .loo

    lda #120
    jsr delay
.shift = 180
    lda #<text1
    sta $e6
    lda #>text1
    sta $e7
    jsr remove_t1
    ldy #sypos_off
    lda ($e6),y
    sec
    sbc #.shift
    sta ($e6),y
    jsr put_t1

    lda #.shift
    sta .count2
    lda #<text4
    ldx #>text4
    jsr .seta
.loo1
    jsr up0_t1
    ldy #17
    jsr put_t1c.e
    jsr put00_t1
    dec .count2
    bne .loo1

    lda #.shift/2
    sta .count2
.loo2
    lda #<text2
    ldx #>text2
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr up0_t1
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text5
    ldx #>text5
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr up0_t1
    ldy #17
    jsr put_t1c.e
    jsr put00_t1

    lda #<text3
    ldx #>text3
    jsr .seta
    ;jsr up0_t1
    ldy #sypos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr up0_t1
    ;ldy #17
    ;jsr put_t1c.e
    jsr put00_t1
    dec .count2
    bne .loo2

    lda #20
    sta .count2
    lda #<text3
    ldx #>text3
    jsr .seta
.loo4
    ;jsr right0_t1
    ldy #sxpos_off
    byte $f3,$e6    ;incsbc ($e6),y
    jsr put00_t1
    dec .count2
    bne .loo4

    lda #20
    sta .count2
    lda #<text2
    ldx #>text2
    jsr .seta
.loo3
    ;jsr left0_t1
    ldy #sxpos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr put00_t1
    dec .count2
    bne .loo3

    lda #20
    sta .count2
    lda #<text5
    ldx #>text5
    jsr .seta
.loo5
    ;jsr right0_t1
    ldy #sxpos_off
    byte $f3,$e6    ;incsbc ($e6),y
    jsr right0_t1
    jsr put00_t1
    dec .count2
    bne .loo5

    lda #100
    jsr delay

    lda #40
    sta .count2
    lda #<text5
    ldx #>text5
    jsr .seta
.loo8
    ;jsr left0_t1
    ldy #sxpos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr put00_t1
    dec .count2
    bne .loo8

    lda #20
    sta .count2
    lda #<text3
    ldx #>text3
    jsr .seta
.loo7
    ;jsr left0_t1
    ldy #sxpos_off
    byte $d3,$e6    ;deccmp ($e6),y
    jsr put00_t1
    dec .count2
    bne .loo7

    lda #20
    sta .count2
    lda #<text2
    ldx #>text2
    jsr .seta
.loo6
    ;jsr right0_t1
    ldy #sxpos_off
    byte $f3,$e6    ;incsbc ($e6),y
    jsr put00_t1
    dec .count2
    bne .loo6
    jmp .loo0

.count2 byte 0

.seta
    sta $e6
    clc
    adc #20
    sta $e4
    txa
    sta $e7    
    adc #0
    sta $e5
    rts

   org $a000
   include "common.s"
   include "aux.s"
   include "sprite-lib1.s"
   include "text-lib1.s"
   ;include "sprite-lib2.s"
   ;include "sprlib/s6.s"

  if 0
make_sprite_t1: ;e6-e7 - addr, A - xsize, X - ysize, d5 - x, d6 - y
    ldy #0
    sta ($e6),y
    iny
    txa
    sta ($e6),y
    iny
    lda $d5
    sta ($e6),y
    iny
    lda $d6
    sta ($e6),y
    ldx #4
    lda #1
.l1 iny
    sta ($e6),y
    dex
    bne .l1

    txa
    ldx #4
.l2 iny
    sta ($e6),y
    dex
    bne .l2

    lda #16
    ldx #4
.l3 iny
    sta ($e6),y
    dex
    bne .l3

    iny
    rts
  endif

text1_xsz = 7  ;hello // 160x256
text1_ysz = 2
    sprite_t1 text1,text1_xsz*8,text1_ysz*8,52,8,1,1,1,1
text1_l_sl
text1_r_sl
text1_u_sl
text1_d_sl word data_text1_d1
        word color_text1_d1
data_text1_d1
  ds text1_xsz*text1_ysz*16,$55
color_text1_d1
  byte $00,$00,$00,$00,$00,$00,$00,$00,$43,$43,$43,$43,$43,$43,$43,$43
  byte $05,$15,$25,$35,$45,$55,$65,$75,$05,$15,$25,$35,$45,$55,$65,$75

text4_xsz = 4   ;DFLI
text4_ysz = 1
    sprite_t1 text4,text4_xsz*8,text4_ysz*8,64,25,1,1,1,1
text4_l_sl
text4_r_sl
text4_u_sl
text4_d_sl word data_text4_d1
        word color_text4_d1
data_text4_d1
  ds text4_xsz*text4_ysz*16,$55
color_text4_d1
  byte $7d,$6d,$5d,$4d,$3d,$2d,$1d,$0d
  byte $02,$12,$22,$32,$42,$52,$62,$72

text2_xsz = 5   ;world
text2_ysz = 1
      sprite_t1 text2,text2_xsz*8,text2_ysz*8,26,44,1,1,1,1
text2_l_sl
text2_r_sl
text2_u_sl
text2_d_sl word data_text2_d1
        word color_text2_d1
data_text2_d1
  ds text1_xsz*text1_ysz*16,$55
color_text2_d1
  byte $01,$11,$21,$31,$41,$51,$61,$71
  byte $07,$17,$27,$37,$47,$57,$67,$77

text5_xsz = 2  ;of
text5_ysz = 1
    sprite_t1 text5,text5_xsz*8,text5_ysz*8,38,54,1,1,1,1
text5_l_sl
text5_r_sl
text5_u_sl
text5_d_sl word data_text5_d1
        word color_text5_d1
data_text5_d1
  ds text5_xsz*text5_ysz*16,$55
color_text5_d1
  byte $41,$51,$61,$71,$01,$11,$21,$31
  byte $0e,$1e,$2e,$3e,$4e,$5e,$6e,$7e

text3_xsz = 8  ;sprites!
text3_ysz = 1
      sprite_t1 text3,text3_xsz*8,text3_ysz*8,76,48,1,1,1,1
text3_l_sl
text3_r_sl
text3_u_sl
text3_d_sl word data_text3_d1
        word color_text3_d1
data_text3_d1
  ds text3_xsz*text3_ysz*16,$55
color_text3_d1
  byte $01,$11,$21,$31,$41,$51,$61,$71
  byte $05,$15,$25,$35,$45,$55,$65,$75

freemem:

