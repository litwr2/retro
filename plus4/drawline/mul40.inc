mul40   ;in y; out r5h:a, C=0
.block
    lda #0
    sta r5h
    sty m1
    tya
    asl
    rol r5h
    asl
    rol r5h
m1 = * + 1
    adc #0
    bcc *+4
    inc r5h
    asl
    rol r5h
    asl
    rol r5h
    asl
    rol r5h
.bend
    rts
