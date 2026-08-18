.include "registers.mac"

    * = $4001
.byte $19,$40,$a,0,$de  ;graphic
.text "3,1:"
.byte $9e  ;sys
.text "16512:"
.byte $a1,$f9,$41,$24  ;getkeya$
.text ":"
.byte $de  ;graphic
.text "0"
.byte 0,0,0

* = $4080

start
    lda #0
    sta r3l
    sta r9l
    sta rah
iter = 40
cs = 1
    ;lda #$74
    ;sta $ff15   ;color0
    lda #$73
    sta $86   ;color1
    lda #$36
    sta $85   ;color2
    lda #$5e
    sta $ff16   ;color3
.if 1
x0i = 159
y0i = 159
x1i = 0
y1i = 0
    lda #0
gl1 pha
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #x1i
    sta r2l
    lda #y1i
    sta r6h
    lda #1
    jsr drawmline
    pla
    clc
    adc #1
    ;bne gl1
.endif
.if 0
x0i = 76
y0i = 72
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #$0
    ldy #$80
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #1
    ldy #$80
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #1
    ldy #$0
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #$1
    ldy #$1
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #0
    ldy #$1
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #$80
    ldy #$1
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1    pha
    ldx #$80
    ldy #$0
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #x0i
    sta r8l
    lda #y0i
    sta r1h
    lda #cs
    jsr gmplot
    lda #iter
l1  pha
    ldx #$80
    ldy #$80
    jsr fmplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.endif
    rts

.include "draw8.asm"

