;for vasm6502/oldstyle
;bitmap+attr
; 0: $4000-413f    $2800-2827  $3000  $3800  $9000
; 1: $4140-427f    $2828-284f
;23: $5cc0-5dff    $2b98-2bbf
;24: $7e00-7f3f    $9bc0-9be7  $7000  $8000  $8800
;25: $7f40-7fff    $9be8-9bff
;    $6000-607f    $9800-980f
;26: $6080-61c0    $9810-9837
;28: $6300-643f    $9860-9887
;31: $66c0-67ff    $98d8-98ff
;32: $6800-693f    $9900-9927
;33: $6940-6a7f    $9928-994f
;34: $6a80-6bbf    $9950-9977
;line 202 gets -56 = 146
;line 206 gets +30 = 236 interrupt
;line 284 gets +26 = 310 interrupt

;the library uses zp locations $d0-d7, $d5 is just reserved

VSIZE = 256  ;value less than 225 makes images compatible with both PAL and NTSC
             ;this value must be a multiple of 8 and in the range 200-280

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

     macro setmc
     lda #\1     ;3x,$9a - 4x,$ca
     sta $ff15   ;3x,$a2 - 4x,$9a
     lda #\2     ;3x,$ae - 4x,$aa
     sta $ff16   ;3x,$b2 - 4x,$ae
     endm

     macro gap
     setmc $24,$25
     nop   ;3x,$b8
     nop   ;3x,$bc
     nop   ;3x,$c0
     nop   ;4x,$c4
     setmc $26,$27
     endm

     macro zline
     lda #$3d
     sta $ff06   ;$b8, it sets the value at $be
     lda #\1
     sta $ff14

     gap

     lda #$3f
     sta $ff06
     lda #\2
     sta $ff14

     gap

     lda #$39
     sta $ff06
     lda #\3
     sta $ff14

     gap

     lda #$3b
     sta $ff06
     lda #\4
     sta $ff14
     endm

     macro iline
     gap
     zline \1,\2,\3,\4
     endm

start:
     lda #0
     sta $ff19   ;border color
     nop
     nop
     jsr init

     sei
     sta $ff3f
     lda #2
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq2
     sta $fffe
     lda #>irq2
     sta $ffff
     cli
     jmp main

irq2:
     pha
     LDA  $FF1E
     AND  #$3E
     lsr
     LSR
     STA *+4
     BPL *
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  $EA

     nop
     nop
     stx .savex+1
     sty .savey+1
     lda #$10     ;bitmap at $4000
     sta $ff12

     lda $ea
     nop
     nop
     ldx #$24
     ldy #$25
BA = *+1
  rept 23          ;starts at 3:$96
     iline $30,$38,$90,$28
  endr
     iline $30,$38,$90,$98

     stx $ff15
     sty $ff16
     lda #$18   ;$b0, bitmap at $6000
     sta $ff12  ;$b4
     lda #396-VSIZE   ;$bc
     sta $ff1d  ;$c0, it sets the value at $c6
     lda #$26   ;$c8
     sta $ff15  ;$96
     lda #$27   ;$a6
     sta $ff16
  if VSIZE > 200
     zline $70,$80,$88,$98

  rept VSIZE/8-26
     iline $70,$80,$88,$98
  endr
     iline $70,$80,$88,$28
  else
     zline $70,$80,$88,$28
  endif

     lda #205
     sta $ff0b
     lda $d4
     beq .nosc

     clc
     adc irq205.sc+1
     sta irq205.sc+1
     ldx $d4
     dex
     txa
     eor #$ff
     clc
     adc irq276.sc+1
     sta irq276.sc+1
     lda #0
     sta $d4
.nosc:   
     lda #<irq205
     sta $fffe
     lda #>irq205
     sta $ffff
.savex:
     ldx #0
.savey:
     ldy #0     
     pla
     inc $ff09
     rti

irq276:   ;245
     pha
