;for vasm assembler, oldstyle syntax
;
;The next code was made by litwr in 2025
;
;160x256 double buffer multicolor for the Commodore +4 or 116/16 (32K)

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

mp = $d0 ;+$d1
icnt = $d2
tmp = $d3
textbase = $2500

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

irqe3  pha    ;@206
       LDA #$EC
       STA $FF1D  ;236
       JSR comm1
       INC $FF09
.ab1 = * + 1
       LDA #$18
       STA $FF14

       lda $ff12
       and #3
       ORA #8    ;$2000
       STA $FF12
       inc $a5
       bne .l2

       inc $a4
       bne .l2

       inc $a3
.l2:   pla
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
       lda $ff12
       and #3
       sty .e1+1
       ldy #0

    pha  ;a delay, 13 ticks
    pla
    pha
    pla  ;+1, 14 actual

       ora #$10     ;$4000
       STA $FF12
       STY $FF1A
       LDA #40
       STA $FF1B

       dec icnt
       bne .e1

       lda #6
       sta icnt

.l6 ldy #0
    lda (mp),y
    bpl .l3

    cmp #$ff
    bne .l4

    sty icnt
    lda #<music
    sta mp
    lda #>music
    sta mp+1
    bne .e2  ;always

.l4 eor #$80
    sta $ff11
    inc mp
    bne *+4
    inc mp +1
    bne .l6  ;always

.l3 asl
    bpl .l1

    lsr  ;sets C=0
    and #3
    sta tmp
    lda $ff12
    and #$fc
    ora tmp
    sta $ff12
    iny
    lda (mp),y
    sta $ff0e
.l8 lda mp
    adc #2  ;C=0
    sta mp
    bcc *+4
    inc mp+1
    bne .l6  ;always

.l1 asl
    bpl .l5

    lsr
    lsr   ;sets C=0
    and #3
    sta $ff10
    iny
    lda (mp),y
    sta $ff0f
    bcc .l8  ;always

.l5 inc mp
    bne *+4
    inc mp +1

.e1    ldy #0
.e2    pla
       RTI

start:
    ldx #0
.iloop2
    lda $d400,x
    sta $d400,x
    lda $d500,x
    sta $d500,x
    lda $d600,x
    sta $d600,x
    lda $d700,x
    sta $d700,x
    inx
    bne .iloop2

.iloop3
    lda tripleem,x
    sta $d408,x
    inx
    cpx #8
    bne .iloop3

    lda #180
    sta icnt
    lda #<music
    sta mp
    lda #>music
    sta mp+1
       ;JSR waitkey
    sei
    STA $FF3F
    LDX #$3B
    STX $FF06
    LDX #$18
    STX $FF07
    LDA #BG
    STA $FF19
    JSR iniirq
    cli
       lda #MC1
       sta $ff15
       lda #MC2
       sta $ff16
    ldx #0
.iloop0
    lda $1800,x
    sta $800,x
    inx
    bne .iloop0

    inc .iloop0+2
    inc .iloop0+5
    lda .iloop0+5
    cmp #$10
    bne .iloop0
.iloop1
    lda $5300,x
    sta $5b00,x
    lda $5700,x
    sta $5f00,x
    lda $5000,x
    sta $5800,x
    lda $5400,x
    sta $5c00,x
    inx
    bne .iloop1

    jsr initext
.mloop
    lda #0
    sta .cc
.cloop
    tax
    lda .fgco,x
    and #15
    ora #(BG&0x0f)<<4
    sta buf0.ac
    lda .fgco,x
    and #$f0
    ora #BG>>4
    sta buf0.al

.clrow = * + 1
    ldy #0
    jsr lscroll
    inc .clrow
.crrow = * +1
    ldy #0
    jsr rscroll
    dec .crrow
    bpl .l2

    jsr initext
.l2 ldx #0
    lda .cbuf
    and #1
    bne .l1

    jsr .shift0
    jsr buf0
    jmp .l3

.l1 jsr .shift1
    jsr buf1
.l3 inc .cbuf
    ldy $ff1c
    iny
    bne *-4
  
    ldy $ff1c
    iny
    beq *-4
    
    ;ldy $ff1c
    ;iny
    ;bne *-4

    sta irqe3.ab1
    sta $ff14
    stx irqe2.ab2
    ldx .cc
    lda .mc1co,x
    sta $ff15
    lda .mc2co,x
    sta $ff16

    ;jsr waitkey
    inc .cc
    lda .cc
    cmp .cmax
    ;bne .cloop
    beq *+5
    jmp .cloop
    jmp .mloop

.shift0
    ldx #0
    ldy $181b,x
.shl0
    tya
    ldy $181c,x
    sta $181c,x
    sta $1844,x
    sta $186c,x
    inx
    cpx #12
    bne .shl0

    sty $181b
    sty $1843
    sty $186b
    rts

.shift1
    ldx #0
    ldy $81b,x
.shl1
    tya
    ldy $81c,x
    sta $81c,x
    sta $844,x
    sta $86c,x
    inx
    cpx #12
    bne .shl1

    sty $81b
    sty $843
    sty $86b
    rts

