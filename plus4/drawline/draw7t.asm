.include "registers.mac"

    * = $1001
.byte <(eob-2),>(eob-2),$a,0
.byte $9e  ;sys
.text "4160:"
.byte $41,$b2,$54,$49  ;a=ti
.text ":"
.byte $de  ;graphic
.text "1,1:"
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
    ;lda #$35
    ;sta $86   ;color1
    ;lda #$58
    ;sta $ff15  ;color0
.if 1
    lda #5
l1  pha
    lda #0
    sta x1+1
l2  lda x1
    sta r8l
    lda x1+1
    sta r8h
    lda #<319
    sec
    sbc x1
    sta r2l
    lda #>319
    sbc x1+1
    sta r2h
    lda #0
    sta r1h
    lda #199
    sta r6h
    lda $ff1e
    lsr
    and #1
    jsr drawhline
    lda x1
    clc
    adc #4
    sta x1
    bcc *+5
    inc x1+1
    lda x1+1
    beq l2

    lda x1
    cmp #<320
    bcc l2

    pla
    tax
    dex
    txa
    bne l1    
.endif
.if 0
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

x1 .byte 0,0

.include "draw7.asm"

