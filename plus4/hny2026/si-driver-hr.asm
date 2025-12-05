;for vasm assembler, oldstyle syntax
;
;The next code was made by litwr in 2025
;
;320x256 double buffer HiRes for the Commodore +4

; text data for 32 rows, buffer 0:
;    $1800 - 1be7, $1c00 - 1fe7  1000 chars  y = 0..199
;    $53e8 - 53ff, $57e8 - 57ff    24 chars  y = 200..207, x = 0..191
;    $5000 - 50ff, $5400 - 54ff   256 chars  y = 200..207, x = 192..319; y = 208..255
; text data for 32 rows, buffer 1:
;    $0800 - 0be7, $0c00 - 0fe7  1000 chars  y = 0..199
;    $5be8 - 5bff, $5fe8 - 5fff    24 chars  y = 200..207, x = 0..191
;    $5800 - 58ff, $5c00 - 5cff   256 chars  y = 200..207, x = 192..319; y = 208..255
; graph data for 32 rows:
;    $2000 - 3f3f  8000 bytes, y = 0..199
;    $4140 - 49ff  2240 bytes, y = 200..255

BSOUT = $FFD2
JPRIMM = $FF4F

bcolor = $41

   org $1001
   word eobp
   word 10
   byte $9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0
eobp
   byte 0,0

irqe1  pha      ;@284
       LDA #$36
       STA $FF1D    ;310
       LDA #$CA		;202
       STA $FF0B
       LDA #$A2		;0 - hi byte
       STA $FF0A
       LDA #<irqe2
       STA $FFFE
       pla
irqe0  INC $FF09
       RTI

irqe2  pha      ;@202
       LDA #$92
       STA $FF1D
       LDA #$CE		;206
       STA $FF0B
       LDA #<irqe3
       STA $FFFE
.ab2 = * + 1
       LDA #$50
       STA $FF14
       INC $FF09

    pha  ;a delay
    pla
    pha
    pla
    pha
    pla
    nop
    nop

       LDA #$10     ;$4000
       STA $FF12
       ;LDA #0
       STA $FF1A
       LDA #40
       STA $FF1B
       pla
       RTI

irqe3  pha    ;@206
       LDA #$EC
       STA $FF1D  ;236
       JSR comm1
       INC $FF09
.ab1 = * + 1
       LDA #$18
       STA $FF14

       LDA #8    ;$2000
       STA $FF12
       inc $a5
       bne .l2

       inc $a4
       bne .l2

       inc $a3
.l2:   pla
       RTI

start: JSR JPRIMM
       byte 9,14,"**************************************",13
       byte "*             ILLUSIONS              *",13
       byte "**************************************",13
       byte 'pRESS A KEY',0
       ;JSR waitkey

    STA $FF3F
    LDX #$3B
    STX $FF06
    LDX #8
    STX $FF07
    LDA #bcolor
    STA $FF19
    JSR iniirq
       JSR waitkey
.mloop
    lda #0
    sta .cc
.cloop
    tax
    lda .colors,x
    asl
    asl
    asl
    asl
    ora #bcolor&0xf
    sta buf0.ac
    lda .colors,x
    lsr
    lsr
    lsr
    lsr
    ora #bcolor&0xf0
    sta buf0.al
    ldx #0
    lda .cbuf
    and #1
    bne .l1

    jsr buf0
    jmp .l3

.l1 jsr buf1
.l3 inc .cbuf
    ldy $ff1c
    iny
    bne *-4
    ldy $ff1c
    iny
    beq *-4
    ldy $ff1c
    iny
    bne *-4
    sta irqe3.ab1
    sta $ff14
    stx irqe2.ab2

    inc .cc
    lda .cc
    cmp .cmax
    bne .cloop
    jmp .mloop

.cc byte 0
.cbuf byte 0
.cmax byte 12
.colors byte $6f, $6a, $59, $58, $48, $3b, $24, $1e, $3e, $46, $5d, $6c
;.colors byte $62, $65, $58, $64, $5d, $4b, $24, $69, $68, $6b, $71, $4e

buf0:
.al = * + 1
    lda #0
.loop1
    sta $1800,x
    sta $1900,x
    sta $1a00,x
    sta $5000,x
    inx
    bne .loop1

    ldx #$e8
    dex
    sta $1b00,x
    bne *-4

    ldx #$e8
    sta $5300,x
    inx
    bne *-4
.ac = * + 1
    lda #0
    ;ldx #0
.loop2
    sta $1c00,x
    sta $1d00,x
    sta $1e00,x
    sta $5400,x
    inx
    bne .loop2

    ldx #$e8
    dex
    sta $1f00,x
    bne *-4

    ldx #$e8
    sta $5700,x
    inx
    bne *-4
    lda #$18
    ldx #$50
    rts

buf1:
    lda buf0.al
.loop1
    sta $800,x
    sta $900,x
    sta $a00,x
    sta $5800,x
    inx
    bne .loop1

    ldx #$e8
    dex
    sta $b00,x
    bne *-4

    ldx #$e8
    sta $5b00,x
    inx
    bne *-4

    lda buf0.ac
    ;ldx #0
.loop2
    sta $c00,x
    sta $d00,x
    sta $e00,x
    sta $5c00,x
    inx
    bne .loop2

    ldx #$e8
    dex
    sta $f00,x
    bne *-4

    ldx #$e8
    sta $5f00,x
    inx
    bne *-4
    lda #$8
    ldx #$58
    rts

iniirq:LDA #>irqe1
       STA $FFFF
comm1: LDA #<irqe1
       STA $FFFE
       LDA #$1C     ;$11c = 284
       STA $FF0B
       LDA #$A3		;1 - hi byte, raster irq only
       STA $FF0A
       RTS

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

getkmtrix:
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
.l2 jsr getkmtrix
    ldx #7
    lda #$ff
.l1 and kmatrix,x
    dex
    bpl .l1

    cmp #$ff
    beq .l2
   rts

  include "pic.s"