.cc byte 0
.cbuf byte 0
.cmax byte 12
.mc1co byte $6f,$6a,$59,$58,$48,$3b,$24,$1e,$3e,$46,$6d,$6c
.mc2co byte $53,$55,$58,$57,$57,$24,$3b,$32,$46,$4d,$3d,$3d
.fgco byte $59,$48,$42,$42,$3b,$3d,$3d,$4d,$4d,$53,$5c,$57

text db "3..  2..  1..  START", 1, " HAPPY NEW YEAR!  THIS IS MY 1ST PROGRAM FOR THE C+4 THAT PLAYS MUSIC.  THE TUNE IS TAKEN FROM THE OLD GOOD GAME HUSTLER.  I ALSO USED A FREE, ANONYMOUS ANIMATED GIF FROM THE NET AS THE BASIS FOR THE PICTURE.  WE CAN SEE PEOPLE RUNNING, BUT NO ONE ACTUALLY MOVES!  IT'S AN ILLUSION.  PERHAPS THE WORLD AROUND US IS AN ILLUSION TOO...  AND ALL OUR ACTIONS ARE NOTHING BUT VANITY OF VANITIES.  IT'S CRAZY AND AMAZING SIMULTANEOUSLY.  SO LET'S HAVE SOME MORE FUN!  ",0

tripleem db $49,$49,$49,$2a,$2a,0,$2a,0

initext: jsr getchar
    sta lscroll.char
    lda #0
    sta start.clrow
    lda #7
    sta start.crrow
    rts

outdirow:   ;Y-row, A-char (<128)
         sty .t2
         ldy #$d0>>3
         sty .t1
         asl
         sec  ;$d4
         rol .t1
         asl
         rol .t1
         asl
         rol .t1  ;set C=0
         tay
.t2 = * + 1
.t1 = * + 2
         lda $d400,y  ;chargen
         sta .t1
         ldx #0
.l6      ldy #4
.l4      bit .t1
         bpl .l5

         clc ;sec
         rol
         sec ;clc
         rol
         jmp .l3  ;always

.l5      sec ;clc
         rol
         clc ;sec
         rol
.l3      asl .t1
         dey
         bne .l4

         sta .chars,x
         inx
         cpx #2
         bne .l6
         rts
.chars byte 0,0

getchar: ldx .cpos
.mh = * + 2
         lda text,x
         bne .l1

         sta .cpos
         lda #>text
         sta .mh
         bne getchar  ;always

.l1      cmp #$60
         bcc *+4
         eor #$60
         inc .cpos
         bne *+5
         inc .mh
         rts
.cpos byte 0

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

  include "pic-mc.s"

  org $4a00
  macro sup
    ldx #0
.ml\@ lda \1+1,x
    sta \1,x
    lda \1+9,x
    sta \1+8,x
    inx
    cpx #7
    bne .ml\@
  endm
  macro supc
    lda \1+320
    sta \1+7
    lda \1+328
    sta \1+15
  endm
  macro supe
    sup \1
    supc \1
  endm
lscroll:  ;y - offset
    supe textbase
    supe textbase+320
    supe textbase+320*2
    supe textbase+320*3
    supe textbase+320*4
    supe textbase+320*5
    supe textbase+320*6
    supe textbase+320*7
    supe textbase+320*8
    supe textbase+320*9
    supe textbase+320*10
    supe textbase+320*11
    supe textbase+320*12
    supe textbase+320*13
    supe textbase+320*14
    sup textbase+320*15
.char = * + 1
    lda #0
    jsr outdirow
    lda outdirow.chars
    sta textbase+320*15+7
    lda outdirow.chars+1
    sta textbase+320*15+15
    rts

  macro sdown
    ldx #6
.ml\@ lda \1,x
    sta \1+1,x
    lda \1+8,x
    sta \1+9,x
    dex
    bpl .ml\@
  endm
  macro sdownc
    lda \1-320+7
    sta \1
    lda \1-312+7
    sta \1+8
  endm
  macro sdowne
    sdown \1
    sdownc \1
  endm
rshift = 38*8
rscroll:  ;y - offset
    sdowne textbase+320*15+rshift
    sdowne textbase+320*14+rshift
    sdowne textbase+320*13+rshift
    sdowne textbase+320*12+rshift
    sdowne textbase+320*11+rshift
    sdowne textbase+320*10+rshift
    sdowne textbase+320*9+rshift
    sdowne textbase+320*8+rshift
    sdowne textbase+320*7+rshift
    sdowne textbase+320*6+rshift
    sdowne textbase+320*5+rshift
    sdowne textbase+320*4+rshift
    sdowne textbase+320*3+rshift
    sdowne textbase+320*2+rshift
    sdowne textbase+320+rshift
    sdown textbase+rshift
    lda lscroll.char
    jsr outdirow
    lda outdirow.chars
    sta textbase+rshift
    lda outdirow.chars+1
    sta textbase+8+rshift
    rts

  org $6000
buf0:
.al = * + 1
    lda #0
.ac = * + 1
    ldx #0
    include "pic-mc-fg0.s"
    lda #$18
    ldx #$50
    rts

buf1:
    lda buf0.al
    ldx buf0.ac
    include "pic-mc-fg1.s"
    lda #$8
    ldx #$58
    rts

music:
  include "music.s"