.sc:
  if VSIZE > 224
     lda #<302+VSIZE/264*8
  else
     lda #249
  endif
     sta $ff1d

     lda #2
     sta $ff0b
     lda #$a2
     sta $ff0a

     inc $a5    ;2-byte timer, 50/60 Hz for PAL/NTSC
     bne *+4
     inc $a4
     
     lda #<irq2
     sta $fffe
     lda #>irq2
     sta $ffff

     pla
     inc $ff09
     rti

irq205:
     pha
.sc:
  if VSIZE > 224
     lda #VSIZE-21-VSIZE/264*8
  else
     lda #VSIZE+1
  endif
     sta $ff1d

  if VSIZE > 224
     lda #$a3
     sta $ff0a
     lda #<276
  else
     lda #245
  endif
     sta $ff0b

  if >irq276 != >irq205
     lda #>irq276  ;245
     sta $ffff
  endif
     lda #<irq276  ;245
     sta $fffe
     pla
     inc $ff09
     rti

main:
     ;include "stars.s"
     include "test1.s"
     
     org $2800    ;attr 0-1: 0-23
     rept $3c0
     byte 0
     endr   ;$2bc0
;$40-9=55
init:
     lda $ff07
     ora #$10
     sta $ff07   ;multicolor mode
     rts
    
     org $2c00    ;clrs 0-1: 0-23
     rept $3c0
     byte 0
     endr   ;$2fc0
;$40-38=26
tobasic:
     sei
     lda #8
     sta $ff14
     lda #$1b
     sta $ff06
     lda $ff07
     and #$ef
     sta $ff07
     lda #$c4
     sta $ff12
     sta $ff3e
     lda #$ee
     sta $ff19
     lda #$f1
     sta $ff15
     cli
     rts 

     org $3000    ;attr 2-3: 0-23
     rept $3c0
     byte 0
     endr   ;$3cc0
;$40
     org $3400    ;clrs 2-3: 0-23
     rept $3c0
     byte 0
     endr   ;$37c0
;$40
     org $3800    ;attr 3-4: 0-23
     rept $3c0
     byte 0
     endr   ;$3bc0
;$40
     org $3c00    ;clrs 3-4: 0-23
     rept $3c0
     byte 0
     endr   ;$3fc0
;$40
     org $4000    ;bm 0-191
     rept $1e00
     byte $55
     endr   ;$5e00
;$200-$155
lo312:  byte $0, $38, $70, $a8, $e0, $18, $50, $88, $c0, $f8, $30, $68, $a0, $d8, $10, $48, $80, $b8, $f0, $28, $60, $98, $d0, $8, $40, $78, $b0, $e8, $20, $58, $90, $c8, $0, $38, $70, $a8
hi312:  byte $0, $1, $2, $3, $4, $6, $7, $8, $9, $a, $c, $d, $e, $f, $11, $12, $13, $14, $15, $17, $18, $19, $1a, $1c, $1d, $1e, $1f, $20, $22, $23, $24, $25, $27, $28, $29, $2a
setp: ;y - ($d8) y, x - x, cs - a; changes: $d0-d1, $d6-d7
     sta $d7
     lda #$40
     sta $d1
     sty $d0
  if VSIZE > 256
     lda $d8
     lsr
     tya
     ror
  else
     tya
     lsr
  endif
     lsr
     lsr
     tay   ;y/8
     cmp #192/8
     bcc .l1  ;branch if a < 192/8

     cmp #200/8
     bcc .l2  ;branch if a < 200/8
     
     cpx #96
     bcs .l1  ;branch if x >= 96
     
     cmp #208/8
     bcs .l1

.l2: lda #$60
     sta $d1
