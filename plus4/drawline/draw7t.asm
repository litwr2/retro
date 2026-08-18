.include "cbm35basic.mac"
drawhline = $12b2
;ghplot = $121e
;fhplot0 = $128e

    * = $4001
.byte $18,$40,$a,0,$de  ;graphic
.text "2,1:"
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
.if 1
x0i = 319
x1i = 0
y0i = 159
y1i = 0
    lda #0
gl1 pha
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #<x1i
    sta r2l
    lda #>x1i
    sta r2h
    lda #y1i
    sta r6h
    lda #1
    jsr drawhline
    pla
    clc
    adc #1
    ;bne gl1
.endif
.if 0
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #$35
    sta $86
    ;lda #$58
    ;sta $ff15
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #$0
    ldy #$80
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #1
    ldy #$80
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #1
    ldy #$0
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #$1
    ldy #$1
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #0
    ldy #$1
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #$80
    ldy #$1
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #$80
    ldy #$0
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.block
    lda #<x0i
    sta r8l
    lda #>x0i
    sta r8h
    lda #y0i
    sta r1h
    lda #cs
    jsr ghplot
    lda #iter
l1    pha
    ldx #$80
    ldy #$80
    jsr fhplot
    pla
    tax
    dex
    txa
    bne l1
.bend
.endif
    rts

