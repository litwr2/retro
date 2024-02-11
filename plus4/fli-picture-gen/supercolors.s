super:
    lda #$10
    sta $e2
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    lda #-$10
    sta $e2
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jsr subr
    jmp super

subr:
    lda #0
    sta $e0
    sta $e1
lo1:lda $e1
    sta $d8
    ldy $e0
    lda #0
    jsr getabyte
    lda ($d0),y
    sec
    sbc $e2
    sta ($d0),y
    ldy $e0
    lda #3
    jsr getabyte
    lda ($d0),y
    clc
    adc $e2
    sta ($d0),y
    inc $e0
    bne *+4
    inc $e1
    lda $e1
    cmp #>VSIZE
    bcc lo1

    lda $e0
    cmp #<VSIZE
    bcc lo1
    rts
;    lda #4
;    jmp delay

