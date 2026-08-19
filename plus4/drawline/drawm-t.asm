.include "registers.mac"

    * = $1001
.byte <(eob-2),>(eob-2),$a,0
.byte $9e  ;sys
.text "4160:"
.byte $41,$b2,$54,$49  ;a=ti
.text ":"
.byte $de  ;graphic
.text "3,1:"
.byte $9e  ;sys
.text "4224:"
.byte $99,$54,$49,$ab,$41  ;print ti-a
;.byte $a1,$f9,$41,$24  ;getkeya$
.text ":"
.byte $de  ;graphic
.text "0"
.byte 0,0,0
eob

* = $1040
init
    lda #<eob
    sta $2d
    sta $2f
    sta $31
    lda #>eob
    sta $2e
    sta $30
    sta $32
    rts

* = $1080
start
    lda #0
    sta r3l
    sta r9l
    sta rah
iter = 40
cs = 1
    ;lda #$74
    ;sta $ff15   ;color0
    ;lda #$73
    ;sta $86   ;color1
    lda #$45
    sta $85   ;color2
    lda #$44
    sta $ff16   ;color3
.if 1
    lda #5
l1  pha
    lda #0
l2  sta x1
    sta r8l
    lda #159
    sec
    sbc x1
    sta r2l
    lda #0
    sta r1h
    lda #199
    sta r6h
    lda $ff1e
    lsr
    and #3
    jsr drawmline
    lda x1
    clc
    adc #4
    cmp #160
    bcc l2

    pla
    tax
    dex
    txa
    bne l1    
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

x1 .byte 0

.include "mul40.inc"
.include "drawm.inc"

