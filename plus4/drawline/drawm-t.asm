;tmpx assembler
.include "registers.mac"
gabase = $18   ;attributes
gbase = $20    ;bitmap

test1 = 1  ;main
test2 = 0  ;diagonal line benchmark, it uses cs
test3 = 0  ;vector sight, it uses cs and iter
cs = 1     ;0 - mc1, 1 - fg, 2 - bg, 3 - mc2
iter = 40  ;vector length

    * = $1001
.byte <(eob-2),>(eob-2),$a,0
.byte $9e  ;sys
.text "4160:"  ;$1040
.byte $de  ;graphic
.text "3,1:"
.byte $41,$b2,$54,$49  ;a=ti
.text ":"
.byte $9e  ;sys
.text "4224:"  ;$1080
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
    ;lda #$74
    ;sta $ff15   ;color0
    ;lda #$73
    ;sta $86   ;color1
    lda #$45
    sta $85   ;color2
    lda #$44
    sta $ff16   ;color3
.if test1
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
    sta rch
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
 .if test2
x0i = 159
y0i = 199
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
    lda #cs
    sta rch
    jsr drawmline
    pla
    clc
    adc #1
    bne gl1
.endif
.if test3
x0i = 80
y0i = 100
    lda #x0i
    sta x1
    lda #y0i
    sta y1
    lda #cs
    sta pcs
    lda #0
gl3 pha
    lda x1  ;dx=0, dy--
    sta r8l
    sta r2l
    lda y1
    sta r1h
    sec
    sbc #iter
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx++, dy--
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    sbc #iter-1  ;C=0
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx++, dy=0
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx++, dy++
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    adc #iter  ;C=0
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx=0, dy++
    sta r8l
    sta r2l
    lda y1
    sta r1h
    clc
    adc #iter
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx--, dy++
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    adc #iter-1  ;C=1
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx--, dy=0
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    sta r6h
    lda pcs
    sta rch
    jsr drawmline

    lda x1  ;dx--, dy--
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    sbc #iter  ;C=1
    sta r6h
    lda pcs
    sta rch
    jsr drawmline
;--
    lda x1  ;dx=0, dy--
    sta r8l
    sta r2l
    lda y1
    sta r1h
    sec
    sbc #iter
    sta r6h
    lda #0
    sta rch
    jsr drawmline

    lda x1  ;dx++, dy--
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    sbc #iter-1  ;C=0
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx++, dy=0
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx++, dy++
    sta r8l
    clc
    adc #iter
    sta r2l
    lda y1
    sta r1h
    adc #iter  ;C=0
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx=0, dy++
    sta r8l
    sta r2l
    lda y1
    sta r1h
    clc
    adc #iter
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx--, dy++
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    adc #iter-1  ;C=1
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx--, dy=0
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline

    lda x1  ;dx--, dy--
    sta r8l
    sec
    sbc #iter
    sta r2l
    lda y1
    sta r1h
    sbc #iter  ;C=1
    sta r6h
    ;lda pcs
    ;sta rch
    jsr drawmline
;--
    lda $ff1e
    lsr
    lsr
    and #3
    tax
    lda crnd,x
    clc
    adc x1
    sta x1

    lda $ff1e
    lsr
    lsr
    and #3
    tax
    lda crnd,x
    clc
    adc y1
    sta y1

    lda $ff1e
    lsr
    and #3
    bne *+4
    lda #1
    sta pcs

    pla
    tax
    inx
    txa
    beq *+5
    jmp gl3
.endif
    rts

x1 .byte 0
y1 .byte 0
pcs .byte 0
crnd .byte 255,1,255,1

.include "mul40.inc"
.include "drawm.inc"