.l1: lda hi312,y   ;y/8*312
     sta $d6
     lda lo312,y
     clc
     adc $d0
     sta $d0
  if VSIZE>256
     lda $d6
     adc $d8
     sta $d6
  else
     bcc *+4
     inc $d6
  endif       ;y/8*312+y
     txa
     and #$fc
     asl    ;x&0xfc << 1
     bcc *+4
     inc $d6
     clc
     adc $d0
     sta $d0
     lda $d6
     adc $d1  ;ba + y/8*312+y+(x&0xfc)*2
     sta $d1
     txa
     and #3
     asl
     sta $d6
     lda #6
     sec
     sbc $d6
     tay     ;6 - ((x&3) << 1) = px
     beq .l3

     tax
     lda #3
     asl
     dey
     bne *-2
     eor #$ff   ;~(3 << px)
     and ($d0),y
     sta $d6
     lda $d7
     asl
     dex
     bne *-2
     ora $d6
.l4: sta ($d0),y
     rts

.l3: lda #$fc
     and ($d0),y
     ora $d7
     jmp .l4   ;bcs .l4

setpbyte: ;y - ($d8) y (0 - 279), x - x (0-159), byte - a; changes: $d0-d1, $d6-d7
     sta $d7
     lda #$40
     sta $d1
     sty $d0
  if VSIZE > 256
     lda $d8
     lsr
     tya
     ror
  else
     tya
     lsr
  endif
     lsr
     lsr
     tay
     cmp #192/8
     bcc .l1  ;branch if a < 192/8

     cmp #200/8
     bcc .l2  ;branch if a < 200/8
     
     cpx #96
     bcs .l1  ;branch if x >= 96
     
     cmp #208/8
     bcs .l1
.l2: lda #$60
     sta $d1
.l1: lda hi312,y   ;y/8*312
     sta $d6
     lda lo312,y
     clc
     adc $d0
     sta $d0
  if VSIZE>256
     lda $d6
     adc $d8
     sta $d6
  else
     bcc *+4
     inc $d6
  endif       ;y/8*312+y
     txa
     and #$fc
     asl    ;x&0xfc << 1
     bcc *+4
     inc $d6
     clc
     tay
     lda $d6
     adc $d1  ;ba + y/8*312+y+(x&0xfc)*2
     sta $d1
     lda $d7
     sta ($d0),y
     rts

getpbyte: ;y - ($d8) y (0 - 279), x - x (0-159); returns a; changes: $d0-d1, $d6-d7
     lda #$40
     sta $d1
     sty $d0
  if VSIZE > 256
     lda $d8
     lsr
     tya
     ror
  else
     tya
     lsr
  endif
     lsr
     lsr
     tay
     cmp #192/8
     bcc .l1  ;branch if a < 192/8

     cmp #200/8
     bcc .l2  ;branch if a < 200/8
     
     cpx #96
     bcs .l1  ;branch if x >= 96
     
     cmp #208/8
     bcs .l1
.l2: lda #$60
     sta $d1
.l1: lda hi312,y   ;y/8*312
     sta $d6
     lda lo312,y
     clc
     adc $d0
     sta $d0
  if VSIZE>256
     lda $d6
     adc $d8
     sta $d6
  else
     bcc *+4
     inc $d6
  endif       ;y/8*312+y
     txa
     and #$fc
     asl    ;x&0xfc << 1
     bcc *+4
     inc $d6
     clc
     tay
     lda $d6
     adc $d1  ;ba + y/8*312+y+(x&0xfc)*2
     sta $d1
     lda ($d0),y
     rts

     org $6000    ;bm 200-207 (24-39), 208-279
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*320+128
     byte $55
     endr
  endif

;$440+
     org $7000    ;attr 2-3: 24 (24-39), 25-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+ -$227
abase1:  byte $28, $30, $38, $90
abase2:  byte $98, $70, $80, $88
seta:   ;y - ($d8) y , x - x, cs - a, color - $d9
        ;if cs == 0 or 3 then x is ignored
        ;changes: $d0-d3, $d6-d7
     ;ora #0
     beq .l0

     cmp #3
     beq .l1
     jmp .l2

