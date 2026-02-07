  if 0
gm byte 0
getkey:
    lda #$7f
.l0 tax
    stx $fd30
    stx $ff08
    ldx $ff08
    cpx #$ff
    bne .l1

    ror  ;C=1
    bcs .l0
    bcc getkey
.l1
    ldy #$ff
    lsr
    iny
    bcs *-2

    txa
    ldx #$ff
    lsr
    inx
    bcs *-2

    stx gm
    tya
    asl
    asl
    asl
    asl
    ora gm
    sta gm
    rts
  endif

kmatrix blk 8
;   0   1   2   3   4   5   6   7  $ff08
;0 del ret ukp hlp f1  f2  f3   @
;1  3   W   A   4   Z   S   E  sht
;2  5   R   D   6   C   F   T   X
;3  7   Y   G   8   B   H   U   V
;4  9   I   J   0   M   K   O   N
;5 cd   P   L  cu   .   :   -   ,
;6 cl   *   ;  cr  esc  =   +   /
;7  1  clr ctr  2  spc cbm  Q  run

getkmatrix:
    ldx #7
    lda #$7f
    sec
.l1 sta $fd30
    sta $ff08
    pha
    lda $ff08
    sta kmatrix,x
    pla
    dex
    ror
    bcs .l1
    rts

waitkey:
.l2 jsr getkmatrix
    ldx #7
    lda #$ff
.l1 and kmatrix,x
    dex
    bpl .l1

    cmp #$ff
    beq .l2
    rts

delay:    ;delay AC frame ticks (50/60 Hz for PAL/NTSC), the actual accuracy is about 1/2 of frame tick, uses AC
     clc
     adc $a5
     cmp $a5
     bne *-2
     rts
