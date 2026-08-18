.include "cbm35basic.mac"
drawmline = $12dc
;fmplot = $1100
;gmplot = $1250

    * = $4001
.byte $18,$40,$a,0,$de  ;graphic
.text "4,1:"
.byte $e7  ;color
.text "0,5,3:"
.byte $9e  ;sys
.text "16512"
.byte 0,0,0

* = $4080

start
    lda #0
    sta r3l
    sta r9l
    sta rah
iter = 40
cs = 1
    lda #$74
    sta $ff15   ;color0
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
    lda #0
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