.l1: lsr
.l0: sta $d6   ;z
     asl
     sta $d7   ;2z
     asl
     adc $d6
     sta $d6   ;5z
  if VSIZE>256
     lda $d8
     lsr
     tya
     ror
  else
     tya
     lsr
  endif 
     bcs .l3

     cmp #192/2
     bne .l4

     lda #<(BA-4)  ;C=0
     sta $d0
     lda #>(BA-4)
     sta $d1
     ldy $d7  ;2z
     lda $d9
     sta ($d0),y
     rts

.l4: lda #1
     bcs .l5

     lda #0     ;y<192
.l5: adc $d6    ;y>192
     sta $d6    ;5z+off
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d1
     tya
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1   ;y*16
     sty $d0
     adc $d0
     tay
     lda $d1
  if VSIZE>256
     adc $d8
  else
     adc #0
  endif
     tax   ;y*17
     tya
     adc #<BA
     sta $d0
     txa
     adc #>BA
     sta $d1   ;y*17+BA
     ldy $d6   ;5z+off
     lda $d9
     sta ($d0),y
     rts

.l3: cmp #192/2
     lda #1
     bcs .l6

     lda #0     ;y<192
.l6: adc $d6    ;y>192
     sta $d6    ;5z+off
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d1
     tya
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1   ;y*16
     sty $d0
     adc $d0
     tay
     lda $d1
  if VSIZE>256
     adc $d8
  else
     adc #0
  endif
     tax   ;y*17
     tya
     adc #<(BA-3)
     sta $d0
     txa
     adc #>(BA-3)
     sta $d1   ;y*17
     ldy $d6   ;5z+off
     lda $d9
     sta ($d0),y
     rts

.l2: lsr
     sta .m1+1  ;cs
     sty $d6  ;y
     tya
     lsr
     and #3
     sta $d7  ;y/2%4
     tay
     lda abase2,y
     sec
     sbc #4
  if VSIZE>256
     ldy $d8
     bne .l7
  endif
     ldy $d6
     cpy #192
     bcs .l8  ;y>=192

     ldy $d7
     lda abase1,y
     jmp .l7

.l8: cpy #200
     bcc .l10

     cpy #208
     bcs .l7

     cpx #96
     bcs .l7

.l10:ldy $d7
     lda abase2,y
.l7: sta $d1  ;ba
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d7
     lda $d6
     and #$f8  ;y&0xf8 = (y/8)*8
     sta $d0
     asl
     rol $d7
     asl
     rol $d7  ;y/8*8*4
     adc $d0
     sta $d0
     sta $d2
  if VSIZE>256
     lda $d7
     adc $d8
     sta $d7
  else
     bcc *+4
     inc $d7
  endif  ;y/8*40
     txa
     lsr
     lsr
     tay
     clc
     lda $d7
     adc $d1
     sta $d1  ;y/8*40+x/4
     adc #4
     sta $d3
     lda ($d0),y
     sta $d7   ;cl
     lda ($d2),y
     sta $d6   ;cc
.m1: ldx #0    ;cs/2
     beq .l9

     and #$f0
     sta $d6
     lda $d9
     and #$f
     ora $d6
     sta ($d2),y
     lda $d7
     and #$f
     sta $d7
     lda $d9
     and #$f0
     ora $d7
     sta ($d0),y
     rts

.l9: and #$f
     sta $d6
     lda $d9
     and #$f0
     ora $d6
     sta ($d2),y
     lda $d7
     and #$f0
     sta $d7
     lda $d9
     and #$f
     ora $d7
     sta ($d0),y
     rts

getabyte:   ;y - ($d8) y , x - x, cs - a
        ;if cs == 0 or 3 then x is ignored
        ;changes: $d0-d3, $d6-d7
        ;returns at ($d0),y multicolor 1 if cs==0, multicolor 2 if cs==3, luminance byte if cs==1 or 2
        ;returns at ($d2),y color byte if cs==1 or 2
     ;ora #0
     beq .l0

     cmp #3
     beq .l1
     jmp .l2

