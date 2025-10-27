;for vasm6502/oldstyle

get_glyph_t1:  ;ZF - 0/1 - ROM/RAM; $d0-d1 - from addr, $d2-d3 - to addr, $d9 - bg, $da - fg, $d5 - xsz
               ;uses: $66-68; modifies: $66-68, $d0-d3
    beq .subr

.l2 lda $ff1d
    cmp #<303  ;ntsc!
    bne .l2

    lda $ff1c
    and #1
    beq .l2

    ldy #7
.l6 jsr rombyte
    sta $100,y
    dey
    bpl .l6

    iny
    sty $d0
    iny
    sty $d1
.subr
    lda #8
    sta $67
    lda #0
    sta $68
.l5 ldy $68
    inc $68
    lda ($d0),y
    jsr .subr1  ;sets X=0
    lda $66
    sta ($d2,x)  ;X=0
    tya
    jsr .subr1
    lda $66
    ldy #1
    sta ($d2),y
    lda $d5
    clc
    adc $d2
    sta $d2
    bcc *+4
    inc $d3
    dec $67
    bne .l5
    rts

.subr1
.l4 ldx #4
.l3 asl
    tay
    lda $d9
    bcc *+4
    lda $da
    asl
    rol $66
    asl
    rol $66
    tya
    dex
    bne .l3
    rts

put_gl_t1: ;list: RAM/ROM(1,0), base_in (2,1), base_out(2,3), bg(1,5), fg(1,6), #(1,7), chars(#,8)...
           ;uses: $66-6a, $d0-d3, $d5-$d7, $d9-da, $dd
    pla
    tax
    pla
    tay
    inx
    bne *+3
    iny
    stx $d6
    sty $d7  ;the list base
    clc
    txa
    adc #8
    sta $69
    bcc *+3
    iny
    sty $6a  ;the char base

    ldy #7
    lda ($d6),y
    sta $dd  ;counter
    ldy #sxsize_off
    lda ($e6),y
    lsr
    lsr
    sta $d5
.l7 ldy #0
    lda ($69),y
    sty $66
    asl
    rol $66
    asl
    rol $66
    asl
    rol $66
    iny
    adc ($d6),y  ;C=0, Y=1
    sta $d0
    lda $66
    iny
    adc ($d6),y  ;Y=2
    sta $d1
    iny
    lda ($d6),y  ;Y=3
    sta $d2
    iny
    lda ($d6),y  ;Y=4
    sta $d3
    iny
    lda ($d6),y  ;Y=5
    sta $d9  ;bg
    iny
    lda ($d6),y  ;Y=6
    sta $da  ;fg
    ldy #0
    lda ($d6),y
    jsr get_glyph_t1
    inc $69
    bne *+4
    inc $6a
    ldy #3
    lda ($d6),y
    clc
    adc #2
    sta ($d6),y
    iny
    lda ($d6),y
    adc #0
    sta ($d6),y
    dec $dd
    bne .l7
    jmp ($69)

