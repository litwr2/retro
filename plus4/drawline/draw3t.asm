.include "cbm35basic.mac"
gabase = $18
gbase = $20
r6l = $14
r6h = $15
r7l = $39
r7h = $3a
r8l = 3
r8h = 4
drawhline = $1218
drawmline = $12fc

    * = $4001
.byte $18,$40,$a,0,$de  ;graphic
.text "4,1:"
.byte $e7  ;color
.text "0,5,3:"
.byte $9e  ;sys
.text "16442"
.byte 0,0,0

.repeat 32,0

start
.if 0
x0i = 0
x1i = 319
y0i = 158
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
    bne gl1
.endif
.if 0
x0i = 159
x1i = 0
y0i = 158
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
    bne gl1
.endif
.if 1
xi = 0
yi = 0
;in x - r8l, y - r1h, a = cs (0 - mc1, 1 - bg, 2 - fg, 3 - mc2); use r0l, r5, r8h
    lda #xi
    sta r8l
    lda #yi
    sta r1h
    lda #1
    jsr gmplot
.endif
    rts