.l1: lsr
.l0: sta $d6   ;z
     asl
     sta $d7   ;2z
     asl
     adc $d6
     sta $d6   ;5z
  if VSIZE>256
     lda $d8
     lsr
     tya
     ror
  else
     tya
     lsr
  endif 
     bcs .l3

     cmp #192/2
     bne .l4

     lda #<(BA-4)  ;C=0
     sta $d0
     lda #>(BA-4)
     sta $d1
     ldy $d7  ;2z
     rts

.l4: lda #1
     bcs .l5

     lda #0     ;y<192
.l5: adc $d6    ;y>192
     sta $d6    ;5z+off
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d1
     tya
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1   ;y*16
     sty $d0
     adc $d0
     tay
     lda $d1
  if VSIZE>256
     adc $d8
  else
     adc #0
  endif
     tax   ;y*17
     tya
     adc #<BA
     sta $d0
     txa
     adc #>BA
     sta $d1   ;y*17+BA
     ldy $d6   ;5z+off
     rts

.l3: cmp #192/2
     lda #1
     bcs .l6

     lda #0     ;y<192
.l6: adc $d6    ;y>192
     sta $d6    ;5z+off
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d1
     tya
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1
     asl
     rol $d1   ;y*16
     sty $d0
     adc $d0
     tay
     lda $d1
  if VSIZE>256
     adc $d8
  else
     adc #0
  endif
     tax   ;y*17
     tya
     adc #<(BA-3)
     sta $d0
     txa
     adc #>(BA-3)
     sta $d1   ;y*17
     ldy $d6   ;5z+off
     rts

.l2: sty $d6  ;y
     tya
     lsr
     and #3
     sta $d7  ;y/2%4
     tay
     lda abase2,y
     sec
     sbc #4
  if VSIZE>256
     ldy $d8
     bne .l7
  endif
     ldy $d6
     cpy #192
     bcs .l8  ;y>=192

     ldy $d7
     lda abase1,y
     jmp .l7

.l8: cpy #200
     bcc .l10

     cpy #208
     bcs .l7

     cpx #96
     bcs .l7

.l10:ldy $d7
     lda abase2,y
.l7: sta $d1  ;ba
  if VSIZE>256
     lda $d8
  else
     lda #0
  endif
     sta $d7
     lda $d6
     and #$f8  ;y&0xf8 = (y/8)*8
     sta $d0
     asl
     rol $d7
     asl
     rol $d7  ;y/8*8*4
     adc $d0
     sta $d0
     sta $d2
  if VSIZE>256
     lda $d7
     adc $d8
     sta $d7
  else
     bcc *+4
     inc $d7
  endif  ;y/8*40
     txa
     lsr
     lsr
     tay
     clc
     lda $d7
     adc $d1
     sta $d1  ;y/8*40+x/4
     adc #4
     sta $d3
     rts

     org $73c0    ;attr 2-3: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;+
     org $7400    ;clrs 2-3: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $77c0    ;clrs 2-3: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;$600+
     org $7e00    ;bm 192-199, 200-207 (0-23)
     rept (VSIZE/8/26)*192+320
     byte $55
     endr
;0+
     org $8000    ;attr 4-5: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $83c0    ;attr 4-5: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;0+
     org $8400    ;clrs 4-5: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $87c0    ;clrs 4-5: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;+
     org $8800     ;attr 6-7: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $8bc0    ;attr 6-7: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;0+
     org $8c00   ;clrs 6-7: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $8fc0    ;clrs 6-7: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;0+
     org $9000    ;attr 6-7, 0-23
     rept $3c0
     byte 0
     endr   ;$93c0
;$40
     org $9400    ;clrs 6-7, 0-23
     rept $3c0
     byte 0
     endr   ;$97c0
;$40
     org $9800    ;attr 0-1: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $9bc0    ;attr 0-1: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr
;0+
     org $9c00    ;clrs 0-1: 25 (24-39), 26-34
  if VSIZE/8 > 25
     rept (VSIZE/8-26)*40+16
     byte 0
     endr
  endif
;$248+
     org $9fc0    ;clrs 0-1: 24, 25 (0-23)
     rept (VSIZE/8/26)*24+40
     byte 0
     endr

